Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbZJTBDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbZJTBDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 21:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756174AbZJTBDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 21:03:10 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37004 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbZJTBDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 21:03:10 -0400
Date: Tue, 20 Oct 2009 03:03:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH 5/5] cfq-iosched: fairness for sync no-idle queues
Message-ID: <20091020010312.GF10727@kernel.dk>
References: <200910192221.43562.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910192221.43562.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19 2009, Corrado Zoccolo wrote:
> Currently no-idle queues in cfq are not serviced fairly:
> even if they can only dispatch a small number of requests at a time,
> they have to compete with idling queues to be serviced, experiencing
> large latencies.
> 
> We should notice, instead, that no-idle queues are the ones that would
> benefit most from having low latency, in fact they are any of:
> * processes with large think times (e.g. interactive ones like file
>   managers)
> * seeky (e.g. programs faulting in their code at startup)
> * or marked as no-idle from upper levels, to improve latencies of those
>   requests.
> 
> This patch improves the fairness and latency for those queues, by:
> * separating sync idle, sync no-idle and async queues in separate
>   service_trees, for each priority
> * service all no-idle queues together
> * and idling when the last no-idle queue has been serviced, to
>   anticipate for more no-idle work
> * the timeslices allotted for idle and no-idle service_trees are
>   computed proportionally to the number of processes in each set.
> 
> Servicing all no-idle queues together should have a performance boost
> for NCQ-capable drives, without compromising fairness.

Good stuff!

> +enum wl_type_t {
> +	ASYNC_WL = 0,
> +	SYNC_NOIDLE_WL = 1,
> +	SYNC_WL = 2
> +};

Again the _WL. WL what?

>  static inline int cfq_busy_queues_wl(enum wl_prio_t wl, struct cfq_data *cfqd)
>  {
>  	return wl == IDLE_WL ? cfqd->service_tree_idle.count :
> -		cfqd->service_trees[wl].count;
> +		cfqd->service_trees[wl][ASYNC_WL].count
> +		+ cfqd->service_trees[wl][SYNC_NOIDLE_WL].count
> +		+ cfqd->service_trees[wl][SYNC_WL].count;

Unreadable.

>  	cfq_slice_expired(cfqd, 0);
>  new_queue:
>  	if (!new_cfqq) {
> +		enum wl_prio_t previous_prio = cfqd->serving_prio;
> +
>  		if (cfq_busy_queues_wl(RT_WL, cfqd))
>  			cfqd->serving_prio = RT_WL;
>  		else if (cfq_busy_queues_wl(BE_WL, cfqd))
>  			cfqd->serving_prio = BE_WL;
> -		else
> +		else {
>  			cfqd->serving_prio = IDLE_WL;
> +			cfqd->workload_expires = jiffies + 1;
> +		}
> +
> +		if (cfqd->serving_prio != IDLE_WL) {
> +			int counts[] = {
> +				service_tree_for(cfqd->serving_prio,
> +						 ASYNC_WL, cfqd)->count,
> +				service_tree_for(cfqd->serving_prio,
> +						 SYNC_NOIDLE_WL, cfqd)->count,
> +				service_tree_for(cfqd->serving_prio,
> +						 SYNC_WL, cfqd)->count
> +			};
> +			int nonzero_counts = !!counts[0] + !!counts[1]
> +				+ !!counts[2];
> +
> +			if (previous_prio != cfqd->serving_prio ||
> +			    (nonzero_counts == 1)) {
> +				cfqd->serving_type = counts[1] ? SYNC_NOIDLE_WL
> +					: counts[2] ? SYNC_WL : ASYNC_WL;
> +			} else {
> +				if (!counts[cfqd->serving_type] ||
> +				    time_after(jiffies, cfqd->workload_expires))
> +					cfqd->serving_type = cfq_choose_wl
> +						(cfqd, cfqd->serving_prio);
> +				else
> +					goto same_wl;
> +			}
> +
> +			{
> +				unsigned slice = cfq_target_latency;
> +				slice = slice * counts[cfqd->serving_type] /
> +					max_t(unsigned, cfqd->busy_queues_avg
> +						[cfqd->serving_prio],
> +					      counts[SYNC_WL] +
> +						counts[SYNC_NOIDLE_WL] +
> +						counts[ASYNC_WL]);
> +
> +				if (cfqd->serving_type == ASYNC_WL)
> +					slice = max(1U, slice
> +						* cfqd->cfq_slice[0]
> +						/ cfqd->cfq_slice[1]);
> +				else {
> +					unsigned slice_min =
> +						2 * cfqd->cfq_slice_idle;
> +					slice = max(slice, slice_min);
> +					slice = max_t(unsigned, slice,
> +						      CFQ_MIN_TT);
> +				}
> +				cfqd->workload_expires = jiffies + slice;
> +			}
> +		}

This so badly needs comments and code cleanups it's not even funny. It's
completely unreadable.

Goes for most of this patch. Your goal is great, but please spend some
time commenting and making this code actually readable and mergeable.

Remember that reviewer time is valuable. You should provide patches that
are easily digestable. Huge chunks of unreadable code like the above
really wants to go into a separate function and be nicely commented.

-- 
Jens Axboe

