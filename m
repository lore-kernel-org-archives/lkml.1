Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbYC1Plv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbYC1Plv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 11:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbYC1Plm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 11:41:42 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:12090 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbYC1Pll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 11:41:41 -0400
Date: Fri, 28 Mar 2008 09:41:39 -0600
From: Alex Chiang <achiang@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, Greg KH <gregkh@suse.de>,
       Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/4] Introduce pci_slot
Message-ID: <20080328154139.GE17862@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Greg KH <gregkh@suse.de>, Gary Hade <garyhade@us.ibm.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
References: <20080325041314.GA29666@ldl.fc.hp.com> <20080325041700.GD29666@ldl.fc.hp.com> <20080328033939.5ef5ab7b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328033939.5ef5ab7b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

* Andrew Morton <akpm@linux-foundation.org>:
> On Mon, 24 Mar 2008 22:17:00 -0600 Alex Chiang <achiang@hp.com> wrote:
> 
> > Currently, /sys/bus/pci/slots/ only exposes hotplug attributes
> > when a hotplug driver is loaded, but PCI slots have attributes
> > such as address, speed, width, etc. that are not related to
> > hotplug at all.
> > 
> > Introduce pci_slot as the primary data structure and kobject
> > model. Hotplug attributes described in hotplug_slot become a
> > secondary structure associated with the pci_slot.
> > 
> > This patch only creates the infrastructure that allows the
> > separation of PCI slot attributes and hotplug attributes.
> > In this patch, the PCI hotplug core remains the only user of this
> > infrastructure, and thus, /sys/bus/pci/slots/ will still only
> > become populated when a hotplug driver is loaded.
> > 
> 
> I've so far fixed four compile errors in this patch.  It's your turn:

Sorry for the sloppiness. :(

In the future, do you have a better suggestion on how to do large
sweeps on code for hardware that one might not own? Is there an
easier way other than setting up a cross-compiler environment?

Thanks.

/ac

Subject: [PATCH] remove rpaphp 'address_read_file'
From: Alex Chiang <achiang@hp.com>

Physical pci_slot removed ->get_address methods from individual
PCI hotplug drivers, but overlooked rpaphp, causing build errors.

Remove rpaphp's 'address_read_file' as well.

Signed-off-by: Alex Chiang <achiang@hp.com>
---
 drivers/pci/hotplug/rpaphp_slot.c |   37 -------------------------------------
 1 files changed, 0 insertions(+), 37 deletions(-)

diff --git a/drivers/pci/hotplug/rpaphp_slot.c b/drivers/pci/hotplug/rpaphp_slot.c
index 8e5fff0..0d4cfc7 100644
--- a/drivers/pci/hotplug/rpaphp_slot.c
+++ b/drivers/pci/hotplug/rpaphp_slot.c
@@ -33,33 +33,6 @@
 #include <asm/rtas.h>
 #include "rpaphp.h"
 
-static ssize_t address_read_file (struct hotplug_slot *php_slot, char *buf)
-{
-	int retval;
-	struct slot *slot = (struct slot *)php_slot->private;
-	struct pci_bus *bus;
-
-	if (!slot)
-		return -ENOENT;
-
-	bus = slot->bus;
-	if (!bus)
-		return -ENOENT;
-
-	if (bus->self)
-		retval = sprintf(buf, pci_name(bus->self));
-	else
-		retval = sprintf(buf, "%04x:%02x:00.0",
-		        pci_domain_nr(bus), bus->number);
-
-	return retval;
-}
-
-static struct hotplug_slot_attribute php_attr_address = {
-	.attr = {.name = "address", .mode = S_IFREG | S_IRUGO},
-	.show = address_read_file,
-};
-
 /* free up the memory used by a slot */
 static void rpaphp_release_slot(struct hotplug_slot *hotplug_slot)
 {
@@ -135,9 +108,6 @@ int rpaphp_deregister_slot(struct slot *slot)
 
 	list_del(&slot->rpaphp_slot_list);
 	
-	/* remove "address" file */
-	sysfs_remove_file(&php_slot->kobj, &php_attr_address.attr);
-
 	retval = pci_hp_deregister(php_slot);
 	if (retval)
 		err("Problem unregistering a slot %s\n", slot->name);
@@ -169,13 +139,6 @@ int rpaphp_register_slot(struct slot *slot)
 		return retval;
 	}
 
-	/* create "address" file */
-	retval = sysfs_create_file(&php_slot->kobj, &php_attr_address.attr);
-	if (retval) {
-		err("sysfs_create_file failed with error %d\n", retval);
-		goto sysfs_fail;
-	}
-
 	/* add slot to our internal list */
 	list_add(&slot->rpaphp_slot_list, &rpaphp_slot_head);
 	info("Slot [%s] registered\n", slot->name);
-- 
1.5.3.1.g1e61

