Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbZK0OA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbZK0OA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 09:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbZK0OAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 09:00:54 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:18096 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbZK0Nzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:55 -0500
X-SpamScore: -4
X-BigFish: VPS-4(z78cMzzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KTRTD7-01-6RW-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 28/34] x86/amd-iommu: Add device bind reference counting
Date: Fri, 27 Nov 2009 14:55:39 +0100
Message-ID: <1259330145-14865-29-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0623 (UTC) FILETIME=[52E159F0:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a reference count to each device to count
how often the device was bound to that domain. This is
important for single devices that act as an alias for a
number of others. These devices must stay bound to their
domains until all devices that alias to it are unbound from
the same domain.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    1 +
 arch/x86/kernel/amd_iommu.c            |   37 +++++++++++++++++++++++++-------
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 9eaa27b..434e90e 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -253,6 +253,7 @@ struct protection_domain {
 struct iommu_dev_data {
 	struct device *alias;		  /* The Alias Device */
 	struct protection_domain *domain; /* Domain the device is bound to */
+	atomic_t bind;			  /* Domain attach reverent count */
 };
 
 /*
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 3214e88..f5db7d5 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -152,6 +152,8 @@ static int iommu_init_device(struct device *dev)
 	if (pdev)
 		dev_data->alias = &pdev->dev;
 
+	atomic_set(&dev_data->bind, 0);
+
 	dev->archdata.iommu = dev_data;
 
 
@@ -1403,10 +1405,13 @@ static int __attach_device(struct device *dev,
 		return -EBUSY;
 
 	/* Do real assignment */
-	if (alias != devid &&
-	    alias_data->domain == NULL) {
-		alias_data->domain = domain;
-		set_dte_entry(alias, domain);
+	if (alias != devid) {
+		if (alias_data->domain == NULL) {
+			alias_data->domain = domain;
+			set_dte_entry(alias, domain);
+		}
+
+		atomic_inc(&alias_data->bind);
 	}
 
 	if (dev_data->domain == NULL) {
@@ -1414,6 +1419,8 @@ static int __attach_device(struct device *dev,
 		set_dte_entry(devid, domain);
 	}
 
+	atomic_inc(&dev_data->bind);
+
 	/* ready */
 	spin_unlock(&domain->lock);
 
@@ -1449,20 +1456,34 @@ static int attach_device(struct device *dev,
  */
 static void __detach_device(struct device *dev)
 {
-	u16 devid = get_device_id(dev);
+	u16 devid = get_device_id(dev), alias;
 	struct amd_iommu *iommu = amd_iommu_rlookup_table[devid];
 	struct iommu_dev_data *dev_data = get_dev_data(dev);
+	struct iommu_dev_data *alias_data;
 
 	BUG_ON(!iommu);
 
-	clear_dte_entry(devid);
-	dev_data->domain = NULL;
+	devid = get_device_id(dev);
+	alias = get_device_id(dev_data->alias);
+
+	if (devid != alias) {
+		alias_data = get_dev_data(dev_data->alias);
+		if (atomic_dec_and_test(&alias_data->bind)) {
+			clear_dte_entry(alias);
+			alias_data->domain = NULL;
+		}
+	}
+
+	if (atomic_dec_and_test(&dev_data->bind)) {
+		clear_dte_entry(devid);
+		dev_data->domain = NULL;
+	}
 
 	/*
 	 * If we run in passthrough mode the device must be assigned to the
 	 * passthrough domain if it is detached from any other domain
 	 */
-	if (iommu_pass_through)
+	if (iommu_pass_through && dev_data->domain == NULL)
 		__attach_device(dev, pt_domain);
 }
 
-- 
1.6.5.3


