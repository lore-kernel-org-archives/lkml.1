Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbYC0Xjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbYC0Xjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 19:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276AbYC0Xjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 19:39:32 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53658 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489AbYC0Xjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 19:39:31 -0400
Subject: [PATCH 5/5] [PPC] provide walk_memory_resource() for ppc
From: Badari Pulavarty <pbadari@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linuxppc-dev@ozlabs.org, paulus@samba.org,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1206664406.19368.2.camel@dyn9047017100.beaverton.ibm.com>
References: <1206664406.19368.2.camel@dyn9047017100.beaverton.ibm.com>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 16:39:55 -0800
Message-Id: <1206664795.19368.13.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide walk_memory_resource() for ppc64. PPC maintains 
logic memory region mapping in lmb.memory structures. Walk
through these structures and do the callbacks for the
contiguous chunks.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
---
 arch/powerpc/mm/mem.c |   30 +++++++++++++++++++++++-------
 include/linux/lmb.h   |    1 +
 lib/lmb.c             |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+), 7 deletions(-)

Index: linux-2.6.25-rc3/lib/lmb.c
===================================================================
--- linux-2.6.25-rc3.orig/lib/lmb.c	2008-03-05 10:28:55.000000000 -0800
+++ linux-2.6.25-rc3/lib/lmb.c	2008-03-05 10:34:01.000000000 -0800
@@ -416,3 +416,36 @@ int __init lmb_is_reserved(u64 addr)
 	}
 	return 0;
 }
+
+/*
+ * Given a <base, len>, find which memory regions belong to this range.
+ * Adjust the request and return a contiguous chunk.
+ */
+int lmb_find(struct lmb_property *res)
+{
+	int i;
+	u64 rstart, rend;
+
+	rstart = res->base;
+	rend = rstart + res->size - 1;
+
+	for (i = 0; i < lmb.memory.cnt; i++) {
+		u64 start = lmb.memory.region[i].base;
+		u64 end = start + lmb.memory.region[i].size - 1;
+
+		if (start > rend)
+			return -1;
+
+		if ((end >= rstart) && (start < rend)) {
+			/* adjust the request */
+			if (rstart < start)
+				rstart = start;
+			if (rend > end)
+				rend = end;
+			res->base = rstart;
+			res->size = rend - rstart + 1;
+			return 0;
+		}
+	}
+	return -1;
+}
Index: linux-2.6.25-rc3/arch/powerpc/mm/mem.c
===================================================================
--- linux-2.6.25-rc3.orig/arch/powerpc/mm/mem.c	2008-03-05 10:14:28.000000000 -0800
+++ linux-2.6.25-rc3/arch/powerpc/mm/mem.c	2008-03-05 10:32:16.000000000 -0800
@@ -148,19 +148,35 @@ out:
 
 /*
  * walk_memory_resource() needs to make sure there is no holes in a given
- * memory range. On PPC64, since this range comes from /sysfs, the range
- * is guaranteed to be valid, non-overlapping and can not contain any
- * holes. By the time we get here (memory add or remove), /proc/device-tree
- * is updated and correct. Only reason we need to check against device-tree
- * would be if we allow user-land to specify a memory range through a
- * system call/ioctl etc. instead of doing offline/online through /sysfs.
+ * memory range. PPC64 does not maintain the memory layout in /proc/iomem.
+ * Instead it maintains it in lmb.memory structures. Walk through the
+ * memory regions, find holes and callback for contiguous regions.
  */
 int
 walk_memory_resource(unsigned long start_pfn, unsigned long nr_pages, void *arg,
 			int (*func)(unsigned long, unsigned long, void *))
 {
-	return  (*func)(start_pfn, nr_pages, arg);
+	struct lmb_property res;
+	unsigned long pfn, len;
+	u64 end;
+	int ret = -1;
+
+	res.base = (u64) start_pfn << PAGE_SHIFT;
+	res.size = (u64) nr_pages << PAGE_SHIFT;
+
+	end = res.base + res.size - 1;
+	while ((res.base < end) && (lmb_find(&res) >= 0)) {
+		pfn = (unsigned long)(res.base >> PAGE_SHIFT);
+		len = (unsigned long)(res.size >> PAGE_SHIFT);
+		ret = (*func)(pfn, len, arg);
+		if (ret)
+			break;
+		res.base += (res.size + 1);
+		res.size = (end - res.base + 1);
+	}
+	return ret;
 }
+EXPORT_SYMBOL_GPL(walk_memory_resource);
 
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
Index: linux-2.6.25-rc3/include/linux/lmb.h
===================================================================
--- linux-2.6.25-rc3.orig/include/linux/lmb.h	2008-03-05 10:30:06.000000000 -0800
+++ linux-2.6.25-rc3/include/linux/lmb.h	2008-03-05 10:33:12.000000000 -0800
@@ -52,6 +52,7 @@ extern u64 __init lmb_phys_mem_size(void
 extern u64 __init lmb_end_of_DRAM(void);
 extern void __init lmb_enforce_memory_limit(u64 memory_limit);
 extern int __init lmb_is_reserved(u64 addr);
+extern int lmb_find(struct lmb_property *res);
 
 extern void lmb_dump_all(void);
 


