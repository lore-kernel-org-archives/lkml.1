Return-Path: <linux-kernel-owner+w=401wt.eu-S1758951AbZFXPhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbZFXPhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 11:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbZFXPhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 11:37:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:37904 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbZFXPhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 11:37:35 -0400
Date: Wed, 24 Jun 2009 15:36:35 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <E1MJTfj-0005i1-W8@eag09.americas.sgi.com>
References: <E1MJTfj-0005i1-W8@eag09.americas.sgi.com>
Subject: [tip:x86/urgent] x86: Fix uv bau sending buffer initialization
Message-ID: <tip-9c26f52b900f7207135bafc8789e1a4f5d43e096@git.kernel.org>
Git-Commit-ID: 9c26f52b900f7207135bafc8789e1a4f5d43e096
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 24 Jun 2009 15:36:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9c26f52b900f7207135bafc8789e1a4f5d43e096
Gitweb:     http://git.kernel.org/tip/9c26f52b900f7207135bafc8789e1a4f5d43e096
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Wed, 24 Jun 2009 09:41:59 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 24 Jun 2009 17:33:58 +0200

x86: Fix uv bau sending buffer initialization

The initialization of the UV Broadcast Assist Unit's sending
buffers was making an invalid assumption about the
initialization of an MMR that defines its address.

The BIOS will not be providing that MMR.  So
uv_activation_descriptor_init() should unconditionally set it.

Tested on UV simulator.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: <stable@kernel.org> # for v2.6.30.x
LKML-Reference: <E1MJTfj-0005i1-W8@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/tlb_uv.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 124d40c..8ccabb8 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -711,7 +711,6 @@ uv_activation_descriptor_init(int node, int pnode)
 	unsigned long pa;
 	unsigned long m;
 	unsigned long n;
-	unsigned long mmr_image;
 	struct bau_desc *adp;
 	struct bau_desc *ad2;
 
@@ -727,12 +726,8 @@ uv_activation_descriptor_init(int node, int pnode)
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
