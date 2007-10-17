Return-Path: <linux-kernel-owner+w=401wt.eu-S933915AbXJQOtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915AbXJQOtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 10:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932435AbXJQOtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 10:49:15 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43872 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932119AbXJQOtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 10:49:13 -0400
Date: Wed, 17 Oct 2007 20:30:56 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.23-git8 kernel oops at __rb_rotate_left+0x7/0x70
Message-ID: <20071017150056.GA28135@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <47144B4F.3050108@linux.vnet.ibm.com> <20071017142140.GA8634@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017142140.GA8634@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 04:21:40PM +0200, Ingo Molnar wrote:
> * Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
> > While running kernbench with the 2.6.23-git8 following oops is 
> > produced
> 
> Dmitry found something that might explain the crash: could you check 
> whether the patch below fixes it?

> this should fix the put_prev_task crashes that were reported,
> Dmitry Adamushko noticed that it's not valid to call into
> task_new_fair() if this_cpu != task_cpu(p).

I don't see a fundamental reason why it would be invalid to call
task_new_fair() when this_cpu != task_cpu(p). Besides, calling 
activate_task->enqueue_task->enqueue_task_fair() on a new born task (as
is being done in the patch you have sent) is slightly buggy in the sense that 
its p->se.vruntime is not properly calculated (because we set wakeup argument 
as 0).

We (myself, Kamalesh and Dhaval) have tested the patch below, w/o being
able to recreate the problem. The patch allows for task_new_fair() to be
called even for the case when child is being added to another cpu's
runqueue.

--

Child task may be added on a different cpu that the one on which parent
is running. In which case, task_new_fair() should check whether the new
born task's parent entity should be added as well on the cfs_rq.

Patch below fixes the problem in task_new_fair.

Signed-off-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>


---
 kernel/sched.c      |    2 +-
 kernel/sched_fair.c |    6 +-----
 2 files changed, 2 insertions(+), 6 deletions(-)

Index: current/kernel/sched.c
===================================================================
--- current.orig/kernel/sched.c
+++ current/kernel/sched.c
@@ -1712,7 +1712,7 @@ void fastcall wake_up_new_task(struct ta
 
 	p->prio = effective_prio(p);
 
-	if (!p->sched_class->task_new || !current->se.on_rq || !rq->cfs.curr) {
+	if (!p->sched_class->task_new || !current->se.on_rq) {
 		activate_task(rq, p, 0);
 	} else {
 		/*
Index: current/kernel/sched_fair.c
===================================================================
--- current.orig/kernel/sched_fair.c
+++ current/kernel/sched_fair.c
@@ -1031,12 +1031,8 @@ static void task_new_fair(struct rq *rq,
 		swap(curr->vruntime, se->vruntime);
 	}
 
-	update_stats_enqueue(cfs_rq, se);
-	check_spread(cfs_rq, se);
-	check_spread(cfs_rq, curr);
-	__enqueue_entity(cfs_rq, se);
-	account_entity_enqueue(cfs_rq, se);
 	se->peer_preempt = 0;
+	enqueue_task_fair(rq, p, 0);
 	resched_task(rq->curr);
 }
 
-- 
Regards,
vatsa
