Return-Path: <linux-kernel-owner+w=401wt.eu-S1760622AbZLKSqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622AbZLKSqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 13:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758950AbZLKSqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 13:46:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758292AbZLKSqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 13:46:30 -0500
Date: Fri, 11 Dec 2009 13:46:30 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq: Take whether cfq group is changed into account
	when choosing service tree
Message-ID: <20091211184630.GA7066@redhat.com>
References: <4B21D252.1060902@cn.fujitsu.com> <20091211150727.GB2756@redhat.com> <4e5e476b0912111001h3c0b9798u2a2b25c9fcc39504@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0912111001h3c0b9798u2a2b25c9fcc39504@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 07:01:14PM +0100, Corrado Zoccolo wrote:
> Hi guys,
> On Fri, Dec 11, 2009 at 4:07 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Fri, Dec 11, 2009 at 01:02:10PM +0800, Gui Jianfeng wrote:
> >> Currently, with IO Controller introduced, CFQ chooses cfq group
> >> at the top, and then choose service tree. So we need to take
> >> whether cfq group is changed into account to decide whether we
> >> should choose service tree start from scratch.
> >>
> >
> > I am not able to understand the need/purpose of this patch. Once we
> > switched the group during scheduling, why should we reset the order
> > of workload with-in group.
> 
> I understand it, and in fact I was thinking about this.
> The idea is the same as with priorities. If we have not serviced a group
> for a while, we want to start with the no-idle workload to reduce its latency.
> 
> Unfortunately, a group may have a too small share, that could cause some
> workloads to be starved, as Vivek correctly points out, and we should
> avoid this.
> It should be easily reproducible testing a "many groups with mixed workloads"
> scenario with group_isolation=1.
> 
> Moreover, even if the approach is groups on top, when group isolation
> is not set (i.e. the default), in the non-root groups you will only
> have the sync-idle
> queues, so it is much more similar (logically) to a workload on top
> than it appears
> from the code.
> 
> I think the net result of this patch is, when group isolation is not
> set, to select no-idle
> workload first only when entering the root group, thus a slight
> penalization of the
> async workload.

Also penalization of sync-idle workload in root group.

The higher latencies for sync-noidle workload with-in a group will be
observed only if group_isolation=1 and if group has low weight. I think
in general this problem should be solved by bumping up the weight of the
group, otherwise just live with it to ensure fairness for sync-idle
workload in the group.

With group_isolation=0, the problem should be less visible as root group
runs with max weight in the system (1000). In general I will assume that
one will choose system weights in such a manner so that root group does
not starve.


> Gui, if you observed improvements with this patch, probably you can obtain them
> without the starvation drawback by making it conditional to !group_isolation.
> 
> BTW, since you always use cfqg_changed and prio_changed OR-ed together, you
> can have just one argument, called e.g. boost_no_idle, and you pass
> (!group_isolation && cfqg_changed) || prio_changed.
> 

Because it will impact the share of sync-idle workload in root group and
asyn workload systemwide, I am not too keen on doing this change. I would
rather rely on root group being higher weight.

So far this reset of workload order happens only if we decide to higher
prio class task. So if there is some RT activity happening in system, we
will constantly be resetting the workload order for BE class and keep on
servicing sync-noidle workload while starving sync-idle and async
workload.

So it is probably still ok for priority class switching, but I am not too keen
on doing this at group switching event. This event will be too frequent if
there are significant number of groups in the system and we don't want to
starve root group sync-idle and system wide async workload. 

If somebody is not happy with latecies of sync-noidle workload, then
easier way to solve that issue is readjust weights of groups.

Thanks
Vivek
 



> > In fact we don't want to do that and we
> > want to start from where we left so that no workload with-in group is
> > starved.
> 
> Agreed.
> 
> Thanks,
> Corrado
> 
> >
> > When a group is resumed, choose_service_tree() always checks if any RT
> > queue got backlogged or not. If yes, it does choose that first.
> >
> > Can you give more details why do you want to do this change?
> >
> > Thanks
> > Vivek
> >
> >> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> >> ---
> >>  block/cfq-iosched.c |   27 ++++++++++++++++++---------
> >>  1 files changed, 18 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> >> index f3f6239..16084ca 100644
> >> --- a/block/cfq-iosched.c
> >> +++ b/block/cfq-iosched.c
> >> @@ -1964,7 +1964,7 @@ static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
> >>
> >>  static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
> >>                               struct cfq_group *cfqg, enum wl_prio_t prio,
> >> -                             bool prio_changed)
> >> +                             bool cfqg_changed, bool prio_changed)
> >>  {
> >>       struct cfq_queue *queue;
> >>       int i;
> >> @@ -1972,7 +1972,7 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
> >>       unsigned long lowest_key = 0;
> >>       enum wl_type_t cur_best = SYNC_NOIDLE_WORKLOAD;
> >>
> >> -     if (prio_changed) {
> >> +     if (cfqg_changed || prio_changed) {
> >>               /*
> >>                * When priorities switched, we prefer starting
> >>                * from SYNC_NOIDLE (first choice), or just SYNC
> >> @@ -2001,7 +2001,8 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
> >>       return cur_best;
> >>  }
> >>
> >> -static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
> >> +static void choose_service_tree(struct cfq_data *cfqd,
> >> +                             struct cfq_group *cfqg, bool cfqg_changed)
> >>  {
> >>       enum wl_prio_t previous_prio = cfqd->serving_prio;
> >>       bool prio_changed;
> >> @@ -2033,21 +2034,22 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
> >>        * expiration time
> >>        */
> >>       prio_changed = (cfqd->serving_prio != previous_prio);
> >> -     st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type,
> >> -                             cfqd);
> >> +     st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type,
> >> +                           cfqd);
> >>       count = st->count;
> >>
> >>       /*
> >>        * If priority didn't change, check workload expiration,
> >>        * and that we still have other queues ready
> >>        */
> >> -     if (!prio_changed && count &&
> >> +     if (!cfqg_changed && !prio_changed && count &&
> >>           !time_after(jiffies, cfqd->workload_expires))
> >>               return;
> >>
> >>       /* otherwise select new workload type */
> >>       cfqd->serving_type =
> >> -             cfq_choose_wl(cfqd, cfqg, cfqd->serving_prio, prio_changed);
> >> +             cfq_choose_wl(cfqd, cfqg, cfqd->serving_prio,
> >> +                           cfqg_changed, prio_changed);
> >>       st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type,
> >>                               cfqd);
> >>       count = st->count;
> >> @@ -2104,9 +2106,16 @@ static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
> >>
> >>  static void cfq_choose_cfqg(struct cfq_data *cfqd)
> >>  {
> >> +     bool cfqg_changed = false;
> >> +
> >> +     struct cfq_group *orig_cfqg = cfqd->serving_group;
> >> +
> >>       struct cfq_group *cfqg = cfq_get_next_cfqg(cfqd);
> >>
> >> -     cfqd->serving_group = cfqg;
> >> +     if (orig_cfqg != cfqg) {
> >> +             cfqg_changed = 1;
> >> +             cfqd->serving_group = cfqg;
> >> +     }
> >>
> >>       /* Restore the workload type data */
> >>       if (cfqg->saved_workload_slice) {
> >> @@ -2114,7 +2123,7 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
> >>               cfqd->serving_type = cfqg->saved_workload;
> >>               cfqd->serving_prio = cfqg->saved_serving_prio;
> >>       }
> >> -     choose_service_tree(cfqd, cfqg);
> >> +     choose_service_tree(cfqd, cfqg, cfqg_changed);
> >>  }
> >>
> >>  /*
> >> --
> >> 1.5.4.rc3
> >>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 
> 
> -- 
> __________________________________________________________________________
> 
> dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
> PhD - Department of Computer Science - University of Pisa, Italy
> --------------------------------------------------------------------------
> The self-confidence of a warrior is not the self-confidence of the average
> man. The average man seeks certainty in the eyes of the onlooker and calls
> that self-confidence. The warrior seeks impeccability in his own eyes and
> calls that humbleness.
>                                Tales of Power - C. Castaneda
