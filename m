Return-Path: <linux-kernel-owner+w=401wt.eu-S1161840AbYCSWiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161840AbYCSWiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936364AbYCSVJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:09:56 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:65077 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764384AbYCSVJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:09:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=reply-to:to:subject:user-agent:cc:references:in-reply-to:mime-version:content-disposition:x-length:x-uid:date:content-type:content-transfer-encoding:message-id:from;
        b=nyUy7SXCbth87Ap4liNbmELgyNFL8vPuax0Detbphg7P1kBYbG77zE/Y8/sVBkfH5JU3NxJTdYSENJH94J3HYgX4NK3wEh8vtonu1ReDLDtooT+8JT2s8OGnF6vcvnnb7DQT48IURQBf/qBU8jveTWYwlW/MAO6OtTtKmx5JywM=
Reply-To: yhlu.kernel@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 09/12] mm: make reserve_bootmem can crossed the nodes v2
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Christoph Lameter <clameter@sgi.com>,
       kernel list <linux-kernel@vger.kernel.org>
References: <200803181237.33861.yhlu.kernel@gmail.com>
In-Reply-To: <200803181237.33861.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 5011
Date: Wed, 19 Mar 2008 14:04:39 -0700
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200803191404.39834.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] mm: make reserve_bootmem can crossed the nodes v2

split reserve_bootmem_core to two function, one check conflicts, and one set bits.

and make reserve_bootmem to loop bdata_list to cross the nodes.

user could be crashkernel and ramdisk..., in case the range cross the nodes

v2, fix out of range check

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/mm/bootmem.c
===================================================================
--- linux-2.6.orig/mm/bootmem.c
+++ linux-2.6/mm/bootmem.c
@@ -111,44 +111,71 @@ static unsigned long __init init_bootmem
  * might be used for boot-time allocations - or it might get added
  * to the free page pool later on.
  */
-static int __init reserve_bootmem_core(bootmem_data_t *bdata,
+static int __init can_reserve_bootmem_core(bootmem_data_t *bdata,
 			unsigned long addr, unsigned long size, int flags)
 {
 	unsigned long sidx, eidx;
 	unsigned long i;
-	int ret;
+
+	BUG_ON(!size);
+
+	/* out of range, don't hold other */
+	if (addr + size < bdata->node_boot_start ||
+		PFN_DOWN(addr) > bdata->node_low_pfn)
+		return 0;
 
 	/*
-	 * round up, partially reserved pages are considered
-	 * fully reserved.
+	 * Round up to index to the range.
 	 */
+	if (addr > bdata->node_boot_start)
+		sidx= PFN_DOWN(addr - bdata->node_boot_start);
+	else
+		sidx = 0;
+
+	eidx = PFN_UP(addr + size - bdata->node_boot_start);
+	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
+		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
+
+	for (i = sidx; i < eidx; i++)
+		if (test_bit(i, bdata->node_bootmem_map)) {
+			if (flags & BOOTMEM_EXCLUSIVE)
+				return -EBUSY;
+		}
+
+	return 0;
+
+}
+static void __init reserve_bootmem_core(bootmem_data_t *bdata,
+			unsigned long addr, unsigned long size, int flags)
+{
+	unsigned long sidx, eidx;
+	unsigned long i;
+
 	BUG_ON(!size);
-	BUG_ON(PFN_DOWN(addr) >= bdata->node_low_pfn);
-	BUG_ON(PFN_UP(addr + size) > bdata->node_low_pfn);
-	BUG_ON(addr < bdata->node_boot_start);
 
-	sidx = PFN_DOWN(addr - bdata->node_boot_start);
+	/* out of range */
+	if (addr + size < bdata->node_boot_start ||
+		PFN_DOWN(addr) > bdata->node_low_pfn)
+		return;
+
+	/*
+	 * Round up to index to the range.
+	 */
+	if (addr > bdata->node_boot_start)
+		sidx= PFN_DOWN(addr - bdata->node_boot_start);
+	else
+		sidx = 0;
+
 	eidx = PFN_UP(addr + size - bdata->node_boot_start);
+	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
+		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
 
 	for (i = sidx; i < eidx; i++)
 		if (test_and_set_bit(i, bdata->node_bootmem_map)) {
 #ifdef CONFIG_DEBUG_BOOTMEM
 			printk("hm, page %08lx reserved twice.\n", i*PAGE_SIZE);
 #endif
-			if (flags & BOOTMEM_EXCLUSIVE) {
-				ret = -EBUSY;
-				goto err;
-			}
 		}
-
-	return 0;
-
-err:
-	/* unreserve memory we accidentally reserved */
-	for (i--; i >= sidx; i--)
-		clear_bit(i, bdata->node_bootmem_map);
-
-	return ret;
 }
 
 static void __init free_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
@@ -415,6 +442,11 @@ unsigned long __init init_bootmem_node(p
 void __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 				 unsigned long size, int flags)
 {
+	int ret;
+
+	ret = can_reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
+	if (ret < 0)
+		return;
 	reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
 }
 
@@ -440,7 +472,16 @@ unsigned long __init init_bootmem(unsign
 int __init reserve_bootmem(unsigned long addr, unsigned long size,
 			    int flags)
 {
-	return reserve_bootmem_core(NODE_DATA(0)->bdata, addr, size, flags);
+	int ret;
+	bootmem_data_t *bdata;
+	list_for_each_entry(bdata, &bdata_list, list) {
+		ret = can_reserve_bootmem_core(bdata, addr, size, flags);
+		if (ret < 0)
+			return ret;
+	}
+	list_for_each_entry(bdata, &bdata_list, list)
+		reserve_bootmem_core(bdata, addr, size, flags);
+	return 0;
 }
 #endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
 
