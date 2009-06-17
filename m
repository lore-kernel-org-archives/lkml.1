Return-Path: <linux-kernel-owner+w=401wt.eu-S1759135AbZFQEH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135AbZFQEH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 00:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764769AbZFQEHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 00:07:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:41900 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764812AbZFQEHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 00:07:38 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] x86,percpu: generalize 4k first chunk allocator
Date: Wed, 17 Jun 2009 13:04:33 +0900
Message-Id: <1245211476-27015-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245211476-27015-1-git-send-email-tj@kernel.org>
References: <1245211476-27015-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 04:04:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generalize and move x86 setup_pcpu_4k() into pcpu_4k_first_chunk().
setup_pcpu_4k() now is a simple wrapper around the generalized
version.  Other than taking size parameters and using arch supplied
callbacks to allocate/free memory, pcpu_4k_first_chunk() is identical
to the original implementation.

This simplifies arch code and will help converting more archs to
dynamic percpu allocator.

While at it, s/pcpu_populate_pte_fn_t/pcpu_fc_populate_pte_fn_t/ for
consistency.

[ Impact: code reorganization and generalization ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/setup_percpu.c |   78 +++++++++---------------------------
 include/linux/percpu.h         |   12 +++++-
 mm/percpu.c                    |   85 +++++++++++++++++++++++++++++++++++++++-
 3 files changed, 113 insertions(+), 62 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 1472820..ab896b3 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -124,6 +124,19 @@ static void * __init pcpu_alloc_bootmem(unsigned int cpu, unsigned long size,
 }
 
 /*
+ * Helpers for first chunk memory allocation
+ */
+static void * __init pcpu_fc_alloc(unsigned int cpu, size_t size)
+{
+	return pcpu_alloc_bootmem(cpu, size, size);
+}
+
+static void __init pcpu_fc_free(void *ptr, size_t size)
+{
+	free_bootmem(__pa(ptr), size);
+}
+
+/*
  * Large page remap allocator
  *
  * This allocator uses PMD page as unit.  A PMD page is allocated for
@@ -346,22 +359,11 @@ static ssize_t __init setup_pcpu_embed(size_t static_size, bool chosen)
 }
 
 /*
- * 4k page allocator
+ * 4k allocator
  *
- * This is the basic allocator.  Static percpu area is allocated
- * page-by-page and most of initialization is done by the generic
- * setup function.
+ * Boring fallback 4k allocator.  This allocator puts more pressure on
+ * PTE TLBs but other than that behaves nicely on both UMA and NUMA.
  */
-static struct page **pcpu4k_pages __initdata;
-static int pcpu4k_nr_static_pages __initdata;
-
-static struct page * __init pcpu4k_get_page(unsigned int cpu, int pageno)
-{
-	if (pageno < pcpu4k_nr_static_pages)
-		return pcpu4k_pages[cpu * pcpu4k_nr_static_pages + pageno];
-	return NULL;
-}
-
 static void __init pcpu4k_populate_pte(unsigned long addr)
 {
 	populate_extra_pte(addr);
@@ -369,51 +371,9 @@ static void __init pcpu4k_populate_pte(unsigned long addr)
 
 static ssize_t __init setup_pcpu_4k(size_t static_size)
 {
-	size_t pages_size;
-	unsigned int cpu;
-	int i, j;
-	ssize_t ret;
-
-	pcpu4k_nr_static_pages = PFN_UP(static_size);
-
-	/* unaligned allocations can't be freed, round up to page size */
-	pages_size = PFN_ALIGN(pcpu4k_nr_static_pages * num_possible_cpus()
-			       * sizeof(pcpu4k_pages[0]));
-	pcpu4k_pages = alloc_bootmem(pages_size);
-
-	/* allocate and copy */
-	j = 0;
-	for_each_possible_cpu(cpu)
-		for (i = 0; i < pcpu4k_nr_static_pages; i++) {
-			void *ptr;
-
-			ptr = pcpu_alloc_bootmem(cpu, PAGE_SIZE, PAGE_SIZE);
-			if (!ptr) {
-				pr_warning("PERCPU: failed to allocate "
-					   "4k page for cpu%u\n", cpu);
-				goto enomem;
-			}
-
-			memcpy(ptr, __per_cpu_load + i * PAGE_SIZE, PAGE_SIZE);
-			pcpu4k_pages[j++] = virt_to_page(ptr);
-		}
-
-	/* we're ready, commit */
-	pr_info("PERCPU: Allocated %d 4k pages, static data %zu bytes\n",
-		pcpu4k_nr_static_pages, static_size);
-
-	ret = pcpu_setup_first_chunk(pcpu4k_get_page, static_size,
-				     PERCPU_FIRST_CHUNK_RESERVE, -1,
-				     -1, NULL, pcpu4k_populate_pte);
-	goto out_free_ar;
-
-enomem:
-	while (--j >= 0)
-		free_bootmem(__pa(page_address(pcpu4k_pages[j])), PAGE_SIZE);
-	ret = -ENOMEM;
-out_free_ar:
-	free_bootmem(__pa(pcpu4k_pages), pages_size);
-	return ret;
+	return pcpu_4k_first_chunk(static_size, PERCPU_FIRST_CHUNK_RESERVE,
+				   pcpu_fc_alloc, pcpu_fc_free,
+				   pcpu4k_populate_pte);
 }
 
 /* for explicit first chunk allocator selection */
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 83bff05..41b5bfa 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -59,18 +59,26 @@
 extern void *pcpu_base_addr;
 
 typedef struct page * (*pcpu_get_page_fn_t)(unsigned int cpu, int pageno);
-typedef void (*pcpu_populate_pte_fn_t)(unsigned long addr);
+typedef void * (*pcpu_fc_alloc_fn_t)(unsigned int cpu, size_t size);
+typedef void (*pcpu_fc_free_fn_t)(void *ptr, size_t size);
+typedef void (*pcpu_fc_populate_pte_fn_t)(unsigned long addr);
 
 extern size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 				size_t static_size, size_t reserved_size,
 				ssize_t dyn_size, ssize_t unit_size,
 				void *base_addr,
-				pcpu_populate_pte_fn_t populate_pte_fn);
+				pcpu_fc_populate_pte_fn_t populate_pte_fn);
 
 extern ssize_t __init pcpu_embed_first_chunk(
 				size_t static_size, size_t reserved_size,
 				ssize_t dyn_size);
 
+extern ssize_t __init pcpu_4k_first_chunk(
+				size_t static_size, size_t reserved_size,
+				pcpu_fc_alloc_fn_t alloc_fn,
+				pcpu_fc_free_fn_t free_fn,
+				pcpu_fc_populate_pte_fn_t populate_pte_fn);
+
 /*
  * Use this to get to a cpu's version of the per-cpu object
  * dynamically allocated. Non-atomic access to the current CPU's
diff --git a/mm/percpu.c b/mm/percpu.c
index fe34b6b..39f4022 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1037,7 +1037,7 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 				     size_t static_size, size_t reserved_size,
 				     ssize_t dyn_size, ssize_t unit_size,
 				     void *base_addr,
-				     pcpu_populate_pte_fn_t populate_pte_fn)
+				     pcpu_fc_populate_pte_fn_t populate_pte_fn)
 {
 	static struct vm_struct first_vm;
 	static int smap[2], dmap[2];
@@ -1271,6 +1271,89 @@ ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
 }
 
 /*
+ * 4k page first chunk setup helper.
+ */
+static struct page **pcpu4k_pages __initdata;
+static int pcpu4k_nr_static_pages __initdata;
+
+static struct page * __init pcpu4k_get_page(unsigned int cpu, int pageno)
+{
+	if (pageno < pcpu4k_nr_static_pages)
+		return pcpu4k_pages[cpu * pcpu4k_nr_static_pages + pageno];
+	return NULL;
+}
+
+/**
+ * pcpu_4k_first_chunk - map the first chunk using PAGE_SIZE pages
+ * @static_size: the size of static percpu area in bytes
+ * @reserved_size: the size of reserved percpu area in bytes
+ * @alloc_fn: function to allocate percpu page, always called with PAGE_SIZE
+ * @free_fn: funtion to free percpu page, always called with PAGE_SIZE
+ * @populate_pte_fn: function to populate pte
+ *
+ * This is a helper to ease setting up embedded first percpu chunk and
+ * can be called where pcpu_setup_first_chunk() is expected.
+ *
+ * This is the basic allocator.  Static percpu area is allocated
+ * page-by-page into vmalloc area.
+ *
+ * RETURNS:
+ * The determined pcpu_unit_size which can be used to initialize
+ * percpu access on success, -errno on failure.
+ */
+ssize_t __init pcpu_4k_first_chunk(size_t static_size, size_t reserved_size,
+				   pcpu_fc_alloc_fn_t alloc_fn,
+				   pcpu_fc_free_fn_t free_fn,
+				   pcpu_fc_populate_pte_fn_t populate_pte_fn)
+{
+	size_t pages_size;
+	unsigned int cpu;
+	int i, j;
+	ssize_t ret;
+
+	pcpu4k_nr_static_pages = PFN_UP(static_size);
+
+	/* unaligned allocations can't be freed, round up to page size */
+	pages_size = PFN_ALIGN(pcpu4k_nr_static_pages * num_possible_cpus() *
+			       sizeof(pcpu4k_pages[0]));
+	pcpu4k_pages = alloc_bootmem(pages_size);
+
+	/* allocate and copy */
+	j = 0;
+	for_each_possible_cpu(cpu)
+		for (i = 0; i < pcpu4k_nr_static_pages; i++) {
+			void *ptr;
+
+			ptr = alloc_fn(cpu, PAGE_SIZE);
+			if (!ptr) {
+				pr_warning("PERCPU: failed to allocate "
+					   "4k page for cpu%u\n", cpu);
+				goto enomem;
+			}
+
+			memcpy(ptr, __per_cpu_load + i * PAGE_SIZE, PAGE_SIZE);
+			pcpu4k_pages[j++] = virt_to_page(ptr);
+		}
+
+	/* we're ready, commit */
+	pr_info("PERCPU: Allocated %d 4k pages, static data %zu bytes\n",
+		pcpu4k_nr_static_pages, static_size);
+
+	ret = pcpu_setup_first_chunk(pcpu4k_get_page, static_size,
+				     reserved_size, -1,
+				     -1, NULL, populate_pte_fn);
+	goto out_free_ar;
+
+enomem:
+	while (--j >= 0)
+		free_fn(page_address(pcpu4k_pages[j]), PAGE_SIZE);
+	ret = -ENOMEM;
+out_free_ar:
+	free_bootmem(__pa(pcpu4k_pages), pages_size);
+	return ret;
+}
+
+/*
  * Generic percpu area setup.
  *
  * The embedding helper is used because its behavior closely resembles
-- 
1.6.0.2

