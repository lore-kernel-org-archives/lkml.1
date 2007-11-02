Return-Path: <linux-kernel-owner+w=401wt.eu-S1763736AbXKCANN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763736AbXKCANN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761920AbXKCACr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:02:47 -0400
Received: from ns1.suse.de ([195.135.220.2]:41206 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761987AbXKCACq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:02:46 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Matt Tolentino <matthew.e.tolentino@intel.com>
Subject: [PATCH 39/54] kobject: convert efivars to kobj_attr interface
Date: Fri,  2 Nov 2007 16:59:17 -0700
Message-Id: <1194047972-9850-39-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This cleans up a lot of code and gets rid of a unneeded macro, and gets
us one step closer to deleting the deprecated subsys_attr code.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Matt Tolentino <matthew.e.tolentino@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/efivars.c |   35 ++++++++++++++---------------------
 1 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 65cddb7..8d7c8c5 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -129,13 +129,6 @@ struct efivar_attribute {
 };
 
 
-#define EFI_ATTR(_name, _mode, _show, _store) \
-struct subsys_attribute efi_attr_##_name = { \
-	.attr = {.name = __stringify(_name), .mode = _mode}, \
-	.show = _show, \
-	.store = _store, \
-};
-
 #define EFIVAR_ATTR(_name, _mode, _show, _store) \
 struct efivar_attribute efivar_attr_##_name = { \
 	.attr = {.name = __stringify(_name), .mode = _mode}, \
@@ -411,12 +404,12 @@ efivar_unregister(struct efivar_entry *var)
  * Let's not leave out systab information that snuck into
  * the efivars driver
  */
-static ssize_t
-systab_read(struct kset *kset, char *buf)
+static ssize_t systab_show(struct kobject *kobj,
+			   struct kobj_attribute *attr, char *buf)
 {
 	char *str = buf;
 
-	if (!kset || !buf)
+	if (!kobj || !buf)
 		return -EINVAL;
 
 	if (efi.mps != EFI_INVALID_TABLE_ADDR)
@@ -437,13 +430,19 @@ systab_read(struct kset *kset, char *buf)
 	return str - buf;
 }
 
-static EFI_ATTR(systab, 0400, systab_read, NULL);
+static struct kobj_attribute efi_attr_systab =
+			__ATTR(systab, 0400, systab_show, NULL);
 
-static struct subsys_attribute *efi_subsys_attrs[] = {
-	&efi_attr_systab,
+static struct attribute *efi_subsys_attrs[] = {
+	&efi_attr_systab.attr,
 	NULL,	/* maybe more in the future? */
 };
 
+static struct attribute_group efi_subsys_attr_group = {
+	.attrs = efi_subsys_attrs,
+};
+
+
 static decl_subsys(vars, NULL);
 static decl_subsys(efi, NULL);
 
@@ -522,9 +521,8 @@ efivars_init(void)
 	efi_status_t status = EFI_NOT_FOUND;
 	efi_guid_t vendor_guid;
 	efi_char16_t *variable_name;
-	struct subsys_attribute *attr;
 	unsigned long variable_name_size = 1024;
-	int i, error = 0;
+	int error = 0;
 
 	if (!efi_enabled)
 		return -ENODEV;
@@ -586,12 +584,7 @@ efivars_init(void)
 	} while (status != EFI_NOT_FOUND);
 
 	/* Don't forget the systab entry */
-
-	for (i = 0; (attr = efi_subsys_attrs[i]) && !error; i++) {
-		if (attr->show)
-			error = subsys_create_file(&efi_subsys, attr);
-	}
-
+	error = sysfs_create_group(&efi_subsys.kobj, &efi_subsys_attr_group);
 	if (error)
 		printk(KERN_ERR "efivars: Sysfs attribute export failed with error %d.\n", error);
 	else
-- 
1.5.3.4

