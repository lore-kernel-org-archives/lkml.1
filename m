Return-Path: <linux-kernel-owner+w=401wt.eu-S1758873AbYKVRdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbYKVRdd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758690AbYKVRd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:33:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55266 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758684AbYKVRdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:33:25 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 1/32] meminit section warnings
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L3wMG-0006F3-Hw@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:33:24 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/page_cgroup.h |    4 ++--
 mm/memory_hotplug.c         |    9 +++++----
 mm/page_cgroup.c            |   13 +++++++------
 mm/sparse.c                 |    2 +-
 4 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -17,7 +17,7 @@ struct page_cgroup {
 	struct list_head lru;		/* per cgroup LRU list */
 };
 
-void __init pgdat_page_cgroup_init(struct pglist_data *pgdat);
+void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat);
 void __init page_cgroup_init(void);
 struct page_cgroup *lookup_page_cgroup(struct page *page);
 
@@ -91,7 +91,7 @@ static inline void unlock_page_cgroup(struct page_cgroup *pc)
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct page_cgroup;
 
-static inline void pgdat_page_cgroup_init(struct pglist_data *pgdat)
+static inline void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
 {
 }
 
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -189,7 +189,7 @@ static void grow_pgdat_span(struct pglist_data *pgdat, unsigned long start_pfn,
 					pgdat->node_start_pfn;
 }
 
-static int __add_zone(struct zone *zone, unsigned long phys_start_pfn)
+static int __meminit __add_zone(struct zone *zone, unsigned long phys_start_pfn)
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nr_pages = PAGES_PER_SECTION;
@@ -216,7 +216,7 @@ static int __add_zone(struct zone *zone, unsigned long phys_start_pfn)
 	return 0;
 }
 
-static int __add_section(struct zone *zone, unsigned long phys_start_pfn)
+static int __meminit __add_section(struct zone *zone, unsigned long phys_start_pfn)
 {
 	int nr_pages = PAGES_PER_SECTION;
 	int ret;
@@ -273,7 +273,7 @@ static int __remove_section(struct zone *zone, struct mem_section *ms)
  * call this function after deciding the zone to which to
  * add the new pages.
  */
-int __add_pages(struct zone *zone, unsigned long phys_start_pfn,
+int __ref __add_pages(struct zone *zone, unsigned long phys_start_pfn,
 		 unsigned long nr_pages)
 {
 	unsigned long i;
@@ -470,7 +470,8 @@ static void rollback_node_hotadd(int nid, pg_data_t *pgdat)
 }
 
 
-int add_memory(int nid, u64 start, u64 size)
+/* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
+int __ref add_memory(int nid, u64 start, u64 size)
 {
 	pg_data_t *pgdat = NULL;
 	int new_pgdat = 0;
diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -21,7 +21,7 @@ static unsigned long total_usage;
 #if !defined(CONFIG_SPARSEMEM)
 
 
-void __init pgdat_page_cgroup_init(struct pglist_data *pgdat)
+void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
 {
 	pgdat->node_page_cgroup = NULL;
 }
@@ -97,7 +97,8 @@ struct page_cgroup *lookup_page_cgroup(struct page *page)
 	return section->page_cgroup + pfn;
 }
 
-int __meminit init_section_page_cgroup(unsigned long pfn)
+/* __alloc_bootmem...() is protected by !slab_available() */
+int __init_refok init_section_page_cgroup(unsigned long pfn)
 {
 	struct mem_section *section;
 	struct page_cgroup *base, *pc;
@@ -158,7 +159,7 @@ void __free_page_cgroup(unsigned long pfn)
 	}
 }
 
-int online_page_cgroup(unsigned long start_pfn,
+int __meminit online_page_cgroup(unsigned long start_pfn,
 			unsigned long nr_pages,
 			int nid)
 {
@@ -183,7 +184,7 @@ int online_page_cgroup(unsigned long start_pfn,
 	return -ENOMEM;
 }
 
-int offline_page_cgroup(unsigned long start_pfn,
+int __meminit offline_page_cgroup(unsigned long start_pfn,
 		unsigned long nr_pages, int nid)
 {
 	unsigned long start, end, pfn;
@@ -197,7 +198,7 @@ int offline_page_cgroup(unsigned long start_pfn,
 
 }
 
-static int page_cgroup_callback(struct notifier_block *self,
+static int __meminit page_cgroup_callback(struct notifier_block *self,
 			       unsigned long action, void *arg)
 {
 	struct memory_notify *mn = arg;
@@ -248,7 +249,7 @@ void __init page_cgroup_init(void)
 	" want\n");
 }
 
-void __init pgdat_page_cgroup_init(struct pglist_data *pgdat)
+void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
 {
 	return;
 }
diff --git a/mm/sparse.c b/mm/sparse.c
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -570,7 +570,7 @@ static void free_section_usemap(struct page *memmap, unsigned long *usemap)
  * set.  If this is <=0, then that means that the passed-in
  * map was not consumed and must be freed.
  */
-int sparse_add_one_section(struct zone *zone, unsigned long start_pfn,
+int __meminit sparse_add_one_section(struct zone *zone, unsigned long start_pfn,
 			   int nr_pages)
 {
 	unsigned long section_nr = pfn_to_section_nr(start_pfn);
