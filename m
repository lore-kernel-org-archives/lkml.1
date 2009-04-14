Return-Path: <linux-kernel-owner+w=401wt.eu-S1756260AbZDNSav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbZDNSav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758679AbZDNS23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:28:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:37450 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758650AbZDNS2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:28:17 -0400
Date: Tue, 14 Apr 2009 18:27:35 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <E1Ltl0C-0004Ob-37@eag09.americas.sgi.com>
References: <E1Ltl0C-0004Ob-37@eag09.americas.sgi.com>
Subject: [tip:x86/uv] x86: UV: BAU partition-relative distribution map
Message-ID: <tip-94ca8e4852807fc42d2f64fcaf248aafc4f2e6a7@git.kernel.org>
Git-Commit-ID: 94ca8e4852807fc42d2f64fcaf248aafc4f2e6a7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 18:27:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  94ca8e4852807fc42d2f64fcaf248aafc4f2e6a7
Gitweb:     http://git.kernel.org/tip/94ca8e4852807fc42d2f64fcaf248aafc4f2e6a7
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Tue, 14 Apr 2009 10:56:48 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 14 Apr 2009 18:53:36 +0200

x86: UV: BAU partition-relative distribution map

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

Signed-off-by: Cliff Wickman <cpw@sgi.com>
LKML-Reference: <E1Ltl0C-0004Ob-37@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/tlb_uv.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index fced96e..98307f9 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -25,6 +25,8 @@ static int			uv_bau_retry_limit __read_mostly;
 
 /* position of pnode (which is nasid>>1): */
 static int			uv_nshift __read_mostly;
+/* base pnode in this partition */
+static int			uv_partition_base_pnode __read_mostly;
 
 static unsigned long		uv_mmask __read_mostly;
 
@@ -43,7 +45,7 @@ static int __init blade_to_first_node(int blade)
 		if (blade == b)
 			return node;
 	}
-	BUG();
+	return -1; /* shouldn't happen */
 }
 
 /*
@@ -359,7 +361,8 @@ const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 			locals++;
 			continue;
 		}
-		bau_node_set(pnode, &bau_desc->distribution);
+		bau_node_set(pnode - uv_partition_base_pnode,
+				&bau_desc->distribution);
 		i++;
 	}
 	if (i == 0) {
@@ -728,7 +731,12 @@ uv_activation_descriptor_init(int node, int pnode)
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
@@ -825,6 +833,11 @@ static int __init uv_bau_init(void)
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
