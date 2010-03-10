Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab0CJPnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 10:43:21 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:27705 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab0CJPnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 10:43:09 -0500
X-IronPort-AV: E=Sophos;i="4.49,614,1262563200"; 
   d="scan'208";a="9880212"
Date: Wed, 10 Mar 2010 15:47:16 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [PATCH 5 of 5] xen pci platform device driver
Message-ID: <alpine.DEB.2.00.1003101504480.28412@kaball-desktop>
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
index cab100a..b2795db 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -60,4 +60,14 @@ config XEN_SYS_HYPERVISOR
          Create entries under /sys/hypervisor describing the Xen
 	 hypervisor environment.  When running native or in another
 	 virtual environment, /sys/hypervisor will still be present,
-	 but will have no xen contents.
\ No newline at end of file
+	 but will have no xen contents.
+
+config XEN_PLATFORM_PCI
+	tristate "xen platform pci device driver"
+	depends on XEN
+	select XEN_XENBUS_FRONTEND
+	help
+	  Driver for the Xen Pci Platform device: it is responsible for
+	  initializing xenbus and grant_table when running in a Xen HVM
+	  domain. As a consequence this driver is required to run any Xen PV
+	  frontend on Xen HVM.
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 7c28434..2a502d2 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -9,4 +9,5 @@ obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
 obj-$(CONFIG_XEN_BALLOON)	+= balloon.o
 obj-$(CONFIG_XEN_DEV_EVTCHN)	+= evtchn.o
 obj-$(CONFIG_XENFS)		+= xenfs/
-obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
\ No newline at end of file
+obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
+obj-$(CONFIG_XEN_PLATFORM_PCI)		+= platform-pci.o
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 7d8f531..dd5be9d 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -40,11 +40,14 @@
 #include <xen/interface/xen.h>
 #include <xen/page.h>
 #include <xen/grant_table.h>
+#include <xen/platform_pci.h>
 #include <asm/xen/hypercall.h>
 
 #include <asm/pgtable.h>
 #include <asm/sync_bitops.h>
 
+#include <xen/interface/memory.h>
+#include <linux/io.h>
 
 /* External tools reserve first few grant table entries. */
 #define NR_RESERVED_ENTRIES 8
@@ -57,6 +60,7 @@ static unsigned int boot_max_nr_grant_frames;
 static int gnttab_free_count;
 static grant_ref_t gnttab_free_head;
 static DEFINE_SPINLOCK(gnttab_list_lock);
+static unsigned long hvm_pv_resume_frames;
 
 static struct grant_entry *shared;
 
@@ -447,6 +451,26 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 	unsigned int nr_gframes = end_idx + 1;
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
 	frames = kmalloc(nr_gframes * sizeof(unsigned long), GFP_ATOMIC);
 	if (!frames)
 		return -ENOMEM;
@@ -474,9 +498,28 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 
 int gnttab_resume(void)
 {
-	if (max_nr_grant_frames() < nr_grant_frames)
+	unsigned int max_nr_gframes;
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
+		shared = ioremap(hvm_pv_resume_frames, PAGE_SIZE * max_nr_gframes);
+		if (shared == NULL) {
+			printk(KERN_WARNING
+					"Fail to ioremap gnttab share frames\n");
+			return -ENOMEM;
+		}
+	}
+
+	gnttab_map(0, nr_grant_frames - 1);
+
+	return 0;
 }
 
 int gnttab_suspend(void)
@@ -503,15 +546,12 @@ static int gnttab_expand(unsigned int req_entries)
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
 
@@ -555,4 +595,16 @@ static int __devinit gnttab_init(void)
 	return -ENOMEM;
 }
 
-core_initcall(gnttab_init);
+static int __devinit __gnttab_init(void)
+{
+	if (!xen_pv_domain())
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
index 0000000..71e76fd
--- /dev/null
+++ b/drivers/xen/platform-pci.c
@@ -0,0 +1,220 @@
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
+#include <xen/interface/platform_pci.h>
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
+static int unplug;
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
+#define XEN_IOPORT_MAGIC_VAL 0x49d2
+#define XEN_IOPORT_LINUX_PRODNUM 0xffff
+#define XEN_IOPORT_LINUX_DRVVER  ((LINUX_VERSION_CODE << 8) + 0x0)
+
+static int check_platform_magic(struct device *dev, long ioaddr, long iolen)
+{
+	short magic;
+	char protocol, *err;
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
+static int __init platform_pci_module_init(void)
+{
+	int rc;
+	char *p, *q;
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
+			printk(KERN_WARNING "unrecognised option '%s' "
+				 "in module parameter 'dev_unplug'\n", p);
+	}
+
+	rc = pci_register_driver(&platform_driver);
+	if (rc) {
+		printk(KERN_INFO DRV_NAME
+		       ": No platform pci device model found\n");
+		return rc;
+	}
+
+	return 0;
+}
+
+module_init(platform_pci_module_init);
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 586b8f8..439372a 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -779,16 +779,24 @@ void xenbus_probe(struct work_struct *unused)
 	blocking_notifier_call_chain(&xenstore_chain, 0, NULL);
 }
 
-static int __init xenbus_probe_init(void)
+static int __init __xenbus_probe_init(void)
+{
+	if (!xen_pv_domain())
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
 
 	DPRINTK("");
 
-	err = -ENODEV;
-	if (!xen_domain())
-		goto out_error;
-
 	/* Register ourselves with the kernel bus subsystem */
 	err = bus_register(&xenbus_frontend.bus);
 	if (err)
@@ -850,7 +858,7 @@ static int __init xenbus_probe_init(void)
 	return err;
 }
 
-postcore_initcall(xenbus_probe_init);
+postcore_initcall(__xenbus_probe_init);
 
 MODULE_LICENSE("GPL");
 
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index a40f1cd..811cda5 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -51,6 +51,7 @@ struct gnttab_free_callback {
 	u16 count;
 };
 
+int gnttab_init(void);
 int gnttab_suspend(void);
 int gnttab_resume(void);
 
diff --git a/include/xen/interface/grant_table.h b/include/xen/interface/grant_table.h
index 39da93c..39e5717 100644
--- a/include/xen/interface/grant_table.h
+++ b/include/xen/interface/grant_table.h
@@ -28,6 +28,7 @@
 #ifndef __XEN_PUBLIC_GRANT_TABLE_H__
 #define __XEN_PUBLIC_GRANT_TABLE_H__
 
+#include <xen/interface/xen.h>
 
 /***********************************
  * GRANT TABLE REPRESENTATION
diff --git a/include/xen/interface/platform_pci.h b/include/xen/interface/platform_pci.h
new file mode 100644
index 0000000..bc230cd
--- /dev/null
+++ b/include/xen/interface/platform_pci.h
@@ -0,0 +1,45 @@
+/******************************************************************************
+ * platform_pci.h
+ *
+ * Interface for granting foreign access to page frames, and receiving
+ * page-ownership transfers.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to
+ * deal in the Software without restriction, including without limitation the
+ * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
+ * sell copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef __XEN_PUBLIC_PLATFORM_PCI_H__
+#define __XEN_PUBLIC_PLATFORM_PCI_H__
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
+#define UNPLUG_ALL_IDE_DISKS 1
+#define UNPLUG_ALL_NICS 2
+#define UNPLUG_AUX_IDE_DISKS 4
+#define UNPLUG_ALL 7
+
+#endif /* __XEN_PUBLIC_PLATFORM_PCI_H__ */
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
index b9763ba..7fa0c22 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -173,6 +173,7 @@ void unregister_xenbus_watch(struct xenbus_watch *watch);
 void xs_suspend(void);
 void xs_resume(void);
 void xs_suspend_cancel(void);
+int xenbus_probe_init(void);
 
 /* Used by xenbus_dev to borrow kernel's store connection. */
 void *xenbus_dev_request_and_reply(struct xsd_sockmsg *msg);
