Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbXFOOjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbXFOOjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 10:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbXFOOjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 10:39:36 -0400
Received: from mail.ccur.com ([66.10.65.12]:38169 "EHLO mail.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbXFOOjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 10:39:35 -0400
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jun 2007 10:39:34 EDT
Message-ID: <4672A2ED.6030401@ccur.com>
Date: Fri, 15 Jun 2007 10:32:13 -0400
From: John Blackwood <john.blackwood@ccur.com>
Reply-To: john.blackwood@ccur.com
Organization: Concurrent Computer Corporation
User-Agent: Thunderbird 1.5.0.9 (X11/20061215)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Roland McGrath <roland@redhat.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>, bugsy@ccur.com
Subject: [RFC] [PATCH] selective signal ptracing
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jun 2007 14:32:13.0722 (UTC) FILETIME=[F72CFFA0:01C7AF59]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Selective Ptraced Signal Support - A proposed enhancement

This is a proposal for a ptrace enhancement that adds two new ptrace(2)
commands that let a debugger view and modify the set of signals that
are being ptraced.

By default all signals are ptraced as before. However, a debugger
may now modify the set of per-task ptraced signals, where only the
signals in this ptrace signal mask will be ptraced.

Signals that are not being ptraced will be handled normally by the ptraced
process, and no notification will be passed on to the debugger process.
Only ptraced signals that are received by the ptraced task will cause
that task to stop and notify the debugger.

This new ptrace selective signal support provides a method for improving
debug session performance and for reducing the amount of ptrace-related
interference of a ptraced process, particularly when an an application
is making use of one or more signals that are not currently of interest
to the debug session, but are occuring frequently.

The command interfaces are:

   long int ptrace(enum __ptrace_request request,
                            pid_t target_pid, void *addr, void *data)

   request:
	When PTRACE_SETSIGTRACE is specified, then the set of signals
	in the sigset_t structure (pointed to by the data
	parameter) will become the set of signals that are ptraced for
	the target process.

	When PTRACE_GETSIGTRACE is specified, then the current set
	of ptraced signals will be returned at the sigset_t structure
	location (pointed to by the data parameter).

   pid:	pid of the target/ptraced task

   addr:	not used

   data:	pointer to a sigset_t structure


Tasks that have the PTRACE_O_TRACEFORK, PTRACE_O_TRACECLONE
or PTRACE_O_TRACECLONE option set at the time of a fork, vfork or clone
call that are currently being ptraced will yield child tasks
that inherited their parent task's ptrace signal mask.

When single-stepping and a user's signal handler is executed, the ptraced
task only single-steps/stops in the signal handler if that signal is in
the ptraced signal mask.  Otherwise, the ptraced task will execute the
entire signal handler and then stop at the next instruction in the normal
(non-signal related) execution flow.

The proposed patch below implements ptrace selective signal ptracing
for the i386 and x86_64 architecutres.  Other architectures will ptrace
all signals, in the same way as before.


diff -rup linux-2.6.22-rc4-git5.orig/arch/i386/kernel/ptrace.c 
linux-2.6.22-rc4-git5.new/arch/i386/kernel/ptrace.c
--- linux-2.6.22-rc4-git5.orig/arch/i386/kernel/ptrace.c	2007-06-13 
09:46:37.000000000 -0400
+++ linux-2.6.22-rc4-git5.new/arch/i386/kernel/ptrace.c	2007-06-13 
17:00:38.000000000 -0400
@@ -620,6 +620,44 @@ long arch_ptrace(struct task_struct *chi
  					(struct user_desc __user *) data);
  		break;

+	case PTRACE_GETSIGTRACE: { /* Get the set of ptraced signals. */
+		int i;
+
+		if (!access_ok(VERIFY_WRITE, datap, sizeof(sigset_t))) {
+			ret = -EIO;
+			break;
+		}
+		for (i = 0; i < _NSIG_WORDS; i++) {
+			ret = __put_user(child->ptrace_sigmask.sig[i], datap);
+			if (ret)
+				break;
+			datap++;
+		}
+		break;
+	}
+
+	case PTRACE_SETSIGTRACE: { /* Set ptraced signal mask. */
+		int i;
+		sigset_t new_smask;
+
+		if (!access_ok( VERIFY_READ, datap, sizeof(sigset_t))) {
+			ret = -EIO;
+			break;
+		}
+		for (i = 0; i < _NSIG_WORDS; i++) {
+			ret = __get_user(new_smask.sig[i], datap);
+			if (ret)
+				break;
+			datap++;
+		}
+		if (ret)
+			break;
+
+		/* Update child task's ptrace signal mask. */
+		ptrace_update_traced_signals(child, &new_smask);
+		break;
+	}
+
  	default:
  		ret = ptrace_request(child, request, addr, data);
  		break;
diff -rup linux-2.6.22-rc4-git5.orig/arch/i386/kernel/signal.c 
linux-2.6.22-rc4-git5.new/arch/i386/kernel/signal.c
--- linux-2.6.22-rc4-git5.orig/arch/i386/kernel/signal.c	2007-06-13 
09:46:37.000000000 -0400
+++ linux-2.6.22-rc4-git5.new/arch/i386/kernel/signal.c	2007-06-13 
17:00:38.000000000 -0400
@@ -393,8 +393,12 @@ static int setup_frame(int sig, struct k
  	 * handler too.
  	 */
  	regs->eflags &= ~TF_MASK;
-	if (test_thread_flag(TIF_SINGLESTEP))
-		ptrace_notify(SIGTRAP);
+	if (test_thread_flag(TIF_SINGLESTEP)) {
+		if (sigismember(&current->ptrace_sigmask, sig))
+			ptrace_notify(SIGTRAP);
+		else
+			clear_thread_flag(TIF_SINGLESTEP);
+	}

  #if DEBUG_SIG
  	printk("SIG deliver (%s:%d): sp=%p pc=%p ra=%p\n",
@@ -487,8 +491,12 @@ static int setup_rt_frame(int sig, struc
  	 * handler too.
  	 */
  	regs->eflags &= ~TF_MASK;
-	if (test_thread_flag(TIF_SINGLESTEP))
-		ptrace_notify(SIGTRAP);
+	if (test_thread_flag(TIF_SINGLESTEP)) {
+		if (sigismember(&current->ptrace_sigmask, sig))
+			ptrace_notify(SIGTRAP);
+		else
+			clear_thread_flag(TIF_SINGLESTEP);
+	}

  #if DEBUG_SIG
  	printk("SIG deliver (%s:%d): sp=%p pc=%p ra=%p\n",
@@ -538,7 +546,8 @@ handle_signal(unsigned long sig, siginfo
  	 * that register information in the sigcontext is correct.
  	 */
  	if (unlikely(regs->eflags & TF_MASK)
-	    && likely(current->ptrace & PT_DTRACE)) {
+	    && likely(current->ptrace & PT_DTRACE)
+	    && sigismember(&current->ptrace_sigmask, sig)) {
  		current->ptrace &= ~PT_DTRACE;
  		regs->eflags &= ~TF_MASK;
  	}
diff -rup linux-2.6.22-rc4-git5.orig/arch/x86_64/ia32/ia32_signal.c 
linux-2.6.22-rc4-git5.new/arch/x86_64/ia32/ia32_signal.c
--- linux-2.6.22-rc4-git5.orig/arch/x86_64/ia32/ia32_signal.c	2007-06-13 
09:46:38.000000000 -0400
+++ linux-2.6.22-rc4-git5.new/arch/x86_64/ia32/ia32_signal.c	2007-06-13 
17:00:38.000000000 -0400
@@ -495,8 +495,12 @@ int ia32_setup_frame(int sig, struct k_s

  	set_fs(USER_DS);
  	regs->eflags &= ~TF_MASK;
-	if (test_thread_flag(TIF_SINGLESTEP))
-		ptrace_notify(SIGTRAP);
+	if (test_thread_flag(TIF_SINGLESTEP)) {
+		if (sigismember(&current->ptrace_sigmask, sig))
+			ptrace_notify(SIGTRAP);
+		else
+			clear_thread_flag(TIF_SINGLESTEP);
+	}

  #if DEBUG_SIG
  	printk("SIG deliver (%s:%d): sp=%p pc=%lx ra=%u\n",
@@ -601,8 +605,12 @@ int ia32_setup_rt_frame(int sig, struct

  	set_fs(USER_DS);
  	regs->eflags &= ~TF_MASK;
-	if (test_thread_flag(TIF_SINGLESTEP))
-		ptrace_notify(SIGTRAP);
+	if (test_thread_flag(TIF_SINGLESTEP)) {
+		if (sigismember(&current->ptrace_sigmask, sig))
+			ptrace_notify(SIGTRAP);
+		else
+			clear_thread_flag(TIF_SINGLESTEP);
+	}

  #if DEBUG_SIG
  	printk("SIG deliver (%s:%d): sp=%p pc=%lx ra=%u\n",
diff -rup linux-2.6.22-rc4-git5.orig/arch/x86_64/ia32/ptrace32.c 
linux-2.6.22-rc4-git5.new/arch/x86_64/ia32/ptrace32.c
--- linux-2.6.22-rc4-git5.orig/arch/x86_64/ia32/ptrace32.c	2007-04-25 
23:08:32.000000000 -0400
+++ linux-2.6.22-rc4-git5.new/arch/x86_64/ia32/ptrace32.c	2007-06-13 
17:00:38.000000000 -0400
@@ -247,6 +247,8 @@ asmlinkage long sys32_ptrace(long reques
  	case PTRACE_SETOPTIONS:
  	case PTRACE_SET_THREAD_AREA:
  	case PTRACE_GET_THREAD_AREA:
+	case PTRACE_SETSIGTRACE:
+	case PTRACE_GETSIGTRACE:
  		return sys_ptrace(request, pid, addr, data);

  	default:
diff -rup linux-2.6.22-rc4-git5.orig/arch/x86_64/kernel/ptrace.c 
linux-2.6.22-rc4-git5.new/arch/x86_64/kernel/ptrace.c
--- linux-2.6.22-rc4-git5.orig/arch/x86_64/kernel/ptrace.c	2007-06-13 
09:46:38.000000000 -0400
+++ linux-2.6.22-rc4-git5.new/arch/x86_64/kernel/ptrace.c	2007-06-13 
17:00:38.000000000 -0400
@@ -567,6 +567,48 @@ long arch_ptrace(struct task_struct *chi
  		break;
  	}

+	case PTRACE_GETSIGTRACE: { /* Get the set of ptraced signals. */
+		int i;
+
+		if (!access_ok(
+			VERIFY_WRITE, (unsigned *)data, sizeof(sigset_t)))
+		{
+			ret = -EIO;
+			break;
+		}
+		for (i = 0; i < _NSIG_WORDS; i++) {
+			ret = __put_user(child->ptrace_sigmask.sig[i],
+				(unsigned long *)data);
+			if (ret)
+				break;
+			data += sizeof(unsigned long);
+		}
+		break;
+	}
+
+	case PTRACE_SETSIGTRACE: { /* Set ptraced signal mask. */
+		int i;
+		sigset_t new_smask;
+
+		if (!access_ok(
+			VERIFY_READ, (unsigned *)data, sizeof(sigset_t)))
+		{
+			ret = -EIO;
+			break;
+		}
+		for (i = 0; i < _NSIG_WORDS; i++) {
+			ret = __get_user(new_smask.sig[i], (unsigned long *)data);
+			if (ret)
+				break;
+			data += sizeof(unsigned long);
+		}
+		if (ret)
+			break;
+		/* Update child task's ptrace signal mask. */
+		ptrace_update_traced_signals(child, &new_smask);
+		break;
+	}
+
  	default:
  		ret = ptrace_request(child, request, addr, data);
  		break;
diff -rup linux-2.6.22-rc4-git5.orig/arch/x86_64/kernel/signal.c 
linux-2.6.22-rc4-git5.new/arch/x86_64/kernel/signal.c
--- linux-2.6.22-rc4-git5.orig/arch/x86_64/kernel/signal.c	2007-06-13 
09:46:38.000000000 -0400
+++ linux-2.6.22-rc4-git5.new/arch/x86_64/kernel/signal.c	2007-06-13 
17:00:38.000000000 -0400
@@ -297,8 +297,13 @@ static int setup_rt_frame(int sig, struc
  	set_fs(USER_DS);

  	regs->eflags &= ~TF_MASK;
-	if (test_thread_flag(TIF_SINGLESTEP))
-		ptrace_notify(SIGTRAP);
+	if (test_thread_flag(TIF_SINGLESTEP)) {
+		if (sigismember(&current->ptrace_sigmask, sig))
+			ptrace_notify(SIGTRAP);
+		else
+			clear_thread_flag(TIF_SINGLESTEP);
+	}
+
  #ifdef DEBUG_SIG
  	printk("SIG deliver (%s:%d): sp=%p pc=%lx ra=%p\n",
  		current->comm, current->pid, frame, regs->rip, frame->pretcode);
@@ -355,7 +360,8 @@ handle_signal(unsigned long sig, siginfo
  	 * correct.
  	 */
  	if (unlikely(regs->eflags & TF_MASK)) {
-		if (likely(current->ptrace & PT_DTRACE)) {
+		if (likely(current->ptrace & PT_DTRACE)
+		    && sigismember(&current->ptrace_sigmask, sig)) {
  			current->ptrace &= ~PT_DTRACE;
  			regs->eflags &= ~TF_MASK;
  		}
diff -rup linux-2.6.22-rc4-git5.orig/include/asm-i386/ptrace-abi.h 
linux-2.6.22-rc4-git5.new/include/asm-i386/ptrace-abi.h
--- linux-2.6.22-rc4-git5.orig/include/asm-i386/ptrace-abi.h	2007-04-25 
23:08:32.000000000 -0400
+++ linux-2.6.22-rc4-git5.new/include/asm-i386/ptrace-abi.h	2007-06-13 
17:00:38.000000000 -0400
@@ -36,4 +36,7 @@
  #define PTRACE_SYSEMU		  31
  #define PTRACE_SYSEMU_SINGLESTEP  32

+#define PTRACE_GETSIGTRACE        33
+#define PTRACE_SETSIGTRACE        34
+
  #endif
diff -rup linux-2.6.22-rc4-git5.orig/include/asm-x86_64/ptrace-abi.h 
linux-2.6.22-rc4-git5.new/include/asm-x86_64/ptrace-abi.h
--- linux-2.6.22-rc4-git5.orig/include/asm-x86_64/ptrace-abi.h 
2007-04-25 23:08:32.000000000 -0400
+++ linux-2.6.22-rc4-git5.new/include/asm-x86_64/ptrace-abi.h	2007-06-13 
17:00:38.000000000 -0400
@@ -48,4 +48,7 @@

  #define PTRACE_ARCH_PRCTL	  30	/* arch_prctl for child */

+#define PTRACE_GETSIGTRACE        33
+#define PTRACE_SETSIGTRACE        34
+
  #endif
diff -rup linux-2.6.22-rc4-git5.orig/include/linux/ptrace.h 
linux-2.6.22-rc4-git5.new/include/linux/ptrace.h
--- linux-2.6.22-rc4-git5.orig/include/linux/ptrace.h	2007-04-25 
23:08:32.000000000 -0400
+++ linux-2.6.22-rc4-git5.new/include/linux/ptrace.h	2007-06-13 
17:00:38.000000000 -0400
@@ -92,6 +92,7 @@ extern void ptrace_disable(struct task_s
  extern int ptrace_check_attach(struct task_struct *task, int kill);
  extern int ptrace_request(struct task_struct *child, long request, 
long addr, long data);
  extern void ptrace_notify(int exit_code);
+extern void ptrace_update_traced_signals(struct task_struct *child, 
sigset_t *smask);
  extern void __ptrace_link(struct task_struct *child,
  			  struct task_struct *new_parent);
  extern void __ptrace_unlink(struct task_struct *child);
diff -rup linux-2.6.22-rc4-git5.orig/include/linux/sched.h 
linux-2.6.22-rc4-git5.new/include/linux/sched.h
--- linux-2.6.22-rc4-git5.orig/include/linux/sched.h	2007-06-13 
09:46:52.000000000 -0400
+++ linux-2.6.22-rc4-git5.new/include/linux/sched.h	2007-06-13 
17:00:38.000000000 -0400
@@ -1029,6 +1029,8 @@ struct task_struct {

  	unsigned long ptrace_message;
  	siginfo_t *last_siginfo; /* For ptrace use.  */
+
+	sigset_t ptrace_sigmask; /* Only signals in this mask are ptraced. */
  /*
   * current io wait handle: wait queue entry to use for io waits
   * If this thread is processing aio, this points at the waitqueue
diff -rup linux-2.6.22-rc4-git5.orig/kernel/exit.c 
linux-2.6.22-rc4-git5.new/kernel/exit.c
--- linux-2.6.22-rc4-git5.orig/kernel/exit.c	2007-06-13 
09:46:52.000000000 -0400
+++ linux-2.6.22-rc4-git5.new/kernel/exit.c	2007-06-13 
17:00:38.000000000 -0400
@@ -604,6 +604,18 @@ choose_new_parent(struct task_struct *p,
  	p->real_parent = reaper;
  }

+static inline void
+ptrace_sigmask_exit(struct task_struct *p, int ptraceflags)
+{
+	sigset_t new_sigmask;
+
+	if (!(ptraceflags & PT_PTRACED))
+		return;
+	/* Clear ptrace signal mask. */
+	sigemptyset(&new_sigmask);
+	ptrace_update_traced_signals(p, &new_sigmask);
+}
+
  static void
  reparent_thread(struct task_struct *p, struct task_struct *father, int 
traced)
  {
@@ -621,7 +633,9 @@ reparent_thread(struct task_struct *p, s
  		/* If this child is being traced, then we're the one tracing it
  		 * anyway, so let go of it.
  		 */
+		int ptrace = p->ptrace;
  		p->ptrace = 0;
+		ptrace_sigmask_exit(p, ptrace);
  		remove_parent(p);
  		p->parent = p->real_parent;
  		add_parent(p);
@@ -716,6 +730,7 @@ forget_original_parent(struct task_struc
  		} else {
  			/* reparent ptraced task to its real parent */
  			__ptrace_unlink (p);
+			ptrace_sigmask_exit(p, ptrace);
  			if (p->exit_state == EXIT_ZOMBIE && p->exit_signal != -1 &&
  			    thread_group_empty(p))
  				do_notify_parent(p, p->exit_signal);
diff -rup linux-2.6.22-rc4-git5.orig/kernel/fork.c 
linux-2.6.22-rc4-git5.new/kernel/fork.c
--- linux-2.6.22-rc4-git5.orig/kernel/fork.c	2007-06-13 
09:46:47.000000000 -0400
+++ linux-2.6.22-rc4-git5.new/kernel/fork.c	2007-06-13 
17:00:38.000000000 -0400
@@ -1168,6 +1168,17 @@ static struct task_struct *copy_process(
  	p->exit_state = 0;

  	/*
+	 * If child is being ptraced, then inherit the ptrace signal mask
+	 * from the parent.  When the ptrace signal mask support is not
+	 * used, all signals are ptraced and inherited by the child process.
+	 *
+	 * Clear the ptrace signal mask if this child process is not being
+	 * ptraced.
+	 */
+	if (!(p->ptrace & PT_PTRACED))
+		sigemptyset(&p->ptrace_sigmask);	/* no ptracing */
+
+	/*
  	 * Ok, make it visible to the rest of the system.
  	 * We dont wake it up yet.
  	 */
diff -rup linux-2.6.22-rc4-git5.orig/kernel/ptrace.c 
linux-2.6.22-rc4-git5.new/kernel/ptrace.c
--- linux-2.6.22-rc4-git5.orig/kernel/ptrace.c	2007-06-13 
09:46:47.000000000 -0400
+++ linux-2.6.22-rc4-git5.new/kernel/ptrace.c	2007-06-13 
17:00:38.000000000 -0400
@@ -206,6 +206,9 @@ repeat:
  	if (capable(CAP_SYS_PTRACE))
  		task->ptrace |= PT_PTRACE_CAP;

+	/* All signals are ptraced by default. */
+	sigfillset(&task->ptrace_sigmask);
+
  	__ptrace_link(task, current);

  	force_sig_specific(SIGSTOP, task);
@@ -219,10 +222,17 @@ out:

  static inline void __ptrace_detach(struct task_struct *child, unsigned 
int data)
  {
+	sigset_t new_smask;
+
  	child->exit_code = data;
-	/* .. re-parent .. */
+	/* re-parent */
  	__ptrace_unlink(child);
-	/* .. and wake it up. */
+
+	/* Clear the ptrace signal mask. */
+	sigemptyset(&new_smask);
+	ptrace_update_traced_signals(child, &new_smask);
+
+	/* Wake it up. */
  	if (child->exit_state != EXIT_ZOMBIE)
  		wake_up_process(child);
  }
@@ -412,8 +422,11 @@ int ptrace_traceme(void)
  		/*
  		 * Set the ptrace bit in the process ptrace flags.
  		 */
-		if (!ret)
+		if (!ret) {
  			current->ptrace |= PT_PTRACED;
+			/* All signals are ptraced by default */
+			sigfillset(&current->ptrace_sigmask);
+		}
  	}
  	task_unlock(current);
  	return ret;
diff -rup linux-2.6.22-rc4-git5.orig/kernel/signal.c 
linux-2.6.22-rc4-git5.new/kernel/signal.c
--- linux-2.6.22-rc4-git5.orig/kernel/signal.c	2007-06-13 
09:46:52.000000000 -0400
+++ linux-2.6.22-rc4-git5.new/kernel/signal.c	2007-06-14 
10:28:03.000000000 -0400
@@ -47,7 +47,7 @@ static int sig_ignored(struct task_struc
  	/*
  	 * Tracers always want to know about signals..
  	 */
-	if (t->ptrace & PT_PTRACED)
+	if (t->ptrace & PT_PTRACED && sigismember(&(t)->ptrace_sigmask, sig))
  		return 0;

  	/*
@@ -1610,6 +1610,58 @@ void ptrace_notify(int exit_code)
  	spin_unlock_irq(&current->sighand->siglock);
  }

+/*
+ * void ptrace_update_traced_signals(
+ *			struct task_struct *child, sigset_t *new_smaskp)
+ *
+ *	Update the signal mask of ptraced signals, removing any ignored
+ *	pending signals that are no longer ptraced.  'new_smaskp' points
+ *	to the new ptrace signal mask which will be stored into
+ *	child->ptrace_sigmask.
+ */
+void ptrace_update_traced_signals(struct task_struct *child,
+							sigset_t *new_smaskp)
+{
+	int sig = 0, index = 0;
+	unsigned long int flags;
+	sigset_t prev_smask;
+
+	/* Get signals that were previously, but no longer ptraced. */
+	signandsets(&prev_smask, &child->ptrace_sigmask, new_smaskp);
+
+	child->ptrace_sigmask = *new_smaskp;
+
+	while (!sigisemptyset(&prev_smask)) {
+		while (index < _NSIG_WORDS) {
+			if (prev_smask.sig[index]) {
+                               	sig = ffz(~prev_smask.sig[index]) +
+						(index * _NSIG_BPW) + 1;
+				break;
+			}
+			index++;
+		}
+		/* Remove signal from the previously ptraced signal mask. */
+		sigdelset(&prev_smask, sig);
+
+		spin_lock_irqsave(&child->sighand->siglock, flags);
+
+		if (child->sighand == NULL) {
+			/* This task is exiting, so just return. */
+			spin_unlock_irqrestore(&child->sighand->siglock, flags);
+			return;
+		}
+		if (!sig_ignored(child, sig)) {
+			spin_unlock_irqrestore(&child->sighand->siglock, flags);
+			continue;
+		}
+		/* Remove any queued signals - they should now be ignored. */
+		rm_from_queue(sigmask(sig), &child->pending);
+		rm_from_queue(sigmask(sig), &child->signal->shared_pending);
+
+		spin_unlock_irqrestore(&child->sighand->siglock, flags);
+	}
+}
+
  static void
  finish_stop(int stop_count)
  {
@@ -1750,7 +1802,8 @@ relock:
  		if (!signr)
  			break; /* will return 0 */

-		if ((current->ptrace & PT_PTRACED) && signr != SIGKILL) {
+		if ((current->ptrace & PT_PTRACED) && signr != SIGKILL &&
+				sigismember(&current->ptrace_sigmask, signr)) {
  			ptrace_signal_deliver(regs, cookie);

  			/* Let the debugger run.  */
