Return-Path: <linux-kernel-owner+w=401wt.eu-S1759492AbYHNRzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492AbYHNRzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbYHNRz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:55:28 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:20751 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbYHNRz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:55:27 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0K5LR44-03-ZTF-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/4] AMD IOMMU: initialize device table properly
Date: Thu, 14 Aug 2008 19:55:16 +0200
Message-ID: <1218736518-25301-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1218736518-25301-1-git-send-email-joerg.roedel@amd.com>
References: <1218736518-25301-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 14 Aug 2008 17:55:18.0598 (UTC) FILETIME=[E9E70660:01C8FE36]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device table initializations which forbids memory accesses for
devices per default and disables all page faults.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c  |   18 ++++++++++++++++++
 include/asm-x86/amd_iommu_types.h |    1 +
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index d9a9da5..ceba338 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -801,6 +801,21 @@ static int __init init_memory_definitions(struct acpi_table_header *table)
 }
 
 /*
+ * Init the device table to not allow DMA access for devices and
+ * suppress all page faults
+ */
+static void init_device_table(void)
+{
+	u16 devid;
+
+	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid) {
+		set_dev_entry_bit(devid, DEV_ENTRY_VALID);
+		set_dev_entry_bit(devid, DEV_ENTRY_TRANSLATION);
+		set_dev_entry_bit(devid, DEV_ENTRY_NO_PAGE_FAULT);
+	}
+}
+
+/*
  * This function finally enables all IOMMUs found in the system after
  * they have been initialized
  */
@@ -931,6 +946,9 @@ int __init amd_iommu_init(void)
 	if (amd_iommu_pd_alloc_bitmap == NULL)
 		goto free;
 
+	/* init the device table */
+	init_device_table();
+
 	/*
 	 * let all alias entries point to itself
 	 */
diff --git a/include/asm-x86/amd_iommu_types.h b/include/asm-x86/amd_iommu_types.h
index 2c23834..01412f0 100644
--- a/include/asm-x86/amd_iommu_types.h
+++ b/include/asm-x86/amd_iommu_types.h
@@ -103,6 +103,7 @@
 #define DEV_ENTRY_TRANSLATION   0x01
 #define DEV_ENTRY_IR            0x3d
 #define DEV_ENTRY_IW            0x3e
+#define DEV_ENTRY_NO_PAGE_FAULT	0x62
 #define DEV_ENTRY_EX            0x67
 #define DEV_ENTRY_SYSMGT1       0x68
 #define DEV_ENTRY_SYSMGT2       0x69
-- 
1.5.3.7


