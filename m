Return-Path: <linux-kernel-owner+w=401wt.eu-S1756409AbYKUTgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbYKUTgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 14:36:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756355AbYKUTfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 14:35:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:30110 "EHLO mga02.intel.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755558AbYKUTfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 14:35:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,645,1220252400"; 
   d="scan'208";a="465873971"
Date: Sat, 22 Nov 2008 02:38:52 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "achiang@hp.com" <achiang@hp.com>,
       "bjorn.helgaas@hp.com" <bjorn.helgaas@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "horms@verge.net.au" <horms@verge.net.au>,
       "yinghai@kernel.org" <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: [PATCH 2/13 v7] PCI: remove unnecessary arg of
	pci_update_resource()
Message-ID: <20081121183852.GC7810@yzhao12-linux.sh.intel.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleanup removes unnecessary argument 'struct resource *res' in
pci_update_resource(), so it takes same arguments as other companion
functions (pci_assign_resource(), etc.).

Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 drivers/pci/pci.c       |    4 ++--
 drivers/pci/setup-res.c |    7 ++++---
 include/linux/pci.h     |    2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 21f2ac6..c408be8 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -377,8 +377,8 @@ pci_restore_bars(struct pci_dev *dev)
 		return;
 	}
 
-	for (i = 0; i < numres; i ++)
-		pci_update_resource(dev, &dev->resource[i], i);
+	for (i = 0; i < numres; i++)
+		pci_update_resource(dev, i);
 }
 
 static struct pci_platform_pm_ops *pci_platform_pm;
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 2dbd96c..b7ca679 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -26,11 +26,12 @@
 #include "pci.h"
 
 
-void pci_update_resource(struct pci_dev *dev, struct resource *res, int resno)
+void pci_update_resource(struct pci_dev *dev, int resno)
 {
 	struct pci_bus_region region;
 	u32 new, check, mask;
 	int reg;
+	struct resource *res = dev->resource + resno;
 
 	/*
 	 * Ignore resources for unimplemented BARs and unused resource slots
@@ -162,7 +163,7 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 	} else {
 		res->flags &= ~IORESOURCE_STARTALIGN;
 		if (resno < PCI_BRIDGE_RESOURCES)
-			pci_update_resource(dev, res, resno);
+			pci_update_resource(dev, resno);
 	}
 
 	return ret;
@@ -197,7 +198,7 @@ int pci_assign_resource_fixed(struct pci_dev *dev, int resno)
 		dev_err(&dev->dev, "BAR %d: can't allocate %s resource %pR\n",
 			resno, res->flags & IORESOURCE_IO ? "I/O" : "mem", res);
 	} else if (resno < PCI_BRIDGE_RESOURCES) {
-		pci_update_resource(dev, res, resno);
+		pci_update_resource(dev, resno);
 	}
 
 	return ret;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index feb4657..7e7ff03 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -642,7 +642,7 @@ int pcie_get_readrq(struct pci_dev *dev);
 int pcie_set_readrq(struct pci_dev *dev, int rq);
 int pci_reset_function(struct pci_dev *dev);
 int pci_execute_reset_function(struct pci_dev *dev);
-void pci_update_resource(struct pci_dev *dev, struct resource *res, int resno);
+void pci_update_resource(struct pci_dev *dev, int resno);
 int __must_check pci_assign_resource(struct pci_dev *dev, int i);
 int pci_select_bars(struct pci_dev *dev, unsigned long flags);
 
-- 
1.5.6.4

