Return-Path: <linux-kernel-owner+w=401wt.eu-S933079AbZJFSYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079AbZJFSYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933014AbZJFSYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:24:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:11217 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932655AbZJFSYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:24:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,514,1249282800"; 
   d="scan'208";a="195741618"
Date: Tue, 6 Oct 2009 11:23:46 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: David Woodhouse <dwmw2@infradead.org>, Joerg Roedel <joro@8bytes.org>,
       Francois Isabelle <Francois.Isabelle@ca.kontron.com>
Cc: iommu <iommu@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] PCIe hot plug for Intel iommu
Message-ID: <20091006182346.GA22770@linux-os.sc.intel.com>
References: <72D8A09E39A89147BE9CFBB6F0C73C306073445396@rrsmsx501.amr.corp.intel.com> <6E2431EDEB6AE64F827F8A1B0D0DA1A603C322CF@azsmsx501.amr.corp.intel.com> <72D8A09E39A89147BE9CFBB6F0C73C30607344552A@rrsmsx501.amr.corp.intel.com> <20091002211844.GA14352@linux-os.sc.intel.com> <20091002215019.GB23379@8bytes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002215019.GB23379@8bytes.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support PCIe hot plug in IOMMU, we register a notifier to respond to device
change action.

When the notifier gets BUS_NOTIFY_UNBOUND_DRIVER, it removes the device from its
DMAR domain.

A hot added device will be added into an IOMMU domain when it first does IOMMU
op. So there is no need to add more code for hot add. 

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---

 intel-iommu.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 855dd7c..d8b8cfc 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3193,6 +3193,33 @@ static int __init init_iommu_sysfs(void)
 }
 #endif	/* CONFIG_PM */
 
+/*
+ * Here we only respond to action of unbound device from driver.
+ *
+ * Added device is not attached to its DMAR domain here yet. That will happen
+ * when mapping the device to iova.
+ */
+static int device_notifier(struct notifier_block *nb,
+				  unsigned long action, void *data)
+{
+	struct device *dev = data;
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct dmar_domain *domain;
+
+	domain = find_domain(pdev);
+	if (!domain)
+		return 0;
+
+	if (action == BUS_NOTIFY_UNBOUND_DRIVER && !iommu_pass_through)
+		domain_remove_one_dev_info(domain, pdev);
+
+	return 0;
+}
+
+static struct notifier_block device_nb = {
+	.notifier_call = device_notifier,
+};
+
 int __init intel_iommu_init(void)
 {
 	int ret = 0;
@@ -3245,6 +3272,8 @@ int __init intel_iommu_init(void)
 
 	register_iommu(&intel_iommu_ops);
 
+	bus_register_notifier(&pci_bus_type, &device_nb);
+
 	return 0;
 }
 
