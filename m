Return-Path: <linux-kernel-owner+w=401wt.eu-S1762501AbYAYHzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762501AbYAYHzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:55:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761756AbYAYHgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:36:36 -0500
Received: from ns.suse.de ([195.135.220.2]:55371 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762000AbYAYHgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:36:35 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Matt Tolentino <matthew.e.tolentino@intel.com>
Subject: [PATCH 100/196] kobject: convert efivars to use kobject_create
Date: Thu, 24 Jan 2008 23:32:09 -0800
Message-Id: <1201246425-5058-21-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using a kset for this simple directory is an overkill.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Matt Tolentino <matthew.e.tolentino@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/efivars.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index d1ad481..7f9f086 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -573,7 +573,7 @@ static struct attribute_group efi_subsys_attr_group = {
 
 
 static struct kset *vars_kset;
-static struct kset *efi_kset;
+static struct kobject *efi_kobj;
 
 /*
  * efivar_create_sysfs_entry()
@@ -665,17 +665,15 @@ efivars_init(void)
 	printk(KERN_INFO "EFI Variables Facility v%s %s\n", EFIVARS_VERSION,
 	       EFIVARS_DATE);
 
-	/*
-	 * For now we'll register the efi subsys within this driver
-	 */
-	efi_kset = kset_create_and_add("efi", NULL, firmware_kobj);
-	if (!efi_kset) {
+	/* For now we'll register the efi directory at /sys/firmware/efi */
+	efi_kobj = kobject_create_and_add("efi", firmware_kobj);
+	if (!efi_kobj) {
 		printk(KERN_ERR "efivars: Firmware registration failed.\n");
 		error = -ENOMEM;
 		goto out_free;
 	}
 
-	vars_kset = kset_create_and_add("vars", NULL, &efi_kset->kobj);
+	vars_kset = kset_create_and_add("vars", NULL, efi_kobj);
 	if (!vars_kset) {
 		printk(KERN_ERR "efivars: Subsystem registration failed.\n");
 		error = -ENOMEM;
@@ -725,7 +723,7 @@ efivars_init(void)
 			" due to error %d\n", error);
 
 	/* Don't forget the systab entry */
-	error = sysfs_create_group(&efi_kset->kobj, &efi_subsys_attr_group);
+	error = sysfs_create_group(efi_kobj, &efi_subsys_attr_group);
 	if (error)
 		printk(KERN_ERR "efivars: Sysfs attribute export failed with error %d.\n", error);
 	else
@@ -734,7 +732,7 @@ efivars_init(void)
 	kset_unregister(vars_kset);
 
 out_firmware_unregister:
-	kset_unregister(efi_kset);
+	kobject_unregister(efi_kobj);
 
 out_free:
 	kfree(variable_name);
@@ -755,7 +753,7 @@ efivars_exit(void)
 	}
 
 	kset_unregister(vars_kset);
-	kset_unregister(efi_kset);
+	kobject_unregister(efi_kobj);
 }
 
 module_init(efivars_init);
-- 
1.5.3.8

