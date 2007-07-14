Return-Path: <linux-kernel-owner+w=401wt.eu-S1762817AbXGNTIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762817AbXGNTIF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 15:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760136AbXGNTHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 15:07:54 -0400
Received: from canuck.infradead.org ([209.217.80.40]:44097 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759466AbXGNTHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 15:07:53 -0400
Subject: Re: [PATCH -rt 2/5] Thread Migration Preemption - v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <1184438694.5284.69.camel@lappy>
References: <20070714175733.194012000@chello.nl>
	 <20070714175839.641246000@chello.nl>  <20070714171646.GB746@tv-sign.ru>
	 <1184438694.5284.69.camel@lappy>
Content-Type: text/plain
Date: Sat, 14 Jul 2007 21:07:31 +0200
Message-Id: <1184440051.5284.72.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

How about somethign like this?

---

Avoid busy looping on unmigratable tasks by pushing the migration requests
onto a delayed_migration_queue, which we try on each wakeup.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -288,6 +288,7 @@ struct rq {
 
 	struct task_struct *migration_thread;
 	struct list_head migration_queue;
+	struct list_head delayed_migration_queue;
 #endif
 
 #ifdef CONFIG_SCHEDSTATS
@@ -5623,6 +5624,11 @@ static int migration_thread(void *data)
 		head = &rq->migration_queue;
 
 		if (list_empty(head)) {
+			/*
+			 * we got a wakeup, give the delayed list another shot.
+			 */
+			if (current->state != TASK_INTERRUPTIBLE)
+				list_splice(&rq->delayed_migration_queue, head);
 			spin_unlock_irq(&rq->lock);
 			schedule();
 			set_current_state(TASK_INTERRUPTIBLE);
@@ -5641,8 +5647,7 @@ static int migration_thread(void *data)
 			 * wake us up.
 			 */
 			spin_lock_irq(&rq->lock);
-			head = &rq->migration_queue;
-			list_add(&req->list, head);
+			list_add(&req->list, &rq->delayed_migration_queue);
 			set_tsk_thread_flag(req->task, TIF_NEED_MIGRATE);
 			spin_unlock_irq(&rq->lock);
 			wake_up_process(req->task);
@@ -7006,6 +7011,7 @@ void __init sched_init(void)
 		rq->cpu = i;
 		rq->migration_thread = NULL;
 		INIT_LIST_HEAD(&rq->migration_queue);
+		INIT_LIST_HEAD(&rq->delayed_migration_queue);
 #endif
 		atomic_set(&rq->nr_iowait, 0);
 


