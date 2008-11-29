Return-Path: <linux-kernel-owner+w=401wt.eu-S1753703AbYK2TcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbYK2TcU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 14:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYK2TcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 14:32:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49581 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbYK2TcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 14:32:09 -0500
Date: Sat, 29 Nov 2008 20:31:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20081129193150.GA25907@elte.hu>
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

 Thanks,

	Ingo

------------------>
Andreas Herrmann (1):
      x86: fixup config space size of CPU functions for AMD family 11h

Eric Dumazet (1):
      oprofile: fix an overflow in ppro code

Ian Campbell (1):
      xen: pin correct PGD on suspend

Joerg Roedel (1):
      x86: always define DECLARE_PCI_UNMAP* macros

Julia Lawall (1):
      arch/x86/kernel/pci-calgary_64.c: change simple_strtol to simple_strtoul

Markus Metzger (4):
      x86, bts: exclude ds.c from build when disabled
      x86, bts: turn macro into static inline function
      x86, pebs: fix PEBS record size configuration
      x86, bts: fix wrmsr and spinlock over kmalloc

Rakib Mullick (2):
      x86: fix __cpuinit/__init tangle in init_thread_xstate()
      x86: fixing __cpuinit/__init tangle, xsave_cntxt_init()

Steven Rostedt (1):
      x86: use limited register constraint for setnz

Thomas Gleixner (1):
      x86: revert irq number limitation


 arch/x86/boot/tty.c               |    2 +-
 arch/x86/include/asm/ds.h         |    6 ++-
 arch/x86/include/asm/pci_64.h     |   14 ------
 arch/x86/kernel/Makefile          |    2 +-
 arch/x86/kernel/ds.c              |   88 ++++++++++++++++++++-----------------
 arch/x86/kernel/i387.c            |    2 +-
 arch/x86/kernel/io_apic.c         |   22 +---------
 arch/x86/kernel/pci-calgary_64.c  |    2 +-
 arch/x86/kernel/xsave.c           |    2 +-
 arch/x86/oprofile/op_model_ppro.c |    2 +-
 arch/x86/pci/fixup.c              |   25 ++++++-----
 arch/x86/xen/mmu.c                |   21 ++++++---
 12 files changed, 87 insertions(+), 101 deletions(-)

diff --git a/arch/x86/boot/tty.c b/arch/x86/boot/tty.c
index 0be77b3..7e8e8b2 100644
--- a/arch/x86/boot/tty.c
+++ b/arch/x86/boot/tty.c
@@ -74,7 +74,7 @@ static int kbd_pending(void)
 {
 	u8 pending;
 	asm volatile("int $0x16; setnz %0"
-		     : "=rm" (pending)
+		     : "=qm" (pending)
 		     : "a" (0x0100));
 	return pending;
 }
diff --git a/arch/x86/include/asm/ds.h b/arch/x86/include/asm/ds.h
index 72c5a19..a950084 100644
--- a/arch/x86/include/asm/ds.h
+++ b/arch/x86/include/asm/ds.h
@@ -23,12 +23,13 @@
 #ifndef _ASM_X86_DS_H
 #define _ASM_X86_DS_H
 
-#ifdef CONFIG_X86_DS
 
 #include <linux/types.h>
 #include <linux/init.h>
 
 
+#ifdef CONFIG_X86_DS
+
 struct task_struct;
 
 /*
@@ -232,7 +233,8 @@ extern void ds_free(struct ds_context *context);
 
 #else /* CONFIG_X86_DS */
 
-#define ds_init_intel(config) do {} while (0)
+struct cpuinfo_x86;
+static inline void __cpuinit ds_init_intel(struct cpuinfo_x86 *ignored) {}
 
 #endif /* CONFIG_X86_DS */
 #endif /* _ASM_X86_DS_H */
diff --git a/arch/x86/include/asm/pci_64.h b/arch/x86/include/asm/pci_64.h
index 5b28995..d02d936 100644
--- a/arch/x86/include/asm/pci_64.h
+++ b/arch/x86/include/asm/pci_64.h
@@ -34,8 +34,6 @@ extern void pci_iommu_alloc(void);
  */
 #define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
 
-#if defined(CONFIG_GART_IOMMU) || defined(CONFIG_CALGARY_IOMMU)
-
 #define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	\
 	dma_addr_t ADDR_NAME;
 #define DECLARE_PCI_UNMAP_LEN(LEN_NAME)		\
@@ -49,18 +47,6 @@ extern void pci_iommu_alloc(void);
 #define pci_unmap_len_set(PTR, LEN_NAME, VAL)		\
 	(((PTR)->LEN_NAME) = (VAL))
 
-#else
-/* No IOMMU */
-
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
-#define pci_unmap_addr(PTR, ADDR_NAME)		(0)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	do { } while (0)
-#define pci_unmap_len(PTR, LEN_NAME)		(0)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	do { } while (0)
-
-#endif
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_PCI_64_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index e489ff9..b62a766 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -41,7 +41,7 @@ obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
 obj-y				+= process.o
 obj-y				+= i387.o xsave.o
 obj-y				+= ptrace.o
-obj-y				+= ds.o
+obj-$(CONFIG_X86_DS)		+= ds.o
 obj-$(CONFIG_X86_32)		+= tls.o
 obj-$(CONFIG_IA32_EMULATION)	+= tls.o
 obj-y				+= step.o
diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index d1a1214..a2d1176 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -21,8 +21,6 @@
  */
 
 
-#ifdef CONFIG_X86_DS
-
 #include <asm/ds.h>
 
 #include <linux/errno.h>
@@ -211,14 +209,15 @@ static DEFINE_PER_CPU(struct ds_context *, system_context);
 static inline struct ds_context *ds_get_context(struct task_struct *task)
 {
 	struct ds_context *context;
+	unsigned long irq;
 
-	spin_lock(&ds_lock);
+	spin_lock_irqsave(&ds_lock, irq);
 
 	context = (task ? task->thread.ds_ctx : this_system_context);
 	if (context)
 		context->count++;
 
-	spin_unlock(&ds_lock);
+	spin_unlock_irqrestore(&ds_lock, irq);
 
 	return context;
 }
@@ -226,55 +225,46 @@ static inline struct ds_context *ds_get_context(struct task_struct *task)
 /*
  * Same as ds_get_context, but allocates the context and it's DS
  * structure, if necessary; returns NULL; if out of memory.
- *
- * pre: requires ds_lock to be held
  */
 static inline struct ds_context *ds_alloc_context(struct task_struct *task)
 {
 	struct ds_context **p_context =
 		(task ? &task->thread.ds_ctx : &this_system_context);
 	struct ds_context *context = *p_context;
+	unsigned long irq;
 
 	if (!context) {
-		spin_unlock(&ds_lock);
-
 		context = kzalloc(sizeof(*context), GFP_KERNEL);
-
-		if (!context) {
-			spin_lock(&ds_lock);
+		if (!context)
 			return NULL;
-		}
 
 		context->ds = kzalloc(ds_cfg.sizeof_ds, GFP_KERNEL);
 		if (!context->ds) {
 			kfree(context);
-			spin_lock(&ds_lock);
 			return NULL;
 		}
 
-		spin_lock(&ds_lock);
-		/*
-		 * Check for race - another CPU could have allocated
-		 * it meanwhile:
-		 */
+		spin_lock_irqsave(&ds_lock, irq);
+
 		if (*p_context) {
 			kfree(context->ds);
 			kfree(context);
-			return *p_context;
-		}
 
-		*p_context = context;
+			context = *p_context;
+		} else {
+			*p_context = context;
 
-		context->this = p_context;
-		context->task = task;
+			context->this = p_context;
+			context->task = task;
 
-		if (task)
-			set_tsk_thread_flag(task, TIF_DS_AREA_MSR);
+			if (task)
+				set_tsk_thread_flag(task, TIF_DS_AREA_MSR);
 
-		if (!task || (task == current))
-			wrmsr(MSR_IA32_DS_AREA, (unsigned long)context->ds, 0);
-
-		get_tracer(task);
+			if (!task || (task == current))
+				wrmsrl(MSR_IA32_DS_AREA,
+				       (unsigned long)context->ds);
+		}
+		spin_unlock_irqrestore(&ds_lock, irq);
 	}
 
 	context->count++;
@@ -288,10 +278,12 @@ static inline struct ds_context *ds_alloc_context(struct task_struct *task)
  */
 static inline void ds_put_context(struct ds_context *context)
 {
+	unsigned long irq;
+
 	if (!context)
 		return;
 
-	spin_lock(&ds_lock);
+	spin_lock_irqsave(&ds_lock, irq);
 
 	if (--context->count)
 		goto out;
@@ -313,7 +305,7 @@ static inline void ds_put_context(struct ds_context *context)
 	kfree(context->ds);
 	kfree(context);
  out:
-	spin_unlock(&ds_lock);
+	spin_unlock_irqrestore(&ds_lock, irq);
 }
 
 
@@ -384,6 +376,7 @@ static int ds_request(struct task_struct *task, void *base, size_t size,
 	struct ds_context *context;
 	unsigned long buffer, adj;
 	const unsigned long alignment = (1 << 3);
+	unsigned long irq;
 	int error = 0;
 
 	if (!ds_cfg.sizeof_ds)
@@ -398,26 +391,27 @@ static int ds_request(struct task_struct *task, void *base, size_t size,
 		return -EOPNOTSUPP;
 
 
-	spin_lock(&ds_lock);
-
-	error = -ENOMEM;
 	context = ds_alloc_context(task);
 	if (!context)
-		goto out_unlock;
+		return -ENOMEM;
+
+	spin_lock_irqsave(&ds_lock, irq);
 
 	error = -EPERM;
 	if (!check_tracer(task))
 		goto out_unlock;
 
+	get_tracer(task);
+
 	error = -EALREADY;
 	if (context->owner[qual] == current)
-		goto out_unlock;
+		goto out_put_tracer;
 	error = -EPERM;
 	if (context->owner[qual] != NULL)
-		goto out_unlock;
+		goto out_put_tracer;
 	context->owner[qual] = current;
 
-	spin_unlock(&ds_lock);
+	spin_unlock_irqrestore(&ds_lock, irq);
 
 
 	error = -ENOMEM;
@@ -465,10 +459,17 @@ static int ds_request(struct task_struct *task, void *base, size_t size,
  out_release:
 	context->owner[qual] = NULL;
 	ds_put_context(context);
+	put_tracer(task);
+	return error;
+
+ out_put_tracer:
+	spin_unlock_irqrestore(&ds_lock, irq);
+	ds_put_context(context);
+	put_tracer(task);
 	return error;
 
  out_unlock:
-	spin_unlock(&ds_lock);
+	spin_unlock_irqrestore(&ds_lock, irq);
 	ds_put_context(context);
 	return error;
 }
@@ -818,13 +819,21 @@ static const struct ds_configuration ds_cfg_var = {
 	.sizeof_ds    = sizeof(long) * 12,
 	.sizeof_field = sizeof(long),
 	.sizeof_rec[ds_bts]   = sizeof(long) * 3,
+#ifdef __i386__
 	.sizeof_rec[ds_pebs]  = sizeof(long) * 10
+#else
+	.sizeof_rec[ds_pebs]  = sizeof(long) * 18
+#endif
 };
 static const struct ds_configuration ds_cfg_64 = {
 	.sizeof_ds    = 8 * 12,
 	.sizeof_field = 8,
 	.sizeof_rec[ds_bts]   = 8 * 3,
+#ifdef __i386__
 	.sizeof_rec[ds_pebs]  = 8 * 10
+#else
+	.sizeof_rec[ds_pebs]  = 8 * 18
+#endif
 };
 
 static inline void
@@ -878,4 +887,3 @@ void ds_free(struct ds_context *context)
 	while (leftovers--)
 		ds_put_context(context);
 }
-#endif /* CONFIG_X86_DS */
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 1f20608..b0f61f0 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -58,7 +58,7 @@ void __cpuinit mxcsr_feature_mask_init(void)
 	stts();
 }
 
-void __init init_thread_xstate(void)
+void __cpuinit init_thread_xstate(void)
 {
 	if (!HAVE_HWFP) {
 		xstate_size = sizeof(struct i387_soft_struct);
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index c9513e1..1fec0f9 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -3608,27 +3608,7 @@ int __init io_apic_get_redir_entries (int ioapic)
 
 int __init probe_nr_irqs(void)
 {
-	int idx;
-	int nr = 0;
-#ifndef CONFIG_XEN
-	int nr_min = 32;
-#else
-	int nr_min = NR_IRQS;
-#endif
-
-	for (idx = 0; idx < nr_ioapics; idx++)
-		nr += io_apic_get_redir_entries(idx) + 1;
-
-	/* double it for hotplug and msi and nmi */
-	nr <<= 1;
-
-	/* something wrong ? */
-	if (nr < nr_min)
-		nr = nr_min;
-	if (WARN_ON(nr > NR_IRQS))
-		nr = NR_IRQS;
-
-	return nr;
+	return NR_IRQS;
 }
 
 /* --------------------------------------------------------------------------
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index e1e731d..d28bbdc 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1567,7 +1567,7 @@ static int __init calgary_parse_options(char *p)
 				++p;
 			if (*p == '\0')
 				break;
-			bridge = simple_strtol(p, &endp, 0);
+			bridge = simple_strtoul(p, &endp, 0);
 			if (p == endp)
 				break;
 
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index b13acb7..15c3e69 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -310,7 +310,7 @@ static void __init setup_xstate_init(void)
 /*
  * Enable and initialize the xsave feature.
  */
-void __init xsave_cntxt_init(void)
+void __ref xsave_cntxt_init(void)
 {
 	unsigned int eax, ebx, ecx, edx;
 
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 3f1b81a..716d26f 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -69,7 +69,7 @@ static void ppro_setup_ctrs(struct op_msrs const * const msrs)
 	int i;
 
 	if (!reset_value) {
-		reset_value = kmalloc(sizeof(unsigned) * num_counters,
+		reset_value = kmalloc(sizeof(reset_value[0]) * num_counters,
 					GFP_ATOMIC);
 		if (!reset_value)
 			return;
diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index 3c27a80..2051dc9 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -496,21 +496,24 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SIEMENS, 0x0015,
 			  pci_siemens_interrupt_controller);
 
 /*
- * Regular PCI devices have 256 bytes, but AMD Family 10h Opteron ext config
- * have 4096 bytes.  Even if the device is capable, that doesn't mean we can
- * access it.  Maybe we don't have a way to generate extended config space
- * accesses.   So check it
+ * Regular PCI devices have 256 bytes, but AMD Family 10h/11h CPUs have
+ * 4096 bytes configuration space for each function of their processor
+ * configuration space.
  */
-static void fam10h_pci_cfg_space_size(struct pci_dev *dev)
+static void amd_cpu_pci_cfg_space_size(struct pci_dev *dev)
 {
 	dev->cfg_size = pci_cfg_space_size_ext(dev);
 }
-
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1200, fam10h_pci_cfg_space_size);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1201, fam10h_pci_cfg_space_size);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1202, fam10h_pci_cfg_space_size);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1203, fam10h_pci_cfg_space_size);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1204, fam10h_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1200, amd_cpu_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1201, amd_cpu_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1202, amd_cpu_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1203, amd_cpu_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1204, amd_cpu_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1300, amd_cpu_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1301, amd_cpu_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1302, amd_cpu_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1303, amd_cpu_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1304, amd_cpu_pci_cfg_space_size);
 
 /*
  * SB600: Disable BAR1 on device 14.0 to avoid HPET resources from
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 6889360..636ef4c 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -661,12 +661,11 @@ void xen_set_pgd(pgd_t *ptr, pgd_t val)
  * For 64-bit, we must skip the Xen hole in the middle of the address
  * space, just after the big x86-64 virtual hole.
  */
-static int xen_pgd_walk(struct mm_struct *mm,
-			int (*func)(struct mm_struct *mm, struct page *,
-				    enum pt_level),
-			unsigned long limit)
+static int __xen_pgd_walk(struct mm_struct *mm, pgd_t *pgd,
+			  int (*func)(struct mm_struct *mm, struct page *,
+				      enum pt_level),
+			  unsigned long limit)
 {
-	pgd_t *pgd = mm->pgd;
 	int flush = 0;
 	unsigned hole_low, hole_high;
 	unsigned pgdidx_limit, pudidx_limit, pmdidx_limit;
@@ -753,6 +752,14 @@ out:
 	return flush;
 }
 
+static int xen_pgd_walk(struct mm_struct *mm,
+			int (*func)(struct mm_struct *mm, struct page *,
+				    enum pt_level),
+			unsigned long limit)
+{
+	return __xen_pgd_walk(mm, mm->pgd, func, limit);
+}
+
 /* If we're using split pte locks, then take the page's lock and
    return a pointer to it.  Otherwise return NULL. */
 static spinlock_t *xen_pte_lock(struct page *page, struct mm_struct *mm)
@@ -854,7 +861,7 @@ static void __xen_pgd_pin(struct mm_struct *mm, pgd_t *pgd)
 
 	xen_mc_batch();
 
-	 if (xen_pgd_walk(mm, xen_pin_page, USER_LIMIT)) {
+	if (__xen_pgd_walk(mm, pgd, xen_pin_page, USER_LIMIT)) {
 		/* re-enable interrupts for flushing */
 		xen_mc_issue(0);
 
@@ -998,7 +1005,7 @@ static void __xen_pgd_unpin(struct mm_struct *mm, pgd_t *pgd)
 		       PT_PMD);
 #endif
 
-	xen_pgd_walk(mm, xen_unpin_page, USER_LIMIT);
+	__xen_pgd_walk(mm, pgd, xen_unpin_page, USER_LIMIT);
 
 	xen_mc_issue(0);
 }
