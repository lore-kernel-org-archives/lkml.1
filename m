Return-Path: <linux-kernel-owner+w=401wt.eu-S1759674AbYHNR4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674AbYHNR4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759242AbYHNRzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:55:37 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:31805 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759162AbYHNRzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:55:36 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K5LR46-03-ZTG-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/4] AMD IOMMU: initialize dma_ops after sysfs registration
Date: Thu, 14 Aug 2008 19:55:18 +0200
Message-ID: <1218736518-25301-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1218736518-25301-1-git-send-email-joerg.roedel@amd.com>
References: <1218736518-25301-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 14 Aug 2008 17:55:18.0645 (UTC) FILETIME=[E9EE3250:01C8FE36]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If sysfs registration fails all memory used by IOMMU is freed. This happens
after dma_ops initialization and the functions will access the freed memory
then. Fix this by initializing dma_ops after the sysfs registration.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index ceba338..a69cc0f 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -972,15 +972,15 @@ int __init amd_iommu_init(void)
 	if (acpi_table_parse("IVRS", init_memory_definitions) != 0)
 		goto free;
 
-	ret = amd_iommu_init_dma_ops();
+	ret = sysdev_class_register(&amd_iommu_sysdev_class);
 	if (ret)
 		goto free;
 
-	ret = sysdev_class_register(&amd_iommu_sysdev_class);
+	ret = sysdev_register(&device_amd_iommu);
 	if (ret)
 		goto free;
 
-	ret = sysdev_register(&device_amd_iommu);
+	ret = amd_iommu_init_dma_ops();
 	if (ret)
 		goto free;
 
-- 
1.5.3.7


