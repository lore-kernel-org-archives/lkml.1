Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbYIWRVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbYIWRVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 13:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbYIWRUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 13:20:55 -0400
Received: from igw3.br.ibm.com ([32.104.18.26]:49191 "EHLO igw3.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbYIWRUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 13:20:54 -0400
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jmoriss@namei.org, serue@linux.vnet.ibm.com,
       zohar@linux.vnet.ibm.com, safford@watson.ibm.com,
       paulmck@linux.vnet.ibm.com, debora@linux.vnet.ibm.com
Subject: [PATCH 4/4] TPM: addition of pnp remove
Date: Tue, 23 Sep 2008 14:19:29 -0300
Message-Id: <1222190371-23814-4-git-send-email-srajiv@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <cover.1222136544.git.srajiv@linux.vnet.ibm.com>
References: <cover.1222136544.git.srajiv@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The tpm_dev_release function is only called for platform devices, not pnp devices, so we
implemented the .remove function for pnp ones.
Since it's code is very similar to the one inside tpm_dev_release, we've created a helper
function tpm_dev_vendor_release, which is called by both.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

---
 drivers/char/tpm/tpm.c     |   22 ++++++++++++++++------
 drivers/char/tpm/tpm.h     |    1 +
 drivers/char/tpm/tpm_tis.c |   14 +++++++++++++-
 3 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index ac8982e..a771ceb 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1132,23 +1132,33 @@ int tpm_pm_resume(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(tpm_pm_resume);
 
+/* In case vendor provided release function, call it too.*/
+
+void tpm_dev_vendor_release(struct tpm_chip *chip)
+{
+	if (chip->vendor.release)
+	 	chip->vendor.release(chip->dev);
+	
+	clear_bit(chip->dev_num, dev_mask);
+	kfree(chip->vendor.miscdev.name);
+}
+EXPORT_SYMBOL_GPL(tpm_dev_vendor_release);
+
+
 /*
  * Once all references to platform device are down to 0,
  * release all allocated structures.
- * In case vendor provided release function, call it too.
  */
 static void tpm_dev_release(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 
-	if (chip->vendor.release)
-		chip->vendor.release(dev);
-	chip->release(dev);
+	tpm_dev_vendor_release(chip);
 
-	clear_bit(chip->dev_num, dev_mask);
-	kfree(chip->vendor.miscdev.name);
+	chip->release(dev);
 	kfree(chip);
 }
+EXPORT_SYMBOL_GPL(tpm_dev_release);
 
 /*
  * Called from tpm_<specific>.c probe function only for devices 
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 2756cab..8e30df4 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -132,6 +132,7 @@ extern struct tpm_chip* tpm_register_hardware(struct device *,
 				 const struct tpm_vendor_specific *);
 extern int tpm_open(struct inode *, struct file *);
 extern int tpm_release(struct inode *, struct file *);
+extern void tpm_dev_vendor_release(struct tpm_chip *);
 extern ssize_t tpm_write(struct file *, const char __user *, size_t,
 			 loff_t *);
 extern ssize_t tpm_read(struct file *, char __user *, size_t, loff_t *);
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index ed1879c..3491d70 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -630,12 +630,23 @@ static struct pnp_device_id tpm_pnp_tbl[] __devinitdata = {
 	{"", 0}			/* Terminator */
 };
 
+static __devexit void tpm_tis_pnp_remove(struct pnp_dev *dev)
+{
+	struct tpm_chip *chip = pnp_get_drvdata(dev);
+	
+	tpm_dev_vendor_release(chip);
+
+	kfree(chip);
+}
+
+
 static struct pnp_driver tis_pnp_driver = {
 	.name = "tpm_tis",
 	.id_table = tpm_pnp_tbl,
 	.probe = tpm_tis_pnp_init,
 	.suspend = tpm_tis_pnp_suspend,
 	.resume = tpm_tis_pnp_resume,
+	.remove = tpm_tis_pnp_remove,
 };
 
 #define TIS_HID_USR_IDX sizeof(tpm_pnp_tbl)/sizeof(struct pnp_device_id) -2
@@ -683,6 +694,7 @@ static void __exit cleanup_tis(void)
 	spin_lock(&tis_lock);
 	list_for_each_entry_safe(i, j, &tis_chips, list) {
 		chip = to_tpm_chip(i);
+		tpm_remove_hardware(chip->dev);
 		iowrite32(~TPM_GLOBAL_INT_ENABLE &
 			  ioread32(chip->vendor.iobase +
 				   TPM_INT_ENABLE(chip->vendor.
@@ -694,9 +706,9 @@ static void __exit cleanup_tis(void)
 			free_irq(chip->vendor.irq, chip);
 		iounmap(i->iobase);
 		list_del(&i->list);
-		tpm_remove_hardware(chip->dev);
 	}
 	spin_unlock(&tis_lock);
+	
 	if (force) {
 		platform_device_unregister(pdev);
 		driver_unregister(&tis_drv);
-- 
1.5.6.3

