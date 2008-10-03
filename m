Return-Path: <linux-kernel-owner+w=401wt.eu-S1754370AbYJCQan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbYJCQan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 12:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYJCQaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 12:30:23 -0400
Received: from igw2.br.ibm.com ([32.104.18.25]:35312 "EHLO igw2.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbYJCQaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 12:30:22 -0400
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: serue@us.ibm.com, zohar@linux.vnet.ibm.com, akpm@linux-foundation.org,
       jmorris@namei.org
Subject: [PATCH 3/5] TPM rcu locking
Date: Fri,  3 Oct 2008 13:30:08 -0300
Message-Id: <ddf7749dc8dbf65d02cc395ccdc85b7f5b37083f.1223042186.git.srajiv@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <cover.1223042186.git.srajiv@linux.vnet.ibm.com>
References: <cover.1223042186.git.srajiv@linux.vnet.ibm.com>
In-Reply-To: <cover.1223042186.git.srajiv@linux.vnet.ibm.com>
References: <cover.1223042186.git.srajiv@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protects tpm_chip_list when transversing it.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm.c |   57 +++++++++++++++++------------------------------
 1 files changed, 21 insertions(+), 36 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index dfd4e7f..24fb7ab 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -961,33 +961,28 @@ EXPORT_SYMBOL_GPL(tpm_store_cancel);
  */
 int tpm_open(struct inode *inode, struct file *file)
 {
-	int rc = 0, minor = iminor(inode);
+	int minor = iminor(inode);
 	struct tpm_chip *chip = NULL, *pos;
 
-	spin_lock(&driver_lock);
-
-	list_for_each_entry(pos, &tpm_chip_list, list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(pos, &tpm_chip_list, list) {
 		if (pos->vendor.miscdev.minor == minor) {
 			chip = pos;
+			get_device(chip->dev);
 			break;
 		}
 	}
+	rcu_read_unlock();
 
-	if (chip == NULL) {
-		rc = -ENODEV;
-		goto err_out;
-	}
+	if (!chip)
+		return -ENODEV;
 
 	if (test_and_set_bit(0, &chip->is_open)) {
 		dev_dbg(chip->dev, "Another process owns this TPM\n");
-		rc = -EBUSY;
-		goto err_out;
+		put_device(chip->dev);
+		return -EBUSY;
 	}
 
-	get_device(chip->dev);
-
-	spin_unlock(&driver_lock);
-
 	chip->data_buffer = kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
 	if (chip->data_buffer == NULL) {
 		clear_bit(0, &chip->is_open);
@@ -999,26 +994,23 @@ int tpm_open(struct inode *inode, struct file *file)
 
 	file->private_data = chip;
 	return 0;
-
-err_out:
-	spin_unlock(&driver_lock);
-	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_open);
 
+/*
+ * Called on file close
+ */
 int tpm_release(struct inode *inode, struct file *file)
 {
 	struct tpm_chip *chip = file->private_data;
 
 	flush_scheduled_work();
-	spin_lock(&driver_lock);
 	file->private_data = NULL;
 	del_singleshot_timer_sync(&chip->user_read_timer);
 	atomic_set(&chip->data_pending, 0);
+	kfree(chip->data_buffer);
 	clear_bit(0, &chip->is_open);
 	put_device(chip->dev);
-	kfree(chip->data_buffer);
-	spin_unlock(&driver_lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_release);
@@ -1092,13 +1084,11 @@ void tpm_remove_hardware(struct device *dev)
 	}
 
 	spin_lock(&driver_lock);
-
-	list_del(&chip->list);
-
+	list_del_rcu(&chip->list);
 	spin_unlock(&driver_lock);
+	synchronize_rcu();
 
 	misc_deregister(&chip->vendor.miscdev);
-
 	sysfs_remove_group(&dev->kobj, chip->vendor.attr_group);
 	tpm_bios_log_teardown(chip->bios_dir);
 
@@ -1146,8 +1136,7 @@ EXPORT_SYMBOL_GPL(tpm_pm_resume);
 /*
  * Once all references to platform device are down to 0,
  * release all allocated structures.
- * In case vendor provided release function,
- * call it too.
+ * In case vendor provided release function, call it too.
  */
 static void tpm_dev_release(struct device *dev)
 {
@@ -1155,7 +1144,6 @@ static void tpm_dev_release(struct device *dev)
 
 	if (chip->vendor.release)
 		chip->vendor.release(dev);
-
 	chip->release(dev);
 
 	clear_bit(chip->dev_num, dev_mask);
@@ -1170,8 +1158,8 @@ static void tpm_dev_release(struct device *dev)
  * upon errant exit from this function specific probe function should call
  * pci_disable_device
  */
-struct tpm_chip *tpm_register_hardware(struct device *dev, const struct tpm_vendor_specific
-				       *entry)
+struct tpm_chip *tpm_register_hardware(struct device *dev,
+		const struct tpm_vendor_specific *entry)
 {
 #define DEVNAME_SIZE 7
 
@@ -1230,12 +1218,6 @@ struct tpm_chip *tpm_register_hardware(struct device *dev, const struct tpm_vend
 		return NULL;
 	}
 
-	spin_lock(&driver_lock);
-
-	list_add(&chip->list, &tpm_chip_list);
-
-	spin_unlock(&driver_lock);
-
 	if (sysfs_create_group(&dev->kobj, chip->vendor.attr_group)) {
 		list_del(&chip->list);
 		misc_deregister(&chip->vendor.miscdev);
@@ -1245,6 +1227,9 @@ struct tpm_chip *tpm_register_hardware(struct device *dev, const struct tpm_vend
 
 	chip->bios_dir = tpm_bios_log_setup(devname);
 
+	/* Make chip available */
+	list_add_rcu(&chip->list, &tpm_chip_list);
+
 	return chip;
 }
 EXPORT_SYMBOL_GPL(tpm_register_hardware);
-- 
1.5.6.3

