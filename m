Return-Path: <linux-kernel-owner+w=401wt.eu-S932593AbYEGHmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593AbYEGHmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756174AbYEGHmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:42:39 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:10320 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043AbYEGHma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:42:30 -0400
Subject: Please pull git390 'for-linus' branch
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain
Organization: IBM Corporation
Date: Wed, 07 May 2008 09:29:24 +0200
Message-Id: <1210145364.25478.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

 Documentation/s390/CommonIO       |   11 --
 arch/s390/Kconfig                 |    7 +
 arch/s390/kernel/compat_wrapper.S |    2 +-
 arch/s390/kernel/entry.S          |   29 ++--
 arch/s390/kernel/entry64.S        |   57 +++++--
 arch/s390/kernel/ptrace.c         |  100 +-----------
 arch/s390/kvm/Kconfig             |    1 -
 arch/s390/kvm/intercept.c         |    3 +
 arch/s390/kvm/kvm-s390.c          |    5 +-
 arch/s390/mm/Makefile             |    1 +
 arch/s390/mm/init.c               |    3 +
 arch/s390/mm/page-states.c        |   79 +++++++++
 drivers/s390/char/tty3270.c       |   15 +-
 drivers/s390/cio/blacklist.c      |  323 +++++++++++++++++++------------------
 drivers/s390/cio/cio.c            |   39 ++----
 drivers/s390/cio/cio.h            |    2 -
 drivers/s390/cio/cio_debug.h      |    6 -
 drivers/s390/cio/css.c            |    4 +-
 drivers/s390/cio/device.c         |   25 ++--
 drivers/s390/cio/device_fsm.c     |   44 +++---
 drivers/s390/cio/device_id.c      |    4 +-
 drivers/s390/cio/device_pgid.c    |   12 +-
 drivers/s390/s390mach.c           |    3 +-
 include/asm-s390/kvm_host.h       |    1 +
 include/asm-s390/page.h           |   11 ++
 include/asm-s390/ptrace.h         |    2 +
 include/asm-s390/system.h         |    6 +
 27 files changed, 408 insertions(+), 387 deletions(-)
 create mode 100644 arch/s390/mm/page-states.c

Christian Borntraeger (1):
      [S390] s390-kvm: leave sie context on work. Removes preemption requirement

Heiko Carstens (1):
      [S390] tty3270: fix put_char fail/success conversion.

Martin Schwidefsky (3):
      [S390] s390: Optimize user and work TIF check
      [S390] s390mach compile warning
      [S390] guest page hinting light

Michael Ernst (2):
      [S390] cio: Remove cio_msg kernel parameter.
      [S390] cio: Fix parsing mechanism for blacklisted devices.

Roland McGrath (1):
      [S390] compat ptrace cleanup

diff --git a/Documentation/s390/CommonIO b/Documentation/s390/CommonIO
index 8fbc0a8..bf0baa1 100644
--- a/Documentation/s390/CommonIO
+++ b/Documentation/s390/CommonIO
@@ -8,17 +8,6 @@ Command line parameters
 
   Enable logging of debug information in case of ccw device timeouts.
 
-
-* cio_msg = yes | no
-  
-  Determines whether information on found devices and sensed device 
-  characteristics should be shown during startup or when new devices are
-  found, i. e. messages of the types "Detected device 0.0.4711 on subchannel
-  0.0.0042" and "SenseID: Device 0.0.4711 reports: ...".
-
-  Default is off.
-
-
 * cio_ignore = {all} |
 	       {<device> | <range of devices>} |
 	       {!<device> | !<range of devices>}
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 29a7940..1d03508 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -430,6 +430,13 @@ config CMM_IUCV
 	  Select this option to enable the special message interface to
 	  the cooperative memory management.
 
+config PAGE_STATES
+	bool "Unused page notification"
+	help
+	  This enables the notification of unused pages to the
+	  hypervisor. The ESSA instruction is used to do the states
+	  changes between a page that has content and the unused state.
+
 config VIRT_TIMER
 	bool "Virtual CPU timer support"
 	help
diff --git a/arch/s390/kernel/compat_wrapper.S b/arch/s390/kernel/compat_wrapper.S
index 743d54f..d003a6e 100644
--- a/arch/s390/kernel/compat_wrapper.S
+++ b/arch/s390/kernel/compat_wrapper.S
@@ -121,7 +121,7 @@ sys32_ptrace_wrapper:
 	lgfr	%r3,%r3			# long
 	llgtr	%r4,%r4			# long
 	llgfr	%r5,%r5			# long
-	jg	sys_ptrace		# branch to system call
+	jg	compat_sys_ptrace	# branch to system call
 
 	.globl	sys32_alarm_wrapper
 sys32_alarm_wrapper:
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index bdbb3bc..708cf9c 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -279,8 +279,6 @@ sysc_do_restart:
 	st	%r2,SP_R2(%r15)   # store return value (change R2 on stack)
 
 sysc_return:
-	tm	SP_PSW+1(%r15),0x01	# returning to user ?
-	bno	BASED(sysc_restore)
 	tm	__TI_flags+3(%r9),_TIF_WORK_SVC
 	bnz	BASED(sysc_work)  # there is work to do (signals etc.)
 sysc_restore:
@@ -312,6 +310,8 @@ sysc_work_loop:
 # One of the work bits is on. Find out which one.
 #
 sysc_work:
+	tm	SP_PSW+1(%r15),0x01	# returning to user ?
+	bno	BASED(sysc_restore)
 	tm	__TI_flags+3(%r9),_TIF_MCCK_PENDING
 	bo	BASED(sysc_mcck_pending)
 	tm	__TI_flags+3(%r9),_TIF_NEED_RESCHED
@@ -602,12 +602,6 @@ io_no_vtime:
 	la	%r2,SP_PTREGS(%r15)	# address of register-save area
 	basr	%r14,%r1		# branch to standard irq handler
 io_return:
-	tm	SP_PSW+1(%r15),0x01	# returning to user ?
-#ifdef CONFIG_PREEMPT
-	bno	BASED(io_preempt)	# no -> check for preemptive scheduling
-#else
-	bno	BASED(io_restore)	# no-> skip resched & signal
-#endif
 	tm	__TI_flags+3(%r9),_TIF_WORK_INT
 	bnz	BASED(io_work)		# there is work to do (signals etc.)
 io_restore:
@@ -629,10 +623,18 @@ io_restore_trace_psw:
 	.long	0, io_restore_trace + 0x80000000
 #endif
 
-#ifdef CONFIG_PREEMPT
-io_preempt:
+#
+# switch to kernel stack, then check the TIF bits
+#
+io_work:
+	tm	SP_PSW+1(%r15),0x01	# returning to user ?
+#ifndef CONFIG_PREEMPT
+	bno	BASED(io_restore)	# no-> skip resched & signal
+#else
+	bnz	BASED(io_work_user)	# no -> check for preemptive scheduling
+	# check for preemptive scheduling
 	icm	%r0,15,__TI_precount(%r9)
-	bnz	BASED(io_restore)
+	bnz	BASED(io_restore)	# preemption disabled
 	l	%r1,SP_R15(%r15)
 	s	%r1,BASED(.Lc_spsize)
 	mvc	SP_PTREGS(__PT_SIZE,%r1),SP_PTREGS(%r15)
@@ -646,10 +648,7 @@ io_resume_loop:
 	br	%r1			# call schedule
 #endif
 
-#
-# switch to kernel stack, then check the TIF bits
-#
-io_work:
+io_work_user:
 	l	%r1,__LC_KERNEL_STACK
 	s	%r1,BASED(.Lc_spsize)
 	mvc	SP_PTREGS(__PT_SIZE,%r1),SP_PTREGS(%r15)
diff --git a/arch/s390/kernel/entry64.S b/arch/s390/kernel/entry64.S
index 5a4a7bc..fee1017 100644
--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -271,8 +271,6 @@ sysc_noemu:
 	stg	%r2,SP_R2(%r15) # store return value (change R2 on stack)
 
 sysc_return:
-	tm	SP_PSW+1(%r15),0x01	# returning to user ?
-	jno	sysc_restore
 	tm	__TI_flags+7(%r9),_TIF_WORK_SVC
 	jnz	sysc_work	# there is work to do (signals etc.)
 sysc_restore:
@@ -304,6 +302,8 @@ sysc_work_loop:
 # One of the work bits is on. Find out which one.
 #
 sysc_work:
+	tm	SP_PSW+1(%r15),0x01	# returning to user ?
+	jno	sysc_restore
 	tm	__TI_flags+7(%r9),_TIF_MCCK_PENDING
 	jo	sysc_mcck_pending
 	tm	__TI_flags+7(%r9),_TIF_NEED_RESCHED
@@ -585,12 +585,6 @@ io_no_vtime:
 	la	%r2,SP_PTREGS(%r15)	# address of register-save area
 	brasl	%r14,do_IRQ		# call standard irq handler
 io_return:
-	tm	SP_PSW+1(%r15),0x01	# returning to user ?
-#ifdef CONFIG_PREEMPT
-	jno	io_preempt		# no -> check for preemptive scheduling
-#else
-	jno	io_restore		# no-> skip resched & signal
-#endif
 	tm	__TI_flags+7(%r9),_TIF_WORK_INT
 	jnz	io_work 		# there is work to do (signals etc.)
 io_restore:
@@ -612,10 +606,41 @@ io_restore_trace_psw:
 	.quad	0, io_restore_trace
 #endif
 
-#ifdef CONFIG_PREEMPT
-io_preempt:
+#
+# There is work todo, we need to check if we return to userspace, then
+# check, if we are in SIE, if yes leave it
+#
+io_work:
+	tm	SP_PSW+1(%r15),0x01	# returning to user ?
+#ifndef CONFIG_PREEMPT
+#if defined(CONFIG_KVM) || defined(CONFIG_KVM_MODULE)
+	jnz	io_work_user		# yes -> no need to check for SIE
+	la	%r1, BASED(sie_opcode)	# we return to kernel here
+	lg	%r2, SP_PSW+8(%r15)
+	clc	0(2,%r1), 0(%r2)	# is current instruction = SIE?
+	jne	io_restore		# no-> return to kernel
+	lg	%r1, SP_PSW+8(%r15)	# yes-> add 4 bytes to leave SIE
+	aghi	%r1, 4
+	stg	%r1, SP_PSW+8(%r15)
+	j	io_restore		# return to kernel
+#else
+	jno	io_restore		# no-> skip resched & signal
+#endif
+#else
+	jnz	io_work_user		# yes -> do resched & signal
+#if defined(CONFIG_KVM) || defined(CONFIG_KVM_MODULE)
+	la	%r1, BASED(sie_opcode)
+	lg	%r2, SP_PSW+8(%r15)
+	clc	0(2,%r1), 0(%r2)	# is current instruction = SIE?
+	jne	0f			# no -> leave PSW alone
+	lg	%r1, SP_PSW+8(%r15)	# yes-> add 4 bytes to leave SIE
+	aghi	%r1, 4
+	stg	%r1, SP_PSW+8(%r15)
+0:
+#endif
+	# check for preemptive scheduling
 	icm	%r0,15,__TI_precount(%r9)
-	jnz	io_restore
+	jnz	io_restore		# preemption is disabled
 	# switch to kernel stack
 	lg	%r1,SP_R15(%r15)
 	aghi	%r1,-SP_SIZE
@@ -629,10 +654,7 @@ io_resume_loop:
 	jg	preempt_schedule_irq
 #endif
 
-#
-# switch to kernel stack, then check TIF bits
-#
-io_work:
+io_work_user:
 	lg	%r1,__LC_KERNEL_STACK
 	aghi	%r1,-SP_SIZE
 	mvc	SP_PTREGS(__PT_SIZE,%r1),SP_PTREGS(%r15)
@@ -653,6 +675,11 @@ io_work_loop:
 	j	io_restore
 io_work_done:
 
+#if defined(CONFIG_KVM) || defined(CONFIG_KVM_MODULE)
+sie_opcode:
+	.long 0xb2140000
+#endif
+
 #
 # _TIF_MCCK_PENDING is set, call handler
 #
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 7f42701..35827b9 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -292,8 +292,7 @@ poke_user(struct task_struct *child, addr_t addr, addr_t data)
 	return 0;
 }
 
-static int
-do_ptrace_normal(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
 	ptrace_area parea; 
 	int copied, ret;
@@ -529,35 +528,19 @@ poke_user_emu31(struct task_struct *child, addr_t addr, addr_t data)
 	return 0;
 }
 
-static int
-do_ptrace_emu31(struct task_struct *child, long request, long addr, long data)
+long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
+			compat_ulong_t caddr, compat_ulong_t cdata)
 {
-	unsigned int tmp;  /* 4 bytes !! */
+	unsigned long addr = caddr;
+	unsigned long data = cdata;
 	ptrace_area_emu31 parea; 
 	int copied, ret;
 
 	switch (request) {
-	case PTRACE_PEEKTEXT:
-	case PTRACE_PEEKDATA:
-		/* read word at location addr. */
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		if (copied != sizeof(tmp))
-			return -EIO;
-		return put_user(tmp, (unsigned int __force __user *) data);
-
 	case PTRACE_PEEKUSR:
 		/* read the word at location addr in the USER area. */
 		return peek_user_emu31(child, addr, data);
 
-	case PTRACE_POKETEXT:
-	case PTRACE_POKEDATA:
-		/* write the word at location addr. */
-		tmp = data;
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 1);
-		if (copied != sizeof(tmp))
-			return -EIO;
-		return 0;
-
 	case PTRACE_POKEUSR:
 		/* write the word at location addr in the USER area */
 		return poke_user_emu31(child, addr, data);
@@ -587,82 +570,11 @@ do_ptrace_emu31(struct task_struct *child, long request, long addr, long data)
 			copied += sizeof(unsigned int);
 		}
 		return 0;
-	case PTRACE_GETEVENTMSG:
-		return put_user((__u32) child->ptrace_message,
-				(unsigned int __force __user *) data);
-	case PTRACE_GETSIGINFO:
-		if (child->last_siginfo == NULL)
-			return -EINVAL;
-		return copy_siginfo_to_user32((compat_siginfo_t
-					       __force __user *) data,
-					      child->last_siginfo);
-	case PTRACE_SETSIGINFO:
-		if (child->last_siginfo == NULL)
-			return -EINVAL;
-		return copy_siginfo_from_user32(child->last_siginfo,
-						(compat_siginfo_t
-						 __force __user *) data);
 	}
-	return ptrace_request(child, request, addr, data);
+	return compat_ptrace_request(child, request, addr, data);
 }
 #endif
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
-{
-	switch (request) {
-	case PTRACE_SYSCALL:
-		/* continue and stop at next (return from) syscall */
-	case PTRACE_CONT:
-		/* restart after signal. */
-		if (!valid_signal(data))
-			return -EIO;
-		if (request == PTRACE_SYSCALL)
-			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		else
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		child->exit_code = data;
-		/* make sure the single step bit is not set. */
-		user_disable_single_step(child);
-		wake_up_process(child);
-		return 0;
-
-	case PTRACE_KILL:
-		/*
-		 * make the child exit.  Best I can do is send it a sigkill. 
-		 * perhaps it should be put in the status that it wants to 
-		 * exit.
-		 */
-		if (child->exit_state == EXIT_ZOMBIE) /* already dead */
-			return 0;
-		child->exit_code = SIGKILL;
-		/* make sure the single step bit is not set. */
-		user_disable_single_step(child);
-		wake_up_process(child);
-		return 0;
-
-	case PTRACE_SINGLESTEP:
-		/* set the trap flag. */
-		if (!valid_signal(data))
-			return -EIO;
-		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		child->exit_code = data;
-		user_enable_single_step(child);
-		/* give it a chance to run. */
-		wake_up_process(child);
-		return 0;
-
-	/* Do requests that differ for 31/64 bit */
-	default:
-#ifdef CONFIG_COMPAT
-		if (test_thread_flag(TIF_31BIT))
-			return do_ptrace_emu31(child, request, addr, data);
-#endif
-		return do_ptrace_normal(child, request, addr, data);
-	}
-	/* Not reached.  */
-	return -EIO;
-}
-
 asmlinkage void
 syscall_trace(struct pt_regs *regs, int entryexit)
 {
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index 1761b74..e051cad 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -22,7 +22,6 @@ config KVM
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	select S390_SWITCH_AMODE
-	select PREEMPT
 	---help---
 	  Support hosting paravirtualized guest machines using the SIE
 	  virtualization capability on the mainframe. This should work
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 349581a..47a0b64 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -105,6 +105,9 @@ static intercept_handler_t instruction_handlers[256] = {
 static int handle_noop(struct kvm_vcpu *vcpu)
 {
 	switch (vcpu->arch.sie_block->icptcode) {
+	case 0x0:
+		vcpu->stat.exit_null++;
+		break;
 	case 0x10:
 		vcpu->stat.exit_external_request++;
 		break;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 98d1e73..0ac36a6 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -31,6 +31,7 @@
 
 struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "userspace_handled", VCPU_STAT(exit_userspace) },
+	{ "exit_null", VCPU_STAT(exit_null) },
 	{ "exit_validity", VCPU_STAT(exit_validity) },
 	{ "exit_stop_request", VCPU_STAT(exit_stop_request) },
 	{ "exit_external_request", VCPU_STAT(exit_external_request) },
@@ -221,10 +222,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	vcpu->arch.guest_fpregs.fpc &= FPC_VALID_MASK;
 	restore_fp_regs(&vcpu->arch.guest_fpregs);
 	restore_access_regs(vcpu->arch.guest_acrs);
-
-	if (signal_pending(current))
-		atomic_set_mask(CPUSTAT_STOP_INT,
-			&vcpu->arch.sie_block->cpuflags);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
diff --git a/arch/s390/mm/Makefile b/arch/s390/mm/Makefile
index fb988a4..2a74581 100644
--- a/arch/s390/mm/Makefile
+++ b/arch/s390/mm/Makefile
@@ -5,3 +5,4 @@
 obj-y	 := init.o fault.o extmem.o mmap.o vmem.o pgtable.o
 obj-$(CONFIG_CMM) += cmm.o
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
+obj-$(CONFIG_PAGE_STATES) += page-states.o
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index fa31de6..29f3a63 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -126,6 +126,9 @@ void __init mem_init(void)
         /* clear the zero-page */
         memset(empty_zero_page, 0, PAGE_SIZE);
 
+	/* Setup guest page hinting */
+	cmma_init();
+
 	/* this will put all low memory onto the freelists */
 	totalram_pages += free_all_bootmem();
 
diff --git a/arch/s390/mm/page-states.c b/arch/s390/mm/page-states.c
new file mode 100644
index 0000000..fc0ad73
--- /dev/null
+++ b/arch/s390/mm/page-states.c
@@ -0,0 +1,79 @@
+/*
+ * arch/s390/mm/page-states.c
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * Guest page hinting for unused pages.
+ *
+ * Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/init.h>
+
+#define ESSA_SET_STABLE		1
+#define ESSA_SET_UNUSED		2
+
+static int cmma_flag;
+
+static int __init cmma(char *str)
+{
+	char *parm;
+	parm = strstrip(str);
+	if (strcmp(parm, "yes") == 0 || strcmp(parm, "on") == 0) {
+		cmma_flag = 1;
+		return 1;
+	}
+	cmma_flag = 0;
+	if (strcmp(parm, "no") == 0 || strcmp(parm, "off") == 0)
+		return 1;
+	return 0;
+}
+
+__setup("cmma=", cmma);
+
+void __init cmma_init(void)
+{
+	register unsigned long tmp asm("0") = 0;
+	register int rc asm("1") = -EOPNOTSUPP;
+
+	if (!cmma_flag)
+		return;
+	asm volatile(
+		"       .insn rrf,0xb9ab0000,%1,%1,0,0\n"
+		"0:     la      %0,0\n"
+		"1:\n"
+		EX_TABLE(0b,1b)
+		: "+&d" (rc), "+&d" (tmp));
+	if (rc)
+		cmma_flag = 0;
+}
+
+void arch_free_page(struct page *page, int order)
+{
+	int i, rc;
+
+	if (!cmma_flag)
+		return;
+	for (i = 0; i < (1 << order); i++)
+		asm volatile(".insn rrf,0xb9ab0000,%0,%1,%2,0"
+			     : "=&d" (rc)
+			     : "a" ((page_to_pfn(page) + i) << PAGE_SHIFT),
+			       "i" (ESSA_SET_UNUSED));
+}
+
+void arch_alloc_page(struct page *page, int order)
+{
+	int i, rc;
+
+	if (!cmma_flag)
+		return;
+	for (i = 0; i < (1 << order); i++)
+		asm volatile(".insn rrf,0xb9ab0000,%0,%1,%2,0"
+			     : "=&d" (rc)
+			     : "a" ((page_to_pfn(page) + i) << PAGE_SHIFT),
+			       "i" (ESSA_SET_STABLE));
+}
diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index c1f2ade..5043150 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -965,8 +965,7 @@ tty3270_write_room(struct tty_struct *tty)
  * Insert character into the screen at the current position with the
  * current color and highlight. This function does NOT do cursor movement.
  */
-static int
-tty3270_put_character(struct tty3270 *tp, char ch)
+static void tty3270_put_character(struct tty3270 *tp, char ch)
 {
 	struct tty3270_line *line;
 	struct tty3270_cell *cell;
@@ -986,7 +985,6 @@ tty3270_put_character(struct tty3270 *tp, char ch)
 	cell->character = tp->view.ascebc[(unsigned int) ch];
 	cell->highlight = tp->highlight;
 	cell->f_color = tp->f_color;
-	return 1;
 }
 
 /*
@@ -1612,16 +1610,15 @@ tty3270_write(struct tty_struct * tty,
 /*
  * Put single characters to the ttys character buffer
  */
-static void
-tty3270_put_char(struct tty_struct *tty, unsigned char ch)
+static int tty3270_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct tty3270 *tp;
 
 	tp = tty->driver_data;
-	if (!tp)
-		return;
-	if (tp->char_count < TTY3270_CHAR_BUF_SIZE)
-		tp->char_buf[tp->char_count++] = ch;
+	if (!tp || tp->char_count >= TTY3270_CHAR_BUF_SIZE)
+		return 0;
+	tp->char_buf[tp->char_count++] = ch;
+	return 1;
 }
 
 /*
diff --git a/drivers/s390/cio/blacklist.c b/drivers/s390/cio/blacklist.c
index 40ef948..9c21b8f 100644
--- a/drivers/s390/cio/blacklist.c
+++ b/drivers/s390/cio/blacklist.c
@@ -19,6 +19,7 @@
 
 #include <asm/cio.h>
 #include <asm/uaccess.h>
+#include <asm/cio.h>
 
 #include "blacklist.h"
 #include "cio.h"
@@ -43,164 +44,169 @@ typedef enum {add, free} range_action;
  * Function: blacklist_range
  * (Un-)blacklist the devices from-to
  */
-static void
-blacklist_range (range_action action, unsigned int from, unsigned int to,
-		 unsigned int ssid)
+static int blacklist_range(range_action action, unsigned int from_ssid,
+			   unsigned int to_ssid, unsigned int from,
+			   unsigned int to, int msgtrigger)
 {
-	if (!to)
-		to = from;
-
-	if (from > to || to > __MAX_SUBCHANNEL || ssid > __MAX_SSID) {
-		printk (KERN_WARNING "cio: Invalid blacklist range "
-			"0.%x.%04x to 0.%x.%04x, skipping\n",
-			ssid, from, ssid, to);
-		return;
+	if ((from_ssid > to_ssid) || ((from_ssid == to_ssid) && (from > to))) {
+		if (msgtrigger)
+			printk(KERN_WARNING "cio: Invalid cio_ignore range "
+			       "0.%x.%04x-0.%x.%04x\n", from_ssid, from,
+			       to_ssid, to);
+		return 1;
 	}
-	for (; from <= to; from++) {
+
+	while ((from_ssid < to_ssid) || ((from_ssid == to_ssid) &&
+	       (from <= to))) {
 		if (action == add)
-			set_bit (from, bl_dev[ssid]);
+			set_bit(from, bl_dev[from_ssid]);
 		else
-			clear_bit (from, bl_dev[ssid]);
+			clear_bit(from, bl_dev[from_ssid]);
+		from++;
+		if (from > __MAX_SUBCHANNEL) {
+			from_ssid++;
+			from = 0;
+		}
 	}
+
+	return 0;
 }
 
-/*
- * Function: blacklist_busid
- * Get devno/busid from given string.
- * Shamelessly grabbed from dasd_devmap.c.
- */
-static int
-blacklist_busid(char **str, int *id0, int *ssid, int *devno)
+static int pure_hex(char **cp, unsigned int *val, int min_digit,
+		    int max_digit, int max_val)
 {
-	int val, old_style;
-	char *sav;
+	int diff;
+	unsigned int value;
 
-	sav = *str;
+	diff = 0;
+	*val = 0;
 
-	/* check for leading '0x' */
-	old_style = 0;
-	if ((*str)[0] == '0' && (*str)[1] == 'x') {
-		*str += 2;
-		old_style = 1;
-	}
-	if (!isxdigit((*str)[0]))	/* We require at least one hex digit */
-		goto confused;
-	val = simple_strtoul(*str, str, 16);
-	if (old_style || (*str)[0] != '.') {
-		*id0 = *ssid = 0;
-		if (val < 0 || val > 0xffff)
-			goto confused;
-		*devno = val;
-		if ((*str)[0] != ',' && (*str)[0] != '-' &&
-		    (*str)[0] != '\n' && (*str)[0] != '\0')
-			goto confused;
-		return 0;
+	while (isxdigit(**cp) && (diff <= max_digit)) {
+
+		if (isdigit(**cp))
+			value = **cp - '0';
+		else
+			value = tolower(**cp) - 'a' + 10;
+		*val = *val * 16 + value;
+		(*cp)++;
+		diff++;
 	}
-	/* New style x.y.z busid */
-	if (val < 0 || val > 0xff)
-		goto confused;
-	*id0 = val;
-	(*str)++;
-	if (!isxdigit((*str)[0]))	/* We require at least one hex digit */
-		goto confused;
-	val = simple_strtoul(*str, str, 16);
-	if (val < 0 || val > 0xff || (*str)++[0] != '.')
-		goto confused;
-	*ssid = val;
-	if (!isxdigit((*str)[0]))	/* We require at least one hex digit */
-		goto confused;
-	val = simple_strtoul(*str, str, 16);
-	if (val < 0 || val > 0xffff)
-		goto confused;
-	*devno = val;
-	if ((*str)[0] != ',' && (*str)[0] != '-' &&
-	    (*str)[0] != '\n' && (*str)[0] != '\0')
-		goto confused;
+
+	if ((diff < min_digit) || (diff > max_digit) || (*val > max_val))
+		return 1;
+
 	return 0;
-confused:
-	strsep(str, ",\n");
-	printk(KERN_WARNING "cio: Invalid cio_ignore parameter '%s'\n", sav);
-	return 1;
 }
 
-static int
-blacklist_parse_parameters (char *str, range_action action)
+static int parse_busid(char *str, int *cssid, int *ssid, int *devno,
+		       int msgtrigger)
 {
-	int from, to, from_id0, to_id0, from_ssid, to_ssid;
-
-	while (*str != 0 && *str != '\n') {
-		range_action ra = action;
-		while(*str == ',')
-			str++;
-		if (*str == '!') {
-			ra = !action;
-			++str;
+	char *str_work;
+	int val, rc, ret;
+
+	rc = 1;
+
+	if (*str == '\0')
+		goto out;
+
+	/* old style */
+	str_work = str;
+	val = simple_strtoul(str, &str_work, 16);
+
+	if (*str_work == '\0') {
+		if (val <= __MAX_SUBCHANNEL) {
+			*devno = val;
+			*ssid = 0;
+			*cssid = 0;
+			rc = 0;
 		}
+		goto out;
+	}
 
-		/*
-		 * Since we have to parse the proc commands and the
-		 * kernel arguments we have to check four cases
-		 */
-		if (strncmp(str,"all,",4) == 0 || strcmp(str,"all") == 0 ||
-		    strncmp(str,"all\n",4) == 0 || strncmp(str,"all ",4) == 0) {
-			int j;
-
-			str += 3;
-			for (j=0; j <= __MAX_SSID; j++)
-				blacklist_range(ra, 0, __MAX_SUBCHANNEL, j);
-		} else {
-			int rc;
+	/* new style */
+	str_work = str;
+	ret = pure_hex(&str_work, cssid, 1, 2, __MAX_CSSID);
+	if (ret || (str_work[0] != '.'))
+		goto out;
+	str_work++;
+	ret = pure_hex(&str_work, ssid, 1, 1, __MAX_SSID);
+	if (ret || (str_work[0] != '.'))
+		goto out;
+	str_work++;
+	ret = pure_hex(&str_work, devno, 4, 4, __MAX_SUBCHANNEL);
+	if (ret || (str_work[0] != '\0'))
+		goto out;
+
+	rc = 0;
+out:
+	if (rc && msgtrigger)
+		printk(KERN_WARNING "cio: Invalid cio_ignore device '%s'\n",
+		       str);
+
+	return rc;
+}
 
-			rc = blacklist_busid(&str, &from_id0,
-					     &from_ssid, &from);
-			if (rc)
-				continue;
-			to = from;
-			to_id0 = from_id0;
-			to_ssid = from_ssid;
-			if (*str == '-') {
-				str++;
-				rc = blacklist_busid(&str, &to_id0,
-						     &to_ssid, &to);
-				if (rc)
-					continue;
-			}
-			if (*str == '-') {
-				printk(KERN_WARNING "cio: invalid cio_ignore "
-					"parameter '%s'\n",
-					strsep(&str, ",\n"));
-				continue;
-			}
-			if ((from_id0 != to_id0) ||
-			    (from_ssid != to_ssid)) {
-				printk(KERN_WARNING "cio: invalid cio_ignore "
-				       "range %x.%x.%04x-%x.%x.%04x\n",
-				       from_id0, from_ssid, from,
-				       to_id0, to_ssid, to);
-				continue;
+static int blacklist_parse_parameters(char *str, range_action action,
+				      int msgtrigger)
+{
+	int from_cssid, to_cssid, from_ssid, to_ssid, from, to;
+	int rc, totalrc;
+	char *parm;
+	range_action ra;
+
+	totalrc = 0;
+
+	while ((parm = strsep(&str, ","))) {
+		rc = 0;
+		ra = action;
+		if (*parm == '!') {
+			if (ra == add)
+				ra = free;
+			else
+				ra = add;
+			parm++;
+		}
+		if (strcmp(parm, "all") == 0) {
+			from_cssid = 0;
+			from_ssid = 0;
+			from = 0;
+			to_cssid = __MAX_CSSID;
+			to_ssid = __MAX_SSID;
+			to = __MAX_SUBCHANNEL;
+		} else {
+			rc = parse_busid(strsep(&parm, "-"), &from_cssid,
+					 &from_ssid, &from, msgtrigger);
+			if (!rc) {
+				if (parm != NULL)
+					rc = parse_busid(parm, &to_cssid,
+							 &to_ssid, &to,
+							 msgtrigger);
+				else {
+					to_cssid = from_cssid;
+					to_ssid = from_ssid;
+					to = from;
+				}
 			}
-			blacklist_range (ra, from, to, to_ssid);
 		}
+		if (!rc) {
+			rc = blacklist_range(ra, from_ssid, to_ssid, from, to,
+					     msgtrigger);
+			if (rc)
+				totalrc = 1;
+		} else
+			totalrc = 1;
 	}
-	return 1;
+
+	return totalrc;
 }
 
-/* Parsing the commandline for blacklist parameters, e.g. to blacklist
- * bus ids 0.0.1234, 0.0.1235 and 0.0.1236, you could use any of:
- * - cio_ignore=1234-1236
- * - cio_ignore=0x1234-0x1235,1236
- * - cio_ignore=0x1234,1235-1236
- * - cio_ignore=1236 cio_ignore=1234-0x1236
- * - cio_ignore=1234 cio_ignore=1236 cio_ignore=0x1235
- * - cio_ignore=0.0.1234-0.0.1236
- * - cio_ignore=0.0.1234,0x1235,1236
- * - ...
- */
 static int __init
 blacklist_setup (char *str)
 {
 	CIO_MSG_EVENT(6, "Reading blacklist parameters\n");
-	return blacklist_parse_parameters (str, add);
+	if (blacklist_parse_parameters(str, add, 1))
+		return 0;
+	return 1;
 }
 
 __setup ("cio_ignore=", blacklist_setup);
@@ -224,27 +230,23 @@ is_blacklisted (int ssid, int devno)
  * Function: blacklist_parse_proc_parameters
  * parse the stuff which is piped to /proc/cio_ignore
  */
-static void
-blacklist_parse_proc_parameters (char *buf)
+static int blacklist_parse_proc_parameters(char *buf)
 {
-	if (strncmp (buf, "free ", 5) == 0) {
-		blacklist_parse_parameters (buf + 5, free);
-	} else if (strncmp (buf, "add ", 4) == 0) {
-		/* 
-		 * We don't need to check for known devices since
-		 * css_probe_device will handle this correctly. 
-		 */
-		blacklist_parse_parameters (buf + 4, add);
-	} else {
-		printk (KERN_WARNING "cio: cio_ignore: Parse error; \n"
-			KERN_WARNING "try using 'free all|<devno-range>,"
-				     "<devno-range>,...'\n"
-			KERN_WARNING "or 'add <devno-range>,"
-				     "<devno-range>,...'\n");
-		return;
-	}
+	int rc;
+	char *parm;
+
+	parm = strsep(&buf, " ");
+
+	if (strcmp("free", parm) == 0)
+		rc = blacklist_parse_parameters(buf, free, 0);
+	else if (strcmp("add", parm) == 0)
+		rc = blacklist_parse_parameters(buf, add, 0);
+	else
+		return 1;
 
 	css_schedule_reprobe();
+
+	return rc;
 }
 
 /* Iterator struct for all devices. */
@@ -328,6 +330,8 @@ cio_ignore_write(struct file *file, const char __user *user_buf,
 		 size_t user_len, loff_t *offset)
 {
 	char *buf;
+	size_t i;
+	ssize_t rc, ret;
 
 	if (*offset)
 		return -EINVAL;
@@ -336,16 +340,27 @@ cio_ignore_write(struct file *file, const char __user *user_buf,
 	buf = vmalloc (user_len + 1); /* maybe better use the stack? */
 	if (buf == NULL)
 		return -ENOMEM;
+	memset(buf, 0, user_len + 1);
+
 	if (strncpy_from_user (buf, user_buf, user_len) < 0) {
-		vfree (buf);
-		return -EFAULT;
+		rc = -EFAULT;
+		goto out_free;
 	}
-	buf[user_len] = '\0';
 
-	blacklist_parse_proc_parameters (buf);
+	i = user_len - 1;
+	while ((i >= 0) && (isspace(buf[i]) || (buf[i] == 0))) {
+		buf[i] = '\0';
+		i--;
+	}
+	ret = blacklist_parse_proc_parameters(buf);
+	if (ret)
+		rc = -EINVAL;
+	else
+		rc = user_len;
 
+out_free:
 	vfree (buf);
-	return user_len;
+	return rc;
 }
 
 static const struct seq_operations cio_ignore_proc_seq_ops = {
diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index 08a5781..82c6a2d 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -39,23 +39,6 @@ debug_info_t *cio_debug_msg_id;
 debug_info_t *cio_debug_trace_id;
 debug_info_t *cio_debug_crw_id;
 
-int cio_show_msg;
-
-static int __init
-cio_setup (char *parm)
-{
-	if (!strcmp (parm, "yes"))
-		cio_show_msg = 1;
-	else if (!strcmp (parm, "no"))
-		cio_show_msg = 0;
-	else
-		printk(KERN_ERR "cio: cio_setup: "
-		       "invalid cio_msg parameter '%s'", parm);
-	return 1;
-}
-
-__setup ("cio_msg=", cio_setup);
-
 /*
  * Function: cio_debug_init
  * Initializes three debug logs for common I/O:
@@ -166,7 +149,7 @@ cio_start_handle_notoper(struct subchannel *sch, __u8 lpm)
 
 	stsch (sch->schid, &sch->schib);
 
-	CIO_MSG_EVENT(0, "cio_start: 'not oper' status for "
+	CIO_MSG_EVENT(2, "cio_start: 'not oper' status for "
 		      "subchannel 0.%x.%04x!\n", sch->schid.ssid,
 		      sch->schid.sch_no);
 	sprintf(dbf_text, "no%s", sch->dev.bus_id);
@@ -567,10 +550,9 @@ cio_validate_subchannel (struct subchannel *sch, struct subchannel_id schid)
 	 * ... just being curious we check for non I/O subchannels
 	 */
 	if (sch->st != 0) {
-		CIO_DEBUG(KERN_INFO, 0,
-			  "Subchannel 0.%x.%04x reports "
-			  "non-I/O subchannel type %04X\n",
-			  sch->schid.ssid, sch->schid.sch_no, sch->st);
+		CIO_MSG_EVENT(4, "Subchannel 0.%x.%04x reports "
+			      "non-I/O subchannel type %04X\n",
+			      sch->schid.ssid, sch->schid.sch_no, sch->st);
 		/* We stop here for non-io subchannels. */
 		err = sch->st;
 		goto out;
@@ -588,7 +570,7 @@ cio_validate_subchannel (struct subchannel *sch, struct subchannel_id schid)
 		 * This device must not be known to Linux. So we simply
 		 * say that there is no device and return ENODEV.
 		 */
-		CIO_MSG_EVENT(4, "Blacklisted device detected "
+		CIO_MSG_EVENT(6, "Blacklisted device detected "
 			      "at devno %04X, subchannel set %x\n",
 			      sch->schib.pmcw.dev, sch->schid.ssid);
 		err = -ENODEV;
@@ -601,12 +583,11 @@ cio_validate_subchannel (struct subchannel *sch, struct subchannel_id schid)
 	sch->lpm = sch->schib.pmcw.pam & sch->opm;
 	sch->isc = 3;
 
-	CIO_DEBUG(KERN_INFO, 0,
-		  "Detected device %04x on subchannel 0.%x.%04X"
-		  " - PIM = %02X, PAM = %02X, POM = %02X\n",
-		  sch->schib.pmcw.dev, sch->schid.ssid,
-		  sch->schid.sch_no, sch->schib.pmcw.pim,
-		  sch->schib.pmcw.pam, sch->schib.pmcw.pom);
+	CIO_MSG_EVENT(6, "Detected device %04x on subchannel 0.%x.%04X "
+		      "- PIM = %02X, PAM = %02X, POM = %02X\n",
+		      sch->schib.pmcw.dev, sch->schid.ssid,
+		      sch->schid.sch_no, sch->schib.pmcw.pim,
+		      sch->schib.pmcw.pam, sch->schib.pmcw.pom);
 
 	/*
 	 * We now have to initially ...
diff --git a/drivers/s390/cio/cio.h b/drivers/s390/cio/cio.h
index 3c75412..6e933ae 100644
--- a/drivers/s390/cio/cio.h
+++ b/drivers/s390/cio/cio.h
@@ -118,6 +118,4 @@ extern void *cio_get_console_priv(void);
 #define cio_get_console_priv() NULL
 #endif
 
-extern int cio_show_msg;
-
 #endif
diff --git a/drivers/s390/cio/cio_debug.h b/drivers/s390/cio/cio_debug.h
index d7429ef..e64e827 100644
--- a/drivers/s390/cio/cio_debug.h
+++ b/drivers/s390/cio/cio_debug.h
@@ -31,10 +31,4 @@ static inline void CIO_HEX_EVENT(int level, void *data, int length)
 	}
 }
 
-#define CIO_DEBUG(printk_level, event_level, msg...) do {	\
-		if (cio_show_msg)				\
-			printk(printk_level "cio: " msg);	\
-		CIO_MSG_EVENT(event_level, msg);		\
-	} while (0)
-
 #endif
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index 595e327..a769565 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -570,7 +570,7 @@ static void reprobe_all(struct work_struct *unused)
 {
 	int ret;
 
-	CIO_MSG_EVENT(2, "reprobe start\n");
+	CIO_MSG_EVENT(4, "reprobe start\n");
 
 	need_reprobe = 0;
 	/* Make sure initial subchannel scan is done. */
@@ -578,7 +578,7 @@ static void reprobe_all(struct work_struct *unused)
 		   atomic_read(&ccw_device_init_count) == 0);
 	ret = for_each_subchannel_staged(NULL, reprobe_subchannel, NULL);
 
-	CIO_MSG_EVENT(2, "reprobe done (rc=%d, need_reprobe=%d)\n", ret,
+	CIO_MSG_EVENT(4, "reprobe done (rc=%d, need_reprobe=%d)\n", ret,
 		      need_reprobe);
 }
 
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index abfd601..e22813d 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -341,7 +341,7 @@ ccw_device_remove_disconnected(struct ccw_device *cdev)
 		rc = device_schedule_callback(&cdev->dev,
 					      ccw_device_remove_orphan_cb);
 		if (rc)
-			CIO_MSG_EVENT(2, "Couldn't unregister orphan "
+			CIO_MSG_EVENT(0, "Couldn't unregister orphan "
 				      "0.%x.%04x\n",
 				      cdev->private->dev_id.ssid,
 				      cdev->private->dev_id.devno);
@@ -351,7 +351,7 @@ ccw_device_remove_disconnected(struct ccw_device *cdev)
 	rc = device_schedule_callback(cdev->dev.parent,
 				      ccw_device_remove_sch_cb);
 	if (rc)
-		CIO_MSG_EVENT(2, "Couldn't unregister disconnected device "
+		CIO_MSG_EVENT(0, "Couldn't unregister disconnected device "
 			      "0.%x.%04x\n",
 			      cdev->private->dev_id.ssid,
 			      cdev->private->dev_id.devno);
@@ -397,7 +397,7 @@ int ccw_device_set_offline(struct ccw_device *cdev)
 	if (ret == 0)
 		wait_event(cdev->private->wait_q, dev_fsm_final_state(cdev));
 	else {
-		CIO_MSG_EVENT(2, "ccw_device_offline returned %d, "
+		CIO_MSG_EVENT(0, "ccw_device_offline returned %d, "
 			      "device 0.%x.%04x\n",
 			      ret, cdev->private->dev_id.ssid,
 			      cdev->private->dev_id.devno);
@@ -433,7 +433,7 @@ int ccw_device_set_online(struct ccw_device *cdev)
 	if (ret == 0)
 		wait_event(cdev->private->wait_q, dev_fsm_final_state(cdev));
 	else {
-		CIO_MSG_EVENT(2, "ccw_device_online returned %d, "
+		CIO_MSG_EVENT(0, "ccw_device_online returned %d, "
 			      "device 0.%x.%04x\n",
 			      ret, cdev->private->dev_id.ssid,
 			      cdev->private->dev_id.devno);
@@ -451,7 +451,7 @@ int ccw_device_set_online(struct ccw_device *cdev)
 	if (ret == 0)
 		wait_event(cdev->private->wait_q, dev_fsm_final_state(cdev));
 	else
-		CIO_MSG_EVENT(2, "ccw_device_offline returned %d, "
+		CIO_MSG_EVENT(0, "ccw_device_offline returned %d, "
 			      "device 0.%x.%04x\n",
 			      ret, cdev->private->dev_id.ssid,
 			      cdev->private->dev_id.devno);
@@ -803,7 +803,7 @@ static void sch_attach_disconnected_device(struct subchannel *sch,
 	other_sch = to_subchannel(get_device(cdev->dev.parent));
 	ret = device_move(&cdev->dev, &sch->dev);
 	if (ret) {
-		CIO_MSG_EVENT(2, "Moving disconnected device 0.%x.%04x failed "
+		CIO_MSG_EVENT(0, "Moving disconnected device 0.%x.%04x failed "
 			      "(ret=%d)!\n", cdev->private->dev_id.ssid,
 			      cdev->private->dev_id.devno, ret);
 		put_device(&other_sch->dev);
@@ -933,7 +933,7 @@ io_subchannel_register(struct work_struct *work)
 			ret = device_reprobe(&cdev->dev);
 			if (ret)
 				/* We can't do much here. */
-				CIO_MSG_EVENT(2, "device_reprobe() returned"
+				CIO_MSG_EVENT(0, "device_reprobe() returned"
 					      " %d for 0.%x.%04x\n", ret,
 					      cdev->private->dev_id.ssid,
 					      cdev->private->dev_id.devno);
@@ -1086,7 +1086,7 @@ static void ccw_device_move_to_sch(struct work_struct *work)
 	rc = device_move(&cdev->dev, &sch->dev);
 	mutex_unlock(&sch->reg_mutex);
 	if (rc) {
-		CIO_MSG_EVENT(2, "Moving device 0.%x.%04x to subchannel "
+		CIO_MSG_EVENT(0, "Moving device 0.%x.%04x to subchannel "
 			      "0.%x.%04x failed (ret=%d)!\n",
 			      cdev->private->dev_id.ssid,
 			      cdev->private->dev_id.devno, sch->schid.ssid,
@@ -1446,8 +1446,7 @@ ccw_device_remove (struct device *dev)
 			wait_event(cdev->private->wait_q,
 				   dev_fsm_final_state(cdev));
 		else
-			//FIXME: we can't fail!
-			CIO_MSG_EVENT(2, "ccw_device_offline returned %d, "
+			CIO_MSG_EVENT(0, "ccw_device_offline returned %d, "
 				      "device 0.%x.%04x\n",
 				      ret, cdev->private->dev_id.ssid,
 				      cdev->private->dev_id.devno);
@@ -1524,7 +1523,7 @@ static int recovery_check(struct device *dev, void *data)
 	spin_lock_irq(cdev->ccwlock);
 	switch (cdev->private->state) {
 	case DEV_STATE_DISCONNECTED:
-		CIO_MSG_EVENT(3, "recovery: trigger 0.%x.%04x\n",
+		CIO_MSG_EVENT(4, "recovery: trigger 0.%x.%04x\n",
 			      cdev->private->dev_id.ssid,
 			      cdev->private->dev_id.devno);
 		dev_fsm_event(cdev, DEV_EVENT_VERIFY);
@@ -1554,7 +1553,7 @@ static void recovery_work_func(struct work_struct *unused)
 		}
 		spin_unlock_irq(&recovery_lock);
 	} else
-		CIO_MSG_EVENT(2, "recovery: end\n");
+		CIO_MSG_EVENT(4, "recovery: end\n");
 }
 
 static DECLARE_WORK(recovery_work, recovery_work_func);
@@ -1572,7 +1571,7 @@ void ccw_device_schedule_recovery(void)
 {
 	unsigned long flags;
 
-	CIO_MSG_EVENT(2, "recovery: schedule\n");
+	CIO_MSG_EVENT(4, "recovery: schedule\n");
 	spin_lock_irqsave(&recovery_lock, flags);
 	if (!timer_pending(&recovery_timer) || (recovery_phase != 0)) {
 		recovery_phase = 0;
diff --git a/drivers/s390/cio/device_fsm.c b/drivers/s390/cio/device_fsm.c
index 99403b0..e268d5a 100644
--- a/drivers/s390/cio/device_fsm.c
+++ b/drivers/s390/cio/device_fsm.c
@@ -322,10 +322,10 @@ ccw_device_recog_done(struct ccw_device *cdev, int state)
 	same_dev = 0; /* Keep the compiler quiet... */
 	switch (state) {
 	case DEV_STATE_NOT_OPER:
-		CIO_DEBUG(KERN_WARNING, 2,
-			  "SenseID : unknown device %04x on subchannel "
-			  "0.%x.%04x\n", cdev->private->dev_id.devno,
-			  sch->schid.ssid, sch->schid.sch_no);
+		CIO_MSG_EVENT(2, "SenseID : unknown device %04x on "
+			      "subchannel 0.%x.%04x\n",
+			      cdev->private->dev_id.devno,
+			      sch->schid.ssid, sch->schid.sch_no);
 		break;
 	case DEV_STATE_OFFLINE:
 		if (cdev->private->state == DEV_STATE_DISCONNECTED_SENSE_ID) {
@@ -348,20 +348,19 @@ ccw_device_recog_done(struct ccw_device *cdev, int state)
 			return;
 		}
 		/* Issue device info message. */
-		CIO_DEBUG(KERN_INFO, 2,
-			  "SenseID : device 0.%x.%04x reports: "
-			  "CU  Type/Mod = %04X/%02X, Dev Type/Mod = "
-			  "%04X/%02X\n",
-			  cdev->private->dev_id.ssid,
-			  cdev->private->dev_id.devno,
-			  cdev->id.cu_type, cdev->id.cu_model,
-			  cdev->id.dev_type, cdev->id.dev_model);
+		CIO_MSG_EVENT(4, "SenseID : device 0.%x.%04x reports: "
+			      "CU  Type/Mod = %04X/%02X, Dev Type/Mod = "
+			      "%04X/%02X\n",
+			      cdev->private->dev_id.ssid,
+			      cdev->private->dev_id.devno,
+			      cdev->id.cu_type, cdev->id.cu_model,
+			      cdev->id.dev_type, cdev->id.dev_model);
 		break;
 	case DEV_STATE_BOXED:
-		CIO_DEBUG(KERN_WARNING, 2,
-			  "SenseID : boxed device %04x on subchannel "
-			  "0.%x.%04x\n", cdev->private->dev_id.devno,
-			  sch->schid.ssid, sch->schid.sch_no);
+		CIO_MSG_EVENT(0, "SenseID : boxed device %04x on "
+			      " subchannel 0.%x.%04x\n",
+			      cdev->private->dev_id.devno,
+			      sch->schid.ssid, sch->schid.sch_no);
 		break;
 	}
 	cdev->private->state = state;
@@ -443,9 +442,8 @@ ccw_device_done(struct ccw_device *cdev, int state)
 
 
 	if (state == DEV_STATE_BOXED)
-		CIO_DEBUG(KERN_WARNING, 2,
-			  "Boxed device %04x on subchannel %04x\n",
-			  cdev->private->dev_id.devno, sch->schid.sch_no);
+		CIO_MSG_EVENT(0, "Boxed device %04x on subchannel %04x\n",
+			      cdev->private->dev_id.devno, sch->schid.sch_no);
 
 	if (cdev->private->flags.donotify) {
 		cdev->private->flags.donotify = 0;
@@ -900,7 +898,7 @@ ccw_device_w4sense(struct ccw_device *cdev, enum dev_event dev_event)
 			/* Basic sense hasn't started. Try again. */
 			ccw_device_do_sense(cdev, irb);
 		else {
-			CIO_MSG_EVENT(2, "Huh? 0.%x.%04x: unsolicited "
+			CIO_MSG_EVENT(0, "0.%x.%04x: unsolicited "
 				      "interrupt during w4sense...\n",
 				      cdev->private->dev_id.ssid,
 				      cdev->private->dev_id.devno);
@@ -1169,8 +1167,10 @@ ccw_device_nop(struct ccw_device *cdev, enum dev_event dev_event)
 static void
 ccw_device_bug(struct ccw_device *cdev, enum dev_event dev_event)
 {
-	CIO_MSG_EVENT(0, "dev_jumptable[%i][%i] == NULL\n",
-		      cdev->private->state, dev_event);
+	CIO_MSG_EVENT(0, "Internal state [%i][%i] not handled for device "
+		      "0.%x.%04x\n", cdev->private->state, dev_event,
+		      cdev->private->dev_id.ssid,
+		      cdev->private->dev_id.devno);
 	BUG();
 }
 
diff --git a/drivers/s390/cio/device_id.c b/drivers/s390/cio/device_id.c
index dc4d87f..cba7020 100644
--- a/drivers/s390/cio/device_id.c
+++ b/drivers/s390/cio/device_id.c
@@ -214,7 +214,7 @@ ccw_device_check_sense_id(struct ccw_device *cdev)
 		 *     sense id information. So, for intervention required,
 		 *     we use the "whack it until it talks" strategy...
 		 */
-		CIO_MSG_EVENT(2, "SenseID : device %04x on Subchannel "
+		CIO_MSG_EVENT(0, "SenseID : device %04x on Subchannel "
 			      "0.%x.%04x reports cmd reject\n",
 			      cdev->private->dev_id.devno, sch->schid.ssid,
 			      sch->schid.sch_no);
@@ -239,7 +239,7 @@ ccw_device_check_sense_id(struct ccw_device *cdev)
 
 		lpm = to_io_private(sch)->orb.lpm;
 		if ((lpm & sch->schib.pmcw.pim & sch->schib.pmcw.pam) != 0)
-			CIO_MSG_EVENT(2, "SenseID : path %02X for device %04x "
+			CIO_MSG_EVENT(4, "SenseID : path %02X for device %04x "
 				      "on subchannel 0.%x.%04x is "
 				      "'not operational'\n", lpm,
 				      cdev->private->dev_id.devno,
diff --git a/drivers/s390/cio/device_pgid.c b/drivers/s390/cio/device_pgid.c
index c52449a..ba55905 100644
--- a/drivers/s390/cio/device_pgid.c
+++ b/drivers/s390/cio/device_pgid.c
@@ -79,7 +79,7 @@ __ccw_device_sense_pgid_start(struct ccw_device *cdev)
 			/* ret is 0, -EBUSY, -EACCES or -ENODEV */
 			if (ret != -EACCES)
 				return ret;
-			CIO_MSG_EVENT(2, "SNID - Device %04x on Subchannel "
+			CIO_MSG_EVENT(3, "SNID - Device %04x on Subchannel "
 				      "0.%x.%04x, lpm %02X, became 'not "
 				      "operational'\n",
 				      cdev->private->dev_id.devno,
@@ -159,7 +159,7 @@ __ccw_device_check_sense_pgid(struct ccw_device *cdev)
 		u8 lpm;
 
 		lpm = to_io_private(sch)->orb.lpm;
-		CIO_MSG_EVENT(2, "SNID - Device %04x on Subchannel 0.%x.%04x,"
+		CIO_MSG_EVENT(3, "SNID - Device %04x on Subchannel 0.%x.%04x,"
 			      " lpm %02X, became 'not operational'\n",
 			      cdev->private->dev_id.devno, sch->schid.ssid,
 			      sch->schid.sch_no, lpm);
@@ -275,7 +275,7 @@ __ccw_device_do_pgid(struct ccw_device *cdev, __u8 func)
 			return ret;
 	}
 	/* PGID command failed on this path. */
-	CIO_MSG_EVENT(2, "SPID - Device %04x on Subchannel "
+	CIO_MSG_EVENT(3, "SPID - Device %04x on Subchannel "
 		      "0.%x.%04x, lpm %02X, became 'not operational'\n",
 		      cdev->private->dev_id.devno, sch->schid.ssid,
 		      sch->schid.sch_no, cdev->private->imask);
@@ -317,7 +317,7 @@ static int __ccw_device_do_nop(struct ccw_device *cdev)
 			return ret;
 	}
 	/* nop command failed on this path. */
-	CIO_MSG_EVENT(2, "NOP - Device %04x on Subchannel "
+	CIO_MSG_EVENT(3, "NOP - Device %04x on Subchannel "
 		      "0.%x.%04x, lpm %02X, became 'not operational'\n",
 		      cdev->private->dev_id.devno, sch->schid.ssid,
 		      sch->schid.sch_no, cdev->private->imask);
@@ -362,7 +362,7 @@ __ccw_device_check_pgid(struct ccw_device *cdev)
 		return -EAGAIN;
 	}
 	if (irb->scsw.cc == 3) {
-		CIO_MSG_EVENT(2, "SPID - Device %04x on Subchannel 0.%x.%04x,"
+		CIO_MSG_EVENT(3, "SPID - Device %04x on Subchannel 0.%x.%04x,"
 			      " lpm %02X, became 'not operational'\n",
 			      cdev->private->dev_id.devno, sch->schid.ssid,
 			      sch->schid.sch_no, cdev->private->imask);
@@ -391,7 +391,7 @@ static int __ccw_device_check_nop(struct ccw_device *cdev)
 		return -ETIME;
 	}
 	if (irb->scsw.cc == 3) {
-		CIO_MSG_EVENT(2, "NOP - Device %04x on Subchannel 0.%x.%04x,"
+		CIO_MSG_EVENT(3, "NOP - Device %04x on Subchannel 0.%x.%04x,"
 			      " lpm %02X, became 'not operational'\n",
 			      cdev->private->dev_id.devno, sch->schid.ssid,
 			      sch->schid.sch_no, cdev->private->imask);
diff --git a/drivers/s390/s390mach.c b/drivers/s390/s390mach.c
index 4d4b542..5080f34 100644
--- a/drivers/s390/s390mach.c
+++ b/drivers/s390/s390mach.c
@@ -48,10 +48,11 @@ s390_collect_crw_info(void *param)
 	int ccode;
 	struct semaphore *sem;
 	unsigned int chain;
+	int ignore;
 
 	sem = (struct semaphore *)param;
 repeat:
-	down_interruptible(sem);
+	ignore = down_interruptible(sem);
 	chain = 0;
 	while (1) {
 		if (unlikely(chain > 1)) {
diff --git a/include/asm-s390/kvm_host.h b/include/asm-s390/kvm_host.h
index f8204a4..18cbd8a 100644
--- a/include/asm-s390/kvm_host.h
+++ b/include/asm-s390/kvm_host.h
@@ -104,6 +104,7 @@ struct sie_block {
 
 struct kvm_vcpu_stat {
 	u32 exit_userspace;
+	u32 exit_null;
 	u32 exit_external_request;
 	u32 exit_external_interrupt;
 	u32 exit_stop_request;
diff --git a/include/asm-s390/page.h b/include/asm-s390/page.h
index f0f4579..12fd9c4 100644
--- a/include/asm-s390/page.h
+++ b/include/asm-s390/page.h
@@ -125,6 +125,17 @@ page_get_storage_key(unsigned long addr)
 	return skey;
 }
 
+#ifdef CONFIG_PAGE_STATES
+
+struct page;
+void arch_free_page(struct page *page, int order);
+void arch_alloc_page(struct page *page, int order);
+
+#define HAVE_ARCH_FREE_PAGE
+#define HAVE_ARCH_ALLOC_PAGE
+
+#endif
+
 #endif /* !__ASSEMBLY__ */
 
 /* to align the pointer to the (next) page boundary */
diff --git a/include/asm-s390/ptrace.h b/include/asm-s390/ptrace.h
index 441d7c2..d7d4e2e 100644
--- a/include/asm-s390/ptrace.h
+++ b/include/asm-s390/ptrace.h
@@ -471,6 +471,8 @@ struct task_struct;
 extern void user_enable_single_step(struct task_struct *);
 extern void user_disable_single_step(struct task_struct *);
 
+#define __ARCH_WANT_COMPAT_SYS_PTRACE
+
 #define user_mode(regs) (((regs)->psw.mask & PSW_MASK_PSTATE) != 0)
 #define instruction_pointer(regs) ((regs)->psw.addr & PSW_ADDR_INSN)
 #define regs_return_value(regs)((regs)->gprs[2])
diff --git a/include/asm-s390/system.h b/include/asm-s390/system.h
index c819ae2..e0d4500 100644
--- a/include/asm-s390/system.h
+++ b/include/asm-s390/system.h
@@ -116,6 +116,12 @@ extern void pfault_fini(void);
 #define pfault_fini()		do { } while (0)
 #endif /* CONFIG_PFAULT */
 
+#ifdef CONFIG_PAGE_STATES
+extern void cmma_init(void);
+#else
+static inline void cmma_init(void) { }
+#endif
+
 #define finish_arch_switch(prev) do {					     \
 	set_fs(current->thread.mm_segment);				     \
 	account_vtime(prev);						     \


