Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbZA3MhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbZA3MhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 07:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbZA3MhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 07:37:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37665 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbZA3MhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 07:37:02 -0500
Date: Fri, 30 Jan 2009 13:34:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Vitaliy Gusev <vgusev@openvz.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] kthreads: simplify migration_thread() exit path
Message-ID: <20090130123401.GA26223@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that kthread_stop() can be used even if the task has already exited,
we can kill the "wait_to_die:" loop in migration_thread(). But we must
pin rq->migration_thread after creation.

Actually, I don't think CPU_UP_CANCELED or CPU_DEAD should wait for
->migration_thread exit. Perhaps we can simplify this code a bit more.
migration_call() can set ->should_stop and forget about this thread.
But we need a new helper in kthred.c for that.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/sched.c~4_MIGRATION	2009-01-19 10:44:33.000000000 +0100
+++ 6.29-rc3/kernel/sched.c	2009-01-30 12:53:57.000000000 +0100
@@ -6208,7 +6208,7 @@ static int migration_thread(void *data)
 
 		if (cpu_is_offline(cpu)) {
 			spin_unlock_irq(&rq->lock);
-			goto wait_to_die;
+			break;
 		}
 
 		if (rq->active_balance) {
@@ -6234,16 +6234,7 @@ static int migration_thread(void *data)
 		complete(&req->done);
 	}
 	__set_current_state(TASK_RUNNING);
-	return 0;
 
-wait_to_die:
-	/* Wait for kthread_stop */
-	set_current_state(TASK_INTERRUPTIBLE);
-	while (!kthread_should_stop()) {
-		schedule();
-		set_current_state(TASK_INTERRUPTIBLE);
-	}
-	__set_current_state(TASK_RUNNING);
 	return 0;
 }
 
@@ -6649,6 +6640,7 @@ migration_call(struct notifier_block *nf
 		rq = task_rq_lock(p, &flags);
 		__setscheduler(rq, p, SCHED_FIFO, MAX_RT_PRIO-1);
 		task_rq_unlock(rq, &flags);
+		get_task_struct(p);
 		cpu_rq(cpu)->migration_thread = p;
 		break;
 
@@ -6677,6 +6669,7 @@ migration_call(struct notifier_block *nf
 		kthread_bind(cpu_rq(cpu)->migration_thread,
 			     cpumask_any(cpu_online_mask));
 		kthread_stop(cpu_rq(cpu)->migration_thread);
+		put_task_struct(cpu_rq(cpu)->migration_thread);
 		cpu_rq(cpu)->migration_thread = NULL;
 		break;
 
@@ -6686,6 +6679,7 @@ migration_call(struct notifier_block *nf
 		migrate_live_tasks(cpu);
 		rq = cpu_rq(cpu);
 		kthread_stop(rq->migration_thread);
+		put_task_struct(rq->migration_thread);
 		rq->migration_thread = NULL;
 		/* Idle task back to normal (off runqueue, low prio) */
 		spin_lock_irq(&rq->lock);

