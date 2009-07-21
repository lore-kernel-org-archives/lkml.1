Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZGUK31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZGUK31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbZGUK2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:28:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:37080 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964AbZGUK2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:28:05 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       rusty@rustcorp.com.au, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/20] percpu: rename 4k first chunk allocator to page
Date: Tue, 21 Jul 2009 19:26:02 +0900
Message-Id: <1248171979-29166-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1248171979-29166-1-git-send-email-tj@kernel.org>
References: <1248171979-29166-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 10:26:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Page size isn't always 4k depending on arch and configuration.  Rename
4k first chunk allocator to page.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Howells <dhowells@redhat.com>
---
 Documentation/kernel-parameters.txt |    2 +-
 arch/x86/kernel/setup_percpu.c      |   23 ++++++++++++-----------
 include/linux/percpu.h              |    2 +-
 mm/percpu.c                         |   25 ++++++++++++++-----------
 4 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index dd1a6d4..faa7178 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1916,7 +1916,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			See arch/parisc/kernel/pdc_chassis.c
 
 	percpu_alloc=	[X86] Select which percpu first chunk allocator to use.
-			Allowed values are one of "lpage", "embed" and "4k".
+			Allowed values are one of "lpage", "embed" and "page".
 			See comments in arch/x86/kernel/setup_percpu.c for
 			details on each allocator.  This parameter is primarily
 			for debugging and performance comparison.
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 7501bb1..3c943b4 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -249,21 +249,22 @@ static ssize_t __init setup_pcpu_embed(size_t static_size, bool chosen)
 }
 
 /*
- * 4k allocator
+ * Page allocator
  *
- * Boring fallback 4k allocator.  This allocator puts more pressure on
- * PTE TLBs but other than that behaves nicely on both UMA and NUMA.
+ * Boring fallback 4k page allocator.  This allocator puts more
+ * pressure on PTE TLBs but other than that behaves nicely on both UMA
+ * and NUMA.
  */
-static void __init pcpu4k_populate_pte(unsigned long addr)
+static void __init pcpup_populate_pte(unsigned long addr)
 {
 	populate_extra_pte(addr);
 }
 
-static ssize_t __init setup_pcpu_4k(size_t static_size)
+static ssize_t __init setup_pcpu_page(size_t static_size)
 {
-	return pcpu_4k_first_chunk(static_size, PERCPU_FIRST_CHUNK_RESERVE,
-				   pcpu_fc_alloc, pcpu_fc_free,
-				   pcpu4k_populate_pte);
+	return pcpu_page_first_chunk(static_size, PERCPU_FIRST_CHUNK_RESERVE,
+				     pcpu_fc_alloc, pcpu_fc_free,
+				     pcpup_populate_pte);
 }
 
 /* for explicit first chunk allocator selection */
@@ -307,7 +308,7 @@ void __init setup_per_cpu_areas(void)
 	 */
 	ret = -EINVAL;
 	if (strlen(pcpu_chosen_alloc)) {
-		if (strcmp(pcpu_chosen_alloc, "4k")) {
+		if (strcmp(pcpu_chosen_alloc, "page")) {
 			if (!strcmp(pcpu_chosen_alloc, "lpage"))
 				ret = setup_pcpu_lpage(static_size, true);
 			else if (!strcmp(pcpu_chosen_alloc, "embed"))
@@ -317,7 +318,7 @@ void __init setup_per_cpu_areas(void)
 					   "specified\n", pcpu_chosen_alloc);
 			if (ret < 0)
 				pr_warning("PERCPU: %s allocator failed (%zd), "
-					   "falling back to 4k\n",
+					   "falling back to page\n",
 					   pcpu_chosen_alloc, ret);
 		}
 	} else {
@@ -326,7 +327,7 @@ void __init setup_per_cpu_areas(void)
 			ret = setup_pcpu_embed(static_size, false);
 	}
 	if (ret < 0)
-		ret = setup_pcpu_4k(static_size);
+		ret = setup_pcpu_page(static_size);
 	if (ret < 0)
 		panic("cannot allocate static percpu area (%zu bytes, err=%zd)",
 		      static_size, ret);
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index e134c82..7989f61 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -74,7 +74,7 @@ extern ssize_t __init pcpu_embed_first_chunk(
 				size_t static_size, size_t reserved_size,
 				ssize_t dyn_size);
 
-extern ssize_t __init pcpu_4k_first_chunk(
+extern ssize_t __init pcpu_page_first_chunk(
 				size_t static_size, size_t reserved_size,
 				pcpu_fc_alloc_fn_t alloc_fn,
 				pcpu_fc_free_fn_t free_fn,
diff --git a/mm/percpu.c b/mm/percpu.c
index 80317dc..27a3033 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1497,15 +1497,15 @@ ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
 }
 
 /**
- * pcpu_4k_first_chunk - map the first chunk using PAGE_SIZE pages
+ * pcpu_page_first_chunk - map the first chunk using PAGE_SIZE pages
  * @static_size: the size of static percpu area in bytes
  * @reserved_size: the size of reserved percpu area in bytes
  * @alloc_fn: function to allocate percpu page, always called with PAGE_SIZE
  * @free_fn: funtion to free percpu page, always called with PAGE_SIZE
  * @populate_pte_fn: function to populate pte
  *
- * This is a helper to ease setting up embedded first percpu chunk and
- * can be called where pcpu_setup_first_chunk() is expected.
+ * This is a helper to ease setting up page-remapped first percpu
+ * chunk and can be called where pcpu_setup_first_chunk() is expected.
  *
  * This is the basic allocator.  Static percpu area is allocated
  * page-by-page into vmalloc area.
@@ -1514,12 +1514,13 @@ ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
  * The determined pcpu_unit_size which can be used to initialize
  * percpu access on success, -errno on failure.
  */
-ssize_t __init pcpu_4k_first_chunk(size_t static_size, size_t reserved_size,
-				   pcpu_fc_alloc_fn_t alloc_fn,
-				   pcpu_fc_free_fn_t free_fn,
-				   pcpu_fc_populate_pte_fn_t populate_pte_fn)
+ssize_t __init pcpu_page_first_chunk(size_t static_size, size_t reserved_size,
+				     pcpu_fc_alloc_fn_t alloc_fn,
+				     pcpu_fc_free_fn_t free_fn,
+				     pcpu_fc_populate_pte_fn_t populate_pte_fn)
 {
 	static struct vm_struct vm;
+	char psize_str[16];
 	int unit_pages;
 	size_t pages_size;
 	struct page **pages;
@@ -1527,6 +1528,8 @@ ssize_t __init pcpu_4k_first_chunk(size_t static_size, size_t reserved_size,
 	int i, j;
 	ssize_t ret;
 
+	snprintf(psize_str, sizeof(psize_str), "%luK", PAGE_SIZE >> 10);
+
 	unit_pages = PFN_UP(max_t(size_t, static_size + reserved_size,
 				  PCPU_MIN_UNIT_SIZE));
 
@@ -1542,8 +1545,8 @@ ssize_t __init pcpu_4k_first_chunk(size_t static_size, size_t reserved_size,
 
 			ptr = alloc_fn(cpu, PAGE_SIZE);
 			if (!ptr) {
-				pr_warning("PERCPU: failed to allocate "
-					   "4k page for cpu%u\n", cpu);
+				pr_warning("PERCPU: failed to allocate %s page "
+					   "for cpu%u\n", psize_str, cpu);
 				goto enomem;
 			}
 			pages[j++] = virt_to_page(ptr);
@@ -1580,8 +1583,8 @@ ssize_t __init pcpu_4k_first_chunk(size_t static_size, size_t reserved_size,
 	}
 
 	/* we're ready, commit */
-	pr_info("PERCPU: %d 4k pages/cpu @%p s%zu r%zu\n",
-		unit_pages, vm.addr, static_size, reserved_size);
+	pr_info("PERCPU: %d %s pages/cpu @%p s%zu r%zu\n",
+		unit_pages, psize_str, vm.addr, static_size, reserved_size);
 
 	ret = pcpu_setup_first_chunk(static_size, reserved_size, -1,
 				     unit_pages << PAGE_SHIFT, vm.addr, NULL);
-- 
1.6.0.2

