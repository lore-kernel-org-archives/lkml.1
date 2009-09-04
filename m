Return-Path: <linux-kernel-owner+w=401wt.eu-S933597AbZIDJpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597AbZIDJpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933584AbZIDJps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:45:48 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:53980 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933476AbZIDJpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:45:45 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KPFXR8-03-O44-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/8] x86/amd-iommu: Introduce function for iommu-local domain flush
Date: Fri, 4 Sep 2009 11:44:37 +0200
Message-ID: <1252057482-32207-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057482-32207-1-git-send-email-joerg.roedel@amd.com>
References: <1252057482-32207-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:44:45.0195 (UTC) FILETIME=[55ADA5B0:01CA2D44]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a function to flush all domain tlbs
for on one given IOMMU. This is required later to reset the
command buffer on one IOMMU.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   49 +++++++++++++++++++++++++++++--------------
 1 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index e62b35f..64cc582 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -465,38 +465,55 @@ static void iommu_flush_tlb_pde(struct amd_iommu *iommu, u16 domid)
 }
 
 /*
- * This function is used to flush the IO/TLB for a given protection domain
- * on every IOMMU in the system
+ * This function flushes one domain on one IOMMU
  */
-static void iommu_flush_domain(u16 domid)
+static void flush_domain_on_iommu(struct amd_iommu *iommu, u16 domid)
 {
-	unsigned long flags;
-	struct amd_iommu *iommu;
 	struct iommu_cmd cmd;
-
-	INC_STATS_COUNTER(domain_flush_all);
+	unsigned long flags;
 
 	__iommu_build_inv_iommu_pages(&cmd, CMD_INV_IOMMU_ALL_PAGES_ADDRESS,
 				      domid, 1, 1);
 
-	for_each_iommu(iommu) {
-		spin_lock_irqsave(&iommu->lock, flags);
-		__iommu_queue_command(iommu, &cmd);
-		__iommu_completion_wait(iommu);
-		__iommu_wait_for_completion(iommu);
-		spin_unlock_irqrestore(&iommu->lock, flags);
-	}
+	spin_lock_irqsave(&iommu->lock, flags);
+	__iommu_queue_command(iommu, &cmd);
+	__iommu_completion_wait(iommu);
+	__iommu_wait_for_completion(iommu);
+	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
-void amd_iommu_flush_all_domains(void)
+static void flush_all_domains_on_iommu(struct amd_iommu *iommu)
 {
 	int i;
 
 	for (i = 1; i < MAX_DOMAIN_ID; ++i) {
 		if (!test_bit(i, amd_iommu_pd_alloc_bitmap))
 			continue;
-		iommu_flush_domain(i);
+		flush_domain_on_iommu(iommu, i);
 	}
+
+}
+
+/*
+ * This function is used to flush the IO/TLB for a given protection domain
+ * on every IOMMU in the system
+ */
+static void iommu_flush_domain(u16 domid)
+{
+	struct amd_iommu *iommu;
+
+	INC_STATS_COUNTER(domain_flush_all);
+
+	for_each_iommu(iommu)
+		flush_domain_on_iommu(iommu, domid);
+}
+
+void amd_iommu_flush_all_domains(void)
+{
+	struct amd_iommu *iommu;
+
+	for_each_iommu(iommu)
+		flush_all_domains_on_iommu(iommu);
 }
 
 void amd_iommu_flush_all_devices(void)
-- 
1.6.3.3


