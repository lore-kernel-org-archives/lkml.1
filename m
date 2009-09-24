Return-Path: <linux-kernel-owner+w=401wt.eu-S1752837AbZIXJVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbZIXJVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 05:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbZIXJVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 05:21:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50212 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbZIXJVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 05:21:21 -0400
Message-ID: <4ABB3A0E.2090204@cn.fujitsu.com>
Date: Thu, 24 Sep 2009 17:21:18 +0800
From: Shan Wei <shanwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: czoccolo@gmail.com
CC: Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
       linux-kernel@vger.kernel.org, Shan Wei <shanwei@cn.fujitsu.com>
Subject: Re: [Fwd: [RFC] cfq: adapt slice to number of processes doing I/O
 (v2.1)]
References: <4AB74629.1030109@cn.fujitsu.com>
In-Reply-To: <4AB74629.1030109@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject:
> [RFC] cfq: adapt slice to number of processes doing I/O (v2.1)
>
> When the number of processes performing I/O concurrently increases,
> a fixed time slice per process will cause large latencies.
> 
> This (v2.1) patch will scale the time slice assigned to each process,
> according to a target latency (tunable from sysfs, default 300ms).
> 
> In order to keep fairness among processes, we adopt two devices, w.r.t. v1.
> 
> * The number of active processes is computed using a special form of
> running average, that quickly follows sudden increases (to keep latency low),
> and decrease slowly (to have fairness in spite of rapid decreases of this 
> value).
> 
> * The idle time is computed using remaining slice as a maximum.
> 
> To safeguard sequential bandwidth, we impose a minimum time slice
> (computed using 2*cfq_slice_idle as base, adjusted according to priority
> and async-ness).
> 
> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
> 

I'm interested in the idea of dynamically tuning the time slice according to the number of
processes. I have tested your patch using Jeff's tool on kernel-2.6.30-rc4. 
>From the following test result, after applying your patch, the fairness is not good 
as original kernel, e.g. io priority of 4 vs 5 in be0-through-7.fio case. 
And the throughout(total data transferred) becomes lower.
Have you tested buffered write, multi-threads?

Additionally i have a question about the minimum time slice, see the comment in your patch. 

*Original*(2.6.30-rc4 without patch):
/cfq-regression-tests/2.6.30-rc4-log/be0-through-7.fio 
total priority: 880
total data transferred: 535872
class	prio	ideal	xferred	%diff
be	0	109610	149748	36
be	1	97431	104436	7
be	2	85252	91124	6
be	3	73073	64244	-13
be	4	60894	59028	-4
be	5	48715	38132	-22
be	6	36536	21492	-42
be	7	24357	7668	-69

/cfq-regression-tests/2.6.30-rc4-log/be0-vs-be1.fio 
total priority: 340
total data transferred: 556008
class	prio	ideal	xferred	%diff
be	0	294357	402164	36
be	1	261650	153844	-42

/cfq-regression-tests/2.6.30-rc4-log/be0-vs-be7.fio 
total priority: 220
total data transferred: 537064
class	prio	ideal	xferred	%diff
be	0	439416	466164	6
be	7	97648	70900	-28

/cfq-regression-tests/2.6.30-rc4-log/be4-x-3.fio 
total priority: 300
total data transferred: 532964
class	prio	ideal	xferred	%diff
be	4	177654	199260	12
be	4	177654	149748	-16
be	4	177654	183956	3

/cfq-regression-tests/2.6.30-rc4-log/be4-x-8.fio 
total priority: 800
total data transferred: 516384
class	prio	ideal	xferred	%diff
be	4	64548	78580	21
be	4	64548	76436	18
be	4	64548	75764	17
be	4	64548	70900	9
be	4	64548	42388	-35
be	4	64548	73780	14
be	4	64548	30708	-53
be	4	64548	67828	5


*Applied patch*(2.6.30-rc4 with patch):

/cfq-regression-tests/log-result/be0-through-7.fio 
total priority: 880
total data transferred: 493824
class	prio	ideal	xferred	%diff
be	0	101009	224852	122
be	1	89786	106996	19
be	2	78562	70388	-11
be	3	67339	38900	-43
be	4	56116	18420	-68
be	5	44893	19700	-57
be	6	33669	9972	-71
be	7	22446	4596	-80

/cfq-regression-tests/log-result/be0-vs-be1.fio 
total priority: 340
total data transferred: 537064
class	prio	ideal	xferred	%diff
be	0	284328	375540	32
be	1	252736	161524	-37

/cfq-regression-tests/log-result/be0-vs-be7.fio 
total priority: 220
total data transferred: 551912
class	prio	ideal	xferred	%diff
be	0	451564	499956	10
be	7	100347	51956	-49

/cfq-regression-tests/log-result/be4-x-3.fio 
total priority: 300
total data transferred: 509404
class	prio	ideal	xferred	%diff
be	4	169801	196596	15
be	4	169801	198388	16
be	4	169801	114420	-33

/cfq-regression-tests/log-result/be4-x-8.fio 
total priority: 800
total data transferred: 459072
class	prio	ideal	xferred	%diff
be	4	57384	70644	23
be	4	57384	52980	-8
be	4	57384	62356	8
be	4	57384	60660	5
be	4	57384	55028	-5
be	4	57384	69620	21
be	4	57384	51956	-10
be	4	57384	35828	-38


Hardware infos.:
CPU: GenuineIntel Intel(R) Xeon(TM) CPU 3.00GHz 
     (4 logic cpus with hyper-thread on)
memory:2G
HDD:scsi

> ---
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 0e3814b..ca90d42 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -27,6 +27,8 @@ static const int cfq_slice_sync = HZ / 10;
>  static int cfq_slice_async = HZ / 25;
>  static const int cfq_slice_async_rq = 2;
>  static int cfq_slice_idle = HZ / 125;
> +static int cfq_target_latency = HZ * 3/10; /* 300 ms */
> +static int cfq_hist_divisor = 4;
>  
>  /*
>   * offset from end of service tree
> @@ -134,6 +136,9 @@ struct cfq_data {
>  	struct rb_root prio_trees[CFQ_PRIO_LISTS];
>  
>  	unsigned int busy_queues;
> +	unsigned int busy_queues_avg;
> +	unsigned int busy_rt_queues;
> +	unsigned int busy_rt_queues_avg;
>  
>  	int rq_in_driver[2];
>  	int sync_flight;
> @@ -173,6 +178,8 @@ struct cfq_data {
>  	unsigned int cfq_slice[2];
>  	unsigned int cfq_slice_async_rq;
>  	unsigned int cfq_slice_idle;
> +	unsigned int cfq_target_latency;
> +	unsigned int cfq_hist_divisor;
>  
>  	struct list_head cic_list;
>  
> @@ -301,10 +308,40 @@ cfq_prio_to_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  	return cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio);
>  }
>  
> +static inline unsigned
> +cfq_get_interested_queues(struct cfq_data *cfqd, bool rt) {
> +	unsigned min_q, max_q;
> +	unsigned mult = cfqd->cfq_hist_divisor - 1;
> +	unsigned round = cfqd->cfq_hist_divisor / 2;
> +	if (rt) {
> +		min_q = min(cfqd->busy_rt_queues_avg, cfqd->busy_rt_queues);
> +		max_q = max(cfqd->busy_rt_queues_avg, cfqd->busy_rt_queues);
> +		cfqd->busy_rt_queues_avg = (mult * max_q + min_q + round) /
> +			cfqd->cfq_hist_divisor;
> +		return cfqd->busy_rt_queues_avg;
> +	} else {
> +		min_q = min(cfqd->busy_queues_avg, cfqd->busy_queues);
> +		max_q = max(cfqd->busy_queues_avg, cfqd->busy_queues);
> +		cfqd->busy_queues_avg = (mult * max_q + min_q + round) /
> +			cfqd->cfq_hist_divisor;
> +		return cfqd->busy_queues_avg;
> +	}
> +}
> +
>  static inline void
>  cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  {
> -	cfqq->slice_end = cfq_prio_to_slice(cfqd, cfqq) + jiffies;
> +	unsigned process_thr = cfqd->cfq_target_latency / cfqd->cfq_slice[1];
> +	unsigned iq = cfq_get_interested_queues(cfqd, cfq_class_rt(cfqq));
> +	unsigned slice = cfq_prio_to_slice(cfqd, cfqq);
> +
> +	if (iq > process_thr) {
> +		unsigned low_slice = 2 * slice * cfqd->cfq_slice_idle
> +			/ cfqd->cfq_slice[1];

For sync queue, the minimum time slice is decided by slice_idle, base time slice and io priority.
But for async queue, why is the minimum time slice also limited by base time slice of sync queue?


Best Regards
-----
Shan Wei


