Return-Path: <linux-kernel-owner+w=401wt.eu-S1762766AbXKCAMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762766AbXKCAMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761868AbXKCACo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:02:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:34916 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762014AbXKCACm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:02:42 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Matt Tolentino <matthew.e.tolentino@intel.com>
Subject: [PATCH 38/54] efivars: remove new_var and del_var files from sysfs
Date: Fri,  2 Nov 2007 16:59:16 -0700
Message-Id: <1194047972-9850-38-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

WTF?  Passing binary structures into a sysfs file, expecting it to be in
the correct format/endianness?  That's just wrong on so many levels.

So, these files are deleted.  If you want to add them back, please do so
in configfs, or in debugfs.  Or use text strings, which is what sysfs is
only for.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Matt Tolentino <matthew.e.tolentino@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/efivars.c |  149 --------------------------------------------
 1 files changed, 0 insertions(+), 149 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 06ecdb9..65cddb7 100644
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
 
@@ -408,144 +401,12 @@ static struct kobj_type efivar_ktype = {
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
 	kobject_unregister(&var->kobj);
 }
 
-
-static ssize_t
-efivar_create(struct kset *kset, const char *buf, size_t count)
-{
-	struct efi_variable *new_var = (struct efi_variable *)buf;
-	struct efivar_entry *search_efivar, *n;
-	unsigned long strsize1, strsize2;
-	efi_status_t status = EFI_NOT_FOUND;
-	int found = 0;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
-	spin_lock(&efivars_lock);
-
-	/*
-	 * Does this variable already exist?
-	 */
-	list_for_each_entry_safe(search_efivar, n, &efivar_list, list) {
-		strsize1 = utf8_strsize(search_efivar->var.VariableName, 1024);
-		strsize2 = utf8_strsize(new_var->VariableName, 1024);
-		if (strsize1 == strsize2 &&
-			!memcmp(&(search_efivar->var.VariableName),
-				new_var->VariableName, strsize1) &&
-			!efi_guidcmp(search_efivar->var.VendorGuid,
-				new_var->VendorGuid)) {
-			found = 1;
-			break;
-		}
-	}
-	if (found) {
-		spin_unlock(&efivars_lock);
-		return -EINVAL;
-	}
-
-	/* now *really* create the variable via EFI */
-	status = efi.set_variable(new_var->VariableName,
-			&new_var->VendorGuid,
-			new_var->Attributes,
-			new_var->DataSize,
-			new_var->Data);
-
-	if (status != EFI_SUCCESS) {
-		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
-			status);
-		spin_unlock(&efivars_lock);
-		return -EIO;
-	}
-	spin_unlock(&efivars_lock);
-
-	/* Create the entry in sysfs.  Locking is not required here */
-	status = efivar_create_sysfs_entry(utf8_strsize(new_var->VariableName,
-			1024), new_var->VariableName, &new_var->VendorGuid);
-	if (status) {
-		printk(KERN_WARNING "efivars: variable created, but sysfs entry wasn't.\n");
-	}
-	return count;
-}
-
-static ssize_t
-efivar_delete(struct kset *kset, const char *buf, size_t count)
-{
-	struct efi_variable *del_var = (struct efi_variable *)buf;
-	struct efivar_entry *search_efivar, *n;
-	unsigned long strsize1, strsize2;
-	efi_status_t status = EFI_NOT_FOUND;
-	int found = 0;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
-	spin_lock(&efivars_lock);
-
-	/*
-	 * Does this variable already exist?
-	 */
-	list_for_each_entry_safe(search_efivar, n, &efivar_list, list) {
-		strsize1 = utf8_strsize(search_efivar->var.VariableName, 1024);
-		strsize2 = utf8_strsize(del_var->VariableName, 1024);
-		if (strsize1 == strsize2 &&
-			!memcmp(&(search_efivar->var.VariableName),
-				del_var->VariableName, strsize1) &&
-			!efi_guidcmp(search_efivar->var.VendorGuid,
-				del_var->VendorGuid)) {
-			found = 1;
-			break;
-		}
-	}
-	if (!found) {
-		spin_unlock(&efivars_lock);
-		return -EINVAL;
-	}
-	/* force the Attributes/DataSize to 0 to ensure deletion */
-	del_var->Attributes = 0;
-	del_var->DataSize = 0;
-
-	status = efi.set_variable(del_var->VariableName,
-			&del_var->VendorGuid,
-			del_var->Attributes,
-			del_var->DataSize,
-			del_var->Data);
-
-	if (status != EFI_SUCCESS) {
-		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
-			status);
-		spin_unlock(&efivars_lock);
-		return -EIO;
-	}
-	list_del(&search_efivar->list);
-	/* We need to release this lock before unregistering. */
-	spin_unlock(&efivars_lock);
-	efivar_unregister(search_efivar);
-
-	/* It's dead Jim.... */
-	return count;
-}
-
-static VAR_SUBSYS_ATTR(new_var, 0200, dummy, efivar_create);
-static VAR_SUBSYS_ATTR(del_var, 0200, dummy, efivar_delete);
-
-static struct subsys_attribute *var_subsys_attrs[] = {
-	&var_subsys_attr_new_var,
-	&var_subsys_attr_del_var,
-	NULL,
-};
-
 /*
  * Let's not leave out systab information that snuck into
  * the efivars driver
@@ -724,16 +585,6 @@ efivars_init(void)
 		}
 	} while (status != EFI_NOT_FOUND);
 
-	/*
-	 * Now add attributes to allow creation of new vars
-	 * and deletion of existing ones...
-	 */
-
-	for (i = 0; (attr = var_subsys_attrs[i]) && !error; i++) {
-		if (attr->show && attr->store)
-			error = subsys_create_file(&vars_subsys, attr);
-	}
-
 	/* Don't forget the systab entry */
 
 	for (i = 0; (attr = efi_subsys_attrs[i]) && !error; i++) {
-- 
1.5.3.4

