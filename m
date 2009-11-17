Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbZKQQw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbZKQQw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbZKQQw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:52:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbZKQQw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:52:27 -0500
Date: Tue, 17 Nov 2009 11:52:28 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC,RFT,PATCH] cfq: autotuning support
Message-ID: <20091117165228.GF22462@redhat.com>
References: <200911171551.14601.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911171551.14601.czoccolo@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 03:51:14PM +0100, Corrado Zoccolo wrote:
> Hi, this is my first attempt at autotuning cfq parameters, and should apply on top of for-2.6.33 branch.
> Jeff and Vivek, if you can test this on your NCQ SSDs, it will help me to have your feedback (please include 
> the output of: 'grep -r . /sys/block/sdX/queue/iosched' after you run your tests).

Sure, I will do some tests on this patch, may be later today.

I had a quick look at the patch. Had couple of questions.

- Service time seems to be the measure of on an average how much time it
  took to service a read/write request (be it sequential or random read).

  In auto tuning, you seem to be updating slice_idle dynamically based on
  service time. So the intent seems to be that is service times are higher
  then it is a slow media and we should have higher slice_idle otherwise
  a low slice_idle?

Thanks
Vivek


> 
> The patch introduces code to sample the request service time distribution, and analyze it,
> in order to compute the following cfq parameters:
> * slice_idle, is computed as the expected service time of random request
> * cfq_slice[1] (i.e. the slice for sync queues)
> * cfq_slice[0] (i.e. the slice for async queues)
> 
> The sync and async slices are scaled from default values proportionally to the new computed slice_idle.
> 
> Autotuning will be enabled by default only on kernels compiled with HZ >= 500.
> With smaller HZ, I don't think jiffies is reliable to estimate those parameters.
> 
> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
> ---
>  block/cfq-iosched.c |  166 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 163 insertions(+), 3 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 6925ab9..d786a0b 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -32,6 +32,12 @@ static const int cfq_target_latency = HZ * 3/10; /* 300 ms */
>  static const int cfq_hist_divisor = 4;
>  
>  /*
> + * Number of samples to collect before updating autotune
> + * higher # makes the measurements more stable
> + */
> +#define CFQ_AUTOTUNE_SAMPLES	(10)
> +
> +/*
>   * offset from end of service tree
>   */
>  #define CFQ_IDLE_DELAY		(HZ / 5)
> @@ -201,6 +207,21 @@ struct cfq_data {
>  	unsigned int hw_tag_samples;
>  
>  	/*
> +	 * disk performance measurements
> +	 */
> +	unsigned long observation_start;
> +	/*
> +	 * measures are split (READ vs WRITE)
> +	 */
> +	unsigned long processed_rq[2];
> +	/*
> +	 * We store an histogram of samples for the service time
> +	 * in log scale [0..5]; [6] is a count, that is reset every
> +	 * time autotuning is done (i.e. every CFQ_AUTOTUNE_SAMPLES)
> +	 */
> +	unsigned int serv_time_samples[2][7];
> +
> +	/*
>  	 * idle window management
>  	 */
>  	struct timer_list idle_slice_timer;
> @@ -228,6 +249,7 @@ struct cfq_data {
>  	unsigned int cfq_slice_async_rq;
>  	unsigned int cfq_slice_idle;
>  	unsigned int cfq_latency;
> +	unsigned int cfq_autotune;
>  
>  	struct list_head cic_list;
>  
> @@ -891,6 +913,12 @@ static void cfq_activate_request(struct request_queue *q, struct request *rq)
>  {
>  	struct cfq_data *cfqd = q->elevator->elevator_data;
>  
> +	if (!rq_in_driver(cfqd)) {
> +		cfqd->observation_start = jiffies;
> +		cfqd->processed_rq[0] = 0;
> +		cfqd->processed_rq[1] = 0;
> +	}
> +
>  	cfqd->rq_in_driver[rq_is_sync(rq)]++;
>  	cfq_log_cfqq(cfqd, RQ_CFQQ(rq), "activate rq, drv=%d",
>  						rq_in_driver(cfqd));
> @@ -2562,14 +2590,120 @@ static void cfq_update_hw_tag(struct cfq_data *cfqd)
>  		cfqd->hw_tag = 0;
>  }
>  
> +
> +/*
> + * Update the histogram to compute service time
> + * Returns true if we collected enough samples to re-run autotune
> + */
> +static bool cfq_update_stime(unsigned samples[6], unsigned long stime)
> +{
> +	unsigned idx = (stime > 15) + (stime > 7) + (stime > 3)
> +		       + (stime > 1) + (stime > 0);
> +	samples[idx]++;
> +	if (samples[idx] > (1U<<31))
> +		for (idx = 0; idx < 6; ++idx) {
> +			samples[idx]++;
> +			samples[idx] >>= 1;
> +		}
> +
> +	if (samples[6]++ < CFQ_AUTOTUNE_SAMPLES)
> +		return false;
> +	samples[6] = 0;
> +	return true;
> +}
> +
> +/*
> + * Currently, we measure only service time for pure READ or WRITE requests
> + * and we update autotune when we have collected enough READ requests
> + */
> +static bool cfq_update_perf_measures(struct cfq_data *cfqd, unsigned long now)
> +{
> +	unsigned long tot_proc = cfqd->processed_rq[0] + cfqd->processed_rq[1];
> +	unsigned long obstime = now - cfqd->observation_start;
> +	unsigned long stime = obstime / tot_proc;
> +
> +	cfqd->observation_start = now;
> +
> +	if (!cfqd->processed_rq[READ])
> +		cfq_update_stime(cfqd->serv_time_samples[WRITE], stime);
> +	if (!cfqd->processed_rq[WRITE])
> +		return cfq_update_stime(cfqd->serv_time_samples[READ], stime);
> +	return false;
> +}
> +
> +/*
> + * Compute service time from the sampled distribution in the histogram
> + * The real service time distribution is a super-position of two distinct
> + * distributions:
> + * the one for sequential requests (usually this has a small mean)
> + * the one for random requests (usually with a larger mean)
> + * and we want to identify the random request one
> + */
> +static unsigned cfq_service_time(unsigned samples[6])
> +{
> +	unsigned last_max = 0, i;
> +	/* Random request service time corresponds to the
> +	 * largest maximum in the histogram */
> +	for (i = 1; i < 6; ++i)
> +		if (samples[i] > samples[i-1])
> +			last_max = i;
> +	/*
> +	 * Unfortunately, if sequential requests overwhelm
> +	 * random ones, and the two peaks are too near,
> +	 * the second peak could be masked by the tail of the first.
> +	 * To catch this, we check if the tail has enough weight,
> +	 * and in this case we take the next bin as maximum
> +	 */
> +	if (last_max < 5) {
> +		unsigned total = 0;
> +		for (i = last_max + 1; i < 6; ++i)
> +			total += samples[i];
> +		if (total > samples[last_max])
> +			++last_max;
> +	}
> +	if (!last_max)
> +		return 0;
> +	return 1U << last_max;
> +}
> +
> +static void cfq_update_autotune(struct cfq_data *cfqd)
> +{
> +	unsigned long base, baseW;
> +	if (!cfqd->cfq_autotune)
> +		return;
> +	base = cfq_service_time(cfqd->serv_time_samples[READ]);
> +	baseW = cfq_service_time(cfqd->serv_time_samples[WRITE]);
> +
> +	/* Compute slice_idle */
> +	if (!base)
> +		base = baseW;
> +	if (base > cfq_slice_idle)
> +		base = min_t(unsigned long,
> +			     (base + cfq_slice_idle) / 2, 2 * cfq_slice_idle);
> +
> +	cfqd->cfq_slice_idle = base;
> +
> +	/* Compute derived cfq_slice[*]
> +	 * Note: those cannot be 0
> +	 */
> +	if (!base)
> +		base = 1;
> +
> +	if (baseW)
> +		baseW = min(base, baseW * cfq_slice_sync / cfq_slice_async);
> +	else
> +		baseW = base;
> +
> +	cfqd->cfq_slice[1] = base * cfq_slice_sync / cfq_slice_idle;
> +	cfqd->cfq_slice[0] = baseW * cfq_slice_async / cfq_slice_idle;
> +}
> +
>  static void cfq_completed_request(struct request_queue *q, struct request *rq)
>  {
>  	struct cfq_queue *cfqq = RQ_CFQQ(rq);
>  	struct cfq_data *cfqd = cfqq->cfqd;
>  	const int sync = rq_is_sync(rq);
> -	unsigned long now;
> -
> -	now = jiffies;
> +	unsigned long now = jiffies;
>  	cfq_log_cfqq(cfqd, cfqq, "complete");
>  
>  	cfq_update_hw_tag(cfqd);
> @@ -2578,6 +2712,10 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
>  	WARN_ON(!cfqq->dispatched);
>  	cfqd->rq_in_driver[sync]--;
>  	cfqq->dispatched--;
> +	cfqd->processed_rq[rq_data_dir(rq)]++;
> +
> +	if (!rq_in_driver(cfqd) && cfq_update_perf_measures(cfqd, now))
> +		cfq_update_autotune(cfqd);
>  
>  	if (cfq_cfqq_sync(cfqq))
>  		cfqd->sync_flight--;
> @@ -2966,6 +3104,7 @@ static void *cfq_init_queue(struct request_queue *q)
>  	cfqd->cfq_slice_async_rq = cfq_slice_async_rq;
>  	cfqd->cfq_slice_idle = cfq_slice_idle;
>  	cfqd->cfq_latency = 1;
> +	cfqd->cfq_autotune = (HZ >= 500);
>  	cfqd->hw_tag = -1;
>  	cfqd->last_end_sync_rq = jiffies;
>  	return cfqd;
> @@ -3002,6 +3141,23 @@ fail:
>  /*
>   * sysfs parts below -->
>   */
> +static ssize_t autotune_stats_show(struct elevator_queue *e, char *page)
> +{
> +	struct cfq_data *cfqd = e->elevator_data;
> +	int pos = 0, i, j;
> +#if HZ < 500
> +	pos += sprintf(page, "Autotune may work incorrectly with HZ < 500\n");
> +#endif
> +	for (j = 0; j < 2; ++j) {
> +		for (i = 0; i < 6; ++i)
> +			pos += sprintf(page+pos, "[%2u]",
> +				cfqd->serv_time_samples[j][i]);
> +		page[pos++] = '\n';
> +	}
> +	page[pos] = '\0';
> +	return pos;
> +}
> +
>  static ssize_t
>  cfq_var_show(unsigned int var, char *page)
>  {
> @@ -3036,6 +3192,7 @@ SHOW_FUNCTION(cfq_slice_sync_show, cfqd->cfq_slice[1], 1);
>  SHOW_FUNCTION(cfq_slice_async_show, cfqd->cfq_slice[0], 1);
>  SHOW_FUNCTION(cfq_slice_async_rq_show, cfqd->cfq_slice_async_rq, 0);
>  SHOW_FUNCTION(cfq_low_latency_show, cfqd->cfq_latency, 0);
> +SHOW_FUNCTION(cfq_autotune_show, cfqd->cfq_autotune, 0);
>  #undef SHOW_FUNCTION
>  
>  #define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX, __CONV)			\
> @@ -3068,6 +3225,7 @@ STORE_FUNCTION(cfq_slice_async_store, &cfqd->cfq_slice[0], 1, UINT_MAX, 1);
>  STORE_FUNCTION(cfq_slice_async_rq_store, &cfqd->cfq_slice_async_rq, 1,
>  		UINT_MAX, 0);
>  STORE_FUNCTION(cfq_low_latency_store, &cfqd->cfq_latency, 0, 1, 0);
> +STORE_FUNCTION(cfq_autotune_store, &cfqd->cfq_autotune, 0, 1, 0);
>  #undef STORE_FUNCTION
>  
>  #define CFQ_ATTR(name) \
> @@ -3084,6 +3242,8 @@ static struct elv_fs_entry cfq_attrs[] = {
>  	CFQ_ATTR(slice_async_rq),
>  	CFQ_ATTR(slice_idle),
>  	CFQ_ATTR(low_latency),
> +	CFQ_ATTR(autotune),
> +	__ATTR_RO(autotune_stats),
>  	__ATTR_NULL
>  };
>  
> -- 
> 1.6.2.5
> 
