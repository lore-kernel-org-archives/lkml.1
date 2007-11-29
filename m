Return-Path: <linux-kernel-owner+w=401wt.eu-S1762594AbXK2L7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762594AbXK2L7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 06:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbXK2L73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 06:59:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525AbXK2L71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 06:59:27 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH x86/mm 02/11] x86: ptrace_32 renamed
In-Reply-To: Roland McGrath's message of  Thursday, 29 November 2007 03:57:11 -0800 <20071129115711.9FC8526F8E7@magilla.localdomain>
References: <20071129115711.9FC8526F8E7@magilla.localdomain>
X-Zippy-Says: This TOPS OFF my partygoing experience!  Someone I DON'T LIKE is
    talking to me about a HEART-WARMING European film..
Message-Id: <20071129115912.451D126F8E7@magilla.localdomain>
Date: Thu, 29 Nov 2007 03:59:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This renames ptrace_32.c back to ptrace.c, in preparation
for merging the 32/64 versions of these files.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/Makefile_32 |    3 +-
 arch/x86/kernel/ptrace.c    |  484 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/ptrace_32.c |  484 -------------------------------------------
 3 files changed, 486 insertions(+), 485 deletions(-)

diff --git a/arch/x86/kernel/Makefile_32 b/arch/x86/kernel/Makefile_32
index 369b297..8946cc8 100644
--- a/arch/x86/kernel/Makefile_32
+++ b/arch/x86/kernel/Makefile_32
@@ -6,10 +6,11 @@ extra-y := head_32.o init_task.o vmlinux.lds
 CPPFLAGS_vmlinux.lds += -Ui386
 
 obj-y	:= process_32.o signal_32.o entry_32.o traps_32.o irq_32.o \
-		ptrace_32.o time_32.o ioport_32.o ldt.o setup_32.o i8259_32.o sys_i386_32.o \
+		time_32.o ioport_32.o ldt.o setup_32.o i8259_32.o sys_i386_32.o \
 		pci-dma_32.o i386_ksyms_32.o i387_32.o bootflag.o e820_32.o\
 		quirks.o i8237.o topology.o alternative.o i8253.o tsc_32.o rtc.o
 
+obj-y				+= ptrace.o
 obj-y				+= tls.o
 obj-y				+= step.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
new file mode 100644
index 0000000..fed83d0
--- /dev/null
+++ b/arch/x86/kernel/ptrace.c
@@ -0,0 +1,484 @@
+/* By Ross Biro 1/23/92 */
+/*
+ * Pentium III FXSR, SSE support
+ *	Gareth Hughes <gareth@valinux.com>, May 2000
+ */
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/errno.h>
+#include <linux/ptrace.h>
+#include <linux/user.h>
+#include <linux/security.h>
+#include <linux/audit.h>
+#include <linux/seccomp.h>
+#include <linux/signal.h>
+
+#include <asm/uaccess.h>
+#include <asm/pgtable.h>
+#include <asm/system.h>
+#include <asm/processor.h>
+#include <asm/i387.h>
+#include <asm/debugreg.h>
+#include <asm/ldt.h>
+#include <asm/desc.h>
+
+/*
+ * does not yet catch signals sent when the child dies.
+ * in exit.c or in signal.c.
+ */
+
+/*
+ * Determines which flags the user has access to [1 = access, 0 = no access].
+ * Prohibits changing ID(21), VIP(20), VIF(19), VM(17), NT(14), IOPL(12-13), IF(9).
+ * Also masks reserved bits (31-22, 15, 5, 3, 1).
+ */
+#define FLAG_MASK 0x00050dd5
+
+static long *pt_regs_access(struct pt_regs *regs, unsigned long regno)
+{
+	BUILD_BUG_ON(offsetof(struct pt_regs, bx) != 0);
+	if (regno > FS)
+		--regno;
+	return &regs->bx + regno;
+}
+
+static int putreg(struct task_struct *child,
+	unsigned long regno, unsigned long value)
+{
+	struct pt_regs *regs = task_pt_regs(child);
+	regno >>= 2;
+	switch (regno) {
+	case GS:
+		if (value && (value & 3) != 3)
+			return -EIO;
+		child->thread.gs = value;
+		if (child == current)
+			/*
+			 * The user-mode %gs is not affected by
+			 * kernel entry, so we must update the CPU.
+			 */
+			loadsegment(gs, value);
+		return 0;
+	case DS:
+	case ES:
+	case FS:
+		if (value && (value & 3) != 3)
+			return -EIO;
+		value &= 0xffff;
+		break;
+	case SS:
+	case CS:
+		if ((value & 3) != 3)
+			return -EIO;
+		value &= 0xffff;
+		break;
+	case EFL:
+		value &= FLAG_MASK;
+		/*
+		 * If the user value contains TF, mark that
+		 * it was not "us" (the debugger) that set it.
+		 * If not, make sure it stays set if we had.
+		 */
+		if (value & X86_EFLAGS_TF)
+			clear_tsk_thread_flag(child, TIF_FORCED_TF);
+		else if (test_tsk_thread_flag(child, TIF_FORCED_TF))
+			value |= X86_EFLAGS_TF;
+		value |= regs->flags & ~FLAG_MASK;
+		break;
+	}
+	*pt_regs_access(regs, regno) = value;
+	return 0;
+}
+
+static unsigned long getreg(struct task_struct *child, unsigned long regno)
+{
+	struct pt_regs *regs = task_pt_regs(child);
+	unsigned long retval = ~0UL;
+
+	regno >>= 2;
+	switch (regno) {
+	case EFL:
+		/*
+		 * If the debugger set TF, hide it from the readout.
+		 */
+		retval = regs->flags;
+		if (test_tsk_thread_flag(child, TIF_FORCED_TF))
+			retval &= ~X86_EFLAGS_TF;
+		break;
+	case GS:
+		retval = child->thread.gs;
+		if (child == current)
+			savesegment(gs, retval);
+		break;
+	case DS:
+	case ES:
+	case FS:
+	case SS:
+	case CS:
+		retval = 0xffff;
+		/* fall through */
+	default:
+		retval &= *pt_regs_access(regs, regno);
+	}
+	return retval;
+}
+
+/*
+ * This function is trivial and will be inlined by the compiler.
+ * Having it separates the implementation details of debug
+ * registers from the interface details of ptrace.
+ */
+static unsigned long ptrace_get_debugreg(struct task_struct *child, int n)
+{
+	switch (n) {
+	case 0:		return child->thread.debugreg0;
+	case 1:		return child->thread.debugreg1;
+	case 2:		return child->thread.debugreg2;
+	case 3:		return child->thread.debugreg3;
+	case 6:		return child->thread.debugreg6;
+	case 7:		return child->thread.debugreg7;
+	}
+	return 0;
+}
+
+static int ptrace_set_debugreg(struct task_struct *child,
+			       int n, unsigned long data)
+{
+	int i;
+
+	if (unlikely(n == 4 || n == 5))
+		return -EIO;
+
+	if (n < 4 && unlikely(data >= TASK_SIZE - 3))
+		return -EIO;
+
+	switch (n) {
+	case 0:		child->thread.debugreg0 = data; break;
+	case 1:		child->thread.debugreg1 = data; break;
+	case 2:		child->thread.debugreg2 = data; break;
+	case 3:		child->thread.debugreg3 = data; break;
+
+	case 6:
+		child->thread.debugreg6 = data;
+		break;
+
+	case 7:
+		/*
+		 * Sanity-check data. Take one half-byte at once with
+		 * check = (val >> (16 + 4*i)) & 0xf. It contains the
+		 * R/Wi and LENi bits; bits 0 and 1 are R/Wi, and bits
+		 * 2 and 3 are LENi. Given a list of invalid values,
+		 * we do mask |= 1 << invalid_value, so that
+		 * (mask >> check) & 1 is a correct test for invalid
+		 * values.
+		 *
+		 * R/Wi contains the type of the breakpoint /
+		 * watchpoint, LENi contains the length of the watched
+		 * data in the watchpoint case.
+		 *
+		 * The invalid values are:
+		 * - LENi == 0x10 (undefined), so mask |= 0x0f00.
+		 * - R/Wi == 0x10 (break on I/O reads or writes), so
+		 *   mask |= 0x4444.
+		 * - R/Wi == 0x00 && LENi != 0x00, so we have mask |=
+		 *   0x1110.
+		 *
+		 * Finally, mask = 0x0f00 | 0x4444 | 0x1110 == 0x5f54.
+		 *
+		 * See the Intel Manual "System Programming Guide",
+		 * 15.2.4
+		 *
+		 * Note that LENi == 0x10 is defined on x86_64 in long
+		 * mode (i.e. even for 32-bit userspace software, but
+		 * 64-bit kernel), so the x86_64 mask value is 0x5454.
+		 * See the AMD manual no. 24593 (AMD64 System Programming)
+		 */
+		data &= ~DR_CONTROL_RESERVED;
+		for (i = 0; i < 4; i++)
+			if ((0x5f54 >> ((data >> (16 + 4*i)) & 0xf)) & 1)
+				return -EIO;
+		child->thread.debugreg7 = data;
+		if (data)
+			set_tsk_thread_flag(child, TIF_DEBUG);
+		else
+			clear_tsk_thread_flag(child, TIF_DEBUG);
+		break;
+	}
+
+	return 0;
+}
+
+/*
+ * Called by kernel/ptrace.c when detaching..
+ *
+ * Make sure the single step bit is not set.
+ */
+void ptrace_disable(struct task_struct *child)
+{
+	user_disable_single_step(child);
+	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
+}
+
+long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+{
+	struct user * dummy = NULL;
+	int i, ret;
+	unsigned long __user *datap = (unsigned long __user *)data;
+
+	switch (request) {
+	/* when I and D space are separate, these will need to be fixed. */
+	case PTRACE_PEEKTEXT: /* read word at location addr. */
+	case PTRACE_PEEKDATA:
+		ret = generic_ptrace_peekdata(child, addr, data);
+		break;
+
+	/* read the word at location addr in the USER area. */
+	case PTRACE_PEEKUSR: {
+		unsigned long tmp;
+
+		ret = -EIO;
+		if ((addr & 3) || addr < 0 ||
+		    addr > sizeof(struct user) - 3)
+			break;
+
+		tmp = 0;  /* Default return condition */
+		if(addr < FRAME_SIZE*sizeof(long))
+			tmp = getreg(child, addr);
+		if(addr >= (long) &dummy->u_debugreg[0] &&
+		   addr <= (long) &dummy->u_debugreg[7]){
+			addr -= (long) &dummy->u_debugreg[0];
+			addr = addr >> 2;
+			tmp = ptrace_get_debugreg(child, addr);
+		}
+		ret = put_user(tmp, datap);
+		break;
+	}
+
+	/* when I and D space are separate, this will have to be fixed. */
+	case PTRACE_POKETEXT: /* write the word at location addr. */
+	case PTRACE_POKEDATA:
+		ret = generic_ptrace_pokedata(child, addr, data);
+		break;
+
+	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
+		ret = -EIO;
+		if ((addr & 3) || addr < 0 ||
+		    addr > sizeof(struct user) - 3)
+			break;
+
+		if (addr < FRAME_SIZE*sizeof(long)) {
+			ret = putreg(child, addr, data);
+			break;
+		}
+		/* We need to be very careful here.  We implicitly
+		   want to modify a portion of the task_struct, and we
+		   have to be selective about what portions we allow someone
+		   to modify. */
+
+		  ret = -EIO;
+		  if(addr >= (long) &dummy->u_debugreg[0] &&
+		     addr <= (long) &dummy->u_debugreg[7]){
+			  addr -= (long) &dummy->u_debugreg;
+			  addr = addr >> 2;
+			  ret = ptrace_set_debugreg(child, addr, data);
+		  }
+		  break;
+
+	case PTRACE_GETREGS: { /* Get all gp regs from the child. */
+	  	if (!access_ok(VERIFY_WRITE, datap, FRAME_SIZE*sizeof(long))) {
+			ret = -EIO;
+			break;
+		}
+		for ( i = 0; i < FRAME_SIZE*sizeof(long); i += sizeof(long) ) {
+			__put_user(getreg(child, i), datap);
+			datap++;
+		}
+		ret = 0;
+		break;
+	}
+
+	case PTRACE_SETREGS: { /* Set all gp regs in the child. */
+		unsigned long tmp;
+	  	if (!access_ok(VERIFY_READ, datap, FRAME_SIZE*sizeof(long))) {
+			ret = -EIO;
+			break;
+		}
+		for ( i = 0; i < FRAME_SIZE*sizeof(long); i += sizeof(long) ) {
+			__get_user(tmp, datap);
+			putreg(child, i, tmp);
+			datap++;
+		}
+		ret = 0;
+		break;
+	}
+
+	case PTRACE_GETFPREGS: { /* Get the child FPU state. */
+		if (!access_ok(VERIFY_WRITE, datap,
+			       sizeof(struct user_i387_struct))) {
+			ret = -EIO;
+			break;
+		}
+		ret = 0;
+		if (!tsk_used_math(child))
+			init_fpu(child);
+		get_fpregs((struct user_i387_struct __user *)data, child);
+		break;
+	}
+
+	case PTRACE_SETFPREGS: { /* Set the child FPU state. */
+		if (!access_ok(VERIFY_READ, datap,
+			       sizeof(struct user_i387_struct))) {
+			ret = -EIO;
+			break;
+		}
+		set_stopped_child_used_math(child);
+		set_fpregs(child, (struct user_i387_struct __user *)data);
+		ret = 0;
+		break;
+	}
+
+	case PTRACE_GETFPXREGS: { /* Get the child extended FPU state. */
+		if (!access_ok(VERIFY_WRITE, datap,
+			       sizeof(struct user_fxsr_struct))) {
+			ret = -EIO;
+			break;
+		}
+		if (!tsk_used_math(child))
+			init_fpu(child);
+		ret = get_fpxregs((struct user_fxsr_struct __user *)data, child);
+		break;
+	}
+
+	case PTRACE_SETFPXREGS: { /* Set the child extended FPU state. */
+		if (!access_ok(VERIFY_READ, datap,
+			       sizeof(struct user_fxsr_struct))) {
+			ret = -EIO;
+			break;
+		}
+		set_stopped_child_used_math(child);
+		ret = set_fpxregs(child, (struct user_fxsr_struct __user *)data);
+		break;
+	}
+
+	case PTRACE_GET_THREAD_AREA:
+		if (addr < 0)
+			return -EIO;
+		ret = do_get_thread_area(child, addr,
+					 (struct user_desc __user *) data);
+		break;
+
+	case PTRACE_SET_THREAD_AREA:
+		if (addr < 0)
+			return -EIO;
+		ret = do_set_thread_area(child, addr,
+					 (struct user_desc __user *) data, 0);
+		break;
+
+	default:
+		ret = ptrace_request(child, request, addr, data);
+		break;
+	}
+
+	return ret;
+}
+
+void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code)
+{
+	struct siginfo info;
+
+	tsk->thread.trap_no = 1;
+	tsk->thread.error_code = error_code;
+
+	memset(&info, 0, sizeof(info));
+	info.si_signo = SIGTRAP;
+	info.si_code = TRAP_BRKPT;
+
+	/* User-mode ip? */
+	info.si_addr = user_mode_vm(regs) ? (void __user *) regs->ip : NULL;
+
+	/* Send us the fake SIGTRAP */
+	force_sig_info(SIGTRAP, &info, tsk);
+}
+
+/* notification of system call entry/exit
+ * - triggered by current->work.syscall_trace
+ */
+__attribute__((regparm(3)))
+int do_syscall_trace(struct pt_regs *regs, int entryexit)
+{
+	int is_sysemu = test_thread_flag(TIF_SYSCALL_EMU);
+	/*
+	 * With TIF_SYSCALL_EMU set we want to ignore TIF_SINGLESTEP for syscall
+	 * interception
+	 */
+	int is_singlestep = !is_sysemu && test_thread_flag(TIF_SINGLESTEP);
+	int ret = 0;
+
+	/* do the secure computing check first */
+	if (!entryexit)
+		secure_computing(regs->orig_ax);
+
+	if (unlikely(current->audit_context)) {
+		if (entryexit)
+			audit_syscall_exit(AUDITSC_RESULT(regs->ax),
+						regs->ax);
+		/* Debug traps, when using PTRACE_SINGLESTEP, must be sent only
+		 * on the syscall exit path. Normally, when TIF_SYSCALL_AUDIT is
+		 * not used, entry.S will call us only on syscall exit, not
+		 * entry; so when TIF_SYSCALL_AUDIT is used we must avoid
+		 * calling send_sigtrap() on syscall entry.
+		 *
+		 * Note that when PTRACE_SYSEMU_SINGLESTEP is used,
+		 * is_singlestep is false, despite his name, so we will still do
+		 * the correct thing.
+		 */
+		else if (is_singlestep)
+			goto out;
+	}
+
+	if (!(current->ptrace & PT_PTRACED))
+		goto out;
+
+	/* If a process stops on the 1st tracepoint with SYSCALL_TRACE
+	 * and then is resumed with SYSEMU_SINGLESTEP, it will come in
+	 * here. We have to check this and return */
+	if (is_sysemu && entryexit)
+		return 0;
+
+	/* Fake a debug trap */
+	if (is_singlestep)
+		send_sigtrap(current, regs, 0);
+
+ 	if (!test_thread_flag(TIF_SYSCALL_TRACE) && !is_sysemu)
+		goto out;
+
+	/* the 0x80 provides a way for the tracing parent to distinguish
+	   between a syscall stop and SIGTRAP delivery */
+	/* Note that the debugger could change the result of test_thread_flag!*/
+	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD) ? 0x80:0));
+
+	/*
+	 * this isn't the same as continuing with a signal, but it will do
+	 * for normal use.  strace only continues with a signal if the
+	 * stopping signal is not SIGTRAP.  -brl
+	 */
+	if (current->exit_code) {
+		send_sig(current->exit_code, current, 1);
+		current->exit_code = 0;
+	}
+	ret = is_sysemu;
+out:
+	if (unlikely(current->audit_context) && !entryexit)
+		audit_syscall_entry(AUDIT_ARCH_I386, regs->orig_ax,
+				    regs->bx, regs->cx, regs->dx, regs->si);
+	if (ret == 0)
+		return 0;
+
+	regs->orig_ax = -1; /* force skip of syscall restarting */
+	if (unlikely(current->audit_context))
+		audit_syscall_exit(AUDITSC_RESULT(regs->ax), regs->ax);
+	return 1;
+}
diff --git a/arch/x86/kernel/ptrace_32.c b/arch/x86/kernel/ptrace_32.c
deleted file mode 100644
index fed83d0..0000000
--- a/arch/x86/kernel/ptrace_32.c
+++ /dev/null
@@ -1,484 +0,0 @@
-/* By Ross Biro 1/23/92 */
-/*
- * Pentium III FXSR, SSE support
- *	Gareth Hughes <gareth@valinux.com>, May 2000
- */
-
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/mm.h>
-#include <linux/smp.h>
-#include <linux/errno.h>
-#include <linux/ptrace.h>
-#include <linux/user.h>
-#include <linux/security.h>
-#include <linux/audit.h>
-#include <linux/seccomp.h>
-#include <linux/signal.h>
-
-#include <asm/uaccess.h>
-#include <asm/pgtable.h>
-#include <asm/system.h>
-#include <asm/processor.h>
-#include <asm/i387.h>
-#include <asm/debugreg.h>
-#include <asm/ldt.h>
-#include <asm/desc.h>
-
-/*
- * does not yet catch signals sent when the child dies.
- * in exit.c or in signal.c.
- */
-
-/*
- * Determines which flags the user has access to [1 = access, 0 = no access].
- * Prohibits changing ID(21), VIP(20), VIF(19), VM(17), NT(14), IOPL(12-13), IF(9).
- * Also masks reserved bits (31-22, 15, 5, 3, 1).
- */
-#define FLAG_MASK 0x00050dd5
-
-static long *pt_regs_access(struct pt_regs *regs, unsigned long regno)
-{
-	BUILD_BUG_ON(offsetof(struct pt_regs, bx) != 0);
-	if (regno > FS)
-		--regno;
-	return &regs->bx + regno;
-}
-
-static int putreg(struct task_struct *child,
-	unsigned long regno, unsigned long value)
-{
-	struct pt_regs *regs = task_pt_regs(child);
-	regno >>= 2;
-	switch (regno) {
-	case GS:
-		if (value && (value & 3) != 3)
-			return -EIO;
-		child->thread.gs = value;
-		if (child == current)
-			/*
-			 * The user-mode %gs is not affected by
-			 * kernel entry, so we must update the CPU.
-			 */
-			loadsegment(gs, value);
-		return 0;
-	case DS:
-	case ES:
-	case FS:
-		if (value && (value & 3) != 3)
-			return -EIO;
-		value &= 0xffff;
-		break;
-	case SS:
-	case CS:
-		if ((value & 3) != 3)
-			return -EIO;
-		value &= 0xffff;
-		break;
-	case EFL:
-		value &= FLAG_MASK;
-		/*
-		 * If the user value contains TF, mark that
-		 * it was not "us" (the debugger) that set it.
-		 * If not, make sure it stays set if we had.
-		 */
-		if (value & X86_EFLAGS_TF)
-			clear_tsk_thread_flag(child, TIF_FORCED_TF);
-		else if (test_tsk_thread_flag(child, TIF_FORCED_TF))
-			value |= X86_EFLAGS_TF;
-		value |= regs->flags & ~FLAG_MASK;
-		break;
-	}
-	*pt_regs_access(regs, regno) = value;
-	return 0;
-}
-
-static unsigned long getreg(struct task_struct *child, unsigned long regno)
-{
-	struct pt_regs *regs = task_pt_regs(child);
-	unsigned long retval = ~0UL;
-
-	regno >>= 2;
-	switch (regno) {
-	case EFL:
-		/*
-		 * If the debugger set TF, hide it from the readout.
-		 */
-		retval = regs->flags;
-		if (test_tsk_thread_flag(child, TIF_FORCED_TF))
-			retval &= ~X86_EFLAGS_TF;
-		break;
-	case GS:
-		retval = child->thread.gs;
-		if (child == current)
-			savesegment(gs, retval);
-		break;
-	case DS:
-	case ES:
-	case FS:
-	case SS:
-	case CS:
-		retval = 0xffff;
-		/* fall through */
-	default:
-		retval &= *pt_regs_access(regs, regno);
-	}
-	return retval;
-}
-
-/*
- * This function is trivial and will be inlined by the compiler.
- * Having it separates the implementation details of debug
- * registers from the interface details of ptrace.
- */
-static unsigned long ptrace_get_debugreg(struct task_struct *child, int n)
-{
-	switch (n) {
-	case 0:		return child->thread.debugreg0;
-	case 1:		return child->thread.debugreg1;
-	case 2:		return child->thread.debugreg2;
-	case 3:		return child->thread.debugreg3;
-	case 6:		return child->thread.debugreg6;
-	case 7:		return child->thread.debugreg7;
-	}
-	return 0;
-}
-
-static int ptrace_set_debugreg(struct task_struct *child,
-			       int n, unsigned long data)
-{
-	int i;
-
-	if (unlikely(n == 4 || n == 5))
-		return -EIO;
-
-	if (n < 4 && unlikely(data >= TASK_SIZE - 3))
-		return -EIO;
-
-	switch (n) {
-	case 0:		child->thread.debugreg0 = data; break;
-	case 1:		child->thread.debugreg1 = data; break;
-	case 2:		child->thread.debugreg2 = data; break;
-	case 3:		child->thread.debugreg3 = data; break;
-
-	case 6:
-		child->thread.debugreg6 = data;
-		break;
-
-	case 7:
-		/*
-		 * Sanity-check data. Take one half-byte at once with
-		 * check = (val >> (16 + 4*i)) & 0xf. It contains the
-		 * R/Wi and LENi bits; bits 0 and 1 are R/Wi, and bits
-		 * 2 and 3 are LENi. Given a list of invalid values,
-		 * we do mask |= 1 << invalid_value, so that
-		 * (mask >> check) & 1 is a correct test for invalid
-		 * values.
-		 *
-		 * R/Wi contains the type of the breakpoint /
-		 * watchpoint, LENi contains the length of the watched
-		 * data in the watchpoint case.
-		 *
-		 * The invalid values are:
-		 * - LENi == 0x10 (undefined), so mask |= 0x0f00.
-		 * - R/Wi == 0x10 (break on I/O reads or writes), so
-		 *   mask |= 0x4444.
-		 * - R/Wi == 0x00 && LENi != 0x00, so we have mask |=
-		 *   0x1110.
-		 *
-		 * Finally, mask = 0x0f00 | 0x4444 | 0x1110 == 0x5f54.
-		 *
-		 * See the Intel Manual "System Programming Guide",
-		 * 15.2.4
-		 *
-		 * Note that LENi == 0x10 is defined on x86_64 in long
-		 * mode (i.e. even for 32-bit userspace software, but
-		 * 64-bit kernel), so the x86_64 mask value is 0x5454.
-		 * See the AMD manual no. 24593 (AMD64 System Programming)
-		 */
-		data &= ~DR_CONTROL_RESERVED;
-		for (i = 0; i < 4; i++)
-			if ((0x5f54 >> ((data >> (16 + 4*i)) & 0xf)) & 1)
-				return -EIO;
-		child->thread.debugreg7 = data;
-		if (data)
-			set_tsk_thread_flag(child, TIF_DEBUG);
-		else
-			clear_tsk_thread_flag(child, TIF_DEBUG);
-		break;
-	}
-
-	return 0;
-}
-
-/*
- * Called by kernel/ptrace.c when detaching..
- *
- * Make sure the single step bit is not set.
- */
-void ptrace_disable(struct task_struct *child)
-{
-	user_disable_single_step(child);
-	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
-}
-
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
-{
-	struct user * dummy = NULL;
-	int i, ret;
-	unsigned long __user *datap = (unsigned long __user *)data;
-
-	switch (request) {
-	/* when I and D space are separate, these will need to be fixed. */
-	case PTRACE_PEEKTEXT: /* read word at location addr. */
-	case PTRACE_PEEKDATA:
-		ret = generic_ptrace_peekdata(child, addr, data);
-		break;
-
-	/* read the word at location addr in the USER area. */
-	case PTRACE_PEEKUSR: {
-		unsigned long tmp;
-
-		ret = -EIO;
-		if ((addr & 3) || addr < 0 ||
-		    addr > sizeof(struct user) - 3)
-			break;
-
-		tmp = 0;  /* Default return condition */
-		if(addr < FRAME_SIZE*sizeof(long))
-			tmp = getreg(child, addr);
-		if(addr >= (long) &dummy->u_debugreg[0] &&
-		   addr <= (long) &dummy->u_debugreg[7]){
-			addr -= (long) &dummy->u_debugreg[0];
-			addr = addr >> 2;
-			tmp = ptrace_get_debugreg(child, addr);
-		}
-		ret = put_user(tmp, datap);
-		break;
-	}
-
-	/* when I and D space are separate, this will have to be fixed. */
-	case PTRACE_POKETEXT: /* write the word at location addr. */
-	case PTRACE_POKEDATA:
-		ret = generic_ptrace_pokedata(child, addr, data);
-		break;
-
-	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
-		ret = -EIO;
-		if ((addr & 3) || addr < 0 ||
-		    addr > sizeof(struct user) - 3)
-			break;
-
-		if (addr < FRAME_SIZE*sizeof(long)) {
-			ret = putreg(child, addr, data);
-			break;
-		}
-		/* We need to be very careful here.  We implicitly
-		   want to modify a portion of the task_struct, and we
-		   have to be selective about what portions we allow someone
-		   to modify. */
-
-		  ret = -EIO;
-		  if(addr >= (long) &dummy->u_debugreg[0] &&
-		     addr <= (long) &dummy->u_debugreg[7]){
-			  addr -= (long) &dummy->u_debugreg;
-			  addr = addr >> 2;
-			  ret = ptrace_set_debugreg(child, addr, data);
-		  }
-		  break;
-
-	case PTRACE_GETREGS: { /* Get all gp regs from the child. */
-	  	if (!access_ok(VERIFY_WRITE, datap, FRAME_SIZE*sizeof(long))) {
-			ret = -EIO;
-			break;
-		}
-		for ( i = 0; i < FRAME_SIZE*sizeof(long); i += sizeof(long) ) {
-			__put_user(getreg(child, i), datap);
-			datap++;
-		}
-		ret = 0;
-		break;
-	}
-
-	case PTRACE_SETREGS: { /* Set all gp regs in the child. */
-		unsigned long tmp;
-	  	if (!access_ok(VERIFY_READ, datap, FRAME_SIZE*sizeof(long))) {
-			ret = -EIO;
-			break;
-		}
-		for ( i = 0; i < FRAME_SIZE*sizeof(long); i += sizeof(long) ) {
-			__get_user(tmp, datap);
-			putreg(child, i, tmp);
-			datap++;
-		}
-		ret = 0;
-		break;
-	}
-
-	case PTRACE_GETFPREGS: { /* Get the child FPU state. */
-		if (!access_ok(VERIFY_WRITE, datap,
-			       sizeof(struct user_i387_struct))) {
-			ret = -EIO;
-			break;
-		}
-		ret = 0;
-		if (!tsk_used_math(child))
-			init_fpu(child);
-		get_fpregs((struct user_i387_struct __user *)data, child);
-		break;
-	}
-
-	case PTRACE_SETFPREGS: { /* Set the child FPU state. */
-		if (!access_ok(VERIFY_READ, datap,
-			       sizeof(struct user_i387_struct))) {
-			ret = -EIO;
-			break;
-		}
-		set_stopped_child_used_math(child);
-		set_fpregs(child, (struct user_i387_struct __user *)data);
-		ret = 0;
-		break;
-	}
-
-	case PTRACE_GETFPXREGS: { /* Get the child extended FPU state. */
-		if (!access_ok(VERIFY_WRITE, datap,
-			       sizeof(struct user_fxsr_struct))) {
-			ret = -EIO;
-			break;
-		}
-		if (!tsk_used_math(child))
-			init_fpu(child);
-		ret = get_fpxregs((struct user_fxsr_struct __user *)data, child);
-		break;
-	}
-
-	case PTRACE_SETFPXREGS: { /* Set the child extended FPU state. */
-		if (!access_ok(VERIFY_READ, datap,
-			       sizeof(struct user_fxsr_struct))) {
-			ret = -EIO;
-			break;
-		}
-		set_stopped_child_used_math(child);
-		ret = set_fpxregs(child, (struct user_fxsr_struct __user *)data);
-		break;
-	}
-
-	case PTRACE_GET_THREAD_AREA:
-		if (addr < 0)
-			return -EIO;
-		ret = do_get_thread_area(child, addr,
-					 (struct user_desc __user *) data);
-		break;
-
-	case PTRACE_SET_THREAD_AREA:
-		if (addr < 0)
-			return -EIO;
-		ret = do_set_thread_area(child, addr,
-					 (struct user_desc __user *) data, 0);
-		break;
-
-	default:
-		ret = ptrace_request(child, request, addr, data);
-		break;
-	}
-
-	return ret;
-}
-
-void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code)
-{
-	struct siginfo info;
-
-	tsk->thread.trap_no = 1;
-	tsk->thread.error_code = error_code;
-
-	memset(&info, 0, sizeof(info));
-	info.si_signo = SIGTRAP;
-	info.si_code = TRAP_BRKPT;
-
-	/* User-mode ip? */
-	info.si_addr = user_mode_vm(regs) ? (void __user *) regs->ip : NULL;
-
-	/* Send us the fake SIGTRAP */
-	force_sig_info(SIGTRAP, &info, tsk);
-}
-
-/* notification of system call entry/exit
- * - triggered by current->work.syscall_trace
- */
-__attribute__((regparm(3)))
-int do_syscall_trace(struct pt_regs *regs, int entryexit)
-{
-	int is_sysemu = test_thread_flag(TIF_SYSCALL_EMU);
-	/*
-	 * With TIF_SYSCALL_EMU set we want to ignore TIF_SINGLESTEP for syscall
-	 * interception
-	 */
-	int is_singlestep = !is_sysemu && test_thread_flag(TIF_SINGLESTEP);
-	int ret = 0;
-
-	/* do the secure computing check first */
-	if (!entryexit)
-		secure_computing(regs->orig_ax);
-
-	if (unlikely(current->audit_context)) {
-		if (entryexit)
-			audit_syscall_exit(AUDITSC_RESULT(regs->ax),
-						regs->ax);
-		/* Debug traps, when using PTRACE_SINGLESTEP, must be sent only
-		 * on the syscall exit path. Normally, when TIF_SYSCALL_AUDIT is
-		 * not used, entry.S will call us only on syscall exit, not
-		 * entry; so when TIF_SYSCALL_AUDIT is used we must avoid
-		 * calling send_sigtrap() on syscall entry.
-		 *
-		 * Note that when PTRACE_SYSEMU_SINGLESTEP is used,
-		 * is_singlestep is false, despite his name, so we will still do
-		 * the correct thing.
-		 */
-		else if (is_singlestep)
-			goto out;
-	}
-
-	if (!(current->ptrace & PT_PTRACED))
-		goto out;
-
-	/* If a process stops on the 1st tracepoint with SYSCALL_TRACE
-	 * and then is resumed with SYSEMU_SINGLESTEP, it will come in
-	 * here. We have to check this and return */
-	if (is_sysemu && entryexit)
-		return 0;
-
-	/* Fake a debug trap */
-	if (is_singlestep)
-		send_sigtrap(current, regs, 0);
-
- 	if (!test_thread_flag(TIF_SYSCALL_TRACE) && !is_sysemu)
-		goto out;
-
-	/* the 0x80 provides a way for the tracing parent to distinguish
-	   between a syscall stop and SIGTRAP delivery */
-	/* Note that the debugger could change the result of test_thread_flag!*/
-	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD) ? 0x80:0));
-
-	/*
-	 * this isn't the same as continuing with a signal, but it will do
-	 * for normal use.  strace only continues with a signal if the
-	 * stopping signal is not SIGTRAP.  -brl
-	 */
-	if (current->exit_code) {
-		send_sig(current->exit_code, current, 1);
-		current->exit_code = 0;
-	}
-	ret = is_sysemu;
-out:
-	if (unlikely(current->audit_context) && !entryexit)
-		audit_syscall_entry(AUDIT_ARCH_I386, regs->orig_ax,
-				    regs->bx, regs->cx, regs->dx, regs->si);
-	if (ret == 0)
-		return 0;
-
-	regs->orig_ax = -1; /* force skip of syscall restarting */
-	if (unlikely(current->audit_context))
-		audit_syscall_exit(AUDITSC_RESULT(regs->ax), regs->ax);
-	return 1;
-}
