Return-Path: <linux-kernel-owner+w=401wt.eu-S1760669AbZFZTIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669AbZFZTIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 15:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZFZTIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 15:08:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38616 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbZFZTIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:08:39 -0400
Date: Fri, 26 Jun 2009 21:07:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20090626190751.GA2732@elte.hu>
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

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
include/linux/kernel.h             # 5211a24: x86: Add sysctl to allow panic on
kernel/sysctl.c                    # 5211a24: x86: Add sysctl to allow panic on
mm/percpu.c                        # fa8a709: x86: implement percpu_alloc kerne
                                   # 85ae87c: percpu: fix too lazy vunmap cache

This is somewhat larger than usual due to the somewhat late 
percpu/PAT fixes.

 Thanks,

	Ingo

------------------>
Andreas Herrmann (1):
      x86: Set cpu_llc_id on AMD CPUs

Cliff Wickman (1):
      x86: Fix uv bau sending buffer initialization

H. Peter Anvin (1):
      x86, setup: correct include file in <asm/boot.h>

Hidetoshi Seto (2):
      x86, mce: Fix mce resume on 32bit
      x86, mce: percpu mcheck_timer should be pinned

Kurt Garloff (1):
      x86: Add sysctl to allow panic on IOCK NMI error

Pallipadi, Venkatesh (1):
      x86, delay: tsc based udelay should have rdtsc_barrier

Pekka J Enberg (1):
      x86: Move init_gbpages() to setup_arch()

Robert P. J. Day (1):
      x86, setup: Fix typo "CONFIG_x86_64" in <asm/boot.h>

Tejun Heo (8):
      percpu: fix too lazy vunmap cache flushing
      x86: fix duplicate free in setup_pcpu_remap() failure path
      x86: rename remap percpu first chunk allocator to lpage
      x86: prepare setup_pcpu_lpage() for pageattr fix
      x86: reorganize cpa_process_alias()
      x86: fix pageattr handling for lpage percpu allocator and re-enable it
      x86: implement percpu_alloc kernel parameter
      x86: ensure percpu lpage doesn't consume too much vmalloc space


 Documentation/kernel-parameters.txt |    6 +
 arch/x86/include/asm/boot.h         |    6 +-
 arch/x86/include/asm/percpu.h       |   10 ++
 arch/x86/kernel/cpu/amd.c           |    4 +-
 arch/x86/kernel/cpu/mcheck/mce.c    |    4 +-
 arch/x86/kernel/dumpstack.c         |    1 +
 arch/x86/kernel/setup.c             |   16 +++
 arch/x86/kernel/setup_percpu.c      |  219 ++++++++++++++++++++++++++---------
 arch/x86/kernel/tlb_uv.c            |    9 +-
 arch/x86/kernel/traps.c             |    3 +
 arch/x86/lib/delay.c                |    3 +
 arch/x86/mm/init.c                  |   17 ---
 arch/x86/mm/pageattr.c              |   65 +++++++----
 arch/x86/power/cpu.c                |    2 +-
 include/linux/kernel.h              |    1 +
 kernel/sysctl.c                     |    8 ++
 mm/percpu.c                         |   24 +++--
 17 files changed, 275 insertions(+), 123 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 08def8d..ecad946 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1882,6 +1882,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			Format: { 0 | 1 }
 			See arch/parisc/kernel/pdc_chassis.c
 
+	percpu_alloc=	[X86] Select which percpu first chunk allocator to use.
+			Allowed values are one of "lpage", "embed" and "4k".
+			See comments in arch/x86/kernel/setup_percpu.c for
+			details on each allocator.  This parameter is primarily
+			for debugging and performance comparison.
+
 	pf.		[PARIDE]
 			See Documentation/blockdev/paride.txt.
 
diff --git a/arch/x86/include/asm/boot.h b/arch/x86/include/asm/boot.h
index 418e632..7a10659 100644
--- a/arch/x86/include/asm/boot.h
+++ b/arch/x86/include/asm/boot.h
@@ -8,7 +8,7 @@
 
 #ifdef __KERNEL__
 
-#include <asm/page_types.h>
+#include <asm/pgtable_types.h>
 
 /* Physical address where kernel should be loaded. */
 #define LOAD_PHYSICAL_ADDR ((CONFIG_PHYSICAL_START \
@@ -16,10 +16,10 @@
 				& ~(CONFIG_PHYSICAL_ALIGN - 1))
 
 /* Minimum kernel alignment, as a power of two */
-#ifdef CONFIG_x86_64
+#ifdef CONFIG_X86_64
 #define MIN_KERNEL_ALIGN_LG2	PMD_SHIFT
 #else
-#define MIN_KERNEL_ALIGN_LG2	(PAGE_SHIFT+1)
+#define MIN_KERNEL_ALIGN_LG2	(PAGE_SHIFT + THREAD_ORDER)
 #endif
 #define MIN_KERNEL_ALIGN	(_AC(1, UL) << MIN_KERNEL_ALIGN_LG2)
 
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 02ecb30..103f1dd 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -42,6 +42,7 @@
 
 #else /* ...!ASSEMBLY */
 
+#include <linux/kernel.h>
 #include <linux/stringify.h>
 
 #ifdef CONFIG_SMP
@@ -155,6 +156,15 @@ do {							\
 /* We can use this directly for local CPU (faster). */
 DECLARE_PER_CPU(unsigned long, this_cpu_off);
 
+#ifdef CONFIG_NEED_MULTIPLE_NODES
+void *pcpu_lpage_remapped(void *kaddr);
+#else
+static inline void *pcpu_lpage_remapped(void *kaddr)
+{
+	return NULL;
+}
+#endif
+
 #endif /* !__ASSEMBLY__ */
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index e5b27d8..28e5f59 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -258,13 +258,15 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_HT
 	unsigned bits;
+	int cpu = smp_processor_id();
 
 	bits = c->x86_coreid_bits;
-
 	/* Low order bits define the core id (index of core in socket) */
 	c->cpu_core_id = c->initial_apicid & ((1 << bits)-1);
 	/* Convert the initial APIC ID into the socket ID */
 	c->phys_proc_id = c->initial_apicid >> bits;
+	/* use socket ID also for last level cache */
+	per_cpu(cpu_llc_id, cpu) = c->phys_proc_id;
 #endif
 }
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 284d1de..af425b8 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1117,7 +1117,7 @@ static void mcheck_timer(unsigned long data)
 		*n = min(*n*2, (int)round_jiffies_relative(check_interval*HZ));
 
 	t->expires = jiffies + *n;
-	add_timer(t);
+	add_timer_on(t, smp_processor_id());
 }
 
 static void mce_do_trigger(struct work_struct *work)
@@ -1321,7 +1321,7 @@ static void mce_init_timer(void)
 		return;
 	setup_timer(t, mcheck_timer, smp_processor_id());
 	t->expires = round_jiffies(jiffies + *n);
-	add_timer(t);
+	add_timer_on(t, smp_processor_id());
 }
 
 /*
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 95ea5fa..c840571 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -22,6 +22,7 @@
 #include "dumpstack.h"
 
 int panic_on_unrecovered_nmi;
+int panic_on_io_nmi;
 unsigned int code_bytes = 64;
 int kstack_depth_to_print = 3 * STACKSLOTS_PER_LINE;
 static int die_counter;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index be5ae80..de2cab1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -289,6 +289,20 @@ void * __init extend_brk(size_t size, size_t align)
 	return ret;
 }
 
+#ifdef CONFIG_X86_64
+static void __init init_gbpages(void)
+{
+	if (direct_gbpages && cpu_has_gbpages)
+		printk(KERN_INFO "Using GB pages for direct mapping\n");
+	else
+		direct_gbpages = 0;
+}
+#else
+static inline void init_gbpages(void)
+{
+}
+#endif
+
 static void __init reserve_brk(void)
 {
 	if (_brk_end > _brk_start)
@@ -871,6 +885,8 @@ void __init setup_arch(char **cmdline_p)
 
 	reserve_brk();
 
+	init_gbpages();
+
 	/* max_pfn_mapped is updated here */
 	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
 	max_pfn_mapped = max_low_pfn_mapped;
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 9c3f082..29a3eef 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -124,7 +124,7 @@ static void * __init pcpu_alloc_bootmem(unsigned int cpu, unsigned long size,
 }
 
 /*
- * Remap allocator
+ * Large page remap allocator
  *
  * This allocator uses PMD page as unit.  A PMD page is allocated for
  * each cpu and each is remapped into vmalloc area using PMD mapping.
@@ -137,105 +137,185 @@ static void * __init pcpu_alloc_bootmem(unsigned int cpu, unsigned long size,
  * better than only using 4k mappings while still being NUMA friendly.
  */
 #ifdef CONFIG_NEED_MULTIPLE_NODES
-static size_t pcpur_size __initdata;
-static void **pcpur_ptrs __initdata;
+struct pcpul_ent {
+	unsigned int	cpu;
+	void		*ptr;
+};
+
+static size_t pcpul_size;
+static struct pcpul_ent *pcpul_map;
+static struct vm_struct pcpul_vm;
 
-static struct page * __init pcpur_get_page(unsigned int cpu, int pageno)
+static struct page * __init pcpul_get_page(unsigned int cpu, int pageno)
 {
 	size_t off = (size_t)pageno << PAGE_SHIFT;
 
-	if (off >= pcpur_size)
+	if (off >= pcpul_size)
 		return NULL;
 
-	return virt_to_page(pcpur_ptrs[cpu] + off);
+	return virt_to_page(pcpul_map[cpu].ptr + off);
 }
 
-static ssize_t __init setup_pcpu_remap(size_t static_size)
+static ssize_t __init setup_pcpu_lpage(size_t static_size, bool chosen)
 {
-	static struct vm_struct vm;
-	size_t ptrs_size, dyn_size;
+	size_t map_size, dyn_size;
 	unsigned int cpu;
+	int i, j;
 	ssize_t ret;
 
-	/*
-	 * If large page isn't supported, there's no benefit in doing
-	 * this.  Also, on non-NUMA, embedding is better.
-	 *
-	 * NOTE: disabled for now.
-	 */
-	if (true || !cpu_has_pse || !pcpu_need_numa())
+	if (!chosen) {
+		size_t vm_size = VMALLOC_END - VMALLOC_START;
+		size_t tot_size = num_possible_cpus() * PMD_SIZE;
+
+		/* on non-NUMA, embedding is better */
+		if (!pcpu_need_numa())
+			return -EINVAL;
+
+		/* don't consume more than 20% of vmalloc area */
+		if (tot_size > vm_size / 5) {
+			pr_info("PERCPU: too large chunk size %zuMB for "
+				"large page remap\n", tot_size >> 20);
+			return -EINVAL;
+		}
+	}
+
+	/* need PSE */
+	if (!cpu_has_pse) {
+		pr_warning("PERCPU: lpage allocator requires PSE\n");
 		return -EINVAL;
+	}
 
 	/*
 	 * Currently supports only single page.  Supporting multiple
 	 * pages won't be too difficult if it ever becomes necessary.
 	 */
-	pcpur_size = PFN_ALIGN(static_size + PERCPU_MODULE_RESERVE +
+	pcpul_size = PFN_ALIGN(static_size + PERCPU_MODULE_RESERVE +
 			       PERCPU_DYNAMIC_RESERVE);
-	if (pcpur_size > PMD_SIZE) {
+	if (pcpul_size > PMD_SIZE) {
 		pr_warning("PERCPU: static data is larger than large page, "
 			   "can't use large page\n");
 		return -EINVAL;
 	}
-	dyn_size = pcpur_size - static_size - PERCPU_FIRST_CHUNK_RESERVE;
+	dyn_size = pcpul_size - static_size - PERCPU_FIRST_CHUNK_RESERVE;
 
 	/* allocate pointer array and alloc large pages */
-	ptrs_size = PFN_ALIGN(num_possible_cpus() * sizeof(pcpur_ptrs[0]));
-	pcpur_ptrs = alloc_bootmem(ptrs_size);
+	map_size = PFN_ALIGN(num_possible_cpus() * sizeof(pcpul_map[0]));
+	pcpul_map = alloc_bootmem(map_size);
 
 	for_each_possible_cpu(cpu) {
-		pcpur_ptrs[cpu] = pcpu_alloc_bootmem(cpu, PMD_SIZE, PMD_SIZE);
-		if (!pcpur_ptrs[cpu])
+		pcpul_map[cpu].cpu = cpu;
+		pcpul_map[cpu].ptr = pcpu_alloc_bootmem(cpu, PMD_SIZE,
+							PMD_SIZE);
+		if (!pcpul_map[cpu].ptr) {
+			pr_warning("PERCPU: failed to allocate large page "
+				   "for cpu%u\n", cpu);
 			goto enomem;
+		}
 
 		/*
-		 * Only use pcpur_size bytes and give back the rest.
+		 * Only use pcpul_size bytes and give back the rest.
 		 *
 		 * Ingo: The 2MB up-rounding bootmem is needed to make
 		 * sure the partial 2MB page is still fully RAM - it's
 		 * not well-specified to have a PAT-incompatible area
 		 * (unmapped RAM, device memory, etc.) in that hole.
 		 */
-		free_bootmem(__pa(pcpur_ptrs[cpu] + pcpur_size),
-			     PMD_SIZE - pcpur_size);
+		free_bootmem(__pa(pcpul_map[cpu].ptr + pcpul_size),
+			     PMD_SIZE - pcpul_size);
 
-		memcpy(pcpur_ptrs[cpu], __per_cpu_load, static_size);
+		memcpy(pcpul_map[cpu].ptr, __per_cpu_load, static_size);
 	}
 
 	/* allocate address and map */
-	vm.flags = VM_ALLOC;
-	vm.size = num_possible_cpus() * PMD_SIZE;
-	vm_area_register_early(&vm, PMD_SIZE);
+	pcpul_vm.flags = VM_ALLOC;
+	pcpul_vm.size = num_possible_cpus() * PMD_SIZE;
+	vm_area_register_early(&pcpul_vm, PMD_SIZE);
 
 	for_each_possible_cpu(cpu) {
-		pmd_t *pmd;
+		pmd_t *pmd, pmd_v;
 
-		pmd = populate_extra_pmd((unsigned long)vm.addr
-					 + cpu * PMD_SIZE);
-		set_pmd(pmd, pfn_pmd(page_to_pfn(virt_to_page(pcpur_ptrs[cpu])),
-				     PAGE_KERNEL_LARGE));
+		pmd = populate_extra_pmd((unsigned long)pcpul_vm.addr +
+					 cpu * PMD_SIZE);
+		pmd_v = pfn_pmd(page_to_pfn(virt_to_page(pcpul_map[cpu].ptr)),
+				PAGE_KERNEL_LARGE);
+		set_pmd(pmd, pmd_v);
 	}
 
 	/* we're ready, commit */
 	pr_info("PERCPU: Remapped at %p with large pages, static data "
-		"%zu bytes\n", vm.addr, static_size);
+		"%zu bytes\n", pcpul_vm.addr, static_size);
 
-	ret = pcpu_setup_first_chunk(pcpur_get_page, static_size,
+	ret = pcpu_setup_first_chunk(pcpul_get_page, static_size,
 				     PERCPU_FIRST_CHUNK_RESERVE, dyn_size,
-				     PMD_SIZE, vm.addr, NULL);
-	goto out_free_ar;
+				     PMD_SIZE, pcpul_vm.addr, NULL);
+
+	/* sort pcpul_map array for pcpu_lpage_remapped() */
+	for (i = 0; i < num_possible_cpus() - 1; i++)
+		for (j = i + 1; j < num_possible_cpus(); j++)
+			if (pcpul_map[i].ptr > pcpul_map[j].ptr) {
+				struct pcpul_ent tmp = pcpul_map[i];
+				pcpul_map[i] = pcpul_map[j];
+				pcpul_map[j] = tmp;
+			}
+
+	return ret;
 
 enomem:
 	for_each_possible_cpu(cpu)
-		if (pcpur_ptrs[cpu])
-			free_bootmem(__pa(pcpur_ptrs[cpu]), PMD_SIZE);
-	ret = -ENOMEM;
-out_free_ar:
-	free_bootmem(__pa(pcpur_ptrs), ptrs_size);
-	return ret;
+		if (pcpul_map[cpu].ptr)
+			free_bootmem(__pa(pcpul_map[cpu].ptr), pcpul_size);
+	free_bootmem(__pa(pcpul_map), map_size);
+	return -ENOMEM;
+}
+
+/**
+ * pcpu_lpage_remapped - determine whether a kaddr is in pcpul recycled area
+ * @kaddr: the kernel address in question
+ *
+ * Determine whether @kaddr falls in the pcpul recycled area.  This is
+ * used by pageattr to detect VM aliases and break up the pcpu PMD
+ * mapping such that the same physical page is not mapped under
+ * different attributes.
+ *
+ * The recycled area is always at the tail of a partially used PMD
+ * page.
+ *
+ * RETURNS:
+ * Address of corresponding remapped pcpu address if match is found;
+ * otherwise, NULL.
+ */
+void *pcpu_lpage_remapped(void *kaddr)
+{
+	void *pmd_addr = (void *)((unsigned long)kaddr & PMD_MASK);
+	unsigned long offset = (unsigned long)kaddr & ~PMD_MASK;
+	int left = 0, right = num_possible_cpus() - 1;
+	int pos;
+
+	/* pcpul in use at all? */
+	if (!pcpul_map)
+		return NULL;
+
+	/* okay, perform binary search */
+	while (left <= right) {
+		pos = (left + right) / 2;
+
+		if (pcpul_map[pos].ptr < pmd_addr)
+			left = pos + 1;
+		else if (pcpul_map[pos].ptr > pmd_addr)
+			right = pos - 1;
+		else {
+			/* it shouldn't be in the area for the first chunk */
+			WARN_ON(offset < pcpul_size);
+
+			return pcpul_vm.addr +
+				pcpul_map[pos].cpu * PMD_SIZE + offset;
+		}
+	}
+
+	return NULL;
 }
 #else
-static ssize_t __init setup_pcpu_remap(size_t static_size)
+static ssize_t __init setup_pcpu_lpage(size_t static_size, bool chosen)
 {
 	return -EINVAL;
 }
@@ -249,7 +329,7 @@ static ssize_t __init setup_pcpu_remap(size_t static_size)
  * mapping so that it can use PMD mapping without additional TLB
  * pressure.
  */
-static ssize_t __init setup_pcpu_embed(size_t static_size)
+static ssize_t __init setup_pcpu_embed(size_t static_size, bool chosen)
 {
 	size_t reserve = PERCPU_MODULE_RESERVE + PERCPU_DYNAMIC_RESERVE;
 
@@ -258,7 +338,7 @@ static ssize_t __init setup_pcpu_embed(size_t static_size)
 	 * this.  Also, embedding allocation doesn't play well with
 	 * NUMA.
 	 */
-	if (!cpu_has_pse || pcpu_need_numa())
+	if (!chosen && (!cpu_has_pse || pcpu_need_numa()))
 		return -EINVAL;
 
 	return pcpu_embed_first_chunk(static_size, PERCPU_FIRST_CHUNK_RESERVE,
@@ -308,8 +388,11 @@ static ssize_t __init setup_pcpu_4k(size_t static_size)
 			void *ptr;
 
 			ptr = pcpu_alloc_bootmem(cpu, PAGE_SIZE, PAGE_SIZE);
-			if (!ptr)
+			if (!ptr) {
+				pr_warning("PERCPU: failed to allocate "
+					   "4k page for cpu%u\n", cpu);
 				goto enomem;
+			}
 
 			memcpy(ptr, __per_cpu_load + i * PAGE_SIZE, PAGE_SIZE);
 			pcpu4k_pages[j++] = virt_to_page(ptr);
@@ -333,6 +416,16 @@ out_free_ar:
 	return ret;
 }
 
+/* for explicit first chunk allocator selection */
+static char pcpu_chosen_alloc[16] __initdata;
+
+static int __init percpu_alloc_setup(char *str)
+{
+	strncpy(pcpu_chosen_alloc, str, sizeof(pcpu_chosen_alloc) - 1);
+	return 0;
+}
+early_param("percpu_alloc", percpu_alloc_setup);
+
 static inline void setup_percpu_segment(int cpu)
 {
 #ifdef CONFIG_X86_32
@@ -346,11 +439,6 @@ static inline void setup_percpu_segment(int cpu)
 #endif
 }
 
-/*
- * Great future plan:
- * Declare PDA itself and support (irqstack,tss,pgd) as per cpu data.
- * Always point %gs to its beginning
- */
 void __init setup_per_cpu_areas(void)
 {
 	size_t static_size = __per_cpu_end - __per_cpu_start;
@@ -367,9 +455,26 @@ void __init setup_per_cpu_areas(void)
 	 * of large page mappings.  Please read comments on top of
 	 * each allocator for details.
 	 */
-	ret = setup_pcpu_remap(static_size);
-	if (ret < 0)
-		ret = setup_pcpu_embed(static_size);
+	ret = -EINVAL;
+	if (strlen(pcpu_chosen_alloc)) {
+		if (strcmp(pcpu_chosen_alloc, "4k")) {
+			if (!strcmp(pcpu_chosen_alloc, "lpage"))
+				ret = setup_pcpu_lpage(static_size, true);
+			else if (!strcmp(pcpu_chosen_alloc, "embed"))
+				ret = setup_pcpu_embed(static_size, true);
+			else
+				pr_warning("PERCPU: unknown allocator %s "
+					   "specified\n", pcpu_chosen_alloc);
+			if (ret < 0)
+				pr_warning("PERCPU: %s allocator failed (%zd), "
+					   "falling back to 4k\n",
+					   pcpu_chosen_alloc, ret);
+		}
+	} else {
+		ret = setup_pcpu_lpage(static_size, false);
+		if (ret < 0)
+			ret = setup_pcpu_embed(static_size, false);
+	}
 	if (ret < 0)
 		ret = setup_pcpu_4k(static_size);
 	if (ret < 0)
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 124d40c..8ccabb8 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -711,7 +711,6 @@ uv_activation_descriptor_init(int node, int pnode)
 	unsigned long pa;
 	unsigned long m;
 	unsigned long n;
-	unsigned long mmr_image;
 	struct bau_desc *adp;
 	struct bau_desc *ad2;
 
@@ -727,12 +726,8 @@ uv_activation_descriptor_init(int node, int pnode)
 	n = pa >> uv_nshift;
 	m = pa & uv_mmask;
 
-	mmr_image = uv_read_global_mmr64(pnode, UVH_LB_BAU_SB_DESCRIPTOR_BASE);
-	if (mmr_image) {
-		uv_write_global_mmr64(pnode, (unsigned long)
-				      UVH_LB_BAU_SB_DESCRIPTOR_BASE,
-				      (n << UV_DESC_BASE_PNODE_SHIFT | m));
-	}
+	uv_write_global_mmr64(pnode, UVH_LB_BAU_SB_DESCRIPTOR_BASE,
+			      (n << UV_DESC_BASE_PNODE_SHIFT | m));
 
 	/*
 	 * initializing all 8 (UV_ITEMS_PER_DESCRIPTOR) descriptors for each
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a0f48f5..5204332 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -346,6 +346,9 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 	printk(KERN_EMERG "NMI: IOCK error (debug interrupt?)\n");
 	show_registers(regs);
 
+	if (panic_on_io_nmi)
+		panic("NMI IOCK error: Not continuing");
+
 	/* Re-enable the IOCK line, wait for a few seconds */
 	reason = (reason & 0xf) | 8;
 	outb(reason, 0x61);
diff --git a/arch/x86/lib/delay.c b/arch/x86/lib/delay.c
index f456860..ff485d3 100644
--- a/arch/x86/lib/delay.c
+++ b/arch/x86/lib/delay.c
@@ -55,8 +55,10 @@ static void delay_tsc(unsigned long loops)
 
 	preempt_disable();
 	cpu = smp_processor_id();
+	rdtsc_barrier();
 	rdtscl(bclock);
 	for (;;) {
+		rdtsc_barrier();
 		rdtscl(now);
 		if ((now - bclock) >= loops)
 			break;
@@ -78,6 +80,7 @@ static void delay_tsc(unsigned long loops)
 		if (unlikely(cpu != smp_processor_id())) {
 			loops -= (now - bclock);
 			cpu = smp_processor_id();
+			rdtsc_barrier();
 			rdtscl(bclock);
 		}
 	}
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index f53b57e..47ce9a2 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -177,20 +177,6 @@ static int __meminit save_mr(struct map_range *mr, int nr_range,
 	return nr_range;
 }
 
-#ifdef CONFIG_X86_64
-static void __init init_gbpages(void)
-{
-	if (direct_gbpages && cpu_has_gbpages)
-		printk(KERN_INFO "Using GB pages for direct mapping\n");
-	else
-		direct_gbpages = 0;
-}
-#else
-static inline void init_gbpages(void)
-{
-}
-#endif
-
 /*
  * Setup the direct mapping of the physical memory at PAGE_OFFSET.
  * This runs before bootmem is initialized and gets pages directly from
@@ -210,9 +196,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
 	printk(KERN_INFO "init_memory_mapping: %016lx-%016lx\n", start, end);
 
-	if (!after_bootmem)
-		init_gbpages();
-
 #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
 	/*
 	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 3cfe9ce..1b734d7 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -11,6 +11,7 @@
 #include <linux/interrupt.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
+#include <linux/pfn.h>
 
 #include <asm/e820.h>
 #include <asm/processor.h>
@@ -681,8 +682,9 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias);
 static int cpa_process_alias(struct cpa_data *cpa)
 {
 	struct cpa_data alias_cpa;
-	int ret = 0;
-	unsigned long temp_cpa_vaddr, vaddr;
+	unsigned long laddr = (unsigned long)__va(cpa->pfn << PAGE_SHIFT);
+	unsigned long vaddr, remapped;
+	int ret;
 
 	if (cpa->pfn >= max_pfn_mapped)
 		return 0;
@@ -706,42 +708,55 @@ static int cpa_process_alias(struct cpa_data *cpa)
 		    PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT)))) {
 
 		alias_cpa = *cpa;
-		temp_cpa_vaddr = (unsigned long) __va(cpa->pfn << PAGE_SHIFT);
-		alias_cpa.vaddr = &temp_cpa_vaddr;
+		alias_cpa.vaddr = &laddr;
 		alias_cpa.flags &= ~(CPA_PAGES_ARRAY | CPA_ARRAY);
 
-
 		ret = __change_page_attr_set_clr(&alias_cpa, 0);
+		if (ret)
+			return ret;
 	}
 
 #ifdef CONFIG_X86_64
-	if (ret)
-		return ret;
 	/*
-	 * No need to redo, when the primary call touched the high
-	 * mapping already:
-	 */
-	if (within(vaddr, (unsigned long) _text, _brk_end))
-		return 0;
-
-	/*
-	 * If the physical address is inside the kernel map, we need
+	 * If the primary call didn't touch the high mapping already
+	 * and the physical address is inside the kernel map, we need
 	 * to touch the high mapped kernel as well:
 	 */
-	if (!within(cpa->pfn, highmap_start_pfn(), highmap_end_pfn()))
-		return 0;
+	if (!within(vaddr, (unsigned long)_text, _brk_end) &&
+	    within(cpa->pfn, highmap_start_pfn(), highmap_end_pfn())) {
+		unsigned long temp_cpa_vaddr = (cpa->pfn << PAGE_SHIFT) +
+					       __START_KERNEL_map - phys_base;
+		alias_cpa = *cpa;
+		alias_cpa.vaddr = &temp_cpa_vaddr;
+		alias_cpa.flags &= ~(CPA_PAGES_ARRAY | CPA_ARRAY);
 
-	alias_cpa = *cpa;
-	temp_cpa_vaddr = (cpa->pfn << PAGE_SHIFT) + __START_KERNEL_map - phys_base;
-	alias_cpa.vaddr = &temp_cpa_vaddr;
-	alias_cpa.flags &= ~(CPA_PAGES_ARRAY | CPA_ARRAY);
+		/*
+		 * The high mapping range is imprecise, so ignore the
+		 * return value.
+		 */
+		__change_page_attr_set_clr(&alias_cpa, 0);
+	}
+#endif
 
 	/*
-	 * The high mapping range is imprecise, so ignore the return value.
+	 * If the PMD page was partially used for per-cpu remapping,
+	 * the recycled area needs to be split and modified.  Because
+	 * the area is always proper subset of a PMD page
+	 * cpa->numpages is guaranteed to be 1 for these areas, so
+	 * there's no need to loop over and check for further remaps.
 	 */
-	__change_page_attr_set_clr(&alias_cpa, 0);
-#endif
-	return ret;
+	remapped = (unsigned long)pcpu_lpage_remapped((void *)laddr);
+	if (remapped) {
+		WARN_ON(cpa->numpages > 1);
+		alias_cpa = *cpa;
+		alias_cpa.vaddr = &remapped;
+		alias_cpa.flags &= ~(CPA_PAGES_ARRAY | CPA_ARRAY);
+		ret = __change_page_attr_set_clr(&alias_cpa, 0);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index d277ef1..b3d20b9 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -244,7 +244,7 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	do_fpu_end();
 	mtrr_ap_init();
 
-#ifdef CONFIG_X86_32
+#ifdef CONFIG_X86_OLD_MCE
 	mcheck_init(&boot_cpu_data);
 #endif
 }
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index fac104e..d6320a3 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -303,6 +303,7 @@ extern int oops_in_progress;		/* If set, an oops, panic(), BUG() or die() is in
 extern int panic_timeout;
 extern int panic_on_oops;
 extern int panic_on_unrecovered_nmi;
+extern int panic_on_io_nmi;
 extern const char *print_tainted(void);
 extern void add_taint(unsigned flag);
 extern int test_taint(unsigned flag);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 62e4ff9..fba42ed 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -744,6 +744,14 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "panic_on_io_nmi",
+		.data		= &panic_on_io_nmi,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
 		.ctl_name	= KERN_BOOTLOADER_TYPE,
 		.procname	= "bootloader_type",
 		.data		= &bootloader_type,
diff --git a/mm/percpu.c b/mm/percpu.c
index c0b2c1a..b70f2ac 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -549,14 +549,14 @@ static void pcpu_free_area(struct pcpu_chunk *chunk, int freeme)
  * @chunk: chunk of interest
  * @page_start: page index of the first page to unmap
  * @page_end: page index of the last page to unmap + 1
- * @flush: whether to flush cache and tlb or not
+ * @flush_tlb: whether to flush tlb or not
  *
  * For each cpu, unmap pages [@page_start,@page_end) out of @chunk.
  * If @flush is true, vcache is flushed before unmapping and tlb
  * after.
  */
 static void pcpu_unmap(struct pcpu_chunk *chunk, int page_start, int page_end,
-		       bool flush)
+		       bool flush_tlb)
 {
 	unsigned int last = num_possible_cpus() - 1;
 	unsigned int cpu;
@@ -569,9 +569,8 @@ static void pcpu_unmap(struct pcpu_chunk *chunk, int page_start, int page_end,
 	 * the whole region at once rather than doing it for each cpu.
 	 * This could be an overkill but is more scalable.
 	 */
-	if (flush)
-		flush_cache_vunmap(pcpu_chunk_addr(chunk, 0, page_start),
-				   pcpu_chunk_addr(chunk, last, page_end));
+	flush_cache_vunmap(pcpu_chunk_addr(chunk, 0, page_start),
+			   pcpu_chunk_addr(chunk, last, page_end));
 
 	for_each_possible_cpu(cpu)
 		unmap_kernel_range_noflush(
@@ -579,7 +578,7 @@ static void pcpu_unmap(struct pcpu_chunk *chunk, int page_start, int page_end,
 				(page_end - page_start) << PAGE_SHIFT);
 
 	/* ditto as flush_cache_vunmap() */
-	if (flush)
+	if (flush_tlb)
 		flush_tlb_kernel_range(pcpu_chunk_addr(chunk, 0, page_start),
 				       pcpu_chunk_addr(chunk, last, page_end));
 }
@@ -1234,6 +1233,7 @@ static struct page * __init pcpue_get_page(unsigned int cpu, int pageno)
 ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
 				      ssize_t dyn_size, ssize_t unit_size)
 {
+	size_t chunk_size;
 	unsigned int cpu;
 
 	/* determine parameters and allocate */
@@ -1248,11 +1248,15 @@ ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
 	} else
 		pcpue_unit_size = max_t(size_t, pcpue_size, PCPU_MIN_UNIT_SIZE);
 
-	pcpue_ptr = __alloc_bootmem_nopanic(
-					num_possible_cpus() * pcpue_unit_size,
-					PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
-	if (!pcpue_ptr)
+	chunk_size = pcpue_unit_size * num_possible_cpus();
+
+	pcpue_ptr = __alloc_bootmem_nopanic(chunk_size, PAGE_SIZE,
+					    __pa(MAX_DMA_ADDRESS));
+	if (!pcpue_ptr) {
+		pr_warning("PERCPU: failed to allocate %zu bytes for "
+			   "embedding\n", chunk_size);
 		return -ENOMEM;
+	}
 
 	/* return the leftover and copy */
 	for_each_possible_cpu(cpu) {
