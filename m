Return-Path: <linux-kernel-owner+w=401wt.eu-S1763880AbXKCANt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763880AbXKCANt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762076AbXKCACz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:02:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761663AbXKCACy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:02:54 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Matt Tolentino <matthew.e.tolentino@intel.com>
Subject: [PATCH 41/54] kset: convert efivars to use kset_create for the efi subsystem.
Date: Fri,  2 Nov 2007 16:59:19 -0700
Message-Id: <1194047972-9850-41-git-send-email-gregkh@suse.de>
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
 drivers/firmware/efivars.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 8d7c8c5..c2383ac 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -444,7 +444,7 @@ static struct attribute_group efi_subsys_attr_group = {
 
 
 static decl_subsys(vars, NULL);
-static decl_subsys(efi, NULL);
+static struct kset *efi_kset;
 
 /*
  * efivar_create_sysfs_entry()
@@ -539,15 +539,14 @@ efivars_init(void)
 	/*
 	 * For now we'll register the efi subsys within this driver
 	 */
-
-	error = firmware_register(&efi_subsys);
-
-	if (error) {
+	efi_kset = kset_create_and_register("efi", NULL, NULL, firmware_kset);
+	if (IS_ERR(efi_kset)) {
+		error = PTR_ERR(efi_kset);
 		printk(KERN_ERR "efivars: Firmware registration failed with error %d.\n", error);
 		goto out_free;
 	}
 
-	vars_subsys.kobj.kset = &efi_subsys;
+	vars_subsys.kobj.kset = efi_kset;
 
 	error = subsystem_register(&vars_subsys);
 
@@ -584,7 +583,7 @@ efivars_init(void)
 	} while (status != EFI_NOT_FOUND);
 
 	/* Don't forget the systab entry */
-	error = sysfs_create_group(&efi_subsys.kobj, &efi_subsys_attr_group);
+	error = sysfs_create_group(&efi_kset->kobj, &efi_subsys_attr_group);
 	if (error)
 		printk(KERN_ERR "efivars: Sysfs attribute export failed with error %d.\n", error);
 	else
@@ -593,7 +592,7 @@ efivars_init(void)
 	subsystem_unregister(&vars_subsys);
 
 out_firmware_unregister:
-	firmware_unregister(&efi_subsys);
+	kset_unregister(efi_kset);
 
 out_free:
 	kfree(variable_name);
@@ -614,7 +613,7 @@ efivars_exit(void)
 	}
 
 	subsystem_unregister(&vars_subsys);
-	firmware_unregister(&efi_subsys);
+	kset_unregister(efi_kset);
 }
 
 module_init(efivars_init);
-- 
1.5.3.4

