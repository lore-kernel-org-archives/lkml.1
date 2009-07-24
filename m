Return-Path: <linux-kernel-owner+w=401wt.eu-S1752179AbZGXIXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbZGXIXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 04:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbZGXIXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 04:23:52 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49508 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbZGXIXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 04:23:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 24 Jul 2009 17:22:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       xiyou.wangcong@gmail.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       ralf@linux-mips.org, benh@kernel.crashing.org, lethal@linux-sh.org
Subject: [RFC][PATCH 6/6] kcore: walk_system_ram_range()
Message-Id: <20090724172200.75c9d57d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090724170819.2625ba07.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090724170819.2625ba07.kamezawa.hiroyu@jp.fujitsu.com>
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
of "System RAM" for detecting memory hotplug/unplug range.
For doing so, flags of IORESOUCE_MEM|IORESOURCE_BUSY was used and this
was enough for memory hotplug.

But for using other purpose, /proc/kcore, this may includes some firmware
area marked as IORESOURCE_BUSY | IORESOUCE_MEM. This patch makes the check
strict to find out "System RAM".

Note: PPC keeps their own walk_memory_resouce(), which walk through
ppc's lmb informaton. Because old kclist_add() is called per lmb,
this patch makes no difference in behavior, finally.

Changelog v2->v3
 - walk_memory_resource() is renamed to be walk_system_ram_range()
Changelog v2:
 - new patch from v2.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
Index: mmotm-2.6.31-Jul16/kernel/resource.c
===================================================================
--- mmotm-2.6.31-Jul16.orig/kernel/resource.c
+++ mmotm-2.6.31-Jul16/kernel/resource.c
@@ -237,10 +237,10 @@ EXPORT_SYMBOL(release_resource);
 #if !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
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
@@ -256,6 +256,8 @@ static int find_next_system_ram(struct r
 		/* system ram is just marked as IORESOURCE_MEM */
 		if (p->flags != res->flags)
 			continue;
+		if (name && strcmp(p->name, name))
+			continue;
 		if (p->start > end) {
 			p = NULL;
 			break;
@@ -273,19 +275,26 @@ static int find_next_system_ram(struct r
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
Index: mmotm-2.6.31-Jul16/include/linux/ioport.h
===================================================================
--- mmotm-2.6.31-Jul16.orig/include/linux/ioport.h
+++ mmotm-2.6.31-Jul16/include/linux/ioport.h
@@ -190,7 +190,7 @@ extern int iomem_is_exclusive(u64 addr);
  * Walk through all SYSTEM_RAM which is registered as resource.
  * arg is (start_pfn, nr_pages, private_arg_pointer)
  */
-extern int walk_memory_resource(unsigned long start_pfn,
+extern int walk_system_ram_range(unsigned long start_pfn,
 			unsigned long nr_pages, void *arg,
 			int (*func)(unsigned long, unsigned long, void *));
 
Index: mmotm-2.6.31-Jul16/mm/memory_hotplug.c
===================================================================
--- mmotm-2.6.31-Jul16.orig/mm/memory_hotplug.c
+++ mmotm-2.6.31-Jul16/mm/memory_hotplug.c
@@ -410,7 +410,7 @@ int online_pages(unsigned long pfn, unsi
 	if (!populated_zone(zone))
 		need_zonelists_rebuild = 1;
 
-	ret = walk_memory_resource(pfn, nr_pages, &onlined_pages,
+	ret = walk_system_ram_range(pfn, nr_pages, &onlined_pages,
 		online_pages_range);
 	if (ret) {
 		printk(KERN_DEBUG "online_pages %lx at %lx failed\n",
@@ -702,7 +702,7 @@ offline_isolated_pages_cb(unsigned long 
 static void
 offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
 {
-	walk_memory_resource(start_pfn, end_pfn - start_pfn, NULL,
+	walk_system_ram_range(start_pfn, end_pfn - start_pfn, NULL,
 				offline_isolated_pages_cb);
 }
 
@@ -728,7 +728,7 @@ check_pages_isolated(unsigned long start
 	long offlined = 0;
 	int ret;
 
-	ret = walk_memory_resource(start_pfn, end_pfn - start_pfn, &offlined,
+	ret = walk_system_ram_range(start_pfn, end_pfn - start_pfn, &offlined,
 			check_pages_isolated_cb);
 	if (ret < 0)
 		offlined = (long)ret;
Index: mmotm-2.6.31-Jul16/arch/powerpc/mm/mem.c
===================================================================
--- mmotm-2.6.31-Jul16.orig/arch/powerpc/mm/mem.c
+++ mmotm-2.6.31-Jul16/arch/powerpc/mm/mem.c
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
Index: mmotm-2.6.31-Jul16/drivers/net/ehea/ehea_qmr.c
===================================================================
--- mmotm-2.6.31-Jul16.orig/drivers/net/ehea/ehea_qmr.c
+++ mmotm-2.6.31-Jul16/drivers/net/ehea/ehea_qmr.c
@@ -751,7 +751,7 @@ int ehea_create_busmap(void)
 
 	mutex_lock(&ehea_busmap_mutex);
 	ehea_mr_len = 0;
-	ret = walk_memory_resource(0, 1ULL << MAX_PHYSMEM_BITS, NULL,
+	ret = walk_system_ram_range(0, 1ULL << MAX_PHYSMEM_BITS, NULL,
 				   ehea_create_busmap_callback);
 	mutex_unlock(&ehea_busmap_mutex);
 	return ret;
Index: mmotm-2.6.31-Jul16/fs/proc/kcore.c
===================================================================
--- mmotm-2.6.31-Jul16.orig/fs/proc/kcore.c
+++ mmotm-2.6.31-Jul16/fs/proc/kcore.c
@@ -199,7 +199,7 @@ static int kcore_update_ram(void)
 		if (end_pfn < node_end_pfn(nid))
 			end_pfn = node_end_pfn(nid);
 	/* scan 0 to max_pfn */
-	ret = walk_memory_resource(0, end_pfn, &head, kclist_add_private);
+	ret = walk_system_ram_range(0, end_pfn, &head, kclist_add_private);
 	if (ret) {
 		free_kclist_ents(&head);
 		return -ENOMEM;

