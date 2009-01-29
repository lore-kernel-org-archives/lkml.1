Return-Path: <linux-kernel-owner+w=401wt.eu-S1759871AbZA2Xv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871AbZA2Xv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbZA2XvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:51:03 -0500
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:48781 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbZA2XvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:51:00 -0500
Subject: [PATCH 2/2 - repost] TPM: integrity interface
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, dave@linux.vnet.ibm.com, jmorris@namei.org,
       matthltc@us.ibm.com, zohar@linux.vnet.ibm.com
In-Reply-To: <cover.1233060433.git.srajiv@linux.vnet.ibm.com>
References: <cover.1233060433.git.srajiv@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 21:50:49 -0200
Message-Id: <1233273049.12919.5.camel@blackbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds internal kernel support for:
 - reading/extending a pcr value
 - looking up the tpm_chip for a given chip number

Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 drivers/char/tpm/tpm.c |  129 +++++++++++++++++++++++++++++++++++++++++-------
 drivers/char/tpm/tpm.h |   18 +++++++
 include/linux/tpm.h    |   35 +++++++++++++
 3 files changed, 163 insertions(+), 19 deletions(-)
 create mode 100644 include/linux/tpm.h

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 58ea16f..0618855 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -660,28 +660,125 @@ ssize_t tpm_show_temp_deactivated(struct device * dev,
 }
 EXPORT_SYMBOL_GPL(tpm_show_temp_deactivated);
 
-static const u8 pcrread[] = {
-	0, 193,			/* TPM_TAG_RQU_COMMAND */
-	0, 0, 0, 14,		/* length */
-	0, 0, 0, 21,		/* TPM_ORD_PcrRead */
-	0, 0, 0, 0		/* PCR index */
+/*
+ * tpm_chip_find_get - return tpm_chip for given chip number
+ */
+static struct tpm_chip *tpm_chip_find_get(int chip_num)
+{
+	struct tpm_chip *pos;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(pos, &tpm_chip_list, list) {
+		if (chip_num != TPM_ANY_NUM && chip_num != pos->dev_num)
+			continue;
+
+		if (try_module_get(pos->dev->driver->owner))
+			break;
+	}
+	rcu_read_unlock();
+	return pos;
+}
+
+#define TPM_ORDINAL_PCRREAD cpu_to_be32(21)
+#define READ_PCR_RESULT_SIZE 30
+static struct tpm_input_header pcrread_header = {
+	.tag = TPM_TAG_RQU_COMMAND,
+	.length = cpu_to_be32(14),
+	.ordinal = TPM_ORDINAL_PCRREAD
+};
+ 
+int __tpm_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
+{
+	int rc;
+	struct tpm_cmd_t cmd;
+
+	cmd.header.in = pcrread_header;
+	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
+	BUILD_BUG_ON(cmd.header.in.length > READ_PCR_RESULT_SIZE);
+	rc = transmit_cmd(chip, &cmd, cmd.header.in.length,
+			  "attempting to read a pcr value");
+
+	if (rc == 0)
+		memcpy(res_buf, cmd.params.pcrread_out.pcr_result,
+		       TPM_DIGEST_SIZE);
+	return rc;
+}
+
+/**
+ * tpm_pcr_read - read a pcr value
+ * @chip_num: 	tpm idx # or ANY
+ * @pcr_idx:	pcr idx to retrieve
+ * @res_buf: 	TPM_PCR value
+ * 		size of res_buf is 20 bytes (or NULL if you don't care)
+ *
+ * The TPM driver should be built-in, but for whatever reason it
+ * isn't, protect against the chip disappearing, by incrementing
+ * the module usage count.
+ */
+int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf)
+{
+	struct tpm_chip *chip;
+	int rc;
+
+	chip = tpm_chip_find_get(chip_num);
+	if (chip == NULL)
+		return -ENODEV;
+	rc = __tpm_pcr_read(chip, pcr_idx, res_buf);
+	module_put(chip->dev->driver->owner);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm_pcr_read);
+
+/**
+ * tpm_pcr_extend - extend pcr value with hash
+ * @chip_num: 	tpm idx # or AN&
+ * @pcr_idx:	pcr idx to extend
+ * @hash: 	hash value used to extend pcr value
+ *
+ * The TPM driver should be built-in, but for whatever reason it
+ * isn't, protect against the chip disappearing, by incrementing
+ * the module usage count.
+ */
+#define TPM_ORD_PCR_EXTEND cpu_to_be32(20)
+#define EXTEND_PCR_SIZE 34
+static struct tpm_input_header pcrextend_header = {
+	.tag = TPM_TAG_RQU_COMMAND,
+	.length = cpu_to_be32(34),
+	.ordinal = TPM_ORD_PCR_EXTEND
 };
 
+int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
+{
+	struct tpm_cmd_t cmd;
+	int rc;
+	struct tpm_chip *chip;
+
+	chip = tpm_chip_find_get(chip_num);
+	if (chip == NULL)
+		return -ENODEV;
+
+	cmd.header.in = pcrextend_header;
+	BUILD_BUG_ON(be32_to_cpu(cmd.header.in.length) > EXTEND_PCR_SIZE);
+	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
+	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
+	rc = transmit_cmd(chip, &cmd, cmd.header.in.length,
+			  "attempting extend a PCR value");
+	
+	module_put(chip->dev->driver->owner);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm_pcr_extend);
+
 ssize_t tpm_show_pcrs(struct device *dev, struct device_attribute *attr,
 		      char *buf)
 {
 	cap_t cap;
-	u8 *data;
+	u8 digest[TPM_DIGEST_SIZE];
 	ssize_t rc;
 	int i, j, num_pcrs;
-	__be32 index;
 	char *str = buf;
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 
-	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
 	rc = tpm_getcap(dev, TPM_CAP_PROP_PCR, &cap,
 			"attempting to determine the number of PCRS");
 	if (rc)
@@ -689,20 +786,14 @@ ssize_t tpm_show_pcrs(struct device *dev, struct device_attribute *attr,
 
 	num_pcrs = be32_to_cpu(cap.num_pcrs);
 	for (i = 0; i < num_pcrs; i++) {
-		memcpy(data, pcrread, sizeof(pcrread));
-		index = cpu_to_be32(i);
-		memcpy(data + 10, &index, 4);
-		rc = transmit_cmd(chip, (struct tpm_cmd_t *)data,
-				  TPM_INTERNAL_RESULT_SIZE,
-				  "attempting to read a PCR");
+		rc = __tpm_pcr_read(chip, i, digest);
 		if (rc)
 			break;
 		str += sprintf(str, "PCR-%02d: ", i);
 		for (j = 0; j < TPM_DIGEST_SIZE; j++)
-			str += sprintf(str, "%02X ", *(data + 10 + j));
+			str += sprintf(str, "%02X ", digest[j]);
 		str += sprintf(str, "\n");
 	}
-	kfree(data);
 	return str - buf;
 }
 EXPORT_SYMBOL_GPL(tpm_show_pcrs);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 867987d..d8091d2 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -26,6 +26,7 @@
 #include <linux/miscdevice.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/tpm.h>
 
 enum tpm_timeout {
 	TPM_TIMEOUT = 5,	/* msecs */
@@ -227,11 +228,28 @@ typedef union {
 	struct	tpm_output_header out;
 } tpm_cmd_header;
 
+#define TPM_DIGEST_SIZE 20
+struct tpm_pcrread_out {
+	u8	pcr_result[TPM_DIGEST_SIZE];
+}__attribute__((packed));
+
+struct tpm_pcrread_in {
+	__be32	pcr_idx;
+}__attribute__((packed));
+
+struct tpm_pcrextend_in {
+	__be32	pcr_idx;
+	u8	hash[TPM_DIGEST_SIZE];
+}__attribute__((packed));
+
 typedef union {
 	struct	tpm_getcap_params_out getcap_out;
 	struct	tpm_readpubek_params_out readpubek_out;
 	u8	readpubek_out_buffer[sizeof(struct tpm_readpubek_params_out)];
 	struct	tpm_getcap_params_in getcap_in;
+	struct	tpm_pcrread_in	pcrread_in;
+	struct	tpm_pcrread_out	pcrread_out;
+	struct	tpm_pcrextend_in pcrextend_in;
 } tpm_cmd_params;
 
 struct tpm_cmd_t {
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
new file mode 100644
index 0000000..3338b3f
--- /dev/null
+++ b/include/linux/tpm.h
@@ -0,0 +1,35 @@
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
+/*
+ * Chip num is this value or a valid tpm idx
+ */
+#define	TPM_ANY_NUM 0xFFFF
+
+#if defined(CONFIG_TCG_TPM)
+
+extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
+extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
+#endif
+#endif
-- 
1.5.6.3



