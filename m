Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbYCDXd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbYCDXd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934005AbYCDXaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:30:35 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:15330 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbYCDXa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:30:27 -0500
Date: Tue, 4 Mar 2008 16:30:26 -0700
From: Alex Chiang <achiang@hp.com>
To: gregkh@suse.de, Gary Hade <garyhade@us.ibm.com>,
       kaneshige.kenji@jp.fujitsu.com, warthog19@eaglescrag.net
Cc: Matthew Wilcox <matthew@wil.cx>, kristen.c.accardi@intel.com,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: [PATCH 3/4, v8] Introduce pci_slot
Message-ID: <20080304233026.GG3694@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, gregkh@suse.de,
	Gary Hade <garyhade@us.ibm.com>, kaneshige.kenji@jp.fujitsu.com,
	warthog19@eaglescrag.net, Matthew Wilcox <matthew@wil.cx>,
	kristen.c.accardi@intel.com, rick.jones2@hp.com,
	linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
	linux-acpi@vger.kernel.org
References: <20080229002341.GA21420@ldl.fc.hp.com> <20080229002855.GD21420@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229002855.GD21420@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, /sys/bus/pci/slots/ only exposes hotplug attributes
when a hotplug driver is loaded, but PCI slots have attributes
such as address, speed, width, etc. that are not related to
hotplug at all.

Introduce pci_slot as the primary data structure and kobject
model. Hotplug attributes described in hotplug_slot become a
secondary structure associated with the pci_slot.

This patch only creates the infrastructure that allows the
separation of PCI slot attributes and hotplug attributes.
In this patch, the PCI hotplug core remains the only user of this
infrastructure, and thus, /sys/bus/pci/slots/ will still only
become populated when a hotplug driver is loaded.

A later patch in this series will add a second user of this new
infrastructure and demonstrate splitting the task of exposing
pci_slot attributes from hotplug_slot attributes.

  - Make pci_slot the primary sysfs entity. hotplug_slot becomes a
    subsidiary structure.
    o pci_create_slot() creates and registers a slot with the PCI core
    o pci_slot_add_hotplug() gives it hotplug capability

  - Change the prototype of pci_hp_register() to take the bus and
    slot number (on parent bus) as parameters.

  - Remove all the ->get_address methods since this functionality is
    now handled by pci_slot directly.

v7 -> v8:
	Incorporate v7 code review comments (no externs in C files)

v6 -> v7:
	Refresh to new kobject model.

v5 -> v6:
	Add debugging information.

v4 -> v5:
	Add refcounting for pci_slot objects.

	Return -EBUSY if an hp driver attempts to register a slot
	that is already registered to another driver. Do not consider
	that to be an error condition in acpiphp and pciehp.

v3 -> v4:
	Fixed bug with pciehp and rpaphp registering slots

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
 drivers/pci/hotplug/acpiphp_core.c      |   25 +---
 drivers/pci/hotplug/acpiphp_glue.c      |   23 +--
 drivers/pci/hotplug/acpiphp_ibm.c       |    6 +-
 drivers/pci/hotplug/cpci_hotplug_core.c |    2 +-
 drivers/pci/hotplug/cpqphp_core.c       |    4 +-
 drivers/pci/hotplug/fakephp.c           |    2 +-
 drivers/pci/hotplug/ibmphp_ebda.c       |    3 +-
 drivers/pci/hotplug/pci_hotplug_core.c  |  244 +++++++++++--------------------
 drivers/pci/hotplug/pciehp_core.c       |   31 ++---
 drivers/pci/hotplug/rpadlpar_sysfs.c    |    5 +-
 drivers/pci/hotplug/rpaphp_slot.c       |    3 +-
 drivers/pci/hotplug/sgi_hotplug.c       |    2 +-
 drivers/pci/hotplug/shpchp_core.c       |   17 +--
 drivers/pci/pci.h                       |   13 ++
 drivers/pci/slot.c                      |  224 ++++++++++++++++++++++++++++
 include/linux/pci.h                     |   17 ++
 include/linux/pci_hotplug.h             |   12 +-
 19 files changed, 388 insertions(+), 248 deletions(-)
 create mode 100644 drivers/pci/slot.c

diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 4d1ce2e..7d63f8c 100644
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
index 7a29164..eecf7cb 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -215,7 +215,6 @@ extern u8 acpiphp_get_power_status (struct acpiphp_slot *slot);
 extern u8 acpiphp_get_attention_status (struct acpiphp_slot *slot);
 extern u8 acpiphp_get_latch_status (struct acpiphp_slot *slot);
 extern u8 acpiphp_get_adapter_status (struct acpiphp_slot *slot);
-extern u32 acpiphp_get_address (struct acpiphp_slot *slot);
 
 /* variables */
 extern int acpiphp_debug;
diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
index 9279d5b..57319e6 100644
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
 
 
@@ -274,23 +272,6 @@ static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 *value)
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
@@ -357,7 +338,11 @@ int acpiphp_register_hotplug_slot(struct acpiphp_slot *acpiphp_slot)
 	acpiphp_slot->slot = slot;
 	snprintf(slot->name, sizeof(slot->name), "%u", slot->acpi_slot->sun);
 
-	retval = pci_hp_register(slot->hotplug_slot);
+	retval = pci_hp_register(slot->hotplug_slot,
+					acpiphp_slot->bridge->pci_bus,
+					acpiphp_slot->device);
+	if (retval == -EBUSY)
+		goto error_hpslot;
 	if (retval) {
 		err("pci_hp_register failed with error %d\n", retval);
 		goto error_hpslot;
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index cf22f9e..f84c4bd 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -258,7 +258,12 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 				bridge->pci_bus->number, slot->device);
 		retval = acpiphp_register_hotplug_slot(slot);
 		if (retval) {
-			warn("acpiphp_register_hotplug_slot failed(err code = 0x%x)\n", retval);
+			if (retval == -EBUSY)
+				warn("Slot %d already registered by another "
+					"hotplug driver\n", slot->sun);
+			else
+				warn("acpiphp_register_hotplug_slot failed "
+					"(err code = 0x%x)\n", retval);
 			goto err_exit;
 		}
 	}
@@ -1867,19 +1872,3 @@ u8 acpiphp_get_adapter_status(struct acpiphp_slot *slot)
 
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
index b0a22b9..34a708f 100644
--- a/drivers/pci/hotplug/acpiphp_ibm.c
+++ b/drivers/pci/hotplug/acpiphp_ibm.c
@@ -33,8 +33,10 @@
 #include <linux/kobject.h>
 #include <asm/uaccess.h>
 #include <linux/moduleparam.h>
+#include <linux/pci.h>
 
 #include "acpiphp.h"
+#include "../pci.h"
 
 #define DRIVER_VERSION	"1.0.1"
 #define DRIVER_AUTHOR	"Irene Zubarev <zubarev@us.ibm.com>, Vernon Mauery <vernux@us.ibm.com>"
@@ -430,7 +432,7 @@ static int __init ibm_acpiphp_init(void)
 	int retval = 0;
 	acpi_status status;
 	struct acpi_device *device;
-	struct kobject *sysdir = &pci_hotplug_slots_kset->kobj;
+	struct kobject *sysdir = &pci_slots_kset->kobj;
 
 	dbg("%s\n", __FUNCTION__);
 
@@ -477,7 +479,7 @@ init_return:
 static void __exit ibm_acpiphp_exit(void)
 {
 	acpi_status status;
-	struct kobject *sysdir = &pci_hotplug_slots_kset->kobj;
+	struct kobject *sysdir = &pci_slots_kset->kobj;
 
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
index 7417887..2e0392e 100644
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
index 6c14b4d..2d84755 100644
--- a/drivers/pci/hotplug/fakephp.c
+++ b/drivers/pci/hotplug/fakephp.c
@@ -127,7 +127,7 @@ static int add_slot(struct pci_dev *dev)
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
index dd59a05..21bbb5e 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -40,6 +40,7 @@
 #include <linux/pci.h>
 #include <linux/pci_hotplug.h>
 #include <asm/uaccess.h>
+#include "../pci.h"
 
 #define MY_NAME	"pci_hotplug"
 
@@ -61,41 +62,6 @@ static int debug;
 
 static LIST_HEAD(pci_hotplug_slot_list);
 
-struct kset *pci_hotplug_slots_kset;
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
 /* these strings match up with the values in pci_bus_speed */
 static char *pci_bus_speed_strings[] = {
 	"33 MHz PCI",		/* 0x00 */
@@ -149,16 +115,15 @@ GET_STATUS(power_status, u8)
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
@@ -166,9 +131,10 @@ exit:
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
@@ -204,29 +170,30 @@ exit:
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
@@ -235,13 +202,13 @@ static ssize_t attention_write_file (struct hotplug_slot *slot, const char *buf,
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
@@ -249,18 +216,18 @@ exit:
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
@@ -269,17 +236,17 @@ exit:
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
@@ -288,42 +255,20 @@ exit:
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
 
@@ -338,18 +283,18 @@ exit:
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
 
@@ -364,14 +309,15 @@ exit:
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
@@ -394,13 +340,14 @@ exit:
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
@@ -410,8 +357,9 @@ static int has_power_file (struct hotplug_slot *slot)
 	return -ENOENT;
 }
 
-static int has_attention_file (struct hotplug_slot *slot)
+static int has_attention_file(struct pci_slot *pci_slot)
 {
+	struct hotplug_slot *slot = pci_slot->hotplug;
 	if ((!slot) || (!slot->ops))
 		return -ENODEV;
 	if ((slot->ops->set_attention_status) ||
@@ -420,8 +368,9 @@ static int has_attention_file (struct hotplug_slot *slot)
 	return -ENOENT;
 }
 
-static int has_latch_file (struct hotplug_slot *slot)
+static int has_latch_file(struct pci_slot *pci_slot)
 {
+	struct hotplug_slot *slot = pci_slot->hotplug;
 	if ((!slot) || (!slot->ops))
 		return -ENODEV;
 	if (slot->ops->get_latch_status)
@@ -429,8 +378,9 @@ static int has_latch_file (struct hotplug_slot *slot)
 	return -ENOENT;
 }
 
-static int has_adapter_file (struct hotplug_slot *slot)
+static int has_adapter_file(struct pci_slot *pci_slot)
 {
+	struct hotplug_slot *slot = pci_slot->hotplug;
 	if ((!slot) || (!slot->ops))
 		return -ENODEV;
 	if (slot->ops->get_adapter_status)
@@ -438,17 +388,9 @@ static int has_adapter_file (struct hotplug_slot *slot)
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
@@ -456,8 +398,9 @@ static int has_max_bus_speed_file (struct hotplug_slot *slot)
 	return -ENOENT;
 }
 
-static int has_cur_bus_speed_file (struct hotplug_slot *slot)
+static int has_cur_bus_speed_file(struct pci_slot *pci_slot)
 {
+	struct hotplug_slot *slot = pci_slot->hotplug;
 	if ((!slot) || (!slot->ops))
 		return -ENODEV;
 	if (slot->ops->get_cur_bus_speed)
@@ -465,8 +408,9 @@ static int has_cur_bus_speed_file (struct hotplug_slot *slot)
 	return -ENOENT;
 }
 
-static int has_test_file (struct hotplug_slot *slot)
+static int has_test_file(struct pci_slot *pci_slot)
 {
+	struct hotplug_slot *slot = pci_slot->hotplug;
 	if ((!slot) || (!slot->ops))
 		return -ENODEV;
 	if (slot->ops->hardware_test)
@@ -474,7 +418,7 @@ static int has_test_file (struct hotplug_slot *slot)
 	return -ENOENT;
 }
 
-static int fs_add_slot (struct hotplug_slot *slot)
+static int fs_add_slot(struct pci_slot *slot)
 {
 	int retval = 0;
 
@@ -505,13 +449,6 @@ static int fs_add_slot (struct hotplug_slot *slot)
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
@@ -544,10 +481,6 @@ exit_cur_speed:
 		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_max_bus_speed.attr);
 
 exit_max_speed:
-	if (has_address_file(slot) == 0)
-		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_address.attr);
-
-exit_address:
 	if (has_adapter_file(slot) == 0)
 		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_presence.attr);
 
@@ -567,7 +500,7 @@ exit:
 	return retval;
 }
 
-static void fs_remove_slot (struct hotplug_slot *slot)
+static void fs_remove_slot(struct pci_slot *slot)
 {
 	if (has_power_file(slot) == 0)
 		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_power.attr);
@@ -581,9 +514,6 @@ static void fs_remove_slot (struct hotplug_slot *slot)
 	if (has_adapter_file(slot) == 0)
 		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_presence.attr);
 
-	if (has_address_file(slot) == 0)
-		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_address.attr);
-
 	if (has_max_bus_speed_file(slot) == 0)
 		sysfs_remove_file(&slot->kobj, &hotplug_slot_attr_max_bus_speed.attr);
 
@@ -607,6 +537,12 @@ static struct hotplug_slot *get_slot_from_name (const char *name)
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
@@ -616,9 +552,10 @@ static struct hotplug_slot *get_slot_from_name (const char *name)
  *
  * Returns 0 if successful, anything else for an error.
  */
-int pci_hp_register (struct hotplug_slot *slot)
+int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr)
 {
 	int result;
+	struct pci_slot *pci_slot;
 
 	if (slot == NULL)
 		return -ENODEV;
@@ -630,20 +567,24 @@ int pci_hp_register (struct hotplug_slot *slot)
 		return -EINVAL;
 	}
 
-	/* this can fail if we have already registered a slot with the same name */
-	slot->kobj.kset = pci_hotplug_slots_kset;
-	result = kobject_init_and_add(&slot->kobj, &hotplug_slot_ktype, NULL,
-				      "%s", slot->name);
+	pci_slot = pci_create_slot(bus, slot_nr, slot->name);
+	if (IS_ERR(pci_slot))
+		return PTR_ERR(pci_slot);
+
+	result = pci_slot_add_hotplug(bus, slot_nr, hotplug_release);
 	if (result) {
-		err("Unable to register kobject '%s'", slot->name);
-		return -EINVAL;
+		pci_destroy_slot(pci_slot);
+		return result;
 	}
 
-	list_add (&slot->slot_list, &pci_hotplug_slot_list);
+	slot->pci_slot = pci_slot;
+	pci_slot->hotplug = slot;
+
+	list_add(&slot->slot_list, &pci_hotplug_slot_list);
 
-	result = fs_add_slot (slot);
-	kobject_uevent(&slot->kobj, KOBJ_ADD);
-	dbg ("Added slot %s to the list\n", slot->name);
+	result = fs_add_slot(pci_slot);
+	kobject_uevent(&pci_slot->kobj, KOBJ_ADD);
+	dbg("Added slot %s to the list\n", slot->name);
 	return result;
 }
 
@@ -656,22 +597,24 @@ int pci_hp_register (struct hotplug_slot *slot)
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
-	kobject_put(&slot->kobj);
+	list_del(&hotplug->slot_list);
+
+	slot = hotplug->pci_slot;
+	fs_remove_slot(slot);
+	pci_destroy_slot(slot);
+	dbg("Removed slot %s from the list\n", hotplug->name);
 	return 0;
 }
 
@@ -685,13 +628,15 @@ int pci_hp_deregister (struct hotplug_slot *slot)
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
@@ -699,36 +644,22 @@ int __must_check pci_hp_change_slot_info(struct hotplug_slot *slot,
 static int __init pci_hotplug_init (void)
 {
 	int result;
-	struct kset *pci_bus_kset;
 
-	pci_bus_kset = bus_get_kset(&pci_bus_type);
-
-	pci_hotplug_slots_kset = kset_create_and_add("slots", NULL,
-						     &pci_bus_kset->kobj);
-	if (!pci_hotplug_slots_kset) {
-		result = -ENOMEM;
-		err("Register subsys error\n");
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
 
-err_subsys:
-	kset_unregister(pci_hotplug_slots_kset);
-exit:
+err_cpci:
 	return result;
 }
 
 static void __exit pci_hotplug_exit (void)
 {
 	cpci_hotplug_exit();
-	kset_unregister(pci_hotplug_slots_kset);
 }
 
 module_init(pci_hotplug_init);
@@ -740,7 +671,6 @@ MODULE_LICENSE("GPL");
 module_param(debug, bool, 0644);
 MODULE_PARM_DESC(debug, "Debugging mode enabled or not");
 
-EXPORT_SYMBOL_GPL(pci_hotplug_slots_kset);
 EXPORT_SYMBOL_GPL(pci_hp_register);
 EXPORT_SYMBOL_GPL(pci_hp_deregister);
 EXPORT_SYMBOL_GPL(pci_hp_change_slot_info);
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 7f4836b..ab45b69 100644
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
@@ -245,14 +243,18 @@ static int init_slots(struct controller *ctrl)
 		dbg("Registering bus=%x dev=%x hp_slot=%x sun=%x "
 		    "slot_device_offset=%x\n", slot->bus, slot->device,
 		    slot->hp_slot, slot->number, ctrl->slot_device_offset);
-		retval = pci_hp_register(hotplug_slot);
+		retval = pci_hp_register(hotplug_slot,
+					 ctrl->pci_dev->subordinate,
+					 slot->device);
+		if (retval == -EBUSY)
+			goto error_info;
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
@@ -285,7 +287,7 @@ static void cleanup_slots(struct controller *ctrl)
 		slot = list_entry(tmp, struct slot, slot_list);
 		list_del(&slot->slot_list);
 		if (EMI(ctrl->ctrlcap))
-			sysfs_remove_file(&slot->hotplug_slot->kobj,
+			sysfs_remove_file(&slot->hotplug_slot->pci_slot->kobj,
 				&hotplug_slot_attr_lock.attr);
 		cancel_delayed_work(&slot->work);
 		flush_scheduled_work();
@@ -387,18 +389,6 @@ static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 *value)
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
@@ -460,7 +450,12 @@ static int pciehp_probe(struct pcie_device *dev, const struct pcie_port_service_
 	/* Setup the slot information structures */
 	rc = init_slots(ctrl);
 	if (rc) {
-		err("%s: slot initialization failed\n", PCIE_MODULE_NAME);
+		if (rc == -EBUSY)
+			warn("%s: slot already registered by another "
+				"hotplug driver\n", PCIE_MODULE_NAME);
+		else
+			err("%s: slot initialization failed\n",
+				PCIE_MODULE_NAME);
 		goto err_out_release_ctlr;
 	}
 
diff --git a/drivers/pci/hotplug/rpadlpar_sysfs.c b/drivers/pci/hotplug/rpadlpar_sysfs.c
index e32148a..399b196 100644
--- a/drivers/pci/hotplug/rpadlpar_sysfs.c
+++ b/drivers/pci/hotplug/rpadlpar_sysfs.c
@@ -14,8 +14,10 @@
  */
 #include <linux/kobject.h>
 #include <linux/string.h>
+#include <linux/pci.h>
 #include <linux/pci_hotplug.h>
 #include "rpadlpar.h"
+#include "../pcih."
 
 #define DLPAR_KOBJ_NAME       "control"
 #define ADD_SLOT_ATTR_NAME    "add_slot"
@@ -23,7 +25,6 @@
 
 #define MAX_DRC_NAME_LEN 64
 
-
 static ssize_t add_slot_store(struct kobject *kobj, struct kobj_attribute *attr,
 			      const char *buf, size_t nbytes)
 {
@@ -108,7 +109,7 @@ int dlpar_sysfs_init(void)
 	int error;
 
 	dlpar_kobj = kobject_create_and_add(DLPAR_KOBJ_NAME,
-					    &pci_hotplug_slots_kset->kobj);
+					    &pci_slots_kset->kobj);
 	if (!dlpar_kobj)
 		return -EINVAL;
 
diff --git a/drivers/pci/hotplug/rpaphp_slot.c b/drivers/pci/hotplug/rpaphp_slot.c
index 8ad3deb..8e5fff0 100644
--- a/drivers/pci/hotplug/rpaphp_slot.c
+++ b/drivers/pci/hotplug/rpaphp_slot.c
@@ -162,7 +162,8 @@ int rpaphp_register_slot(struct slot *slot)
 		return -EAGAIN;
 	}	
 
-	retval = pci_hp_register(php_slot);
+	retval = pci_hp_register(php_slot, slot->bus,
+				 PCI_SLOT(PCI_DN(slot->dn->child)->devfn));
 	if (retval) {
 		err("pci_hp_register failed with error %d\n", retval);
 		return retval;
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
index eabeb1f..61bb743 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -87,3 +87,16 @@ pci_match_one_device(const struct pci_device_id *id, const struct pci_dev *dev)
 }
 
 struct pci_dev *pci_find_upstream_pcie_bridge(struct pci_dev *pdev);
+
+/* PCI slot sysfs helper code */
+#define to_pci_slot(s) container_of(s, struct pci_slot, kobj)
+
+extern struct kset *pci_slots_kset;
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
index 0000000..5b71b9f
--- /dev/null
+++ b/drivers/pci/slot.c
@@ -0,0 +1,224 @@
+/*
+ * drivers/pci/slot.c
+ * Copyright (C) 2006 Matthew Wilcox <matthew@wil.cx>
+ * Copyright (C) 2006,2007 Hewlett-Packard Development Company, L.P.
+ * Copyright (C) 2007 Alex Chiang <achiang@hp.com>
+ */
+
+#include <linux/kobject.h>
+#include <linux/pci.h>
+#include "pci.h"
+
+static int pci_slot_debug;
+#define MY_NAME "slot"
+#define dbg(format, arg...)					\
+	do {							\
+		if (pci_slot_debug)				\
+			printk(KERN_DEBUG "%s: " format,	\
+				MY_NAME , ## arg);		\
+	} while (0)
+
+struct kset *pci_slots_kset;
+EXPORT_SYMBOL_GPL(pci_slots_kset);
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
+static void pci_slot_release(struct kobject *kobj)
+{
+	struct pci_slot **pprev;
+	struct pci_slot *slot = to_pci_slot(kobj);
+
+	dbg("%s: releasing pci_slot on %x:%d\n", __FUNCTION__,
+		slot->bus->number, slot->number);
+
+	for (pprev = &slot->bus->slot; *pprev; pprev = &(*pprev)->next) {
+		if (*pprev == slot) {
+			*pprev = slot->next;
+			break;
+		}
+	}
+
+	if (slot->release)
+		slot->release(slot);
+
+	remove_sysfs_files(slot);
+	kfree(slot);
+}
+
+static struct kobj_type pci_slot_ktype = {
+	.sysfs_ops = &pci_slot_sysfs_ops,
+	.release = &pci_slot_release,
+};
+
+int pci_slot_add_hotplug(struct pci_bus *parent, int slot_nr,
+			 void (*release)(struct pci_slot *))
+{
+	struct pci_slot *slot;
+	int retval, found;
+
+	retval = found = 0;
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
+		dbg("%s: slot not found\n", __FUNCTION__);
+		retval = -EEXIST;
+		goto out;
+	}
+
+	if (slot->release) {
+		dbg("%s: already claimed\n", __FUNCTION__);
+		retval = -EBUSY;
+		goto out;
+	}
+
+	dbg("%s: adding release function to %x:%d\n",
+		__FUNCTION__, parent->number, slot_nr);
+	slot->release = release;
+ out:
+	up_write(&pci_bus_sem);
+	return retval;
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
+	/* If we've already created this slot, bump refcount and return. */
+	for (slot = parent->slot; slot; slot = slot->next) {
+		if (slot->number == slot_nr) {
+			kobject_get(&slot->kobj);
+			dbg("%s: bumped refcount to %d on %x:%d\n",
+				__FUNCTION__, slot->kobj.kref.refcount,
+				parent->number, slot_nr);
+			goto out;
+		}
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
+	slot->kobj.kset = pci_slots_kset;
+	err = kobject_init_and_add(&slot->kobj, &pci_slot_ktype, NULL,
+				   "%s", name);
+	if (err) {
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
+	dbg("%s: created pci_slot on %x:%d\n",
+		__FUNCTION__, parent->number, slot_nr);
+
+ out:
+	up_write(&pci_bus_sem);
+	return slot;
+
+ unregister:
+	kobject_put(&slot->kobj);
+ err:
+	kfree(slot);
+	slot = ERR_PTR(err);
+	goto out;
+}
+EXPORT_SYMBOL_GPL(pci_create_slot);
+
+int pci_destroy_slot(struct pci_slot *slot)
+{
+	kobject_put(&slot->kobj);
+
+	dbg("%s: decreased refcount to %d on %x:%d\n", __FUNCTION__,
+		slot->kobj.kref.refcount, slot->bus->number, slot->number);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_destroy_slot);
+
+static int pci_slot_init(void)
+{
+	int result = 0;
+	struct kset *pci_bus_kset;
+
+	pci_bus_kset = bus_get_kset(&pci_bus_type);
+
+	pci_slots_kset = kset_create_and_add("slots", NULL,
+						&pci_bus_kset->kobj);
+	if (!pci_slots_kset) {
+		result = -ENOMEM;
+		printk(KERN_ERR "PCI: Slot initialisation failure (%d)",
+			result);
+	}
+	return result;
+}
+
+subsys_initcall(pci_slot_init);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 87195b6..2b3ada0 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -128,6 +128,16 @@ struct pci_cap_saved_state {
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
@@ -139,6 +149,7 @@ struct pci_dev {
 
 	void		*sysdata;	/* hook for sys-specific extension */
 	struct proc_dir_entry *procent;	/* device entry in /proc/bus/pci */
+	struct pci_slot	*slot;		/* Physical slot this device is in */
 
 	unsigned int	devfn;		/* encoded device & function index */
 	unsigned short	vendor;
@@ -258,6 +269,7 @@ struct pci_bus {
 	struct list_head children;	/* list of child buses */
 	struct list_head devices;	/* list of devices on this bus */
 	struct pci_dev	*self;		/* bridge device as seen by parent */
+	struct pci_slot	*slot;		/* First physical slot on this bus */
 	struct resource	*resource[PCI_BUS_NUM_RESOURCES];
 					/* address space routed to this bus */
 
@@ -470,6 +482,11 @@ struct pci_bus *pci_create_bus(struct device *parent, int bus,
 			       struct pci_ops *ops, void *sysdata);
 struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev,
 				int busnr);
+struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
+				 const char *name);
+int pci_slot_add_hotplug(struct pci_bus *parent, int slot_nr,
+			 void (*release)(struct pci_slot *));
+int pci_destroy_slot(struct pci_slot *slot);
 int pci_scan_slot(struct pci_bus *bus, int devfn);
 struct pci_dev *pci_scan_single_device(struct pci_bus *bus, int devfn);
 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus);
diff --git a/include/linux/pci_hotplug.h b/include/linux/pci_hotplug.h
index 8f67e8f..bb36c59 100644
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
-extern struct kset *pci_hotplug_slots_kset;
 
 /* PCI Setting Record (Type 0) */
 struct hpp_type0 {
-- 
1.5.3.1.g1e61

