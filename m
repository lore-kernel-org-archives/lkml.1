Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbZDPRqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbZDPRqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 13:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756565AbZDPRqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 13:46:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:38737 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928AbZDPRq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 13:46:29 -0400
Date: Thu, 16 Apr 2009 17:45:39 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <E1LuR5Z-0007An-B8@eag09.americas.sgi.com>
References: <E1LuR5Z-0007An-B8@eag09.americas.sgi.com>
Subject: [tip:x86/uv] x86: UV BAU distribution and payload MMRs
Message-ID: <tip-4ea3c51d5bd3bb4eea7d7d3a1f80d1a48c2a6f92@git.kernel.org>
Git-Commit-ID: 4ea3c51d5bd3bb4eea7d7d3a1f80d1a48c2a6f92
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 16 Apr 2009 17:45:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4ea3c51d5bd3bb4eea7d7d3a1f80d1a48c2a6f92
Gitweb:     http://git.kernel.org/tip/4ea3c51d5bd3bb4eea7d7d3a1f80d1a48c2a6f92
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Thu, 16 Apr 2009 07:53:09 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 16 Apr 2009 19:44:16 +0200

x86: UV BAU distribution and payload MMRs

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

[ Impact: fix possible runtime crash due to incorrect TLB logic ]

Signed-off-by: Cliff Wickman <cpw@sgi.com>
LKML-Reference: <E1LuR5Z-0007An-B8@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/tlb_uv.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 98307f9..7842233 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -717,7 +717,7 @@ uv_activation_descriptor_init(int node, int pnode)
 	adp = (struct bau_desc *)kmalloc_node(16384, GFP_KERNEL, node);
 	BUG_ON(!adp);
 
-	pa = __pa((unsigned long)adp);
+	pa = uv_gpa(adp); /* need the real nasid*/
 	n = pa >> uv_nshift;
 	m = pa & uv_mmask;
 
@@ -754,6 +754,8 @@ static struct bau_payload_queue_entry * __init
 uv_payload_queue_init(int node, int pnode, struct bau_control *bau_tablesp)
 {
 	struct bau_payload_queue_entry *pqp;
+	unsigned long pa;
+	int pn;
 	char *cp;
 
 	pqp = (struct bau_payload_queue_entry *) kmalloc_node(
@@ -764,10 +766,14 @@ uv_payload_queue_init(int node, int pnode, struct bau_control *bau_tablesp)
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
