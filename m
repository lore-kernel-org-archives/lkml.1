Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbYKFW5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbYKFW5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:57:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbYKFW45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:56:57 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:51118 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbYKFW44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:56:56 -0500
Date: Fri, 7 Nov 2008 09:56:54 +1100
From: Simon Horman <horms@verge.net.au>
To: H L <swdevyid@yahoo.com>
Cc: Greg KH <greg@kroah.com>, Yu Zhao <yu.zhao@intel.com>,
       randy.dunlap@oracle.com, grundler@parisc-linux.org, achiang@hp.com,
       matthew@wil.cx, linux-pci@vger.kernel.org, rdreier@cisco.com,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       mingo@elte.hu, Xen-devel List <xen-devel@lists.xensource.com>
Subject: Re: git repository for SR-IOV development?
Message-ID: <20081106225654.GA2012@verge.net.au>
References: <20081106165914.GA13476@kroah.com> <104014.9320.qm@web45110.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <104014.9320.qm@web45110.mail.sp1.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 11:58:25AM -0800, H L wrote:
> --- On Thu, 11/6/08, Greg KH <greg@kroah.com> wrote:
> 
> > On Thu, Nov 06, 2008 at 08:51:09AM -0800, H L wrote:
> > > 
> > > Has anyone initiated or given consideration to the
> > creation of a git
> > > repository (say, on kernel.org) for SR-IOV
> > development?
> > 
> > Why?  It's only a few patches, right?  Why would it
> > need a whole new git
> > tree?
> 
> 
> So as to minimize the time and effort patching a kernel, especially if
> the tree (and/or hash level) against which the patches were created fails
> to be specified on a mailing-list.  Plus, there appears to be questions
> raised on how, precisely, the implementation should ultimately be modeled
> and especially given that, who knows at this point what number of patches
> will ultimately be submitted?  I know I've built the "7-patch" one
> (painfully, by the way), and I'm aware there's another 15-patch set out
> there which I've not yet examined.

FWIW, the v6 patch series (this thread) applied to both 2.6.28-rc3
and the current Linus tree after a minor tweak to the first patch, as below.

-- 
Simon Horman
  VA Linux Systems Japan K.K., Sydney, Australia Satellite Office
  H: www.vergenet.net/~horms/             W: www.valinux.co.jp/en

From: Yu Zhao <yu.zhao@intel.com>

[PATCH 1/16 v6] PCI: remove unnecessary arg of pci_update_resource()

This cleanup removes unnecessary argument 'struct resource *res' in
pci_update_resource(), so it takes same arguments as other companion
functions (pci_assign_resource(), etc.).

Cc: Alex Chiang <achiang@hp.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Roland Dreier <rdreier@cisco.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>
Upported-by: Simon Horman <horms@verge.net.au>

---
 drivers/pci/pci.c       |    4 ++--
 drivers/pci/setup-res.c |    7 ++++---
 include/linux/pci.h     |    2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

* Fri, 07 Nov 2008 09:05:18 +1100, Simon Horman
  - Minor rediff of include/linux/pci.h section to apply to 2.6.28-rc3

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 4db261e..ae62f01 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -376,8 +376,8 @@ pci_restore_bars(struct pci_dev *dev)
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
index 085187b..43e1fc1 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -626,7 +626,7 @@ int pcix_get_mmrbc(struct pci_dev *dev);
 int pcie_set_readrq(struct pci_dev *dev, int rq);
 int pci_reset_function(struct pci_dev *dev);
 int pci_execute_reset_function(struct pci_dev *dev);
-void pci_update_resource(struct pci_dev *dev, struct resource *res, int resno);
+void pci_update_resource(struct pci_dev *dev, int resno);
 int __must_check pci_assign_resource(struct pci_dev *dev, int i);
 int pci_select_bars(struct pci_dev *dev, unsigned long flags);
 
-- 
1.5.6.4

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

