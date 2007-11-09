Return-Path: <linux-kernel-owner+w=401wt.eu-S1751385AbXKIGuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbXKIGuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 01:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbXKIGuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 01:50:06 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:51427 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbXKIGuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 01:50:04 -0500
Date: Fri, 9 Nov 2007 12:32:14 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: sukadev@us.ibm.com
Cc: balbir@in.ibm.com, Containers <containers@lists.osdl.org>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       dhaval@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       dmitry.adamushko@gmail.com, efault@gmx.de
Subject: Re: [BUG]: Crash with CONFIG_FAIR_CGROUP_SCHED=y
Message-ID: <20071109070214.GO3143@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20071108234805.GA2240@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071108234805.GA2240@us.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2007 at 03:48:05PM -0800, sukadev@us.ibm.com wrote:
> With CONFIG_FAIR_CGROUP_SCHED=y, following commands on 2.6.24-rc1 crash
> the system.

Thanks for reporting the problem. It was caused because of the fact that
current task isn't kept in its runqueue in case of sched_fair class
tasks.

With the patch below, I could run ns_exec w/o any crash. Can you pls
verify it works for you as well?

Ingo,
	Once Suka verifies that the patch fixes his crash, I would request you 
to include the same in your tree and route it to Linus.

--

current task is not present in its runqueue in case of sched_fair class
tasks. Take care of this fact in rt_mutex_setprio(),
sched_setscheduler() and sched_move_task() routines.

Signed-off-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>


---
 kernel/sched.c |   45 +++++++++++++++++++++++++--------------------
 1 files changed, 25 insertions(+), 20 deletions(-)

Index: current/kernel/sched.c
===================================================================
--- current.orig/kernel/sched.c
+++ current/kernel/sched.c
@@ -3986,11 +3986,13 @@ void rt_mutex_setprio(struct task_struct
 	oldprio = p->prio;
 	on_rq = p->se.on_rq;
 	running = task_running(rq, p);
-	if (on_rq) {
+	if (on_rq)
 		dequeue_task(rq, p, 0);
-		if (running)
-			p->sched_class->put_prev_task(rq, p);
-	}
+	/* current task is not kept in its runqueue in case of sched_fair class.
+	 * Hence we need the 'on_rq?' and 'running?' tests to be separate.
+	 */
+	if (running)
+		p->sched_class->put_prev_task(rq, p);
 
 	if (rt_prio(prio))
 		p->sched_class = &rt_sched_class;
@@ -3999,9 +4001,9 @@ void rt_mutex_setprio(struct task_struct
 
 	p->prio = prio;
 
+	if (running)
+		p->sched_class->set_curr_task(rq);
 	if (on_rq) {
-		if (running)
-			p->sched_class->set_curr_task(rq);
 		enqueue_task(rq, p, 0);
 		inc_load(rq, p);
 		/*
@@ -4298,18 +4300,20 @@ recheck:
 	update_rq_clock(rq);
 	on_rq = p->se.on_rq;
 	running = task_running(rq, p);
-	if (on_rq) {
+	if (on_rq)
 		deactivate_task(rq, p, 0);
-		if (running)
-			p->sched_class->put_prev_task(rq, p);
-	}
+	/* current task is not kept in its runqueue in case of sched_fair class.
+	 * Hence we need the 'on_rq?' and 'running?' tests to be separate.
+	 */
+	if (running)
+		p->sched_class->put_prev_task(rq, p);
 
 	oldprio = p->prio;
 	__setscheduler(rq, p, policy, param->sched_priority);
 
+	if (running)
+		p->sched_class->set_curr_task(rq);
 	if (on_rq) {
-		if (running)
-			p->sched_class->set_curr_task(rq);
 		activate_task(rq, p, 0);
 		/*
 		 * Reschedule if we are currently running on this runqueue and
@@ -7036,19 +7040,20 @@ void sched_move_task(struct task_struct 
 	running = task_running(rq, tsk);
 	on_rq = tsk->se.on_rq;
 
-	if (on_rq) {
+	if (on_rq)
 		dequeue_task(rq, tsk, 0);
-		if (unlikely(running))
-			tsk->sched_class->put_prev_task(rq, tsk);
-	}
+	/* current task is not kept in its runqueue in case of sched_fair class.
+	 * Hence we need the 'on_rq?' and 'running?' tests to be separate.
+	 */
+	if (unlikely(running))
+		tsk->sched_class->put_prev_task(rq, tsk);
 
 	set_task_cfs_rq(tsk);
 
-	if (on_rq) {
-		if (unlikely(running))
-			tsk->sched_class->set_curr_task(rq);
+	if (unlikely(running))
+		tsk->sched_class->set_curr_task(rq);
+	if (on_rq)
 		enqueue_task(rq, tsk, 0);
-	}
 
 done:
 	task_rq_unlock(rq, &flags);


-- 
Regards,
vatsa
