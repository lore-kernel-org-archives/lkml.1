Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbYJUMnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbYJUMnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbYJUMnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:43:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:36135 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911AbYJUMnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:43:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,457,1220252400"; 
   d="scan'208";a="453859996"
Date: Tue, 21 Oct 2008 19:48:03 +0800
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
Subject: [PATCH 5/15 v5] PCI: add a wrapper for resource_alignment()
Message-ID: <20081021114803.GF3185@yzhao12-linux.sh.intel.com>
References: <20081021114056.GA3185@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021114056.GA3185@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a wrap of resource_alignment() so it can handle device specific
resource alignment.

Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Alex Chiang <achiang@hp.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 drivers/pci/pci.c       |   20 ++++++++++++++++++++
 drivers/pci/pci.h       |    1 +
 drivers/pci/setup-bus.c |    4 ++--
 drivers/pci/setup-res.c |    7 ++++---
 4 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 40284dc..a9b554e 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1904,6 +1904,26 @@ int pci_select_bars(struct pci_dev *dev, unsigned long flags)
 	return bars;
 }
 
+/**
+ * pci_resource_alignment - get a PCI BAR resource alignment
+ * @dev: the PCI device
+ * @resno: the resource number
+ *
+ * Returns alignment size on success, or 0 on error.
+ */
+int pci_resource_alignment(struct pci_dev *dev, int resno)
+{
+	resource_size_t align;
+	struct resource *res = dev->resource + resno;
+
+	align = resource_alignment(res);
+	if (align)
+		return align;
+
+	dev_err(&dev->dev, "alignment: invalid resource #%d\n", resno);
+	return 0;
+}
+
 static void __devinit pci_no_domains(void)
 {
 #ifdef CONFIG_PCI_DOMAINS
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index fbbc6ad..baa3d23 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -166,6 +166,7 @@ enum pci_bar_type {
 
 extern int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 				struct resource *res, unsigned int reg);
+extern int pci_resource_alignment(struct pci_dev *dev, int resno);
 extern void pci_enable_ari(struct pci_dev *dev);
 /**
  * pci_ari_enabled - query ARI forwarding status
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index ea979f2..90a9c0a 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -25,6 +25,7 @@
 #include <linux/ioport.h>
 #include <linux/cache.h>
 #include <linux/slab.h>
+#include "pci.h"
 
 
 static void pbus_assign_resources_sorted(struct pci_bus *bus)
@@ -351,8 +352,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask, unsigned long
 			if (r->parent || (r->flags & mask) != type)
 				continue;
 			r_size = resource_size(r);
-			/* For bridges size != alignment */
-			align = resource_alignment(r);
+			align = pci_resource_alignment(dev, i);
 			order = __ffs(align) - 20;
 			if (order > 11) {
 				dev_warn(&dev->dev, "BAR %d bad alignment %llx: "
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index b7ca679..88a9c70 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -133,7 +133,7 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 	size = resource_size(res);
 	min = (res->flags & IORESOURCE_IO) ? PCIBIOS_MIN_IO : PCIBIOS_MIN_MEM;
 
-	align = resource_alignment(res);
+	align = pci_resource_alignment(dev, resno);
 	if (!align) {
 		dev_err(&dev->dev, "BAR %d: can't allocate resource (bogus "
 			"alignment) %pR flags %#lx\n",
@@ -224,7 +224,7 @@ void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
 		if (!(r->flags) || r->parent)
 			continue;
 
-		r_align = resource_alignment(r);
+		r_align = pci_resource_alignment(dev, i);
 		if (!r_align) {
 			dev_warn(&dev->dev, "BAR %d: bogus alignment "
 				"%pR flags %#lx\n",
@@ -236,7 +236,8 @@ void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
 			struct resource_list *ln = list->next;
 
 			if (ln)
-				align = resource_alignment(ln->res);
+				align = pci_resource_alignment(ln->dev,
+						ln->res - ln->dev->resource);
 
 			if (r_align > align) {
 				tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
-- 
1.5.6.4

