Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbYI0I3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbYI0I3U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 04:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbYI0I22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 04:28:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:35218 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbYI0I2U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 04:28:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,319,1220252400"; 
   d="scan'208";a="620952190"
From: "Zhao, Yu" <yu.zhao@intel.com>
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Alex Chiang <achiang@hp.com>, Matthew Wilcox <matthew@wil.cx>,
       Roland Dreier <rdreier@cisco.com>, Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Date: Sat, 27 Sep 2008 16:28:15 +0800
Subject: [PATCH 4/6 v3] PCI: support SR-IOV capability
Thread-Topic: [PATCH 4/6 v3] PCI: support SR-IOV capability
Thread-Index: AckgevyELelqC5YlQ2SoMzP9Y8CaaA==
Message-ID: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F4@pdsmsx502.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Single Root I/O Virtualization (SR-IOV) support.

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
 drivers/pci/iov.c        |  850 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci-sysfs.c  |    4 +
 drivers/pci/pci.c        |   14 +-
 drivers/pci/pci.h        |   55 +++
 drivers/pci/probe.c      |    4 +
 include/linux/pci.h      |   57 +++
 include/linux/pci_regs.h |   21 ++
 9 files changed, 1018 insertions(+), 1 deletions(-)
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
+       bool "PCI SR-IOV support"
+       depends on PCI
+       select PCI_MSI
+       default n
+       help
+         This option allows device drivers to enable Single Root I/O
+         Virtualization. Each Virtual Function's PCI configuration
+         space can be accessed using its own Bus, Device and Function
+         Number (Routing ID). Each Virtual Function also has PCI Memory
+         Space, which is used to map its own register set.
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 7d63f8c..47bb456 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -53,3 +53,5 @@ obj-$(CONFIG_PCI_SYSCALL) += syscall.o
 ifeq ($(CONFIG_PCI_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
 endif
+
+obj-$(CONFIG_PCI_IOV) += iov.o
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
new file mode 100644
index 0000000..a2b2de9
--- /dev/null
+++ b/drivers/pci/iov.c
@@ -0,0 +1,850 @@
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
+#define VF_NAME_LEN    8
+
+
+struct iov_attr {
+       struct attribute attr;
+       ssize_t (*show)(struct kobject *,
+                       struct iov_attr *, char *);
+       ssize_t (*store)(struct kobject *,
+                       struct iov_attr *, const char *, size_t);
+};
+
+#define iov_config_attr(field)                                         \
+static ssize_t field##_show(struct kobject *kobj,                      \
+               struct iov_attr *attr, char *buf)                       \
+{                                                                      \
+       struct pci_iov *iov = container_of(kobj, struct pci_iov, kobj); \
+                                                                       \
+       return sprintf(buf, "%d\n", iov->field);                        \
+}
+
+iov_config_attr(is_enabled);
+iov_config_attr(totalvfs);
+iov_config_attr(initialvfs);
+iov_config_attr(numvfs);
+
+struct vf_entry {
+       int vfn;
+       struct kobject kobj;
+       struct pci_iov *iov;
+       struct iov_attr *attr;
+       char name[VF_NAME_LEN];
+       char (*param)[PCI_IOV_PARAM_LEN];
+};
+
+static ssize_t iov_attr_show(struct kobject *kobj,
+               struct attribute *attr, char *buf)
+{
+       struct iov_attr *ia = container_of(attr, struct iov_attr, attr);
+
+       return ia->show ? ia->show(kobj, ia, buf) : -EIO;
+}
+
+static ssize_t iov_attr_store(struct kobject *kobj,
+               struct attribute *attr, const char *buf, size_t len)
+{
+       struct iov_attr *ia = container_of(attr, struct iov_attr, attr);
+
+       return ia->store ? ia->store(kobj, ia, buf, len) : -EIO;
+}
+
+static struct sysfs_ops iov_attr_ops = {
+       .show = iov_attr_show,
+       .store = iov_attr_store,
+};
+
+static struct kobj_type iov_ktype = {
+       .sysfs_ops = &iov_attr_ops,
+};
+
+static inline void vf_rid(struct pci_dev *dev, int vfn, u8 *busnr, u8 *devfn)
+{
+       u16 rid;
+
+       rid = (dev->bus->number << 8) + dev->devfn +
+               dev->iov->offset + dev->iov->stride * vfn;
+       *busnr = rid >> 8;
+       *devfn = rid & 0xff;
+}
+
+static int vf_add(struct pci_dev *dev, int vfn)
+{
+       int i;
+       int rc;
+       u8 busnr, devfn;
+       unsigned long size;
+       struct pci_dev *new;
+       struct pci_bus *bus;
+       struct resource *res;
+
+       vf_rid(dev, vfn, &busnr, &devfn);
+
+       new = alloc_pci_dev();
+       if (!new)
+               return -ENOMEM;
+
+       list_for_each_entry(bus, &dev->bus->children, node)
+               if (bus->number == busnr) {
+                       new->bus = bus;
+                       break;
+               }
+
+       BUG_ON(!new->bus);
+       new->sysdata = bus->sysdata;
+       new->dev.parent = dev->dev.parent;
+       new->dev.bus = dev->dev.bus;
+       new->devfn = devfn;
+       new->hdr_type = PCI_HEADER_TYPE_NORMAL;
+       new->multifunction = 0;
+       new->vendor = dev->vendor;
+       pci_read_config_word(dev, dev->iov->cap + PCI_IOV_VF_DID, &new->device);
+       new->cfg_size = PCI_CFG_SPACE_EXP_SIZE;
+       new->error_state = pci_channel_io_normal;
+       new->is_pcie = 1;
+       new->pcie_type = PCI_EXP_TYPE_ENDPOINT;
+       new->dma_mask = 0xffffffff;
+
+       dev_set_name(&new->dev, "%04x:%02x:%02x.%d", pci_domain_nr(bus),
+                    busnr, PCI_SLOT(devfn), PCI_FUNC(devfn));
+
+       pci_read_config_byte(new, PCI_REVISION_ID, &new->revision);
+       new->class = dev->class;
+       new->current_state = PCI_UNKNOWN;
+       new->irq = 0;
+
+       for (i = 0; i < PCI_IOV_NUM_BAR; i++) {
+               res = dev->resource + PCI_IOV_RESOURCES + i;
+               if (!res->parent)
+                       continue;
+               new->resource[i].name = pci_name(new);
+               new->resource[i].flags = res->flags;
+               size = resource_size(res) / dev->iov->totalvfs;
+               new->resource[i].start = res->start + size * vfn;
+               new->resource[i].end = new->resource[i].start + size - 1;
+               rc = request_resource(res, &new->resource[i]);
+               BUG_ON(rc);
+       }
+
+       new->subsystem_vendor = dev->subsystem_vendor;
+       pci_read_config_word(new, PCI_SUBSYSTEM_ID, &new->subsystem_device);
+
+       pci_device_add(new, bus);
+       return pci_bus_add_device(new);
+}
+
+static void vf_remove(struct pci_dev *dev, int vfn)
+{
+       u8 busnr, devfn;
+       struct pci_dev *tmp;
+
+       vf_rid(dev, vfn, &busnr, &devfn);
+
+       tmp = pci_get_bus_and_slot(busnr, devfn);
+       if (!tmp)
+               return;
+
+       pci_dev_put(tmp);
+       pci_remove_bus_device(tmp);
+}
+
+static int iov_enable(struct pci_iov *iov)
+{
+       int rc;
+       int i, j;
+       u16 ctrl;
+
+       if (!iov->notify)
+               return -ENODEV;
+
+       if (iov->is_enabled)
+               return 0;
+
+       iov->notify(iov->dev, iov->numvfs | PCI_IOV_ENABLE);
+       pci_read_config_word(iov->dev, iov->cap + PCI_IOV_CTRL, &ctrl);
+       ctrl |= (PCI_IOV_CTRL_VFE | PCI_IOV_CTRL_MSE);
+       pci_write_config_word(iov->dev, iov->cap + PCI_IOV_CTRL, ctrl);
+       ssleep(1);
+
+       for (i = 0; i < iov->numvfs; i++) {
+               rc = vf_add(iov->dev, i);
+               if (rc)
+                       goto failed;
+       }
+
+       iov->notify(iov->dev, iov->numvfs |
+                               PCI_IOV_ENABLE | PCI_IOV_POST_EVENT);
+       iov->is_enabled = 1;
+       return 0;
+
+failed:
+       for (j = 0; j < i; j++)
+               vf_remove(iov->dev, j);
+
+       pci_read_config_word(iov->dev, iov->cap + PCI_IOV_CTRL, &ctrl);
+       ctrl &= ~(PCI_IOV_CTRL_VFE | PCI_IOV_CTRL_MSE);
+       pci_write_config_word(iov->dev, iov->cap + PCI_IOV_CTRL, ctrl);
+       ssleep(1);
+
+       return rc;
+}
+
+static int iov_disable(struct pci_iov *iov)
+{
+       int i;
+       u16 ctrl;
+
+       if (!iov->notify)
+               return -ENODEV;
+
+       if (!iov->is_enabled)
+               return 0;
+
+       iov->notify(iov->dev, PCI_IOV_DISABLE);
+       for (i = 0; i < iov->numvfs; i++)
+               vf_remove(iov->dev, i);
+
+       pci_read_config_word(iov->dev, iov->cap + PCI_IOV_CTRL, &ctrl);
+       ctrl &= ~(PCI_IOV_CTRL_VFE | PCI_IOV_CTRL_MSE);
+       pci_write_config_word(iov->dev, iov->cap + PCI_IOV_CTRL, ctrl);
+       ssleep(1);
+
+       iov->notify(iov->dev, PCI_IOV_DISABLE | PCI_IOV_POST_EVENT);
+       iov->is_enabled = 0;
+       return 0;
+}
+
+static int iov_set_numvfs(struct pci_iov *iov, int numvfs)
+{
+       u16 offset, stride;
+
+       if (!iov->notify)
+               return -ENODEV;
+
+       if (numvfs == iov->numvfs)
+               return 0;
+
+       if (numvfs < 0 || numvfs > iov->initialvfs || iov->is_enabled)
+               return -EINVAL;
+
+       pci_write_config_word(iov->dev, iov->cap + PCI_IOV_NUM_VF, numvfs);
+       pci_read_config_word(iov->dev, iov->cap + PCI_IOV_VF_OFFSET, &offset);
+       pci_read_config_word(iov->dev, iov->cap + PCI_IOV_VF_STRIDE, &stride);
+       if ((numvfs && !offset) || (numvfs > 1 && !stride))
+               return -EIO;
+
+       iov->offset = offset;
+       iov->stride = stride;
+       iov->numvfs = numvfs;
+       return 0;
+}
+
+static ssize_t is_enabled_store(struct kobject *kobj, struct iov_attr *attr,
+                               const char *buf, size_t count)
+{
+       int rc;
+       long enable;
+       struct pci_iov *iov = container_of(kobj, struct pci_iov, kobj);
+
+       rc = strict_strtol(buf, 0, &enable);
+       if (rc)
+               return rc;
+
+       mutex_lock(&iov->mutex);
+       switch (enable) {
+       case 0:
+               rc = iov_disable(iov);
+               break;
+       case 1:
+               rc = iov_enable(iov);
+               break;
+       default:
+               rc = -EINVAL;
+       }
+       mutex_unlock(&iov->mutex);
+
+       return rc ? rc : count;
+}
+
+static ssize_t numvfs_store(struct kobject *kobj, struct iov_attr *attr,
+                               const char *buf, size_t count)
+{
+       int rc;
+       long numvfs;
+       struct pci_iov *iov = container_of(kobj, struct pci_iov, kobj);
+
+       rc = strict_strtol(buf, 0, &numvfs);
+       if (rc)
+               return rc;
+
+       mutex_lock(&iov->mutex);
+       rc = iov_set_numvfs(iov, numvfs);
+       mutex_unlock(&iov->mutex);
+
+       return rc ? rc : count;
+}
+
+
+static struct iov_attr iov_attr[] = {
+       __ATTR_RO(totalvfs),
+       __ATTR_RO(initialvfs),
+       __ATTR(numvfs, S_IWUSR | S_IRUGO, numvfs_show, numvfs_store),
+       __ATTR(enable, S_IWUSR | S_IRUGO, is_enabled_show, is_enabled_store),
+};
+
+static ssize_t vf_show(struct kobject *kobj, struct iov_attr *attr,
+                               char *buf)
+{
+       int vfn;
+       struct vf_entry *ve = container_of(kobj, struct vf_entry, kobj);
+
+       vfn = attr - ve->attr;
+       ve->iov->notify(ve->iov->dev, vfn | PCI_IOV_RD_CONF);
+
+       return sprintf(buf, "%s\n", ve->param[vfn]);
+}
+
+static ssize_t vf_store(struct kobject *kobj, struct iov_attr *attr,
+                               const char *buf, size_t count)
+{
+       int vfn;
+       struct vf_entry *ve = container_of(kobj, struct vf_entry, kobj);
+
+       vfn = attr - ve->attr;
+       sscanf(buf, "%63s", ve->param[vfn]);
+       ve->iov->notify(ve->iov->dev, vfn | PCI_IOV_WR_CONF);
+
+       return count;
+}
+
+static ssize_t rid_show(struct kobject *kobj, struct iov_attr *attr,
+                               char *buf)
+{
+       u8 busnr, devfn;
+       struct vf_entry *ve = container_of(kobj, struct vf_entry, kobj);
+
+       vf_rid(ve->iov->dev, ve->vfn, &busnr, &devfn);
+
+       return sprintf(buf, "%04x:%02x:%02x.%d\n",
+                       pci_domain_nr(ve->iov->dev->bus),
+                       busnr, PCI_SLOT(devfn), PCI_FUNC(devfn));
+}
+
+static struct iov_attr vf_attr = __ATTR_RO(rid);
+
+int iov_alloc_bus(struct pci_bus *bus, int busnr)
+{
+       int i;
+       int rc = 0;
+       struct pci_bus *child, *next;
+       struct list_head head;
+
+       INIT_LIST_HEAD(&head);
+
+       down_write(&pci_bus_sem);
+
+       for (i = bus->number + 1; i <= busnr; i++) {
+               list_for_each_entry(child, &bus->children, node)
+                       if (child->number == i)
+                               break;
+               if (child->number == i)
+                       continue;
+               child = pci_alloc_child_bus(bus, NULL, i);
+               if (!child) {
+                       rc = -ENOMEM;
+                       break;
+               }
+               child->subordinate = i;
+               child->dev.parent = bus->bridge;
+               rc = device_register(&child->dev);
+               if (rc) {
+                       kfree(child);
+                       break;
+               }
+               child->is_added = 1;
+               list_add_tail(&child->node, &head);
+       }
+
+       if (rc)
+               list_for_each_entry_safe(child, next, &head, node) {
+                       device_unregister(&child->dev);
+                       kfree(child);
+               }
+       else
+               list_for_each_entry_safe(child, next, &head, node)
+                       list_move_tail(&child->node, &bus->children);
+
+       up_write(&pci_bus_sem);
+
+       return rc;
+}
+
+void iov_release_bus(struct pci_bus *bus)
+{
+       struct pci_dev *dev;
+       struct pci_bus *child, *next;
+       struct list_head head;
+
+       INIT_LIST_HEAD(&head);
+
+       down_write(&pci_bus_sem);
+
+       list_for_each_entry(dev, &bus->devices, bus_list)
+               if (dev->iov && dev->iov->notify)
+                       goto done;
+
+       list_for_each_entry_safe(child, next, &bus->children, node)
+               if (!child->bridge)
+                       list_move(&child->node, &head);
+done:
+       up_write(&pci_bus_sem);
+
+       list_for_each_entry_safe(child, next, &head, node)
+               pci_remove_bus(child);
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
+       int i;
+       int pos;
+       u32 pgsz;
+       u16 ctrl, total, initial, offset, stride;
+       struct pci_iov *iov;
+       struct resource *res;
+
+       if (!dev->is_pcie || (dev->pcie_type != PCI_EXP_TYPE_RC_END &&
+                               dev->pcie_type != PCI_EXP_TYPE_ENDPOINT))
+               return -ENODEV;
+
+       pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_IOV);
+       if (!pos)
+               return -ENODEV;
+
+       ctrl = pci_ari_enabled(dev) ? PCI_IOV_CTRL_ARI : 0;
+       pci_write_config_word(dev, pos + PCI_IOV_CTRL, ctrl);
+       ssleep(1);
+
+       pci_read_config_word(dev, pos + PCI_IOV_TOTAL_VF, &total);
+       pci_read_config_word(dev, pos + PCI_IOV_INITIAL_VF, &initial);
+       pci_write_config_word(dev, pos + PCI_IOV_NUM_VF, initial);
+       pci_read_config_word(dev, pos + PCI_IOV_VF_OFFSET, &offset);
+       pci_read_config_word(dev, pos + PCI_IOV_VF_STRIDE, &stride);
+       if (!total || initial > total || (initial && !offset) ||
+           (initial > 1 && !stride))
+               return -EIO;
+
+       pci_read_config_dword(dev, pos + PCI_IOV_SUP_PGSIZE, &pgsz);
+       i = PAGE_SHIFT > 12 ? PAGE_SHIFT - 12 : 0;
+       pgsz &= ~((1 << i) - 1);
+       if (!pgsz)
+               return -EIO;
+
+       pgsz &= ~(pgsz - 1);
+       pci_write_config_dword(dev, pos + PCI_IOV_SYS_PGSIZE, pgsz);
+
+       iov = kzalloc(sizeof(*iov), GFP_KERNEL);
+       if (!iov)
+               return -ENOMEM;
+
+       iov->dev = dev;
+       iov->cap = pos;
+       iov->totalvfs = total;
+       iov->initialvfs = initial;
+       iov->offset = offset;
+       iov->stride = stride;
+       iov->align = pgsz << 12;
+       mutex_init(&iov->mutex);
+
+       for (i = 0; i < PCI_IOV_NUM_BAR; i++) {
+               res = dev->resource + PCI_IOV_RESOURCES + i;
+               pos = iov->cap + PCI_IOV_BAR_0 + i * 4;
+               i += pci_read_base(dev, pci_bar_unknown, res, pos);
+               if (!res->flags)
+                       continue;
+               res->flags &= ~IORESOURCE_SIZEALIGN;
+               res->end = res->start + resource_size(res) * total - 1;
+       }
+
+       dev->iov = iov;
+       dev_info(&dev->dev, "SR-IOV capability is initialized\n");
+
+       return 0;
+}
+
+/**
+ * pci_iov_release - release resources used by SR-IOV capability
+ * @dev: the PCI device
+ */
+void pci_iov_release(struct pci_dev *dev)
+{
+       if (!dev->iov)
+               return;
+
+       mutex_destroy(&dev->iov->mutex);
+       kfree(dev->iov);
+       dev->iov = NULL;
+}
+
+/**
+ * pci_iov_create_sysfs - create sysfs for SR-IOV capability
+ * @dev: the PCI device
+ */
+void pci_iov_create_sysfs(struct pci_dev *dev)
+{
+       int rc;
+       int i, j;
+       struct pci_iov *iov = dev->iov;
+
+       if (!iov)
+               return;
+
+       iov->ve = kzalloc(sizeof(*iov->ve) * iov->totalvfs, GFP_KERNEL);
+       if (!iov->ve)
+               return;
+
+       for (i = 0; i < iov->totalvfs; i++) {
+               iov->ve[i].vfn = i;
+               iov->ve[i].iov = iov;
+       }
+
+       rc = kobject_init_and_add(&iov->kobj, &iov_ktype,
+                                       &dev->dev.kobj, "iov");
+       if (rc)
+               goto failed1;
+
+       for (i = 0; i < ARRAY_SIZE(iov_attr); i++) {
+               rc = sysfs_create_file(&iov->kobj, &iov_attr[i].attr);
+               if (rc)
+                       goto failed2;
+       }
+
+       for (i = 0; i < iov->totalvfs; i++) {
+               sprintf(iov->ve[i].name, "%d", i);
+               rc = kobject_init_and_add(&iov->ve[i].kobj, &iov_ktype,
+                                               &iov->kobj, iov->ve[i].name);
+               if (rc)
+                       goto failed3;
+               rc = sysfs_create_file(&iov->ve[i].kobj, &vf_attr.attr);
+               if (rc) {
+                       kobject_put(&iov->ve[i].kobj);
+                       goto failed3;
+               }
+       }
+
+       return;
+
+failed3:
+       for (j = 0; j < i; j++) {
+               sysfs_remove_file(&iov->ve[j].kobj, &vf_attr.attr);
+               kobject_put(&iov->ve[j].kobj);
+       }
+failed2:
+       for (j = 0; j < i; j++)
+               sysfs_remove_file(&dev->iov->kobj, &iov_attr[j].attr);
+       kobject_put(&iov->kobj);
+failed1:
+       kfree(iov->ve);
+       iov->ve = NULL;
+
+       dev_err(&dev->dev, "can't create sysfs for SR-IOV.\n");
+}
+
+/**
+ * pci_iov_remove_sysfs - remove sysfs of SR-IOV capability
+ * @dev: the PCI device
+ */
+void pci_iov_remove_sysfs(struct pci_dev *dev)
+{
+       int i;
+       struct pci_iov *iov = dev->iov;
+
+       if (!iov || !iov->ve)
+               return;
+
+       for (i = 0; i < iov->totalvfs; i++) {
+               sysfs_remove_file(&iov->ve[i].kobj, &vf_attr.attr);
+               kobject_put(&iov->ve[i].kobj);
+       }
+
+       for (i = 0; i < ARRAY_SIZE(iov_attr); i++)
+               sysfs_remove_file(&dev->iov->kobj, &iov_attr[i].attr);
+
+       kobject_put(&iov->kobj);
+       kfree(iov->ve);
+}
+
+int pci_iov_resource_align(struct pci_dev *dev, int resno)
+{
+       if (resno < PCI_IOV_RESOURCES || resno > PCI_IOV_RESOURCES_END)
+               return 0;
+
+       BUG_ON(!dev->iov);
+
+       return dev->iov->align;
+}
+
+int pci_iov_resource_bar(struct pci_dev *dev, int resno,
+                        enum pci_bar_type *type)
+{
+       if (resno < PCI_IOV_RESOURCES || resno > PCI_IOV_RESOURCES_END)
+               return 0;
+
+       BUG_ON(!dev->iov);
+
+       *type = pci_bar_unknown;
+       return dev->iov->cap + PCI_IOV_BAR_0 +
+               4 * (resno - PCI_IOV_RESOURCES);
+}
+
+/**
+ * pci_iov_register - register SR-IOV service
+ * @dev: the PCI device
+ * @notify: callback function for SR-IOV events
+ * @entries: sysfs entries used by Physical Function driver
+ *
+ * Returns 0 on success, or negative on failure.
+ */
+int pci_iov_register(struct pci_dev *dev, int (*notify)(struct pci_dev *, u32),
+                       char **entries)
+{
+       int rc;
+       int n, i, j, k;
+       u8 busnr, devfn;
+       struct iov_attr *attr;
+       struct pci_iov *iov = dev->iov;
+
+       if (!iov || !iov->ve)
+               return -ENODEV;
+
+       if (!notify)
+               return -EINVAL;
+
+       vf_rid(dev, iov->totalvfs - 1, &busnr, &devfn);
+       if (busnr > dev->bus->subordinate)
+               return -EIO;
+
+       iov->notify = notify;
+       rc = iov_alloc_bus(dev->bus, busnr);
+       if (rc)
+               return rc;
+
+       for (n = 0; entries && entries[n] && *entries[n]; n++)
+               ;
+       if (!n)
+               return 0;
+
+       for (i = 0; i < iov->totalvfs; i++) {
+               rc = -ENOMEM;
+               iov->ve[i].param = kzalloc(PCI_IOV_PARAM_LEN * n, GFP_KERNEL);
+               if (!iov->ve[i].param)
+                       goto failed;
+               attr = kzalloc(sizeof(*attr) * n, GFP_KERNEL);
+               if (!attr) {
+                       kfree(iov->ve[i].param);
+                       goto failed;
+               }
+               iov->ve[i].attr = attr;
+               for (j = 0; j < n; j++) {
+                       attr[j].attr.name = entries[j];
+                       attr[j].attr.mode = S_IWUSR | S_IRUGO;
+                       attr[j].show = vf_show;
+                       attr[j].store = vf_store;
+                       rc = sysfs_create_file(&iov->ve[i].kobj, &attr[j].attr);
+                       if (rc) {
+                               while (j--)
+                                       sysfs_remove_file(&iov->ve[i].kobj,
+                                                               &attr[j].attr);
+                               kfree(iov->ve[i].attr);
+                               kfree(iov->ve[i].param);
+                               goto failed;
+                       }
+               }
+       }
+
+       iov->nentries = n;
+       return 0;
+
+failed:
+       for (k = 0; k < i; k++) {
+               for (j = 0; j < n; j++)
+                       sysfs_remove_file(&iov->ve[k].kobj,
+                                       &iov->ve[k].attr[j].attr);
+               kfree(iov->ve[k].attr);
+               kfree(iov->ve[k].param);
+       }
+
+       return rc;
+}
+EXPORT_SYMBOL_GPL(pci_iov_register);
+
+/**
+ * pci_iov_unregister - unregister SR-IOV service
+ * @dev: the PCI device
+ */
+void pci_iov_unregister(struct pci_dev *dev)
+{
+       int i, j;
+       struct pci_iov *iov = dev->iov;
+
+       BUG_ON(!iov || !iov->notify);
+
+       if (!iov->nentries)
+               return;
+
+       for (i = 0; i < iov->totalvfs; i++) {
+               for (j = 0; j < iov->nentries; j++)
+                       sysfs_remove_file(&iov->ve[i].kobj,
+                                       &iov->ve[i].attr[j].attr);
+               kfree(iov->ve[i].attr);
+               kfree(iov->ve[i].param);
+       }
+       iov->notify = NULL;
+       iov_release_bus(dev->bus);
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
+       int rc;
+       struct pci_iov *iov = dev->iov;
+
+       if (!iov)
+               return -ENODEV;
+
+       if (!iov->notify)
+               return -EINVAL;
+
+       mutex_lock(&iov->mutex);
+       rc = iov_set_numvfs(iov, numvfs);
+       if (rc)
+               goto done;
+       rc = iov_enable(iov);
+done:
+       mutex_unlock(&iov->mutex);
+
+       return rc;
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
+       struct pci_iov *iov = dev->iov;
+
+       BUG_ON(!iov || !iov->notify);
+       mutex_lock(&iov->mutex);
+       iov_disable(iov);
+       mutex_unlock(&iov->mutex);
+}
+EXPORT_SYMBOL_GPL(pci_iov_disable);
+
+/**
+ * pci_iov_read_config - read SR-IOV configurations
+ * @dev: the PCI device
+ * @vfn: Virtual Function Number
+ * @entry: the entry to be read
+ * @buf: the buffer to be filled
+ * @size: size of the buffer
+ *
+ * Returns 0 on success, or negative on failure.
+ */
+int pci_iov_read_config(struct pci_dev *dev, int vfn,
+                       char *entry, char *buf, int size)
+{
+       int i;
+       struct pci_iov *iov = dev->iov;
+
+       if (!iov)
+               return -ENODEV;
+
+       if (!iov->notify || !iov->ve || !iov->nentries)
+               return -EINVAL;
+
+       if (vfn < 0 || vfn >= iov->totalvfs)
+               return -EINVAL;
+
+       for (i = 0; i < iov->nentries; i++)
+               if (!strcmp(iov->ve[vfn].attr[i].attr.name, entry)) {
+                       strncpy(buf, iov->ve[vfn].param[i], size);
+                       buf[size - 1] = '\0';
+                       return 0;
+               }
+
+       return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(pci_iov_read_config);
+
+/**
+ * pci_iov_write_config - write SR-IOV configurations
+ * @dev: the PCI device
+ * @vfn: Virtual Function Number
+ * @entry: the entry to be written
+ * @buf: the buffer contains configurations
+ *
+ * Returns 0 on success, or negative on failure.
+ */
+int pci_iov_write_config(struct pci_dev *dev, int vfn,
+                       char *entry, char *buf)
+{
+       int i;
+       struct pci_iov *iov = dev->iov;
+
+       if (!iov)
+               return -ENODEV;
+
+       if (!iov->notify || !iov->ve || !iov->nentries)
+               return -EINVAL;
+
+       if (vfn < 0 || vfn >= iov->totalvfs)
+               return -EINVAL;
+
+       for (i = 0; i < iov->nentries; i++)
+               if (!strcmp(iov->ve[vfn].attr[i].attr.name, entry)) {
+                       strncpy(iov->ve[vfn].param[i], buf, PCI_IOV_PARAM_LEN);
+                       iov->ve[vfn].param[i][PCI_IOV_PARAM_LEN - 1] = '\0';
+                       return 0;
+               }
+
+       return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(pci_iov_write_config);
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index f2feebc..c819762 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -743,6 +743,9 @@ static int pci_create_capabilities_sysfs(struct pci_dev *dev)
        /* Active State Power Management */
        pcie_aspm_create_sysfs_dev_files(dev);

+       /* Single Root I/O Virtualization */
+       pci_iov_create_sysfs(dev);
+
        return 0;
 }

@@ -822,6 +825,7 @@ static void pci_remove_capabilities_sysfs(struct pci_dev *dev)
        }

        pcie_aspm_remove_sysfs_dev_files(dev);
+       pci_iov_remove_sysfs(dev);
 }

 /**
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index fe9efc4..bf60951 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1898,7 +1898,12 @@ int pci_resource_alignment(struct pci_dev *dev, int resno)

        if (resno <= PCI_ROM_RESOURCE)
                return resource_size(res);
-       else if (resno <= PCI_BRIDGE_RES_END)
+       else if (resno < PCI_BRIDGE_RESOURCES) {
+               /* may be device specific resource */
+               align = pci_iov_resource_align(dev, resno);
+               if (align)
+                       return align;
+       } else if (resno <= PCI_BRIDGE_RES_END)
                return res->start;

        dev_err(&dev->dev, "alignment: invalid resource #%d\n", resno);
@@ -1915,12 +1920,19 @@ int pci_resource_alignment(struct pci_dev *dev, int resno)
  */
 int pci_resource_bar(struct pci_dev *dev, int resno, enum pci_bar_type *type)
 {
+       int reg;
+
        if (resno < PCI_ROM_RESOURCE) {
                *type = pci_bar_unknown;
                return PCI_BASE_ADDRESS_0 + 4 * resno;
        } else if (resno == PCI_ROM_RESOURCE) {
                *type = pci_bar_rom;
                return dev->rom_base_reg;
+       } else if (resno < PCI_BRIDGE_RESOURCES) {
+               /* may be device specific resource */
+               reg = pci_iov_resource_bar(dev, resno, type);
+               if (reg)
+                       return reg;
        }

        dev_err(&dev->dev, "BAR: invalid resource #%d\n", resno);
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 593b415..11b1d17 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -178,4 +178,59 @@ static inline int pci_ari_enabled(struct pci_dev *dev)
        return dev->ari_enabled;
 }

+/* Single Root I/O Virtualization */
+#define PCI_IOV_PARAM_LEN      64
+
+struct vf_entry;
+
+struct pci_iov {
+       int cap;                /* capability position */
+       int align;              /* page size used to map memory space */
+       int is_enabled;         /* status of SR-IOV */
+       int nentries;           /* number of sysfs entries used by PF driver */
+       u16 totalvfs;           /* total VFs associated with the PF */
+       u16 initialvfs;         /* initial VFs associated with the PF */
+       u16 numvfs;             /* number of VFs available */
+       u16 offset;             /* first VF Routing ID offset */
+       u16 stride;             /* following VF stride */
+       struct mutex mutex;     /* lock for SR-IOV */
+       struct kobject kobj;    /* koject for IOV */
+       struct pci_dev *dev;    /* Physical Function */
+       struct vf_entry *ve;    /* Virtual Function related */
+       int (*notify)(struct pci_dev *, u32);   /* event callback function */
+};
+
+#ifdef CONFIG_PCI_IOV
+extern int pci_iov_init(struct pci_dev *dev);
+extern void pci_iov_release(struct pci_dev *dev);
+void pci_iov_create_sysfs(struct pci_dev *dev);
+void pci_iov_remove_sysfs(struct pci_dev *dev);
+extern int pci_iov_resource_align(struct pci_dev *dev, int resno);
+extern int pci_iov_resource_bar(struct pci_dev *dev, int resno,
+                               enum pci_bar_type *type);
+#else
+static inline int pci_iov_init(struct pci_dev *dev)
+{
+       return -EIO;
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
+       return 0;
+}
+static inline int pci_iov_resource_bar(struct pci_dev *dev, int resno,
+                                      enum pci_bar_type *type)
+{
+       return 0;
+}
+#endif /* CONFIG_PCI_IOV */
+
 #endif /* DRIVERS_PCI_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 06b9a75..f18174e 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -845,6 +845,7 @@ static int pci_setup_device(struct pci_dev * dev)
 static void pci_release_capabilities(struct pci_dev *dev)
 {
        pci_vpd_release(dev);
+       pci_iov_release(dev);
 }

 /**
@@ -1022,6 +1023,9 @@ static void pci_init_capabilities(struct pci_dev *dev)

        /* Alternative Routing-ID Forwarding */
        pci_ari_init(dev);
+
+       /* Single Root I/O Virtualization */
+       pci_iov_init(dev);
 }

 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 497d639..a7d2fd4 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -87,6 +87,12 @@ enum {
        /* #6: expansion ROM */
        PCI_ROM_RESOURCE,

+       /* device specific resources */
+#ifdef CONFIG_PCI_IOV
+       PCI_IOV_RESOURCES,
+       PCI_IOV_RESOURCES_END = PCI_IOV_RESOURCES + PCI_IOV_NUM_BAR - 1,
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
+       struct pci_iov *iov;
 };

 extern struct pci_dev *alloc_pci_dev(void);
@@ -1128,5 +1136,54 @@ static inline void pci_mmcfg_early_init(void) { }
 static inline void pci_mmcfg_late_init(void) { }
 #endif

+/* SR-IOV events masks */
+#define PCI_IOV_VIRTFN_ID      0x0000FFFFU     /* Virtual Function Number */
+#define PCI_IOV_NUM_VIRTFN     0x0000FFFFU     /* num of Virtual Functions */
+#define PCI_IOV_EVENT_TYPE     0x80000000U     /* event type (pre/post) */
+/* SR-IOV events values */
+#define PCI_IOV_ENABLE         0x00010000U     /* SR-IOV enable request */
+#define PCI_IOV_DISABLE                0x00020000U     /* SR-IOV disable request */
+#define PCI_IOV_RD_CONF                0x00040000U     /* read configuration */
+#define PCI_IOV_WR_CONF                0x00080000U     /* write configuration */
+#define PCI_IOV_POST_EVENT     0x80000000U     /* post event */
+
+#ifdef CONFIG_PCI_IOV
+extern int pci_iov_enable(struct pci_dev *dev, int numvfs);
+extern void pci_iov_disable(struct pci_dev *dev);
+extern int pci_iov_register(struct pci_dev *dev,
+       int (*notify)(struct pci_dev *dev, u32 event), char **entries);
+extern void pci_iov_unregister(struct pci_dev *dev);
+extern int pci_iov_read_config(struct pci_dev *dev, int id,
+                       char *entry, char *buf, int size);
+extern int pci_iov_write_config(struct pci_dev *dev, int id,
+                       char *entry, char *buf);
+#else
+static inline int pci_iov_enable(struct pci_dev *dev, int numvfs)
+{
+       return -EIO;
+}
+static inline void pci_iov_disable(struct pci_dev *dev)
+{
+}
+static inline int pci_iov_register(struct pci_dev *dev,
+       int (*notify)(struct pci_dev *dev, u32 event), char **entries)
+{
+       return -EIO;
+}
+static inline void pci_iov_unregister(struct pci_dev *dev)
+{
+}
+static inline int pci_iov_read_config(struct pci_dev *dev, int id,
+                       char *entry, char *buf, int size)
+{
+       return -EIO;
+}
+static inline int pci_iov_write_config(struct pci_dev *dev, int id,
+                       char *entry, char *buf)
+{
+       return -EIO;
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
 #define  PCI_EXP_TYPE_UPSTREAM 0x5     /* Upstream Port */
 #define  PCI_EXP_TYPE_DOWNSTREAM 0x6   /* Downstream Port */
 #define  PCI_EXP_TYPE_PCI_BRIDGE 0x7   /* PCI/PCI-X Bridge */
+#define  PCI_EXP_TYPE_RC_END   0x9     /* Root Complex Integrated Endpoint */
 #define PCI_EXP_FLAGS_SLOT     0x0100  /* Slot implemented */
 #define PCI_EXP_FLAGS_IRQ      0x3e00  /* Interrupt message number */
 #define PCI_EXP_DEVCAP         4       /* Device capabilities */
@@ -434,6 +435,7 @@
 #define PCI_EXT_CAP_ID_DSN     3
 #define PCI_EXT_CAP_ID_PWR     4
 #define PCI_EXT_CAP_ID_ARI     14
+#define PCI_EXT_CAP_ID_IOV     16

 /* Advanced Error Reporting */
 #define PCI_ERR_UNCOR_STATUS   4       /* Uncorrectable Error Status */
@@ -551,4 +553,23 @@
 #define  PCI_ARI_CTRL_ACS      0x0002  /* ACS Function Groups Enable */
 #define  PCI_ARI_CTRL_FG(x)    (((x) >> 4) & 7) /* Function Group */

+/* Single Root I/O Virtualization */
+#define PCI_IOV_CAP            0x04    /* SR-IOV Capabilities */
+#define PCI_IOV_CTRL           0x08    /* SR-IOV Control */
+#define  PCI_IOV_CTRL_VFE      0x01    /* VF Enable */
+#define  PCI_IOV_CTRL_MSE      0x08    /* VF Memory Space Enable */
+#define  PCI_IOV_CTRL_ARI      0x10    /* ARI Capable Hierarchy */
+#define PCI_IOV_STATUS         0x0a    /* SR-IOV Status */
+#define PCI_IOV_INITIAL_VF     0x0c    /* Initial VFs */
+#define PCI_IOV_TOTAL_VF       0x0e    /* Total VFs */
+#define PCI_IOV_NUM_VF         0x10    /* Number of VFs */
+#define PCI_IOV_FUNC_LINK      0x12    /* Function Dependency Link */
+#define PCI_IOV_VF_OFFSET      0x14    /* First VF Offset */
+#define PCI_IOV_VF_STRIDE      0x16    /* Following VF Stride */
+#define PCI_IOV_VF_DID         0x1a    /* VF Device ID */
+#define PCI_IOV_SUP_PGSIZE     0x1c    /* Supported Page Sizes */
+#define PCI_IOV_SYS_PGSIZE     0x20    /* System Page Size */
+#define PCI_IOV_BAR_0          0x24    /* VF BAR0 */
+#define PCI_IOV_NUM_BAR                6       /* Number of VF BARs */
+
 #endif /* LINUX_PCI_REGS_H */
--
1.5.6.4

