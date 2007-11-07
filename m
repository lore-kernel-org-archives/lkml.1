Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbXKGHP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbXKGHP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 02:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbXKGHPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 02:15:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:23150 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031AbXKGHPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 02:15:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,382,1188802800"; 
   d="scan'208";a="372403029"
Subject: [Patch]Add strict_goal parameter to __alloc_bootmem_core
From: Zou Nan hai <nanhai.zou@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Suresh.b.siddha@intel.com
Content-Type: text/plain
Organization: 
Message-Id: <1194419271.3046.1414.camel@linux-znh>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.2.2 (1.2.2-4) 
Date: 07 Nov 2007 15:07:51 +0800
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If __alloc_bootmem_core was given a goal, it will first try to allocate
memory above that goal. If failed, it will try from the low pages.

Sometimes we don't want this behavior, we want the goal to be strict.

This patch introduce a strict_goal parameter to __alloc_bootmem_core, 

If strict_goal is set, __alloc_bootmem_core will return NULL to indicate
it can't allocate memory above that goal.

Note we do not scan from last_success if strict_goal is set, it will
scan from the beginning of the goal instead
We skip this optimization to keep the code simple because strict_goal is
not supposed to be used in hot path.

Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

diff -Nraup a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c	2007-10-24 11:50:57.000000000 +0800
+++ b/arch/x86/mm/numa_64.c	2007-11-07 13:06:50.000000000 +0800
@@ -247,7 +247,7 @@ void __init setup_node_zones(int nodeid)
 		__alloc_bootmem_core(NODE_DATA(nodeid)->bdata, 
 				memmapsize, SMP_CACHE_BYTES, 
 				round_down(limit - memmapsize, PAGE_SIZE), 
-				limit);
+				limit, 1);
 #endif
 } 
 
diff -Nraup a/include/linux/bootmem.h b/include/linux/bootmem.h
--- a/include/linux/bootmem.h	2007-11-07 13:06:35.000000000 +0800
+++ b/include/linux/bootmem.h	2007-11-07 13:06:04.000000000 +0800
@@ -58,7 +58,8 @@ extern void *__alloc_bootmem_core(struct
 				  unsigned long size,
 				  unsigned long align,
 				  unsigned long goal,
-				  unsigned long limit);
+				  unsigned long limit,
+				  int strict_goal);
 
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
 extern void reserve_bootmem(unsigned long addr, unsigned long size);
diff -Nraup a/mm/bootmem.c b/mm/bootmem.c
--- a/mm/bootmem.c	2007-11-07 13:06:35.000000000 +0800
+++ b/mm/bootmem.c	2007-11-07 13:06:18.000000000 +0800
@@ -179,7 +179,7 @@ static void __init free_bootmem_core(boo
  */
 void * __init
 __alloc_bootmem_core(struct bootmem_data *bdata, unsigned long size,
-	      unsigned long align, unsigned long goal, unsigned long limit)
+	      unsigned long align, unsigned long goal, unsigned long limit, int strict_goal)
 {
 	unsigned long offset, remaining_size, areasize, preferred;
 	unsigned long i, start = 0, incr, eidx, end_pfn;
@@ -212,15 +212,20 @@ __alloc_bootmem_core(struct bootmem_data
 	/*
 	 * We try to allocate bootmem pages above 'goal'
 	 * first, then we try to allocate lower pages.
-	 */
-	if (goal && goal >= bdata->node_boot_start && PFN_DOWN(goal) < end_pfn) {
-		preferred = goal - bdata->node_boot_start;
+	 * if the goal is not strict.
+         */
+
+	preferred = 0;
+	if (goal) {
+		if (goal >= bdata->node_boot_start && PFN_DOWN(goal) < end_pfn) {
+			preferred = goal - bdata->node_boot_start;
 
 		if (bdata->last_success >= preferred)
-			if (!limit || (limit && limit > bdata->last_success))
+			if (!strict_goal && (!limit || (limit && limit > bdata->last_success)))
 				preferred = bdata->last_success;
-	} else
-		preferred = 0;
+		} else if (strict_goal)
+                        return NULL;
+	}
 
 	preferred = PFN_DOWN(ALIGN(preferred, align)) + offset;
 	areasize = (size + PAGE_SIZE-1) / PAGE_SIZE;
@@ -247,7 +252,7 @@ restart_scan:
 		i = ALIGN(j, incr);
 	}
 
-	if (preferred > offset) {
+	if (preferred > offset && !strict_goal) {
 		preferred = offset;
 		goto restart_scan;
 	}
@@ -421,7 +426,7 @@ void * __init __alloc_bootmem_nopanic(un
 	void *ptr;
 
 	list_for_each_entry(bdata, &bdata_list, list) {
-		ptr = __alloc_bootmem_core(bdata, size, align, goal, 0);
+		ptr = __alloc_bootmem_core(bdata, size, align, goal, 0, 0);
 		if (ptr)
 			return ptr;
 	}
@@ -449,7 +454,7 @@ void * __init __alloc_bootmem_node(pg_da
 {
 	void *ptr;
 
-	ptr = __alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
+	ptr = __alloc_bootmem_core(pgdat->bdata, size, align, goal, 0, 0);
 	if (ptr)
 		return ptr;
 
@@ -468,7 +473,7 @@ void * __init __alloc_bootmem_low(unsign
 
 	list_for_each_entry(bdata, &bdata_list, list) {
 		ptr = __alloc_bootmem_core(bdata, size, align, goal,
-						ARCH_LOW_ADDRESS_LIMIT);
+						ARCH_LOW_ADDRESS_LIMIT, 0);
 		if (ptr)
 			return ptr;
 	}
@@ -485,5 +490,5 @@ void * __init __alloc_bootmem_low_node(p
 				       unsigned long align, unsigned long goal)
 {
 	return __alloc_bootmem_core(pgdat->bdata, size, align, goal,
-				    ARCH_LOW_ADDRESS_LIMIT);
+				    ARCH_LOW_ADDRESS_LIMIT, 0);
 }





