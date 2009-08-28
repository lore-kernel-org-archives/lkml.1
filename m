Return-Path: <linux-kernel-owner+w=401wt.eu-S1753129AbZH1UBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbZH1UBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 16:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZH1UBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 16:01:30 -0400
Received: from sous-sol.org ([216.99.217.87]:42131 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752875AbZH1UB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 16:01:29 -0400
Date: Fri, 28 Aug 2009 13:00:06 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yu Zhao <yu.zhao@intel.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, stable@kernel.org
Subject: [PATCH v2] SR-IOV: correct broken resource alignment calculations
Message-ID: <20090828200006.GL10360@sequoia.sous-sol.org>
References: <20090828191714.GI10360@sequoia.sous-sol.org> <20090828194825.GM4884@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090828194825.GM4884@parisc-linux.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Wilcox (matthew@wil.cx) wrote:
> On Fri, Aug 28, 2009 at 12:17:14PM -0700, Chris Wright wrote:
> > This patch adds a support for a new resource alignment type,
> > IORESOURCE_VSIZEALIGN, and allows struct resource to keep track of the
> > size requirements of a VF BAR which are smaller than the full resource
> > size.  This could also be done all within the PCI layer w/out bloating
> > struct resource or using the last available bit for alignment types.
> 
> Yes, I think that would be preferable.  We have a *LOT* of resources in
> the kernel, and the embedded folks would not find it funny if they all
> grew in size suddenly.

An SR-IOV capable device includes an SR-IOV PCIe capability which
describes the Virtual Function (VF) BAR requirements.  A typical SR-IOV
device can support multiple VFs whose BARs must be in a contiguous region,
effectively an array of VF BARs.  The BAR reports the size requirement
for a single VF.  We calculate the full range needed by simply multiplying
the VF BAR size with the number of possible VFs and create a resource
spanning the full range.

This all seems sane enough except it artificially inflates the alignment
requirement for the VF BAR.  The VF BAR need only be aligned to the size
of a single BAR not the contiguous range of VF BARs.  This can cause us
to fail to allocate resources for the BAR despite the fact that we
actually have enough space.

This patch adds a thin PCI specific layer over the generic
resource_alignment() function which is aware of the special nature of
VF BARs and does sorting and allocation based on the smaller alignment
requirement.

I recognize that while resource_alignment is generic, it's basically a
PCI helper.  An alternative to this patch is to add PCI VF BAR specific
information to struct resource.  I opted for the extra layer rather than
adding such PCI specific information to struct resource.  This does
have the slight downside that we don't cache the BAR size and re-read
for each alignment query (happens a small handful of times during boot
for each VF BAR).

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Yu Zhao <yu.zhao@intel.com>
Cc: stable@kernel.org
---
 drivers/pci/iov.c       |   23 +++++++++++++++++++++++
 drivers/pci/pci.h       |   13 +++++++++++++
 drivers/pci/setup-bus.c |    4 ++--
 drivers/pci/setup-res.c |    8 ++++----
 4 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index e3a8721..e03fe98 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -598,6 +598,29 @@ int pci_iov_resource_bar(struct pci_dev *dev, int resno,
 }
 
 /**
+ * pci_sriov_resource_alignment - get resource alignment for VF BAR
+ * @dev: the PCI device
+ * @resno: the resource number
+ *
+ * Returns the alignment of the VF BAR found in the SR-IOV capability.
+ * This is not the same as the resource size which is defined as
+ * the VF BAR size multiplied by the number of VFs.  The alignment
+ * is just the VF BAR size.
+ */
+int pci_sriov_resource_alignment(struct pci_dev *dev, int resno)
+{
+	struct resource tmp;
+	enum pci_bar_type type;
+	int reg = pci_iov_resource_bar(dev, resno, &type);
+	
+	if (!reg)
+		return 0;
+
+	 __pci_read_base(dev, type, &tmp, reg);
+	return resource_alignment(&tmp);
+}
+
+/**
  * pci_restore_iov_state - restore the state of the IOV capability
  * @dev: the PCI device
  */
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index f73bcbe..5ff4d25 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -243,6 +243,7 @@ extern int pci_iov_init(struct pci_dev *dev);
 extern void pci_iov_release(struct pci_dev *dev);
 extern int pci_iov_resource_bar(struct pci_dev *dev, int resno,
 				enum pci_bar_type *type);
+extern int pci_sriov_resource_alignment(struct pci_dev *dev, int resno);
 extern void pci_restore_iov_state(struct pci_dev *dev);
 extern int pci_iov_bus_range(struct pci_bus *bus);
 
@@ -298,4 +299,16 @@ static inline int pci_ats_enabled(struct pci_dev *dev)
 }
 #endif /* CONFIG_PCI_IOV */
 
+static inline int pci_resource_alignment(struct pci_dev *dev,
+					 struct resource *res)
+{
+#ifdef CONFIG_PCI_IOV
+	int resno = res - dev->resource;
+
+	if (resno >= PCI_IOV_RESOURCES && resno <= PCI_IOV_RESOURCE_END)
+		return pci_sriov_resource_alignment(dev, resno);
+#endif
+	return resource_alignment(res);
+}
+
 #endif /* DRIVERS_PCI_H */
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index b636e24..7c443b4 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -25,7 +25,7 @@
 #include <linux/ioport.h>
 #include <linux/cache.h>
 #include <linux/slab.h>
-
+#include "pci.h"
 
 static void pbus_assign_resources_sorted(const struct pci_bus *bus)
 {
@@ -384,7 +384,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask, unsigned long
 				continue;
 			r_size = resource_size(r);
 			/* For bridges size != alignment */
-			align = resource_alignment(r);
+			align = pci_resource_alignment(dev, r);
 			order = __ffs(align) - 20;
 			if (order > 11) {
 				dev_warn(&dev->dev, "BAR %d bad alignment %llx: "
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 1898c7b..88cdd1a 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -144,7 +144,7 @@ static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
 
 	size = resource_size(res);
 	min = (res->flags & IORESOURCE_IO) ? PCIBIOS_MIN_IO : PCIBIOS_MIN_MEM;
-	align = resource_alignment(res);
+	align = pci_resource_alignment(dev, res);
 
 	/* First, try exact prefetching match.. */
 	ret = pci_bus_alloc_resource(bus, res, size, align, min,
@@ -178,7 +178,7 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 	struct pci_bus *bus;
 	int ret;
 
-	align = resource_alignment(res);
+	align = pci_resource_alignment(dev, res);
 	if (!align) {
 		dev_info(&dev->dev, "BAR %d: can't allocate resource (bogus "
 			"alignment) %pR flags %#lx\n",
@@ -259,7 +259,7 @@ void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
 		if (!(r->flags) || r->parent)
 			continue;
 
-		r_align = resource_alignment(r);
+		r_align = pci_resource_alignment(dev, r);
 		if (!r_align) {
 			dev_warn(&dev->dev, "BAR %d: bogus alignment "
 				"%pR flags %#lx\n",
@@ -271,7 +271,7 @@ void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
 			struct resource_list *ln = list->next;
 
 			if (ln)
-				align = resource_alignment(ln->res);
+				align = pci_resource_alignment(ln->dev, ln->res);
 
 			if (r_align > align) {
 				tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
