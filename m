Return-Path: <linux-kernel-owner+w=401wt.eu-S1762662AbYFZTeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762662AbYFZTeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760886AbYFZT2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:28:52 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:12965 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760776AbYFZT2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:28:49 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K334R2-04-UNI-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 29/34] AMD IOMMU: add dma_ops initialization function
Date: Thu, 26 Jun 2008 21:28:05 +0200
Message-ID: <1214508490-29683-30-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:12.0190 (UTC) FILETIME=[C5C7EBE0:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the function to initialize the dma_ops for the AMD IOMMU.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   46 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index bed5f82..c282bde 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -906,3 +906,49 @@ void prealloc_protection_domains(void)
 	}
 }
 
+static struct dma_mapping_ops amd_iommu_dma_ops = {
+	.alloc_coherent = alloc_coherent,
+	.free_coherent = free_coherent,
+	.map_single = map_single,
+	.unmap_single = unmap_single,
+	.map_sg = map_sg,
+	.unmap_sg = unmap_sg,
+};
+
+int __init amd_iommu_init_dma_ops(void)
+{
+	struct amd_iommu *iommu;
+	int order = amd_iommu_aperture_order;
+	int ret;
+
+	list_for_each_entry(iommu, &amd_iommu_list, list) {
+		iommu->default_dom = dma_ops_domain_alloc(iommu, order);
+		if (iommu->default_dom == NULL)
+			return -ENOMEM;
+		ret = iommu_init_unity_mappings(iommu);
+		if (ret)
+			goto free_domains;
+	}
+
+	if (amd_iommu_isolate)
+		prealloc_protection_domains();
+
+	iommu_detected = 1;
+	force_iommu = 1;
+	bad_dma_address = 0;
+	gart_iommu_aperture_disabled = 1;
+	gart_iommu_aperture = 0;
+
+	dma_ops = &amd_iommu_dma_ops;
+
+	return 0;
+
+free_domains:
+
+	list_for_each_entry(iommu, &amd_iommu_list, list) {
+		if (iommu->default_dom)
+			dma_ops_domain_free(iommu->default_dom);
+	}
+
+	return ret;
+}
-- 
1.5.3.7


