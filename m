Return-Path: <linux-kernel-owner+w=401wt.eu-S1762589AbYAYHrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762589AbYAYHrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761586AbYAYHfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:35:16 -0500
Received: from mail.suse.de ([195.135.220.2]:55074 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761575AbYAYHfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:35:14 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Matt Tolentino <matthew.e.tolentino@intel.com>
Subject: [PATCH 081/196] kset: convert efivars to use kset_create for the vars sub-subsystem.
Date: Thu, 24 Jan 2008 23:31:50 -0800
Message-Id: <1201246425-5058-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Matt Tolentino <matthew.e.tolentino@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/efivars.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 018ca1c..e17cd81 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -572,7 +572,7 @@ static struct attribute_group efi_subsys_attr_group = {
 };
 
 
-static decl_subsys(vars, NULL);
+static struct kset *vars_kset;
 static struct kset *efi_kset;
 
 /*
@@ -618,7 +618,7 @@ efivar_create_sysfs_entry(unsigned long variable_name_size,
 	efi_guid_unparse(vendor_guid, short_name + strlen(short_name));
 
 	kobject_set_name(&new_efivar->kobj, "%s", short_name);
-	new_efivar->kobj.kset = &vars_subsys;
+	new_efivar->kobj.kset = vars_kset;
 	new_efivar->kobj.ktype = &efivar_ktype;
 	i = kobject_register(&new_efivar->kobj);
 	if (i) {
@@ -675,12 +675,10 @@ efivars_init(void)
 		goto out_free;
 	}
 
-	vars_subsys.kobj.kset = efi_kset;
-
-	error = subsystem_register(&vars_subsys);
-
-	if (error) {
-		printk(KERN_ERR "efivars: Subsystem registration failed with error %d.\n", error);
+	vars_kset = kset_create_and_add("vars", NULL, &efi_kset->kobj);
+	if (!vars_kset) {
+		printk(KERN_ERR "efivars: Subsystem registration failed.\n");
+		error = -ENOMEM;
 		goto out_firmware_unregister;
 	}
 
@@ -715,12 +713,12 @@ efivars_init(void)
 	 * Now add attributes to allow creation of new vars
 	 * and deletion of existing ones...
 	 */
-	error = sysfs_create_bin_file(&vars_subsys.kobj,
+	error = sysfs_create_bin_file(&vars_kset->kobj,
 				      &var_subsys_attr_new_var);
 	if (error)
 		printk(KERN_ERR "efivars: unable to create new_var sysfs file"
 			" due to error %d\n", error);
-	error = sysfs_create_bin_file(&vars_subsys.kobj,
+	error = sysfs_create_bin_file(&vars_kset->kobj,
 				      &var_subsys_attr_del_var);
 	if (error)
 		printk(KERN_ERR "efivars: unable to create del_var sysfs file"
@@ -733,7 +731,7 @@ efivars_init(void)
 	else
 		goto out_free;
 
-	subsystem_unregister(&vars_subsys);
+	kset_unregister(vars_kset);
 
 out_firmware_unregister:
 	kset_unregister(efi_kset);
@@ -756,7 +754,7 @@ efivars_exit(void)
 		efivar_unregister(entry);
 	}
 
-	subsystem_unregister(&vars_subsys);
+	kset_unregister(vars_kset);
 	kset_unregister(efi_kset);
 }
 
-- 
1.5.3.8

