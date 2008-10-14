Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbYJNLtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbYJNLtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 07:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbYJNLte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 07:49:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:36182 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373AbYJNLtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 07:49:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,409,1220252400"; 
   d="scan'208";a="451007778"
Date: Tue, 14 Oct 2008 18:53:23 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "achiang@hp.com" <achiang@hp.com>, "matthew@wil.cx" <matthew@wil.cx>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "greg@kroah.com" <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: [PATCH 3/8 v4] PCI: export pci_alloc_child_bus
Message-ID: <20081014105323.GC1734@yzhao12-linux.sh.intel.com>
References: <20081014103424.GA1704@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014103424.GA1704@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export pci_alloc_child_bus(), and make it be able to handle buses without
bridge devices. Some devices such as SR-IOV devices use more than one bus
number while there is no explicit bridge devices since they have internal
routing mechanism.

Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 drivers/pci/pci.h   |    2 ++
 drivers/pci/probe.c |    9 ++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 922b742..c6fa8ab 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -159,6 +159,8 @@ enum pci_bar_type {
 
 extern int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 				struct resource *res, unsigned int reg);
+extern struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
+				struct pci_dev *bridge, int busnr);
 extern void pci_enable_ari(struct pci_dev *dev);
 /**
  * pci_ari_enabled - query ARI forwarding status
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 2326609..9c680b8 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -454,7 +454,7 @@ static struct pci_bus * pci_alloc_bus(void)
 	return b;
 }
 
-static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
+struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 					   struct pci_dev *bridge, int busnr)
 {
 	struct pci_bus *child;
@@ -467,12 +467,10 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 	if (!child)
 		return NULL;
 
-	child->self = bridge;
 	child->parent = parent;
 	child->ops = parent->ops;
 	child->sysdata = parent->sysdata;
 	child->bus_flags = parent->bus_flags;
-	child->bridge = get_device(&bridge->dev);
 
 	/* initialize some portions of the bus device, but don't register it
 	 * now as the parent is not properly set up yet.  This device will get
@@ -489,6 +487,11 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 	child->primary = parent->secondary;
 	child->subordinate = 0xff;
 
+	if (!bridge)
+		return child;
+
+	child->self = bridge;
+	child->bridge = get_device(&bridge->dev);
 	/* Set up default resource pointers and names.. */
 	for (i = 0; i < PCI_BRIDGE_RES_NUM; i++) {
 		child->resource[i] = &bridge->resource[PCI_BRIDGE_RESOURCES+i];
-- 
1.5.6.4

