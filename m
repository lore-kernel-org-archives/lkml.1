Return-Path: <linux-kernel-owner+w=401wt.eu-S1758043AbYKUTkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbYKUTkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 14:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755613AbYKUTj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 14:39:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:20487 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318AbYKUTjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 14:39:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,645,1220252400"; 
   d="scan'208";a="362855405"
Date: Sat, 22 Nov 2008 02:42:57 +0800
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
Subject: [PATCH 10/13 v7] PCI: support the SR-IOV capability
Message-ID: <20081121184257.GK7810@yzhao12-linux.sh.intel.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support Single Root I/O Virtualization (SR-IOV) capability.

Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 drivers/pci/Kconfig      |   13 ++
 drivers/pci/Makefile     |    3 +
 drivers/pci/iov.c        |  491 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci-driver.c |   12 +-
 drivers/pci/pci.c        |    8 +
 drivers/pci/pci.h        |   51 +++++
 drivers/pci/probe.c      |    4 +
 include/linux/pci.h      |    9 +
 include/linux/pci_regs.h |   21 ++
 9 files changed, 610 insertions(+), 2 deletions(-)
 create mode 100644 drivers/pci/iov.c

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index e1ca425..493233e 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -50,3 +50,16 @@ config HT_IRQ
 	   This allows native hypertransport devices to use interrupts.
 
 	   If unsure say Y.
+
+config PCI_IOV
+	bool "PCI IOV support"
+	depends on PCI
+	select PCI_MSI
+	default n
+	help
+	  PCI-SIG I/O Virtualization (IOV) Specifications support.
+	  Single Root IOV: allows the Physical Function device driver
+	  to enable the hardware capability, so the Virtual Function
+	  is accessible via the PCI configuration space using its own
+	  Bus, Device and Function Number. Each Virtual Function also
+	  has PCI Memory Space to map its own register set.
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index af3bfe2..8c7c12d 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -29,6 +29,9 @@ obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
 
 obj-$(CONFIG_INTR_REMAP) += dmar.o intr_remapping.o
 
+# PCI IOV support
+obj-$(CONFIG_PCI_IOV) += iov.o
+
 #
 # Some architectures use the generic PCI setup functions
 #
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
new file mode 100644
index 0000000..03f62ca
--- /dev/null
+++ b/drivers/pci/iov.c
@@ -0,0 +1,491 @@
+/*
+ * drivers/pci/iov.c
+ *
+ * Copyright (C) 2008 Intel Corporation
+ *
+ * PCI Express I/O Virtualization (IOV) support.
+ *   Single Root IOV 1.0
+ */
+
+#include <linux/ctype.h>
+#include <linux/string.h>
+#include <linux/pci.h>
+#include <linux/delay.h>
+#include <asm/page.h>
+#include "pci.h"
+
+
+#define pci_iov_attr(field)					\
+static ssize_t iov_##field##_show(struct device *dev,		\
+		struct device_attribute *attr, char *buf)	\
+{								\
+	struct pci_dev *pdev = to_pci_dev(dev);			\
+	return sprintf(buf, "%d\n", pdev->iov->field);		\
+}
+
+pci_iov_attr(total);
+pci_iov_attr(initial);
+pci_iov_attr(nr_virtfn);
+
+static inline void virtfn_bdf(struct pci_dev *dev, int id, u8 *busnr, u8 *devfn)
+{
+	u16 bdf;
+
+	bdf = (dev->bus->number << 8) + dev->devfn +
+		dev->iov->offset + dev->iov->stride * id;
+	*busnr = bdf >> 8;
+	*devfn = bdf & 0xff;
+}
+
+static int virtfn_add(struct pci_dev *dev, int id)
+{
+	int i;
+	int rc;
+	u8 busnr, devfn;
+	struct pci_dev *virtfn;
+	struct resource *res;
+	resource_size_t size;
+
+	virtfn_bdf(dev, id, &busnr, &devfn);
+
+	virtfn = alloc_pci_dev();
+	if (!virtfn)
+		return -ENOMEM;
+
+	virtfn->bus = pci_find_bus(pci_domain_nr(dev->bus), busnr);
+	BUG_ON(!virtfn->bus);
+	virtfn->sysdata = dev->bus->sysdata;
+	virtfn->dev.parent = dev->dev.parent;
+	virtfn->dev.bus = dev->dev.bus;
+	virtfn->devfn = devfn;
+	virtfn->hdr_type = PCI_HEADER_TYPE_NORMAL;
+	virtfn->multifunction = 0;
+	virtfn->vendor = dev->vendor;
+	pci_read_config_word(dev, dev->iov->cap + PCI_IOV_VF_DID,
+			     &virtfn->device);
+	virtfn->cfg_size = PCI_CFG_SPACE_EXP_SIZE;
+	virtfn->error_state = pci_channel_io_normal;
+	virtfn->is_pcie = 1;
+	virtfn->pcie_type = PCI_EXP_TYPE_ENDPOINT;
+	virtfn->dma_mask = 0xffffffff;
+
+	dev_set_name(&virtfn->dev, "%04x:%02x:%02x.%d",
+		     pci_domain_nr(virtfn->bus), busnr,
+		     PCI_SLOT(devfn), PCI_FUNC(devfn));
+
+	pci_read_config_byte(virtfn, PCI_REVISION_ID, &virtfn->revision);
+	virtfn->class = dev->class;
+	virtfn->current_state = PCI_UNKNOWN;
+	virtfn->irq = 0;
+
+	for (i = 0; i < PCI_IOV_NUM_BAR; i++) {
+		res = dev->resource + PCI_IOV_RESOURCES + i;
+		if (!res->parent)
+			continue;
+		virtfn->resource[i].name = pci_name(virtfn);
+		virtfn->resource[i].flags = res->flags;
+		size = resource_size(res);
+		do_div(size, dev->iov->total);
+		virtfn->resource[i].start = res->start + size * id;
+		virtfn->resource[i].end = virtfn->resource[i].start + size - 1;
+		rc = request_resource(res, &virtfn->resource[i]);
+		BUG_ON(rc);
+	}
+
+	virtfn->subsystem_vendor = dev->subsystem_vendor;
+	pci_read_config_word(virtfn, PCI_SUBSYSTEM_ID,
+			     &virtfn->subsystem_device);
+
+	pci_device_add(virtfn, virtfn->bus);
+	rc = pci_bus_add_device(virtfn);
+
+	return rc;
+}
+
+static void virtfn_remove(struct pci_dev *dev, int id)
+{
+	u8 busnr, devfn;
+	struct pci_bus *bus;
+	struct pci_dev *virtfn;
+
+	virtfn_bdf(dev, id, &busnr, &devfn);
+
+	bus = pci_find_bus(pci_domain_nr(dev->bus), busnr);
+	BUG_ON(!bus);
+	virtfn = pci_get_slot(bus, devfn);
+	BUG_ON(!virtfn);
+	pci_dev_put(virtfn);
+	pci_remove_bus_device(virtfn);
+}
+
+static int iov_add_bus(struct pci_bus *bus, int busnr)
+{
+	int i;
+	int rc;
+	struct pci_bus *child;
+
+	for (i = bus->number + 1; i <= busnr; i++) {
+		child = pci_find_bus(pci_domain_nr(bus), i);
+		if (child)
+			continue;
+		child = pci_add_new_bus(bus, NULL, i);
+		if (!child)
+			return -ENOMEM;
+
+		child->subordinate = i;
+		child->dev.parent = bus->bridge;
+		rc = pci_bus_add_child(child);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+static void iov_remove_bus(struct pci_bus *bus, int busnr)
+{
+	int i;
+	struct pci_bus *child;
+
+	for (i = bus->number + 1; i <= busnr; i++) {
+		child = pci_find_bus(pci_domain_nr(bus), i);
+		BUG_ON(!child);
+		if (list_empty(&child->devices))
+			pci_remove_bus(child);
+	}
+}
+
+static int iov_enable(struct pci_dev *dev, int nr_virtfn)
+{
+	int i, j;
+	int rc;
+	u8 busnr, devfn;
+	u16 ctrl, offset, stride;
+
+	pci_write_config_word(dev, dev->iov->cap + PCI_IOV_NUM_VF, nr_virtfn);
+	pci_read_config_word(dev, dev->iov->cap + PCI_IOV_VF_OFFSET, &offset);
+	pci_read_config_word(dev, dev->iov->cap + PCI_IOV_VF_STRIDE, &stride);
+
+	if (!offset || (nr_virtfn > 1 && !stride))
+		return -EIO;
+
+	dev->iov->offset = offset;
+	dev->iov->stride = stride;
+
+	virtfn_bdf(dev, nr_virtfn - 1, &busnr, &devfn);
+	if (busnr > dev->bus->subordinate)
+		return -EIO;
+
+	rc = dev->driver->virtual(dev, nr_virtfn);
+	if (rc)
+		return rc;
+
+	pci_read_config_word(dev, dev->iov->cap + PCI_IOV_CTRL, &ctrl);
+	ctrl |= PCI_IOV_CTRL_VFE | PCI_IOV_CTRL_MSE;
+	pci_write_config_word(dev, dev->iov->cap + PCI_IOV_CTRL, ctrl);
+	ssleep(1);
+
+	iov_add_bus(dev->bus, busnr);
+	for (i = 0; i < nr_virtfn; i++) {
+		rc = virtfn_add(dev, i);
+		if (rc)
+			goto failed;
+	}
+
+	dev->iov->nr_virtfn = nr_virtfn;
+
+	return 0;
+
+failed:
+	for (j = 0; j < i; j++)
+		virtfn_remove(dev, j);
+
+	iov_remove_bus(dev->bus, busnr);
+
+	ctrl &= ~(PCI_IOV_CTRL_VFE | PCI_IOV_CTRL_MSE);
+	pci_write_config_word(dev, dev->iov->cap + PCI_IOV_CTRL, ctrl);
+	ssleep(1);
+
+	return rc;
+}
+
+static void iov_disable(struct pci_dev *dev)
+{
+	int i;
+	int rc;
+	u16 ctrl;
+	u8 busnr, devfn;
+
+	if (!dev->iov->nr_virtfn)
+		return;
+
+	rc = dev->driver->virtual(dev, 0);
+	if (rc)
+		return;
+
+	for (i = 0; i < dev->iov->nr_virtfn; i++)
+		virtfn_remove(dev, i);
+
+	virtfn_bdf(dev, dev->iov->nr_virtfn - 1, &busnr, &devfn);
+	iov_remove_bus(dev->bus, busnr);
+
+	pci_read_config_word(dev, dev->iov->cap + PCI_IOV_CTRL, &ctrl);
+	ctrl &= ~(PCI_IOV_CTRL_VFE | PCI_IOV_CTRL_MSE);
+	pci_write_config_word(dev, dev->iov->cap + PCI_IOV_CTRL, ctrl);
+	ssleep(1);
+
+	dev->iov->nr_virtfn = 0;
+}
+
+static ssize_t iov_set_nr_virtfn(struct device *dev,
+			struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	int rc;
+	long nr_virtfn;
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	rc = strict_strtol(buf, 0, &nr_virtfn);
+	if (rc)
+		return rc;
+
+	if (nr_virtfn < 0 || nr_virtfn > pdev->iov->initial)
+		return -EINVAL;
+
+	if (nr_virtfn == pdev->iov->nr_virtfn)
+		return count;
+
+	mutex_lock(&pdev->iov->physfn->iov->lock);
+	iov_disable(pdev);
+
+	if (nr_virtfn)
+		rc = iov_enable(pdev, nr_virtfn);
+	mutex_unlock(&pdev->iov->physfn->iov->lock);
+
+	return rc ? rc : count;
+}
+
+static DEVICE_ATTR(total_virtfn, S_IRUGO, iov_total_show, NULL);
+static DEVICE_ATTR(initial_virtfn, S_IRUGO, iov_initial_show, NULL);
+static DEVICE_ATTR(nr_virtfn, S_IWUSR | S_IRUGO,
+		   iov_nr_virtfn_show, iov_set_nr_virtfn);
+
+static struct attribute *iov_attrs[] = {
+	&dev_attr_total_virtfn.attr,
+	&dev_attr_initial_virtfn.attr,
+	&dev_attr_nr_virtfn.attr,
+	NULL
+};
+
+static struct attribute_group iov_attr_group = {
+	.attrs = iov_attrs,
+	.name = "iov",
+};
+
+/**
+ * pci_iov_init - initialize device's SR-IOV capability
+ * @dev: the PCI device
+ *
+ * Returns 0 on success, or negative on failure.
+ *
+ * The major differences between Virtual Function and PCI device are:
+ * 1) the device with multiple bus numbers uses internal routing, so
+ *    there is no explicit bridge device in this case.
+ * 2) Virtual Function memory spaces are designated by BARs encapsulated
+ *    in the capability structure, and the BARs in Virtual Function PCI
+ *    configuration space are read-only zero.
+ */
+int pci_iov_init(struct pci_dev *dev)
+{
+	int i;
+	int pos;
+	u32 pgsz;
+	u16 ctrl, total, initial, offset, stride;
+	struct pci_iov *iov;
+	struct resource *res;
+	struct pci_dev *physfn;
+
+	if (!dev->is_pcie)
+		return -ENODEV;
+
+	if (dev->pcie_type != PCI_EXP_TYPE_RC_END &&
+	    dev->pcie_type != PCI_EXP_TYPE_ENDPOINT)
+		return -ENODEV;
+
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_IOV);
+	if (!pos)
+		return -ENODEV;
+
+	pci_read_config_word(dev, pos + PCI_IOV_CTRL, &ctrl);
+	if (ctrl & PCI_IOV_CTRL_VFE) {
+		pci_write_config_word(dev, pos + PCI_IOV_CTRL, 0);
+		ssleep(1);
+	}
+
+	physfn = NULL;
+	if (!list_empty(&dev->bus->devices))
+		list_for_each_entry(physfn, &dev->bus->devices, bus_list)
+			if (physfn->iov)
+				break;
+
+	ctrl = 0;
+	if (!(physfn && physfn->iov) && pci_ari_enabled(dev->bus))
+		ctrl |= PCI_IOV_CTRL_ARI;
+
+	pci_write_config_word(dev, pos + PCI_IOV_CTRL, ctrl);
+	pci_read_config_word(dev, pos + PCI_IOV_TOTAL_VF, &total);
+	pci_read_config_word(dev, pos + PCI_IOV_INITIAL_VF, &initial);
+	pci_write_config_word(dev, pos + PCI_IOV_NUM_VF, initial);
+	pci_read_config_word(dev, pos + PCI_IOV_VF_OFFSET, &offset);
+	pci_read_config_word(dev, pos + PCI_IOV_VF_STRIDE, &stride);
+
+	if (!total || initial > total || (initial && !offset) ||
+	    (initial > 1 && !stride))
+		return -EIO;
+
+	pci_read_config_dword(dev, pos + PCI_IOV_SUP_PGSIZE, &pgsz);
+	i = PAGE_SHIFT > 12 ? PAGE_SHIFT - 12 : 0;
+	pgsz &= ~((1 << i) - 1);
+	if (!pgsz)
+		return -EIO;
+
+	pgsz &= ~(pgsz - 1);
+	pci_write_config_dword(dev, pos + PCI_IOV_SYS_PGSIZE, pgsz);
+
+	iov = kzalloc(sizeof(*iov), GFP_KERNEL);
+	if (!iov)
+		return -ENOMEM;
+
+	iov->cap = pos;
+	iov->total = total;
+	iov->initial = initial;
+	iov->offset = offset;
+	iov->stride = stride;
+	iov->pgsz = pgsz;
+
+	for (i = 0; i < PCI_IOV_NUM_BAR; i++) {
+		res = dev->resource + PCI_IOV_RESOURCES + i;
+		pos = iov->cap + PCI_IOV_BAR_0 + i * 4;
+		i += __pci_read_base(dev, pci_bar_unknown, res, pos);
+		if (!res->flags)
+			continue;
+		res->end = res->start + resource_size(res) * total - 1;
+	}
+
+	if (physfn && physfn->iov) {
+		pci_dev_get(physfn);
+		iov->physfn = physfn;
+	} else {
+		mutex_init(&iov->lock);
+		iov->physfn = dev;
+	}
+
+	dev->iov = iov;
+
+	return 0;
+}
+
+/**
+ * pci_iov_release - release resources used by the SR-IOV capability
+ * @dev: the PCI device
+ */
+void pci_iov_release(struct pci_dev *dev)
+{
+	if (!dev->iov)
+		return;
+
+	if (dev == dev->iov->physfn)
+		mutex_destroy(&dev->iov->lock);
+	else
+		pci_dev_put(dev->iov->physfn);
+
+	kfree(dev->iov);
+}
+
+/**
+ * pci_iov_resource_bar - get position of the SR-IOV BAR
+ * @dev: the PCI device
+ * @resno: the resource number
+ * @type: the BAR type to be filled in
+ *
+ * Returns position of the BAR encapsulated in the SR-IOV capability.
+ */
+int pci_iov_resource_bar(struct pci_dev *dev, int resno,
+			 enum pci_bar_type *type)
+{
+	if (resno < PCI_IOV_RESOURCES || resno > PCI_IOV_RESOURCE_END)
+		return 0;
+
+	BUG_ON(!dev->iov);
+
+	*type = pci_bar_unknown;
+	return dev->iov->cap + PCI_IOV_BAR_0 +
+		4 * (resno - PCI_IOV_RESOURCES);
+}
+
+/**
+ * pci_restore_iov_state - restore the state of the SR-IOV capability
+ * @dev: the PCI device
+ */
+void pci_restore_iov_state(struct pci_dev *dev)
+{
+	u16 ctrl;
+
+	if (!dev->iov)
+		return;
+
+	pci_read_config_word(dev, dev->iov->cap + PCI_IOV_CTRL, &ctrl);
+	if (ctrl & PCI_IOV_CTRL_VFE)
+		return;
+
+	pci_write_config_dword(dev, dev->iov->cap + PCI_IOV_SYS_PGSIZE,
+			       dev->iov->pgsz);
+	ctrl = 0;
+	if (dev == dev->iov->physfn && pci_ari_enabled(dev->bus))
+		ctrl |= PCI_IOV_CTRL_ARI;
+	pci_write_config_word(dev, dev->iov->cap + PCI_IOV_CTRL, ctrl);
+
+	if (!dev->iov->nr_virtfn)
+		return;
+
+	pci_write_config_word(dev, dev->iov->cap + PCI_IOV_NUM_VF,
+			      dev->iov->nr_virtfn);
+	ctrl |= PCI_IOV_CTRL_VFE | PCI_IOV_CTRL_MSE;
+	pci_write_config_word(dev, dev->iov->cap + PCI_IOV_CTRL, ctrl);
+
+	ssleep(1);
+}
+
+/**
+ * pci_iov_register - register the SR-IOV capability
+ * @dev: the PCI device
+ */
+int pci_iov_register(struct pci_dev *dev)
+{
+	int rc;
+
+	if (!dev->iov)
+		return -ENODEV;
+
+	rc = sysfs_create_group(&dev->dev.kobj, &iov_attr_group);
+	if (rc)
+		return rc;
+
+	rc = kobject_uevent(&dev->dev.kobj, KOBJ_CHANGE);
+
+	return rc;
+}
+
+/**
+ * pci_iov_unregister - unregister the SR-IOV capability
+ * @dev: the PCI device
+ */
+void pci_iov_unregister(struct pci_dev *dev)
+{
+	if (!dev->iov)
+		return;
+
+	sysfs_remove_group(&dev->dev.kobj, &iov_attr_group);
+	iov_disable(dev);
+	kobject_uevent(&dev->dev.kobj, KOBJ_CHANGE);
+}
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index b4cdd69..3d5f3a3 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -234,6 +234,8 @@ __pci_device_probe(struct pci_driver *drv, struct pci_dev *pci_dev)
 			error = pci_call_probe(drv, pci_dev, id);
 		if (error >= 0) {
 			pci_dev->driver = drv;
+			if (drv->virtual)
+				pci_iov_register(pci_dev);
 			error = 0;
 		}
 	}
@@ -262,6 +264,8 @@ static int pci_device_remove(struct device * dev)
 	struct pci_driver * drv = pci_dev->driver;
 
 	if (drv) {
+		if (drv->virtual)
+			pci_iov_unregister(pci_dev);
 		if (drv->remove)
 			drv->remove(pci_dev);
 		pci_dev->driver = NULL;
@@ -292,8 +296,12 @@ static void pci_device_shutdown(struct device *dev)
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct pci_driver *drv = pci_dev->driver;
 
-	if (drv && drv->shutdown)
-		drv->shutdown(pci_dev);
+	if (drv) {
+		if (drv->virtual)
+			pci_iov_unregister(pci_dev);
+		if (drv->shutdown)
+			drv->shutdown(pci_dev);
+	}
 	pci_msi_shutdown(pci_dev);
 	pci_msix_shutdown(pci_dev);
 }
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 9382b5f..ca26e53 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -763,6 +763,7 @@ pci_restore_state(struct pci_dev *dev)
 	}
 	pci_restore_pcix_state(dev);
 	pci_restore_msi_state(dev);
+	pci_restore_iov_state(dev);
 
 	return 0;
 }
@@ -2017,12 +2018,19 @@ int pci_select_bars(struct pci_dev *dev, unsigned long flags)
  */
 int pci_resource_bar(struct pci_dev *dev, int resno, enum pci_bar_type *type)
 {
+	int reg;
+
 	if (resno < PCI_ROM_RESOURCE) {
 		*type = pci_bar_unknown;
 		return PCI_BASE_ADDRESS_0 + 4 * resno;
 	} else if (resno == PCI_ROM_RESOURCE) {
 		*type = pci_bar_mem32;
 		return dev->rom_base_reg;
+	} else if (resno < PCI_BRIDGE_RESOURCES) {
+		/* device specific resource */
+		reg = pci_iov_resource_bar(dev, resno, type);
+		if (reg)
+			return reg;
 	}
 
 	dev_err(&dev->dev, "BAR: invalid resource #%d\n", resno);
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 315bbe6..3113d11 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -183,4 +183,55 @@ static inline int pci_ari_enabled(struct pci_bus *bus)
 	return bus->self && bus->self->ari_enabled;
 }
 
+/* Single Root I/O Virtualization */
+struct pci_iov {
+	int cap;		/* capability position */
+	int status;		/* status of SR-IOV */
+	u16 total;		/* total VFs associated with the PF */
+	u16 initial;		/* initial VFs associated with the PF */
+	u16 nr_virtfn;		/* number of VFs available */
+	u16 offset;		/* first VF Routing ID offset */
+	u16 stride;		/* following VF stride */
+	u32 pgsz;		/* page size for BAR alignment */
+	struct pci_dev *physfn;	/* lowest numbered PF */
+	struct mutex lock;	/* lock for VF bus */
+};
+
+#ifdef CONFIG_PCI_IOV
+extern int pci_iov_init(struct pci_dev *dev);
+extern void pci_iov_release(struct pci_dev *dev);
+extern int pci_iov_resource_bar(struct pci_dev *dev, int resno,
+				enum pci_bar_type *type);
+extern int pci_iov_register(struct pci_dev *dev);
+extern void pci_iov_unregister(struct pci_dev *dev);
+extern void pci_restore_iov_state(struct pci_dev *dev);
+#else
+static inline int pci_iov_init(struct pci_dev *dev)
+{
+	return -EIO;
+}
+static inline void pci_iov_release(struct pci_dev *dev)
+
+{
+}
+
+static inline int pci_iov_resource_bar(struct pci_dev *dev, int resno,
+				       enum pci_bar_type *type)
+{
+	return 0;
+}
+
+static inline int pci_iov_register(struct pci_dev *dev)
+{
+}
+
+static inline void pci_iov_unregister(struct pci_dev *dev)
+{
+}
+
+static inline void pci_restore_iov_state(struct pci_dev *dev)
+{
+}
+#endif /* CONFIG_PCI_IOV */
+
 #endif /* DRIVERS_PCI_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index cd205fd..cb26e64 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -785,6 +785,7 @@ static int pci_setup_device(struct pci_dev * dev)
 static void pci_release_capabilities(struct pci_dev *dev)
 {
 	pci_vpd_release(dev);
+	pci_iov_release(dev);
 }
 
 /**
@@ -968,6 +969,9 @@ static void pci_init_capabilities(struct pci_dev *dev)
 
 	/* Alternative Routing-ID Forwarding */
 	pci_enable_ari(dev);
+
+	/* Single Root I/O Virtualization */
+	pci_iov_init(dev);
 }
 
 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index d455ec8..c9046a3 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -93,6 +93,12 @@ enum {
 	/* #6: expansion ROM resource */
 	PCI_ROM_RESOURCE,
 
+	/* device specific resources */
+#ifdef CONFIG_PCI_IOV
+	PCI_IOV_RESOURCES,
+	PCI_IOV_RESOURCE_END = PCI_IOV_RESOURCES + PCI_IOV_NUM_BAR - 1,
+#endif
+
 	/* resources assigned to buses behind the bridge */
 #define PCI_BRIDGE_RESOURCE_NUM 4
 
@@ -171,6 +177,7 @@ struct pci_cap_saved_state {
 
 struct pcie_link_state;
 struct pci_vpd;
+struct pci_iov;
 
 /*
  * The pci_dev structure is used to describe PCI devices.
@@ -259,6 +266,7 @@ struct pci_dev {
 	struct list_head msi_list;
 #endif
 	struct pci_vpd *vpd;
+	struct pci_iov *iov;
 };
 
 extern struct pci_dev *alloc_pci_dev(void);
@@ -426,6 +434,7 @@ struct pci_driver {
 	int  (*resume_early) (struct pci_dev *dev);
 	int  (*resume) (struct pci_dev *dev);	                /* Device woken up */
 	void (*shutdown) (struct pci_dev *dev);
+	int (*virtual) (struct pci_dev *dev, int nr_virtfn);
 	struct pm_ext_ops *pm;
 	struct pci_error_handlers *err_handler;
 	struct device_driver	driver;
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index e5effd4..1d1ade2 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -363,6 +363,7 @@
 #define  PCI_EXP_TYPE_UPSTREAM	0x5	/* Upstream Port */
 #define  PCI_EXP_TYPE_DOWNSTREAM 0x6	/* Downstream Port */
 #define  PCI_EXP_TYPE_PCI_BRIDGE 0x7	/* PCI/PCI-X Bridge */
+#define  PCI_EXP_TYPE_RC_END	0x9	/* Root Complex Integrated Endpoint */
 #define PCI_EXP_FLAGS_SLOT	0x0100	/* Slot implemented */
 #define PCI_EXP_FLAGS_IRQ	0x3e00	/* Interrupt message number */
 #define PCI_EXP_DEVCAP		4	/* Device capabilities */
@@ -436,6 +437,7 @@
 #define PCI_EXT_CAP_ID_DSN	3
 #define PCI_EXT_CAP_ID_PWR	4
 #define PCI_EXT_CAP_ID_ARI	14
+#define PCI_EXT_CAP_ID_IOV	16
 
 /* Advanced Error Reporting */
 #define PCI_ERR_UNCOR_STATUS	4	/* Uncorrectable Error Status */
@@ -553,4 +555,23 @@
 #define  PCI_ARI_CTRL_ACS	0x0002	/* ACS Function Groups Enable */
 #define  PCI_ARI_CTRL_FG(x)	(((x) >> 4) & 7) /* Function Group */
 
+/* Single Root I/O Virtualization */
+#define PCI_IOV_CAP		0x04	/* SR-IOV Capabilities */
+#define PCI_IOV_CTRL		0x08	/* SR-IOV Control */
+#define  PCI_IOV_CTRL_VFE	0x01	/* VF Enable */
+#define  PCI_IOV_CTRL_MSE	0x08	/* VF Memory Space Enable */
+#define  PCI_IOV_CTRL_ARI	0x10	/* ARI Capable Hierarchy */
+#define PCI_IOV_STATUS		0x0a	/* SR-IOV Status */
+#define PCI_IOV_INITIAL_VF	0x0c	/* Initial VFs */
+#define PCI_IOV_TOTAL_VF	0x0e	/* Total VFs */
+#define PCI_IOV_NUM_VF		0x10	/* Number of VFs */
+#define PCI_IOV_FUNC_LINK	0x12	/* Function Dependency Link */
+#define PCI_IOV_VF_OFFSET	0x14	/* First VF Offset */
+#define PCI_IOV_VF_STRIDE	0x16	/* Following VF Stride */
+#define PCI_IOV_VF_DID		0x1a	/* VF Device ID */
+#define PCI_IOV_SUP_PGSIZE	0x1c	/* Supported Page Sizes */
+#define PCI_IOV_SYS_PGSIZE	0x20	/* System Page Size */
+#define PCI_IOV_BAR_0		0x24	/* VF BAR0 */
+#define PCI_IOV_NUM_BAR		6	/* Number of VF BARs */
+
 #endif /* LINUX_PCI_REGS_H */
-- 
1.5.6.4

