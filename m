Return-Path: <linux-kernel-owner+w=401wt.eu-S936513AbZDJQer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936513AbZDJQer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 12:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934303AbZDJQe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 12:34:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:44166 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936330AbZDJQe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 12:34:26 -0400
Subject: [git-pull -tip] x86: declaration patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain
Date: Fri, 10 Apr 2009 22:03:04 +0530
Message-Id: <1239381184.23116.5.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

I have already send these patches for review to LKML.

Now here is pull request:
The following changes since commit 7fd61bdf06572f1ca681aa35f5c86531a821ea75:
  Ingo Molnar (1):
        Merge branch 'x86/urgent'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master

Jaswinder Singh Rajput (8):
      x86: irq.c declare smp_generic_interrupt before they get used
      x86: syscalls.h update declarations due to unifications
      x86: process.c declare sys_fork and sys_vfork before they get used
      x86: tsc.c rename tsc_khz shadow variable
      x86: apic/probe_32.c declare apic_default before they get used
      x86: apic/nmi.c prev_nmi_count should be unsigned
      x86: apic/io_apic.c declare smp_irq_move_cleanup_interrupt before they get used
      x86: mm/init.c declare direct_gbpages and free_initrd_mem before they get used

 arch/x86/include/asm/apic.h       |    3 ++
 arch/x86/include/asm/hw_irq.h     |   14 +++++++++++
 arch/x86/include/asm/pgtable.h    |    2 +
 arch/x86/include/asm/pgtable_64.h |    6 -----
 arch/x86/include/asm/syscalls.h   |   45 +++++++++++++++++++-----------------
 arch/x86/kernel/apic/io_apic.c    |    6 ++++-
 arch/x86/kernel/apic/nmi.c        |    2 +-
 arch/x86/kernel/apic/probe_32.c   |    1 -
 arch/x86/kernel/irq.c             |    4 +++
 arch/x86/kernel/process.c         |    1 +
 arch/x86/kernel/tsc.c             |    8 +++---
 arch/x86/mm/init.c                |    1 +
 12 files changed, 59 insertions(+), 34 deletions(-)

Complete diff:
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 42f2f83..5773660 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -478,6 +478,9 @@ static inline unsigned int read_apic_id(void)
 extern void default_setup_apic_routing(void);
 
 #ifdef CONFIG_X86_32
+
+extern struct apic apic_default;
+
 /*
  * Set up the logical destination ID.
  *
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 7309c0a..2f35e81 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -81,6 +81,11 @@ extern void eisa_set_level_irq(unsigned int irq);
 /* SMP */
 extern void smp_apic_timer_interrupt(struct pt_regs *);
 extern void smp_spurious_interrupt(struct pt_regs *);
+#ifdef CONFIG_X86_32
+extern void smp_generic_interrupt(struct pt_regs *);
+#else
+extern asmlinkage void smp_generic_interrupt(struct pt_regs *);
+#endif
 extern void smp_error_interrupt(struct pt_regs *);
 #ifdef CONFIG_SMP
 extern void smp_reschedule_interrupt(struct pt_regs *);
@@ -93,6 +98,15 @@ extern asmlinkage void smp_invalidate_interrupt(struct pt_regs *);
 #endif
 #endif
 
+#ifdef CONFIG_X86_IO_APIC
+#ifdef CONFIG_X86_32
+extern void smp_irq_move_cleanup_interrupt(void);
+#else
+extern asmlinkage void smp_irq_move_cleanup_interrupt(void);
+#endif
+#endif
+
+
 extern void (*__initconst interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
 
 typedef int vector_irq_t[NR_VECTORS];
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 205f6a9..577485b 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -510,6 +510,8 @@ static inline int pte_hidden(pte_t pte)
 
 #ifndef __ASSEMBLY__
 
+extern int direct_gbpages;
+
 /* local pte updates need not use xchg for locking */
 static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
 {
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index 6b87bc6..abde308 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -25,10 +25,6 @@ extern pgd_t init_level4_pgt[];
 
 extern void paging_init(void);
 
-#endif /* !__ASSEMBLY__ */
-
-#ifndef __ASSEMBLY__
-
 #define pte_ERROR(e)					\
 	printk("%s:%d: bad pte %p(%016lx).\n",		\
 	       __FILE__, __LINE__, &(e), pte_val(e))
@@ -135,8 +131,6 @@ static inline int pgd_large(pgd_t pgd) { return 0; }
 
 #define update_mmu_cache(vma, address, pte) do { } while (0)
 
-extern int direct_gbpages;
-
 /* Encode and de-code a swap entry */
 #if _PAGE_BIT_FILE < _PAGE_BIT_PROTNONE
 #define SWP_TYPE_BITS (_PAGE_BIT_FILE - _PAGE_BIT_PRESENT - 1)
diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 7043408..372b76e 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -1,7 +1,7 @@
 /*
  * syscalls.h - Linux syscall interfaces (arch-specific)
  *
- * Copyright (c) 2008 Jaswinder Singh
+ * Copyright (c) 2008 Jaswinder Singh Rajput
  *
  * This file is released under the GPLv2.
  * See the file COPYING for more details.
@@ -12,50 +12,55 @@
 
 #include <linux/compiler.h>
 #include <linux/linkage.h>
-#include <linux/types.h>
 #include <linux/signal.h>
+#include <linux/types.h>
 
 /* Common in X86_32 and X86_64 */
 /* kernel/ioport.c */
 asmlinkage long sys_ioperm(unsigned long, unsigned long, int);
 
+/* kernel/process.c */
+int sys_fork(struct pt_regs *);
+int sys_vfork(struct pt_regs *);
+
 /* kernel/ldt.c */
 asmlinkage int sys_modify_ldt(int, void __user *, unsigned long);
 
+/* kernel/signal.c */
+long sys_rt_sigreturn(struct pt_regs *);
+
 /* kernel/tls.c */
 asmlinkage int sys_set_thread_area(struct user_desc __user *);
 asmlinkage int sys_get_thread_area(struct user_desc __user *);
 
 /* X86_32 only */
 #ifdef CONFIG_X86_32
+/* kernel/ioport.c */
+long sys_iopl(struct pt_regs *);
+
 /* kernel/process_32.c */
-int sys_fork(struct pt_regs *);
 int sys_clone(struct pt_regs *);
-int sys_vfork(struct pt_regs *);
 int sys_execve(struct pt_regs *);
 
-/* kernel/signal_32.c */
+/* kernel/signal.c */
 asmlinkage int sys_sigsuspend(int, int, old_sigset_t);
 asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
 			     struct old_sigaction __user *);
 int sys_sigaltstack(struct pt_regs *);
 unsigned long sys_sigreturn(struct pt_regs *);
-long sys_rt_sigreturn(struct pt_regs *);
-
-/* kernel/ioport.c */
-long sys_iopl(struct pt_regs *);
 
 /* kernel/sys_i386_32.c */
+struct mmap_arg_struct;
+struct sel_arg_struct;
+struct oldold_utsname;
+struct old_utsname;
+
 asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
 			  unsigned long, unsigned long, unsigned long);
-struct mmap_arg_struct;
 asmlinkage int old_mmap(struct mmap_arg_struct __user *);
-struct sel_arg_struct;
 asmlinkage int old_select(struct sel_arg_struct __user *);
 asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
-struct old_utsname;
 asmlinkage int sys_uname(struct old_utsname __user *);
-struct oldold_utsname;
 asmlinkage int sys_olduname(struct oldold_utsname __user *);
 
 /* kernel/vm86_32.c */
@@ -65,29 +70,27 @@ int sys_vm86(struct pt_regs *);
 #else /* CONFIG_X86_32 */
 
 /* X86_64 only */
+/* kernel/ioport.c */
+asmlinkage long sys_iopl(unsigned int, struct pt_regs *);
+
 /* kernel/process_64.c */
-asmlinkage long sys_fork(struct pt_regs *);
 asmlinkage long sys_clone(unsigned long, unsigned long,
 			  void __user *, void __user *,
 			  struct pt_regs *);
-asmlinkage long sys_vfork(struct pt_regs *);
 asmlinkage long sys_execve(char __user *, char __user * __user *,
 			   char __user * __user *,
 			   struct pt_regs *);
 long sys_arch_prctl(int, unsigned long);
 
-/* kernel/ioport.c */
-asmlinkage long sys_iopl(unsigned int, struct pt_regs *);
-
-/* kernel/signal_64.c */
+/* kernel/signal.c */
 asmlinkage long sys_sigaltstack(const stack_t __user *, stack_t __user *,
 				struct pt_regs *);
-long sys_rt_sigreturn(struct pt_regs *);
 
 /* kernel/sys_x86_64.c */
+struct new_utsname;
+
 asmlinkage long sys_mmap(unsigned long, unsigned long, unsigned long,
 			 unsigned long, unsigned long, unsigned long);
-struct new_utsname;
 asmlinkage long sys_uname(struct new_utsname __user *);
 
 #endif /* CONFIG_X86_32 */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8499000..d1bac67 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -59,6 +59,7 @@
 #include <asm/setup.h>
 #include <asm/irq_remapping.h>
 #include <asm/hpet.h>
+#include <asm/hw_irq.h>		/* smp_irq_move_cleanup_interrupt */
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_irq.h>
 
@@ -2428,7 +2429,10 @@ static inline void set_ir_ioapic_affinity_irq_desc(struct irq_desc *desc,
 }
 #endif
 
-asmlinkage void smp_irq_move_cleanup_interrupt(void)
+#ifdef CONFIG_X86_64
+asmlinkage
+#endif
+void smp_irq_move_cleanup_interrupt(void)
 {
 	unsigned vector, me;
 
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index d6bd624..0205631 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -104,7 +104,7 @@ static __init void nmi_cpu_busy(void *data)
 }
 #endif
 
-static void report_broken_nmi(int cpu, int *prev_nmi_count)
+static void report_broken_nmi(int cpu, unsigned int *prev_nmi_count)
 {
 	printk(KERN_CONT "\n");
 
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 01eda2a..440a8bc 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -160,7 +160,6 @@ extern struct apic apic_summit;
 extern struct apic apic_bigsmp;
 extern struct apic apic_es7000;
 extern struct apic apic_es7000_cluster;
-extern struct apic apic_default;
 
 struct apic *apic = &apic_default;
 EXPORT_SYMBOL_GPL(apic);
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 9be593f..8370125 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -12,6 +12,7 @@
 #include <asm/io_apic.h>
 #include <asm/irq.h>
 #include <asm/idle.h>
+#include <asm/hw_irq.h>			/* smp_generic_interrupt */
 
 atomic_t irq_err_count;
 
@@ -242,6 +243,9 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 /*
  * Handler for GENERIC_INTERRUPT_VECTOR.
  */
+#ifdef CONFIG_X86_64
+asmlinkage
+#endif
 void smp_generic_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1d71442..4d397ce 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -15,6 +15,7 @@
 #include <asm/uaccess.h>
 #include <asm/i387.h>
 #include <asm/ds.h>
+#include <asm/syscalls.h>		/* sys_fork, sys_vfork */
 
 unsigned long idle_halt;
 EXPORT_SYMBOL(idle_halt);
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 7a567eb..a8dc0d0 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -384,13 +384,13 @@ unsigned long native_calibrate_tsc(void)
 {
 	u64 tsc1, tsc2, delta, ref1, ref2;
 	unsigned long tsc_pit_min = ULONG_MAX, tsc_ref_min = ULONG_MAX;
-	unsigned long flags, latch, ms, fast_calibrate, tsc_khz;
+	unsigned long flags, latch, ms, fast_calibrate, hv_tsc_khz;
 	int hpet = is_hpet_enabled(), i, loopmin;
 
-	tsc_khz = get_hypervisor_tsc_freq();
-	if (tsc_khz) {
+	hv_tsc_khz = get_hypervisor_tsc_freq();
+	if (hv_tsc_khz) {
 		printk(KERN_INFO "TSC: Frequency read from the hypervisor\n");
-		return tsc_khz;
+		return hv_tsc_khz;
 	}
 
 	local_irq_save(flags);
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 51ae5ea..688c008 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -1,3 +1,4 @@
+#include <linux/initrd.h>	/* free_initrd_mem */
 #include <linux/ioport.h>
 #include <linux/swap.h>
 


