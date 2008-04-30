Return-Path: <linux-kernel-owner+w=401wt.eu-S1764097AbYD3Ry2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764097AbYD3Ry2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763931AbYD3Rxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:53:38 -0400
Received: from saeurebad.de ([85.214.36.134]:60208 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763927AbYD3Rxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:53:36 -0400
X-Mailbox-Line: From hannes@symbol.fehenstaub.lan Wed Apr 30 19:08:40 2008
Message-Id: <20080430170840.176104554@symbol.fehenstaub.lan>
References: <20080430170521.246745395@symbol.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Wed, 30 Apr 2008 19:05:25 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 4/4] mm: Unexport __alloc_bootmem_core()
Content-Disposition: inline; filename=mm-unexport__alloc_bootmem_core.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function has no external callers, so unexport it.  Also fix its
naming inconsistency.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Ingo Molnar <mingo@elte.hu>
---

It could be argued that all bootmem alloc function names begin with
underscores.  But I chose to `no _core function names begin with
underscores' :)

Index: linux-2.6/include/linux/bootmem.h
===================================================================
--- linux-2.6.orig/include/linux/bootmem.h
+++ linux-2.6/include/linux/bootmem.h
@@ -56,11 +56,6 @@ extern void *__alloc_bootmem_low_node(pg
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
Index: linux-2.6/mm/bootmem.c
===================================================================
--- linux-2.6.orig/mm/bootmem.c
+++ linux-2.6/mm/bootmem.c
@@ -233,9 +233,9 @@ static void __init free_bootmem_core(boo
  *
  * NOTE:  This function is _not_ reentrant.
  */
-void * __init
-__alloc_bootmem_core(struct bootmem_data *bdata, unsigned long size,
-	      unsigned long align, unsigned long goal, unsigned long limit)
+static void * __init
+alloc_bootmem_core(struct bootmem_data *bdata, unsigned long size,
+		unsigned long align, unsigned long goal, unsigned long limit)
 {
 	unsigned long areasize, preferred;
 	unsigned long i, start = 0, incr, eidx, end_pfn;
@@ -244,7 +244,7 @@ __alloc_bootmem_core(struct bootmem_data
 	void *node_bootmem_map;
 
 	if (!size) {
-		printk("__alloc_bootmem_core(): zero-sized request\n");
+		printk("alloc_bootmem_core(): zero-sized request\n");
 		BUG();
 	}
 	BUG_ON(align & (align-1));
@@ -509,7 +509,7 @@ void * __init __alloc_bootmem_nopanic(un
 	void *ptr;
 
 	list_for_each_entry(bdata, &bdata_list, list) {
-		ptr = __alloc_bootmem_core(bdata, size, align, goal, 0);
+		ptr = alloc_bootmem_core(bdata, size, align, goal, 0);
 		if (ptr)
 			return ptr;
 	}
@@ -537,7 +537,7 @@ void * __init __alloc_bootmem_node(pg_da
 {
 	void *ptr;
 
-	ptr = __alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
+	ptr = alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
 	if (ptr)
 		return ptr;
 
@@ -556,8 +556,8 @@ void * __init alloc_bootmem_section(unsi
 	goal = PFN_PHYS(pfn);
 	limit = PFN_PHYS(section_nr_to_pfn(section_nr + 1)) - 1;
 	pgdat = NODE_DATA(early_pfn_to_nid(pfn));
-	ptr = __alloc_bootmem_core(pgdat->bdata, size, SMP_CACHE_BYTES, goal,
-				   limit);
+	ptr = alloc_bootmem_core(pgdat->bdata, size, SMP_CACHE_BYTES, goal,
+				limit);
 
 	if (!ptr)
 		return NULL;
@@ -586,8 +586,8 @@ void * __init __alloc_bootmem_low(unsign
 	void *ptr;
 
 	list_for_each_entry(bdata, &bdata_list, list) {
-		ptr = __alloc_bootmem_core(bdata, size, align, goal,
-						ARCH_LOW_ADDRESS_LIMIT);
+		ptr = alloc_bootmem_core(bdata, size, align, goal,
+					ARCH_LOW_ADDRESS_LIMIT);
 		if (ptr)
 			return ptr;
 	}
@@ -603,6 +603,6 @@ void * __init __alloc_bootmem_low(unsign
 void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
 				       unsigned long align, unsigned long goal)
 {
-	return __alloc_bootmem_core(pgdat->bdata, size, align, goal,
-				    ARCH_LOW_ADDRESS_LIMIT);
+	return alloc_bootmem_core(pgdat->bdata, size, align, goal,
+				ARCH_LOW_ADDRESS_LIMIT);
 }

-- 
