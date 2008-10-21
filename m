Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbYJUMso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbYJUMso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbYJUMsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:48:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:38263 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbYJUMsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:48:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,457,1220252400"; 
   d="scan'208";a="453868755"
Date: Tue, 21 Oct 2008 19:53:08 +0800
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
Subject: [PATCH 12/15 v5] PCI: support the SR-IOV capability
Message-ID: <20081021115308.GM3185@yzhao12-linux.sh.intel.com>
References: <20081021114056.GA3185@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021114056.GA3185@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support Single Root I/O Virtualization (SR-IOV) capability.

Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Alex Chiang <achiang@hp.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 drivers/pci/Kconfig      |   12 +
 drivers/pci/Makefile     |    2 +
 drivers/pci/iov.c        |  616 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci-sysfs.c  |    4 +
 drivers/pci/pci.c        |   14 +
 drivers/pci/pci.h        |   48 ++++
 drivers/pci/probe.c      |    4 +
 include/linux/pci.h      |   40 +++
 include/linux/pci_regs.h |   21 ++
 9 files changed, 761 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pci/iov.c

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index e1ca425..e7c0836 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -50,3 +50,15 @@ config HT_IRQ
 	   This allows native hypertransport devices to use interrupts.
 
 	   If unsure say Y.
+
+config PCI_IOV
+	bool "PCI SR-IOV support"
+	depends on PCI
+	select PCI_MSI
+	default n
+	help
+	  This option allows device drivers to enable Single Root I/O
+	  Virtualization. Each Virtual Function's PCI configuration
+	  space can be accessed using its own Bus, Device and Function
+	  Number (Routing ID). Each Virtual Function also has PCI Memory
+	  Space, which is used to map its own register set.
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 4b47f4e..abbfcfa 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -55,3 +55,5 @@ obj-$(CONFIG_PCI_SYSCALL) += syscall.o
 ifeq ($(CONFIG_PCI_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
 endif
+
+obj-$(CONFIG_PCI_IOV) += iov.o
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
new file mode 100644
index 0000000..571a46c
--- /dev/null
+++ b/drivers/pci/iov.c
@@ -0,0 +1,616 @@
+/*
+ * drivers/pci/iov.c
+ *
+ * Copyright (C) 2008 Intel Corporation
+ *
+ * PCI Express Single Root I/O Virtualization capability support.
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
+#define iov_config_attr(field)						\
+static ssize_t field##_show(struct device *dev,				\
+		struct device_attribute *attr, char *buf)		\
+{									\
+	struct pci_dev *pdev = to_pci_dev(dev);				\
+	return sprintf(buf, "%d\n", pdev->iov->field);			\
+}
+
+iov_config_attr(status);
+iov_config_attr(totalvfs);
+iov_config_attr(initialvfs);
+iov_config_attr(numvfs);
+
+static inline void vf_rid(struct pci_dev *dev, int vfn, u8 *busnr, u8 *devfn)
+{
+	u16 rid;
+
+	rid = (dev->bus->number << 8) + dev->devfn +
+		dev->iov->offset + dev->iov->stride * vfn;
+	*busnr = rid >> 8;
+	*devfn = rid & 0xff;
+}
+
+static int vf_add(struct pci_dev *dev, int vfn)
+{
+	int i;
+	int rc;
+	u8 busnr, devfn;
+	struct pci_dev *vf;
+	struct pci_bus *bus;
+	struct resource *res;
+	resource_size_t size;
+
+	vf_rid(dev, vfn, &busnr, &devfn);
+
+	vf = alloc_pci_dev();
+	if (!vf)
+		return -ENOMEM;
+
+	if (dev->bus->number == busnr)
+		vf->bus = bus = dev->bus;
+	else {
+		list_for_each_entry(bus, &dev->bus->children, node)
+			if (bus->number == busnr) {
+				vf->bus = bus;
+				break;
+			}
+		BUG_ON(!vf->bus);
+	}
+
+	vf->sysdata = bus->sysdata;
+	vf->dev.parent = dev->dev.parent;
+	vf->dev.bus = dev->dev.bus;
+	vf->devfn = devfn;
+	vf->hdr_type = PCI_HEADER_TYPE_NORMAL;
+	vf->multifunction = 0;
+	vf->vendor = dev->vendor;
+	pci_read_config_word(dev, dev->iov->cap + PCI_IOV_VF_DID, &vf->device);
+	vf->cfg_size = PCI_CFG_SPACE_EXP_SIZE;
+	vf->error_state = pci_channel_io_normal;
+	vf->is_pcie = 1;
+	vf->pcie_type = PCI_EXP_TYPE_ENDPOINT;
+	vf->dma_mask = 0xffffffff;
+
+	dev_set_name(&vf->dev, "%04x:%02x:%02x.%d", pci_domain_nr(bus),
+		     busnr, PCI_SLOT(devfn), PCI_FUNC(devfn));
+
+	pci_read_config_byte(vf, PCI_REVISION_ID, &vf->revision);
+	vf->class = dev->class;
+	vf->current_state = PCI_UNKNOWN;
+	vf->irq = 0;
+
+	for (i = 0; i < PCI_IOV_NUM_BAR; i++) {
+		res = dev->resource + PCI_IOV_RESOURCES + i;
+		if (!res->parent)
+			continue;
+		vf->resource[i].name = pci_name(vf);
+		vf->resource[i].flags = res->flags;
+		size = resource_size(res);
+		do_div(size, dev->iov->totalvfs);
+		vf->resource[i].start = res->start + size * vfn;
+		vf->resource[i].end = vf->resource[i].start + size - 1;
+		rc = request_resource(res, &vf->resource[i]);
+		BUG_ON(rc);
+	}
+
+	vf->subsystem_vendor = dev->subsystem_vendor;
+	pci_read_config_word(vf, PCI_SUBSYSTEM_ID, &vf->subsystem_device);
+
+	pci_device_add(vf, bus);
+	return pci_bus_add_device(vf);
+}
+
+static void vf_remove(struct pci_dev *dev, int vfn)
+{
+	u8 busnr, devfn;
+	struct pci_dev *vf;
+
+	vf_rid(dev, vfn, &busnr, &devfn);
+
+	vf = pci_get_bus_and_slot(busnr, devfn);
+	if (!vf)
+		return;
+
+	pci_dev_put(vf);
+	pci_remove_bus_device(vf);
+}
+
+static int iov_enable(struct pci_dev *dev)
+{
+	int rc;
+	int i, j;
+	u16 ctrl;
+	struct pci_iov *iov = dev->iov;
+
+	if (!iov->callback)
+		return -ENODEV;
+
+	if (!iov->numvfs)
+		return -EINVAL;
+
+	if (iov->status)
+		return 0;
+
+	rc = iov->callback(dev, PCI_IOV_ENABLE);
+	if (rc)
+		return rc;
+
+	pci_read_config_word(dev, iov->cap + PCI_IOV_CTRL, &ctrl);
+	ctrl |= (PCI_IOV_CTRL_VFE | PCI_IOV_CTRL_MSE);
+	pci_write_config_word(dev, iov->cap + PCI_IOV_CTRL, ctrl);
+	ssleep(1);
+
+	for (i = 0; i < iov->numvfs; i++) {
+		rc = vf_add(dev, i);
+		if (rc)
+			goto failed;
+	}
+
+	iov->status = 1;
+	return 0;
+
+failed:
+	for (j = 0; j < i; j++)
+		vf_remove(dev, j);
+
+	pci_read_config_word(dev, iov->cap + PCI_IOV_CTRL, &ctrl);
+	ctrl &= ~(PCI_IOV_CTRL_VFE | PCI_IOV_CTRL_MSE);
+	pci_write_config_word(dev, iov->cap + PCI_IOV_CTRL, ctrl);
+	ssleep(1);
+
+	return rc;
+}
+
+static int iov_disable(struct pci_dev *dev)
+{
+	int i;
+	int rc;
+	u16 ctrl;
+	struct pci_iov *iov = dev->iov;
+
+	if (!iov->callback)
+		return -ENODEV;
+
+	if (!iov->status)
+		return 0;
+
+	rc = iov->callback(dev, PCI_IOV_DISABLE);
+	if (rc)
+		return rc;
+
+	for (i = 0; i < iov->numvfs; i++)
+		vf_remove(dev, i);
+
+	pci_read_config_word(dev, iov->cap + PCI_IOV_CTRL, &ctrl);
+	ctrl &= ~(PCI_IOV_CTRL_VFE | PCI_IOV_CTRL_MSE);
+	pci_write_config_word(dev, iov->cap + PCI_IOV_CTRL, ctrl);
+	ssleep(1);
+
+	iov->status = 0;
+	return 0;
+}
+
+static int iov_set_numvfs(struct pci_dev *dev, int numvfs)
+{
+	int rc;
+	u16 offset, stride;
+	struct pci_iov *iov = dev->iov;
+
+	if (!iov->callback)
+		return -ENODEV;
+
+	if (numvfs < 0 || numvfs > iov->initialvfs || iov->status)
+		return -EINVAL;
+
+	if (numvfs == iov->numvfs)
+		return 0;
+
+	rc = iov->callback(dev, PCI_IOV_NUMVFS | iov->numvfs);
+	if (rc)
+		return rc;
+
+	pci_write_config_word(dev, iov->cap + PCI_IOV_NUM_VF, numvfs);
+	pci_read_config_word(dev, iov->cap + PCI_IOV_VF_OFFSET, &offset);
+	pci_read_config_word(dev, iov->cap + PCI_IOV_VF_STRIDE, &stride);
+	if ((numvfs && !offset) || (numvfs > 1 && !stride))
+		return -EIO;
+
+	iov->offset = offset;
+	iov->stride = stride;
+	iov->numvfs = numvfs;
+	return 0;
+}
+
+static ssize_t status_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	int rc;
+	long enable;
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	rc = strict_strtol(buf, 0, &enable);
+	if (rc)
+		return rc;
+
+	mutex_lock(&pdev->iov->ops_lock);
+	switch (enable) {
+	case 0:
+		rc = iov_disable(pdev);
+		break;
+	case 1:
+		rc = iov_enable(pdev);
+		break;
+	default:
+		rc = -EINVAL;
+	}
+	mutex_unlock(&pdev->iov->ops_lock);
+
+	return rc ? rc : count;
+}
+
+static ssize_t numvfs_store(struct device *dev,
+			struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	int rc;
+	long numvfs;
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	rc = strict_strtol(buf, 0, &numvfs);
+	if (rc)
+		return rc;
+
+	mutex_lock(&pdev->iov->ops_lock);
+	rc = iov_set_numvfs(pdev, numvfs);
+	mutex_unlock(&pdev->iov->ops_lock);
+
+	return rc ? rc : count;
+}
+
+static DEVICE_ATTR(totalvfs, S_IRUGO, totalvfs_show, NULL);
+static DEVICE_ATTR(initialvfs, S_IRUGO, initialvfs_show, NULL);
+static DEVICE_ATTR(numvfs, S_IWUSR | S_IRUGO, numvfs_show, numvfs_store);
+static DEVICE_ATTR(enable, S_IWUSR | S_IRUGO, status_show, status_store);
+
+static struct attribute *iov_attrs[] = {
+	&dev_attr_totalvfs.attr,
+	&dev_attr_initialvfs.attr,
+	&dev_attr_numvfs.attr,
+	&dev_attr_enable.attr,
+	NULL
+};
+
+static struct attribute_group iov_attr_group = {
+	.attrs = iov_attrs,
+	.name = "iov",
+};
+
+static int iov_alloc_bus(struct pci_bus *bus, int busnr)
+{
+	int i;
+	int rc;
+	struct pci_dev *dev;
+	struct pci_bus *child;
+
+	list_for_each_entry(dev, &bus->devices, bus_list)
+		if (dev->iov)
+			break;
+
+	BUG_ON(!dev->iov);
+	pci_dev_get(dev);
+	mutex_lock(&dev->iov->bus_lock);
+
+	for (i = bus->number + 1; i <= busnr; i++) {
+		list_for_each_entry(child, &bus->children, node)
+			if (child->number == i)
+				break;
+		if (child->number == i)
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
+	mutex_unlock(&dev->iov->bus_lock);
+
+	return 0;
+}
+
+static void iov_release_bus(struct pci_bus *bus)
+{
+	struct pci_dev *dev, *tmp;
+	struct pci_bus *child, *next;
+
+	list_for_each_entry(dev, &bus->devices, bus_list)
+		if (dev->iov)
+			break;
+
+	BUG_ON(!dev->iov);
+	mutex_lock(&dev->iov->bus_lock);
+
+	list_for_each_entry(tmp, &bus->devices, bus_list)
+		if (tmp->iov && tmp->iov->callback)
+			goto done;
+
+	list_for_each_entry_safe(child, next, &bus->children, node)
+		if (!child->bridge)
+			pci_remove_bus(child);
+done:
+	mutex_unlock(&dev->iov->bus_lock);
+	pci_dev_put(dev);
+}
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
+
+	if (!dev->is_pcie || (dev->pcie_type != PCI_EXP_TYPE_RC_END &&
+				dev->pcie_type != PCI_EXP_TYPE_ENDPOINT))
+		return -ENODEV;
+
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_IOV);
+	if (!pos)
+		return -ENODEV;
+
+	ctrl = pci_ari_enabled(dev) ? PCI_IOV_CTRL_ARI : 0;
+	pci_write_config_word(dev, pos + PCI_IOV_CTRL, ctrl);
+	ssleep(1);
+
+	pci_read_config_word(dev, pos + PCI_IOV_TOTAL_VF, &total);
+	pci_read_config_word(dev, pos + PCI_IOV_INITIAL_VF, &initial);
+	pci_write_config_word(dev, pos + PCI_IOV_NUM_VF, initial);
+	pci_read_config_word(dev, pos + PCI_IOV_VF_OFFSET, &offset);
+	pci_read_config_word(dev, pos + PCI_IOV_VF_STRIDE, &stride);
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
+	iov->totalvfs = total;
+	iov->initialvfs = initial;
+	iov->offset = offset;
+	iov->stride = stride;
+	iov->align = pgsz << 12;
+
+	for (i = 0; i < PCI_IOV_NUM_BAR; i++) {
+		res = dev->resource + PCI_IOV_RESOURCES + i;
+		pos = iov->cap + PCI_IOV_BAR_0 + i * 4;
+		i += __pci_read_base(dev, pci_bar_unknown, res, pos);
+		if (!res->flags)
+			continue;
+		res->flags &= ~IORESOURCE_SIZEALIGN;
+		res->end = res->start + resource_size(res) * total - 1;
+	}
+
+	mutex_init(&iov->ops_lock);
+	mutex_init(&iov->bus_lock);
+
+	dev->iov = iov;
+
+	return 0;
+}
+
+/**
+ * pci_iov_release - release resources used by SR-IOV capability
+ * @dev: the PCI device
+ */
+void pci_iov_release(struct pci_dev *dev)
+{
+	if (!dev->iov)
+		return;
+
+	mutex_destroy(&dev->iov->ops_lock);
+	mutex_destroy(&dev->iov->bus_lock);
+	kfree(dev->iov);
+	dev->iov = NULL;
+}
+
+/**
+ * pci_iov_create_sysfs - create sysfs for SR-IOV capability
+ * @dev: the PCI device
+ */
+void pci_iov_create_sysfs(struct pci_dev *dev)
+{
+	if (!dev->iov)
+		return;
+
+	sysfs_create_group(&dev->dev.kobj, &iov_attr_group);
+}
+
+/**
+ * pci_iov_remove_sysfs - remove sysfs of SR-IOV capability
+ * @dev: the PCI device
+ */
+void pci_iov_remove_sysfs(struct pci_dev *dev)
+{
+	if (!dev->iov)
+		return;
+
+	sysfs_remove_group(&dev->dev.kobj, &iov_attr_group);
+}
+
+/**
+ * pci_iov_bus_range - find bus range used by SR-IOV capability
+ * @bus: the PCI bus
+ *
+ * Returns max number of buses (exclude current one) used by Virtual
+ * Functions.
+ */
+int pci_iov_bus_range(struct pci_bus *bus)
+{
+	int max = 0;
+	u8 busnr, devfn;
+	struct pci_dev *dev;
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		if (!dev->iov)
+			continue;
+		vf_rid(dev, dev->iov->totalvfs - 1, &busnr, &devfn);
+		if (busnr > max)
+			max = busnr;
+	}
+
+	return max ? max - bus->number : 0;
+}
+
+int pci_iov_resource_align(struct pci_dev *dev, int resno)
+{
+	if (resno < PCI_IOV_RESOURCES || resno > PCI_IOV_RESOURCES_END)
+		return 0;
+
+	BUG_ON(!dev->iov);
+
+	return dev->iov->align;
+}
+
+int pci_iov_resource_bar(struct pci_dev *dev, int resno,
+			 enum pci_bar_type *type)
+{
+	if (resno < PCI_IOV_RESOURCES || resno > PCI_IOV_RESOURCES_END)
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
+ * pci_iov_register - register SR-IOV service
+ * @dev: the PCI device
+ * @callback: callback function for SR-IOV events
+ *
+ * Returns 0 on success, or negative on failure.
+ */
+int pci_iov_register(struct pci_dev *dev,
+		int (*callback)(struct pci_dev *, u32))
+{
+	u8 busnr, devfn;
+	struct pci_iov *iov = dev->iov;
+
+	if (!iov)
+		return -ENODEV;
+
+	if (!callback || iov->callback)
+		return -EINVAL;
+
+	vf_rid(dev, iov->totalvfs - 1, &busnr, &devfn);
+	if (busnr > dev->bus->subordinate)
+		return -EIO;
+
+	iov->callback = callback;
+	return iov_alloc_bus(dev->bus, busnr);
+}
+EXPORT_SYMBOL_GPL(pci_iov_register);
+
+/**
+ * pci_iov_unregister - unregister SR-IOV service
+ * @dev: the PCI device
+ */
+void pci_iov_unregister(struct pci_dev *dev)
+{
+	struct pci_iov *iov = dev->iov;
+
+	if (!iov || !iov->callback)
+		return;
+
+	iov->callback = NULL;
+	iov_release_bus(dev->bus);
+}
+EXPORT_SYMBOL_GPL(pci_iov_unregister);
+
+/**
+ * pci_iov_enable - enable SR-IOV capability
+ * @dev: the PCI device
+ * @numvfs: number of VFs to be available
+ *
+ * Returns 0 on success, or negative on failure.
+ */
+int pci_iov_enable(struct pci_dev *dev, int numvfs)
+{
+	int rc;
+	struct pci_iov *iov = dev->iov;
+
+	if (!iov)
+		return -ENODEV;
+
+	if (!iov->callback)
+		return -EINVAL;
+
+	mutex_lock(&iov->ops_lock);
+	rc = iov_set_numvfs(dev, numvfs);
+	if (rc)
+		goto done;
+	rc = iov_enable(dev);
+done:
+	mutex_unlock(&iov->ops_lock);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(pci_iov_enable);
+
+/**
+ * pci_iov_disable - disable SR-IOV capability
+ * @dev: the PCI device
+ *
+ * Should be called upon Physical Function driver removal, and power
+ * state change. All previous allocated Virtual Functions are reclaimed.
+ */
+void pci_iov_disable(struct pci_dev *dev)
+{
+	struct pci_iov *iov = dev->iov;
+
+	if (!iov || !iov->callback)
+		return;
+
+	mutex_lock(&iov->ops_lock);
+	iov_disable(dev);
+	mutex_unlock(&iov->ops_lock);
+}
+EXPORT_SYMBOL_GPL(pci_iov_disable);
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 5c456ab..18881f2 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -847,6 +847,9 @@ static int pci_create_capabilities_sysfs(struct pci_dev *dev)
 	/* Active State Power Management */
 	pcie_aspm_create_sysfs_dev_files(dev);
 
+	/* Single Root I/O Virtualization */
+	pci_iov_create_sysfs(dev);
+
 	return 0;
 }
 
@@ -932,6 +935,7 @@ static void pci_remove_capabilities_sysfs(struct pci_dev *dev)
 	}
 
 	pcie_aspm_remove_sysfs_dev_files(dev);
+	pci_iov_remove_sysfs(dev);
 }
 
 /**
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 11ecd6f..10a43b2 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1936,6 +1936,13 @@ int pci_resource_alignment(struct pci_dev *dev, int resno)
 	if (align)
 		return align > bios_align ? align : bios_align;
 
+	if (resno > PCI_ROM_RESOURCE && resno < PCI_BRIDGE_RESOURCES) {
+		/* device specific resource */
+		align = pci_iov_resource_align(dev, resno);
+		if (align)
+			return align > bios_align ? align : bios_align;
+	}
+
 	dev_err(&dev->dev, "alignment: invalid resource #%d\n", resno);
 	return 0;
 }
@@ -1950,12 +1957,19 @@ int pci_resource_alignment(struct pci_dev *dev, int resno)
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
index d707477..7735d92 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -181,4 +181,52 @@ static inline int pci_ari_enabled(struct pci_dev *dev)
 	return dev->ari_enabled;
 }
 
+/* Single Root I/O Virtualization */
+struct pci_iov {
+	int cap;		/* capability position */
+	int align;		/* page size used to map memory space */
+	int status;		/* status of SR-IOV */
+	u16 totalvfs;		/* total VFs associated with the PF */
+	u16 initialvfs;		/* initial VFs associated with the PF */
+	u16 numvfs;		/* number of VFs available */
+	u16 offset;		/* first VF Routing ID offset */
+	u16 stride;		/* following VF stride */
+	struct mutex ops_lock;	/* lock for SR-IOV operations */
+	struct mutex bus_lock;	/* lock for VF bus */
+	int (*callback)(struct pci_dev *, u32);	/* event callback function */
+};
+
+#ifdef CONFIG_PCI_IOV
+extern int pci_iov_init(struct pci_dev *dev);
+extern void pci_iov_release(struct pci_dev *dev);
+void pci_iov_create_sysfs(struct pci_dev *dev);
+void pci_iov_remove_sysfs(struct pci_dev *dev);
+extern int pci_iov_resource_align(struct pci_dev *dev, int resno);
+extern int pci_iov_resource_bar(struct pci_dev *dev, int resno,
+				enum pci_bar_type *type);
+#else
+static inline int pci_iov_init(struct pci_dev *dev)
+{
+	return -EIO;
+}
+static inline void pci_iov_release(struct pci_dev *dev)
+{
+}
+static inline void pci_iov_create_sysfs(struct pci_dev *dev)
+{
+}
+static inline void pci_iov_remove_sysfs(struct pci_dev *dev)
+{
+}
+static inline int pci_iov_resource_align(struct pci_dev *dev, int resno)
+{
+	return 0;
+}
+static inline int pci_iov_resource_bar(struct pci_dev *dev, int resno,
+				       enum pci_bar_type *type)
+{
+	return 0;
+}
+#endif /* CONFIG_PCI_IOV */
+
 #endif /* DRIVERS_PCI_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 4b12b58..18ce9c0 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -779,6 +779,7 @@ static int pci_setup_device(struct pci_dev * dev)
 static void pci_release_capabilities(struct pci_dev *dev)
 {
 	pci_vpd_release(dev);
+	pci_iov_release(dev);
 }
 
 /**
@@ -962,6 +963,9 @@ static void pci_init_capabilities(struct pci_dev *dev)
 
 	/* Alternative Routing-ID Forwarding */
 	pci_enable_ari(dev);
+
+	/* Single Root I/O Virtualization */
+	pci_iov_init(dev);
 }
 
 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 80d88f8..e64ffa2 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -87,6 +87,12 @@ enum {
 	/* #6: expansion ROM */
 	PCI_ROM_RESOURCE,
 
+	/* device specific resources */
+#ifdef CONFIG_PCI_IOV
+	PCI_IOV_RESOURCES,
+	PCI_IOV_RESOURCES_END = PCI_IOV_RESOURCES + PCI_IOV_NUM_BAR - 1,
+#endif
+
 	/* address space assigned to buses behind the bridge */
 #ifndef PCI_BRIDGE_RES_NUM
 #define PCI_BRIDGE_RES_NUM 4
@@ -165,6 +171,7 @@ struct pci_cap_saved_state {
 
 struct pcie_link_state;
 struct pci_vpd;
+struct pci_iov;
 
 /*
  * The pci_dev structure is used to describe PCI devices.
@@ -253,6 +260,7 @@ struct pci_dev {
 	struct list_head msi_list;
 #endif
 	struct pci_vpd *vpd;
+	struct pci_iov *iov;
 };
 
 extern struct pci_dev *alloc_pci_dev(void);
@@ -1147,5 +1155,37 @@ static inline void * pci_ioremap_bar(struct pci_dev *pdev, int bar)
 }
 #endif
 
+/* SR-IOV events masks */
+#define PCI_IOV_VIRTFN_ID	0x0000FFFFU	/* Virtual Function Number */
+#define PCI_IOV_NUM_VIRTFN	0x0000FFFFU	/* NumVFs to be set */
+/* SR-IOV events values */
+#define PCI_IOV_ENABLE		0x00010000U	/* SR-IOV enable request */
+#define PCI_IOV_DISABLE		0x00020000U	/* SR-IOV disable request */
+#define PCI_IOV_NUMVFS		0x00040000U	/* SR-IOV disable request */
+
+#ifdef CONFIG_PCI_IOV
+extern int pci_iov_enable(struct pci_dev *dev, int numvfs);
+extern void pci_iov_disable(struct pci_dev *dev);
+extern int pci_iov_register(struct pci_dev *dev,
+	int (*callback)(struct pci_dev *dev, u32 event));
+extern void pci_iov_unregister(struct pci_dev *dev);
+#else
+static inline int pci_iov_enable(struct pci_dev *dev, int numvfs)
+{
+	return -EIO;
+}
+static inline void pci_iov_disable(struct pci_dev *dev)
+{
+}
+static inline int pci_iov_register(struct pci_dev *dev,
+	int (*callback)(struct pci_dev *dev, u32 event))
+{
+	return -EIO;
+}
+static inline void pci_iov_unregister(struct pci_dev *dev)
+{
+}
+#endif /* CONFIG_PCI_IOV */
+
 #endif /* __KERNEL__ */
 #endif /* LINUX_PCI_H */
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index eb6686b..1b28b3f 100644
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
@@ -434,6 +435,7 @@
 #define PCI_EXT_CAP_ID_DSN	3
 #define PCI_EXT_CAP_ID_PWR	4
 #define PCI_EXT_CAP_ID_ARI	14
+#define PCI_EXT_CAP_ID_IOV	16
 
 /* Advanced Error Reporting */
 #define PCI_ERR_UNCOR_STATUS	4	/* Uncorrectable Error Status */
@@ -551,4 +553,23 @@
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

