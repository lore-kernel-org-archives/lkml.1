Return-Path: <linux-kernel-owner+w=401wt.eu-S932084AbXKCAEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084AbXKCAEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756523AbXKCABF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:01:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:34821 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbXKCABD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:01:03 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [PATCH 14/54] kset: convert pci hotplug to use kset_create_and_register
Date: Fri,  2 Nov 2007 16:58:52 -0700
Message-Id: <1194047972-9850-14-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This also renames pci_hotplug_slots_subsys to pcis_hotplug_slots_kset
catch all current users with a build error instead of a build warning
which can easily be missed.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/hotplug/acpiphp_ibm.c      |    4 ++--
 drivers/pci/hotplug/pci_hotplug_core.c |   21 ++++++++++-----------
 drivers/pci/hotplug/rpadlpar_sysfs.c   |    2 +-
 include/linux/pci_hotplug.h            |    2 +-
 4 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_ibm.c b/drivers/pci/hotplug/acpiphp_ibm.c
index 56829f8..121643f 100644
--- a/drivers/pci/hotplug/acpiphp_ibm.c
+++ b/drivers/pci/hotplug/acpiphp_ibm.c
@@ -428,7 +428,7 @@ static int __init ibm_acpiphp_init(void)
 	int retval = 0;
 	acpi_status status;
 	struct acpi_device *device;
-	struct kobject *sysdir = &pci_hotplug_slots_subsys.kobj;
+	struct kobject *sysdir = &pci_hotplug_slots_kset->kobj;
 
 	dbg("%s\n", __FUNCTION__);
 
@@ -475,7 +475,7 @@ init_return:
 static void __exit ibm_acpiphp_exit(void)
 {
 	acpi_status status;
-	struct kobject *sysdir = &pci_hotplug_slots_subsys.kobj;
+	struct kobject *sysdir = &pci_hotplug_slots_kset->kobj;
 
 	dbg("%s\n", __FUNCTION__);
 
diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index ce1cff0..6130397 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -61,7 +61,7 @@ static int debug;
 
 static LIST_HEAD(pci_hotplug_slot_list);
 
-struct kset pci_hotplug_slots_subsys;
+struct kset *pci_hotplug_slots_kset;
 
 static ssize_t hotplug_slot_attr_show(struct kobject *kobj,
 		struct attribute *attr, char *buf)
@@ -96,8 +96,6 @@ static struct kobj_type hotplug_slot_ktype = {
 	.release = &hotplug_slot_release,
 };
 
-decl_subsys_name(pci_hotplug_slots, slots, NULL);
-
 /* these strings match up with the values in pci_bus_speed */
 static char *pci_bus_speed_strings[] = {
 	"33 MHz PCI",		/* 0x00 */
@@ -633,7 +631,7 @@ int pci_hp_register (struct hotplug_slot *slot)
 	}
 
 	kobject_set_name(&slot->kobj, "%s", slot->name);
-	slot->kobj.kset = &pci_hotplug_slots_subsys;
+	slot->kobj.kset = pci_hotplug_slots_kset;
 	slot->kobj.ktype = &hotplug_slot_ktype;
 
 	/* this can fail if we have already registered a slot with the same name */
@@ -702,9 +700,10 @@ static int __init pci_hotplug_init (void)
 {
 	int result;
 
-	pci_hotplug_slots_subsys.kobj.kset = &pci_bus_type.subsys;
-	result = subsystem_register(&pci_hotplug_slots_subsys);
-	if (result) {
+	pci_hotplug_slots_kset = kset_create_and_register("slots", NULL, NULL,
+							  &pci_bus_type.subsys);
+	if (IS_ERR(pci_hotplug_slots_kset)) {
+		result = PTR_ERR(pci_hotplug_slots_kset);
 		err("Register subsys with error %d\n", result);
 		goto exit;
 	}
@@ -716,9 +715,9 @@ static int __init pci_hotplug_init (void)
 
 	info (DRIVER_DESC " version: " DRIVER_VERSION "\n");
 	goto exit;
-	
+
 err_subsys:
-	subsystem_unregister(&pci_hotplug_slots_subsys);
+	kset_unregister(pci_hotplug_slots_kset);
 exit:
 	return result;
 }
@@ -726,7 +725,7 @@ exit:
 static void __exit pci_hotplug_exit (void)
 {
 	cpci_hotplug_exit();
-	subsystem_unregister(&pci_hotplug_slots_subsys);
+	kset_unregister(pci_hotplug_slots_kset);
 }
 
 module_init(pci_hotplug_init);
@@ -738,7 +737,7 @@ MODULE_LICENSE("GPL");
 module_param(debug, bool, 0644);
 MODULE_PARM_DESC(debug, "Debugging mode enabled or not");
 
-EXPORT_SYMBOL_GPL(pci_hotplug_slots_subsys);
+EXPORT_SYMBOL_GPL(pci_hotplug_slots_kset);
 EXPORT_SYMBOL_GPL(pci_hp_register);
 EXPORT_SYMBOL_GPL(pci_hp_deregister);
 EXPORT_SYMBOL_GPL(pci_hp_change_slot_info);
diff --git a/drivers/pci/hotplug/rpadlpar_sysfs.c b/drivers/pci/hotplug/rpadlpar_sysfs.c
index a080fed..71c23db 100644
--- a/drivers/pci/hotplug/rpadlpar_sysfs.c
+++ b/drivers/pci/hotplug/rpadlpar_sysfs.c
@@ -130,7 +130,7 @@ struct kobj_type ktype_dlpar_io = {
 
 struct kset dlpar_io_kset = {
 	.kobj = {.ktype = &ktype_dlpar_io,
-		 .parent = &pci_hotplug_slots_subsys.kobj},
+		 .parent = &pci_hotplug_slots_kset->kobj},
 	.ktype = &ktype_dlpar_io,
 };
 
diff --git a/include/linux/pci_hotplug.h b/include/linux/pci_hotplug.h
index ab4cb6e..8f67e8f 100644
--- a/include/linux/pci_hotplug.h
+++ b/include/linux/pci_hotplug.h
@@ -174,7 +174,7 @@ extern int pci_hp_register		(struct hotplug_slot *slot);
 extern int pci_hp_deregister		(struct hotplug_slot *slot);
 extern int __must_check pci_hp_change_slot_info	(struct hotplug_slot *slot,
 						 struct hotplug_slot_info *info);
-extern struct kset pci_hotplug_slots_subsys;
+extern struct kset *pci_hotplug_slots_kset;
 
 /* PCI Setting Record (Type 0) */
 struct hpp_type0 {
-- 
1.5.3.4

