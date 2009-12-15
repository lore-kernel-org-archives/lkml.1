Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbZLOPX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbZLOPX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 10:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbZLOPX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 10:23:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824AbZLOPX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 10:23:26 -0500
Date: Tue, 15 Dec 2009 10:23:14 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq: Take whether cfq group is changed into account
	when choosing service tree
Message-ID: <20091215152314.GC5811@redhat.com>
References: <4B21D252.1060902@cn.fujitsu.com> <20091211150727.GB2756@redhat.com> <4e5e476b0912111001h3c0b9798u2a2b25c9fcc39504@mail.gmail.com> <20091211184630.GA7066@redhat.com> <4B25A4F0.60407@cn.fujitsu.com> <4e5e476b0912140039s2f802786t84f53ee62b87c04e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0912140039s2f802786t84f53ee62b87c04e@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 09:39:32AM +0100, Corrado Zoccolo wrote:
> Hi,
> On Mon, Dec 14, 2009 at 3:37 AM, Gui Jianfeng
> <guijianfeng@cn.fujitsu.com> wrote:
> > Vivek Goyal wrote:
> >> On Fri, Dec 11, 2009 at 07:01:14PM +0100, Corrado Zoccolo wrote:
> >>> Hi guys,
> >>> On Fri, Dec 11, 2009 at 4:07 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >>>> On Fri, Dec 11, 2009 at 01:02:10PM +0800, Gui Jianfeng wrote:
> >>>>> Currently, with IO Controller introduced, CFQ chooses cfq group
> >>>>> at the top, and then choose service tree. So we need to take
> >>>>> whether cfq group is changed into account to decide whether we
> >>>>> should choose service tree start from scratch.
> >>>>>
> >>>> I am not able to understand the need/purpose of this patch. Once we
> >>>> switched the group during scheduling, why should we reset the order
> >>>> of workload with-in group.
> >>> I understand it, and in fact I was thinking about this.
> >>> The idea is the same as with priorities. If we have not serviced a group
> >>> for a while, we want to start with the no-idle workload to reduce its latency.
> >>>
> >>> Unfortunately, a group may have a too small share, that could cause some
> >>> workloads to be starved, as Vivek correctly points out, and we should
> >>> avoid this.
> >>> It should be easily reproducible testing a "many groups with mixed workloads"
> >>> scenario with group_isolation=1.
> >>>
> >>> Moreover, even if the approach is groups on top, when group isolation
> >>> is not set (i.e. the default), in the non-root groups you will only
> >>> have the sync-idle
> >>> queues, so it is much more similar (logically) to a workload on top
> >>> than it appears
> >>> from the code.
> >>>
> >>> I think the net result of this patch is, when group isolation is not
> >>> set, to select no-idle
> >>> workload first only when entering the root group, thus a slight
> >>> penalization of the
> >>> async workload.
> >>
> >> Also penalization of sync-idle workload in root group.
> >>
> >> The higher latencies for sync-noidle workload with-in a group will be
> >> observed only if group_isolation=1 and if group has low weight. I think
> >> in general this problem should be solved by bumping up the weight of the
> >> group, otherwise just live with it to ensure fairness for sync-idle
> >> workload in the group.
> >>
> >> With group_isolation=0, the problem should be less visible as root group
> >> runs with max weight in the system (1000). In general I will assume that
> >> one will choose system weights in such a manner so that root group does
> >> not starve.
> >>
> >>
> >>> Gui, if you observed improvements with this patch, probably you can obtain them
> >>> without the starvation drawback by making it conditional to !group_isolation.
> >>>
> >>> BTW, since you always use cfqg_changed and prio_changed OR-ed together, you
> >>> can have just one argument, called e.g. boost_no_idle, and you pass
> >>> (!group_isolation && cfqg_changed) || prio_changed.
> >>>
> >>
> >> Because it will impact the share of sync-idle workload in root group and
> >> asyn workload systemwide, I am not too keen on doing this change. I would
> >> rather rely on root group being higher weight.
> >>
> >> So far this reset of workload order happens only if we decide to higher
> >> prio class task. So if there is some RT activity happening in system, we
> >> will constantly be resetting the workload order for BE class and keep on
> >> servicing sync-noidle workload while starving sync-idle and async
> >> workload.
> >>
> >> So it is probably still ok for priority class switching, but I am not too keen
> >> on doing this at group switching event. This event will be too frequent if
> >> there are significant number of groups in the system and we don't want to
> >> starve root group sync-idle and system wide async workload.
> >>
> >> If somebody is not happy with latecies of sync-noidle workload, then
> >> easier way to solve that issue is readjust weights of groups.
> >>
> >> Thanks
> >> Vivek
> >
> > Hi Vivek, Corrado
> >
> > Thanks for Corrado's explanation, i have the same concern.
> >
> > Consider the following code,
> >
> > prio_changed = (cfqd->serving_prio != previous_prio);
> > st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type,
> >                        cfqd);
> > count = st->count;
> > /*
> >  * If priority didn't change, check workload expiration,
> >  * and that we still have other queues ready
> >  */
> > if (!prio_changed && count &&
> >      !time_after(jiffies, cfqd->workload_expires))
> >      return;
> >
> > One more thing i do this change is that currently if serving_prio isn't changed,
> > we'll start from where we left. But with io group introduced, cfqd->serving_prio and
> > previous_prio might come from different groups. So i don't think "prio_changed" still
> > makes sense in the case of group changing.
> Probably it is better to just remove the priority change concept. The
> code will be simpler, and the impact should be very small.
> > cfqd->workload_expires also might come from
> > the workload from another group when deciding whether starting from "cfqd->serving_type".
> This shouldn't happen, since Vivek is saving&restoring the workload
> parameters at each group change. So it is likely that the workload
> will be expired here, and we compute the new workload when entering
> the new group.
> 
> I have one more concern, though.
> RT priority has now changed meaning. Before, an RT task would always
> have priority access to the disk. Now, a BE task in a different group,
> with lower weight, can steal the disk from the RT task.
> A way to preserve the old meaning is to consider wheter a group has RT
> tasks inside when sorting groups tree, and putting those groups at the
> front.
> Usually, RT tasks will be put in the root group, and this (if
> group_isolation=0) will automatically make sure that also the noidle
> workload gets serviced quickly after RT tasks release the disk. We
> could even enforce that, with group_isolation=0, all RT tasks are put
> in the root group.
> 
> The rationale behind this suggestion is that groups are for user
> processes, while RT is system wide, since it is only root that can
> grant it.
> 

Thinking more about it...

Moving all RT tasks to root group will increase the overall share of root
group (including share of non RT workload like sync-idle, sync-noidle and
async). Because everytime, RT task does some IO, root group will be put at the
front of service tree (irrespective of the fact how much service it has
received in the past w.r.t other groups). That will make root group gain
share and in trun root group non-RT sync-idle, sync-nodile and async
workload also gain share.

Another way to solve the issue could be to have a separate service tree
and root group for RT workload. By default all the RT tasks (systemwide),
will be put into that group and we will always serve that root rt group first
and if that group does not have any request than serve the requests from
regular (BE and IDLE tasks), group service tree. 

This will make sure that RT tasks system wide get full access to disk
first and then BE and IDLE tasks get to run. Also BE and IDLE tasks in
root group will not gain share.

One issue with this approach is prio_changed concept. Because now all the
RT tasks are in a seprate group altogether, there will be no concept of
prio_changed with-in group. Rest of the group will have either BE or IDLE
prio tasks only. So that would mean that I need to get rid of prio_changed
concept while selecting workload with-in group and rely on either fresh
selection of workload type based on rb_key offset or kind of force strict
round-robin between workloads of type (sync-idle, sync-noidle and async).

Does this make sense? Corrodo, do you forsee any issues if I get rid of 
prio_changed concept. So if a workload has expired, we will always do
fresh selection of workload based on rb_key across service trees of 
sync-idle, sync-noidle and async. This might lead to issues of sync-noidle
workload not gettting as good latency in the presence of RT tasks. May be
forcing a strict round robin between workload types will mitigate that
issue up to some extent.

Thanks
Vivek
