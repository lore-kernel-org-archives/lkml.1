Return-Path: <linux-kernel-owner+w=401wt.eu-S1761756AbXIZSxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761756AbXIZSxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbXIZSxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:53:11 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:42198 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780AbXIZSxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:53:10 -0400
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Sep 2007 14:53:09 EDT
Date: Wed, 26 Sep 2007 14:46:52 -0400
From: Konrad Rzeszutek <konrad@darnok.org>
To: linux-kernel@vger.kernel.org
Cc: pjones@redhat.com, konradr@redhat.com, konradr@linux.vnet.ibm.com
Subject: [PATCH] Add iSCSI iBFT support.
Message-ID: <20070926184652.GA16369@andromeda.dapyr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a /sysfs/firmware/ibft/table binary blob which exports
the iSCSI Boot Firmware Table (iBFT) structure. 

What is iSCSI Boot Firmware Table? It is a mechanism for the iSCSI
tools to extract from the machine NICs the iSCSI connection information
so that they can automagically mount the iSCSI share/target. Currently
the iSCSI information is hard-coded in the initrd.

The full details of the structure are located at:
ftp://ftp.software.ibm.com/systems/support/system_x_pdf/ibm_iscsi_boot_firmware_table_v1.02.pdf

Signed-off-by: Konrad Rzeszutek <konradr@linux.vnet.ibm.com>
Signed-off-by: Peter Jones <pjones@redhat.com>

diff --git a/arch/i386/kernel/setup.c b/arch/i386/kernel/setup.c
index d474cd6..11d700f 100644
--- a/arch/i386/kernel/setup.c
+++ b/arch/i386/kernel/setup.c
@@ -46,7 +46,7 @@ #include <linux/kexec.h>
 #include <linux/crash_dump.h>
 #include <linux/dmi.h>
 #include <linux/pfn.h>
-
+#include <linux/iscsi_ibft.h>
 #include <video/edid.h>
 
 #include <asm/apic.h>
@@ -150,6 +150,9 @@ static inline void copy_edd(void)
 }
 #endif
 
+void *ibft_phys;
+EXPORT_SYMBOL(ibft_phys);
+
 int __initdata user_defined_memmap = 0;
 
 /*
@@ -456,6 +459,15 @@ #ifdef CONFIG_KEXEC
 		reserve_bootmem(crashk_res.start,
 			crashk_res.end - crashk_res.start + 1);
 #endif
+
+	/* Scan for an iBFT (iSCSI Boot Firmware Table) */
+	{
+	unsigned int ibft_len = find_ibft();
+	if (ibft_len)
+		/* The specs says to scan for the table between 512k to 1MB.
+		   We reserve it n case it is in the e820 RAM section. */
+		reserve_bootmem(ibft_phys, PAGE_ALIGN(ibft_len));
+	}
 }
 
 /*
diff --git a/arch/x86_64/kernel/setup.c b/arch/x86_64/kernel/setup.c
index af838f6..0d12775 100644
--- a/arch/x86_64/kernel/setup.c
+++ b/arch/x86_64/kernel/setup.c
@@ -44,6 +44,7 @@ #include <linux/cpufreq.h>
 #include <linux/dmi.h>
 #include <linux/dma-mapping.h>
 #include <linux/ctype.h>
+#include <linux/iscsi_ibft.h>
 
 #include <asm/mtrr.h>
 #include <asm/uaccess.h>
@@ -196,6 +197,9 @@ static inline void copy_edd(void)
 }
 #endif
 
+void *ibft_phys;
+EXPORT_SYMBOL(ibft_phys);
+
 #define EBDA_ADDR_POINTER 0x40E
 
 unsigned __initdata ebda_addr;
@@ -365,6 +369,15 @@ #ifdef CONFIG_KEXEC
 			crashk_res.end - crashk_res.start + 1);
 	}
 #endif
+	/* Scan for an iBFT (iSCSI Boot Firmware Table) */
+	{
+	unsigned int ibft_len = find_ibft();
+	if (ibft_len)
+		/* The specs says to scan for the table between 512k to 1MB.
+		   We reserve it in case it is in the e820 RAM section. */
+		reserve_bootmem_generic((unsigned long)ibft_phys,
+				PAGE_ALIGN(ibft_len));
+	}
 
 	paging_init();
 
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 05f02a3..2d9f01a 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -93,4 +93,14 @@ config DMIID
 	  information from userspace through /sys/class/dmi/id/ or if you want
 	  DMI-based module auto-loading.
 
+config ISCSI_IBFT
+	tristate "iSCSI Boot Firmware Table Attributes"
+	depends on X86
+	default	n
+	help
+	  This option enables support for detection of an iSCSI
+	  Boot Firmware Table (iBFT).  If you wish to detect iSCSI boot
+	  parameters dynamically during system boot, say Y.
+	  Otherwise, say N.
+
 endmenu
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 8d4ebc8..b6319f7 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_EFI_PCDP)		+= pcdp.o
 obj-$(CONFIG_DELL_RBU)          += dell_rbu.o
 obj-$(CONFIG_DCDBAS)		+= dcdbas.o
 obj-$(CONFIG_DMIID)		+= dmi-id.o
+obj-$(CONFIG_ISCSI_IBFT)	+= iscsi_ibft.o
diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
new file mode 100644
index 0000000..b3767fe
--- /dev/null
+++ b/drivers/firmware/iscsi_ibft.c
@@ -0,0 +1,201 @@
+/*
+ * drivers/firmware/iscsi_ibft.c
+ *  Copyright 2007 Red Hat, Inc.
+ *  by Peter Jones <pjones@redhat.com>
+ *  Copyright 2007 IBM
+ *  by Konrad Rzeszutek <konradr@us.ibm.com>
+ *
+ * This code exposes the the iSCSI Boot Format Table to userland via sysfs.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License v2.0 as published by
+ * the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/stat.h>
+#include <linux/err.h>
+#include <linux/ctype.h>
+#include <linux/slab.h>
+#include <linux/limits.h>
+#include <linux/device.h>
+#include <linux/pci.h>
+#include <linux/blkdev.h>
+
+#include <linux/iscsi_ibft.h>
+
+#define ISCSI_IBFT_VERSION  "0.2"
+#define ISCSI_IBFT_DATE	 "2007-Aug-29"
+
+MODULE_AUTHOR
+("Peter Jones <pjones@redhat.com> and Konrad Rzeszutek <konradr@us.ibm.com>");
+MODULE_DESCRIPTION("sysfs interface to BIOS iBFT information");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(ISCSI_IBFT_VERSION);
+
+
+static void ibft_release(struct kobject *kobj)
+{
+	struct ibft_device *ibft = container_of(kobj, struct ibft_device, kobj);
+	kfree(ibft->hdr);
+	kfree(ibft);
+}
+
+static ssize_t
+ibft_read_binary(struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		 loff_t off, size_t count)
+{
+
+	struct ibft_device *ibft = container_of(kobj, struct ibft_device, kobj);
+	ssize_t len = ibft->hdr->length;
+
+	if (off > len)
+		return 0;
+
+	if (off + count > len)
+		count = len - off;
+
+	memcpy(buf, ibft->hdr + off, count);
+
+	return count;
+}
+static int
+ibft_mmap_binary(struct kobject *kobj, struct bin_attribute *attr,
+		 struct vm_area_struct *vma)
+{
+	struct ibft_device *ibft = container_of(kobj, struct ibft_device, kobj);
+	ssize_t len = ibft->hdr->length;
+	unsigned long start = vma->vm_start;
+	unsigned long size = vma->vm_end - vma->vm_start;
+	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long pos;
+	unsigned long pfn;
+	int i;
+
+	pos = (unsigned long)ibft->hdr;
+
+	if (off > len)
+		return -EINVAL;
+
+	if (vma->vm_flags & VM_WRITE)
+		return -EPERM;
+
+	for (i = 0; i < len; i += PAGE_SIZE) {
+		pfn = virt_to_phys((void *)(pos + off)) >> PAGE_SHIFT;
+		if (remap_pfn_range
+		    (vma, start, pfn, PAGE_SIZE, vma->vm_page_prot))
+			return -EAGAIN;
+		start += PAGE_SIZE;
+		if (size <= PAGE_SIZE)
+			break;
+		size -= PAGE_SIZE;
+	}
+	return 0;
+}
+static struct bin_attribute ibft_attribute_binary = {
+	.attr = {
+		 .name = "binary",
+		 .mode = S_IRUSR,
+		 .owner = THIS_MODULE,
+		 },
+	.read = ibft_read_binary,
+	.write = NULL,
+	.mmap = ibft_mmap_binary
+};
+static struct kobj_type ktype_ibft = {
+	.release = ibft_release,
+};
+
+static decl_subsys(ibft, &ktype_ibft, NULL);
+
+static int ibft_device_register(struct ibft_device *idev)
+{
+	int error = 0;
+	int len = 0;
+	struct ibft_header *hdr;
+
+	if (!idev)
+		return 1;
+
+	/* Copy over the data */
+	hdr = (struct ibft_header *)phys_to_virt((unsigned long)ibft_phys);
+	len = hdr->length;
+
+	/* Need PAGE_ALING for mmap functionality. */
+	idev->hdr = kzalloc(PAGE_ALIGN(len), GFP_KERNEL);
+	if (!idev->hdr)
+		return -ENOMEM;
+
+	memcpy(idev->hdr, hdr, len);
+
+	/* This is firmware/ibft */
+	kobject_set_name(&idev->kobj, "table");
+	kobj_set_kset_s(idev, ibft_subsys);
+	error = kobject_register(&idev->kobj);
+
+	if (!error) {
+		ibft_attribute_binary.size = idev->hdr->length;
+		error =
+		    sysfs_create_bin_file(&idev->kobj, &ibft_attribute_binary);
+	}
+
+	/* The de-allocation part is done by module_exit() */
+	return error;
+}
+
+static struct ibft_device *ibft_idev;
+/*
+ * ibft_init() - creates  sysfs tree entry for ibft data
+ */
+static int __init ibft_init(void)
+{
+	int rc = 0;
+
+	printk(KERN_INFO "BIOS iBFT facility v%s %s\n", ISCSI_IBFT_VERSION,
+	       ISCSI_IBFT_DATE);
+
+	if (!ibft_phys)
+		find_ibft();
+
+	/* What if the ibft_subsys is underneath another struct? */
+	rc = firmware_register(&ibft_subsys);
+	if (rc)
+		return rc;
+
+	if (ibft_phys) {
+		printk(KERN_INFO "iBFT detected at 0x%lx.\n",
+		       (unsigned long)ibft_phys);
+		ibft_idev = kzalloc(sizeof(*ibft_idev), GFP_KERNEL);
+		if (!ibft_idev)
+			return -ENOMEM;
+
+		rc = ibft_device_register(ibft_idev);
+		if (rc) {
+			kfree(ibft_idev);
+			return rc;
+		}
+	} else {
+		printk(KERN_INFO "No iBFT detected.\n");
+	}
+	return rc;
+}
+
+static void __exit ibft_exit(void)
+{
+	if (ibft_idev)
+		kobject_unregister(&ibft_idev->kobj);
+
+	firmware_unregister(&ibft_subsys);
+	printk(KERN_INFO "BIOS iBFT unloaded.\n");
+}
+
+module_init(ibft_init);
+module_exit(ibft_exit);
diff --git a/include/linux/iscsi_ibft.h b/include/linux/iscsi_ibft.h
new file mode 100644
index 0000000..5e7b267
--- /dev/null
+++ b/include/linux/iscsi_ibft.h
@@ -0,0 +1,58 @@
+#ifndef ISCSI_IBFT_H
+#define ISCSI_IBFT_H
+
+extern void *ibft_phys;
+
+struct ibft_header {
+	char signature[4];
+	u32 length;
+	u8 revision;
+	u8 checksum;
+	char oem_id[6];
+	char oem_table_id[8];
+	char reserved[24];
+};
+
+struct ibft_device {
+	struct ibft_header *hdr;
+	struct kobject kobj;
+};
+
+#if defined(CONFIG_ISCSI_IBFT) || defined(CONFIG_ISCSI_IBFT_MODULES)
+
+#define IBFT_SIGN "iBFT"
+#define IBFT_SIGN_LEN 4
+#define IBFT_START 0x80000 /* 512kB */
+#define IBFT_END 0x100000 /* 1MB */
+#define VGA_MEM 0xA0000 /* VGA buffer */
+#define VGA_SIZE 0x20000 /* 132kB */
+static inline ssize_t find_ibft(void)
+{
+	unsigned long pos;
+	for (pos = IBFT_START; pos < IBFT_END; pos += 16) {
+		void *virt;
+		/* The table can't be inside the VGA BIOS reserved space,
+		 * so skip that area */
+		if (pos == VGA_MEM-PAGE_SIZE)
+			pos += VGA_SIZE+PAGE_SIZE;
+		virt = phys_to_virt(pos);
+		if (memcmp(virt, IBFT_SIGN, IBFT_SIGN_LEN) == 0) {
+			unsigned long *addr =
+			    (unsigned long *)phys_to_virt(pos + 4);
+			unsigned int len = *addr;
+			/* if the length of the table extends past 1M,
+			 * the table cannot be valid. */
+			if (pos + len <= (IBFT_END-1)) {
+				ibft_phys = (void *)pos;
+				return len;
+			}
+		}
+	}
+	return 0;
+}
+
+#else
+
+static inline ssize_t find_ibft(void) { return 0; };
+#endif
+#endif /* ISCSI_IBFT_H */
