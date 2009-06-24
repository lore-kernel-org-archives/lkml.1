Return-Path: <linux-kernel-owner+w=401wt.eu-S1759993AbZFXOkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993AbZFXOkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 10:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbZFXOk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 10:40:28 -0400
Received: from relay1.sgi.com ([192.48.179.29]:40210 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750975AbZFXOk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 10:40:28 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: uv bau sending buffer initialization
Cc: mingo@elte.hu
Message-Id: <E1MJTfj-0005i1-W8@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Wed, 24 Jun 2009 09:41:59 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

The initialization of the UV Broadcast Assist Unit's sending buffers
was making an invalid assumption about the initialization of an MMR
that defines its address.

The BIOS will not be providing that MMR.  So uv_activation_descriptor_init()
should unconditionally set it.

Tested on UV simulator.

Diffed against 2.6.30

Signed-off-by: Cliff Wickman <cpw@sgi.com>

---
 arch/x86/kernel/tlb_uv.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

Index: linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_uv.c
+++ linux/arch/x86/kernel/tlb_uv.c
@@ -711,7 +711,6 @@ uv_activation_descriptor_init(int node, 
 	unsigned long pa;
 	unsigned long m;
 	unsigned long n;
-	unsigned long mmr_image;
 	struct bau_desc *adp;
 	struct bau_desc *ad2;
 
@@ -727,12 +726,8 @@ uv_activation_descriptor_init(int node, 
 	n = pa >> uv_nshift;
 	m = pa & uv_mmask;
 
-	mmr_image = uv_read_global_mmr64(pnode, UVH_LB_BAU_SB_DESCRIPTOR_BASE);
-	if (mmr_image) {
-		uv_write_global_mmr64(pnode, (unsigned long)
-				      UVH_LB_BAU_SB_DESCRIPTOR_BASE,
-				      (n << UV_DESC_BASE_PNODE_SHIFT | m));
-	}
+	uv_write_global_mmr64(pnode, UVH_LB_BAU_SB_DESCRIPTOR_BASE,
+			      (n << UV_DESC_BASE_PNODE_SHIFT | m));
 
 	/*
 	 * initializing all 8 (UV_ITEMS_PER_DESCRIPTOR) descriptors for each
