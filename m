Return-Path: <linux-kernel-owner+w=401wt.eu-S1758623AbZLKAda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623AbZLKAda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 19:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757350AbZLKAd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 19:33:26 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40909 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757023AbZLKAd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 19:33:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 11 Dec 2009 09:30:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com, mingo@elte.hu
Subject: Re: [RFC mm][PATCH 2/5] percpu cached mm counter
Message-Id: <20091211093032.db7fdd91.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0912101136110.5481@router.home>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
	<20091210163448.338a0bd2.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0912101136110.5481@router.home>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


thank you for review.

On Thu, 10 Dec 2009 11:51:24 -0600 (CST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Thu, 10 Dec 2009, KAMEZAWA Hiroyuki wrote:
> 
> > Now, mm's counter information is updated by atomic_long_xxx() functions if
> > USE_SPLIT_PTLOCKS is defined. This causes cache-miss when page faults happens
> > simultaneously in prural cpus. (Almost all process-shared objects is...)
> 
> s/prural cpus/multiple cpus simultaneously/?
> 
Ah, I see..I often does this misuse, sorry.

> > This patch implements per-cpu mm cache. This per-cpu cache is loosely
> > synchronized with mm's counter. Current design is..
> 
> Some more explanation about the role of the per cpu data would be useful.
> 
I see.
> For each cpu we keep a set of counters that can be incremented using per
> cpu operations. curr_mc points to the mm struct that is currently using
> the per cpu counters on a specific cpu?
> 
yes. Precisely. per-cpu curr_mmc.mm points to mm_struct of current thread
if a page fault occurs since last schedule().


> >   - prepare per-cpu object curr_mmc. curr_mmc containes pointer to mm and
> >     array of counters.
> >   - At page fault,
> >      * if curr_mmc.mm != NULL, update curr_mmc.mm counter.
> >      * if curr_mmc.mm == NULL, fill curr_mmc.mm = current->mm and account 1.
> >   - At schedule()
> >      * if curr_mm.mm != NULL, synchronize and invalidate cached information.
> >      * if curr_mmc.mm == NULL, nothing to do.
> 
> Sounds like a very good idea that could be expanded and used for other
> things like tracking the amount of memory used on a specific NUMA node in
> the future. Through that we may get to a schedule that can schedule with
> an awareness where the memory of a process is actually located.
> 
Hmm. Expanding as per-node stat ?

>  > By this.
> >   - no atomic ops, which tends to cache-miss, under page table lock.
> >   - mm->counters are synchronized when schedule() is called.
> >   - No bad thing to read-side.
> >
> > Concern:
> >   - added cost to schedule().
> 
> That is only a simple check right?
yes.

> Are we already touching that cacheline in schedule?

0000000000010040 l     O .data.percpu   0000000000000050 vmstat_work
00000000000100a0 g     O .data.percpu   0000000000000030 curr_mmc
00000000000100e0 l     O .data.percpu   0000000000000030 vmap_block_queue

Hmm...not touched unless a page fault occurs.

> Or place that structure near other stuff touched by the scheduer?
> 

I'll think about that.


> >
> > +#if USE_SPLIT_PTLOCKS
> > +
> > +DEFINE_PER_CPU(struct pcp_mm_cache, curr_mmc);
> > +
> > +void __sync_mm_counters(struct mm_struct *mm)
> > +{
> > +	struct pcp_mm_cache *mmc = &per_cpu(curr_mmc, smp_processor_id());
> > +	int i;
> > +
> > +	for (i = 0; i < NR_MM_COUNTERS; i++) {
> > +		if (mmc->counters[i] != 0) {
> 
> Omit != 0?
> 
> if you change mmc->curr_mc then there is no need to set mmc->counters[0]
> to zero right? add_mm_counter_fast will set the counter to 1 next?
> 
yes. I can omit that.


> > +static void add_mm_counter_fast(struct mm_struct *mm, int member, int val)
> > +{
> > +	struct mm_struct *cached = percpu_read(curr_mmc.mm);
> > +
> > +	if (likely(cached == mm)) { /* fast path */
> > +		percpu_add(curr_mmc.counters[member], val);
> > +	} else if (mm == current->mm) { /* 1st page fault in this period */
> > +		percpu_write(curr_mmc.mm, mm);
> > +		percpu_write(curr_mmc.counters[member], val);
> > +	} else /* page fault via side-path context (get_user_pages()) */
> > +		add_mm_counter(mm, member, val);
> 
> So get_user pages will not be accellerated.
> 
Yes. but I guess it's not fast path. I'll mention about that in patch description.


> > Index: mmotm-2.6.32-Dec8/kernel/sched.c
> > ===================================================================
> > --- mmotm-2.6.32-Dec8.orig/kernel/sched.c
> > +++ mmotm-2.6.32-Dec8/kernel/sched.c
> > @@ -2858,6 +2858,7 @@ context_switch(struct rq *rq, struct tas
> >  	trace_sched_switch(rq, prev, next);
> >  	mm = next->mm;
> >  	oldmm = prev->active_mm;
> > +
> >  	/*
> >  	 * For paravirt, this is coupled with an exit in switch_to to
> >  	 * combine the page table reload and the switch backend into
> 
> Extraneous new line.
> 
will fix.

> > @@ -5477,6 +5478,11 @@ need_resched_nonpreemptible:
> >
> >  	if (sched_feat(HRTICK))
> >  		hrtick_clear(rq);
> > +	/*
> > +	 * sync/invaldidate per-cpu cached mm related information
> > +	 * before taling rq->lock. (see include/linux/mm.h)
> > +	 */
> > +	sync_mm_counters_atomic();
> >
> >  	spin_lock_irq(&rq->lock);
> >  	update_rq_clock(rq);
> 
> Could the per cpu counter stuff be placed into rq to avoid
> touching another cacheline?
> 
I will try and check how it can be done without annoyting people.

Thanks,
-Kame

