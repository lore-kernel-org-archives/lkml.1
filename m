Return-Path: <linux-kernel-owner+w=401wt.eu-S1762174AbZEOJgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762174AbZEOJgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 05:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762029AbZEOJgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 05:36:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:37916 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761946AbZEOJgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 05:36:03 -0400
Message-ID: <4A0D3766.4040100@kernel.org>
Date: Fri, 15 May 2009 18:35:34 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu,
       linux-kernel-owner@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH UPDATED 3/5] x86: fix pageattr handling for remap percpu allocator
References: <1242361739-21186-1-git-send-email-tj@kernel.org> <1242361739-21186-4-git-send-email-tj@kernel.org>
In-Reply-To: <1242361739-21186-4-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 09:35:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remap allocator aliases a PMD page for each cpu and returns whatever
is unused to the page allocator.  When the pageattr of the recycled
pages are changed, this makes the two aliases point to the overlapping
regions with different attributes which isn't allowed and known to
cause subtle data corruption in certain cases.

This can be handled in simliar manner to the x86_64 highmap alias.
pageattr code should detect if the target pages have PMD alias and
split the PMD alias and synchronize the attributes.

pcpur allocator is updated to keep the allocated PMD pages map sorted
in ascending address order and provide pcpu_pmd_remapped() function
which binary searches the array to determine whether the given address
is aliased and if so to which address.  pageattr is updated to use
pcpu_pmd_remapped() to detect the PMD alias and split it up as
necessary from cpa_process_alias().

Jan Beulich spotted the original problem and incorrect usage of vaddr
instead of laddr for lookup.

[ Impact: fix subtle pageattr bug ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jan Beulich <JBeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/percpu.h  |    9 +++++
 arch/x86/kernel/setup_percpu.c |   68 +++++++++++++++++++++++++++++++++++++----
 arch/x86/mm/pageattr.c         |   26 +++++++++++++++
 3 files changed, 96 insertions(+), 7 deletions(-)

Index: work/arch/x86/include/asm/percpu.h
===================================================================
--- work.orig/arch/x86/include/asm/percpu.h
+++ work/arch/x86/include/asm/percpu.h
@@ -155,6 +155,15 @@ do {							\
 /* We can use this directly for local CPU (faster). */
 DECLARE_PER_CPU(unsigned long, this_cpu_off);
 
+#ifdef CONFIG_NEED_MULTIPLE_NODES
+void *pcpu_pmd_remapped(void *kaddr);
+#else
+static inline void *pcpu_pmd_remapped(void *kaddr)
+{
+	return NULL;
+}
+#endif
+
 #endif /* !__ASSEMBLY__ */
 
 #ifdef CONFIG_SMP
Index: work/arch/x86/kernel/setup_percpu.c
===================================================================
--- work.orig/arch/x86/kernel/setup_percpu.c
+++ work/arch/x86/kernel/setup_percpu.c
@@ -142,8 +142,8 @@ struct pcpur_ent {
 	void		*ptr;
 };
 
-static size_t pcpur_size __initdata;
-static struct pcpur_ent *pcpur_map __initdata;
+static size_t pcpur_size;
+static struct pcpur_ent *pcpur_map;
 static struct vm_struct pcpur_vm;
 
 static struct page * __init pcpur_get_page(unsigned int cpu, int pageno)
@@ -160,6 +160,7 @@ static ssize_t __init setup_pcpu_remap(s
 {
 	size_t map_size, dyn_size;
 	unsigned int cpu;
+	int i, j;
 	ssize_t ret;
 
 	/*
@@ -229,16 +230,71 @@ static ssize_t __init setup_pcpu_remap(s
 	ret = pcpu_setup_first_chunk(pcpur_get_page, static_size,
 				     PERCPU_FIRST_CHUNK_RESERVE, dyn_size,
 				     PMD_SIZE, pcpur_vm.addr, NULL);
-	goto out_free_map;
+
+	/* sort pcpur_map array for pcpu_pmd_remapped() */
+	for (i = 0; i < num_possible_cpus() - 1; i++)
+		for (j = i + 1; j < num_possible_cpus(); j++)
+			if (pcpur_map[i].ptr > pcpur_map[j].ptr) {
+				struct pcpur_ent tmp = pcpur_map[i];
+				pcpur_map[i] = pcpur_map[j];
+				pcpur_map[j] = tmp;
+			}
+
+	return ret;
 
 enomem:
 	for_each_possible_cpu(cpu)
 		if (pcpur_map[cpu].ptr)
 			free_bootmem(__pa(pcpur_map[cpu].ptr), PMD_SIZE);
-	ret = -ENOMEM;
-out_free_map:
 	free_bootmem(__pa(pcpur_map), map_size);
-	return ret;
+	return -ENOMEM;
+}
+
+/**
+ * pcpu_pmd_remapped - determine whether a kaddr is in pcpur recycled area
+ * @kaddr: the kernel address in question
+ *
+ * Determine whether @kaddr falls in the pcpur recycled area.  This is
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
+void *pcpu_pmd_remapped(void *kaddr)
+{
+	void *pmd_addr = (void *)((unsigned long)kaddr & PMD_MASK);
+	unsigned long offset = (unsigned long)kaddr & ~PMD_MASK;
+	int left = 0, right = num_possible_cpus() - 1;
+	int pos;
+
+	/* pcpur in use at all? */
+	if (!pcpur_map)
+		return NULL;
+
+	/* okay, perform binary search */
+	while (left <= right) {
+		pos = (left + right) / 2;
+
+		if (pcpur_map[pos].ptr < pmd_addr)
+			left = pos + 1;
+		else if (pcpur_map[pos].ptr > pmd_addr)
+			right = pos - 1;
+		else {
+			/* it shouldn't be in the area for the first chunk */
+			WARN_ON(offset < pcpur_size);
+
+			return pcpur_vm.addr +
+				pcpur_map[pos].cpu * PMD_SIZE + offset;
+		}
+	}
+
+	return NULL;
 }
 #else
 static ssize_t __init setup_pcpu_remap(size_t static_size)
Index: work/arch/x86/mm/pageattr.c
===================================================================
--- work.orig/arch/x86/mm/pageattr.c
+++ work/arch/x86/mm/pageattr.c
@@ -11,6 +11,7 @@
 #include <linux/interrupt.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
+#include <linux/pfn.h>
 
 #include <asm/e820.h>
 #include <asm/processor.h>
@@ -687,7 +688,7 @@ static int cpa_process_alias(struct cpa_
 {
 	struct cpa_data alias_cpa;
 	unsigned long laddr = (unsigned long)__va(cpa->pfn << PAGE_SHIFT);
-	unsigned long vaddr;
+	unsigned long vaddr, remapped;
 	int ret;
 
 	if (cpa->pfn >= max_pfn_mapped)
@@ -742,6 +743,29 @@ static int cpa_process_alias(struct cpa_
 	}
 #endif
 
+	/*
+	 * If the PMD page was partially used for per-cpu remapping,
+	 * the remapped area needs to be split and modified.  Note
+	 * that the partial recycling only happens at the tail of a
+	 * partially used PMD page, so touching single PMD page is
+	 * always enough.
+	 *
+	 * Look up alias using the linear address to detect, for
+	 * example, recycled pages which got vmapped.
+	 */
+	remapped = (unsigned long)pcpu_pmd_remapped((void *)laddr);
+	if (remapped) {
+		int max_pages = PFN_DOWN(PMD_SIZE - (vaddr & ~PMD_MASK));
+
+		alias_cpa = *cpa;
+		alias_cpa.vaddr = &remapped;
+		alias_cpa.numpages = min(alias_cpa.numpages, max_pages);
+		alias_cpa.flags &= ~(CPA_PAGES_ARRAY | CPA_ARRAY);
+		ret = __change_page_attr_set_clr(&alias_cpa, 0);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 
