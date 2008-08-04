Return-Path: <linux-kernel-owner+w=401wt.eu-S1756338AbYHDQfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbYHDQfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbYHDQfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:35:31 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:15832 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbYHDQfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:35:30 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K534QL-04-2C2-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: hpa@zytor.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] AMD IOMMU: initialize dma_ops after sysfs registration
Date: Mon, 4 Aug 2008 18:35:13 +0200
Message-ID: <1217867713-25450-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 04 Aug 2008 16:35:13.0853 (UTC) FILETIME=[11EB9ED0:01C8F650]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the initialization of the dma_ops interface for AMD IOMMU
behind the sysfs registration. Without this and if sysfs registration fails the
AMD IOMMU driver is still in place and operates on already freed data.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index d9a9da5..880249d 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -954,15 +954,15 @@ int __init amd_iommu_init(void)
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


