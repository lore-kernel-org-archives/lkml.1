Return-Path: <linux-kernel-owner+w=401wt.eu-S1751448AbXDHPzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbXDHPzq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 11:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbXDHPzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 11:55:46 -0400
Received: from mail.screens.ru ([213.234.233.54]:37444 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbXDHPzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 11:55:45 -0400
Date: Sun, 8 Apr 2007 19:55:34 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [RFC, PATCH 3/3] use CLONE_KERNEL_THREAD
Message-ID: <20070408155534.GA132@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For review only.

Add CLONE_KERNEL_THREAD to kthread_create() and change reparent_to_init()
to match CLONE_KERNEL_THREAD.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 kthread.c |    2 +-
 exit.c    |   20 +++++++++-----------
 2 files changed, 10 insertions(+), 12 deletions(-)

--- 2.6.21-rc5-mm4/kernel/kthread.c~3_USE	2007-04-05 12:18:28.000000000 +0400
+++ 2.6.21-rc5-mm4/kernel/kthread.c	2007-04-08 19:18:59.000000000 +0400
@@ -120,7 +120,7 @@ static void keventd_create_kthread(struc
 	int pid;
 
 	/* We want our own signal handler (we take no signals by default). */
-	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
+	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | CLONE_KERNEL_THREAD);
 	if (pid < 0) {
 		create->result = ERR_PTR(pid);
 	} else {
--- 2.6.21-rc5-mm4/kernel/exit.c~3_USE	2007-04-08 19:06:27.000000000 +0400
+++ 2.6.21-rc5-mm4/kernel/exit.c	2007-04-08 19:23:18.000000000 +0400
@@ -279,28 +279,26 @@ static int has_stopped_jobs(struct pid *
 }
 
 /**
- * reparent_to_init - Reparent the calling kernel thread to the init task of the pid space that the thread belongs to.
+ * reparent_kthread - Reparent the calling kernel thread to swapper.
  *
  * If a kernel thread is launched as a result of a system call, or if
- * it ever exits, it should generally reparent itself to init so that
- * it is correctly cleaned up on exit.
+ * it ever exits, it should generally reparent itself so that it is
+ * correctly cleaned up on exit.
  *
  * The various task state such as scheduling policy and priority may have
  * been inherited from a user process, so we reset them to sane values here.
  *
- * NOTE that reparent_to_init() gives the caller full capabilities.
+ * NOTE that reparent_kthread() gives the caller full capabilities.
  */
-static void reparent_to_init(void)
+static void reparent_kthread(void)
 {
 	write_lock_irq(&tasklist_lock);
 
-	/* Reparent to init */
 	remove_parent(current);
-	current->parent = child_reaper(current);
-	add_parent(current);
 
-	/* Set the exit signal to SIGCHLD so we signal init on exit */
-	current->exit_signal = SIGCHLD;
+	current->parent = &init_task;
+	add_parent(current);
+	current->exit_signal = -1;
 
 	if (!has_rt_policy(current) && (task_nice(current) < 0))
 		set_user_nice(current, 0);
@@ -423,7 +421,7 @@ void daemonize(const char *name, ...)
 	current->files = init_task.files;
 	atomic_inc(&current->files->count);
 
-	reparent_to_init();
+	reparent_kthread();
 }
 
 EXPORT_SYMBOL(daemonize);

