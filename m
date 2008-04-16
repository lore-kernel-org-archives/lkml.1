Return-Path: <linux-kernel-owner+w=401wt.eu-S1763242AbYDPMtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763242AbYDPMtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 08:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760690AbYDPMsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 08:48:09 -0400
Received: from saeurebad.de ([85.214.36.134]:58563 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763355AbYDPMsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 08:48:08 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Wed Apr 16 13:37:19 2008
Message-Id: <20080416113719.236705173@skyscraper.fehenstaub.lan>
References: <20080416113629.947746497@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 13:36:32 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux MM <linux-mm@kvack.org>
Subject: [RFC][patch 3/5] mm: Unexport __alloc_bootmem_core()
Content-Disposition: inline; filename=0003-bootmem-Unexport-__alloc_bootmem_core.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function has no external callers, make it local to the allocator.
Also fix its naming inconsistency.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 include/linux/bootmem.h |    5 -----
 mm/bootmem.c            |   18 +++++++++---------
 2 files changed, 9 insertions(+), 14 deletions(-)

Index: tree-linus/include/linux/bootmem.h
===================================================================
--- tree-linus.orig/include/linux/bootmem.h
+++ tree-linus/include/linux/bootmem.h
@@ -54,11 +54,6 @@ extern void *__alloc_bootmem_low_node(pg
 				      unsigned long size,
 				      unsigned long align,
 				      unsigned long goal);
-extern void *__alloc_bootmem_core(struct bootmem_data *bdata,
-				  unsigned long size,
-				  unsigned long align,
-				  unsigned long goal,
-				  unsigned long limit);
 
 /*
  * flags for reserve_bootmem (also if CONFIG_HAVE_ARCH_BOOTMEM_NODE,
Index: tree-linus/mm/bootmem.c
===================================================================
--- tree-linus.orig/mm/bootmem.c
+++ tree-linus/mm/bootmem.c
@@ -191,16 +191,16 @@ static void __init free_bootmem_core(boo
  *
  * NOTE:  This function is _not_ reentrant.
  */
-void * __init
-__alloc_bootmem_core(struct bootmem_data *bdata, unsigned long size,
-	      unsigned long align, unsigned long goal, unsigned long limit)
+static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
+				unsigned long size, unsigned long align,
+				unsigned long goal, unsigned long limit)
 {
 	unsigned long offset, remaining_size, areasize, preferred;
 	unsigned long i, start = 0, incr, eidx, end_pfn;
 	void *ret;
 
 	if (!size) {
-		printk("__alloc_bootmem_core(): zero-sized request\n");
+		printk(KERN_ERR "alloc_bootmem_core(): zero-sized request\n");
 		BUG();
 	}
 	BUG_ON(align & (align-1));
@@ -461,7 +461,7 @@ void * __init __alloc_bootmem_nopanic(un
 	void *ptr;
 
 	list_for_each_entry(bdata, &bdata_list, list) {
-		ptr = __alloc_bootmem_core(bdata, size, align, goal, 0);
+		ptr = alloc_bootmem_core(bdata, size, align, goal, 0);
 		if (ptr)
 			return ptr;
 	}
@@ -489,7 +489,7 @@ void * __init __alloc_bootmem_node(pg_da
 {
 	void *ptr;
 
-	ptr = __alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
+	ptr = alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
 	if (ptr)
 		return ptr;
 
@@ -507,8 +507,8 @@ void * __init __alloc_bootmem_low(unsign
 	void *ptr;
 
 	list_for_each_entry(bdata, &bdata_list, list) {
-		ptr = __alloc_bootmem_core(bdata, size, align, goal,
-						ARCH_LOW_ADDRESS_LIMIT);
+		ptr = alloc_bootmem_core(bdata, size, align, goal,
+					ARCH_LOW_ADDRESS_LIMIT);
 		if (ptr)
 			return ptr;
 	}
@@ -524,6 +524,6 @@ void * __init __alloc_bootmem_low(unsign
 void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
 				       unsigned long align, unsigned long goal)
 {
-	return __alloc_bootmem_core(pgdat->bdata, size, align, goal,
+	return alloc_bootmem_core(pgdat->bdata, size, align, goal,
 				    ARCH_LOW_ADDRESS_LIMIT);
 }

-- 

