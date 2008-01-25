Return-Path: <linux-kernel-owner+w=401wt.eu-S1763012AbYAYHyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763012AbYAYHyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761771AbYAYHgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:36:23 -0500
Received: from ns.suse.de ([195.135.220.2]:55321 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761969AbYAYHgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:36:22 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 097/196] kobject: remove subsystem_(un)register functions
Date: Thu, 24 Jan 2008 23:32:06 -0800
Message-Id: <1201246425-5058-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions are no longer used and are the last remants of the old
subsystem crap.  So delete them for good.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c      |    6 +++---
 drivers/base/class.c    |    4 ++--
 include/linux/kobject.h |    3 ---
 lib/kobject.c           |   13 -------------
 4 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 6796d3e..871607b 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -854,7 +854,7 @@ int bus_register(struct bus_type * bus)
 	bus->subsys.kobj.kset = bus_kset;
 	bus->subsys.kobj.ktype = &bus_ktype;
 
-	retval = subsystem_register(&bus->subsys);
+	retval = kset_register(&bus->subsys);
 	if (retval)
 		goto out;
 
@@ -900,7 +900,7 @@ bus_drivers_fail:
 bus_devices_fail:
 	bus_remove_file(bus, &bus_attr_uevent);
 bus_uevent_fail:
-	subsystem_unregister(&bus->subsys);
+	kset_unregister(&bus->subsys);
 out:
 	return retval;
 }
@@ -920,7 +920,7 @@ void bus_unregister(struct bus_type * bus)
 	kset_unregister(bus->drivers_kset);
 	kset_unregister(bus->devices_kset);
 	bus_remove_file(bus, &bus_attr_uevent);
-	subsystem_unregister(&bus->subsys);
+	kset_unregister(&bus->subsys);
 }
 
 int bus_register_notifier(struct bus_type *bus, struct notifier_block *nb)
diff --git a/drivers/base/class.c b/drivers/base/class.c
index 304f90e..3ffcda7 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -152,7 +152,7 @@ int class_register(struct class * cls)
 	cls->subsys.kobj.kset = class_kset;
 	cls->subsys.kobj.ktype = &class_ktype;
 
-	error = subsystem_register(&cls->subsys);
+	error = kset_register(&cls->subsys);
 	if (!error) {
 		error = add_class_attrs(class_get(cls));
 		class_put(cls);
@@ -164,7 +164,7 @@ void class_unregister(struct class * cls)
 {
 	pr_debug("device class '%s': unregistering\n", cls->name);
 	remove_class_attrs(cls);
-	subsystem_unregister(&cls->subsys);
+	kset_unregister(&cls->subsys);
 }
 
 static void class_create_release(struct class *cls)
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 0930efd..78c851b 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -207,9 +207,6 @@ extern struct kset *power_kset;
 /* The global /sys/firmware/ kobject for people to chain off of */
 extern struct kobject *firmware_kobj;
 
-extern int __must_check subsystem_register(struct kset *);
-extern void subsystem_unregister(struct kset *);
-
 #if defined(CONFIG_HOTPLUG)
 int kobject_uevent(struct kobject *kobj, enum kobject_action action);
 int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
diff --git a/lib/kobject.c b/lib/kobject.c
index c742ac2..7919c32 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -800,16 +800,6 @@ struct kobject * kset_find_obj(struct kset * kset, const char * name)
 	return ret;
 }
 
-int subsystem_register(struct kset *s)
-{
-	return kset_register(s);
-}
-
-void subsystem_unregister(struct kset *s)
-{
-	kset_unregister(s);
-}
-
 static void kset_release(struct kobject *kobj)
 {
 	struct kset *kset = container_of(kobj, struct kset, kobj);
@@ -904,6 +894,3 @@ EXPORT_SYMBOL(kobject_del);
 
 EXPORT_SYMBOL(kset_register);
 EXPORT_SYMBOL(kset_unregister);
-
-EXPORT_SYMBOL(subsystem_register);
-EXPORT_SYMBOL(subsystem_unregister);
-- 
1.5.3.8

