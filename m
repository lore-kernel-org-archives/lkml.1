Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbZIKTgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbZIKTgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZIKTgC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:36:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40894 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbZIKTf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:35:59 -0400
Date: Fri, 11 Sep 2009 21:35:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] x86/asm for v2.6.32
Message-ID: <20090911193548.GA25243@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-asm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-asm-for-linus


out-of-topic modifications in x86-asm-for-linus:
------------------------------------------------
drivers/pnp/pnpbios/bioscalls.c    # c742531: x86: Introduce GDT_ENTRY_INIT(), 
                                   # 1e5de18: x86: Introduce GDT_ENTRY_INIT()
                                   # 5759474: x86: Introduce set_desc_base() an
include/asm-generic/percpu.h       # 53f8245: x86/i386: Put aligned stack-canar
include/linux/init.h               # 8b5a10f: x86: properly annotate alternativ
include/linux/percpu-defs.h        # 53f8245: x86/i386: Put aligned stack-canar

 Thanks,

	Ingo

------------------>
Akinobu Mita (5):
      x86: Use get_desc_base()
      x86: Remove unused patch_espfix_desc()
      x86: Introduce set_desc_base() and set_desc_limit()
      x86: Introduce GDT_ENTRY_INIT()
      x86: Introduce GDT_ENTRY_INIT(), initialize bad_bios_desc statically

Amerigo Wang (1):
      x86, 32-bit: Use generic sys_pipe()

H. Peter Anvin (1):
      x86: allow "=rm" in native_save_fl()

Ingo Molnar (1):
      x86: Introduce GDT_ENTRY_INIT(), fix APM

Jan Beulich (1):
      x86: properly annotate alternatives.c

Jeremy Fitzhardinge (2):
      x86/i386: Make sure stack-protector segment base is cache aligned
      x86/i386: Put aligned stack-canary in percpu shared_aligned section

Michal Schmidt (1):
      x86: Detect stack protector for i386 builds on x86_64


 arch/x86/Makefile                     |    2 +-
 arch/x86/ia32/ia32entry.S             |    2 +-
 arch/x86/ia32/sys_ia32.c              |   14 --------
 arch/x86/include/asm/alternative.h    |    7 ----
 arch/x86/include/asm/desc.h           |   13 +++++++
 arch/x86/include/asm/desc_defs.h      |    6 +++
 arch/x86/include/asm/irqflags.h       |    9 ++---
 arch/x86/include/asm/lguest.h         |    5 ++-
 arch/x86/include/asm/processor.h      |   12 ++++++-
 arch/x86/include/asm/stackprotector.h |   10 ++---
 arch/x86/include/asm/system.h         |   29 +----------------
 arch/x86/include/asm/traps.h          |    4 +--
 arch/x86/kernel/alternative.c         |   56 +++++++++++++++++++--------------
 arch/x86/kernel/apm_32.c              |   31 +++++++++---------
 arch/x86/kernel/cpu/common.c          |   42 ++++++++++++------------
 arch/x86/kernel/doublefault_32.c      |    4 +--
 arch/x86/kernel/head_32.S             |    1 -
 arch/x86/kernel/step.c                |    9 ++---
 arch/x86/kernel/traps.c               |   21 ------------
 drivers/pnp/pnpbios/bioscalls.c       |   25 ++++++--------
 include/asm-generic/percpu.h          |    3 ++
 include/linux/init.h                  |   12 ++++++-
 include/linux/percpu-defs.h           |    8 +++++
 23 files changed, 150 insertions(+), 175 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1b68659..5e7db44 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -72,7 +72,7 @@ endif
 
 ifdef CONFIG_CC_STACKPROTECTOR
 	cc_has_sp := $(srctree)/scripts/gcc-x86_$(BITS)-has-stack-protector.sh
-        ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC)),y)
+        ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC) $(biarch)),y)
                 stackp-y := -fstack-protector
                 stackp-$(CONFIG_CC_STACKPROTECTOR_ALL) += -fstack-protector-all
                 KBUILD_CFLAGS += $(stackp-y)
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index e590261..ba331bf 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -537,7 +537,7 @@ ia32_sys_call_table:
 	.quad sys_mkdir
 	.quad sys_rmdir		/* 40 */
 	.quad sys_dup
-	.quad sys32_pipe
+	.quad sys_pipe
 	.quad compat_sys_times
 	.quad quiet_ni_syscall			/* old prof syscall holder */
 	.quad sys_brk		/* 45 */
diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 085a8c3..9f55271 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -189,20 +189,6 @@ asmlinkage long sys32_mprotect(unsigned long start, size_t len,
 	return sys_mprotect(start, len, prot);
 }
 
-asmlinkage long sys32_pipe(int __user *fd)
-{
-	int retval;
-	int fds[2];
-
-	retval = do_pipe_flags(fds, 0);
-	if (retval)
-		goto out;
-	if (copy_to_user(fd, fds, sizeof(fds)))
-		retval = -EFAULT;
-out:
-	return retval;
-}
-
 asmlinkage long sys32_rt_sigaction(int sig, struct sigaction32 __user *act,
 				   struct sigaction32 __user *oact,
 				   unsigned int sigsetsize)
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 1a37bcd..c240efc 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -73,8 +73,6 @@ static inline void alternatives_smp_module_del(struct module *mod) {}
 static inline void alternatives_smp_switch(int smp) {}
 #endif	/* CONFIG_SMP */
 
-const unsigned char *const *find_nop_table(void);
-
 /* alternative assembly primitive: */
 #define ALTERNATIVE(oldinstr, newinstr, feature)			\
 									\
@@ -144,8 +142,6 @@ static inline void apply_paravirt(struct paravirt_patch_site *start,
 #define __parainstructions_end	NULL
 #endif
 
-extern void add_nops(void *insns, unsigned int len);
-
 /*
  * Clear and restore the kernel write-protection flag on the local CPU.
  * Allows the kernel to edit read-only pages.
@@ -161,10 +157,7 @@ extern void add_nops(void *insns, unsigned int len);
  * Intel's errata.
  * On the local CPU you need to be protected again NMI or MCE handlers seeing an
  * inconsistent instruction while you patch.
- * The _early version expects the memory to already be RW.
  */
-
 extern void *text_poke(void *addr, const void *opcode, size_t len);
-extern void *text_poke_early(void *addr, const void *opcode, size_t len);
 
 #endif /* _ASM_X86_ALTERNATIVE_H */
diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index c993e9e..e8de2f6 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -291,11 +291,24 @@ static inline unsigned long get_desc_base(const struct desc_struct *desc)
 	return desc->base0 | ((desc->base1) << 16) | ((desc->base2) << 24);
 }
 
+static inline void set_desc_base(struct desc_struct *desc, unsigned long base)
+{
+	desc->base0 = base & 0xffff;
+	desc->base1 = (base >> 16) & 0xff;
+	desc->base2 = (base >> 24) & 0xff;
+}
+
 static inline unsigned long get_desc_limit(const struct desc_struct *desc)
 {
 	return desc->limit0 | (desc->limit << 16);
 }
 
+static inline void set_desc_limit(struct desc_struct *desc, unsigned long limit)
+{
+	desc->limit0 = limit & 0xffff;
+	desc->limit = (limit >> 16) & 0xf;
+}
+
 static inline void _set_gate(int gate, unsigned type, void *addr,
 			     unsigned dpl, unsigned ist, unsigned seg)
 {
diff --git a/arch/x86/include/asm/desc_defs.h b/arch/x86/include/asm/desc_defs.h
index a6adefa..9d66848 100644
--- a/arch/x86/include/asm/desc_defs.h
+++ b/arch/x86/include/asm/desc_defs.h
@@ -34,6 +34,12 @@ struct desc_struct {
 	};
 } __attribute__((packed));
 
+#define GDT_ENTRY_INIT(flags, base, limit) { { { \
+		.a = ((limit) & 0xffff) | (((base) & 0xffff) << 16), \
+		.b = (((base) & 0xff0000) >> 16) | (((flags) & 0xf0ff) << 8) | \
+			((limit) & 0xf0000) | ((base) & 0xff000000), \
+	} } }
+
 enum {
 	GATE_INTERRUPT = 0xE,
 	GATE_TRAP = 0xF,
diff --git a/arch/x86/include/asm/irqflags.h b/arch/x86/include/asm/irqflags.h
index c6ccbe7..9e2b952 100644
--- a/arch/x86/include/asm/irqflags.h
+++ b/arch/x86/include/asm/irqflags.h
@@ -13,14 +13,13 @@ static inline unsigned long native_save_fl(void)
 	unsigned long flags;
 
 	/*
-	 * Note: this needs to be "=r" not "=rm", because we have the
-	 * stack offset from what gcc expects at the time the "pop" is
-	 * executed, and so a memory reference with respect to the stack
-	 * would end up using the wrong address.
+	 * "=rm" is safe here, because "pop" adjusts the stack before
+	 * it evaluates its effective address -- this is part of the
+	 * documented behavior of the "pop" instruction.
 	 */
 	asm volatile("# __raw_save_flags\n\t"
 		     "pushf ; pop %0"
-		     : "=r" (flags)
+		     : "=rm" (flags)
 		     : /* no input */
 		     : "memory");
 
diff --git a/arch/x86/include/asm/lguest.h b/arch/x86/include/asm/lguest.h
index 5136dad..0d97deb 100644
--- a/arch/x86/include/asm/lguest.h
+++ b/arch/x86/include/asm/lguest.h
@@ -90,8 +90,9 @@ static inline void lguest_set_ts(void)
 }
 
 /* Full 4G segment descriptors, suitable for CS and DS. */
-#define FULL_EXEC_SEGMENT ((struct desc_struct){ { {0x0000ffff, 0x00cf9b00} } })
-#define FULL_SEGMENT ((struct desc_struct){ { {0x0000ffff, 0x00cf9300} } })
+#define FULL_EXEC_SEGMENT \
+	((struct desc_struct)GDT_ENTRY_INIT(0xc09b, 0, 0xfffff))
+#define FULL_SEGMENT ((struct desc_struct)GDT_ENTRY_INIT(0xc093, 0, 0xfffff))
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c776826..ac7e796 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -403,7 +403,17 @@ extern unsigned long kernel_eflags;
 extern asmlinkage void ignore_sysret(void);
 #else	/* X86_64 */
 #ifdef CONFIG_CC_STACKPROTECTOR
-DECLARE_PER_CPU(unsigned long, stack_canary);
+/*
+ * Make sure stack canary segment base is cached-aligned:
+ *   "For Intel Atom processors, avoid non zero segment base address
+ *    that is not aligned to cache line boundary at all cost."
+ * (Optim Ref Manual Assembly/Compiler Coding Rule 15.)
+ */
+struct stack_canary {
+	char __pad[20];		/* canary at %gs:20 */
+	unsigned long canary;
+};
+DECLARE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
 #endif
 #endif	/* X86_64 */
 
diff --git a/arch/x86/include/asm/stackprotector.h b/arch/x86/include/asm/stackprotector.h
index c2d742c..1575177 100644
--- a/arch/x86/include/asm/stackprotector.h
+++ b/arch/x86/include/asm/stackprotector.h
@@ -48,7 +48,7 @@
  * head_32 for boot CPU and setup_per_cpu_areas() for others.
  */
 #define GDT_STACK_CANARY_INIT						\
-	[GDT_ENTRY_STACK_CANARY] = { { { 0x00000018, 0x00409000 } } },
+	[GDT_ENTRY_STACK_CANARY] = GDT_ENTRY_INIT(0x4090, 0, 0x18),
 
 /*
  * Initialize the stackprotector canary value.
@@ -78,21 +78,19 @@ static __always_inline void boot_init_stack_canary(void)
 #ifdef CONFIG_X86_64
 	percpu_write(irq_stack_union.stack_canary, canary);
 #else
-	percpu_write(stack_canary, canary);
+	percpu_write(stack_canary.canary, canary);
 #endif
 }
 
 static inline void setup_stack_canary_segment(int cpu)
 {
 #ifdef CONFIG_X86_32
-	unsigned long canary = (unsigned long)&per_cpu(stack_canary, cpu) - 20;
+	unsigned long canary = (unsigned long)&per_cpu(stack_canary, cpu);
 	struct desc_struct *gdt_table = get_cpu_gdt_table(cpu);
 	struct desc_struct desc;
 
 	desc = gdt_table[GDT_ENTRY_STACK_CANARY];
-	desc.base0 = canary & 0xffff;
-	desc.base1 = (canary >> 16) & 0xff;
-	desc.base2 = (canary >> 24) & 0xff;
+	set_desc_base(&desc, canary);
 	write_gdt_entry(gdt_table, GDT_ENTRY_STACK_CANARY, &desc, DESCTYPE_S);
 #endif
 }
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 643c59b..f08f973 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -31,7 +31,7 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 	"movl %P[task_canary](%[next]), %%ebx\n\t"			\
 	"movl %%ebx, "__percpu_arg([stack_canary])"\n\t"
 #define __switch_canary_oparam						\
-	, [stack_canary] "=m" (per_cpu_var(stack_canary))
+	, [stack_canary] "=m" (per_cpu_var(stack_canary.canary))
 #define __switch_canary_iparam						\
 	, [task_canary] "i" (offsetof(struct task_struct, stack_canary))
 #else	/* CC_STACKPROTECTOR */
@@ -150,33 +150,6 @@ do {									\
 #endif
 
 #ifdef __KERNEL__
-#define _set_base(addr, base) do { unsigned long __pr; \
-__asm__ __volatile__ ("movw %%dx,%1\n\t" \
-	"rorl $16,%%edx\n\t" \
-	"movb %%dl,%2\n\t" \
-	"movb %%dh,%3" \
-	:"=&d" (__pr) \
-	:"m" (*((addr)+2)), \
-	 "m" (*((addr)+4)), \
-	 "m" (*((addr)+7)), \
-	 "0" (base) \
-	); } while (0)
-
-#define _set_limit(addr, limit) do { unsigned long __lr; \
-__asm__ __volatile__ ("movw %%dx,%1\n\t" \
-	"rorl $16,%%edx\n\t" \
-	"movb %2,%%dh\n\t" \
-	"andb $0xf0,%%dh\n\t" \
-	"orb %%dh,%%dl\n\t" \
-	"movb %%dl,%2" \
-	:"=&d" (__lr) \
-	:"m" (*(addr)), \
-	 "m" (*((addr)+6)), \
-	 "0" (limit) \
-	); } while (0)
-
-#define set_base(ldt, base) _set_base(((char *)&(ldt)) , (base))
-#define set_limit(ldt, limit) _set_limit(((char *)&(ldt)) , ((limit)-1))
 
 extern void native_load_gs_index(unsigned);
 
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index bfd74c0..4da91ad 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -81,9 +81,7 @@ extern int panic_on_unrecovered_nmi;
 
 void math_error(void __user *);
 void math_emulate(struct math_emu_info *);
-#ifdef CONFIG_X86_32
-unsigned long patch_espfix_desc(unsigned long, unsigned long);
-#else
+#ifndef CONFIG_X86_32
 asmlinkage void smp_thermal_interrupt(void);
 asmlinkage void mce_threshold_interrupt(void);
 #endif
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index f576587..4869351 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -2,6 +2,7 @@
 #include <linux/sched.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
+#include <linux/stringify.h>
 #include <linux/kprobes.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
@@ -32,7 +33,7 @@ __setup("smp-alt-boot", bootonly);
 #define smp_alt_once 1
 #endif
 
-static int debug_alternative;
+static int __initdata_or_module debug_alternative;
 
 static int __init debug_alt(char *str)
 {
@@ -51,7 +52,7 @@ static int __init setup_noreplace_smp(char *str)
 __setup("noreplace-smp", setup_noreplace_smp);
 
 #ifdef CONFIG_PARAVIRT
-static int noreplace_paravirt = 0;
+static int __initdata_or_module noreplace_paravirt = 0;
 
 static int __init setup_noreplace_paravirt(char *str)
 {
@@ -64,16 +65,17 @@ __setup("noreplace-paravirt", setup_noreplace_paravirt);
 #define DPRINTK(fmt, args...) if (debug_alternative) \
 	printk(KERN_DEBUG fmt, args)
 
-#ifdef GENERIC_NOP1
+#if defined(GENERIC_NOP1) && !defined(CONFIG_X86_64)
 /* Use inline assembly to define this because the nops are defined
    as inline assembly strings in the include files and we cannot
    get them easily into strings. */
-asm("\t.section .rodata, \"a\"\nintelnops: "
+asm("\t" __stringify(__INITRODATA_OR_MODULE) "\nintelnops: "
 	GENERIC_NOP1 GENERIC_NOP2 GENERIC_NOP3 GENERIC_NOP4 GENERIC_NOP5 GENERIC_NOP6
 	GENERIC_NOP7 GENERIC_NOP8
     "\t.previous");
 extern const unsigned char intelnops[];
-static const unsigned char *const intel_nops[ASM_NOP_MAX+1] = {
+static const unsigned char *const __initconst_or_module
+intel_nops[ASM_NOP_MAX+1] = {
 	NULL,
 	intelnops,
 	intelnops + 1,
@@ -87,12 +89,13 @@ static const unsigned char *const intel_nops[ASM_NOP_MAX+1] = {
 #endif
 
 #ifdef K8_NOP1
-asm("\t.section .rodata, \"a\"\nk8nops: "
+asm("\t" __stringify(__INITRODATA_OR_MODULE) "\nk8nops: "
 	K8_NOP1 K8_NOP2 K8_NOP3 K8_NOP4 K8_NOP5 K8_NOP6
 	K8_NOP7 K8_NOP8
     "\t.previous");
 extern const unsigned char k8nops[];
-static const unsigned char *const k8_nops[ASM_NOP_MAX+1] = {
+static const unsigned char *const __initconst_or_module
+k8_nops[ASM_NOP_MAX+1] = {
 	NULL,
 	k8nops,
 	k8nops + 1,
@@ -105,13 +108,14 @@ static const unsigned char *const k8_nops[ASM_NOP_MAX+1] = {
 };
 #endif
 
-#ifdef K7_NOP1
-asm("\t.section .rodata, \"a\"\nk7nops: "
+#if defined(K7_NOP1) && !defined(CONFIG_X86_64)
+asm("\t" __stringify(__INITRODATA_OR_MODULE) "\nk7nops: "
 	K7_NOP1 K7_NOP2 K7_NOP3 K7_NOP4 K7_NOP5 K7_NOP6
 	K7_NOP7 K7_NOP8
     "\t.previous");
 extern const unsigned char k7nops[];
-static const unsigned char *const k7_nops[ASM_NOP_MAX+1] = {
+static const unsigned char *const __initconst_or_module
+k7_nops[ASM_NOP_MAX+1] = {
 	NULL,
 	k7nops,
 	k7nops + 1,
@@ -125,12 +129,13 @@ static const unsigned char *const k7_nops[ASM_NOP_MAX+1] = {
 #endif
 
 #ifdef P6_NOP1
-asm("\t.section .rodata, \"a\"\np6nops: "
+asm("\t" __stringify(__INITRODATA_OR_MODULE) "\np6nops: "
 	P6_NOP1 P6_NOP2 P6_NOP3 P6_NOP4 P6_NOP5 P6_NOP6
 	P6_NOP7 P6_NOP8
     "\t.previous");
 extern const unsigned char p6nops[];
-static const unsigned char *const p6_nops[ASM_NOP_MAX+1] = {
+static const unsigned char *const __initconst_or_module
+p6_nops[ASM_NOP_MAX+1] = {
 	NULL,
 	p6nops,
 	p6nops + 1,
@@ -146,7 +151,7 @@ static const unsigned char *const p6_nops[ASM_NOP_MAX+1] = {
 #ifdef CONFIG_X86_64
 
 extern char __vsyscall_0;
-const unsigned char *const *find_nop_table(void)
+static const unsigned char *const *__init_or_module find_nop_table(void)
 {
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
 	    boot_cpu_has(X86_FEATURE_NOPL))
@@ -157,7 +162,7 @@ const unsigned char *const *find_nop_table(void)
 
 #else /* CONFIG_X86_64 */
 
-const unsigned char *const *find_nop_table(void)
+static const unsigned char *const *__init_or_module find_nop_table(void)
 {
 	if (boot_cpu_has(X86_FEATURE_K8))
 		return k8_nops;
@@ -172,7 +177,7 @@ const unsigned char *const *find_nop_table(void)
 #endif /* CONFIG_X86_64 */
 
 /* Use this to add nops to a buffer, then text_poke the whole buffer. */
-void add_nops(void *insns, unsigned int len)
+static void __init_or_module add_nops(void *insns, unsigned int len)
 {
 	const unsigned char *const *noptable = find_nop_table();
 
@@ -185,10 +190,10 @@ void add_nops(void *insns, unsigned int len)
 		len -= noplen;
 	}
 }
-EXPORT_SYMBOL_GPL(add_nops);
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 extern u8 *__smp_locks[], *__smp_locks_end[];
+static void *text_poke_early(void *addr, const void *opcode, size_t len);
 
 /* Replace instructions with better alternatives for this CPU type.
    This runs before SMP is initialized to avoid SMP problems with
@@ -196,7 +201,8 @@ extern u8 *__smp_locks[], *__smp_locks_end[];
    APs have less capabilities than the boot processor are not handled.
    Tough. Make sure you disable such features by hand. */
 
-void apply_alternatives(struct alt_instr *start, struct alt_instr *end)
+void __init_or_module apply_alternatives(struct alt_instr *start,
+					 struct alt_instr *end)
 {
 	struct alt_instr *a;
 	char insnbuf[MAX_PATCH_LEN];
@@ -279,9 +285,10 @@ static LIST_HEAD(smp_alt_modules);
 static DEFINE_MUTEX(smp_alt);
 static int smp_mode = 1;	/* protected by smp_alt */
 
-void alternatives_smp_module_add(struct module *mod, char *name,
-				 void *locks, void *locks_end,
-				 void *text,  void *text_end)
+void __init_or_module alternatives_smp_module_add(struct module *mod,
+						  char *name,
+						  void *locks, void *locks_end,
+						  void *text,  void *text_end)
 {
 	struct smp_alt_module *smp;
 
@@ -317,7 +324,7 @@ void alternatives_smp_module_add(struct module *mod, char *name,
 	mutex_unlock(&smp_alt);
 }
 
-void alternatives_smp_module_del(struct module *mod)
+void __init_or_module alternatives_smp_module_del(struct module *mod)
 {
 	struct smp_alt_module *item;
 
@@ -386,8 +393,8 @@ void alternatives_smp_switch(int smp)
 #endif
 
 #ifdef CONFIG_PARAVIRT
-void apply_paravirt(struct paravirt_patch_site *start,
-		    struct paravirt_patch_site *end)
+void __init_or_module apply_paravirt(struct paravirt_patch_site *start,
+				     struct paravirt_patch_site *end)
 {
 	struct paravirt_patch_site *p;
 	char insnbuf[MAX_PATCH_LEN];
@@ -485,7 +492,8 @@ void __init alternative_instructions(void)
  * instructions. And on the local CPU you need to be protected again NMI or MCE
  * handlers seeing an inconsistent instruction while you patch.
  */
-void *text_poke_early(void *addr, const void *opcode, size_t len)
+static void *__init_or_module text_poke_early(void *addr, const void *opcode,
+					      size_t len)
 {
 	unsigned long flags;
 	local_irq_save(flags);
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 442b550..151ace6 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -403,7 +403,15 @@ static DECLARE_WAIT_QUEUE_HEAD(apm_waitqueue);
 static DECLARE_WAIT_QUEUE_HEAD(apm_suspend_waitqueue);
 static struct apm_user *user_list;
 static DEFINE_SPINLOCK(user_list_lock);
-static const struct desc_struct	bad_bios_desc = { { { 0, 0x00409200 } } };
+
+/*
+ * Set up a segment that references the real mode segment 0x40
+ * that extends up to the end of page zero (that we have reserved).
+ * This is for buggy BIOS's that refer to (real mode) segment 0x40
+ * even though they are called in protected mode.
+ */
+static struct desc_struct bad_bios_desc = GDT_ENTRY_INIT(0x4092,
+			(unsigned long)__va(0x400UL), PAGE_SIZE - 0x400 - 1);
 
 static const char driver_version[] = "1.16ac";	/* no spaces */
 
@@ -2332,15 +2340,6 @@ static int __init apm_init(void)
 	pm_flags |= PM_APM;
 
 	/*
-	 * Set up a segment that references the real mode segment 0x40
-	 * that extends up to the end of page zero (that we have reserved).
-	 * This is for buggy BIOS's that refer to (real mode) segment 0x40
-	 * even though they are called in protected mode.
-	 */
-	set_base(bad_bios_desc, __va((unsigned long)0x40 << 4));
-	_set_limit((char *)&bad_bios_desc, 4095 - (0x40 << 4));
-
-	/*
 	 * Set up the long jump entry point to the APM BIOS, which is called
 	 * from inline assembly.
 	 */
@@ -2358,12 +2357,12 @@ static int __init apm_init(void)
 	 * code to that CPU.
 	 */
 	gdt = get_cpu_gdt_table(0);
-	set_base(gdt[APM_CS >> 3],
-		 __va((unsigned long)apm_info.bios.cseg << 4));
-	set_base(gdt[APM_CS_16 >> 3],
-		 __va((unsigned long)apm_info.bios.cseg_16 << 4));
-	set_base(gdt[APM_DS >> 3],
-		 __va((unsigned long)apm_info.bios.dseg << 4));
+	set_desc_base(&gdt[APM_CS >> 3],
+		 (unsigned long)__va((unsigned long)apm_info.bios.cseg << 4));
+	set_desc_base(&gdt[APM_CS_16 >> 3],
+		 (unsigned long)__va((unsigned long)apm_info.bios.cseg_16 << 4));
+	set_desc_base(&gdt[APM_DS >> 3],
+		 (unsigned long)__va((unsigned long)apm_info.bios.dseg << 4));
 
 	proc_create("apm", 0, NULL, &apm_file_ops);
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 5ce60a8..f23e236 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -94,45 +94,45 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 	 * TLS descriptors are currently at a different place compared to i386.
 	 * Hopefully nobody expects them at a fixed place (Wine?)
 	 */
-	[GDT_ENTRY_KERNEL32_CS]		= { { { 0x0000ffff, 0x00cf9b00 } } },
-	[GDT_ENTRY_KERNEL_CS]		= { { { 0x0000ffff, 0x00af9b00 } } },
-	[GDT_ENTRY_KERNEL_DS]		= { { { 0x0000ffff, 0x00cf9300 } } },
-	[GDT_ENTRY_DEFAULT_USER32_CS]	= { { { 0x0000ffff, 0x00cffb00 } } },
-	[GDT_ENTRY_DEFAULT_USER_DS]	= { { { 0x0000ffff, 0x00cff300 } } },
-	[GDT_ENTRY_DEFAULT_USER_CS]	= { { { 0x0000ffff, 0x00affb00 } } },
+	[GDT_ENTRY_KERNEL32_CS]		= GDT_ENTRY_INIT(0xc09b, 0, 0xfffff),
+	[GDT_ENTRY_KERNEL_CS]		= GDT_ENTRY_INIT(0xa09b, 0, 0xfffff),
+	[GDT_ENTRY_KERNEL_DS]		= GDT_ENTRY_INIT(0xc093, 0, 0xfffff),
+	[GDT_ENTRY_DEFAULT_USER32_CS]	= GDT_ENTRY_INIT(0xc0fb, 0, 0xfffff),
+	[GDT_ENTRY_DEFAULT_USER_DS]	= GDT_ENTRY_INIT(0xc0f3, 0, 0xfffff),
+	[GDT_ENTRY_DEFAULT_USER_CS]	= GDT_ENTRY_INIT(0xa0fb, 0, 0xfffff),
 #else
-	[GDT_ENTRY_KERNEL_CS]		= { { { 0x0000ffff, 0x00cf9a00 } } },
-	[GDT_ENTRY_KERNEL_DS]		= { { { 0x0000ffff, 0x00cf9200 } } },
-	[GDT_ENTRY_DEFAULT_USER_CS]	= { { { 0x0000ffff, 0x00cffa00 } } },
-	[GDT_ENTRY_DEFAULT_USER_DS]	= { { { 0x0000ffff, 0x00cff200 } } },
+	[GDT_ENTRY_KERNEL_CS]		= GDT_ENTRY_INIT(0xc09a, 0, 0xfffff),
+	[GDT_ENTRY_KERNEL_DS]		= GDT_ENTRY_INIT(0xc092, 0, 0xfffff),
+	[GDT_ENTRY_DEFAULT_USER_CS]	= GDT_ENTRY_INIT(0xc0fa, 0, 0xfffff),
+	[GDT_ENTRY_DEFAULT_USER_DS]	= GDT_ENTRY_INIT(0xc0f2, 0, 0xfffff),
 	/*
 	 * Segments used for calling PnP BIOS have byte granularity.
 	 * They code segments and data segments have fixed 64k limits,
 	 * the transfer segment sizes are set at run time.
 	 */
 	/* 32-bit code */
-	[GDT_ENTRY_PNPBIOS_CS32]	= { { { 0x0000ffff, 0x00409a00 } } },
+	[GDT_ENTRY_PNPBIOS_CS32]	= GDT_ENTRY_INIT(0x409a, 0, 0xffff),
 	/* 16-bit code */
-	[GDT_ENTRY_PNPBIOS_CS16]	= { { { 0x0000ffff, 0x00009a00 } } },
+	[GDT_ENTRY_PNPBIOS_CS16]	= GDT_ENTRY_INIT(0x009a, 0, 0xffff),
 	/* 16-bit data */
-	[GDT_ENTRY_PNPBIOS_DS]		= { { { 0x0000ffff, 0x00009200 } } },
+	[GDT_ENTRY_PNPBIOS_DS]		= GDT_ENTRY_INIT(0x0092, 0, 0xffff),
 	/* 16-bit data */
-	[GDT_ENTRY_PNPBIOS_TS1]		= { { { 0x00000000, 0x00009200 } } },
+	[GDT_ENTRY_PNPBIOS_TS1]		= GDT_ENTRY_INIT(0x0092, 0, 0),
 	/* 16-bit data */
-	[GDT_ENTRY_PNPBIOS_TS2]		= { { { 0x00000000, 0x00009200 } } },
+	[GDT_ENTRY_PNPBIOS_TS2]		= GDT_ENTRY_INIT(0x0092, 0, 0),
 	/*
 	 * The APM segments have byte granularity and their bases
 	 * are set at run time.  All have 64k limits.
 	 */
 	/* 32-bit code */
-	[GDT_ENTRY_APMBIOS_BASE]	= { { { 0x0000ffff, 0x00409a00 } } },
+	[GDT_ENTRY_APMBIOS_BASE]	= GDT_ENTRY_INIT(0x409a, 0, 0xffff),
 	/* 16-bit code */
-	[GDT_ENTRY_APMBIOS_BASE+1]	= { { { 0x0000ffff, 0x00009a00 } } },
+	[GDT_ENTRY_APMBIOS_BASE+1]	= GDT_ENTRY_INIT(0x009a, 0, 0xffff),
 	/* data */
-	[GDT_ENTRY_APMBIOS_BASE+2]	= { { { 0x0000ffff, 0x00409200 } } },
+	[GDT_ENTRY_APMBIOS_BASE+2]	= GDT_ENTRY_INIT(0x4092, 0, 0xffff),
 
-	[GDT_ENTRY_ESPFIX_SS]		= { { { 0x0000ffff, 0x00cf9200 } } },
-	[GDT_ENTRY_PERCPU]		= { { { 0x0000ffff, 0x00cf9200 } } },
+	[GDT_ENTRY_ESPFIX_SS]		= GDT_ENTRY_INIT(0xc092, 0, 0xfffff),
+	[GDT_ENTRY_PERCPU]		= GDT_ENTRY_INIT(0xc092, 0, 0xfffff),
 	GDT_STACK_CANARY_INIT
 #endif
 } };
@@ -1043,7 +1043,7 @@ DEFINE_PER_CPU(struct orig_ist, orig_ist);
 #else	/* CONFIG_X86_64 */
 
 #ifdef CONFIG_CC_STACKPROTECTOR
-DEFINE_PER_CPU(unsigned long, stack_canary);
+DEFINE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
 #endif
 
 /* Make sure %fs and %gs are initialized properly in idle threads */
diff --git a/arch/x86/kernel/doublefault_32.c b/arch/x86/kernel/doublefault_32.c
index b4f14c6..37250fe 100644
--- a/arch/x86/kernel/doublefault_32.c
+++ b/arch/x86/kernel/doublefault_32.c
@@ -27,9 +27,7 @@ static void doublefault_fn(void)
 
 	if (ptr_ok(gdt)) {
 		gdt += GDT_ENTRY_TSS << 3;
-		tss = *(u16 *)(gdt+2);
-		tss += *(u8 *)(gdt+4) << 16;
-		tss += *(u8 *)(gdt+7) << 24;
+		tss = get_desc_base((struct desc_struct *)gdt);
 		printk(KERN_EMERG "double fault, tss at %08lx\n", tss);
 
 		if (ptr_ok(tss)) {
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index cc827ac..7ffec6b 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -439,7 +439,6 @@ is386:	movl $2,%ecx		# set MP
 	jne 1f
 	movl $per_cpu__gdt_page,%eax
 	movl $per_cpu__stack_canary,%ecx
-	subl $20, %ecx
 	movw %cx, 8 * GDT_ENTRY_STACK_CANARY + 2(%eax)
 	shrl $16, %ecx
 	movb %cl, 8 * GDT_ENTRY_STACK_CANARY + 4(%eax)
diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index e8b9863..3149032 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -4,6 +4,7 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/ptrace.h>
+#include <asm/desc.h>
 
 unsigned long convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs)
 {
@@ -23,7 +24,7 @@ unsigned long convert_ip_to_linear(struct task_struct *child, struct pt_regs *re
 	 * and APM bios ones we just ignore here.
 	 */
 	if ((seg & SEGMENT_TI_MASK) == SEGMENT_LDT) {
-		u32 *desc;
+		struct desc_struct *desc;
 		unsigned long base;
 
 		seg &= ~7UL;
@@ -33,12 +34,10 @@ unsigned long convert_ip_to_linear(struct task_struct *child, struct pt_regs *re
 			addr = -1L; /* bogus selector, access would fault */
 		else {
 			desc = child->mm->context.ldt + seg;
-			base = ((desc[0] >> 16) |
-				((desc[1] & 0xff) << 16) |
-				(desc[1] & 0xff000000));
+			base = get_desc_base(desc);
 
 			/* 16-bit code segment? */
-			if (!((desc[1] >> 22) & 1))
+			if (!desc->d)
 				addr &= 0xffff;
 			addr += base;
 		}
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 5204332..2367941 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -786,27 +786,6 @@ do_spurious_interrupt_bug(struct pt_regs *regs, long error_code)
 #endif
 }
 
-#ifdef CONFIG_X86_32
-unsigned long patch_espfix_desc(unsigned long uesp, unsigned long kesp)
-{
-	struct desc_struct *gdt = get_cpu_gdt_table(smp_processor_id());
-	unsigned long base = (kesp - uesp) & -THREAD_SIZE;
-	unsigned long new_kesp = kesp - base;
-	unsigned long lim_pages = (new_kesp | (THREAD_SIZE - 1)) >> PAGE_SHIFT;
-	__u64 desc = *(__u64 *)&gdt[GDT_ENTRY_ESPFIX_SS];
-
-	/* Set up base for espfix segment */
-	desc &= 0x00f0ff0000000000ULL;
-	desc |=	((((__u64)base) << 16) & 0x000000ffffff0000ULL) |
-		((((__u64)base) << 32) & 0xff00000000000000ULL) |
-		((((__u64)lim_pages) << 32) & 0x000f000000000000ULL) |
-		(lim_pages & 0xffff);
-	*(__u64 *)&gdt[GDT_ENTRY_ESPFIX_SS] = desc;
-
-	return new_kesp;
-}
-#endif
-
 asmlinkage void __attribute__((weak)) smp_thermal_interrupt(void)
 {
 }
diff --git a/drivers/pnp/pnpbios/bioscalls.c b/drivers/pnp/pnpbios/bioscalls.c
index 7e6b5a3..fc83783 100644
--- a/drivers/pnp/pnpbios/bioscalls.c
+++ b/drivers/pnp/pnpbios/bioscalls.c
@@ -55,12 +55,13 @@ __asm__(".text			\n"
 
 #define Q2_SET_SEL(cpu, selname, address, size) \
 do { \
-struct desc_struct *gdt = get_cpu_gdt_table((cpu)); \
-set_base(gdt[(selname) >> 3], (u32)(address)); \
-set_limit(gdt[(selname) >> 3], size); \
+	struct desc_struct *gdt = get_cpu_gdt_table((cpu)); \
+	set_desc_base(&gdt[(selname) >> 3], (u32)(address)); \
+	set_desc_limit(&gdt[(selname) >> 3], (size) - 1); \
 } while(0)
 
-static struct desc_struct bad_bios_desc;
+static struct desc_struct bad_bios_desc = GDT_ENTRY_INIT(0x4092,
+			(unsigned long)__va(0x400UL), PAGE_SIZE - 0x400 - 1);
 
 /*
  * At some point we want to use this stack frame pointer to unwind
@@ -476,19 +477,15 @@ void pnpbios_calls_init(union pnp_bios_install_struct *header)
 	pnp_bios_callpoint.offset = header->fields.pm16offset;
 	pnp_bios_callpoint.segment = PNP_CS16;
 
-	bad_bios_desc.a = 0;
-	bad_bios_desc.b = 0x00409200;
-
-	set_base(bad_bios_desc, __va((unsigned long)0x40 << 4));
-	_set_limit((char *)&bad_bios_desc, 4095 - (0x40 << 4));
 	for_each_possible_cpu(i) {
 		struct desc_struct *gdt = get_cpu_gdt_table(i);
 		if (!gdt)
 			continue;
-		set_base(gdt[GDT_ENTRY_PNPBIOS_CS32], &pnp_bios_callfunc);
-		set_base(gdt[GDT_ENTRY_PNPBIOS_CS16],
-			 __va(header->fields.pm16cseg));
-		set_base(gdt[GDT_ENTRY_PNPBIOS_DS],
-			 __va(header->fields.pm16dseg));
+		set_desc_base(&gdt[GDT_ENTRY_PNPBIOS_CS32],
+			 (unsigned long)&pnp_bios_callfunc);
+		set_desc_base(&gdt[GDT_ENTRY_PNPBIOS_CS16],
+			 (unsigned long)__va(header->fields.pm16cseg));
+		set_desc_base(&gdt[GDT_ENTRY_PNPBIOS_DS],
+			 (unsigned long)__va(header->fields.pm16dseg));
 	}
 }
diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index aa00800..90079c3 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -81,14 +81,17 @@ extern void setup_per_cpu_areas(void);
 
 #ifdef MODULE
 #define PER_CPU_SHARED_ALIGNED_SECTION ""
+#define PER_CPU_ALIGNED_SECTION ""
 #else
 #define PER_CPU_SHARED_ALIGNED_SECTION ".shared_aligned"
+#define PER_CPU_ALIGNED_SECTION ".shared_aligned"
 #endif
 #define PER_CPU_FIRST_SECTION ".first"
 
 #else
 
 #define PER_CPU_SHARED_ALIGNED_SECTION ""
+#define PER_CPU_ALIGNED_SECTION ".shared_aligned"
 #define PER_CPU_FIRST_SECTION ""
 
 #endif
diff --git a/include/linux/init.h b/include/linux/init.h
index 13b633e..400adbb 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -103,8 +103,8 @@
 #define __INIT		.section	".init.text","ax"
 #define __FINIT		.previous
 
-#define __INITDATA	.section	".init.data","aw"
-#define __INITRODATA	.section	".init.rodata","a"
+#define __INITDATA	.section	".init.data","aw",%progbits
+#define __INITRODATA	.section	".init.rodata","a",%progbits
 #define __FINITDATA	.previous
 
 #define __DEVINIT        .section	".devinit.text", "ax"
@@ -305,9 +305,17 @@ void __init parse_early_options(char *cmdline);
 #ifdef CONFIG_MODULES
 #define __init_or_module
 #define __initdata_or_module
+#define __initconst_or_module
+#define __INIT_OR_MODULE	.text
+#define __INITDATA_OR_MODULE	.data
+#define __INITRODATA_OR_MODULE	.section ".rodata","a",%progbits
 #else
 #define __init_or_module __init
 #define __initdata_or_module __initdata
+#define __initconst_or_module __initconst
+#define __INIT_OR_MODULE __INIT
+#define __INITDATA_OR_MODULE __INITDATA
+#define __INITRODATA_OR_MODULE __INITRODATA
 #endif /*CONFIG_MODULES*/
 
 /* Functions marked as __devexit may be discarded at kernel link time, depending
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 68438e1..3058cf9 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -66,6 +66,14 @@
 	DEFINE_PER_CPU_SECTION(type, name, PER_CPU_SHARED_ALIGNED_SECTION) \
 	____cacheline_aligned_in_smp
 
+#define DECLARE_PER_CPU_ALIGNED(type, name)				\
+	DECLARE_PER_CPU_SECTION(type, name, PER_CPU_ALIGNED_SECTION)	\
+	____cacheline_aligned
+
+#define DEFINE_PER_CPU_ALIGNED(type, name)				\
+	DEFINE_PER_CPU_SECTION(type, name, PER_CPU_ALIGNED_SECTION)	\
+	____cacheline_aligned
+
 /*
  * Declaration/definition used for per-CPU variables that must be page aligned.
  */
