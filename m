Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbZCWIAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbZCWIAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756679AbZCWH6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 03:58:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:1727 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286AbZCWH6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 03:58:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,407,1233561600"; 
   d="scan'208";a="396704206"
From: Yu Zhao <yu.zhao@intel.com>
To: dwmw2@infradead.org, jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v4 2/6] PCI: handle Virtual Function ATS enabling
Date: Mon, 23 Mar 2009 15:58:58 +0800
Message-Id: <1237795142-6606-3-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1237795142-6606-1-git-send-email-yu.zhao@intel.com>
References: <1237795142-6606-1-git-send-email-yu.zhao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SR-IOV spec requires the Smallest Translation Unit and the
Invalidate Queue Depth fields in the Virtual Function ATS capability
to be hardwired to 0. If a function is a Virtual Function, then and
set its Physical Function's STU before enabling the ATS.

Signed-off-by: Yu Zhao <yu.zhao@intel.com>
---
 drivers/pci/iov.c |   66 +++++++++++++++++++++++++++++++++++++++++-----------
 drivers/pci/pci.h |    4 ++-
 2 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 8a9817c..0bf23fc 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -491,10 +491,10 @@ found:
 
 	if (pdev)
 		iov->dev = pci_dev_get(pdev);
-	else {
+	else
 		iov->dev = dev;
-		mutex_init(&iov->lock);
-	}
+
+	mutex_init(&iov->lock);
 
 	dev->sriov = iov;
 	dev->is_physfn = 1;
@@ -514,11 +514,11 @@ static void sriov_release(struct pci_dev *dev)
 {
 	BUG_ON(dev->sriov->nr_virtfn);
 
-	if (dev == dev->sriov->dev)
-		mutex_destroy(&dev->sriov->lock);
-	else
+	if (dev != dev->sriov->dev)
 		pci_dev_put(dev->sriov->dev);
 
+	mutex_destroy(&dev->sriov->lock);
+
 	kfree(dev->sriov);
 	dev->sriov = NULL;
 }
@@ -722,19 +722,40 @@ int pci_enable_ats(struct pci_dev *dev, int pgshift)
 	int rc;
 	u16 ctrl;
 
-	BUG_ON(dev->ats);
+	BUG_ON(dev->ats && dev->ats->is_enabled);
 
 	if (pgshift < PCI_ATS_MIN_STU)
 		return -EINVAL;
 
-	rc = ats_alloc_one(dev, pgshift);
-	if (rc)
-		return rc;
+	if (dev->is_physfn || dev->is_virtfn) {
+		struct pci_dev *pdev = dev->is_physfn ? dev : dev->physfn;
+
+		mutex_lock(&pdev->sriov->lock);
+		if (pdev->ats)
+			rc = pdev->ats->stu == pgshift ? 0 : -EINVAL;
+		else
+			rc = ats_alloc_one(pdev, pgshift);
+
+		if (!rc)
+			pdev->ats->ref_cnt++;
+		mutex_unlock(&pdev->sriov->lock);
+		if (rc)
+			return rc;
+	}
+
+	if (!dev->is_physfn) {
+		rc = ats_alloc_one(dev, pgshift);
+		if (rc)
+			return rc;
+	}
 
 	ctrl = PCI_ATS_CTRL_ENABLE;
-	ctrl |= PCI_ATS_CTRL_STU(pgshift - PCI_ATS_MIN_STU);
+	if (!dev->is_virtfn)
+		ctrl |= PCI_ATS_CTRL_STU(pgshift - PCI_ATS_MIN_STU);
 	pci_write_config_word(dev, dev->ats->pos + PCI_ATS_CTRL, ctrl);
 
+	dev->ats->is_enabled = 1;
+
 	return 0;
 }
 
@@ -746,13 +767,26 @@ void pci_disable_ats(struct pci_dev *dev)
 {
 	u16 ctrl;
 
-	BUG_ON(!dev->ats);
+	BUG_ON(!dev->ats || !dev->ats->is_enabled);
 
 	pci_read_config_word(dev, dev->ats->pos + PCI_ATS_CTRL, &ctrl);
 	ctrl &= ~PCI_ATS_CTRL_ENABLE;
 	pci_write_config_word(dev, dev->ats->pos + PCI_ATS_CTRL, ctrl);
 
-	ats_free_one(dev);
+	dev->ats->is_enabled = 0;
+
+	if (dev->is_physfn || dev->is_virtfn) {
+		struct pci_dev *pdev = dev->is_physfn ? dev : dev->physfn;
+
+		mutex_lock(&pdev->sriov->lock);
+		pdev->ats->ref_cnt--;
+		if (!pdev->ats->ref_cnt)
+			ats_free_one(pdev);
+		mutex_unlock(&pdev->sriov->lock);
+	}
+
+	if (!dev->is_physfn)
+		ats_free_one(dev);
 }
 
 /**
@@ -764,13 +798,17 @@ void pci_disable_ats(struct pci_dev *dev)
  * The ATS spec uses 0 in the Invalidate Queue Depth field to
  * indicate that the function can accept 32 Invalidate Request.
  * But here we use the `real' values (i.e. 1~32) for the Queue
- * Depth.
+ * Depth; and 0 indicates the function shares the Queue with
+ * other functions (doesn't exclusively own a Queue).
  */
 int pci_ats_queue_depth(struct pci_dev *dev)
 {
 	int pos;
 	u16 cap;
 
+	if (dev->is_virtfn)
+		return 0;
+
 	if (dev->ats)
 		return dev->ats->qdep;
 
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 9f0db6a..8ecd185 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -223,6 +223,8 @@ struct pci_ats {
 	int pos;	/* capability position */
 	int stu;	/* Smallest Translation Unit */
 	int qdep;	/* Invalidate Queue Depth */
+	int ref_cnt;	/* Physical Function reference count */
+	int is_enabled:1;	/* Enable bit is set */
 };
 
 #ifdef CONFIG_PCI_IOV
@@ -244,7 +246,7 @@ extern int pci_ats_queue_depth(struct pci_dev *dev);
  */
 static inline int pci_ats_enabled(struct pci_dev *dev)
 {
-	return !!dev->ats;
+	return dev->ats && dev->ats->is_enabled;
 }
 #else
 static inline int pci_iov_init(struct pci_dev *dev)
-- 
1.5.6.4

