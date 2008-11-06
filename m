Return-Path: <linux-kernel-owner+w=401wt.eu-S1754358AbYKFIqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbYKFIqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 03:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYKFIqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 03:46:11 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:56760 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbYKFIqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 03:46:10 -0500
X-SourceIP: 213.46.9.244
Subject: Re: Scheduler RR, first time slice wrong?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andreas Huber <andreas.huber@keymile.com>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <20081106074449.GC8459@elte.hu>
References: <1225956167.4472.27.camel@chber1-10446x.ch.keymile.net>
	 <20081106074449.GC8459@elte.hu>
Content-Type: text/plain
Date: Thu, 06 Nov 2008 09:46:52 +0100
Message-Id: <1225961212.7803.4190.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-06 at 08:44 +0100, Ingo Molnar wrote:
> (added Cc:s)
> 
> * Andreas Huber <andreas.huber@keymile.com> wrote:
> 
> > Hi,
> > 
> > when starting a real-time process with the round-robin scheduler, the
> > first time slice is set to HZ (1 second).
> > When starting two such processes at the same time of the same static
> > priority, the second one started is first executed after 1 second.
> > (supposing the first process is heavy on cpu load).
> > After both have exhausted this first time slice, it is set to
> > DEF_TIMESLICE (which is 100ms).
> > 
> > Is this behavior as it is supposed to be?
> > 
> > Please add me in CC.
> > 
> > Regards,
> > Andreas
> > 
> > 
> > Relevant parts in the code:
> > include/linux/init_task.h
> > #define INIT_TASK(tsk) \
> > 	.rt	= { \
> > 		.time_slice = HZ,
> > 
> > kernel/sched.c
> > #define DEF_TIMESLICE   (100 * HZ / 1000)
> > 
> > kernel/sched_rt.c
> > static void task_tick_rt(struct rq *rq, struct task_struct *p, int
> > queued)
> >   if (--p->rt.time_slice)
> >     return;
> > 
> >   p->rt.time_slice = DEF_TIMESLICE;
> > 

How does this work?


---
Subject: sched: reset RR timeslice on fork

Currently we inherit the RR time-slice from our parent. In case that is
init we inherit the 1s value set by default, in case its an already
running RR task, we inherit whatever is left.

Fix both these by resetting the time-slice on fork.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/kernel/sched.c b/kernel/sched.c
index 241fd85..e7d69a0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2337,6 +2337,7 @@ static void __sched_fork(struct task_struct *p)
 #endif
 
 	INIT_LIST_HEAD(&p->rt.run_list);
+	p->rt.time_slice = DEF_TIMESLICE;
 	p->se.on_rq = 0;
 	INIT_LIST_HEAD(&p->se.group_node);
 


