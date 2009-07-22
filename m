Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608AbZGVFOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbZGVFOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 01:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbZGVFOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 01:14:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59800 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbZGVFOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 01:14:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 22 Jul 2009 14:12:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 4/4] kcore: remove noise from walk_memory_resource
Message-Id: <20090722141227.9712ee7b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090722140613.0a751811.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090722140613.0a751811.kamezawa.hiroyu@jp.fujitsu.com>
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
was enough for memory hotplug because scanning range was controlled properly.

But for using other purpose, /proc/kcore, this may includes some firmware
area marked as IORESOURCE_BUSY | IORESOUCE_MEM. This patch makes the check
strict to find out busy "System RAM".

Note: PPC64 keeps their own walk_memory_resouce(), which walk through
ppc64's lmb informaton. Because old kclist_add() is called per lmb,
this patch makes no difference in behavior, finally.

Changelog v2:
 - new patch from v2.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 kernel/resource.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

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
@@ -273,19 +275,27 @@ static int find_next_system_ram(struct r
 		res->end = p->end;
 	return 0;
 }
+
+/*
+ * This function calls callback against all memory range of "System RAM"
+ * which are marked as IORESOURCE_MEM and IORESOUCE_BUSY.
+ * Now, this function is only for "System RAM".
+ */
 int
 walk_memory_resource(unsigned long start_pfn, unsigned long nr_pages, void *arg,
-			int (*func)(unsigned long, unsigned long, void *))
+		int (*func)(unsigned long, unsigned long, void *))
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

