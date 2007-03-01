Return-Path: <linux-kernel-owner+w=401wt.eu-S965415AbXCARMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965415AbXCARMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 12:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965416AbXCARMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 12:12:19 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:43080 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965413AbXCARMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 12:12:17 -0500
X-Originating-Ip: 74.109.98.130
Date: Thu, 1 Mar 2007 12:09:59 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Greg KH <greg@kroah.com>
Subject: [PATCH] Remove "decl_subsys_name" macro and single usage of it.
Message-ID: <Pine.LNX.4.64.0703011205510.20928@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Remove the macro "decl_subsys_name" which can be used to declare a
sysfs subsystem, along with the single invocation of it in the source
tree, since there appears to be little value in creating a subsystem
whose subsystem name differs from its structure name.  Everyone else
just uses "decl_subsys".

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  based on conversations with greg kh.  compile-tested on x86.

 drivers/pci/hotplug/acpiphp_ibm.c      |    4 ++--
 drivers/pci/hotplug/pci_hotplug_core.c |   16 ++++++++--------
 drivers/pci/hotplug/rpadlpar_sysfs.c   |    2 +-
 include/linux/kobject.h                |    8 --------
 include/linux/pci_hotplug.h            |    2 +-
 5 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_ibm.c b/drivers/pci/hotplug/acpiphp_ibm.c
index 7f03881..836194e 100644
--- a/drivers/pci/hotplug/acpiphp_ibm.c
+++ b/drivers/pci/hotplug/acpiphp_ibm.c
@@ -424,7 +424,7 @@ static int __init ibm_acpiphp_init(void)
 	int retval = 0;
 	acpi_status status;
 	struct acpi_device *device;
-	struct kobject *sysdir = &pci_hotplug_slots_subsys.kset.kobj;
+	struct kobject *sysdir = &slots_subsys.kset.kobj;

 	dbg("%s\n", __FUNCTION__);

@@ -471,7 +471,7 @@ init_return:
 static void __exit ibm_acpiphp_exit(void)
 {
 	acpi_status status;
-	struct kobject *sysdir = &pci_hotplug_slots_subsys.kset.kobj;
+	struct kobject *sysdir = &slots_subsys.kset.kobj;

 	dbg("%s\n", __FUNCTION__);

diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index f5d632e..bfbc46c 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -62,7 +62,7 @@ static int debug;

 static LIST_HEAD(pci_hotplug_slot_list);

-struct subsystem pci_hotplug_slots_subsys;
+struct subsystem slots_subsys;

 static ssize_t hotplug_slot_attr_show(struct kobject *kobj,
 		struct attribute *attr, char *buf)
@@ -97,7 +97,7 @@ static struct kobj_type hotplug_slot_ktype = {
 	.release = &hotplug_slot_release,
 };

-decl_subsys_name(pci_hotplug_slots, slots, &hotplug_slot_ktype, NULL);
+decl_subsys(slots, &hotplug_slot_ktype, NULL);

 /* these strings match up with the values in pci_bus_speed */
 static char *pci_bus_speed_strings[] = {
@@ -634,7 +634,7 @@ int pci_hp_register (struct hotplug_slot *slot)
 	}

 	kobject_set_name(&slot->kobj, "%s", slot->name);
-	kobj_set_kset_s(slot, pci_hotplug_slots_subsys);
+	kobj_set_kset_s(slot, slots_subsys);

 	/* this can fail if we have already registered a slot with the same name */
 	if (kobject_register(&slot->kobj)) {
@@ -764,8 +764,8 @@ static int __init pci_hotplug_init (void)
 {
 	int result;

-	kset_set_kset_s(&pci_hotplug_slots_subsys, pci_bus_type.subsys);
-	result = subsystem_register(&pci_hotplug_slots_subsys);
+	kset_set_kset_s(&slots_subsys, pci_bus_type.subsys);
+	result = subsystem_register(&slots_subsys);
 	if (result) {
 		err("Register subsys with error %d\n", result);
 		goto exit;
@@ -780,7 +780,7 @@ static int __init pci_hotplug_init (void)
 	goto exit;

 err_subsys:
-	subsystem_unregister(&pci_hotplug_slots_subsys);
+	subsystem_unregister(&slots_subsys);
 exit:
 	return result;
 }
@@ -788,7 +788,7 @@ exit:
 static void __exit pci_hotplug_exit (void)
 {
 	cpci_hotplug_exit();
-	subsystem_unregister(&pci_hotplug_slots_subsys);
+	subsystem_unregister(&slots_subsys);
 }

 module_init(pci_hotplug_init);
@@ -800,7 +800,7 @@ MODULE_LICENSE("GPL");
 module_param(debug, bool, 0644);
 MODULE_PARM_DESC(debug, "Debugging mode enabled or not");

-EXPORT_SYMBOL_GPL(pci_hotplug_slots_subsys);
+EXPORT_SYMBOL_GPL(slots_subsys);
 EXPORT_SYMBOL_GPL(pci_hp_register);
 EXPORT_SYMBOL_GPL(pci_hp_deregister);
 EXPORT_SYMBOL_GPL(pci_hp_change_slot_info);
diff --git a/drivers/pci/hotplug/rpadlpar_sysfs.c b/drivers/pci/hotplug/rpadlpar_sysfs.c
index 6c5be3f..5332294 100644
--- a/drivers/pci/hotplug/rpadlpar_sysfs.c
+++ b/drivers/pci/hotplug/rpadlpar_sysfs.c
@@ -129,7 +129,7 @@ struct kobj_type ktype_dlpar_io = {
 };

 struct kset dlpar_io_kset = {
-	.subsys = &pci_hotplug_slots_subsys,
+	.subsys = &slots_subsys,
 	.kobj = {.name = DLPAR_KOBJ_NAME, .ktype=&ktype_dlpar_io,},
 	.ktype = &ktype_dlpar_io,
 };
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index b850e03..13326de 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -186,14 +186,6 @@ struct subsystem _name##_subsys = { \
 		.uevent_ops =_uevent_ops, \
 	} \
 }
-#define decl_subsys_name(_varname,_name,_type,_uevent_ops) \
-struct subsystem _varname##_subsys = { \
-	.kset = { \
-		.kobj = { .name = __stringify(_name) }, \
-		.ktype = _type, \
-		.uevent_ops =_uevent_ops, \
-	} \
-}

 /* The global /sys/kernel/ subsystem for people to chain off of */
 extern struct subsystem kernel_subsys;
diff --git a/include/linux/pci_hotplug.h b/include/linux/pci_hotplug.h
index a675a05..82766a1 100644
--- a/include/linux/pci_hotplug.h
+++ b/include/linux/pci_hotplug.h
@@ -174,7 +174,7 @@ extern int pci_hp_register		(struct hotplug_slot *slot);
 extern int pci_hp_deregister		(struct hotplug_slot *slot);
 extern int __must_check pci_hp_change_slot_info	(struct hotplug_slot *slot,
 						 struct hotplug_slot_info *info);
-extern struct subsystem pci_hotplug_slots_subsys;
+extern struct subsystem slots_subsys;

 /* PCI Setting Record (Type 0) */
 struct hpp_type0 {

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
