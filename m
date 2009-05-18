Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbZEROjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbZEROjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 10:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbZEROjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 10:39:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39842 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467AbZEROja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 10:39:30 -0400
Date: Mon, 18 May 2009 16:38:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] x86 fixes
Message-ID: <20090518143847.GA26834@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

The Kconfig change comes from separating the paravirt-spinlocks 
feature out of CONFIG_PARAVIRT and turning it off by default. (i was 
tempted to mark it broken as well, but lets give it some time to get 
fixed.)

 Thanks,

	Ingo

------------------>
Jan Beulich (1):
      x86: fix percpu_{to,from}_op()

Jeremy Fitzhardinge (1):
      x86: Fix performance regression caused by paravirt_ops on native kernels

Masami Hiramatsu (1):
      x86, 32-bit: fix kernel_trap_sp()

Randy Dunlap (1):
      xen: use header for EXPORT_SYMBOL_GPL

Sam Ravnborg (1):
      x86: Fix false positive section mismatch warnings in the apic code

Yinghai Lu (1):
      x86: mtrr: Fix high_width computation when phys-addr is >= 44bit


 arch/x86/Kconfig                   |   13 +++++++++++++
 arch/x86/include/asm/paravirt.h    |    2 +-
 arch/x86/include/asm/percpu.h      |   10 +++++-----
 arch/x86/include/asm/ptrace.h      |    7 ++++---
 arch/x86/include/asm/spinlock.h    |    4 ++--
 arch/x86/kernel/Makefile           |    3 ++-
 arch/x86/kernel/apic/es7000_32.c   |    8 ++++----
 arch/x86/kernel/cpu/mtrr/generic.c |    6 +++++-
 arch/x86/kernel/paravirt.c         |    2 ++
 arch/x86/oprofile/backtrace.c      |    2 +-
 arch/x86/xen/Makefile              |    5 +++--
 arch/x86/xen/mmu.c                 |    1 +
 arch/x86/xen/xen-ops.h             |   19 +++++++++++++++----
 13 files changed, 58 insertions(+), 24 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index df9e885..a6efe0a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -498,6 +498,19 @@ config PARAVIRT
 	  over full virtualization.  However, when run without a hypervisor
 	  the kernel is theoretically slower and slightly larger.
 
+config PARAVIRT_SPINLOCKS
+	bool "Paravirtualization layer for spinlocks"
+	depends on PARAVIRT && SMP && EXPERIMENTAL
+	---help---
+	  Paravirtualized spinlocks allow a pvops backend to replace the
+	  spinlock implementation with something virtualization-friendly
+	  (for example, block the virtual CPU rather than spinning).
+
+	  Unfortunately the downside is an up to 5% performance hit on
+	  native kernels, with various workloads.
+
+	  If you are unsure how to answer this question, answer N.
+
 config PARAVIRT_CLOCK
 	bool
 	default n
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 378e369..a53da00 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -1443,7 +1443,7 @@ u64 _paravirt_ident_64(u64);
 
 #define paravirt_nop	((void *)_paravirt_nop)
 
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SMP) && defined(CONFIG_PARAVIRT_SPINLOCKS)
 
 static inline int __raw_spin_is_locked(struct raw_spinlock *lock)
 {
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index aee103b..02ecb30 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -82,22 +82,22 @@ do {							\
 	case 1:						\
 		asm(op "b %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
-		    : "ri" ((T__)val));			\
+		    : "qi" ((T__)(val)));		\
 		break;					\
 	case 2:						\
 		asm(op "w %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
-		    : "ri" ((T__)val));			\
+		    : "ri" ((T__)(val)));		\
 		break;					\
 	case 4:						\
 		asm(op "l %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
-		    : "ri" ((T__)val));			\
+		    : "ri" ((T__)(val)));		\
 		break;					\
 	case 8:						\
 		asm(op "q %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
-		    : "re" ((T__)val));			\
+		    : "re" ((T__)(val)));		\
 		break;					\
 	default: __bad_percpu_size();			\
 	}						\
@@ -109,7 +109,7 @@ do {							\
 	switch (sizeof(var)) {				\
 	case 1:						\
 		asm(op "b "__percpu_arg(1)",%0"		\
-		    : "=r" (ret__)			\
+		    : "=q" (ret__)			\
 		    : "m" (var));			\
 		break;					\
 	case 2:						\
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index e304b66..624f133 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -187,14 +187,15 @@ static inline int v8086_mode(struct pt_regs *regs)
 
 /*
  * X86_32 CPUs don't save ss and esp if the CPU is already in kernel mode
- * when it traps.  So regs will be the current sp.
+ * when it traps.  The previous stack will be directly underneath the saved
+ * registers, and 'sp/ss' won't even have been saved. Thus the '&regs->sp'.
  *
  * This is valid only for kernel mode traps.
  */
-static inline unsigned long kernel_trap_sp(struct pt_regs *regs)
+static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
 {
 #ifdef CONFIG_X86_32
-	return (unsigned long)regs;
+	return (unsigned long)(&regs->sp);
 #else
 	return regs->sp;
 #endif
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index e5e6caf..b7e5db8 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -172,7 +172,7 @@ static inline int __ticket_spin_is_contended(raw_spinlock_t *lock)
 	return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) > 1;
 }
 
-#ifndef CONFIG_PARAVIRT
+#ifndef CONFIG_PARAVIRT_SPINLOCKS
 
 static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
 {
@@ -206,7 +206,7 @@ static __always_inline void __raw_spin_lock_flags(raw_spinlock_t *lock,
 	__raw_spin_lock(lock);
 }
 
-#endif
+#endif	/* CONFIG_PARAVIRT_SPINLOCKS */
 
 static inline void __raw_spin_unlock_wait(raw_spinlock_t *lock)
 {
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 145cce7..88d1bfc 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -89,7 +89,8 @@ obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o
 obj-$(CONFIG_KVM_CLOCK)		+= kvmclock.o
-obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o paravirt-spinlocks.o
+obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
+obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= paravirt-spinlocks.o
 obj-$(CONFIG_PARAVIRT_CLOCK)	+= pvclock.o
 
 obj-$(CONFIG_PCSPKR_PLATFORM)	+= pcspeaker.o
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 1c11b81..3029477 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -254,7 +254,7 @@ static int parse_unisys_oem(char *oemptr)
 }
 
 #ifdef CONFIG_ACPI
-static int find_unisys_acpi_oem_table(unsigned long *oem_addr)
+static int __init find_unisys_acpi_oem_table(unsigned long *oem_addr)
 {
 	struct acpi_table_header *header = NULL;
 	struct es7000_oem_table *table;
@@ -285,7 +285,7 @@ static int find_unisys_acpi_oem_table(unsigned long *oem_addr)
 	return 0;
 }
 
-static void unmap_unisys_acpi_oem_table(unsigned long oem_addr)
+static void __init unmap_unisys_acpi_oem_table(unsigned long oem_addr)
 {
 	if (!oem_addr)
 		return;
@@ -306,7 +306,7 @@ static int es7000_check_dsdt(void)
 static int es7000_acpi_ret;
 
 /* Hook from generic ACPI tables.c */
-static int es7000_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int __init es7000_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	unsigned long oem_addr = 0;
 	int check_dsdt;
@@ -717,7 +717,7 @@ struct apic apic_es7000_cluster = {
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 };
 
-struct apic apic_es7000 = {
+struct apic __refdata apic_es7000 = {
 
 	.name				= "es7000",
 	.probe				= probe_es7000,
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 0b776c0..d21d4fb 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -275,7 +275,11 @@ static void __init print_mtrr_state(void)
 	}
 	printk(KERN_DEBUG "MTRR variable ranges %sabled:\n",
 	       mtrr_state.enabled & 2 ? "en" : "dis");
-	high_width = ((size_or_mask ? ffs(size_or_mask) - 1 : 32) - (32 - PAGE_SHIFT) + 3) / 4;
+	if (size_or_mask & 0xffffffffUL)
+		high_width = ffs(size_or_mask & 0xffffffffUL) - 1;
+	else
+		high_width = ffs(size_or_mask>>32) + 32 - 1;
+	high_width = (high_width - (32 - PAGE_SHIFT) + 3) / 4;
 	for (i = 0; i < num_var_ranges; ++i) {
 		if (mtrr_state.var_ranges[i].mask_lo & (1 << 11))
 			printk(KERN_DEBUG "  %u base %0*X%05X000 mask %0*X%05X000 %s\n",
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 8e45f44..9faf43b 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -134,7 +134,9 @@ static void *get_call_destination(u8 type)
 		.pv_irq_ops = pv_irq_ops,
 		.pv_apic_ops = pv_apic_ops,
 		.pv_mmu_ops = pv_mmu_ops,
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
 		.pv_lock_ops = pv_lock_ops,
+#endif
 	};
 	return *((void **)&tmpl + type);
 }
diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index 04df67f..044897b 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -76,9 +76,9 @@ void
 x86_backtrace(struct pt_regs * const regs, unsigned int depth)
 {
 	struct frame_head *head = (struct frame_head *)frame_pointer(regs);
-	unsigned long stack = kernel_trap_sp(regs);
 
 	if (!user_mode_vm(regs)) {
+		unsigned long stack = kernel_stack_pointer(regs);
 		if (depth)
 			dump_trace(NULL, regs, (unsigned long *)stack, 0,
 				   &backtrace_ops, &depth);
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 3b767d0..172438f 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -9,5 +9,6 @@ obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 			time.o xen-asm.o xen-asm_$(BITS).o \
 			grant-table.o suspend.o
 
-obj-$(CONFIG_SMP)		+= smp.o spinlock.o
-obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
\ No newline at end of file
+obj-$(CONFIG_SMP)		+= smp.o
+obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
+obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index e25a78e..fba55b1 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -42,6 +42,7 @@
 #include <linux/highmem.h>
 #include <linux/debugfs.h>
 #include <linux/bug.h>
+#include <linux/module.h>
 
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 2013946..ca6596b 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -62,15 +62,26 @@ void xen_setup_vcpu_info_placement(void);
 #ifdef CONFIG_SMP
 void xen_smp_init(void);
 
-void __init xen_init_spinlocks(void);
-__cpuinit void xen_init_lock_cpu(int cpu);
-void xen_uninit_lock_cpu(int cpu);
-
 extern cpumask_var_t xen_cpu_initialized_map;
 #else
 static inline void xen_smp_init(void) {}
 #endif
 
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+void __init xen_init_spinlocks(void);
+__cpuinit void xen_init_lock_cpu(int cpu);
+void xen_uninit_lock_cpu(int cpu);
+#else
+static inline void xen_init_spinlocks(void)
+{
+}
+static inline void xen_init_lock_cpu(int cpu)
+{
+}
+static inline void xen_uninit_lock_cpu(int cpu)
+{
+}
+#endif
 
 /* Declare an asm function, along with symbols needed to make it
    inlineable */
