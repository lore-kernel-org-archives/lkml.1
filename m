Return-Path: <linux-kernel-owner+w=401wt.eu-S1758365AbZDIAxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365AbZDIAxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 20:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756883AbZDIAxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 20:53:02 -0400
Received: from ozlabs.org ([203.10.76.45]:37852 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829AbZDIAxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 20:53:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] kthread changes
Date: Thu, 9 Apr 2009 10:22:56 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.27-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Vitaliy Gusev <vgusev@openvz.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904091022.56550.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7b85a88ca7760d6d5f34bdaa793c71d921a3e853:
  Linus Torvalds (1):
        Merge branch 'release' of git://git.kernel.org/.../lenb/linux-acpi-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Andrew Morton (1):
      work_on_cpu(): rewrite it to create a kernel thread on demand

Oleg Nesterov (1):
      kthread: move sched-realeted initialization from kthreadd context

Vitaliy Gusev (1):
      kthread: Don't looking for a task in create_kthread() #2

 kernel/kthread.c   |   26 ++++++++++++--------------
 kernel/workqueue.c |   36 +++++++++++++++++++-----------------
 2 files changed, 31 insertions(+), 31 deletions(-)

commit 3217ab97f14c5c8f9f975ed8c40c351164b0b10e
Author: Vitaliy Gusev <vgusev@openvz.org>
Date:   Thu Apr 9 09:50:35 2009 -0600

    kthread: Don't looking for a task in create_kthread() #2
    
    Remove the unnecessary find_task_by_pid_ns(). kthread() can just
    use "current" to get the same result.
    
    Signed-off-by: Vitaliy Gusev <vgusev@openvz.org>
    Acked-by: Oleg Nesterov <oleg@redhat.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 kernel/kthread.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

commit 1c99315bb36b5d776210546d438ca928dc9b1f22
Author: Oleg Nesterov <oleg@redhat.com>
Date:   Thu Apr 9 09:50:36 2009 -0600

    kthread: move sched-realeted initialization from kthreadd context
    
    kthreadd is the single thread which implements ths "create" request, move
    sched_setscheduler/etc from create_kthread() to kthread_create() to
    improve the scalability.
    
    We should be careful with sched_setscheduler(), use _nochek helper.
    
    Signed-off-by: Oleg Nesterov <oleg@redhat.com>
    Cc: Christoph Hellwig <hch@lst.de>
    Cc: "Eric W. Biederman" <ebiederm@xmission.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Pavel Emelyanov <xemul@openvz.org>
    Cc: Vitaliy Gusev <vgusev@openvz.org
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 kernel/kthread.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

commit 6b44003e5ca66a3fffeb5bc90f40ada2c4340896
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Thu Apr 9 09:50:37 2009 -0600

    work_on_cpu(): rewrite it to create a kernel thread on demand
    
    Impact: circular locking bugfix
    
    The various implemetnations and proposed implemetnations of work_on_cpu()
    are vulnerable to various deadlocks because they all used queues of some
    form.
    
    Unrelated pieces of kernel code thus gained dependencies wherein if one
    work_on_cpu() caller holds a lock which some other work_on_cpu() callback
    also takes, the kernel could rarely deadlock.
    
    Fix this by creating a short-lived kernel thread for each work_on_cpu()
    invokation.
    
    This is not terribly fast, but the only current caller of work_on_cpu() is
    pci_call_probe().
    
    It would be nice to find some other way of doing the node-local
    allocations in the PCI probe code so that we can zap work_on_cpu()
    altogether.  The code there is rather nasty.  I can't think of anything
    simple at this time...
    
    Cc: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 kernel/workqueue.c |   36 +++++++++++++++++++-----------------
 1 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 84bbadd..4ebaf85 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -76,6 +76,7 @@ static int kthread(void *_create)
 
 	/* OK, tell user we're spawned, wait for stop or wakeup */
 	__set_current_state(TASK_UNINTERRUPTIBLE);
+	create->result = current;
 	complete(&create->started);
 	schedule();
 
@@ -96,22 +97,10 @@ static void create_kthread(struct kthread_create_info *create)
 
 	/* We want our own signal handler (we take no signals by default). */
 	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
-	if (pid < 0) {
+	if (pid < 0)
 		create->result = ERR_PTR(pid);
-	} else {
-		struct sched_param param = { .sched_priority = 0 };
+	else
 		wait_for_completion(&create->started);
-		read_lock(&tasklist_lock);
-		create->result = find_task_by_pid_ns(pid, &init_pid_ns);
-		read_unlock(&tasklist_lock);
-		/*
-		 * root may have changed our (kthreadd's) priority or CPU mask.
-		 * The kernel thread should not inherit these properties.
-		 */
-		sched_setscheduler(create->result, SCHED_NORMAL, &param);
-		set_user_nice(create->result, KTHREAD_NICE_LEVEL);
-		set_cpus_allowed_ptr(create->result, cpu_all_mask);
-	}
 	complete(&create->done);
 }
 
@@ -154,11 +143,20 @@ struct task_struct *kthread_create(int (*threadfn)(void *data),
 	wait_for_completion(&create.done);
 
 	if (!IS_ERR(create.result)) {
+		struct sched_param param = { .sched_priority = 0 };
 		va_list args;
+
 		va_start(args, namefmt);
 		vsnprintf(create.result->comm, sizeof(create.result->comm),
 			  namefmt, args);
 		va_end(args);
+		/*
+		 * root may have changed our (kthreadd's) priority or CPU mask.
+		 * The kernel thread should not inherit these properties.
+		 */
+		sched_setscheduler_nocheck(create.result, SCHED_NORMAL, &param);
+		set_user_nice(create.result, KTHREAD_NICE_LEVEL);
+		set_cpus_allowed_ptr(create.result, cpu_all_mask);
 	}
 	return create.result;
 }
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index b6b966c..f71fb2a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -966,20 +966,20 @@ undo:
 }
 
 #ifdef CONFIG_SMP
-static struct workqueue_struct *work_on_cpu_wq __read_mostly;
 
 struct work_for_cpu {
-	struct work_struct work;
+	struct completion completion;
 	long (*fn)(void *);
 	void *arg;
 	long ret;
 };
 
-static void do_work_for_cpu(struct work_struct *w)
+static int do_work_for_cpu(void *_wfc)
 {
-	struct work_for_cpu *wfc = container_of(w, struct work_for_cpu, work);
-
+	struct work_for_cpu *wfc = _wfc;
 	wfc->ret = wfc->fn(wfc->arg);
+	complete(&wfc->completion);
+	return 0;
 }
 
 /**
@@ -990,17 +990,23 @@ static void do_work_for_cpu(struct work_struct *w)
  *
  * This will return the value @fn returns.
  * It is up to the caller to ensure that the cpu doesn't go offline.
+ * The caller must not hold any locks which would prevent @fn from completing.
  */
 long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 {
-	struct work_for_cpu wfc;
-
-	INIT_WORK(&wfc.work, do_work_for_cpu);
-	wfc.fn = fn;
-	wfc.arg = arg;
-	queue_work_on(cpu, work_on_cpu_wq, &wfc.work);
-	flush_work(&wfc.work);
-
+	struct task_struct *sub_thread;
+	struct work_for_cpu wfc = {
+		.completion = COMPLETION_INITIALIZER_ONSTACK(wfc.completion),
+		.fn = fn,
+		.arg = arg,
+	};
+
+	sub_thread = kthread_create(do_work_for_cpu, &wfc, "work_for_cpu");
+	if (IS_ERR(sub_thread))
+		return PTR_ERR(sub_thread);
+	kthread_bind(sub_thread, cpu);
+	wake_up_process(sub_thread);
+	wait_for_completion(&wfc.completion);
 	return wfc.ret;
 }
 EXPORT_SYMBOL_GPL(work_on_cpu);
@@ -1016,8 +1022,4 @@ void __init init_workqueues(void)
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
-#ifdef CONFIG_SMP
-	work_on_cpu_wq = create_workqueue("work_on_cpu");
-	BUG_ON(!work_on_cpu_wq);
-#endif
 }
