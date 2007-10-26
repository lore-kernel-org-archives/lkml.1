Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbXJZPSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbXJZPSE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbXJZPRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:17:53 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:57209 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbXJZPRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:17:52 -0400
Date: Fri, 26 Oct 2007 11:17:07 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [PATCH] RT: Cache cpus_allowed weight for optimizing migration
In-Reply-To: <1193410770.3959.8.camel@ghaskins-t60p.haskins.net>
Message-ID: <Pine.LNX.4.58.0710261114270.3280@gandalf.stny.rr.com>
References: 1193346777.7561.47.camel@ghaskins-t60p.haskins.net
 <20071026132440.5370.78235.stgit@novell1.haskins.net> 
 <Pine.LNX.4.58.0710261035310.18997@gandalf.stny.rr.com>
 <1193410770.3959.8.camel@ghaskins-t60p.haskins.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--
On Fri, 26 Oct 2007, Gregory Haskins wrote:

> On Fri, 2007-10-26 at 10:47 -0400, Steven Rostedt wrote:
> > --
> > On Fri, 26 Oct 2007, Gregory Haskins wrote:
> >
> > > This version has the feedback from Steve's review incorporated
> > >
> > > -----------------------------------------
> > >
> > > RT: Cache cpus_allowed weight for optimizing migration
> > >
> > > Some RT tasks (particularly kthreads) are bound to one specific CPU.
> > > It is fairly common for one or more bound tasks to get queued up at the
> > > same time.  Consider, for instance, softirq_timer and softirq_sched.  A
> > > timer goes off in an ISR which schedules softirq_thread to run at RT50.
> > > Then during the handling of the timer, the system determines that it's
> > > time to smp-rebalance the system so it schedules softirq_sched to run
> > > from within the softirq_timer kthread context. So we are in a situation
> > > where we have two RT50 tasks queued, and the system will go into
> > > rt-overload condition to request other CPUs for help.
> > >
> > > The problem is that these tasks cannot ever be pulled away since they
> > > are already running on their one and only valid RQ.  However, the other
> > > CPUs cannot determine that the tasks are unpullable without going
> > > through expensive checks/locking.  Therefore the helping CPUS
> >
> > A little exageration there ;-)  We don't need to go through locking (at
> > least my code doesn't), and the checks are not that expensive (could cause
> > some unneeded cache bouncing though).
>
> Well, its all relative.  Not going into overload to begin with, and
> therefore not hitting the pull_rt_tasks() logic outright should be
> faster than lockless scanning tricks ;)
>
> But I digress.  I don't think the original code had your optimization,
> so you are right:  It's perhaps a bit of an exaggeration in HEAD.  I'll
> be less dramatic for the next drop ;)
>

I'll digress some more ;-)

Actually, what I want to stress is that the greatest benefit of this patch
is not removing the unneed checks to processes that can't migrate (it is a
benefit though), but the real benefit that I'm looking forward to is the
migrating of lower priority tasks that can migrate. And these tasks wont
be affected by tasks that can't migrate.

Looking forward to your next patch.

-- Steve

