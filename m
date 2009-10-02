Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbZJBVWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbZJBVWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 17:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbZJBVWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 17:22:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:39189 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbZJBVWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 17:22:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,496,1249282800"; 
   d="scan'208";a="194564103"
Date: Fri, 2 Oct 2009 14:18:44 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: David Woodhouse <dwmw2@infradead.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Francois Isabelle <Francois.Isabelle@ca.kontron.com>
Cc: Weidong Han <weidong.han@intel.com>, iommu@lists.linux-foundation.org,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] pciehp_driver.c: PCIe hot plug for Intel iommu - call IOMMU API in hot remove
Message-ID: <20091002211844.GA14352@linux-os.sc.intel.com>
References: <72D8A09E39A89147BE9CFBB6F0C73C306073445396@rrsmsx501.amr.corp.intel.com> <6E2431EDEB6AE64F827F8A1B0D0DA1A603C322CF@azsmsx501.amr.corp.intel.com> <72D8A09E39A89147BE9CFBB6F0C73C30607344552A@rrsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72D8A09E39A89147BE9CFBB6F0C73C30607344552A@rrsmsx501.amr.corp.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOMMU API iommu_detach_devcie() is called to hot remove a PCIe device.

A hot added device will be added into an IOMMU domain when it first does IOMMU
op. So there is no need to add more code for hot add. 

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---

 drivers/pci/pci-driver.c |    8 ++++++++
 1 files changed, 8 insertions(+)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index e5d47be..b8f0592 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/cpu.h>
+#include <linux/iommu.h>
 #include "pci.h"
 
 struct pci_dynid {
@@ -390,6 +391,13 @@ static int pci_device_remove(struct device * dev)
 	 */
 
 	pci_dev_put(pci_dev);
+
+	/*
+	 * Remove this pci device from its iommu domain.
+	 */
+	if (iommu_found())
+		iommu_detach_device(NULL, dev);
+
 	return 0;
 }
 
