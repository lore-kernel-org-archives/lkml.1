Return-Path: <linux-kernel-owner+w=401wt.eu-S1751955AbXCEWt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbXCEWt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbXCEWtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:49:55 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:26264 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbXCEWtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:49:53 -0500
Date: Mon, 5 Mar 2007 23:49:50 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Please pull git390 'for-linus' branch
Message-ID: <20070305224950.GP22630@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

 arch/s390/Kconfig                |    2 +
 arch/s390/kernel/head31.S        |   11 +++-
 arch/s390/kernel/head64.S        |   11 +++-
 arch/s390/kernel/ipl.c           |    4 +-
 arch/s390/kernel/kprobes.c       |   21 ++-----
 arch/s390/kernel/machine_kexec.c |    5 ++
 arch/s390/kernel/reipl.S         |   13 ++--
 arch/s390/kernel/reipl64.S       |   13 +++-
 arch/s390/kernel/smp.c           |   15 +++--
 arch/s390/mm/fault.c             |  105 +++++++++++++++-------------------
 drivers/s390/block/dasd_eer.c    |    1 +
 drivers/s390/char/tape_std.c     |    5 +-
 drivers/s390/cio/device_fsm.c    |  117 ++++++++++++++++++--------------------
 include/asm-s390/bugs.h          |    2 +-
 include/asm-s390/ipl.h           |    1 +
 15 files changed, 165 insertions(+), 161 deletions(-)

Cornelia Huck (3):
      [S390] cio: Fix locking when calling notify function.
      [S390] cio: Use path verification to check for path state.
      [S390] cio: Call cancel_halt_clear even when actl == 0.

Gerald Schaefer (1):
      [S390] Fixed handling of access register mode faults.

Heiko Carstens (4):
      [S390] smp: disable preemption in smp_call_function/smp_call_function_on
      [S390] reipl: move dump_prefix_page out of text section.
      [S390] nss: disable kexec.
      [S390] check_bugs() should be inline.

Martin Schwidefsky (1):
      [S390] kprobes breaks BUG_ON

Michael Holzheu (1):
      [S390] tape: Compression overwrites crypto setting

Stefan Weinhuber (1):
      [S390] dasd: Use default recovery for SNSS requests

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index d9425f5..0f293aa 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -376,6 +376,8 @@ config SHARED_KERNEL
 	  Select this option, if you want to share the text segment of the
 	  Linux kernel between different VM guests. This reduces memory
 	  usage with lots of guests but greatly increases kernel size.
+	  Also if a kernel was IPL'ed from a shared segment the kexec system
+	  call will not work.
 	  You should only select this option if you know what you are
 	  doing and want to exploit this feature.
 
diff --git a/arch/s390/kernel/head31.S b/arch/s390/kernel/head31.S
index da7c8bb..dc364c1 100644
--- a/arch/s390/kernel/head31.S
+++ b/arch/s390/kernel/head31.S
@@ -121,7 +121,7 @@ startup_continue:
 	.long	.Lduct			# cr2: dispatchable unit control table
 	.long	0			# cr3: instruction authorization
 	.long	0			# cr4: instruction authorization
-	.long	0xffffffff		# cr5: primary-aste origin
+	.long	.Lduct			# cr5: primary-aste origin
 	.long	0			# cr6:	I/O interrupts
 	.long	0			# cr7:	secondary space segment table
 	.long	0			# cr8:	access registers translation
@@ -132,8 +132,6 @@ startup_continue:
 	.long	0			# cr13: home space segment table
 	.long	0xc0000000		# cr14: machine check handling off
 	.long	0			# cr15: linkage stack operations
-.Lduct:	.long	0,0,0,0,0,0,0,0
-	.long	0,0,0,0,0,0,0,0
 .Lpcfpu:.long	0x00080000,0x80000000 + .Lchkfpu
 .Lpccsp:.long	0x00080000,0x80000000 + .Lchkcsp
 .Lpcmvpg:.long	0x00080000,0x80000000 + .Lchkmvpg
@@ -147,6 +145,13 @@ startup_continue:
 .Linittu:   .long init_thread_union
 .Lstartup_init:
 	    .long startup_init
+	.align	64
+.Lduct:	.long	0,0,0,0,.Lduald,0,0,0
+	.long	0,0,0,0,0,0,0,0
+	.align	128
+.Lduald:.rept	8
+	.long	0x80000000,0,0,0	# invalid access-list entries
+	.endr
 
 	.org	0x12000
 	.globl	_ehead
diff --git a/arch/s390/kernel/head64.S b/arch/s390/kernel/head64.S
index af09e18..3701070 100644
--- a/arch/s390/kernel/head64.S
+++ b/arch/s390/kernel/head64.S
@@ -134,7 +134,7 @@ startup_continue:
 	.quad	.Lduct			# cr2: dispatchable unit control table
 	.quad	0			# cr3: instruction authorization
 	.quad	0			# cr4: instruction authorization
-	.quad	0xffffffffffffffff	# cr5: primary-aste origin
+	.quad	.Lduct			# cr5: primary-aste origin
 	.quad	0			# cr6:	I/O interrupts
 	.quad	0			# cr7:	secondary space segment table
 	.quad	0			# cr8:	access registers translation
@@ -145,14 +145,19 @@ startup_continue:
 	.quad	0			# cr13: home space segment table
 	.quad	0xc0000000		# cr14: machine check handling off
 	.quad	0			# cr15: linkage stack operations
-.Lduct: .long	0,0,0,0,0,0,0,0
-	.long	0,0,0,0,0,0,0,0
 .Lpcmsk:.quad	0x0000000180000000
 .L4malign:.quad 0xffffffffffc00000
 .Lscan2g:.quad	0x80000000 + 0x20000 - 8	# 2GB + 128K - 8
 .Lnop:	.long	0x07000700
 .Lparmaddr:
 	.quad	PARMAREA
+	.align	64
+.Lduct: .long	0,0,0,0,.Lduald,0,0,0
+	.long	0,0,0,0,0,0,0,0
+	.align	128
+.Lduald:.rept	8
+	.long	0x80000000,0,0,0	# invalid access-list entries
+	.endr
 
 	.org	0x12000
 	.globl	_ehead
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 5a863a3..d125a4e 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -1066,7 +1066,7 @@ static void do_reset_calls(void)
 		reset->fn();
 }
 
-extern __u32 dump_prefix_page;
+u32 dump_prefix_page;
 
 void s390_reset_system(void)
 {
@@ -1078,7 +1078,7 @@ void s390_reset_system(void)
 	lc->panic_stack = S390_lowcore.panic_stack;
 
 	/* Save prefix page address for dump case */
-	dump_prefix_page = (unsigned long) lc;
+	dump_prefix_page = (u32)(unsigned long) lc;
 
 	/* Disable prefixing */
 	set_prefix(0);
diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
index a466bab..8af549e 100644
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -337,21 +337,14 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 	}
 
 	p = get_kprobe(addr);
-	if (!p) {
-		if (*addr != BREAKPOINT_INSTRUCTION) {
-			/*
-			 * The breakpoint instruction was removed right
-			 * after we hit it.  Another cpu has removed
-			 * either a probepoint or a debugger breakpoint
-			 * at this address.  In either case, no further
-			 * handling of this interrupt is appropriate.
-			 *
-			 */
-			ret = 1;
-		}
-		/* Not one of ours: let kernel handle it */
+	if (!p)
+		/*
+		 * No kprobe at this address. The fault has not been
+		 * caused by a kprobe breakpoint. The race of breakpoint
+		 * vs. kprobe remove does not exist because on s390 we
+		 * use stop_machine_run to arm/disarm the breakpoints.
+		 */
 		goto no_kprobe;
-	}
 
 	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
 	set_current_kprobe(p, regs, kcb);
diff --git a/arch/s390/kernel/machine_kexec.c b/arch/s390/kernel/machine_kexec.c
index 52f57af..3c77dd3 100644
--- a/arch/s390/kernel/machine_kexec.c
+++ b/arch/s390/kernel/machine_kexec.c
@@ -19,6 +19,7 @@
 #include <asm/system.h>
 #include <asm/smp.h>
 #include <asm/reset.h>
+#include <asm/ipl.h>
 
 typedef void (*relocate_kernel_t)(kimage_entry_t *, unsigned long);
 
@@ -29,6 +30,10 @@ int machine_kexec_prepare(struct kimage *image)
 {
 	void *reboot_code_buffer;
 
+	/* Can't replace kernel image since it is read-only. */
+	if (ipl_flags & IPL_NSS_VALID)
+		return -ENOSYS;
+
 	/* We don't support anything but the default image type for now. */
 	if (image->type != KEXEC_TYPE_DEFAULT)
 		return -EINVAL;
diff --git a/arch/s390/kernel/reipl.S b/arch/s390/kernel/reipl.S
index c3f4d9b..2f481cc 100644
--- a/arch/s390/kernel/reipl.S
+++ b/arch/s390/kernel/reipl.S
@@ -8,6 +8,10 @@
 
 #include <asm/lowcore.h>
 
+#
+# do_reipl_asm
+# Parameter: r2 = schid of reipl device
+#
 		.globl	do_reipl_asm
 do_reipl_asm:	basr	%r13,0
 .Lpg0:		lpsw	.Lnewpsw-.Lpg0(%r13)
@@ -16,12 +20,12 @@ do_reipl_asm:	basr	%r13,0
 		stm	%r0,%r15,__LC_GPREGS_SAVE_AREA
 		stctl	%c0,%c15,__LC_CREGS_SAVE_AREA
 		stam	%a0,%a15,__LC_AREGS_SAVE_AREA
-		mvc	__LC_PREFIX_SAVE_AREA(4),dump_prefix_page-.Lpg0(%r13)
+		l	%r10,.Ldump_pfx-.Lpg0(%r13)
+		mvc	__LC_PREFIX_SAVE_AREA(4),0(%r10)
 		stckc	.Lclkcmp-.Lpg0(%r13)
 		mvc	__LC_CLOCK_COMP_SAVE_AREA(8),.Lclkcmp-.Lpg0(%r13)
 		stpt	__LC_CPU_TIMER_SAVE_AREA
 		st	%r13, __LC_PSW_SAVE_AREA+4
-
 		lctl	%c6,%c6,.Lall-.Lpg0(%r13)
 		lr	%r1,%r2
 		mvc	__LC_PGM_NEW_PSW(8),.Lpcnew-.Lpg0(%r13)
@@ -55,6 +59,7 @@ do_reipl_asm:	basr	%r13,0
 		.align	8
 .Lclkcmp:	.quad	0x0000000000000000
 .Lall:		.long	0xff000000
+.Ldump_pfx:	.long	dump_prefix_page
 		.align	8
 .Lnewpsw:	.long	0x00080000,0x80000000+.Lpg1
 .Lpcnew:	.long	0x00080000,0x80000000+.Lecs
@@ -79,7 +84,3 @@ do_reipl_asm:	basr	%r13,0
 		.long	0x00000000,0x00000000
 		.long	0x00000000,0x00000000
 		.long	0x00000000,0x00000000
-	.globl dump_prefix_page
-dump_prefix_page:
-	.long 0x00000000
-
diff --git a/arch/s390/kernel/reipl64.S b/arch/s390/kernel/reipl64.S
index dbb3eed..c419304 100644
--- a/arch/s390/kernel/reipl64.S
+++ b/arch/s390/kernel/reipl64.S
@@ -8,6 +8,12 @@
  */
 
 #include <asm/lowcore.h>
+
+#
+# do_reipl_asm
+# Parameter: r2 = schid of reipl device
+#
+
 		.globl	do_reipl_asm
 do_reipl_asm:	basr	%r13,0
 .Lpg0:		lpswe	.Lnewpsw-.Lpg0(%r13)
@@ -20,7 +26,8 @@ do_reipl_asm:	basr	%r13,0
 		stg	%r0,__LC_GPREGS_SAVE_AREA-0x1000+8(%r1)
 		stctg	%c0,%c15,__LC_CREGS_SAVE_AREA-0x1000(%r1)
 		stam	%a0,%a15,__LC_AREGS_SAVE_AREA-0x1000(%r1)
-		mvc	__LC_PREFIX_SAVE_AREA-0x1000(4,%r1),dump_prefix_page-.Lpg0(%r13)
+		lg	%r10,.Ldump_pfx-.Lpg0(%r13)
+		mvc	__LC_PREFIX_SAVE_AREA-0x1000(4,%r1),0(%r10)
 		stfpc	__LC_FP_CREG_SAVE_AREA-0x1000(%r1)
 		stckc	.Lclkcmp-.Lpg0(%r13)
 		mvc	__LC_CLOCK_COMP_SAVE_AREA-0x1000(8,%r1),.Lclkcmp-.Lpg0(%r13)
@@ -64,6 +71,7 @@ do_reipl_asm:	basr	%r13,0
 		.align	8
 .Lclkcmp:	.quad	0x0000000000000000
 .Lall:		.quad	0x00000000ff000000
+.Ldump_pfx:	.quad	dump_prefix_page
 .Lregsave:	.quad	0x0000000000000000
 		.align	16
 /*
@@ -103,6 +111,3 @@ do_reipl_asm:	basr	%r13,0
 		.long	0x00000000,0x00000000
 		.long	0x00000000,0x00000000
 		.long	0x00000000,0x00000000
-	.globl dump_prefix_page
-dump_prefix_page:
-	.long 0x00000000
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index ecaa432..97764f7 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -94,10 +94,9 @@ static void __smp_call_function_map(void (*func) (void *info), void *info,
 	int cpu, local = 0;
 
 	/*
-	 * Can deadlock when interrupts are disabled or if in wrong context,
-	 * caller must disable preemption
+	 * Can deadlock when interrupts are disabled or if in wrong context.
 	 */
-	WARN_ON(irqs_disabled() || in_irq() || preemptible());
+	WARN_ON(irqs_disabled() || in_irq());
 
 	/*
 	 * Check for local function call. We have to have the same call order
@@ -152,17 +151,18 @@ out:
  * Run a function on all other CPUs.
  *
  * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler. Must be called with preemption disabled.
- * You may call it from a bottom half.
+ * hardware interrupt handler. You may call it from a bottom half.
  */
 int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
 		      int wait)
 {
 	cpumask_t map;
 
+	preempt_disable();
 	map = cpu_online_map;
 	cpu_clear(smp_processor_id(), map);
 	__smp_call_function_map(func, info, nonatomic, wait, map);
+	preempt_enable();
 	return 0;
 }
 EXPORT_SYMBOL(smp_call_function);
@@ -178,16 +178,17 @@ EXPORT_SYMBOL(smp_call_function);
  * Run a function on one processor.
  *
  * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler. Must be called with preemption disabled.
- * You may call it from a bottom half.
+ * hardware interrupt handler. You may call it from a bottom half.
  */
 int smp_call_function_on(void (*func) (void *info), void *info, int nonatomic,
 			  int wait, int cpu)
 {
 	cpumask_t map = CPU_MASK_NONE;
 
+	preempt_disable();
 	cpu_set(cpu, map);
 	__smp_call_function_map(func, info, nonatomic, wait, map);
+	preempt_enable();
 	return 0;
 }
 EXPORT_SYMBOL(smp_call_function_on);
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 641aef3..7462aeb 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -108,53 +108,40 @@ void bust_spinlocks(int yes)
 }
 
 /*
- * Check which address space is addressed by the access
- * register in S390_lowcore.exc_access_id.
- * Returns 1 for user space and 0 for kernel space.
+ * Returns the address space associated with the fault.
+ * Returns 0 for kernel space, 1 for user space and
+ * 2 for code execution in user space with noexec=on.
  */
-static int __check_access_register(struct pt_regs *regs, int error_code)
-{
-	int areg = S390_lowcore.exc_access_id;
-
-	if (areg == 0)
-		/* Access via access register 0 -> kernel address */
-		return 0;
-	save_access_regs(current->thread.acrs);
-	if (regs && areg < NUM_ACRS && current->thread.acrs[areg] <= 1)
-		/*
-		 * access register contains 0 -> kernel address,
-		 * access register contains 1 -> user space address
-		 */
-		return current->thread.acrs[areg];
-
-	/* Something unhealthy was done with the access registers... */
-	die("page fault via unknown access register", regs, error_code);
-	do_exit(SIGKILL);
-	return 0;
-}
-
-/*
- * Check which address space the address belongs to.
- * May return 1 or 2 for user space and 0 for kernel space.
- * Returns 2 for user space in primary addressing mode with
- * CONFIG_S390_EXEC_PROTECT on and kernel parameter noexec=on.
- */
-static inline int check_user_space(struct pt_regs *regs, int error_code)
+static inline int check_space(struct task_struct *tsk)
 {
 	/*
-	 * The lowest two bits of S390_lowcore.trans_exc_code indicate
-	 * which paging table was used:
-	 *   0: Primary Segment Table Descriptor
-	 *   1: STD determined via access register
-	 *   2: Secondary Segment Table Descriptor
-	 *   3: Home Segment Table Descriptor
+	 * The lowest two bits of S390_lowcore.trans_exc_code
+	 * indicate which paging table was used.
 	 */
-	int descriptor = S390_lowcore.trans_exc_code & 3;
-	if (unlikely(descriptor == 1))
-		return __check_access_register(regs, error_code);
-	if (descriptor == 2)
-		return current->thread.mm_segment.ar4;
-	return ((descriptor != 0) ^ (switch_amode)) << s390_noexec;
+	int desc = S390_lowcore.trans_exc_code & 3;
+
+	if (desc == 3)	/* Home Segment Table Descriptor */
+		return switch_amode == 0;
+	if (desc == 2)	/* Secondary Segment Table Descriptor */
+		return tsk->thread.mm_segment.ar4;
+#ifdef CONFIG_S390_SWITCH_AMODE
+	if (unlikely(desc == 1)) { /* STD determined via access register */
+		/* %a0 always indicates primary space. */
+		if (S390_lowcore.exc_access_id != 0) {
+			save_access_regs(tsk->thread.acrs);
+			/*
+			 * An alet of 0 indicates primary space.
+			 * An alet of 1 indicates secondary space.
+			 * Any other alet values generate an
+			 * alen-translation exception.
+			 */
+			if (tsk->thread.acrs[S390_lowcore.exc_access_id])
+				return tsk->thread.mm_segment.ar4;
+		}
+	}
+#endif
+	/* Primary Segment Table Descriptor */
+	return switch_amode << s390_noexec;
 }
 
 /*
@@ -265,16 +252,16 @@ out_fault:
  *   11       Page translation     ->  Not present       (nullification)
  *   3b       Region third trans.  ->  Not present       (nullification)
  */
-static inline void __kprobes
+static inline void
 do_exception(struct pt_regs *regs, unsigned long error_code, int is_protection)
 {
         struct task_struct *tsk;
         struct mm_struct *mm;
         struct vm_area_struct * vma;
         unsigned long address;
-	int user_address;
 	const struct exception_table_entry *fixup;
-	int si_code = SEGV_MAPERR;
+	int si_code;
+	int space;
 
         tsk = current;
         mm = tsk->mm;
@@ -294,7 +281,7 @@ do_exception(struct pt_regs *regs, unsigned long error_code, int is_protection)
 		   NULL pointer write access in kernel mode.  */
  		if (!(regs->psw.mask & PSW_MASK_PSTATE)) {
 			address = 0;
-			user_address = 0;
+			space = 0;
 			goto no_context;
 		}
 
@@ -309,15 +296,15 @@ do_exception(struct pt_regs *regs, unsigned long error_code, int is_protection)
          * the address 
          */
         address = S390_lowcore.trans_exc_code & __FAIL_ADDR_MASK;
-	user_address = check_user_space(regs, error_code);
+	space = check_space(tsk);
 
 	/*
 	 * Verify that the fault happened in user space, that
 	 * we are not in an interrupt and that there is a 
 	 * user context.
 	 */
-        if (user_address == 0 || in_atomic() || !mm)
-                goto no_context;
+	if (unlikely(space == 0 || in_atomic() || !mm))
+		goto no_context;
 
 	/*
 	 * When we get here, the fault happened in the current
@@ -328,12 +315,13 @@ do_exception(struct pt_regs *regs, unsigned long error_code, int is_protection)
 
         down_read(&mm->mmap_sem);
 
-        vma = find_vma(mm, address);
-        if (!vma)
-                goto bad_area;
+	si_code = SEGV_MAPERR;
+	vma = find_vma(mm, address);
+	if (!vma)
+		goto bad_area;
 
 #ifdef CONFIG_S390_EXEC_PROTECT
-	if (unlikely((user_address == 2) && !(vma->vm_flags & VM_EXEC)))
+	if (unlikely((space == 2) && !(vma->vm_flags & VM_EXEC)))
 		if (!signal_return(mm, regs, address, error_code))
 			/*
 			 * signal_return() has done an up_read(&mm->mmap_sem)
@@ -389,7 +377,7 @@ survive:
 	 * The instruction that caused the program check will
 	 * be repeated. Don't signal single step via SIGTRAP.
 	 */
-	clear_tsk_thread_flag(current, TIF_SINGLE_STEP);
+	clear_tsk_thread_flag(tsk, TIF_SINGLE_STEP);
         return;
 
 /*
@@ -419,7 +407,7 @@ no_context:
  * Oops. The kernel tried to access some bad page. We'll have to
  * terminate things with extreme prejudice.
  */
-        if (user_address == 0)
+	if (space == 0)
                 printk(KERN_ALERT "Unable to handle kernel pointer dereference"
         	       " at virtual kernel address %p\n", (void *)address);
         else
@@ -462,13 +450,14 @@ do_sigbus:
 		goto no_context;
 }
 
-void do_protection_exception(struct pt_regs *regs, unsigned long error_code)
+void __kprobes do_protection_exception(struct pt_regs *regs,
+				       unsigned long error_code)
 {
 	regs->psw.addr -= (error_code >> 16);
 	do_exception(regs, 4, 1);
 }
 
-void do_dat_exception(struct pt_regs *regs, unsigned long error_code)
+void __kprobes do_dat_exception(struct pt_regs *regs, unsigned long error_code)
 {
 	do_exception(regs, error_code & 0xff, 0);
 }
diff --git a/drivers/s390/block/dasd_eer.c b/drivers/s390/block/dasd_eer.c
index 4b8a95f..a1dc8c4 100644
--- a/drivers/s390/block/dasd_eer.c
+++ b/drivers/s390/block/dasd_eer.c
@@ -461,6 +461,7 @@ int dasd_eer_enable(struct dasd_device *device)
 	cqr->device = device;
 	cqr->retries = 255;
 	cqr->expires = 10 * HZ;
+	clear_bit(DASD_CQR_FLAGS_USE_ERP, &cqr->flags);
 
 	cqr->cpaddr->cmd_code = DASD_ECKD_CCW_SNSS;
 	cqr->cpaddr->count = SNSS_DATA_SIZE;
diff --git a/drivers/s390/char/tape_std.c b/drivers/s390/char/tape_std.c
index 7a76ec4..2a1af4e 100644
--- a/drivers/s390/char/tape_std.c
+++ b/drivers/s390/char/tape_std.c
@@ -647,7 +647,10 @@ tape_std_mtcompression(struct tape_device *device, int mt_count)
 		return PTR_ERR(request);
 	request->op = TO_NOP;
 	/* setup ccws */
-	*device->modeset_byte = (mt_count == 0) ? 0x00 : 0x08;
+	if (mt_count == 0)
+		*device->modeset_byte &= ~0x08;
+	else
+		*device->modeset_byte |= 0x08;
 	tape_ccw_cc(request->cpaddr, MODE_SET_DB, 1, device->modeset_byte);
 	tape_ccw_end(request->cpaddr + 1, NOP, 0, NULL);
 	/* execute it */
diff --git a/drivers/s390/cio/device_fsm.c b/drivers/s390/cio/device_fsm.c
index 51238e7..089a3dd 100644
--- a/drivers/s390/cio/device_fsm.c
+++ b/drivers/s390/cio/device_fsm.c
@@ -144,8 +144,8 @@ ccw_device_cancel_halt_clear(struct ccw_device *cdev)
 	ret = stsch(sch->schid, &sch->schib);
 	if (ret || !sch->schib.pmcw.dnv)
 		return -ENODEV; 
-	if (!sch->schib.pmcw.ena || sch->schib.scsw.actl == 0)
-		/* Not operational or no activity -> done. */
+	if (!sch->schib.pmcw.ena)
+		/* Not operational -> done. */
 		return 0;
 	/* Stage 1: cancel io. */
 	if (!(sch->schib.scsw.actl & SCSW_ACTL_HALT_PEND) &&
@@ -334,20 +334,29 @@ ccw_device_oper_notify(struct work_struct *work)
 	struct ccw_device *cdev;
 	struct subchannel *sch;
 	int ret;
+	unsigned long flags;
 
 	priv = container_of(work, struct ccw_device_private, kick_work);
 	cdev = priv->cdev;
+	spin_lock_irqsave(cdev->ccwlock, flags);
 	sch = to_subchannel(cdev->dev.parent);
-	ret = (sch->driver && sch->driver->notify) ?
-		sch->driver->notify(&sch->dev, CIO_OPER) : 0;
-	if (!ret)
-		/* Driver doesn't want device back. */
-		ccw_device_do_unreg_rereg(work);
-	else {
+	if (sch->driver && sch->driver->notify) {
+		spin_unlock_irqrestore(cdev->ccwlock, flags);
+		ret = sch->driver->notify(&sch->dev, CIO_OPER);
+		spin_lock_irqsave(cdev->ccwlock, flags);
+	} else
+		ret = 0;
+	if (ret) {
 		/* Reenable channel measurements, if needed. */
+		spin_unlock_irqrestore(cdev->ccwlock, flags);
 		cmf_reenable(cdev);
+		spin_lock_irqsave(cdev->ccwlock, flags);
 		wake_up(&cdev->private->wait_q);
 	}
+	spin_unlock_irqrestore(cdev->ccwlock, flags);
+	if (!ret)
+		/* Driver doesn't want device back. */
+		ccw_device_do_unreg_rereg(work);
 }
 
 /*
@@ -534,15 +543,21 @@ ccw_device_nopath_notify(struct work_struct *work)
 	struct ccw_device *cdev;
 	struct subchannel *sch;
 	int ret;
+	unsigned long flags;
 
 	priv = container_of(work, struct ccw_device_private, kick_work);
 	cdev = priv->cdev;
+	spin_lock_irqsave(cdev->ccwlock, flags);
 	sch = to_subchannel(cdev->dev.parent);
 	/* Extra sanity. */
 	if (sch->lpm)
-		return;
-	ret = (sch->driver && sch->driver->notify) ?
-		sch->driver->notify(&sch->dev, CIO_NO_PATH) : 0;
+		goto out_unlock;
+	if (sch->driver && sch->driver->notify) {
+		spin_unlock_irqrestore(cdev->ccwlock, flags);
+		ret = sch->driver->notify(&sch->dev, CIO_NO_PATH);
+		spin_lock_irqsave(cdev->ccwlock, flags);
+	} else
+		ret = 0;
 	if (!ret) {
 		if (get_device(&sch->dev)) {
 			/* Driver doesn't want to keep device. */
@@ -562,6 +577,8 @@ ccw_device_nopath_notify(struct work_struct *work)
 		cdev->private->state = DEV_STATE_DISCONNECTED;
 		wake_up(&cdev->private->wait_q);
 	}
+out_unlock:
+	spin_unlock_irqrestore(cdev->ccwlock, flags);
 }
 
 void
@@ -607,10 +624,13 @@ ccw_device_verify_done(struct ccw_device *cdev, int err)
 	default:
 		/* Reset oper notify indication after verify error. */
 		cdev->private->flags.donotify = 0;
-		PREPARE_WORK(&cdev->private->kick_work,
-			     ccw_device_nopath_notify);
-		queue_work(ccw_device_notify_work, &cdev->private->kick_work);
-		ccw_device_done(cdev, DEV_STATE_NOT_OPER);
+		if (cdev->online) {
+			PREPARE_WORK(&cdev->private->kick_work,
+				     ccw_device_nopath_notify);
+			queue_work(ccw_device_notify_work,
+				   &cdev->private->kick_work);
+		} else
+			ccw_device_done(cdev, DEV_STATE_NOT_OPER);
 		break;
 	}
 }
@@ -756,15 +776,22 @@ static void
 ccw_device_online_notoper(struct ccw_device *cdev, enum dev_event dev_event)
 {
 	struct subchannel *sch;
+	int ret;
 
 	sch = to_subchannel(cdev->dev.parent);
-	if (sch->driver->notify &&
-	    sch->driver->notify(&sch->dev, sch->lpm ? CIO_GONE : CIO_NO_PATH)) {
-			ccw_device_set_timeout(cdev, 0);
-			cdev->private->flags.fake_irb = 0;
-			cdev->private->state = DEV_STATE_DISCONNECTED;
-			wake_up(&cdev->private->wait_q);
-			return;
+	if (sch->driver->notify) {
+		spin_unlock_irq(cdev->ccwlock);
+		ret = sch->driver->notify(&sch->dev,
+					  sch->lpm ? CIO_GONE : CIO_NO_PATH);
+		spin_lock_irq(cdev->ccwlock);
+	} else
+		ret = 0;
+	if (ret) {
+		ccw_device_set_timeout(cdev, 0);
+		cdev->private->flags.fake_irb = 0;
+		cdev->private->state = DEV_STATE_DISCONNECTED;
+		wake_up(&cdev->private->wait_q);
+		return;
 	}
 	cdev->private->state = DEV_STATE_NOT_OPER;
 	cio_disable_subchannel(sch);
@@ -969,18 +996,12 @@ ccw_device_killing_irq(struct ccw_device *cdev, enum dev_event dev_event)
 
 	sch = to_subchannel(cdev->dev.parent);
 	ccw_device_set_timeout(cdev, 0);
+	/* Start delayed path verification. */
+	ccw_device_online_verify(cdev, 0);
 	/* OK, i/o is dead now. Call interrupt handler. */
-	cdev->private->state = DEV_STATE_ONLINE;
 	if (cdev->handler)
 		cdev->handler(cdev, cdev->private->intparm,
 			      ERR_PTR(-EIO));
-	if (!sch->lpm) {
-		PREPARE_WORK(&cdev->private->kick_work,
-			     ccw_device_nopath_notify);
-		queue_work(ccw_device_notify_work, &cdev->private->kick_work);
-	} else if (cdev->private->flags.doverify)
-		/* Start delayed path verification. */
-		ccw_device_online_verify(cdev, 0);
 }
 
 static void
@@ -993,21 +1014,8 @@ ccw_device_killing_timeout(struct ccw_device *cdev, enum dev_event dev_event)
 		ccw_device_set_timeout(cdev, 3*HZ);
 		return;
 	}
-	if (ret == -ENODEV) {
-		struct subchannel *sch;
-
-		sch = to_subchannel(cdev->dev.parent);
-		if (!sch->lpm) {
-			PREPARE_WORK(&cdev->private->kick_work,
-				     ccw_device_nopath_notify);
-			queue_work(ccw_device_notify_work,
-				   &cdev->private->kick_work);
-		} else
-			dev_fsm_event(cdev, DEV_EVENT_NOTOPER);
-		return;
-	}
-	//FIXME: Can we get here?
-	cdev->private->state = DEV_STATE_ONLINE;
+	/* Start delayed path verification. */
+	ccw_device_online_verify(cdev, 0);
 	if (cdev->handler)
 		cdev->handler(cdev, cdev->private->intparm,
 			      ERR_PTR(-EIO));
@@ -1025,26 +1033,11 @@ void device_kill_io(struct subchannel *sch)
 		cdev->private->state = DEV_STATE_TIMEOUT_KILL;
 		return;
 	}
-	if (ret == -ENODEV) {
-		if (!sch->lpm) {
-			PREPARE_WORK(&cdev->private->kick_work,
-				     ccw_device_nopath_notify);
-			queue_work(ccw_device_notify_work,
-				   &cdev->private->kick_work);
-		} else
-			dev_fsm_event(cdev, DEV_EVENT_NOTOPER);
-		return;
-	}
+	/* Start delayed path verification. */
+	ccw_device_online_verify(cdev, 0);
 	if (cdev->handler)
 		cdev->handler(cdev, cdev->private->intparm,
 			      ERR_PTR(-EIO));
-	if (!sch->lpm) {
-		PREPARE_WORK(&cdev->private->kick_work,
-			     ccw_device_nopath_notify);
-		queue_work(ccw_device_notify_work, &cdev->private->kick_work);
-	} else
-		/* Start delayed path verification. */
-		ccw_device_online_verify(cdev, 0);
 }
 
 static void
diff --git a/include/asm-s390/bugs.h b/include/asm-s390/bugs.h
index 2c36596..011f1e6 100644
--- a/include/asm-s390/bugs.h
+++ b/include/asm-s390/bugs.h
@@ -16,7 +16,7 @@
  *      void check_bugs(void);
  */
 
-static void __init check_bugs(void)
+static inline void check_bugs(void)
 {
   /* s390 has no bugs ... */
 }
diff --git a/include/asm-s390/ipl.h b/include/asm-s390/ipl.h
index 5650d3d..660f782 100644
--- a/include/asm-s390/ipl.h
+++ b/include/asm-s390/ipl.h
@@ -74,6 +74,7 @@ struct ipl_parameter_block {
 extern u32 ipl_flags;
 extern u16 ipl_devno;
 
+extern u32 dump_prefix_page;
 extern void do_reipl(void);
 extern void ipl_save_parameters(void);
 
