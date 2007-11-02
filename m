Return-Path: <linux-kernel-owner+w=401wt.eu-S1762445AbXKCAOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762445AbXKCAOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761804AbXKCAC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:02:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34960 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762253AbXKCAC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:02:58 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Matt Tolentino <matthew.e.tolentino@intel.com>
Subject: [PATCH 42/54] kset: convert efivars to use kset_create for the vars sub-subsystem.
Date: Fri,  2 Nov 2007 16:59:20 -0700
Message-Id: <1194047972-9850-42-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Matt Tolentino <matthew.e.tolentino@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/efivars.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index c2383ac..362c5a5 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -443,7 +443,7 @@ static struct attribute_group efi_subsys_attr_group = {
 };
 
 
-static decl_subsys(vars, NULL);
+static struct kset *vars_kset;
 static struct kset *efi_kset;
 
 /*
@@ -489,7 +489,7 @@ efivar_create_sysfs_entry(unsigned long variable_name_size,
 	efi_guid_unparse(vendor_guid, short_name + strlen(short_name));
 
 	kobject_set_name(&new_efivar->kobj, "%s", short_name);
-	new_efivar->kobj.kset = &vars_subsys;
+	new_efivar->kobj.kset = vars_kset;
 	new_efivar->kobj.ktype = &efivar_ktype;
 	i = kobject_register(&new_efivar->kobj);
 	if (i) {
@@ -546,11 +546,9 @@ efivars_init(void)
 		goto out_free;
 	}
 
-	vars_subsys.kobj.kset = efi_kset;
-
-	error = subsystem_register(&vars_subsys);
-
-	if (error) {
+	vars_kset = kset_create_and_register("vars", NULL, NULL, efi_kset);
+	if (IS_ERR(vars_kset)) {
+		error = PTR_ERR(vars_kset);
 		printk(KERN_ERR "efivars: Subsystem registration failed with error %d.\n", error);
 		goto out_firmware_unregister;
 	}
@@ -589,7 +587,7 @@ efivars_init(void)
 	else
 		goto out_free;
 
-	subsystem_unregister(&vars_subsys);
+	kset_unregister(vars_kset);
 
 out_firmware_unregister:
 	kset_unregister(efi_kset);
@@ -612,7 +610,7 @@ efivars_exit(void)
 		efivar_unregister(entry);
 	}
 
-	subsystem_unregister(&vars_subsys);
+	kset_unregister(vars_kset);
 	kset_unregister(efi_kset);
 }
 
-- 
1.5.3.4

