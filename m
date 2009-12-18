Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbZLRPTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbZLRPTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbZLRPTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:19:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417AbZLRPTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:19:48 -0500
Date: Fri, 18 Dec 2009 10:17:32 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       lizf@cn.fujitsu.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       taka@valinux.co.jp, jmoyer@redhat.com, m-ikeda@ds.jp.nec.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: Re: [PATCH 3/4] cfq-iosched: Remove prio_change logic for workload
	selection
Message-ID: <20091218151732.GB3123@redhat.com>
References: <1261003980-10115-1-git-send-email-vgoyal@redhat.com> <1261003980-10115-4-git-send-email-vgoyal@redhat.com> <4B29F7DE.4020700@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B29F7DE.4020700@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 05:20:30PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > o CFQ now internally divides cfq queues in therr workload categories. sync-idle,
> >   sync-noidle and async. Which workload to run depends primarily on rb_key
> >   offset across three service trees. Which is a combination of mulitiple things
> >   including what time queue got queued on the service tree.
> > 
> >   There is one exception though. That is if we switched the prio class, say
> >   we served some RT tasks and again started serving BE class, then with-in
> >   BE class we always started with sync-noidle workload irrespective of rb_key
> >   offset in service trees.
> > 
> >   This can provide better latencies for sync-noidle workload in the presence
> >   of RT tasks.
> > 
> > o This patch gets rid of that exception and which workload to run with-in
> >   class always depends on lowest rb_key across service trees. The reason
> >   being that now we have multiple BE class groups and if we always switch
> >   to sync-noidle workload with-in group, we can potentially starve a sync-idle
> >   workload with-in group. Same is true for async workload which will be in
> >   root group. Also the workload-switching with-in group will become very
> >   unpredictable as it now depends whether some RT workload was running in
> >   the system or not.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 
> Actually, in current CFQ, there still has bug in prio_changed logic.
> Because prio_changed = (cfqd->serving_prio != previous_prio), and previous_prio
> might come from another group, in this case, prio_changed becomes invalid, but
> cfq_choose_wl() still relies on prio_changed to calculate serving_type, this
> doesn't make sence IMHO. 

Ok, so you are referring to the case when we don't save workload state
because it has expired at the time of group expiry.

How about saving the serving prio all the time at the time of group expiry,
irrespective of the fact whether workload has expired or not at the time of
group expiry and while we also need to always restore the serving prio back
when group is rescheduled in.

Thanks
Vivek

> But with this change, this bug is gone.
> 
> Reviewed-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> 
> > ---
> >  block/cfq-iosched.c |   48 ++++++++++++------------------------------------
> >  1 files changed, 12 insertions(+), 36 deletions(-)
> > 
> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > index d9bfa09..8df4fe5 100644
> > --- a/block/cfq-iosched.c
> > +++ b/block/cfq-iosched.c
> > @@ -292,8 +292,7 @@ static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
> >  
> >  static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
> >  					    enum wl_prio_t prio,
> > -					    enum wl_type_t type,
> > -					    struct cfq_data *cfqd)
> > +					    enum wl_type_t type)
> >  {
> >  	if (!cfqg)
> >  		return NULL;
> > @@ -1146,7 +1145,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
> >  #endif
> >  
> >  	service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
> > -						cfqq_type(cfqq), cfqd);
> > +						cfqq_type(cfqq));
> >  	if (cfq_class_idle(cfqq)) {
> >  		rb_key = CFQ_IDLE_DELAY;
> >  		parent = rb_last(&service_tree->rb);
> > @@ -1609,7 +1608,7 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
> >  {
> >  	struct cfq_rb_root *service_tree =
> >  		service_tree_for(cfqd->serving_group, cfqd->serving_prio,
> > -					cfqd->serving_type, cfqd);
> > +					cfqd->serving_type);
> >  
> >  	if (!cfqd->rq_queued)
> >  		return NULL;
> > @@ -1956,8 +1955,7 @@ static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
> >  }
> >  
> >  static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
> > -				struct cfq_group *cfqg, enum wl_prio_t prio,
> > -				bool prio_changed)
> > +				struct cfq_group *cfqg, enum wl_prio_t prio)
> >  {
> >  	struct cfq_queue *queue;
> >  	int i;
> > @@ -1965,24 +1963,9 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
> >  	unsigned long lowest_key = 0;
> >  	enum wl_type_t cur_best = SYNC_NOIDLE_WORKLOAD;
> >  
> > -	if (prio_changed) {
> > -		/*
> > -		 * When priorities switched, we prefer starting
> > -		 * from SYNC_NOIDLE (first choice), or just SYNC
> > -		 * over ASYNC
> > -		 */
> > -		if (service_tree_for(cfqg, prio, cur_best, cfqd)->count)
> > -			return cur_best;
> > -		cur_best = SYNC_WORKLOAD;
> > -		if (service_tree_for(cfqg, prio, cur_best, cfqd)->count)
> > -			return cur_best;
> > -
> > -		return ASYNC_WORKLOAD;
> > -	}
> > -
> > -	for (i = 0; i < 3; ++i) {
> > -		/* otherwise, select the one with lowest rb_key */
> > -		queue = cfq_rb_first(service_tree_for(cfqg, prio, i, cfqd));
> > +	for (i = 0; i <= SYNC_WORKLOAD; ++i) {
> > +		/* select the one with lowest rb_key */
> > +		queue = cfq_rb_first(service_tree_for(cfqg, prio, i));
> >  		if (queue &&
> >  		    (!key_valid || time_before(queue->rb_key, lowest_key))) {
> >  			lowest_key = queue->rb_key;
> > @@ -1996,8 +1979,6 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
> >  
> >  static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
> >  {
> > -	enum wl_prio_t previous_prio = cfqd->serving_prio;
> > -	bool prio_changed;
> >  	unsigned slice;
> >  	unsigned count;
> >  	struct cfq_rb_root *st;
> > @@ -2025,24 +2006,19 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
> >  	 * (SYNC, SYNC_NOIDLE, ASYNC), and to compute a workload
> >  	 * expiration time
> >  	 */
> > -	prio_changed = (cfqd->serving_prio != previous_prio);
> > -	st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type,
> > -				cfqd);
> > +	st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type);
> >  	count = st->count;
> >  
> >  	/*
> > -	 * If priority didn't change, check workload expiration,
> > -	 * and that we still have other queues ready
> > +	 * check workload expiration, and that we still have other queues ready
> >  	 */
> > -	if (!prio_changed && count &&
> > -	    !time_after(jiffies, cfqd->workload_expires))
> > +	if (count && !time_after(jiffies, cfqd->workload_expires))
> >  		return;
> >  
> >  	/* otherwise select new workload type */
> >  	cfqd->serving_type =
> > -		cfq_choose_wl(cfqd, cfqg, cfqd->serving_prio, prio_changed);
> > -	st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type,
> > -				cfqd);
> > +		cfq_choose_wl(cfqd, cfqg, cfqd->serving_prio);
> > +	st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type);
> >  	count = st->count;
> >  
> >  	/*
