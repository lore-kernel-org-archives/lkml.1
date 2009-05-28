Return-Path: <linux-kernel-owner+w=401wt.eu-S1761678AbZE1OV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761678AbZE1OV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbZE1OVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:21:18 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:43624 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbZE1OVS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:21:18 -0400
Message-Id: <4A1EBA000200007800003197@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 28 May 2009 15:21:20 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Tejun Heo" <TeHeo@novell.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: percpu memory setup and num_possible_cpus() vs. nr_cpu_ids
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

this code of yours, as I learned the hard way during some Xen kernel work,
assumes that cpu_possible_map is not sparse. While on native x86 this is
certainly true, I wonder whether such a dependency should really exist in
architecture neutral code. Below, for reference, the places I needed to
change (4k allocator only). However, there are more instances of this in the
other allocators - those seem more problematic, as they directly drive input
to alloc_bootmem() (hence a lot of memory could be wasted, or allocation
could even fail, with a very sparse cpu_possible_map if one would simply
also use nr_cpu_ids here). In the remap (x86 - under the assumption that
if this change gets made, it should also be made in x86 code, albeit not
directly affected) allocator's case things may not be that bad, since the
memory gets freed again at the end of setup_pcpu_remap().

Thoughts?

Jan

--- head-2009-05-19.orig/arch/x86/kernel/setup_percpu.c	2009-05-19 09:55:40.000000000 +0200
+++ head-2009-05-19/arch/x86/kernel/setup_percpu.c	2009-05-27 11:12:46.000000000 +0200
@@ -295,13 +295,14 @@ static ssize_t __init setup_pcpu_4k(size
 	pcpu4k_nr_static_pages = PFN_UP(static_size);
 
 	/* unaligned allocations can't be freed, round up to page size */
-	pages_size = PFN_ALIGN(pcpu4k_nr_static_pages * num_possible_cpus()
+	pages_size = PFN_ALIGN(pcpu4k_nr_static_pages * nr_cpu_ids
 			       * sizeof(pcpu4k_pages[0]));
 	pcpu4k_pages = alloc_bootmem(pages_size);
 
 	/* allocate and copy */
 	j = 0;
-	for_each_possible_cpu(cpu)
+	for_each_possible_cpu(cpu) {
+		j = cpu * pcpu4k_nr_static_pages;
 		for (i = 0; i < pcpu4k_nr_static_pages; i++) {
 			void *ptr;
 
@@ -312,6 +313,7 @@ static ssize_t __init setup_pcpu_4k(size
 			memcpy(ptr, __per_cpu_load + i * PAGE_SIZE, PAGE_SIZE);
 			pcpu4k_pages[j++] = virt_to_page(ptr);
 		}
+	}
 
 	/* we're ready, commit */
 	pr_info("PERCPU: Allocated %d 4k pages, static data %zu bytes\n",
@@ -323,8 +325,11 @@ static ssize_t __init setup_pcpu_4k(size
 	goto out_free_ar;
 
 enomem:
-	while (--j >= 0)
+	while (--j >= 0) {
+		if (!pcpu4k_pages[j])
+			continue;
 		free_bootmem(__pa(page_address(pcpu4k_pages[j])), PAGE_SIZE);
+	}
 	ret = -ENOMEM;
 out_free_ar:
 	free_bootmem(__pa(pcpu4k_pages), pages_size);
--- head-2009-05-19.orig/mm/percpu.c	2009-04-21 10:18:29.000000000 +0200
+++ head-2009-05-19/mm/percpu.c	2009-05-27 11:34:01.000000000 +0200
@@ -604,7 +604,7 @@ static void pcpu_free_area(struct pcpu_c
 static void pcpu_unmap(struct pcpu_chunk *chunk, int page_start, int page_end,
 		       bool flush)
 {
-	unsigned int last = num_possible_cpus() - 1;
+	unsigned int last = nr_cpu_ids - 1;
 	unsigned int cpu;
 
 	/* unmap must not be done on immutable chunk */
@@ -690,7 +690,7 @@ static void pcpu_depopulate_chunk(struct
  */
 static int pcpu_map(struct pcpu_chunk *chunk, int page_start, int page_end)
 {
-	unsigned int last = num_possible_cpus() - 1;
+	unsigned int last = nr_cpu_ids - 1;
 	unsigned int cpu;
 	int err;
 
@@ -1115,9 +1115,9 @@ size_t __init pcpu_setup_first_chunk(pcp
 					PFN_UP(size_sum));
 
 	pcpu_unit_size = pcpu_unit_pages << PAGE_SHIFT;
-	pcpu_chunk_size = num_possible_cpus() * pcpu_unit_size;
+	pcpu_chunk_size = nr_cpu_ids * pcpu_unit_size;
 	pcpu_chunk_struct_size = sizeof(struct pcpu_chunk)
-		+ num_possible_cpus() * pcpu_unit_pages * sizeof(struct page *);
+		+ nr_cpu_ids * pcpu_unit_pages * sizeof(struct page *);
 
 	if (dyn_size < 0)
 		dyn_size = pcpu_unit_size - static_size - reserved_size;


