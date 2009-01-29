Return-Path: <linux-kernel-owner+w=401wt.eu-S1759043AbZA2XCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759043AbZA2XCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756218AbZA2XBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:01:50 -0500
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:43699 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328AbZA2XBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:01:47 -0500
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, dave@linux.vnet.ibm.com, jmorris@namei.org,
       matthltc@us.ibm.com, zohar@linux.vnet.ibm.com
Subject: [PATCH 1/2] TPM: sysfs functions consolidation
Date: Thu, 29 Jan 2009 21:01:34 -0200
Message-Id: <83b938103ecea5b82372cf55c722d7e986959f62.1233269000.git.srajiv@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <cover.1233060433.git.srajiv@linux.vnet.ibm.com>
References: <cover.1233060433.git.srajiv@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Dave Hansen's comments on the tpm_show_*, some of these functions
present a pattern when allocating data[] memory space and also when setting its
content. A new function was created so that this pattern could be consolidated.
Also, replaced the data[] command vectors and its indexes by meaningful structures
as pointed out by Matt Helsley too.

Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm.c |  410 +++++++++++++++++-------------------------------
 drivers/char/tpm/tpm.h |  117 ++++++++++++++
 2 files changed, 258 insertions(+), 269 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 9c47dc4..58ea16f 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -429,134 +429,147 @@ out:
 #define TPM_DIGEST_SIZE 20
 #define TPM_ERROR_SIZE 10
 #define TPM_RET_CODE_IDX 6
-#define TPM_GET_CAP_RET_SIZE_IDX 10
-#define TPM_GET_CAP_RET_UINT32_1_IDX 14
-#define TPM_GET_CAP_RET_UINT32_2_IDX 18
-#define TPM_GET_CAP_RET_UINT32_3_IDX 22
-#define TPM_GET_CAP_RET_UINT32_4_IDX 26
-#define TPM_GET_CAP_PERM_DISABLE_IDX 16
-#define TPM_GET_CAP_PERM_INACTIVE_IDX 18
-#define TPM_GET_CAP_RET_BOOL_1_IDX 14
-#define TPM_GET_CAP_TEMP_INACTIVE_IDX 16
-
-#define TPM_CAP_IDX 13
-#define TPM_CAP_SUBCAP_IDX 21
 
 enum tpm_capabilities {
-	TPM_CAP_FLAG = 4,
-	TPM_CAP_PROP = 5,
+	TPM_CAP_FLAG = cpu_to_be32(4),
+	TPM_CAP_PROP = cpu_to_be32(5),
+	CAP_VERSION_1_1 = cpu_to_be32(0x06),
+	CAP_VERSION_1_2 = cpu_to_be32(0x1A)
 };
 
 enum tpm_sub_capabilities {
-	TPM_CAP_PROP_PCR = 0x1,
-	TPM_CAP_PROP_MANUFACTURER = 0x3,
-	TPM_CAP_FLAG_PERM = 0x8,
-	TPM_CAP_FLAG_VOL = 0x9,
-	TPM_CAP_PROP_OWNER = 0x11,
-	TPM_CAP_PROP_TIS_TIMEOUT = 0x15,
-	TPM_CAP_PROP_TIS_DURATION = 0x20,
-};
+	TPM_CAP_PROP_PCR = cpu_to_be32(0x101),
+	TPM_CAP_PROP_MANUFACTURER = cpu_to_be32(0x103),
+	TPM_CAP_FLAG_PERM = cpu_to_be32(0x108),
+	TPM_CAP_FLAG_VOL = cpu_to_be32(0x109),
+	TPM_CAP_PROP_OWNER = cpu_to_be32(0x111),
+	TPM_CAP_PROP_TIS_TIMEOUT = cpu_to_be32(0x115),
+	TPM_CAP_PROP_TIS_DURATION = cpu_to_be32(0x120),
 
-/*
- * This is a semi generic GetCapability command for use
- * with the capability type TPM_CAP_PROP or TPM_CAP_FLAG
- * and their associated sub_capabilities.
- */
-
-static const u8 tpm_cap[] = {
-	0, 193,			/* TPM_TAG_RQU_COMMAND */
-	0, 0, 0, 22,		/* length */
-	0, 0, 0, 101,		/* TPM_ORD_GetCapability */
-	0, 0, 0, 0,		/* TPM_CAP_<TYPE> */
-	0, 0, 0, 4,		/* TPM_CAP_SUB_<TYPE> size */
-	0, 0, 1, 0		/* TPM_CAP_SUB_<TYPE> */
 };
 
-static ssize_t transmit_cmd(struct tpm_chip *chip, u8 *data, int len,
-			    char *desc)
+static ssize_t transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
+			    int len, const char *desc)
 {
 	int err;
 
-	len = tpm_transmit(chip, data, len);
+	len = tpm_transmit(chip,(u8 *) cmd, len);
 	if (len <  0)
 		return len;
 	if (len == TPM_ERROR_SIZE) {
-		err = be32_to_cpu(*((__be32 *) (data + TPM_RET_CODE_IDX)));
+		err = be32_to_cpu(cmd->header.out.return_code);
 		dev_dbg(chip->dev, "A TPM error (%d) occurred %s\n", err, desc);
 		return err;
 	}
 	return 0;
 }
 
+#define TPM_INTERNAL_RESULT_SIZE 200
+#define TPM_TAG_RQU_COMMAND cpu_to_be16(193)
+#define TPM_ORD_GET_CAP cpu_to_be32(101)
+
+static const struct tpm_input_header tpm_getcap_header = {
+	.tag = TPM_TAG_RQU_COMMAND,
+	.length = cpu_to_be32(22),
+	.ordinal = TPM_ORD_GET_CAP
+};
+
+ssize_t tpm_getcap(struct device *dev, __be32 subcap_id, cap_t *cap,
+		   const char *desc)
+{
+	struct tpm_cmd_t tpm_cmd;
+	int rc;
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+
+	tpm_cmd.header.in = tpm_getcap_header;
+	if (subcap_id == CAP_VERSION_1_1 || subcap_id == CAP_VERSION_1_2) {
+		tpm_cmd.params.getcap_in.cap = subcap_id;
+		/*subcap field not necessary */
+		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(0);
+		tpm_cmd.header.in.length -= cpu_to_be32(sizeof(__be32));
+	} else {
+		if (subcap_id == TPM_CAP_FLAG_PERM ||
+		    subcap_id == TPM_CAP_FLAG_VOL)
+			tpm_cmd.params.getcap_in.cap = TPM_CAP_FLAG;
+		else
+			tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
+		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
+		tpm_cmd.params.getcap_in.subcap = subcap_id;
+	}
+	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, desc);
+	if (!rc)
+		*cap = tpm_cmd.params.getcap_out.cap;
+	return rc;
+}
+
 void tpm_gen_interrupt(struct tpm_chip *chip)
 {
-	u8 data[max_t(int, ARRAY_SIZE(tpm_cap), 30)];
+	struct	tpm_cmd_t tpm_cmd;
 	ssize_t rc;
 
-	memcpy(data, tpm_cap, sizeof(tpm_cap));
-	data[TPM_CAP_IDX] = TPM_CAP_PROP;
-	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_TIS_TIMEOUT;
+	tpm_cmd.header.in = tpm_getcap_header;
+	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
+	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
+	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
 
-	rc = transmit_cmd(chip, data, sizeof(data),
+	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
 			"attempting to determine the timeouts");
 }
 EXPORT_SYMBOL_GPL(tpm_gen_interrupt);
 
 void tpm_get_timeouts(struct tpm_chip *chip)
 {
-	u8 data[max_t(int, ARRAY_SIZE(tpm_cap), 30)];
+	struct tpm_cmd_t tpm_cmd;
+	struct timeout_t *timeout_cap;
 	ssize_t rc;
 	u32 timeout;
 
-	memcpy(data, tpm_cap, sizeof(tpm_cap));
-	data[TPM_CAP_IDX] = TPM_CAP_PROP;
-	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_TIS_TIMEOUT;
+	tpm_cmd.header.in = tpm_getcap_header;
+	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
+	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
+	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
 
-	rc = transmit_cmd(chip, data, sizeof(data),
+	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
 			"attempting to determine the timeouts");
 	if (rc)
 		goto duration;
 
-	if (be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_SIZE_IDX)))
+	if (be32_to_cpu(tpm_cmd.header.out.length)
 	    != 4 * sizeof(u32))
 		goto duration;
 
+	timeout_cap = &tpm_cmd.params.getcap_out.cap.timeout;
 	/* Don't overwrite default if value is 0 */
-	timeout =
-	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_1_IDX)));
+	timeout = be32_to_cpu(timeout_cap->a);
 	if (timeout)
 		chip->vendor.timeout_a = usecs_to_jiffies(timeout);
-	timeout =
-	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_2_IDX)));
+	timeout = be32_to_cpu(timeout_cap->b);
 	if (timeout)
 		chip->vendor.timeout_b = usecs_to_jiffies(timeout);
-	timeout =
-	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_3_IDX)));
+	timeout = be32_to_cpu(timeout_cap->c);
 	if (timeout)
 		chip->vendor.timeout_c = usecs_to_jiffies(timeout);
-	timeout =
-	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_4_IDX)));
+	timeout = be32_to_cpu(timeout_cap->d);
 	if (timeout)
 		chip->vendor.timeout_d = usecs_to_jiffies(timeout);
 
 duration:
-	memcpy(data, tpm_cap, sizeof(tpm_cap));
-	data[TPM_CAP_IDX] = TPM_CAP_PROP;
-	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_TIS_DURATION;
+	tpm_cmd.header.in = tpm_getcap_header;
+	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
+	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
+	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_DURATION;
 
-	rc = transmit_cmd(chip, data, sizeof(data),
+	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
 			"attempting to determine the durations");
 	if (rc)
 		return;
 
-	if (be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_SIZE_IDX)))
+	if (be32_to_cpu(tpm_cmd.header.out.return_code)
 	    != 3 * sizeof(u32))
 		return;
-
+	timeout_cap = &tpm_cmd.params.getcap_out.cap.timeout;
 	chip->vendor.duration[TPM_SHORT] =
-	    usecs_to_jiffies(be32_to_cpu
-			     (*((__be32 *) (data +
-					    TPM_GET_CAP_RET_UINT32_1_IDX))));
+	    usecs_to_jiffies(be32_to_cpu(timeout_cap->a));
 	/* The Broadcom BCM0102 chipset in a Dell Latitude D820 gets the above
 	 * value wrong and apparently reports msecs rather than usecs. So we
 	 * fix up the resulting too-small TPM_SHORT value to make things work.
@@ -565,13 +578,9 @@ duration:
 		chip->vendor.duration[TPM_SHORT] = HZ;
 
 	chip->vendor.duration[TPM_MEDIUM] =
-	    usecs_to_jiffies(be32_to_cpu
-			     (*((__be32 *) (data +
-					    TPM_GET_CAP_RET_UINT32_2_IDX))));
+	    usecs_to_jiffies(be32_to_cpu(timeout_cap->b));
 	chip->vendor.duration[TPM_LONG] =
-	    usecs_to_jiffies(be32_to_cpu
-			     (*((__be32 *) (data +
-					    TPM_GET_CAP_RET_UINT32_3_IDX))));
+	    usecs_to_jiffies(be32_to_cpu(timeout_cap->c));
 }
 EXPORT_SYMBOL_GPL(tpm_get_timeouts);
 
@@ -587,36 +596,18 @@ void tpm_continue_selftest(struct tpm_chip *chip)
 }
 EXPORT_SYMBOL_GPL(tpm_continue_selftest);
 
-#define  TPM_INTERNAL_RESULT_SIZE 200
-
 ssize_t tpm_show_enabled(struct device * dev, struct device_attribute * attr,
 			char *buf)
 {
-	u8 *data;
+	cap_t cap;
 	ssize_t rc;
 
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-	if (chip == NULL)
-		return -ENODEV;
-
-	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	memcpy(data, tpm_cap, sizeof(tpm_cap));
-	data[TPM_CAP_IDX] = TPM_CAP_FLAG;
-	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_FLAG_PERM;
-
-	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
-			"attemtping to determine the permanent enabled state");
-	if (rc) {
-		kfree(data);
+	rc = tpm_getcap(dev, TPM_CAP_FLAG_PERM, &cap,
+			 "attempting to determine the permanent enabled state");
+	if (rc)
 		return 0;
-	}
-
-	rc = sprintf(buf, "%d\n", !data[TPM_GET_CAP_PERM_DISABLE_IDX]);
 
-	kfree(data);
+	rc = sprintf(buf, "%d\n", !cap.perm_flags.disable);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_show_enabled);
@@ -624,31 +615,15 @@ EXPORT_SYMBOL_GPL(tpm_show_enabled);
 ssize_t tpm_show_active(struct device * dev, struct device_attribute * attr,
 			char *buf)
 {
-	u8 *data;
+	cap_t cap;
 	ssize_t rc;
 
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-	if (chip == NULL)
-		return -ENODEV;
-
-	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	memcpy(data, tpm_cap, sizeof(tpm_cap));
-	data[TPM_CAP_IDX] = TPM_CAP_FLAG;
-	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_FLAG_PERM;
-
-	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
-			"attemtping to determine the permanent active state");
-	if (rc) {
-		kfree(data);
+	rc = tpm_getcap(dev, TPM_CAP_FLAG_PERM, &cap,
+			 "attempting to determine the permanent active state");
+	if (rc)
 		return 0;
-	}
 
-	rc = sprintf(buf, "%d\n", !data[TPM_GET_CAP_PERM_INACTIVE_IDX]);
-
-	kfree(data);
+	rc = sprintf(buf, "%d\n", !cap.perm_flags.deactivated);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_show_active);
@@ -656,31 +631,15 @@ EXPORT_SYMBOL_GPL(tpm_show_active);
 ssize_t tpm_show_owned(struct device * dev, struct device_attribute * attr,
 			char *buf)
 {
-	u8 *data;
+	cap_t cap;
 	ssize_t rc;
 
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-	if (chip == NULL)
-		return -ENODEV;
-
-	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	memcpy(data, tpm_cap, sizeof(tpm_cap));
-	data[TPM_CAP_IDX] = TPM_CAP_PROP;
-	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_OWNER;
-
-	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
-			"attempting to determine the owner state");
-	if (rc) {
-		kfree(data);
+	rc = tpm_getcap(dev, TPM_CAP_PROP_OWNER, &cap,
+			 "attempting to determine the owner state");
+	if (rc)
 		return 0;
-	}
-
-	rc = sprintf(buf, "%d\n", data[TPM_GET_CAP_RET_BOOL_1_IDX]);
 
-	kfree(data);
+	rc = sprintf(buf, "%d\n", cap.owned);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_show_owned);
@@ -688,31 +647,15 @@ EXPORT_SYMBOL_GPL(tpm_show_owned);
 ssize_t tpm_show_temp_deactivated(struct device * dev,
 				struct device_attribute * attr, char *buf)
 {
-	u8 *data;
+	cap_t cap;
 	ssize_t rc;
 
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-	if (chip == NULL)
-		return -ENODEV;
-
-	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	memcpy(data, tpm_cap, sizeof(tpm_cap));
-	data[TPM_CAP_IDX] = TPM_CAP_FLAG;
-	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_FLAG_VOL;
-
-	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
-			"attempting to determine the temporary state");
-	if (rc) {
-		kfree(data);
+	rc = tpm_getcap(dev, TPM_CAP_FLAG_VOL, &cap,
+			 "attempting to determine the temporary state");
+	if (rc)
 		return 0;
-	}
 
-	rc = sprintf(buf, "%d\n", data[TPM_GET_CAP_TEMP_INACTIVE_IDX]);
-
-	kfree(data);
+	rc = sprintf(buf, "%d\n", cap.stclear_flags.deactivated);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_show_temp_deactivated);
@@ -727,77 +670,64 @@ static const u8 pcrread[] = {
 ssize_t tpm_show_pcrs(struct device *dev, struct device_attribute *attr,
 		      char *buf)
 {
+	cap_t cap;
 	u8 *data;
 	ssize_t rc;
 	int i, j, num_pcrs;
 	__be32 index;
 	char *str = buf;
-
 	struct tpm_chip *chip = dev_get_drvdata(dev);
-	if (chip == NULL)
-		return -ENODEV;
 
 	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	memcpy(data, tpm_cap, sizeof(tpm_cap));
-	data[TPM_CAP_IDX] = TPM_CAP_PROP;
-	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_PCR;
-
-	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
+	rc = tpm_getcap(dev, TPM_CAP_PROP_PCR, &cap,
 			"attempting to determine the number of PCRS");
-	if (rc) {
-		kfree(data);
+	if (rc)
 		return 0;
-	}
 
-	num_pcrs = be32_to_cpu(*((__be32 *) (data + 14)));
+	num_pcrs = be32_to_cpu(cap.num_pcrs);
 	for (i = 0; i < num_pcrs; i++) {
 		memcpy(data, pcrread, sizeof(pcrread));
 		index = cpu_to_be32(i);
 		memcpy(data + 10, &index, 4);
-		rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
-				"attempting to read a PCR");
+		rc = transmit_cmd(chip, (struct tpm_cmd_t *)data,
+				  TPM_INTERNAL_RESULT_SIZE,
+				  "attempting to read a PCR");
 		if (rc)
-			goto out;
+			break;
 		str += sprintf(str, "PCR-%02d: ", i);
 		for (j = 0; j < TPM_DIGEST_SIZE; j++)
 			str += sprintf(str, "%02X ", *(data + 10 + j));
 		str += sprintf(str, "\n");
 	}
-out:
 	kfree(data);
 	return str - buf;
 }
 EXPORT_SYMBOL_GPL(tpm_show_pcrs);
 
 #define  READ_PUBEK_RESULT_SIZE 314
-static const u8 readpubek[] = {
-	0, 193,			/* TPM_TAG_RQU_COMMAND */
-	0, 0, 0, 30,		/* length */
-	0, 0, 0, 124,		/* TPM_ORD_ReadPubek */
+#define TPM_ORD_READPUBEK cpu_to_be32(124)
+struct tpm_input_header tpm_readpubek_header = {
+	.tag = TPM_TAG_RQU_COMMAND,
+	.length = cpu_to_be32(30),
+	.ordinal = TPM_ORD_READPUBEK
 };
 
 ssize_t tpm_show_pubek(struct device *dev, struct device_attribute *attr,
 		       char *buf)
 {
 	u8 *data;
+	struct tpm_cmd_t tpm_cmd;
 	ssize_t err;
 	int i, rc;
 	char *str = buf;
 
 	struct tpm_chip *chip = dev_get_drvdata(dev);
-	if (chip == NULL)
-		return -ENODEV;
 
-	data = kzalloc(READ_PUBEK_RESULT_SIZE, GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	memcpy(data, readpubek, sizeof(readpubek));
-
-	err = transmit_cmd(chip, data, READ_PUBEK_RESULT_SIZE,
+	tpm_cmd.header.in = tpm_readpubek_header;
+	err = transmit_cmd(chip, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
 			"attempting to read the PUBEK");
 	if (err)
 		goto out;
@@ -812,7 +742,7 @@ ssize_t tpm_show_pubek(struct device *dev, struct device_attribute *attr,
 	   256 byte modulus
 	   ignore checksum 20 bytes
 	 */
-
+	data = tpm_cmd.params.readpubek_out_buffer;
 	str +=
 	    sprintf(str,
 		    "Algorithm: %02X %02X %02X %02X\nEncscheme: %02X %02X\n"
@@ -832,65 +762,33 @@ ssize_t tpm_show_pubek(struct device *dev, struct device_attribute *attr,
 	}
 out:
 	rc = str - buf;
-	kfree(data);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_show_pubek);
 
-#define CAP_VERSION_1_1 6
-#define CAP_VERSION_1_2 0x1A
-#define CAP_VERSION_IDX 13
-static const u8 cap_version[] = {
-	0, 193,			/* TPM_TAG_RQU_COMMAND */
-	0, 0, 0, 18,		/* length */
-	0, 0, 0, 101,		/* TPM_ORD_GetCapability */
-	0, 0, 0, 0,
-	0, 0, 0, 0
-};
 
 ssize_t tpm_show_caps(struct device *dev, struct device_attribute *attr,
 		      char *buf)
 {
-	u8 *data;
+	cap_t cap;
 	ssize_t rc;
 	char *str = buf;
 
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-	if (chip == NULL)
-		return -ENODEV;
-
-	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	memcpy(data, tpm_cap, sizeof(tpm_cap));
-	data[TPM_CAP_IDX] = TPM_CAP_PROP;
-	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_MANUFACTURER;
-
-	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
+	rc = tpm_getcap(dev, TPM_CAP_PROP_MANUFACTURER, &cap,
 			"attempting to determine the manufacturer");
-	if (rc) {
-		kfree(data);
+	if (rc)
 		return 0;
-	}
-
 	str += sprintf(str, "Manufacturer: 0x%x\n",
-		       be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_1_IDX))));
+		       be32_to_cpu(cap.manufacturer_id));
 
-	memcpy(data, cap_version, sizeof(cap_version));
-	data[CAP_VERSION_IDX] = CAP_VERSION_1_1;
-	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
-			"attempting to determine the 1.1 version");
+	rc = tpm_getcap(dev, CAP_VERSION_1_1, &cap,
+		        "attempting to determine the 1.1 version");
 	if (rc)
-		goto out;
-
+		return 0;
 	str += sprintf(str,
 		       "TCG version: %d.%d\nFirmware version: %d.%d\n",
-		       (int) data[14], (int) data[15], (int) data[16],
-		       (int) data[17]);
-
-out:
-	kfree(data);
+		       cap.tpm_version.Major, cap.tpm_version.Minor,
+		       cap.tpm_version.revMajor, cap.tpm_version.revMinor);
 	return str - buf;
 }
 EXPORT_SYMBOL_GPL(tpm_show_caps);
@@ -898,51 +796,25 @@ EXPORT_SYMBOL_GPL(tpm_show_caps);
 ssize_t tpm_show_caps_1_2(struct device * dev,
 			  struct device_attribute * attr, char *buf)
 {
-	u8 *data;
-	ssize_t len;
+	cap_t cap;
+	ssize_t rc;
 	char *str = buf;
 
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-	if (chip == NULL)
-		return -ENODEV;
-
-	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	memcpy(data, tpm_cap, sizeof(tpm_cap));
-	data[TPM_CAP_IDX] = TPM_CAP_PROP;
-	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_MANUFACTURER;
-
-	len = tpm_transmit(chip, data, TPM_INTERNAL_RESULT_SIZE);
-	if (len <= TPM_ERROR_SIZE) {
-		dev_dbg(chip->dev, "A TPM error (%d) occurred "
-			"attempting to determine the manufacturer\n",
-			be32_to_cpu(*((__be32 *) (data + TPM_RET_CODE_IDX))));
-		kfree(data);
+	rc = tpm_getcap(dev, TPM_CAP_PROP_MANUFACTURER, &cap,
+			"attempting to determine the manufacturer");
+	if (rc)
 		return 0;
-	}
-
 	str += sprintf(str, "Manufacturer: 0x%x\n",
-		       be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_1_IDX))));
-
-	memcpy(data, cap_version, sizeof(cap_version));
-	data[CAP_VERSION_IDX] = CAP_VERSION_1_2;
-
-	len = tpm_transmit(chip, data, TPM_INTERNAL_RESULT_SIZE);
-	if (len <= TPM_ERROR_SIZE) {
-		dev_err(chip->dev, "A TPM error (%d) occurred "
-			"attempting to determine the 1.2 version\n",
-			be32_to_cpu(*((__be32 *) (data + TPM_RET_CODE_IDX))));
-		goto out;
-	}
+		       be32_to_cpu(cap.manufacturer_id));
+	rc = tpm_getcap(dev, CAP_VERSION_1_2, &cap,
+			 "attempting to determine the 1.2 version");
+	if (rc)
+		return 0;
 	str += sprintf(str,
 		       "TCG version: %d.%d\nFirmware version: %d.%d\n",
-		       (int) data[16], (int) data[17], (int) data[18],
-		       (int) data[19]);
-
-out:
-	kfree(data);
+		       cap.tpm_version_1_2.Major, cap.tpm_version_1_2.Minor,
+		       cap.tpm_version_1_2.revMajor,
+		       cap.tpm_version_1_2.revMinor);
 	return str - buf;
 }
 EXPORT_SYMBOL_GPL(tpm_show_caps_1_2);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 8e30df4..867987d 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -123,6 +123,123 @@ static inline void tpm_write_index(int base, int index, int value)
 	outb(index, base);
 	outb(value & 0xFF, base+1);
 }
+struct tpm_input_header {
+	__be16	tag;
+	__be32	length;
+	__be32	ordinal;
+}__attribute__((packed));
+
+struct tpm_output_header {
+	__be16	tag;
+	__be32	length;
+	__be32	return_code;
+}__attribute__((packed));
+
+struct	stclear_flags_t {
+	__be16	tag;
+	u8	deactivated;
+	u8	disableForceClear;
+	u8	physicalPresence;
+	u8	physicalPresenceLock;
+	u8	bGlobalLock;
+}__attribute__((packed));
+
+struct	tpm_version_t {
+	u8	Major;
+	u8	Minor;
+	u8	revMajor;
+	u8	revMinor;
+}__attribute__((packed));
+
+struct	tpm_version_1_2_t {
+	__be16	tag;
+	u8	Major;
+	u8	Minor;
+	u8	revMajor;
+	u8	revMinor;
+}__attribute__((packed));
+
+struct	timeout_t {
+	__be32	a;
+	__be32	b;
+	__be32	c;
+	__be32	d;
+}__attribute__((packed));
+
+struct permanent_flags_t {
+	__be16	tag;
+	u8	disable;
+	u8	ownership;
+	u8	deactivated;
+	u8	readPubek;
+	u8	disableOwnerClear;
+	u8	allowMaintenance;
+	u8	physicalPresenceLifetimeLock;
+	u8	physicalPresenceHWEnable;
+	u8	physicalPresenceCMDEnable;
+	u8	CEKPUsed;
+	u8	TPMpost;
+	u8	TPMpostLock;
+	u8	FIPS;
+	u8	operator;
+	u8	enableRevokeEK;
+	u8	nvLocked;
+	u8	readSRKPub;
+	u8	tpmEstablished;
+	u8	maintenanceDone;
+	u8	disableFullDALogicInfo;
+}__attribute__((packed));
+
+typedef union {
+	struct	permanent_flags_t perm_flags;
+	struct	stclear_flags_t	stclear_flags;
+	bool	owned;
+	__be32	num_pcrs;
+	struct	tpm_version_t	tpm_version;
+	struct	tpm_version_1_2_t tpm_version_1_2;
+	__be32	manufacturer_id;
+	struct timeout_t  timeout;
+} cap_t;
+
+struct	tpm_getcap_params_in {
+	__be32	cap;
+	__be32	subcap_size;
+	__be32	subcap;
+}__attribute__((packed));
+
+struct	tpm_getcap_params_out {
+	__be32	cap_size;
+	cap_t	cap;
+}__attribute__((packed));
+
+struct	tpm_readpubek_params_out {
+	u8	algorithm[4];
+	u8	encscheme[2];
+	u8	sigscheme[2];
+	u8	parameters[12]; /*assuming RSA*/
+	__be32	keysize;
+	u8	modulus[256];
+	u8	checksum[20];
+}__attribute__((packed));
+
+typedef union {
+	struct	tpm_input_header in;
+	struct	tpm_output_header out;
+} tpm_cmd_header;
+
+typedef union {
+	struct	tpm_getcap_params_out getcap_out;
+	struct	tpm_readpubek_params_out readpubek_out;
+	u8	readpubek_out_buffer[sizeof(struct tpm_readpubek_params_out)];
+	struct	tpm_getcap_params_in getcap_in;
+} tpm_cmd_params;
+
+struct tpm_cmd_t {
+	tpm_cmd_header	header;
+	tpm_cmd_params	params;
+}__attribute__((packed));
+
+ssize_t	tpm_getcap(struct device *, __be32, cap_t *, const char *);
 
 extern void tpm_get_timeouts(struct tpm_chip *);
 extern void tpm_gen_interrupt(struct tpm_chip *);
-- 
1.5.6.3

