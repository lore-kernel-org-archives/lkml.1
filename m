Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbYLDRjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbYLDRjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757393AbYLDRch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:32:37 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:14755 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038AbYLDRcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:32:14 -0500
X-BigFish: VPS-2(z78cMzzzzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KBD4PA-03-CXD-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/19] AMD IOMMU: add device reference counting for protection domains
Date: Thu, 4 Dec 2008 18:31:48 +0100
Message-ID: <1228411916-22668-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:31:57.0245 (UTC) FILETIME=[34E586D0:01C95636]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: know how many devices are assigned to a domain

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    1 +
 arch/x86/kernel/amd_iommu.c            |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index b74d35f..90f77de 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -203,6 +203,7 @@ struct protection_domain {
 	int mode;		/* paging mode (0-6 levels) */
 	u64 *pt_root;		/* page table root pointer */
 	unsigned long flags;	/* flags to find out type of domain */
+	unsigned dev_cnt;	/* devices assigned to this domain */
 	void *priv;		/* private data */
 };
 
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index be626ad..afd2128 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -819,9 +819,10 @@ static void set_device_domain(struct amd_iommu *iommu,
 			      u16 devid)
 {
 	unsigned long flags;
-
 	u64 pte_root = virt_to_phys(domain->pt_root);
 
+	domain->dev_cnt += 1;
+
 	pte_root |= (domain->mode & DEV_ENTRY_MODE_MASK)
 		    << DEV_ENTRY_MODE_SHIFT;
 	pte_root |= IOMMU_PTE_IR | IOMMU_PTE_IW | IOMMU_PTE_P | IOMMU_PTE_TV;
-- 
1.5.6.4


