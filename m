Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbZDNP6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbZDNP6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbZDNPzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:55:52 -0400
Received: from relay3.sgi.com ([192.48.156.57]:34684 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754834AbZDNPzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:55:51 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: UV BAU partition-relative distribution map
Cc: mingo@elte.hu
Message-Id: <E1Ltl0C-0004Ob-37@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Tue, 14 Apr 2009 10:56:48 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Cliff Wickman <cpw@sgi.com>

This patch enables each partition's BAU distribution bit map
to be partition-relative.

The distribution bitmap had been constructed assuming 0 as the base
node number.  That construct would not have allowed a total system of
greater than 256 nodes.
It also corrects an error that occurred when the first blade's nasid
was not zero.  That nasid was stored as the base node.
The base node number gets added by hardware to the node numbers implied
in the distribution bitmap, resulting in invalid target nasids.

Tested on the UV hardware simulator.

Diffed against 2.6.29

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/tlb_uv.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

Index: linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_uv.c
+++ linux/arch/x86/kernel/tlb_uv.c
@@ -25,6 +25,8 @@ static int			uv_bau_retry_limit __read_m
 
 /* position of pnode (which is nasid>>1): */
 static int			uv_nshift __read_mostly;
+/* base pnode in this partition */
+static int			uv_partition_base_pnode __read_mostly;
 
 static unsigned long		uv_mmask __read_mostly;
 
@@ -43,7 +45,7 @@ static int __init blade_to_first_node(in
 		if (blade == b)
 			return node;
 	}
-	BUG();
+	return -1; /* shouldn't happen */
 }
 
 /*
@@ -360,7 +362,8 @@ const struct cpumask *uv_flush_tlb_other
 			locals++;
 			continue;
 		}
-		bau_node_set(pnode, &bau_desc->distribution);
+		bau_node_set(pnode - uv_partition_base_pnode,
+				&bau_desc->distribution);
 		i++;
 	}
 	if (i == 0) {
@@ -729,7 +732,12 @@ uv_activation_descriptor_init(int node, 
 	for (i = 0, ad2 = adp; i < UV_ACTIVATION_DESCRIPTOR_SIZE; i++, ad2++) {
 		memset(ad2, 0, sizeof(struct bau_desc));
 		ad2->header.sw_ack_flag = 1;
-		ad2->header.base_dest_nodeid = uv_cpu_to_pnode(0);
+		/*
+		 * base_dest_nodeid is the first node in the partition, so
+		 * the bit map will indicate partition-relative node numbers.
+		 * note that base_dest_nodeid is actually a nasid.
+		 */
+		ad2->header.base_dest_nodeid = uv_partition_base_pnode << 1;
 		ad2->header.command = UV_NET_ENDPOINT_INTD;
 		ad2->header.int_both = 1;
 		/*
@@ -830,6 +838,11 @@ static int __init uv_bau_init(void)
 	    kmalloc(nblades * sizeof(struct bau_control *), GFP_KERNEL);
 	BUG_ON(!uv_bau_table_bases);
 
+	uv_partition_base_pnode = 0x7fffffff;
+	for (blade = 0; blade < nblades; blade++)
+		if (uv_blade_nr_possible_cpus(blade) &&
+			(uv_blade_to_pnode(blade) < uv_partition_base_pnode))
+			uv_partition_base_pnode = uv_blade_to_pnode(blade);
 	for (blade = 0; blade < nblades; blade++)
 		if (uv_blade_nr_possible_cpus(blade))
 			uv_init_blade(blade);
