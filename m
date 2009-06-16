Return-Path: <linux-kernel-owner+w=401wt.eu-S1760841AbZFPUZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760841AbZFPUZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758988AbZFPUZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:25:05 -0400
Received: from claw.goop.org ([74.207.240.146]:42125 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbZFPUZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:25:04 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Cliff Wickman <cpw@sgi.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 03/16] x86: Fix UV BAU activation descriptor init
Date: Tue, 16 Jun 2009 13:15:42 -0700
Message-Id: <1245183355-25808-4-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1245183355-25808-1-git-send-email-jeremy@goop.org>
References: <1245183355-25808-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

The UV tlb shootdown code has a serious initialization error.

An array of structures [32*8] is initialized as if it were [32].
The array is indexed by (cpu number on the blade)*8, so the short
initialization works for up to 4 cpus on a blade.
But above that, we provide an invalid opcode to the hub's
broadcast assist unit.

This patch changes the allocation of the array to use its symbolic
dimensions for better clarity. And initializes all 32*8 entries.

Shortened 'UV_ACTIVATION_DESCRIPTOR_SIZE' to 'UV_ADP_SIZE' per Ingo's
recommendation.

Tested on the UV simulator.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
LKML-Reference: <E1M6lZR-0007kV-Aq@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uv/uv_bau.h |    2 +-
 arch/x86/kernel/tlb_uv.c         |   15 +++++++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 9b0e61b..bddd44f 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -37,7 +37,7 @@
 #define UV_CPUS_PER_ACT_STATUS		32
 #define UV_ACT_STATUS_MASK		0x3
 #define UV_ACT_STATUS_SIZE		2
-#define UV_ACTIVATION_DESCRIPTOR_SIZE	32
+#define UV_ADP_SIZE			32
 #define UV_DISTRIBUTION_SIZE		256
 #define UV_SW_ACK_NPENDING		8
 #define UV_NET_ENDPOINT_INTD		0x38
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index ed0c337..16f0fd4 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -715,7 +715,12 @@ uv_activation_descriptor_init(int node, int pnode)
 	struct bau_desc *adp;
 	struct bau_desc *ad2;
 
-	adp = (struct bau_desc *)kmalloc_node(16384, GFP_KERNEL, node);
+	/*
+	 * each bau_desc is 64 bytes; there are 8 (UV_ITEMS_PER_DESCRIPTOR)
+	 * per cpu; and up to 32 (UV_ADP_SIZE) cpu's per blade
+	 */
+	adp = (struct bau_desc *)kmalloc_node(sizeof(struct bau_desc)*
+		UV_ADP_SIZE*UV_ITEMS_PER_DESCRIPTOR, GFP_KERNEL, node);
 	BUG_ON(!adp);
 
 	pa = uv_gpa(adp); /* need the real nasid*/
@@ -729,7 +734,13 @@ uv_activation_descriptor_init(int node, int pnode)
 				      (n << UV_DESC_BASE_PNODE_SHIFT | m));
 	}
 
-	for (i = 0, ad2 = adp; i < UV_ACTIVATION_DESCRIPTOR_SIZE; i++, ad2++) {
+	/*
+	 * initializing all 8 (UV_ITEMS_PER_DESCRIPTOR) descriptors for each
+	 * cpu even though we only use the first one; one descriptor can
+	 * describe a broadcast to 256 nodes.
+	 */
+	for (i = 0, ad2 = adp; i < (UV_ADP_SIZE*UV_ITEMS_PER_DESCRIPTOR);
+		i++, ad2++) {
 		memset(ad2, 0, sizeof(struct bau_desc));
 		ad2->header.sw_ack_flag = 1;
 		/*
-- 
1.6.2.2

