Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbZASXX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbZASXX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 18:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbZASXXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:23:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60643 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbZASXXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:23:17 -0500
Date: Tue, 20 Jan 2009 00:23:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20090119232306.GA22601@elte.hu>
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

it also includes workqueue.c fixes to work_on_cpu() which were triggered 
by cpumask conversion changes.

out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
include/asm-generic/bitops/__ffs.h # c839994: x86, generic: mark complex bitops
include/asm-generic/bitops/__fls.h # c839994: x86, generic: mark complex bitops
include/asm-generic/bitops/fls.h   # c839994: x86, generic: mark complex bitops
include/asm-generic/bitops/fls64.h # c839994: x86, generic: mark complex bitops
kernel/workqueue.c                 # 8ccad40: work_on_cpu: Use our own workqueu
                                   # 31ad908: work_on_cpu: don't try to get_onl

 Thanks,

	Ingo

------------------>
Andi Kleen (1):
      x86, generic: mark complex bitops.h inlines as __always_inline

Cliff Wickman (1):
      x86, UV: cpu_relax in uv_wait_completion

Ingo Molnar (2):
      x86, cpufreq: remove leftover copymask_copy()
      fix: crash: IP: __bitmap_intersects+0x48/0x73

Jan Beulich (2):
      x86: avoid early crash in disable_local_APIC()
      x86: fix assumed to be contiguous leaf page tables for kmap_atomic region (take 2)

Jeff Mahoney (1):
      x86: define ARCH_WANT_FRAME_POINTERS

Leonardo Potenza (1):
      x86: fix section mismatch warnings in kernel/setup_percpu.c

Mike Travis (2):
      x86: put trigger in to detect mismatched apic versions
      cpufreq: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write

Rusty Russell (2):
      work_on_cpu: don't try to get_online_cpus() in work_on_cpu.
      work_on_cpu: Use our own workqueue.

Suresh Siddha (1):
      x86, pat: fix reserve_memtype() for legacy 1MB range


 arch/x86/include/asm/bitops.h              |   14 ++++++--
 arch/x86/include/asm/io.h                  |    1 -
 arch/x86/kernel/apic.c                     |    9 +++++
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   35 +++++++-------------
 arch/x86/kernel/setup_percpu.c             |    2 +-
 arch/x86/kernel/tlb_uv.c                   |    1 +
 arch/x86/mm/init_32.c                      |   48 ++++++++++++++++++++++++++--
 arch/x86/mm/ioremap.c                      |   25 --------------
 arch/x86/mm/pat.c                          |   37 +++++++++++++++------
 include/asm-generic/bitops/__ffs.h         |    2 +-
 include/asm-generic/bitops/__fls.h         |    2 +-
 include/asm-generic/bitops/fls.h           |    2 +-
 include/asm-generic/bitops/fls64.h         |    4 +-
 kernel/workqueue.c                         |   20 ++++++------
 lib/Kconfig.debug                          |    9 +++++
 15 files changed, 130 insertions(+), 81 deletions(-)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index e02a359..02b47a6 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -3,6 +3,9 @@
 
 /*
  * Copyright 1992, Linus Torvalds.
+ *
+ * Note: inlines with more than a single statement should be marked
+ * __always_inline to avoid problems with older gcc's inlining heuristics.
  */
 
 #ifndef _LINUX_BITOPS_H
@@ -53,7 +56,8 @@
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void set_bit(unsigned int nr, volatile unsigned long *addr)
+static __always_inline void
+set_bit(unsigned int nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "orb %1,%0"
@@ -90,7 +94,8 @@ static inline void __set_bit(int nr, volatile unsigned long *addr)
  * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
  * in order to ensure changes are visible on other processors.
  */
-static inline void clear_bit(int nr, volatile unsigned long *addr)
+static __always_inline void
+clear_bit(int nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "andb %1,%0"
@@ -204,7 +209,8 @@ static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
  *
  * This is the same as test_and_set_bit on x86.
  */
-static inline int test_and_set_bit_lock(int nr, volatile unsigned long *addr)
+static __always_inline int
+test_and_set_bit_lock(int nr, volatile unsigned long *addr)
 {
 	return test_and_set_bit(nr, addr);
 }
@@ -300,7 +306,7 @@ static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
 	return oldbit;
 }
 
-static inline int constant_test_bit(unsigned int nr, const volatile unsigned long *addr)
+static __always_inline int constant_test_bit(unsigned int nr, const volatile unsigned long *addr)
 {
 	return ((1UL << (nr % BITS_PER_LONG)) &
 		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 05cfed4..1dbbdf4 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -99,7 +99,6 @@ extern void __iomem *ioremap_wc(unsigned long offset, unsigned long size);
  * A boot-time mapping is currently limited to at most 16 pages.
  */
 extern void early_ioremap_init(void);
-extern void early_ioremap_clear(void);
 extern void early_ioremap_reset(void);
 extern void __iomem *early_ioremap(unsigned long offset, unsigned long size);
 extern void __iomem *early_memremap(unsigned long offset, unsigned long size);
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 0f830e4..4b6df24 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -895,6 +895,10 @@ void disable_local_APIC(void)
 {
 	unsigned int value;
 
+	/* APIC hasn't been mapped yet */
+	if (!apic_phys)
+		return;
+
 	clear_local_APIC();
 
 	/*
@@ -1833,6 +1837,11 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	num_processors++;
 	cpu = cpumask_next_zero(-1, cpu_present_mask);
 
+	if (version != apic_version[boot_cpu_physical_apicid])
+		WARN_ONCE(1,
+			"ACPI: apic version mismatch, bootcpu: %x cpu %d: %x\n",
+			apic_version[boot_cpu_physical_apicid], cpu, version);
+
 	physid_set(apicid, phys_cpu_present_map);
 	if (apicid == boot_cpu_physical_apicid) {
 		/*
diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 6f11e02..4b1c319 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -145,13 +145,14 @@ typedef union {
 
 struct drv_cmd {
 	unsigned int type;
-	cpumask_var_t mask;
+	const struct cpumask *mask;
 	drv_addr_union addr;
 	u32 val;
 };
 
-static void do_drv_read(struct drv_cmd *cmd)
+static long do_drv_read(void *_cmd)
 {
+	struct drv_cmd *cmd = _cmd;
 	u32 h;
 
 	switch (cmd->type) {
@@ -166,10 +167,12 @@ static void do_drv_read(struct drv_cmd *cmd)
 	default:
 		break;
 	}
+	return 0;
 }
 
-static void do_drv_write(struct drv_cmd *cmd)
+static long do_drv_write(void *_cmd)
 {
+	struct drv_cmd *cmd = _cmd;
 	u32 lo, hi;
 
 	switch (cmd->type) {
@@ -186,30 +189,23 @@ static void do_drv_write(struct drv_cmd *cmd)
 	default:
 		break;
 	}
+	return 0;
 }
 
 static void drv_read(struct drv_cmd *cmd)
 {
-	cpumask_t saved_mask = current->cpus_allowed;
 	cmd->val = 0;
 
-	set_cpus_allowed_ptr(current, cmd->mask);
-	do_drv_read(cmd);
-	set_cpus_allowed_ptr(current, &saved_mask);
+	work_on_cpu(cpumask_any(cmd->mask), do_drv_read, cmd);
 }
 
 static void drv_write(struct drv_cmd *cmd)
 {
-	cpumask_t saved_mask = current->cpus_allowed;
 	unsigned int i;
 
 	for_each_cpu(i, cmd->mask) {
-		set_cpus_allowed_ptr(current, cpumask_of(i));
-		do_drv_write(cmd);
+		work_on_cpu(i, do_drv_write, cmd);
 	}
-
-	set_cpus_allowed_ptr(current, &saved_mask);
-	return;
 }
 
 static u32 get_cur_val(const struct cpumask *mask)
@@ -235,8 +231,7 @@ static u32 get_cur_val(const struct cpumask *mask)
 		return 0;
 	}
 
-	cpumask_copy(cmd.mask, mask);
-
+	cmd.mask = mask;
 	drv_read(&cmd);
 
 	dprintk("get_cur_val = %u\n", cmd.val);
@@ -368,7 +363,7 @@ static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
 	return freq;
 }
 
-static unsigned int check_freqs(const cpumask_t *mask, unsigned int freq,
+static unsigned int check_freqs(const struct cpumask *mask, unsigned int freq,
 				struct acpi_cpufreq_data *data)
 {
 	unsigned int cur_freq;
@@ -403,9 +398,6 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 		return -ENODEV;
 	}
 
-	if (unlikely(!alloc_cpumask_var(&cmd.mask, GFP_KERNEL)))
-		return -ENOMEM;
-
 	perf = data->acpi_data;
 	result = cpufreq_frequency_table_target(policy,
 						data->freq_table,
@@ -450,9 +442,9 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 
 	/* cpufreq holds the hotplug lock, so we are safe from here on */
 	if (policy->shared_type != CPUFREQ_SHARED_TYPE_ANY)
-		cpumask_and(cmd.mask, cpu_online_mask, policy->cpus);
+		cmd.mask = policy->cpus;
 	else
-		cpumask_copy(cmd.mask, cpumask_of(policy->cpu));
+		cmd.mask = cpumask_of(policy->cpu);
 
 	freqs.old = perf->states[perf->state].core_frequency * 1000;
 	freqs.new = data->freq_table[next_state].frequency;
@@ -479,7 +471,6 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 	perf->state = next_perf_state;
 
 out:
-	free_cpumask_var(cmd.mask);
 	return result;
 }
 
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 55c4607..0116107 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -136,7 +136,7 @@ static void __init setup_cpu_pda_map(void)
 #ifdef CONFIG_X86_64
 
 /* correctly size the local cpu masks */
-static void setup_cpu_local_masks(void)
+static void __init setup_cpu_local_masks(void)
 {
 	alloc_bootmem_cpumask_var(&cpu_initialized_mask);
 	alloc_bootmem_cpumask_var(&cpu_callin_mask);
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index f885023..6812b82 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -200,6 +200,7 @@ static int uv_wait_completion(struct bau_desc *bau_desc,
 				destination_timeouts = 0;
 			}
 		}
+		cpu_relax();
 	}
 	return FLUSH_COMPLETE;
 }
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 88f1b10..2cef050 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -138,6 +138,47 @@ static pte_t * __init one_page_table_init(pmd_t *pmd)
 	return pte_offset_kernel(pmd, 0);
 }
 
+static pte_t *__init page_table_kmap_check(pte_t *pte, pmd_t *pmd,
+					   unsigned long vaddr, pte_t *lastpte)
+{
+#ifdef CONFIG_HIGHMEM
+	/*
+	 * Something (early fixmap) may already have put a pte
+	 * page here, which causes the page table allocation
+	 * to become nonlinear. Attempt to fix it, and if it
+	 * is still nonlinear then we have to bug.
+	 */
+	int pmd_idx_kmap_begin = fix_to_virt(FIX_KMAP_END) >> PMD_SHIFT;
+	int pmd_idx_kmap_end = fix_to_virt(FIX_KMAP_BEGIN) >> PMD_SHIFT;
+
+	if (pmd_idx_kmap_begin != pmd_idx_kmap_end
+	    && (vaddr >> PMD_SHIFT) >= pmd_idx_kmap_begin
+	    && (vaddr >> PMD_SHIFT) <= pmd_idx_kmap_end
+	    && ((__pa(pte) >> PAGE_SHIFT) < table_start
+		|| (__pa(pte) >> PAGE_SHIFT) >= table_end)) {
+		pte_t *newpte;
+		int i;
+
+		BUG_ON(after_init_bootmem);
+		newpte = alloc_low_page();
+		for (i = 0; i < PTRS_PER_PTE; i++)
+			set_pte(newpte + i, pte[i]);
+
+		paravirt_alloc_pte(&init_mm, __pa(newpte) >> PAGE_SHIFT);
+		set_pmd(pmd, __pmd(__pa(newpte)|_PAGE_TABLE));
+		BUG_ON(newpte != pte_offset_kernel(pmd, 0));
+		__flush_tlb_all();
+
+		paravirt_release_pte(__pa(pte) >> PAGE_SHIFT);
+		pte = newpte;
+	}
+	BUG_ON(vaddr < fix_to_virt(FIX_KMAP_BEGIN - 1)
+	       && vaddr > fix_to_virt(FIX_KMAP_END)
+	       && lastpte && lastpte + PTRS_PER_PTE != pte);
+#endif
+	return pte;
+}
+
 /*
  * This function initializes a certain range of kernel virtual memory
  * with new bootmem page tables, everywhere page tables are missing in
@@ -154,6 +195,7 @@ page_table_range_init(unsigned long start, unsigned long end, pgd_t *pgd_base)
 	unsigned long vaddr;
 	pgd_t *pgd;
 	pmd_t *pmd;
+	pte_t *pte = NULL;
 
 	vaddr = start;
 	pgd_idx = pgd_index(vaddr);
@@ -165,7 +207,8 @@ page_table_range_init(unsigned long start, unsigned long end, pgd_t *pgd_base)
 		pmd = pmd + pmd_index(vaddr);
 		for (; (pmd_idx < PTRS_PER_PMD) && (vaddr != end);
 							pmd++, pmd_idx++) {
-			one_page_table_init(pmd);
+			pte = page_table_kmap_check(one_page_table_init(pmd),
+			                            pmd, vaddr, pte);
 
 			vaddr += PMD_SIZE;
 		}
@@ -508,7 +551,6 @@ static void __init early_ioremap_page_table_range_init(pgd_t *pgd_base)
 	 * Fixed mappings, only the page table structure has to be
 	 * created - mappings will be set by set_fixmap():
 	 */
-	early_ioremap_clear();
 	vaddr = __fix_to_virt(__end_of_fixed_addresses - 1) & PMD_MASK;
 	end = (FIXADDR_TOP + PMD_SIZE - 1) & PMD_MASK;
 	page_table_range_init(vaddr, end, pgd_base);
@@ -801,7 +843,7 @@ static void __init find_early_table_space(unsigned long end, int use_pse)
 	tables += PAGE_ALIGN(ptes * sizeof(pte_t));
 
 	/* for fixmap */
-	tables += PAGE_SIZE * 2;
+	tables += PAGE_ALIGN(__end_of_fixed_addresses * sizeof(pte_t));
 
 	/*
 	 * RED-PEN putting page tables only on node 0 could
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index bd85d42..af750ab 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -557,34 +557,9 @@ void __init early_ioremap_init(void)
 	}
 }
 
-void __init early_ioremap_clear(void)
-{
-	pmd_t *pmd;
-
-	if (early_ioremap_debug)
-		printk(KERN_INFO "early_ioremap_clear()\n");
-
-	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
-	pmd_clear(pmd);
-	paravirt_release_pte(__pa(bm_pte) >> PAGE_SHIFT);
-	__flush_tlb_all();
-}
-
 void __init early_ioremap_reset(void)
 {
-	enum fixed_addresses idx;
-	unsigned long addr, phys;
-	pte_t *pte;
-
 	after_paging_init = 1;
-	for (idx = FIX_BTMAP_BEGIN; idx >= FIX_BTMAP_END; idx--) {
-		addr = fix_to_virt(idx);
-		pte = early_ioremap_pte(addr);
-		if (pte_present(*pte)) {
-			phys = pte_val(*pte) & PAGE_MASK;
-			set_fixmap(idx, phys);
-		}
-	}
 }
 
 static void __init __early_set_fixmap(enum fixed_addresses idx,
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 85cbd3c..070ee4a 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -333,11 +333,20 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 					      req_type & _PAGE_CACHE_MASK);
 	}
 
-	is_range_ram = pagerange_is_ram(start, end);
-	if (is_range_ram == 1)
-		return reserve_ram_pages_type(start, end, req_type, new_type);
-	else if (is_range_ram < 0)
-		return -EINVAL;
+	/*
+	 * For legacy reasons, some parts of the physical address range in the
+	 * legacy 1MB region is treated as non-RAM (even when listed as RAM in
+	 * the e820 tables).  So we will track the memory attributes of this
+	 * legacy 1MB region using the linear memtype_list always.
+	 */
+	if (end >= ISA_END_ADDRESS) {
+		is_range_ram = pagerange_is_ram(start, end);
+		if (is_range_ram == 1)
+			return reserve_ram_pages_type(start, end, req_type,
+						      new_type);
+		else if (is_range_ram < 0)
+			return -EINVAL;
+	}
 
 	new  = kmalloc(sizeof(struct memtype), GFP_KERNEL);
 	if (!new)
@@ -437,11 +446,19 @@ int free_memtype(u64 start, u64 end)
 	if (is_ISA_range(start, end - 1))
 		return 0;
 
-	is_range_ram = pagerange_is_ram(start, end);
-	if (is_range_ram == 1)
-		return free_ram_pages_type(start, end);
-	else if (is_range_ram < 0)
-		return -EINVAL;
+	/*
+	 * For legacy reasons, some parts of the physical address range in the
+	 * legacy 1MB region is treated as non-RAM (even when listed as RAM in
+	 * the e820 tables).  So we will track the memory attributes of this
+	 * legacy 1MB region using the linear memtype_list always.
+	 */
+	if (end >= ISA_END_ADDRESS) {
+		is_range_ram = pagerange_is_ram(start, end);
+		if (is_range_ram == 1)
+			return free_ram_pages_type(start, end);
+		else if (is_range_ram < 0)
+			return -EINVAL;
+	}
 
 	spin_lock(&memtype_lock);
 	list_for_each_entry(entry, &memtype_list, nd) {
diff --git a/include/asm-generic/bitops/__ffs.h b/include/asm-generic/bitops/__ffs.h
index 9a3274a..937d7c4 100644
--- a/include/asm-generic/bitops/__ffs.h
+++ b/include/asm-generic/bitops/__ffs.h
@@ -9,7 +9,7 @@
  *
  * Undefined if no bit exists, so code should check against 0 first.
  */
-static inline unsigned long __ffs(unsigned long word)
+static __always_inline unsigned long __ffs(unsigned long word)
 {
 	int num = 0;
 
diff --git a/include/asm-generic/bitops/__fls.h b/include/asm-generic/bitops/__fls.h
index be24465..a60a7cc 100644
--- a/include/asm-generic/bitops/__fls.h
+++ b/include/asm-generic/bitops/__fls.h
@@ -9,7 +9,7 @@
  *
  * Undefined if no set bit exists, so code should check against 0 first.
  */
-static inline unsigned long __fls(unsigned long word)
+static __always_inline unsigned long __fls(unsigned long word)
 {
 	int num = BITS_PER_LONG - 1;
 
diff --git a/include/asm-generic/bitops/fls.h b/include/asm-generic/bitops/fls.h
index 850859b..0576d1f 100644
--- a/include/asm-generic/bitops/fls.h
+++ b/include/asm-generic/bitops/fls.h
@@ -9,7 +9,7 @@
  * Note fls(0) = 0, fls(1) = 1, fls(0x80000000) = 32.
  */
 
-static inline int fls(int x)
+static __always_inline int fls(int x)
 {
 	int r = 32;
 
diff --git a/include/asm-generic/bitops/fls64.h b/include/asm-generic/bitops/fls64.h
index 86d403f..b097cf8 100644
--- a/include/asm-generic/bitops/fls64.h
+++ b/include/asm-generic/bitops/fls64.h
@@ -15,7 +15,7 @@
  * at position 64.
  */
 #if BITS_PER_LONG == 32
-static inline int fls64(__u64 x)
+static __always_inline int fls64(__u64 x)
 {
 	__u32 h = x >> 32;
 	if (h)
@@ -23,7 +23,7 @@ static inline int fls64(__u64 x)
 	return fls(x);
 }
 #elif BITS_PER_LONG == 64
-static inline int fls64(__u64 x)
+static __always_inline int fls64(__u64 x)
 {
 	if (x == 0)
 		return 0;
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2f44583..1f0c509 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -971,6 +971,8 @@ undo:
 }
 
 #ifdef CONFIG_SMP
+static struct workqueue_struct *work_on_cpu_wq __read_mostly;
+
 struct work_for_cpu {
 	struct work_struct work;
 	long (*fn)(void *);
@@ -991,8 +993,8 @@ static void do_work_for_cpu(struct work_struct *w)
  * @fn: the function to run
  * @arg: the function arg
  *
- * This will return -EINVAL in the cpu is not online, or the return value
- * of @fn otherwise.
+ * This will return the value @fn returns.
+ * It is up to the caller to ensure that the cpu doesn't go offline.
  */
 long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 {
@@ -1001,14 +1003,8 @@ long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 	INIT_WORK(&wfc.work, do_work_for_cpu);
 	wfc.fn = fn;
 	wfc.arg = arg;
-	get_online_cpus();
-	if (unlikely(!cpu_online(cpu)))
-		wfc.ret = -EINVAL;
-	else {
-		schedule_work_on(cpu, &wfc.work);
-		flush_work(&wfc.work);
-	}
-	put_online_cpus();
+	queue_work_on(cpu, work_on_cpu_wq, &wfc.work);
+	flush_work(&wfc.work);
 
 	return wfc.ret;
 }
@@ -1025,4 +1021,8 @@ void __init init_workqueues(void)
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
+#ifdef CONFIG_SMP
+	work_on_cpu_wq = create_workqueue("work_on_cpu");
+	BUG_ON(!work_on_cpu_wq);
+#endif
 }
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 4c9ae60..d30561d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -570,6 +570,15 @@ config DEBUG_NOTIFIERS
 	  This is a relatively cheap check but if you care about maximum
 	  performance, say N.
 
+#
+# Select this config option from the architecture Kconfig, if it
+# it is preferred to always offer frame pointers as a config
+# option on the architecture (regardless of KERNEL_DEBUG):
+#
+config ARCH_WANT_FRAME_POINTERS
+	bool
+	help
+
 config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
 	depends on DEBUG_KERNEL && \
