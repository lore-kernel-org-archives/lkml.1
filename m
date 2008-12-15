Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbYLOOSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbYLOOSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbYLOOST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:18:19 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:53630 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbYLOOSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:18:18 -0500
X-BigFish: VPS3(zzzzzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KBX926-03-GLN-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/22] AMD IOMMU: allocate a new protection for hotplugged devices
Date: Mon, 15 Dec 2008 15:17:45 +0100
Message-ID: <1229350685-3816-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
References: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 15 Dec 2008 14:18:05.0869 (UTC) FILETIME=[F299A5D0:01C95EBF]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: also hotplug devices benefit from device isolation

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 1694415..cebbf58 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -922,6 +922,8 @@ static int device_change_notifier(struct notifier_block *nb,
 	struct protection_domain *domain;
 	struct dma_ops_domain *dma_domain;
 	struct amd_iommu *iommu;
+	int order = amd_iommu_aperture_order;
+	unsigned long flags;
 
 	if (devid > amd_iommu_last_bdf)
 		goto out;
@@ -954,6 +956,21 @@ static int device_change_notifier(struct notifier_block *nb,
 			goto out;
 		detach_device(domain, devid);
 		break;
+	case BUS_NOTIFY_ADD_DEVICE:
+		/* allocate a protection domain if a device is added */
+		dma_domain = find_protection_domain(devid);
+		if (dma_domain)
+			goto out;
+		dma_domain = dma_ops_domain_alloc(iommu, order);
+		if (!dma_domain)
+			goto out;
+		dma_domain->target_dev = devid;
+
+		spin_lock_irqsave(&iommu_pd_list_lock, flags);
+		list_add_tail(&dma_domain->list, &iommu_pd_list);
+		spin_unlock_irqrestore(&iommu_pd_list_lock, flags);
+
+		break;
 	default:
 		goto out;
 	}
-- 
1.5.6.4


