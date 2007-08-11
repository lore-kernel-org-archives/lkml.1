Return-Path: <linux-kernel-owner+w=401wt.eu-S1764139AbXHKTBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764139AbXHKTBf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759211AbXHKS6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:58:18 -0400
Received: from 1wt.eu ([62.212.114.60]:1532 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762222AbXHKS6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:58:14 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184837.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:48:00 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Zou Nan hai <nanhai.zou@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 08/28] x86_64: allocate sparsemem memmap above 4G
Content-Disposition: inline; filename=0008-PATCH-x86_64-allocate-sparsemem-memmap-above-4G.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On systems with huge amount of physical memory, VFS cache and memory memmap
may eat all available system memory under 4G, then the system may fail to
allocate swiotlb bounce buffer.

There was a fix for this issue in arch/x86_64/mm/numa.c, but that fix dose
not cover sparsemem model.

This patch add fix to sparsemem model by first try to allocate memmap above
4G.

Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[chrisw: trivial backport]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86_64/mm/init.c   |    6 ++++++
 include/linux/bootmem.h |    1 +
 mm/sparse.c             |   11 +++++++++++
 3 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86_64/mm/init.c b/arch/x86_64/mm/init.c
index 2968b90..2489aa7 100644
--- a/arch/x86_64/mm/init.c
+++ b/arch/x86_64/mm/init.c
@@ -766,3 +766,9 @@ int in_gate_area_no_task(unsigned long addr)
 {
 	return (addr >= VSYSCALL_START) && (addr < VSYSCALL_END);
 }
+
+void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
+{
+	return __alloc_bootmem_core(pgdat->bdata, size,
+			SMP_CACHE_BYTES, (4UL*1024*1024*1024), 0);
+}
diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index 2275f27..8f820e4 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -59,6 +59,7 @@ extern void *__alloc_bootmem_core(struct bootmem_data *bdata,
 				  unsigned long align,
 				  unsigned long goal,
 				  unsigned long limit);
+extern void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size);
 
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
 extern void reserve_bootmem(unsigned long addr, unsigned long size);
diff --git a/mm/sparse.c b/mm/sparse.c
index ac26eb0..faa08e2 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -209,6 +209,12 @@ static int sparse_init_one_section(struct mem_section *ms,
 	return 1;
 }
 
+__attribute__((weak))
+void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
+{
+	return NULL;
+}
+
 static struct page *sparse_early_mem_map_alloc(unsigned long pnum)
 {
 	struct page *map;
@@ -219,6 +225,11 @@ static struct page *sparse_early_mem_map_alloc(unsigned long pnum)
 	if (map)
 		return map;
 
+  	map = alloc_bootmem_high_node(NODE_DATA(nid),
+                       sizeof(struct page) * PAGES_PER_SECTION);
+	if (map)
+		return map;
+
 	map = alloc_bootmem_node(NODE_DATA(nid),
 			sizeof(struct page) * PAGES_PER_SECTION);
 	if (map)
-- 
1.5.2.4

-- 
