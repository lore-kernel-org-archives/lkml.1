Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbYCQCCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbYCQCCD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 22:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbYCQB63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 21:58:29 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:23320 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032AbYCQB60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 21:58:26 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080317258.659191058@firstfloor.org>
In-Reply-To: <20080317258.659191058@firstfloor.org>
To: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: [PATCH] [11/18] Fix alignment bug in bootmem allocator
Message-Id: <20080317015825.0C0171B41E0@basil.firstfloor.org>
Date: Mon, 17 Mar 2008 02:58:25 +0100 (CET)
X-OriginalArrivalTime: 17 Mar 2008 01:51:50.0767 (UTC) FILETIME=[77C987F0:01C887D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Without this fix bootmem can return unaligned addresses when the start of a
node is not aligned to the align value. Needed for reliably allocating
gigabyte pages.
Signed-off-by: Andi Kleen <ak@suse.de>

---
 mm/bootmem.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/mm/bootmem.c
===================================================================
--- linux.orig/mm/bootmem.c
+++ linux/mm/bootmem.c
@@ -197,6 +197,7 @@ __alloc_bootmem_core(struct bootmem_data
 {
 	unsigned long offset, remaining_size, areasize, preferred;
 	unsigned long i, start = 0, incr, eidx, end_pfn;
+	unsigned long pfn;
 	void *ret;
 
 	if (!size) {
@@ -239,12 +240,13 @@ __alloc_bootmem_core(struct bootmem_data
 	preferred = PFN_DOWN(ALIGN(preferred, align)) + offset;
 	areasize = (size + PAGE_SIZE-1) / PAGE_SIZE;
 	incr = align >> PAGE_SHIFT ? : 1;
+	pfn = PFN_DOWN(bdata->node_boot_start);
 
 restart_scan:
 	for (i = preferred; i < eidx; i += incr) {
 		unsigned long j;
 		i = find_next_zero_bit(bdata->node_bootmem_map, eidx, i);
-		i = ALIGN(i, incr);
+		i = ALIGN(pfn + i, incr) - pfn;
 		if (i >= eidx)
 			break;
 		if (test_bit(i, bdata->node_bootmem_map))
