Return-Path: <linux-kernel-owner+w=401wt.eu-S1762755AbYGABd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762755AbYGABd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 21:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbYGABdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 21:33:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:25401 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbYGABdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 21:33:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=o6ZtPv0ngWiNN9QIvZRNzjZPZgEw3g0J9wQ3TeG3DnTdx1cvCoiT0uSY3R8PP4zpcB
         PFtbzN5DtIzYLWRPIh5b40bvBMtwvXVd9L8FnTyZ3B6fFj9T1DZn3uFw4DC8+F7KWWJS
         JpKZmC6X2wKDHmbqlEOtZlRS0VlmyvLD+8+FQ=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: don't reallocate pgt for node0
Date: Mon, 30 Jun 2008 18:34:58 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806301834.59156.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


kva ram already mapped right after away, so don't need to get that for low ram.
avoid wasting one copy pgdat.

also add node id in early_res name in case get it from find_e820_area.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/mm/discontig_32.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/mm/discontig_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/discontig_32.c
+++ linux-2.6/arch/x86/mm/discontig_32.c
@@ -156,17 +156,20 @@ static void __init propagate_e820_map_no
  */
 static void __init allocate_pgdat(int nid)
 {
-	if (nid && node_has_online_mem(nid) && node_remap_start_vaddr[nid])
+	char buf[16];
+
+	if (node_has_online_mem(nid) && node_remap_start_vaddr[nid])
 		NODE_DATA(nid) = (pg_data_t *)node_remap_start_vaddr[nid];
 	else {
 		unsigned long pgdat_phys;
 		pgdat_phys = find_e820_area(min_low_pfn<<PAGE_SHIFT,
-				 (nid ? max_low_pfn:max_pfn_mapped)<<PAGE_SHIFT,
+				 max_pfn_mapped<<PAGE_SHIFT,
 				 sizeof(pg_data_t),
 				 PAGE_SIZE);
 		NODE_DATA(nid) = (pg_data_t *)(pfn_to_kaddr(pgdat_phys>>PAGE_SHIFT));
-		reserve_early(pgdat_phys, pgdat_phys + sizeof(pg_data_t),
-			      "NODE_DATA");
+		memset(buf, 0, sizeof(buf));
+		sprintf(buf, "NODE_DATA %d",  nid);
+		reserve_early(pgdat_phys, pgdat_phys + sizeof(pg_data_t), buf);
 	}
 	printk(KERN_DEBUG "allocate_pgdat: node %d NODE_DATA %08lx\n",
 		nid, (unsigned long)NODE_DATA(nid));
