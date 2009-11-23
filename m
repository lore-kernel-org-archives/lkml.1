Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZKWNuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZKWNuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 08:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbZKWNuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 08:50:21 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:55243 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbZKWNuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 08:50:20 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KTKEF3-01-0S1-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>,
       stable@kernel.org
Subject: [PATCH 2/2] x86/amd-iommu: attach devices to pre-allocated domains early
Date: Mon, 23 Nov 2009 14:49:46 +0100
Message-ID: <1258984186-4328-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1258984186-4328-1-git-send-email-joerg.roedel@amd.com>
References: <1258984186-4328-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 23 Nov 2009 13:49:50.0129 (UTC) FILETIME=[D38C8210:01CA6C43]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some devices the ACPI table may define unity map
requirements which must me met when the IOMMU is enabled. So
we need to attach devices to their domains as early as
possible so that these mappings are in place when needed.
This patch assigns the domains right after they are
allocated. Otherwise this can result in I/O page faults
before a driver binds to a device and BIOS is still using
it.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 093bd52..b74b212 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2047,10 +2047,10 @@ static void prealloc_protection_domains(void)
 	struct pci_dev *dev = NULL;
 	struct dma_ops_domain *dma_dom;
 	struct amd_iommu *iommu;
-	u16 devid;
+	u16 devid, __devid;
 
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
-		devid = calc_devid(dev->bus->number, dev->devfn);
+		__devid = devid = calc_devid(dev->bus->number, dev->devfn);
 		if (devid > amd_iommu_last_bdf)
 			continue;
 		devid = amd_iommu_alias_table[devid];
@@ -2065,6 +2065,10 @@ static void prealloc_protection_domains(void)
 		init_unity_mappings_for_device(dma_dom, devid);
 		dma_dom->target_dev = devid;
 
+		attach_device(iommu, &dma_dom->domain, devid);
+		if (__devid != devid)
+			attach_device(iommu, &dma_dom->domain, __devid);
+
 		list_add_tail(&dma_dom->list, &iommu_pd_list);
 	}
 }
-- 
1.6.5.3


