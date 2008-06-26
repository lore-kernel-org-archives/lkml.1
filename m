Return-Path: <linux-kernel-owner+w=401wt.eu-S932149AbYFZTjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbYFZTjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759898AbYFZT3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:29:22 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:5045 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383AbYFZT3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:29:15 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K334RU-04-UOJ-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 31/34] AMD IOMMU: initialize dma_ops from IOMMU initialization and enable IOMMUs
Date: Thu, 26 Jun 2008 21:28:07 +0200
Message-ID: <1214508490-29683-32-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:12.0246 (UTC) FILETIME=[C5D07760:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a call to the driver specific dma_ops initialization routine
from the AMD IOMMU hardware initialization. Further it adds the necessary code
to finally enable AMD IOMMU hardware.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index bae4a76..d1aa234 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -644,6 +644,16 @@ static int __init init_memory_definitions(struct acpi_table_header *table)
 	return 0;
 }
 
+static void __init enable_iommus(void)
+{
+	struct amd_iommu *iommu;
+
+	list_for_each_entry(iommu, &amd_iommu_list, list) {
+		iommu_set_exclusion_range(iommu);
+		iommu_enable(iommu);
+	}
+}
+
 int __init amd_iommu_init(void)
 {
 	int i, ret = 0;
@@ -731,6 +741,12 @@ int __init amd_iommu_init(void)
 	if (acpi_table_parse("IVRS", init_memory_definitions) != 0)
 		goto free;
 
+	ret = amd_iommu_init_dma_ops();
+	if (ret)
+		goto free;
+
+	enable_iommus();
+
 	printk(KERN_INFO "AMD IOMMU: aperture size is %d MB\n",
 			(1 << (amd_iommu_aperture_order-20)));
 
-- 
1.5.3.7


