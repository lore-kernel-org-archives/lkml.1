Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbZESWva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbZESWva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 18:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZESWvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 18:51:23 -0400
Received: from relay1.sgi.com ([192.48.179.29]:59283 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751910AbZESWvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 18:51:22 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: UV BAU activation descriptor init
Cc: mingo@elte.hu, hpa@zytor.com
Message-Id: <E1M6YCG-0002eM-1Z@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Tue, 19 May 2009 17:54:08 -0500
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

Tested on the UV simulator.

Diffed against 2.6.30-rc6

Signed-off-by: Cliff Wickman <cpw@sgi.com>

---
 arch/x86/kernel/tlb_uv.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_uv.c
+++ linux/arch/x86/kernel/tlb_uv.c
@@ -715,7 +715,14 @@ uv_activation_descriptor_init(int node, 
 	struct bau_desc *adp;
 	struct bau_desc *ad2;
 
-	adp = (struct bau_desc *)kmalloc_node(16384, GFP_KERNEL, node);
+	/*
+	 * each bau_desc is 64 bytes; there are 8 (UV_ITEMS_PER_DESCRIPTOR)
+	 * per cpu; and up to 32 (UV_ACTIVATION_DESCRIPTOR_SIZE) cpu's
+	 * per blade
+	 */
+	adp = (struct bau_desc *)kmalloc_node(sizeof(struct bau_desc)*
+		UV_ACTIVATION_DESCRIPTOR_SIZE*UV_ITEMS_PER_DESCRIPTOR,
+		GFP_KERNEL, node);
 	BUG_ON(!adp);
 
 	pa = uv_gpa(adp); /* need the real nasid*/
@@ -729,7 +736,14 @@ uv_activation_descriptor_init(int node, 
 				      (n << UV_DESC_BASE_PNODE_SHIFT | m));
 	}
 
-	for (i = 0, ad2 = adp; i < UV_ACTIVATION_DESCRIPTOR_SIZE; i++, ad2++) {
+	/*
+	 * initializing all 8 (UV_ITEMS_PER_DESCRIPTOR) descriptors for each
+	 * cpu even though we only use the first one; one descriptor can
+	 * describe a broadcast to 256 nodes.
+	 */
+	for (i = 0, ad2 = adp;
+		i < (UV_ACTIVATION_DESCRIPTOR_SIZE*UV_ITEMS_PER_DESCRIPTOR);
+		i++, ad2++) {
 		memset(ad2, 0, sizeof(struct bau_desc));
 		ad2->header.sw_ack_flag = 1;
 		/*
