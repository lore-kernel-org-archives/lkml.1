Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbXLGO5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbXLGO5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 09:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbXLGO47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 09:56:59 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:56653 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751593AbXLGO4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 09:56:55 -0500
Date: Fri, 7 Dec 2007 15:56:39 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, kernel@avr32linux.org
Subject: [GIT PULL] avr32 fixes for 2.6.24
Message-ID: <20071207155639.60aff061@dhcp-252-066.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from

  ssh://master.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git for-linus

to receive the following updates.

Yes, lots of complicated stuff has been changed here. There is
currently a bug in the debug trap handling code which may cause a soft
lockup while debugging userspace applications, and it took some major
surgery to get it fixed. The lockdep stuff isn't really a part of the
fix, but since it touches the low-level exception handling code, I
think it is more risky to remove it than leaving it in.

So I hope you won't be too upset by these changes. I wouldn't have
pushed it if I didn't think the bug it fixes is very serious, and I've
spent quite a few days testing that nothing broke. A customer has
verified the fix too, and the LTP test cases that fail after this
patch, failed before too.

Haavard Skinnemoen (9):
      [AVR32] Add TIF_RESTORE_SIGMASK to the work masks
      [AVR32] Fix invalid status register bit definitions in asm/ptrace.h
      [AVR32] Kconfig: Use def_bool instead of bool + default
      [AVR32] Implement stacktrace support
      [AVR32] Implement irqflags trace and lockdep support
      [AVR32] Clean up OCD register usage
      [AVR32] Follow the rules when dealing with the OCD system
      [AVR32] Fix copy_to_user_page() breakage
      [AVR32] Fix wrong pt_regs in critical exception handler

 arch/avr32/Kconfig               |   65 ++---
 arch/avr32/kernel/Makefile       |    1 +
 arch/avr32/kernel/asm-offsets.c  |    2 +
 arch/avr32/kernel/entry-avr32b.S |  285 ++++++++++++-------
 arch/avr32/kernel/kprobes.c      |   14 +-
 arch/avr32/kernel/process.c      |    9 +-
 arch/avr32/kernel/ptrace.c       |  273 ++++++++++--------
 arch/avr32/kernel/stacktrace.c   |   53 ++++
 arch/avr32/kernel/traps.c        |    2 +-
 arch/avr32/kernel/vmlinux.lds.S  |    2 +-
 arch/avr32/mm/cache.c            |   20 +-
 include/asm-avr32/cacheflush.h   |   19 +-
 include/asm-avr32/ocd.h          |  592 +++++++++++++++++++++++++++++++++-----
 include/asm-avr32/processor.h    |    3 +
 include/asm-avr32/ptrace.h       |    6 +-
 include/asm-avr32/sysreg.h       |    2 +
 include/asm-avr32/system.h       |    4 +-
 include/asm-avr32/thread_info.h  |   25 ++-
 18 files changed, 1006 insertions(+), 371 deletions(-)
 create mode 100644 arch/avr32/kernel/stacktrace.c

diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 4f402c9..b77abce 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -6,8 +6,7 @@
 mainmenu "Linux Kernel Configuration"
 
 config AVR32
-	bool
-	default y
+	def_bool y
 	# With EMBEDDED=n, we get lots of stuff automatically selected
 	# that we usually don't need on AVR32.
 	select EMBEDDED
@@ -20,51 +19,49 @@ config AVR32
 	  http://avr32linux.org/.
 
 config GENERIC_GPIO
-	bool
-	default y
+	def_bool y
 
 config GENERIC_HARDIRQS
-	bool
-	default y
+	def_bool y
+
+config STACKTRACE_SUPPORT
+	def_bool y
+
+config LOCKDEP_SUPPORT
+	def_bool y
+
+config TRACE_IRQFLAGS_SUPPORT
+	def_bool y
 
 config HARDIRQS_SW_RESEND
-	bool
-	default y
+	def_bool y
 
 config GENERIC_IRQ_PROBE
-	bool
-	default y
+	def_bool y
 
 config RWSEM_GENERIC_SPINLOCK
-	bool
-	default y
+	def_bool y
 
 config GENERIC_TIME
-	bool
-	default y
+	def_bool y
 
 config RWSEM_XCHGADD_ALGORITHM
-	bool
+	def_bool n
 
 config ARCH_HAS_ILOG2_U32
-	bool
-	default n
+	def_bool n
 
 config ARCH_HAS_ILOG2_U64
-	bool
-	default n
+	def_bool n
 
 config GENERIC_HWEIGHT
-	bool
-	default y
+	def_bool y
 
 config GENERIC_CALIBRATE_DELAY
-	bool
-	default y
+	def_bool y
 
 config GENERIC_BUG
-	bool
-	default y
+	def_bool y
 	depends on BUG
 
 source "init/Kconfig"
@@ -139,28 +136,22 @@ config PHYS_OFFSET
 source "kernel/Kconfig.preempt"
 
 config HAVE_ARCH_BOOTMEM_NODE
-	bool
-	default n
+	def_bool n
 
 config ARCH_HAVE_MEMORY_PRESENT
-	bool
-	default n
+	def_bool n
 
 config NEED_NODE_MEMMAP_SIZE
-	bool
-	default n
+	def_bool n
 
 config ARCH_FLATMEM_ENABLE
-	bool
-	default y
+	def_bool y
 
 config ARCH_DISCONTIGMEM_ENABLE
-	bool
-	default n
+	def_bool n
 
 config ARCH_SPARSEMEM_ENABLE
-	bool
-	default n
+	def_bool n
 
 source "mm/Kconfig"
 
diff --git a/arch/avr32/kernel/Makefile b/arch/avr32/kernel/Makefile
index 989fcd1..2d6d48f 100644
--- a/arch/avr32/kernel/Makefile
+++ b/arch/avr32/kernel/Makefile
@@ -11,3 +11,4 @@ obj-y				+= signal.o sys_avr32.o process.o time.o
 obj-y				+= init_task.o switch_to.o cpu.o
 obj-$(CONFIG_MODULES)		+= module.o avr32_ksyms.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
+obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
diff --git a/arch/avr32/kernel/asm-offsets.c b/arch/avr32/kernel/asm-offsets.c
index 97d8658..078cd33 100644
--- a/arch/avr32/kernel/asm-offsets.c
+++ b/arch/avr32/kernel/asm-offsets.c
@@ -21,5 +21,7 @@ void foo(void)
 	OFFSET(TI_flags, thread_info, flags);
 	OFFSET(TI_cpu, thread_info, cpu);
 	OFFSET(TI_preempt_count, thread_info, preempt_count);
+	OFFSET(TI_rar_saved, thread_info, rar_saved);
+	OFFSET(TI_rsr_saved, thread_info, rsr_saved);
 	OFFSET(TI_restart_block, thread_info, restart_block);
 }
diff --git a/arch/avr32/kernel/entry-avr32b.S b/arch/avr32/kernel/entry-avr32b.S
index ccadfd9..8cf16d7 100644
--- a/arch/avr32/kernel/entry-avr32b.S
+++ b/arch/avr32/kernel/entry-avr32b.S
@@ -264,16 +264,7 @@ syscall_exit_work:
 
 3:	bld	r1, TIF_BREAKPOINT
 	brcc	syscall_exit_cont
-	mfsr	r3, SYSREG_TLBEHI
-	lddsp	r2, sp[REG_PC]
-	andl	r3, 0xff, COH
-	lsl	r3, 1
-	sbr	r3, 30
-	sbr	r3, 0
-	mtdr	DBGREG_BWA2A, r2
-	mtdr	DBGREG_BWC2A, r3
-	rjmp	syscall_exit_cont
-
+	rjmp	enter_monitor_mode
 
 	/* The slow path of the TLB miss handler */
 page_table_not_present:
@@ -288,11 +279,16 @@ page_not_present:
 	rjmp	ret_from_exception
 
 	/* This function expects to find offending PC in SYSREG_RAR_EX */
+	.type	save_full_context_ex, @function
+	.align	2
 save_full_context_ex:
+	mfsr	r11, SYSREG_RAR_EX
+	sub	r9, pc, . - debug_trampoline
 	mfsr	r8, SYSREG_RSR_EX
+	cp.w	r9, r11
+	breq	3f
 	mov	r12, r8
 	andh	r8, (MODE_MASK >> 16), COH
-	mfsr	r11, SYSREG_RAR_EX
 	brne	2f
 
 1:	pushm	r11, r12	/* PC and SR */
@@ -303,10 +299,25 @@ save_full_context_ex:
 	stdsp	sp[4], r10	/* replace saved SP */
 	rjmp	1b
 
+	/*
+	 * The debug handler set up a trampoline to make us
+	 * automatically enter monitor mode upon return, but since
+	 * we're saving the full context, we must assume that the
+	 * exception handler might want to alter the return address
+	 * and/or status register. So we need to restore the original
+	 * context and enter monitor mode manually after the exception
+	 * has been handled.
+	 */
+3:	get_thread_info r8
+	ld.w	r11, r8[TI_rar_saved]
+	ld.w	r12, r8[TI_rsr_saved]
+	rjmp	1b
+	.size	save_full_context_ex, . - save_full_context_ex
+
 	/* Low-level exception handlers */
 handle_critical:
-	pushm	r12
-	pushm	r0-r12
+	sub	sp, 4
+	stmts	--sp, r0-lr
 	rcall	save_full_context_ex
 	mfsr	r12, SYSREG_ECR
 	mov	r11, sp
@@ -439,6 +450,7 @@ do_fpe_ll:
 ret_from_exception:
 	mask_interrupts
 	lddsp	r4, sp[REG_SR]
+
 	andh	r4, (MODE_MASK >> 16), COH
 	brne	fault_resume_kernel
 
@@ -515,119 +527,124 @@ fault_exit_work:
 
 2:	bld	r1, TIF_BREAKPOINT
 	brcc	fault_resume_user
-	mfsr	r3, SYSREG_TLBEHI
-	lddsp	r2, sp[REG_PC]
-	andl	r3, 0xff, COH
-	lsl	r3, 1
-	sbr	r3, 30
-	sbr	r3, 0
-	mtdr	DBGREG_BWA2A, r2
-	mtdr	DBGREG_BWC2A, r3
-	rjmp	fault_resume_user
-
-	/* If we get a debug trap from privileged context we end up here */
-handle_debug_priv:
-	/* Fix up LR and SP in regs. r11 contains the mode we came from */
+	rjmp	enter_monitor_mode
+
+	.section .kprobes.text, "ax", @progbits
+	.type	handle_debug, @function
+handle_debug:
+	sub	sp, 4		/* r12_orig */
+	stmts	--sp, r0-lr
+	mfsr	r8, SYSREG_RAR_DBG
+	mfsr	r9, SYSREG_RSR_DBG
+	unmask_exceptions
+	pushm	r8-r9
+	bfextu	r9, r9, SYSREG_MODE_OFFSET, SYSREG_MODE_SIZE
+	brne	debug_fixup_regs
+
+.Ldebug_fixup_cont:
+#ifdef CONFIG_TRACE_IRQFLAGS
+	rcall	trace_hardirqs_off
+#endif
+	mov	r12, sp
+	rcall	do_debug
+	mov	sp, r12
+
+	lddsp	r2, sp[REG_SR]
+	bfextu	r3, r2, SYSREG_MODE_OFFSET, SYSREG_MODE_SIZE
+	brne	debug_resume_kernel
+
+	get_thread_info r0
+	ld.w	r1, r0[TI_flags]
+	mov	r2, _TIF_DBGWORK_MASK
+	tst	r1, r2
+	brne	debug_exit_work
+
+	bld	r1, TIF_SINGLE_STEP
+	brcc	1f
+	mfdr	r4, OCD_DC
+	sbr	r4, OCD_DC_SS_BIT
+	mtdr	OCD_DC, r4
+
+1:	popm	r10,r11
+	mask_exceptions
+	mtsr	SYSREG_RSR_DBG, r11
+	mtsr	SYSREG_RAR_DBG, r10
+#ifdef CONFIG_TRACE_IRQFLAGS
+	rcall	trace_hardirqs_on
+1:
+#endif
+	ldmts	sp++, r0-lr
+	sub	sp, -4
+	retd
+	.size	handle_debug, . - handle_debug
+
+	/* Mode of the trapped context is in r9 */
+	.type	debug_fixup_regs, @function
+debug_fixup_regs:
 	mfsr	r8, SYSREG_SR
-	mov	r9, r8
-	andh	r8, hi(~MODE_MASK)
-	or	r8, r11
+	mov	r10, r8
+	bfins	r8, r9, SYSREG_MODE_OFFSET, SYSREG_MODE_SIZE
 	mtsr	SYSREG_SR, r8
 	sub	pc, -2
 	stdsp	sp[REG_LR], lr
-	mtsr	SYSREG_SR, r9
+	mtsr	SYSREG_SR, r10
 	sub	pc, -2
-	sub	r10, sp, -FRAME_SIZE_FULL
-	stdsp	sp[REG_SP], r10
-	mov	r12, sp
-	rcall	do_debug_priv
+	sub	r8, sp, -FRAME_SIZE_FULL
+	stdsp	sp[REG_SP], r8
+	rjmp	.Ldebug_fixup_cont
+	.size	debug_fixup_regs, . - debug_fixup_regs
 
-	/* Now, put everything back */
-	ssrf	SR_EM_BIT
+	.type	debug_resume_kernel, @function
+debug_resume_kernel:
+	mask_exceptions
 	popm	r10, r11
 	mtsr	SYSREG_RAR_DBG, r10
 	mtsr	SYSREG_RSR_DBG, r11
-	mfsr	r8, SYSREG_SR
-	mov	r9, r8
-	andh	r8, hi(~MODE_MASK)
-	andh	r11, hi(MODE_MASK)
-	or	r8, r11
-	mtsr	SYSREG_SR, r8
+#ifdef CONFIG_TRACE_IRQFLAGS
+	bld	r11, SYSREG_GM_OFFSET
+	brcc	1f
+	rcall	trace_hardirqs_on
+1:
+#endif
+	mfsr	r2, SYSREG_SR
+	mov	r1, r2
+	bfins	r2, r3, SYSREG_MODE_OFFSET, SYSREG_MODE_SIZE
+	mtsr	SYSREG_SR, r2
 	sub	pc, -2
 	popm	lr
-	mtsr	SYSREG_SR, r9
+	mtsr	SYSREG_SR, r1
 	sub	pc, -2
 	sub	sp, -4		/* skip SP */
 	popm	r0-r12
 	sub	sp, -4
 	retd
+	.size	debug_resume_kernel, . - debug_resume_kernel
 
+	.type	debug_exit_work, @function
+debug_exit_work:
 	/*
-	 * At this point, everything is masked, that is, interrupts,
-	 * exceptions and debugging traps. We might get called from
-	 * interrupt or exception context in some rare cases, but this
-	 * will be taken care of by do_debug(), so we're not going to
-	 * do a 100% correct context save here.
+	 * We must return from Monitor Mode using a retd, and we must
+	 * not schedule since that involves the D bit in SR getting
+	 * cleared by something other than the debug hardware. This
+	 * may cause undefined behaviour according to the Architecture
+	 * manual.
+	 *
+	 * So we fix up the return address and status and return to a
+	 * stub below in Exception mode. From there, we can follow the
+	 * normal exception return path.
+	 *
+	 * The real return address and status registers are stored on
+	 * the stack in the way the exception return path understands,
+	 * so no need to fix anything up there.
 	 */
-handle_debug:
-	sub	sp, 4		/* r12_orig */
-	stmts	--sp, r0-lr
-	mfsr	r10, SYSREG_RAR_DBG
-	mfsr	r11, SYSREG_RSR_DBG
-	unmask_exceptions
-	pushm	r10,r11
-	andh	r11, (MODE_MASK >> 16), COH
-	brne	handle_debug_priv
-
-	mov	r12, sp
-	rcall	do_debug
-
-	lddsp	r10, sp[REG_SR]
-	andh	r10, (MODE_MASK >> 16), COH
-	breq	debug_resume_user
-
-debug_restore_all:
-	popm	r10,r11
-	mask_exceptions
-	mtsr	SYSREG_RSR_DBG, r11
-	mtsr	SYSREG_RAR_DBG, r10
-	ldmts	sp++, r0-lr
-	sub	sp, -4
+	sub	r8, pc, . - fault_exit_work
+	mtsr	SYSREG_RAR_DBG, r8
+	mov	r9, 0
+	orh	r9, hi(SR_EM | SR_GM | MODE_EXCEPTION)
+	mtsr	SYSREG_RSR_DBG, r9
+	sub	pc, -2
 	retd
-
-debug_resume_user:
-	get_thread_info r0
-	mask_interrupts
-
-	ld.w	r1, r0[TI_flags]
-	andl	r1, _TIF_DBGWORK_MASK, COH
-	breq	debug_restore_all
-
-1:	bld	r1, TIF_NEED_RESCHED
-	brcc	2f
-	unmask_interrupts
-	rcall	schedule
-	mask_interrupts
-	ld.w	r1, r0[TI_flags]
-	rjmp	1b
-
-2:	mov	r2, _TIF_SIGPENDING | _TIF_RESTORE_SIGMASK
-	tst	r1, r2
-	breq	3f
-	unmask_interrupts
-	mov	r12, sp
-	mov	r11, r0
-	rcall	do_notify_resume
-	mask_interrupts
-	ld.w	r1, r0[TI_flags]
-	rjmp	1b
-
-3:	bld	r1, TIF_SINGLE_STEP
-	brcc	debug_restore_all
-	mfdr	r2, DBGREG_DC
-	sbr	r2, DC_SS_BIT
-	mtdr	DBGREG_DC, r2
-	rjmp	debug_restore_all
+	.size	debug_exit_work, . - debug_exit_work
 
 	.set	rsr_int0,	SYSREG_RSR_INT0
 	.set	rsr_int1,	SYSREG_RSR_INT1
@@ -675,7 +692,11 @@ irq_level\level:
 	andl	r1, _TIF_WORK_MASK, COH
 	brne	irq_exit_work
 
-1:	popm	r8-r9
+1:
+#ifdef CONFIG_TRACE_IRQFLAGS
+	rcall	trace_hardirqs_on
+#endif
+	popm	r8-r9
 	mtsr	rar_int\level, r8
 	mtsr	rsr_int\level, r9
 	ldmts	sp++,r0-lr
@@ -748,3 +769,53 @@ cpu_idle_enable_int_and_exit:
 	IRQ_LEVEL 1
 	IRQ_LEVEL 2
 	IRQ_LEVEL 3
+
+	.section .kprobes.text, "ax", @progbits
+	.type	enter_monitor_mode, @function
+enter_monitor_mode:
+	/*
+	 * We need to enter monitor mode to do a single step. The
+	 * monitor code will alter the return address so that we
+	 * return directly to the user instead of returning here.
+	 */
+	breakpoint
+	rjmp	breakpoint_failed
+
+	.size	enter_monitor_mode, . - enter_monitor_mode
+
+	.type	debug_trampoline, @function
+	.global	debug_trampoline
+debug_trampoline:
+	/*
+	 * Save the registers on the stack so that the monitor code
+	 * can find them easily.
+	 */
+	sub	sp, 4		/* r12_orig */
+	stmts	--sp, r0-lr
+	get_thread_info	r0
+	ld.w	r8, r0[TI_rar_saved]
+	ld.w	r9, r0[TI_rsr_saved]
+	pushm	r8-r9
+
+	/*
+	 * The monitor code will alter the return address so we don't
+	 * return here.
+	 */
+	breakpoint
+	rjmp	breakpoint_failed
+	.size	debug_trampoline, . - debug_trampoline
+
+	.type breakpoint_failed, @function
+breakpoint_failed:
+	/*
+	 * Something went wrong. Perhaps the debug hardware isn't
+	 * enabled?
+	 */
+	lda.w	r12, msg_breakpoint_failed
+	mov	r11, sp
+	mov	r10, 9		/* SIGKILL */
+	call	die
+1:	rjmp	1b
+
+msg_breakpoint_failed:
+	.asciz	"Failed to enter Debug Mode"
diff --git a/arch/avr32/kernel/kprobes.c b/arch/avr32/kernel/kprobes.c
index 20b1c9d..799ba89 100644
--- a/arch/avr32/kernel/kprobes.c
+++ b/arch/avr32/kernel/kprobes.c
@@ -70,9 +70,9 @@ static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
 
 	BUG_ON(!(sysreg_read(SR) & SYSREG_BIT(SR_D)));
 
-	dc = __mfdr(DBGREG_DC);
-	dc |= DC_SS;
-	__mtdr(DBGREG_DC, dc);
+	dc = ocd_read(DC);
+	dc |= 1 << OCD_DC_SS_BIT;
+	ocd_write(DC, dc);
 
 	/*
 	 * We must run the instruction from its original location
@@ -91,9 +91,9 @@ static void __kprobes resume_execution(struct kprobe *p, struct pt_regs *regs)
 
 	pr_debug("resuming execution at PC=%08lx\n", regs->pc);
 
-	dc = __mfdr(DBGREG_DC);
-	dc &= ~DC_SS;
-	__mtdr(DBGREG_DC, dc);
+	dc = ocd_read(DC);
+	dc &= ~(1 << OCD_DC_SS_BIT);
+	ocd_write(DC, dc);
 
 	*p->addr = BREAKPOINT_INSTRUCTION;
 	flush_icache_range((unsigned long)p->addr,
@@ -261,7 +261,7 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 int __init arch_init_kprobes(void)
 {
 	printk("KPROBES: Enabling monitor mode (MM|DBE)...\n");
-	__mtdr(DBGREG_DC, DC_MM | DC_DBE);
+	ocd_write(DC, (1 << OCD_DC_MM_BIT) | (1 << OCD_DC_DBE_BIT));
 
 	/* TODO: Register kretprobe trampoline */
 	return 0;
diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index 13f9884..9d6dac8 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -55,8 +55,8 @@ void machine_power_off(void)
 
 void machine_restart(char *cmd)
 {
-	__mtdr(DBGREG_DC, DC_DBE);
-	__mtdr(DBGREG_DC, DC_RES);
+	ocd_write(DC, (1 << OCD_DC_DBE_BIT));
+	ocd_write(DC, (1 << OCD_DC_RES_BIT));
 	while (1) ;
 }
 
@@ -287,10 +287,11 @@ void show_regs_log_lvl(struct pt_regs *regs, const char *log_lvl)
 	       regs->sr & SR_N ? 'N' : 'n',
 	       regs->sr & SR_Z ? 'Z' : 'z',
 	       regs->sr & SR_C ? 'C' : 'c');
-	printk("%sMode bits: %c%c%c%c%c%c%c%c%c\n", log_lvl,
+	printk("%sMode bits: %c%c%c%c%c%c%c%c%c%c\n", log_lvl,
 	       regs->sr & SR_H ? 'H' : 'h',
-	       regs->sr & SR_R ? 'R' : 'r',
 	       regs->sr & SR_J ? 'J' : 'j',
+	       regs->sr & SR_DM ? 'M' : 'm',
+	       regs->sr & SR_D ? 'D' : 'd',
 	       regs->sr & SR_EM ? 'E' : 'e',
 	       regs->sr & SR_I3M ? '3' : '.',
 	       regs->sr & SR_I2M ? '2' : '.',
diff --git a/arch/avr32/kernel/ptrace.c b/arch/avr32/kernel/ptrace.c
index 9e16b8a..002369e 100644
--- a/arch/avr32/kernel/ptrace.c
+++ b/arch/avr32/kernel/ptrace.c
@@ -30,20 +30,22 @@ static struct pt_regs *get_user_regs(struct task_struct *tsk)
 
 static void ptrace_single_step(struct task_struct *tsk)
 {
-	pr_debug("ptrace_single_step: pid=%u, SR=0x%08lx\n",
-		 tsk->pid, tsk->thread.cpu_context.sr);
-	if (!(tsk->thread.cpu_context.sr & SR_D)) {
-		/*
-		 * Set a breakpoint at the current pc to force the
-		 * process into debug mode.  The syscall/exception
-		 * exit code will set a breakpoint at the return
-		 * address when this flag is set.
-		 */
-		pr_debug("ptrace_single_step: Setting TIF_BREAKPOINT\n");
-		set_tsk_thread_flag(tsk, TIF_BREAKPOINT);
-	}
+	pr_debug("ptrace_single_step: pid=%u, PC=0x%08lx, SR=0x%08lx\n",
+		 tsk->pid, task_pt_regs(tsk)->pc, task_pt_regs(tsk)->sr);
 
-	/* The monitor code will do the actual step for us */
+	/*
+	 * We can't schedule in Debug mode, so when TIF_BREAKPOINT is
+	 * set, the system call or exception handler will do a
+	 * breakpoint to enter monitor mode before returning to
+	 * userspace.
+	 *
+	 * The monitor code will then notice that TIF_SINGLE_STEP is
+	 * set and return to userspace with single stepping enabled.
+	 * The CPU will then enter monitor mode again after exactly
+	 * one instruction has been executed, and the monitor code
+	 * will then send a SIGTRAP to the process.
+	 */
+	set_tsk_thread_flag(tsk, TIF_BREAKPOINT);
 	set_tsk_thread_flag(tsk, TIF_SINGLE_STEP);
 }
 
@@ -55,23 +57,7 @@ static void ptrace_single_step(struct task_struct *tsk)
 void ptrace_disable(struct task_struct *child)
 {
 	clear_tsk_thread_flag(child, TIF_SINGLE_STEP);
-}
-
-/*
- * Handle hitting a breakpoint
- */
-static void ptrace_break(struct task_struct *tsk, struct pt_regs *regs)
-{
-	siginfo_t info;
-
-	info.si_signo = SIGTRAP;
-	info.si_errno = 0;
-	info.si_code  = TRAP_BRKPT;
-	info.si_addr  = (void __user *)instruction_pointer(regs);
-
-	pr_debug("ptrace_break: Sending SIGTRAP to PID %u (pc = 0x%p)\n",
-		 tsk->pid, info.si_addr);
-	force_sig_info(SIGTRAP, &info, tsk);
+	clear_tsk_thread_flag(child, TIF_BREAKPOINT);
 }
 
 /*
@@ -84,9 +70,6 @@ static int ptrace_read_user(struct task_struct *tsk, unsigned long offset,
 	unsigned long *regs;
 	unsigned long value;
 
-	pr_debug("ptrace_read_user(%p, %#lx, %p)\n",
-		 tsk, offset, data);
-
 	if (offset & 3 || offset >= sizeof(struct user)) {
 		printk("ptrace_read_user: invalid offset 0x%08lx\n", offset);
 		return -EIO;
@@ -98,6 +81,9 @@ static int ptrace_read_user(struct task_struct *tsk, unsigned long offset,
 	if (offset < sizeof(struct pt_regs))
 		value = regs[offset / sizeof(regs[0])];
 
+	pr_debug("ptrace_read_user(%s[%u], %#lx, %p) -> %#lx\n",
+		 tsk->comm, tsk->pid, offset, data, value);
+
 	return put_user(value, data);
 }
 
@@ -111,8 +97,11 @@ static int ptrace_write_user(struct task_struct *tsk, unsigned long offset,
 {
 	unsigned long *regs;
 
+	pr_debug("ptrace_write_user(%s[%u], %#lx, %#lx)\n",
+			tsk->comm, tsk->pid, offset, value);
+
 	if (offset & 3 || offset >= sizeof(struct user)) {
-		printk("ptrace_write_user: invalid offset 0x%08lx\n", offset);
+		pr_debug("  invalid offset 0x%08lx\n", offset);
 		return -EIO;
 	}
 
@@ -155,11 +144,9 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
 	int ret;
 
-	pr_debug("arch_ptrace(%ld, %d, %#lx, %#lx)\n",
-		 request, child->pid, addr, data);
-
 	pr_debug("ptrace: Enabling monitor mode...\n");
-	__mtdr(DBGREG_DC, __mfdr(DBGREG_DC) | DC_MM | DC_DBE);
+	ocd_write(DC, ocd_read(DC) | (1 << OCD_DC_MM_BIT)
+			| (1 << OCD_DC_DBE_BIT));
 
 	switch (request) {
 	/* Read the word at location addr in the child process */
@@ -240,19 +227,16 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		break;
 	}
 
-	pr_debug("sys_ptrace returning %d (DC = 0x%08lx)\n", ret, __mfdr(DBGREG_DC));
 	return ret;
 }
 
 asmlinkage void syscall_trace(void)
 {
-	pr_debug("syscall_trace called\n");
 	if (!test_thread_flag(TIF_SYSCALL_TRACE))
 		return;
 	if (!(current->ptrace & PT_PTRACED))
 		return;
 
-	pr_debug("syscall_trace: notifying parent\n");
 	/* The 0x80 provides a way for the tracing parent to
 	 * distinguish between a syscall stop and SIGTRAP delivery */
 	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD)
@@ -271,86 +255,143 @@ asmlinkage void syscall_trace(void)
 	}
 }
 
-asmlinkage void do_debug_priv(struct pt_regs *regs)
-{
-	unsigned long dc, ds;
-	unsigned long die_val;
-
-	ds = __mfdr(DBGREG_DS);
-
-	pr_debug("do_debug_priv: pc = %08lx, ds = %08lx\n", regs->pc, ds);
-
-	if (ds & DS_SSS)
-		die_val = DIE_SSTEP;
-	else
-		die_val = DIE_BREAKPOINT;
-
-	if (notify_die(die_val, "ptrace", regs, 0, 0, SIGTRAP) == NOTIFY_STOP)
-		return;
-
-	if (likely(ds & DS_SSS)) {
-		extern void itlb_miss(void);
-		extern void tlb_miss_common(void);
-		struct thread_info *ti;
-
-		dc = __mfdr(DBGREG_DC);
-		dc &= ~DC_SS;
-		__mtdr(DBGREG_DC, dc);
-
-		ti = current_thread_info();
-		set_ti_thread_flag(ti, TIF_BREAKPOINT);
-
-		/* The TLB miss handlers don't check thread flags */
-		if ((regs->pc >= (unsigned long)&itlb_miss)
-		    && (regs->pc <= (unsigned long)&tlb_miss_common)) {
-			__mtdr(DBGREG_BWA2A, sysreg_read(RAR_EX));
-			__mtdr(DBGREG_BWC2A, 0x40000001 | (get_asid() << 1));
-		}
-
-		/*
-		 * If we're running in supervisor mode, the breakpoint
-		 * will take us where we want directly, no need to
-		 * single step.
-		 */
-		if ((regs->sr & MODE_MASK) != MODE_SUPERVISOR)
-			set_ti_thread_flag(ti, TIF_SINGLE_STEP);
-	} else {
-		panic("Unable to handle debug trap at pc = %08lx\n",
-		      regs->pc);
-	}
-}
-
 /*
- * Handle breakpoints, single steps and other debuggy things. To keep
- * things simple initially, we run with interrupts and exceptions
- * disabled all the time.
+ * debug_trampoline() is an assembly stub which will store all user
+ * registers on the stack and execute a breakpoint instruction.
+ *
+ * If we single-step into an exception handler which runs with
+ * interrupts disabled the whole time so it doesn't have to check for
+ * pending work, its return address will be modified so that it ends
+ * up returning to debug_trampoline.
+ *
+ * If the exception handler decides to store the user context and
+ * enable interrupts after all, it will restore the original return
+ * address and status register value. Before it returns, it will
+ * notice that TIF_BREAKPOINT is set and execute a breakpoint
+ * instruction.
  */
-asmlinkage void do_debug(struct pt_regs *regs)
-{
-	unsigned long dc, ds;
+extern void debug_trampoline(void);
 
-	ds = __mfdr(DBGREG_DS);
-	pr_debug("do_debug: pc = %08lx, ds = %08lx\n", regs->pc, ds);
+asmlinkage struct pt_regs *do_debug(struct pt_regs *regs)
+{
+	struct thread_info	*ti;
+	unsigned long		trampoline_addr;
+	u32			status;
+	u32			ctrl;
+	int			code;
+
+	status = ocd_read(DS);
+	ti = current_thread_info();
+	code = TRAP_BRKPT;
+
+	pr_debug("do_debug: status=0x%08x PC=0x%08lx SR=0x%08lx tif=0x%08lx\n",
+			status, regs->pc, regs->sr, ti->flags);
+
+	if (!user_mode(regs)) {
+		unsigned long	die_val = DIE_BREAKPOINT;
+
+		if (status & (1 << OCD_DS_SSS_BIT))
+			die_val = DIE_SSTEP;
+
+		if (notify_die(die_val, "ptrace", regs, 0, 0, SIGTRAP)
+				== NOTIFY_STOP)
+			return regs;
+
+		if ((status & (1 << OCD_DS_SWB_BIT))
+				&& test_and_clear_ti_thread_flag(
+					ti, TIF_BREAKPOINT)) {
+			/*
+			 * Explicit breakpoint from trampoline or
+			 * exception/syscall/interrupt handler.
+			 *
+			 * The real saved regs are on the stack right
+			 * after the ones we saved on entry.
+			 */
+			regs++;
+			pr_debug("  -> TIF_BREAKPOINT done, adjusted regs:"
+					"PC=0x%08lx SR=0x%08lx\n",
+					regs->pc, regs->sr);
+			BUG_ON(!user_mode(regs));
+
+			if (test_thread_flag(TIF_SINGLE_STEP)) {
+				pr_debug("Going to do single step...\n");
+				return regs;
+			}
+
+			/*
+			 * No TIF_SINGLE_STEP means we're done
+			 * stepping over a syscall. Do the trap now.
+			 */
+			code = TRAP_TRACE;
+		} else if ((status & (1 << OCD_DS_SSS_BIT))
+				&& test_ti_thread_flag(ti, TIF_SINGLE_STEP)) {
+
+			pr_debug("Stepped into something, "
+					"setting TIF_BREAKPOINT...\n");
+			set_ti_thread_flag(ti, TIF_BREAKPOINT);
+
+			/*
+			 * We stepped into an exception, interrupt or
+			 * syscall handler. Some exception handlers
+			 * don't check for pending work, so we need to
+			 * set up a trampoline just in case.
+			 *
+			 * The exception entry code will undo the
+			 * trampoline stuff if it does a full context
+			 * save (which also means that it'll check for
+			 * pending work later.)
+			 */
+			if ((regs->sr & MODE_MASK) == MODE_EXCEPTION) {
+				trampoline_addr
+					= (unsigned long)&debug_trampoline;
+
+				pr_debug("Setting up trampoline...\n");
+				ti->rar_saved = sysreg_read(RAR_EX);
+				ti->rsr_saved = sysreg_read(RSR_EX);
+				sysreg_write(RAR_EX, trampoline_addr);
+				sysreg_write(RSR_EX, (MODE_EXCEPTION
+							| SR_EM | SR_GM));
+				BUG_ON(ti->rsr_saved & MODE_MASK);
+			}
+
+			/*
+			 * If we stepped into a system call, we
+			 * shouldn't do a single step after we return
+			 * since the return address is right after the
+			 * "scall" instruction we were told to step
+			 * over.
+			 */
+			if ((regs->sr & MODE_MASK) == MODE_SUPERVISOR) {
+				pr_debug("Supervisor; no single step\n");
+				clear_ti_thread_flag(ti, TIF_SINGLE_STEP);
+			}
+
+			ctrl = ocd_read(DC);
+			ctrl &= ~(1 << OCD_DC_SS_BIT);
+			ocd_write(DC, ctrl);
+
+			return regs;
+		} else {
+			printk(KERN_ERR "Unexpected OCD_DS value: 0x%08x\n",
+					status);
+			printk(KERN_ERR "Thread flags: 0x%08lx\n", ti->flags);
+			die("Unhandled debug trap in kernel mode",
+					regs, SIGTRAP);
+		}
+	} else if (status & (1 << OCD_DS_SSS_BIT)) {
+		/* Single step in user mode */
+		code = TRAP_TRACE;
 
-	if (test_thread_flag(TIF_BREAKPOINT)) {
-		pr_debug("TIF_BREAKPOINT set\n");
-		/* We're taking care of it */
-		clear_thread_flag(TIF_BREAKPOINT);
-		__mtdr(DBGREG_BWC2A, 0);
+		ctrl = ocd_read(DC);
+		ctrl &= ~(1 << OCD_DC_SS_BIT);
+		ocd_write(DC, ctrl);
 	}
 
-	if (test_thread_flag(TIF_SINGLE_STEP)) {
-		pr_debug("TIF_SINGLE_STEP set, ds = 0x%08lx\n", ds);
-		if (ds & DS_SSS) {
-			dc = __mfdr(DBGREG_DC);
-			dc &= ~DC_SS;
-			__mtdr(DBGREG_DC, dc);
+	pr_debug("Sending SIGTRAP: code=%d PC=0x%08lx SR=0x%08lx\n",
+			code, regs->pc, regs->sr);
 
-			clear_thread_flag(TIF_SINGLE_STEP);
-			ptrace_break(current, regs);
-		}
-	} else {
-		/* regular breakpoint */
-		ptrace_break(current, regs);
-	}
+	clear_thread_flag(TIF_SINGLE_STEP);
+	_exception(SIGTRAP, regs, code, instruction_pointer(regs));
+
+	return regs;
 }
diff --git a/arch/avr32/kernel/stacktrace.c b/arch/avr32/kernel/stacktrace.c
new file mode 100644
index 0000000..9a68190
--- /dev/null
+++ b/arch/avr32/kernel/stacktrace.c
@@ -0,0 +1,53 @@
+/*
+ * Stack trace management functions
+ *
+ * Copyright (C) 2007 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/sched.h>
+#include <linux/stacktrace.h>
+#include <linux/thread_info.h>
+
+register unsigned long current_frame_pointer asm("r7");
+
+struct stackframe {
+	unsigned long lr;
+	unsigned long fp;
+};
+
+/*
+ * Save stack-backtrace addresses into a stack_trace buffer.
+ */
+void save_stack_trace(struct stack_trace *trace)
+{
+	unsigned long low, high;
+	unsigned long fp;
+	struct stackframe *frame;
+	int skip = trace->skip;
+
+	low = (unsigned long)task_stack_page(current);
+	high = low + THREAD_SIZE;
+	fp = current_frame_pointer;
+
+	while (fp >= low && fp <= (high - 8)) {
+		frame = (struct stackframe *)fp;
+
+		if (skip) {
+			skip--;
+		} else {
+			trace->entries[trace->nr_entries++] = frame->lr;
+			if (trace->nr_entries >= trace->max_entries)
+				break;
+		}
+
+		/*
+		 * The next frame must be at a higher address than the
+		 * current frame.
+		 */
+		low = fp + 8;
+		fp = frame->fp;
+	}
+}
diff --git a/arch/avr32/kernel/traps.c b/arch/avr32/kernel/traps.c
index 8a7caf8..870c075 100644
--- a/arch/avr32/kernel/traps.c
+++ b/arch/avr32/kernel/traps.c
@@ -39,7 +39,7 @@ void NORET_TYPE die(const char *str, struct pt_regs *regs, long err)
 	printk("FRAME_POINTER ");
 #endif
 	if (current_cpu_data.features & AVR32_FEATURE_OCD) {
-		unsigned long did = __mfdr(DBGREG_DID);
+		unsigned long did = ocd_read(DID);
 		printk("chip: 0x%03lx:0x%04lx rev %lu\n",
 		       (did >> 1) & 0x7ff,
 		       (did >> 12) & 0x7fff,
diff --git a/arch/avr32/kernel/vmlinux.lds.S b/arch/avr32/kernel/vmlinux.lds.S
index ce9ac96..11f08e3 100644
--- a/arch/avr32/kernel/vmlinux.lds.S
+++ b/arch/avr32/kernel/vmlinux.lds.S
@@ -77,10 +77,10 @@ SECTIONS
 		. = 0x100;
 		*(.scall.text)
 		*(.irq.text)
+		KPROBES_TEXT
 		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
-		KPROBES_TEXT
 		*(.fixup)
 		*(.gnu.warning)
 		_etext = .;
diff --git a/arch/avr32/mm/cache.c b/arch/avr32/mm/cache.c
index c1233c6..15a4e5e 100644
--- a/arch/avr32/mm/cache.c
+++ b/arch/avr32/mm/cache.c
@@ -122,16 +122,6 @@ void flush_icache_page(struct vm_area_struct *vma, struct page *page)
 	}
 }
 
-/*
- * This one is used by copy_to_user_page()
- */
-void flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
-			     unsigned long addr, int len)
-{
-	if (vma->vm_flags & VM_EXEC)
-		flush_icache_range(addr, addr + len);
-}
-
 asmlinkage int sys_cacheflush(int operation, void __user *addr, size_t len)
 {
 	int ret;
@@ -159,3 +149,13 @@ asmlinkage int sys_cacheflush(int operation, void __user *addr, size_t len)
 out:
 	return ret;
 }
+
+void copy_to_user_page(struct vm_area_struct *vma, struct page *page,
+		unsigned long vaddr, void *dst, const void *src,
+		unsigned long len)
+{
+	memcpy(dst, src, len);
+	if (vma->vm_flags & VM_EXEC)
+		flush_icache_range((unsigned long)dst,
+				(unsigned long)dst + len);
+}
diff --git a/include/asm-avr32/cacheflush.h b/include/asm-avr32/cacheflush.h
index dfaaa88..6706747 100644
--- a/include/asm-avr32/cacheflush.h
+++ b/include/asm-avr32/cacheflush.h
@@ -116,15 +116,16 @@ extern void flush_icache_page(struct vm_area_struct *vma, struct page *page);
  * flush with all configurations.
  */
 extern void flush_icache_range(unsigned long start, unsigned long end);
-extern void flush_icache_user_range(struct vm_area_struct *vma,
-				    struct page *page,
-				    unsigned long addr, int len);
 
-#define copy_to_user_page(vma, page, vaddr, dst, src, len) do {	\
-	memcpy(dst, src, len);					\
-	flush_icache_user_range(vma, page, vaddr, len);		\
-} while(0)
-#define copy_from_user_page(vma, page, vaddr, dst, src, len)	\
-	memcpy(dst, src, len)
+extern void copy_to_user_page(struct vm_area_struct *vma, struct page *page,
+		unsigned long vaddr, void *dst, const void *src,
+		unsigned long len);
+
+static inline void copy_from_user_page(struct vm_area_struct *vma,
+		struct page *page, unsigned long vaddr, void *dst,
+		const void *src, unsigned long len)
+{
+	memcpy(dst, src, len);
+}
 
 #endif /* __ASM_AVR32_CACHEFLUSH_H */
diff --git a/include/asm-avr32/ocd.h b/include/asm-avr32/ocd.h
index 46f7318..996405e 100644
--- a/include/asm-avr32/ocd.h
+++ b/include/asm-avr32/ocd.h
@@ -1,7 +1,7 @@
 /*
- * AVR32 OCD Registers
+ * AVR32 OCD Interface and register definitions
  *
- * Copyright (C) 2004-2006 Atmel Corporation
+ * Copyright (C) 2004-2007 Atmel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -10,69 +10,529 @@
 #ifndef __ASM_AVR32_OCD_H
 #define __ASM_AVR32_OCD_H
 
-/* Debug Registers */
-#define DBGREG_DID		  0
-#define DBGREG_DC		  8
-#define DBGREG_DS		 16
-#define DBGREG_RWCS		 28
-#define DBGREG_RWA		 36
-#define DBGREG_RWD		 40
-#define DBGREG_WT		 44
-#define DBGREG_DTC		 52
-#define DBGREG_DTSA0		 56
-#define DBGREG_DTSA1		 60
-#define DBGREG_DTEA0		 72
-#define DBGREG_DTEA1		 76
-#define DBGREG_BWC0A		 88
-#define DBGREG_BWC0B		 92
-#define DBGREG_BWC1A		 96
-#define DBGREG_BWC1B		100
-#define DBGREG_BWC2A		104
-#define DBGREG_BWC2B		108
-#define DBGREG_BWC3A		112
-#define DBGREG_BWC3B		116
-#define DBGREG_BWA0A		120
-#define DBGREG_BWA0B		124
-#define DBGREG_BWA1A		128
-#define DBGREG_BWA1B		132
-#define DBGREG_BWA2A		136
-#define DBGREG_BWA2B		140
-#define DBGREG_BWA3A		144
-#define DBGREG_BWA3B		148
-#define DBGREG_BWD3A		153
-#define DBGREG_BWD3B		156
-
-#define DBGREG_PID		284
-
-#define SABAH_OCD		0x01
-#define SABAH_ICACHE		0x02
-#define SABAH_MEM_CACHED	0x04
-#define SABAH_MEM_UNCACHED	0x05
-
-/* Fields in the Development Control register */
-#define DC_SS_BIT		8
-
-#define DC_SS			(1 <<  DC_SS_BIT)
-#define DC_DBE			(1 << 13)
-#define DC_RID			(1 << 27)
-#define DC_ORP			(1 << 28)
-#define DC_MM			(1 << 29)
-#define DC_RES			(1 << 30)
-
-/* Fields in the Development Status register */
-#define DS_SSS			(1 <<  0)
-#define DS_SWB			(1 <<  1)
-#define DS_HWB			(1 <<  2)
-#define DS_BP_SHIFT		8
-#define DS_BP_MASK		(0xff << DS_BP_SHIFT)
-
-#define __mfdr(addr)							\
-({									\
-	register unsigned long value;					\
-	asm volatile("mfdr	%0, %1" : "=r"(value) : "i"(addr));	\
-	value;								\
-})
-#define __mtdr(addr, value)						\
-	asm volatile("mtdr	%0, %1" : : "i"(addr), "r"(value))
+/* OCD Register offsets. Abbreviations used below:
+ *
+ *      BP      Breakpoint
+ *      Comm    Communication
+ *      DT      Data Trace
+ *      PC      Program Counter
+ *      PID     Process ID
+ *      R/W     Read/Write
+ *      WP      Watchpoint
+ */
+#define OCD_DID				0x0000  /* Device ID */
+#define OCD_DC				0x0008  /* Development Control */
+#define OCD_DS				0x0010  /* Development Status */
+#define OCD_RWCS			0x001c  /* R/W Access Control */
+#define OCD_RWA				0x0024  /* R/W Access Address */
+#define OCD_RWD				0x0028  /* R/W Access Data */
+#define OCD_WT				0x002c  /* Watchpoint Trigger */
+#define OCD_DTC				0x0034  /* Data Trace Control */
+#define OCD_DTSA0			0x0038  /* DT Start Addr Channel 0 */
+#define OCD_DTSA1			0x003c  /* DT Start Addr Channel 1 */
+#define OCD_DTEA0			0x0048  /* DT End Addr Channel 0 */
+#define OCD_DTEA1			0x004c  /* DT End Addr Channel 1 */
+#define OCD_BWC0A			0x0058  /* PC BP/WP Control 0A */
+#define OCD_BWC0B			0x005c  /* PC BP/WP Control 0B */
+#define OCD_BWC1A			0x0060  /* PC BP/WP Control 1A */
+#define OCD_BWC1B			0x0064  /* PC BP/WP Control 1B */
+#define OCD_BWC2A			0x0068  /* PC BP/WP Control 2A */
+#define OCD_BWC2B			0x006c  /* PC BP/WP Control 2B */
+#define OCD_BWC3A			0x0070  /* Data BP/WP Control 3A */
+#define OCD_BWC3B			0x0074  /* Data BP/WP Control 3B */
+#define OCD_BWA0A			0x0078  /* PC BP/WP Address 0A */
+#define OCD_BWA0B			0x007c  /* PC BP/WP Address 0B */
+#define OCD_BWA1A			0x0080  /* PC BP/WP Address 1A */
+#define OCD_BWA1B			0x0084  /* PC BP/WP Address 1B */
+#define OCD_BWA2A			0x0088  /* PC BP/WP Address 2A */
+#define OCD_BWA2B			0x008c  /* PC BP/WP Address 2B */
+#define OCD_BWA3A			0x0090  /* Data BP/WP Address 3A */
+#define OCD_BWA3B			0x0094  /* Data BP/WP Address 3B */
+#define OCD_NXCFG			0x0100  /* Nexus Configuration */
+#define OCD_DINST			0x0104  /* Debug Instruction */
+#define OCD_DPC				0x0108  /* Debug Program Counter */
+#define OCD_CPUCM			0x010c  /* CPU Control Mask */
+#define OCD_DCCPU			0x0110  /* Debug Comm CPU */
+#define OCD_DCEMU			0x0114  /* Debug Comm Emulator */
+#define OCD_DCSR			0x0118  /* Debug Comm Status */
+#define OCD_PID				0x011c  /* Ownership Trace PID */
+#define OCD_EPC0			0x0120  /* Event Pair Control 0 */
+#define OCD_EPC1			0x0124  /* Event Pair Control 1 */
+#define OCD_EPC2			0x0128  /* Event Pair Control 2 */
+#define OCD_EPC3			0x012c  /* Event Pair Control 3 */
+#define OCD_AXC				0x0130  /* AUX port Control */
+
+/* Bits in DID */
+#define OCD_DID_MID_START		1
+#define OCD_DID_MID_SIZE		11
+#define OCD_DID_PN_START		12
+#define OCD_DID_PN_SIZE			16
+#define OCD_DID_RN_START		28
+#define OCD_DID_RN_SIZE			4
+
+/* Bits in DC */
+#define OCD_DC_TM_START			0
+#define OCD_DC_TM_SIZE			2
+#define OCD_DC_EIC_START		3
+#define OCD_DC_EIC_SIZE			2
+#define OCD_DC_OVC_START		5
+#define OCD_DC_OVC_SIZE			3
+#define OCD_DC_SS_BIT			8
+#define OCD_DC_DBR_BIT			12
+#define OCD_DC_DBE_BIT			13
+#define OCD_DC_EOS_START		20
+#define OCD_DC_EOS_SIZE			2
+#define OCD_DC_SQA_BIT			22
+#define OCD_DC_IRP_BIT			23
+#define OCD_DC_IFM_BIT			24
+#define OCD_DC_TOZ_BIT			25
+#define OCD_DC_TSR_BIT			26
+#define OCD_DC_RID_BIT			27
+#define OCD_DC_ORP_BIT			28
+#define OCD_DC_MM_BIT			29
+#define OCD_DC_RES_BIT			30
+#define OCD_DC_ABORT_BIT		31
+
+/* Bits in DS */
+#define OCD_DS_SSS_BIT			0
+#define OCD_DS_SWB_BIT			1
+#define OCD_DS_HWB_BIT			2
+#define OCD_DS_HWE_BIT			3
+#define OCD_DS_STP_BIT			4
+#define OCD_DS_DBS_BIT			5
+#define OCD_DS_BP_START			8
+#define OCD_DS_BP_SIZE			8
+#define OCD_DS_INC_BIT			24
+#define OCD_DS_BOZ_BIT			25
+#define OCD_DS_DBA_BIT			26
+#define OCD_DS_EXB_BIT			27
+#define OCD_DS_NTBF_BIT			28
+
+/* Bits in RWCS */
+#define OCD_RWCS_DV_BIT			0
+#define OCD_RWCS_ERR_BIT		1
+#define OCD_RWCS_CNT_START		2
+#define OCD_RWCS_CNT_SIZE		14
+#define OCD_RWCS_CRC_BIT		19
+#define OCD_RWCS_NTBC_START		20
+#define OCD_RWCS_NTBC_SIZE		2
+#define OCD_RWCS_NTE_BIT		22
+#define OCD_RWCS_NTAP_BIT		23
+#define OCD_RWCS_WRAPPED_BIT		24
+#define OCD_RWCS_CCTRL_START		25
+#define OCD_RWCS_CCTRL_SIZE		2
+#define OCD_RWCS_SZ_START		27
+#define OCD_RWCS_SZ_SIZE		3
+#define OCD_RWCS_RW_BIT			30
+#define OCD_RWCS_AC_BIT			31
+
+/* Bits in RWA */
+#define OCD_RWA_RWA_START		0
+#define OCD_RWA_RWA_SIZE		32
+
+/* Bits in RWD */
+#define OCD_RWD_RWD_START		0
+#define OCD_RWD_RWD_SIZE		32
+
+/* Bits in WT */
+#define OCD_WT_DTE_START		20
+#define OCD_WT_DTE_SIZE			3
+#define OCD_WT_DTS_START		23
+#define OCD_WT_DTS_SIZE			3
+#define OCD_WT_PTE_START		26
+#define OCD_WT_PTE_SIZE			3
+#define OCD_WT_PTS_START		29
+#define OCD_WT_PTS_SIZE			3
+
+/* Bits in DTC */
+#define OCD_DTC_T0WP_BIT		0
+#define OCD_DTC_T1WP_BIT		1
+#define OCD_DTC_ASID0EN_BIT		2
+#define OCD_DTC_ASID0_START		3
+#define OCD_DTC_ASID0_SIZE		8
+#define OCD_DTC_ASID1EN_BIT		11
+#define OCD_DTC_ASID1_START		12
+#define OCD_DTC_ASID1_SIZE		8
+#define OCD_DTC_RWT1_START		28
+#define OCD_DTC_RWT1_SIZE		2
+#define OCD_DTC_RWT0_START		30
+#define OCD_DTC_RWT0_SIZE		2
+
+/* Bits in DTSA0 */
+#define OCD_DTSA0_DTSA_START		0
+#define OCD_DTSA0_DTSA_SIZE		32
+
+/* Bits in DTSA1 */
+#define OCD_DTSA1_DTSA_START		0
+#define OCD_DTSA1_DTSA_SIZE		32
+
+/* Bits in DTEA0 */
+#define OCD_DTEA0_DTEA_START		0
+#define OCD_DTEA0_DTEA_SIZE		32
+
+/* Bits in DTEA1 */
+#define OCD_DTEA1_DTEA_START		0
+#define OCD_DTEA1_DTEA_SIZE		32
+
+/* Bits in BWC0A */
+#define OCD_BWC0A_ASIDEN_BIT		0
+#define OCD_BWC0A_ASID_START		1
+#define OCD_BWC0A_ASID_SIZE		8
+#define OCD_BWC0A_EOC_BIT		14
+#define OCD_BWC0A_AME_BIT		25
+#define OCD_BWC0A_BWE_START		30
+#define OCD_BWC0A_BWE_SIZE		2
+
+/* Bits in BWC0B */
+#define OCD_BWC0B_ASIDEN_BIT		0
+#define OCD_BWC0B_ASID_START		1
+#define OCD_BWC0B_ASID_SIZE		8
+#define OCD_BWC0B_EOC_BIT		14
+#define OCD_BWC0B_AME_BIT		25
+#define OCD_BWC0B_BWE_START		30
+#define OCD_BWC0B_BWE_SIZE		2
+
+/* Bits in BWC1A */
+#define OCD_BWC1A_ASIDEN_BIT		0
+#define OCD_BWC1A_ASID_START		1
+#define OCD_BWC1A_ASID_SIZE		8
+#define OCD_BWC1A_EOC_BIT		14
+#define OCD_BWC1A_AME_BIT		25
+#define OCD_BWC1A_BWE_START		30
+#define OCD_BWC1A_BWE_SIZE		2
+
+/* Bits in BWC1B */
+#define OCD_BWC1B_ASIDEN_BIT		0
+#define OCD_BWC1B_ASID_START		1
+#define OCD_BWC1B_ASID_SIZE		8
+#define OCD_BWC1B_EOC_BIT		14
+#define OCD_BWC1B_AME_BIT		25
+#define OCD_BWC1B_BWE_START		30
+#define OCD_BWC1B_BWE_SIZE		2
+
+/* Bits in BWC2A */
+#define OCD_BWC2A_ASIDEN_BIT		0
+#define OCD_BWC2A_ASID_START		1
+#define OCD_BWC2A_ASID_SIZE		8
+#define OCD_BWC2A_EOC_BIT		14
+#define OCD_BWC2A_AMB_START		20
+#define OCD_BWC2A_AMB_SIZE		5
+#define OCD_BWC2A_AME_BIT		25
+#define OCD_BWC2A_BWE_START		30
+#define OCD_BWC2A_BWE_SIZE		2
+
+/* Bits in BWC2B */
+#define OCD_BWC2B_ASIDEN_BIT		0
+#define OCD_BWC2B_ASID_START		1
+#define OCD_BWC2B_ASID_SIZE		8
+#define OCD_BWC2B_EOC_BIT		14
+#define OCD_BWC2B_AME_BIT		25
+#define OCD_BWC2B_BWE_START		30
+#define OCD_BWC2B_BWE_SIZE		2
+
+/* Bits in BWC3A */
+#define OCD_BWC3A_ASIDEN_BIT		0
+#define OCD_BWC3A_ASID_START		1
+#define OCD_BWC3A_ASID_SIZE		8
+#define OCD_BWC3A_SIZE_START		9
+#define OCD_BWC3A_SIZE_SIZE		3
+#define OCD_BWC3A_EOC_BIT		14
+#define OCD_BWC3A_BWO_START		16
+#define OCD_BWC3A_BWO_SIZE		2
+#define OCD_BWC3A_BME_START		20
+#define OCD_BWC3A_BME_SIZE		4
+#define OCD_BWC3A_BRW_START		28
+#define OCD_BWC3A_BRW_SIZE		2
+#define OCD_BWC3A_BWE_START		30
+#define OCD_BWC3A_BWE_SIZE		2
+
+/* Bits in BWC3B */
+#define OCD_BWC3B_ASIDEN_BIT		0
+#define OCD_BWC3B_ASID_START		1
+#define OCD_BWC3B_ASID_SIZE		8
+#define OCD_BWC3B_SIZE_START		9
+#define OCD_BWC3B_SIZE_SIZE		3
+#define OCD_BWC3B_EOC_BIT		14
+#define OCD_BWC3B_BWO_START		16
+#define OCD_BWC3B_BWO_SIZE		2
+#define OCD_BWC3B_BME_START		20
+#define OCD_BWC3B_BME_SIZE		4
+#define OCD_BWC3B_BRW_START		28
+#define OCD_BWC3B_BRW_SIZE		2
+#define OCD_BWC3B_BWE_START		30
+#define OCD_BWC3B_BWE_SIZE		2
+
+/* Bits in BWA0A */
+#define OCD_BWA0A_BWA_START		0
+#define OCD_BWA0A_BWA_SIZE		32
+
+/* Bits in BWA0B */
+#define OCD_BWA0B_BWA_START		0
+#define OCD_BWA0B_BWA_SIZE		32
+
+/* Bits in BWA1A */
+#define OCD_BWA1A_BWA_START		0
+#define OCD_BWA1A_BWA_SIZE		32
+
+/* Bits in BWA1B */
+#define OCD_BWA1B_BWA_START		0
+#define OCD_BWA1B_BWA_SIZE		32
+
+/* Bits in BWA2A */
+#define OCD_BWA2A_BWA_START		0
+#define OCD_BWA2A_BWA_SIZE		32
+
+/* Bits in BWA2B */
+#define OCD_BWA2B_BWA_START		0
+#define OCD_BWA2B_BWA_SIZE		32
+
+/* Bits in BWA3A */
+#define OCD_BWA3A_BWA_START		0
+#define OCD_BWA3A_BWA_SIZE		32
+
+/* Bits in BWA3B */
+#define OCD_BWA3B_BWA_START		0
+#define OCD_BWA3B_BWA_SIZE		32
+
+/* Bits in NXCFG */
+#define OCD_NXCFG_NXARCH_START		0
+#define OCD_NXCFG_NXARCH_SIZE		4
+#define OCD_NXCFG_NXOCD_START		4
+#define OCD_NXCFG_NXOCD_SIZE		4
+#define OCD_NXCFG_NXPCB_START		8
+#define OCD_NXCFG_NXPCB_SIZE		4
+#define OCD_NXCFG_NXDB_START		12
+#define OCD_NXCFG_NXDB_SIZE		4
+#define OCD_NXCFG_MXMSEO_BIT		16
+#define OCD_NXCFG_NXMDO_START		17
+#define OCD_NXCFG_NXMDO_SIZE		4
+#define OCD_NXCFG_NXPT_BIT		21
+#define OCD_NXCFG_NXOT_BIT		22
+#define OCD_NXCFG_NXDWT_BIT		23
+#define OCD_NXCFG_NXDRT_BIT		24
+#define OCD_NXCFG_NXDTC_START		25
+#define OCD_NXCFG_NXDTC_SIZE		3
+#define OCD_NXCFG_NXDMA_BIT		28
+
+/* Bits in DINST */
+#define OCD_DINST_DINST_START		0
+#define OCD_DINST_DINST_SIZE		32
+
+/* Bits in CPUCM */
+#define OCD_CPUCM_BEM_BIT		1
+#define OCD_CPUCM_FEM_BIT		2
+#define OCD_CPUCM_REM_BIT		3
+#define OCD_CPUCM_IBEM_BIT		4
+#define OCD_CPUCM_IEEM_BIT		5
+
+/* Bits in DCCPU */
+#define OCD_DCCPU_DATA_START		0
+#define OCD_DCCPU_DATA_SIZE		32
+
+/* Bits in DCEMU */
+#define OCD_DCEMU_DATA_START		0
+#define OCD_DCEMU_DATA_SIZE		32
+
+/* Bits in DCSR */
+#define OCD_DCSR_CPUD_BIT		0
+#define OCD_DCSR_EMUD_BIT		1
+
+/* Bits in PID */
+#define OCD_PID_PROCESS_START		0
+#define OCD_PID_PROCESS_SIZE		32
+
+/* Bits in EPC0 */
+#define OCD_EPC0_RNG_START		0
+#define OCD_EPC0_RNG_SIZE		2
+#define OCD_EPC0_CE_BIT			4
+#define OCD_EPC0_ECNT_START		16
+#define OCD_EPC0_ECNT_SIZE		16
+
+/* Bits in EPC1 */
+#define OCD_EPC1_RNG_START		0
+#define OCD_EPC1_RNG_SIZE		2
+#define OCD_EPC1_ATB_BIT		5
+#define OCD_EPC1_AM_BIT			6
+
+/* Bits in EPC2 */
+#define OCD_EPC2_RNG_START		0
+#define OCD_EPC2_RNG_SIZE		2
+#define OCD_EPC2_DB_START		2
+#define OCD_EPC2_DB_SIZE		2
+
+/* Bits in EPC3 */
+#define OCD_EPC3_RNG_START		0
+#define OCD_EPC3_RNG_SIZE		2
+#define OCD_EPC3_DWE_BIT		2
+
+/* Bits in AXC */
+#define OCD_AXC_DIV_START		0
+#define OCD_AXC_DIV_SIZE		4
+#define OCD_AXC_AXE_BIT			8
+#define OCD_AXC_AXS_BIT			9
+#define OCD_AXC_DDR_BIT			10
+#define OCD_AXC_LS_BIT			11
+#define OCD_AXC_REX_BIT			12
+#define OCD_AXC_REXTEN_BIT		13
+
+/* Constants for DC:EIC */
+#define OCD_EIC_PROGRAM_AND_DATA_TRACE	0
+#define OCD_EIC_BREAKPOINT		1
+#define OCD_EIC_NOP			2
+
+/* Constants for DC:OVC */
+#define OCD_OVC_OVERRUN			0
+#define OCD_OVC_DELAY_CPU_BTM		1
+#define OCD_OVC_DELAY_CPU_DTM		2
+#define OCD_OVC_DELAY_CPU_BTM_DTM	3
+
+/* Constants for DC:EOS */
+#define OCD_EOS_NOP			0
+#define OCD_EOS_DEBUG_MODE		1
+#define OCD_EOS_BREAKPOINT_WATCHPOINT	2
+#define OCD_EOS_THQ			3
+
+/* Constants for RWCS:NTBC */
+#define OCD_NTBC_OVERWRITE		0
+#define OCD_NTBC_DISABLE		1
+#define OCD_NTBC_BREAKPOINT		2
+
+/* Constants for RWCS:CCTRL */
+#define OCD_CCTRL_AUTO			0
+#define OCD_CCTRL_CACHED		1
+#define OCD_CCTRL_UNCACHED		2
+
+/* Constants for RWCS:SZ */
+#define OCD_SZ_BYTE			0
+#define OCD_SZ_HALFWORD			1
+#define OCD_SZ_WORD			2
+
+/* Constants for WT:PTS */
+#define OCD_PTS_DISABLED		0
+#define OCD_PTS_PROGRAM_0B		1
+#define OCD_PTS_PROGRAM_1A		2
+#define OCD_PTS_PROGRAM_1B		3
+#define OCD_PTS_PROGRAM_2A		4
+#define OCD_PTS_PROGRAM_2B		5
+#define OCD_PTS_DATA_3A			6
+#define OCD_PTS_DATA_3B			7
+
+/* Constants for DTC:RWT1 */
+#define OCD_RWT1_NO_TRACE		0
+#define OCD_RWT1_DATA_READ		1
+#define OCD_RWT1_DATA_WRITE		2
+#define OCD_RWT1_DATA_READ_WRITE	3
+
+/* Constants for DTC:RWT0 */
+#define OCD_RWT0_NO_TRACE		0
+#define OCD_RWT0_DATA_READ		1
+#define OCD_RWT0_DATA_WRITE		2
+#define OCD_RWT0_DATA_READ_WRITE	3
+
+/* Constants for BWC0A:BWE */
+#define OCD_BWE_DISABLED		0
+#define OCD_BWE_BREAKPOINT_ENABLED	1
+#define OCD_BWE_WATCHPOINT_ENABLED	3
+
+/* Constants for BWC0B:BWE */
+#define OCD_BWE_DISABLED		0
+#define OCD_BWE_BREAKPOINT_ENABLED	1
+#define OCD_BWE_WATCHPOINT_ENABLED	3
+
+/* Constants for BWC1A:BWE */
+#define OCD_BWE_DISABLED		0
+#define OCD_BWE_BREAKPOINT_ENABLED	1
+#define OCD_BWE_WATCHPOINT_ENABLED	3
+
+/* Constants for BWC1B:BWE */
+#define OCD_BWE_DISABLED		0
+#define OCD_BWE_BREAKPOINT_ENABLED	1
+#define OCD_BWE_WATCHPOINT_ENABLED	3
+
+/* Constants for BWC2A:BWE */
+#define OCD_BWE_DISABLED		0
+#define OCD_BWE_BREAKPOINT_ENABLED	1
+#define OCD_BWE_WATCHPOINT_ENABLED	3
+
+/* Constants for BWC2B:BWE */
+#define OCD_BWE_DISABLED		0
+#define OCD_BWE_BREAKPOINT_ENABLED	1
+#define OCD_BWE_WATCHPOINT_ENABLED	3
+
+/* Constants for BWC3A:SIZE */
+#define OCD_SIZE_BYTE_ACCESS		4
+#define OCD_SIZE_HALFWORD_ACCESS	5
+#define OCD_SIZE_WORD_ACCESS		6
+#define OCD_SIZE_DOUBLE_WORD_ACCESS	7
+
+/* Constants for BWC3A:BRW */
+#define OCD_BRW_READ_BREAK		0
+#define OCD_BRW_WRITE_BREAK		1
+#define OCD_BRW_ANY_ACCES_BREAK		2
+
+/* Constants for BWC3A:BWE */
+#define OCD_BWE_DISABLED		0
+#define OCD_BWE_BREAKPOINT_ENABLED	1
+#define OCD_BWE_WATCHPOINT_ENABLED	3
+
+/* Constants for BWC3B:SIZE */
+#define OCD_SIZE_BYTE_ACCESS		4
+#define OCD_SIZE_HALFWORD_ACCESS	5
+#define OCD_SIZE_WORD_ACCESS		6
+#define OCD_SIZE_DOUBLE_WORD_ACCESS	7
+
+/* Constants for BWC3B:BRW */
+#define OCD_BRW_READ_BREAK		0
+#define OCD_BRW_WRITE_BREAK		1
+#define OCD_BRW_ANY_ACCES_BREAK		2
+
+/* Constants for BWC3B:BWE */
+#define OCD_BWE_DISABLED		0
+#define OCD_BWE_BREAKPOINT_ENABLED	1
+#define OCD_BWE_WATCHPOINT_ENABLED	3
+
+/* Constants for EPC0:RNG */
+#define OCD_RNG_DISABLED		0
+#define OCD_RNG_EXCLUSIVE		1
+#define OCD_RNG_INCLUSIVE		2
+
+/* Constants for EPC1:RNG */
+#define OCD_RNG_DISABLED		0
+#define OCD_RNG_EXCLUSIVE		1
+#define OCD_RNG_INCLUSIVE		2
+
+/* Constants for EPC2:RNG */
+#define OCD_RNG_DISABLED		0
+#define OCD_RNG_EXCLUSIVE		1
+#define OCD_RNG_INCLUSIVE		2
+
+/* Constants for EPC2:DB */
+#define OCD_DB_DISABLED			0
+#define OCD_DB_CHAINED_B		1
+#define OCD_DB_CHAINED_A		2
+#define OCD_DB_AHAINED_A_AND_B		3
+
+/* Constants for EPC3:RNG */
+#define OCD_RNG_DISABLED		0
+#define OCD_RNG_EXCLUSIVE		1
+#define OCD_RNG_INCLUSIVE		2
+
+#ifndef __ASSEMBLER__
+
+/* Register access macros */
+static inline unsigned long __ocd_read(unsigned int reg)
+{
+	return __builtin_mfdr(reg);
+}
+
+static inline void __ocd_write(unsigned int reg, unsigned long value)
+{
+	__builtin_mtdr(reg, value);
+}
+
+#define ocd_read(reg)			__ocd_read(OCD_##reg)
+#define ocd_write(reg, value)		__ocd_write(OCD_##reg, value)
+
+#endif /* !__ASSEMBLER__ */
 
 #endif /* __ASM_AVR32_OCD_H */
diff --git a/include/asm-avr32/processor.h b/include/asm-avr32/processor.h
index 6a64833..a52576b 100644
--- a/include/asm-avr32/processor.h
+++ b/include/asm-avr32/processor.h
@@ -139,6 +139,9 @@ extern void show_regs_log_lvl(struct pt_regs *regs, const char *log_lvl);
 extern void show_stack_log_lvl(struct task_struct *tsk, unsigned long sp,
 			       struct pt_regs *regs, const char *log_lvl);
 
+#define task_pt_regs(p) \
+	((struct pt_regs *)(THREAD_SIZE + task_stack_page(p)) - 1)
+
 #define KSTK_EIP(tsk)	((tsk)->thread.cpu_context.pc)
 #define KSTK_ESP(tsk)	((tsk)->thread.cpu_context.ksp)
 
diff --git a/include/asm-avr32/ptrace.h b/include/asm-avr32/ptrace.h
index 60f0f19..8c5dba5 100644
--- a/include/asm-avr32/ptrace.h
+++ b/include/asm-avr32/ptrace.h
@@ -14,8 +14,7 @@
 /*
  * Status Register bits
  */
-#define SR_H		0x40000000
-#define SR_R		0x20000000
+#define SR_H		0x20000000
 #define SR_J		0x10000000
 #define SR_DM		0x08000000
 #define SR_D		0x04000000
@@ -35,8 +34,7 @@
 #define SR_I0M		0x00020000
 #define SR_GM		0x00010000
 
-#define SR_H_BIT	30
-#define SR_R_BIT	29
+#define SR_H_BIT	29
 #define SR_J_BIT	28
 #define SR_DM_BIT	27
 #define SR_D_BIT	26
diff --git a/include/asm-avr32/sysreg.h b/include/asm-avr32/sysreg.h
index dd21182..d4e0950 100644
--- a/include/asm-avr32/sysreg.h
+++ b/include/asm-avr32/sysreg.h
@@ -93,6 +93,8 @@
 #define SYSREG_I3M_SIZE				1
 #define SYSREG_EM_OFFSET			21
 #define SYSREG_EM_SIZE				1
+#define SYSREG_MODE_OFFSET			22
+#define SYSREG_MODE_SIZE			3
 #define SYSREG_M0_OFFSET			22
 #define SYSREG_M0_SIZE				1
 #define SYSREG_M1_OFFSET			23
diff --git a/include/asm-avr32/system.h b/include/asm-avr32/system.h
index dc2d527..c600cc1 100644
--- a/include/asm-avr32/system.h
+++ b/include/asm-avr32/system.h
@@ -35,8 +35,8 @@
 #include <asm/ocd.h>
 #define finish_arch_switch(prev)			\
 	do {						\
-		__mtdr(DBGREG_PID, prev->pid);		\
-		__mtdr(DBGREG_PID, current->pid);	\
+		ocd_write(PID, prev->pid);		\
+		ocd_write(PID, current->pid);		\
 	} while(0)
 #endif
 
diff --git a/include/asm-avr32/thread_info.h b/include/asm-avr32/thread_info.h
index 17dacf3..184b574 100644
--- a/include/asm-avr32/thread_info.h
+++ b/include/asm-avr32/thread_info.h
@@ -25,6 +25,11 @@ struct thread_info {
 	unsigned long		flags;		/* low level flags */
 	__u32			cpu;
 	__s32			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	__u32			rar_saved;	/* return address... */
+	__u32			rsr_saved;	/* ...and status register
+						   saved by debug handler
+						   when setting up
+						   trampoline */
 	struct restart_block	restart_block;
 	__u8			supervisor_stack[0];
 };
@@ -78,8 +83,8 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_NEED_RESCHED        2       /* rescheduling necessary */
 #define TIF_POLLING_NRFLAG      3       /* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
-#define TIF_BREAKPOINT		4	/* true if we should break after return */
-#define TIF_SINGLE_STEP		5	/* single step after next break */
+#define TIF_BREAKPOINT		4	/* enter monitor mode on return */
+#define TIF_SINGLE_STEP		5	/* single step in progress */
 #define TIF_MEMDIE		6
 #define TIF_RESTORE_SIGMASK	7	/* restore signal mask in do_signal */
 #define TIF_CPU_GOING_TO_SLEEP	8	/* CPU is entering sleep 0 mode */
@@ -89,18 +94,24 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
-#define _TIF_BREAKPOINT		(1 << TIF_BREAKPOINT)
 #define _TIF_SINGLE_STEP	(1 << TIF_SINGLE_STEP)
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_CPU_GOING_TO_SLEEP (1 << TIF_CPU_GOING_TO_SLEEP)
 
-/* XXX: These two masks must never span more than 16 bits! */
+/* Note: The masks below must never span more than 16 bits! */
+
 /* work to do on interrupt/exception return */
-#define _TIF_WORK_MASK		0x0000013e
+#define _TIF_WORK_MASK				\
+	((1 << TIF_SIGPENDING)			\
+	 | (1 << TIF_NEED_RESCHED)		\
+	 | (1 << TIF_POLLING_NRFLAG)		\
+	 | (1 << TIF_BREAKPOINT)		\
+	 | (1 << TIF_RESTORE_SIGMASK))
+
 /* work to do on any return to userspace */
-#define _TIF_ALLWORK_MASK	0x0000013f
+#define _TIF_ALLWORK_MASK	(_TIF_WORK_MASK | (1 << TIF_SYSCALL_TRACE))
 /* work to do on return from debug mode */
-#define _TIF_DBGWORK_MASK	0x0000017e
+#define _TIF_DBGWORK_MASK	(_TIF_WORK_MASK & ~(1 << TIF_BREAKPOINT))
 
 #endif /* __ASM_AVR32_THREAD_INFO_H */
