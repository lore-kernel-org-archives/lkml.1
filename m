Return-Path: <linux-kernel-owner+w=401wt.eu-S1760474AbZLOQWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760474AbZLOQWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 11:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbZLOQWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 11:22:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433AbZLOQWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 11:22:41 -0500
Date: Tue, 15 Dec 2009 11:22:32 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq: Take whether cfq group is changed into account
	when choosing service tree
Message-ID: <20091215162232.GD5811@redhat.com>
References: <4B21D252.1060902@cn.fujitsu.com> <20091211150727.GB2756@redhat.com> <4e5e476b0912111001h3c0b9798u2a2b25c9fcc39504@mail.gmail.com> <20091211184630.GA7066@redhat.com> <4B25A4F0.60407@cn.fujitsu.com> <4e5e476b0912140039s2f802786t84f53ee62b87c04e@mail.gmail.com> <20091215152314.GC5811@redhat.com> <4e5e476b0912150804g79f2a89byb9913861476b9297@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0912150804g79f2a89byb9913861476b9297@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 05:04:31PM +0100, Corrado Zoccolo wrote:
> Hi Vivek,
> 
> On Tue, Dec 15, 2009 at 4:23 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > Thinking more about it...
> >
> > Moving all RT tasks to root group will increase the overall share of root
> > group (including share of non RT workload like sync-idle, sync-noidle and
> > async). Because everytime, RT task does some IO, root group will be put at the
> > front of service tree (irrespective of the fact how much service it has
> > received in the past w.r.t other groups). That will make root group gain
> > share and in trun root group non-RT sync-idle, sync-nodile and async
> > workload also gain share.
> >
> Yes, this can be a problem. However, it can obtain a similar effect to the
> prio_changed concept (especially when group_isolation = 0). In fact, we wanted
> to run sync_noidle after RT, and sync_noidle are in root group in the
> uninsulated case.
> 
> > Another way to solve the issue could be to have a separate service tree
> > and root group for RT workload. By default all the RT tasks (systemwide),
> > will be put into that group and we will always serve that root rt group first
> > and if that group does not have any request than serve the requests from
> > regular (BE and IDLE tasks), group service tree.
> Ok. In this way, in a group you won't have 2 arrays of service trees
> (one for each priority), but just one of them.
> Only the RT root group will be allowed to contain RT queues.

Yes, something like that. So instead of a group hosting both RT and BE
queues, group can have a type and it will host only either RT or BE
queues.
 
> What about IDLE? Should we have an other root group for it, to have
> system-wide idle?

My be. We can make a system wide idle group also along the lines of system
wide RT group.

So in this model, we will be doing proportional BW division only for BE
class tasks and not for RT and BE class tasks. RT and BE class tasks will
be system wide and will always go to fixed root RT or root BE groups. BE
class tasks will go in different groups based on their cgroups and will
get disk share in proportion to group weight.

> In that case, the design will become more orthogonal.
> 
> >
> > This will make sure that RT tasks system wide get full access to disk
> > first and then BE and IDLE tasks get to run. Also BE and IDLE tasks in
> > root group will not gain share.
> >
> > One issue with this approach is prio_changed concept. Because now all the
> > RT tasks are in a seprate group altogether, there will be no concept of
> > prio_changed with-in group. Rest of the group will have either BE or IDLE
> > prio tasks only. So that would mean that I need to get rid of prio_changed
> > concept while selecting workload with-in group and rely on either fresh
> > selection of workload type based on rb_key offset or kind of force strict
> > round-robin between workloads of type (sync-idle, sync-noidle and async).
> >
> > Does this make sense? Corrodo, do you forsee any issues if I get rid of
> > prio_changed concept. So if a workload has expired, we will always do
> > fresh selection of workload based on rb_key across service trees of
> > sync-idle, sync-noidle and async. This might lead to issues of sync-noidle
> > workload not gettting as good latency in the presence of RT tasks. May be
> > forcing a strict round robin between workload types will mitigate that
> > issue up to some extent.
> >
> I think the prio_changed concept can simply be dropped, and we can still have
> lowest rb_key selection (that I think is superior to strict round robin).
> I don't see any problem in this. In presence of RT, the latency will
> go up anyway.

Ok, initially we can stick to lowest rb_key based selection and if that
does not give satisfactory latencies for sync-noidle workload, we can
revisit this issue.

Cool, I will write a patch and see how well does this thing work.

Thanks
Vivek
