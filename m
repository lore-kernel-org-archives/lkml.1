Return-Path: <linux-kernel-owner+w=401wt.eu-S1764382AbXKQSil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764382AbXKQSil (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 13:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759190AbXKQSic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 13:38:32 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:18713 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758634AbXKQSi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 13:38:29 -0500
Date: Sat, 17 Nov 2007 11:37:07 -0700
From: Alex Chiang <achiang@hp.com>
To: Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, kaneshige.kenji@jp.fujitsu.com,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: [PATCH 3/4, v3] PCI, PCI Hotplug: Introduce pci_slot
Message-ID: <20071117183707.GC26452@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
	gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, kaneshige.kenji@jp.fujitsu.com,
	pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
References: <20071117182954.GA25003@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071117182954.GA25003@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  - Make pci_slot the primary sysfs entity. hotplug_slot becomes a
    subsidiary structure.
    o pci_create_slot() creates and registers a slot with the PCI core
    o pci_slot_add_hotplug() gives it hotplug capability

  - Change the prototype of pci_hp_register() to take the bus and
    slot number (on parent bus) as parameters.

  - Remove all the ->get_address methods since this functionality is
    now handled by pci_slot directly.

v2 -> v3:
	Separated slot creation and slot hotplug ability into two
	interfaces. Fixed bugs in pci_destroy_slot(), and now
	properly calling from pci_hp_deregister.

v1 -> v2:
	No change

Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/pci/Makefile                    |    2 +-
 drivers/pci/hotplug/acpiphp.h           |    1 -
 drivers/pci/hotplug/acpiphp_core.c      |   23 +---
 drivers/pci/hotplug/acpiphp_glue.c      |   16 --
 drivers/pci/hotplug/acpiphp_ibm.c       |    5 +-
 drivers/pci/hotplug/cpci_hotplug_core.c |    2 +-
 drivers/pci/hotplug/cpqphp_core.c       |    4 +-
 drivers/pci/hotplug/fakephp.c           |    2 +-
 drivers/pci/hotplug/ibmphp_ebda.c       |    3 +-
 drivers/pci/hotplug/pci_hotplug_core.c  |  242 +++++++++++--------------------
 drivers/pci/hotplug/pciehp_core.c       |   22 +--
 drivers/pci/hotplug/rpadlpar_sysfs.c    |    4 +-
 drivers/pci/hotplug/sgi_hotplug.c       |    2 +-
 drivers/pci/hotplug/shpchp_core.c       |   17 +--
 drivers/pci/pci.h                       |   13 ++
 drivers/pci/slot.c                      |  184 +++++++++++++++++++++++
 include/linux/pci.h                     |   17 ++
 include/linux/pci_hotplug.h             |   12 +-
 18 files changed, 328 insertions(+), 243 deletions(-)
 create mode 100644 drivers/pci/slot.c

diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 5550556..12f0b2d 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the PCI bus specific drivers.
 #
 
-obj-y		+= access.o bus.o probe.o remove.o pci.o quirks.o \
+obj-y		+= access.o bus.o probe.o remove.o pci.o quirks.o slot.o \
 			pci-driver.o search.o pci-sysfs.o rom.o setup-res.o
 obj-$(CONFIG_PROC_FS) += proc.o
 
diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
index f6cc0c5..ab46189 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -216,7 +216,6 @@ extern u8 acpiphp_get_power_status (struct acpiphp_slot *slot);
 extern u8 acpiphp_get_attention_status (struct acpiphp_slot *slot);
 extern u8 acpiphp_get_latch_status (struct acpiphp_slot *slot);
 extern u8 acpiphp_get_adapter_status (struct acpiphp_slot *slot);
-extern u32 acpiphp_get_address (struct acpiphp_slot *slot);
 
 /* variables */
 extern int acpiphp_debug;
diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
index a0ca63a..34b8d0b 100644
--- a/drivers/pci/hotplug/acpiphp_core.c
+++ b/drivers/pci/hotplug/acpiphp_core.c
@@ -70,7 +70,6 @@ static int disable_slot		(struct hotplug_slot *slot);
 static int set_attention_status (struct hotplug_slot *slot, u8 value);
 static int get_power_status	(struct hotplug_slot *slot, u8 *value);
 static int get_attention_status (struct hotplug_slot *slot, u8 *value);
-static int get_address		(struct hotplug_slot *slot, u32 *value);
 static int get_latch_status	(struct hotplug_slot *slot, u8 *value);
 static int get_adapter_status	(struct hotplug_slot *slot, u8 *value);
 
@@ -83,7 +82,6 @@ static struct hotplug_slot_ops acpi_hotplug_slot_ops = {
 	.get_attention_status	= get_attention_status,
 	.get_latch_status	= get_latch_status,
 	.get_adapter_status	= get_adapter_status,
-	.get_address		= get_address,
 };
 
 
@@ -279,23 +277,6 @@ static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	return 0;
 }
 
-
-/**
- * get_address - get pci address of a slot
- * @hotplug_slot: slot to get status
- * @value: pointer to struct pci_busdev (seg, bus, dev)
- */
-static int get_address(struct hotplug_slot *hotplug_slot, u32 *value)
-{
-	struct slot *slot = hotplug_slot->private;
-
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
-
-	*value = acpiphp_get_address(slot->acpi_slot);
-
-	return 0;
-}
-
 static int __init init_acpi(void)
 {
 	int retval;
@@ -362,7 +343,9 @@ int acpiphp_register_hotplug_slot(struct acpiphp_slot *acpiphp_slot)
 	acpiphp_slot->slot = slot;
 	snprintf(slot->name, sizeof(slot->name), "%u", slot->acpi_slot->sun);
 
-	retval = pci_hp_register(slot->hotplug_slot);
+	retval = pci_hp_register(slot->hotplug_slot,
+					acpiphp_slot->bridge->pci_bus,
+					acpiphp_slot->device);
 	if (retval) {
 		err("pci_hp_register failed with error %d\n", retval);
 		goto error_hpslot;
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 1e125b5..02a2fd7 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -1874,19 +1874,3 @@ u8 acpiphp_get_adapter_status(struct acpiphp_slot *slot)
 
 	return (sta == 0) ? 0 : 1;
 }
-
-
-/*
- * pci address (seg/bus/dev)
- */
-u32 acpiphp_get_address(struct acpiphp_slot *slot)
-{
-	u32 address;
-	struct pci_bus *pci_bus = slot->bridge->pci_bus;
-
-	address = (pci_domain_nr(pci_bus) << 16) |
-		  (pci_bus->number << 8) |
-		  slot->device;
-
-	return address;
-}
diff --git a/drivers/pci/hotplug/acpiphp_ibm.c b/drivers/pci/hotplug/acpiphp_ibm.c
index 56829f8..927b1fb 100644
--- a/drivers/pci/hotplug/acpiphp_ibm.c
+++ b/drivers/pci/hotplug/acpiphp_ibm.c
@@ -35,6 +35,7 @@
 #include <linux/moduleparam.h>
 
 #include "acpiphp.h"
+extern struct kset pci_slots_subsys;
 
 #define DRIVER_VERSION	"1.0.1"
 #define DRIVER_AUTHOR	"Irene Zubarev <zubarev@us.ibm.com>, Vernon Mauery <vernux@us.ibm.com>"
@@ -428,7 +429,7 @@ static int __init ibm_acpiphp_init(void)
 	int retval = 0;
 	acpi_status status;
 	struct acpi_device *device;
-	struct kobject *sysdir = &pci_hotplug_slots_subsys.kobj;
+	struct kobject *sysdir = &pci_slots_subsys.kobj;
 
 	dbg("%s\n", __FUNCTION__);
 
@@ -475,7 +476,7 @@ init_return:
 static void __exit ibm_acpiphp_exit(void)
 {
 	acpi_status status;
-	struct kobject *sysdir = &pci_hotplug_slots_subsys.kobj;
+	struct kobject *sysdir = &pci_slots_subsys.kobj;
 
 	dbg("%s\n", __FUNCTION__);
 
diff --git a/drivers/pci/hotplug/cpci_hotplug_core.c b/drivers/pci/hotplug/cpci_hotplug_core.c
index ed4d44e..aa47b80 100644
--- a/drivers/pci/hotplug/cpci_hotplug_core.c
+++ b/drivers/pci/hotplug/cpci_hotplug_core.c
@@ -285,7 +285,7 @@ cpci_hp_register_bus(struct pci_bus *bus, u8 first, u8 last)
 		info->attention_status = cpci_get_attention_status(slot);
 
 		dbg("registering slot %s", slot->hotplug_slot->name);
-		status = pci_hp_register(slot->hotplug_slot);
+		status = pci_hp_register(slot->hotplug_slot, bus, i);
 		if (status) {
 			err("pci_hp_register failed with error %d", status);
 			goto error_name;
diff --git a/drivers/pci/hotplug/cpqphp_core.c b/drivers/pci/hotplug/cpqphp_core.c
index a96b739..67f6a0c 100644
--- a/drivers/pci/hotplug/cpqphp_core.c
+++ b/drivers/pci/hotplug/cpqphp_core.c
@@ -434,7 +434,9 @@ static int ctrl_slot_setup(struct controller *ctrl,
 				slot->bus, slot->device,
 				slot->number, ctrl->slot_device_offset,
 				slot_number);
-		result = pci_hp_register(hotplug_slot);
+		result = pci_hp_register(hotplug_slot,
+					 ctrl->pci_dev->subordinate,
+					 slot->device);
 		if (result) {
 			err("pci_hp_register failed with error %d\n", result);
 			goto error_name;
diff --git a/drivers/pci/hotplug/fakephp.c b/drivers/pci/hotplug/fakephp.c
index 996c942..405c608 100644
--- a/drivers/pci/hotplug/fakephp.c
+++ b/drivers/pci/hotplug/fakephp.c
@@ -120,7 +120,7 @@ static int add_slot(struct pci_dev *dev)
 	slot->release = &dummy_release;
 	slot->private = dslot;
 
-	retval = pci_hp_register(slot);
+	retval = pci_hp_register(slot, dev->bus, PCI_SLOT(dev->devfn));
 	if (retval) {
 		err("pci_hp_register failed with error %d\n", retval);
 		goto error_dslot;
diff --git a/drivers/pci/hotplug/ibmphp_ebda.c b/drivers/pci/hotplug/ibmphp_ebda.c
index 600ed7b..eb7a1c0 100644
--- a/drivers/pci/hotplug/ibmphp_ebda.c
+++ b/drivers/pci/hotplug/ibmphp_ebda.c
@@ -1000,7 +1000,8 @@ static int __init ebda_rsrc_controller (void)
 		tmp_slot = list_entry (list, struct slot, ibm_slot_list);
 
 		snprintf (tmp_slot->hotplug_slot->name, 30, "%s", create_file_name (tmp_slot));
-		pci_hp_register (tmp_slot->hotplug_slot);
+		pci_hp_register(tmp_slot->hotplug_slot,
+			pci_find_bus(0, tmp_slot->bus), tmp_slot->device);
 	}
 
 	print_ebda_hpc ();
diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index 01c351c..1be5b0d 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -40,6 +40,7 @@
 #include <linux/pci.h>
 #include <linux/pci_hotplug.h>
 #include <asm/uaccess.h>
+#include "../pci.h"
 
 #define MY_NAME	"pci_hotplug"
 
@@ -61,43 +62,6 @@ static int debug;
 
 static LIST_HEAD(pci_hotplug_slot_list);
 
-struct kset pci_hotplug_slots_subsys;
-
-static ssize_t hotplug_slot_attr_show(struct kobject *kobj,
-		struct attribute *attr, char *buf)
-{
-	struct hotplug_slot *slot = to_hotplug_slot(kobj);
-	struct hotplug_slot_attribute *attribute = to_hotplug_attr(attr);
-	return attribute->show ? attribute->show(slot, buf) : -EIO;
-}
-
-static ssize_t hotplug_slot_attr_store(struct kobject *kobj,
-		struct attribute *attr, const char *buf, size_t len)
-{
-	struct hotplug_slot *slot = to_hotplug_slot(kobj);
-	struct hotplug_slot_attribute *attribute = to_hotplug_attr(attr);
-	return attribute->store ? attribute->store(slot, buf, len) : -EIO;
-}
-
-static struct sysfs_ops hotplug_slot_sysfs_ops = {
-	.show = hotplug_slot_attr_show,
-	.store = hotplug_slot_attr_store,
-};
-
-static void hotplug_slot_release(struct kobject *kobj)
-{
-	struct hotplug_slot *slot = to_hotplug_slot(kobj);
-	if (slot->release)
-		slot->release(slot);
-}
-
-static struct kobj_type hotplug_slot_ktype = {
-	.sysfs_ops = &hotplug_slot_sysfs_ops,
-	.release = &hotplug_slot_release,
-};
-
-decl_subsys_name(pci_hotplug_slots, slots, &hotplug_slot_ktype, NULL);
-
 /* these strings match up with the values in pci_bus_speed */
 static char *pci_bus_speed_strings[] = {
 	"33 MHz PCI",		/* 0x00 */
@@ -151,16 +115,15 @@ GET_STATUS(power_status, u8)
 GET_STATUS(attention_status, u8)
 GET_STATUS(latch_status, u8)
 GET_STATUS(adapter_status, u8)
-GET_STATUS(address, u32)
 GET_STATUS(max_bus_speed, enum pci_bus_speed)
 GET_STATUS(cur_bus_speed, enum pci_bus_speed)
 
-static ssize_t power_read_file (struct hotplug_slot *slot, char *buf)
+static ssize_t power_read_file(struct pci_slot *slot, char *buf)
 {
 	int retval;
 	u8 value;
 
-	retval = get_power_status (slot, &value);
+	retval = get_power_status(slot->hotplug, &value);
 	if (retval)
 		goto exit;
 	retval = sprintf (buf, "%d\n", value);
@@ -168,9 +131,10 @@ exit:
 	return retval;
 }
 
-static ssize_t power_write_file (struct hotplug_slot *slot, const char *buf,
+static ssize_t power_write_file(struct pci_slot *pci_slot, const char *buf,
 		size_t count)
 {
+	struct hotplug_slot *slot = pci_slot->hotplug;
 	unsigned long lpower;
 	u8 power;
 	int retval = 0;
@@ -206,29 +170,30 @@ exit:
 	return count;
 }
 
-static struct hotplug_slot_attribute hotplug_slot_attr_power = {
+static struct pci_slot_attribute hotplug_slot_attr_power = {
 	.attr = {.name = "power", .mode = S_IFREG | S_IRUGO | S_IWUSR},
 	.show = power_read_file,
 	.store = power_write_file
 };
 
-static ssize_t attention_read_file (struct hotplug_slot *slot, char *buf)
+static ssize_t attention_read_file(struct pci_slot *slot, char *buf)
 {
 	int retval;
 	u8 value;
 
-	retval = get_attention_status (slot, &value);
+	retval = get_attention_status(slot->hotplug, &value);
 	if (retval)
 		goto exit;
-	retval = sprintf (buf, "%d\n", value);
+	retval = sprintf(buf, "%d\n", value);
 
 exit:
 	return retval;
 }
 
-static ssize_t attention_write_file (struct hotplug_slot *slot, const char *buf,
+static ssize_t attention_write_file(struct pci_slot *slot, const char *buf,
 		size_t count)
 {
+	struct hotplug_slot_ops *ops = slot->hotplug->ops;
 	unsigned long lattention;
 	u8 attention;
 	int retval = 0;
@@ -237,13 +202,13 @@ static ssize_t attention_write_file (struct hotplug_slot *slot, const char *buf,
 	attention = (u8)(lattention & 0xff);
 	dbg (" - attention = %d\n", attention);
 
-	if (!try_module_get(slot->ops->owner)) {
+	if (!try_module_get(ops->owner)) {
 		retval = -ENODEV;
 		goto exit;
 	}
-	if (slot->ops->set_attention_status)
-		retval = slot->ops->set_attention_status(slot, attention);
-	module_put(slot->ops->owner);
+	if (ops->set_attention_status)
+		retval = ops->set_attention_status(slot->hotplug, attention);
+	module_put(ops->owner);
 
 exit:	
 	if (retval)
@@ -251,18 +216,18 @@ exit:
 	return count;
 }
 
-static struct hotplug_slot_attribute hotplug_slot_attr_attention = {
+static struct pci_slot_attribute hotplug_slot_attr_attention = {
 	.attr = {.name = "attention", .mode = S_IFREG | S_IRUGO | S_IWUSR},
 	.show = attention_read_file,
 	.store = attention_write_file
 };
 
-static ssize_t latch_read_file (struct hotplug_slot *slot, char *buf)
+static ssize_t latch_read_file(struct pci_slot *slot, char *buf)
 {
 	int retval;
 	u8 value;
 
-	retval = get_latch_status (slot, &value);
+	retval = get_latch_status(slot->hotplug, &value);
 	if (retval)
 		goto exit;
 	retval = sprintf (buf, "%d\n", value);
@@ -271,17 +236,17 @@ exit:
 	return retval;
 }
 
-static struct hotplug_slot_attribute hotplug_slot_attr_latch = {
+static struct pci_slot_attribute hotplug_slot_attr_latch = {
 	.attr = {.name = "latch", .mode = S_IFREG | S_IRUGO},
 	.show = latch_read_file,
 };
 
-static ssize_t presence_read_file (struct hotplug_slot *slot, char *buf)
+static ssize_t presence_read_file(struct pci_slot *slot, char *buf)
 {
 	int retval;
 	u8 value;
 
-	retval = get_adapter_status (slot, &value);
+	retval = get_adapter_status(slot->hotplug, &value);
 	if (retval)
 		goto exit;
 	retval = sprintf (buf, "%d\n", value);
@@ -290,42 +255,20 @@ exit:
 	return retval;
 }
 
-static struct hotplug_slot_attribute hotplug_slot_attr_presence = {
+static struct pci_slot_attribute hotplug_slot_attr_presence = {
 	.attr = {.name = "adapter", .mode = S_IFREG | S_IRUGO},
 	.show = presence_read_file,
 };
 
-static ssize_t address_read_file (struct hotplug_slot *slot, char *buf)
-{
-	int retval;
-	u32 address;
-
-	retval = get_address (slot, &address);
-	if (retval)
-		goto exit;
-	retval = sprintf (buf, "%04x:%02x:%02x\n",
-			  (address >> 16) & 0xffff,
-			  (address >> 8) & 0xff,
-			  address & 0xff);
-
-exit:
-	return retval;
-}
-
-static struct hotplug_slot_attribute hotplug_slot_attr_address = {
-	.attr = {.name = "address", .mode = S_IFREG | S_IRUGO},
-	.show = address_read_file,
-};
-
 static char *unknown_speed = "Unknown bus speed";
 
-static ssize_t max_bus_speed_read_file (struct hotplug_slot *slot, char *buf)
+static ssize_t max_bus_speed_read_file(struct pci_slot *slot, char *buf)
 {
 	char *speed_string;
 	int retval;
 	enum pci_bus_speed value;
 	
-	retval = get_max_bus_speed (slot, &value);
+	retval = get_max_bus_speed(slot->hotplug, &value);
 	if (retval)
 		goto exit;
 
@@ -340,18 +283,18 @@ exit:
 	return retval;
 }
 
-static struct hotplug_slot_attribute hotplug_slot_attr_max_bus_speed = {
+static struct pci_slot_attribute hotplug_slot_attr_max_bus_speed = {
 	.attr = {.name = "max_bus_speed", .mode = S_IFREG | S_IRUGO},
 	.show = max_bus_speed_read_file,
 };
 
-static ssize_t cur_bus_speed_read_file (struct hotplug_slot *slot, char *buf)
+static ssize_t cur_bus_speed_read_file(struct pci_slot *slot, char *buf)
 {
 	char *speed_string;
 	int retval;
 	enum pci_bus_speed value;
 
-	retval = get_cur_bus_speed (slot, &value);
+	retval = get_cur_bus_speed(slot->hotplug, &value);
 	if (retval)
 		goto exit;
 
@@ -366,14 +309,15 @@ exit:
 	return retval;
 }
 
-static struct hotplug_slot_attribute hotplug_slot_attr_cur_bus_speed = {
+static struct pci_slot_attribute hotplug_slot_attr_cur_bus_speed = {
 	.attr = {.name = "cur_bus_speed", .mode = S_IFREG | S_IRUGO},
 	.show = cur_bus_speed_read_file,
 };
 
-static ssize_t test_write_file (struct hotplug_slot *slot, const char *buf,
+static ssize_t test_write_file(struct pci_slot *pci_slot, const char *buf,
 		size_t count)
 {
+	struct hotplug_slot *slot = pci_slot->hotplug;
 	unsigned long ltest;
 	u32 test;
 	int retval = 0;
@@ -396,13 +340,14 @@ exit:
 	return count;
 }
 
-static struct hotplug_slot_attribute hotplug_slot_attr_test = {
+static struct pci_slot_attribute hotplug_slot_attr_test = {
 	.attr = {.name = "test", .mode = S_IFREG | S_IRUGO | S_IWUSR},
 	.store = test_write_file
 };
 
-static int has_power_file (struct hotplug_slot *slot)
+static int has_power_file(struct pci_slot *pci_slot)
 {
+	struct hotplug_slot *slot = pci_slot->hotplug;
 	if ((!slot) || (!slot->ops))
 		return -ENODEV;
 	if ((slot->ops->enable_slot) ||
@@ -412,8 +357,9 @@ static int has_power_file (struct hotplug_slot *slot)
 	return -ENOENT;
 }
 
-static int has_attention_file (struct hotplug_slot *slot)
+static int has_attention_file(struct pci_slot *pci_slot)
 {
+	struct hotplug_slot *slot = pci_slot->hotplug;
 	if ((!slot) || (!slot->ops))
 		return -ENODEV;
 	if ((slot->ops->set_attention_status) ||
@@ -422,8 +368,9 @@ static int has_attention_file (struct hotplug_slot *slot)
 	return -ENOENT;
 }
 
-static int has_latch_file (struct hotplug_slot *slot)
+static int has_latch_file(struct pci_slot *pci_slot)
 {
+	struct hotplug_slot *slot = pci_slot->hotplug;
 	if ((!slot) || (!slot->ops))
 		return -ENODEV;
 	if (slot->ops->get_latch_status)
@@ -431,8 +378,9 @@ static int has_latch_file (struct hotplug_slot *slot)
 	return -ENOENT;
 }
 
-static int has_adapter_file (struct hotplug_slot *slot)
+static int has_adapter_file(struct pci_slot *pci_slot)
 {
+	struct hotplug_slot *slot = pci_slot->hotplug;
 	if ((!slot) || (!slot->ops))
 		return -ENODEV;
 	if (slot->ops->get_adapter_status)
@@ -440,17 +388,9 @@ static int has_adapter_file (struct hotplug_slot *slot)
 	return -ENOENT;
 }
 
-static int has_address_file (struct hotplug_slot *slot)
-{
-	if ((!slot) || (!slot->ops))
-		return -ENODEV;
-	if (slot->ops->get_address)
-		return 0;
-	return -ENOENT;
-}
-
-static int has_max_bus_speed_file (struct hotplug_slot *slot)
+static int has_max_bus_speed_file(struct pci_slot *pci_slot)
 {
+	struct hotplug_slot *slot = pci_slot->hotplug;
 	if ((!slot) || (!slot->ops))
 		return -ENODEV;
 	if (slot->ops->get_max_bus_speed)
@@ -458,8 +398,9 @@ static int has_max_bus_speed_file (struct hotplug_slot *slot)
 	return -ENOENT;
 }
 
-static int has_cur_bus_speed_file (struct hotplug_slot *slot)
+static int has_cur_bus_speed_file(struct pci_slot *pci_slot)
 {
+	struct hotplug_slot *slot = pci_slot->hotplug;
 	if ((!slot) || (!slot->ops))
 		return -ENODEV;
 	if (slot->ops->get_cur_bus_speed)
@@ -467,8 +408,9 @@ static int has_cur_bus_speed_file (struct hotplug_slot *slot)
 	return -ENOENT;
 }
 
-static int has_test_file (struct hotplug_slot *slot)
+static int has_test_file(struct pci_slot *pci_slot)
 {
+	struct hotplug_slot *slot = pci_slot->hotplug;
 	if ((!slot) || (!slot->ops))
 		return -ENODEV;
 	if (slot->ops->hardware_test)
@@ -476,7 +418,7 @@ static int has_test_file (struct hotplug_slot *slot)
 	return -ENOENT;
 }
 
-static int fs_add_slot (struct hotplug_slot *slot)
+static int fs_add_slot(struct pci_slot *slot)
 {
 	int retval = 0;
 
@@ -507,13 +449,6 @@ static int fs_add_slot (struct hotplug_slot *slot)
 			goto exit_adapter;
 	}
 
-	if (has_address_file(slot) == 0) {
-		retval = sysfs_create_file(&slot->kobj,
-					   &hotplug_slot_attr_address.attr);
-		if (retval)
-			goto exit_address;
-	}
-
 	if (has_max_bus_speed_file(slot) == 0) {
 		retval = sysfs_create_file(&slot->kobj,
 					   &hotplug_slot_attr_max_bus_speed.attr);
@@ -546,10 +481,6 @@ exit_cur_speed:
 		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_max_bus_speed.attr);
 
 exit_max_speed:
-	if (has_address_file(slot) == 0)
-		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_address.attr);
-
-exit_address:
 	if (has_adapter_file(slot) == 0)
 		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_presence.attr);
 
@@ -569,7 +500,7 @@ exit:
 	return retval;
 }
 
-static void fs_remove_slot (struct hotplug_slot *slot)
+static void fs_remove_slot(struct pci_slot *slot)
 {
 	if (has_power_file(slot) == 0)
 		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_power.attr);
@@ -583,9 +514,6 @@ static void fs_remove_slot (struct hotplug_slot *slot)
 	if (has_adapter_file(slot) == 0)
 		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_presence.attr);
 
-	if (has_address_file(slot) == 0)
-		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_address.attr);
-
 	if (has_max_bus_speed_file(slot) == 0)
 		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_max_bus_speed.attr);
 
@@ -609,6 +537,12 @@ static struct hotplug_slot *get_slot_from_name (const char *name)
 	return NULL;
 }
 
+static void hotplug_release(struct pci_slot *slot)
+{
+	struct hotplug_slot *hotplug = slot->hotplug;
+	hotplug->release(hotplug);
+}
+
 /**
  * pci_hp_register - register a hotplug_slot with the PCI hotplug subsystem
  * @slot: pointer to the &struct hotplug_slot to register
@@ -618,8 +552,9 @@ static struct hotplug_slot *get_slot_from_name (const char *name)
  *
  * Returns 0 if successful, anything else for an error.
  */
-int pci_hp_register (struct hotplug_slot *slot)
+int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr)
 {
+	struct pci_slot *pci_slot;
 	int result;
 
 	if (slot == NULL)
@@ -632,18 +567,20 @@ int pci_hp_register (struct hotplug_slot *slot)
 		return -EINVAL;
 	}
 
-	kobject_set_name(&slot->kobj, "%s", slot->name);
-	kobj_set_kset_s(slot, pci_hotplug_slots_subsys);
+	pci_slot = pci_create_slot(bus, slot_nr, slot->name);
+	if (IS_ERR(pci_slot))
+		return PTR_ERR(pci_slot);
 
-	/* this can fail if we have already registered a slot with the same name */
-	if (kobject_register(&slot->kobj)) {
-		err("Unable to register kobject");
-		return -EINVAL;
-	}
-		
-	list_add (&slot->slot_list, &pci_hotplug_slot_list);
+	pci_slot = pci_slot_add_hotplug(bus, slot_nr, hotplug_release);
+	if (IS_ERR(pci_slot))
+		return PTR_ERR(pci_slot);
+
+	slot->pci_slot = pci_slot;
+	pci_slot->hotplug = slot;
 
-	result = fs_add_slot (slot);
+	list_add(&slot->slot_list, &pci_hotplug_slot_list);
+
+	result = fs_add_slot(pci_slot);
 	dbg ("Added slot %s to the list\n", slot->name);
 	return result;
 }
@@ -657,22 +594,24 @@ int pci_hp_register (struct hotplug_slot *slot)
  *
  * Returns 0 if successful, anything else for an error.
  */
-int pci_hp_deregister (struct hotplug_slot *slot)
+int pci_hp_deregister(struct hotplug_slot *hotplug)
 {
 	struct hotplug_slot *temp;
+	struct pci_slot *slot;
 
-	if (slot == NULL)
+	if (!hotplug)
 		return -ENODEV;
 
-	temp = get_slot_from_name (slot->name);
-	if (temp != slot) {
+	temp = get_slot_from_name(hotplug->name);
+	if (temp != hotplug)
 		return -ENODEV;
-	}
-	list_del (&slot->slot_list);
 
-	fs_remove_slot (slot);
-	dbg ("Removed slot %s from the list\n", slot->name);
-	kobject_unregister(&slot->kobj);
+	list_del(&hotplug->slot_list);
+
+	slot = hotplug->pci_slot;
+	fs_remove_slot(slot);
+	pci_destroy_slot(slot);
+	dbg("Removed slot %s from the list\n", hotplug->name);
 	return 0;
 }
 
@@ -686,13 +625,15 @@ int pci_hp_deregister (struct hotplug_slot *slot)
  *
  * Returns 0 if successful, anything else for an error.
  */
-int __must_check pci_hp_change_slot_info(struct hotplug_slot *slot,
+int __must_check pci_hp_change_slot_info(struct hotplug_slot *hotplug,
 					 struct hotplug_slot_info *info)
 {
-	if ((slot == NULL) || (info == NULL))
+	struct pci_slot *slot;
+	if (!hotplug || !info)
 		return -ENODEV;
+	slot = hotplug->pci_slot;
 
-	memcpy (slot->info, info, sizeof (struct hotplug_slot_info));
+	memcpy(hotplug->info, info, sizeof(struct hotplug_slot_info));
 
 	return 0;
 }
@@ -701,31 +642,21 @@ static int __init pci_hotplug_init (void)
 {
 	int result;
 
-	kobj_set_kset_s(&pci_hotplug_slots_subsys, pci_bus_type.subsys);
-	result = subsystem_register(&pci_hotplug_slots_subsys);
-	if (result) {
-		err("Register subsys with error %d\n", result);
-		goto exit;
-	}
 	result = cpci_hotplug_init(debug);
 	if (result) {
 		err ("cpci_hotplug_init with error %d\n", result);
-		goto err_subsys;
+		goto err_cpci;
 	}
 
 	info (DRIVER_DESC " version: " DRIVER_VERSION "\n");
-	goto exit;
-	
-err_subsys:
-	subsystem_unregister(&pci_hotplug_slots_subsys);
-exit:
+
+err_cpci:
 	return result;
 }
 
 static void __exit pci_hotplug_exit (void)
 {
 	cpci_hotplug_exit();
-	subsystem_unregister(&pci_hotplug_slots_subsys);
 }
 
 module_init(pci_hotplug_init);
@@ -737,7 +668,6 @@ MODULE_LICENSE("GPL");
 module_param(debug, bool, 0644);
 MODULE_PARM_DESC(debug, "Debugging mode enabled or not");
 
-EXPORT_SYMBOL_GPL(pci_hotplug_slots_subsys);
 EXPORT_SYMBOL_GPL(pci_hp_register);
 EXPORT_SYMBOL_GPL(pci_hp_deregister);
 EXPORT_SYMBOL_GPL(pci_hp_change_slot_info);
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 6462ac3..8fee402 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -69,7 +69,6 @@ static int get_power_status	(struct hotplug_slot *slot, u8 *value);
 static int get_attention_status	(struct hotplug_slot *slot, u8 *value);
 static int get_latch_status	(struct hotplug_slot *slot, u8 *value);
 static int get_adapter_status	(struct hotplug_slot *slot, u8 *value);
-static int get_address		(struct hotplug_slot *slot, u32 *value);
 static int get_max_bus_speed	(struct hotplug_slot *slot, enum pci_bus_speed *value);
 static int get_cur_bus_speed	(struct hotplug_slot *slot, enum pci_bus_speed *value);
 
@@ -82,7 +81,6 @@ static struct hotplug_slot_ops pciehp_hotplug_slot_ops = {
 	.get_attention_status =	get_attention_status,
 	.get_latch_status =	get_latch_status,
 	.get_adapter_status =	get_adapter_status,
-	.get_address =		get_address,
   	.get_max_bus_speed =	get_max_bus_speed,
   	.get_cur_bus_speed =	get_cur_bus_speed,
 };
@@ -245,14 +243,16 @@ static int init_slots(struct controller *ctrl)
 		dbg("Registering bus=%x dev=%x hp_slot=%x sun=%x "
 		    "slot_device_offset=%x\n", slot->bus, slot->device,
 		    slot->hp_slot, slot->number, ctrl->slot_device_offset);
-		retval = pci_hp_register(hotplug_slot);
+		retval = pci_hp_register(hotplug_slot,
+					 ctrl->pci_dev->subordinate,
+					 slot->number);
 		if (retval) {
 			err ("pci_hp_register failed with error %d\n", retval);
 			goto error_info;
 		}
 		/* create additional sysfs entries */
 		if (EMI(ctrl->ctrlcap)) {
-			retval = sysfs_create_file(&hotplug_slot->kobj,
+			retval = sysfs_create_file(&hotplug_slot->pci_slot->kobj,
 				&hotplug_slot_attr_lock.attr);
 			if (retval) {
 				pci_hp_deregister(hotplug_slot);
@@ -285,7 +285,7 @@ static void cleanup_slots(struct controller *ctrl)
 		slot = list_entry(tmp, struct slot, slot_list);
 		list_del(&slot->slot_list);
 		if (EMI(ctrl->ctrlcap))
-			sysfs_remove_file(&slot->hotplug_slot->kobj,
+			sysfs_remove_file(&slot->hotplug_slot->pci_slot->kobj,
 				&hotplug_slot_attr_lock.attr);
 		cancel_delayed_work(&slot->work);
 		flush_scheduled_work();
@@ -387,18 +387,6 @@ static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	return 0;
 }
 
-static int get_address(struct hotplug_slot *hotplug_slot, u32 *value)
-{
-	struct slot *slot = hotplug_slot->private;
-	struct pci_bus *bus = slot->ctrl->pci_dev->subordinate;
-
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
-
-	*value = (pci_domain_nr(bus) << 16) | (slot->bus << 8) | slot->device;
-
-	return 0;
-}
-
 static int get_max_bus_speed(struct hotplug_slot *hotplug_slot, enum pci_bus_speed *value)
 {
 	struct slot *slot = hotplug_slot->private;
diff --git a/drivers/pci/hotplug/rpadlpar_sysfs.c b/drivers/pci/hotplug/rpadlpar_sysfs.c
index a080fed..3663507 100644
--- a/drivers/pci/hotplug/rpadlpar_sysfs.c
+++ b/drivers/pci/hotplug/rpadlpar_sysfs.c
@@ -23,6 +23,8 @@
 
 #define MAX_DRC_NAME_LEN 64
 
+extern struct kset pci_slots_subsys;
+
 /* Store return code of dlpar operation in attribute struct */
 struct dlpar_io_attr {
 	int rc;
@@ -130,7 +132,7 @@ struct kobj_type ktype_dlpar_io = {
 
 struct kset dlpar_io_kset = {
 	.kobj = {.ktype = &ktype_dlpar_io,
-		 .parent = &pci_hotplug_slots_subsys.kobj},
+		 .parent = &pci_slots_subsys.kobj},
 	.ktype = &ktype_dlpar_io,
 };
 
diff --git a/drivers/pci/hotplug/sgi_hotplug.c b/drivers/pci/hotplug/sgi_hotplug.c
index 693519e..cc74602 100644
--- a/drivers/pci/hotplug/sgi_hotplug.c
+++ b/drivers/pci/hotplug/sgi_hotplug.c
@@ -625,7 +625,7 @@ static int sn_hotplug_slot_register(struct pci_bus *pci_bus)
 		bss_hotplug_slot->ops = &sn_hotplug_slot_ops;
 		bss_hotplug_slot->release = &sn_release_slot;
 
-		rc = pci_hp_register(bss_hotplug_slot);
+		rc = pci_hp_register(bss_hotplug_slot, pci_bus, device);
 		if (rc)
 			goto register_err;
 	}
diff --git a/drivers/pci/hotplug/shpchp_core.c b/drivers/pci/hotplug/shpchp_core.c
index 80dec97..22c4d2e 100644
--- a/drivers/pci/hotplug/shpchp_core.c
+++ b/drivers/pci/hotplug/shpchp_core.c
@@ -65,7 +65,6 @@ static int get_power_status	(struct hotplug_slot *slot, u8 *value);
 static int get_attention_status	(struct hotplug_slot *slot, u8 *value);
 static int get_latch_status	(struct hotplug_slot *slot, u8 *value);
 static int get_adapter_status	(struct hotplug_slot *slot, u8 *value);
-static int get_address		(struct hotplug_slot *slot, u32 *value);
 static int get_max_bus_speed	(struct hotplug_slot *slot, enum pci_bus_speed *value);
 static int get_cur_bus_speed	(struct hotplug_slot *slot, enum pci_bus_speed *value);
 
@@ -78,7 +77,6 @@ static struct hotplug_slot_ops shpchp_hotplug_slot_ops = {
 	.get_attention_status =	get_attention_status,
 	.get_latch_status =	get_latch_status,
 	.get_adapter_status =	get_adapter_status,
-	.get_address =		get_address,
 	.get_max_bus_speed =	get_max_bus_speed,
 	.get_cur_bus_speed =	get_cur_bus_speed,
 };
@@ -152,7 +150,8 @@ static int init_slots(struct controller *ctrl)
 		dbg("Registering bus=%x dev=%x hp_slot=%x sun=%x "
 		    "slot_device_offset=%x\n", slot->bus, slot->device,
 		    slot->hp_slot, slot->number, ctrl->slot_device_offset);
-		retval = pci_hp_register(slot->hotplug_slot);
+		retval = pci_hp_register(slot->hotplug_slot,
+				ctrl->pci_dev->subordinate, slot->device);
 		if (retval) {
 			err("pci_hp_register failed with error %d\n", retval);
 			goto error_info;
@@ -277,18 +276,6 @@ static int get_adapter_status (struct hotplug_slot *hotplug_slot, u8 *value)
 	return 0;
 }
 
-static int get_address (struct hotplug_slot *hotplug_slot, u32 *value)
-{
-	struct slot *slot = get_slot(hotplug_slot);
-	struct pci_bus *bus = slot->ctrl->pci_dev->subordinate;
-
-	dbg("%s - physical_slot = %s\n", __FUNCTION__, hotplug_slot->name);
-
-	*value = (pci_domain_nr(bus) << 16) | (slot->bus << 8) | slot->device;
-
-	return 0;
-}
-
 static int get_max_bus_speed (struct hotplug_slot *hotplug_slot, enum pci_bus_speed *value)
 {
 	struct slot *slot = get_slot(hotplug_slot);
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index fc87e14..4bcfabf 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -91,3 +91,16 @@ pci_match_one_device(const struct pci_device_id *id, const struct pci_dev *dev)
 }
 
 struct pci_dev *pci_find_upstream_pcie_bridge(struct pci_dev *pdev);
+
+/* PCI slot sysfs helper code */
+#define to_pci_slot(s) container_of(s, struct pci_slot, kobj)
+
+extern struct kset pci_slots_subsys;
+
+struct pci_slot_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct pci_slot *, char *);
+	ssize_t (*store)(struct pci_slot *, const char *, size_t);
+};
+#define to_pci_slot_attr(s) container_of(s, struct pci_slot_attribute, attr)
+
diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
new file mode 100644
index 0000000..f4ca61b
--- /dev/null
+++ b/drivers/pci/slot.c
@@ -0,0 +1,184 @@
+/*
+ * drivers/pci/slot.c
+ * Copyright (c) 2006 Matthew Wilcox <matthew@wil.cx>
+ * Copyright (c) 2006 Hewlett-Packard Company
+ */
+
+#include <linux/kobject.h>
+#include <linux/pci.h>
+#include "pci.h"
+
+struct kset pci_slots_subsys;
+EXPORT_SYMBOL_GPL(pci_slots_subsys);
+
+static ssize_t pci_slot_attr_show(struct kobject *kobj,
+					struct attribute *attr, char *buf)
+{
+	struct pci_slot *slot = to_pci_slot(kobj);
+	struct pci_slot_attribute *attribute = to_pci_slot_attr(attr);
+	return attribute->show ? attribute->show(slot, buf) : -EIO;
+}
+
+static ssize_t pci_slot_attr_store(struct kobject *kobj,
+			struct attribute *attr, const char *buf, size_t len)
+{
+	struct pci_slot *slot = to_pci_slot(kobj);
+	struct pci_slot_attribute *attribute = to_pci_slot_attr(attr);
+	return attribute->store ? attribute->store(slot, buf, len) : -EIO;
+}
+
+static struct sysfs_ops pci_slot_sysfs_ops = {
+	.show = pci_slot_attr_show,
+	.store = pci_slot_attr_store,
+};
+
+static void pci_slot_release(struct kobject *kobj)
+{
+	struct pci_slot *slot = to_pci_slot(kobj);
+	slot->release(slot);
+	kfree(slot);
+}
+
+static struct kobj_type pci_slot_ktype = {
+	.sysfs_ops = &pci_slot_sysfs_ops,
+	.release = &pci_slot_release,
+};
+
+decl_subsys_name(pci_slots, slots, &pci_slot_ktype, NULL);
+
+static ssize_t address_read_file(struct pci_slot *slot, char *buf)
+{
+	return sprintf(buf, "%04x:%02x:%02x\n", pci_domain_nr(slot->bus),
+					slot->bus->number, slot->number);
+}
+
+static struct pci_slot_attribute pci_slot_attr_address = {
+	.attr = { .name = "address", .mode = S_IFREG | S_IRUGO },
+	.show = address_read_file,
+};
+
+static void remove_sysfs_files(struct pci_slot *slot)
+{
+	sysfs_remove_file(&slot->kobj, &pci_slot_attr_address.attr);
+}
+
+static int create_sysfs_files(struct pci_slot *slot)
+{
+	int result;
+
+	result = sysfs_create_file(&slot->kobj, &pci_slot_attr_address.attr);
+
+	return result;
+}
+
+struct pci_slot *pci_slot_add_hotplug(struct pci_bus *parent, int slot_nr,
+				      void (*release)(struct pci_slot *))
+{
+	struct pci_slot *slot;
+	int found = 0;
+
+	down_write(&pci_bus_sem);
+
+	/* This slot should have already been created, so look for it. If
+	 * we can't find it, return -EEXIST.
+	 */
+	for (slot = parent->slot; slot; slot = slot->next)
+		if (slot->number == slot_nr) {
+			found = 1;
+			break;
+		}
+
+	if (!found) {
+		slot = ERR_PTR(-EEXIST);
+		goto out;
+	}
+
+	slot->release = release;
+ out:
+	up_write(&pci_bus_sem);
+	return slot;
+}
+EXPORT_SYMBOL_GPL(pci_slot_add_hotplug);
+
+struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
+				 const char *name)
+{
+	struct pci_slot *slot;
+	int err;
+
+	down_write(&pci_bus_sem);
+
+	/* If we've already created this slot, just return. */
+	for (slot = parent->slot; slot; slot = slot->next) {
+		if (slot->number != slot_nr)
+			continue;
+		goto out;
+	}
+
+	slot = kzalloc(sizeof(*slot), GFP_KERNEL);
+	if (!slot) {
+		slot = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+
+	slot->bus = parent;
+	slot->number = slot_nr;
+
+	kobject_set_name(&slot->kobj, "%s", name);
+	kobj_set_kset_s(slot, pci_slots_subsys);
+	if (kobject_register(&slot->kobj)) {
+		printk(KERN_ERR "Unable to register kobject %s", name);
+		err = -EINVAL;
+		goto err;
+	}
+
+	err = create_sysfs_files(slot);
+	if (err)
+		goto unregister;
+
+	slot->next = parent->slot;
+	parent->slot = slot;
+
+ out:
+	up_write(&pci_bus_sem);
+	return slot;
+
+ unregister:
+	kobject_unregister(&slot->kobj);
+ err:
+	kfree(slot);
+	slot = ERR_PTR(err);
+	goto out;
+}
+EXPORT_SYMBOL_GPL(pci_create_slot);
+
+int pci_destroy_slot(struct pci_slot *slot)
+{
+	struct pci_slot **pprev;
+
+	for (pprev = &slot->bus->slot; *pprev; pprev = &(*pprev)->next) {
+		if (*pprev == slot) {
+			*pprev = slot->next;
+			break;
+		}
+	}
+
+	remove_sysfs_files(slot);
+	kobject_unregister(&slot->kobj);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_destroy_slot);
+
+static int pci_slot_init(void)
+{
+	int result;
+
+	kobj_set_kset_s(&pci_slots_subsys, pci_bus_type.subsys);
+	result = subsystem_register(&pci_slots_subsys);
+	if (result)
+		printk(KERN_ERR "PCI: Slot initialisation failure (%d)",
+			result);
+	return result;
+}
+
+subsys_initcall(pci_slot_init);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 0dd93bb..ae2245f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -129,6 +129,16 @@ struct pci_cap_saved_state {
 	u32 data[0];
 };
 
+/* pci_slot represents a physical slot */
+struct pci_slot {
+	struct pci_bus *bus;		/* The bus this slot is on */
+	struct pci_slot *next;		/* Next slot on this bus */
+	struct hotplug_slot *hotplug;	/* Hotplug info (migrate over time) */
+	unsigned char number;		/* PCI_SLOT(pci_dev->devfn) */
+	struct kobject kobj;
+	void (*release)(struct pci_slot *);
+};
+
 /*
  * The pci_dev structure is used to describe PCI devices.
  */
@@ -140,6 +150,7 @@ struct pci_dev {
 
 	void		*sysdata;	/* hook for sys-specific extension */
 	struct proc_dir_entry *procent;	/* device entry in /proc/bus/pci */
+	struct pci_slot	*slot;		/* Physical slot this device is in */
 
 	unsigned int	devfn;		/* encoded device & function index */
 	unsigned short	vendor;
@@ -261,6 +272,7 @@ struct pci_bus {
 	struct list_head children;	/* list of child buses */
 	struct list_head devices;	/* list of devices on this bus */
 	struct pci_dev	*self;		/* bridge device as seen by parent */
+	struct pci_slot	*slot;		/* First physical slot on this bus */
 	struct resource	*resource[PCI_BUS_NUM_RESOURCES];
 					/* address space routed to this bus */
 
@@ -470,6 +482,11 @@ static inline struct pci_bus *pci_scan_bus(int bus, struct pci_ops *ops, void *s
 }
 struct pci_bus *pci_create_bus(struct device *parent, int bus, struct pci_ops *ops, void *sysdata);
 struct pci_bus * pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev, int busnr);
+struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
+				 const char *name);
+struct pci_slot *pci_slot_add_hotplug(struct pci_bus *parent, int slot_nr,
+				    void (*release)(struct pci_slot *));
+int pci_destroy_slot(struct pci_slot *slot);
 int pci_scan_slot(struct pci_bus *bus, int devfn);
 struct pci_dev * pci_scan_single_device(struct pci_bus *bus, int devfn);
 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus);
diff --git a/include/linux/pci_hotplug.h b/include/linux/pci_hotplug.h
index ab4cb6e..bb36c59 100644
--- a/include/linux/pci_hotplug.h
+++ b/include/linux/pci_hotplug.h
@@ -95,9 +95,6 @@ struct hotplug_slot_attribute {
  * @get_adapter_status: Called to get see if an adapter is present in the slot or not.
  *	If this field is NULL, the value passed in the struct hotplug_slot_info
  *	will be used when this value is requested by a user.
- * @get_address: Called to get pci address of a slot.
- *	If this field is NULL, the value passed in the struct hotplug_slot_info
- *	will be used when this value is requested by a user.
  * @get_max_bus_speed: Called to get the max bus speed for a slot.
  *	If this field is NULL, the value passed in the struct hotplug_slot_info
  *	will be used when this value is requested by a user.
@@ -120,7 +117,6 @@ struct hotplug_slot_ops {
 	int (*get_attention_status)	(struct hotplug_slot *slot, u8 *value);
 	int (*get_latch_status)		(struct hotplug_slot *slot, u8 *value);
 	int (*get_adapter_status)	(struct hotplug_slot *slot, u8 *value);
-	int (*get_address)		(struct hotplug_slot *slot, u32 *value);
 	int (*get_max_bus_speed)	(struct hotplug_slot *slot, enum pci_bus_speed *value);
 	int (*get_cur_bus_speed)	(struct hotplug_slot *slot, enum pci_bus_speed *value);
 };
@@ -140,7 +136,6 @@ struct hotplug_slot_info {
 	u8	attention_status;
 	u8	latch_status;
 	u8	adapter_status;
-	u32	address;
 	enum pci_bus_speed	max_bus_speed;
 	enum pci_bus_speed	cur_bus_speed;
 };
@@ -166,15 +161,14 @@ struct hotplug_slot {
 
 	/* Variables below this are for use only by the hotplug pci core. */
 	struct list_head		slot_list;
-	struct kobject			kobj;
+	struct pci_slot			*pci_slot;
 };
 #define to_hotplug_slot(n) container_of(n, struct hotplug_slot, kobj)
 
-extern int pci_hp_register		(struct hotplug_slot *slot);
-extern int pci_hp_deregister		(struct hotplug_slot *slot);
+extern int pci_hp_register(struct hotplug_slot *, struct pci_bus *, int nr);
+extern int pci_hp_deregister(struct hotplug_slot *slot);
 extern int __must_check pci_hp_change_slot_info	(struct hotplug_slot *slot,
 						 struct hotplug_slot_info *info);
-extern struct kset pci_hotplug_slots_subsys;
 
 /* PCI Setting Record (Type 0) */
 struct hpp_type0 {
-- 
1.5.3.1.1.g1e61

