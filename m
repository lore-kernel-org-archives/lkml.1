Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbYLIO1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbYLIO1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbYLIOR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:17:27 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:54408 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbYLIOQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:44 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KBM4ZA-04-AEV-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 16/21] AMD IOMMU: add device detach function for IOMMU API
Date: Tue, 9 Dec 2008 15:16:13 +0100
Message-ID: <1228832178-13429-17-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228832178-13429-16-git-send-email-joerg.roedel@amd.com>
References: <20081209141143.GW12816@amd.com>
 <1228832178-13429-1-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-2-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-3-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-4-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-5-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-6-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-7-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-8-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-9-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-10-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-11-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-12-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-13-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-14-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-15-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-16-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Dec 2008 14:16:19.0224 (UTC) FILETIME=[B48E6980:01C95A08]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add a generic function to detach devices from protection domains

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index d5581bb..60e268a 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1573,3 +1573,30 @@ static void amd_iommu_domain_destroy(struct iommu_domain *dom)
 
 	dom->priv = NULL;
 }
+
+static void amd_iommu_detach_device(struct iommu_domain *dom,
+				    struct device *dev)
+{
+	struct protection_domain *domain = dom->priv;
+	struct amd_iommu *iommu;
+	struct pci_dev *pdev;
+	u16 devid;
+
+	if (dev->bus != &pci_bus_type)
+		return;
+
+	pdev = to_pci_dev(dev);
+
+	devid = calc_devid(pdev->bus->number, pdev->devfn);
+
+	if (devid > 0)
+		detach_device(domain, devid);
+
+	iommu = amd_iommu_rlookup_table[devid];
+	if (!iommu)
+		return;
+
+	iommu_queue_inv_dev_entry(iommu, devid);
+	iommu_completion_wait(iommu);
+}
+
-- 
1.5.6.4


