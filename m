Return-Path: <linux-kernel-owner+w=401wt.eu-S934127AbZLJL4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934127AbZLJL4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 06:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934234AbZLJLzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 06:55:55 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:33989 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934202AbZLJLzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 06:55:52 -0500
X-SpamScore: 7
X-BigFish: VPS7(zba6lzab9bhzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KUFQH1-02-41O-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/2] x86/amd-iommu: Fix PCI hotplug with passthrough mode
Date: Thu, 10 Dec 2009 12:55:35 +0100
Message-ID: <1260446135-16460-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.4
In-Reply-To: <1260446135-16460-1-git-send-email-joerg.roedel@amd.com>
References: <1260446135-16460-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 10 Dec 2009 11:55:46.0951 (UTC) FILETIME=[B5B82970:01CA798F]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device change notifier is initialized in the dma_ops
initialization path. But this path is never executed for
iommu=pt. Move the notifier initialization to IOMMU hardware
init code to fix this.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_proto.h |    1 +
 arch/x86/kernel/amd_iommu.c            |    7 +++++--
 arch/x86/kernel/amd_iommu_init.c       |    2 ++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_proto.h b/arch/x86/include/asm/amd_iommu_proto.h
index 2566e26..4d817f9 100644
--- a/arch/x86/include/asm/amd_iommu_proto.h
+++ b/arch/x86/include/asm/amd_iommu_proto.h
@@ -30,6 +30,7 @@ extern void amd_iommu_apply_erratum_63(u16 devid);
 extern void amd_iommu_reset_cmd_buffer(struct amd_iommu *iommu);
 extern int amd_iommu_init_devices(void);
 extern void amd_iommu_uninit_devices(void);
+extern void amd_iommu_init_notifier(void);
 #ifndef CONFIG_AMD_IOMMU_STATS
 
 static inline void amd_iommu_stats_init(void) { }
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 450dd6a..a831850 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1624,6 +1624,11 @@ static struct notifier_block device_nb = {
 	.notifier_call = device_change_notifier,
 };
 
+void amd_iommu_init_notifier(void)
+{
+	bus_register_notifier(&pci_bus_type, &device_nb);
+}
+
 /*****************************************************************************
  *
  * The next functions belong to the dma_ops mapping/unmapping code.
@@ -2250,8 +2255,6 @@ int __init amd_iommu_init_dma_ops(void)
 
 	register_iommu(&amd_iommu_ops);
 
-	bus_register_notifier(&pci_bus_type, &device_nb);
-
 	amd_iommu_stats_init();
 
 	return 0;
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index df01c69..309a52f 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1285,6 +1285,8 @@ static int __init amd_iommu_init(void)
 	if (ret)
 		goto free;
 
+	amd_iommu_init_notifier();
+
 	enable_iommus();
 
 	if (iommu_pass_through)
-- 
1.6.5.4


