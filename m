Return-Path: <linux-kernel-owner+w=401wt.eu-S1762212AbYAYHwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762212AbYAYHwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757889AbYAYHgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:36:05 -0500
Received: from ns1.suse.de ([195.135.220.2]:55253 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761646AbYAYHgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:36:01 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: [PATCH 092/196] firmware: change firmware_kset to firmware_kobj
Date: Thu, 24 Jan 2008 23:32:01 -0800
Message-Id: <1201246425-5058-13-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no firmware "subsystem" it's just a directory in /sys that
other portions of the kernel want to hook into.  So make it a kobject
not a kset to help alivate anyone who tries to do some odd kset-like
things with this.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/s390/kernel/ipl.c      |    8 ++++----
 drivers/acpi/bus.c          |    2 +-
 drivers/base/firmware.c     |    8 ++++----
 drivers/firmware/edd.c      |    2 +-
 drivers/firmware/efivars.c  |    2 +-
 drivers/parisc/pdc_stable.c |    2 +-
 include/linux/kobject.h     |    4 ++--
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index c8179fc..b97694f 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -855,7 +855,7 @@ static int __init ipl_init(void)
 {
 	int rc;
 
-	ipl_kset = kset_create_and_add("ipl", NULL, &firmware_kset->kobj);
+	ipl_kset = kset_create_and_add("ipl", NULL, firmware_kobj);
 	if (!ipl_kset)
 		return -ENOMEM;
 	switch (ipl_info.type) {
@@ -974,7 +974,7 @@ static int __init reipl_init(void)
 {
 	int rc;
 
-	reipl_kset = kset_create_and_add("reipl", NULL, &firmware_kset->kobj);
+	reipl_kset = kset_create_and_add("reipl", NULL, firmware_kobj);
 	if (!reipl_kset)
 		return -ENOMEM;
 	rc = sysfs_create_file(&reipl_kset->kobj, &reipl_type_attr.attr);
@@ -1063,7 +1063,7 @@ static int __init dump_init(void)
 {
 	int rc;
 
-	dump_kset = kset_create_and_add("dump", NULL, &firmware_kset->kobj);
+	dump_kset = kset_create_and_add("dump", NULL, firmware_kobj);
 	if (!dump_kset)
 		return -ENOMEM;
 	rc = sysfs_create_file(&dump_kset->kobj, &dump_type_attr);
@@ -1086,7 +1086,7 @@ static int __init shutdown_actions_init(void)
 	int rc;
 
 	shutdown_actions_kset = kset_create_and_add("shutdown_actions", NULL,
-						    &firmware_kset->kobj);
+						    firmware_kobj);
 	if (!shutdown_actions_kset)
 		return -ENOMEM;
 	rc = sysfs_create_file(&shutdown_actions_kset->kobj, &on_panic_attr);
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index e550da6..1b4cf98 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -755,7 +755,7 @@ static int __init acpi_init(void)
 		return -ENODEV;
 	}
 
-	acpi_kobj = kobject_create_and_add("acpi", &firmware_kset->kobj);
+	acpi_kobj = kobject_create_and_add("acpi", firmware_kobj);
 	if (!acpi_kobj) {
 		printk(KERN_WARNING "%s: kset create error\n", __FUNCTION__);
 		acpi_kobj = NULL;
diff --git a/drivers/base/firmware.c b/drivers/base/firmware.c
index 9efff48..1138155 100644
--- a/drivers/base/firmware.c
+++ b/drivers/base/firmware.c
@@ -15,13 +15,13 @@
 
 #include "base.h"
 
-struct kset *firmware_kset;
-EXPORT_SYMBOL_GPL(firmware_kset);
+struct kobject *firmware_kobj;
+EXPORT_SYMBOL_GPL(firmware_kobj);
 
 int __init firmware_init(void)
 {
-	firmware_kset = kset_create_and_add("firmware", NULL, NULL);
-	if (!firmware_kset)
+	firmware_kobj = kobject_create_and_add("firmware", NULL);
+	if (!firmware_kobj)
 		return -ENOMEM;
 	return 0;
 }
diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index f07f370..ddcc957 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -756,7 +756,7 @@ edd_init(void)
 		return 1;
 	}
 
-	edd_kset = kset_create_and_add("edd", NULL, &firmware_kset->kobj);
+	edd_kset = kset_create_and_add("edd", NULL, firmware_kobj);
 	if (!edd_kset)
 		return -ENOMEM;
 
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index e17cd81..d1ad481 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -668,7 +668,7 @@ efivars_init(void)
 	/*
 	 * For now we'll register the efi subsys within this driver
 	 */
-	efi_kset = kset_create_and_add("efi", NULL, &firmware_kset->kobj);
+	efi_kset = kset_create_and_add("efi", NULL, firmware_kobj);
 	if (!efi_kset) {
 		printk(KERN_ERR "efivars: Firmware registration failed.\n");
 		error = -ENOMEM;
diff --git a/drivers/parisc/pdc_stable.c b/drivers/parisc/pdc_stable.c
index 4444834..ef1a353 100644
--- a/drivers/parisc/pdc_stable.c
+++ b/drivers/parisc/pdc_stable.c
@@ -1059,7 +1059,7 @@ pdc_stable_init(void)
 	pdcs_osid = (u16)(result >> 16);
 
 	/* For now we'll register the stable kset within this driver */
-	stable_kset = kset_create_and_add("stable", NULL, &firmware_kset->kobj);
+	stable_kset = kset_create_and_add("stable", NULL, firmware_kobj);
 	if (!stable_kset) {
 		rc = -ENOMEM;
 		goto fail_firmreg;
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 29841bb..673623f 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -210,8 +210,8 @@ extern struct kset *kernel_kset;
 extern struct kobject *hypervisor_kobj;
 /* The global /sys/power/ kset for people to chain off of */
 extern struct kset *power_kset;
-/* The global /sys/firmware/ kset for people to chain off of */
-extern struct kset *firmware_kset;
+/* The global /sys/firmware/ kobject for people to chain off of */
+extern struct kobject *firmware_kobj;
 
 extern int __must_check subsystem_register(struct kset *);
 extern void subsystem_unregister(struct kset *);
-- 
1.5.3.8

