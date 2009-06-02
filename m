Return-Path: <linux-kernel-owner+w=401wt.eu-S1755784AbZFBBH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784AbZFBBH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 21:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbZFBBHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 21:07:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:33755 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731AbZFBBHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 21:07:17 -0400
Date: Tue, 2 Jun 2009 01:06:38 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <E1M6lZR-0007kV-Aq@eag09.americas.sgi.com>
References: <E1M6lZR-0007kV-Aq@eag09.americas.sgi.com>
Subject: [tip:x86/urgent] x86: Fix UV BAU activation descriptor init
Message-ID: <tip-2602dc43a8ba2ca17609067819937c52b34c05c0@git.kernel.org>
Git-Commit-ID: 2602dc43a8ba2ca17609067819937c52b34c05c0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 01:06:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2602dc43a8ba2ca17609067819937c52b34c05c0
Gitweb:     http://git.kernel.org/tip/2602dc43a8ba2ca17609067819937c52b34c05c0
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Wed, 20 May 2009 08:10:57 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 02:50:33 +0200

x86: Fix UV BAU activation descriptor init

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
