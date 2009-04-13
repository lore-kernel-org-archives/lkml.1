Return-Path: <linux-kernel-owner+w=401wt.eu-S1751675AbZDMRhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbZDMRhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 13:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbZDMRg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 13:36:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53377 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbZDMRg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 13:36:56 -0400
Date: Mon, 13 Apr 2009 19:36:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] x86 fixes
Message-ID: <20090413173642.GA31728@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

This commit:

   a30469e: x86: add linux kernel support for YMM state

adds new hardware support and is simple, so we thought it's fine for 
-rc2.

 Thanks,

	Ingo

------------------>
Andy Grover (1):
      x86: Document get_user_pages_fast()

Marcin Slusarz (1):
      x86: fix wrong section of pat_disable & make it static

Masami Hiramatsu (1):
      x86: fix set_fixmap to use phys_addr_t

Rakib Mullick (1):
      x86: Fix section mismatches in mpparse

Suresh Siddha (1):
      x86: add linux kernel support for YMM state

Weidong Han (1):
      x86, intr-remap: fix eoi for interrupt remapping without x2apic


 arch/x86/include/asm/fixmap.h     |    4 ++--
 arch/x86/include/asm/io.h         |    6 ++++--
 arch/x86/include/asm/paravirt.h   |    4 ++--
 arch/x86/include/asm/processor.h  |    6 ++++++
 arch/x86/include/asm/sigcontext.h |    6 ++++++
 arch/x86/include/asm/xsave.h      |    3 ++-
 arch/x86/kernel/apic/io_apic.c    |    5 ++++-
 arch/x86/kernel/mpparse.c         |    7 ++++---
 arch/x86/kernel/xsave.c           |    2 +-
 arch/x86/mm/gup.c                 |   16 ++++++++++++++++
 arch/x86/mm/ioremap.c             |   23 +++++++++++++----------
 arch/x86/mm/pat.c                 |    2 +-
 arch/x86/mm/pgtable.c             |    3 ++-
 arch/x86/xen/mmu.c                |    2 +-
 14 files changed, 64 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 81937a5..2d81af3 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -151,11 +151,11 @@ extern pte_t *pkmap_page_table;
 
 void __native_set_fixmap(enum fixed_addresses idx, pte_t pte);
 void native_set_fixmap(enum fixed_addresses idx,
-		       unsigned long phys, pgprot_t flags);
+		       phys_addr_t phys, pgprot_t flags);
 
 #ifndef CONFIG_PARAVIRT
 static inline void __set_fixmap(enum fixed_addresses idx,
-				unsigned long phys, pgprot_t flags)
+				phys_addr_t phys, pgprot_t flags)
 {
 	native_set_fixmap(idx, phys, flags);
 }
diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index e5383e3..7373932 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -193,8 +193,10 @@ extern void __iomem *ioremap_wc(resource_size_t offset, unsigned long size);
  */
 extern void early_ioremap_init(void);
 extern void early_ioremap_reset(void);
-extern void __iomem *early_ioremap(unsigned long offset, unsigned long size);
-extern void __iomem *early_memremap(unsigned long offset, unsigned long size);
+extern void __iomem *early_ioremap(resource_size_t phys_addr,
+				   unsigned long size);
+extern void __iomem *early_memremap(resource_size_t phys_addr,
+				    unsigned long size);
 extern void early_iounmap(void __iomem *addr, unsigned long size);
 
 #define IO_SPACE_LIMIT 0xffff
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 7727aa8..378e369 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -347,7 +347,7 @@ struct pv_mmu_ops {
 	/* Sometimes the physical address is a pfn, and sometimes its
 	   an mfn.  We can tell which is which from the index. */
 	void (*set_fixmap)(unsigned /* enum fixed_addresses */ idx,
-			   unsigned long phys, pgprot_t flags);
+			   phys_addr_t phys, pgprot_t flags);
 };
 
 struct raw_spinlock;
@@ -1432,7 +1432,7 @@ static inline void arch_leave_lazy_mmu_mode(void)
 void arch_flush_lazy_mmu_mode(void);
 
 static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
-				unsigned long phys, pgprot_t flags)
+				phys_addr_t phys, pgprot_t flags)
 {
 	pv_mmu_ops.set_fixmap(idx, phys, flags);
 }
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 34c5237..fcf4d92 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -352,6 +352,11 @@ struct i387_soft_struct {
 	u32			entry_eip;
 };
 
+struct ymmh_struct {
+	/* 16 * 16 bytes for each YMMH-reg = 256 bytes */
+	u32 ymmh_space[64];
+};
+
 struct xsave_hdr_struct {
 	u64 xstate_bv;
 	u64 reserved1[2];
@@ -361,6 +366,7 @@ struct xsave_hdr_struct {
 struct xsave_struct {
 	struct i387_fxsave_struct i387;
 	struct xsave_hdr_struct xsave_hdr;
+	struct ymmh_struct ymmh;
 	/* new processor state extensions will go here */
 } __attribute__ ((packed, aligned (64)));
 
diff --git a/arch/x86/include/asm/sigcontext.h b/arch/x86/include/asm/sigcontext.h
index ec66649..72e5a44 100644
--- a/arch/x86/include/asm/sigcontext.h
+++ b/arch/x86/include/asm/sigcontext.h
@@ -269,6 +269,11 @@ struct _xsave_hdr {
 	__u64 reserved2[5];
 };
 
+struct _ymmh_state {
+	/* 16 * 16 bytes for each YMMH-reg */
+	__u32 ymmh_space[64];
+};
+
 /*
  * Extended state pointed by the fpstate pointer in the sigcontext.
  * In addition to the fpstate, information encoded in the xstate_hdr
@@ -278,6 +283,7 @@ struct _xsave_hdr {
 struct _xstate {
 	struct _fpstate fpstate;
 	struct _xsave_hdr xstate_hdr;
+	struct _ymmh_state ymmh;
 	/* new processor state extensions go here */
 };
 
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 08e9a1a..727acc1 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -7,6 +7,7 @@
 
 #define XSTATE_FP	0x1
 #define XSTATE_SSE	0x2
+#define XSTATE_YMM	0x4
 
 #define XSTATE_FPSSE	(XSTATE_FP | XSTATE_SSE)
 
@@ -15,7 +16,7 @@
 /*
  * These are the features that the OS can handle currently.
  */
-#define XCNTXT_MASK	(XSTATE_FP | XSTATE_SSE)
+#define XCNTXT_MASK	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
 
 #ifdef CONFIG_X86_64
 #define REX_PREFIX	"0x48, "
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 767fe7e..a2789e4 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2524,7 +2524,6 @@ static void irq_complete_move(struct irq_desc **descp)
 static inline void irq_complete_move(struct irq_desc **descp) {}
 #endif
 
-#ifdef CONFIG_X86_X2APIC
 static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
 {
 	int apic, pin;
@@ -2558,6 +2557,7 @@ eoi_ioapic_irq(struct irq_desc *desc)
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
+#ifdef CONFIG_X86_X2APIC
 static void ack_x2apic_level(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
@@ -2634,6 +2634,9 @@ static void ack_apic_level(unsigned int irq)
 	 */
 	ack_APIC_irq();
 
+	if (irq_remapped(irq))
+		eoi_ioapic_irq(desc);
+
 	/* Now we can move and renable the irq */
 	if (unlikely(do_unmask_irq)) {
 		/* Only migrate the irq if the ack has been received.
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index dce99dc..70fd7e4 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -679,7 +679,7 @@ void __init get_smp_config(void)
 	__get_smp_config(0);
 }
 
-static void smp_reserve_bootmem(struct mpf_intel *mpf)
+static void __init smp_reserve_bootmem(struct mpf_intel *mpf)
 {
 	unsigned long size = get_mpc_size(mpf->physptr);
 #ifdef CONFIG_X86_32
@@ -838,7 +838,7 @@ static int  __init get_MP_intsrc_index(struct mpc_intsrc *m)
 
 static struct mpc_intsrc __initdata *m_spare[SPARE_SLOT_NUM];
 
-static void check_irq_src(struct mpc_intsrc *m, int *nr_m_spare)
+static void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare)
 {
 	int i;
 
@@ -866,7 +866,8 @@ static void check_irq_src(struct mpc_intsrc *m, int *nr_m_spare)
 	}
 }
 #else /* CONFIG_X86_IO_APIC */
-static inline void check_irq_src(struct mpc_intsrc *m, int *nr_m_spare) {}
+static
+inline void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare) {}
 #endif /* CONFIG_X86_IO_APIC */
 
 static int check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length,
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 2b54fe0..0a5b04a 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -324,7 +324,7 @@ void __ref xsave_cntxt_init(void)
 	}
 
 	/*
-	 * for now OS knows only about FP/SSE
+	 * Support only the state known to OS.
 	 */
 	pcntxt_mask = pcntxt_mask & XCNTXT_MASK;
 	xsave_init();
diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index be54176..6340cef 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -219,6 +219,22 @@ static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
 	return 1;
 }
 
+/**
+ * get_user_pages_fast() - pin user pages in memory
+ * @start:	starting user address
+ * @nr_pages:	number of pages from start to pin
+ * @write:	whether pages will be written to
+ * @pages:	array that receives pointers to the pages pinned.
+ * 		Should be at least nr_pages long.
+ *
+ * Attempt to pin user pages in memory without taking mm->mmap_sem.
+ * If not successful, it will fall back to taking the lock and
+ * calling get_user_pages().
+ *
+ * Returns number of pages pinned. This may be fewer than the number
+ * requested. If nr_pages is 0 or negative, returns 0. If no pages
+ * were pinned, returns -errno.
+ */
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages)
 {
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 0dfa09d..09daebf 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -547,7 +547,7 @@ void __init early_ioremap_reset(void)
 }
 
 static void __init __early_set_fixmap(enum fixed_addresses idx,
-				   unsigned long phys, pgprot_t flags)
+				      phys_addr_t phys, pgprot_t flags)
 {
 	unsigned long addr = __fix_to_virt(idx);
 	pte_t *pte;
@@ -566,7 +566,7 @@ static void __init __early_set_fixmap(enum fixed_addresses idx,
 }
 
 static inline void __init early_set_fixmap(enum fixed_addresses idx,
-					   unsigned long phys, pgprot_t prot)
+					   phys_addr_t phys, pgprot_t prot)
 {
 	if (after_paging_init)
 		__set_fixmap(idx, phys, prot);
@@ -607,9 +607,10 @@ static int __init check_early_ioremap_leak(void)
 late_initcall(check_early_ioremap_leak);
 
 static void __init __iomem *
-__early_ioremap(unsigned long phys_addr, unsigned long size, pgprot_t prot)
+__early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
 {
-	unsigned long offset, last_addr;
+	unsigned long offset;
+	resource_size_t last_addr;
 	unsigned int nrpages;
 	enum fixed_addresses idx0, idx;
 	int i, slot;
@@ -625,15 +626,15 @@ __early_ioremap(unsigned long phys_addr, unsigned long size, pgprot_t prot)
 	}
 
 	if (slot < 0) {
-		printk(KERN_INFO "early_iomap(%08lx, %08lx) not found slot\n",
-			 phys_addr, size);
+		printk(KERN_INFO "early_iomap(%08llx, %08lx) not found slot\n",
+			 (u64)phys_addr, size);
 		WARN_ON(1);
 		return NULL;
 	}
 
 	if (early_ioremap_debug) {
-		printk(KERN_INFO "early_ioremap(%08lx, %08lx) [%d] => ",
-		       phys_addr, size, slot);
+		printk(KERN_INFO "early_ioremap(%08llx, %08lx) [%d] => ",
+		       (u64)phys_addr, size, slot);
 		dump_stack();
 	}
 
@@ -680,13 +681,15 @@ __early_ioremap(unsigned long phys_addr, unsigned long size, pgprot_t prot)
 }
 
 /* Remap an IO device */
-void __init __iomem *early_ioremap(unsigned long phys_addr, unsigned long size)
+void __init __iomem *
+early_ioremap(resource_size_t phys_addr, unsigned long size)
 {
 	return __early_ioremap(phys_addr, size, PAGE_KERNEL_IO);
 }
 
 /* Remap memory */
-void __init __iomem *early_memremap(unsigned long phys_addr, unsigned long size)
+void __init __iomem *
+early_memremap(resource_size_t phys_addr, unsigned long size)
 {
 	return __early_ioremap(phys_addr, size, PAGE_KERNEL);
 }
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 640339e..c009a24 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -31,7 +31,7 @@
 #ifdef CONFIG_X86_PAT
 int __read_mostly pat_enabled = 1;
 
-void __cpuinit pat_disable(const char *reason)
+static inline void pat_disable(const char *reason)
 {
 	pat_enabled = 0;
 	printk(KERN_INFO "%s\n", reason);
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 5b7c7c8..7aa03a5 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -345,7 +345,8 @@ void __native_set_fixmap(enum fixed_addresses idx, pte_t pte)
 	fixmaps_set++;
 }
 
-void native_set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t flags)
+void native_set_fixmap(enum fixed_addresses idx, phys_addr_t phys,
+		       pgprot_t flags)
 {
 	__native_set_fixmap(idx, pfn_pte(phys >> PAGE_SHIFT, flags));
 }
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index db3802f..2a81838 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1750,7 +1750,7 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 }
 #endif	/* CONFIG_X86_64 */
 
-static void xen_set_fixmap(unsigned idx, unsigned long phys, pgprot_t prot)
+static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 {
 	pte_t pte;
 
