Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbZIANmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbZIANmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 09:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbZIANmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 09:42:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746AbZIANmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 09:42:13 -0400
Date: Tue, 1 Sep 2009 15:37:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: arjan@infradead.org, jeremy@goop.org, mschmidt@redhat.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tj@kernel.org, tglx@linutronix.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] kthreads: Fix startup synchronization boot crash
Message-ID: <20090901133709.GA24041@redhat.com>
References: <20090829182718.10f566b1@leela> <tip-23386d63bbb3199cf247313ec088878d72debcfd@git.kernel.org> <20090901100351.GA3361@elte.hu> <20090901113914.GA23578@elte.hu> <20090901130436.GA22514@redhat.com> <20090901131440.GA29783@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901131440.GA29783@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Yes, this should work. But I _think_ we can make the better fix...
> >
> > I'll try to make the patch soon. Afaics we don't need
> > kthreadd_task_init_done.
>
> ok.

Just in case, the patch is ready. I need to re-check my thinking
and test it somehow...

- remove kthreadd_task initialization from rest_init()

- change kthreadd() to initialize kthreadd_task = current

- change the main loop in kthreadd() to take kthread_create_lock
  before the first schedule() (just shift schedule() down)

This way, if kthreadd_task needs the wakeup, kthread_create()
must see kthreadd_task != NULL after unlock(kthread_create_lock).

If kthread_create() sees kthreadd_task == NULL we can just sleep
on create.done, kthreadd() must notice the new request before
it calls schedule().

Note that with this change it is possible to use kthread_create()
at any time, but the caller will sleep until rest_init() creates
kthreadd.

Oleg.

 init/main.c      |    5 +----
 kernel/kthread.c |   30 ++++++++++++++++++------------
 2 files changed, 19 insertions(+), 16 deletions(-)


--- a/init/main.c
+++ b/init/main.c
@@ -449,12 +449,9 @@ static void __init setup_command_line(ch
 static noinline void __init_refok rest_init(void)
 	__releases(kernel_lock)
 {
-	int pid;
-
 	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
 	numa_default_policy();
-	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
-	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
+	kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
 	unlock_kernel();
 
 	/*
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -128,8 +128,14 @@ struct task_struct *kthread_create(int (
 	spin_lock(&kthread_create_lock);
 	list_add_tail(&create.list, &kthread_create_list);
 	spin_unlock(&kthread_create_lock);
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
@@ -216,23 +222,18 @@ EXPORT_SYMBOL(kthread_stop);
 
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
@@ -247,6 +248,11 @@ int kthreadd(void *unused)
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

