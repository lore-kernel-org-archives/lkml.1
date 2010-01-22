Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991Ab0AVRS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab0AVRS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 12:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266Ab0AVRSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 12:18:53 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:55971 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975Ab0AVRSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 12:18:43 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzab9bh936eMzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KWNS2G-01-CVG-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>,
       stable@kernel.org
Subject: [PATCH 3/5] x86/amd-iommu: Fix IOMMU-API initialization for iommu=pt
Date: Fri, 22 Jan 2010 18:18:11 +0100
Message-ID: <1264180693-27197-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264180693-27197-1-git-send-email-joerg.roedel@amd.com>
References: <1264180693-27197-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 Jan 2010 17:18:15.0735 (UTC) FILETIME=[E2418C70:01CA9B86]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the initialization of the iommu-api out of
the dma-ops initialization code. This ensures that the
iommu-api is initialized even with iommu=pt.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_proto.h |    1 +
 arch/x86/kernel/amd_iommu.c            |    8 ++++++--
 arch/x86/kernel/amd_iommu_init.c       |    3 +++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_proto.h b/arch/x86/include/asm/amd_iommu_proto.h
index 4d817f9..d2544f1 100644
--- a/arch/x86/include/asm/amd_iommu_proto.h
+++ b/arch/x86/include/asm/amd_iommu_proto.h
@@ -31,6 +31,7 @@ extern void amd_iommu_reset_cmd_buffer(struct amd_iommu *iommu);
 extern int amd_iommu_init_devices(void);
 extern void amd_iommu_uninit_devices(void);
 extern void amd_iommu_init_notifier(void);
+extern void amd_iommu_init_api(void);
 #ifndef CONFIG_AMD_IOMMU_STATS
 
 static inline void amd_iommu_stats_init(void) { }
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 4478a48..751ce73 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2221,6 +2221,12 @@ static struct dma_map_ops amd_iommu_dma_ops = {
 /*
  * The function which clues the AMD IOMMU driver into dma_ops.
  */
+
+void __init amd_iommu_init_api(void)
+{
+	register_iommu(&amd_iommu_ops);
+}
+
 int __init amd_iommu_init_dma_ops(void)
 {
 	struct amd_iommu *iommu;
@@ -2256,8 +2262,6 @@ int __init amd_iommu_init_dma_ops(void)
 	/* Make the driver finally visible to the drivers */
 	dma_ops = &amd_iommu_dma_ops;
 
-	register_iommu(&amd_iommu_ops);
-
 	amd_iommu_stats_init();
 
 	return 0;
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index fb490ce..9dc91b4 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1292,9 +1292,12 @@ static int __init amd_iommu_init(void)
 		ret = amd_iommu_init_passthrough();
 	else
 		ret = amd_iommu_init_dma_ops();
+
 	if (ret)
 		goto free;
 
+	amd_iommu_init_api();
+
 	amd_iommu_init_notifier();
 
 	enable_iommus();
-- 
1.6.6


