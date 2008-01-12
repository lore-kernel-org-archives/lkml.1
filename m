Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbYALVKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbYALVKq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 16:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760538AbYALVKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 16:10:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757077AbYALVKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 16:10:37 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org
Subject: [PATCH] kthread: allow kthread_stop calls to run in parallel
Date: Sat, 12 Jan 2008 16:10:25 -0500
Message-Id: <1200172225-25149-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.5.3.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, all kthread_stop calls are serialized. If something calls
kthread_stop on a kthread, no other kthread will be able to be
brought down until the first kthread_stop returns. A "rogue" kthread
could therefore prevent other kthreads from ever coming down.

This patch makes it so that kthread_stop calls can be done in parallel.
To do this, it adds a new pointer to the task struct. This works, but
I'd prefer to use an existing pointer that's never used for kthreads
rather than adding a new one. I'm just not sure what pointer would be
a good candidate for this.

This is really an RFC at this point, so comments and suggestions
are appreciated...

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 include/linux/sched.h |    2 ++
 kernel/kthread.c      |   33 +++++++++++++--------------------
 2 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ac3d496..bc38574 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1178,6 +1178,8 @@ struct task_struct {
 	int make_it_fail;
 #endif
 	struct prop_local_single dirties;
+
+	struct kthread_stop_info *kthread_stop_info;
 };
 
 /*
diff --git a/kernel/kthread.c b/kernel/kthread.c
index dcfe724..12594fa 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -35,26 +35,23 @@ struct kthread_create_info
 
 struct kthread_stop_info
 {
-	struct task_struct *k;
 	int err;
 	struct completion done;
 };
 
-/* Thread stopping is done by setthing this var: lock serializes
- * multiple kthread_stop calls. */
-static DEFINE_MUTEX(kthread_stop_lock);
-static struct kthread_stop_info kthread_stop_info;
-
 /**
  * kthread_should_stop - should this kthread return now?
  *
  * When someone calls kthread_stop() on your kthread, it will be woken
  * and this will return true.  You should then return, and your return
  * value will be passed through to kthread_stop().
+ *
+ * In this implementation, setting the kthread_stop_info pointer to
+ * a non-NULL value means that it should stop.
  */
 int kthread_should_stop(void)
 {
-	return (kthread_stop_info.k == current);
+	return (current->kthread_stop_info != NULL);
 }
 EXPORT_SYMBOL(kthread_should_stop);
 
@@ -68,6 +65,7 @@ static int kthread(void *_create)
 	/* Copy data: it's on kthread's stack */
 	threadfn = create->threadfn;
 	data = create->data;
+	current->kthread_stop_info = NULL;
 
 	/* OK, tell user we're spawned, wait for stop or wakeup */
 	__set_current_state(TASK_UNINTERRUPTIBLE);
@@ -79,8 +77,8 @@ static int kthread(void *_create)
 
 	/* It might have exited on its own, w/o kthread_stop.  Check. */
 	if (kthread_should_stop()) {
-		kthread_stop_info.err = ret;
-		complete(&kthread_stop_info.done);
+		current->kthread_stop_info->err = ret;
+		complete(&current->kthread_stop_info->done);
 	}
 	return 0;
 }
@@ -104,7 +102,7 @@ static void create_kthread(struct kthread_create_info *create)
 
 /**
  * kthread_create - create a kthread.
- * @threadfn: the function to run until signal_pending(current).
+ * @threadfn: the function to run until kthread_should_stop()
  * @data: data ptr for @threadfn.
  * @namefmt: printf-style name for the thread.
  *
@@ -188,29 +186,24 @@ EXPORT_SYMBOL(kthread_bind);
  */
 int kthread_stop(struct task_struct *k)
 {
-	int ret;
-
-	mutex_lock(&kthread_stop_lock);
+	struct kthread_stop_info kstop_info;
 
 	/* It could exit after stop_info.k set, but before wake_up_process. */
 	get_task_struct(k);
 
 	/* Must init completion *before* thread sees kthread_stop_info.k */
-	init_completion(&kthread_stop_info.done);
+	init_completion(&kstop_info.done);
 	smp_wmb();
 
 	/* Now set kthread_should_stop() to true, and wake it up. */
-	kthread_stop_info.k = k;
+	k->kthread_stop_info = &kstop_info;
 	wake_up_process(k);
 	put_task_struct(k);
 
 	/* Once it dies, reset stop ptr, gather result and we're done. */
-	wait_for_completion(&kthread_stop_info.done);
-	kthread_stop_info.k = NULL;
-	ret = kthread_stop_info.err;
-	mutex_unlock(&kthread_stop_lock);
+	wait_for_completion(&kstop_info.done);
 
-	return ret;
+	return kstop_info.err;
 }
 EXPORT_SYMBOL(kthread_stop);
 
-- 
1.5.3.7

