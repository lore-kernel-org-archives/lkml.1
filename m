Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbXDIWu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbXDIWu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 18:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965570AbXDIWt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 18:49:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:21255 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965940AbXDIWsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 18:48:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,388,1170662400"; 
   d="scan'208"; a="70978877:sNHT28044855"
Message-Id: <20070409215723.248187000@intel.com>
References: <20070409215552.221374000@intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 09 Apr 2007 14:55:53 -0700
From: Ashok Raj <ashok.raj@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com
Subject: [patch 1/8] [Intel IOMMU] ACPI support for Intel Virtualization Technology for Directed I/O
Content-Disposition: inline; filename=iommu-acpi-mods.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains basic ACPI parsing and enumeration support.

Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Index: linux-2.6.21-rc5/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/arch/x86_64/Kconfig	2007-04-03 04:30:40.000000000 -0700
+++ linux-2.6.21-rc5/arch/x86_64/Kconfig	2007-04-03 06:34:17.000000000 -0700
@@ -687,6 +687,14 @@
 	bool "Support mmconfig PCI config space access"
 	depends on PCI && ACPI
 
+config DMAR
+	bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
+	depends on PCI_MSI && ACPI && EXPERIMENTAL
+	help
+	  Support DMA Remapping Devices. The devices are reported via
+	  ACPI tables and includes pci device scope under each DMA
+	  remapping device.
+
 source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pci/Kconfig"
Index: linux-2.6.21-rc5/drivers/acpi/Makefile
===================================================================
--- linux-2.6.21-rc5.orig/drivers/acpi/Makefile	2007-04-03 04:30:40.000000000 -0700
+++ linux-2.6.21-rc5/drivers/acpi/Makefile	2007-04-03 06:34:17.000000000 -0700
@@ -60,3 +60,4 @@
 obj-$(CONFIG_ACPI_HOTPLUG_MEMORY)	+= acpi_memhotplug.o
 obj-y				+= cm_sbs.o
 obj-$(CONFIG_ACPI_SBS)		+= i2c_ec.o sbs.o
+obj-$(CONFIG_DMAR)		+= dmar.o
Index: linux-2.6.21-rc5/drivers/acpi/dmar.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21-rc5/drivers/acpi/dmar.c	2007-04-03 06:54:27.000000000 -0700
@@ -0,0 +1,344 @@
+/*
+ * Copyright (c) 2006, Intel Corporation.
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
+ * Copyright (C) Ashok Raj <ashok.raj@intel.com>
+ * Copyright (C) Shaohua Li <shaohua.li@intel.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/acpi.h>
+
+#include <acpi/dmar.h>
+
+#undef PREFIX
+#define PREFIX "ACPI DMAR:"
+
+#define MIN_SCOPE_LEN (sizeof(struct acpi_pci_path) + sizeof(struct acpi_dev_scope))
+
+LIST_HEAD(acpi_drhd_units);
+LIST_HEAD(acpi_rmrr_units);
+u8 dmar_host_address_width;
+
+static int __init acpi_register_drhd_unit(struct acpi_drhd_unit *drhd)
+{
+	/*
+	 * add INCLUDE_ALL at the tail, so scan the list will find it at
+	 * the very end.
+	 */
+	if (drhd->include_all)
+		list_add_tail(&drhd->list, &acpi_drhd_units);
+	else
+		list_add(&drhd->list, &acpi_drhd_units);
+	return 0;
+}
+
+static int __init acpi_register_rmrr_unit(struct acpi_rmrr_unit *rmrr)
+{
+	list_add(&rmrr->list, &acpi_rmrr_units);
+	return 0;
+}
+
+static int acpi_pci_device_match(struct pci_dev *devices[], int cnt,
+			     struct pci_dev *dev)
+{
+	int index;
+
+	while (dev) {
+		for (index = 0; index < cnt; index ++)
+			if (dev == devices[index])
+				return 1;
+
+		/* Check our parent */
+		dev = dev->bus->self;
+	}
+
+	return 0;
+}
+
+struct acpi_drhd_unit * acpi_find_matched_drhd_unit(struct pci_dev *dev)
+{
+	struct acpi_drhd_unit *drhd = NULL;
+
+	list_for_each_entry(drhd, &acpi_drhd_units, list) {
+		if (drhd->include_all || acpi_pci_device_match(drhd->devices,
+						drhd->devices_cnt, dev))
+			break;
+	}
+
+	return drhd;
+}
+
+struct acpi_rmrr_unit * acpi_find_matched_rmrr_unit(struct pci_dev *dev)
+{
+	struct acpi_rmrr_unit *rmrr;
+
+	list_for_each_entry(rmrr, &acpi_rmrr_units, list) {
+		if (acpi_pci_device_match(rmrr->devices,
+						rmrr->devices_cnt, dev))
+			goto out;
+	}
+	rmrr = NULL;
+out:
+	return rmrr;
+}
+
+static int __init acpi_parse_one_dev_scope(struct acpi_dev_scope *scope,
+					   struct pci_dev **dev, u16 segment)
+{
+	struct pci_bus *bus;
+	struct pci_dev *pdev = NULL;
+	struct acpi_pci_path *path;
+	int count;
+
+	bus = pci_find_bus(segment, scope->start_bus);
+	path = (struct acpi_pci_path *)(scope + 1);
+	count = (scope->length - sizeof(struct acpi_dev_scope))
+		/sizeof(struct acpi_pci_path);
+
+	while (count) {
+		if (pdev)
+			pci_dev_put(pdev);
+		/*
+		 * Some BIOSes list non-exist devices in DMAR table, just
+		 * ignore it
+		 */
+		if (!bus) {
+			printk(KERN_WARNING PREFIX "Device scope bus not found\n");
+			break;
+		}
+		pdev = pci_get_slot(bus, PCI_DEVFN(path->dev, path->fn));
+		if (!pdev) {
+			printk(KERN_WARNING PREFIX
+				"Device scope device [%04x:%02x:%02x.%02x] not found\n",
+				segment, bus->number, path->dev, path->fn);
+			break;
+		}
+		path ++;
+		count --;
+		bus = pdev->subordinate;
+	}
+	if (!pdev) {
+		printk(KERN_WARNING PREFIX "Device scope device not found\n");
+		*dev = NULL;
+		return 0;
+	}
+	if ((scope->dev_type == ACPI_DEV_ENDPOINT && pdev->subordinate)
+	   || (scope->dev_type == ACPI_DEV_P2PBRIDGE && !pdev->subordinate)) {
+		pci_dev_put(pdev);
+		printk(KERN_WARNING PREFIX "Device scope type does not match for %s\n", pci_name(pdev));
+		return -EINVAL;
+	}
+	*dev = pdev;
+	return 0;
+}
+
+static int __init acpi_parse_dev_scope(void *start, void *end, int *cnt,
+				       struct pci_dev ***devices, u16 segment)
+{
+	struct acpi_dev_scope *scope;
+	void * tmp = start;
+	int index;
+	int ret;
+
+	*cnt = 0;
+	while (start < end) {
+		scope = start;
+		if (scope->dev_type == ACPI_DEV_ENDPOINT ||
+		    scope->dev_type == ACPI_DEV_P2PBRIDGE)
+			(*cnt)++;
+		else
+			printk(KERN_WARNING PREFIX "Unsupported device scope\n");
+		start += scope->length;
+	}
+	if (*cnt == 0)
+		return 0;
+
+	*devices = kcalloc(*cnt, sizeof(struct pci_dev *), GFP_KERNEL);
+	if (!*devices)
+		return -ENOMEM;
+
+	start = tmp;
+	index = 0;
+	while (start < end) {
+		scope = start;
+		if (scope->dev_type == ACPI_DEV_ENDPOINT ||
+		    scope->dev_type == ACPI_DEV_P2PBRIDGE) {
+			ret = acpi_parse_one_dev_scope(scope,
+				&(*devices)[index], segment);
+			if (ret) {
+				kfree(*devices);
+				return ret;
+			}
+			index ++;
+		}
+		start += scope->length;
+	}
+
+	return 0;
+}
+
+static int __init
+acpi_parse_one_drhd(struct acpi_dmar_entry_header *header)
+{
+	struct acpi_table_drhd * drhd = (struct acpi_table_drhd *)header;
+	struct acpi_drhd_unit *dmaru;
+	int ret = 0;
+	static int include_all;
+
+	dmaru = kzalloc(sizeof(*dmaru), GFP_KERNEL);
+	if (!dmaru)
+		return -ENOMEM;
+
+	dmaru->address = drhd->address;
+	dmaru->include_all = drhd->flags & 1; /* BIT0: INCLUDE_ALL */
+
+	if (!dmaru->include_all)
+		ret = acpi_parse_dev_scope((void *)(drhd + 1),
+				((void *)drhd) + header->length,
+				&dmaru->devices_cnt, &dmaru->devices,
+				drhd->segment);
+	else {
+		/* Only allow one INCLUDE_ALL */
+		if (include_all) {
+			printk(KERN_WARNING PREFIX "Only one INCLUDE_ALL "
+				"device scope is allowed\n");
+			ret = -EINVAL;
+		}
+		include_all = 1;
+	}
+
+	if (ret || (dmaru->devices_cnt == 0 && !dmaru->include_all))
+		kfree(dmaru);
+	else
+		acpi_register_drhd_unit(dmaru);
+	return ret;
+}
+
+static int __init
+acpi_parse_one_rmrr(struct acpi_dmar_entry_header *header)
+{
+	struct acpi_table_rmrr *rmrr = (struct acpi_table_rmrr *)header;
+	struct acpi_rmrr_unit *rmrru;
+	int ret = 0;
+
+	rmrru = kzalloc(sizeof(*rmrru), GFP_KERNEL);
+	if (!rmrru)
+		return -ENOMEM;
+
+	rmrru->base_address = rmrr->base_address;
+	rmrru->end_address = rmrr->end_address;
+	ret = acpi_parse_dev_scope((void *)(rmrr + 1),
+		((void*)rmrr) + header->length,
+		&rmrru->devices_cnt, &rmrru->devices, rmrr->segment);
+
+	if (ret || (rmrru->devices_cnt == 0))
+		kfree(rmrru);
+	else
+		acpi_register_rmrr_unit(rmrru);
+	return ret;
+}
+
+static void __init
+acpi_table_print_dmar_entry(struct acpi_dmar_entry_header *header)
+{
+	struct acpi_table_drhd *drhd;
+	struct acpi_table_rmrr *rmrr;
+
+	switch (header->type) {
+	case ACPI_DMAR_DRHD:
+		drhd = (struct acpi_table_drhd *)header;
+		printk (KERN_INFO PREFIX
+			"DRHD (flags: 0x%08x)base: 0x%016Lx\n",
+			drhd->flags, drhd->address);
+		break;
+	case ACPI_DMAR_RMRR:
+		rmrr = (struct acpi_table_rmrr *)header;
+
+		printk (KERN_INFO PREFIX
+			"RMRR base: 0x%016Lx end: 0x%016Lx\n",
+			rmrr->base_address, rmrr->end_address);
+		break;
+	}
+}
+
+static int __init
+acpi_parse_dmar(struct acpi_table_header *table)
+{
+	struct acpi_table_dmar *dmar;
+	struct acpi_dmar_entry_header *entry_header;
+	int ret = 0;
+
+	dmar = (struct acpi_table_dmar *)table;
+	if (!dmar) {
+		printk (KERN_WARNING PREFIX "Unable to map DMAR\n");
+		return -ENODEV;
+	}
+
+	if (!dmar->haw) {
+		printk (KERN_WARNING PREFIX "Zero: Invalid DMAR haw\n");
+		return -EINVAL;
+	}
+
+	dmar_host_address_width = dmar->haw + 1;
+	printk (KERN_INFO PREFIX "Host address width %d\n",
+		dmar_host_address_width);
+
+	entry_header = (struct acpi_dmar_entry_header *)(dmar + 1);
+	while (((unsigned long)entry_header) < (((unsigned long)dmar) + table->length)) {
+		acpi_table_print_dmar_entry(entry_header);
+
+		switch (entry_header->type) {
+		case ACPI_DMAR_DRHD:
+			ret = acpi_parse_one_drhd(entry_header);
+			break;
+		case ACPI_DMAR_RMRR:
+			ret = acpi_parse_one_rmrr(entry_header);
+			break;
+		default:
+			printk(KERN_WARNING PREFIX "Unknown DMAR structure type\n");
+			ret = 0; /* for forward compatibility */
+			break;
+		}
+		if (ret)
+			break;
+
+		entry_header = ((void *)entry_header + entry_header->length);
+	}
+	return ret;
+}
+
+int __init early_dmar_detect(void)
+{
+	struct acpi_table_header header;
+
+	/* if we could find DMAR table, then there are DMAR devices */
+	if (!acpi_get_table_header(ACPI_SIG_DMAR, 0, &header))
+		return 1;
+	return 0;
+}
+
+static int __init acpi_dmar_init(void)
+{
+	acpi_table_parse(ACPI_SIG_DMAR, acpi_parse_dmar);
+	if (list_empty(&acpi_drhd_units)) {
+		printk(KERN_ERR PREFIX "No DMAR devices found\n");
+		return -ENODEV;
+	}
+	return 0;
+}
+subsys_initcall(acpi_dmar_init);
Index: linux-2.6.21-rc5/include/acpi/actbl1.h
===================================================================
--- linux-2.6.21-rc5.orig/include/acpi/actbl1.h	2007-04-03 04:30:50.000000000 -0700
+++ linux-2.6.21-rc5/include/acpi/actbl1.h	2007-04-03 06:34:17.000000000 -0700
@@ -256,41 +256,48 @@
 
 struct acpi_table_dmar {
 	struct acpi_table_header header;	/* Common ACPI table header */
-	u8 width;		/* Host Address Width */
-	u8 reserved[11];
+	u8 haw;		/* Host Address Width */
+	u8 flags;
+	u8 reserved[10];
 };
 
 /* DMAR subtable header */
 
-struct acpi_dmar_header {
+struct acpi_dmar_entry_header {
 	u16 type;
 	u16 length;
-	u8 flags;
-	u8 reserved[3];
 };
 
 /* Values for subtable type in struct acpi_dmar_header */
 
-enum acpi_dmar_type {
-	ACPI_DMAR_TYPE_HARDWARE_UNIT = 0,
-	ACPI_DMAR_TYPE_RESERVED_MEMORY = 1,
-	ACPI_DMAR_TYPE_RESERVED = 2	/* 2 and greater are reserved */
+enum acpi_dmar_entry_type {
+	ACPI_DMAR_DRHD = 0,
+	ACPI_DMAR_RMRR = 1,
+	ACPI_DMAR_ASTR = 2,
+	ACPI_DMAR_ENTRY_COUNT
 };
 
-struct acpi_dmar_device_scope {
-	u8 entry_type;
+struct acpi_dev_scope {
+	u8 dev_type;
 	u8 length;
-	u8 segment;
-	u8 bus;
+	u16 reserved;
+	u8 enumeration_id;
+	u8 start_bus;
 };
 
 /* Values for entry_type in struct acpi_dmar_device_scope */
 
-enum acpi_dmar_scope_type {
-	ACPI_DMAR_SCOPE_TYPE_NOT_USED = 0,
-	ACPI_DMAR_SCOPE_TYPE_ENDPOINT = 1,
-	ACPI_DMAR_SCOPE_TYPE_BRIDGE = 2,
-	ACPI_DMAR_SCOPE_TYPE_RESERVED = 3	/* 3 and greater are reserved */
+enum acpi_dev_scope_type {
+	ACPI_DEV_ENDPOINT = 1,
+	ACPI_DEV_P2PBRIDGE,
+	ACPI_DEV_IOAPIC,
+	ACPI_DEV_HPET,
+	ACPI_DEV_ENTRY_COUNT
+};
+
+struct acpi_pci_path {
+	u8 dev;
+	u8 fn;
 };
 
 /*
@@ -299,9 +306,12 @@
 
 /* 0: Hardware Unit Definition */
 
-struct acpi_dmar_hardware_unit {
-	struct acpi_dmar_header header;
-	u64 address;		/* Register Base Address */
+struct acpi_table_drhd {
+	struct acpi_dmar_entry_header header;
+	u8	flags;	/* BIT0: INCLUDE_ALL */
+	u8	reserved;
+	u16	segment;
+	u64	address; /* register base address for this drhd */
 };
 
 /* Flags */
@@ -310,16 +320,14 @@
 
 /* 1: Reserved Memory Defininition */
 
-struct acpi_dmar_reserved_memory {
-	struct acpi_dmar_header header;
-	u64 address;		/* 4_k aligned base address */
-	u64 end_address;	/* 4_k aligned limit address */
+struct acpi_table_rmrr {
+	struct acpi_dmar_entry_header header;
+	u16	reserved;
+	u16	segment;
+	u64	base_address;
+	u64	end_address;
 };
 
-/* Flags */
-
-#define ACPI_DMAR_ALLOW_ALL         (1)
-
 /*******************************************************************************
  *
  * ECDT - Embedded Controller Boot Resources Table
Index: linux-2.6.21-rc5/include/acpi/dmar.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21-rc5/include/acpi/dmar.h	2007-04-03 06:34:17.000000000 -0700
@@ -0,0 +1,60 @@
+/*
+ * Copyright (c) 2006, Intel Corporation.
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
+ * Copyright (C) Ashok Raj <ashok.raj@intel.com>
+ * Copyright (C) Shaohua Li <shaohua.li@intel.com>
+ */
+
+extern u8 dmar_host_address_width;
+extern struct list_head acpi_drhd_units;
+extern struct list_head acpi_rmrr_units;
+
+#define no_drhd_detected()	(list_empty(&acpi_drhd_units))
+
+struct iommu;
+struct acpi_drhd_unit {
+	struct list_head list;
+	u64	address; /* register base address of the unit */
+	struct	pci_dev **devices; /* target devices */
+	int	devices_cnt;
+	u8	include_all:1;
+	struct iommu *iommu;
+};
+
+struct acpi_rmrr_unit {
+	struct list_head list;
+	u64	base_address;
+	u64	end_address;
+	struct pci_dev **devices; /* target devices */
+	int	devices_cnt;
+};
+
+#define for_each_drhd_unit(drhd) \
+	list_for_each_entry(drhd, &acpi_drhd_units, list)
+#define for_each_rmrr_device(rmrr, pdev) \
+	list_for_each_entry(rmrr, &acpi_rmrr_units, list) { \
+		int _i; \
+		for (_i = 0; _i < rmrr->devices_cnt; _i++) { \
+			pdev = rmrr->devices[_i]; \
+			/* some BIOS lists non-exist devices in DMAR table */\
+			if (!pdev) \
+				continue;
+#define end_for_each_rmrr_device(rmrr, pdev) \
+		} \
+	}
+
+struct acpi_drhd_unit * acpi_find_matched_drhd_unit(struct pci_dev *dev);
+struct acpi_rmrr_unit * acpi_find_matched_rmrr_unit(struct pci_dev *dev);

-- 
