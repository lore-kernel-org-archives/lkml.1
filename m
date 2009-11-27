Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbZK0N6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbZK0N6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZK0N6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:58:39 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:53093
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753317AbZK0N4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:56:02 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KTRTDA-02-34Y-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 23/34] x86/amd-iommu: Remove iommu parameter from dma_ops_domain_alloc
Date: Fri, 27 Nov 2009 14:55:34 +0100
Message-ID: <1259330145-14865-24-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0576 (UTC) FILETIME=[52DA2E00:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function doesn't use the parameter anymore so it can be
removed.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index d10195b..17e83ec 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1188,7 +1188,7 @@ static void dma_ops_domain_free(struct dma_ops_domain *dom)
  * It also intializes the page table and the address allocator data
  * structures required for the dma_ops interface
  */
-static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu)
+static struct dma_ops_domain *dma_ops_domain_alloc(void)
 {
 	struct dma_ops_domain *dma_dom;
 
@@ -1443,7 +1443,7 @@ static int device_change_notifier(struct notifier_block *nb,
 		dma_domain = find_protection_domain(devid);
 		if (dma_domain)
 			goto out;
-		dma_domain = dma_ops_domain_alloc(iommu);
+		dma_domain = dma_ops_domain_alloc();
 		if (!dma_domain)
 			goto out;
 		dma_domain->target_dev = devid;
@@ -2085,7 +2085,6 @@ static void prealloc_protection_domains(void)
 {
 	struct pci_dev *dev = NULL;
 	struct dma_ops_domain *dma_dom;
-	struct amd_iommu *iommu;
 	u16 devid;
 
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
@@ -2100,10 +2099,7 @@ static void prealloc_protection_domains(void)
 
 		devid = get_device_id(&dev->dev);
 
-		iommu = amd_iommu_rlookup_table[devid];
-		if (!iommu)
-			continue;
-		dma_dom = dma_ops_domain_alloc(iommu);
+		dma_dom = dma_ops_domain_alloc();
 		if (!dma_dom)
 			continue;
 		init_unity_mappings_for_device(dma_dom, devid);
@@ -2139,7 +2135,7 @@ int __init amd_iommu_init_dma_ops(void)
 	 * protection domain will be assigned to the default one.
 	 */
 	for_each_iommu(iommu) {
-		iommu->default_dom = dma_ops_domain_alloc(iommu);
+		iommu->default_dom = dma_ops_domain_alloc();
 		if (iommu->default_dom == NULL)
 			return -ENOMEM;
 		iommu->default_dom->domain.flags |= PD_DEFAULT_MASK;
-- 
1.6.5.3


