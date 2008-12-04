Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbYLDRm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbYLDRm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbYLDRc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:32:56 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:16150 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758721AbYLDRcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:32:36 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KBD4PA-04-YDS-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 15/19] AMD IOMMU: add device attach function for IOMMU API
Date: Thu, 4 Dec 2008 18:31:52 +0100
Message-ID: <1228411916-22668-16-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:31:57.0386 (UTC) FILETIME=[34FB0AA0:01C95636]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add a generic function to attach devices to protection domains

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 0ded6f4..d3fee3e 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1580,3 +1580,38 @@ static void amd_iommu_detach_device(struct iommu_domain *dom,
 	iommu_completion_wait(iommu);
 }
 
+static int amd_iommu_attach_device(struct iommu_domain *dom,
+				   struct device *dev)
+{
+	struct protection_domain *domain = dom->priv;
+	struct protection_domain *old_domain;
+	struct amd_iommu *iommu;
+	struct pci_dev *pdev;
+	u16 devid;
+
+	if (dev->bus != &pci_bus_type)
+		return -EINVAL;
+
+	pdev = to_pci_dev(dev);
+
+	devid = calc_devid(pdev->bus->number, pdev->devfn);
+
+	if (devid >= amd_iommu_last_bdf ||
+			devid != amd_iommu_alias_table[devid])
+		return -EINVAL;
+
+	iommu = amd_iommu_rlookup_table[devid];
+	if (!iommu)
+		return -EINVAL;
+
+	old_domain = domain_for_device(devid);
+	if (old_domain)
+		__detach_device(old_domain, devid);
+
+	set_device_domain(iommu, domain, devid);
+
+	iommu_completion_wait(iommu);
+
+	return 0;
+}
+
-- 
1.5.6.4


