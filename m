Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbYGGV4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbYGGV4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbYGGV4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:56:37 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47082 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575AbYGGV4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:56:36 -0400
Subject: [PATCH 1/5] integrity: TPM cleanup
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com,
       debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com
References: <20080707192529.489789904@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 17:56:29 -0400
Message-Id: <1215467789.27626.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains 5 patches.
	Patch 1/5 integrity: TPM cleanup (scripts/Lindent and other)
	Patch 2/5 integrity: TPM internal kernel interface
	Patch 3/5 integrity: special fs magic
	Patch 4/5 integrity: Linux Integrity Module(LIM)
	Patch 5/5 integrity: IMA as an integrity service provider
 
Signed-off-by: Debora Velarde <dvelarde@us.ibm.com>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
Index: linux-2.6.26-rc9-git1/drivers/char/tpm/tpm.c
===================================================================
--- linux-2.6.26-rc9-git1.orig/drivers/char/tpm/tpm.c
+++ linux-2.6.26-rc9-git1/drivers/char/tpm/tpm.c
@@ -6,6 +6,7 @@
  * Dave Safford <safford@watson.ibm.com>
  * Reiner Sailer <sailer@watson.ibm.com>
  * Kylene Hall <kjhall@us.ibm.com>
+ * Debora Velarde <dvelarde@us.ibm.com>
  *
  * Maintained by: <tpmdd-devel@lists.sourceforge.net>
  *
@@ -321,7 +322,7 @@ static const u8 tpm_ordinal_duration[TPM
 
 static void user_reader_timeout(unsigned long ptr)
 {
-	struct tpm_chip *chip = (struct tpm_chip *) ptr;
+	struct tpm_chip *chip = (struct tpm_chip *)ptr;
 
 	schedule_work(&chip->work);
 }
@@ -337,10 +338,9 @@ static void timeout_work(struct work_str
 }
 
 /*
- * Returns max number of jiffies to wait
+ * tpm_calc_ordinal_duration - returns max number of jiffies to wait
  */
-unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip,
-					   u32 ordinal)
+unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal)
 {
 	int duration_idx = TPM_UNDEFINED;
 	int duration = 0;
@@ -363,7 +363,7 @@ unsigned long tpm_calc_ordinal_duration(
 EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
 
 /*
- * Internal kernel interface to transmit TPM commands
+ * tpm_transmit - internal kernel interface to transmit TPM commands
  */
 static ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 			    size_t bufsiz)
@@ -385,8 +385,7 @@ static ssize_t tpm_transmit(struct tpm_c
 	mutex_lock(&chip->tpm_mutex);
 
 	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {
-		dev_err(chip->dev,
-			"tpm_transmit: tpm_send: error %zd\n", rc);
+		dev_err(chip->dev, "tpm_transmit: tpm_send: error %zd\n", rc);
 		goto out;
 	}
 
@@ -418,8 +417,7 @@ static ssize_t tpm_transmit(struct tpm_c
 out_recv:
 	rc = chip->vendor.recv(chip, (u8 *) buf, bufsiz);
 	if (rc < 0)
-		dev_err(chip->dev,
-			"tpm_transmit: tpm_recv: error %zd\n", rc);
+		dev_err(chip->dev, "tpm_transmit: tpm_recv: error %zd\n", rc);
 out:
 	mutex_unlock(&chip->tpm_mutex);
 	return rc;
@@ -477,7 +475,7 @@ static ssize_t transmit_cmd(struct tpm_c
 	int err;
 
 	len = tpm_transmit(chip, data, len);
-	if (len <  0)
+	if (len < 0)
 		return len;
 	if (len == TPM_ERROR_SIZE) {
 		err = be32_to_cpu(*((__be32 *) (data + TPM_RET_CODE_IDX)));
@@ -497,7 +495,7 @@ void tpm_gen_interrupt(struct tpm_chip *
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_TIS_TIMEOUT;
 
 	rc = transmit_cmd(chip, data, sizeof(data),
-			"attempting to determine the timeouts");
+			  "attempting to determine the timeouts");
 }
 EXPORT_SYMBOL_GPL(tpm_gen_interrupt);
 
@@ -512,7 +510,7 @@ void tpm_get_timeouts(struct tpm_chip *c
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_TIS_TIMEOUT;
 
 	rc = transmit_cmd(chip, data, sizeof(data),
-			"attempting to determine the timeouts");
+			  "attempting to determine the timeouts");
 	if (rc)
 		goto duration;
 
@@ -544,7 +542,7 @@ duration:
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_TIS_DURATION;
 
 	rc = transmit_cmd(chip, data, sizeof(data),
-			"attempting to determine the durations");
+			  "attempting to determine the durations");
 	if (rc)
 		return;
 
@@ -570,17 +568,20 @@ EXPORT_SYMBOL_GPL(tpm_get_timeouts);
 void tpm_continue_selftest(struct tpm_chip *chip)
 {
 	u8 data[] = {
-		0, 193,			/* TPM_TAG_RQU_COMMAND */
-		0, 0, 0, 10,		/* length */
-		0, 0, 0, 83,		/* TPM_ORD_GetCapability */
+		0, 193,		/* TPM_TAG_RQU_COMMAND */
+		0, 0, 0, 10,	/* length */
+		0, 0, 0, 83,	/* TPM_ORD_GetCapability */
 	};
 
 	tpm_transmit(chip, data, sizeof(data));
 }
 EXPORT_SYMBOL_GPL(tpm_continue_selftest);
 
-ssize_t tpm_show_enabled(struct device * dev, struct device_attribute * attr,
-			char *buf)
+/*
+ * tpm_show_enabled - determine the permanent disabled state
+ */
+ssize_t tpm_show_enabled(struct device *dev, struct device_attribute *attr,
+			 char *buf)
 {
 	u8 data[max_t(int, ARRAY_SIZE(tpm_cap), 35)];
 	ssize_t rc;
@@ -594,14 +595,17 @@ ssize_t tpm_show_enabled(struct device *
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_FLAG_PERM;
 
 	rc = transmit_cmd(chip, data, sizeof(data),
-			"attemtping to determine the permanent state");
+			  "attemtping to determine the permanent state");
 	if (rc)
 		return 0;
 	return sprintf(buf, "%d\n", !data[TPM_GET_CAP_PERM_DISABLE_IDX]);
 }
 EXPORT_SYMBOL_GPL(tpm_show_enabled);
 
-ssize_t tpm_show_active(struct device * dev, struct device_attribute * attr,
+/*
+ * tpm_show_active - determine the permanent inactive state
+ */
+ssize_t tpm_show_active(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
 	u8 data[max_t(int, ARRAY_SIZE(tpm_cap), 35)];
@@ -616,15 +620,18 @@ ssize_t tpm_show_active(struct device * 
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_FLAG_PERM;
 
 	rc = transmit_cmd(chip, data, sizeof(data),
-			"attemtping to determine the permanent state");
+			  "attemtping to determine the permanent state");
 	if (rc)
 		return 0;
 	return sprintf(buf, "%d\n", !data[TPM_GET_CAP_PERM_INACTIVE_IDX]);
 }
 EXPORT_SYMBOL_GPL(tpm_show_active);
 
-ssize_t tpm_show_owned(struct device * dev, struct device_attribute * attr,
-			char *buf)
+/*
+ * tpm_show_owned - determine the owner state
+ */
+ssize_t tpm_show_owned(struct device *dev, struct device_attribute *attr,
+		       char *buf)
 {
 	u8 data[sizeof(tpm_cap)];
 	ssize_t rc;
@@ -638,15 +645,18 @@ ssize_t tpm_show_owned(struct device * d
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_OWNER;
 
 	rc = transmit_cmd(chip, data, sizeof(data),
-			"attempting to determine the owner state");
+			  "attempting to determine the owner state");
 	if (rc)
 		return 0;
 	return sprintf(buf, "%d\n", data[TPM_GET_CAP_RET_BOOL_1_IDX]);
 }
 EXPORT_SYMBOL_GPL(tpm_show_owned);
 
-ssize_t tpm_show_temp_deactivated(struct device * dev,
-				struct device_attribute * attr, char *buf)
+/*
+ * tpm_show_temp_deactivated - determine the temporary inactive state
+ */
+ssize_t tpm_show_temp_deactivated(struct device *dev,
+				  struct device_attribute *attr, char *buf)
 {
 	u8 data[sizeof(tpm_cap)];
 	ssize_t rc;
@@ -660,13 +670,14 @@ ssize_t tpm_show_temp_deactivated(struct
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_FLAG_VOL;
 
 	rc = transmit_cmd(chip, data, sizeof(data),
-			"attempting to determine the temporary state");
+			  "attempting to determine the temporary state");
 	if (rc)
 		return 0;
 	return sprintf(buf, "%d\n", data[TPM_GET_CAP_TEMP_INACTIVE_IDX]);
 }
 EXPORT_SYMBOL_GPL(tpm_show_temp_deactivated);
 
+#define READ_PCR_RESULT_SIZE 30
 static const u8 pcrread[] = {
 	0, 193,			/* TPM_TAG_RQU_COMMAND */
 	0, 0, 0, 14,		/* length */
@@ -677,7 +688,8 @@ static const u8 pcrread[] = {
 ssize_t tpm_show_pcrs(struct device *dev, struct device_attribute *attr,
 		      char *buf)
 {
-	u8 data[max_t(int, max(ARRAY_SIZE(tpm_cap), ARRAY_SIZE(pcrread)), 30)];
+	u8 data[max_t(int, max(ARRAY_SIZE(tpm_cap), ARRAY_SIZE(pcrread)),
+		      READ_PCR_RESULT_SIZE)];
 	ssize_t rc;
 	int i, j, num_pcrs;
 	__be32 index;
@@ -692,7 +704,7 @@ ssize_t tpm_show_pcrs(struct device *dev
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_PCR;
 
 	rc = transmit_cmd(chip, data, sizeof(data),
-			"attempting to determine the number of PCRS");
+			  "attempting to determine the number of PCRS");
 	if (rc)
 		return 0;
 
@@ -702,7 +714,7 @@ ssize_t tpm_show_pcrs(struct device *dev
 		index = cpu_to_be32(i);
 		memcpy(data + 10, &index, 4);
 		rc = transmit_cmd(chip, data, sizeof(data),
-				"attempting to read a PCR");
+				  "attempting to read a PCR");
 		if (rc)
 			goto out;
 		str += sprintf(str, "PCR-%02d: ", i);
@@ -722,6 +734,9 @@ static const u8 readpubek[] = {
 	0, 0, 0, 124,		/* TPM_ORD_ReadPubek */
 };
 
+/*
+ * tpm_show_pubek - returns the tpm's public endorcement key
+ */
 ssize_t tpm_show_pubek(struct device *dev, struct device_attribute *attr,
 		       char *buf)
 {
@@ -741,13 +756,13 @@ ssize_t tpm_show_pubek(struct device *de
 	memcpy(data, readpubek, sizeof(readpubek));
 
 	err = transmit_cmd(chip, data, READ_PUBEK_RESULT_SIZE,
-			"attempting to read the PUBEK");
+			   "attempting to read the PUBEK");
 	if (err)
 		goto out;
 
 	/* 
 	   ignore header 10 bytes
-	   algorithm 32 bits (1 == RSA )
+	   algorithm 32 bits (1 == RSA)
 	   encscheme 16 bits
 	   sigscheme 16 bits
 	   parameters (RSA 12->bytes: keybit, #primes, expbit)  
@@ -756,17 +771,16 @@ ssize_t tpm_show_pubek(struct device *de
 	   ignore checksum 20 bytes
 	 */
 
-	str +=
-	    sprintf(str,
-		    "Algorithm: %02X %02X %02X %02X\nEncscheme: %02X %02X\n"
-		    "Sigscheme: %02X %02X\nParameters: %02X %02X %02X %02X"
-		    " %02X %02X %02X %02X %02X %02X %02X %02X\n"
-		    "Modulus length: %d\nModulus: \n",
-		    data[10], data[11], data[12], data[13], data[14],
-		    data[15], data[16], data[17], data[22], data[23],
-		    data[24], data[25], data[26], data[27], data[28],
-		    data[29], data[30], data[31], data[32], data[33],
-		    be32_to_cpu(*((__be32 *) (data + 34))));
+	str += sprintf(str,
+		       "Algorithm: %02X %02X %02X %02X\nEncscheme: %02X %02X\n"
+		       "Sigscheme: %02X %02X\nParameters: %02X %02X %02X %02X"
+		       " %02X %02X %02X %02X %02X %02X %02X %02X\n"
+		       "Modulus length: %d\nModulus: \n",
+		       data[10], data[11], data[12], data[13], data[14],
+		       data[15], data[16], data[17], data[22], data[23],
+		       data[24], data[25], data[26], data[27], data[28],
+		       data[29], data[30], data[31], data[32], data[33],
+		       be32_to_cpu(*((__be32 *) (data + 34))));
 
 	for (i = 0; i < 256; i++) {
 		str += sprintf(str, "%02X ", data[i + 38]);
@@ -791,10 +805,14 @@ static const u8 cap_version[] = {
 	0, 0, 0, 0
 };
 
+/*
+ * tpm_show_caps - returns the manufacturer and chip version
+ */
 ssize_t tpm_show_caps(struct device *dev, struct device_attribute *attr,
 		      char *buf)
 {
-	u8 data[max_t(int, max(ARRAY_SIZE(tpm_cap), ARRAY_SIZE(cap_version)), 30)];
+	u8 data[max_t(int, max(ARRAY_SIZE(tpm_cap),
+			       ARRAY_SIZE(cap_version)), 30)];
 	ssize_t rc;
 	char *str = buf;
 
@@ -807,34 +825,39 @@ ssize_t tpm_show_caps(struct device *dev
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_MANUFACTURER;
 
 	rc = transmit_cmd(chip, data, sizeof(data),
-			"attempting to determine the manufacturer");
+			  "attempting to determine the manufacturer");
 	if (rc)
 		return 0;
 
 	str += sprintf(str, "Manufacturer: 0x%x\n",
-		       be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_1_IDX))));
+		       be32_to_cpu(*((__be32 *) (data +
+						 TPM_GET_CAP_RET_UINT32_1_IDX))));
 
 	memcpy(data, cap_version, sizeof(cap_version));
 	data[CAP_VERSION_IDX] = CAP_VERSION_1_1;
 	rc = transmit_cmd(chip, data, sizeof(data),
-			"attempting to determine the 1.1 version");
+			  "attempting to determine the 1.1 version");
 	if (rc)
 		goto out;
 
 	str += sprintf(str,
 		       "TCG version: %d.%d\nFirmware version: %d.%d\n",
-		       (int) data[14], (int) data[15], (int) data[16],
-		       (int) data[17]);
+		       (int)data[14], (int)data[15], (int)data[16],
+		       (int)data[17]);
 
 out:
 	return str - buf;
 }
 EXPORT_SYMBOL_GPL(tpm_show_caps);
 
-ssize_t tpm_show_caps_1_2(struct device * dev,
-			  struct device_attribute * attr, char *buf)
+/*
+ * tpm_show_caps_1_2 - returns the manufacturer and chip 1.2 version
+ */
+ssize_t tpm_show_caps_1_2(struct device *dev,
+			  struct device_attribute *attr, char *buf)
 {
-	u8 data[max_t(int, max(ARRAY_SIZE(tpm_cap), ARRAY_SIZE(cap_version)), 30)];
+	u8 data[max_t
+		(int, max(ARRAY_SIZE(tpm_cap), ARRAY_SIZE(cap_version)), 30)];
 	ssize_t len;
 	char *str = buf;
 
@@ -846,8 +869,8 @@ ssize_t tpm_show_caps_1_2(struct device 
 	data[TPM_CAP_IDX] = TPM_CAP_PROP;
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_MANUFACTURER;
 
-	if ((len = tpm_transmit(chip, data, sizeof(data))) <=
-	    TPM_ERROR_SIZE) {
+	len = tpm_transmit(chip, data, sizeof(data));
+	if (len <= TPM_ERROR_SIZE) {
 		dev_dbg(chip->dev, "A TPM error (%d) occurred "
 			"attempting to determine the manufacturer\n",
 			be32_to_cpu(*((__be32 *) (data + TPM_RET_CODE_IDX))));
@@ -855,30 +878,33 @@ ssize_t tpm_show_caps_1_2(struct device 
 	}
 
 	str += sprintf(str, "Manufacturer: 0x%x\n",
-		       be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_1_IDX))));
+		       be32_to_cpu(*((__be32 *) (data +
+						 TPM_GET_CAP_RET_UINT32_1_IDX))));
 
 	memcpy(data, cap_version, sizeof(cap_version));
 	data[CAP_VERSION_IDX] = CAP_VERSION_1_2;
 
-	if ((len = tpm_transmit(chip, data, sizeof(data))) <=
-	    TPM_ERROR_SIZE) {
+	len = tpm_transmit(chip, data, sizeof(data));
+	if (len <= TPM_ERROR_SIZE) {
 		dev_err(chip->dev, "A TPM error (%d) occurred "
 			"attempting to determine the 1.2 version\n",
 			be32_to_cpu(*((__be32 *) (data + TPM_RET_CODE_IDX))));
 		goto out;
 	}
-	str += sprintf(str,
-		       "TCG version: %d.%d\nFirmware version: %d.%d\n",
-		       (int) data[16], (int) data[17], (int) data[18],
-		       (int) data[19]);
+	str += sprintf(str, "TCG version: %d.%d\nFirmware version: %d.%d\n",
+		       (int)data[16], (int)data[17], (int)data[18],
+		       (int)data[19]);
 
 out:
 	return str - buf;
 }
 EXPORT_SYMBOL_GPL(tpm_show_caps_1_2);
 
+/*
+ * tpm_store_cancel - cancel the current tpm operation
+ */
 ssize_t tpm_store_cancel(struct device *dev, struct device_attribute *attr,
-			const char *buf, size_t count)
+			 const char *buf, size_t count)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 	if (chip == NULL)
@@ -973,8 +999,7 @@ ssize_t tpm_write(struct file *file, con
 	if (in_size > TPM_BUFSIZE)
 		in_size = TPM_BUFSIZE;
 
-	if (copy_from_user
-	    (chip->data_buffer, (void __user *) buf, in_size)) {
+	if (copy_from_user(chip->data_buffer, (void __user *)buf, in_size)) {
 		mutex_unlock(&chip->buffer_mutex);
 		return -EFAULT;
 	}
@@ -1104,8 +1129,8 @@ static void tpm_dev_release(struct devic
  * upon errant exit from this function specific probe function should call
  * pci_disable_device
  */
-struct tpm_chip *tpm_register_hardware(struct device *dev, const struct tpm_vendor_specific
-				       *entry)
+struct tpm_chip *tpm_register_hardware(struct device *dev,
+				       const struct tpm_vendor_specific *entry)
 {
 #define DEVNAME_SIZE 7
 
@@ -1129,7 +1154,7 @@ struct tpm_chip *tpm_register_hardware(s
 	INIT_WORK(&chip->work, timeout_work);
 
 	setup_timer(&chip->user_read_timer, user_reader_timeout,
-			(unsigned long)chip);
+		    (unsigned long)chip);
 
 	memcpy(&chip->vendor, entry, sizeof(struct tpm_vendor_specific));
 
@@ -1158,8 +1183,7 @@ struct tpm_chip *tpm_register_hardware(s
 	if (misc_register(&chip->vendor.miscdev)) {
 		dev_err(chip->dev,
 			"unable to misc_register %s, minor %d\n",
-			chip->vendor.miscdev.name,
-			chip->vendor.miscdev.minor);
+			chip->vendor.miscdev.name, chip->vendor.miscdev.minor);
 		put_device(chip->dev);
 		return NULL;
 	}

-- 

