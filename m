Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbXKZXQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbXKZXQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 18:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbXKZXQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 18:16:44 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:60307 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756315AbXKZXQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:16:41 -0500
X-Greylist: delayed 773 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Nov 2007 18:16:40 EST
Date: Mon, 26 Nov 2007 18:56:42 -0400
From: Konrad Rzeszutek <konrad@darnok.org>
To: linux-kernel@vger.kernel.org
Cc: pjones@redhat.com, konradr@redhat.com, konradr@linux.vnet.ibm.com,
       greg@kroah.com, randy.dunlap@oracle.com, hpa@zytor.com, lenb@kernel.org,
       mike.anderson@us.ibm.com, dwm@austin.ibm.com
Subject: [PATCH] Add iSCSI IBFT Support (v0.3)
Message-ID: <20071126225642.GA7973@andromeda.dapyr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds /sysfs/firmware/ibft/[chosen|aliases|ethernet@0,X|target@0,X]
directories along with text properties which export the the iSCSI Boot
Firmware Table (iBFT) structure. The layout of the directories mirrors
how PowerPC OpenBoot exports this data.

What is iSCSI Boot Firmware Table? It is a mechanism for the iSCSI
tools to extract from the machine NICs the iSCSI connection information
so that they can automagically mount the iSCSI share/target. Currently
the iSCSI information is hard-coded in th initrd.

For full details of the IBFT structure please take a look at:
ftp://ftp.software.ibm.com/systems/support/system_x_pdf/ibm_iscsi_boot_firmware_table_v1.02.pdf


Signed-off-by: Konrad Rzeszutek <konradr@linux.vnet.ibm.com>
Signed-off-by: Peter Jones <pjones@redhat.com>

diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index e1e18c3..e3ed866 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -39,6 +39,7 @@ #include <linux/module.h>
 #include <linux/efi.h>
 #include <linux/init.h>
 #include <linux/edd.h>
+#include <linux/iscsi_ibft.h>
 #include <linux/nodemask.h>
 #include <linux/kexec.h>
 #include <linux/crash_dump.h>
@@ -148,6 +149,23 @@ static inline void copy_edd(void)
 }
 #endif
 
+#if defined(CONFIG_ISCSI_IBFT) || defined(CONFIG_ISCSI_IBFT_MODULE)
+void *ibft_phys;
+#if defined(CONFIG_ISCSI_IBFT_MODULE)
+EXPORT_SYMBOL(ibft_phys);
+#endif
+static void __init reserve_ibft_region(void)
+{
+	unsigned int ibft_len;
+	ibft_len = find_ibft();
+	if (ibft_len)
+		reserve_bootmem((unsigned int)ibft_phys, PAGE_ALIGN(ibft_len));
+}
+
+#else
+static void __init reserve_ibft_region(void) { };
+#endif
+
 int __initdata user_defined_memmap = 0;
 
 /*
@@ -496,6 +514,7 @@ #ifdef CONFIG_BLK_DEV_INITRD
 	}
 #endif
 	reserve_crashkernel();
+	reserve_ibft_region();
 }
 
 /*
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 30d94d1..ba6fd21 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -33,6 +33,7 @@ #include <linux/pci.h>
 #include <linux/acpi.h>
 #include <linux/kallsyms.h>
 #include <linux/edd.h>
+#include <linux/iscsi_ibft.h>
 #include <linux/mmzone.h>
 #include <linux/kexec.h>
 #include <linux/cpufreq.h>
@@ -198,6 +199,23 @@ static inline void copy_edd(void)
 }
 #endif
 
+#if defined(CONFIG_ISCSI_IBFT) || defined(CONFIG_ISCSI_IBFT_MODULE)
+void *ibft_phys;
+#if defined(CONFIG_ISCSI_IBFT_MODULE)
+EXPORT_SYMBOL(ibft_phys);
+#endif
+static void __init reserve_ibft_region(void)
+{
+	unsigned int ibft_len;
+	ibft_len = find_ibft();
+	if (ibft_len)
+		reserve_bootmem_generic(ibft_phys, PAGE_ALIGN(ibft_len));
+}
+
+#else
+static void __init reserve_ibft_region(void) { };
+#endif
+
 #ifdef CONFIG_KEXEC
 static void __init reserve_crashkernel(void)
 {
@@ -403,6 +421,7 @@ #ifdef CONFIG_BLK_DEV_INITRD
 	}
 #endif
 	reserve_crashkernel();
+	reserve_ibft_region();
 	paging_init();
 
 #ifdef CONFIG_PCI
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 05f02a3..b132f37 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -93,4 +93,13 @@ config DMIID
 	  information from userspace through /sys/class/dmi/id/ or if you want
 	  DMI-based module auto-loading.
 
+config ISCSI_IBFT
+	tristate "iSCSI Boot Firmware Table Attributes"
+	default	n
+	help
+	  This option enables support for detection of an iSCSI
+	  Boot Firmware Table (iBFT).  If you wish to detect iSCSI boot
+	  parameters dynamically during system boot, say Y.
+	  Otherwise, say N.
+
 endmenu
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 8d4ebc8..5b6638e 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -8,3 +8,5 @@ obj-$(CONFIG_EFI_PCDP)		+= pcdp.o
 obj-$(CONFIG_DELL_RBU)          += dell_rbu.o
 obj-$(CONFIG_DCDBAS)		+= dcdbas.o
 obj-$(CONFIG_DMIID)		+= dmi-id.o
+obj-$(CONFIG_ISCSI_IBFT)	+= iscsi_ibft.o
+
diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
new file mode 100644
index 0000000..7e4e117
--- /dev/null
+++ b/drivers/firmware/iscsi_ibft.c
@@ -0,0 +1,612 @@
+/*
+ *  Copyright 2007 Red Hat, Inc.
+ *  by Peter Jones <pjones@redhat.com>
+ *  Copyright 2007 IBM, Inc.
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
+#define IBFT_ISCSI_VERSION  "0.3"
+#define IBFT_ISCSI_DATE	 "2007-Nov-21"
+
+MODULE_AUTHOR("Peter Jones <pjones@redhat.com> and \
+Konrad Rzeszutek <konradr@us.ibm.com>");
+MODULE_DESCRIPTION("sysfs interface to BIOS iBFT information");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(IBFT_ISCSI_VERSION);
+
+static LIST_HEAD(ibft_attr_list);
+static LIST_HEAD(ibft_kobject_list);
+static LIST_HEAD(ibft_data_list);
+
+static const char nulls[16];
+static struct ibft_table_header *ibft_device;
+
+/*
+ * Helper functions to parse data properly.
+ */
+static ssize_t sprintf_ipaddr(char *buf, const char *name, u8 *ip)
+{
+	if (ip[0] == 0 && ip[1] == 0 && ip[2] == 0 && ip[3] == 0 &&
+	    ip[4] == 0 && ip[5] == 0 && ip[6] == 0 && ip[7] == 0 &&
+	    ip[8] == 0 && ip[9] == 0 && ip[10] == 0xff && ip[11] == 0xff) {
+		/*
+		 * IPV4
+		 */
+		return sprintf(buf, "%s=%d.%d.%d.%d,", name, ip[12],
+			ip[13], ip[14], ip[15]);
+	} else {
+		return 0;
+	}
+}
+
+static ssize_t sprintf_string(char *str, const char *name, int len, char *buf)
+{
+	return sprintf(str, "%s=%.*s,", name, len, buf);
+}
+
+/*
+ * Helper function to verify the IBFT header.
+ */
+static int ibft_verify_hdr(struct ibft_hdr *hdr, int id, int length)
+{
+#define IBFT_VERIFY_HDR_FIELD(hdr2, val, name) \
+	if (hdr2->val != val) { \
+		printk(KERN_INFO  \
+			"error, in IBFT structure (%s) expected %d but" \
+			" found %d\n", \
+			name, val, hdr2->val); \
+		return -ENODEV; \
+	}
+	IBFT_VERIFY_HDR_FIELD(hdr, id, "ID");
+	IBFT_VERIFY_HDR_FIELD(hdr, length, "Length");
+#undef IBFT_VERIFY_HDR_FIELD
+	return 0;
+}
+
+static void ibft_release(struct kobject *kobj)
+{
+	struct ibft_kobject *ibft =
+		container_of(kobj, struct ibft_kobject, kobj);
+	kfree(ibft);
+}
+
+/*
+ *  Routines for reading of the iBFT data in a human readable fashion.
+ */
+ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
+				 struct ibft_attribute *attr,
+				 char *buf)
+{
+	struct ibft_initiator *initiator = attr->initiator;
+	void *ibft_loc = entry->data->hdr;
+	char *str = buf;
+
+	if (!initiator)
+		return 0;
+
+	str += sprintf_ipaddr(str, "isns", initiator->isns_server);
+	str += sprintf_ipaddr(str, "slp", initiator->slp_server);
+	str += sprintf_ipaddr(str, "primary_radius_server",
+		initiator->pri_radius_server);
+	str += sprintf_ipaddr(str, "secondary_radius_server",
+		initiator->sec_radius_server);
+	str += sprintf_string(str, "itname", initiator->initiator_name_len,
+		(char *)ibft_loc + initiator->initiator_name_off);
+	str--;
+
+	return str-buf;
+}
+
+ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
+			   struct ibft_attribute *attr,
+			   char *buf)
+{
+	struct ibft_nic *nic = attr->nic;
+	void *ibft_loc = entry->data->hdr;
+	char *str = buf;
+
+	if (!nic)
+		return 0;
+	/*
+	 * Assume dhcp if any non-zero portions of its address are set.
+	 */
+	if (memcmp(nic->dhcp, nulls, sizeof(nic->dhcp))) {
+		str += sprintf_ipaddr(str, "dhcp", nic->dhcp);
+	} else {
+		str += sprintf_ipaddr(str, "ciaddr", nic->ip_addr);
+		str += sprintf_ipaddr(str, "giaddr", nic->gateway);
+		str += sprintf_ipaddr(str, "dnsaddr1", nic->primary_dns);
+		str += sprintf_ipaddr(str, "dnsaddr2", nic->secondary_dns);
+	}
+	if (nic->hostname_len)
+		str += sprintf_string(str, "hostname", nic->hostname_len,
+				(char *)ibft_loc + nic->hostname_off);
+	/* Cut off the comma. */
+	str--;
+
+	return str-buf;
+}
+
+ssize_t ibft_attr_show_target(struct ibft_kobject *entry,
+			      struct ibft_attribute *attr,
+			      char *buf)
+{
+	struct ibft_tgt *tgt = attr->tgt;
+	void *ibft_loc = entry->data->hdr;
+	char *str = buf;
+	int i;
+
+	if (!tgt)
+		return 0;
+
+	str += sprintf_ipaddr(str, "siaddr", tgt->ip_addr);
+	str += sprintf(str, "iport=%d,", tgt->port);
+	str += sprintf(str, "ilun=");
+	for (i = 0; i < 8; i++)
+		str += sprintf(str, "%x", (u8)tgt->lun[i]);
+	str += sprintf(str, ",");
+
+	if (tgt->tgt_name_len)
+		str += sprintf_string(str, "iname", tgt->tgt_name_len,
+		(void *)ibft_loc + tgt->tgt_name_off);
+
+	if (tgt->chap_name_len)
+		str += sprintf_string(str, "chapid", tgt->chap_name_len,
+			(char *)ibft_loc + tgt->chap_name_off);
+	if (tgt->chap_secret_len)
+		str += sprintf_string(str, "chappw", tgt->chap_secret_len,
+			(char *)ibft_loc + tgt->chap_secret_off);
+	if (tgt->rev_chap_name_len)
+		str += sprintf_string(str, "ichapid", tgt->rev_chap_name_len,
+			(char *)ibft_loc + tgt->rev_chap_name_off);
+	if (tgt->rev_chap_secret_len)
+		str += sprintf_string(str, "ichappw", tgt->rev_chap_secret_len,
+			(char *)ibft_loc + tgt->rev_chap_secret_off);
+
+	/* Cut off the comma. */
+	str--;
+
+	return str-buf;
+}
+
+ssize_t ibft_attr_show_disk(struct ibft_kobject *dev,
+			    struct ibft_attribute *ibft_attr,
+			    char *buf)
+{
+	char *str = buf;
+
+	str += sprintf(str, "//ethernet@0,%d:iscsi,", dev->data->index);
+	str += ibft_attr_show_initiator(dev, ibft_attr, str);
+	str += sprintf(str, ",");
+	str += ibft_attr_show_target(dev, ibft_attr, str);
+	str += sprintf(str, ",");
+	str += ibft_attr_show_nic(dev, ibft_attr, str);
+
+	return str-buf;
+}
+
+ssize_t ibft_attr_show_mac(struct ibft_kobject *entry,
+			   struct ibft_attribute *attr,
+			   char *buf)
+{
+	struct ibft_nic *nic = attr->nic;
+	int len = 6;
+
+	if (!nic)
+		return 0;
+
+	memcpy(buf, attr->nic->mac, len);
+
+	return len;
+}
+
+/*
+ * The main routine which allows the user to read the IBFT data.
+ */
+static ssize_t ibft_show_attribute(struct kobject *kobj,
+				   struct attribute *attr,
+				   char *buf)
+{
+	struct ibft_kobject *dev =
+		container_of(kobj, struct ibft_kobject, kobj);
+	struct ibft_attribute *ibft_attr =
+		container_of(attr, struct ibft_attribute, attr);
+	ssize_t ret = -EIO;
+	char *str = buf;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (ibft_attr->show)
+		ret = ibft_attr->show(dev, ibft_attr, str);
+
+	return ret;
+}
+
+static struct sysfs_ops ibft_attr_ops = {
+	.show = ibft_show_attribute,
+};
+
+static struct kobj_type ktype_ibft = {
+	.release = ibft_release,
+	.sysfs_ops = &ibft_attr_ops,
+};
+
+static decl_subsys(ibft, &ktype_ibft, NULL);
+
+
+static int ibft_alloc_device(void *idev)
+{
+	int len;
+	struct ibft_table_header *hdr;
+
+	if (!idev)
+		return -ENOENT;
+
+	hdr = (struct ibft_table_header *)phys_to_virt(
+			(unsigned long)ibft_phys);
+
+	len = hdr->length;
+
+	ibft_device = kzalloc(len, GFP_KERNEL);
+
+	if (!ibft_device)
+		return -ENOMEM;
+
+	memcpy(ibft_device, hdr, len);
+
+	return 0;
+}
+
+static void ibft_free_device(struct ibft_table_header *hdr)
+{
+	kfree(hdr);
+};
+
+
+/*
+ * Helper function for ibft_scan_device.
+ */
+static int ibft_populate_data(struct ibft_table_header *header,
+			      struct ibft_hdr *hdr,
+			      struct ibft_initiator *initiator,
+			      struct list_head *list)
+{
+	struct ibft_data *i, *n, *data = NULL;
+	int rc = 0;
+
+	/* Based on the header index value find the data tuple,
+	if possibly. */
+	list_for_each_entry_safe(i, n, list, node) {
+		if (hdr->index == i->index) {
+			data = i;
+			break;
+		}
+	}
+	if (!data) {
+		data = kzalloc(sizeof(*data), GFP_KERNEL);
+		if (!data)
+			return -ENOMEM;
+		/* There is only _one_ initiator. We make every 'data'
+		   struct carry it for convience. */
+		data->initiator = initiator;
+		data->hdr = header;
+		data->index = hdr->index;
+		list_add_tail(&data->node, list);
+	}
+
+	switch (hdr->id) {
+	case id_nic:
+		data->nic = (struct ibft_nic *)hdr;
+		rc = ibft_verify_hdr(hdr, id_nic, sizeof(*data->nic));
+		break;
+	case id_target:
+		data->tgt = (struct ibft_tgt *)hdr;
+		rc = ibft_verify_hdr(hdr, id_target, sizeof(*data->tgt));
+		break;
+	default:
+		/* Extension field which we don't support. Ignore it */
+		break;
+	}
+	return rc;
+};
+
+/*
+ * Scan the IBFT table structure for the NIC and Target fields. When
+ * found add them on the passed in list.
+ */
+static int ibft_scan_device(struct ibft_table_header *header,
+			    struct list_head *list)
+{
+	struct ibft_control *control = NULL;
+	struct ibft_initiator *initiator = NULL;
+	void *ptr, *end;
+	int rc = 0;
+	u16 offset;
+
+	control = (void *)header + sizeof(*header);
+	initiator = (void *)header + control->initiator_off;
+
+	end = (void *)control + control->hdr.length;
+
+	/* We can have multiple NICs and multiple targets. The index in
+	   their header defines their 1-to-1 correlation.
+	*/
+	for (ptr = &control->nic0_off; ptr <= end; ptr += sizeof(u16)) {
+		offset = *(u16 *)ptr;
+		if (offset) {
+			rc = ibft_populate_data(header,
+					(void *)header + offset,
+					initiator, list);
+			if (rc)
+				return rc;
+		}
+	}
+	return rc;
+};
+
+static void ibft_free_data(struct list_head *list)
+{
+	struct ibft_data *data = NULL, *n;
+
+	list_for_each_entry_safe(data, n, list, node) {
+		list_del(&data->node);
+		kfree(data);
+	}
+	list_del_init(list);
+};
+
+/*
+ * Helper function for ibft_register_kobjects.
+ */
+static int ibft_create_kobject(struct ibft_data *data,
+			       u8 type, const char *name,
+			       struct list_head *list)
+{
+	struct ibft_kobject *obj = NULL;
+	int rc = 0;
+
+	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
+	if (!obj)
+		return -ENOMEM;
+
+	snprintf(obj->name, IBFT_ISCSI_KOBJECT_MAX_LEN, name, data->index);
+
+	obj->data = data;
+	obj->type = type;
+
+	kobject_set_name(&obj->kobj, obj->name);
+	kobj_set_kset_s(obj, ibft_subsys);
+
+	rc = kobject_register(&obj->kobj);
+	if (rc)
+		return rc;
+
+	list_add_tail(&obj->node, list);
+	return rc;
+}
+
+static int ibft_register_kobjects(struct list_head *data_list,
+				  struct list_head *kobj_list)
+{
+	struct ibft_data *data = NULL, *n = NULL;
+	int rc = 0;
+
+	list_for_each_entry_safe(data, n, data_list, node) {
+		if (data->tgt)
+			rc |= ibft_create_kobject(data, kobject_type_target,
+				IBFT_ISCSI_KOBJECT_TARGET_NAME, kobj_list);
+		if (data->nic)
+			rc |= ibft_create_kobject(data, kobject_type_ethernet,
+				IBFT_ISCSI_KOBJECT_ETHERNET_NAME, kobj_list);
+		if (data->nic && (data->nic->hdr.flags &
+			ISCSI_IBFT_INIT_FLAG_FW_SEL_BOOT)) {
+			rc |= ibft_create_kobject(data, kobject_type_chosen,
+				IBFT_ISCSI_KOBJECT_CHOSEN_NAME, kobj_list);
+			rc |= ibft_create_kobject(data, kobject_type_aliases,
+				IBFT_ISCSI_KOBJECT_ALIASES_NAME, kobj_list);
+		}
+		if (rc) break;
+	}
+	return rc;
+};
+
+static void ibft_unregister_kobjects(struct list_head *list)
+{
+	struct ibft_kobject *data = NULL, *n;
+	list_for_each_entry_safe(data, n, list, node) {
+		list_del(&data->node);
+		kobject_unregister(&data->kobj);
+	};
+	list_del_init(list);
+};
+
+static int ibft_create_attribute(struct ibft_kobject *kobj_data,
+				 const char *name,
+				 ssize_t (*show) (struct  ibft_kobject *entry,
+						  struct ibft_attribute *attr,
+						  char *buf),
+				 struct list_head *list)
+{
+	struct ibft_attribute *attr = NULL;
+
+	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
+	if (!attr)
+		return -ENOMEM;
+
+	snprintf(attr->name, IBFT_ISCSI_ATTR_MAX_LEN, name,
+		kobj_data->data->index);
+
+	attr->attr.name = attr->name;
+	attr->attr.mode = S_IRUSR;
+	attr->attr.owner = THIS_MODULE;
+
+	attr->nic = kobj_data->data->nic;
+	attr->tgt = kobj_data->data->tgt;
+	attr->initiator = kobj_data->data->initiator;
+
+	attr->show = show;
+	attr->kobj = &kobj_data->kobj;
+
+	list_add_tail(&attr->node, list);
+	return 0;
+}
+/*
+ *  Register the attributes for all of the kobjects.
+ */
+static int ibft_register_attributes(struct list_head *kobject_list,
+				    struct list_head *attr_list)
+{
+	int rc = 0;
+	struct ibft_kobject *data = NULL;
+	struct ibft_attribute *attr = NULL, *m;
+
+	list_for_each_entry(data, kobject_list, node) {
+		switch (data->type) {
+		case kobject_type_chosen:
+			rc = ibft_create_attribute(data,
+				IBFT_ISCSI_ATTR_BOOTPATH_NAME,
+				ibft_attr_show_disk, attr_list);
+			break;
+		case kobject_type_ethernet:
+			rc |= ibft_create_attribute(data,
+					IBFT_ISCSI_ATTR_LOCAL_MAC_ADDRESS_NAME,
+					ibft_attr_show_mac, attr_list);
+			rc |= ibft_create_attribute(data,
+					IBFT_ISCSI_ATTR_PROPERTY_NAME,
+					ibft_attr_show_nic, attr_list);
+			break;
+		case kobject_type_target:
+			rc |= ibft_create_attribute(data,
+					IBFT_ISCSI_ATTR_PROPERTY_NAME,
+					ibft_attr_show_target, attr_list);
+			break;
+		case kobject_type_aliases:
+			rc |= ibft_create_attribute(data,
+					IBFT_ISCSI_ATTR_DISK_NAME,
+					ibft_attr_show_disk, attr_list);
+			break;
+		default:
+			break;
+		}
+		if (rc)
+			break;
+	}
+	list_for_each_entry_safe(attr, m, attr_list, node) {
+		rc = sysfs_create_file(attr->kobj, &attr->attr);
+		if (rc) {
+			list_del(&attr->node);
+			kfree(attr);
+			break;
+		}
+	}
+	return rc;
+};
+
+static void ibft_unregister_attributes(struct list_head *list)
+{
+	struct ibft_attribute *attr = NULL, *m;
+
+	list_for_each_entry_safe(attr, m, list, node) {
+		sysfs_remove_file(attr->kobj, &attr->attr);
+		list_del(&attr->node);
+		kfree(attr);
+	}
+	list_del_init(list);
+};
+
+
+/*
+ * ibft_init() - creates sysfs tree entries for iBFT data.
+ */
+static int __init ibft_init(void)
+{
+	int rc = 0;
+
+	if (!ibft_phys)
+		find_ibft();
+
+	rc = firmware_register(&ibft_subsys);
+	if (rc)
+		return rc;
+
+	if (ibft_phys) {
+		printk(KERN_INFO "iBFT detected at 0x%lx.\n",
+		       (unsigned long)ibft_phys);
+
+		rc = ibft_alloc_device(ibft_phys);
+		if (rc)
+			goto out_firmware_unregister;
+
+		/* Scan the IBFT for data. */
+		rc = ibft_scan_device(ibft_device, &ibft_data_list);
+		if (rc)
+			goto out_free;
+
+		/* Register the kobjects based on the ibft_data_list */
+		rc = ibft_register_kobjects(&ibft_data_list,
+				&ibft_kobject_list);
+		if (rc)
+			goto out_free;
+
+		/* Register the attributes */
+		rc = ibft_register_attributes(&ibft_kobject_list,
+				&ibft_attr_list);
+		if (rc)
+			goto out_free;
+	} else
+		printk(KERN_INFO "No iBFT detected.\n");
+
+	if (!rc)
+		return rc;
+
+out_free:
+	ibft_unregister_attributes(&ibft_attr_list);
+	ibft_unregister_kobjects(&ibft_kobject_list);
+	ibft_free_data(&ibft_data_list);
+	ibft_free_device(ibft_device);
+	ibft_device = NULL;
+out_firmware_unregister:
+	firmware_unregister(&ibft_subsys);
+	return rc;
+}
+
+static void __exit ibft_exit(void)
+{
+	ibft_unregister_attributes(&ibft_attr_list);
+	ibft_unregister_kobjects(&ibft_kobject_list);
+	ibft_free_data(&ibft_data_list);
+	ibft_free_device(ibft_device);
+	ibft_device = NULL;
+	firmware_unregister(&ibft_subsys);
+	ibft_phys = 0;
+}
+
+module_init(ibft_init);
+module_exit(ibft_exit);
diff --git a/include/linux/iscsi_ibft.h b/include/linux/iscsi_ibft.h
new file mode 100644
index 0000000..bbbb53c
--- /dev/null
+++ b/include/linux/iscsi_ibft.h
@@ -0,0 +1,198 @@
+#ifndef ISCSI_IBFT_H
+#define ISCSI_IBFT_H
+
+extern void *ibft_phys;
+
+struct ibft_table_header {
+	char signature[4];
+	u32 length;
+	u8 revision;
+	u8 checksum;
+	char oem_id[6];
+	char oem_table_id[8];
+	char reserved[24];
+} __attribute__((__packed__));
+
+#define ISCSI_IBFT_INIT_FLAG_FW_SEL_BOOT 2
+
+enum ibft_id {
+    id_reserved = 0,
+    id_control = 1,
+    id_initiator = 2,
+    id_nic = 3,
+    id_target = 4,
+    id_extensions,
+};
+struct ibft_hdr {
+	u8 id;
+	u8 version;
+	u16 length;
+	u8 index;
+	u8 flags;
+} __attribute__((__packed__));
+
+struct ibft_control {
+    struct ibft_hdr hdr;
+    u16 extensions;
+    u16 initiator_off;
+    u16 nic0_off;
+    u16 tgt0_off;
+    u16 nic1_off;
+    u16 tgt1_off;
+} __attribute__((__packed__));
+
+struct ibft_initiator {
+	struct ibft_hdr hdr;
+	char isns_server[16];
+	char slp_server[16];
+	char pri_radius_server[16];
+	char sec_radius_server[16];
+	u16 initiator_name_len;
+	u16 initiator_name_off;
+} __attribute__((__packed__));
+
+struct ibft_nic {
+	struct ibft_hdr hdr;
+	char ip_addr[16];
+	u8 subnet_mask_prefix;
+	u8 origin;
+	char gateway[16];
+	char primary_dns[16];
+	char secondary_dns[16];
+	char dhcp[16];
+	u16 vlan;
+	char mac[6];
+	u16 pci_bdf;
+	u16 hostname_len;
+	u16 hostname_off;
+} __attribute__((__packed__));
+
+struct ibft_tgt {
+	struct ibft_hdr hdr;
+	char ip_addr[16];
+	u16 port;
+	char lun[8];
+	u8 chap_type;
+	u8 nic_assoc;
+	u16 tgt_name_len;
+	u16 tgt_name_off;
+	u16 chap_name_len;
+	u16 chap_name_off;
+	u16 chap_secret_len;
+	u16 chap_secret_off;
+	u16 rev_chap_name_len;
+	u16 rev_chap_name_off;
+	u16 rev_chap_secret_len;
+	u16 rev_chap_secret_off;
+} __attribute__((__packed__));
+
+#if defined(CONFIG_ISCSI_IBFT) || defined(CONFIG_ISCSI_IBFT_MODULE)
+
+#define IBFT_SIGN "iBFT"
+#define IBFT_SIGN_LEN 4
+#define IBFT_START 0x80000 /* 512kB */
+#define IBFT_END 0x100000 /* 1MB */
+#define VGA_MEM 0xA0000 /* VGA buffer */
+#define VGA_SIZE 0x20000 /* 132kB */
+static ssize_t find_ibft(void)
+{
+	unsigned long pos;
+
+	for (pos = IBFT_START; pos < IBFT_END; pos += 16) {
+		void *virt;
+		/* The table can't be inside the VGA BIOS reserved space,
+		 * so skip that area */
+		if (pos == VGA_MEM)
+			pos += VGA_SIZE;
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
+/*
+ * The tuple of data containing a pointer to the appropiate
+ * (by index number) NIC and Target.
+ *
+ */
+struct ibft_data {
+	u8 index;
+	struct ibft_table_header *hdr;
+	struct ibft_initiator *initiator;
+	struct ibft_nic *nic;
+	struct ibft_tgt *tgt;
+	struct list_head node;
+};
+
+/*
+ * The various kobjects which are linked to the ibft_data.
+ * These are the following kobjects based on the data:
+ *  ethernet@0,X
+ *	+---- local-mac-address
+ *	+---- property
+ *  target@0,X
+ *	+---- property
+ *  chosen
+ *      +---- bootpath (only one)
+ *  aliases
+ *      +---- iscsi-diskX
+ *
+ */
+#define IBFT_ISCSI_KOBJECT_MAX_LEN 15
+#define IBFT_ISCSI_KOBJECT_CHOSEN_NAME "chosen"
+#define IBFT_ISCSI_KOBJECT_ETHERNET_NAME "ethernet@0,%d"
+#define IBFT_ISCSI_KOBJECT_TARGET_NAME "target@0,%d"
+#define IBFT_ISCSI_KOBJECT_ALIASES_NAME "aliases"
+
+enum ibft_kobject_type {
+	kobject_type_chosen,
+	kobject_type_ethernet,
+	kobject_type_target,
+	kobject_type_aliases
+};
+struct ibft_kobject {
+	struct ibft_data *data;
+	char name[IBFT_ISCSI_KOBJECT_MAX_LEN];
+	u8 type;
+	struct kobject kobj;
+	struct list_head node;
+};
+
+/*
+ * The text attributes, which can be:
+ *  - local-mac-address (many of them)
+ *  - property (many of them)
+ *  - bootpath (one) , iscsi-diskX (many)
+ *
+*/
+#define IBFT_ISCSI_ATTR_DISK_NAME "iscsi-disk%d"
+#define IBFT_ISCSI_ATTR_PROPERTY_NAME "property"
+#define IBFT_ISCSI_ATTR_BOOTPATH_NAME "bootpath"
+#define IBFT_ISCSI_ATTR_LOCAL_MAC_ADDRESS_NAME "local-mac-address"
+#define IBFT_ISCSI_ATTR_MAX_LEN 18
+
+struct ibft_attribute {
+	struct attribute attr;
+	ssize_t (*show) (struct  ibft_kobject *entry,
+			 struct ibft_attribute *attr, char *buf);
+	struct ibft_initiator *initiator;
+	struct ibft_nic *nic;
+	struct ibft_tgt *tgt;
+	struct kobject *kobj;
+	char name[IBFT_ISCSI_ATTR_MAX_LEN];
+	struct list_head node;
+};
+
+#endif
+
+#endif /* ISCSI_IBFT_H */
