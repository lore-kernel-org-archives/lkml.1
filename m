Return-Path: <linux-kernel-owner+w=401wt.eu-S1752088AbZH0JS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbZH0JS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 05:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbZH0JS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 05:18:26 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46934 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbZH0JSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:18:25 -0400
Date: Thu, 27 Aug 2009 11:18:27 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Cc: tj@kernel.org, alan@lxorguk.ukuu.org.uk, jeff@garzik.org,
       dhowells@redhat.com
Subject: [PATCH 2/3] slow-work: add support for cancellation of slow work
	(updated)
Message-ID: <20090827091826.GH12579@kernel.dk>
References: <1251364122-9592-1-git-send-email-jens.axboe@oracle.com> <1251364122-9592-2-git-send-email-jens.axboe@oracle.com> <1251364122-9592-3-git-send-email-jens.axboe@oracle.com> <20090827091409.GF12579@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827091409.GF12579@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 542bd594356125971a518a4c7a3e4ead21ea256a Mon Sep 17 00:00:00 2001
From: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 27 Aug 2009 11:17:04 +0200
Subject: [PATCH 1/2] slow-work: add support for cancellation of slow work

This adds support for cancellation of queued slow work and delayed
slow work. If the work is already queued, it will not be executed.
If work is attempted queued while the cancellation is running,
it will fail.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/slow-work.h |    3 +++
 kernel/slow-work.c        |   43 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/include/linux/slow-work.h b/include/linux/slow-work.h
index 12827a8..f2fd4e1 100644
--- a/include/linux/slow-work.h
+++ b/include/linux/slow-work.h
@@ -47,6 +47,7 @@ struct slow_work {
 #define SLOW_WORK_EXECUTING	1	/* item currently executing */
 #define SLOW_WORK_ENQ_DEFERRED	2	/* item enqueue deferred */
 #define SLOW_WORK_VERY_SLOW	3	/* item is very slow */
+#define SLOW_WORK_CANCEL	4	/* item is cancelled, don't enqueue */
 	const struct slow_work_ops *ops; /* operations table for this item */
 	struct list_head	link;	/* link in queue */
 };
@@ -96,11 +97,13 @@ static inline void vslow_work_init(struct slow_work *work,
 }
 
 extern int slow_work_enqueue(struct slow_work *work);
+extern void cancel_slow_work(struct slow_work *work);
 extern int slow_work_register_user(void);
 extern void slow_work_unregister_user(void);
 
 extern int delayed_slow_work_enqueue(struct delayed_slow_work *dwork,
 					unsigned long delay);
+extern void cancel_delayed_slow_work(struct delayed_slow_work *dwork);
 
 #ifdef CONFIG_SYSCTL
 extern ctl_table slow_work_sysctls[];
diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index 1eeda59..a39778a 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -194,7 +194,17 @@ static bool slow_work_execute(void)
 	if (!test_and_clear_bit(SLOW_WORK_PENDING, &work->flags))
 		BUG();
 
-	work->ops->execute(work);
+	/*
+	 * Wake anyone waiting for this work to not be pending anymore
+	 */
+	smp_mb__after_clear_bit();
+	wake_up_bit(&work->flags, SLOW_WORK_PENDING);
+
+	/*
+	 * Don't execute if the work was cancelled after being added
+	 */
+	if (!test_bit(SLOW_WORK_CANCEL, &work->flags))
+		work->ops->execute(work);
 
 	if (very_slow)
 		atomic_dec(&vslow_work_executing_count);
@@ -260,12 +270,16 @@ auto_requeue:
  * allowed to pick items to execute.  This ensures that very slow items won't
  * overly block ones that are just ordinarily slow.
  *
- * Returns 0 if successful, -EAGAIN if not.
+ * Returns 0 if successful, -EAGAIN if not (or -EBUSY if cancelled work is
+ * attempted queued)
  */
 int slow_work_enqueue(struct slow_work *work)
 {
 	unsigned long flags;
 
+	if (test_bit(SLOW_WORK_CANCEL, &work->flags))
+		return -EINVAL;
+
 	BUG_ON(slow_work_user_count <= 0);
 	BUG_ON(!work);
 	BUG_ON(!work->ops);
@@ -347,6 +361,9 @@ int delayed_slow_work_enqueue(struct delayed_slow_work *dwork,
 	struct slow_work *work = &dwork->work;
 	unsigned long flags;
 
+	if (test_bit(SLOW_WORK_CANCEL, &work->flags))
+		return -EINVAL;
+
 	BUG_ON(slow_work_user_count <= 0);
 	BUG_ON(!work);
 	BUG_ON(!work->ops);
@@ -377,6 +394,28 @@ cant_get_ref:
 }
 EXPORT_SYMBOL(delayed_slow_work_enqueue);
 
+static int slow_work_wait(void *word)
+{
+	schedule();
+	return 0;
+}
+
+void cancel_slow_work(struct slow_work *work)
+{
+	set_bit(SLOW_WORK_CANCEL, &work->flags);
+	wait_on_bit(&work->flags, SLOW_WORK_PENDING, slow_work_wait,
+				TASK_UNINTERRUPTIBLE);
+	clear_bit(SLOW_WORK_CANCEL, &work->flags);
+}
+EXPORT_SYMBOL(cancel_slow_work);
+
+void cancel_delayed_slow_work(struct delayed_slow_work *dwork)
+{
+	del_timer(&dwork->timer);
+	cancel_slow_work(&dwork->work);
+}
+EXPORT_SYMBOL(cancel_delayed_slow_work);
+
 /*
  * Schedule a cull of the thread pool at some time in the near future
  */
-- 
1.6.4.1.207.g68ea

-- 
Jens Axboe

