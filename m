Return-Path: <linux-kernel-owner+w=401wt.eu-S1030634AbXAYWUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030634AbXAYWUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 17:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030636AbXAYWUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 17:20:54 -0500
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:19453 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030635AbXAYWUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 17:20:54 -0500
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns; b=ULitrVIfOxIqWRhE4zjdQnVsa6Eg1HFik1yIGYPDGxw42N1eJB3AwglIsOL8uPFJgHuHnJy4r8qGW+ZNxl90j/BrmTBiQcFMxsya9bGpG+0ZmuCEH2XP0gnvkGi/mRb/;
X-IronPort-AV: i="4.13,239,1167631200"; 
   d="scan'208"; a="169429212:sNHT18599607"
Date: Thu, 25 Jan 2007 16:20:56 -0600
From: Matt Domsch <Matt_Domsch@dell.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, matthew.e.tolentino@intel.com,
       anil.s.keshavamurthy@intel.com, akpm@osdl.org
Subject: [PATCH] Fix race in efi variable delete code
Message-ID: <20070125222055.GA7237@lists.us.dell.com>
References: <20070122152209.29717.52473.sendpatchset@prarit.boston.redhat.com> <20070125203456.GB16521@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070125203456.GB16521@lists.us.dell.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix race when deleting an EFI variable and issuing another EFI command on the
same variable.  The removal of the variable from the efivars_list should be
done in efivar_delete and not delayed until the kobject release.

Furthermore, remove the item from the list at module unload time, and
use list_for_each_entry_safe() rather than list_for_each_safe() for readability.

Tested on ia64. 

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

--- linux-2.6/drivers/firmware/efivars.c.orig	Thu Jan 25 14:35:05 2007
+++ linux-2.6/drivers/firmware/efivars.c	Thu Jan 25 15:00:45 2007
@@ -122,8 +122,6 @@ struct efivar_entry {
 	struct kobject kobj;
 };
 
-#define get_efivar_entry(n) list_entry(n, struct efivar_entry, list)
-
 struct efivar_attribute {
 	struct attribute attr;
 	ssize_t (*show) (struct efivar_entry *entry, char *buf);
@@ -386,9 +384,6 @@ static struct sysfs_ops efivar_attr_ops 
 static void efivar_release(struct kobject *kobj)
 {
 	struct efivar_entry *var = container_of(kobj, struct efivar_entry, kobj);
-	spin_lock(&efivars_lock);
-	list_del(&var->list);
-	spin_unlock(&efivars_lock);
 	kfree(var);
 }
 
@@ -430,9 +425,8 @@ static ssize_t
 efivar_create(struct subsystem *sub, const char *buf, size_t count)
 {
 	struct efi_variable *new_var = (struct efi_variable *)buf;
-	struct efivar_entry *search_efivar = NULL;
+	struct efivar_entry *search_efivar, *n;
 	unsigned long strsize1, strsize2;
-	struct list_head *pos, *n;
 	efi_status_t status = EFI_NOT_FOUND;
 	int found = 0;
 
@@ -444,8 +438,7 @@ efivar_create(struct subsystem *sub, con
 	/*
 	 * Does this variable already exist?
 	 */
-	list_for_each_safe(pos, n, &efivar_list) {
-		search_efivar = get_efivar_entry(pos);
+	list_for_each_entry_safe(search_efivar, n, &efivar_list, list) {
 		strsize1 = utf8_strsize(search_efivar->var.VariableName, 1024);
 		strsize2 = utf8_strsize(new_var->VariableName, 1024);
 		if (strsize1 == strsize2 &&
@@ -490,9 +483,8 @@ static ssize_t
 efivar_delete(struct subsystem *sub, const char *buf, size_t count)
 {
 	struct efi_variable *del_var = (struct efi_variable *)buf;
-	struct efivar_entry *search_efivar = NULL;
+	struct efivar_entry *search_efivar, *n;
 	unsigned long strsize1, strsize2;
-	struct list_head *pos, *n;
 	efi_status_t status = EFI_NOT_FOUND;
 	int found = 0;
 
@@ -504,8 +496,7 @@ efivar_delete(struct subsystem *sub, con
 	/*
 	 * Does this variable already exist?
 	 */
-	list_for_each_safe(pos, n, &efivar_list) {
-		search_efivar = get_efivar_entry(pos);
+	list_for_each_entry_safe(search_efivar, n, &efivar_list, list) {
 		strsize1 = utf8_strsize(search_efivar->var.VariableName, 1024);
 		strsize2 = utf8_strsize(del_var->VariableName, 1024);
 		if (strsize1 == strsize2 &&
@@ -537,9 +528,9 @@ efivar_delete(struct subsystem *sub, con
 		spin_unlock(&efivars_lock);
 		return -EIO;
 	}
+	list_del(&search_efivar->list);
 	/* We need to release this lock before unregistering. */
 	spin_unlock(&efivars_lock);
-
 	efivar_unregister(search_efivar);
 
 	/* It's dead Jim.... */
@@ -768,10 +759,14 @@ out_free:
 static void __exit
 efivars_exit(void)
 {
-	struct list_head *pos, *n;
+	struct efivar_entry *entry, *n;
 
-	list_for_each_safe(pos, n, &efivar_list)
-		efivar_unregister(get_efivar_entry(pos));
+	list_for_each_entry_safe(entry, n, &efivar_list, list) {
+		spin_lock(&efivars_lock);
+		list_del(&entry->list);
+		spin_unlock(&efivars_lock);
+		efivar_unregister(entry);
+	}
 
 	subsystem_unregister(&vars_subsys);
 	firmware_unregister(&efi_subsys);
