Return-Path: <linux-kernel-owner+w=401wt.eu-S1759663AbYDDAde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759663AbYDDAde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbYDDAdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:33:12 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:43594
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754042AbYDDAdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:33:11 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 5 of 6] hotplug-memory: add section_ops
X-Mercurial-Node: 785fe0877fea0f488bc5b951ac147d08570e6062
Message-Id: <785fe0877fea0f488bc5.1207267545@localhost>
In-Reply-To: <patchbomb.1207267540@localhost>
Date: Thu, 03 Apr 2008 17:05:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a per-section "section_ops" structure,  allowing each section to have
specific functions for onlining and offlining pages within the section.
This is used by the Xen balloon driver to make sure that pages are not
onlined without some physical memory backing them.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/ia64/mm/init.c            |    4 ++--
 arch/powerpc/mm/mem.c          |    5 +++--
 arch/sh/mm/init.c              |    4 ++--
 arch/x86/mm/init_32.c          |    7 ++++---
 arch/x86/mm/init_64.c          |    4 ++--
 drivers/xen/balloon.c          |    2 +-
 include/linux/memory_hotplug.h |   18 +++++++++++++-----
 include/linux/mmzone.h         |    2 ++
 mm/memory_hotplug.c            |   32 +++++++++++++++++++++-----------
 mm/sparse.c                    |    3 ++-
 10 files changed, 52 insertions(+), 29 deletions(-)

diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -690,7 +690,7 @@
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-int arch_add_memory(int nid, u64 start, u64 size)
+int arch_add_memory(int nid, u64 start, u64 size, const struct section_ops *ops)
 {
 	pg_data_t *pgdat;
 	struct zone *zone;
@@ -701,7 +701,7 @@
 	pgdat = NODE_DATA(nid);
 
 	zone = pgdat->node_zones + ZONE_NORMAL;
-	ret = __add_pages(zone, start_pfn, nr_pages);
+	ret = __add_pages(zone, start_pfn, nr_pages, ops);
 
 	if (ret)
 		printk("%s: Problem encountered in __add_pages() as ret=%d\n",
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -102,7 +102,8 @@
 }
 #endif
 
-int __devinit arch_add_memory(int nid, u64 start, u64 size)
+int __devinit arch_add_memory(int nid, u64 start, u64 size,
+			      const struct section_ops *ops)
 {
 	struct pglist_data *pgdata;
 	struct zone *zone;
@@ -117,7 +118,7 @@
 	/* this should work for most non-highmem platforms */
 	zone = pgdata->node_zones;
 
-	return __add_pages(zone, start_pfn, nr_pages);
+	return __add_pages(zone, start_pfn, nr_pages, ops);
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -307,7 +307,7 @@
 #endif
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-int arch_add_memory(int nid, u64 start, u64 size)
+int arch_add_memory(int nid, u64 start, u64 size, const struct section_ops *ops)
 {
 	pg_data_t *pgdat;
 	unsigned long start_pfn = start >> PAGE_SHIFT;
@@ -317,7 +317,7 @@
 	pgdat = NODE_DATA(nid);
 
 	/* We only have ZONE_NORMAL, so this is easy.. */
-	ret = __add_pages(pgdat->node_zones + ZONE_NORMAL, start_pfn, nr_pages);
+	ret = __add_pages(pgdat->node_zones + ZONE_NORMAL, start_pfn, nr_pages, ops);
 	if (unlikely(ret))
 		printk("%s: Failed, __add_pages() == %d\n", __func__, ret);
 
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -322,10 +322,11 @@
  * has been added dynamically that would be
  * onlined here is in HIGHMEM.
  */
-void __meminit online_page(struct page *page)
+bool __meminit online_page(struct page *page)
 {
 	ClearPageReserved(page);
 	add_one_highpage_hotplug(page, page_to_pfn(page));
+	return true;
 }
 
 #ifndef CONFIG_NUMA
@@ -706,14 +707,14 @@
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-int arch_add_memory(int nid, u64 start, u64 size)
+int arch_add_memory(int nid, u64 start, u64 size, const struct section_ops *ops)
 {
 	struct pglist_data *pgdata = NODE_DATA(nid);
 	struct zone *zone = pgdata->node_zones + ZONE_HIGHMEM;
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	return __add_pages(zone, start_pfn, nr_pages);
+	return __add_pages(zone, start_pfn, nr_pages, ops);
 }
 #endif
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -629,7 +629,7 @@
  * Memory is added always to NORMAL zone. This means you will never get
  * additional DMA/DMA32 memory.
  */
-int arch_add_memory(int nid, u64 start, u64 size)
+int arch_add_memory(int nid, u64 start, u64 size, const struct section_ops *ops)
 {
 	struct pglist_data *pgdat = NODE_DATA(nid);
 	struct zone *zone = pgdat->node_zones + ZONE_NORMAL;
@@ -641,7 +641,7 @@
 	if (last_mapped_pfn > max_pfn_mapped)
 		max_pfn_mapped = last_mapped_pfn;
 
-	ret = __add_pages(zone, start_pfn, nr_pages);
+	ret = __add_pages(zone, start_pfn, nr_pages, ops);
 	WARN_ON(1);
 
 	return ret;
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -165,7 +165,7 @@
 	start_pfn = res->start >> PAGE_SHIFT;
 	end_pfn = (res->end + 1) >> PAGE_SHIFT;
 
-	ret = add_memory_resource(0, res);
+	ret = add_memory_resource(0, res, &default_section_ops);
 	if (ret)
 		goto release_res;
 
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -8,6 +8,10 @@
 struct page;
 struct zone;
 struct pglist_data;
+struct section_ops {
+    bool (*online_page)(struct page *);
+    bool (*offline_page)(struct page *);
+};
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 /*
@@ -55,7 +59,7 @@
 extern int zone_grow_waitqueues(struct zone *zone, unsigned long nr_pages);
 extern int add_one_highpage(struct page *page, int pfn, int bad_ppro);
 /* need some defines for these for archs that don't support it */
-extern void online_page(struct page *page);
+extern bool online_page(struct page *page);
 /* VM interface that may be used by firmware interface */
 extern int prepare_online_pages(unsigned long pfn, unsigned long nr_pages);
 extern unsigned long mark_pages_onlined(unsigned long pfn, unsigned long nr_pages);
@@ -66,7 +70,7 @@
 
 /* reasonably generic interface to expand the physical pages in a zone  */
 extern int __add_pages(struct zone *zone, unsigned long start_pfn,
-	unsigned long nr_pages);
+		       unsigned long nr_pages, const struct section_ops *ops);
 
 /*
  * Walk thorugh all memory which is registered as resource.
@@ -176,11 +180,15 @@
 
 struct resource;
 
+extern const struct section_ops default_section_ops;
+
 extern int add_memory(int nid, u64 start, u64 size);
-extern int add_memory_resource(int nid, struct resource *res);
-extern int arch_add_memory(int nid, u64 start, u64 size);
+extern int add_memory_resource(int nid, struct resource *res,
+			       const struct section_ops *ops);
+extern int arch_add_memory(int nid, u64 start, u64 size,
+			   const struct section_ops *ops);
 extern int remove_memory(u64 start, u64 size);
 extern int sparse_add_one_section(struct zone *zone, unsigned long start_pfn,
-								int nr_pages);
+				  int nr_pages, const struct section_ops *ops);
 
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -809,6 +809,8 @@
 
 	/* See declaration of similar field in struct zone */
 	unsigned long *pageblock_flags;
+
+	const struct section_ops *ops;
 };
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -80,7 +80,8 @@
 	return 0;
 }
 
-static int __add_section(struct zone *zone, unsigned long phys_start_pfn)
+static int __add_section(struct zone *zone, unsigned long phys_start_pfn,
+			 const struct section_ops *ops)
 {
 	int nr_pages = PAGES_PER_SECTION;
 	int ret;
@@ -88,7 +89,7 @@
 	if (pfn_valid(phys_start_pfn))
 		return -EEXIST;
 
-	ret = sparse_add_one_section(zone, phys_start_pfn, nr_pages);
+	ret = sparse_add_one_section(zone, phys_start_pfn, nr_pages, ops);
 
 	if (ret < 0)
 		return ret;
@@ -108,7 +109,7 @@
  * add the new pages.
  */
 int __add_pages(struct zone *zone, unsigned long phys_start_pfn,
-		 unsigned long nr_pages)
+		unsigned long nr_pages, const struct section_ops *ops)
 {
 	unsigned long i;
 	int err = 0;
@@ -118,7 +119,7 @@
 	end_sec = pfn_to_section_nr(phys_start_pfn + nr_pages - 1);
 
 	for (i = start_sec; i <= end_sec; i++) {
-		err = __add_section(zone, i << PFN_SECTION_SHIFT);
+		err = __add_section(zone, i << PFN_SECTION_SHIFT, ops);
 
 		/*
 		 * EEXIST is finally dealt with by ioresource collision
@@ -147,13 +148,14 @@
 					pgdat->node_start_pfn;
 }
 
-__weak void online_page(struct page *page)
+__weak bool online_page(struct page *page)
 {
 	ClearPageReserved(page);
 	init_page_count(page);
 	__free_page(page);
 	totalram_pages++;
 	num_physpages++;
+	return true;
 }
 
 static void grow_zone_span(unsigned long start_pfn, unsigned long end_pfn)
@@ -193,9 +195,13 @@
 	struct page *page;
 	if (PageReserved(pfn_to_page(start_pfn)))
 		for (i = 0; i < nr_pages; i++) {
-			page = pfn_to_page(start_pfn + i);
-			online_page(page);
-			onlined_pages++;
+			unsigned long pfn = start_pfn + i;
+			struct mem_section *ms = __pfn_to_section(pfn);
+
+			page = pfn_to_page(pfn);
+
+			if (ms->ops->online_page(page))
+				onlined_pages++;
 		}
 	*(unsigned long *)arg = onlined_pages;
 	return 0;
@@ -318,6 +324,10 @@
 	return;
 }
 
+const struct section_ops default_section_ops = {
+	.online_page = online_page,
+	.offline_page = NULL,
+};
 
 int add_memory(int nid, u64 start, u64 size)
 {
@@ -328,7 +338,7 @@
 	if (!res)
 		return -EEXIST;
 
-	ret = add_memory_resource(nid, res);
+	ret = add_memory_resource(nid, res, &default_section_ops);
 
 	if (ret)
 		release_memory_resource(res);
@@ -336,7 +346,7 @@
 	return ret;
 }
 
-int add_memory_resource(int nid, struct resource *res)
+int add_memory_resource(int nid, struct resource *res, const struct section_ops *ops)
 {
 	pg_data_t *pgdat = NULL;
 	int new_pgdat = 0;
@@ -352,7 +362,7 @@
 	}
 
 	/* call arch's memory hotadd */
-	ret = arch_add_memory(nid, start, size);
+	ret = arch_add_memory(nid, start, size, ops);
 
 	if (ret < 0)
 		goto error;
diff --git a/mm/sparse.c b/mm/sparse.c
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -393,7 +393,7 @@
  * map was not consumed and must be freed.
  */
 int sparse_add_one_section(struct zone *zone, unsigned long start_pfn,
-			   int nr_pages)
+			   int nr_pages, const struct section_ops *ops)
 {
 	unsigned long section_nr = pfn_to_section_nr(start_pfn);
 	struct pglist_data *pgdat = zone->zone_pgdat;
@@ -428,6 +428,7 @@
 	}
 
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
+	ms->ops = ops;
 
 	ret = sparse_init_one_section(ms, section_nr, memmap, usemap);
 


