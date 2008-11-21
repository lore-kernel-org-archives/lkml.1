Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYKUPYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYKUPYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbYKUPX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:23:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40096 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683AbYKUPX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:23:58 -0500
Date: Fri, 21 Nov 2008 10:22:23 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Nauman Rafique <nauman@google.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Divyesh Shah <dpshah@google.com>,
       Fabio Checconi <fchecconi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Ryo Tsuruta <ryov@valinux.co.jp>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, taka@valinux.co.jp,
       righi.andrea@gmail.com, s-uchida@ap.jp.nec.com, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, akpm@linux-foundation.org, menage@google.com,
       ngupta@google.com, riel@redhat.com, jmoyer@redhat.com,
       peterz@infradead.org, paolo.valente@unimore.it
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
Message-ID: <20081121152223.GE3111@redhat.com>
References: <20081118144139.GE15268@gandalf.sssup.it> <20081118191208.GJ26308@kernel.dk> <e98e18940811181507t6b1473act2efa23df21dab270@mail.gmail.com> <20081119142446.GH26308@kernel.dk> <af41c7c40811191612v5db13ae7n3cfe537beb6a157c@mail.gmail.com> <20081120081640.GE26308@kernel.dk> <20081120134058.GA29306@redhat.com> <e98e18940811201154l6fb0499x24da39812fb2aa7e@mail.gmail.com> <20081120211536.GG29306@redhat.com> <e98e18940811201442s787a346em4ada30bcb1badfe6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e98e18940811201442s787a346em4ada30bcb1badfe6@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 02:42:38PM -0800, Nauman Rafique wrote:

[..]
> >> It seems that we have a solution if we can figure out a way to share
> >> cgroup code between different schedulers. I am thinking how other
> >> schedulers (AS, Deadline, No-op) would use cgroups. Will they have
> >> proportional division between requests from different cgroups? And use
> >> their own policy (e.g deadline scheduling) within a cgroup? How about
> >> if we have both threads and cgroups at a particular level? I think
> >> putting all threads in a default cgroup seems like a reasonable choice
> >> in this case.
> >>
> >> Here is a high level design that comes to mind.
> >>
> >> Put proportional division code and state in common code. Each level of
> >> the hierarchy which has more than one cgroup would have some state
> >> maintained in common code. At leaf level of hiearchy, we can have a
> >> cgroup specific scheduler (created when a cgroup is created). We can
> >> choose a different scheduler for each cgroup (we can have a no-op for
> >> one cgroup while cfq for another).
> >
> > I am not sure that I understand the different scheduler for each cgroup
> > aspect of it. What's the need? It makes things even more complicated I
> > think.
> 
> With the design I had in my mind, it seemed like that would come for
> free. But if it does not, I completely agree with you that its not as
> important.
> 
> >
> > But moving proportional division code out of particular scheduler and make
> > it common makes sense.
> >
> > Looking at BFQ, I was thinking that we can just keep large part of the
> > code. This common code can think of everything as scheduling entity. This
> > scheduling entity (SE) will be defined by underlying scheduler depending on
> > how queue management is done by underlying scheduler. So for CFQ, at
> > each level, an SE can be either task or group. For the schedulers which
> > don't maintain separate queues for tasks, it will simply be group at all
> > levels.
> 
> So the structure of hierarchy would be dependent on the underlying scheduler?
> 

Kind of. In fact it will depend on cgroup hierarchy and dependent on
underlying scheduler.

> >
> > We probably can employ B-WFQ2+ to provide hierarchical fairness between
> > secheduling entities of this tree. Common layer will do the scheduling of
> > entities (without knowing what is contained inside) and underlying scheduler
> > will take care of dispatching the requests from the scheduled entity.
> > (It could be a task queue for CFQ or a group queue for other schedulers).
> >
> > The tricky part would be how to abstract it in a clean way. It should lead
> > to reduced code in CFQ/BFQ because B-WFQ2+ logic will be put into a
> > common layer (for large part).
> 
> How about this plan:
> 1 Start with CFQ patched with some BFQ like patches (This is what we
> will have if Jens takes some of Fabio's patches). This will have no
> cgroup related logic (correct me if I am wrong).
> 2 Repeat proportional scheduling logic for cgroups in the common
> layer, without touching the code produced in step 1. That means that
> we will have WF2Q+ used for scheduling cgroup time slices proportional
> to weight in the common code. If CFQ (step 1 output) is used as
> scheduler, WF2Q+ would be used there too, but to schedule time slices
> (in proportion to priorities?) between different threads. Common code
> logic will be completely oblivious of the actual scheduler used
> (patched CFQ, Deadline, AS etc).

I think once you start using WF2Q+ in common layer, CFQ will have to get
rid of that code. (Remember in case of CFQ, we will have a tree which
has got both task and groups as Scheduling Entity). So common layer code
can select the next entity to be dispatched base on WFQ2+ and then 
CFQ will decide which request to dispatch with-in that scheduling entity.

So may be we can start with bfq and try to break the code in two pieces.
One common code and one scheduler specific code. Then try to make use
of common code in deadline or anticipatory to see if things work fine. If,
that works, then we can get to CFQ to make use of common code. By that
time CFQ should have Fabio's changes. I think that will include WF2Q+
algorithm also (At least to provide faireness among taks, and not the
hierarchical thing). Once common layer WF2Q+ works well, we can get rid
of WF2Q+ from CFQ and try to complete the picture.

> cgroup tracking has to be implemented as part of step 2. The good
> thing is that step 2 can proceed independent of step 1, as the output
> of step 1 will have the same interface as the existing CFQ scheduler.
> 

Agreed. any kind of tracking based on bio and not the task context shall
have to be done later, once we have come up with common layer code.

These are very vague high level ideas. Devil lies in details. :-) I will
get started to see how feasible the common layer code idea is.

Thanks
Vivek
