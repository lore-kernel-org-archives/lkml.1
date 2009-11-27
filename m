Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbZK0N7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbZK0N7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbZK0N7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:59:37 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:53443
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753070AbZK0Nz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:59 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KTRTD3-01-6RN-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/34] x86/amd-iommu: Reimplement flush_all_domains_on_iommu()
Date: Fri, 27 Nov 2009 14:55:22 +0100
Message-ID: <1259330145-14865-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0107 (UTC) FILETIME=[52929DB0:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reimplements the function
flush_all_domains_on_iommu to use the global protection
domain list.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   43 ++++++++++++++++++++++++-------------------
 1 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 5141f56..a1bd99d 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -499,43 +499,48 @@ static void iommu_flush_tlb_pde(struct protection_domain *domain)
 }
 
 /*
- * This function flushes one domain on one IOMMU
+ * This function flushes all domains that have devices on the given IOMMU
  */
-static void flush_domain_on_iommu(struct amd_iommu *iommu, u16 domid)
+static void flush_all_domains_on_iommu(struct amd_iommu *iommu)
 {
-	struct iommu_cmd cmd;
+	u64 address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
+	struct protection_domain *domain;
 	unsigned long flags;
 
-	__iommu_build_inv_iommu_pages(&cmd, CMD_INV_IOMMU_ALL_PAGES_ADDRESS,
-				      domid, 1, 1);
-
-	spin_lock_irqsave(&iommu->lock, flags);
-	__iommu_queue_command(iommu, &cmd);
-	__iommu_completion_wait(iommu);
-	__iommu_wait_for_completion(iommu);
-	spin_unlock_irqrestore(&iommu->lock, flags);
-}
-
-static void flush_all_domains_on_iommu(struct amd_iommu *iommu)
-{
-	int i;
+	spin_lock_irqsave(&amd_iommu_pd_lock, flags);
 
-	for (i = 1; i < MAX_DOMAIN_ID; ++i) {
-		if (!test_bit(i, amd_iommu_pd_alloc_bitmap))
+	list_for_each_entry(domain, &amd_iommu_pd_list, list) {
+		if (domain->dev_iommu[iommu->index] == 0)
 			continue;
-		flush_domain_on_iommu(iommu, i);
+
+		spin_lock(&domain->lock);
+		iommu_queue_inv_iommu_pages(iommu, address, domain->id, 1, 1);
+		iommu_flush_complete(domain);
+		spin_unlock(&domain->lock);
 	}
 
+	spin_unlock_irqrestore(&amd_iommu_pd_lock, flags);
 }
 
+/*
+ * This function uses heavy locking and may disable irqs for some time. But
+ * this is no issue because it is only called during resume.
+ */
 void amd_iommu_flush_all_domains(void)
 {
 	struct protection_domain *domain;
+	unsigned long flags;
+
+	spin_lock_irqsave(&amd_iommu_pd_lock, flags);
 
 	list_for_each_entry(domain, &amd_iommu_pd_list, list) {
+		spin_lock(&domain->lock);
 		iommu_flush_tlb_pde(domain);
 		iommu_flush_complete(domain);
+		spin_unlock(&domain->lock);
 	}
+
+	spin_unlock_irqrestore(&amd_iommu_pd_lock, flags);
 }
 
 static void flush_all_devices_for_iommu(struct amd_iommu *iommu)
-- 
1.6.5.3


