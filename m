Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbZBKOcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbZBKOcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:32:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756442AbZBKObv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:31:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53719 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756971AbZBKObr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:31:47 -0500
Date: Wed, 11 Feb 2009 15:31:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20090211143132.GA2414@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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

out-of-topic modifications in x86/urgent:
-----------------------------------------
drivers/pci/intel-iommu.c          # 0cd5c3c: x86: disable intel_iommu support 
kernel/fork.c                      # 06eb23b: ptrace, x86: fix the usage of ptr

 Thanks,

	Ingo

------------------>
Alex Chiang (1):
      x86: fix grammar in user-visible BIOS warning

Alok Kataria (1):
      x86, vmi: put a missing paravirt_release_pmd in pgd_dtor

Borislav Petkov (1):
      x86/Kconfig.cpu: make Kconfig help readable in the console

Clemens Ladisch (1):
      i8327: fix outb() parameter order

Jeremy Fitzhardinge (1):
      x86: don't apply __supported_pte_mask to non-present ptes

Kyle McMartin (2):
      x86, 64-bit: print DMI info in the oops trace
      x86: disable intel_iommu support by default

Oleg Nesterov (1):
      ptrace, x86: fix the usage of ptrace_fork()

Pallipadi, Venkatesh (1):
      x86: add clflush before monitor for Intel 7400 series

Tejun Heo (3):
      x86: include correct %gs in a.out core dump
      x86: math_emu info cleanup
      x86: fix math_emu register frame access

Yinghai Lu (1):
      x86: find nr_irqs_gsi with mp_ioapic_routing


 Documentation/kernel-parameters.txt |    2 +
 arch/x86/Kconfig                    |   11 ++++++
 arch/x86/Kconfig.cpu                |   30 ++++++++-------
 arch/x86/include/asm/a.out-core.h   |    4 +--
 arch/x86/include/asm/cpufeature.h   |    1 +
 arch/x86/include/asm/math_emu.h     |   29 ++++-----------
 arch/x86/include/asm/mpspec.h       |    6 +++
 arch/x86/include/asm/pgtable.h      |   26 ++++++++++---
 arch/x86/include/asm/processor.h    |    2 +-
 arch/x86/include/asm/traps.h        |    4 +-
 arch/x86/include/asm/xen/page.h     |    2 +-
 arch/x86/kernel/acpi/boot.c         |   23 ++++++++++++
 arch/x86/kernel/cpu/intel.c         |    3 ++
 arch/x86/kernel/i8237.c             |   17 ++++-----
 arch/x86/kernel/io_apic.c           |   20 ++++++++---
 arch/x86/kernel/process.c           |    6 +++
 arch/x86/kernel/process_64.c        |    9 ++++-
 arch/x86/kernel/setup.c             |    2 +-
 arch/x86/kernel/traps.c             |   15 +++++---
 arch/x86/kernel/vmi_32.c            |   11 ++++++
 arch/x86/math-emu/fpu_entry.c       |    6 ++--
 arch/x86/math-emu/fpu_proto.h       |    4 +-
 arch/x86/math-emu/fpu_system.h      |   16 +++-----
 arch/x86/math-emu/get_address.c     |   69 +++++++++++++++++------------------
 drivers/pci/intel-iommu.c           |   14 ++++++--
 kernel/fork.c                       |    2 +-
 26 files changed, 208 insertions(+), 126 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index d8362cf..b182626 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -937,6 +937,8 @@ and is between 256 and 4096 characters. It is defined in the file
 
 
 	intel_iommu=	[DMAR] Intel IOMMU driver (DMAR) option
+		on
+			Enable intel iommu driver.
 		off
 			Disable intel iommu driver.
 		igfx_off [Default Off]
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 73f7fe8..9c39095 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1802,6 +1802,17 @@ config DMAR
 	  and include PCI device scope covered by these DMA
 	  remapping devices.
 
+config DMAR_DEFAULT_ON
+	def_bool n
+	prompt "Enable DMA Remapping Devices by default"
+	depends on DMAR
+	help
+	  Selecting this option will enable a DMAR device at boot time if
+	  one is found. If this option is not selected, DMAR support can
+	  be enabled by passing intel_iommu=on to the kernel. It is
+	  recommended you say N here while the DMAR code remains
+	  experimental.
+
 config DMAR_GFX_WA
 	def_bool y
 	prompt "Support for Graphics workaround"
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 8078955..c98d52e 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -167,9 +167,9 @@ config MK7
 config MK8
 	bool "Opteron/Athlon64/Hammer/K8"
 	help
-	  Select this for an AMD Opteron or Athlon64 Hammer-family processor.  Enables
-	  use of some extended instructions, and passes appropriate optimization
-	  flags to GCC.
+	  Select this for an AMD Opteron or Athlon64 Hammer-family processor.
+	  Enables use of some extended instructions, and passes appropriate
+	  optimization flags to GCC.
 
 config MCRUSOE
 	bool "Crusoe"
@@ -256,9 +256,11 @@ config MPSC
 config MCORE2
 	bool "Core 2/newer Xeon"
 	help
-	  Select this for Intel Core 2 and newer Core 2 Xeons (Xeon 51xx and 53xx)
-	  CPUs. You can distinguish newer from older Xeons by the CPU family
-	  in /proc/cpuinfo. Newer ones have 6 and older ones 15 (not a typo)
+
+	  Select this for Intel Core 2 and newer Core 2 Xeons (Xeon 51xx and
+	  53xx) CPUs. You can distinguish newer from older Xeons by the CPU
+	  family in /proc/cpuinfo. Newer ones have 6 and older ones 15
+	  (not a typo)
 
 config GENERIC_CPU
 	bool "Generic-x86-64"
@@ -320,14 +322,14 @@ config X86_PPRO_FENCE
 	bool "PentiumPro memory ordering errata workaround"
 	depends on M686 || M586MMX || M586TSC || M586 || M486 || M386 || MGEODEGX1
 	help
-	  Old PentiumPro multiprocessor systems had errata that could cause memory
-	  operations to violate the x86 ordering standard in rare cases. Enabling this
-	  option will attempt to work around some (but not all) occurances of
-	  this problem, at the cost of much heavier spinlock and memory barrier
-	  operations.
+	  Old PentiumPro multiprocessor systems had errata that could cause
+	  memory operations to violate the x86 ordering standard in rare cases.
+	  Enabling this option will attempt to work around some (but not all)
+	  occurances of this problem, at the cost of much heavier spinlock and
+	  memory barrier operations.
 
-	  If unsure, say n here. Even distro kernels should think twice before enabling
-	  this: there are few systems, and an unlikely bug.
+	  If unsure, say n here. Even distro kernels should think twice before
+	  enabling this: there are few systems, and an unlikely bug.
 
 config X86_F00F_BUG
 	def_bool y
diff --git a/arch/x86/include/asm/a.out-core.h b/arch/x86/include/asm/a.out-core.h
index 3782220..3c601f8 100644
--- a/arch/x86/include/asm/a.out-core.h
+++ b/arch/x86/include/asm/a.out-core.h
@@ -23,8 +23,6 @@
  */
 static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
 {
-	u16 gs;
-
 /* changed the size calculations - should hopefully work better. lbt */
 	dump->magic = CMAGIC;
 	dump->start_code = 0;
@@ -57,7 +55,7 @@ static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
 	dump->regs.ds = (u16)regs->ds;
 	dump->regs.es = (u16)regs->es;
 	dump->regs.fs = (u16)regs->fs;
-	savesegment(gs, gs);
+	savesegment(gs, dump->regs.gs);
 	dump->regs.orig_ax = regs->orig_ax;
 	dump->regs.ip = regs->ip;
 	dump->regs.cs = (u16)regs->cs;
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index ea408dc..7301e60 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -93,6 +93,7 @@
 #define X86_FEATURE_XTOPOLOGY	(3*32+22) /* cpu topology enum extensions */
 #define X86_FEATURE_TSC_RELIABLE (3*32+23) /* TSC is known to be reliable */
 #define X86_FEATURE_NONSTOP_TSC	(3*32+24) /* TSC does not stop in C states */
+#define X86_FEATURE_CLFLUSH_MONITOR (3*32+25) /* "" clflush reqd with monitor */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
diff --git a/arch/x86/include/asm/math_emu.h b/arch/x86/include/asm/math_emu.h
index 5a65b10..031f626 100644
--- a/arch/x86/include/asm/math_emu.h
+++ b/arch/x86/include/asm/math_emu.h
@@ -1,31 +1,18 @@
 #ifndef _ASM_X86_MATH_EMU_H
 #define _ASM_X86_MATH_EMU_H
 
+#include <asm/ptrace.h>
+#include <asm/vm86.h>
+
 /* This structure matches the layout of the data saved to the stack
    following a device-not-present interrupt, part of it saved
    automatically by the 80386/80486.
    */
-struct info {
+struct math_emu_info {
 	long ___orig_eip;
-	long ___ebx;
-	long ___ecx;
-	long ___edx;
-	long ___esi;
-	long ___edi;
-	long ___ebp;
-	long ___eax;
-	long ___ds;
-	long ___es;
-	long ___fs;
-	long ___orig_eax;
-	long ___eip;
-	long ___cs;
-	long ___eflags;
-	long ___esp;
-	long ___ss;
-	long ___vm86_es; /* This and the following only in vm86 mode */
-	long ___vm86_ds;
-	long ___vm86_fs;
-	long ___vm86_gs;
+	union {
+		struct pt_regs *regs;
+		struct kernel_vm86_regs *vm86;
+	};
 };
 #endif /* _ASM_X86_MATH_EMU_H */
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 62d14ce..bd22f2a 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -60,6 +60,7 @@ extern void mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
 				   u32 gsi);
 extern void mp_config_acpi_legacy_irqs(void);
 extern int mp_register_gsi(u32 gsi, int edge_level, int active_high_low);
+extern int acpi_probe_gsi(void);
 #ifdef CONFIG_X86_IO_APIC
 extern int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
 				u32 gsi, int triggering, int polarity);
@@ -71,6 +72,11 @@ mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
 	return 0;
 }
 #endif
+#else /* !CONFIG_ACPI: */
+static inline int acpi_probe_gsi(void)
+{
+	return 0;
+}
 #endif /* CONFIG_ACPI */
 
 #define PHYSID_ARRAY_SIZE	BITS_TO_LONGS(MAX_APICS)
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 06bbcbd..4f5af84 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -302,16 +302,30 @@ static inline pte_t pte_mkspecial(pte_t pte)
 
 extern pteval_t __supported_pte_mask;
 
+/*
+ * Mask out unsupported bits in a present pgprot.  Non-present pgprots
+ * can use those bits for other purposes, so leave them be.
+ */
+static inline pgprotval_t massage_pgprot(pgprot_t pgprot)
+{
+	pgprotval_t protval = pgprot_val(pgprot);
+
+	if (protval & _PAGE_PRESENT)
+		protval &= __supported_pte_mask;
+
+	return protval;
+}
+
 static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
 {
-	return __pte((((phys_addr_t)page_nr << PAGE_SHIFT) |
-		      pgprot_val(pgprot)) & __supported_pte_mask);
+	return __pte(((phys_addr_t)page_nr << PAGE_SHIFT) |
+		     massage_pgprot(pgprot));
 }
 
 static inline pmd_t pfn_pmd(unsigned long page_nr, pgprot_t pgprot)
 {
-	return __pmd((((phys_addr_t)page_nr << PAGE_SHIFT) |
-		      pgprot_val(pgprot)) & __supported_pte_mask);
+	return __pmd(((phys_addr_t)page_nr << PAGE_SHIFT) |
+		     massage_pgprot(pgprot));
 }
 
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
@@ -323,7 +337,7 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 	 * the newprot (if present):
 	 */
 	val &= _PAGE_CHG_MASK;
-	val |= pgprot_val(newprot) & (~_PAGE_CHG_MASK) & __supported_pte_mask;
+	val |= massage_pgprot(newprot) & ~_PAGE_CHG_MASK;
 
 	return __pte(val);
 }
@@ -339,7 +353,7 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
 
 #define pte_pgprot(x) __pgprot(pte_flags(x) & PTE_FLAGS_MASK)
 
-#define canon_pgprot(p) __pgprot(pgprot_val(p) & __supported_pte_mask)
+#define canon_pgprot(p) __pgprot(massage_pgprot(p))
 
 static inline int is_new_memtype_allowed(unsigned long flags,
 						unsigned long new_flags)
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 091cd88..3bfd523 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -353,7 +353,7 @@ struct i387_soft_struct {
 	u8			no_update;
 	u8			rm;
 	u8			alimit;
-	struct info		*info;
+	struct math_emu_info	*info;
 	u32			entry_eip;
 };
 
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 2ee0a3b..cf3bb05 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -41,7 +41,7 @@ dotraplinkage void do_int3(struct pt_regs *, long);
 dotraplinkage void do_overflow(struct pt_regs *, long);
 dotraplinkage void do_bounds(struct pt_regs *, long);
 dotraplinkage void do_invalid_op(struct pt_regs *, long);
-dotraplinkage void do_device_not_available(struct pt_regs *, long);
+dotraplinkage void do_device_not_available(struct pt_regs);
 dotraplinkage void do_coprocessor_segment_overrun(struct pt_regs *, long);
 dotraplinkage void do_invalid_TSS(struct pt_regs *, long);
 dotraplinkage void do_segment_not_present(struct pt_regs *, long);
@@ -77,7 +77,7 @@ extern int panic_on_unrecovered_nmi;
 extern int kstack_depth_to_print;
 
 void math_error(void __user *);
-asmlinkage void math_emulate(long);
+void math_emulate(struct math_emu_info *);
 #ifdef CONFIG_X86_32
 unsigned long patch_espfix_desc(unsigned long, unsigned long);
 #else
diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 7ef617e..4bd990e 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -137,7 +137,7 @@ static inline pte_t mfn_pte(unsigned long page_nr, pgprot_t pgprot)
 	pte_t pte;
 
 	pte.pte = ((phys_addr_t)page_nr << PAGE_SHIFT) |
-		(pgprot_val(pgprot) & __supported_pte_mask);
+			massage_pgprot(pgprot);
 
 	return pte;
 }
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index d37593c..7678f10 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -973,6 +973,29 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	nr_ioapics++;
 }
 
+int __init acpi_probe_gsi(void)
+{
+	int idx;
+	int gsi;
+	int max_gsi = 0;
+
+	if (acpi_disabled)
+		return 0;
+
+	if (!acpi_ioapic)
+		return 0;
+
+	max_gsi = 0;
+	for (idx = 0; idx < nr_ioapics; idx++) {
+		gsi = mp_ioapic_routing[idx].gsi_end;
+
+		if (gsi > max_gsi)
+			max_gsi = gsi;
+	}
+
+	return max_gsi + 1;
+}
+
 static void assign_to_mp_irq(struct mp_config_intsrc *m,
 				    struct mp_config_intsrc *mp_irq)
 {
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 430e5c3..24ff26a 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -291,6 +291,9 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 		ds_init_intel(c);
 	}
 
+	if (c->x86 == 6 && c->x86_model == 29 && cpu_has_clflush)
+		set_cpu_cap(c, X86_FEATURE_CLFLUSH_MONITOR);
+
 #ifdef CONFIG_X86_64
 	if (c->x86 == 15)
 		c->x86_cache_alignment = c->x86_clflush_size * 2;
diff --git a/arch/x86/kernel/i8237.c b/arch/x86/kernel/i8237.c
index dbd6c1d..b42ca69 100644
--- a/arch/x86/kernel/i8237.c
+++ b/arch/x86/kernel/i8237.c
@@ -28,10 +28,10 @@ static int i8237A_resume(struct sys_device *dev)
 
 	flags = claim_dma_lock();
 
-	dma_outb(DMA1_RESET_REG, 0);
-	dma_outb(DMA2_RESET_REG, 0);
+	dma_outb(0, DMA1_RESET_REG);
+	dma_outb(0, DMA2_RESET_REG);
 
-	for (i = 0;i < 8;i++) {
+	for (i = 0; i < 8; i++) {
 		set_dma_addr(i, 0x000000);
 		/* DMA count is a bit weird so this is not 0 */
 		set_dma_count(i, 1);
@@ -51,14 +51,14 @@ static int i8237A_suspend(struct sys_device *dev, pm_message_t state)
 }
 
 static struct sysdev_class i8237_sysdev_class = {
-	.name = "i8237",
-	.suspend = i8237A_suspend,
-	.resume = i8237A_resume,
+	.name		= "i8237",
+	.suspend	= i8237A_suspend,
+	.resume		= i8237A_resume,
 };
 
 static struct sys_device device_i8237A = {
-	.id	= 0,
-	.cls	= &i8237_sysdev_class,
+	.id		= 0,
+	.cls		= &i8237_sysdev_class,
 };
 
 static int __init i8237A_init_sysfs(void)
@@ -68,5 +68,4 @@ static int __init i8237A_init_sysfs(void)
 		error = sysdev_register(&device_i8237A);
 	return error;
 }
-
 device_initcall(i8237A_init_sysfs);
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 9b0c480..bc7ac4d 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -3841,14 +3841,24 @@ int __init io_apic_get_redir_entries (int ioapic)
 
 void __init probe_nr_irqs_gsi(void)
 {
-	int idx;
 	int nr = 0;
 
-	for (idx = 0; idx < nr_ioapics; idx++)
-		nr += io_apic_get_redir_entries(idx) + 1;
-
-	if (nr > nr_irqs_gsi)
+	nr = acpi_probe_gsi();
+	if (nr > nr_irqs_gsi) {
 		nr_irqs_gsi = nr;
+	} else {
+		/* for acpi=off or acpi is not compiled in */
+		int idx;
+
+		nr = 0;
+		for (idx = 0; idx < nr_ioapics; idx++)
+			nr += io_apic_get_redir_entries(idx) + 1;
+
+		if (nr > nr_irqs_gsi)
+			nr_irqs_gsi = nr;
+	}
+
+	printk(KERN_DEBUG "nr_irqs_gsi: %d\n", nr_irqs_gsi);
 }
 
 /* --------------------------------------------------------------------------
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e68bb9e..6d12f7e 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -180,6 +180,9 @@ void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 
 	trace_power_start(&it, POWER_CSTATE, (ax>>4)+1);
 	if (!need_resched()) {
+		if (cpu_has(&current_cpu_data, X86_FEATURE_CLFLUSH_MONITOR))
+			clflush((void *)&current_thread_info()->flags);
+
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
 		if (!need_resched())
@@ -194,6 +197,9 @@ static void mwait_idle(void)
 	struct power_trace it;
 	if (!need_resched()) {
 		trace_power_start(&it, POWER_CSTATE, 1);
+		if (cpu_has(&current_cpu_data, X86_FEATURE_CLFLUSH_MONITOR))
+			clflush((void *)&current_thread_info()->flags);
+
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
 		if (!need_resched())
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 416fb92..85b4cb5 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -40,6 +40,7 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/ftrace.h>
+#include <linux/dmi.h>
 
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -151,14 +152,18 @@ void __show_regs(struct pt_regs *regs, int all)
 	unsigned long d0, d1, d2, d3, d6, d7;
 	unsigned int fsindex, gsindex;
 	unsigned int ds, cs, es;
+	const char *board;
 
 	printk("\n");
 	print_modules();
-	printk(KERN_INFO "Pid: %d, comm: %.20s %s %s %.*s\n",
+	board = dmi_get_system_info(DMI_PRODUCT_NAME);
+	if (!board)
+		board = "";
+	printk(KERN_INFO "Pid: %d, comm: %.20s %s %s %.*s %s\n",
 		current->pid, current->comm, print_tainted(),
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
+		init_utsname()->version, board);
 	printk(KERN_INFO "RIP: %04lx:[<%016lx>] ", regs->cs & 0xffff, regs->ip);
 	printk_address(regs->ip, 1);
 	printk(KERN_INFO "RSP: %04lx:%016lx  EFLAGS: %08lx\n", regs->ss,
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ae0d804..c461f6d 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -607,7 +607,7 @@ struct x86_quirks *x86_quirks __initdata = &default_x86_quirks;
 static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE
-		"%s detected: BIOS may corrupt low RAM, working it around.\n",
+		"%s detected: BIOS may corrupt low RAM, working around it.\n",
 		d->ident);
 
 	e820_update_range(0, 0x10000, E820_RAM, E820_RESERVED);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 98c2d05..7932338 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -896,7 +896,7 @@ asmlinkage void math_state_restore(void)
 EXPORT_SYMBOL_GPL(math_state_restore);
 
 #ifndef CONFIG_MATH_EMULATION
-asmlinkage void math_emulate(long arg)
+void math_emulate(struct math_emu_info *info)
 {
 	printk(KERN_EMERG
 		"math-emulation not enabled and no coprocessor found.\n");
@@ -906,16 +906,19 @@ asmlinkage void math_emulate(long arg)
 }
 #endif /* CONFIG_MATH_EMULATION */
 
-dotraplinkage void __kprobes
-do_device_not_available(struct pt_regs *regs, long error)
+dotraplinkage void __kprobes do_device_not_available(struct pt_regs regs)
 {
 #ifdef CONFIG_X86_32
 	if (read_cr0() & X86_CR0_EM) {
-		conditional_sti(regs);
-		math_emulate(0);
+		struct math_emu_info info = { };
+
+		conditional_sti(&regs);
+
+		info.regs = &regs;
+		math_emulate(&info);
 	} else {
 		math_state_restore(); /* interrupts still off */
-		conditional_sti(regs);
+		conditional_sti(&regs);
 	}
 #else
 	math_state_restore();
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 1d3302c..bef58b4 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -321,6 +321,16 @@ static void vmi_release_pmd(unsigned long pfn)
 }
 
 /*
+ * We use the pgd_free hook for releasing the pgd page:
+ */
+static void vmi_pgd_free(struct mm_struct *mm, pgd_t *pgd)
+{
+	unsigned long pfn = __pa(pgd) >> PAGE_SHIFT;
+
+	vmi_ops.release_page(pfn, VMI_PAGE_L2);
+}
+
+/*
  * Helper macros for MMU update flags.  We can defer updates until a flush
  * or page invalidation only if the update is to the current address space
  * (otherwise, there is no flush).  We must check against init_mm, since
@@ -762,6 +772,7 @@ static inline int __init activate_vmi(void)
 	if (vmi_ops.release_page) {
 		pv_mmu_ops.release_pte = vmi_release_pte;
 		pv_mmu_ops.release_pmd = vmi_release_pmd;
+		pv_mmu_ops.pgd_free = vmi_pgd_free;
 	}
 
 	/* Set linear is needed in all cases */
diff --git a/arch/x86/math-emu/fpu_entry.c b/arch/x86/math-emu/fpu_entry.c
index c7b06fe..5d87f58 100644
--- a/arch/x86/math-emu/fpu_entry.c
+++ b/arch/x86/math-emu/fpu_entry.c
@@ -131,7 +131,7 @@ u_char emulating = 0;
 static int valid_prefix(u_char *Byte, u_char __user ** fpu_eip,
 			overrides * override);
 
-asmlinkage void math_emulate(long arg)
+void math_emulate(struct math_emu_info *info)
 {
 	u_char FPU_modrm, byte1;
 	unsigned short code;
@@ -161,7 +161,7 @@ asmlinkage void math_emulate(long arg)
 	RE_ENTRANT_CHECK_ON;
 #endif /* RE_ENTRANT_CHECKING */
 
-	SETUP_DATA_AREA(arg);
+	FPU_info = info;
 
 	FPU_ORIG_EIP = FPU_EIP;
 
@@ -659,7 +659,7 @@ static int valid_prefix(u_char *Byte, u_char __user **fpu_eip,
 	}
 }
 
-void math_abort(struct info *info, unsigned int signal)
+void math_abort(struct math_emu_info *info, unsigned int signal)
 {
 	FPU_EIP = FPU_ORIG_EIP;
 	current->thread.trap_no = 16;
diff --git a/arch/x86/math-emu/fpu_proto.h b/arch/x86/math-emu/fpu_proto.h
index aa49b6a..9779df4 100644
--- a/arch/x86/math-emu/fpu_proto.h
+++ b/arch/x86/math-emu/fpu_proto.h
@@ -51,8 +51,8 @@ extern void ffreep(void);
 extern void fst_i_(void);
 extern void fstp_i(void);
 /* fpu_entry.c */
-asmlinkage extern void math_emulate(long arg);
-extern void math_abort(struct info *info, unsigned int signal);
+extern void math_emulate(struct math_emu_info *info);
+extern void math_abort(struct math_emu_info *info, unsigned int signal);
 /* fpu_etc.c */
 extern void FPU_etc(void);
 /* fpu_tags.c */
diff --git a/arch/x86/math-emu/fpu_system.h b/arch/x86/math-emu/fpu_system.h
index 13488fa..50fa0ec 100644
--- a/arch/x86/math-emu/fpu_system.h
+++ b/arch/x86/math-emu/fpu_system.h
@@ -16,10 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 
-/* This sets the pointer FPU_info to point to the argument part
-   of the stack frame of math_emulate() */
-#define SETUP_DATA_AREA(arg)	FPU_info = (struct info *) &arg
-
 /* s is always from a cpu register, and the cpu does bounds checking
  * during register load --> no further bounds checks needed */
 #define LDT_DESCRIPTOR(s)	(((struct desc_struct *)current->mm->context.ldt)[(s) >> 3])
@@ -38,12 +34,12 @@
 #define I387			(current->thread.xstate)
 #define FPU_info		(I387->soft.info)
 
-#define FPU_CS			(*(unsigned short *) &(FPU_info->___cs))
-#define FPU_SS			(*(unsigned short *) &(FPU_info->___ss))
-#define FPU_DS			(*(unsigned short *) &(FPU_info->___ds))
-#define FPU_EAX			(FPU_info->___eax)
-#define FPU_EFLAGS		(FPU_info->___eflags)
-#define FPU_EIP			(FPU_info->___eip)
+#define FPU_CS			(*(unsigned short *) &(FPU_info->regs->cs))
+#define FPU_SS			(*(unsigned short *) &(FPU_info->regs->ss))
+#define FPU_DS			(*(unsigned short *) &(FPU_info->regs->ds))
+#define FPU_EAX			(FPU_info->regs->ax)
+#define FPU_EFLAGS		(FPU_info->regs->flags)
+#define FPU_EIP			(FPU_info->regs->ip)
 #define FPU_ORIG_EIP		(FPU_info->___orig_eip)
 
 #define FPU_lookahead           (I387->soft.lookahead)
diff --git a/arch/x86/math-emu/get_address.c b/arch/x86/math-emu/get_address.c
index d701e2b..420b3b6 100644
--- a/arch/x86/math-emu/get_address.c
+++ b/arch/x86/math-emu/get_address.c
@@ -29,46 +29,43 @@
 #define FPU_WRITE_BIT 0x10
 
 static int reg_offset[] = {
-	offsetof(struct info, ___eax),
-	offsetof(struct info, ___ecx),
-	offsetof(struct info, ___edx),
-	offsetof(struct info, ___ebx),
-	offsetof(struct info, ___esp),
-	offsetof(struct info, ___ebp),
-	offsetof(struct info, ___esi),
-	offsetof(struct info, ___edi)
+	offsetof(struct pt_regs, ax),
+	offsetof(struct pt_regs, cx),
+	offsetof(struct pt_regs, dx),
+	offsetof(struct pt_regs, bx),
+	offsetof(struct pt_regs, sp),
+	offsetof(struct pt_regs, bp),
+	offsetof(struct pt_regs, si),
+	offsetof(struct pt_regs, di)
 };
 
-#define REG_(x) (*(long *)(reg_offset[(x)]+(u_char *) FPU_info))
+#define REG_(x) (*(long *)(reg_offset[(x)] + (u_char *)FPU_info->regs))
 
 static int reg_offset_vm86[] = {
-	offsetof(struct info, ___cs),
-	offsetof(struct info, ___vm86_ds),
-	offsetof(struct info, ___vm86_es),
-	offsetof(struct info, ___vm86_fs),
-	offsetof(struct info, ___vm86_gs),
-	offsetof(struct info, ___ss),
-	offsetof(struct info, ___vm86_ds)
+	offsetof(struct pt_regs, cs),
+	offsetof(struct kernel_vm86_regs, ds),
+	offsetof(struct kernel_vm86_regs, es),
+	offsetof(struct kernel_vm86_regs, fs),
+	offsetof(struct kernel_vm86_regs, gs),
+	offsetof(struct pt_regs, ss),
+	offsetof(struct kernel_vm86_regs, ds)
 };
 
 #define VM86_REG_(x) (*(unsigned short *) \
-		      (reg_offset_vm86[((unsigned)x)]+(u_char *) FPU_info))
-
-/* This dummy, gs is not saved on the stack. */
-#define ___GS ___ds
+		(reg_offset_vm86[((unsigned)x)] + (u_char *)FPU_info->regs))
 
 static int reg_offset_pm[] = {
-	offsetof(struct info, ___cs),
-	offsetof(struct info, ___ds),
-	offsetof(struct info, ___es),
-	offsetof(struct info, ___fs),
-	offsetof(struct info, ___GS),
-	offsetof(struct info, ___ss),
-	offsetof(struct info, ___ds)
+	offsetof(struct pt_regs, cs),
+	offsetof(struct pt_regs, ds),
+	offsetof(struct pt_regs, es),
+	offsetof(struct pt_regs, fs),
+	offsetof(struct pt_regs, ds),	/* dummy, not saved on stack */
+	offsetof(struct pt_regs, ss),
+	offsetof(struct pt_regs, ds)
 };
 
 #define PM_REG_(x) (*(unsigned short *) \
-		      (reg_offset_pm[((unsigned)x)]+(u_char *) FPU_info))
+		(reg_offset_pm[((unsigned)x)] + (u_char *)FPU_info->regs))
 
 /* Decode the SIB byte. This function assumes mod != 0 */
 static int sib(int mod, unsigned long *fpu_eip)
@@ -349,34 +346,34 @@ void __user *FPU_get_address_16(u_char FPU_modrm, unsigned long *fpu_eip,
 	}
 	switch (rm) {
 	case 0:
-		address += FPU_info->___ebx + FPU_info->___esi;
+		address += FPU_info->regs->bx + FPU_info->regs->si;
 		break;
 	case 1:
-		address += FPU_info->___ebx + FPU_info->___edi;
+		address += FPU_info->regs->bx + FPU_info->regs->di;
 		break;
 	case 2:
-		address += FPU_info->___ebp + FPU_info->___esi;
+		address += FPU_info->regs->bp + FPU_info->regs->si;
 		if (addr_modes.override.segment == PREFIX_DEFAULT)
 			addr_modes.override.segment = PREFIX_SS_;
 		break;
 	case 3:
-		address += FPU_info->___ebp + FPU_info->___edi;
+		address += FPU_info->regs->bp + FPU_info->regs->di;
 		if (addr_modes.override.segment == PREFIX_DEFAULT)
 			addr_modes.override.segment = PREFIX_SS_;
 		break;
 	case 4:
-		address += FPU_info->___esi;
+		address += FPU_info->regs->si;
 		break;
 	case 5:
-		address += FPU_info->___edi;
+		address += FPU_info->regs->di;
 		break;
 	case 6:
-		address += FPU_info->___ebp;
+		address += FPU_info->regs->bp;
 		if (addr_modes.override.segment == PREFIX_DEFAULT)
 			addr_modes.override.segment = PREFIX_SS_;
 		break;
 	case 7:
-		address += FPU_info->___ebx;
+		address += FPU_info->regs->bx;
 		break;
 	}
 
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 3dfecb2..f4b7c79 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -268,7 +268,12 @@ static long list_size;
 
 static void domain_remove_dev_info(struct dmar_domain *domain);
 
-int dmar_disabled;
+#ifdef CONFIG_DMAR_DEFAULT_ON
+int dmar_disabled = 0;
+#else
+int dmar_disabled = 1;
+#endif /*CONFIG_DMAR_DEFAULT_ON*/
+
 static int __initdata dmar_map_gfx = 1;
 static int dmar_forcedac;
 static int intel_iommu_strict;
@@ -284,9 +289,12 @@ static int __init intel_iommu_setup(char *str)
 	if (!str)
 		return -EINVAL;
 	while (*str) {
-		if (!strncmp(str, "off", 3)) {
+		if (!strncmp(str, "on", 2)) {
+			dmar_disabled = 0;
+			printk(KERN_INFO "Intel-IOMMU: enabled\n");
+		} else if (!strncmp(str, "off", 3)) {
 			dmar_disabled = 1;
-			printk(KERN_INFO"Intel-IOMMU: disabled\n");
+			printk(KERN_INFO "Intel-IOMMU: disabled\n");
 		} else if (!strncmp(str, "igfx_off", 8)) {
 			dmar_map_gfx = 0;
 			printk(KERN_INFO
diff --git a/kernel/fork.c b/kernel/fork.c
index 242a706..43c039d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1093,7 +1093,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 #ifdef CONFIG_DEBUG_MUTEXES
 	p->blocked_on = NULL; /* not blocked yet */
 #endif
-	if (unlikely(ptrace_reparented(current)))
+	if (unlikely(current->ptrace))
 		ptrace_fork(p, clone_flags);
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
