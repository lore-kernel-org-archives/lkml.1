Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbZCFGtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbZCFGtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756287AbZCFGrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:47:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:56799 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453AbZCFGrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:47:07 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, efault@gmx.de,
       jaswinder@kernel.org, cooloney@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/8] percpu: use negative for auto for pcpu_setup_first_chunk() arguments
Date: Fri,  6 Mar 2009 15:46:24 +0900
Message-Id: <1236321988-19457-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1236321988-19457-1-git-send-email-tj@kernel.org>
References: <1236321988-19457-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 06:46:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: argument semantic cleanup

In pcpu_setup_first_chunk(), zero @unit_size and @dyn_size meant
auto-sizing.  It's okay for @unit_size as 0 doesn't make sense but 0
dynamic reserve size is valid.  Alos, if arch @dyn_size is calculated
from other parameters, it might end up passing in 0 @dyn_size and
malfunction when the size is automatically adjusted.

This patch makes both @unit_size and @dyn_size ssize_t and use -1 for
auto sizing.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/setup_percpu.c |    2 +-
 include/linux/percpu.h         |    5 ++-
 mm/percpu.c                    |   46 +++++++++++++++++++++------------------
 3 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index c29f301..ef3a2cd 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -344,7 +344,7 @@ static ssize_t __init setup_pcpu_4k(size_t static_size)
 	pr_info("PERCPU: Allocated %d 4k pages, static data %zu bytes\n",
 		pcpu4k_nr_static_pages, static_size);
 
-	ret = pcpu_setup_first_chunk(pcpu4k_get_page, static_size, 0, 0, NULL,
+	ret = pcpu_setup_first_chunk(pcpu4k_get_page, static_size, -1, -1, NULL,
 				     pcpu4k_populate_pte);
 	goto out_free_ar;
 
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index a0b4ea2..a96fc53 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -117,8 +117,9 @@ typedef struct page * (*pcpu_get_page_fn_t)(unsigned int cpu, int pageno);
 typedef void (*pcpu_populate_pte_fn_t)(unsigned long addr);
 
 extern size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
-					size_t static_size, size_t unit_size,
-					size_t dyn_size, void *base_addr,
+					size_t static_size,
+					ssize_t unit_size, ssize_t dyn_size,
+					void *base_addr,
 					pcpu_populate_pte_fn_t populate_pte_fn);
 
 /*
diff --git a/mm/percpu.c b/mm/percpu.c
index 503ccad..a84cf99 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -824,8 +824,8 @@ EXPORT_SYMBOL_GPL(free_percpu);
  * pcpu_setup_first_chunk - initialize the first percpu chunk
  * @get_page_fn: callback to fetch page pointer
  * @static_size: the size of static percpu area in bytes
- * @unit_size: unit size in bytes, must be multiple of PAGE_SIZE, 0 for auto
- * @dyn_size: free size for dynamic allocation in bytes, 0 for auto
+ * @unit_size: unit size in bytes, must be multiple of PAGE_SIZE, -1 for auto
+ * @dyn_size: free size for dynamic allocation in bytes, -1 for auto
  * @base_addr: mapped address, NULL for auto
  * @populate_pte_fn: callback to allocate pagetable, NULL if unnecessary
  *
@@ -842,13 +842,14 @@ EXPORT_SYMBOL_GPL(free_percpu);
  * indicates end of pages for the cpu.  Note that @get_page_fn() must
  * return the same number of pages for all cpus.
  *
- * @unit_size, if non-zero, determines unit size and must be aligned
- * to PAGE_SIZE and equal to or larger than @static_size + @dyn_size.
+ * @unit_size, if non-negative, specifies unit size and must be
+ * aligned to PAGE_SIZE and equal to or larger than @static_size +
+ * @dyn_size.
  *
- * @dyn_size determines the number of free bytes after the static
- * area in the first chunk.  If zero, whatever left is available.
- * Specifying non-zero value make percpu leave the area after
- * @static_size + @dyn_size alone.
+ * @dyn_size, if non-negative, limits the number of bytes available
+ * for dynamic allocation in the first chunk.  Specifying non-negative
+ * value make percpu leave alone the area beyond @static_size +
+ * @dyn_size.
  *
  * Non-null @base_addr means that the caller already allocated virtual
  * region for the first chunk and mapped it.  percpu must not mess
@@ -863,8 +864,9 @@ EXPORT_SYMBOL_GPL(free_percpu);
  * percpu access.
  */
 size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
-				     size_t static_size, size_t unit_size,
-				     size_t dyn_size, void *base_addr,
+				     size_t static_size,
+				     ssize_t unit_size, ssize_t dyn_size,
+				     void *base_addr,
 				     pcpu_populate_pte_fn_t populate_pte_fn)
 {
 	static struct vm_struct first_vm;
@@ -877,13 +879,17 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 	/* santiy checks */
 	BUILD_BUG_ON(ARRAY_SIZE(smap) >= PCPU_DFL_MAP_ALLOC);
 	BUG_ON(!static_size);
-	BUG_ON(!unit_size && dyn_size);
-	BUG_ON(unit_size && unit_size < static_size + dyn_size);
-	BUG_ON(unit_size & ~PAGE_MASK);
-	BUG_ON(base_addr && !unit_size);
+	if (unit_size >= 0) {
+		BUG_ON(unit_size < static_size +
+				   (dyn_size >= 0 ? dyn_size : 0));
+		BUG_ON(unit_size & ~PAGE_MASK);
+	} else {
+		BUG_ON(dyn_size >= 0);
+		BUG_ON(base_addr);
+	}
 	BUG_ON(base_addr && populate_pte_fn);
 
-	if (unit_size)
+	if (unit_size >= 0)
 		pcpu_unit_pages = unit_size >> PAGE_SHIFT;
 	else
 		pcpu_unit_pages = max_t(int, PCPU_MIN_UNIT_SIZE >> PAGE_SHIFT,
@@ -894,6 +900,9 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 	pcpu_chunk_struct_size = sizeof(struct pcpu_chunk)
 		+ num_possible_cpus() * pcpu_unit_pages * sizeof(struct page *);
 
+	if (dyn_size < 0)
+		dyn_size = pcpu_unit_size - static_size;
+
 	/*
 	 * Allocate chunk slots.  The additional last slot is for
 	 * empty chunks.
@@ -909,12 +918,7 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 	schunk->vm = &first_vm;
 	schunk->map = smap;
 	schunk->map_alloc = ARRAY_SIZE(smap);
-
-	if (dyn_size)
-		schunk->free_size = dyn_size;
-	else
-		schunk->free_size = pcpu_unit_size - static_size;
-
+	schunk->free_size = dyn_size;
 	schunk->contig_hint = schunk->free_size;
 
 	schunk->map[schunk->map_used++] = -static_size;
-- 
1.6.0.2

