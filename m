Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbYLaTUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbYLaTUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 14:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbYLaTUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 14:20:03 -0500
Received: from relay3.sgi.com ([192.48.171.31]:57149 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751882AbYLaTUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 14:20:01 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] UV: remove erroneous BAU initialization
Cc: mingo@elte.hu, gregkh@suse.de, dcn@sgi.com
Message-Id: <E1LI6cc-00045u-4i@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Wed, 31 Dec 2008 13:20:50 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

UV is the SGI "UltraViolet" machine, which is x86_64 based.
BAU is the "Broadcast Assist Unit", used for TLB shootdown in UV.

This patch removes the allocation and initialization of an unused table.

This table is left over from a development test mode.  It is unused in
the present code.
And it was incorrectly initialized: 8 entries allocated but 17 initialized,
causing slab corruption.

This patch should go into 2.6.27 and 2.6.28 as well as the current tree.

Diffed against 2.6.28 (linux-next, 12/30/08)

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/tlb_uv.c |    9 ---------
 1 file changed, 9 deletions(-)

Index: linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_uv.c
+++ linux/arch/x86/kernel/tlb_uv.c
@@ -582,7 +582,6 @@ static int __init uv_ptc_init(void)
 static struct bau_control * __init uv_table_bases_init(int blade, int node)
 {
 	int i;
-	int *ip;
 	struct bau_msg_status *msp;
 	struct bau_control *bau_tabp;
 
@@ -599,13 +598,6 @@ static struct bau_control * __init uv_ta
 		bau_cpubits_clear(&msp->seen_by, (int)
 				  uv_blade_nr_possible_cpus(blade));
 
-	bau_tabp->watching =
-	    kmalloc_node(sizeof(int) * DEST_NUM_RESOURCES, GFP_KERNEL, node);
-	BUG_ON(!bau_tabp->watching);
-
-	for (i = 0, ip = bau_tabp->watching; i < DEST_Q_SIZE; i++, ip++)
-		*ip = 0;
-
 	uv_bau_table_bases[blade] = bau_tabp;
 
 	return bau_tabp;
@@ -628,7 +620,6 @@ uv_table_bases_finish(int blade, int nod
 		bcp->bau_msg_head	= bau_tablesp->va_queue_first;
 		bcp->va_queue_first	= bau_tablesp->va_queue_first;
 		bcp->va_queue_last	= bau_tablesp->va_queue_last;
-		bcp->watching		= bau_tablesp->watching;
 		bcp->msg_statuses	= bau_tablesp->msg_statuses;
 		bcp->descriptor_base	= adp;
 	}
