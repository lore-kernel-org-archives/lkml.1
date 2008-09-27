Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbYI0I2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbYI0I2N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 04:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYI0I1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 04:27:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:38269 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbYI0I1s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 04:27:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,319,1220252400"; 
   d="scan'208";a="444304299"
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
Date: Sat, 27 Sep 2008 16:27:44 +0800
Subject: [PATCH 1/6 v3] PCI: export some functions and macros
Thread-Topic: [PATCH 1/6 v3] PCI: export some functions and macros
Thread-Index: AckgeuoKoZ+SczqKR5eJ0UGeSMcRBg==
Message-ID: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F0@pdsmsx502.ccr.corp.intel.com>
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

Export some functions and move some macros from c file to header file.

Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Alex Chiang <achiang@hp.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 drivers/pci/pci-sysfs.c |   10 ++++----
 drivers/pci/pci.c       |    2 +-
 drivers/pci/pci.h       |   20 ++++++++++++++++++
 drivers/pci/probe.c     |   50 +++++++++++++++++++++-------------------------
 drivers/pci/setup-bus.c |    4 +-
 drivers/pci/setup-res.c |    2 +-
 include/linux/pci.h     |    4 +-
 7 files changed, 54 insertions(+), 38 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 9c71858..f99160d 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -696,7 +696,7 @@ static struct bin_attribute pci_config_attr = {
                .name = "config",
                .mode = S_IRUGO | S_IWUSR,
        },
-       .size = 256,
+       .size = PCI_CFG_SPACE_SIZE,
        .read = pci_read_config,
        .write = pci_write_config,
 };
@@ -706,7 +706,7 @@ static struct bin_attribute pcie_config_attr = {
                .name = "config",
                .mode = S_IRUGO | S_IWUSR,
        },
-       .size = 4096,
+       .size = PCI_CFG_SPACE_EXP_SIZE,
        .read = pci_read_config,
        .write = pci_write_config,
 };
@@ -724,7 +724,7 @@ int __must_check pci_create_sysfs_dev_files (struct pci_dev *pdev)
        if (!sysfs_initialized)
                return -EACCES;

-       if (pdev->cfg_size < 4096)
+       if (pdev->cfg_size < PCI_CFG_SPACE_EXP_SIZE)
                retval = sysfs_create_bin_file(&pdev->dev.kobj, &pci_config_attr);
        else
                retval = sysfs_create_bin_file(&pdev->dev.kobj, &pcie_config_attr);
@@ -795,7 +795,7 @@ err_vpd:
                kfree(pdev->vpd->attr);
        }
 err_config_file:
-       if (pdev->cfg_size < 4096)
+       if (pdev->cfg_size < PCI_CFG_SPACE_EXP_SIZE)
                sysfs_remove_bin_file(&pdev->dev.kobj, &pci_config_attr);
        else
                sysfs_remove_bin_file(&pdev->dev.kobj, &pcie_config_attr);
@@ -820,7 +820,7 @@ void pci_remove_sysfs_dev_files(struct pci_dev *pdev)
                sysfs_remove_bin_file(&pdev->dev.kobj, pdev->vpd->attr);
                kfree(pdev->vpd->attr);
        }
-       if (pdev->cfg_size < 4096)
+       if (pdev->cfg_size < PCI_CFG_SPACE_EXP_SIZE)
                sysfs_remove_bin_file(&pdev->dev.kobj, &pci_config_attr);
        else
                sysfs_remove_bin_file(&pdev->dev.kobj, &pcie_config_attr);
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index c9884bb..259eaff 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -216,7 +216,7 @@ int pci_find_ext_capability(struct pci_dev *dev, int cap)
        int ttl = 480; /* 3840 bytes, minimum 8 bytes per capability */
        int pos = 0x100;

-       if (dev->cfg_size <= 256)
+       if (dev->cfg_size <= PCI_CFG_SPACE_SIZE)
                return 0;

        if (pci_read_config_dword(dev, pos, &header) != PCIBIOS_SUCCESSFUL)
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index d807cd7..596efa6 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -1,3 +1,9 @@
+#ifndef DRIVERS_PCI_H
+#define DRIVERS_PCI_H
+
+#define PCI_CFG_SPACE_SIZE     256
+#define PCI_CFG_SPACE_EXP_SIZE 4096
+
 /* Functions internal to the PCI core code */

 extern int pci_uevent(struct device *dev, struct kobj_uevent_env *env);
@@ -144,3 +150,17 @@ struct pci_slot_attribute {
 };
 #define to_pci_slot_attr(s) container_of(s, struct pci_slot_attribute, attr)

+enum pci_bar_type {
+       pci_bar_unknown,        /* Standard PCI BAR probe */
+       pci_bar_io,             /* An io port BAR */
+       pci_bar_mem32,          /* A 32-bit memory BAR */
+       pci_bar_mem64,          /* A 64-bit memory BAR */
+       pci_bar_rom,            /* A ROM BAR */
+};
+
+extern int pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
+                               struct resource *res, unsigned int reg);
+extern struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
+                               struct pci_dev *bridge, int busnr);
+
+#endif /* DRIVERS_PCI_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 36698e5..7cdb834 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -14,8 +14,6 @@

 #define CARDBUS_LATENCY_TIMER  176     /* secondary latency timer */
 #define CARDBUS_RESERVE_BUSNR  3
-#define PCI_CFG_SPACE_SIZE     256
-#define PCI_CFG_SPACE_EXP_SIZE 4096

 /* Ugh.  Need to stop exporting this to modules. */
 LIST_HEAD(pci_root_buses);
@@ -203,13 +201,6 @@ static u64 pci_size(u64 base, u64 maxbase, u64 mask)
        return size;
 }

-enum pci_bar_type {
-       pci_bar_unknown,        /* Standard PCI BAR probe */
-       pci_bar_io,             /* An io port BAR */
-       pci_bar_mem32,          /* A 32-bit memory BAR */
-       pci_bar_mem64,          /* A 64-bit memory BAR */
-};
-
 static inline enum pci_bar_type decode_bar(struct resource *res, u32 bar)
 {
        if ((bar & PCI_BASE_ADDRESS_SPACE) == PCI_BASE_ADDRESS_SPACE_IO) {
@@ -224,16 +215,21 @@ static inline enum pci_bar_type decode_bar(struct resource *res, u32 bar)
        return pci_bar_mem32;
 }

-/*
- * If the type is not unknown, we assume that the lowest bit is 'enable'.
- * Returns 1 if the BAR was 64-bit and 0 if it was 32-bit.
+/**
+ * pci_read_base - read a PCI BAR
+ * @dev: the PCI device
+ * @type: type of the BAR
+ * @res: resource buffer to be filled in
+ * @pos: BAR position in the config space
+ *
+ * Returns 1 if the BAR is 64-bit, or 0 if 32-bit.
  */
-static int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
+int pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
                        struct resource *res, unsigned int pos)
 {
        u32 l, sz, mask;

-       mask = type ? ~PCI_ROM_ADDRESS_ENABLE : ~0;
+       mask = (type == pci_bar_rom) ? ~PCI_ROM_ADDRESS_ENABLE : ~0;

        res->name = pci_name(dev);

@@ -258,7 +254,11 @@ static int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
        if (l == 0xffffffff)
                l = 0;

-       if (type == pci_bar_unknown) {
+       if (type == pci_bar_rom) {
+               res->flags |= (l & IORESOURCE_ROM_ENABLE);
+               l &= PCI_ROM_ADDRESS_MASK;
+               mask = (u32)PCI_ROM_ADDRESS_MASK;
+       } else {
                type = decode_bar(res, l);
                res->flags |= pci_calc_resource_flags(l) | IORESOURCE_SIZEALIGN;
                if (type == pci_bar_io) {
@@ -268,10 +268,6 @@ static int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
                        l &= PCI_BASE_ADDRESS_MEM_MASK;
                        mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
                }
-       } else {
-               res->flags |= (l & IORESOURCE_ROM_ENABLE);
-               l &= PCI_ROM_ADDRESS_MASK;
-               mask = (u32)PCI_ROM_ADDRESS_MASK;
        }

        if (type == pci_bar_mem64) {
@@ -335,7 +331,7 @@ static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
        for (pos = 0; pos < howmany; pos++) {
                struct resource *res = &dev->resource[pos];
                reg = PCI_BASE_ADDRESS_0 + (pos << 2);
-               pos += __pci_read_base(dev, pci_bar_unknown, res, reg);
+               pos += pci_read_base(dev, pci_bar_unknown, res, reg);
        }

        if (rom) {
@@ -344,7 +340,7 @@ static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
                res->flags = IORESOURCE_MEM | IORESOURCE_PREFETCH |
                                IORESOURCE_READONLY | IORESOURCE_CACHEABLE |
                                IORESOURCE_SIZEALIGN;
-               __pci_read_base(dev, pci_bar_mem32, res, rom);
+               pci_read_base(dev, pci_bar_mem32, res, rom);
        }
 }

@@ -366,9 +362,6 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
                        child->resource[i] = child->parent->resource[i - 3];
        }

-       for(i=0; i<3; i++)
-               child->resource[i] = &dev->resource[PCI_BRIDGE_RESOURCES+i];
-
        res = child->resource[0];
        pci_read_config_byte(dev, PCI_IO_BASE, &io_base_lo);
        pci_read_config_byte(dev, PCI_IO_LIMIT, &io_limit_lo);
@@ -461,7 +454,7 @@ static struct pci_bus * pci_alloc_bus(void)
        return b;
 }

-static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
+struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
                                           struct pci_dev *bridge, int busnr)
 {
        struct pci_bus *child;
@@ -474,12 +467,10 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
        if (!child)
                return NULL;

-       child->self = bridge;
        child->parent = parent;
        child->ops = parent->ops;
        child->sysdata = parent->sysdata;
        child->bus_flags = parent->bus_flags;
-       child->bridge = get_device(&bridge->dev);

        /* initialize some portions of the bus device, but don't register it
         * now as the parent is not properly set up yet.  This device will get
@@ -496,6 +487,11 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
        child->primary = parent->secondary;
        child->subordinate = 0xff;

+       if (!bridge)
+               return child;
+
+       child->self = bridge;
+       child->bridge = get_device(&bridge->dev);
        /* Set up default resource pointers and names.. */
        for (i = 0; i < 4; i++) {
                child->resource[i] = &bridge->resource[PCI_BRIDGE_RESOURCES+i];
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 3abbfad..6c78cf8 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -299,7 +299,7 @@ static void pbus_size_io(struct pci_bus *bus)

                        if (r->parent || !(r->flags & IORESOURCE_IO))
                                continue;
-                       r_size = r->end - r->start + 1;
+                       r_size = resource_size(r);

                        if (r_size < 0x400)
                                /* Might be re-aligned for ISA */
@@ -350,7 +350,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask, unsigned long

                        if (r->parent || (r->flags & mask) != type)
                                continue;
-                       r_size = r->end - r->start + 1;
+                       r_size = resource_size(r);
                        /* For bridges size != alignment */
                        align = resource_alignment(r);
                        order = __ffs(align) - 20;
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 1a5fc83..56e4042 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -133,7 +133,7 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
        resource_size_t size, min, align;
        int ret;

-       size = res->end - res->start + 1;
+       size = resource_size(res);
        min = (res->flags & IORESOURCE_IO) ? PCIBIOS_MIN_IO : PCIBIOS_MIN_MEM;

        align = resource_alignment(res);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 98dc624..cc78be6 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -456,8 +456,8 @@ struct pci_driver {

 /**
  * PCI_VDEVICE - macro used to describe a specific pci device in short form
- * @vend: the vendor name
- * @dev: the 16 bit PCI Device ID
+ * @vendor: the vendor name
+ * @device: the 16 bit PCI Device ID
  *
  * This macro is used to create a struct pci_device_id that matches a
  * specific PCI device.  The subvendor, and subdevice fields will be set
--
1.5.6.4

