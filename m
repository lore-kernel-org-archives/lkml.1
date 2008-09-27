Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbYI0I2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbYI0I2g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 04:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYI0I2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 04:28:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:54134 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbYI0I2A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 04:28:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,319,1220252400"; 
   d="scan'208";a="341193324"
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
Date: Sat, 27 Sep 2008 16:27:55 +0800
Subject: [PATCH 2/6 v3] PCI: add new general functions
Thread-Topic: [PATCH 2/6 v3] PCI: add new general functions
Thread-Index: AckgevEESWz53hP2Th65hpW8WGf59Q==
Message-ID: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F2@pdsmsx502.ccr.corp.intel.com>
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

Centralize capability related functions into several new functions and put PCI resource definitions into an enum.

Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Alex Chiang <achiang@hp.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 drivers/pci/pci-sysfs.c |  119 +++++++++++++++++++++++++++--------------------
 drivers/pci/pci.c       |   68 ++++++++++++++++++++-------
 drivers/pci/pci.h       |    3 +
 drivers/pci/probe.c     |   29 ++++++++---
 drivers/pci/proc.c      |    7 ++-
 drivers/pci/setup-bus.c |    4 +-
 drivers/pci/setup-res.c |   27 +++++------
 include/linux/pci.h     |   39 ++++++++++------
 8 files changed, 186 insertions(+), 110 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index f99160d..f2feebc 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -100,11 +100,11 @@ resource_show(struct device * dev, struct device_attribute *attr, char * buf)
        struct pci_dev * pci_dev = to_pci_dev(dev);
        char * str = buf;
        int i;
-       int max = 7;
+       int max;
        resource_size_t start, end;

-       if (pci_dev->subordinate)
-               max = DEVICE_COUNT_RESOURCE;
+       max = pci_dev->subordinate ? DEVICE_COUNT_RESOURCE :
+                               PCI_BRIDGE_RESOURCES;

        for (i = 0; i < max; i++) {
                struct resource *res =  &pci_dev->resource[i];
@@ -716,10 +716,40 @@ int __attribute__ ((weak)) pcibios_add_platform_entries(struct pci_dev *dev)
        return 0;
 }

+static int pci_create_capabilities_sysfs(struct pci_dev *dev)
+{
+       int retval;
+       struct bin_attribute *attr;
+
+       /* If the device has VPD, try to expose it in sysfs. */
+       if (dev->vpd) {
+               attr = kzalloc(sizeof(*attr), GFP_ATOMIC);
+               if (!attr)
+                       return -ENOMEM;
+
+               attr->size = dev->vpd->len;
+               attr->attr.name = "vpd";
+               attr->attr.mode = S_IRUSR | S_IWUSR;
+               attr->read = pci_read_vpd;
+               attr->write = pci_write_vpd;
+               retval = sysfs_create_bin_file(&dev->dev.kobj, attr);
+               if (retval) {
+                       kfree(dev->vpd->attr);
+                       return retval;
+               }
+               dev->vpd->attr = attr;
+       }
+
+       /* Active State Power Management */
+       pcie_aspm_create_sysfs_dev_files(dev);
+
+       return 0;
+}
+
 int __must_check pci_create_sysfs_dev_files (struct pci_dev *pdev)
 {
-       struct bin_attribute *attr = NULL;
        int retval;
+       struct bin_attribute *attr;

        if (!sysfs_initialized)
                return -EACCES;
@@ -731,69 +761,50 @@ int __must_check pci_create_sysfs_dev_files (struct pci_dev *pdev)
        if (retval)
                goto err;

-       /* If the device has VPD, try to expose it in sysfs. */
-       if (pdev->vpd) {
-               attr = kzalloc(sizeof(*attr), GFP_ATOMIC);
-               if (attr) {
-                       pdev->vpd->attr = attr;
-                       attr->size = pdev->vpd->len;
-                       attr->attr.name = "vpd";
-                       attr->attr.mode = S_IRUSR | S_IWUSR;
-                       attr->read = pci_read_vpd;
-                       attr->write = pci_write_vpd;
-                       retval = sysfs_create_bin_file(&pdev->dev.kobj, attr);
-                       if (retval)
-                               goto err_vpd;
-               } else {
-                       retval = -ENOMEM;
-                       goto err_config_file;
-               }
-       }
-
        retval = pci_create_resource_files(pdev);
        if (retval)
-               goto err_vpd_file;
+               goto err_config_file;

        /* If the device has a ROM, try to expose it in sysfs. */
        if (pci_resource_len(pdev, PCI_ROM_RESOURCE) ||
            (pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW)) {
                attr = kzalloc(sizeof(*attr), GFP_ATOMIC);
-               if (attr) {
-                       pdev->rom_attr = attr;
-                       attr->size = pci_resource_len(pdev, PCI_ROM_RESOURCE);
-                       attr->attr.name = "rom";
-                       attr->attr.mode = S_IRUSR;
-                       attr->read = pci_read_rom;
-                       attr->write = pci_write_rom;
-                       retval = sysfs_create_bin_file(&pdev->dev.kobj, attr);
-                       if (retval)
-                               goto err_rom;
-               } else {
+               if (!attr) {
                        retval = -ENOMEM;
                        goto err_resource_files;
                }
+               attr->size = pci_resource_len(pdev, PCI_ROM_RESOURCE);
+               attr->attr.name = "rom";
+               attr->attr.mode = S_IRUSR;
+               attr->read = pci_read_rom;
+               attr->write = pci_write_rom;
+               retval = sysfs_create_bin_file(&pdev->dev.kobj, attr);
+               if (retval) {
+                       kfree(attr);
+                       goto err_resource_files;
+               }
+               pdev->rom_attr = attr;
        }
        /* add platform-specific attributes */
-       if (pcibios_add_platform_entries(pdev))
+       retval = pcibios_add_platform_entries(pdev);
+       if (retval)
                goto err_rom_file;

-       pcie_aspm_create_sysfs_dev_files(pdev);
+       /* add sysfs entries for various capabilities */
+       retval = pci_create_capabilities_sysfs(pdev);
+       if (retval)
+               goto err_rom_file;

        return 0;

 err_rom_file:
-       if (pci_resource_len(pdev, PCI_ROM_RESOURCE))
+       if (pci_resource_len(pdev, PCI_ROM_RESOURCE) ||
+           (pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW)) {
                sysfs_remove_bin_file(&pdev->dev.kobj, pdev->rom_attr);
-err_rom:
-       kfree(pdev->rom_attr);
+               kfree(pdev->rom_attr);
+       }
 err_resource_files:
        pci_remove_resource_files(pdev);
-err_vpd_file:
-       if (pdev->vpd) {
-               sysfs_remove_bin_file(&pdev->dev.kobj, pdev->vpd->attr);
-err_vpd:
-               kfree(pdev->vpd->attr);
-       }
 err_config_file:
        if (pdev->cfg_size < PCI_CFG_SPACE_EXP_SIZE)
                sysfs_remove_bin_file(&pdev->dev.kobj, &pci_config_attr);
@@ -803,6 +814,16 @@ err:
        return retval;
 }

+static void pci_remove_capabilities_sysfs(struct pci_dev *dev)
+{
+       if (dev->vpd) {
+               sysfs_remove_bin_file(&dev->dev.kobj, dev->vpd->attr);
+               kfree(dev->vpd->attr);
+       }
+
+       pcie_aspm_remove_sysfs_dev_files(dev);
+}
+
 /**
  * pci_remove_sysfs_dev_files - cleanup PCI specific sysfs files
  * @pdev: device whose entries we should free
@@ -814,12 +835,8 @@ void pci_remove_sysfs_dev_files(struct pci_dev *pdev)
        if (!sysfs_initialized)
                return;

-       pcie_aspm_remove_sysfs_dev_files(pdev);
+       pci_remove_capabilities_sysfs(pdev);

-       if (pdev->vpd) {
-               sysfs_remove_bin_file(&pdev->dev.kobj, pdev->vpd->attr);
-               kfree(pdev->vpd->attr);
-       }
        if (pdev->cfg_size < PCI_CFG_SPACE_EXP_SIZE)
                sysfs_remove_bin_file(&pdev->dev.kobj, &pci_config_attr);
        else
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 259eaff..400d3b3 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -356,25 +356,10 @@ pci_find_parent_resource(const struct pci_dev *dev, struct resource *res)
 static void
 pci_restore_bars(struct pci_dev *dev)
 {
-       int i, numres;
-
-       switch (dev->hdr_type) {
-       case PCI_HEADER_TYPE_NORMAL:
-               numres = 6;
-               break;
-       case PCI_HEADER_TYPE_BRIDGE:
-               numres = 2;
-               break;
-       case PCI_HEADER_TYPE_CARDBUS:
-               numres = 1;
-               break;
-       default:
-               /* Should never get here, but just in case... */
-               return;
-       }
+       int i;

-       for (i = 0; i < numres; i ++)
-               pci_update_resource(dev, &dev->resource[i], i);
+       for (i = 0; i < PCI_BRIDGE_RESOURCES; i++)
+               pci_update_resource(dev, i);
 }

 static struct pci_platform_pm_ops *pci_platform_pm;
@@ -1864,6 +1849,53 @@ int pci_select_bars(struct pci_dev *dev, unsigned long flags)
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
+       resource_size_t align;
+       struct resource *res = dev->resource + resno;
+
+       align = resource_alignment(res);
+       if (align)
+               return align;
+
+       if (resno <= PCI_ROM_RESOURCE)
+               return resource_size(res);
+       else if (resno <= PCI_BRIDGE_RES_END)
+               return res->start;
+
+       dev_err(&dev->dev, "alignment: invalid resource #%d\n", resno);
+       return 0;
+}
+
+/**
+ * pci_resource_bar - get position of the BAR associated with a resource
+ * @dev: the PCI device
+ * @resno: the resource number
+ * @type: the BAR type to be filled in
+ *
+ * Returns BAR position in config space, or 0 if the BAR is invalid.
+ */
+int pci_resource_bar(struct pci_dev *dev, int resno, enum pci_bar_type *type)
+{
+       if (resno < PCI_ROM_RESOURCE) {
+               *type = pci_bar_unknown;
+               return PCI_BASE_ADDRESS_0 + 4 * resno;
+       } else if (resno == PCI_ROM_RESOURCE) {
+               *type = pci_bar_rom;
+               return dev->rom_base_reg;
+       }
+
+       dev_err(&dev->dev, "BAR: invalid resource #%d\n", resno);
+       return 0;
+}
+
 static void __devinit pci_no_domains(void)
 {
 #ifdef CONFIG_PCI_DOMAINS
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 596efa6..9f0fa0e 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -162,5 +162,8 @@ extern int pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
                                struct resource *res, unsigned int reg);
 extern struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
                                struct pci_dev *bridge, int busnr);
+extern int pci_resource_alignment(struct pci_dev *dev, int resno);
+extern int pci_resource_bar(struct pci_dev *dev, int resno,
+                           enum pci_bar_type *type);

 #endif /* DRIVERS_PCI_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 7cdb834..b9f759d 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -493,7 +493,7 @@ struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
        child->self = bridge;
        child->bridge = get_device(&bridge->dev);
        /* Set up default resource pointers and names.. */
-       for (i = 0; i < 4; i++) {
+       for (i = 0; i < PCI_BRIDGE_RES_NUM; i++) {
                child->resource[i] = &bridge->resource[PCI_BRIDGE_RESOURCES+i];
                child->resource[i]->name = child->name;
        }
@@ -842,6 +842,11 @@ static int pci_setup_device(struct pci_dev * dev)
        return 0;
 }

+static void pci_release_capabilities(struct pci_dev *dev)
+{
+       pci_vpd_release(dev);
+}
+
 /**
  * pci_release_dev - free a pci device structure when all users of it are finished.
  * @dev: device that's been disconnected
@@ -854,7 +859,7 @@ static void pci_release_dev(struct device *dev)
        struct pci_dev *pci_dev;

        pci_dev = to_pci_dev(dev);
-       pci_vpd_release(pci_dev);
+       pci_release_capabilities(pci_dev);
        kfree(pci_dev);
 }

@@ -934,8 +939,6 @@ struct pci_dev *alloc_pci_dev(void)

        INIT_LIST_HEAD(&dev->bus_list);

-       pci_msi_init_pci_dev(dev);
-
        return dev;
 }
 EXPORT_SYMBOL(alloc_pci_dev);
@@ -1003,11 +1006,21 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
                return NULL;
        }

-       pci_vpd_pci22_init(dev);
-
        return dev;
 }

+static void pci_init_capabilities(struct pci_dev *dev)
+{
+       /* MSI/MSI-X list */
+       pci_msi_init_pci_dev(dev);
+
+       /* Power Management */
+       pci_pm_init(dev);
+
+       /* Vital Product Data */
+       pci_vpd_pci22_init(dev);
+}
+
 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 {
        device_initialize(&dev->dev);
@@ -1024,8 +1037,8 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
        /* Fix up broken headers */
        pci_fixup_device(pci_fixup_header, dev);

-       /* Initialize power management of the device */
-       pci_pm_init(dev);
+       /* Initialize various capabilities */
+       pci_init_capabilities(dev);

        /*
         * Add the device to our list of discovered devices
diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index e1098c3..f6f2a59 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -352,15 +352,16 @@ static int show_device(struct seq_file *m, void *v)
                        dev->vendor,
                        dev->device,
                        dev->irq);
-       /* Here should be 7 and not PCI_NUM_RESOURCES as we need to preserve compatibility */
-       for (i=0; i<7; i++) {
+
+       /* only print standard and ROM resources to preserve compatibility */
+       for (i = 0; i <= PCI_ROM_RESOURCE; i++) {
                resource_size_t start, end;
                pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
                seq_printf(m, "\t%16llx",
                        (unsigned long long)(start |
                        (dev->resource[i].flags & PCI_REGION_FLAG_MASK)));
        }
-       for (i=0; i<7; i++) {
+       for (i = 0; i <= PCI_ROM_RESOURCE; i++) {
                resource_size_t start, end;
                pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
                seq_printf(m, "\t%16llx",
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 6c78cf8..d454ec3 100644
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
-                       /* For bridges size != alignment */
-                       align = resource_alignment(r);
+                       align = pci_resource_alignment(dev, i);
                        order = __ffs(align) - 20;
                        if (order > 11) {
                                dev_warn(&dev->dev, "BAR %d bad alignment %llx: "
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 56e4042..b6bb1ad 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -26,11 +26,13 @@
 #include "pci.h"


-void pci_update_resource(struct pci_dev *dev, struct resource *res, int resno)
+void pci_update_resource(struct pci_dev *dev, int resno)
 {
        struct pci_bus_region region;
        u32 new, check, mask;
        int reg;
+       enum pci_bar_type type;
+       struct resource *res = dev->resource + resno;

        /*
         * Ignore resources for unimplemented BARs and unused resource slots
@@ -63,17 +65,13 @@ void pci_update_resource(struct pci_dev *dev, struct resource *res, int resno)
        else
                mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;

-       if (resno < 6) {
-               reg = PCI_BASE_ADDRESS_0 + 4 * resno;
-       } else if (resno == PCI_ROM_RESOURCE) {
+       reg = pci_resource_bar(dev, resno, &type);
+       if (!reg)
+               return;
+       if (type == pci_bar_rom) {
                if (!(res->flags & IORESOURCE_ROM_ENABLE))
                        return;
                new |= PCI_ROM_ADDRESS_ENABLE;
-               reg = dev->rom_base_reg;
-       } else {
-               /* Hmm, non-standard resource. */
-
-               return;         /* kill uninitialised var warning */
        }

        pci_write_config_dword(dev, reg, new);
@@ -136,7 +134,7 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
        size = resource_size(res);
        min = (res->flags & IORESOURCE_IO) ? PCIBIOS_MIN_IO : PCIBIOS_MIN_MEM;

-       align = resource_alignment(res);
+       align = pci_resource_alignment(dev, resno);
        if (!align) {
                dev_err(&dev->dev, "BAR %d: can't allocate resource (bogus "
                        "alignment) [%#llx-%#llx] flags %#lx\n",
@@ -170,7 +168,7 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
        } else {
                res->flags &= ~IORESOURCE_STARTALIGN;
                if (resno < PCI_BRIDGE_RESOURCES)
-                       pci_update_resource(dev, res, resno);
+                       pci_update_resource(dev, resno);
        }

        return ret;
@@ -208,7 +206,7 @@ int pci_assign_resource_fixed(struct pci_dev *dev, int resno)
                        (unsigned long long)res->start,
                        (unsigned long long)res->end);
        } else if (resno < PCI_BRIDGE_RESOURCES) {
-               pci_update_resource(dev, res, resno);
+               pci_update_resource(dev, resno);
        }

        return ret;
@@ -234,7 +232,7 @@ void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
                if (!(r->flags) || r->parent)
                        continue;

-               r_align = resource_alignment(r);
+               r_align = pci_resource_alignment(dev, i);
                if (!r_align) {
                        dev_warn(&dev->dev, "BAR %d: bogus alignment "
                                "[%#llx-%#llx] flags %#lx\n",
@@ -247,7 +245,8 @@ void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
                        struct resource_list *ln = list->next;

                        if (ln)
-                               align = resource_alignment(ln->res);
+                               align = pci_resource_alignment(ln->dev,
+                                               ln->res - ln->dev->resource);

                        if (r_align > align) {
                                tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index cc78be6..a0d6381 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -76,7 +76,30 @@ enum pci_mmap_state {
 #define PCI_DMA_FROMDEVICE     2
 #define PCI_DMA_NONE           3

-#define DEVICE_COUNT_RESOURCE  12
+/*
+ *  For PCI devices, the region numbers are assigned this way:
+ */
+enum {
+       /* #0-5: standard PCI regions */
+       PCI_STD_RESOURCES,
+       PCI_STD_RESOURCES_END = 5,
+
+       /* #6: expansion ROM */
+       PCI_ROM_RESOURCE,
+
+       /* address space assigned to buses behind the bridge */
+#ifndef PCI_BRIDGE_RES_NUM
+#define PCI_BRIDGE_RES_NUM 4
+#endif
+       PCI_BRIDGE_RESOURCES,
+       PCI_BRIDGE_RES_END = PCI_BRIDGE_RESOURCES + PCI_BRIDGE_RES_NUM - 1,
+
+       /* total resources associated with a PCI device */
+       PCI_NUM_RESOURCES,
+
+       /* preserve this for compatibility */
+       DEVICE_COUNT_RESOURCE
+};

 typedef int __bitwise pci_power_t;

@@ -261,18 +284,6 @@ static inline void pci_add_saved_cap(struct pci_dev *pci_dev,
        hlist_add_head(&new_cap->next, &pci_dev->saved_cap_space);
 }

-/*
- *  For PCI devices, the region numbers are assigned this way:
- *
- *     0-5     standard PCI regions
- *     6       expansion ROM
- *     7-10    bridges: address space assigned to buses behind the bridge
- */
-
-#define PCI_ROM_RESOURCE       6
-#define PCI_BRIDGE_RESOURCES   7
-#define PCI_NUM_RESOURCES      11
-
 #ifndef PCI_BUS_NUM_RESOURCES
 #define PCI_BUS_NUM_RESOURCES  16
 #endif
@@ -626,7 +637,7 @@ int pcix_get_mmrbc(struct pci_dev *dev);
 int pcix_set_mmrbc(struct pci_dev *dev, int mmrbc);
 int pcie_get_readrq(struct pci_dev *dev);
 int pcie_set_readrq(struct pci_dev *dev, int rq);
-void pci_update_resource(struct pci_dev *dev, struct resource *res, int resno);
+void pci_update_resource(struct pci_dev *dev, int resno);
 int __must_check pci_assign_resource(struct pci_dev *dev, int i);
 int pci_select_bars(struct pci_dev *dev, unsigned long flags);

--
1.5.6.4

