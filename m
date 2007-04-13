Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbXDMNCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbXDMNCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 09:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbXDMNCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 09:02:47 -0400
Received: from mail.screens.ru ([213.234.233.54]:33998 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbXDMNCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 09:02:46 -0400
Date: Fri, 13 Apr 2007 17:02:36 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] make kthread_stop() scalable
Message-ID: <20070413130236.GA173@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's a shame kthread_stop() (may take a while!) runs with a global semaphore
held. With this patch kthread() allocates all neccesary data (struct kthread)
on its own stack, globals kthread_stop_xxx are deleted.

HACKS:

	- re-use task_struct->set_child_tid to point to "struct kthread"

	- use do_exit() directly to preserve "struct kthread" on stack

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 2.6.21-rc5/kernel/kthread.c~3_STOP	2007-04-13 16:28:41.000000000 +0400
+++ 2.6.21-rc5/kernel/kthread.c	2007-04-13 16:24:37.000000000 +0400
@@ -17,7 +17,25 @@
 
 static DEFINE_SPINLOCK(kthread_create_lock);
 static LIST_HEAD(kthread_create_list);
-struct task_struct *kthreadd_task;
+struct task_struct *kthreadd_task __read_mostly;
+
+struct kthread {
+	int should_stop;
+	struct task_struct *task;
+
+	struct completion exited;
+	int err;
+};
+
+static inline struct kthread *to_kthread(struct task_struct *t)
+{
+	return (void*)t->set_child_tid;
+}
+
+static inline void set_kthread(struct kthread *self)
+{
+	current->set_child_tid = (void __user*)self;
+}
 
 struct kthread_create_info
 {
@@ -27,24 +45,12 @@ struct kthread_create_info
 	struct completion created;
 	struct completion started;
 
-	/* Result passed back to kthread_create() from kthreadd. */
-	pid_t result;
+	/* Result passed back to kthread_create() from kthread. */
+	struct kthread *result;
 
 	struct list_head list;
 };
 
-struct kthread_stop_info
-{
-	struct task_struct *k;
-	int err;
-	struct completion done;
-};
-
-/* Thread stopping is done by setthing this var: lock serializes
- * multiple kthread_stop calls. */
-static DEFINE_MUTEX(kthread_stop_lock);
-static struct kthread_stop_info kthread_stop_info;
-
 /**
  * kthread_should_stop - should this kthread return now?
  *
@@ -54,20 +60,28 @@ static struct kthread_stop_info kthread_
  */
 int kthread_should_stop(void)
 {
-	return (kthread_stop_info.k == current);
+	return to_kthread(current)->should_stop;
 }
 EXPORT_SYMBOL(kthread_should_stop);
 
 static int kthread(void *_create)
 {
-	struct kthread_create_info *create = _create;
-	int (*threadfn)(void *data);
-	void *data;
-	int ret = -EINTR;
+	struct kthread self = {
+		.task = current,
+		.err = -EINTR,
+	};
 
 	/* Copy data: it's on kthread's stack */
-	threadfn = create->threadfn;
-	data = create->data;
+	struct kthread_create_info *create = _create;
+	int (*threadfn)(void *data) = create->threadfn;
+	void *data = create->data;
+
+	/*
+	 * This should be enough to assure that self is still on
+	 * stack when we enter do_exit()
+	 */
+	set_kthread(&self);
+	create->result = &self;
 
 	/* OK, tell user we're spawned, wait for stop or wakeup */
 	__set_current_state(TASK_UNINTERRUPTIBLE);
@@ -75,13 +89,13 @@ static int kthread(void *_create)
 	schedule();
 
 	if (!kthread_should_stop())
-		ret = threadfn(data);
+		self.err = threadfn(data);
 
-	/* It might have exited on its own, w/o kthread_stop.  Check. */
-	if (kthread_should_stop()) {
-		kthread_stop_info.err = ret;
-		complete(&kthread_stop_info.done);
-	}
+	/* It might have exited on its own, w/o kthread_stop. Check. */
+	if (kthread_should_stop())
+		complete(&self.exited);
+
+	do_exit(0);
 	return 0;
 }
 
@@ -91,7 +105,7 @@ static void create_kthread(struct kthrea
 
 	/* We want our own signal handler (we take no signals by default). */
 	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
-	create->result = pid;
+	create->result = ERR_PTR(pid);
 
 	complete(&create->created);
 }
@@ -135,11 +149,11 @@ struct task_struct *kthread_create(int (
 	wake_up_process(kthreadd_task);
 
 	wait_for_completion(&create.created);
-	if (create.result < 0)
-		return ERR_PTR(create.result);
+	if (IS_ERR(create.result))
+		return (void*)create.result;
 
 	wait_for_completion(&create.started);
-	ret = find_task_by_pid(create.result);
+	ret = create.result->task;
 
 	va_start(args, namefmt);
 	vsnprintf(ret->comm, sizeof(ret->comm), namefmt, args);
@@ -183,27 +197,23 @@ EXPORT_SYMBOL(kthread_bind);
  */
 int kthread_stop(struct task_struct *k)
 {
+	struct kthread *kthread;
 	int ret;
 
-	mutex_lock(&kthread_stop_lock);
-
 	/* It could exit after stop_info.k set, but before wake_up_process. */
 	get_task_struct(k);
+	kthread = to_kthread(k);
 
-	/* Must init completion *before* thread sees kthread_stop_info.k */
-	init_completion(&kthread_stop_info.done);
+	/* Must init completion *before* thread sees ->should_stop */
+	init_completion(&kthread->exited);
 	smp_wmb();
-
-	/* Now set kthread_should_stop() to true, and wake it up. */
-	kthread_stop_info.k = k;
+	kthread->should_stop = 1;
 	wake_up_process(k);
-	put_task_struct(k);
 
 	/* Once it dies, reset stop ptr, gather result and we're done. */
-	wait_for_completion(&kthread_stop_info.done);
-	kthread_stop_info.k = NULL;
-	ret = kthread_stop_info.err;
-	mutex_unlock(&kthread_stop_lock);
+	wait_for_completion(&kthread->exited);
+	ret = kthread->err;
+	put_task_struct(k);
 
 	return ret;
 }

