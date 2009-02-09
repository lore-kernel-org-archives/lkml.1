Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbZBINnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbZBINnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756052AbZBINk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:40:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:37871 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756025AbZBINk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:40:56 -0500
From: Tejun Heo <tj@kernel.org>
To: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/11] x86: implement x86_32 stack protector
Date: Mon,  9 Feb 2009 22:39:58 +0900
Message-Id: <1234186798-16820-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1234186798-16820-1-git-send-email-tj@kernel.org>
References: <1234186798-16820-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 09 Feb 2009 13:40:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: stack protector for x86_32

Implement stack protector for x86_32.  GDT entry 28 is used for it.
It's set to point to stack_canary-20 and have the length of 24 bytes.
CONFIG_CC_STACKPROTECTOR turns off CONFIG_X86_32_LAZY_GS and sets %gs
to the stack canary segment on entry.  As %gs is otherwise unused by
the kernel, the canary can be anywhere.  It's defined as a percpu
variable.

x86_32 exception handlers take register frame on stack directly as
struct pt_regs.  With -fstack-protector turned on, gcc copies the
whole structure after the stack canary and (of course) doesn't copy
back on return thus losing all changed.  For now, -fno-stack-protector
is added to all files which contain those functions.  We definitely
need something better.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/Kconfig                          |    3 +-
 arch/x86/include/asm/processor.h          |    4 +
 arch/x86/include/asm/segment.h            |    9 +++-
 arch/x86/include/asm/stackprotector.h     |   91 +++++++++++++++++++++++++++--
 arch/x86/include/asm/system.h             |   21 +++++++
 arch/x86/kernel/Makefile                  |   18 ++++++
 arch/x86/kernel/cpu/common.c              |   17 ++++--
 arch/x86/kernel/entry_32.S                |    2 +-
 arch/x86/kernel/head_32.S                 |   20 ++++++-
 arch/x86/kernel/process_32.c              |    1 +
 arch/x86/kernel/setup_percpu.c            |    2 +
 scripts/gcc-x86_32-has-stack-protector.sh |    8 +++
 12 files changed, 180 insertions(+), 16 deletions(-)
 create mode 100644 scripts/gcc-x86_32-has-stack-protector.sh

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e91093a..31c555f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -198,7 +198,7 @@ config X86_TRAMPOLINE
 
 config X86_32_LAZY_GS
 	def_bool y
-	depends on X86_32
+	depends on X86_32 && !CC_STACKPROTECTOR
 
 config KTIME_SCALAR
 	def_bool X86_32
@@ -1342,7 +1342,6 @@ config CC_STACKPROTECTOR_ALL
 
 config CC_STACKPROTECTOR
 	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
-	depends on X86_64
 	select CC_STACKPROTECTOR_ALL
 	---help---
 	  This option turns on the -fstack-protector GCC feature. This
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 80b8be2..a013383 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -396,7 +396,11 @@ DECLARE_PER_CPU(union irq_stack_union, irq_stack_union);
 DECLARE_INIT_PER_CPU(irq_stack_union);
 
 DECLARE_PER_CPU(char *, irq_stack_ptr);
+#else	/* X86_64 */
+#ifdef CONFIG_CC_STACKPROTECTOR
+DECLARE_PER_CPU(unsigned long, stack_canary);
 #endif
+#endif	/* X86_64 */
 
 extern void print_cpu_info(struct cpuinfo_x86 *);
 extern unsigned int xstate_size;
diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index 1dc1b51..14e0ed8 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -61,7 +61,7 @@
  *
  *  26 - ESPFIX small SS
  *  27 - per-cpu			[ offset to per-cpu data area ]
- *  28 - unused
+ *  28 - stack_canary-20		[ for stack protector ]
  *  29 - unused
  *  30 - unused
  *  31 - TSS for double fault handler
@@ -95,6 +95,13 @@
 #define __KERNEL_PERCPU 0
 #endif
 
+#define GDT_ENTRY_STACK_CANARY		(GDT_ENTRY_KERNEL_BASE + 16)
+#ifdef CONFIG_CC_STACKPROTECTOR
+#define __KERNEL_STACK_CANARY		(GDT_ENTRY_STACK_CANARY * 8)
+#else
+#define __KERNEL_STACK_CANARY		0
+#endif
+
 #define GDT_ENTRY_DOUBLEFAULT_TSS	31
 
 /*
diff --git a/arch/x86/include/asm/stackprotector.h b/arch/x86/include/asm/stackprotector.h
index ee275e9..fa7e5bd 100644
--- a/arch/x86/include/asm/stackprotector.h
+++ b/arch/x86/include/asm/stackprotector.h
@@ -1,3 +1,35 @@
+/*
+ * GCC stack protector support.
+ *
+ * Stack protector works by putting predefined pattern at the start of
+ * the stack frame and verifying that it hasn't been overwritten when
+ * returning from the function.  The pattern is called stack canary
+ * and unfortunately gcc requires it to be at a fixed offset from %gs.
+ * On x86_64, the offset is 40 bytes and on x86_32 20 bytes.  x86_64
+ * and x86_32 use segment registers differently and thus handles this
+ * requirement differently.
+ *
+ * On x86_64, %gs is shared by percpu area and stack canary.  All
+ * percpu symbols are zero based and %gs points to the base of percpu
+ * area.  The first occupant of the percpu area is always
+ * irq_stack_union which contains stack_canary at offset 40.  Userland
+ * %gs is always saved and restored on kernel entry and exit using
+ * swapgs, so stack protector doesn't add any complexity there.
+ *
+ * On x86_32, it's slightly more complicated.  As in x86_64, %gs is
+ * used for userland TLS.  Unfortunately, some processors are much
+ * slower at loading segment registers with different value when
+ * entering and leaving the kernel, so the kernel uses %fs for percpu
+ * area and manages %gs lazily so that %gs is switched only when
+ * necessary, usually during task switch.
+ *
+ * As gcc requires the stack canary at %gs:20, %gs can't be managed
+ * lazily if stack protector is enabled, so the kernel saves and
+ * restores userland %gs on kernel entry and exit.  This behavior is
+ * controlled by CONFIG_X86_32_LAZY_GS and accessors are defined in
+ * system.h to hide the details.
+ */
+
 #ifndef _ASM_STACKPROTECTOR_H
 #define _ASM_STACKPROTECTOR_H 1
 
@@ -6,9 +38,19 @@
 #include <asm/tsc.h>
 #include <asm/processor.h>
 #include <asm/percpu.h>
+#include <asm/system.h>
+#include <asm/desc.h>
 #include <linux/random.h>
 
 /*
+ * 24 byte read-only segment initializer for stack canary.  Linker
+ * can't handle the address bit shifting.  Address will be set in
+ * head_32 for boot CPU and setup_per_cpu_areas() for others.
+ */
+#define GDT_STACK_CANARY_INIT						\
+	[GDT_ENTRY_STACK_CANARY] = { { { 0x00000018, 0x00409000 } } },
+
+/*
  * Initialize the stackprotector canary value.
  *
  * NOTE: this must only be called from functions that never return,
@@ -19,12 +61,9 @@ static __always_inline void boot_init_stack_canary(void)
 	u64 canary;
 	u64 tsc;
 
-	/*
-	 * Build time only check to make sure the stack_canary is at
-	 * offset 40 in the pda; this is a gcc ABI requirement
-	 */
+#ifdef CONFIG_X86_64
 	BUILD_BUG_ON(offsetof(union irq_stack_union, stack_canary) != 40);
-
+#endif
 	/*
 	 * We both use the random pool and the current TSC as a source
 	 * of randomness. The TSC only matters for very early init,
@@ -36,7 +75,49 @@ static __always_inline void boot_init_stack_canary(void)
 	canary += tsc + (tsc << 32UL);
 
 	current->stack_canary = canary;
+#ifdef CONFIG_X86_64
 	percpu_write(irq_stack_union.stack_canary, canary);
+#else
+	percpu_write(stack_canary, canary);
+#endif
+}
+
+static inline void setup_stack_canary_segment(int cpu)
+{
+#ifdef CONFIG_X86_32
+	unsigned long canary = (unsigned long)&per_cpu(stack_canary, cpu);
+	struct desc_struct *gdt_table = get_cpu_gdt_table(cpu);
+	struct desc_struct desc;
+
+	desc = gdt_table[GDT_ENTRY_STACK_CANARY];
+	desc.base0 = canary & 0xffff;
+	desc.base1 = (canary >> 16) & 0xff;
+	desc.base2 = (canary >> 24) & 0xff;
+	write_gdt_entry(gdt_table, GDT_ENTRY_STACK_CANARY, &desc, DESCTYPE_S);
+#endif
+}
+
+static inline void load_stack_canary_segment(void)
+{
+#ifdef CONFIG_X86_32
+	asm("mov %0, %%gs" : : "r" (__KERNEL_STACK_CANARY) : "memory");
+#endif
+}
+
+#else	/* CC_STACKPROTECTOR */
+
+#define GDT_STACK_CANARY_INIT
+
+/* dummy boot_init_stack_canary() is defined in linux/stackprotector.h */
+
+static inline void setup_stack_canary_segment(int cpu)
+{ }
+
+static inline void load_stack_canary_segment(void)
+{
+#ifdef CONFIG_X86_32
+	asm volatile ("mov %0, %%gs" : : "r" (0));
+#endif
 }
 
 #endif	/* CC_STACKPROTECTOR */
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index e658bbe..4ded307 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -23,6 +23,22 @@ struct task_struct *__switch_to(struct task_struct *prev,
 
 #ifdef CONFIG_X86_32
 
+#ifdef CONFIG_CC_STACKPROTECTOR
+#define __switch_canary							\
+	"movl "__percpu_arg([current_task])",%%ebx\n\t"			\
+	"movl %P[task_canary](%%ebx),%%ebx\n\t"				\
+	"movl %%ebx,"__percpu_arg([stack_canary])"\n\t"
+#define __switch_canary_oparam						\
+	, [stack_canary] "=m" (per_cpu_var(stack_canary))
+#define __switch_canary_iparam						\
+	, [current_task] "m" (per_cpu_var(current_task))		\
+	, [task_canary] "i" (offsetof(struct task_struct, stack_canary))
+#else	/* CC_STACKPROTECTOR */
+#define __switch_canary
+#define __switch_canary_oparam
+#define __switch_canary_iparam
+#endif	/* CC_STACKPROTECTOR */
+
 /*
  * Saving eflags is important. It switches not only IOPL between tasks,
  * it also protects other tasks from NT leaking through sysenter etc.
@@ -46,6 +62,7 @@ do {									\
 		     "pushl %[next_ip]\n\t"	/* restore EIP   */	\
 		     "jmp __switch_to\n"	/* regparm call  */	\
 		     "1:\t"						\
+		     __switch_canary					\
 		     "popl %%ebp\n\t"		/* restore EBP   */	\
 		     "popfl\n"			/* restore flags */	\
 									\
@@ -58,6 +75,8 @@ do {									\
 		       "=b" (ebx), "=c" (ecx), "=d" (edx),		\
 		       "=S" (esi), "=D" (edi)				\
 		       							\
+		       __switch_canary_oparam				\
+									\
 		       /* input parameters: */				\
 		     : [next_sp]  "m" (next->thread.sp),		\
 		       [next_ip]  "m" (next->thread.ip),		\
@@ -66,6 +85,8 @@ do {									\
 		       [prev]     "a" (prev),				\
 		       [next]     "d" (next)				\
 									\
+		       __switch_canary_iparam				\
+									\
 		     : /* reloaded segment registers */			\
 			"memory");					\
 } while (0)
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index a11e5ac..0da4e4d 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -24,6 +24,24 @@ CFLAGS_vsyscall_64.o	:= $(PROFILING) -g0 $(nostackp)
 CFLAGS_hpet.o		:= $(nostackp)
 CFLAGS_tsc.o		:= $(nostackp)
 CFLAGS_paravirt.o	:= $(nostackp)
+#
+# On x86_32, register frame is passed verbatim on stack as struct
+# pt_regs.  gcc considers the parameter to belong to the callee and
+# with -fstack-protector it copies pt_regs to the callee's stack frame
+# to put the structure after the stack canary causing changes made by
+# the exception handlers to be lost.  Turn off stack protector for all
+# files containing functions which take struct pt_regs from register
+# frame.
+#
+# The proper way to fix this is to teach gcc that the argument belongs
+# to the caller for these functions, oh well...
+#
+ifdef CONFIG_X86_32
+CFLAGS_process_32.o	:= $(nostackp)
+CFLAGS_vm86_32.o	:= $(nostackp)
+CFLAGS_signal.o		:= $(nostackp)
+CFLAGS_traps.o		:= $(nostackp)
+endif
 
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 2a3c9a5..3a9d45a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -40,6 +40,7 @@
 #include <asm/sections.h>
 #include <asm/setup.h>
 #include <asm/hypervisor.h>
+#include <asm/stackprotector.h>
 
 #include "cpu.h"
 
@@ -123,6 +124,7 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 
 	[GDT_ENTRY_ESPFIX_SS] = { { { 0x00000000, 0x00c09200 } } },
 	[GDT_ENTRY_PERCPU] = { { { 0x0000ffff, 0x00cf9200 } } },
+	GDT_STACK_CANARY_INIT
 #endif
 } };
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
@@ -305,6 +307,7 @@ void load_percpu_segment(int cpu)
 	loadsegment(gs, 0);
 	wrmsrl(MSR_GS_BASE, (unsigned long)per_cpu(irq_stack_union.gs_base, cpu));
 #endif
+	load_stack_canary_segment();
 }
 
 /* Current gdt points %fs at the "master" per-cpu area: after this,
@@ -984,16 +987,21 @@ unsigned long kernel_eflags;
  */
 DEFINE_PER_CPU(struct orig_ist, orig_ist);
 
-#else
+#else	/* x86_64 */
+
+#ifdef CONFIG_CC_STACKPROTECTOR
+DEFINE_PER_CPU(unsigned long, stack_canary);
+#endif
 
-/* Make sure %fs is initialized properly in idle threads */
+/* Make sure %fs and %gs are initialized properly in idle threads */
 struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
 {
 	memset(regs, 0, sizeof(struct pt_regs));
 	regs->fs = __KERNEL_PERCPU;
+	regs->gs = __KERNEL_STACK_CANARY;
 	return regs;
 }
-#endif
+#endif	/* x86_64 */
 
 /*
  * cpu_init() initializes state that is per-CPU. Some data is already
@@ -1155,9 +1163,6 @@ void __cpuinit cpu_init(void)
 	__set_tss_desc(cpu, GDT_ENTRY_DOUBLEFAULT_TSS, &doublefault_tss);
 #endif
 
-	/* Clear %gs. */
-	asm volatile ("mov %0, %%gs" : : "r" (0));
-
 	/* Clear all 6 debug registers: */
 	set_debugreg(0, 0);
 	set_debugreg(0, 1);
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index d3be889..f7d0837 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -186,7 +186,7 @@
 	/*CFI_REL_OFFSET gs, PT_GS*/
 .endm
 .macro SET_KERNEL_GS reg
-	xorl \reg, \reg
+	movl $(__KERNEL_STACK_CANARY), \reg
 	movl \reg, %gs
 .endm
 
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 0cd61bb..410c9bb 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -19,6 +19,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/setup.h>
 #include <asm/processor-flags.h>
+#include <asm/percpu.h>
 
 /* Physical address */
 #define pa(X) ((X) - __PAGE_OFFSET)
@@ -437,8 +438,25 @@ is386:	movl $2,%ecx		# set MP
 	movl $(__KERNEL_PERCPU), %eax
 	movl %eax,%fs			# set this cpu's percpu
 
-	xorl %eax,%eax			# Clear GS and LDT
+#ifdef CONFIG_CC_STACKPROTECTOR
+	/*
+	 * The linker can't handle this by relocation.  Manually set
+	 * base address in stack canary segment descriptor.
+	 */
+	cmpb $0,ready
+	jne 1f
+	movl $per_cpu__gdt_page,%eax
+	movl $per_cpu__stack_canary,%ecx
+	movw %cx, 8 * GDT_ENTRY_STACK_CANARY + 2(%eax)
+	shrl $16, %ecx
+	movb %cl, 8 * GDT_ENTRY_STACK_CANARY + 4(%eax)
+	movb %ch, 8 * GDT_ENTRY_STACK_CANARY + 7(%eax)
+1:
+#endif
+	movl $(__KERNEL_STACK_CANARY),%eax
 	movl %eax,%gs
+
+	xorl %eax,%eax			# Clear LDT
 	lldt %ax
 
 	cld			# gcc2 wants the direction flag cleared at all times
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 461d0a7..13d224b 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -210,6 +210,7 @@ int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 	regs.ds = __USER_DS;
 	regs.es = __USER_DS;
 	regs.fs = __KERNEL_PERCPU;
+	regs.gs = __KERNEL_STACK_CANARY;
 	regs.orig_ax = -1;
 	regs.ip = (unsigned long) kernel_thread_helper;
 	regs.cs = __KERNEL_CS | get_kernel_rpl();
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index ef91747..d992e6c 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -16,6 +16,7 @@
 #include <asm/proto.h>
 #include <asm/cpumask.h>
 #include <asm/cpu.h>
+#include <asm/stackprotector.h>
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 # define DBG(x...) printk(KERN_DEBUG x)
@@ -95,6 +96,7 @@ void __init setup_per_cpu_areas(void)
 		per_cpu(this_cpu_off, cpu) = per_cpu_offset(cpu);
 		per_cpu(cpu_number, cpu) = cpu;
 		setup_percpu_segment(cpu);
+		setup_stack_canary_segment(cpu);
 		/*
 		 * Copy data used in early init routines from the
 		 * initial arrays to the per cpu data areas.  These
diff --git a/scripts/gcc-x86_32-has-stack-protector.sh b/scripts/gcc-x86_32-has-stack-protector.sh
new file mode 100644
index 0000000..4fdf6ce
--- /dev/null
+++ b/scripts/gcc-x86_32-has-stack-protector.sh
@@ -0,0 +1,8 @@
+#!/bin/sh
+
+echo "int foo(void) { char X[200]; return 3; }" | $1 -S -xc -c -O0 -fstack-protector - -o - 2> /dev/null | grep -q "%gs"
+if [ "$?" -eq "0" ] ; then
+	echo y
+else
+	echo n
+fi
-- 
1.6.0.2

