Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbYGASrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbYGASrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbYGASrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:47:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbYGASr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:47:29 -0400
Date: Tue, 1 Jul 2008 14:46:18 -0400
Message-Id: <200807011846.m61IkHWF014954@pobox-2.corp.redhat.com>
From: Glauber Costa <gcosta@redhat.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [GIT PULL] Userlib integration patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, please pull the latest master git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/glommer/linux-2.6-x86-integration.git master

It is based on your tip/master tree, and contains an update to the userlib integration
according to the mailing list discussions. You should be able to wipe out the previous branch, and put this
one on instead.

Thanks!

	Glauber

------------------>
Glauber Costa (42):
      Don't use size specifiers
      provide delay loop for x86_64
      use rdtscll in read_current_timer for i386.
      explicitly use edx in const delay function.
      integrate delay functions
      use something common for both architectures
      don't clobber r8 nor use rcx
      don't use word-size specifiers
      adapt x86_64 getuser functions
      rename threadinfo to TI
      Don't use word-size specifiers on getuser_64
      introduce __ASM_REG macro
      use _ASM_PTR instead of explicit word-size pointers
      merge getuser asm functions
      don't save ebx in putuser_32.S
      user put_user_x instead of all variants.
      clobber rbx in putuser_64.S
      pass argument to putuser_64 functions in ax register.
      change testing logic in putuser_64.S
      replace function headers by macros
      don't use word-size specifiers in putuser files
      use macros from asm.h
      merge putuser asm functions
      commonize __range_not_ok
      change asm constraint
      introduce likely in macro
      use long instead of int
      merge common parts of uaccess.
      merge getuser
      move __addr_ok to uaccess.h
      use k modifier for 4-byte access.
      mark x86_64 as having a working WP.
      don't always use EFAULT on __put_user_size.
      merge __put_user_asm and its user.
      don't always use EFAULT on __get_user_size.
      merge __get_user_asm and its users.
      Be more explicit in __put_user_x
      turn __put_user_check directly into put_user.
      merge put_user
      move __get_user and __put_user into uaccess.h
      put movsl_mask into uaccess.h
      define architectural characteristics in uaccess.h

 arch/x86/Kconfig.cpu                     |    2 +-
 arch/x86/ia32/ia32entry.S                |   25 +-
 arch/x86/kernel/asm-offsets_64.c         |    2 +-
 arch/x86/kernel/entry_64.S               |   27 +-
 arch/x86/kernel/tsc_64.c                 |    1 +
 arch/x86/lib/Makefile                    |    4 +-
 arch/x86/lib/copy_user_64.S              |    4 +-
 arch/x86/lib/{delay_32.c => delay.c}     |   17 +-
 arch/x86/lib/delay_64.c                  |   85 ------
 arch/x86/lib/{getuser_64.S => getuser.S} |   87 +++---
 arch/x86/lib/getuser_32.S                |   78 -----
 arch/x86/lib/{putuser_32.S => putuser.S} |   73 +++---
 arch/x86/lib/putuser_64.S                |  106 -------
 include/asm-x86/asm.h                    |    9 +-
 include/asm-x86/uaccess.h                |  448 ++++++++++++++++++++++++++++++
 include/asm-x86/uaccess_32.h             |  422 ----------------------------
 include/asm-x86/uaccess_64.h             |  260 -----------------
 17 files changed, 576 insertions(+), 1074 deletions(-)
 rename arch/x86/lib/{delay_32.c => delay.c} (96%)
 delete mode 100644 arch/x86/lib/delay_64.c
 rename arch/x86/lib/{getuser_64.S => getuser.S} (53%)
 delete mode 100644 arch/x86/lib/getuser_32.S
 rename arch/x86/lib/{putuser_32.S => putuser.S} (54%)
 delete mode 100644 arch/x86/lib/putuser_64.S

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index d5f04f9..99ec0fe 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -344,7 +344,7 @@ config X86_F00F_BUG
 
 config X86_WP_WORKS_OK
 	def_bool y
-	depends on X86_32 && !M386
+	depends on !M386
 
 config X86_INVLPG
 	def_bool y
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 3aefbce..9bfea05 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -103,7 +103,7 @@ ENTRY(ia32_sysenter_target)
 	pushfq
 	CFI_ADJUST_CFA_OFFSET 8
 	/*CFI_REL_OFFSET rflags,0*/
-	movl	8*3-THREAD_SIZE+threadinfo_sysenter_return(%rsp), %r10d
+	movl	8*3-THREAD_SIZE+TI_sysenter_return(%rsp), %r10d
 	CFI_REGISTER rip,r10
 	pushq	$__USER32_CS
 	CFI_ADJUST_CFA_OFFSET 8
@@ -123,8 +123,9 @@ ENTRY(ia32_sysenter_target)
  	.quad 1b,ia32_badarg
  	.previous	
 	GET_THREAD_INFO(%r10)
-	orl    $TS_COMPAT,threadinfo_status(%r10)
-	testl  $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%r10)
+	orl    $TS_COMPAT,TI_status(%r10)
+	testl  $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP), \
+		 TI_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz  sysenter_tracesys
 sysenter_do_call:	
@@ -136,9 +137,9 @@ sysenter_do_call:
 	GET_THREAD_INFO(%r10)
 	cli
 	TRACE_IRQS_OFF
-	testl	$_TIF_ALLWORK_MASK,threadinfo_flags(%r10)
+	testl	$_TIF_ALLWORK_MASK,TI_flags(%r10)
 	jnz	int_ret_from_sys_call
-	andl    $~TS_COMPAT,threadinfo_status(%r10)
+	andl    $~TS_COMPAT,TI_status(%r10)
 	/* clear IF, that popfq doesn't enable interrupts early */
 	andl  $~0x200,EFLAGS-R11(%rsp) 
 	movl	RIP-R11(%rsp),%edx		/* User %eip */
@@ -230,8 +231,9 @@ ENTRY(ia32_cstar_target)
 	.quad 1b,ia32_badarg
 	.previous	
 	GET_THREAD_INFO(%r10)
-	orl   $TS_COMPAT,threadinfo_status(%r10)
-	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%r10)
+	orl   $TS_COMPAT,TI_status(%r10)
+	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP), \
+		TI_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz   cstar_tracesys
 cstar_do_call:	
@@ -243,9 +245,9 @@ cstar_do_call:
 	GET_THREAD_INFO(%r10)
 	cli
 	TRACE_IRQS_OFF
-	testl $_TIF_ALLWORK_MASK,threadinfo_flags(%r10)
+	testl $_TIF_ALLWORK_MASK,TI_flags(%r10)
 	jnz  int_ret_from_sys_call
-	andl $~TS_COMPAT,threadinfo_status(%r10)
+	andl $~TS_COMPAT,TI_status(%r10)
 	RESTORE_ARGS 1,-ARG_SKIP,1,1,1
 	movl RIP-ARGOFFSET(%rsp),%ecx
 	CFI_REGISTER rip,rcx
@@ -324,8 +326,9 @@ ENTRY(ia32_syscall)
 	   this could be a problem. */
 	SAVE_ARGS 0,0,1
 	GET_THREAD_INFO(%r10)
-	orl   $TS_COMPAT,threadinfo_status(%r10)
-	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%r10)
+	orl   $TS_COMPAT,TI_status(%r10)
+	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP), \
+		TI_flags(%r10)
 	jnz ia32_tracesys
 ia32_do_syscall:	
 	cmpl $(IA32_NR_syscalls-1),%eax
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index a5bbec3..2fcc6ac 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -34,7 +34,7 @@ int main(void)
 	ENTRY(pid);
 	BLANK();
 #undef ENTRY
-#define ENTRY(entry) DEFINE(threadinfo_ ## entry, offsetof(struct thread_info, entry))
+#define ENTRY(entry) DEFINE(TI_ ## entry, offsetof(struct thread_info, entry))
 	ENTRY(flags);
 	ENTRY(addr_limit);
 	ENTRY(preempt_count);
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index c035b20..b79cfc9 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -277,13 +277,13 @@ ENTRY(ret_from_fork)
 	CFI_ADJUST_CFA_OFFSET -4
 	call schedule_tail
 	GET_THREAD_INFO(%rcx)
-	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT),threadinfo_flags(%rcx)
+	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT),TI_flags(%rcx)
 	jnz rff_trace
 rff_action:	
 	RESTORE_REST
 	testl $3,CS-ARGOFFSET(%rsp)	# from kernel_thread?
 	je   int_ret_from_sys_call
-	testl $_TIF_IA32,threadinfo_flags(%rcx)
+	testl $_TIF_IA32,TI_flags(%rcx)
 	jnz  int_ret_from_sys_call
 	RESTORE_TOP_OF_STACK %rdi,ARGOFFSET
 	jmp ret_from_sys_call
@@ -352,7 +352,8 @@ ENTRY(system_call_after_swapgs)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
 	GET_THREAD_INFO(%rcx)
-	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%rcx)
+	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP), \
+		TI_flags(%rcx)
 	jnz tracesys
 	cmpq $__NR_syscall_max,%rax
 	ja badsys
@@ -371,7 +372,7 @@ sysret_check:
 	GET_THREAD_INFO(%rcx)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	movl threadinfo_flags(%rcx),%edx
+	movl TI_flags(%rcx),%edx
 	andl %edi,%edx
 	jnz  sysret_careful 
 	CFI_REMEMBER_STATE
@@ -455,10 +456,10 @@ int_ret_from_sys_call:
 int_with_check:
 	LOCKDEP_SYS_EXIT_IRQ
 	GET_THREAD_INFO(%rcx)
-	movl threadinfo_flags(%rcx),%edx
+	movl TI_flags(%rcx),%edx
 	andl %edi,%edx
 	jnz   int_careful
-	andl    $~TS_COMPAT,threadinfo_status(%rcx)
+	andl    $~TS_COMPAT,TI_status(%rcx)
 	jmp   retint_swapgs
 
 	/* Either reschedule or signal or syscall exit tracking needed. */
@@ -666,7 +667,7 @@ retint_with_reschedule:
 	movl $_TIF_WORK_MASK,%edi
 retint_check:
 	LOCKDEP_SYS_EXIT_IRQ
-	movl threadinfo_flags(%rcx),%edx
+	movl TI_flags(%rcx),%edx
 	andl %edi,%edx
 	CFI_REMEMBER_STATE
 	jnz  retint_careful
@@ -764,7 +765,7 @@ retint_signal:
 	/* Returning to kernel space from exception. */
 	/* rcx:	 threadinfo. interrupts off. */
 ENTRY(retexc_kernel)
-	testl $HARDNMI_MASK,threadinfo_preempt_count(%rcx)
+	testl $HARDNMI_MASK,TI_preempt_count(%rcx)
 	jz retint_kernel		/* Not nested over NMI ? */
 	testw $X86_EFLAGS_TF,EFLAGS-ARGOFFSET(%rsp)	/* trap flag? */
 	jnz retint_kernel		/*
@@ -782,9 +783,9 @@ ENTRY(retexc_kernel)
 	/* Returning to kernel space. Check if we need preemption */
 	/* rcx:	 threadinfo. interrupts off. */
 ENTRY(retint_kernel)
-	cmpl $0,threadinfo_preempt_count(%rcx)
+	cmpl $0,TI_preempt_count(%rcx)
 	jnz  retint_restore_args
-	bt  $TIF_NEED_RESCHED,threadinfo_flags(%rcx)
+	bt  $TIF_NEED_RESCHED,TI_flags(%rcx)
 	jnc  retint_restore_args
 	bt   $9,EFLAGS-ARGOFFSET(%rsp)	/* interrupts off? */
 	jnc  retint_restore_args
@@ -945,7 +946,7 @@ paranoid_restore_no_nmi\trace:
 	jmp irq_return
 paranoid_restore\trace:
 	GET_THREAD_INFO(%rcx)
-	testl $HARDNMI_MASK,threadinfo_preempt_count(%rcx)
+	testl $HARDNMI_MASK,TI_preempt_count(%rcx)
 	jz paranoid_restore_no_nmi\trace	/* Nested over NMI ? */
 	testw $X86_EFLAGS_TF,EFLAGS-0(%rsp)	/* trap flag? */
 	jnz paranoid_restore_no_nmi\trace
@@ -953,7 +954,7 @@ paranoid_restore\trace:
 	INTERRUPT_RETURN_NMI_SAFE
 paranoid_userspace\trace:
 	GET_THREAD_INFO(%rcx)
-	movl threadinfo_flags(%rcx),%ebx
+	movl TI_flags(%rcx),%ebx
 	andl $_TIF_WORK_MASK,%ebx
 	jz paranoid_swapgs\trace
 	movq %rsp,%rdi			/* &pt_regs */
@@ -1051,7 +1052,7 @@ error_exit:
 	testl %eax,%eax
 	jne  retexc_kernel
 	LOCKDEP_SYS_EXIT_IRQ
-	movl  threadinfo_flags(%rcx),%edx
+	movl  TI_flags(%rcx),%edx
 	movl  $_TIF_WORK_MASK,%edi
 	andl  %edi,%edx
 	jnz  retint_careful
diff --git a/arch/x86/kernel/tsc_64.c b/arch/x86/kernel/tsc_64.c
index 9898fb0..36ac46f 100644
--- a/arch/x86/kernel/tsc_64.c
+++ b/arch/x86/kernel/tsc_64.c
@@ -258,6 +258,7 @@ void __init tsc_calibrate(void)
 out:
 	for_each_possible_cpu(cpu)
 		set_cyc2ns_scale(tsc_khz, cpu);
+	use_tsc_delay();
 }
 
 /*
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 84aa288..aa3fa41 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -4,9 +4,9 @@
 
 obj-$(CONFIG_SMP) := msr-on-cpu.o
 
-lib-y := delay_$(BITS).o
+lib-y := delay.o
 lib-y += thunk_$(BITS).o
-lib-y += usercopy_$(BITS).o getuser_$(BITS).o putuser_$(BITS).o
+lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
 
 ifeq ($(CONFIG_X86_32),y)
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index ee1c3f6..7eaaf01 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -40,7 +40,7 @@ ENTRY(copy_to_user)
 	movq %rdi,%rcx
 	addq %rdx,%rcx
 	jc  bad_to_user
-	cmpq threadinfo_addr_limit(%rax),%rcx
+	cmpq TI_addr_limit(%rax),%rcx
 	jae bad_to_user
 	xorl %eax,%eax	/* clear zero flag */
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
@@ -65,7 +65,7 @@ ENTRY(copy_from_user)
 	movq %rsi,%rcx
 	addq %rdx,%rcx
 	jc  bad_from_user
-	cmpq threadinfo_addr_limit(%rax),%rcx
+	cmpq TI_addr_limit(%rax),%rcx
 	jae  bad_from_user
 	movl $1,%ecx	/* set zero flag */
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
diff --git a/arch/x86/lib/delay_32.c b/arch/x86/lib/delay.c
similarity index 96%
rename from arch/x86/lib/delay_32.c
rename to arch/x86/lib/delay.c
index ef69131..f456860 100644
--- a/arch/x86/lib/delay_32.c
+++ b/arch/x86/lib/delay.c
@@ -29,7 +29,7 @@
 /* simple loop based delay: */
 static void delay_loop(unsigned long loops)
 {
-	__asm__ __volatile__(
+	asm volatile(
 		"	test %0,%0	\n"
 		"	jz 3f		\n"
 		"	jmp 1f		\n"
@@ -38,9 +38,9 @@ static void delay_loop(unsigned long loops)
 		"1:	jmp 2f		\n"
 
 		".align 16		\n"
-		"2:	decl %0		\n"
+		"2:	dec %0		\n"
 		"	jnz 2b		\n"
-		"3:	decl %0		\n"
+		"3:	dec %0		\n"
 
 		: /* we don't need output */
 		:"a" (loops)
@@ -98,7 +98,7 @@ void use_tsc_delay(void)
 int __devinit read_current_timer(unsigned long *timer_val)
 {
 	if (delay_fn == delay_tsc) {
-		rdtscl(*timer_val);
+		rdtscll(*timer_val);
 		return 0;
 	}
 	return -1;
@@ -108,31 +108,30 @@ void __delay(unsigned long loops)
 {
 	delay_fn(loops);
 }
+EXPORT_SYMBOL(__delay);
 
 inline void __const_udelay(unsigned long xloops)
 {
 	int d0;
 
 	xloops *= 4;
-	__asm__("mull %0"
+	asm("mull %%edx"
 		:"=d" (xloops), "=&a" (d0)
 		:"1" (xloops), "0"
 		(cpu_data(raw_smp_processor_id()).loops_per_jiffy * (HZ/4)));
 
 	__delay(++xloops);
 }
+EXPORT_SYMBOL(__const_udelay);
 
 void __udelay(unsigned long usecs)
 {
 	__const_udelay(usecs * 0x000010c7); /* 2**32 / 1000000 (rounded up) */
 }
+EXPORT_SYMBOL(__udelay);
 
 void __ndelay(unsigned long nsecs)
 {
 	__const_udelay(nsecs * 0x00005); /* 2**32 / 1000000000 (rounded up) */
 }
-
-EXPORT_SYMBOL(__delay);
-EXPORT_SYMBOL(__const_udelay);
-EXPORT_SYMBOL(__udelay);
 EXPORT_SYMBOL(__ndelay);
diff --git a/arch/x86/lib/delay_64.c b/arch/x86/lib/delay_64.c
deleted file mode 100644
index 4c441be..0000000
--- a/arch/x86/lib/delay_64.c
+++ /dev/null
@@ -1,85 +0,0 @@
-/*
- *	Precise Delay Loops for x86-64
- *
- *	Copyright (C) 1993 Linus Torvalds
- *	Copyright (C) 1997 Martin Mares <mj@atrey.karlin.mff.cuni.cz>
- *
- *	The __delay function must _NOT_ be inlined as its execution time
- *	depends wildly on alignment on many x86 processors. 
- */
-
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/timex.h>
-#include <linux/preempt.h>
-#include <linux/delay.h>
-#include <linux/init.h>
-
-#include <asm/delay.h>
-#include <asm/msr.h>
-
-#ifdef CONFIG_SMP
-#include <asm/smp.h>
-#endif
-
-int __devinit read_current_timer(unsigned long *timer_value)
-{
-	rdtscll(*timer_value);
-	return 0;
-}
-
-void __delay(unsigned long loops)
-{
-	unsigned bclock, now;
-	int cpu;
-
-	preempt_disable();
-	cpu = smp_processor_id();
-	rdtscl(bclock);
-	for (;;) {
-		rdtscl(now);
-		if ((now - bclock) >= loops)
-			break;
-
-		/* Allow RT tasks to run */
-		preempt_enable();
-		rep_nop();
-		preempt_disable();
-
-		/*
-		 * It is possible that we moved to another CPU, and
-		 * since TSC's are per-cpu we need to calculate
-		 * that. The delay must guarantee that we wait "at
-		 * least" the amount of time. Being moved to another
-		 * CPU could make the wait longer but we just need to
-		 * make sure we waited long enough. Rebalance the
-		 * counter for this CPU.
-		 */
-		if (unlikely(cpu != smp_processor_id())) {
-			loops -= (now - bclock);
-			cpu = smp_processor_id();
-			rdtscl(bclock);
-		}
-	}
-	preempt_enable();
-}
-EXPORT_SYMBOL(__delay);
-
-inline void __const_udelay(unsigned long xloops)
-{
-	__delay(((xloops * HZ *
-		cpu_data(raw_smp_processor_id()).loops_per_jiffy) >> 32) + 1);
-}
-EXPORT_SYMBOL(__const_udelay);
-
-void __udelay(unsigned long usecs)
-{
-	__const_udelay(usecs * 0x000010c7);  /* 2**32 / 1000000 (rounded up) */
-}
-EXPORT_SYMBOL(__udelay);
-
-void __ndelay(unsigned long nsecs)
-{
-	__const_udelay(nsecs * 0x00005);  /* 2**32 / 1000000000 (rounded up) */
-}
-EXPORT_SYMBOL(__ndelay);
diff --git a/arch/x86/lib/getuser_64.S b/arch/x86/lib/getuser.S
similarity index 53%
rename from arch/x86/lib/getuser_64.S
rename to arch/x86/lib/getuser.S
index 5448876..ad37400 100644
--- a/arch/x86/lib/getuser_64.S
+++ b/arch/x86/lib/getuser.S
@@ -3,6 +3,7 @@
  *
  * (C) Copyright 1998 Linus Torvalds
  * (C) Copyright 2005 Andi Kleen
+ * (C) Copyright 2008 Glauber Costa
  *
  * These functions have a non-standard call interface
  * to make them more efficient, especially as they
@@ -13,14 +14,13 @@
 /*
  * __get_user_X
  *
- * Inputs:	%rcx contains the address.
+ * Inputs:	%[r|e]ax contains the address.
  *		The register is modified, but all changes are undone
  *		before returning because the C code doesn't know about it.
  *
- * Outputs:	%rax is error code (0 or -EFAULT)
- *		%rdx contains zero-extended value
- * 
- * %r8 is destroyed.
+ * Outputs:	%[r|e]ax is error code (0 or -EFAULT)
+ *		%[r|e]dx contains zero-extended value
+ *
  *
  * These functions should not modify any other registers,
  * as they get called from within inline assembly.
@@ -32,78 +32,73 @@
 #include <asm/errno.h>
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
+#include <asm/asm.h>
 
 	.text
 ENTRY(__get_user_1)
 	CFI_STARTPROC
-	GET_THREAD_INFO(%r8)
-	cmpq threadinfo_addr_limit(%r8),%rcx
+	GET_THREAD_INFO(%_ASM_DX)
+	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
-1:	movzb (%rcx),%edx
-	xorl %eax,%eax
+1:	movzb (%_ASM_AX),%edx
+	xor %eax,%eax
 	ret
 	CFI_ENDPROC
 ENDPROC(__get_user_1)
 
 ENTRY(__get_user_2)
 	CFI_STARTPROC
-	GET_THREAD_INFO(%r8)
-	addq $1,%rcx
-	jc 20f
-	cmpq threadinfo_addr_limit(%r8),%rcx
-	jae 20f
-	decq   %rcx
-2:	movzwl (%rcx),%edx
-	xorl %eax,%eax
+	add $1,%_ASM_AX
+	jc bad_get_user
+	GET_THREAD_INFO(%_ASM_DX)
+	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
+	jae bad_get_user
+2:	movzwl -1(%_ASM_AX),%edx
+	xor %eax,%eax
 	ret
-20:	decq    %rcx
-	jmp	bad_get_user
 	CFI_ENDPROC
 ENDPROC(__get_user_2)
 
 ENTRY(__get_user_4)
 	CFI_STARTPROC
-	GET_THREAD_INFO(%r8)
-	addq $3,%rcx
-	jc 30f
-	cmpq threadinfo_addr_limit(%r8),%rcx
-	jae 30f
-	subq $3,%rcx
-3:	movl (%rcx),%edx
-	xorl %eax,%eax
+	add $3,%_ASM_AX
+	jc bad_get_user
+	GET_THREAD_INFO(%_ASM_DX)
+	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
+	jae bad_get_user
+3:	mov -3(%_ASM_AX),%edx
+	xor %eax,%eax
 	ret
-30:	subq $3,%rcx
-	jmp bad_get_user
 	CFI_ENDPROC
 ENDPROC(__get_user_4)
 
+#ifdef CONFIG_X86_64
 ENTRY(__get_user_8)
 	CFI_STARTPROC
-	GET_THREAD_INFO(%r8)
-	addq $7,%rcx
-	jc 40f
-	cmpq threadinfo_addr_limit(%r8),%rcx
-	jae	40f
-	subq	$7,%rcx
-4:	movq (%rcx),%rdx
-	xorl %eax,%eax
+	add $7,%_ASM_AX
+	jc bad_get_user
+	GET_THREAD_INFO(%_ASM_DX)
+	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
+	jae	bad_get_user
+4:	movq -7(%_ASM_AX),%_ASM_DX
+	xor %eax,%eax
 	ret
-40:	subq $7,%rcx
-	jmp bad_get_user
 	CFI_ENDPROC
 ENDPROC(__get_user_8)
+#endif
 
 bad_get_user:
 	CFI_STARTPROC
-	xorl %edx,%edx
-	movq $(-EFAULT),%rax
+	xor %edx,%edx
+	mov $(-EFAULT),%_ASM_AX
 	ret
 	CFI_ENDPROC
 END(bad_get_user)
 
 .section __ex_table,"a"
-	.quad 1b,bad_get_user
-	.quad 2b,bad_get_user
-	.quad 3b,bad_get_user
-	.quad 4b,bad_get_user
-.previous
+	_ASM_PTR 1b,bad_get_user
+	_ASM_PTR 2b,bad_get_user
+	_ASM_PTR 3b,bad_get_user
+#ifdef CONFIG_X86_64
+	_ASM_PTR 4b,bad_get_user
+#endif
diff --git a/arch/x86/lib/getuser_32.S b/arch/x86/lib/getuser_32.S
deleted file mode 100644
index 6d84b53..0000000
--- a/arch/x86/lib/getuser_32.S
+++ /dev/null
@@ -1,78 +0,0 @@
-/*
- * __get_user functions.
- *
- * (C) Copyright 1998 Linus Torvalds
- *
- * These functions have a non-standard call interface
- * to make them more efficient, especially as they
- * return an error value in addition to the "real"
- * return value.
- */
-#include <linux/linkage.h>
-#include <asm/dwarf2.h>
-#include <asm/thread_info.h>
-
-
-/*
- * __get_user_X
- *
- * Inputs:	%eax contains the address
- *
- * Outputs:	%eax is error code (0 or -EFAULT)
- *		%edx contains zero-extended value
- *
- * These functions should not modify any other registers,
- * as they get called from within inline assembly.
- */
-
-.text
-ENTRY(__get_user_1)
-	CFI_STARTPROC
-	GET_THREAD_INFO(%edx)
-	cmpl TI_addr_limit(%edx),%eax
-	jae bad_get_user
-1:	movzbl (%eax),%edx
-	xorl %eax,%eax
-	ret
-	CFI_ENDPROC
-ENDPROC(__get_user_1)
-
-ENTRY(__get_user_2)
-	CFI_STARTPROC
-	addl $1,%eax
-	jc bad_get_user
-	GET_THREAD_INFO(%edx)
-	cmpl TI_addr_limit(%edx),%eax
-	jae bad_get_user
-2:	movzwl -1(%eax),%edx
-	xorl %eax,%eax
-	ret
-	CFI_ENDPROC
-ENDPROC(__get_user_2)
-
-ENTRY(__get_user_4)
-	CFI_STARTPROC
-	addl $3,%eax
-	jc bad_get_user
-	GET_THREAD_INFO(%edx)
-	cmpl TI_addr_limit(%edx),%eax
-	jae bad_get_user
-3:	movl -3(%eax),%edx
-	xorl %eax,%eax
-	ret
-	CFI_ENDPROC
-ENDPROC(__get_user_4)
-
-bad_get_user:
-	CFI_STARTPROC
-	xorl %edx,%edx
-	movl $-14,%eax
-	ret
-	CFI_ENDPROC
-END(bad_get_user)
-
-.section __ex_table,"a"
-	.long 1b,bad_get_user
-	.long 2b,bad_get_user
-	.long 3b,bad_get_user
-.previous
diff --git a/arch/x86/lib/putuser_32.S b/arch/x86/lib/putuser.S
similarity index 54%
rename from arch/x86/lib/putuser_32.S
rename to arch/x86/lib/putuser.S
index f58fba1..36b0d15 100644
--- a/arch/x86/lib/putuser_32.S
+++ b/arch/x86/lib/putuser.S
@@ -2,6 +2,8 @@
  * __put_user functions.
  *
  * (C) Copyright 2005 Linus Torvalds
+ * (C) Copyright 2005 Andi Kleen
+ * (C) Copyright 2008 Glauber Costa
  *
  * These functions have a non-standard call interface
  * to make them more efficient, especially as they
@@ -11,6 +13,8 @@
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
 #include <asm/thread_info.h>
+#include <asm/errno.h>
+#include <asm/asm.h>
 
 
 /*
@@ -26,73 +30,68 @@
  */
 
 #define ENTER	CFI_STARTPROC ; \
-		pushl %ebx ; \
-		CFI_ADJUST_CFA_OFFSET 4 ; \
-		CFI_REL_OFFSET ebx, 0 ; \
-		GET_THREAD_INFO(%ebx)
-#define EXIT	popl %ebx ; \
-		CFI_ADJUST_CFA_OFFSET -4 ; \
-		CFI_RESTORE ebx ; \
-		ret ; \
+		GET_THREAD_INFO(%_ASM_BX)
+#define EXIT	ret ; \
 		CFI_ENDPROC
 
 .text
 ENTRY(__put_user_1)
 	ENTER
-	cmpl TI_addr_limit(%ebx),%ecx
+	cmp TI_addr_limit(%_ASM_BX),%_ASM_CX
 	jae bad_put_user
-1:	movb %al,(%ecx)
-	xorl %eax,%eax
+1:	movb %al,(%_ASM_CX)
+	xor %eax,%eax
 	EXIT
 ENDPROC(__put_user_1)
 
 ENTRY(__put_user_2)
 	ENTER
-	movl TI_addr_limit(%ebx),%ebx
-	subl $1,%ebx
-	cmpl %ebx,%ecx
+	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
+	sub $1,%_ASM_BX
+	cmp %_ASM_BX,%_ASM_CX
 	jae bad_put_user
-2:	movw %ax,(%ecx)
-	xorl %eax,%eax
+2:	movw %ax,(%_ASM_CX)
+	xor %eax,%eax
 	EXIT
 ENDPROC(__put_user_2)
 
 ENTRY(__put_user_4)
 	ENTER
-	movl TI_addr_limit(%ebx),%ebx
-	subl $3,%ebx
-	cmpl %ebx,%ecx
+	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
+	sub $3,%_ASM_BX
+	cmp %_ASM_BX,%_ASM_CX
 	jae bad_put_user
-3:	movl %eax,(%ecx)
-	xorl %eax,%eax
+3:	movl %eax,(%_ASM_CX)
+	xor %eax,%eax
 	EXIT
 ENDPROC(__put_user_4)
 
 ENTRY(__put_user_8)
 	ENTER
-	movl TI_addr_limit(%ebx),%ebx
-	subl $7,%ebx
-	cmpl %ebx,%ecx
+	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
+	sub $7,%_ASM_BX
+	cmp %_ASM_BX,%_ASM_CX
 	jae bad_put_user
-4:	movl %eax,(%ecx)
-5:	movl %edx,4(%ecx)
-	xorl %eax,%eax
+4:	mov %_ASM_AX,(%_ASM_CX)
+#ifdef CONFIG_X86_32
+5:	movl %edx,4(%_ASM_CX)
+#endif
+	xor %eax,%eax
 	EXIT
 ENDPROC(__put_user_8)
 
 bad_put_user:
-	CFI_STARTPROC simple
-	CFI_DEF_CFA esp, 2*4
-	CFI_OFFSET eip, -1*4
-	CFI_OFFSET ebx, -2*4
-	movl $-14,%eax
+	CFI_STARTPROC
+	movl $-EFAULT,%eax
 	EXIT
 END(bad_put_user)
 
 .section __ex_table,"a"
-	.long 1b,bad_put_user
-	.long 2b,bad_put_user
-	.long 3b,bad_put_user
-	.long 4b,bad_put_user
-	.long 5b,bad_put_user
+	_ASM_PTR 1b,bad_put_user
+	_ASM_PTR 2b,bad_put_user
+	_ASM_PTR 3b,bad_put_user
+	_ASM_PTR 4b,bad_put_user
+#ifdef CONFIG_X86_32
+	_ASM_PTR 5b,bad_put_user
+#endif
 .previous
diff --git a/arch/x86/lib/putuser_64.S b/arch/x86/lib/putuser_64.S
deleted file mode 100644
index 4989f5a..0000000
--- a/arch/x86/lib/putuser_64.S
+++ /dev/null
@@ -1,106 +0,0 @@
-/*
- * __put_user functions.
- *
- * (C) Copyright 1998 Linus Torvalds
- * (C) Copyright 2005 Andi Kleen
- *
- * These functions have a non-standard call interface
- * to make them more efficient, especially as they
- * return an error value in addition to the "real"
- * return value.
- */
-
-/*
- * __put_user_X
- *
- * Inputs:	%rcx contains the address
- *		%rdx contains new value
- *
- * Outputs:	%rax is error code (0 or -EFAULT)
- *
- * %r8 is destroyed.
- *
- * These functions should not modify any other registers,
- * as they get called from within inline assembly.
- */
-
-#include <linux/linkage.h>
-#include <asm/dwarf2.h>
-#include <asm/page.h>
-#include <asm/errno.h>
-#include <asm/asm-offsets.h>
-#include <asm/thread_info.h>
-
-	.text
-ENTRY(__put_user_1)
-	CFI_STARTPROC
-	GET_THREAD_INFO(%r8)
-	cmpq threadinfo_addr_limit(%r8),%rcx
-	jae bad_put_user
-1:	movb %dl,(%rcx)
-	xorl %eax,%eax
-	ret
-	CFI_ENDPROC
-ENDPROC(__put_user_1)
-
-ENTRY(__put_user_2)
-	CFI_STARTPROC
-	GET_THREAD_INFO(%r8)
-	addq $1,%rcx
-	jc 20f
-	cmpq threadinfo_addr_limit(%r8),%rcx
-	jae 20f
-	decq %rcx
-2:	movw %dx,(%rcx)
-	xorl %eax,%eax
-	ret
-20:	decq %rcx
-	jmp bad_put_user
-	CFI_ENDPROC
-ENDPROC(__put_user_2)
-
-ENTRY(__put_user_4)
-	CFI_STARTPROC
-	GET_THREAD_INFO(%r8)
-	addq $3,%rcx
-	jc 30f
-	cmpq threadinfo_addr_limit(%r8),%rcx
-	jae 30f
-	subq $3,%rcx
-3:	movl %edx,(%rcx)
-	xorl %eax,%eax
-	ret
-30:	subq $3,%rcx
-	jmp bad_put_user
-	CFI_ENDPROC
-ENDPROC(__put_user_4)
-
-ENTRY(__put_user_8)
-	CFI_STARTPROC
-	GET_THREAD_INFO(%r8)
-	addq $7,%rcx
-	jc 40f
-	cmpq threadinfo_addr_limit(%r8),%rcx
-	jae 40f
-	subq $7,%rcx
-4:	movq %rdx,(%rcx)
-	xorl %eax,%eax
-	ret
-40:	subq $7,%rcx
-	jmp bad_put_user
-	CFI_ENDPROC
-ENDPROC(__put_user_8)
-
-bad_put_user:
-	CFI_STARTPROC
-	movq $(-EFAULT),%rax
-	ret
-	CFI_ENDPROC
-END(bad_put_user)
-
-.section __ex_table,"a"
-	.quad 1b,bad_put_user
-	.quad 2b,bad_put_user
-	.quad 3b,bad_put_user
-	.quad 4b,bad_put_user
-.previous
diff --git a/include/asm-x86/asm.h b/include/asm-x86/asm.h
index 7093982..9722032 100644
--- a/include/asm-x86/asm.h
+++ b/include/asm-x86/asm.h
@@ -3,8 +3,10 @@
 
 #ifdef __ASSEMBLY__
 # define __ASM_FORM(x)	x
+# define __ASM_EX_SEC	.section __ex_table
 #else
 # define __ASM_FORM(x)	" " #x " "
+# define __ASM_EX_SEC	" .section __ex_table,\"a\"\n"
 #endif
 
 #ifdef CONFIG_X86_32
@@ -14,6 +16,7 @@
 #endif
 
 #define __ASM_SIZE(inst)	__ASM_SEL(inst##l, inst##q)
+#define __ASM_REG(reg)		__ASM_SEL(e##reg, r##reg)
 
 #define _ASM_PTR	__ASM_SEL(.long, .quad)
 #define _ASM_ALIGN	__ASM_SEL(.balign 4, .balign 8)
@@ -24,10 +27,14 @@
 #define _ASM_ADD	__ASM_SIZE(add)
 #define _ASM_SUB	__ASM_SIZE(sub)
 #define _ASM_XADD	__ASM_SIZE(xadd)
+#define _ASM_AX		__ASM_REG(ax)
+#define _ASM_BX		__ASM_REG(bx)
+#define _ASM_CX		__ASM_REG(cx)
+#define _ASM_DX		__ASM_REG(dx)
 
 /* Exception table entry */
 # define _ASM_EXTABLE(from,to) \
-	" .section __ex_table,\"a\"\n" \
+	__ASM_EX_SEC	\
 	_ASM_ALIGN "\n" \
 	_ASM_PTR #from "," #to "\n" \
 	" .previous\n"
diff --git a/include/asm-x86/uaccess.h b/include/asm-x86/uaccess.h
index 9fefd29..f6fa4d8 100644
--- a/include/asm-x86/uaccess.h
+++ b/include/asm-x86/uaccess.h
@@ -1,5 +1,453 @@
+#ifndef _ASM_UACCES_H_
+#define _ASM_UACCES_H_
+/*
+ * User space memory access functions
+ */
+#include <linux/errno.h>
+#include <linux/compiler.h>
+#include <linux/thread_info.h>
+#include <linux/prefetch.h>
+#include <linux/string.h>
+#include <asm/asm.h>
+#include <asm/page.h>
+
+#define VERIFY_READ 0
+#define VERIFY_WRITE 1
+
+/*
+ * The fs value determines whether argument validity checking should be
+ * performed or not.  If get_fs() == USER_DS, checking is performed, with
+ * get_fs() == KERNEL_DS, checking is bypassed.
+ *
+ * For historical reasons, these macros are grossly misnamed.
+ */
+
+#define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })
+
+#define KERNEL_DS	MAKE_MM_SEG(-1UL)
+#define USER_DS		MAKE_MM_SEG(PAGE_OFFSET)
+
+#define get_ds()	(KERNEL_DS)
+#define get_fs()	(current_thread_info()->addr_limit)
+#define set_fs(x)	(current_thread_info()->addr_limit = (x))
+
+#define segment_eq(a, b)	((a).seg == (b).seg)
+
+#define __addr_ok(addr)					\
+	((unsigned long __force)(addr) <		\
+	 (current_thread_info()->addr_limit.seg))
+
+/*
+ * Test whether a block of memory is a valid user space address.
+ * Returns 0 if the range is valid, nonzero otherwise.
+ *
+ * This is equivalent to the following test:
+ * (u33)addr + (u33)size >= (u33)current->addr_limit.seg (u65 for x86_64)
+ *
+ * This needs 33-bit (65-bit for x86_64) arithmetic. We have a carry...
+ */
+
+#define __range_not_ok(addr, size)					\
+({									\
+	unsigned long flag, roksum;					\
+	__chk_user_ptr(addr);						\
+	asm("add %3,%1 ; sbb %0,%0 ; cmp %1,%4 ; sbb $0,%0"		\
+	    : "=&r" (flag), "=r" (roksum)				\
+	    : "1" (addr), "g" ((long)(size)),				\
+	      "rm" (current_thread_info()->addr_limit.seg));		\
+	flag;								\
+})
+
+/**
+ * access_ok: - Checks if a user space pointer is valid
+ * @type: Type of access: %VERIFY_READ or %VERIFY_WRITE.  Note that
+ *        %VERIFY_WRITE is a superset of %VERIFY_READ - if it is safe
+ *        to write to a block, it is always safe to read from it.
+ * @addr: User space pointer to start of block to check
+ * @size: Size of block to check
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * Checks if a pointer to a block of memory in user space is valid.
+ *
+ * Returns true (nonzero) if the memory block may be valid, false (zero)
+ * if it is definitely invalid.
+ *
+ * Note that, depending on architecture, this function probably just
+ * checks that the pointer is in the user space range - after calling
+ * this function, memory access functions may still return -EFAULT.
+ */
+#define access_ok(type, addr, size) (likely(__range_not_ok(addr, size) == 0))
+
+/*
+ * The exception table consists of pairs of addresses: the first is the
+ * address of an instruction that is allowed to fault, and the second is
+ * the address at which the program should continue.  No registers are
+ * modified, so it is entirely up to the continuation code to figure out
+ * what to do.
+ *
+ * All the routines below use bits of fixup code that are out of line
+ * with the main instruction path.  This means when everything is well,
+ * we don't even have to jump over them.  Further, they do not intrude
+ * on our cache or tlb entries.
+ */
+
+struct exception_table_entry {
+	unsigned long insn, fixup;
+};
+
+extern int fixup_exception(struct pt_regs *regs);
+
+/*
+ * These are the main single-value transfer routines.  They automatically
+ * use the right size if we just have the right pointer type.
+ *
+ * This gets kind of ugly. We want to return _two_ values in "get_user()"
+ * and yet we don't want to do any pointers, because that is too much
+ * of a performance impact. Thus we have a few rather ugly macros here,
+ * and hide all the ugliness from the user.
+ *
+ * The "__xxx" versions of the user access functions are versions that
+ * do not verify the address space, that must have been done previously
+ * with a separate "access_ok()" call (this is used when we do multiple
+ * accesses to the same area of user memory).
+ */
+
+extern int __get_user_1(void);
+extern int __get_user_2(void);
+extern int __get_user_4(void);
+extern int __get_user_8(void);
+extern int __get_user_bad(void);
+
+#define __get_user_x(size, ret, x, ptr)		      \
+	asm volatile("call __get_user_" #size	      \
+		     : "=a" (ret),"=d" (x)	      \
+		     : "0" (ptr))		      \
+
+/* Careful: we have to cast the result to the type of the pointer
+ * for sign reasons */
+
+/**
+ * get_user: - Get a simple variable from user space.
+ * @x:   Variable to store result.
+ * @ptr: Source address, in user space.
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * This macro copies a single simple variable from user space to kernel
+ * space.  It supports simple types like char and int, but not larger
+ * data types like structures or arrays.
+ *
+ * @ptr must have pointer-to-simple-variable type, and the result of
+ * dereferencing @ptr must be assignable to @x without a cast.
+ *
+ * Returns zero on success, or -EFAULT on error.
+ * On error, the variable @x is set to zero.
+ */
+#ifdef CONFIG_X86_32
+#define __get_user_8(__ret_gu, __val_gu, ptr)				\
+		__get_user_x(X, __ret_gu, __val_gu, ptr)
+#else
+#define __get_user_8(__ret_gu, __val_gu, ptr)				\
+		__get_user_x(8, __ret_gu, __val_gu, ptr)
+#endif
+
+#define get_user(x, ptr)						\
+({									\
+	int __ret_gu;							\
+	unsigned long __val_gu;						\
+	__chk_user_ptr(ptr);						\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		__get_user_x(1, __ret_gu, __val_gu, ptr);		\
+		break;							\
+	case 2:								\
+		__get_user_x(2, __ret_gu, __val_gu, ptr);		\
+		break;							\
+	case 4:								\
+		__get_user_x(4, __ret_gu, __val_gu, ptr);		\
+		break;							\
+	case 8:								\
+		__get_user_8(__ret_gu, __val_gu, ptr);			\
+		break;							\
+	default:							\
+		__get_user_x(X, __ret_gu, __val_gu, ptr);		\
+		break;							\
+	}								\
+	(x) = (__typeof__(*(ptr)))__val_gu;				\
+	__ret_gu;							\
+})
+
+#define __put_user_x(size, x, ptr, __ret_pu)			\
+	asm volatile("call __put_user_" #size : "=a" (__ret_pu)	\
+		     :"0" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
+
+
+
+#ifdef CONFIG_X86_32
+#define __put_user_u64(x, addr, err)					\
+	asm volatile("1:	movl %%eax,0(%2)\n"			\
+		     "2:	movl %%edx,4(%2)\n"			\
+		     "3:\n"						\
+		     ".section .fixup,\"ax\"\n"				\
+		     "4:	movl %3,%0\n"				\
+		     "	jmp 3b\n"					\
+		     ".previous\n"					\
+		     _ASM_EXTABLE(1b, 4b)				\
+		     _ASM_EXTABLE(2b, 4b)				\
+		     : "=r" (err)					\
+		     : "A" (x), "r" (addr), "i" (-EFAULT), "0" (err))
+
+#define __put_user_x8(x, ptr, __ret_pu)				\
+	asm volatile("call __put_user_8" : "=a" (__ret_pu)	\
+		     : "A" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
+#else
+#define __put_user_u64(x, ptr, retval) \
+	__put_user_asm(x, ptr, retval, "q", "", "Zr", -EFAULT)
+#define __put_user_x8(x, ptr, __ret_pu) __put_user_x(8, x, ptr, __ret_pu)
+#endif
+
+extern void __put_user_bad(void);
+
+/*
+ * Strange magic calling convention: pointer in %ecx,
+ * value in %eax(:%edx), return value in %eax. clobbers %rbx
+ */
+extern void __put_user_1(void);
+extern void __put_user_2(void);
+extern void __put_user_4(void);
+extern void __put_user_8(void);
+
+#ifdef CONFIG_X86_WP_WORKS_OK
+
+/**
+ * put_user: - Write a simple value into user space.
+ * @x:   Value to copy to user space.
+ * @ptr: Destination address, in user space.
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * This macro copies a single simple value from kernel space to user
+ * space.  It supports simple types like char and int, but not larger
+ * data types like structures or arrays.
+ *
+ * @ptr must have pointer-to-simple-variable type, and @x must be assignable
+ * to the result of dereferencing @ptr.
+ *
+ * Returns zero on success, or -EFAULT on error.
+ */
+#define put_user(x, ptr)					\
+({								\
+	int __ret_pu;						\
+	__typeof__(*(ptr)) __pu_val;				\
+	__chk_user_ptr(ptr);					\
+	__pu_val = x;						\
+	switch (sizeof(*(ptr))) {				\
+	case 1:							\
+		__put_user_x(1, __pu_val, ptr, __ret_pu);	\
+		break;						\
+	case 2:							\
+		__put_user_x(2, __pu_val, ptr, __ret_pu);	\
+		break;						\
+	case 4:							\
+		__put_user_x(4, __pu_val, ptr, __ret_pu);	\
+		break;						\
+	case 8:							\
+		__put_user_x8(__pu_val, ptr, __ret_pu);		\
+		break;						\
+	default:						\
+		__put_user_x(X, __pu_val, ptr, __ret_pu);	\
+		break;						\
+	}							\
+	__ret_pu;						\
+})
+
+#define __put_user_size(x, ptr, size, retval, errret)			\
+do {									\
+	retval = 0;							\
+	__chk_user_ptr(ptr);						\
+	switch (size) {							\
+	case 1:								\
+		__put_user_asm(x, ptr, retval, "b", "b", "iq", errret);	\
+		break;							\
+	case 2:								\
+		__put_user_asm(x, ptr, retval, "w", "w", "ir", errret);	\
+		break;							\
+	case 4:								\
+		__put_user_asm(x, ptr, retval, "l", "k",  "ir", errret);\
+		break;							\
+	case 8:								\
+		__put_user_u64((__typeof__(*ptr))(x), ptr, retval);	\
+		break;							\
+	default:							\
+		__put_user_bad();					\
+	}								\
+} while (0)
+
+#else
+
+#define __put_user_size(x, ptr, size, retval, errret)			\
+do {									\
+	__typeof__(*(ptr))__pus_tmp = x;				\
+	retval = 0;							\
+									\
+	if (unlikely(__copy_to_user_ll(ptr, &__pus_tmp, size) != 0))	\
+		retval = errret;					\
+} while (0)
+
+#define put_user(x, ptr)					\
+({								\
+	int __ret_pu;						\
+	__typeof__(*(ptr))__pus_tmp = x;			\
+	__ret_pu = 0;						\
+	if (unlikely(__copy_to_user_ll(ptr, &__pus_tmp,		\
+				       sizeof(*(ptr))) != 0))	\
+		__ret_pu = -EFAULT;				\
+	__ret_pu;						\
+})
+#endif
+
+#ifdef CONFIG_X86_32
+#define __get_user_asm_u64(x, ptr, retval, errret)	(x) = __get_user_bad()
+#else
+#define __get_user_asm_u64(x, ptr, retval, errret) \
+	 __get_user_asm(x, ptr, retval, "q", "", "=r", errret)
+#endif
+
+#define __get_user_size(x, ptr, size, retval, errret)			\
+do {									\
+	retval = 0;							\
+	__chk_user_ptr(ptr);						\
+	switch (size) {							\
+	case 1:								\
+		__get_user_asm(x, ptr, retval, "b", "b", "=q", errret);	\
+		break;							\
+	case 2:								\
+		__get_user_asm(x, ptr, retval, "w", "w", "=r", errret);	\
+		break;							\
+	case 4:								\
+		__get_user_asm(x, ptr, retval, "l", "k", "=r", errret);	\
+		break;							\
+	case 8:								\
+		__get_user_asm_u64(x, ptr, retval, errret);		\
+		break;							\
+	default:							\
+		(x) = __get_user_bad();					\
+	}								\
+} while (0)
+
+#define __get_user_asm(x, addr, err, itype, rtype, ltype, errret)	\
+	asm volatile("1:	mov"itype" %2,%"rtype"1\n"		\
+		     "2:\n"						\
+		     ".section .fixup,\"ax\"\n"				\
+		     "3:	mov %3,%0\n"				\
+		     "	xor"itype" %"rtype"1,%"rtype"1\n"		\
+		     "	jmp 2b\n"					\
+		     ".previous\n"					\
+		     _ASM_EXTABLE(1b, 3b)				\
+		     : "=r" (err), ltype(x)				\
+		     : "m" (__m(addr)), "i" (errret), "0" (err))
+
+#define __put_user_nocheck(x, ptr, size)			\
+({								\
+	long __pu_err;						\
+	__put_user_size((x), (ptr), (size), __pu_err, -EFAULT);	\
+	__pu_err;						\
+})
+
+#define __get_user_nocheck(x, ptr, size)				\
+({									\
+	long __gu_err;							\
+	unsigned long __gu_val;						\
+	__get_user_size(__gu_val, (ptr), (size), __gu_err, -EFAULT);	\
+	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
+	__gu_err;							\
+})
+
+/* FIXME: this hack is definitely wrong -AK */
+struct __large_struct { unsigned long buf[100]; };
+#define __m(x) (*(struct __large_struct __user *)(x))
+
+/*
+ * Tell gcc we read from memory instead of writing: this is because
+ * we do not write to any memory gcc knows about, so there are no
+ * aliasing issues.
+ */
+#define __put_user_asm(x, addr, err, itype, rtype, ltype, errret)	\
+	asm volatile("1:	mov"itype" %"rtype"1,%2\n"		\
+		     "2:\n"						\
+		     ".section .fixup,\"ax\"\n"				\
+		     "3:	mov %3,%0\n"				\
+		     "	jmp 2b\n"					\
+		     ".previous\n"					\
+		     _ASM_EXTABLE(1b, 3b)				\
+		     : "=r"(err)					\
+		     : ltype(x), "m" (__m(addr)), "i" (errret), "0" (err))
+/**
+ * __get_user: - Get a simple variable from user space, with less checking.
+ * @x:   Variable to store result.
+ * @ptr: Source address, in user space.
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * This macro copies a single simple variable from user space to kernel
+ * space.  It supports simple types like char and int, but not larger
+ * data types like structures or arrays.
+ *
+ * @ptr must have pointer-to-simple-variable type, and the result of
+ * dereferencing @ptr must be assignable to @x without a cast.
+ *
+ * Caller must check the pointer with access_ok() before calling this
+ * function.
+ *
+ * Returns zero on success, or -EFAULT on error.
+ * On error, the variable @x is set to zero.
+ */
+
+#define __get_user(x, ptr)						\
+	__get_user_nocheck((x), (ptr), sizeof(*(ptr)))
+/**
+ * __put_user: - Write a simple value into user space, with less checking.
+ * @x:   Value to copy to user space.
+ * @ptr: Destination address, in user space.
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * This macro copies a single simple value from kernel space to user
+ * space.  It supports simple types like char and int, but not larger
+ * data types like structures or arrays.
+ *
+ * @ptr must have pointer-to-simple-variable type, and @x must be assignable
+ * to the result of dereferencing @ptr.
+ *
+ * Caller must check the pointer with access_ok() before calling this
+ * function.
+ *
+ * Returns zero on success, or -EFAULT on error.
+ */
+
+#define __put_user(x, ptr)						\
+	__put_user_nocheck((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
+
+#define __get_user_unaligned __get_user
+#define __put_user_unaligned __put_user
+
+/*
+ * movsl can be slow when source and dest are not both 8-byte aligned
+ */
+#ifdef CONFIG_X86_INTEL_USERCOPY
+extern struct movsl_mask {
+	int mask;
+} ____cacheline_aligned_in_smp movsl_mask;
+#endif
+
+#define ARCH_HAS_NOCACHE_UACCESS 1
+
 #ifdef CONFIG_X86_32
 # include "uaccess_32.h"
 #else
+# define ARCH_HAS_SEARCH_EXTABLE
 # include "uaccess_64.h"
 #endif
+
+#endif
diff --git a/include/asm-x86/uaccess_32.h b/include/asm-x86/uaccess_32.h
index 8e7595c..6fdef39 100644
--- a/include/asm-x86/uaccess_32.h
+++ b/include/asm-x86/uaccess_32.h
@@ -11,426 +11,6 @@
 #include <asm/asm.h>
 #include <asm/page.h>
 
-#define VERIFY_READ 0
-#define VERIFY_WRITE 1
-
-/*
- * The fs value determines whether argument validity checking should be
- * performed or not.  If get_fs() == USER_DS, checking is performed, with
- * get_fs() == KERNEL_DS, checking is bypassed.
- *
- * For historical reasons, these macros are grossly misnamed.
- */
-
-#define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })
-
-
-#define KERNEL_DS	MAKE_MM_SEG(0xFFFFFFFFUL)
-#define USER_DS		MAKE_MM_SEG(PAGE_OFFSET)
-
-#define get_ds()	(KERNEL_DS)
-#define get_fs()	(current_thread_info()->addr_limit)
-#define set_fs(x)	(current_thread_info()->addr_limit = (x))
-
-#define segment_eq(a, b)	((a).seg == (b).seg)
-
-/*
- * movsl can be slow when source and dest are not both 8-byte aligned
- */
-#ifdef CONFIG_X86_INTEL_USERCOPY
-extern struct movsl_mask {
-	int mask;
-} ____cacheline_aligned_in_smp movsl_mask;
-#endif
-
-#define __addr_ok(addr)					\
-	((unsigned long __force)(addr) <		\
-	 (current_thread_info()->addr_limit.seg))
-
-/*
- * Test whether a block of memory is a valid user space address.
- * Returns 0 if the range is valid, nonzero otherwise.
- *
- * This is equivalent to the following test:
- * (u33)addr + (u33)size >= (u33)current->addr_limit.seg
- *
- * This needs 33-bit arithmetic. We have a carry...
- */
-#define __range_ok(addr, size)						\
-({									\
-	unsigned long flag, roksum;					\
-	__chk_user_ptr(addr);						\
-	asm("addl %3,%1 ; sbbl %0,%0; cmpl %1,%4; sbbl $0,%0"		\
-	    :"=&r" (flag), "=r" (roksum)				\
-	    :"1" (addr), "g" ((int)(size)),				\
-	    "rm" (current_thread_info()->addr_limit.seg));		\
-	flag;								\
-})
-
-/**
- * access_ok: - Checks if a user space pointer is valid
- * @type: Type of access: %VERIFY_READ or %VERIFY_WRITE.  Note that
- *        %VERIFY_WRITE is a superset of %VERIFY_READ - if it is safe
- *        to write to a block, it is always safe to read from it.
- * @addr: User space pointer to start of block to check
- * @size: Size of block to check
- *
- * Context: User context only.  This function may sleep.
- *
- * Checks if a pointer to a block of memory in user space is valid.
- *
- * Returns true (nonzero) if the memory block may be valid, false (zero)
- * if it is definitely invalid.
- *
- * Note that, depending on architecture, this function probably just
- * checks that the pointer is in the user space range - after calling
- * this function, memory access functions may still return -EFAULT.
- */
-#define access_ok(type, addr, size) (likely(__range_ok(addr, size) == 0))
-
-/*
- * The exception table consists of pairs of addresses: the first is the
- * address of an instruction that is allowed to fault, and the second is
- * the address at which the program should continue.  No registers are
- * modified, so it is entirely up to the continuation code to figure out
- * what to do.
- *
- * All the routines below use bits of fixup code that are out of line
- * with the main instruction path.  This means when everything is well,
- * we don't even have to jump over them.  Further, they do not intrude
- * on our cache or tlb entries.
- */
-
-struct exception_table_entry {
-	unsigned long insn, fixup;
-};
-
-extern int fixup_exception(struct pt_regs *regs);
-
-/*
- * These are the main single-value transfer routines.  They automatically
- * use the right size if we just have the right pointer type.
- *
- * This gets kind of ugly. We want to return _two_ values in "get_user()"
- * and yet we don't want to do any pointers, because that is too much
- * of a performance impact. Thus we have a few rather ugly macros here,
- * and hide all the ugliness from the user.
- *
- * The "__xxx" versions of the user access functions are versions that
- * do not verify the address space, that must have been done previously
- * with a separate "access_ok()" call (this is used when we do multiple
- * accesses to the same area of user memory).
- */
-
-extern void __get_user_1(void);
-extern void __get_user_2(void);
-extern void __get_user_4(void);
-
-#define __get_user_x(size, ret, x, ptr)	      \
-	asm volatile("call __get_user_" #size \
-		     :"=a" (ret),"=d" (x)     \
-		     :"0" (ptr))
-
-
-/* Careful: we have to cast the result to the type of the pointer
- * for sign reasons */
-
-/**
- * get_user: - Get a simple variable from user space.
- * @x:   Variable to store result.
- * @ptr: Source address, in user space.
- *
- * Context: User context only.  This function may sleep.
- *
- * This macro copies a single simple variable from user space to kernel
- * space.  It supports simple types like char and int, but not larger
- * data types like structures or arrays.
- *
- * @ptr must have pointer-to-simple-variable type, and the result of
- * dereferencing @ptr must be assignable to @x without a cast.
- *
- * Returns zero on success, or -EFAULT on error.
- * On error, the variable @x is set to zero.
- */
-#define get_user(x, ptr)						\
-({									\
-	int __ret_gu;							\
-	unsigned long __val_gu;						\
-	__chk_user_ptr(ptr);						\
-	switch (sizeof(*(ptr))) {					\
-	case 1:								\
-		__get_user_x(1, __ret_gu, __val_gu, ptr);		\
-		break;							\
-	case 2:								\
-		__get_user_x(2, __ret_gu, __val_gu, ptr);		\
-		break;							\
-	case 4:								\
-		__get_user_x(4, __ret_gu, __val_gu, ptr);		\
-		break;							\
-	default:							\
-		__get_user_x(X, __ret_gu, __val_gu, ptr);		\
-		break;							\
-	}								\
-	(x) = (__typeof__(*(ptr)))__val_gu;				\
-	__ret_gu;							\
-})
-
-extern void __put_user_bad(void);
-
-/*
- * Strange magic calling convention: pointer in %ecx,
- * value in %eax(:%edx), return value in %eax, no clobbers.
- */
-extern void __put_user_1(void);
-extern void __put_user_2(void);
-extern void __put_user_4(void);
-extern void __put_user_8(void);
-
-#define __put_user_1(x, ptr)					\
-	asm volatile("call __put_user_1" : "=a" (__ret_pu)	\
-		     : "0" ((typeof(*(ptr)))(x)), "c" (ptr))
-
-#define __put_user_2(x, ptr)					\
-	asm volatile("call __put_user_2" : "=a" (__ret_pu)	\
-		     : "0" ((typeof(*(ptr)))(x)), "c" (ptr))
-
-#define __put_user_4(x, ptr)					\
-	asm volatile("call __put_user_4" : "=a" (__ret_pu)	\
-		     : "0" ((typeof(*(ptr)))(x)), "c" (ptr))
-
-#define __put_user_8(x, ptr)					\
-	asm volatile("call __put_user_8" : "=a" (__ret_pu)	\
-		     : "A" ((typeof(*(ptr)))(x)), "c" (ptr))
-
-#define __put_user_X(x, ptr)					\
-	asm volatile("call __put_user_X" : "=a" (__ret_pu)	\
-		     : "c" (ptr))
-
-/**
- * put_user: - Write a simple value into user space.
- * @x:   Value to copy to user space.
- * @ptr: Destination address, in user space.
- *
- * Context: User context only.  This function may sleep.
- *
- * This macro copies a single simple value from kernel space to user
- * space.  It supports simple types like char and int, but not larger
- * data types like structures or arrays.
- *
- * @ptr must have pointer-to-simple-variable type, and @x must be assignable
- * to the result of dereferencing @ptr.
- *
- * Returns zero on success, or -EFAULT on error.
- */
-#ifdef CONFIG_X86_WP_WORKS_OK
-
-#define put_user(x, ptr)					\
-({								\
-	int __ret_pu;						\
-	__typeof__(*(ptr)) __pu_val;				\
-	__chk_user_ptr(ptr);					\
-	__pu_val = x;						\
-	switch (sizeof(*(ptr))) {				\
-	case 1:							\
-		__put_user_1(__pu_val, ptr);			\
-		break;						\
-	case 2:							\
-		__put_user_2(__pu_val, ptr);			\
-		break;						\
-	case 4:							\
-		__put_user_4(__pu_val, ptr);			\
-		break;						\
-	case 8:							\
-		__put_user_8(__pu_val, ptr);			\
-		break;						\
-	default:						\
-		__put_user_X(__pu_val, ptr);			\
-		break;						\
-	}							\
-	__ret_pu;						\
-})
-
-#else
-#define put_user(x, ptr)					\
-({								\
-	int __ret_pu;						\
-	__typeof__(*(ptr))__pus_tmp = x;			\
-	__ret_pu = 0;						\
-	if (unlikely(__copy_to_user_ll(ptr, &__pus_tmp,		\
-				       sizeof(*(ptr))) != 0))	\
-		__ret_pu = -EFAULT;				\
-	__ret_pu;						\
-})
-
-
-#endif
-
-/**
- * __get_user: - Get a simple variable from user space, with less checking.
- * @x:   Variable to store result.
- * @ptr: Source address, in user space.
- *
- * Context: User context only.  This function may sleep.
- *
- * This macro copies a single simple variable from user space to kernel
- * space.  It supports simple types like char and int, but not larger
- * data types like structures or arrays.
- *
- * @ptr must have pointer-to-simple-variable type, and the result of
- * dereferencing @ptr must be assignable to @x without a cast.
- *
- * Caller must check the pointer with access_ok() before calling this
- * function.
- *
- * Returns zero on success, or -EFAULT on error.
- * On error, the variable @x is set to zero.
- */
-#define __get_user(x, ptr)				\
-	__get_user_nocheck((x), (ptr), sizeof(*(ptr)))
-
-
-/**
- * __put_user: - Write a simple value into user space, with less checking.
- * @x:   Value to copy to user space.
- * @ptr: Destination address, in user space.
- *
- * Context: User context only.  This function may sleep.
- *
- * This macro copies a single simple value from kernel space to user
- * space.  It supports simple types like char and int, but not larger
- * data types like structures or arrays.
- *
- * @ptr must have pointer-to-simple-variable type, and @x must be assignable
- * to the result of dereferencing @ptr.
- *
- * Caller must check the pointer with access_ok() before calling this
- * function.
- *
- * Returns zero on success, or -EFAULT on error.
- */
-#define __put_user(x, ptr)						\
-	__put_user_nocheck((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
-
-#define __put_user_nocheck(x, ptr, size)			\
-({								\
-	long __pu_err;						\
-	__put_user_size((x), (ptr), (size), __pu_err, -EFAULT);	\
-	__pu_err;						\
-})
-
-
-#define __put_user_u64(x, addr, err)					\
-	asm volatile("1:	movl %%eax,0(%2)\n"			\
-		     "2:	movl %%edx,4(%2)\n"			\
-		     "3:\n"						\
-		     ".section .fixup,\"ax\"\n"				\
-		     "4:	movl %3,%0\n"				\
-		     "	jmp 3b\n"					\
-		     ".previous\n"					\
-		     _ASM_EXTABLE(1b, 4b)				\
-		     _ASM_EXTABLE(2b, 4b)				\
-		     : "=r" (err)					\
-		     : "A" (x), "r" (addr), "i" (-EFAULT), "0" (err))
-
-#ifdef CONFIG_X86_WP_WORKS_OK
-
-#define __put_user_size(x, ptr, size, retval, errret)			\
-do {									\
-	retval = 0;							\
-	__chk_user_ptr(ptr);						\
-	switch (size) {							\
-	case 1:								\
-		__put_user_asm(x, ptr, retval, "b", "b", "iq", errret);	\
-		break;							\
-	case 2:								\
-		__put_user_asm(x, ptr, retval, "w", "w", "ir", errret);	\
-		break;							\
-	case 4:								\
-		__put_user_asm(x, ptr, retval, "l", "",  "ir", errret);	\
-		break;							\
-	case 8:								\
-		__put_user_u64((__typeof__(*ptr))(x), ptr, retval);	\
-		break;							\
-	default:							\
-		__put_user_bad();					\
-	}								\
-} while (0)
-
-#else
-
-#define __put_user_size(x, ptr, size, retval, errret)			\
-do {									\
-	__typeof__(*(ptr))__pus_tmp = x;				\
-	retval = 0;							\
-									\
-	if (unlikely(__copy_to_user_ll(ptr, &__pus_tmp, size) != 0))	\
-		retval = errret;					\
-} while (0)
-
-#endif
-struct __large_struct { unsigned long buf[100]; };
-#define __m(x) (*(struct __large_struct __user *)(x))
-
-/*
- * Tell gcc we read from memory instead of writing: this is because
- * we do not write to any memory gcc knows about, so there are no
- * aliasing issues.
- */
-#define __put_user_asm(x, addr, err, itype, rtype, ltype, errret)	\
-	asm volatile("1:	mov"itype" %"rtype"1,%2\n"		\
-		     "2:\n"						\
-		     ".section .fixup,\"ax\"\n"				\
-		     "3:	movl %3,%0\n"				\
-		     "	jmp 2b\n"					\
-		     ".previous\n"					\
-		     _ASM_EXTABLE(1b, 3b)				\
-		     : "=r"(err)					\
-		     : ltype (x), "m" (__m(addr)), "i" (errret), "0" (err))
-
-
-#define __get_user_nocheck(x, ptr, size)				\
-({									\
-	long __gu_err;							\
-	unsigned long __gu_val;						\
-	__get_user_size(__gu_val, (ptr), (size), __gu_err, -EFAULT);	\
-	(x) = (__typeof__(*(ptr)))__gu_val;				\
-	__gu_err;							\
-})
-
-extern long __get_user_bad(void);
-
-#define __get_user_size(x, ptr, size, retval, errret)			\
-do {									\
-	retval = 0;							\
-	__chk_user_ptr(ptr);						\
-	switch (size) {							\
-	case 1:								\
-		__get_user_asm(x, ptr, retval, "b", "b", "=q", errret);	\
-		break;							\
-	case 2:								\
-		__get_user_asm(x, ptr, retval, "w", "w", "=r", errret);	\
-		break;							\
-	case 4:								\
-		__get_user_asm(x, ptr, retval, "l", "", "=r", errret);	\
-		break;							\
-	default:							\
-		(x) = __get_user_bad();					\
-	}								\
-} while (0)
-
-#define __get_user_asm(x, addr, err, itype, rtype, ltype, errret)	\
-	asm volatile("1:	mov"itype" %2,%"rtype"1\n"		\
-		     "2:\n"						\
-		     ".section .fixup,\"ax\"\n"				\
-		     "3:	movl %3,%0\n"				\
-		     "	xor"itype" %"rtype"1,%"rtype"1\n"		\
-		     "	jmp 2b\n"					\
-		     ".previous\n"					\
-		     _ASM_EXTABLE(1b, 3b)				\
-		     : "=r" (err), ltype (x)				\
-		     : "m" (__m(addr)), "i" (errret), "0" (err))
-
-
 unsigned long __must_check __copy_to_user_ll
 		(void __user *to, const void *from, unsigned long n);
 unsigned long __must_check __copy_from_user_ll
@@ -576,8 +156,6 @@ __copy_from_user(void *to, const void __user *from, unsigned long n)
 	return __copy_from_user_ll(to, from, n);
 }
 
-#define ARCH_HAS_NOCACHE_UACCESS
-
 static __always_inline unsigned long __copy_from_user_nocache(void *to,
 				const void __user *from, unsigned long n)
 {
diff --git a/include/asm-x86/uaccess_64.h b/include/asm-x86/uaccess_64.h
index b8a2f43..4e3ec00 100644
--- a/include/asm-x86/uaccess_64.h
+++ b/include/asm-x86/uaccess_64.h
@@ -9,265 +9,6 @@
 #include <linux/prefetch.h>
 #include <asm/page.h>
 
-#define VERIFY_READ 0
-#define VERIFY_WRITE 1
-
-/*
- * The fs value determines whether argument validity checking should be
- * performed or not.  If get_fs() == USER_DS, checking is performed, with
- * get_fs() == KERNEL_DS, checking is bypassed.
- *
- * For historical reasons, these macros are grossly misnamed.
- */
-
-#define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })
-
-#define KERNEL_DS	MAKE_MM_SEG(0xFFFFFFFFFFFFFFFFUL)
-#define USER_DS		MAKE_MM_SEG(PAGE_OFFSET)
-
-#define get_ds()	(KERNEL_DS)
-#define get_fs()	(current_thread_info()->addr_limit)
-#define set_fs(x)	(current_thread_info()->addr_limit = (x))
-
-#define segment_eq(a, b)	((a).seg == (b).seg)
-
-#define __addr_ok(addr) (!((unsigned long)(addr) &			\
-			   (current_thread_info()->addr_limit.seg)))
-
-/*
- * Uhhuh, this needs 65-bit arithmetic. We have a carry..
- */
-#define __range_not_ok(addr, size)					\
-({									\
-	unsigned long flag, roksum;					\
-	__chk_user_ptr(addr);						\
-	asm("# range_ok\n\r"						\
-	    "addq %3,%1 ; sbbq %0,%0 ; cmpq %1,%4 ; sbbq $0,%0"		\
-	    : "=&r" (flag), "=r" (roksum)				\
-	    : "1" (addr), "g" ((long)(size)),				\
-	      "g" (current_thread_info()->addr_limit.seg));		\
-	flag;								\
-})
-
-#define access_ok(type, addr, size) (__range_not_ok(addr, size) == 0)
-
-/*
- * The exception table consists of pairs of addresses: the first is the
- * address of an instruction that is allowed to fault, and the second is
- * the address at which the program should continue.  No registers are
- * modified, so it is entirely up to the continuation code to figure out
- * what to do.
- *
- * All the routines below use bits of fixup code that are out of line
- * with the main instruction path.  This means when everything is well,
- * we don't even have to jump over them.  Further, they do not intrude
- * on our cache or tlb entries.
- */
-
-struct exception_table_entry {
-	unsigned long insn, fixup;
-};
-
-extern int fixup_exception(struct pt_regs *regs);
-
-#define ARCH_HAS_SEARCH_EXTABLE
-
-/*
- * These are the main single-value transfer routines.  They automatically
- * use the right size if we just have the right pointer type.
- *
- * This gets kind of ugly. We want to return _two_ values in "get_user()"
- * and yet we don't want to do any pointers, because that is too much
- * of a performance impact. Thus we have a few rather ugly macros here,
- * and hide all the ugliness from the user.
- *
- * The "__xxx" versions of the user access functions are versions that
- * do not verify the address space, that must have been done previously
- * with a separate "access_ok()" call (this is used when we do multiple
- * accesses to the same area of user memory).
- */
-
-#define __get_user_x(size, ret, x, ptr)		      \
-	asm volatile("call __get_user_" #size	      \
-		     : "=a" (ret),"=d" (x)	      \
-		     : "c" (ptr)		      \
-		     : "r8")
-
-/* Careful: we have to cast the result to the type of the pointer
- * for sign reasons */
-
-#define get_user(x, ptr)						\
-({									\
-	unsigned long __val_gu;						\
-	int __ret_gu;							\
-	__chk_user_ptr(ptr);						\
-	switch (sizeof(*(ptr))) {					\
-	case 1:								\
-		__get_user_x(1, __ret_gu, __val_gu, ptr);		\
-		break;							\
-	case 2:								\
-		__get_user_x(2, __ret_gu, __val_gu, ptr);		\
-		break;							\
-	case 4:								\
-		__get_user_x(4, __ret_gu, __val_gu, ptr);		\
-		break;							\
-	case 8:								\
-		__get_user_x(8, __ret_gu, __val_gu, ptr);		\
-		break;							\
-	default:							\
-		__get_user_bad();					\
-		break;							\
-	}								\
-	(x) = (__force typeof(*(ptr)))__val_gu;				\
-	__ret_gu;							\
-})
-
-extern void __put_user_1(void);
-extern void __put_user_2(void);
-extern void __put_user_4(void);
-extern void __put_user_8(void);
-extern void __put_user_bad(void);
-
-#define __put_user_x(size, ret, x, ptr)					\
-	asm volatile("call __put_user_" #size				\
-		     :"=a" (ret)					\
-		     :"c" (ptr),"d" (x)					\
-		     :"r8")
-
-#define put_user(x, ptr)						\
-	__put_user_check((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
-
-#define __get_user(x, ptr)						\
-	__get_user_nocheck((x), (ptr), sizeof(*(ptr)))
-#define __put_user(x, ptr)						\
-	__put_user_nocheck((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
-
-#define __get_user_unaligned __get_user
-#define __put_user_unaligned __put_user
-
-#define __put_user_nocheck(x, ptr, size)		\
-({							\
-	int __pu_err;					\
-	__put_user_size((x), (ptr), (size), __pu_err);	\
-	__pu_err;					\
-})
-
-
-#define __put_user_check(x, ptr, size)				\
-({								\
-	int __pu_err;						\
-	typeof(*(ptr)) __user *__pu_addr = (ptr);		\
-	switch (size) {						\
-	case 1:							\
-		__put_user_x(1, __pu_err, x, __pu_addr);	\
-		break;						\
-	case 2:							\
-		__put_user_x(2, __pu_err, x, __pu_addr);	\
-		break;						\
-	case 4:							\
-		__put_user_x(4, __pu_err, x, __pu_addr);	\
-		break;						\
-	case 8:							\
-		__put_user_x(8, __pu_err, x, __pu_addr);	\
-		break;						\
-	default:						\
-		__put_user_bad();				\
-	}							\
-	__pu_err;						\
-})
-
-#define __put_user_size(x, ptr, size, retval)				\
-do {									\
-	retval = 0;							\
-	__chk_user_ptr(ptr);						\
-	switch (size) {							\
-	case 1:								\
-		__put_user_asm(x, ptr, retval, "b", "b", "iq", -EFAULT);\
-		break;							\
-	case 2:								\
-		__put_user_asm(x, ptr, retval, "w", "w", "ir", -EFAULT);\
-		break;							\
-	case 4:								\
-		__put_user_asm(x, ptr, retval, "l", "k", "ir", -EFAULT);\
-		break;							\
-	case 8:								\
-		__put_user_asm(x, ptr, retval, "q", "", "Zr", -EFAULT);	\
-		break;							\
-	default:							\
-		__put_user_bad();					\
-	}								\
-} while (0)
-
-/* FIXME: this hack is definitely wrong -AK */
-struct __large_struct { unsigned long buf[100]; };
-#define __m(x) (*(struct __large_struct __user *)(x))
-
-/*
- * Tell gcc we read from memory instead of writing: this is because
- * we do not write to any memory gcc knows about, so there are no
- * aliasing issues.
- */
-#define __put_user_asm(x, addr, err, itype, rtype, ltype, errno)	\
-	asm volatile("1:	mov"itype" %"rtype"1,%2\n"		\
-		     "2:\n"						\
-		     ".section .fixup, \"ax\"\n"			\
-		     "3:	mov %3,%0\n"				\
-		     "	jmp 2b\n"					\
-		     ".previous\n"					\
-		     _ASM_EXTABLE(1b, 3b)				\
-		     : "=r"(err)					\
-		     : ltype (x), "m" (__m(addr)), "i" (errno), "0" (err))
-
-
-#define __get_user_nocheck(x, ptr, size)			\
-({								\
-	int __gu_err;						\
-	unsigned long __gu_val;					\
-	__get_user_size(__gu_val, (ptr), (size), __gu_err);	\
-	(x) = (__force typeof(*(ptr)))__gu_val;			\
-	__gu_err;						\
-})
-
-extern int __get_user_1(void);
-extern int __get_user_2(void);
-extern int __get_user_4(void);
-extern int __get_user_8(void);
-extern int __get_user_bad(void);
-
-#define __get_user_size(x, ptr, size, retval)				\
-do {									\
-	retval = 0;							\
-	__chk_user_ptr(ptr);						\
-	switch (size) {							\
-	case 1:								\
-		__get_user_asm(x, ptr, retval, "b", "b", "=q", -EFAULT);\
-		break;							\
-	case 2:								\
-		__get_user_asm(x, ptr, retval, "w", "w", "=r", -EFAULT);\
-		break;							\
-	case 4:								\
-		__get_user_asm(x, ptr, retval, "l", "k", "=r", -EFAULT);\
-		break;							\
-	case 8:								\
-		__get_user_asm(x, ptr, retval, "q", "", "=r", -EFAULT);	\
-		break;							\
-	default:							\
-		(x) = __get_user_bad();					\
-	}								\
-} while (0)
-
-#define __get_user_asm(x, addr, err, itype, rtype, ltype, errno)	\
-	asm volatile("1:	mov"itype" %2,%"rtype"1\n"		\
-		     "2:\n"						\
-		     ".section .fixup, \"ax\"\n"			\
-		     "3:	mov %3,%0\n"				\
-		     "	xor"itype" %"rtype"1,%"rtype"1\n"		\
-		     "	jmp 2b\n"					\
-		     ".previous\n"					\
-		     _ASM_EXTABLE(1b, 3b)				\
-		     : "=r" (err), ltype (x)				\
-		     : "m" (__m(addr)), "i"(errno), "0"(err))
-
 /*
  * Copy To/From Userspace
  */
@@ -437,7 +178,6 @@ __copy_to_user_inatomic(void __user *dst, const void *src, unsigned size)
 	return copy_user_generic((__force void *)dst, src, size);
 }
 
-#define ARCH_HAS_NOCACHE_UACCESS 1
 extern long __copy_user_nocache(void *dst, const void __user *src,
 				unsigned size, int zerorest);
 
