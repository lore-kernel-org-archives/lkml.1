Return-Path: <linux-kernel-owner+w=401wt.eu-S1751696AbXISCdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbXISCdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 22:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbXISCcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 22:32:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53918 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbXISCcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 22:32:41 -0400
Date: Wed, 19 Sep 2007 11:34:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, GOTO <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH] fix memory hot remove not configured case.
Message-Id: <20070919113427.2d252e13.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070919112029.3a938f47.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070919112029.3a938f47.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry... I sent old version...it returns -ENOSYS.

Andrew-san, please replace.
Goto-san, please confirm and ack.
==
Now, arch dependent code around CONFIG_MEMORY_HOTREMOVE is a mess.
This patch cleans up them.

 - For !CONFIG_MEMORY_HOTREMOVE, add generic no-op remove_memory(),
   which returns -EINVAL.
 - removed remove_pages() only used in powerpc.
 - removed no-op remove_memory() in i386, sh, sparc64, x86_64.

 - only powerpc returns -ENOSYS at memory hot remove. changes it
   to return -EINVAL.

Note:
Currently, only ia64 supports CONFIG_MEMORY_HOTREMOVE. I welcome other
archs if there are requirements and testers.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 arch/i386/mm/init.c            |    5 ----
 arch/ia64/mm/init.c            |    3 +-
 arch/powerpc/mm/mem.c          |   45 -----------------------------------------
 arch/sh/mm/init.c              |    6 -----
 arch/sparc64/mm/init.c         |    5 ----
 arch/x86_64/mm/init.c          |    6 -----
 include/linux/memory_hotplug.h |   12 +---------
 mm/memory_hotplug.c            |    6 +++++
 8 files changed, 10 insertions(+), 78 deletions(-)

Index: linux-2.6.23-rc6-mm1/arch/ia64/mm/init.c
===================================================================
--- linux-2.6.23-rc6-mm1.orig/arch/ia64/mm/init.c
+++ linux-2.6.23-rc6-mm1/arch/ia64/mm/init.c
@@ -719,7 +719,7 @@ int arch_add_memory(int nid, u64 start, 
 
 	return ret;
 }
-
+#ifdef CONFIG_MEMORY_HOTREMOVE
 int remove_memory(u64 start, u64 size)
 {
 	unsigned long start_pfn, end_pfn;
@@ -735,4 +735,5 @@ out:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(remove_memory);
+#endif /* CONFIG_MEMORY_HOTREMOVE */
 #endif
Index: linux-2.6.23-rc6-mm1/arch/powerpc/mm/mem.c
===================================================================
--- linux-2.6.23-rc6-mm1.orig/arch/powerpc/mm/mem.c
+++ linux-2.6.23-rc6-mm1/arch/powerpc/mm/mem.c
@@ -129,51 +129,6 @@ int __devinit arch_add_memory(int nid, u
 	return __add_pages(zone, start_pfn, nr_pages);
 }
 
-/*
- * First pass at this code will check to determine if the remove
- * request is within the RMO.  Do not allow removal within the RMO.
- */
-int __devinit remove_memory(u64 start, u64 size)
-{
-	struct zone *zone;
-	unsigned long start_pfn, end_pfn, nr_pages;
-
-	start_pfn = start >> PAGE_SHIFT;
-	nr_pages = size >> PAGE_SHIFT;
-	end_pfn = start_pfn + nr_pages;
-
-	printk("%s(): Attempting to remove memoy in range "
-			"%lx to %lx\n", __func__, start, start+size);
-	/*
-	 * check for range within RMO
-	 */
-	zone = page_zone(pfn_to_page(start_pfn));
-
-	printk("%s(): memory will be removed from "
-			"the %s zone\n", __func__, zone->name);
-
-	/*
-	 * not handling removing memory ranges that
-	 * overlap multiple zones yet
-	 */
-	if (end_pfn > (zone->zone_start_pfn + zone->spanned_pages))
-		goto overlap;
-
-	/* make sure it is NOT in RMO */
-	if ((start < lmb.rmo_size) || ((start+size) < lmb.rmo_size)) {
-		printk("%s(): range to be removed must NOT be in RMO!\n",
-			__func__);
-		goto in_rmo;
-	}
-
-	return __remove_pages(zone, start_pfn, nr_pages);
-
-overlap:
-	printk("%s(): memory range to be removed overlaps "
-		"multiple zones!!!\n", __func__);
-in_rmo:
-	return -1;
-}
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 void show_mem(void)
Index: linux-2.6.23-rc6-mm1/arch/x86_64/mm/init.c
===================================================================
--- linux-2.6.23-rc6-mm1.orig/arch/x86_64/mm/init.c
+++ linux-2.6.23-rc6-mm1/arch/x86_64/mm/init.c
@@ -474,12 +474,6 @@ error:
 }
 EXPORT_SYMBOL_GPL(arch_add_memory);
 
-int remove_memory(u64 start, u64 size)
-{
-	return -EINVAL;
-}
-EXPORT_SYMBOL_GPL(remove_memory);
-
 #if !defined(CONFIG_ACPI_NUMA) && defined(CONFIG_NUMA)
 int memory_add_physaddr_to_nid(u64 start)
 {
Index: linux-2.6.23-rc6-mm1/include/linux/memory_hotplug.h
===================================================================
--- linux-2.6.23-rc6-mm1.orig/include/linux/memory_hotplug.h
+++ linux-2.6.23-rc6-mm1/include/linux/memory_hotplug.h
@@ -58,10 +58,9 @@ extern int add_one_highpage(struct page 
 extern void online_page(struct page *page);
 /* VM interface that may be used by firmware interface */
 extern int online_pages(unsigned long, unsigned long);
-#ifdef CONFIG_MEMORY_HOTREMOVE
-extern int offline_pages(unsigned long, unsigned long, unsigned long);
 extern void __offline_isolated_pages(unsigned long, unsigned long);
-#endif
+extern int offline_pages(unsigned long, unsigned long, unsigned long);
+
 /* reasonably generic interface to expand the physical pages in a zone  */
 extern int __add_pages(struct zone *zone, unsigned long start_pfn,
 	unsigned long nr_pages);
@@ -171,13 +170,6 @@ static inline int mhp_notimplemented(con
 }
 
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
-static inline int __remove_pages(struct zone *zone, unsigned long start_pfn,
-	unsigned long nr_pages)
-{
-	printk(KERN_WARNING "%s() called, not yet supported\n", __FUNCTION__);
-	dump_stack();
-	return -ENOSYS;
-}
 
 extern int add_memory(int nid, u64 start, u64 size);
 extern int arch_add_memory(int nid, u64 start, u64 size);
Index: linux-2.6.23-rc6-mm1/mm/memory_hotplug.c
===================================================================
--- linux-2.6.23-rc6-mm1.orig/mm/memory_hotplug.c
+++ linux-2.6.23-rc6-mm1/mm/memory_hotplug.c
@@ -555,4 +555,10 @@ failed_removal:
 	undo_isolate_page_range(start_pfn, end_pfn);
 	return ret;
 }
+#else
+int remove_memory(u64 start, u64 size)
+{
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(remove_memory);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
Index: linux-2.6.23-rc6-mm1/arch/i386/mm/init.c
===================================================================
--- linux-2.6.23-rc6-mm1.orig/arch/i386/mm/init.c
+++ linux-2.6.23-rc6-mm1/arch/i386/mm/init.c
@@ -735,11 +735,6 @@ int arch_add_memory(int nid, u64 start, 
 	return __add_pages(zone, start_pfn, nr_pages);
 }
 
-int remove_memory(u64 start, u64 size)
-{
-	return -EINVAL;
-}
-EXPORT_SYMBOL_GPL(remove_memory);
 #endif
 
 struct kmem_cache *pmd_cache;
Index: linux-2.6.23-rc6-mm1/arch/sh/mm/init.c
===================================================================
--- linux-2.6.23-rc6-mm1.orig/arch/sh/mm/init.c
+++ linux-2.6.23-rc6-mm1/arch/sh/mm/init.c
@@ -294,12 +294,6 @@ int arch_add_memory(int nid, u64 start, 
 }
 EXPORT_SYMBOL_GPL(arch_add_memory);
 
-int remove_memory(u64 start, u64 size)
-{
-	return -EINVAL;
-}
-EXPORT_SYMBOL_GPL(remove_memory);
-
 #ifdef CONFIG_NUMA
 int memory_add_physaddr_to_nid(u64 addr)
 {
Index: linux-2.6.23-rc6-mm1/arch/sparc64/mm/init.c
===================================================================
--- linux-2.6.23-rc6-mm1.orig/arch/sparc64/mm/init.c
+++ linux-2.6.23-rc6-mm1/arch/sparc64/mm/init.c
@@ -1963,9 +1963,4 @@ void online_page(struct page *page)
 	num_physpages++;
 }
 
-int remove_memory(u64 start, u64 size)
-{
-	return -EINVAL;
-}
-
 #endif /* CONFIG_MEMORY_HOTPLUG */


