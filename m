Return-Path: <linux-kernel-owner+w=401wt.eu-S1761511AbXHXQua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761511AbXHXQua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbXHXQuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:50:22 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:41965 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756910AbXHXQuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:50:21 -0400
Date: Fri, 24 Aug 2007 20:53:03 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>, Cliff Wickman <cpw@sgi.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] do CPU_DEAD migrating under read_lock(tasklist) instead of write_lock_irq(tasklist)
Message-ID: <20070824165303.GA1782@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(the explicit ack/nack from maintainers is wanted)

Currently move_task_off_dead_cpu() is called under write_lock_irq(tasklist).
This means it can't use task_lock() which is needed to improve migrating to
take task's ->cpuset into account.

Change the code to call move_task_off_dead_cpu() with irqs enabled, and change
migrate_live_tasks() to use read_lock(tasklist).

This all is a preparation for the futher changes proposed by Cliff Wickman, see
	http://marc.info/?t=117327786100003

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/kernel/sched.c~1_READ_LOCK	2007-08-12 14:15:37.000000000 +0400
+++ t/kernel/sched.c	2007-08-24 20:31:03.000000000 +0400
@@ -5048,7 +5048,7 @@ static void move_task_off_dead_cpu(int d
 	unsigned long flags;
 	cpumask_t mask;
 	struct rq *rq;
-	int dest_cpu;
+	int dest_cpu, done;
 
 restart:
 	/* On same node? */
@@ -5077,7 +5077,11 @@ restart:
 			       "longer affine to cpu%d\n",
 			       p->pid, p->comm, dead_cpu);
 	}
-	if (!__migrate_task(p, dead_cpu, dest_cpu))
+
+	local_irq_disable();
+	done = __migrate_task(p, dead_cpu, dest_cpu);
+	local_irq_enable();
+	if (!done)
 		goto restart;
 }
 
@@ -5106,7 +5110,7 @@ static void migrate_live_tasks(int src_c
 {
 	struct task_struct *p, *t;
 
-	write_lock_irq(&tasklist_lock);
+	read_lock(&tasklist_lock);
 
 	do_each_thread(t, p) {
 		if (p == current)
@@ -5116,7 +5120,7 @@ static void migrate_live_tasks(int src_c
 			move_task_off_dead_cpu(src_cpu, p);
 	} while_each_thread(t, p);
 
-	write_unlock_irq(&tasklist_lock);
+	read_unlock(&tasklist_lock);
 }
 
 /*
@@ -5180,11 +5184,10 @@ static void migrate_dead(unsigned int de
 	 * Drop lock around migration; if someone else moves it,
 	 * that's OK.  No task can be added to this CPU, so iteration is
 	 * fine.
-	 * NOTE: interrupts should be left disabled  --dev@
 	 */
-	spin_unlock(&rq->lock);
+	spin_unlock_irq(&rq->lock);
 	move_task_off_dead_cpu(dead_cpu, p);
-	spin_lock(&rq->lock);
+	spin_lock_irq(&rq->lock);
 
 	put_task_struct(p);
 }

