Return-Path: <linux-kernel-owner+w=401wt.eu-S933255AbZKXUIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255AbZKXUIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933145AbZKXUH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:07:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933181AbZKXUHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:07:51 -0500
Date: Tue, 24 Nov 2009 21:02:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: [RFC,PATCH 12/14] reorder the code in kernel/ptrace.c
Message-ID: <20091124200212.GA5818@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes, preparation for the next patch.

Move the code which can be shared with ptrace-utrace up, before
__ptrace_link(). This way ptrace-utrace needs a single #ifdef in
ptrace.c.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/ptrace.c |  556 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 278 insertions(+), 278 deletions(-)

--- V1/kernel/ptrace.c~12_REORDER_PTRACE_C	2009-11-24 20:30:16.000000000 +0100
+++ V1/kernel/ptrace.c	2009-11-24 20:30:16.000000000 +0100
@@ -23,6 +23,284 @@
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
 
+int __ptrace_may_access(struct task_struct *task, unsigned int mode)
+{
+	const struct cred *cred = current_cred(), *tcred;
+
+	/* May we inspect the given task?
+	 * This check is used both for attaching with ptrace
+	 * and for allowing access to sensitive information in /proc.
+	 *
+	 * ptrace_attach denies several cases that /proc allows
+	 * because setting up the necessary parent/child relationship
+	 * or halting the specified task is impossible.
+	 */
+	int dumpable = 0;
+	/* Don't let security modules deny introspection */
+	if (task == current)
+		return 0;
+	rcu_read_lock();
+	tcred = __task_cred(task);
+	if ((cred->uid != tcred->euid ||
+	     cred->uid != tcred->suid ||
+	     cred->uid != tcred->uid  ||
+	     cred->gid != tcred->egid ||
+	     cred->gid != tcred->sgid ||
+	     cred->gid != tcred->gid) &&
+	    !capable(CAP_SYS_PTRACE)) {
+		rcu_read_unlock();
+		return -EPERM;
+	}
+	rcu_read_unlock();
+	smp_rmb();
+	if (task->mm)
+		dumpable = get_dumpable(task->mm);
+	if (!dumpable && !capable(CAP_SYS_PTRACE))
+		return -EPERM;
+
+	return security_ptrace_access_check(task, mode);
+}
+
+bool ptrace_may_access(struct task_struct *task, unsigned int mode)
+{
+	int err;
+	task_lock(task);
+	err = __ptrace_may_access(task, mode);
+	task_unlock(task);
+	return !err;
+}
+
+/*
+ * Called with irqs disabled, returns true if childs should reap themselves.
+ */
+static int ignoring_children(struct sighand_struct *sigh)
+{
+	int ret;
+	spin_lock(&sigh->siglock);
+	ret = (sigh->action[SIGCHLD-1].sa.sa_handler == SIG_IGN) ||
+	      (sigh->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT);
+	spin_unlock(&sigh->siglock);
+	return ret;
+}
+
+/*
+ * Called with tasklist_lock held for writing.
+ * Unlink a traced task, and clean it up if it was a traced zombie.
+ * Return true if it needs to be reaped with release_task().
+ * (We can't call release_task() here because we already hold tasklist_lock.)
+ *
+ * If it's a zombie, our attachedness prevented normal parent notification
+ * or self-reaping.  Do notification now if it would have happened earlier.
+ * If it should reap itself, return true.
+ *
+ * If it's our own child, there is no notification to do. But if our normal
+ * children self-reap, then this child was prevented by ptrace and we must
+ * reap it now, in that case we must also wake up sub-threads sleeping in
+ * do_wait().
+ */
+bool __ptrace_detach(struct task_struct *tracer, struct task_struct *p)
+{
+	__ptrace_unlink(p);
+
+	if (p->exit_state == EXIT_ZOMBIE) {
+		if (!task_detached(p) && thread_group_empty(p)) {
+			if (!same_thread_group(p->real_parent, tracer))
+				do_notify_parent(p, p->exit_signal);
+			else if (ignoring_children(tracer->sighand)) {
+				__wake_up_parent(p, tracer);
+				p->exit_signal = -1;
+			}
+		}
+		if (task_detached(p)) {
+			/* Mark it as in the process of being reaped. */
+			p->exit_state = EXIT_DEAD;
+			return true;
+		}
+	}
+
+	return false;
+}
+
+int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len)
+{
+	int copied = 0;
+
+	while (len > 0) {
+		char buf[128];
+		int this_len, retval;
+
+		this_len = (len > sizeof(buf)) ? sizeof(buf) : len;
+		retval = access_process_vm(tsk, src, buf, this_len, 0);
+		if (!retval) {
+			if (copied)
+				break;
+			return -EIO;
+		}
+		if (copy_to_user(dst, buf, retval))
+			return -EFAULT;
+		copied += retval;
+		src += retval;
+		dst += retval;
+		len -= retval;
+	}
+	return copied;
+}
+
+int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long dst, int len)
+{
+	int copied = 0;
+
+	while (len > 0) {
+		char buf[128];
+		int this_len, retval;
+
+		this_len = (len > sizeof(buf)) ? sizeof(buf) : len;
+		if (copy_from_user(buf, src, this_len))
+			return -EFAULT;
+		retval = access_process_vm(tsk, dst, buf, this_len, 1);
+		if (!retval) {
+			if (copied)
+				break;
+			return -EIO;
+		}
+		copied += retval;
+		src += retval;
+		dst += retval;
+		len -= retval;
+	}
+	return copied;
+}
+
+static struct task_struct *ptrace_get_task_struct(pid_t pid)
+{
+	struct task_struct *child;
+
+	rcu_read_lock();
+	child = find_task_by_vpid(pid);
+	if (child)
+		get_task_struct(child);
+	rcu_read_unlock();
+
+	if (!child)
+		return ERR_PTR(-ESRCH);
+	return child;
+}
+
+#ifndef arch_ptrace_attach
+#define arch_ptrace_attach(child)	do { } while (0)
+#endif
+
+SYSCALL_DEFINE4(ptrace, long, request, long, pid, long, addr, long, data)
+{
+	struct task_struct *child;
+	long ret;
+
+	/*
+	 * This lock_kernel fixes a subtle race with suid exec
+	 */
+	lock_kernel();
+	if (request == PTRACE_TRACEME) {
+		ret = ptrace_traceme();
+		if (!ret)
+			arch_ptrace_attach(current);
+		goto out;
+	}
+
+	child = ptrace_get_task_struct(pid);
+	if (IS_ERR(child)) {
+		ret = PTR_ERR(child);
+		goto out;
+	}
+
+	if (request == PTRACE_ATTACH) {
+		ret = ptrace_attach(child);
+		/*
+		 * Some architectures need to do book-keeping after
+		 * a ptrace attach.
+		 */
+		if (!ret)
+			arch_ptrace_attach(child);
+		goto out_put_task_struct;
+	}
+
+	ret = ptrace_check_attach(child, request == PTRACE_KILL);
+	if (ret < 0)
+		goto out_put_task_struct;
+
+	ret = arch_ptrace(child, request, addr, data);
+
+ out_put_task_struct:
+	put_task_struct(child);
+ out:
+	unlock_kernel();
+	return ret;
+}
+
+int generic_ptrace_peekdata(struct task_struct *tsk, long addr, long data)
+{
+	unsigned long tmp;
+	int copied;
+
+	copied = access_process_vm(tsk, addr, &tmp, sizeof(tmp), 0);
+	if (copied != sizeof(tmp))
+		return -EIO;
+	return put_user(tmp, (unsigned long __user *)data);
+}
+
+int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data)
+{
+	int copied;
+
+	copied = access_process_vm(tsk, addr, &data, sizeof(data), 1);
+	return (copied == sizeof(data)) ? 0 : -EIO;
+}
+
+#if defined CONFIG_COMPAT
+#include <linux/compat.h>
+
+asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
+				  compat_long_t addr, compat_long_t data)
+{
+	struct task_struct *child;
+	long ret;
+
+	/*
+	 * This lock_kernel fixes a subtle race with suid exec
+	 */
+	lock_kernel();
+	if (request == PTRACE_TRACEME) {
+		ret = ptrace_traceme();
+		goto out;
+	}
+
+	child = ptrace_get_task_struct(pid);
+	if (IS_ERR(child)) {
+		ret = PTR_ERR(child);
+		goto out;
+	}
+
+	if (request == PTRACE_ATTACH) {
+		ret = ptrace_attach(child);
+		/*
+		 * Some architectures need to do book-keeping after
+		 * a ptrace attach.
+		 */
+		if (!ret)
+			arch_ptrace_attach(child);
+		goto out_put_task_struct;
+	}
+
+	ret = ptrace_check_attach(child, request == PTRACE_KILL);
+	if (!ret)
+		ret = compat_arch_ptrace(child, request, addr, data);
+
+ out_put_task_struct:
+	put_task_struct(child);
+ out:
+	unlock_kernel();
+	return ret;
+}
+#endif	/* CONFIG_COMPAT */
 
 /*
  * ptrace a task: make the debugger its new parent and
@@ -117,53 +395,6 @@ int ptrace_check_attach(struct task_stru
 	return ret;
 }
 
-int __ptrace_may_access(struct task_struct *task, unsigned int mode)
-{
-	const struct cred *cred = current_cred(), *tcred;
-
-	/* May we inspect the given task?
-	 * This check is used both for attaching with ptrace
-	 * and for allowing access to sensitive information in /proc.
-	 *
-	 * ptrace_attach denies several cases that /proc allows
-	 * because setting up the necessary parent/child relationship
-	 * or halting the specified task is impossible.
-	 */
-	int dumpable = 0;
-	/* Don't let security modules deny introspection */
-	if (task == current)
-		return 0;
-	rcu_read_lock();
-	tcred = __task_cred(task);
-	if ((cred->uid != tcred->euid ||
-	     cred->uid != tcred->suid ||
-	     cred->uid != tcred->uid  ||
-	     cred->gid != tcred->egid ||
-	     cred->gid != tcred->sgid ||
-	     cred->gid != tcred->gid) &&
-	    !capable(CAP_SYS_PTRACE)) {
-		rcu_read_unlock();
-		return -EPERM;
-	}
-	rcu_read_unlock();
-	smp_rmb();
-	if (task->mm)
-		dumpable = get_dumpable(task->mm);
-	if (!dumpable && !capable(CAP_SYS_PTRACE))
-		return -EPERM;
-
-	return security_ptrace_access_check(task, mode);
-}
-
-bool ptrace_may_access(struct task_struct *task, unsigned int mode)
-{
-	int err;
-	task_lock(task);
-	err = __ptrace_may_access(task, mode);
-	task_unlock(task);
-	return !err;
-}
-
 int ptrace_attach(struct task_struct *task)
 {
 	int retval;
@@ -243,57 +474,6 @@ int ptrace_traceme(void)
 	return ret;
 }
 
-/*
- * Called with irqs disabled, returns true if childs should reap themselves.
- */
-static int ignoring_children(struct sighand_struct *sigh)
-{
-	int ret;
-	spin_lock(&sigh->siglock);
-	ret = (sigh->action[SIGCHLD-1].sa.sa_handler == SIG_IGN) ||
-	      (sigh->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT);
-	spin_unlock(&sigh->siglock);
-	return ret;
-}
-
-/*
- * Called with tasklist_lock held for writing.
- * Unlink a traced task, and clean it up if it was a traced zombie.
- * Return true if it needs to be reaped with release_task().
- * (We can't call release_task() here because we already hold tasklist_lock.)
- *
- * If it's a zombie, our attachedness prevented normal parent notification
- * or self-reaping.  Do notification now if it would have happened earlier.
- * If it should reap itself, return true.
- *
- * If it's our own child, there is no notification to do. But if our normal
- * children self-reap, then this child was prevented by ptrace and we must
- * reap it now, in that case we must also wake up sub-threads sleeping in
- * do_wait().
- */
-bool __ptrace_detach(struct task_struct *tracer, struct task_struct *p)
-{
-	__ptrace_unlink(p);
-
-	if (p->exit_state == EXIT_ZOMBIE) {
-		if (!task_detached(p) && thread_group_empty(p)) {
-			if (!same_thread_group(p->real_parent, tracer))
-				do_notify_parent(p, p->exit_signal);
-			else if (ignoring_children(tracer->sighand)) {
-				__wake_up_parent(p, tracer);
-				p->exit_signal = -1;
-			}
-		}
-		if (task_detached(p)) {
-			/* Mark it as in the process of being reaped. */
-			p->exit_state = EXIT_DEAD;
-			return true;
-		}
-	}
-
-	return false;
-}
-
 int ptrace_detach(struct task_struct *child, unsigned int data)
 {
 	bool dead = false;
@@ -347,56 +527,6 @@ void exit_ptrace(struct task_struct *tra
 	}
 }
 
-int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len)
-{
-	int copied = 0;
-
-	while (len > 0) {
-		char buf[128];
-		int this_len, retval;
-
-		this_len = (len > sizeof(buf)) ? sizeof(buf) : len;
-		retval = access_process_vm(tsk, src, buf, this_len, 0);
-		if (!retval) {
-			if (copied)
-				break;
-			return -EIO;
-		}
-		if (copy_to_user(dst, buf, retval))
-			return -EFAULT;
-		copied += retval;
-		src += retval;
-		dst += retval;
-		len -= retval;
-	}
-	return copied;
-}
-
-int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long dst, int len)
-{
-	int copied = 0;
-
-	while (len > 0) {
-		char buf[128];
-		int this_len, retval;
-
-		this_len = (len > sizeof(buf)) ? sizeof(buf) : len;
-		if (copy_from_user(buf, src, this_len))
-			return -EFAULT;
-		retval = access_process_vm(tsk, dst, buf, this_len, 1);
-		if (!retval) {
-			if (copied)
-				break;
-			return -EIO;
-		}
-		copied += retval;
-		src += retval;
-		dst += retval;
-		len -= retval;
-	}
-	return copied;
-}
-
 static int ptrace_setoptions(struct task_struct *child, long data)
 {
 	child->ptrace &= ~PT_TRACE_MASK;
@@ -457,7 +587,6 @@ static int ptrace_setsiginfo(struct task
 	return error;
 }
 
-
 #ifdef PTRACE_SINGLESTEP
 #define is_singlestep(request)		((request) == PTRACE_SINGLESTEP)
 #else
@@ -580,93 +709,7 @@ int ptrace_request(struct task_struct *c
 	return ret;
 }
 
-static struct task_struct *ptrace_get_task_struct(pid_t pid)
-{
-	struct task_struct *child;
-
-	rcu_read_lock();
-	child = find_task_by_vpid(pid);
-	if (child)
-		get_task_struct(child);
-	rcu_read_unlock();
-
-	if (!child)
-		return ERR_PTR(-ESRCH);
-	return child;
-}
-
-#ifndef arch_ptrace_attach
-#define arch_ptrace_attach(child)	do { } while (0)
-#endif
-
-SYSCALL_DEFINE4(ptrace, long, request, long, pid, long, addr, long, data)
-{
-	struct task_struct *child;
-	long ret;
-
-	/*
-	 * This lock_kernel fixes a subtle race with suid exec
-	 */
-	lock_kernel();
-	if (request == PTRACE_TRACEME) {
-		ret = ptrace_traceme();
-		if (!ret)
-			arch_ptrace_attach(current);
-		goto out;
-	}
-
-	child = ptrace_get_task_struct(pid);
-	if (IS_ERR(child)) {
-		ret = PTR_ERR(child);
-		goto out;
-	}
-
-	if (request == PTRACE_ATTACH) {
-		ret = ptrace_attach(child);
-		/*
-		 * Some architectures need to do book-keeping after
-		 * a ptrace attach.
-		 */
-		if (!ret)
-			arch_ptrace_attach(child);
-		goto out_put_task_struct;
-	}
-
-	ret = ptrace_check_attach(child, request == PTRACE_KILL);
-	if (ret < 0)
-		goto out_put_task_struct;
-
-	ret = arch_ptrace(child, request, addr, data);
-
- out_put_task_struct:
-	put_task_struct(child);
- out:
-	unlock_kernel();
-	return ret;
-}
-
-int generic_ptrace_peekdata(struct task_struct *tsk, long addr, long data)
-{
-	unsigned long tmp;
-	int copied;
-
-	copied = access_process_vm(tsk, addr, &tmp, sizeof(tmp), 0);
-	if (copied != sizeof(tmp))
-		return -EIO;
-	return put_user(tmp, (unsigned long __user *)data);
-}
-
-int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data)
-{
-	int copied;
-
-	copied = access_process_vm(tsk, addr, &data, sizeof(data), 1);
-	return (copied == sizeof(data)) ? 0 : -EIO;
-}
-
 #if defined CONFIG_COMPAT
-#include <linux/compat.h>
-
 int compat_ptrace_request(struct task_struct *child, compat_long_t request,
 			  compat_ulong_t addr, compat_ulong_t data)
 {
@@ -718,47 +761,4 @@ int compat_ptrace_request(struct task_st
 
 	return ret;
 }
-
-asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
-				  compat_long_t addr, compat_long_t data)
-{
-	struct task_struct *child;
-	long ret;
-
-	/*
-	 * This lock_kernel fixes a subtle race with suid exec
-	 */
-	lock_kernel();
-	if (request == PTRACE_TRACEME) {
-		ret = ptrace_traceme();
-		goto out;
-	}
-
-	child = ptrace_get_task_struct(pid);
-	if (IS_ERR(child)) {
-		ret = PTR_ERR(child);
-		goto out;
-	}
-
-	if (request == PTRACE_ATTACH) {
-		ret = ptrace_attach(child);
-		/*
-		 * Some architectures need to do book-keeping after
-		 * a ptrace attach.
-		 */
-		if (!ret)
-			arch_ptrace_attach(child);
-		goto out_put_task_struct;
-	}
-
-	ret = ptrace_check_attach(child, request == PTRACE_KILL);
-	if (!ret)
-		ret = compat_arch_ptrace(child, request, addr, data);
-
- out_put_task_struct:
-	put_task_struct(child);
- out:
-	unlock_kernel();
-	return ret;
-}
 #endif	/* CONFIG_COMPAT */

