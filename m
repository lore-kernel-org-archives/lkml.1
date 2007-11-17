Return-Path: <linux-kernel-owner+w=401wt.eu-S1764256AbXKQSf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764256AbXKQSf3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 13:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758617AbXKQSfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 13:35:19 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:22046 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbXKQSfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 13:35:16 -0500
Date: Sat, 17 Nov 2007 11:35:14 -0700
From: Alex Chiang <achiang@hp.com>
To: Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, kaneshige.kenji@jp.fujitsu.com,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: [PATCH 1/4, v3] PCI Hotplug: Remove path attribute from sgi_hotplug
Message-ID: <20071117183514.GA26452@ldl.fc.hp.com>
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

Rename the slot to be the contents of the 'path' sysfs attribute, and
delete the attribute.  The mapping from pci address to slot name is
supposed to be done through the 'address' file, which will be provided
automatically later in this series of patches.

Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/pci/hotplug/sgi_hotplug.c |   32 +-------------------------------
 1 files changed, 1 insertions(+), 31 deletions(-)

diff --git a/drivers/pci/hotplug/sgi_hotplug.c b/drivers/pci/hotplug/sgi_hotplug.c
index ef07c36..693519e 100644
--- a/drivers/pci/hotplug/sgi_hotplug.c
+++ b/drivers/pci/hotplug/sgi_hotplug.c
@@ -91,21 +91,6 @@ static struct hotplug_slot_ops sn_hotplug_slot_ops = {
 
 static DEFINE_MUTEX(sn_hotplug_mutex);
 
-static ssize_t path_show (struct hotplug_slot *bss_hotplug_slot,
-	       		  char *buf)
-{
-	int retval = -ENOENT;
-	struct slot *slot = bss_hotplug_slot->private;
-
-	if (!slot)
-		return retval;
-
-	retval = sprintf (buf, "%s\n", slot->physical_path);
-	return retval;
-}
-
-static struct hotplug_slot_attribute sn_slot_path_attr = __ATTR_RO(path);
-
 static int sn_pci_slot_valid(struct pci_bus *pci_bus, int device)
 {
 	struct pcibus_info *pcibus_info;
@@ -173,18 +158,10 @@ static int sn_hp_slot_private_alloc(struct hotplug_slot *bss_hotplug_slot,
 		return -ENOMEM;
 	bss_hotplug_slot->private = slot;
 
-	bss_hotplug_slot->name = kmalloc(SN_SLOT_NAME_SIZE, GFP_KERNEL);
-	if (!bss_hotplug_slot->name) {
-		kfree(bss_hotplug_slot->private);
-		return -ENOMEM;
-	}
+	bss_hotplug_slot->name = slot->physical_path;
 
 	slot->device_num = device;
 	slot->pci_bus = pci_bus;
-	sprintf(bss_hotplug_slot->name, "%04x:%02x:%02x",
-		pci_domain_nr(pci_bus),
-		((u16)pcibus_info->pbi_buscommon.bs_persist_busnum),
-		device + 1);
 
 	sn_generate_path(pci_bus, slot->physical_path);
 
@@ -203,8 +180,6 @@ static struct hotplug_slot * sn_hp_destroy(void)
 		bss_hotplug_slot = slot->hotplug_slot;
 		list_del(&((struct slot *)bss_hotplug_slot->private)->
 			 hp_list);
-		sysfs_remove_file(&bss_hotplug_slot->kobj,
-				  &sn_slot_path_attr.attr);
 		break;
 	}
 	return bss_hotplug_slot;
@@ -653,11 +628,6 @@ static int sn_hotplug_slot_register(struct pci_bus *pci_bus)
 		rc = pci_hp_register(bss_hotplug_slot);
 		if (rc)
 			goto register_err;
-
-		rc = sysfs_create_file(&bss_hotplug_slot->kobj,
-				       &sn_slot_path_attr.attr);
-		if (rc)
-			goto register_err;
 	}
 	dev_dbg(&pci_bus->self->dev, "Registered bus with hotplug\n");
 	return rc;
-- 
1.5.3.1.1.g1e61

