Return-Path: <linux-kernel-owner+w=401wt.eu-S1762798AbXHXQun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762798AbXHXQun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762203AbXHXQuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:50:35 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:41966 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940AbXHXQue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:50:34 -0400
Date: Fri, 24 Aug 2007 20:53:15 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>, Cliff Wickman <cpw@sgi.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] migration_call(CPU_DEAD): use spin_lock_irq() instead of task_rq_lock()
Message-ID: <20070824165315.GA1785@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change migration_call(CPU_DEAD) to use direct spin_lock_irq() instead of
task_rq_lock(rq->idle), rq->idle can't change its task_rq().

This makes the code a bit more symmetrical with migrate_dead_tasks()'s
path which uses spin_lock_irq/spin_unlock_irq.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/kernel/sched.c~2_RQ_LOCK	2007-08-24 20:31:03.000000000 +0400
+++ t/kernel/sched.c	2007-08-24 20:37:17.000000000 +0400
@@ -5381,13 +5381,13 @@ migration_call(struct notifier_block *nf
 		kthread_stop(rq->migration_thread);
 		rq->migration_thread = NULL;
 		/* Idle task back to normal (off runqueue, low prio) */
-		rq = task_rq_lock(rq->idle, &flags);
+		spin_lock_irq(&rq->lock);
 		deactivate_task(rq, rq->idle, 0);
 		rq->idle->static_prio = MAX_PRIO;
 		__setscheduler(rq, rq->idle, SCHED_NORMAL, 0);
 		rq->idle->sched_class = &idle_sched_class;
 		migrate_dead_tasks(cpu);
-		task_rq_unlock(rq, &flags);
+		spin_unlock_irq(&rq->lock);
 		migrate_nr_uninterruptible(rq);
 		BUG_ON(rq->nr_running != 0);
 

