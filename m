Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbYLOOZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbYLOOZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:25:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbYLOOTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:19:36 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:27467 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbYLOOTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:19:35 -0500
X-BigFish: VPS6(zz8b9ckzzzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KBX93B-03-00U-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/22] AMD IOMMU: add init code for statistic collection
Date: Mon, 15 Dec 2008 15:17:53 +0100
Message-ID: <1229350685-3816-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
References: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 15 Dec 2008 14:18:06.0197 (UTC) FILETIME=[F2CBB250:01C95EBF]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: create a new debugfs directory

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    2 +
 arch/x86/kernel/amd_iommu.c            |   37 ++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 1379c5f..95c8cd9 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -420,6 +420,8 @@ struct __iommu_counter {
 #define ADD_STATS_COUNTER(name, x)
 #define SUB_STATS_COUNTER(name, x)
 
+static inline void amd_iommu_stats_init(void) { }
+
 #endif /* CONFIG_AMD_IOMMU_STATS */
 
 #endif /* _ASM_X86_AMD_IOMMU_TYPES_H */
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 0734ae9..be1ddca 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -20,6 +20,7 @@
 #include <linux/pci.h>
 #include <linux/gfp.h>
 #include <linux/bitops.h>
+#include <linux/debugfs.h>
 #include <linux/scatterlist.h>
 #include <linux/iommu-helper.h>
 #ifdef CONFIG_IOMMU_API
@@ -56,6 +57,40 @@ static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 static struct dma_ops_domain *find_protection_domain(u16 devid);
 
 
+#ifdef CONFIG_AMD_IOMMU_STATS
+
+/*
+ * Initialization code for statistics collection
+ */
+
+static struct dentry *stats_dir;
+static struct dentry *de_isolate;
+static struct dentry *de_fflush;
+
+static void amd_iommu_stats_add(struct __iommu_counter *cnt)
+{
+	if (stats_dir == NULL)
+		return;
+
+	cnt->dent = debugfs_create_u64(cnt->name, 0444, stats_dir,
+				       &cnt->value);
+}
+
+static void amd_iommu_stats_init(void)
+{
+	stats_dir = debugfs_create_dir("amd-iommu", NULL);
+	if (stats_dir == NULL)
+		return;
+
+	de_isolate = debugfs_create_bool("isolation", 0444, stats_dir,
+					 (u32 *)&amd_iommu_isolate);
+
+	de_fflush  = debugfs_create_bool("fullflush", 0444, stats_dir,
+					 (u32 *)&amd_iommu_unmap_flush);
+}
+
+#endif
+
 /* returns !0 if the IOMMU is caching non-present entries in its TLB */
 static int iommu_has_npcache(struct amd_iommu *iommu)
 {
@@ -1619,6 +1654,8 @@ int __init amd_iommu_init_dma_ops(void)
 
 	bus_register_notifier(&pci_bus_type, &device_nb);
 
+	amd_iommu_stats_init();
+
 	return 0;
 
 free_domains:
-- 
1.5.6.4


