Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbZBJJGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbZBJJGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 04:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbZBJJEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 04:04:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:4654 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbZBJJDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 04:03:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,185,1233561600"; 
   d="scan'208";a="488749287"
From: Yu Zhao <yu.zhao@intel.com>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v8 4/7] PCI: add SR-IOV API for Physical Function driver
Date: Tue, 10 Feb 2009 16:59:12 +0800
Message-Id: <1234256355-23153-5-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1234256355-23153-1-git-send-email-yu.zhao@intel.com>
References: <1234256355-23153-1-git-send-email-yu.zhao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yu Zhao <yu.zhao@intel.com>
---
 drivers/pci/iov.c   |  336 +++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h   |    3 +
 include/linux/pci.h |   14 ++
 3 files changed, 353 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 1cf13be..d576160 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -10,6 +10,8 @@
 #include <linux/pci.h>
 #include "pci.h"
 
+#define VIRTFN_ID_LEN	8
+
 
 static inline void virtfn_bdf(struct pci_dev *dev, int id, u8 *busnr, u8 *devfn)
 {
@@ -21,6 +23,311 @@ static inline void virtfn_bdf(struct pci_dev *dev, int id, u8 *busnr, u8 *devfn)
 	*devfn = bdf & 0xff;
 }
 
+static struct pci_bus *virtfn_add_bus(struct pci_bus *bus, int busnr)
+{
+	int rc;
+	struct pci_bus *child;
+
+	if (bus->number == busnr)
+		return bus;
+
+	child = pci_find_bus(pci_domain_nr(bus), busnr);
+	if (child)
+		return child;
+
+	child = pci_add_new_bus(bus, NULL, busnr);
+	if (!child)
+		return NULL;
+
+	child->subordinate = busnr;
+	child->dev.parent = bus->bridge;
+	rc = pci_bus_add_child(child);
+	if (rc) {
+		pci_remove_bus(child);
+		return NULL;
+	}
+
+	return child;
+}
+
+static void virtfn_remove_bus(struct pci_bus *bus, int busnr)
+{
+	struct pci_bus *child;
+
+	if (bus->number == busnr)
+		return;
+
+	child = pci_find_bus(pci_domain_nr(bus), busnr);
+	BUG_ON(!child);
+
+	if (list_empty(&child->devices))
+		pci_remove_bus(child);
+}
+
+static int virtfn_add(struct pci_dev *dev, int id, int reset)
+{
+	int i;
+	int rc;
+	u64 size;
+	u8 busnr, devfn;
+	char buf[VIRTFN_ID_LEN];
+	struct pci_dev *virtfn;
+	struct resource *res;
+	struct pci_sriov *iov = dev->sriov;
+
+	virtfn = alloc_pci_dev();
+	if (!virtfn)
+		return -ENOMEM;
+
+	virtfn_bdf(dev, id, &busnr, &devfn);
+	mutex_lock(&iov->pdev->sriov->lock);
+	virtfn->bus = virtfn_add_bus(dev->bus, busnr);
+	if (!virtfn->bus) {
+		kfree(virtfn);
+		mutex_unlock(&iov->pdev->sriov->lock);
+		return -ENOMEM;
+	}
+
+	virtfn->sysdata = dev->bus->sysdata;
+	virtfn->dev.parent = dev->dev.parent;
+	virtfn->dev.bus = dev->dev.bus;
+	virtfn->devfn = devfn;
+	virtfn->hdr_type = PCI_HEADER_TYPE_NORMAL;
+	virtfn->cfg_size = PCI_CFG_SPACE_EXP_SIZE;
+	virtfn->error_state = pci_channel_io_normal;
+	virtfn->current_state = PCI_UNKNOWN;
+	virtfn->is_pcie = 1;
+	virtfn->pcie_type = PCI_EXP_TYPE_ENDPOINT;
+	virtfn->dma_mask = 0xffffffff;
+	virtfn->vendor = dev->vendor;
+	virtfn->subsystem_vendor = dev->subsystem_vendor;
+	virtfn->class = dev->class;
+	pci_read_config_word(dev, iov->pos + PCI_SRIOV_VF_DID, &virtfn->device);
+	pci_read_config_byte(virtfn, PCI_REVISION_ID, &virtfn->revision);
+	pci_read_config_word(virtfn, PCI_SUBSYSTEM_ID,
+			     &virtfn->subsystem_device);
+
+	dev_set_name(&virtfn->dev, "%04x:%02x:%02x.%d",
+		     pci_domain_nr(virtfn->bus), busnr,
+		     PCI_SLOT(devfn), PCI_FUNC(devfn));
+
+	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
+		res = dev->resource + PCI_SRIOV_RESOURCES + i;
+		if (!res->parent)
+			continue;
+		virtfn->resource[i].name = pci_name(virtfn);
+		virtfn->resource[i].flags = res->flags;
+		size = resource_size(res);
+		do_div(size, iov->total);
+		virtfn->resource[i].start = res->start + size * id;
+		virtfn->resource[i].end = virtfn->resource[i].start + size - 1;
+		rc = request_resource(res, &virtfn->resource[i]);
+		BUG_ON(rc);
+	}
+
+	if (reset)
+		pci_execute_reset_function(virtfn);
+
+	pci_device_add(virtfn, virtfn->bus);
+	mutex_unlock(&iov->pdev->sriov->lock);
+
+	virtfn->physfn = pci_dev_get(dev);
+
+	rc = pci_bus_add_device(virtfn);
+	if (rc)
+		goto failed1;
+	sprintf(buf, "%d", id);
+	rc = sysfs_create_link(&iov->dev.kobj, &virtfn->dev.kobj, buf);
+	if (rc)
+		goto failed1;
+	rc = sysfs_create_link(&virtfn->dev.kobj, &dev->dev.kobj, "physfn");
+	if (rc)
+		goto failed2;
+
+	kobject_uevent(&virtfn->dev.kobj, KOBJ_CHANGE);
+
+	return 0;
+
+failed2:
+	sysfs_remove_link(&iov->dev.kobj, buf);
+failed1:
+	pci_dev_put(dev);
+	mutex_lock(&iov->pdev->sriov->lock);
+	pci_remove_bus_device(virtfn);
+	virtfn_remove_bus(dev->bus, busnr);
+	mutex_unlock(&iov->pdev->sriov->lock);
+
+	return rc;
+}
+
+static void virtfn_remove(struct pci_dev *dev, int id, int reset)
+{
+	u8 busnr, devfn;
+	char buf[VIRTFN_ID_LEN];
+	struct pci_bus *bus;
+	struct pci_dev *virtfn;
+	struct pci_sriov *iov = dev->sriov;
+
+	virtfn_bdf(dev, id, &busnr, &devfn);
+	bus = pci_find_bus(pci_domain_nr(dev->bus), busnr);
+	if (!bus)
+		return;
+
+	virtfn = pci_get_slot(bus, devfn);
+	if (!virtfn)
+		return;
+
+	pci_dev_put(virtfn);
+
+	if (reset) {
+		device_release_driver(&virtfn->dev);
+		pci_execute_reset_function(virtfn);
+	}
+
+	sprintf(buf, "%d", id);
+	sysfs_remove_link(&iov->dev.kobj, buf);
+	sysfs_remove_link(&virtfn->dev.kobj, "physfn");
+
+	mutex_lock(&iov->pdev->sriov->lock);
+	pci_remove_bus_device(virtfn);
+	virtfn_remove_bus(dev->bus, busnr);
+	mutex_unlock(&iov->pdev->sriov->lock);
+
+	pci_dev_put(dev);
+}
+
+static void sriov_release_dev(struct device *dev)
+{
+	struct pci_sriov *iov = container_of(dev, struct pci_sriov, dev);
+
+	iov->nr_virtfn = 0;
+}
+
+static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
+{
+	int rc;
+	int i, j;
+	int nres;
+	u8 busnr, devfn;
+	u16 offset, stride, initial;
+	struct resource *res;
+	struct pci_dev *link;
+	struct pci_sriov *iov = dev->sriov;
+
+	if (!nr_virtfn)
+		return 0;
+
+	if (iov->nr_virtfn)
+		return -EINVAL;
+
+	pci_read_config_word(dev, iov->pos + PCI_SRIOV_INITIAL_VF, &initial);
+	if (initial > iov->total ||
+	    (!(iov->cap & PCI_SRIOV_CAP_VFM) && (initial != iov->total)))
+		return -EIO;
+
+	if (nr_virtfn < 0 || nr_virtfn > iov->total ||
+	    (!(iov->cap & PCI_SRIOV_CAP_VFM) && (nr_virtfn > initial)))
+		return -EINVAL;
+
+	pci_write_config_word(dev, iov->pos + PCI_SRIOV_NUM_VF, nr_virtfn);
+	pci_read_config_word(dev, iov->pos + PCI_SRIOV_VF_OFFSET, &offset);
+	pci_read_config_word(dev, iov->pos + PCI_SRIOV_VF_STRIDE, &stride);
+	if (!offset || (nr_virtfn > 1 && !stride))
+		return -EIO;
+
+	nres = 0;
+	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
+		res = dev->resource + PCI_SRIOV_RESOURCES + i;
+		if (!res->parent)
+			continue;
+		nres++;
+	}
+	if (nres != iov->nres)
+		return -ENOMEM;
+
+	iov->offset = offset;
+	iov->stride = stride;
+
+	virtfn_bdf(dev, nr_virtfn - 1, &busnr, &devfn);
+	if (busnr > dev->bus->subordinate) {
+		dev_err(&dev->dev, "no enough bus range for SR-IOV\n");
+		return -EIO;
+	}
+
+	memset(&iov->dev, 0, sizeof(iov->dev));
+	strcpy(iov->dev.bus_id, "virtfn");
+	iov->dev.parent = &dev->dev;
+	iov->dev.release = sriov_release_dev;
+	rc = device_register(&iov->dev);
+	if (rc)
+		return rc;
+
+	if (iov->link != dev->devfn) {
+		rc = -ENODEV;
+		list_for_each_entry(link, &dev->bus->devices, bus_list) {
+			if (link->sriov && link->devfn == iov->link)
+				rc = sysfs_create_link(&iov->dev.kobj,
+						&link->dev.kobj, "dep_link");
+		}
+		if (rc)
+			goto failed1;
+	}
+
+	iov->ctrl |= PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE;
+	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
+	msleep(100);
+
+	iov->initial = initial;
+	if (nr_virtfn < initial)
+		initial = nr_virtfn;
+
+	for (i = 0; i < initial; i++) {
+		rc = virtfn_add(dev, i, 0);
+		if (rc)
+			goto failed2;
+	}
+
+	kobject_uevent(&dev->dev.kobj, KOBJ_CHANGE);
+	iov->nr_virtfn = nr_virtfn;
+
+	return 0;
+
+failed2:
+	for (j = 0; j < i; j++)
+		virtfn_remove(dev, j, 0);
+
+	iov->ctrl &= ~(PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE);
+	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
+	msleep(100);
+
+	if (iov->link != dev->devfn)
+		sysfs_remove_link(&iov->dev.kobj, "dep_link");
+failed1:
+	device_unregister(&iov->dev);
+
+	return rc;
+}
+
+static void sriov_disable(struct pci_dev *dev)
+{
+	int i;
+	struct pci_sriov *iov = dev->sriov;
+
+	if (!iov->nr_virtfn)
+		return;
+
+	for (i = 0; i < iov->nr_virtfn; i++)
+		virtfn_remove(dev, i, 0);
+
+	iov->ctrl &= ~(PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE);
+	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
+	msleep(100);
+
+	if (iov->link != dev->devfn)
+		sysfs_remove_link(&iov->dev.kobj, "dep_link");
+	device_unregister(&iov->dev);
+}
+
 static int sriov_init(struct pci_dev *dev, int pos)
 {
 	int i;
@@ -126,6 +433,8 @@ failed:
 
 static void sriov_release(struct pci_dev *dev)
 {
+	BUG_ON(dev->sriov->nr_virtfn);
+
 	if (dev == dev->sriov->pdev)
 		mutex_destroy(&dev->sriov->lock);
 	else
@@ -145,6 +454,7 @@ static void sriov_restore_state(struct pci_dev *dev)
 		return;
 
 	pci_write_config_dword(dev, iov->pos + PCI_SRIOV_SYS_PGSIZE, iov->pgsz);
+	pci_write_config_word(dev, iov->pos + PCI_SRIOV_NUM_VF, iov->nr_virtfn);
 	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
 	if (iov->ctrl & PCI_SRIOV_CTRL_VFE)
 		msleep(100);
@@ -235,3 +545,29 @@ int pci_iov_bus_range(struct pci_bus *bus)
 
 	return max ? max - bus->number : 0;
 }
+
+/**
+ * pci_enable_sriov - enable the SR-IOV capability
+ * @dev: the PCI device
+ *
+ * Returns 0 on success, or negative on failure.
+ */
+int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn)
+{
+	if (!dev->sriov)
+		return -ENODEV;
+
+	return sriov_enable(dev, nr_virtfn);
+}
+EXPORT_SYMBOL_GPL(pci_enable_sriov);
+
+/**
+ * pci_disable_sriov - disable the SR-IOV capability
+ * @dev: the PCI device
+ */
+void pci_disable_sriov(struct pci_dev *dev)
+{
+	if (dev->sriov)
+		sriov_disable(dev);
+}
+EXPORT_SYMBOL_GPL(pci_disable_sriov);
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index fdfc476..328a611 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -202,6 +202,8 @@ struct pci_sriov {
 	u32 cap;		/* SR-IOV Capabilities */
 	u16 ctrl;		/* SR-IOV Control */
 	u16 total;		/* total VFs associated with the PF */
+	u16 initial;		/* initial VFs associated with the PF */
+	u16 nr_virtfn;		/* number of VFs available */
 	u16 offset;		/* first VF Routing ID offset */
 	u16 stride;		/* following VF stride */
 	u32 pgsz;		/* page size for BAR alignment */
@@ -209,6 +211,7 @@ struct pci_sriov {
 	struct pci_dev *pdev;	/* lowest numbered PF */
 	struct pci_dev *self;	/* this PF */
 	struct mutex lock;	/* lock for VF bus */
+	struct device dev;
 };
 
 #ifdef CONFIG_PCI_IOV
diff --git a/include/linux/pci.h b/include/linux/pci.h
index f4d740e..b14ecf0 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -278,6 +278,7 @@ struct pci_dev {
 #endif
 	struct pci_vpd *vpd;
 	struct pci_sriov *sriov;	/* SR-IOV capability related */
+	struct pci_dev *physfn;	/* Physical Function the device belongs to */
 };
 
 extern struct pci_dev *alloc_pci_dev(void);
@@ -1202,5 +1203,18 @@ int pci_ext_cfg_avail(struct pci_dev *dev);
 
 void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar);
 
+#ifdef CONFIG_PCI_IOV
+extern int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn);
+extern void pci_disable_sriov(struct pci_dev *dev);
+#else
+static inline int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn)
+{
+	return -ENODEV;
+}
+static inline void pci_disable_sriov(struct pci_dev *dev)
+{
+}
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* LINUX_PCI_H */
-- 
1.5.6.4

