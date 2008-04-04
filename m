Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbYDDAXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbYDDAXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbYDDAXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:23:13 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:40057
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750928AbYDDAXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:23:12 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 6] xen-balloon: use memory hot-add to expand the domain's
	memory
X-Mercurial-Node: cc71cc78d6b0fb4698e069b08c31fb06caa218f2
Message-Id: <cc71cc78d6b0fb4698e0.1207267543@localhost>
In-Reply-To: <patchbomb.1207267540@localhost>
Date: Thu, 03 Apr 2008 17:05:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When expanding a domain beyond its initial size, we must introduce new
page structures to describe the newly added memory.  In the past this has
been done by over-allocating the mem_map[] array to allow space to grow.

This has two disadvantages:
 1 - it sets an upper limit at domain-creation time which cannot be
     later changed, and
 2 - it sets a lower limit on how small a domain can be shrunk, because
     lowmem gets filled with page structures.

This patch uses a different approach.  When the balloon driver wants to
expand the domain, it hot-adds new memory via the hotplug memory driver,
which will allocate new page structures for the memory.  As balloon
driver gets backing memory from the hypervisor, it incrementally onlines
the pages.

Note that memory is never hot-unplugged, so growing a domain to a
large size then shrinking it again will still leave memory full of
page structures.

NB: the newly hotplugged memory will appear in sysfs under
/sys/device/system/memory/memoryX.  This memory can be manually onlined by
"echo online > /sys/device/system/memory/memoryX/state".  DO NOT DO THIS!
The "memory" has no underlying memory until the balloon driver puts it
there, and the domain will crash.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
---
 drivers/xen/balloon.c |  100 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 91 insertions(+), 9 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -40,6 +40,8 @@
 #include <linux/bootmem.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
+#include <linux/ioport.h>
+#include <linux/memory_hotplug.h>
 #include <linux/mutex.h>
 #include <linux/highmem.h>
 #include <linux/list.h>
@@ -60,7 +62,7 @@
 
 #define PAGES2KB(_p) ((_p)<<(PAGE_SHIFT-10))
 
-#define BALLOON_CLASS_NAME "memory"
+#define BALLOON_CLASS_NAME "xen_memory"
 
 struct balloon_stats {
 	/* We aim for 'current allocation' == 'target allocation'. */
@@ -137,6 +139,60 @@
 	}
 }
 
+/* hotplug some memory we can add pages to */
+static void balloon_expand(unsigned pages)
+{
+#ifdef CONFIG_MEMORY_HOTPLUG
+	struct resource *res;
+	int ret;
+	u64 size = (u64)pages * PAGE_SIZE;
+	unsigned pfn;
+	unsigned start_pfn, end_pfn;
+
+	res = kzalloc(sizeof(*res), GFP_KERNEL);
+	if (!res)
+		return;
+
+	res->name = "Xen Balloon";
+	res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+
+	ret = allocate_resource(&iomem_resource, res, size, 0, -1,
+				1ul << SECTION_SIZE_BITS, NULL, NULL);
+
+	if (ret)
+		goto free_res;
+
+	start_pfn = res->start >> PAGE_SHIFT;
+	end_pfn = (res->end + 1) >> PAGE_SHIFT;
+
+	ret = add_memory_resource(0, res);
+	if (ret)
+		goto release_res;
+
+	ret = prepare_online_pages(start_pfn, pages);
+	if (ret)
+		goto release_res;
+
+	for(pfn = start_pfn; pfn < end_pfn; pfn++) {
+		struct page *page = pfn_to_page(pfn);
+
+		SetPageReserved(page);
+		set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
+		balloon_append(page);
+	}
+
+	return;
+
+  release_res:
+	release_resource(res);
+
+  free_res:
+	kfree(res);
+
+	printk(KERN_INFO "balloon_expand failed: ret = %d\n", ret);
+#endif	/* CONFIG_MEMORY_HOTPLUG */
+}
+
 /* balloon_retrieve: rescue a page from the balloon, if it is not empty. */
 static struct page *balloon_retrieve(void)
 {
@@ -178,14 +234,23 @@
 	schedule_work(&balloon_worker);
 }
 
+static unsigned long balloon_remains(void)
+{
+	return balloon_stats.balloon_low + balloon_stats.balloon_high;
+}
+
 static unsigned long current_target(void)
 {
-	unsigned long target = min(balloon_stats.target_pages, balloon_stats.hard_limit);
+	unsigned long target;
 
+	target = min(balloon_stats.target_pages, balloon_stats.hard_limit);
+
+#ifndef CONFIG_MEMORY_HOTPLUG
 	target = min(target,
 		     balloon_stats.current_pages +
 		     balloon_stats.balloon_low +
 		     balloon_stats.balloon_high);
+#endif
 
 	return target;
 }
@@ -241,20 +306,29 @@
 
 		set_phys_to_machine(pfn, frame_list[i]);
 
+		/* Relinquish the page back to the allocator. */
+		mark_pages_onlined(pfn, 1);
+
 		/* Link back into the page tables if not highmem. */
-		if (pfn < max_low_pfn) {
+		if (!PageHighMem(page)) {
 			int ret;
 			ret = HYPERVISOR_update_va_mapping(
 				(unsigned long)__va(pfn << PAGE_SHIFT),
 				mfn_pte(frame_list[i], PAGE_KERNEL),
 				0);
+
+			if (ret) {
+				struct zone *zone = page_zone(page);
+
+				printk("failed to map pfn %lu max_low_pfn %lu "
+				       "addr %p mfn %lx; ret=%d; "
+				       "page->flags=%lx, zone=%d\n",
+					pfn, max_low_pfn, __va(pfn << PAGE_SHIFT),
+				       frame_list[i], ret, page->flags,
+				       zone - zone->zone_pgdat->node_zones);
+			}
 			BUG_ON(ret);
 		}
-
-		/* Relinquish the page back to the allocator. */
-		ClearPageReserved(page);
-		init_page_count(page);
-		__free_page(page);
 	}
 
 	balloon_stats.current_pages += nr_pages;
@@ -282,6 +356,8 @@
 
 	for (i = 0; i < nr_pages; i++) {
 		if ((page = alloc_page(GFP_BALLOON)) == NULL) {
+			printk("managed to get %d/%d pages\n",
+				i, nr_pages);
 			nr_pages = i;
 			need_sleep = 1;
 			break;
@@ -330,8 +406,13 @@
 
 	do {
 		credit = current_target() - balloon_stats.current_pages;
-		if (credit > 0)
+		if (credit > 0) {
+			if (credit > balloon_remains()) {
+				/* Give ourselves some pages to balloon into */
+				balloon_expand(PAGES_PER_SECTION);
+			}
 			need_sleep = (increase_reservation(credit) != 0);
+		}
 		if (credit < 0)
 			need_sleep = (decrease_reservation(-credit) != 0);
 
@@ -426,6 +507,7 @@
 		if (!PageReserved(page))
 			balloon_append(page);
 	}
+
 
 	target_watch.callback = watch_target;
 	xenstore_notifier.notifier_call = balloon_init_watcher;


