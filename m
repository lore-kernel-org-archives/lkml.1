Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbYAYHmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbYAYHmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759369AbYAYHTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:19:09 -0500
Received: from ns.suse.de ([195.135.220.2]:53003 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758090AbYAYHTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:19:08 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Matt Tolentino <matthew.e.tolentino@intel.com>
Subject: [PATCH 077/196] efivars: make new_var and del_var binary sysfs files
Date: Thu, 24 Jan 2008 23:10:15 -0800
Message-Id: <1201245134-4876-77-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These files should not be "normal" sysfs files as they really are binary
ones.  This patch makes them binary files and saves code in doing so.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Tested-by: Matt Domsch <Matt_Domsch@dell.com>
Cc: Matt Tolentino <matthew.e.tolentino@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/efivars.c |   51 +++++++++++++++++++------------------------
 1 files changed, 23 insertions(+), 28 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 06ecdb9..82183c2 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -143,13 +143,6 @@ struct efivar_attribute efivar_attr_##_name = { \
 	.store = _store, \
 };
 
-#define VAR_SUBSYS_ATTR(_name, _mode, _show, _store) \
-struct subsys_attribute var_subsys_attr_##_name = { \
-	.attr = {.name = __stringify(_name), .mode = _mode}, \
-	.show = _show, \
-	.store = _store, \
-};
-
 #define to_efivar_attr(_attr) container_of(_attr, struct efivar_attribute, attr)
 #define to_efivar_entry(obj)  container_of(obj, struct efivar_entry, kobj)
 
@@ -408,12 +401,6 @@ static struct kobj_type efivar_ktype = {
 	.default_attrs = def_attrs,
 };
 
-static ssize_t
-dummy(struct kset *kset, char *buf)
-{
-	return -ENODEV;
-}
-
 static inline void
 efivar_unregister(struct efivar_entry *var)
 {
@@ -421,8 +408,9 @@ efivar_unregister(struct efivar_entry *var)
 }
 
 
-static ssize_t
-efivar_create(struct kset *kset, const char *buf, size_t count)
+static ssize_t efivar_create(struct kobject *kobj,
+			     struct bin_attribute *bin_attr,
+			     char *buf, loff_t pos, size_t count)
 {
 	struct efi_variable *new_var = (struct efi_variable *)buf;
 	struct efivar_entry *search_efivar, *n;
@@ -479,8 +467,9 @@ efivar_create(struct kset *kset, const char *buf, size_t count)
 	return count;
 }
 
-static ssize_t
-efivar_delete(struct kset *kset, const char *buf, size_t count)
+static ssize_t efivar_delete(struct kobject *kobj,
+			     struct bin_attribute *bin_attr,
+			     char *buf, loff_t pos, size_t count)
 {
 	struct efi_variable *del_var = (struct efi_variable *)buf;
 	struct efivar_entry *search_efivar, *n;
@@ -537,13 +526,14 @@ efivar_delete(struct kset *kset, const char *buf, size_t count)
 	return count;
 }
 
-static VAR_SUBSYS_ATTR(new_var, 0200, dummy, efivar_create);
-static VAR_SUBSYS_ATTR(del_var, 0200, dummy, efivar_delete);
+static struct bin_attribute var_subsys_attr_new_var = {
+	.attr = {.name = "new_var", .mode = 0200},
+	.write = efivar_create,
+};
 
-static struct subsys_attribute *var_subsys_attrs[] = {
-	&var_subsys_attr_new_var,
-	&var_subsys_attr_del_var,
-	NULL,
+static struct bin_attribute var_subsys_attr_del_var = {
+	.attr = {.name = "del_var", .mode = 0200},
+	.write = efivar_delete,
 };
 
 /*
@@ -728,11 +718,16 @@ efivars_init(void)
 	 * Now add attributes to allow creation of new vars
 	 * and deletion of existing ones...
 	 */
-
-	for (i = 0; (attr = var_subsys_attrs[i]) && !error; i++) {
-		if (attr->show && attr->store)
-			error = subsys_create_file(&vars_subsys, attr);
-	}
+	error = sysfs_create_bin_file(&vars_subsys.kobj,
+				      &var_subsys_attr_new_var);
+	if (error)
+		printk(KERN_ERR "efivars: unable to create new_var sysfs file"
+			" due to error %d\n", error);
+	error = sysfs_create_bin_file(&vars_subsys.kobj,
+				      &var_subsys_attr_del_var);
+	if (error)
+		printk(KERN_ERR "efivars: unable to create del_var sysfs file"
+			" due to error %d\n", error);
 
 	/* Don't forget the systab entry */
 
-- 
1.5.3.8

