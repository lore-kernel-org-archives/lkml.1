Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbZJBVSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbZJBVSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 17:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZJBVSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 17:18:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:37891 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbZJBVSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 17:18:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,496,1249282800"; 
   d="scan'208";a="556169242"
Date: Fri, 2 Oct 2009 14:18:27 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: David Woodhouse <dwmw2@infradead.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Francois Isabelle <Francois.Isabelle@ca.kontron.com>
Cc: Weidong Han <weidong.han@intel.com>, iommu@lists.linux-foundation.org,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] intel-iommu: PCIe hot plug for Intel iommu - IOMMU API
Message-ID: <20091002211826.GA11326@linux-os.sc.intel.com>
References: <A6AD88C3F2289247BE726C37303E1EB8BC06E356@orsmsx505.amr.corp.intel.com> <715D42877B251141A38726ABF5CABF2C05505A7433@pdsmsx503.ccr.corp.intel.com> <C2866F9FC4CB034EB51A633DF168598605E2D2EE@ssbarcelone>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C2866F9FC4CB034EB51A633DF168598605E2D2EE@ssbarcelone>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We expand existing IOMMU API iommu_detach_device for PCIe hot remove. We don't
need IOMMU API for hot add.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---

 drivers/pci/intel-iommu.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 855dd7c..5c12283 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3559,9 +3559,20 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
 static void intel_iommu_detach_device(struct iommu_domain *domain,
 				      struct device *dev)
 {
-	struct dmar_domain *dmar_domain = domain->priv;
+	struct dmar_domain *dmar_domain;
 	struct pci_dev *pdev = to_pci_dev(dev);
 
+	/* If domain=NULL, we'll find a valid domain for the device.*/
+	if (!domain) {
+		dmar_domain = find_domain(pdev);
+		if (!dmar_domain) {
+			printk(KERN_ERR "Can not find IOMMU domain for %s\n",
+			       pci_name(pdev));
+			return;
+		}
+	} else
+		dmar_domain = domain->priv;
+
 	domain_remove_one_dev_info(dmar_domain, pdev);
 }
 
