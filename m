Return-Path: <linux-kernel-owner+w=401wt.eu-S1755062AbZIAQ6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbZIAQ6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 12:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbZIAQ6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 12:58:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbZIAQ6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 12:58:12 -0400
Date: Tue, 1 Sep 2009 18:53:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: arjan@infradead.org, jeremy@goop.org, mschmidt@redhat.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tj@kernel.org, tglx@linutronix.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-tip-commits@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/1] kthreads: simplify !kthreadd_task logic, kill
	kthreadd_task_init_done
Message-ID: <20090901165312.GB9105@redhat.com>
References: <20090829182718.10f566b1@leela> <tip-23386d63bbb3199cf247313ec088878d72debcfd@git.kernel.org> <20090901100351.GA3361@elte.hu> <20090901113914.GA23578@elte.hu> <20090901130436.GA22514@redhat.com> <20090901131440.GA29783@elte.hu> <20090901133709.GA24041@redhat.com> <20090901135925.GA9083@elte.hu> <20090901145526.GA31317@redhat.com> <20090901165235.GA9105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901165235.GA9105@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert "[PATCH] kthreads: Fix startup synchronization boot crash", it was
the minimal fix for stable.

Then:
	- change kthread_create() to check kthreadd_task != NULL before
	  wake_up_process(kthreadd_task)

	- remove kthreadd_task initialization from rest_init()

	- change kthreadd() to initialize kthreadd_task = current

	- change the main loop in kthreadd() to take kthread_create_lock
	  before the first schedule() (just shift schedule() down)

This way, if kthreadd_task needs the wakeup, kthread_create() must see
kthreadd_task != NULL after unlock(kthread_create_lock).

If kthread_create() sees kthreadd_task == NULL we can just sleep on .done,
kthreadd() must notice the new request before it calls schedule().

IOW both checks, !kthreadd_task and list_empty(), are done after
lock+unlock of the same lock. The 2nd task which takes the lock must
see the changes which were done by the 1st task which locked this lock.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/kthread.h |    1 -
 init/main.c             |    7 +------
 kernel/kthread.c        |   35 ++++++++++++++++++-----------------
 3 files changed, 19 insertions(+), 24 deletions(-)

--- WAIT/include/linux/kthread.h~KT_KTHREADD_NULL_FIX	2009-09-01 18:25:50.000000000 +0200
+++ WAIT/include/linux/kthread.h	2009-09-01 18:31:39.000000000 +0200
@@ -33,6 +33,5 @@ int kthread_should_stop(void);
 
 int kthreadd(void *unused);
 extern struct task_struct *kthreadd_task;
-extern struct completion kthreadd_task_init_done;
 
 #endif /* _LINUX_KTHREAD_H */
--- WAIT/init/main.c~KT_KTHREADD_NULL_FIX	2009-09-01 18:25:50.000000000 +0200
+++ WAIT/init/main.c	2009-09-01 18:32:05.000000000 +0200
@@ -453,14 +453,9 @@ static void __init setup_command_line(ch
 static noinline void __init_refok rest_init(void)
 	__releases(kernel_lock)
 {
-	int pid;
-
 	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
 	numa_default_policy();
-	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
-	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
-	complete(&kthreadd_task_init_done);
-
+	kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
 	unlock_kernel();
 
 	/*
--- WAIT/kernel/kthread.c~KT_KTHREADD_NULL_FIX	2009-09-01 18:25:50.000000000 +0200
+++ WAIT/kernel/kthread.c	2009-09-01 18:32:05.000000000 +0200
@@ -20,9 +20,7 @@
 
 static DEFINE_SPINLOCK(kthread_create_lock);
 static LIST_HEAD(kthread_create_list);
-
 struct task_struct *kthreadd_task;
-DECLARE_COMPLETION(kthreadd_task_init_done);
 
 struct kthread_create_info
 {
@@ -130,11 +128,14 @@ struct task_struct *kthread_create(int (
 	spin_lock(&kthread_create_lock);
 	list_add_tail(&create.list, &kthread_create_list);
 	spin_unlock(&kthread_create_lock);
-
-	if (unlikely(!kthreadd_task))
-		wait_for_completion(&kthreadd_task_init_done);
-
-	wake_up_process(kthreadd_task);
+	/*
+	 * If kthreadd was not created yet, kthreadd() must see the result
+	 * of list_add_tail() later, it takes kthread_create_lock before the
+	 * first schedule(). If kthreadd() locked kthread_create_lock at
+	 * least once, we must see kthreadd_task != NULL.
+	 */
+	if (likely(kthreadd_task))
+		wake_up_process(kthreadd_task);
 	wait_for_completion(&create.done);
 
 	if (!IS_ERR(create.result)) {
@@ -219,23 +220,18 @@ EXPORT_SYMBOL(kthread_stop);
 
 int kthreadd(void *unused)
 {
-	struct task_struct *tsk = current;
+	kthreadd_task = current;
 
 	/* Setup a clean context for our children to inherit. */
-	set_task_comm(tsk, "kthreadd");
-	ignore_signals(tsk);
-	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
-	set_cpus_allowed_ptr(tsk, cpu_all_mask);
+	set_task_comm(kthreadd_task, "kthreadd");
+	ignore_signals(kthreadd_task);
+	set_user_nice(kthreadd_task, KTHREAD_NICE_LEVEL);
+	set_cpus_allowed_ptr(kthreadd_task, cpu_all_mask);
 	set_mems_allowed(node_possible_map);
 
 	current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
 
 	for (;;) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (list_empty(&kthread_create_list))
-			schedule();
-		__set_current_state(TASK_RUNNING);
-
 		spin_lock(&kthread_create_lock);
 		while (!list_empty(&kthread_create_list)) {
 			struct kthread_create_info *create;
@@ -250,6 +246,11 @@ int kthreadd(void *unused)
 			spin_lock(&kthread_create_lock);
 		}
 		spin_unlock(&kthread_create_lock);
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (list_empty(&kthread_create_list))
+			schedule();
+		__set_current_state(TASK_RUNNING);
 	}
 
 	return 0;

