Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbZIIPjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbZIIPjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZIIPjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:39:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:54937 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbZIIPjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:39:36 -0400
Date: Wed, 9 Sep 2009 15:37:34 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1252486344.28645.18.camel@marge.simson.net>
References: <1252486344.28645.18.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Keep kthreads at default priority
Message-ID: <tip-61cbe54d9479ad98283b2dda686deae4c34b2d59@git.kernel.org>
Git-Commit-ID: 61cbe54d9479ad98283b2dda686deae4c34b2d59
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 09 Sep 2009 15:37:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  61cbe54d9479ad98283b2dda686deae4c34b2d59
Gitweb:     http://git.kernel.org/tip/61cbe54d9479ad98283b2dda686deae4c34b2d59
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Wed, 9 Sep 2009 15:41:37 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Sep 2009 17:30:06 +0200

sched: Keep kthreads at default priority

Removes kthread/workqueue priority boost, they increase worst-case
desktop latencies.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1252486344.28645.18.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/kthread.c   |    4 ----
 kernel/workqueue.c |    2 --
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index eb8751a..5fe7099 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -16,8 +16,6 @@
 #include <linux/mutex.h>
 #include <trace/events/sched.h>
 
-#define KTHREAD_NICE_LEVEL (-5)
-
 static DEFINE_SPINLOCK(kthread_create_lock);
 static LIST_HEAD(kthread_create_list);
 struct task_struct *kthreadd_task;
@@ -145,7 +143,6 @@ struct task_struct *kthread_create(int (*threadfn)(void *data),
 		 * The kernel thread should not inherit these properties.
 		 */
 		sched_setscheduler_nocheck(create.result, SCHED_NORMAL, &param);
-		set_user_nice(create.result, KTHREAD_NICE_LEVEL);
 		set_cpus_allowed_ptr(create.result, cpu_all_mask);
 	}
 	return create.result;
@@ -221,7 +218,6 @@ int kthreadd(void *unused)
 	/* Setup a clean context for our children to inherit. */
 	set_task_comm(tsk, "kthreadd");
 	ignore_signals(tsk);
-	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
 	set_cpus_allowed_ptr(tsk, cpu_all_mask);
 	set_mems_allowed(node_possible_map);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0668795..ea1b4e7 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -317,8 +317,6 @@ static int worker_thread(void *__cwq)
 	if (cwq->wq->freezeable)
 		set_freezable();
 
-	set_user_nice(current, -5);
-
 	for (;;) {
 		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
 		if (!freezing(current) &&
