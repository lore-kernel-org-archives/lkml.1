Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbYGCRfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbYGCRfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 13:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbYGCRfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 13:35:30 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:12266 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbYGCRf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 13:35:29 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K3FY6N-03-NVD-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/6] AMD IOMMU: don't try to init IOMMU if early detect code did not detect one
Date: Thu, 3 Jul 2008 19:35:10 +0200
Message-ID: <1215106511-12915-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1215106511-12915-1-git-send-email-joerg.roedel@amd.com>
References: <1215106511-12915-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Jul 2008 17:35:12.0210 (UTC) FILETIME=[257D5320:01C8DD33]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a check if the early detect code has found AMD IOMMU hardware
descriptions and does not try to initialize hardware if the check failed.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index c54c823..c970fac 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -101,6 +101,8 @@ struct ivmd_header {
 	u64 range_length;
 } __attribute__((packed));
 
+static int __initdata amd_iommu_detected;
+
 u16 amd_iommu_last_bdf;
 struct list_head amd_iommu_unity_map;
 unsigned amd_iommu_aperture_order = 26;
@@ -689,6 +691,9 @@ int __init amd_iommu_init(void)
 		return 0;
 	}
 
+	if (!amd_iommu_detected)
+		return -ENODEV;
+
 	/*
 	 * First parse ACPI tables to find the largest Bus/Dev/Func
 	 * we need to handle. Upon this information the shared data
@@ -831,6 +836,7 @@ void __init amd_iommu_detect(void)
 
 	if (acpi_table_parse("IVRS", early_amd_iommu_detect) == 0) {
 		iommu_detected = 1;
+		amd_iommu_detected = 1;
 #ifdef CONFIG_GART_IOMMU
 		gart_iommu_aperture_disabled = 1;
 		gart_iommu_aperture = 0;
-- 
1.5.3.7


