Return-Path: <linux-kernel-owner+w=401wt.eu-S1031443AbXDJSwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031443AbXDJSwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 14:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031451AbXDJSwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 14:52:11 -0400
Received: from mail.screens.ru ([213.234.233.54]:46386 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031443AbXDJSwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 14:52:10 -0400
Date: Tue, 10 Apr 2007 22:51:33 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] make kernel threads invisible to /sbin/init
Message-ID: <20070410185133.GA104@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1. rename reparent_to_init() to reparent_kthread() and export it

2. use init_pid_ns.child_reaper instead of child_reaper(current)

3. set ->exit_signal = -1, so init can't see us and we don't use
   it to reap the task.

4. add reparent_kthread() to kthread() and stopmachine()

See also

	http://marc.info/?t=117580282200003&r=1
	http://marc.info/?t=95299284800003&r=1

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 include/linux/sched.h |    1 +
 kernel/exit.c         |   16 ++++++++--------
 kernel/kthread.c      |    1 +
 kernel/stop_machine.c |    1 +
 4 files changed, 11 insertions(+), 8 deletions(-)

--- 2.6.21-rc5/include/linux/sched.h~2_DETACH	2007-04-05 12:18:28.000000000 +0400
+++ 2.6.21-rc5/include/linux/sched.h	2007-04-10 21:52:27.000000000 +0400
@@ -1401,6 +1401,7 @@ extern void exit_itimers(struct signal_s
 
 extern NORET_TYPE void do_group_exit(int);
 
+extern void reparent_kthread(void);
 extern void daemonize(const char *, ...);
 extern int allow_signal(int);
 extern int disallow_signal(int);
--- 2.6.21-rc5/kernel/exit.c~2_DETACH	2007-04-10 21:32:44.000000000 +0400
+++ 2.6.21-rc5/kernel/exit.c	2007-04-10 21:59:41.000000000 +0400
@@ -255,7 +255,7 @@ static int has_stopped_jobs(struct pid *
 }
 
 /**
- * reparent_to_init - Reparent the calling kernel thread to the init task of the pid space that the thread belongs to.
+ * reparent_kthread - Reparent the calling kernel thread to the init task of the pid space that the thread belongs to.
  *
  * If a kernel thread is launched as a result of a system call, or if
  * it ever exits, it should generally reparent itself to init so that
@@ -264,20 +264,20 @@ static int has_stopped_jobs(struct pid *
  * The various task state such as scheduling policy and priority may have
  * been inherited from a user process, so we reset them to sane values here.
  *
- * NOTE that reparent_to_init() gives the caller full capabilities.
+ * NOTE that reparent_kthread() gives the caller full capabilities.
  */
-static void reparent_to_init(void)
+void reparent_kthread(void)
 {
 	write_lock_irq(&tasklist_lock);
 
 	ptrace_unlink(current);
 	remove_parent(current);
-	current->parent = child_reaper(current);
-	current->real_parent = child_reaper(current);
+	current->parent = init_pid_ns.child_reaper;
+	current->real_parent = current->parent;
 	add_parent(current);
 
-	/* Set the exit signal to SIGCHLD so we signal init on exit */
-	current->exit_signal = SIGCHLD;
+	/* make the task auto-reap */
+	current->exit_signal = -1;
 
 	security_task_reparent_to_init(current);
 	write_unlock_irq(&tasklist_lock);
@@ -391,7 +391,7 @@ void daemonize(const char *name, ...)
 	current->files = init_task.files;
 	atomic_inc(&current->files->count);
 
-	reparent_to_init();
+	reparent_kthread();
 
 	if (!has_rt_policy(current) && (task_nice(current) < 0))
 		set_user_nice(current, 0);
--- 2.6.21-rc5/kernel/kthread.c~2_DETACH	2007-04-05 12:18:28.000000000 +0400
+++ 2.6.21-rc5/kernel/kthread.c	2007-04-10 22:02:31.000000000 +0400
@@ -82,6 +82,7 @@ static int kthread(void *_create)
 	sigset_t blocked;
 	int ret = -EINTR;
 
+	reparent_kthread();
 	kthread_exit_files();
 
 	/* Copy data: it's on keventd's stack */
--- 2.6.21-rc5/kernel/stop_machine.c~2_DETACH	2006-10-22 18:24:03.000000000 +0400
+++ 2.6.21-rc5/kernel/stop_machine.c	2007-04-10 22:04:23.000000000 +0400
@@ -33,6 +33,7 @@ static int stopmachine(void *cpu)
 	int irqs_disabled = 0;
 	int prepared = 0;
 
+	reparent_kthread();
 	set_cpus_allowed(current, cpumask_of_cpu((int)(long)cpu));
 
 	/* Ack: we are alive */

