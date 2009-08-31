Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbZHaKIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbZHaKIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 06:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbZHaKIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 06:08:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53597 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbZHaKIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 06:08:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 31 Aug 2009 19:06:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       benh@kernel.crashing.org, ralf@linux-mips.org, xiyou.wangcong@gmail.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       jirislaby@gmail.com
Subject: [PATCH 5/8][mmotm] walk system ram range
Message-Id: <20090831190641.dcc56269.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090831190024.fadc3b50.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090831190024.fadc3b50.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Originally, walk_memory_resource() was introduced to traverse all memory
of "System RAM" for detecting memory hotplug/unplug range.  For doing so,
flags of IORESOUCE_MEM|IORESOURCE_BUSY was used and this was enough for
memory hotplug.

But for using other purpose, /proc/kcore, this may includes some firmware
area marked as IORESOURCE_BUSY | IORESOUCE_MEM.  This patch makes the
check strict to find out busy "System RAM".

Note: PPC64 keeps their own walk_memory_resouce(), which walk through
ppc64's lmb informaton.  Because old kclist_add() is called per lmb, this
patch makes no difference in behavior, finally.

And this patch removes CONFIG_MEMORY_HOTPLUG check from this function. 
Because pfn_valid() just show "there is memmap or not* and cannot be used
for "there is physical memory or not", this function is useful in generic
to scan physical memory range.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mem.c          |    4 ++--
 drivers/net/ehea/ehea_qmr.c    |    2 +-
 include/linux/ioport.h         |    4 ++++
 include/linux/memory_hotplug.h |    8 --------
 kernel/resource.c              |   23 ++++++++++++++++-------
 mm/memory_hotplug.c            |    6 +++---
 6 files changed, 26 insertions(+), 21 deletions(-)

Index: mmotm-2.6.31-Aug27/arch/powerpc/mm/mem.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/arch/powerpc/mm/mem.c
+++ mmotm-2.6.31-Aug27/arch/powerpc/mm/mem.c
@@ -143,8 +143,8 @@ int arch_add_memory(int nid, u64 start, 
  * memory regions, find holes and callback for contiguous regions.
  */
 int
-walk_memory_resource(unsigned long start_pfn, unsigned long nr_pages, void *arg,
-			int (*func)(unsigned long, unsigned long, void *))
+walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
+		void *arg, int (*func)(unsigned long, unsigned long, void *))
 {
 	struct lmb_property res;
 	unsigned long pfn, len;
Index: mmotm-2.6.31-Aug27/drivers/net/ehea/ehea_qmr.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/drivers/net/ehea/ehea_qmr.c
+++ mmotm-2.6.31-Aug27/drivers/net/ehea/ehea_qmr.c
@@ -751,7 +751,7 @@ int ehea_create_busmap(void)
 
 	mutex_lock(&ehea_busmap_mutex);
 	ehea_mr_len = 0;
-	ret = walk_memory_resource(0, 1ULL << MAX_PHYSMEM_BITS, NULL,
+	ret = walk_system_ram_range(0, 1ULL << MAX_PHYSMEM_BITS, NULL,
 				   ehea_create_busmap_callback);
 	mutex_unlock(&ehea_busmap_mutex);
 	return ret;
Index: mmotm-2.6.31-Aug27/include/linux/ioport.h
===================================================================
--- mmotm-2.6.31-Aug27.orig/include/linux/ioport.h
+++ mmotm-2.6.31-Aug27/include/linux/ioport.h
@@ -184,5 +184,9 @@ extern void __devm_release_region(struct
 extern int iomem_map_sanity_check(resource_size_t addr, unsigned long size);
 extern int iomem_is_exclusive(u64 addr);
 
+extern int
+walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
+		void *arg, int (*func)(unsigned long, unsigned long, void *));
+
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
Index: mmotm-2.6.31-Aug27/include/linux/memory_hotplug.h
===================================================================
--- mmotm-2.6.31-Aug27.orig/include/linux/memory_hotplug.h
+++ mmotm-2.6.31-Aug27/include/linux/memory_hotplug.h
@@ -191,14 +191,6 @@ static inline void register_page_bootmem
 
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
 
-/*
- * Walk through all memory which is registered as resource.
- * arg is (start_pfn, nr_pages, private_arg_pointer)
- */
-extern int walk_memory_resource(unsigned long start_pfn,
-			unsigned long nr_pages, void *arg,
-			int (*func)(unsigned long, unsigned long, void *));
-
 #ifdef CONFIG_MEMORY_HOTREMOVE
 
 extern int is_mem_section_removable(unsigned long pfn, unsigned long nr_pages);
Index: mmotm-2.6.31-Aug27/kernel/resource.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/kernel/resource.c
+++ mmotm-2.6.31-Aug27/kernel/resource.c
@@ -233,13 +233,13 @@ int release_resource(struct resource *ol
 
 EXPORT_SYMBOL(release_resource);
 
-#if defined(CONFIG_MEMORY_HOTPLUG) && !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
+#if !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
 /*
  * Finds the lowest memory reosurce exists within [res->start.res->end)
- * the caller must specify res->start, res->end, res->flags.
+ * the caller must specify res->start, res->end, res->flags and "name".
  * If found, returns 0, res is overwritten, if not found, returns -1.
  */
-static int find_next_system_ram(struct resource *res)
+static int find_next_system_ram(struct resource *res, char *name)
 {
 	resource_size_t start, end;
 	struct resource *p;
@@ -255,6 +255,8 @@ static int find_next_system_ram(struct r
 		/* system ram is just marked as IORESOURCE_MEM */
 		if (p->flags != res->flags)
 			continue;
+		if (name && strcmp(p->name, name))
+			continue;
 		if (p->start > end) {
 			p = NULL;
 			break;
@@ -272,19 +274,26 @@ static int find_next_system_ram(struct r
 		res->end = p->end;
 	return 0;
 }
-int
-walk_memory_resource(unsigned long start_pfn, unsigned long nr_pages, void *arg,
-			int (*func)(unsigned long, unsigned long, void *))
+
+/*
+ * This function calls callback against all memory range of "System RAM"
+ * which are marked as IORESOURCE_MEM and IORESOUCE_BUSY.
+ * Now, this function is only for "System RAM".
+ */
+int walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
+		void *arg, int (*func)(unsigned long, unsigned long, void *))
 {
 	struct resource res;
 	unsigned long pfn, len;
 	u64 orig_end;
 	int ret = -1;
+
 	res.start = (u64) start_pfn << PAGE_SHIFT;
 	res.end = ((u64)(start_pfn + nr_pages) << PAGE_SHIFT) - 1;
 	res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 	orig_end = res.end;
-	while ((res.start < res.end) && (find_next_system_ram(&res) >= 0)) {
+	while ((res.start < res.end) &&
+		(find_next_system_ram(&res, "System RAM") >= 0)) {
 		pfn = (unsigned long)(res.start >> PAGE_SHIFT);
 		len = (unsigned long)((res.end + 1 - res.start) >> PAGE_SHIFT);
 		ret = (*func)(pfn, len, arg);
Index: mmotm-2.6.31-Aug27/mm/memory_hotplug.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/mm/memory_hotplug.c
+++ mmotm-2.6.31-Aug27/mm/memory_hotplug.c
@@ -413,7 +413,7 @@ int online_pages(unsigned long pfn, unsi
 	if (!populated_zone(zone))
 		need_zonelists_rebuild = 1;
 
-	ret = walk_memory_resource(pfn, nr_pages, &onlined_pages,
+	ret = walk_system_ram_range(pfn, nr_pages, &onlined_pages,
 		online_pages_range);
 	if (ret) {
 		printk(KERN_DEBUG "online_pages %lx at %lx failed\n",
@@ -705,7 +705,7 @@ offline_isolated_pages_cb(unsigned long 
 static void
 offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
 {
-	walk_memory_resource(start_pfn, end_pfn - start_pfn, NULL,
+	walk_system_ram_range(start_pfn, end_pfn - start_pfn, NULL,
 				offline_isolated_pages_cb);
 }
 
@@ -731,7 +731,7 @@ check_pages_isolated(unsigned long start
 	long offlined = 0;
 	int ret;
 
-	ret = walk_memory_resource(start_pfn, end_pfn - start_pfn, &offlined,
+	ret = walk_system_ram_range(start_pfn, end_pfn - start_pfn, &offlined,
 			check_pages_isolated_cb);
 	if (ret < 0)
 		offlined = (long)ret;

