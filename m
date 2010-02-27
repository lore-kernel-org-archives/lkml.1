Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968556Ab0B0QUQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:20:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35979 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968536Ab0B0QUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:20:13 -0500
Date: Sat, 27 Feb 2010 17:20:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] x86/mm changes for v2.6.34
Message-ID: <20100227162000.GA22346@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-mm-for-linus


out-of-topic modifications in x86-mm-for-linus:
-----------------------------------------------
arch/mips/mm/init.c                # 61ef248: resources: introduce generic page
arch/score/mm/init.c               # 61ef248: resources: introduce generic page
include/linux/mm.h                 # 53df8fd: Move page_is_ram() declaration to
kernel/resource.c                  # e527300: Generic page_is_ram: use __weak
                                   # 61ef248: resources: introduce generic page

 Thanks,

	Ingo

------------------>
Andrew Morton (1):
      Generic page_is_ram: use __weak

Ian Campbell (1):
      x86, mm: Allow highmem user page tables to be disabled at boot time

Pekka Enberg (1):
      x86, mm: Unify kernel_physical_mapping_init() API

Thadeu Lima de Souza Cascardo (1):
      x86: Do not reserve brk for DMI if it's not going to be used

Thomas Gleixner (1):
      x86: Convert tlbstate_lock to raw_spinlock

Wu Fengguang (3):
      resources: introduce generic page_is_ram()
      Move page_is_ram() declaration to mm.h
      x86: Use the generic page_is_ram()

Yinghai Lu (1):
      x86: Remove BIOS data range from e820


 Documentation/kernel-parameters.txt |    7 ++++++
 arch/mips/mm/init.c                 |    2 +-
 arch/score/mm/init.c                |    2 +-
 arch/x86/include/asm/page_types.h   |    1 -
 arch/x86/include/asm/pgalloc.h      |    5 ++++
 arch/x86/kernel/e820.c              |    8 +++++++
 arch/x86/kernel/setup.c             |   21 ++++++++++++++++++-
 arch/x86/mm/init.c                  |    7 ------
 arch/x86/mm/init_32.c               |    8 ++++--
 arch/x86/mm/ioremap.c               |   37 -----------------------------------
 arch/x86/mm/pgtable.c               |   31 ++++++++++++++++++++++++----
 arch/x86/mm/tlb.c                   |    8 +++---
 include/linux/mm.h                  |    2 +
 kernel/resource.c                   |   13 ++++++++++++
 14 files changed, 92 insertions(+), 60 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 736d456..67c69ff 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2694,6 +2694,13 @@ and is between 256 and 4096 characters. It is defined in the file
 					medium is write-protected).
 			Example: quirks=0419:aaf5:rl,0421:0433:rc
 
+	userpte=
+			[X86] Flags controlling user PTE allocations.
+
+				nohigh = do not allocate PTE pages in
+					HIGHMEM regardless of setting
+					of CONFIG_HIGHPTE.
+
 	vdso=		[X86,SH]
 			vdso=2: enable compat VDSO (default with COMPAT_VDSO)
 			vdso=1: enable VDSO (default)
diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 1651942..dee564a 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -298,7 +298,7 @@ void __init fixrange_init(unsigned long start, unsigned long end,
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-static int __init page_is_ram(unsigned long pagenr)
+int page_is_ram(unsigned long pagenr)
 {
 	int i;
 
diff --git a/arch/score/mm/init.c b/arch/score/mm/init.c
index dfaf458..7f001bb 100644
--- a/arch/score/mm/init.c
+++ b/arch/score/mm/init.c
@@ -59,7 +59,7 @@ static unsigned long setup_zero_page(void)
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-static int __init page_is_ram(unsigned long pagenr)
+int page_is_ram(unsigned long pagenr)
 {
 	if (pagenr >= min_low_pfn && pagenr < max_low_pfn)
 		return 1;
diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 642fe34..a667f24 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -40,7 +40,6 @@
 
 #ifndef __ASSEMBLY__
 
-extern int page_is_ram(unsigned long pagenr);
 extern int devmem_is_allowed(unsigned long pagenr);
 
 extern unsigned long max_low_pfn_mapped;
diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
index 0e8c2a0..271de94 100644
--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -23,6 +23,11 @@ static inline void paravirt_release_pud(unsigned long pfn) {}
 #endif
 
 /*
+ * Flags to use when allocating a user page table page.
+ */
+extern gfp_t __userpte_alloc_gfp;
+
+/*
  * Allocate and free page tables.
  */
 extern pgd_t *pgd_alloc(struct mm_struct *);
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index a1a7876..a966b75 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -517,11 +517,19 @@ u64 __init e820_remove_range(u64 start, u64 size, unsigned old_type,
 			     int checktype)
 {
 	int i;
+	u64 end;
 	u64 real_removed_size = 0;
 
 	if (size > (ULLONG_MAX - start))
 		size = ULLONG_MAX - start;
 
+	end = start + size;
+	printk(KERN_DEBUG "e820 remove range: %016Lx - %016Lx ",
+		       (unsigned long long) start,
+		       (unsigned long long) end);
+	e820_print_type(old_type);
+	printk(KERN_CONT "\n");
+
 	for (i = 0; i < e820.nr_map; i++) {
 		struct e820entry *ei = &e820.map[i];
 		u64 final_start, final_end;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 5d9e40c..cb42109 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -121,7 +121,9 @@
 unsigned long max_low_pfn_mapped;
 unsigned long max_pfn_mapped;
 
+#ifdef CONFIG_DMI
 RESERVE_BRK(dmi_alloc, 65536);
+#endif
 
 unsigned int boot_cpu_id __read_mostly;
 
@@ -667,6 +669,23 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
 	{}
 };
 
+static void __init trim_bios_range(void)
+{
+	/*
+	 * A special case is the first 4Kb of memory;
+	 * This is a BIOS owned area, not kernel ram, but generally
+	 * not listed as such in the E820 table.
+	 */
+	e820_update_range(0, PAGE_SIZE, E820_RAM, E820_RESERVED);
+	/*
+	 * special case: Some BIOSen report the PC BIOS
+	 * area (640->1Mb) as ram even though it is not.
+	 * take them out.
+	 */
+	e820_remove_range(BIOS_BEGIN, BIOS_END - BIOS_BEGIN, E820_RAM, 1);
+	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+}
+
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
@@ -830,7 +849,7 @@ void __init setup_arch(char **cmdline_p)
 	insert_resource(&iomem_resource, &data_resource);
 	insert_resource(&iomem_resource, &bss_resource);
 
-
+	trim_bios_range();
 #ifdef CONFIG_X86_32
 	if (ppro_with_ram_bug()) {
 		e820_update_range(0x70000000ULL, 0x40000ULL, E820_RAM,
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index d406c52..e71c5cb 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -266,16 +266,9 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	if (!after_bootmem)
 		find_early_table_space(end, use_pse, use_gbpages);
 
-#ifdef CONFIG_X86_32
-	for (i = 0; i < nr_range; i++)
-		kernel_physical_mapping_init(mr[i].start, mr[i].end,
-					     mr[i].page_size_mask);
-	ret = end;
-#else /* CONFIG_X86_64 */
 	for (i = 0; i < nr_range; i++)
 		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
 						   mr[i].page_size_mask);
-#endif
 
 #ifdef CONFIG_X86_32
 	early_ioremap_page_table_range_init();
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 9a0c258..2226f2c 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -241,6 +241,7 @@ kernel_physical_mapping_init(unsigned long start,
 			     unsigned long page_size_mask)
 {
 	int use_pse = page_size_mask == (1<<PG_LEVEL_2M);
+	unsigned long last_map_addr = end;
 	unsigned long start_pfn, end_pfn;
 	pgd_t *pgd_base = swapper_pg_dir;
 	int pgd_idx, pmd_idx, pte_ofs;
@@ -341,9 +342,10 @@ repeat:
 					prot = PAGE_KERNEL_EXEC;
 
 				pages_4k++;
-				if (mapping_iter == 1)
+				if (mapping_iter == 1) {
 					set_pte(pte, pfn_pte(pfn, init_prot));
-				else
+					last_map_addr = (pfn << PAGE_SHIFT) + PAGE_SIZE;
+				} else
 					set_pte(pte, pfn_pte(pfn, prot));
 			}
 		}
@@ -368,7 +370,7 @@ repeat:
 		mapping_iter = 2;
 		goto repeat;
 	}
-	return 0;
+	return last_map_addr;
 }
 
 pte_t *kmap_pte;
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index c246d25..e404ffe 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -24,43 +24,6 @@
 
 #include "physaddr.h"
 
-int page_is_ram(unsigned long pagenr)
-{
-	resource_size_t addr, end;
-	int i;
-
-	/*
-	 * A special case is the first 4Kb of memory;
-	 * This is a BIOS owned area, not kernel ram, but generally
-	 * not listed as such in the E820 table.
-	 */
-	if (pagenr == 0)
-		return 0;
-
-	/*
-	 * Second special case: Some BIOSen report the PC BIOS
-	 * area (640->1Mb) as ram even though it is not.
-	 */
-	if (pagenr >= (BIOS_BEGIN >> PAGE_SHIFT) &&
-		    pagenr < (BIOS_END >> PAGE_SHIFT))
-		return 0;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		/*
-		 * Not usable memory:
-		 */
-		if (e820.map[i].type != E820_RAM)
-			continue;
-		addr = (e820.map[i].addr + PAGE_SIZE-1) >> PAGE_SHIFT;
-		end = (e820.map[i].addr + e820.map[i].size) >> PAGE_SHIFT;
-
-
-		if ((pagenr >= addr) && (pagenr < end))
-			return 1;
-	}
-	return 0;
-}
-
 /*
  * Fix up the linear direct mapping of the kernel to avoid cache attribute
  * conflicts.
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index ed34f5e..c9ba9de 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -6,6 +6,14 @@
 
 #define PGALLOC_GFP GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO
 
+#ifdef CONFIG_HIGHPTE
+#define PGALLOC_USER_GFP __GFP_HIGHMEM
+#else
+#define PGALLOC_USER_GFP 0
+#endif
+
+gfp_t __userpte_alloc_gfp = PGALLOC_GFP | PGALLOC_USER_GFP;
+
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
 	return (pte_t *)__get_free_page(PGALLOC_GFP);
@@ -15,16 +23,29 @@ pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address)
 {
 	struct page *pte;
 
-#ifdef CONFIG_HIGHPTE
-	pte = alloc_pages(PGALLOC_GFP | __GFP_HIGHMEM, 0);
-#else
-	pte = alloc_pages(PGALLOC_GFP, 0);
-#endif
+	pte = alloc_pages(__userpte_alloc_gfp, 0);
 	if (pte)
 		pgtable_page_ctor(pte);
 	return pte;
 }
 
+static int __init setup_userpte(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	/*
+	 * "userpte=nohigh" disables allocation of user pagetables in
+	 * high memory.
+	 */
+	if (strcmp(arg, "nohigh") == 0)
+		__userpte_alloc_gfp &= ~__GFP_HIGHMEM;
+	else
+		return -EINVAL;
+	return 0;
+}
+early_param("userpte", setup_userpte);
+
 void ___pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
 {
 	pgtable_page_dtor(pte);
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 65b58e4..426f3a1 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -41,7 +41,7 @@ union smp_flush_state {
 	struct {
 		struct mm_struct *flush_mm;
 		unsigned long flush_va;
-		spinlock_t tlbstate_lock;
+		raw_spinlock_t tlbstate_lock;
 		DECLARE_BITMAP(flush_cpumask, NR_CPUS);
 	};
 	char pad[INTERNODE_CACHE_BYTES];
@@ -181,7 +181,7 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
 	 * num_online_cpus() <= NUM_INVALIDATE_TLB_VECTORS, but it is
 	 * probably not worth checking this for a cache-hot lock.
 	 */
-	spin_lock(&f->tlbstate_lock);
+	raw_spin_lock(&f->tlbstate_lock);
 
 	f->flush_mm = mm;
 	f->flush_va = va;
@@ -199,7 +199,7 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
 
 	f->flush_mm = NULL;
 	f->flush_va = 0;
-	spin_unlock(&f->tlbstate_lock);
+	raw_spin_unlock(&f->tlbstate_lock);
 }
 
 void native_flush_tlb_others(const struct cpumask *cpumask,
@@ -223,7 +223,7 @@ static int __cpuinit init_smp_flush(void)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(flush_state); i++)
-		spin_lock_init(&flush_state[i].tlbstate_lock);
+		raw_spin_lock_init(&flush_state[i].tlbstate_lock);
 
 	return 0;
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 60c467b..8b2fa85 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -265,6 +265,8 @@ static inline int get_page_unless_zero(struct page *page)
 	return atomic_inc_not_zero(&page->_count);
 }
 
+extern int page_is_ram(unsigned long pfn);
+
 /* Support for virtually mapped pages */
 struct page *vmalloc_to_page(const void *addr);
 unsigned long vmalloc_to_pfn(const void *addr);
diff --git a/kernel/resource.c b/kernel/resource.c
index af96c1e..03c897f 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -297,6 +297,19 @@ int walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 
 #endif
 
+static int __is_ram(unsigned long pfn, unsigned long nr_pages, void *arg)
+{
+	return 1;
+}
+/*
+ * This generic page_is_ram() returns true if specified address is
+ * registered as "System RAM" in iomem_resource list.
+ */
+int __weak page_is_ram(unsigned long pfn)
+{
+	return walk_system_ram_range(pfn, 1, NULL, __is_ram) == 1;
+}
+
 /*
  * Find empty slot in the resource tree given range and alignment.
  */
