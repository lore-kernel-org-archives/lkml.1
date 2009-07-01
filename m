Return-Path: <linux-kernel-owner+w=401wt.eu-S1764974AbZGAA7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764974AbZGAA7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761497AbZGAAey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:54 -0400
Received: from kroah.org ([198.145.64.141]:60369 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759857AbZGAAeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:50 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:28 2009
Message-Id: <20090701002428.090919305@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Cliff Wickman <cpw@sgi.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 047/108] x86: Fix uv bau sending buffer initialization
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=x86-fix-uv-bau-sending-buffer-initialization.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Cliff Wickman <cpw@sgi.com>

commit 9c26f52b900f7207135bafc8789e1a4f5d43e096 upstream.

The initialization of the UV Broadcast Assist Unit's sending
buffers was making an invalid assumption about the
initialization of an MMR that defines its address.

The BIOS will not be providing that MMR.  So
uv_activation_descriptor_init() should unconditionally set it.

Tested on UV simulator.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
LKML-Reference: <E1MJTfj-0005i1-W8@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/tlb_uv.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
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


