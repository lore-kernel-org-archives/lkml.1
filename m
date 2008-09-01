Return-Path: <linux-kernel-owner+w=401wt.eu-S1759882AbYIALWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759882AbYIALWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759139AbYIALVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:21:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:9651 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759066AbYIALVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:21:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,307,1217833200"; 
   d="scan'208";a="40044578"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH 3/4 v2] PCI: support SR-IOV capability
Date: Mon, 1 Sep 2008 19:21:01 +0800
Message-ID: <7A25B56E4BE99C4283EB931CD1A40E110177EB6F@pdsmsx414.ccr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/4 v2] PCI: support SR-IOV capability
Thread-Index: AckMJNCM+efmWjatQuyQXKMG0x7/jw==
From: "Zhao, Yu" <yu.zhao@intel.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>, <linux-pci@vger.kernel.org>
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>, "Greg KH" <greg@kroah.com>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "Matthew Wilcox" <matthew@wil.cx>, <linux-kernel@vger.kernel.org>,
       <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
       <xen-devel@lists.xensource.com>
X-OriginalArrivalTime: 01 Sep 2008 11:21:04.0363 (UTC) FILETIME=[D250B3B0:01C90C24]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support SR-IOV capability. By default, this feature is not enabled and the SR-IOV device behaves as traditional PCI device. After it's enabled, each Virtual Function's PCI configuration space can be accessed using its own Bus, Device and Function Number (Routing ID). Each Virtual Function also has PCI Memory Space, which is used to map its own register set.

Signed-off-by: Yu Zhao <yu.zhao@intel.com>
Signed-off-by: Eddie Dong <eddie.dong@intel.com>

---
 drivers/pci/Kconfig      |   10 +
 drivers/pci/Makefile     |    2 +
 drivers/pci/iov.c        |  555 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.c        |   14 +-
 drivers/pci/pci.h        |   44 ++++
 drivers/pci/probe.c      |    5 +
 include/linux/pci.h      |   28 +++
 include/linux/pci_regs.h |   20 ++
 8 files changed, 677 insertions(+), 1 deletions(-)
 create mode 100644 drivers/pci/iov.c

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index f43cc46..0a1fe01 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -57,3 +57,13 @@ config PCI_ARI
 	default n
 	help
 	  This enables PCI Alternative Routing-ID Interpretation.
+
+config PCI_IOV
+	bool "PCI SR-IOV support"
+	depends on PCI && HOTPLUG
+	select PCI_MSI
+	select PCI_ARI
+	select HOTPLUG_PCI
+	default n
+	help
+	  This allows device drivers to enable Single Root I/O Virtualization.
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 96f2767..2dcefce 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -55,3 +55,5 @@ EXTRA_CFLAGS += -DDEBUG
 endif
 
 obj-$(CONFIG_PCI_ARI) += ari.o
+
+obj-$(CONFIG_PCI_IOV) += iov.o
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
new file mode 100644
index 0000000..0656655
--- /dev/null
+++ b/drivers/pci/iov.c
@@ -0,0 +1,555 @@
+/*
+ * drivers/pci/iov.c
+ *
+ * Copyright (C) 2008 Intel Corporation, Yu Zhao <yu.zhao@intel.com>
+ *
+ * PCI Express Single Root I/O Virtualization capability support.
+ */
+
+#include <linux/ctype.h>
+#include <linux/string.h>
+#include <linux/pci.h>
+#include <linux/pci_hotplug.h>
+#include <linux/delay.h>
+#include <asm/page.h>
+
+#include "pci.h"
+
+
+#define PCI_IOV_SLOTNAME_LEN	24
+
+#define notify(dev, event, id, param) ({ \
+	dev->iov->cb ? dev->iov->cb(dev, event, id, param) : 0; \
+})
+
+
+struct virtfn_slot {
+	int id;
+	char name[PCI_IOV_SLOTNAME_LEN];
+	struct pci_dev *dev;
+	struct list_head node;
+	struct hotplug_slot *slot;
+};
+
+static int enable_virtfn(struct hotplug_slot *);
+static int disable_virtfn(struct hotplug_slot *);
+static int set_virtfn_param(struct hotplug_slot *, const char *, int);
+static int get_virtfn_param(struct hotplug_slot *, const char **);
+
+static struct hotplug_slot_ops virtfn_slot_ops = {
+	.owner			= THIS_MODULE,
+	.enable_slot		= enable_virtfn,
+	.disable_slot		= disable_virtfn,
+	.set_param		= set_virtfn_param,
+	.get_param		= get_virtfn_param
+};
+
+static DEFINE_MUTEX(iov_lock);
+
+
+static inline void get_addr(struct pci_dev *dev, int id, u8 *busnr, u8 *devfn)
+{
+	u16 addr;
+
+	addr = (dev->bus->number << 8) + dev->devfn +
+	      dev->iov->offset + dev->iov->stride * id;
+	*busnr = addr >> 8;
+	*devfn = addr & 0xff;
+}
+
+static inline struct pci_bus *find_bus(struct pci_dev *dev, int busnr)
+{
+	struct pci_bus *bus;
+
+	down_read(&pci_bus_sem);
+	list_for_each_entry(bus, &dev->bus->children, node)
+		if (bus->number == busnr) {
+			up_read(&pci_bus_sem);
+			return bus;
+		}
+	up_read(&pci_bus_sem);
+
+	return NULL;
+}
+
+static int alloc_virtfn(struct pci_dev *dev, int id)
+{
+	int i;
+	int rc;
+	u8 busnr, devfn;
+	unsigned long size;
+	struct pci_dev *new;
+	struct pci_bus *bus;
+	struct resource *res;
+
+	get_addr(dev, id, &busnr, &devfn);
+
+	new = alloc_pci_dev();
+	if (!new)
+		return -ENOMEM;
+
+	bus = find_bus(dev, busnr);
+	BUG_ON(!bus);
+	new->bus = bus;
+	new->sysdata = bus->sysdata;
+	new->dev.parent = dev->dev.parent;
+	new->dev.bus = dev->dev.bus;
+	new->devfn = devfn;
+	new->hdr_type = PCI_HEADER_TYPE_NORMAL;
+	new->multifunction = 0;
+	new->vendor = dev->vendor;
+	pci_read_config_word(dev, dev->iov->cap + PCI_IOV_VF_DID, &new->device);
+	new->cfg_size = 4096;
+	new->error_state = pci_channel_io_normal;
+	new->pcie_type = PCI_EXP_TYPE_ENDPOINT;
+	new->dma_mask = 0xffffffff;
+
+	dev_set_name(&new->dev, "%04x:%02x:%02x.%d", pci_domain_nr(bus),
+		     busnr, PCI_SLOT(devfn), PCI_FUNC(devfn));
+
+	pci_read_config_byte(new, PCI_REVISION_ID, &new->revision);
+	new->class = dev->class;
+	new->current_state = PCI_UNKNOWN;
+	new->irq = 0;
+
+	for (i = 0; i < PCI_IOV_NUM_BAR; i++) {
+		res = dev->resource + PCI_IOV_RESOURCES + i;
+		if (!res->parent)
+			continue;
+		new->resource[i].name = pci_name(new);
+		new->resource[i].flags = res->flags;
+		size = resource_size(res) / dev->iov->total;
+		new->resource[i].start = res->start + size * id;
+		new->resource[i].end = new->resource[i].start + size - 1;
+		rc = request_resource(res, &new->resource[i]);
+		BUG_ON(rc);
+	}
+
+	new->subsystem_vendor = dev->subsystem_vendor;
+	pci_read_config_word(new, PCI_SUBSYSTEM_ID, &new->subsystem_device);
+
+	pci_device_add(new, bus);
+	return pci_bus_add_device(new);
+}
+
+static int enable_virtfn(struct hotplug_slot *slot)
+{
+	int rc;
+	u8 busnr, devfn;
+	struct pci_dev *dev;
+	struct virtfn_slot *vslot = slot->private;
+
+	get_addr(vslot->dev, vslot->id, &busnr, &devfn);
+
+	mutex_lock(&iov_lock);
+	dev = pci_get_bus_and_slot(busnr, devfn);
+	if (dev) {
+		pci_dev_put(dev);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	rc = notify(vslot->dev, PCI_IOV_VF_ENABLE,
+		     vslot->id, vslot->slot->info->param);
+	if (rc)
+		goto out;
+
+	rc = alloc_virtfn(vslot->dev, vslot->id);
+	if (!rc)
+		slot->info->power_status = 1;
+out:
+	mutex_unlock(&iov_lock);
+
+	return rc;
+}
+
+static int disable_virtfn(struct hotplug_slot *slot)
+{
+	int rc;
+	u8 busnr, devfn;
+	struct pci_dev *dev;
+	struct virtfn_slot *vslot = slot->private;
+
+	get_addr(vslot->dev, vslot->id, &busnr, &devfn);
+
+	mutex_lock(&iov_lock);
+	dev = pci_get_bus_and_slot(busnr, devfn);
+	if (!dev) {
+		rc = -ENODEV;
+		goto out;
+	}
+
+	pci_dev_put(dev);
+	pci_remove_bus_device(dev);
+	rc = notify(vslot->dev, PCI_IOV_VF_DISABLE, vslot->id, NULL);
+	slot->info->power_status = 0;
+out:
+	mutex_unlock(&iov_lock);
+
+	return rc;
+}
+
+static int set_virtfn_param(struct hotplug_slot *slot, const char *buf, int len)
+{
+	int rc;
+	struct virtfn_slot *vslot = slot->private;
+
+	if (len > PCI_IOV_PARAM_LEN)
+		return -E2BIG;
+
+	strcpy(slot->info->param, buf);
+	rc = notify(vslot->dev, PCI_IOV_VF_SETPARAM,
+		     vslot->id, vslot->slot->info->param);
+	if (rc)
+		memset(slot->info->param, 0, PCI_IOV_PARAM_LEN);
+
+	return rc;
+}
+
+static int get_virtfn_param(struct hotplug_slot *slot, const char **param)
+{
+	int rc;
+	struct virtfn_slot *vslot = slot->private;
+
+	rc = notify(vslot->dev, PCI_IOV_VF_GETPARAM,
+		     vslot->id, vslot->slot->info->param);
+	if (!rc)
+		*param = slot->info->param;
+
+	return rc;
+}
+
+static void remove_slot(struct hotplug_slot *slot)
+{
+	struct virtfn_slot *vslot = slot->private;
+
+	disable_virtfn(slot);
+	pci_dev_put(vslot->dev);
+	list_del(&vslot->node);
+	kfree(slot->info->param);
+	kfree(slot->info);
+	kfree(slot);
+	kfree(vslot);
+}
+
+static int add_slot(struct pci_dev *dev, int id)
+{
+	int rc = -ENOMEM;
+	u8 busnr, devfn;
+	struct pci_bus *bus;
+	struct hotplug_slot *slot;
+	struct virtfn_slot *vslot;
+
+	slot = kzalloc(sizeof(*slot), GFP_KERNEL);
+	if (!slot)
+		return rc;
+
+	slot->info = kzalloc(sizeof(*slot->info), GFP_KERNEL);
+	if (!slot->info)
+		goto failed1;
+
+	slot->info->param = kzalloc(PCI_IOV_PARAM_LEN, GFP_KERNEL);
+	if (!slot->info)
+		goto failed2;
+
+	vslot = kzalloc(sizeof(*vslot), GFP_KERNEL);
+	if (!vslot)
+		goto failed3;
+
+	slot->name = vslot->name;
+	sprintf(slot->name, "%s-iov-%04x", pci_name(dev), id);
+	slot->ops = &virtfn_slot_ops;
+	slot->release = &remove_slot;
+	slot->private = vslot;
+	vslot->id = id;
+	vslot->dev = pci_dev_get(dev);
+	vslot->slot = slot;
+
+	get_addr(dev, id, &busnr, &devfn);
+	bus = find_bus(dev, busnr);
+	BUG_ON(!bus);
+
+	/* use device and function # as slot # */
+	rc = pci_hp_register(slot, bus, devfn);
+	if (rc)
+		goto failed4;
+
+	list_add(&vslot->node, &dev->iov->slot);
+
+	return 0;
+
+failed4:
+	kfree(vslot);
+failed3:
+	kfree(slot->info->param);
+failed2:
+	kfree(slot->info);
+failed1:
+	kfree(slot);
+
+	return rc;
+}
+
+/**
+ * pci_iov_init - initialize device's SR-IOV capability
+ * @dev: the PCI device
+ *
+ * Returns 0 on success, or negative on failure.
+ *
+ * The major differences between Virtual Function and PCI device are:
+ * 1) the device uses internal switch to route Type 1 configuration
+ *    transaction to Virtual Functions when they resides on a different
+ *    bus from Physical Function, so there is no explicit bridge device
+ *    in this case.
+ * 2) BARs encapsulated in the capability structure only describes the
+ *    memory apertures required for each Virtual Functions, so we need
+ *    to multiply them by the number of Virtual Functions to determine
+ *    the total amount of space.
+ */
+int pci_iov_init(struct pci_dev *dev)
+{
+	int i;
+	int pos;
+	u32 pgsz;
+	u16 ctrl, total, offset, stride;
+	struct pci_iov *iov;
+	struct resource *res;
+
+	if (dev->pcie_type != PCI_EXP_TYPE_ENDPOINT)
+		return -ENODEV;
+
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_IOV);
+	if (!pos)
+		return -ENODEV;
+
+	ctrl = pci_ari_fwd_enabled(dev) ? PCI_IOV_CTRL_ARI : 0;
+	pci_write_config_word(dev, pos + PCI_IOV_CTRL, ctrl);
+	ssleep(1);
+
+	pci_read_config_word(dev, pos + PCI_IOV_INITIAL_VF, &total);
+	pci_write_config_word(dev, pos + PCI_IOV_NUM_VF, total);
+	pci_read_config_word(dev, pos + PCI_IOV_VF_OFFSET, &offset);
+	pci_read_config_word(dev, pos + PCI_IOV_VF_STRIDE, &stride);
+	if (!total || !offset || (total > 1 && !stride))
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
+	iov->offset = offset;
+	iov->stride = stride;
+	iov->align = pgsz << 12;
+	iov->maxbus = (dev->devfn + offset + stride * (total - 1)) >> 8;
+
+	for (i = 0; i < PCI_IOV_NUM_BAR; i++) {
+		res = dev->resource + PCI_IOV_RESOURCES + i;
+		pos = iov->cap + PCI_IOV_BAR_0 + i * 4;
+		i += pci_read_base(dev, pci_bar_unknown, res, pos);
+		if (!res->flags)
+			continue;
+		res->flags &= ~IORESOURCE_SIZEALIGN;
+		res->end = res->start + resource_size(res) * total - 1;
+	}
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
+	int i;
+	struct resource *res;
+	struct pci_dev *tmp;
+	struct pci_bus *bus;
+
+	if (!dev->iov)
+		return;
+
+	for (i = 0; i < PCI_IOV_NUM_BAR; i++) {
+		res = dev->resource + PCI_IOV_RESOURCES + i;
+		if (res->parent)
+			release_resource(res);
+	}
+
+	mutex_lock(&iov_lock);
+	down_read(&pci_bus_sem);
+	list_for_each_entry(tmp, &dev->bus->devices, bus_list)
+		if (tmp->iov) {
+			up_read(&pci_bus_sem);
+			goto done;
+		}
+	up_read(&pci_bus_sem);
+
+	for (i = 1; i <= dev->iov->maxbus; i++) {
+		bus = find_bus(dev, dev->bus->number + i);
+		if (!bus)
+			break;
+		pci_remove_bus(bus);
+		kfree(bus);
+	}
+done:
+	mutex_unlock(&iov_lock);
+
+	kfree(dev->iov);
+	dev->iov = NULL;
+}
+
+/**
+ * pci_iov_bus_range - find bus requirement from SR-IOV capability
+ * @bus: the PCI bus
+ *
+ * Returns max number of buses (exclude current bus) used by all Virtual
+ * Functions on a bus.
+ */
+int pci_iov_bus_range(struct pci_bus *bus)
+{
+	int i;
+	int max = 0;
+	struct pci_dev *dev;
+	struct pci_bus *child;
+
+	down_read(&pci_bus_sem);
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		if (!dev->iov)
+			continue;
+		if (dev->iov->maxbus > max)
+			max = dev->iov->maxbus;
+	}
+	up_read(&pci_bus_sem);
+
+	for (i = 1; i <= max; i++) {
+		child = pci_add_new_bus(bus, NULL, bus->number + i);
+		if (!child)
+			goto failed;
+		child->dev.parent = bus->bridge;
+		child->subordinate = bus->number + i;
+	}
+
+	down_read(&pci_bus_sem);
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		if (!dev->iov)
+			continue;
+		dev->iov->maxbus = max;
+	}
+	up_read(&pci_bus_sem);
+
+	return max;
+
+failed:
+	for (i = 1; i <= max; i++) {
+		child = find_bus(dev, dev->bus->number + i);
+		if (!child)
+			break;
+		down_write(&pci_bus_sem);
+		list_del(&child->node);
+		up_write(&pci_bus_sem);
+		kfree(child);
+	}
+
+	kfree(dev->iov);
+	dev->iov = NULL;
+
+	return 0;
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
+	       4 * (resno - PCI_IOV_RESOURCES);
+}
+
+/**
+ * pci_iov_enable - enable device's SR-IOV capability
+ * @dev: the PCI device
+ * @cb: callback used to notify Physical Function driver
+ *
+ * Returns 0 on success, or negative on failure.
+ */
+int pci_iov_enable(struct pci_dev *dev,
+		   int (*cb)(struct pci_dev *, int, int, char *))
+{
+	int i;
+	int rc;
+	u16 ctrl;
+
+	if (!dev->iov)
+		return -ENODEV;
+
+	pci_read_config_word(dev, dev->iov->cap + PCI_IOV_CTRL, &ctrl);
+	ctrl |= (PCI_IOV_CTRL_VFE | PCI_IOV_CTRL_MSE);
+	pci_write_config_word(dev, dev->iov->cap + PCI_IOV_CTRL, ctrl);
+	ssleep(1);
+
+	INIT_LIST_HEAD(&dev->iov->slot);
+
+	dev->iov->cb = cb;
+	for (i = 0; i < dev->iov->total; i++) {
+		rc = add_slot(dev, i);
+		if (rc)
+			return rc;
+	}
+
+	dev_info(&dev->dev, "IOV is enabled\n");
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_iov_enable);
+
+/**
+ * pci_iov_disable - disable device's SR-IOV capability
+ * @dev: the PCI device
+ *
+ * Should be called upon Physical Function driver removal, and power
+ * state change. All previous allocated Virtual Functions are reclaimed.
+ */
+void pci_iov_disable(struct pci_dev *dev)
+{
+	u16 ctrl;
+	struct virtfn_slot *vslot, *next;
+
+	BUG_ON(!dev->iov);
+
+	dev->iov->cb = NULL;
+	list_for_each_entry_safe(vslot, next, &dev->iov->slot, node)
+		pci_hp_deregister(vslot->slot);
+
+	pci_read_config_word(dev, dev->iov->cap + PCI_IOV_CTRL, &ctrl);
+	ctrl &= ~(PCI_IOV_CTRL_VFE | PCI_IOV_CTRL_MSE);
+	pci_write_config_word(dev, dev->iov->cap + PCI_IOV_CTRL, ctrl);
+	ssleep(1);
+}
+EXPORT_SYMBOL_GPL(pci_iov_disable);
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index bc4b6d0..cd651e0 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1867,7 +1867,12 @@ int pci_resource_alignment(struct pci_dev *dev, int resno)
 
 	if (resno <= PCI_ROM_RESOURCE)
 		return resource_size(res);
-	else if (resno <= PCI_BRIDGE_RES_END)
+	else if (resno < PCI_BRIDGE_RESOURCES) {
+		/* may be device specific resource */
+		align = pci_iov_resource_align(dev, resno);
+		if (align)
+			return align;
+	} else if (resno <= PCI_BRIDGE_RES_END)
 		return res->start;
 
 	dev_err(&dev->dev, "alignment: invalid resource #: %d\n", resno);
@@ -1884,12 +1889,19 @@ int pci_resource_alignment(struct pci_dev *dev, int resno)
  */
 int pci_resource_bar(struct pci_dev *dev, int resno, enum pci_bar_type *type)
 {
+	int reg;
+
 	if (resno < PCI_ROM_RESOURCE) {
 		*type = pci_bar_unknown;
 		return PCI_BASE_ADDRESS_0 + 4 * resno;
 	} else if (resno == PCI_ROM_RESOURCE) {
 		*type = pci_bar_rom;
 		return dev->rom_base_reg;
+	} else if (resno < PCI_BRIDGE_RESOURCES) {
+		/* may be device specific resource */
+		reg = pci_iov_resource_bar(dev, resno, type);
+		if (reg)
+			return reg;
 	}
 
 	dev_err(&dev->dev, "BAR: invalid resource #: %d\n", resno);
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 720a607..07ac992 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -155,3 +155,47 @@ static inline void pci_ari_enable_fwd(struct pci_dev *dev)
 {
 }
 #endif /* CONFIG_PCI_ARI */
+
+/* Single Root I/O Virtualization */
+#define PCI_IOV_PARAM_LEN	64
+
+struct pci_iov {
+	int cap;		/* capability position */
+	int align;		/* page size used to map memory space */
+	int maxbus;		/* max number of buses required by VFs */
+	u16 total;		/* number of VFs associated with the PF */
+	u16 offset;		/* first VF Routing ID offset */
+	u16 stride;		/* following VF stride */
+	struct list_head slot;	/* list of VF slots */
+	int (*cb)(struct pci_dev *, int, int, char *);	/* event callback */
+};
+
+#ifdef CONFIG_PCI_IOV
+extern int pci_iov_init(struct pci_dev *dev);
+extern void pci_iov_release(struct pci_dev *dev);
+extern int pci_iov_bus_range(struct pci_bus *bus);
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
+extern inline int pci_iov_bus_range(struct pci_bus *bus)
+{
+	return 0;
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
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index ad7ad35..74b2255 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -850,6 +850,7 @@ static void pci_release_dev(struct device *dev)
 
 	pci_dev = to_pci_dev(dev);
 	pci_vpd_release(pci_dev);
+	pci_iov_release(pci_dev);
 	kfree(pci_dev);
 }
 
@@ -999,6 +1000,7 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
 	}
 
 	pci_vpd_pci22_init(dev);
+	pci_iov_init(dev);
 
 	return dev;
 }
@@ -1106,6 +1108,9 @@ unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
 	for (devfn = 0; devfn < 0x100; devfn += 8)
 		pci_scan_slot(bus, devfn);
 
+	/* Reserve buses for SR-IOV capability. */
+	max += pci_iov_bus_range(bus);
+
 	/*
 	 * After performing arch-dependent fixup of the bus, look behind
 	 * all PCI-to-PCI bridges on this bus.
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 8ed7405..16d55e9 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -86,6 +86,12 @@ enum {
 	/* expansion ROM */
 	PCI_ROM_RESOURCE = 6,
 
+	/* device specific resources */
+#ifdef CONFIG_PCI_IOV
+	PCI_IOV_RESOURCES,
+	PCI_IOV_RESOURCES_END = PCI_IOV_RESOURCES + PCI_IOV_NUM_BAR - 1,
+#endif
+
 	/* address space assigned to buses behind the bridge */
 #ifndef PCI_BRIDGE_NUM_RES 
 #define PCI_BRIDGE_NUM_RES 4
@@ -164,6 +170,7 @@ struct pci_cap_saved_state {
 
 struct pcie_link_state;
 struct pci_vpd;
+struct pci_iov;
 
 /*
  * The pci_dev structure is used to describe PCI devices.
@@ -252,6 +259,7 @@ struct pci_dev {
 	struct list_head msi_list;
 #endif
 	struct pci_vpd *vpd;
+	struct pci_iov *iov;
 };
 
 extern struct pci_dev *alloc_pci_dev(void);
@@ -1162,5 +1170,25 @@ static inline int pci_ari_next_fn(struct pci_dev *dev)
 }
 #endif /* CONFIG_PCI_ARI */
 
+#define PCI_IOV_VF_ENABLE	0x01U	/* VF enable request */
+#define PCI_IOV_VF_DISABLE	0x02U	/* VF disable request */
+#define PCI_IOV_VF_GETPARAM	0x03U	/* get VF parameter */
+#define PCI_IOV_VF_SETPARAM	0x04U	/* set VF parameter */
+
+#ifdef CONFIG_PCI_IOV
+extern int pci_iov_enable(struct pci_dev *dev,
+			  int (*notify)(struct pci_dev *, int, int, char *));
+extern void pci_iov_disable(struct pci_dev *dev);
+#else
+static inline int pci_iov_enable(struct pci_dev *dev,
+			  int (*notify)(struct pci_dev *, int, int, char *))
+{
+	return -EIO;
+}
+static inline void pci_iov_disable(struct pci_dev *dev)
+{
+}
+#endif /* CONFIG_PCI_IOV */
+
 #endif /* __KERNEL__ */
 #endif /* LINUX_PCI_H */
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index eb6686b..c97c5f2 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -434,6 +434,7 @@
 #define PCI_EXT_CAP_ID_DSN	3
 #define PCI_EXT_CAP_ID_PWR	4
 #define PCI_EXT_CAP_ID_ARI	14
+#define PCI_EXT_CAP_ID_IOV	16
 
 /* Advanced Error Reporting */
 #define PCI_ERR_UNCOR_STATUS	4	/* Uncorrectable Error Status */
@@ -551,4 +552,23 @@
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

