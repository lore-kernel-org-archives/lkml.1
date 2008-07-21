Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbYGUQS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbYGUQS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 12:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbYGUQSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 12:18:12 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:49664 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbYGUQSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:18:10 -0400
Date: Mon, 21 Jul 2008 20:21:39 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: killable/interruptible coredumps
Message-ID: <20080721162139.GA340@tv-sign.ru>
References: <20080716135359.GA1219@tv-sign.ru> <20080720023258.26D2015421D@magilla.localdomain> <20080720122354.GD143@tv-sign.ru> <20080721000842.94DAE15421D@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721000842.94DAE15421D@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20, Roland McGrath wrote:
>
> Then have the dumping and the waiting
> for it be killable.

I think it is easy to make the coredumping killable right now,

	--- fs/exec.c~	2008-07-21 19:47:22.000000000 +0400
	+++ fs/exec.c	2008-07-21 19:56:44.000000000 +0400
	@@ -1523,6 +1523,7 @@ static inline int zap_threads(struct tas
		spin_lock_irq(&tsk->sighand->siglock);
		if (!signal_group_exit(tsk->signal)) {
			mm->core_state = core_state;
	+		clear_thread_flag(TIF_SIGPENDING);
			tsk->signal->group_exit_code = exit_code;
			nr = zap_process(tsk);
		}
	@@ -1735,12 +1736,6 @@ int do_coredump(long signr, int exit_cod
			goto fail;
	 
		/*
	-	 * Clear any false indication of pending signals that might
	-	 * be seen by the filesystem code called to write the core file.
	-	 */
	-	clear_thread_flag(TIF_SIGPENDING);
	-
	-	/*
		 * lock_kernel() because format_corename() is controlled by sysctl, which
		 * uses lock_kernel()
		 */
	--- fs/binfmt_elf.c~	2008-07-13 20:52:25.000000000 +0400
	+++ fs/binfmt_elf.c	2008-07-20 19:53:08.000000000 +0400
	@@ -1105,11 +1105,17 @@ out:
	  */
	 static int dump_write(struct file *file, const void *addr, int nr)
	 {
	+	if (fatal_signal_pending(current))
	+		return 0;
	+
		return file->f_op->write(file, addr, nr, &file->f_pos) == nr;
	 }
	 
	 static int dump_seek(struct file *file, loff_t off)
	 {
	+	if (fatal_signal_pending(current))
	+		return 0;
	+
		if (file->f_op->llseek && file->f_op->llseek != no_llseek) {
			if (file->f_op->llseek(file, off, SEEK_CUR) < 0)
				return 0;

This relies on the fact SIGKILL will find the coredumping thread
because it is not PF_EXITING, even if SIGNAL_GROUP_EXIT is set. This
is a bit racy though, SIGKILL may come after zap_process(current)
but before other threads have "died".


I wonder if it makes sense to go futher. Currently the coredumping
thread sets SIGNAL_GROUP_EXIT. We can set signal->group_exit_task
instead, this way it can be killed by any fatal signal, not only by
SIGKILL. For example the user can just use ^C (unless it is ignored/etc).

What is your opinion about the patch below? I can't decide wether
this change is good or bad. It complicates the code, but otoh it
makes things more consistent, imho. Note also we can change oom_kill
to check SIGNAL_GROUP_EXIT instead of PF_EXITING to detect the process
which should release its ->mm and probably free the memory "soon".

It is not clear what should be ->group_exit_code if ->core_dump() is
interrupted. This patch sets it = exit_code, but perhaps we should
keep the original signr in that case.

Oleg.

--- 26-rc2/fs/exec.c~1_MAKE_KILLABLE	2008-07-20 17:31:40.000000000 +0400
+++ 26-rc2/fs/exec.c	2008-07-20 19:46:21.000000000 +0400
@@ -1498,7 +1498,6 @@ static int zap_process(struct task_struc
 	struct task_struct *t;
 	int nr = 0;
 
-	start->signal->flags = SIGNAL_GROUP_EXIT;
 	start->signal->group_stop_count = 0;
 
 	t = start;
@@ -1523,7 +1522,8 @@ static inline int zap_threads(struct tas
 	spin_lock_irq(&tsk->sighand->siglock);
 	if (!signal_group_exit(tsk->signal)) {
 		mm->core_state = core_state;
-		tsk->signal->group_exit_code = exit_code;
+		clear_thread_flag(TIF_SIGPENDING);
+		tsk->signal->group_exit_task = tsk;
 		nr = zap_process(tsk);
 	}
 	spin_unlock_irq(&tsk->sighand->siglock);
@@ -1574,6 +1574,7 @@ static inline int zap_threads(struct tas
 			if (p->mm) {
 				if (unlikely(p->mm == mm)) {
 					lock_task_sighand(p, &flags);
+					p->signal->flags = SIGNAL_GROUP_EXIT;
 					nr += zap_process(p);
 					unlock_task_sighand(p, &flags);
 				}
@@ -1619,7 +1620,7 @@ fail:
 	return core_waiters;
 }
 
-static void coredump_finish(struct mm_struct *mm)
+static inline void core_state_finish(struct mm_struct *mm)
 {
 	struct core_thread *curr, *next;
 	struct task_struct *task;
@@ -1640,6 +1641,17 @@ static void coredump_finish(struct mm_st
 	mm->core_state = NULL;
 }
 
+static void coredump_finish(struct mm_struct *mm, int exit_code)
+{
+	spin_lock_irq(&current->sighand->siglock);
+	current->signal->flags = SIGNAL_GROUP_EXIT;
+	current->signal->group_exit_code = exit_code;
+	current->signal->group_exit_task = NULL;
+	spin_unlock_irq(&current->sighand->siglock);
+
+	core_state_finish(mm);
+}
+
 /*
  * set_dumpable converts traditional three-value dumpable to two flags and
  * stores them into mm->flags.  It modifies lower two bits of mm->flags, but
@@ -1735,12 +1747,6 @@ int do_coredump(long signr, int exit_cod
 		goto fail;
 
 	/*
-	 * Clear any false indication of pending signals that might
-	 * be seen by the filesystem code called to write the core file.
-	 */
-	clear_thread_flag(TIF_SIGPENDING);
-
-	/*
 	 * lock_kernel() because format_corename() is controlled by sysctl, which
 	 * uses lock_kernel()
 	 */
@@ -1814,9 +1820,8 @@ int do_coredump(long signr, int exit_cod
 		goto close_fail;
 
 	retval = binfmt->core_dump(signr, regs, file, core_limit);
-
 	if (retval)
-		current->signal->group_exit_code |= 0x80;
+		exit_code |= 0x80;
 close_fail:
 	filp_close(file, NULL);
 fail_unlock:
@@ -1824,7 +1829,7 @@ fail_unlock:
 		argv_free(helper_argv);
 
 	current->fsuid = fsuid;
-	coredump_finish(mm);
+	coredump_finish(mm, exit_code);
 fail:
 	return retval;
 }

