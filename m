Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYKJNjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYKJNjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 08:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbYKJNje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 08:39:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57188 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913AbYKJNje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 08:39:34 -0500
Date: Mon, 10 Nov 2008 15:39:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Cc: adobriyan@gmail.com, Doug Chapman <doug.chapman@hp.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] for account_group_exec_runtime(), make sure ->signal can't
	be freed under rq->lock
Message-ID: <20081110143930.GA28275@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is ugly, but I don't see the better fix for now. Needs
the review from Peter/Ingo.

Unlike other similar routines, account_group_exec_runtime() could be
called "implicitly" from within scheduler after exit_notify(). This
means we can race with the parent doing release_task(), we can't just
check ->signal != NULL.

Change __exit_signal() to do spin_unlock_wait(&task_rq(tsk)->lock)
before __cleanup_signal() to make sure ->signal can't be freed under
task_rq(tsk)->lock. Note that task_rq_unlock_wait() doesn't care
about the case when tsk changes cpu/rq under us, this should be OK.

Thanks to Ingo who nacked my previous buggy patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Doug Chapman <doug.chapman@hp.com>

--- K-28/include/linux/sched.h~SIG_RQ_LOCK	2008-11-06 19:12:44.000000000 +0100
+++ K-28/include/linux/sched.h	2008-11-10 13:13:07.000000000 +0100
@@ -247,6 +247,7 @@ extern void init_idle(struct task_struct
 extern void init_idle_bootup_task(struct task_struct *idle);
 
 extern int runqueue_is_locked(void);
+extern void task_rq_unlock_wait(struct task_struct *p);
 
 extern cpumask_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
--- K-28/kernel/sched.c~SIG_RQ_LOCK	2008-11-06 19:12:44.000000000 +0100
+++ K-28/kernel/sched.c	2008-11-10 13:05:09.000000000 +0100
@@ -969,6 +969,14 @@ static struct rq *task_rq_lock(struct ta
 	}
 }
 
+void task_rq_unlock_wait(struct task_struct *p)
+{
+	struct rq *rq = task_rq(p);
+
+	smp_mb();
+	spin_unlock_wait(&rq->lock);
+}
+
 static void __task_rq_unlock(struct rq *rq)
 	__releases(rq->lock)
 {
--- K-28/kernel/exit.c~SIG_RQ_LOCK	2008-11-06 19:11:02.000000000 +0100
+++ K-28/kernel/exit.c	2008-11-10 15:07:22.000000000 +0100
@@ -141,6 +141,11 @@ static void __exit_signal(struct task_st
 	if (sig) {
 		flush_sigqueue(&sig->shared_pending);
 		taskstats_tgid_free(sig);
+		/*
+		 * Make sure ->signal can't go away under rq->lock,
+		 * see account_group_exec_runtime().
+		 */
+		task_rq_unlock_wait(tsk);
 		__cleanup_signal(sig);
 	}
 }

