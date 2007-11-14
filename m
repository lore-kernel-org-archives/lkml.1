Return-Path: <linux-kernel-owner+w=401wt.eu-S1764490AbXKNUbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764490AbXKNUbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 15:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760163AbXKNUbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 15:31:37 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53891 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651AbXKNUbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 15:31:35 -0500
Date: Wed, 14 Nov 2007 14:31:26 -0600
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, strosake@us.ibm.com,
       Alex Chiang <achiang@hp.com>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, lenb@kernel.org, rick.jones2@hp.com,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH v2] pci hotplug: fix rpaphp directory naming
Message-ID: <20071114203126.GC18745@austin.ibm.com>
References: <20071114003455.GD8509@austin.ibm.com> <20071114032607.GA22438@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114032607.GA22438@kroah.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix presentation of the slot number in the /sys/bus/pci/slots
directory to match that used in the majority of other drivers.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>

------
On Tue, Nov 13, 2007 at 07:26:07PM -0800, Greg KH wrote:
> We need a signed-off-by: to be able to apply this...

Whoops. See above. Same patch as list time, no changes.

On Tue, Nov 13, 2007 at 02:58:30PM -0700, Matthew Wilcox wrote:
> On Tue, Nov 13, 2007 at 03:41:21PM -0600, Linas Vepstas wrote:
> > /sys/bus/pci/slots
> > /sys/bus/pci/slots/control
> > /sys/bus/pci/slots/control/remove_slot
> > /sys/bus/pci/slots/control/add_slot
> > /sys/bus/pci/slots/0001:00:02.0
> > /sys/bus/pci/slots/0001:00:02.0/phy_location
>
> Ugh.  Almost two years ago, paulus promised me he was going to fix the
> slot name for rpaphp.  Guess he didn't.

You have to ask the right person. :-) I've been defacto mainaining
the rpaphp code for unpteen years now. On the other hand, I am also
much, much better at promising than delivering.

> This is one of the hateful things about the current design -- hotplug
> drivers do too much.  Instead of being just the interface between the
> Linux PCI code and the hardware, they create sysfs directories, add
> files,
> and generally have far too much freedom.

I chopped out several hundred LOC from rpaphp a year ago,
and hopefuly that might make furthre simplification easier 
someday.

> We have four different schemes currently for naming in slots/,
> 1. slot number.  Used by cpqphp, ibmphp, acpiphp, pciehp, shpc.
> 2. domain:bus:dev:fn.  Used by fakephp.
> 3a. domain:bus:dev.  Used by rpaphp and sgihp.
> 3b. Except that rpaphp uses phy_location to present the information
> that
> should be in the name and sgihp uses path.
>
> ... I've forgotten what cpci uses.  And yenta doesn't use it.
>
> How is anyone supposed to write sane managability tools in the
> presence
> of such anarchy?
>
> > ~ # cat /sys/bus/pci/slots/0000:00:02.2/phy_location
> > U787A.001.DNZ00Z5-P1-C2
>
> Right.  This should look like:
>
> # cat /sys/bus/pci/slots/U787A.001.DNZ00Z5-P1-C2/address
> 0000:00:02

This patch implements exactly what you describe. Boot tested.
I assume you really mean it -- if so, then please review and
ack the patch !?

I have absolutely no clue if this breaks any existing IBM tools.
I'm pretty sure it doesn't ... but attention Mike Strosaker! does it?


 drivers/pci/hotplug/rpaphp.h      |    1 
 drivers/pci/hotplug/rpaphp_pci.c  |   14 -----------
 drivers/pci/hotplug/rpaphp_slot.c |   47 +++++++++++++++++++-------------------
 3 files changed, 24 insertions(+), 38 deletions(-)

Index: linux-2.6.23-rc8-mm1/drivers/pci/hotplug/rpaphp_pci.c
===================================================================
--- linux-2.6.23-rc8-mm1.orig/drivers/pci/hotplug/rpaphp_pci.c	2007-07-08 18:32:17.000000000 -0500
+++ linux-2.6.23-rc8-mm1/drivers/pci/hotplug/rpaphp_pci.c	2007-11-13 17:52:10.000000000 -0600
@@ -64,19 +64,6 @@ int rpaphp_get_sensor_state(struct slot 
 	return rc;
 }
 
-static void set_slot_name(struct slot *slot)
-{
-	struct pci_bus *bus = slot->bus;
-	struct pci_dev *bridge;
-
-	bridge = bus->self;
-	if (bridge)
-		strcpy(slot->name, pci_name(bridge));
-	else
-		sprintf(slot->name, "%04x:%02x:00.0", pci_domain_nr(bus),
-			bus->number);
-}
-
 /**
  * rpaphp_enable_slot - record slot state, config pci device
  *
@@ -114,7 +101,6 @@ int rpaphp_enable_slot(struct slot *slot
 	info->adapter_status = EMPTY;
 	slot->bus = bus;
 	slot->pci_devs = &bus->devices;
-	set_slot_name(slot);
 
 	/* if there's an adapter in the slot, go add the pci devices */
 	if (state == PRESENT) {
Index: linux-2.6.23-rc8-mm1/drivers/pci/hotplug/rpaphp_slot.c
===================================================================
--- linux-2.6.23-rc8-mm1.orig/drivers/pci/hotplug/rpaphp_slot.c	2007-07-08 18:32:17.000000000 -0500
+++ linux-2.6.23-rc8-mm1/drivers/pci/hotplug/rpaphp_slot.c	2007-11-13 18:05:13.000000000 -0600
@@ -33,23 +33,31 @@
 #include <asm/rtas.h>
 #include "rpaphp.h"
 
-static ssize_t location_read_file (struct hotplug_slot *php_slot, char *buf)
+static ssize_t address_read_file (struct hotplug_slot *php_slot, char *buf)
 {
-	char *value;
-	int retval = -ENOENT;
+	int retval;
 	struct slot *slot = (struct slot *)php_slot->private;
+	struct pci_bus *bus;
 
 	if (!slot)
-		return retval;
+		return -ENOENT;
 
-	value = slot->location;
-	retval = sprintf (buf, "%s\n", value);
+	bus = slot->bus;
+	if (!bus)
+		return -ENOENT;
+
+	if (bus->self)
+		retval = sprintf(buf, pci_name(bus->self));
+	else
+		retval = sprintf(buf, "%04x:%02x:00.0", 
+		        pci_domain_nr(bus), bus->number);
+	
 	return retval;
 }
 
-static struct hotplug_slot_attribute php_attr_location = {
-	.attr = {.name = "phy_location", .mode = S_IFREG | S_IRUGO},
-	.show = location_read_file,
+static struct hotplug_slot_attribute php_attr_address = {
+	.attr = {.name = "address", .mode = S_IFREG | S_IRUGO},
+	.show = address_read_file,
 };
 
 /* free up the memory used by a slot */
@@ -64,7 +72,6 @@ void dealloc_slot_struct(struct slot *sl
 	kfree(slot->hotplug_slot->info);
 	kfree(slot->hotplug_slot->name);
 	kfree(slot->hotplug_slot);
-	kfree(slot->location);
 	kfree(slot);
 }
 
@@ -83,16 +90,13 @@ struct slot *alloc_slot_struct(struct de
 					   GFP_KERNEL);
 	if (!slot->hotplug_slot->info)
 		goto error_hpslot;
-	slot->hotplug_slot->name = kmalloc(BUS_ID_SIZE + 1, GFP_KERNEL);
+	slot->hotplug_slot->name = kmalloc(strlen(drc_name) + 1, GFP_KERNEL);
 	if (!slot->hotplug_slot->name)
 		goto error_info;	
-	slot->location = kmalloc(strlen(drc_name) + 1, GFP_KERNEL);
-	if (!slot->location)
-		goto error_name;
 	slot->name = slot->hotplug_slot->name;
+	strcpy(slot->name, drc_name);
 	slot->dn = dn;
 	slot->index = drc_index;
-	strcpy(slot->location, drc_name);
 	slot->power_domain = power_domain;
 	slot->hotplug_slot->private = slot;
 	slot->hotplug_slot->ops = &rpaphp_hotplug_slot_ops;
@@ -100,8 +104,6 @@ struct slot *alloc_slot_struct(struct de
 	
 	return (slot);
 
-error_name:
-	kfree(slot->hotplug_slot->name);
 error_info:
 	kfree(slot->hotplug_slot->info);
 error_hpslot:
@@ -133,8 +135,8 @@ int rpaphp_deregister_slot(struct slot *
 
 	list_del(&slot->rpaphp_slot_list);
 	
-	/* remove "phy_location" file */
-	sysfs_remove_file(&php_slot->kobj, &php_attr_location.attr);
+	/* remove "address" file */
+	sysfs_remove_file(&php_slot->kobj, &php_attr_address.attr);
 
 	retval = pci_hp_deregister(php_slot);
 	if (retval)
@@ -166,8 +168,8 @@ int rpaphp_register_slot(struct slot *sl
 		return retval;
 	}
 
-	/* create "phy_location" file */
-	retval = sysfs_create_file(&php_slot->kobj, &php_attr_location.attr);
+	/* create "address" file */
+	retval = sysfs_create_file(&php_slot->kobj, &php_attr_address.attr);
 	if (retval) {
 		err("sysfs_create_file failed with error %d\n", retval);
 		goto sysfs_fail;
@@ -175,8 +177,7 @@ int rpaphp_register_slot(struct slot *sl
 
 	/* add slot to our internal list */
 	list_add(&slot->rpaphp_slot_list, &rpaphp_slot_head);
-	info("Slot [%s](PCI location=%s) registered\n", slot->name,
-			slot->location);
+	info("Slot [%s] registered\n", slot->name);
 	return 0;
 
 sysfs_fail:
Index: linux-2.6.23-rc8-mm1/drivers/pci/hotplug/rpaphp.h
===================================================================
--- linux-2.6.23-rc8-mm1.orig/drivers/pci/hotplug/rpaphp.h	2007-07-08 18:32:17.000000000 -0500
+++ linux-2.6.23-rc8-mm1/drivers/pci/hotplug/rpaphp.h	2007-11-13 18:06:16.000000000 -0600
@@ -74,7 +74,6 @@ struct slot {
 	u32 type;
 	u32 power_domain;
 	char *name;
-	char *location;
 	struct device_node *dn;
 	struct pci_bus *bus;
 	struct list_head *pci_devs;
