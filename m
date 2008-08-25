Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbYHYHhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbYHYHhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 03:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYHYHhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 03:37:33 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:32826 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbYHYHhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 03:37:33 -0400
Message-ID: <48B26083.8080506@linux.vnet.ibm.com>
Date: Mon, 25 Aug 2008 09:34:27 +0200
From: Pierre Morel <pmorel@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Roland McGrath <roland@redhat.com>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       sameske@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC] [Patch 1/1] [Self Ptrace] System call notification with self_ptrace
Content-Type: multipart/mixed;
 boundary="------------050608090503070103060105"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050608090503070103060105
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The following patch adds a new functionality to ptrace:
system call notification to the current process.

It applies to the 2.6.26 vanilla kernel for the x86 and s390 architectures.

It provides the following:
---------------------------------
   - Activation and de-activation of the functionality through ptrace
     system call
   - When the functionality is activated, the system call is not done
     and the calling process receives a SIGSYS signal.

What is it good for?
--------------------------
   - Debugging : a tracing tool can be implemented inside the space
     of the current thread and access the thread data directly from
     inside reducing task switch and IPC overhead.
   - Virtualization : a system call interposition mechanism can be
     implemneted inside the space of the current thread reducing the
     overhead of task switch and IPC and access directly all syscall
     parameters

What is missing?
----------------------
   - Port to other architectures.

It follows the patch itself.

-- 
=============
Pierre Morel
RTOS and Embedded Linux


--------------050608090503070103060105
Content-Type: text/plain;
 name="self_ptrace_08.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="self_ptrace_08.patch"

Subject: [PATCH] system call notification with self_ptrace

From: Pierre Morel <pmorel@fr.ibm.com>


PTRACE SELF

This patch adds a new functionality to ptrace: system call notification to
the current process.
When a process requests self ptrace, with the new request PTRACE_SELF_ON:

 1.  the next system call performed by the process will not be executed
 2.  self ptrace will be disabled for the process
 3.  a SIGSYS signal will be sent to the process.

With an appropriate SIGSYS signal handler, the process can access its own
data structures to

 1.  get the system call number from the siginfo structure
 2.  get the system call arguments from the stack
 3.  instrument the system call with other system calls
 4.  emulate the system call with other system calls
 5.  change the arguments of the system call
 6.  perform the system call for good
 7.  change the return value of the system call
 8.  request self ptrace again before returning.

The new request PTRACE_SELF_OFF disables self ptrace.


Signed-off-by: Pierre Morel <pmorel@fr.ibm.com>
Signed-off-by: Volker Sameske <sameske@de.ibm.com>
---

 arch/s390/kernel/ptrace.c     |   18 ++++++++++++++++++
 arch/s390/kernel/signal.c     |    5 +++++
 arch/x86/kernel/ptrace.c      |   36 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/signal_32.c   |    5 +++++
 arch/x86/kernel/signal_64.c   |    5 +++++
 include/asm-generic/siginfo.h |    6 ++++++
 include/linux/ptrace.h        |    5 +++++
 kernel/ptrace.c               |   17 +++++++++++++++++
 8 files changed, 97 insertions(+)

Index: linux/arch/s390/kernel/ptrace.c
===================================================================
--- linux.orig/arch/s390/kernel/ptrace.c
+++ linux/arch/s390/kernel/ptrace.c
@@ -583,6 +583,24 @@ syscall_trace(struct pt_regs *regs, int 
 
 	if (!test_thread_flag(TIF_SYSCALL_TRACE))
 		goto out;
+
+	if ((current->ptrace & PT_SELF)
+		&& (regs->gprs[2] != __NR_rt_sigreturn)
+		&& (regs->gprs[2] != __NR_ptrace)) {
+		if (!entryexit) {
+			struct siginfo info;
+
+			memset(&info, 0, sizeof(struct siginfo));
+			info.si_signo = SIGSYS;
+			info.si_code = SYS_SYSCALL;
+			info.si_errno = regs->gprs[2];
+			info.si_addr = (void *)regs->orig_gpr2;
+			send_sig_info(SIGSYS, &info, current);
+			regs->gprs[2] = -1;
+		}
+		return;
+	}
+
 	if (!(current->ptrace & PT_PTRACED))
 		goto out;
 	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD)
Index: linux/arch/s390/kernel/signal.c
===================================================================
--- linux.orig/arch/s390/kernel/signal.c
+++ linux/arch/s390/kernel/signal.c
@@ -409,6 +409,11 @@ handle_signal(unsigned long sig, struct 
 		spin_unlock_irq(&current->sighand->siglock);
 	}
 
+	if (current->ptrace & PT_SELF) {
+		clear_thread_flag(TIF_SYSCALL_TRACE);
+		current->ptrace &= ~PT_SELF;
+	}
+
 	return ret;
 }
 
Index: linux/arch/x86/kernel/ptrace.c
===================================================================
--- linux.orig/arch/x86/kernel/ptrace.c
+++ linux/arch/x86/kernel/ptrace.c
@@ -20,6 +20,7 @@
 #include <linux/audit.h>
 #include <linux/seccomp.h>
 #include <linux/signal.h>
+#include <linux/unistd.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -1394,6 +1395,21 @@ int do_syscall_trace(struct pt_regs *reg
 	if (!entryexit)
 		secure_computing(regs->orig_ax);
 
+	if ((current->ptrace & PT_SELF)
+		&& (regs->orig_ax != __NR_rt_sigreturn)
+		&& (regs->orig_ax != __NR_ptrace)) {
+		if (!entryexit) {
+		struct siginfo info;
+
+		memset(&info, 0, sizeof(struct siginfo));
+		info.si_signo = SIGSYS;
+		info.si_code = SYS_SYSCALL;
+		info.si_addr = (void *) regs->orig_ax;
+		send_sig_info(SIGSYS, &info, current);
+		}
+		return 1; /* Skip system call, deliver signal. */
+	}
+
 	if (unlikely(current->audit_context)) {
 		if (entryexit)
 			audit_syscall_exit(AUDITSC_RESULT(regs->ax),
@@ -1486,6 +1502,20 @@ asmlinkage void syscall_trace_enter(stru
 	/* do the secure computing check first */
 	secure_computing(regs->orig_ax);
 
+	if ((current->ptrace & PT_SELF)
+		&& (regs->orig_rax != __NR_rt_sigreturn)
+		&& (regs->orig_rax != __NR_ptrace)) {
+		struct siginfo info;
+
+		memset(&info, 0, sizeof(struct siginfo));
+		info.si_signo = SIGSYS;
+		info.si_code = SYS_SYSCALL;
+		info.si_addr = (void *) regs->orig_rax;
+		send_sig_info(SIGSYS, &info, current);
+		regs->rax = -1 ;
+		return; /* Skip system call, deliver signal. */
+	}
+
 	if (test_thread_flag(TIF_SYSCALL_TRACE)
 	    && (current->ptrace & PT_PTRACED))
 		syscall_trace(regs);
@@ -1507,6 +1537,12 @@ asmlinkage void syscall_trace_enter(stru
 
 asmlinkage void syscall_trace_leave(struct pt_regs *regs)
 {
+	if ((current->ptrace & PT_SELF)
+		&& (regs->orig_rax != __NR_rt_sigreturn)
+		&& (regs->orig_rax != __NR_ptrace)) {
+		regs->rax = -1 ;
+		return; /* Skip system call. */
+	}
 	if (unlikely(current->audit_context))
 		audit_syscall_exit(AUDITSC_RESULT(regs->ax), regs->ax);
 
Index: linux/arch/x86/kernel/signal_32.c
===================================================================
--- linux.orig/arch/x86/kernel/signal_32.c
+++ linux/arch/x86/kernel/signal_32.c
@@ -94,6 +94,11 @@ sys_sigaction(int sig, const struct old_
 		__put_user(old_ka.sa.sa_mask.sig[0], &oact->sa_mask);
 	}
 
+	if (current->ptrace & PT_SELF) {
+		clear_thread_flag(TIF_SYSCALL_TRACE);
+		current->ptrace &= ~PT_SELF;
+	}
+
 	return ret;
 }
 
Index: linux/arch/x86/kernel/signal_64.c
===================================================================
--- linux.orig/arch/x86/kernel/signal_64.c
+++ linux/arch/x86/kernel/signal_64.c
@@ -402,6 +402,11 @@ handle_signal(unsigned long sig, siginfo
 		spin_unlock_irq(&current->sighand->siglock);
 	}
 
+	if (current->ptrace & PT_SELF) {
+		clear_thread_flag(TIF_SYSCALL_TRACE);
+		current->ptrace &= ~PT_SELF;
+	}
+
 	return ret;
 }
 
Index: linux/include/asm-generic/siginfo.h
===================================================================
--- linux.orig/include/asm-generic/siginfo.h
+++ linux/include/asm-generic/siginfo.h
@@ -224,6 +224,12 @@ typedef struct siginfo {
 #define NSIGPOLL	6
 
 /*
+ * SIGSYS si_codes
+ */
+#define SYS_SYSCALL    (__SI_FAULT|1)  /* system call notification */
+#define NSIGSYS        1
+
+/*
  * sigevent definitions
  * 
  * It seems likely that SIGEV_THREAD will have to be handled from 
Index: linux/include/linux/ptrace.h
===================================================================
--- linux.orig/include/linux/ptrace.h
+++ linux/include/linux/ptrace.h
@@ -27,6 +27,10 @@
 #define PTRACE_GETSIGINFO	0x4202
 #define PTRACE_SETSIGINFO	0x4203
 
+/* PTRACE SELF requests					*/
+#define PTRACE_SELF_ON		0x4281
+#define PTRACE_SELF_OFF		0x4282
+
 /* options set using PTRACE_SETOPTIONS */
 #define PTRACE_O_TRACESYSGOOD	0x00000001
 #define PTRACE_O_TRACEFORK	0x00000002
@@ -67,6 +71,7 @@
 #define PT_TRACE_EXEC	0x00000080
 #define PT_TRACE_VFORK_DONE	0x00000100
 #define PT_TRACE_EXIT	0x00000200
+#define PT_SELF		0x00000400
 
 #define PT_TRACE_MASK	0x000003f4
 
Index: linux/kernel/ptrace.c
===================================================================
--- linux.orig/kernel/ptrace.c
+++ linux/kernel/ptrace.c
@@ -550,6 +550,23 @@ asmlinkage long sys_ptrace(long request,
 		goto out;
 	}
 
+	if (request == PTRACE_SELF_ON) {
+		task_lock(current);
+		set_thread_flag(TIF_SYSCALL_TRACE);
+		current->ptrace |= PT_SELF;
+		task_unlock(current);
+		ret = 0;
+		goto out;
+	}
+	if (request == PTRACE_SELF_OFF) {
+		task_lock(current);
+		clear_thread_flag(TIF_SYSCALL_TRACE);
+		current->ptrace &= ~PT_SELF;
+		task_unlock(current);
+		ret = 0;
+		goto out;
+	}
+
 	child = ptrace_get_task_struct(pid);
 	if (IS_ERR(child)) {
 		ret = PTR_ERR(child);

--------------050608090503070103060105--
