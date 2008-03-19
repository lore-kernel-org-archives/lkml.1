Return-Path: <linux-kernel-owner+w=401wt.eu-S935714AbYCSW1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935714AbYCSW1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965328AbYCSVDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:03:25 -0400
Received: from rn-out-0910.google.com ([64.233.170.184]:25372 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975AbYCSVDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:03:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=reply-to:to:subject:user-agent:cc:references:in-reply-to:mime-version:content-disposition:x-length:x-uid:date:content-type:content-transfer-encoding:message-id:from;
        b=Ga4iTsXV+UldDGHNF3tLZvvCnMDpmBQTBh8I0Z2C7OL2OZ72lnXA0UM1kOiR+PBuqGVVtlon0brVJIwAn3ZGizzpHuh+tpcxkboSvmihifHmwI5K893ZZjdpjxyjDNBQglZYHtFZ6vvVX/AnvHZzsxFt3xHia2S4s/4h7yxAVSw=
Reply-To: yhlu.kernel@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 06/12] mm: fix alloc_bootmem_core to use fast searching for all nodes
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Christoph Lameter <clameter@sgi.com>,
       kernel list <linux-kernel@vger.kernel.org>
References: <200803181237.33861.yhlu.kernel@gmail.com>
In-Reply-To: <200803181237.33861.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2934
Date: Wed, 19 Mar 2008 14:04:10 -0700
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200803191404.10282.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] mm: fix alloc_bootmem_core to use fast searching for all nodes

make the nodes other than node 0 could use bdata->last_success for fast search too.

we need to use __alloc_bootmem_core for vmemmap allocation for other nodes when
numa and sparsemem/vmemmap are enabled.

also make fail_block path increase i with incr only needed after ALIGN to avoid
extra increase when size is large than align.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/mm/bootmem.c
===================================================================
--- linux-2.6.orig/mm/bootmem.c
+++ linux-2.6/mm/bootmem.c
@@ -238,28 +238,32 @@ __alloc_bootmem_core(struct bootmem_data
 	 * We try to allocate bootmem pages above 'goal'
 	 * first, then we try to allocate lower pages.
 	 */
-	if (goal && goal >= bdata->node_boot_start && PFN_DOWN(goal) < end_pfn) {
-		preferred = goal - bdata->node_boot_start;
+	preferred = 0;
+	if (goal && PFN_DOWN(goal) < end_pfn) {
+		if (goal > bdata->node_boot_start)
+			preferred = goal - bdata->node_boot_start;
 
 		if (bdata->last_success >= preferred)
 			if (!limit || (limit && limit > bdata->last_success))
 				preferred = bdata->last_success;
-	} else
-		preferred = 0;
+	}
 
 	preferred = PFN_DOWN(ALIGN(preferred, align)) + offset;
 	areasize = (size + PAGE_SIZE-1) / PAGE_SIZE;
 	incr = align >> PAGE_SHIFT ? : 1;
 
 restart_scan:
-	for (i = preferred; i < eidx; i += incr) {
+	for (i = preferred; i < eidx;) {
 		unsigned long j;
+
 		i = find_next_zero_bit(bdata->node_bootmem_map, eidx, i);
 		i = ALIGN(i, incr);
 		if (i >= eidx)
 			break;
-		if (test_bit(i, bdata->node_bootmem_map))
+		if (test_bit(i, bdata->node_bootmem_map)) {
+			i += incr;
 			continue;
+		}
 		for (j = i + 1; j < i + areasize; ++j) {
 			if (j >= eidx)
 				goto fail_block;
@@ -270,6 +274,8 @@ restart_scan:
 		goto found;
 	fail_block:
 		i = ALIGN(j, incr);
+		if (i == j)
+			i += incr;
 	}
 
 	if (preferred > offset) {
