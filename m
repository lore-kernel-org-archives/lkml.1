Return-Path: <linux-kernel-owner+w=401wt.eu-S932327AbYETKEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327AbYETKEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 06:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764931AbYETKBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 06:01:22 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2895 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764714AbYETKBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 06:01:20 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andy Whitcroft <apw@shadowen.org>, Mel Gorman <mel@csn.ul.ie>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86: cope with no remap space being allocated for a numa node
References: <exportbomb.1211277639@pinky>
InReply-To: <exportbomb.1211277639@pinky>
Date: Tue, 20 May 2008 11:01:19 +0100
Message-Id: <1211277679.0@pinky>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When allocating the pgdat's for numa nodes on x86_32 we attempt to
place them in the numa remap space for that node.  However should
the node not have any remap space allocated (such as due to having
non-ram pages in the remap location in the node) then we will
incorrectly place the pgdat at zero.  Check we have remap available,
falling back to node 0 memory where we do not.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
---
 arch/x86/mm/discontig_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
diff --git a/arch/x86/mm/discontig_32.c b/arch/x86/mm/discontig_32.c
index 026201f..435c343 100644
--- a/arch/x86/mm/discontig_32.c
+++ b/arch/x86/mm/discontig_32.c
@@ -156,7 +156,7 @@ static void __init propagate_e820_map_node(int nid)
  */
 static void __init allocate_pgdat(int nid)
 {
-	if (nid && node_has_online_mem(nid))
+	if (nid && node_has_online_mem(nid) && node_remap_start_vaddr[nid])
 		NODE_DATA(nid) = (pg_data_t *)node_remap_start_vaddr[nid];
 	else {
 		NODE_DATA(nid) = (pg_data_t *)(pfn_to_kaddr(min_low_pfn));
