Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbYJOMuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbYJOMuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 08:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbYJOMup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 08:50:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58936 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885AbYJOMun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 08:50:43 -0400
Date: Wed, 15 Oct 2008 14:50:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] core kernel updates for v2.6.28
Message-ID: <20081015125023.GA6702@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-v28-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-v28-for-linus

this is a combination of the following topics:

   core/softlockup
   core/softirq
   core/resources
   core/printk
   core/misc

 Thanks,

	Ingo

------------------>
Alexey Dobriyan (1):
      softirq: allocate less vectors

Andrew Morton (1):
      softlockup: Documentation/sysctl/kernel.txt: fix softlockup_thresh description

Frederic Weisbecker (1):
      softirq, warning fix: correct a format to avoid a warning

Ingo Molnar (5):
      printk: robustify printk, fix
      IO resources: fix/remove printk
      dmi scan: warn about too early calls to dmi_check_system()
      IO resources, x86: ioremap sanity check to catch mapping requests exceeding, fix
      x86, pci-hotplug, calgary / rio: fix EBDA ioremap()

Jeremy Fitzhardinge (3):
      generic: add phys_addr_t for holding physical addresses
      generic: make PFN_PHYS explicitly return phys_addr_t
      generic: redefine resource_size_t as phys_addr_t

Jiri Kosina (1):
      printk: robustify printk, update comment

Oleg Nesterov (1):
      do_generic_file_read: s/EINTR/EIO/ if lock_page_killable() fails

Peter Zijlstra (2):
      printk: robustify printk
      printk: robustify printk, fix #2

Suresh Siddha (1):
      IO resources, x86: ioremap sanity check to catch mapping requests exceeding the BAR sizes

Thomas Gleixner (1):
      softirqs, debug: preemption check


 arch/m32r/mm/discontig.c               |    4 +-
 arch/powerpc/Kconfig                   |    3 ++
 arch/powerpc/include/asm/types.h       |    7 ----
 arch/powerpc/platforms/Kconfig.cputype |    1 -
 arch/powerpc/sysdev/ppc4xx_pci.c       |   16 ++++------
 arch/x86/Kconfig                       |    4 ++-
 arch/x86/kernel/e820.c                 |    4 +--
 arch/x86/mm/ioremap.c                  |    6 ++++
 drivers/firmware/dmi_scan.c            |   22 ++++++++++----
 drivers/pci/hotplug/ibmphp_ebda.c      |    2 +-
 drivers/pci/setup-bus.c                |    9 ++---
 include/asm-x86/page_32.h              |    2 -
 include/asm-x86/page_64.h              |    1 -
 include/asm-x86/xen/page.h             |    4 +-
 include/linux/interrupt.h              |    2 +
 include/linux/ioport.h                 |    1 +
 include/linux/kernel.h                 |    3 ++
 include/linux/pfn.h                    |    6 +++-
 include/linux/types.h                  |    8 +++--
 kernel/printk.c                        |   22 ++++++++++---
 kernel/resource.c                      |   51 ++++++++++++++++++++++++++-----
 kernel/softirq.c                       |   13 +++++++-
 kernel/time/tick-sched.c               |    2 +-
 kernel/timer.c                         |    1 +
 mm/Kconfig                             |    3 ++
 mm/filemap.c                           |   15 +++++----
 26 files changed, 144 insertions(+), 68 deletions(-)

diff --git a/arch/m32r/mm/discontig.c b/arch/m32r/mm/discontig.c
index cbc3c4c..7daf897 100644
--- a/arch/m32r/mm/discontig.c
+++ b/arch/m32r/mm/discontig.c
@@ -111,9 +111,9 @@ unsigned long __init setup_memory(void)
 				initrd_start, INITRD_SIZE);
 		} else {
 			printk("initrd extends beyond end of memory "
-				"(0x%08lx > 0x%08lx)\ndisabling initrd\n",
+				"(0x%08lx > 0x%08llx)\ndisabling initrd\n",
 				INITRD_START + INITRD_SIZE,
-				PFN_PHYS(max_low_pfn));
+			        (unsigned long long)PFN_PHYS(max_low_pfn));
 
 			initrd_start = 0;
 		}
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 587da5e..f5f83ee 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -22,6 +22,9 @@ config WORD_SIZE
 config PPC_MERGE
 	def_bool y
 
+config ARCH_PHYS_ADDR_T_64BIT
+       def_bool PPC64 || PHYS_64BIT
+
 config MMU
 	bool
 	default y
diff --git a/arch/powerpc/include/asm/types.h b/arch/powerpc/include/asm/types.h
index d3374bc..c646f34 100644
--- a/arch/powerpc/include/asm/types.h
+++ b/arch/powerpc/include/asm/types.h
@@ -48,13 +48,6 @@ typedef struct {
 
 typedef __vector128 vector128;
 
-/* Physical address used by some IO functions */
-#if defined(CONFIG_PPC64) || defined(CONFIG_PHYS_64BIT)
-typedef u64 phys_addr_t;
-#else
-typedef u32 phys_addr_t;
-#endif
-
 #ifdef __powerpc64__
 typedef u64 dma_addr_t;
 #else
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 7f65127..be852fd 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -135,7 +135,6 @@ config PTE_64BIT
 config PHYS_64BIT
 	bool 'Large physical address support' if E500
 	depends on 44x || E500
-	select RESOURCES_64BIT
 	default y if 44x
 	---help---
 	  This option enables kernel support for larger than 32-bit physical
diff --git a/arch/powerpc/sysdev/ppc4xx_pci.c b/arch/powerpc/sysdev/ppc4xx_pci.c
index fb368df..e8a76d9 100644
--- a/arch/powerpc/sysdev/ppc4xx_pci.c
+++ b/arch/powerpc/sysdev/ppc4xx_pci.c
@@ -41,13 +41,10 @@ extern unsigned long total_memory;
 #define U64_TO_U32_LOW(val)	((u32)((val) & 0x00000000ffffffffULL))
 #define U64_TO_U32_HIGH(val)	((u32)((val) >> 32))
 
-#ifdef CONFIG_RESOURCES_64BIT
-#define RES_TO_U32_LOW(val)	U64_TO_U32_LOW(val)
-#define RES_TO_U32_HIGH(val)	U64_TO_U32_HIGH(val)
-#else
-#define RES_TO_U32_LOW(val)	(val)
-#define RES_TO_U32_HIGH(val)	(0)
-#endif
+#define RES_TO_U32_LOW(val)	\
+	((sizeof(resource_size_t) > sizeof(u32)) ? U64_TO_U32_LOW(val) : (val))
+#define RES_TO_U32_HIGH(val)	\
+	((sizeof(resource_size_t) > sizeof(u32)) ? U64_TO_U32_HIGH(val) : (0))
 
 static inline int ppc440spe_revA(void)
 {
@@ -145,12 +142,11 @@ static int __init ppc4xx_parse_dma_ranges(struct pci_controller *hose,
 
 		/* Use that */
 		res->start = pci_addr;
-#ifndef CONFIG_RESOURCES_64BIT
 		/* Beware of 32 bits resources */
-		if ((pci_addr + size) > 0x100000000ull)
+		if (sizeof(resource_size_t) == sizeof(u32) &&
+		    (pci_addr + size) > 0x100000000ull)
 			res->end = 0xffffffff;
 		else
-#endif
 			res->end = res->start + size - 1;
 		break;
 	}
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f65c274..837a9aa 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -947,13 +947,15 @@ config X86_PAE
 	def_bool n
 	prompt "PAE (Physical Address Extension) Support"
 	depends on X86_32 && !HIGHMEM4G
-	select RESOURCES_64BIT
 	help
 	  PAE is required for NX support, and furthermore enables
 	  larger swapspace support for non-overcommit purposes. It
 	  has the cost of more pagetable lookup overhead, and also
 	  consumes more pagetable space per process.
 
+config ARCH_PHYS_ADDR_T_64BIT
+       def_bool X86_64 || X86_PAE
+
 # Common NUMA Features
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 78e642f..ce97bf3 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1282,12 +1282,10 @@ void __init e820_reserve_resources(void)
 	e820_res = res;
 	for (i = 0; i < e820.nr_map; i++) {
 		end = e820.map[i].addr + e820.map[i].size - 1;
-#ifndef CONFIG_RESOURCES_64BIT
-		if (end > 0x100000000ULL) {
+		if (end != (resource_size_t)end) {
 			res++;
 			continue;
 		}
-#endif
 		res->name = e820_type_to_string(e820.map[i].type);
 		res->start = e820.map[i].addr;
 		res->end = end;
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index e4c43ec..ae71e11 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -220,6 +220,12 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 		return (__force void __iomem *)phys_to_virt(phys_addr);
 
 	/*
+	 * Check if the request spans more than any BAR in the iomem resource
+	 * tree.
+	 */
+	WARN_ON(iomem_map_sanity_check(phys_addr, size));
+
+	/*
 	 * Don't allow anybody to remap normal RAM that we're using..
 	 */
 	for (pfn = phys_addr >> PAGE_SHIFT;
diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 455575b..3e526b6 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -15,6 +15,11 @@
  */
 static char dmi_empty_string[] = "        ";
 
+/*
+ * Catch too early calls to dmi_check_system():
+ */
+static int dmi_initialized;
+
 static const char * __init dmi_string_nosave(const struct dmi_header *dm, u8 s)
 {
 	const u8 *bp = ((u8 *) dm) + dm->length;
@@ -366,7 +371,7 @@ void __init dmi_scan_machine(void)
 
 	if (efi_enabled) {
 		if (efi.smbios == EFI_INVALID_TABLE_ADDR)
-			goto out;
+			goto error;
 
 		/* This is called as a core_initcall() because it isn't
 		 * needed during early boot.  This also means we can
@@ -374,13 +379,13 @@ void __init dmi_scan_machine(void)
 		 */
 		p = dmi_ioremap(efi.smbios, 32);
 		if (p == NULL)
-			goto out;
+			goto error;
 
 		rc = dmi_present(p + 0x10); /* offset of _DMI_ string */
 		dmi_iounmap(p, 32);
 		if (!rc) {
 			dmi_available = 1;
-			return;
+			goto out;
 		}
 	}
 	else {
@@ -391,19 +396,22 @@ void __init dmi_scan_machine(void)
 		 */
 		p = dmi_ioremap(0xF0000, 0x10000);
 		if (p == NULL)
-			goto out;
+			goto error;
 
 		for (q = p; q < p + 0x10000; q += 16) {
 			rc = dmi_present(q);
 			if (!rc) {
 				dmi_available = 1;
 				dmi_iounmap(p, 0x10000);
-				return;
+				goto out;
 			}
 		}
 		dmi_iounmap(p, 0x10000);
 	}
- out:	printk(KERN_INFO "DMI not present or invalid.\n");
+ error:
+	printk(KERN_INFO "DMI not present or invalid.\n");
+ out:
+	dmi_initialized = 1;
 }
 
 /**
@@ -424,6 +432,8 @@ int dmi_check_system(const struct dmi_system_id *list)
 	int i, count = 0;
 	const struct dmi_system_id *d = list;
 
+	WARN(!dmi_initialized, KERN_ERR "dmi check: not initialized yet.\n");
+
 	while (d->ident) {
 		for (i = 0; i < ARRAY_SIZE(d->matches); i++) {
 			int s = d->matches[i].slot;
diff --git a/drivers/pci/hotplug/ibmphp_ebda.c b/drivers/pci/hotplug/ibmphp_ebda.c
index 8467d02..7d27631 100644
--- a/drivers/pci/hotplug/ibmphp_ebda.c
+++ b/drivers/pci/hotplug/ibmphp_ebda.c
@@ -276,7 +276,7 @@ int __init ibmphp_access_ebda (void)
 	iounmap (io_mem);
 	debug ("returned ebda segment: %x\n", ebda_seg);
 	
-	io_mem = ioremap (ebda_seg<<4, 65000);
+	io_mem = ioremap(ebda_seg<<4, 1024);
 	if (!io_mem )
 		return -ENOMEM;
 	next_offset = 0x180;
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 3abbfad..d5e2106 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -378,11 +378,10 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask, unsigned long
 	align = 0;
 	min_align = 0;
 	for (order = 0; order <= max_order; order++) {
-#ifdef CONFIG_RESOURCES_64BIT
-		resource_size_t align1 = 1ULL << (order + 20);
-#else
-		resource_size_t align1 = 1U << (order + 20);
-#endif
+		resource_size_t align1 = 1;
+
+		align1 <<= (order + 20);
+
 		if (!align)
 			min_align = align1;
 		else if (ALIGN(align + min_align, min_align) < align1)
diff --git a/include/asm-x86/page_32.h b/include/asm-x86/page_32.h
index e8d80d1..bdf5dba 100644
--- a/include/asm-x86/page_32.h
+++ b/include/asm-x86/page_32.h
@@ -39,7 +39,6 @@ typedef u64	pmdval_t;
 typedef u64	pudval_t;
 typedef u64	pgdval_t;
 typedef u64	pgprotval_t;
-typedef u64	phys_addr_t;
 
 typedef union {
 	struct {
@@ -60,7 +59,6 @@ typedef unsigned long	pmdval_t;
 typedef unsigned long	pudval_t;
 typedef unsigned long	pgdval_t;
 typedef unsigned long	pgprotval_t;
-typedef unsigned long	phys_addr_t;
 
 typedef union {
 	pteval_t pte;
diff --git a/include/asm-x86/page_64.h b/include/asm-x86/page_64.h
index 5e64acf..49380b8 100644
--- a/include/asm-x86/page_64.h
+++ b/include/asm-x86/page_64.h
@@ -79,7 +79,6 @@ typedef unsigned long	pmdval_t;
 typedef unsigned long	pudval_t;
 typedef unsigned long	pgdval_t;
 typedef unsigned long	pgprotval_t;
-typedef unsigned long	phys_addr_t;
 
 typedef struct page *pgtable_t;
 
diff --git a/include/asm-x86/xen/page.h b/include/asm-x86/xen/page.h
index c50185d..d5eada0 100644
--- a/include/asm-x86/xen/page.h
+++ b/include/asm-x86/xen/page.h
@@ -76,13 +76,13 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
 static inline xmaddr_t phys_to_machine(xpaddr_t phys)
 {
 	unsigned offset = phys.paddr & ~PAGE_MASK;
-	return XMADDR(PFN_PHYS((u64)pfn_to_mfn(PFN_DOWN(phys.paddr))) | offset);
+	return XMADDR(PFN_PHYS(pfn_to_mfn(PFN_DOWN(phys.paddr))) | offset);
 }
 
 static inline xpaddr_t machine_to_phys(xmaddr_t machine)
 {
 	unsigned offset = machine.maddr & ~PAGE_MASK;
-	return XPADDR(PFN_PHYS((u64)mfn_to_pfn(PFN_DOWN(machine.maddr))) | offset);
+	return XPADDR(PFN_PHYS(mfn_to_pfn(PFN_DOWN(machine.maddr))) | offset);
 }
 
 /*
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 58ff4e7..54b3623 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -252,6 +252,8 @@ enum
 	HRTIMER_SOFTIRQ,
 #endif
 	RCU_SOFTIRQ, 	/* Preferable RCU should always be the last softirq */
+
+	NR_SOFTIRQS
 };
 
 /* softirq mask and active fields moved to irq_cpustat_t in
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index ee9bcc6..e38b6aa 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -169,6 +169,7 @@ extern struct resource * __devm_request_region(struct device *dev,
 
 extern void __devm_release_region(struct device *dev, struct resource *parent,
 				  resource_size_t start, resource_size_t n);
+extern int iomem_map_sanity_check(resource_size_t addr, unsigned long size);
 
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 75d81f1..9687491 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -213,6 +213,9 @@ static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
 		{ return false; }
 #endif
 
+extern int printk_needs_cpu(int cpu);
+extern void printk_tick(void);
+
 extern void asmlinkage __attribute__((format(printf, 1, 2)))
 	early_printk(const char *fmt, ...);
 
diff --git a/include/linux/pfn.h b/include/linux/pfn.h
index bb01f8b..7646637 100644
--- a/include/linux/pfn.h
+++ b/include/linux/pfn.h
@@ -1,9 +1,13 @@
 #ifndef _LINUX_PFN_H_
 #define _LINUX_PFN_H_
 
+#ifndef __ASSEMBLY__
+#include <linux/types.h>
+#endif
+
 #define PFN_ALIGN(x)	(((unsigned long)(x) + (PAGE_SIZE - 1)) & PAGE_MASK)
 #define PFN_UP(x)	(((x) + PAGE_SIZE-1) >> PAGE_SHIFT)
 #define PFN_DOWN(x)	((x) >> PAGE_SHIFT)
-#define PFN_PHYS(x)	((x) << PAGE_SHIFT)
+#define PFN_PHYS(x)	((phys_addr_t)(x) << PAGE_SHIFT)
 
 #endif
diff --git a/include/linux/types.h b/include/linux/types.h
index d4a9ce6..f24f7be 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -191,12 +191,14 @@ typedef __u32 __bitwise __wsum;
 #ifdef __KERNEL__
 typedef unsigned __bitwise__ gfp_t;
 
-#ifdef CONFIG_RESOURCES_64BIT
-typedef u64 resource_size_t;
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
+typedef u64 phys_addr_t;
 #else
-typedef u32 resource_size_t;
+typedef u32 phys_addr_t;
 #endif
 
+typedef phys_addr_t resource_size_t;
+
 struct ustat {
 	__kernel_daddr_t	f_tfree;
 	__kernel_ino_t		f_tinode;
diff --git a/kernel/printk.c b/kernel/printk.c
index a430fd0..aee891a 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -577,9 +577,6 @@ static int have_callable_console(void)
  * @fmt: format string
  *
  * This is printk().  It can be called from any context.  We want it to work.
- * Be aware of the fact that if oops_in_progress is not set, we might try to
- * wake klogd up which could deadlock on runqueue lock if printk() is called
- * from scheduler code.
  *
  * We try to grab the console_sem.  If we succeed, it's easy - we log the output and
  * call the console drivers.  If we fail to get the semaphore we place the output
@@ -982,10 +979,25 @@ int is_console_locked(void)
 	return console_locked;
 }
 
-void wake_up_klogd(void)
+static DEFINE_PER_CPU(int, printk_pending);
+
+void printk_tick(void)
 {
-	if (!oops_in_progress && waitqueue_active(&log_wait))
+	if (__get_cpu_var(printk_pending)) {
+		__get_cpu_var(printk_pending) = 0;
 		wake_up_interruptible(&log_wait);
+	}
+}
+
+int printk_needs_cpu(int cpu)
+{
+	return per_cpu(printk_pending, cpu);
+}
+
+void wake_up_klogd(void)
+{
+	if (waitqueue_active(&log_wait))
+		__raw_get_cpu_var(printk_pending) = 1;
 }
 
 /**
diff --git a/kernel/resource.c b/kernel/resource.c
index 414d6fc..7797dae 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -38,10 +38,6 @@ EXPORT_SYMBOL(iomem_resource);
 
 static DEFINE_RWLOCK(resource_lock);
 
-#ifdef CONFIG_PROC_FS
-
-enum { MAX_IORES_LEVEL = 5 };
-
 static void *r_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct resource *p = v;
@@ -53,6 +49,10 @@ static void *r_next(struct seq_file *m, void *v, loff_t *pos)
 	return p->sibling;
 }
 
+#ifdef CONFIG_PROC_FS
+
+enum { MAX_IORES_LEVEL = 5 };
+
 static void *r_start(struct seq_file *m, loff_t *pos)
 	__acquires(resource_lock)
 {
@@ -549,13 +549,9 @@ static void __init __reserve_region_with_split(struct resource *root,
 	}
 
 	if (!res) {
-		printk(KERN_DEBUG "    __reserve_region_with_split: (%s) [%llx, %llx], res: (%s) [%llx, %llx]\n",
-			 conflict->name, conflict->start, conflict->end,
-			 name, start, end);
-
 		/* failed, split and try again */
 
-		/* conflict coverred whole area */
+		/* conflict covered whole area */
 		if (conflict->start <= start && conflict->end >= end)
 			return;
 
@@ -831,3 +827,40 @@ static int __init reserve_setup(char *str)
 }
 
 __setup("reserve=", reserve_setup);
+
+/*
+ * Check if the requested addr and size spans more than any slot in the
+ * iomem resource tree.
+ */
+int iomem_map_sanity_check(resource_size_t addr, unsigned long size)
+{
+	struct resource *p = &iomem_resource;
+	int err = 0;
+	loff_t l;
+
+	read_lock(&resource_lock);
+	for (p = p->child; p ; p = r_next(NULL, p, &l)) {
+		/*
+		 * We can probably skip the resources without
+		 * IORESOURCE_IO attribute?
+		 */
+		if (p->start >= addr + size)
+			continue;
+		if (p->end < addr)
+			continue;
+		if (p->start <= addr && (p->end >= addr + size - 1))
+			continue;
+		printk(KERN_WARNING "resource map sanity check conflict: "
+		       "0x%llx 0x%llx 0x%llx 0x%llx %s\n",
+		       (unsigned long long)addr,
+		       (unsigned long long)(addr + size - 1),
+		       (unsigned long long)p->start,
+		       (unsigned long long)p->end,
+		       p->name);
+		err = -1;
+		break;
+	}
+	read_unlock(&resource_lock);
+
+	return err;
+}
diff --git a/kernel/softirq.c b/kernel/softirq.c
index c506f26..be7a829 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -46,7 +46,7 @@ irq_cpustat_t irq_stat[NR_CPUS] ____cacheline_aligned;
 EXPORT_SYMBOL(irq_stat);
 #endif
 
-static struct softirq_action softirq_vec[32] __cacheline_aligned_in_smp;
+static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp;
 
 static DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
 
@@ -205,7 +205,18 @@ restart:
 
 	do {
 		if (pending & 1) {
+			int prev_count = preempt_count();
+
 			h->action(h);
+
+			if (unlikely(prev_count != preempt_count())) {
+				printk(KERN_ERR "huh, entered softirq %d %p"
+				       "with preempt_count %08x,"
+				       " exited with %08x?\n", h - softirq_vec,
+				       h->action, prev_count, preempt_count());
+				preempt_count() = prev_count;
+			}
+
 			rcu_bh_qsctr_inc(cpu);
 		}
 		h++;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index a4d2193..b711ffc 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -270,7 +270,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	next_jiffies = get_next_timer_interrupt(last_jiffies);
 	delta_jiffies = next_jiffies - last_jiffies;
 
-	if (rcu_needs_cpu(cpu))
+	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu))
 		delta_jiffies = 1;
 	/*
 	 * Do not stop the tick, if we are only one off
diff --git a/kernel/timer.c b/kernel/timer.c
index 03bc7f1..510fe69 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -978,6 +978,7 @@ void update_process_times(int user_tick)
 	run_local_timers();
 	if (rcu_pending(cpu))
 		rcu_check_callbacks(cpu, user_tick);
+	printk_tick();
 	scheduler_tick();
 	run_posix_cpu_timers(p);
 }
diff --git a/mm/Kconfig b/mm/Kconfig
index 0bd9c2d..91ee392 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -187,6 +187,9 @@ config RESOURCES_64BIT
 	help
 	  This option allows memory and IO resources to be 64 bit.
 
+config PHYS_ADDR_T_64BIT
+	def_bool 64BIT || ARCH_PHYS_ADDR_T_64BIT
+
 config ZONE_DMA_FLAG
 	int
 	default "0" if !ZONE_DMA
diff --git a/mm/filemap.c b/mm/filemap.c
index 876bc59..494ff20 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1100,8 +1100,9 @@ page_ok:
 
 page_not_up_to_date:
 		/* Get exclusive access to the page ... */
-		if (lock_page_killable(page))
-			goto readpage_eio;
+		error = lock_page_killable(page);
+		if (unlikely(error))
+			goto readpage_error;
 
 page_not_up_to_date_locked:
 		/* Did it get truncated before we got the lock? */
@@ -1130,8 +1131,9 @@ readpage:
 		}
 
 		if (!PageUptodate(page)) {
-			if (lock_page_killable(page))
-				goto readpage_eio;
+			error = lock_page_killable(page);
+			if (unlikely(error))
+				goto readpage_error;
 			if (!PageUptodate(page)) {
 				if (page->mapping == NULL) {
 					/*
@@ -1143,15 +1145,14 @@ readpage:
 				}
 				unlock_page(page);
 				shrink_readahead_size_eio(filp, ra);
-				goto readpage_eio;
+				error = -EIO;
+				goto readpage_error;
 			}
 			unlock_page(page);
 		}
 
 		goto page_ok;
 
-readpage_eio:
-		error = -EIO;
 readpage_error:
 		/* UHHUH! A synchronous read error occurred. Report it */
 		desc->error = error;
