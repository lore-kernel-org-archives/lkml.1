Return-Path: <linux-kernel-owner+w=401wt.eu-S1752943AbZA3MiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbZA3MiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 07:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbZA3MhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 07:37:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45580 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbZA3MhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 07:37:09 -0500
Date: Fri, 30 Jan 2009 13:33:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Vitaliy Gusev <vgusev@openvz.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] kthreads: rework kthread_stop()
Message-ID: <20090130123358.GA26216@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on Eric's patch which in turn was based on my patch.

kthread_stop() has the nasty problems:

- it runs unpredictably long with the global semaphore held.

- it deadlocks if kthread itself does kthread_stop() before it obeys
  the kthread_should_stop() request.

- it is not useable if kthread exits on its own, see for example the
  ugly "wait_to_die:" hack in migration_thread()

- it is not possible to just tell kthread it should stop, we must always
  wait for its exit.

With this patch kthread() allocates all neccesary data (struct kthread)
on its own stack, globals kthread_stop_xxx are deleted. ->vfork_done
is used as a pointer into "struct kthread", this means kthread_stop()
can easily wait for kthread's exit.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/kthread.c~3_EXIT	2009-01-30 10:45:18.000000000 +0100
+++ 6.29-rc3/kernel/kthread.c	2009-01-30 12:08:52.000000000 +0100
@@ -37,17 +37,13 @@ struct kthread_create_info
 	struct list_head list;
 };
 
-struct kthread_stop_info
-{
-	struct task_struct *k;
-	int err;
-	struct completion done;
+struct kthread {
+	int should_stop;
+	struct completion exited;
 };
 
-/* Thread stopping is done by setthing this var: lock serializes
- * multiple kthread_stop calls. */
-static DEFINE_MUTEX(kthread_stop_lock);
-static struct kthread_stop_info kthread_stop_info;
+#define to_kthread(tsk)	\
+	container_of((tsk)->vfork_done, struct kthread, exited)
 
 /**
  * kthread_should_stop - should this kthread return now?
@@ -58,20 +54,22 @@ static struct kthread_stop_info kthread_
  */
 int kthread_should_stop(void)
 {
-	return (kthread_stop_info.k == current);
+	return to_kthread(current)->should_stop;
 }
 EXPORT_SYMBOL(kthread_should_stop);
 
 static int kthread(void *_create)
 {
+	/* Copy data: it's on kthread's stack */
 	struct kthread_create_info *create = _create;
-	int (*threadfn)(void *data);
-	void *data;
-	int ret = -EINTR;
+	int (*threadfn)(void *data) = create->threadfn;
+	void *data = create->data;
+	struct kthread self;
+	int ret;
 
-	/* Copy data: it's on kthread's stack */
-	threadfn = create->threadfn;
-	data = create->data;
+	self.should_stop = 0;
+	init_completion(&self.exited);
+	current->vfork_done = &self.exited;
 
 	/* OK, tell user we're spawned, wait for stop or wakeup */
 	__set_current_state(TASK_UNINTERRUPTIBLE);
@@ -79,15 +77,12 @@ static int kthread(void *_create)
 	complete(&create->done);
 	schedule();
 
-	if (!kthread_should_stop())
+	ret = -EINTR;
+	if (!self.should_stop)
 		ret = threadfn(data);
 
-	/* It might have exited on its own, w/o kthread_stop.  Check. */
-	if (kthread_should_stop()) {
-		kthread_stop_info.err = ret;
-		complete(&kthread_stop_info.done);
-	}
-	return 0;
+	/* we can't just return, we must preserve "self" on stack */
+	do_exit(ret);
 }
 
 static void create_kthread(struct kthread_create_info *create)
@@ -197,30 +192,22 @@ EXPORT_SYMBOL(kthread_bind);
  */
 int kthread_stop(struct task_struct *k)
 {
+	struct kthread *kthread;
 	int ret;
 
-	mutex_lock(&kthread_stop_lock);
-
-	/* It could exit after stop_info.k set, but before wake_up_process. */
-	get_task_struct(k);
-
 	trace_sched_kthread_stop(k);
+	get_task_struct(k);
 
-	/* Must init completion *before* thread sees kthread_stop_info.k */
-	init_completion(&kthread_stop_info.done);
-	smp_wmb();
+	kthread = to_kthread(k);
+	barrier(); /* it might have exited */
+	if (k->vfork_done != NULL) {
+		kthread->should_stop = 1;
+		wake_up_process(k);
+		wait_for_completion(&kthread->exited);
+	}
+	ret = k->exit_code;
 
-	/* Now set kthread_should_stop() to true, and wake it up. */
-	kthread_stop_info.k = k;
-	wake_up_process(k);
 	put_task_struct(k);
-
-	/* Once it dies, reset stop ptr, gather result and we're done. */
-	wait_for_completion(&kthread_stop_info.done);
-	kthread_stop_info.k = NULL;
-	ret = kthread_stop_info.err;
-	mutex_unlock(&kthread_stop_lock);
-
 	trace_sched_kthread_stop_ret(ret);
 
 	return ret;

