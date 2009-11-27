Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbZK0N4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbZK0N4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbZK0N4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:56:32 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:42664 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbZK0N42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:56:28 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KTRTD9-01-6S1-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 31/34] x86/amd-iommu: Introduce iommu_flush_device() function
Date: Fri, 27 Nov 2009 14:55:42 +0100
Message-ID: <1259330145-14865-32-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0732 (UTC) FILETIME=[52F1FBC0:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a function to flush a DTE entry for a given
struct device and replaces iommu_queue_inv_dev_entry calls
with this function where appropriate.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index e3363fd..41c4ebe 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -494,6 +494,17 @@ static int iommu_queue_inv_dev_entry(struct amd_iommu *iommu, u16 devid)
 	return ret;
 }
 
+static int iommu_flush_device(struct device *dev)
+{
+	struct amd_iommu *iommu;
+	u16 devid;
+
+	devid = get_device_id(dev);
+	iommu = amd_iommu_rlookup_table[devid];
+
+	return iommu_queue_inv_dev_entry(iommu, devid);
+}
+
 static void __iommu_build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
 					  u16 domid, int pde, int s)
 {
@@ -1382,7 +1393,7 @@ static void do_attach(struct device *dev, struct protection_domain *domain)
 	domain->dev_cnt                 += 1;
 
 	/* Flush the DTE entry */
-	iommu_queue_inv_dev_entry(iommu, devid);
+	iommu_flush_device(dev);
 }
 
 static void do_detach(struct device *dev)
@@ -1405,7 +1416,7 @@ static void do_detach(struct device *dev)
 	clear_dte_entry(devid);
 
 	/* Flush the DTE entry */
-	iommu_queue_inv_dev_entry(iommu, devid);
+	iommu_flush_device(dev);
 }
 
 /*
@@ -1610,7 +1621,7 @@ static int device_change_notifier(struct notifier_block *nb,
 		goto out;
 	}
 
-	iommu_queue_inv_dev_entry(iommu, devid);
+	iommu_flush_device(dev);
 	iommu_completion_wait(iommu);
 
 out:
@@ -2393,7 +2404,7 @@ static void amd_iommu_detach_device(struct iommu_domain *dom,
 	if (!iommu)
 		return;
 
-	iommu_queue_inv_dev_entry(iommu, devid);
+	iommu_flush_device(dev);
 	iommu_completion_wait(iommu);
 }
 
-- 
1.6.5.3


