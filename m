Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbZGUKaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbZGUKaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbZGUKaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:30:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:37109 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbZGUK2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:28:10 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       rusty@rustcorp.com.au, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/20] percpu: make @dyn_size mandatory for pcpu_setup_first_chunk()
Date: Tue, 21 Jul 2009 19:26:06 +0900
Message-Id: <1248171979-29166-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1248171979-29166-1-git-send-email-tj@kernel.org>
References: <1248171979-29166-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 10:26:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all actual first chunk allocation and copying happen in the
first chunk allocators and helpers, there's no reason for
pcpu_setup_first_chunk() to try to determine @dyn_size automatically.
The only left user is page first chunk allocator.  Make it determine
dyn_size like other allocators and make @dyn_size mandatory for
pcpu_setup_first_chunk().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/percpu.h |    2 +-
 mm/percpu.c            |   39 +++++++++++++++++++--------------------
 2 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index be2fc8f..0cfdd14 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -79,7 +79,7 @@ typedef void (*pcpu_fc_map_fn_t)(void *ptr, size_t size, void *addr);
 
 extern size_t __init pcpu_setup_first_chunk(
 				size_t static_size, size_t reserved_size,
-				ssize_t dyn_size, size_t unit_size,
+				size_t dyn_size, size_t unit_size,
 				void *base_addr, const int *unit_map);
 
 #ifdef CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK
diff --git a/mm/percpu.c b/mm/percpu.c
index e9f45ab..3177cf6 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1235,7 +1235,7 @@ EXPORT_SYMBOL_GPL(free_percpu);
  * pcpu_setup_first_chunk - initialize the first percpu chunk
  * @static_size: the size of static percpu area in bytes
  * @reserved_size: the size of reserved percpu area in bytes, 0 for none
- * @dyn_size: free size for dynamic allocation in bytes, -1 for auto
+ * @dyn_size: free size for dynamic allocation in bytes
  * @unit_size: unit size in bytes, must be multiple of PAGE_SIZE
  * @base_addr: mapped address
  * @unit_map: cpu -> unit map, NULL for sequential mapping
@@ -1252,10 +1252,9 @@ EXPORT_SYMBOL_GPL(free_percpu);
  * limited offset range for symbol relocations to guarantee module
  * percpu symbols fall inside the relocatable range.
  *
- * @dyn_size, if non-negative, determines the number of bytes
- * available for dynamic allocation in the first chunk.  Specifying
- * non-negative value makes percpu leave alone the area beyond
- * @static_size + @reserved_size + @dyn_size.
+ * @dyn_size determines the number of bytes available for dynamic
+ * allocation in the first chunk.  The area between @static_size +
+ * @reserved_size + @dyn_size and @unit_size is unused.
  *
  * @unit_size specifies unit size and must be aligned to PAGE_SIZE and
  * equal to or larger than @static_size + @reserved_size + if
@@ -1276,13 +1275,12 @@ EXPORT_SYMBOL_GPL(free_percpu);
  * percpu access.
  */
 size_t __init pcpu_setup_first_chunk(size_t static_size, size_t reserved_size,
-				     ssize_t dyn_size, size_t unit_size,
+				     size_t dyn_size, size_t unit_size,
 				     void *base_addr, const int *unit_map)
 {
 	static struct vm_struct first_vm;
 	static int smap[2], dmap[2];
-	size_t size_sum = static_size + reserved_size +
-			  (dyn_size >= 0 ? dyn_size : 0);
+	size_t size_sum = static_size + reserved_size + dyn_size;
 	struct pcpu_chunk *schunk, *dchunk = NULL;
 	unsigned int cpu, tcpu;
 	int i;
@@ -1345,9 +1343,6 @@ size_t __init pcpu_setup_first_chunk(size_t static_size, size_t reserved_size,
 	pcpu_chunk_struct_size = sizeof(struct pcpu_chunk) +
 		BITS_TO_LONGS(pcpu_unit_pages) * sizeof(unsigned long);
 
-	if (dyn_size < 0)
-		dyn_size = pcpu_unit_size - static_size - reserved_size;
-
 	first_vm.flags = VM_ALLOC;
 	first_vm.size = pcpu_chunk_size;
 	first_vm.addr = base_addr;
@@ -1557,6 +1552,8 @@ ssize_t __init pcpu_page_first_chunk(size_t reserved_size,
 {
 	static struct vm_struct vm;
 	const size_t static_size = __per_cpu_end - __per_cpu_start;
+	ssize_t dyn_size = -1;
+	size_t size_sum, unit_size;
 	char psize_str[16];
 	int unit_pages;
 	size_t pages_size;
@@ -1567,8 +1564,9 @@ ssize_t __init pcpu_page_first_chunk(size_t reserved_size,
 
 	snprintf(psize_str, sizeof(psize_str), "%luK", PAGE_SIZE >> 10);
 
-	unit_pages = PFN_UP(max_t(size_t, static_size + reserved_size,
-				  PCPU_MIN_UNIT_SIZE));
+	size_sum = pcpu_calc_fc_sizes(static_size, reserved_size, &dyn_size);
+	unit_size = max_t(size_t, size_sum, PCPU_MIN_UNIT_SIZE);
+	unit_pages = unit_size >> PAGE_SHIFT;
 
 	/* unaligned allocations can't be freed, round up to page size */
 	pages_size = PFN_ALIGN(unit_pages * nr_cpu_ids * sizeof(pages[0]));
@@ -1591,12 +1589,12 @@ ssize_t __init pcpu_page_first_chunk(size_t reserved_size,
 
 	/* allocate vm area, map the pages and copy static data */
 	vm.flags = VM_ALLOC;
-	vm.size = nr_cpu_ids * unit_pages << PAGE_SHIFT;
+	vm.size = nr_cpu_ids * unit_size;
 	vm_area_register_early(&vm, PAGE_SIZE);
 
 	for_each_possible_cpu(cpu) {
-		unsigned long unit_addr = (unsigned long)vm.addr +
-			(cpu * unit_pages << PAGE_SHIFT);
+		unsigned long unit_addr =
+			(unsigned long)vm.addr + cpu * unit_size;
 
 		for (i = 0; i < unit_pages; i++)
 			populate_pte_fn(unit_addr + (i << PAGE_SHIFT));
@@ -1620,11 +1618,12 @@ ssize_t __init pcpu_page_first_chunk(size_t reserved_size,
 	}
 
 	/* we're ready, commit */
-	pr_info("PERCPU: %d %s pages/cpu @%p s%zu r%zu\n",
-		unit_pages, psize_str, vm.addr, static_size, reserved_size);
+	pr_info("PERCPU: %d %s pages/cpu @%p s%zu r%zu d%zu\n",
+		unit_pages, psize_str, vm.addr, static_size, reserved_size,
+		dyn_size);
 
-	ret = pcpu_setup_first_chunk(static_size, reserved_size, -1,
-				     unit_pages << PAGE_SHIFT, vm.addr, NULL);
+	ret = pcpu_setup_first_chunk(static_size, reserved_size, dyn_size,
+				     unit_size, vm.addr, NULL);
 	goto out_free_ar;
 
 enomem:
-- 
1.6.0.2

