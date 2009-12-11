Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbZLKPHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbZLKPHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757897AbZLKPH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:07:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756858AbZLKPH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:07:28 -0500
Date: Fri, 11 Dec 2009 10:07:27 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq: Take whether cfq group is changed into account
	when choosing service tree
Message-ID: <20091211150727.GB2756@redhat.com>
References: <4B21D252.1060902@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B21D252.1060902@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 01:02:10PM +0800, Gui Jianfeng wrote:
> Currently, with IO Controller introduced, CFQ chooses cfq group
> at the top, and then choose service tree. So we need to take 
> whether cfq group is changed into account to decide whether we 
> should choose service tree start from scratch.
> 

I am not able to understand the need/purpose of this patch. Once we
switched the group during scheduling, why should we reset the order
of workload with-in group. In fact we don't want to do that and we
want to start from where we left so that no workload with-in group is
starved.

When a group is resumed, choose_service_tree() always checks if any RT
queue got backlogged or not. If yes, it does choose that first.

Can you give more details why do you want to do this change?

Thanks
Vivek

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/cfq-iosched.c |   27 ++++++++++++++++++---------
>  1 files changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index f3f6239..16084ca 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1964,7 +1964,7 @@ static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
>  
>  static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
>  				struct cfq_group *cfqg, enum wl_prio_t prio,
> -				bool prio_changed)
> +				bool cfqg_changed, bool prio_changed)
>  {
>  	struct cfq_queue *queue;
>  	int i;
> @@ -1972,7 +1972,7 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
>  	unsigned long lowest_key = 0;
>  	enum wl_type_t cur_best = SYNC_NOIDLE_WORKLOAD;
>  
> -	if (prio_changed) {
> +	if (cfqg_changed || prio_changed) {
>  		/*
>  		 * When priorities switched, we prefer starting
>  		 * from SYNC_NOIDLE (first choice), or just SYNC
> @@ -2001,7 +2001,8 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
>  	return cur_best;
>  }
>  
> -static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
> +static void choose_service_tree(struct cfq_data *cfqd, 
> +				struct cfq_group *cfqg, bool cfqg_changed)
>  {
>  	enum wl_prio_t previous_prio = cfqd->serving_prio;
>  	bool prio_changed;
> @@ -2033,21 +2034,22 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  	 * expiration time
>  	 */
>  	prio_changed = (cfqd->serving_prio != previous_prio);
> -	st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type,
> -				cfqd);
> +	st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type, 
> +			      cfqd);
>  	count = st->count;
>  
>  	/*
>  	 * If priority didn't change, check workload expiration,
>  	 * and that we still have other queues ready
>  	 */
> -	if (!prio_changed && count &&
> +	if (!cfqg_changed && !prio_changed && count &&
>  	    !time_after(jiffies, cfqd->workload_expires))
>  		return;
>  
>  	/* otherwise select new workload type */
>  	cfqd->serving_type =
> -		cfq_choose_wl(cfqd, cfqg, cfqd->serving_prio, prio_changed);
> +		cfq_choose_wl(cfqd, cfqg, cfqd->serving_prio, 
> +			      cfqg_changed, prio_changed);
>  	st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type,
>  				cfqd);
>  	count = st->count;
> @@ -2104,9 +2106,16 @@ static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
>  
>  static void cfq_choose_cfqg(struct cfq_data *cfqd)
>  {
> +	bool cfqg_changed = false;
> +
> +	struct cfq_group *orig_cfqg = cfqd->serving_group;
> +
>  	struct cfq_group *cfqg = cfq_get_next_cfqg(cfqd);
>  
> -	cfqd->serving_group = cfqg;
> +	if (orig_cfqg != cfqg) {
> +		cfqg_changed = 1;
> +		cfqd->serving_group = cfqg;
> +	}
>  
>  	/* Restore the workload type data */
>  	if (cfqg->saved_workload_slice) {
> @@ -2114,7 +2123,7 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
>  		cfqd->serving_type = cfqg->saved_workload;
>  		cfqd->serving_prio = cfqg->saved_serving_prio;
>  	}
> -	choose_service_tree(cfqd, cfqg);
> +	choose_service_tree(cfqd, cfqg, cfqg_changed);
>  }
>  
>  /*
> -- 
> 1.5.4.rc3
> 
