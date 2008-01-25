Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYAYHrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYAYHrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759563AbYAYHfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:35:12 -0500
Received: from ns2.suse.de ([195.135.220.15]:49599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759645AbYAYHfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:35:11 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Matt Tolentino <matthew.e.tolentino@intel.com>
Subject: [PATCH 080/196] kset: convert efivars to use kset_create for the efi subsystem.
Date: Thu, 24 Jan 2008 23:31:49 -0800
Message-Id: <1201246425-5058-1-git-send-email-gregkh@suse.de>
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
 drivers/firmware/efivars.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index ebc3853..018ca1c 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -573,7 +573,7 @@ static struct attribute_group efi_subsys_attr_group = {
 
 
 static decl_subsys(vars, NULL);
-static decl_subsys(efi, NULL);
+static struct kset *efi_kset;
 
 /*
  * efivar_create_sysfs_entry()
@@ -668,15 +668,14 @@ efivars_init(void)
 	/*
 	 * For now we'll register the efi subsys within this driver
 	 */
-
-	error = firmware_register(&efi_subsys);
-
-	if (error) {
-		printk(KERN_ERR "efivars: Firmware registration failed with error %d.\n", error);
+	efi_kset = kset_create_and_add("efi", NULL, &firmware_kset->kobj);
+	if (!efi_kset) {
+		printk(KERN_ERR "efivars: Firmware registration failed.\n");
+		error = -ENOMEM;
 		goto out_free;
 	}
 
-	vars_subsys.kobj.kset = &efi_subsys;
+	vars_subsys.kobj.kset = efi_kset;
 
 	error = subsystem_register(&vars_subsys);
 
@@ -728,7 +727,7 @@ efivars_init(void)
 			" due to error %d\n", error);
 
 	/* Don't forget the systab entry */
-	error = sysfs_create_group(&efi_subsys.kobj, &efi_subsys_attr_group);
+	error = sysfs_create_group(&efi_kset->kobj, &efi_subsys_attr_group);
 	if (error)
 		printk(KERN_ERR "efivars: Sysfs attribute export failed with error %d.\n", error);
 	else
@@ -737,7 +736,7 @@ efivars_init(void)
 	subsystem_unregister(&vars_subsys);
 
 out_firmware_unregister:
-	firmware_unregister(&efi_subsys);
+	kset_unregister(efi_kset);
 
 out_free:
 	kfree(variable_name);
@@ -758,7 +757,7 @@ efivars_exit(void)
 	}
 
 	subsystem_unregister(&vars_subsys);
-	firmware_unregister(&efi_subsys);
+	kset_unregister(efi_kset);
 }
 
 module_init(efivars_init);
-- 
1.5.3.8

