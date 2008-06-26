Return-Path: <linux-kernel-owner+w=401wt.eu-S1762816AbYFZTjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762816AbYFZTjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbYFZT3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:29:21 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:14203 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759898AbYFZT3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:29:14 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K334RT-04-UOA-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 15/34] AMD IOMMU: add early detection code
Date: Thu, 26 Jun 2008 21:27:51 +0200
Message-ID: <1214508490-29683-16-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:11.0777 (UTC) FILETIME=[C588E710:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code to detect an AMD IOMMU early during boot before the early
detection code of other IOMMUs run.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index c792ddc..d7a75bf 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -769,3 +769,23 @@ free:
 	goto out;
 }
 
+static int __init early_amd_iommu_detect(struct acpi_table_header *table)
+{
+	return 0;
+}
+
+void __init amd_iommu_detect(void)
+{
+	if (swiotlb || no_iommu || iommu_detected)
+		return;
+
+	if (amd_iommu_disable)
+		return;
+
+	if (acpi_table_parse("IVRS", early_amd_iommu_detect) == 0) {
+		iommu_detected = 1;
+		gart_iommu_aperture_disabled = 1;
+		gart_iommu_aperture = 0;
+	}
+}
+
-- 
1.5.3.7


