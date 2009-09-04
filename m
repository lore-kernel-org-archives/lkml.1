Return-Path: <linux-kernel-owner+w=401wt.eu-S933475AbZIDJmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475AbZIDJmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933465AbZIDJmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:42:05 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:26847 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933306AbZIDJmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:42:02 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KPFXLV-04-HX8-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/14] x86/amd-iommu: Introduce set_dte_entry function
Date: Fri, 4 Sep 2009 11:40:43 +0200
Message-ID: <1252057252-32074-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
References: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:40:55.0502 (UTC) FILETIME=[CCC546E0:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function factors out some logic of attach_device to a
seperate function. This new function will be used to update
device table entries when necessary.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   27 +++++++++++++++++----------
 1 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 5265dd1..0fab1f1 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1058,18 +1058,10 @@ static struct protection_domain *domain_for_device(u16 devid)
 	return dom;
 }
 
-/*
- * If a device is not yet associated with a domain, this function does
- * assigns it visible for the hardware
- */
-static void attach_device(struct amd_iommu *iommu,
-			  struct protection_domain *domain,
-			  u16 devid)
+static void set_dte_entry(u16 devid, struct protection_domain *domain)
 {
-	unsigned long flags;
 	u64 pte_root = virt_to_phys(domain->pt_root);
-
-	domain->dev_cnt += 1;
+	unsigned long flags;
 
 	pte_root |= (domain->mode & DEV_ENTRY_MODE_MASK)
 		    << DEV_ENTRY_MODE_SHIFT;
@@ -1082,6 +1074,21 @@ static void attach_device(struct amd_iommu *iommu,
 
 	amd_iommu_pd_table[devid] = domain;
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
+}
+
+/*
+ * If a device is not yet associated with a domain, this function does
+ * assigns it visible for the hardware
+ */
+static void attach_device(struct amd_iommu *iommu,
+			  struct protection_domain *domain,
+			  u16 devid)
+{
+	/* set the DTE entry */
+	set_dte_entry(devid, domain);
+
+	/* increase reference counter */
+	domain->dev_cnt += 1;
 
        /*
         * We might boot into a crash-kernel here. The crashed kernel
-- 
1.6.3.3


