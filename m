Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbZDPMwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbZDPMwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 08:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbZDPMwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 08:52:09 -0400
Received: from relay2.sgi.com ([192.48.179.30]:42595 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753054AbZDPMwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 08:52:08 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: UV BAU distribution and payload MMRs
Cc: mingo@elte.hu
Message-Id: <E1LuR5Z-0007An-B8@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Thu, 16 Apr 2009 07:53:09 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Cliff Wickman <cpw@sgi.com>

This patch correctly sets BAU memory mapped registers to point
to the sending activation descriptor table and target payload table.

The "Broadcast Assist Unit" is used for TLB shootdown in UV.

The memory mapped registers that point to sending and receiving
memory structures contain node numbers.
In one case the __pa() function did not provide the node id of
memory on blade zero in configurations where that id is nonzero.
In another case, it was assumed that memory was allocated on
the local node.  That assumption is not true in a configuration
in which the node has no memory.

Tested on the UV hardware simulator.

Diffed against 2.6.29

Signed-off-by: Cliff Wickman <cpw@sgi.com>

---
 arch/x86/kernel/tlb_uv.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

Index: linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_uv.c
+++ linux/arch/x86/kernel/tlb_uv.c
@@ -718,7 +718,7 @@ uv_activation_descriptor_init(int node, 
 	adp = (struct bau_desc *)kmalloc_node(16384, GFP_KERNEL, node);
 	BUG_ON(!adp);
 
-	pa = __pa((unsigned long)adp);
+	pa = uv_gpa(adp); /* need the real nasid*/
 	n = pa >> uv_nshift;
 	m = pa & uv_mmask;
 
@@ -755,6 +755,8 @@ static struct bau_payload_queue_entry * 
 uv_payload_queue_init(int node, int pnode, struct bau_control *bau_tablesp)
 {
 	struct bau_payload_queue_entry *pqp;
+	unsigned long pa;
+	int pn;
 	char *cp;
 
 	pqp = (struct bau_payload_queue_entry *) kmalloc_node(
@@ -765,10 +767,14 @@ uv_payload_queue_init(int node, int pnod
 	cp = (char *)pqp + 31;
 	pqp = (struct bau_payload_queue_entry *)(((unsigned long)cp >> 5) << 5);
 	bau_tablesp->va_queue_first = pqp;
+	/*
+	 * need the pnode of where the memory was really allocated
+	 */
+	pa = uv_gpa(pqp);
+	pn = pa >> uv_nshift;
 	uv_write_global_mmr64(pnode,
 			      UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST,
-			      ((unsigned long)pnode <<
-			       UV_PAYLOADQ_PNODE_SHIFT) |
+			      ((unsigned long)pn << UV_PAYLOADQ_PNODE_SHIFT) |
 			      uv_physnodeaddr(pqp));
 	uv_write_global_mmr64(pnode, UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL,
 			      uv_physnodeaddr(pqp));
