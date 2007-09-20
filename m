Return-Path: <linux-kernel-owner+w=401wt.eu-S1759512AbXITHHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512AbXITHHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbXITHF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:05:27 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:65209 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbXITHFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:05:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=gR/Bgb0F9LFT941HCiWyEafviVKKEkwT/GbKXZyXcigH7OBVo9a1k/S7+G1LYjVTmjT/fww2lOkXsIWtrW0zxzlZMCvTmW6R/7565ANGqFUZicOt+n4J4UVyH/ic0A230ahW80aihVAbpiMVpDta4CtAorZzvwGKVnGS1odA/lc=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 05/15] sysfs: kill sysfs_update_file()
In-Reply-To: <11902719091692-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 16:05:10 +0900
Message-Id: <11902719103333-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs_update_file() depends on inode->i_mtime but sysfs iondes are now
reclaimable making the reported modification time unreliable.  There's
only one user (pci hotplug) of this notification mechanism and it
reportedly isn't utilized from userland.

Kill sysfs_update_file().

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 drivers/pci/hotplug/pci_hotplug_core.c |   60 --------------------------------
 fs/sysfs/file.c                        |   40 ---------------------
 include/linux/sysfs.h                  |    7 ----
 3 files changed, 0 insertions(+), 107 deletions(-)

diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index bd433ef..f0eba53 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -694,66 +694,6 @@ int __must_check pci_hp_change_slot_info(struct hotplug_slot *slot,
 	if ((slot == NULL) || (info == NULL))
 		return -ENODEV;
 
-	/*
-	* check all fields in the info structure, and update timestamps
-	* for the files referring to the fields that have now changed.
-	*/
-	if ((has_power_file(slot) == 0) &&
-	    (slot->info->power_status != info->power_status)) {
-		retval = sysfs_update_file(&slot->kobj,
-					   &hotplug_slot_attr_power.attr);
-		if (retval)
-			return retval;
-	}
-
-	if ((has_attention_file(slot) == 0) &&
-	    (slot->info->attention_status != info->attention_status)) {
-		retval = sysfs_update_file(&slot->kobj,
-					   &hotplug_slot_attr_attention.attr);
-		if (retval)
-			return retval;
-	}
-
-	if ((has_latch_file(slot) == 0) &&
-	    (slot->info->latch_status != info->latch_status)) {
-		retval = sysfs_update_file(&slot->kobj,
-					   &hotplug_slot_attr_latch.attr);
-		if (retval)
-			return retval;
-	}
-
-	if ((has_adapter_file(slot) == 0) &&
-	    (slot->info->adapter_status != info->adapter_status)) {
-		retval = sysfs_update_file(&slot->kobj,
-					   &hotplug_slot_attr_presence.attr);
-		if (retval)
-			return retval;
-	}
-
-	if ((has_address_file(slot) == 0) &&
-	    (slot->info->address != info->address)) {
-		retval = sysfs_update_file(&slot->kobj,
-					   &hotplug_slot_attr_address.attr);
-		if (retval)
-			return retval;
-	}
-
-	if ((has_max_bus_speed_file(slot) == 0) &&
-	    (slot->info->max_bus_speed != info->max_bus_speed)) {
-		retval = sysfs_update_file(&slot->kobj,
-					   &hotplug_slot_attr_max_bus_speed.attr);
-		if (retval)
-			return retval;
-	}
-
-	if ((has_cur_bus_speed_file(slot) == 0) &&
-	    (slot->info->cur_bus_speed != info->cur_bus_speed)) {
-		retval = sysfs_update_file(&slot->kobj,
-					   &hotplug_slot_attr_cur_bus_speed.attr);
-		if (retval)
-			return retval;
-	}
-
 	memcpy (slot->info, info, sizeof (struct hotplug_slot_info));
 
 	return 0;
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 9fdf8da..61a8c19 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -3,7 +3,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/fsnotify.h>
 #include <linux/kobject.h>
 #include <linux/namei.h>
 #include <linux/poll.h>
@@ -453,44 +452,6 @@ int sysfs_add_file_to_group(struct kobject *kobj,
 }
 EXPORT_SYMBOL_GPL(sysfs_add_file_to_group);
 
-
-/**
- * sysfs_update_file - update the modified timestamp on an object attribute.
- * @kobj: object we're acting for.
- * @attr: attribute descriptor.
- */
-int sysfs_update_file(struct kobject * kobj, const struct attribute * attr)
-{
-	struct sysfs_dirent *victim_sd = NULL;
-	struct dentry *victim = NULL;
-	int rc;
-
-	rc = -ENOENT;
-	victim_sd = sysfs_get_dirent(kobj->sd, attr->name);
-	if (!victim_sd)
-		goto out;
-
-	mutex_lock(&sysfs_rename_mutex);
-	victim = sysfs_get_dentry(victim_sd);
-	mutex_unlock(&sysfs_rename_mutex);
-	if (IS_ERR(victim)) {
-		rc = PTR_ERR(victim);
-		victim = NULL;
-		goto out;
-	}
-
-	mutex_lock(&victim->d_inode->i_mutex);
-	victim->d_inode->i_mtime = CURRENT_TIME;
-	fsnotify_modify(victim);
-	mutex_unlock(&victim->d_inode->i_mutex);
-	rc = 0;
- out:
-	dput(victim);
-	sysfs_put(victim_sd);
-	return rc;
-}
-
-
 /**
  * sysfs_chmod_file - update the modified mode value on an object attribute.
  * @kobj: object we're acting for.
@@ -641,4 +602,3 @@ EXPORT_SYMBOL_GPL(sysfs_schedule_callback);
 
 EXPORT_SYMBOL_GPL(sysfs_create_file);
 EXPORT_SYMBOL_GPL(sysfs_remove_file);
-EXPORT_SYMBOL_GPL(sysfs_update_file);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index b393bb4..db5dd24 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -87,8 +87,6 @@ int __must_check sysfs_move_dir(struct kobject *kobj,
 
 int __must_check sysfs_create_file(struct kobject *kobj,
 				   const struct attribute *attr);
-int __must_check sysfs_update_file(struct kobject *kobj,
-				   const struct attribute *attr);
 int __must_check sysfs_chmod_file(struct kobject *kobj, struct attribute *attr,
 				  mode_t mode);
 void sysfs_remove_file(struct kobject *kobj, const struct attribute *attr);
@@ -149,11 +147,6 @@ static inline int sysfs_create_file(struct kobject *kobj,
 	return 0;
 }
 
-static inline int sysfs_update_file(struct kobject *kobj,
-				    const struct attribute *attr)
-{
-	return 0;
-}
 static inline int sysfs_chmod_file(struct kobject *kobj,
 				   struct attribute *attr, mode_t mode)
 {
-- 
1.5.0.3


