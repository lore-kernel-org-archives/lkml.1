Return-Path: <linux-kernel-owner+w=401wt.eu-S933282AbYEBQ4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282AbYEBQ4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 12:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757642AbYEBQ4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 12:56:11 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47841 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824AbYEBQ4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 12:56:10 -0400
Subject: [PATCH] Add sysfs removable attribute for hotplug memory remove
From: Badari Pulavarty <pbadari@us.ibm.com>
To: akpm@linux-foundation.org, Mel Gorman <mel@csn.ul.ie>,
       "kamezawa.hiroyu" <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 02 May 2008 09:56:16 -0700
Message-Id: <1209747376.16169.27.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here is the updated/commented version of the sysfs "removability"
attribute patch for hotplug memory remove (against 2.6.25-git18). 
Could you please consider this for inclusion ?

Thanks,
Badari

Memory may be hot-removed on a per-memory-block basis, particularly on POWER
where the SPARSEMEM section size often matches the memory-block size. A
user-level agent must be able to identify which sections of memory are likely
to be removable before attempting the potentially expensive operation. This
patch adds a file called "removable" to the memory directory in sysfs to
help such an agent.  In this patch, a memory block is considered removable if;

o It contains only MOVABLE pageblocks
o It contains only pageblocks with free pages regardless of pageblock type

On the other hand, a memory block starting with a PageReserved() page will
never be considered removable. Without this patch, the user-agent is
forced to choose a memory block to remove randomly.

Sample output of the sysfs files:

./memory/memory0/removable: 0
./memory/memory1/removable: 0
./memory/memory2/removable: 0
./memory/memory3/removable: 0
./memory/memory4/removable: 0
./memory/memory5/removable: 0
./memory/memory6/removable: 0
./memory/memory7/removable: 1
./memory/memory8/removable: 0
./memory/memory9/removable: 0
./memory/memory10/removable: 0
./memory/memory11/removable: 0
./memory/memory12/removable: 0
./memory/memory13/removable: 0
./memory/memory14/removable: 0
./memory/memory15/removable: 0
./memory/memory16/removable: 0
./memory/memory17/removable: 1
./memory/memory18/removable: 1
./memory/memory19/removable: 1
./memory/memory20/removable: 1
./memory/memory21/removable: 1
./memory/memory22/removable: 1

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/base/memory.c          |   19 +++++++++++++
 include/linux/memory_hotplug.h |   12 ++++++++
 mm/memory_hotplug.c            |   58 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+)

Index: linux-2.6.25/drivers/base/memory.c
===================================================================
--- linux-2.6.25.orig/drivers/base/memory.c	2008-05-02 07:53:06.000000000 -0700
+++ linux-2.6.25/drivers/base/memory.c	2008-05-02 07:53:39.000000000 -0700
@@ -98,6 +98,21 @@ static ssize_t show_mem_phys_index(struc
 }
 
 /*
+ * Show whether the section of memory is likely to be hot-removable
+ */
+static ssize_t show_mem_removable(struct sys_device *dev, char *buf)
+{
+	unsigned long start_pfn;
+	int ret;
+	struct memory_block *mem =
+		container_of(dev, struct memory_block, sysdev);
+
+	start_pfn = section_nr_to_pfn(mem->phys_index);
+	ret = is_mem_section_removable(start_pfn, PAGES_PER_SECTION);
+	return sprintf(buf, "%d\n", ret);
+}
+
+/*
  * online, offline, going offline, etc.
  */
 static ssize_t show_mem_state(struct sys_device *dev, char *buf)
@@ -256,6 +271,7 @@ static ssize_t show_phys_device(struct s
 static SYSDEV_ATTR(phys_index, 0444, show_mem_phys_index, NULL);
 static SYSDEV_ATTR(state, 0644, show_mem_state, store_mem_state);
 static SYSDEV_ATTR(phys_device, 0444, show_phys_device, NULL);
+static SYSDEV_ATTR(removable, 0444, show_mem_removable, NULL);
 
 #define mem_create_simple_file(mem, attr_name)	\
 	sysdev_create_file(&mem->sysdev, &attr_##attr_name)
@@ -344,6 +360,8 @@ static int add_memory_block(unsigned lon
 		ret = mem_create_simple_file(mem, state);
 	if (!ret)
 		ret = mem_create_simple_file(mem, phys_device);
+	if (!ret)
+		ret = mem_create_simple_file(mem, removable);
 
 	return ret;
 }
@@ -388,6 +406,7 @@ int remove_memory_block(unsigned long no
 	mem_remove_simple_file(mem, phys_index);
 	mem_remove_simple_file(mem, state);
 	mem_remove_simple_file(mem, phys_device);
+	mem_remove_simple_file(mem, removable);
 	unregister_memory(mem, section);
 
 	return 0;
Index: linux-2.6.25/include/linux/memory_hotplug.h
===================================================================
--- linux-2.6.25.orig/include/linux/memory_hotplug.h	2008-05-02 07:53:13.000000000 -0700
+++ linux-2.6.25/include/linux/memory_hotplug.h	2008-05-02 07:53:39.000000000 -0700
@@ -199,6 +199,18 @@ static inline void register_page_bootmem
 
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
+
+extern int is_mem_section_removable(unsigned long pfn, unsigned long nr_pages);
+
+#else
+static inline int is_mem_section_removable(unsigned long pfn,
+					unsigned long nr_pages)
+{
+	return 0;
+}
+#endif /* CONFIG_MEMORY_HOTREMOVE */
+
 extern int add_memory(int nid, u64 start, u64 size);
 extern int arch_add_memory(int nid, u64 start, u64 size);
 extern int remove_memory(u64 start, u64 size);
Index: linux-2.6.25/mm/memory_hotplug.c
===================================================================
--- linux-2.6.25.orig/mm/memory_hotplug.c	2008-05-02 07:53:13.000000000 -0700
+++ linux-2.6.25/mm/memory_hotplug.c	2008-05-02 07:54:31.000000000 -0700
@@ -513,6 +513,64 @@ EXPORT_SYMBOL_GPL(add_memory);
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
 /*
+ * A free page on the buddy free lists (not the per-cpu lists) has PageBuddy
+ * set and the size of the free page is given by page_order(). Using this,
+ * the function determines if the pageblock contains only free pages.
+ * Due to buddy contraints, a free page at least the size of a pageblock will
+ * be located at the start of the pageblock
+ */
+static inline int pageblock_free(struct page *page)
+{
+	return PageBuddy(page) && page_order(page) >= pageblock_order;
+}
+
+/* Return the start of the next active pageblock after a given page */
+static struct page *next_active_pageblock(struct page *page)
+{
+	/* Ensure the starting page is pageblock-aligned */
+	BUG_ON(page_to_pfn(page) & (pageblock_nr_pages - 1));
+
+	/* Move forward by at least 1 * pageblock_nr_pages */
+	int pageblocks_stride = 1;
+
+	/* If the entire pageblock is free, move to the end of free page */
+	if (pageblock_free(page))
+		pageblocks_stride += page_order(page) - pageblock_order;
+
+	return page + (pageblocks_stride * pageblock_nr_pages);
+}
+
+/* Checks if this range of memory is likely to be hot-removable. */
+int is_mem_section_removable(unsigned long start_pfn, unsigned long nr_pages)
+{
+	int type;
+	struct page *page = pfn_to_page(start_pfn);
+	struct page *end_page = page + nr_pages;
+
+	/* Check the starting page of each pageblock within the range */
+	for (; page < end_page; page = next_active_pageblock(page)) {
+		type = get_pageblock_migratetype(page);
+
+		/*
+		 * A pageblock containing MOVABLE or free pages is considered
+		 * removable
+		 */
+		if (type != MIGRATE_MOVABLE && !pageblock_free(page))
+			return 0;
+
+		/*
+		 * A pageblock starting with a PageReserved page is not
+		 * considered removable.
+		 */
+		if (PageReserved(page))
+			return 0;
+	}
+
+	/* All pageblocks in the memory block are likely to be hot-removable */
+	return 1;
+}
+
+/*
  * Confirm all pages in a range [start, end) is belongs to the same zone.
  */
 static int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn)


