Return-Path: <linux-kernel-owner+w=401wt.eu-S941013AbYCSWZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941013AbYCSWZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935878AbYCSVDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:03:13 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:55319 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935761AbYCSVDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:03:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=reply-to:to:subject:user-agent:cc:references:in-reply-to:mime-version:content-disposition:x-length:x-uid:date:content-type:content-transfer-encoding:message-id:from;
        b=HR+vE2Sa0Zf13shSOc5BSvrauKAuPfN/RTjBsyHvHBMt1qdE5wGi+xVBhmoyqpoXWkEaQqTJXxiQaaB9o3oG9eDleicZrszgapVjAeSuTCZKf9RgOYjn6X7CwjA2vt0UwMPLzTXEcpFZbhGexhI0wCfFqI4Z/9M8sQcDDBHjM3w=
Reply-To: yhlu.kernel@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 01/12] mm: fix boundary checking in free_bootmem_core
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>
References: <200803181209.07654.yhlu.kernel@gmail.com>
In-Reply-To: <200803181209.07654.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3246
Date: Wed, 19 Mar 2008 14:03:23 -0700
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200803191403.24110.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] mm: fix boundary checking in free_bootmem_core

With numa enabled, some callers could have a range of memory on one node but
try to free that on other node.  This can cause some pages to be freed
wrongly.

For example: when we try to allocate 128g boot ram early for gart/swiotlb, and
free that range later so gart/swiotlb can get some range afterwards.

With this patch, we don't need to care which node holds the range, just loop
to call free_bootmem_node for all online nodes.

This patch make free_bootmem_core() more robust by trimming the sidx and eidx
according the ram range that the node has.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/mm/bootmem.c
===================================================================
--- linux-2.6.orig/mm/bootmem.c
+++ linux-2.6/mm/bootmem.c
@@ -125,6 +125,7 @@ static int __init reserve_bootmem_core(b
 	BUG_ON(!size);
 	BUG_ON(PFN_DOWN(addr) >= bdata->node_low_pfn);
 	BUG_ON(PFN_UP(addr + size) > bdata->node_low_pfn);
+	BUG_ON(addr < bdata->node_boot_start);
 
 	sidx = PFN_DOWN(addr - bdata->node_boot_start);
 	eidx = PFN_UP(addr + size - bdata->node_boot_start);
@@ -156,21 +157,31 @@ static void __init free_bootmem_core(boo
 	unsigned long sidx, eidx;
 	unsigned long i;
 
+	BUG_ON(!size);
+
+	/* out range */
+	if (addr + size < bdata->node_boot_start ||
+		PFN_DOWN(addr) > bdata->node_low_pfn)
+		return;
 	/*
 	 * round down end of usable mem, partially free pages are
 	 * considered reserved.
 	 */
-	BUG_ON(!size);
-	BUG_ON(PFN_DOWN(addr + size) > bdata->node_low_pfn);
 
-	if (addr < bdata->last_success)
+	if (addr >= bdata->node_boot_start && addr < bdata->last_success)
 		bdata->last_success = addr;
 
 	/*
-	 * Round up the beginning of the address.
+	 * Round up to index to the range.
 	 */
-	sidx = PFN_UP(addr) - PFN_DOWN(bdata->node_boot_start);
+	if (PFN_UP(addr) > PFN_DOWN(bdata->node_boot_start))
+		sidx = PFN_UP(addr) - PFN_DOWN(bdata->node_boot_start);
+	else
+		sidx = 0;
+
 	eidx = PFN_DOWN(addr + size - bdata->node_boot_start);
+	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
+		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
 
 	for (i = sidx; i < eidx; i++) {
 		if (unlikely(!test_and_clear_bit(i, bdata->node_bootmem_map)))
