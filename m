Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab0CBS1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 13:27:30 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:28349 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab0CBS11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 13:27:27 -0500
X-IronPort-AV: E=Sophos;i="4.49,568,1262563200"; 
   d="scan'208";a="9747279"
Date: Tue, 2 Mar 2010 18:31:10 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [PATCH 4 of 4] Linux pvops: xen pci platform device driver
Message-ID: <alpine.DEB.2.00.1003021748250.22259@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch adds the xen pci platform device driver that is responsible
for initializing the grant table and xenbus in PV on HVM mode.
Few changes to xenbus and grant table are necessary to allow the delayed
initialization in HVM mode.
Finally grant table needs few additional modifications to work in HVM
mode.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Sheng Yang <sheng@linux.intel.com>

---

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 22c8818..e1c78f7 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -184,3 +184,10 @@ config ACPI_PROCESSOR_XEN
 	depends on XEN_DOM0 && ACPI_PROCESSOR && CPU_FREQ
 	default y
 
+config XEN_PLATFORM_PCI
+	bool "xen platform pci device driver"
+	depends on XEN
+	select XEN_XENBUS_FRONTEND
+	help
+	  Necessary to run Xen PV drivers in Xen HVM domains.
+
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index f7893f3..9c742dd 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -19,3 +19,4 @@ obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
 obj-$(CONFIG_XEN_S3)			+= acpi.o
 obj-$(CONFIG_XEN_MCE)			+= mce.o
 obj-$(CONFIG_ACPI_PROCESSOR_XEN)	+= acpi_processor.o
+obj-$(CONFIG_XEN_PLATFORM_PCI)		+= platform-pci.o
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index c653970..c65b249 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -40,11 +40,15 @@
 #include <xen/interface/xen.h>
 #include <xen/page.h>
 #include <xen/grant_table.h>
+#include <xen/platform_pci.h>
 #include <asm/xen/hypercall.h>
 
 #include <asm/pgtable.h>
 #include <asm/sync_bitops.h>
 
+#include <xen/interface/memory.h>
+#include <linux/io.h>
+
 /* External tools reserve first few grant table entries. */
 #define NR_RESERVED_ENTRIES 8
 #define GNTTAB_LIST_END 0xffffffff
@@ -65,6 +69,7 @@ static LIST_HEAD(gnttab_pending_free_pages);
 static DEFINE_TIMER(gnttab_delayed_free_timer, pending_free_timer, 0, 0);
 static DEFINE_SPINLOCK(gnttab_pending_free_lock);
 static DEFINE_SPINLOCK(gnttab_list_lock);
+static unsigned long hvm_pv_resume_frames;
 
 static union {
 	struct grant_entry_v1 *v1;
@@ -697,10 +702,13 @@ static void gnttab_request_version(void)
 	int rc;
 	struct gnttab_set_version gsv;
 
-	gsv.version = 2;
+	if (xen_hvm_domain())
+		gsv.version = 1;
+	else
+		gsv.version = 2;
 	rc = HYPERVISOR_grant_table_op(GNTTABOP_set_version, &gsv, 1);
 	if (rc == 0)
-		grant_table_version = 2;
+		grant_table_version = xen_hvm_domain() ? 1 : 2;
 	else {
 		if (grant_table_version == 2) {
 			/*
@@ -712,7 +720,7 @@ static void gnttab_request_version(void)
 			 */
 			panic("we need grant tables version 2, but only version 1 is available");
 		}
-		grant_table_version = 1;
+		grant_table_version = xen_hvm_domain() ? 2 : 1;
 	}
 	printk(KERN_INFO "Grant tables using version %d layout.\n", grant_table_version);
 }
@@ -726,6 +734,26 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 	unsigned int nr_sframes;
 	int rc;
 
+	if (xen_hvm_domain()) {
+		struct xen_add_to_physmap xatp;
+		unsigned int i = end_idx;
+		rc = 0;
+		/*
+		 * Loop backwards, so that the first hypercall has the largest
+		 * index, ensuring that the table will grow only once.
+		 */
+		do {
+			xatp.domid = DOMID_SELF;
+			xatp.idx = i;
+			xatp.space = XENMAPSPACE_grant_table;
+			xatp.gpfn = (hvm_pv_resume_frames >> PAGE_SHIFT) + i;
+			if ((rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp)) != 0)
+				break;
+		} while (i-- > start_idx);
+
+		return rc;
+	}
+
 	gframes = kmalloc(nr_gframes * sizeof(unsigned long), GFP_ATOMIC);
 	if (!gframes)
 		return -ENOMEM;
@@ -890,10 +918,31 @@ EXPORT_SYMBOL_GPL(gnttab_reset_grant_page);
 
 int gnttab_resume(void)
 {
+	unsigned int max_nr_gframes;
+
 	gnttab_request_version();
-	if (max_nr_grant_frames() < nr_grant_frames)
+
+	max_nr_gframes = max_nr_grant_frames();
+	if (max_nr_gframes < nr_grant_frames)
 		return -ENOSYS;
-	return gnttab_map(0, nr_grant_frames - 1);
+
+	if (xen_pv_domain())
+		return gnttab_map(0, nr_grant_frames - 1);
+
+	if (!hvm_pv_resume_frames) {
+		hvm_pv_resume_frames = alloc_xen_mmio(PAGE_SIZE * max_nr_gframes);
+		shared.raw = ioremap(hvm_pv_resume_frames, PAGE_SIZE * max_nr_gframes);
+		if (shared.raw == NULL) {
+			printk(KERN_WARNING
+					"Fail to ioremap gnttab share frames\n");
+			return -ENOMEM;
+		}
+	}
+
+	gnttab_map(0, nr_grant_frames - 1);
+
+	return 0;
+
 }
 
 int gnttab_suspend(void)
@@ -922,15 +971,12 @@ static int gnttab_expand(unsigned int req_entries)
 	return rc;
 }
 
-static int __devinit gnttab_init(void)
+int gnttab_init(void)
 {
 	int i;
 	unsigned int max_nr_glist_frames, nr_glist_frames;
 	unsigned int nr_init_grefs;
 
-	if (!xen_domain())
-		return -ENODEV;
-
 	nr_grant_frames = 1;
 	boot_max_nr_grant_frames = __max_nr_grant_frames();
 
@@ -974,4 +1020,16 @@ static int __devinit gnttab_init(void)
 	return -ENOMEM;
 }
 
-core_initcall(gnttab_init);
+static int __devinit __gnttab_init(void)
+{
+	if (!xen_domain())
+		return -ENODEV;
+
+	/* Delay grant-table initialization in the PV on HVM case */
+	if (xen_hvm_domain())
+		return 0;
+
+	return gnttab_init();
+}
+
+core_initcall(__gnttab_init);
diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
new file mode 100644
index 0000000..2738a0a
--- /dev/null
+++ b/drivers/xen/platform-pci.c
@@ -0,0 +1,238 @@
+/******************************************************************************
+ * platform-pci.c
+ * 
+ * Xen platform PCI device driver
+ * Copyright (c) 2005, Intel Corporation.
+ * Copyright (c) 2007, XenSource Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/version.h>
+
+#include <asm/io.h>
+
+#include <xen/grant_table.h>
+#include <xen/platform_pci.h>
+#include <xen/xenbus.h>
+
+#define DRV_NAME    "xen-platform-pci"
+
+MODULE_AUTHOR("ssmith@xensource.com and stefano.stabellini@eu.citrix.com");
+MODULE_DESCRIPTION("Xen platform PCI device");
+MODULE_LICENSE("GPL");
+
+/* NB. [aux-]ide-disks options do not unplug IDE CD-ROM drives. */
+/* NB. aux-ide-disks is equiv to ide-disks except ignores primary master. */
+static char *dev_unplug;
+module_param(dev_unplug, charp, 0644);
+MODULE_PARM_DESC(dev_unplug, "Emulated devices to unplug: "
+		 "[all,][ide-disks,][aux-ide-disks,][nics]\n");
+
+static unsigned long platform_mmio;
+static unsigned long platform_mmio_alloc;
+static unsigned long platform_mmiolen;
+
+unsigned long alloc_xen_mmio(unsigned long len)
+{
+	unsigned long addr;
+
+	addr = platform_mmio + platform_mmio_alloc;
+	platform_mmio_alloc += len;
+	BUG_ON(platform_mmio_alloc > platform_mmiolen);
+
+	return addr;
+}
+
+#define XEN_IOPORT_BASE 0x10
+
+#define XEN_IOPORT_PLATFLAGS	(XEN_IOPORT_BASE + 0) /* 1 byte access (R/W) */
+#define XEN_IOPORT_MAGIC	(XEN_IOPORT_BASE + 0) /* 2 byte access (R) */
+#define XEN_IOPORT_UNPLUG	(XEN_IOPORT_BASE + 0) /* 2 byte access (W) */
+#define XEN_IOPORT_DRVVER	(XEN_IOPORT_BASE + 0) /* 4 byte access (W) */
+
+#define XEN_IOPORT_SYSLOG	(XEN_IOPORT_BASE + 2) /* 1 byte access (W) */
+#define XEN_IOPORT_PROTOVER	(XEN_IOPORT_BASE + 2) /* 1 byte access (R) */
+#define XEN_IOPORT_PRODNUM	(XEN_IOPORT_BASE + 2) /* 2 byte access (W) */
+
+#define XEN_IOPORT_MAGIC_VAL 0x49d2
+#define XEN_IOPORT_LINUX_PRODNUM 0xffff /* NB: register a proper one */
+#define XEN_IOPORT_LINUX_DRVVER  ((LINUX_VERSION_CODE << 8) + 0x0)
+
+#define UNPLUG_ALL_IDE_DISKS 1
+#define UNPLUG_ALL_NICS 2
+#define UNPLUG_AUX_IDE_DISKS 4
+#define UNPLUG_ALL 7
+
+static int check_platform_magic(struct device *dev, long ioaddr, long iolen)
+{
+	short magic, unplug = 0;
+	char protocol, *p, *q, *err;
+
+	for (p = dev_unplug; p; p = q) {
+		q = strchr(dev_unplug, ',');
+		if (q)
+			*q++ = '\0';
+		if (!strcmp(p, "all"))
+			unplug |= UNPLUG_ALL;
+		else if (!strcmp(p, "ide-disks"))
+			unplug |= UNPLUG_ALL_IDE_DISKS;
+		else if (!strcmp(p, "aux-ide-disks"))
+			unplug |= UNPLUG_AUX_IDE_DISKS;
+		else if (!strcmp(p, "nics"))
+			unplug |= UNPLUG_ALL_NICS;
+		else
+			dev_warn(dev, "unrecognised option '%s' "
+				 "in module parameter 'dev_unplug'\n", p);
+	}
+
+	if (iolen < 0x16) {
+		err = "backend too old";
+		goto no_dev;
+	}
+
+	magic = inw(XEN_IOPORT_MAGIC);
+
+	if (magic != XEN_IOPORT_MAGIC_VAL) {
+		err = "unrecognised magic value";
+		goto no_dev;
+	}
+
+	protocol = inb(XEN_IOPORT_PROTOVER);
+
+	dev_info(dev, "I/O protocol version %d\n", protocol);
+
+	switch (protocol) {
+	case 1:
+		outw(XEN_IOPORT_LINUX_PRODNUM, XEN_IOPORT_PRODNUM);
+		outl(XEN_IOPORT_LINUX_DRVVER, XEN_IOPORT_DRVVER);
+		if (inw(XEN_IOPORT_MAGIC) != XEN_IOPORT_MAGIC_VAL) {
+			dev_err(dev, "blacklisted by host\n");
+			return -ENODEV;
+		}
+		/* Fall through */
+	case 0:
+		outw(unplug, XEN_IOPORT_UNPLUG);
+		break;
+	default:
+		err = "unknown I/O protocol version";
+		goto no_dev;
+	}
+
+	return 0;
+
+ no_dev:
+	dev_warn(dev, "failed backend handshake: %s\n", err);
+	if (!unplug)
+		return 0;
+	dev_err(dev, "failed to execute specified dev_unplug options!\n");
+	return -ENODEV;
+}
+
+static int __devinit platform_pci_init(struct pci_dev *pdev,
+				       const struct pci_device_id *ent)
+{
+	int i, ret;
+	long ioaddr, iolen;
+	long mmio_addr, mmio_len;
+
+	i = pci_enable_device(pdev);
+	if (i)
+		return i;
+
+	ioaddr = pci_resource_start(pdev, 0);
+	iolen = pci_resource_len(pdev, 0);
+
+	mmio_addr = pci_resource_start(pdev, 1);
+	mmio_len = pci_resource_len(pdev, 1);
+
+	if (mmio_addr == 0 || ioaddr == 0) {
+		printk(KERN_WARNING DRV_NAME ":no resources found\n");
+		return -ENOENT;
+	}
+
+	if (request_mem_region(mmio_addr, mmio_len, DRV_NAME) == NULL) {
+		printk(KERN_ERR ":MEM I/O resource 0x%lx @ 0x%lx busy\n",
+		       mmio_addr, mmio_len);
+		return -EBUSY;
+	}
+
+	if (request_region(ioaddr, iolen, DRV_NAME) == NULL) {
+		printk(KERN_ERR DRV_NAME ":I/O resource 0x%lx @ 0x%lx busy\n",
+		       iolen, ioaddr);
+		release_mem_region(mmio_addr, mmio_len);
+		return -EBUSY;
+	}
+
+	platform_mmio = mmio_addr;
+	platform_mmiolen = mmio_len;
+
+	ret = check_platform_magic(&pdev->dev, ioaddr, iolen);
+	if (ret < 0)
+		goto out;
+
+	if ((ret = gnttab_init()))
+		goto out;
+
+	if ((ret = xenbus_probe_init()))
+		goto out;
+
+ out:
+	if (ret) {
+		release_mem_region(mmio_addr, mmio_len);
+		release_region(ioaddr, iolen);
+	}
+
+	return ret;
+}
+
+#define XEN_PLATFORM_VENDOR_ID 0x5853
+#define XEN_PLATFORM_DEVICE_ID 0x0001
+static struct pci_device_id platform_pci_tbl[] __devinitdata = {
+	{XEN_PLATFORM_VENDOR_ID, XEN_PLATFORM_DEVICE_ID,
+	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	/* Continue to recognise the old ID for now */
+	{0xfffd, 0x0101, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{0,}
+};
+
+MODULE_DEVICE_TABLE(pci, platform_pci_tbl);
+
+static struct pci_driver platform_driver = {
+	name:     DRV_NAME,
+	probe:    platform_pci_init,
+	id_table: platform_pci_tbl,
+};
+
+static int pci_device_registered;
+
+static int __init platform_pci_module_init(void)
+{
+	int rc;
+
+	rc = pci_register_driver(&platform_driver);
+	if (rc) {
+		printk(KERN_INFO DRV_NAME
+		       ": No platform pci device model found\n");
+		return rc;
+	}
+
+	pci_device_registered = 1;
+	return 0;
+}
+
+module_init(platform_pci_module_init);
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index c18ae96..8e443e7 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -682,17 +682,25 @@ void xenbus_probe(struct work_struct *unused)
 	blocking_notifier_call_chain(&xenstore_chain, 0, NULL);
 }
 
-static int __init xenbus_probe_init(void)
+static int __init __xenbus_probe_init(void)
+{
+	if (!xen_domain())
+		return -ENODEV;
+
+	/* Delay initialization in the PV on HVM case */
+	if (xen_hvm_domain())
+		return 0;
+
+	return xenbus_probe_init();
+}
+
+int xenbus_probe_init(void)
 {
 	int err = 0;
 	unsigned long page = 0;
 
 	DPRINTK("");
 
-	err = -ENODEV;
-	if (!xen_domain())
-		return err;
-
 	/*
 	 * Domain0 doesn't have a store_evtchn or store_mfn yet.
 	 */
@@ -768,6 +776,6 @@ static int __init xenbus_probe_init(void)
 	return err;
 }
 
-postcore_initcall(xenbus_probe_init);
+postcore_initcall(__xenbus_probe_init);
 
 MODULE_LICENSE("GPL");
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index ef07e91..3c1920a 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -59,6 +59,7 @@ struct gnttab_free_callback {
 
 void gnttab_reset_grant_page(struct page *page);
 
+int gnttab_init(void);
 int gnttab_suspend(void);
 int gnttab_resume(void);
 
diff --git a/include/xen/platform_pci.h b/include/xen/platform_pci.h
new file mode 100644
index 0000000..c178230
--- /dev/null
+++ b/include/xen/platform_pci.h
@@ -0,0 +1,34 @@
+/******************************************************************************
+ * platform-pci.h
+ * 
+ * Xen platform PCI device driver
+ * Copyright (c) 2004, Intel Corporation. <xiaofeng.ling@intel.com>
+ * Copyright (c) 2007, XenSource Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ */
+
+#ifndef _XEN_PLATFORM_PCI_H
+#define _XEN_PLATFORM_PCI_H
+
+#ifdef CONFIG_XEN_PLATFORM_PCI
+unsigned long alloc_xen_mmio(unsigned long len);
+#else
+static inline unsigned long alloc_xen_mmio(unsigned long len)
+{
+	return 0xffffffff;
+}
+#endif
+
+#endif /* _XEN_PLATFORM_PCI_H */
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index 84dc8b0..17f0c0b 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -173,6 +173,7 @@ void unregister_xenbus_watch(struct xenbus_watch *watch);
 void xs_suspend(void);
 void xs_resume(void);
 void xs_suspend_cancel(void);
+int xenbus_probe_init(void);
 
 /* Used by xenbus_dev to borrow kernel's store connection. */
 void *xenbus_dev_request_and_reply(struct xsd_sockmsg *msg);
