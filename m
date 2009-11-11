Return-Path: <linux-kernel-owner+w=401wt.eu-S1757674AbZKKPXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674AbZKKPXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 10:23:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbZKKPXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 10:23:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:13503 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757000AbZKKPXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 10:23:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,723,1249282800"; 
   d="scan'208";a="512800521"
Date: Wed, 11 Nov 2009 07:23:06 -0800
From: Fenghua Yu <fenghua.yu@intel.com>
To: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, David Woodhouse <dwmw2@infradead.org>,
       jbarnes@virtuousgeek.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       stable@kernel.org
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [stable][PATCH] PCIe hot-plug for Intel IOMMU
Message-ID: <20091111152306.GA29256@linux-os.sc.intel.com>
References: <20091104225359.2720.91502.stgit@nehalem.aw> <20091106114130J.fujita.tomonori@lab.ntt.co.jp> <1257807747.25961.852.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257807747.25961.852.camel@macbook.infradead.org>
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

Without the patch, after a hot-remove, a hot-added device on the same slot will
not work.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---

The patch missed 2.6.32 release. Could it be in 2.6.32 stable?

 drivers/pci/intel-iommu.c |   29 +++++++++++++++++++++++++++++
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
 
