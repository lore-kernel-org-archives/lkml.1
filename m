Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYLIOZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYLIOZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbYLIORS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:17:18 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:40775 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbYLIOQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:36 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KBM4ZA-03-KKX-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 17/21] AMD IOMMU: add device attach function for IOMMU API
Date: Tue, 9 Dec 2008 15:16:14 +0100
Message-ID: <1228832178-13429-18-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228832178-13429-17-git-send-email-joerg.roedel@amd.com>
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
 <1228832178-13429-17-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Dec 2008 14:16:19.0271 (UTC) FILETIME=[B4959570:01C95A08]
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
index 60e268a..97eb60d 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1600,3 +1600,38 @@ static void amd_iommu_detach_device(struct iommu_domain *dom,
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


