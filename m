Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbZK0N5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbZK0N5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbZK0N5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:57:38 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:38900
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753447AbZK0N4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:56:06 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KTRTDA-02-34X-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 30/34] x86/amd-iommu: Cleanup attach/detach_device code
Date: Fri, 27 Nov 2009 14:55:41 +0100
Message-ID: <1259330145-14865-31-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0685 (UTC) FILETIME=[52EACFD0:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up the attach_device and detach_device
paths and fixes reference counting while at it.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |  102 ++++++++++++++++++++++++------------------
 1 files changed, 58 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 530d608..e3363fd 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1329,7 +1329,6 @@ static bool dma_ops_domain(struct protection_domain *domain)
 
 static void set_dte_entry(u16 devid, struct protection_domain *domain)
 {
-	struct amd_iommu *iommu = amd_iommu_rlookup_table[devid];
 	u64 pte_root = virt_to_phys(domain->pt_root);
 
 	BUG_ON(amd_iommu_pd_table[devid] != NULL);
@@ -1344,18 +1343,11 @@ static void set_dte_entry(u16 devid, struct protection_domain *domain)
 
 	amd_iommu_pd_table[devid] = domain;
 
-	/* Do reference counting */
-	domain->dev_iommu[iommu->index] += 1;
-	domain->dev_cnt                 += 1;
-
-	/* Flush the changes DTE entry */
-	iommu_queue_inv_dev_entry(iommu, devid);
 }
 
 static void clear_dte_entry(u16 devid)
 {
 	struct protection_domain *domain = amd_iommu_pd_table[devid];
-	struct amd_iommu *iommu = amd_iommu_rlookup_table[devid];
 
 	BUG_ON(domain == NULL);
 
@@ -1368,11 +1360,51 @@ static void clear_dte_entry(u16 devid)
 	amd_iommu_dev_table[devid].data[2] = 0;
 
 	amd_iommu_apply_erratum_63(devid);
+}
+
+static void do_attach(struct device *dev, struct protection_domain *domain)
+{
+	struct iommu_dev_data *dev_data;
+	struct amd_iommu *iommu;
+	u16 devid;
+
+	devid    = get_device_id(dev);
+	iommu    = amd_iommu_rlookup_table[devid];
+	dev_data = get_dev_data(dev);
+
+	/* Update data structures */
+	dev_data->domain = domain;
+	list_add(&dev_data->list, &domain->dev_list);
+	set_dte_entry(devid, domain);
+
+	/* Do reference counting */
+	domain->dev_iommu[iommu->index] += 1;
+	domain->dev_cnt                 += 1;
+
+	/* Flush the DTE entry */
+	iommu_queue_inv_dev_entry(iommu, devid);
+}
+
+static void do_detach(struct device *dev)
+{
+	struct iommu_dev_data *dev_data;
+	struct amd_iommu *iommu;
+	u16 devid;
+
+	devid    = get_device_id(dev);
+	iommu    = amd_iommu_rlookup_table[devid];
+	dev_data = get_dev_data(dev);
 
 	/* decrease reference counters */
-	domain->dev_iommu[iommu->index] -= 1;
-	domain->dev_cnt                 -= 1;
+	dev_data->domain->dev_iommu[iommu->index] -= 1;
+	dev_data->domain->dev_cnt                 -= 1;
+
+	/* Update data structures */
+	dev_data->domain = NULL;
+	list_del(&dev_data->list);
+	clear_dte_entry(devid);
 
+	/* Flush the DTE entry */
 	iommu_queue_inv_dev_entry(iommu, devid);
 }
 
@@ -1384,12 +1416,10 @@ static int __attach_device(struct device *dev,
 			   struct protection_domain *domain)
 {
 	struct iommu_dev_data *dev_data, *alias_data;
-	u16 devid, alias;
 
-	devid      = get_device_id(dev);
-	alias      = amd_iommu_alias_table[devid];
 	dev_data   = get_dev_data(dev);
 	alias_data = get_dev_data(dev_data->alias);
+
 	if (!alias_data)
 		return -EINVAL;
 
@@ -1406,21 +1436,16 @@ static int __attach_device(struct device *dev,
 		return -EBUSY;
 
 	/* Do real assignment */
-	if (alias != devid) {
-		if (alias_data->domain == NULL) {
-			alias_data->domain = domain;
-			list_add(&alias_data->list, &domain->dev_list);
-			set_dte_entry(alias, domain);
-		}
+	if (dev_data->alias != dev) {
+		alias_data = get_dev_data(dev_data->alias);
+		if (alias_data->domain == NULL)
+			do_attach(dev_data->alias, domain);
 
 		atomic_inc(&alias_data->bind);
 	}
 
-	if (dev_data->domain == NULL) {
-		dev_data->domain = domain;
-		list_add(&dev_data->list, &domain->dev_list);
-		set_dte_entry(devid, domain);
-	}
+	if (dev_data->domain == NULL)
+		do_attach(dev, domain);
 
 	atomic_inc(&dev_data->bind);
 
@@ -1459,35 +1484,24 @@ static int attach_device(struct device *dev,
  */
 static void __detach_device(struct device *dev)
 {
-	u16 devid = get_device_id(dev), alias;
-	struct amd_iommu *iommu = amd_iommu_rlookup_table[devid];
 	struct iommu_dev_data *dev_data = get_dev_data(dev);
 	struct iommu_dev_data *alias_data;
 	unsigned long flags;
 
-	BUG_ON(!iommu);
+	BUG_ON(!dev_data->domain);
 
-	devid = get_device_id(dev);
-	alias = get_device_id(dev_data->alias);
+	spin_lock_irqsave(&dev_data->domain->lock, flags);
 
-	if (devid != alias) {
+	if (dev_data->alias != dev) {
 		alias_data = get_dev_data(dev_data->alias);
-		if (atomic_dec_and_test(&alias_data->bind)) {
-			spin_lock_irqsave(&alias_data->domain->lock, flags);
-			clear_dte_entry(alias);
-			list_del(&alias_data->list);
-			spin_unlock_irqrestore(&alias_data->domain->lock, flags);
-			alias_data->domain = NULL;
-		}
+		if (atomic_dec_and_test(&alias_data->bind))
+			do_detach(dev_data->alias);
 	}
 
-	if (atomic_dec_and_test(&dev_data->bind)) {
-		spin_lock_irqsave(&dev_data->domain->lock, flags);
-		clear_dte_entry(devid);
-		list_del(&dev_data->list);
-		spin_unlock_irqrestore(&dev_data->domain->lock, flags);
-		dev_data->domain = NULL;
-	}
+	if (atomic_dec_and_test(&dev_data->bind))
+		do_detach(dev);
+
+	spin_unlock_irqrestore(&dev_data->domain->lock, flags);
 
 	/*
 	 * If we run in passthrough mode the device must be assigned to the
-- 
1.6.5.3


