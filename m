Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbYKMDuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbYKMDuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 22:50:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbYKMDty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 22:49:54 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59068 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbYKMDtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 22:49:52 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: [PATCH 1/4] integrity: TPM internel kernel interface
Date: Wed, 12 Nov 2008 22:47:11 -0500
Message-Id: <2b68b76c93c3e5479454fa3839482047483e6c16.1226547084.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <cover.1226547084.git.zohar@linux.vnet.ibm.com>
References: <cover.1226547084.git.zohar@linux.vnet.ibm.com>
In-Reply-To: <cover.1226547084.git.zohar@linux.vnet.ibm.com>
References: <cover.1226547084.git.zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The internal TPM kernel interface did not protect itself from
the removal of the TPM driver, while being used.  We continue
to protect the tpm_chip_list using the driver_lock as before,
and are using an rcu lock to protect readers. The internal TPM
kernel interface now protects itself from the driver being
removed by incrementing the module reference count.

Resubmitting integrity-tpm-internal-kernel-interface.patch, which
was previously Signed-off-by Kylene Hall.
Updated per feedback:

Adds the following support:
  - make internal kernel interface to transmit TPM commands global
  - adds reading a pcr value
  - adds extending a pcr value
  - adds lookup the tpm_chip for given chip number and type

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
---
diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 9c47dc4..17d2849 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1,11 +1,12 @@
 /*
- * Copyright (C) 2004 IBM Corporation
+ * Copyright (C) 2004,2007,2008 IBM Corporation
  *
  * Authors:
  * Leendert van Doorn <leendert@watson.ibm.com>
  * Dave Safford <safford@watson.ibm.com>
  * Reiner Sailer <sailer@watson.ibm.com>
  * Kylene Hall <kjhall@us.ibm.com>
+ * Debora Velarde <dvelarde@us.ibm.com>
  *
  * Maintained by: <tpmdd-devel@lists.sourceforge.net>
  *
@@ -28,6 +29,14 @@
 #include <linux/spinlock.h>
 #include <linux/smp_lock.h>
 
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/crypto.h>
+#include <linux/fs.h>
+#include <linux/scatterlist.h>
+#include <linux/rcupdate.h>
+#include <asm/unaligned.h>
 #include "tpm.h"
 
 enum tpm_const {
@@ -50,6 +59,8 @@ enum tpm_duration {
 static LIST_HEAD(tpm_chip_list);
 static DEFINE_SPINLOCK(driver_lock);
 static DECLARE_BITMAP(dev_mask, TPM_NUM_DEVICES);
+#define TPM_CHIP_NUM_MASK       0x0000ffff
+#define TPM_CHIP_TYPE_SHIFT     16
 
 /*
  * Array with one entry per ordinal defining the maximum amount
@@ -366,8 +377,7 @@ EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
 /*
  * Internal kernel interface to transmit TPM commands
  */
-static ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
-			    size_t bufsiz)
+ssize_t tpm_transmit(struct tpm_chip *chip, char *buf, size_t bufsiz)
 {
 	ssize_t rc;
 	u32 count, ordinal;
@@ -425,6 +435,7 @@ out:
 	mutex_unlock(&chip->tpm_mutex);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(tpm_transmit);
 
 #define TPM_DIGEST_SIZE 20
 #define TPM_ERROR_SIZE 10
@@ -717,6 +728,7 @@ ssize_t tpm_show_temp_deactivated(struct device * dev,
 }
 EXPORT_SYMBOL_GPL(tpm_show_temp_deactivated);
 
+#define READ_PCR_RESULT_SIZE 30
 static const u8 pcrread[] = {
 	0, 193,			/* TPM_TAG_RQU_COMMAND */
 	0, 0, 0, 14,		/* length */
@@ -772,6 +784,128 @@ out:
 }
 EXPORT_SYMBOL_GPL(tpm_show_pcrs);
 
+/*
+ * tpm_chip_lookup - return tpm_chip for given chip number and type
+ *
+ * Must be called with rcu_read_lock.
+ */
+static struct tpm_chip *tpm_chip_lookup(int chip_num, int chip_typ)
+{
+	struct tpm_chip *pos;
+	int rc;
+
+	list_for_each_entry_rcu(pos, &tpm_chip_list, list) {
+		rc = (chip_num == TPM_ANY_NUM || pos->dev_num == chip_num)
+		    && (chip_typ == TPM_ANY_TYPE);
+		if (rc)
+			return pos;
+	}
+	return NULL;
+}
+
+/**
+ * tpm_pcr_read - read a pcr value
+ * @chip_id: 	tpm chip identifier
+ * 		Upper 2 bytes: ANY, HW_ONLY or SW_ONLY
+ * 		Lower 2 bytes: tpm idx # or AN&
+ * @pcr_idx:	pcr idx to retrieve
+ * @res_buf: 	TPM_PCR value
+ * 		size of res_buf is 20 bytes (or NULL if you don't care)
+ *
+ * The TPM driver should be built-in, but for whatever reason it
+ * isn't, protect against the chip disappearing, by incrementing
+ * the module usage count.
+ */
+int tpm_pcr_read(u32 chip_id, int pcr_idx, u8 *res_buf)
+{
+	u8 data[READ_PCR_RESULT_SIZE];
+	int rc;
+	__be32 index;
+	int chip_num = chip_id & TPM_CHIP_NUM_MASK;
+	struct tpm_chip *chip;
+
+	rcu_read_lock();
+	chip = tpm_chip_lookup(chip_num, chip_id >> TPM_CHIP_TYPE_SHIFT);
+	if (chip == NULL) {
+		rcu_read_unlock();
+		return -ENODEV;
+	}
+	if (!try_module_get(chip->dev->driver->owner)) {
+		rcu_read_unlock();
+		return -ENODEV;
+	}
+	rcu_read_unlock();
+
+	BUILD_BUG_ON(sizeof(pcrread) > READ_PCR_RESULT_SIZE);
+	memcpy(data, pcrread, sizeof(pcrread));
+	index = cpu_to_be32(pcr_idx);
+	memcpy(data + 10, &index, 4);
+	rc = tpm_transmit(chip, data, sizeof(data));
+	if (rc > 0)
+		rc = get_unaligned_be32((__be32 *) (data + 6));
+
+	if (rc == 0 && res_buf)
+		memcpy(res_buf, data + 10, TPM_DIGEST_SIZE);
+
+	module_put(chip->dev->driver->owner);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm_pcr_read);
+
+#define EXTEND_PCR_SIZE 34
+static const u8 pcrextend[] = {
+	0, 193,			/* TPM_TAG_RQU_COMMAND */
+	0, 0, 0, 34,		/* length */
+	0, 0, 0, 20,		/* TPM_ORD_Extend */
+	0, 0, 0, 0		/* PCR index */
+};
+
+/**
+ * tpm_pcr_extend - extend pcr value with hash
+ * @chip_id: 	tpm chip identifier
+ * 		Upper 2 bytes: ANY, HW_ONLY or SW_ONLY
+ * 		Lower 2 bytes: tpm idx # or AN&
+ * @pcr_idx:	pcr idx to extend
+ * @hash: 	hash value used to extend pcr value
+ *
+ * The TPM driver should be built-in, but for whatever reason it
+ * isn't, protect against the chip disappearing, by incrementing
+ * the module usage count.
+ */
+int tpm_pcr_extend(u32 chip_id, int pcr_idx, const u8 *hash)
+{
+	u8 data[EXTEND_PCR_SIZE];
+	int rc;
+	__be32 index;
+	int chip_num = chip_id & TPM_CHIP_NUM_MASK;
+	struct tpm_chip *chip;
+
+	rcu_read_lock();
+	chip = tpm_chip_lookup(chip_num, chip_id >> TPM_CHIP_TYPE_SHIFT);
+	if (chip == NULL) {
+		rcu_read_unlock();
+		return -ENODEV;
+	}
+	if (!try_module_get(chip->dev->driver->owner)) {
+		rcu_read_unlock();
+		return -ENODEV;
+	}
+	rcu_read_unlock();
+
+	BUILD_BUG_ON(sizeof(pcrextend) > EXTEND_PCR_SIZE);
+	memcpy(data, pcrextend, sizeof(pcrextend));
+	index = cpu_to_be32(pcr_idx);
+	memcpy(data + 10, &index, 4);
+	memcpy(data + 14, hash, TPM_DIGEST_SIZE);
+	rc = tpm_transmit(chip, data, sizeof(data));
+	if (rc > 0)
+		rc = get_unaligned_be32((__be32 *) (data + 6));
+
+	module_put(chip->dev->driver->owner);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm_pcr_extend);
+
 #define  READ_PUBEK_RESULT_SIZE 314
 static const u8 readpubek[] = {
 	0, 193,			/* TPM_TAG_RQU_COMMAND */
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 8e30df4..e0ffddb 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2004 IBM Corporation
+ * Copyright (C) 2004, 2007, 2008 IBM Corporation
  *
  * Authors:
  * Leendert van Doorn <leendert@watson.ibm.com>
@@ -26,6 +26,7 @@
 #include <linux/miscdevice.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/tpm.h>
 
 enum tpm_timeout {
 	TPM_TIMEOUT = 5,	/* msecs */
@@ -128,6 +129,7 @@ extern void tpm_get_timeouts(struct tpm_chip *);
 extern void tpm_gen_interrupt(struct tpm_chip *);
 extern void tpm_continue_selftest(struct tpm_chip *);
 extern unsigned long tpm_calc_ordinal_duration(struct tpm_chip *, u32);
+ssize_t tpm_transmit(struct tpm_chip *chip, char *buf, size_t bufsiz);
 extern struct tpm_chip* tpm_register_hardware(struct device *,
 				 const struct tpm_vendor_specific *);
 extern int tpm_open(struct inode *, struct file *);
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 717af7a..bc26116 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -642,6 +642,9 @@ static __devexit void tpm_tis_pnp_remove(struct pnp_dev *dev)
 
 static struct pnp_driver tis_pnp_driver = {
 	.name = "tpm_tis",
+	.driver = {
+		.owner = THIS_MODULE,
+	},
 	.id_table = tpm_pnp_tbl,
 	.probe = tpm_tis_pnp_init,
 	.suspend = tpm_tis_pnp_suspend,
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
new file mode 100644
index 0000000..355a442
--- /dev/null
+++ b/include/linux/tpm.h
@@ -0,0 +1,49 @@
+/*
+ * Copyright (C) 2004,2007,2008 IBM Corporation
+ *
+ * Authors:
+ * Leendert van Doorn <leendert@watson.ibm.com>
+ * Dave Safford <safford@watson.ibm.com>
+ * Reiner Sailer <sailer@watson.ibm.com>
+ * Kylene Hall <kjhall@us.ibm.com>
+ * Debora Velarde <dvelarde@us.ibm.com>
+ *
+ * Maintained by: <tpmdd_devel@lists.sourceforge.net>
+ *
+ * Device driver for TCG/TCPA TPM (trusted platform module).
+ * Specifications at www.trustedcomputinggroup.org
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ */
+#ifndef __LINUX_TPM_H__
+#define __LINUX_TPM_H__
+
+#define PCI_DEVICE_ID_AMD_8111_LPC    0x7468
+
+/*
+ * Chip type is one of these values in the upper two bytes of chip_id
+ */
+enum tpm_chip_type {
+	TPM_HW_TYPE = 0x0,
+	TPM_SW_TYPE = 0x1,
+	TPM_ANY_TYPE = 0xFFFF,
+};
+
+/*
+ * Chip num is this value or a valid tpm idx in lower two bytes of chip_id
+ */
+enum tpm_chip_num {
+	TPM_ANY_NUM = 0xFFFF,
+};
+
+
+#if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
+
+extern int tpm_pcr_read(u32 chip_id, int pcr_idx, u8 *res_buf);
+extern int tpm_pcr_extend(u32 chip_id, int pcr_idx, const u8 *hash);
+#endif
+#endif
-- 
1.5.5.1

