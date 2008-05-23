Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbYEWPEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbYEWPEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbYEWPEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:04:14 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59977 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbYEWPEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:04:12 -0400
Subject: [RFC][Patch 2/5]integrity: TPM internel kernel interface
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: safford@watson.ibm.com, serue@linux.vnet.ibm.com, sailer@watson.ibm.com,
       zohar@us.ibm.com, Stephen Smalley <sds@tycho.nsa.gov>,
       CaseySchaufler <casey@schaufler-ca.com>
Content-Type: text/plain
Date: Fri, 23 May 2008 11:03:41 -0400
Message-Id: <1211555021.16195.14.camel@new-host>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resubmitting integrity-tpm-internal-kernel-interface.patch, which
was previously Signed-off-by Kylene Hall.

Adds the following support: 
- make internal kernel interface to transmit TPM commands global
- adds reading a pcr value
- adds extending a pcr value
- adds lookup the tpm_chip for given chip number and type

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
Index: linux-2.6.26-rc3-git2/drivers/char/tpm/tpm.c
===================================================================
--- linux-2.6.26-rc3-git2.orig/drivers/char/tpm/tpm.c
+++ linux-2.6.26-rc3-git2/drivers/char/tpm/tpm.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2004 IBM Corporation
+ * Copyright (C) 2004,2007 IBM Corporation
  *
  * Authors:
  * Leendert van Doorn <leendert@watson.ibm.com>
@@ -26,6 +26,12 @@
 #include <linux/poll.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/crypto.h>
+#include <linux/fs.h>
+#include <linux/scatterlist.h>
 
 #include "tpm.h"
 
@@ -49,6 +55,8 @@ enum tpm_duration {
 static LIST_HEAD(tpm_chip_list);
 static DEFINE_SPINLOCK(driver_lock);
 static DECLARE_BITMAP(dev_mask, TPM_NUM_DEVICES);
+#define TPM_CHIP_NUM_MASK       0x0000ffff
+#define TPM_CHIP_TYPE_SHIFT     16
 
 /*
  * Array with one entry per ordinal defining the maximum amount
@@ -364,8 +372,7 @@ EXPORT_SYMBOL_GPL(tpm_calc_ordinal_durat
 /*
  * tpm_transmit - internal kernel interface to transmit TPM commands
  */
-static ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
-			    size_t bufsiz)
+ssize_t tpm_transmit(struct tpm_chip *chip, char *buf, size_t bufsiz)
 {
 	ssize_t rc;
 	u32 count, ordinal;
@@ -421,6 +428,7 @@ out:
 	mutex_unlock(&chip->tpm_mutex);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(tpm_transmit);
 
 #define TPM_DIGEST_SIZE 20
 #define TPM_ERROR_SIZE 10
@@ -726,6 +734,103 @@ out:
 }
 EXPORT_SYMBOL_GPL(tpm_show_pcrs);
 
+/*
+ * tpm_chip_lookup - return tpm_chip for given chip number and type
+ */
+static struct tpm_chip *tpm_chip_lookup(int chip_num, int chip_typ)
+{
+	struct tpm_chip *pos;
+
+	spin_lock(&driver_lock);
+	list_for_each_entry(pos, &tpm_chip_list, list)
+	    if ((chip_num == TPM_ANY_NUM || pos->dev_num == chip_num)
+		&& (chip_typ == TPM_ANY_TYPE)) {
+		spin_unlock(&driver_lock);
+		return pos;
+	}
+
+	spin_unlock(&driver_lock);
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
+ * @res_buf_size: 20 bytes (or NULL if you don't care)
+ */
+int tpm_pcr_read(u32 chip_id, int pcr_idx, u8 *res_buf, int res_buf_size)
+{
+	u8 data[READ_PCR_RESULT_SIZE];
+	int rc;
+	__be32 index;
+	int chip_num = chip_id & TPM_CHIP_NUM_MASK;
+	struct tpm_chip *chip;
+
+	if (res_buf && res_buf_size < TPM_DIGEST_SIZE)
+		return -ENOSPC;
+
+	chip = tpm_chip_lookup(chip_num, chip_id >> TPM_CHIP_TYPE_SHIFT);
+	if (chip == NULL)
+		return -ENODEV;
+
+	memcpy(data, pcrread, sizeof(pcrread));
+	index = cpu_to_be32(pcr_idx);
+	memcpy(data + 10, &index, 4);
+	rc = tpm_transmit(chip, data, sizeof(data));
+	if (rc > 0)
+		rc = be32_to_cpu(*((u32 *) (data + 6)));
+
+	if (rc == 0 && res_buf)
+		memcpy(res_buf, data + 10, TPM_DIGEST_SIZE);
+
+	return rc;
+
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
+ */
+int tpm_pcr_extend(u32 chip_id, int pcr_idx, const u8 *hash)
+{
+	u8 data[EXTEND_PCR_SIZE];
+	int rc;
+	__be32 index;
+	int chip_num = chip_id & TPM_CHIP_NUM_MASK;
+	struct tpm_chip *chip;
+
+	chip = tpm_chip_lookup(chip_num, chip_id >> TPM_CHIP_TYPE_SHIFT);
+	if (chip == NULL)
+		return -ENODEV;
+
+	memcpy(data, pcrextend, sizeof(pcrextend));
+	index = cpu_to_be32(pcr_idx);
+	memcpy(data + 10, &index, 4);
+	memcpy(data + 14, hash, TPM_DIGEST_SIZE);
+	rc = tpm_transmit(chip, data, sizeof(data));
+	if (rc > 0)
+		rc = be32_to_cpu(*((u32 *) (data + 6)));
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm_pcr_extend);
+
 #define  READ_PUBEK_RESULT_SIZE 314
 static const u8 readpubek[] = {
 	0, 193,			/* TPM_TAG_RQU_COMMAND */
Index: linux-2.6.26-rc3-git2/drivers/char/tpm/tpm.h
===================================================================
--- linux-2.6.26-rc3-git2.orig/drivers/char/tpm/tpm.h
+++ linux-2.6.26-rc3-git2/drivers/char/tpm/tpm.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2004 IBM Corporation
+ * Copyright (C) 2004, 2007 IBM Corporation
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
@@ -128,6 +129,7 @@ extern void tpm_get_timeouts(struct tpm_
 extern void tpm_gen_interrupt(struct tpm_chip *);
 extern void tpm_continue_selftest(struct tpm_chip *);
 extern unsigned long tpm_calc_ordinal_duration(struct tpm_chip *, u32);
+ssize_t tpm_transmit(struct tpm_chip *chip, char *buf, size_t bufsiz);
 extern struct tpm_chip* tpm_register_hardware(struct device *,
 				 const struct tpm_vendor_specific *);
 extern int tpm_open(struct inode *, struct file *);
Index: linux-2.6.26-rc3-git2/include/linux/tpm.h
===================================================================
--- /dev/null
+++ linux-2.6.26-rc3-git2/include/linux/tpm.h
@@ -0,0 +1,61 @@
+/*
+ * Copyright (C) 2004,2007 IBM Corporation
+ *
+ * Authors:
+ * Leendert van Doorn <leendert@watson.ibm.com>
+ * Dave Safford <safford@watson.ibm.com>
+ * Reiner Sailer <sailer@watson.ibm.com>
+ * Kylene Hall <kjhall@us.ibm.com>
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
+extern int tpm_pcr_read(u32 chip_id, int pcr_idx, u8 *res_buf,
+			int res_buf_size);
+extern int tpm_pcr_extend(u32 chip_id, int pcr_idx, const u8 *hash);
+#else
+static inline int tpm_pcr_read(u32 chip_id, int pcr_idx, u8 *res_buf,
+				int res_buf_size)
+{
+	return -ENODEV;
+}
+
+static inline int tpm_pcr_extend(u32 chip_id, int pcr_idx, const u8 *hash)
+{
+	return -ENODEV;
+}
+#endif
+#endif
+


