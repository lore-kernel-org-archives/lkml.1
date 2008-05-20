Return-Path: <linux-kernel-owner+w=401wt.eu-S932694AbYETSGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbYETSGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932318AbYETSGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:06:17 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:3977 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758869AbYETSGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:06:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wkGpgsnE9nylqsBVzBl5/3KR852VYj6QNJZiMGtsBb3DqxPUrzfgUei5qnXjnFypeu3hVlkKTiQh3Q6aT8AxmA9m91i0X/YAtPfwEdOAzxwll9i1GiaHE4xII2QyCDA0r3X89g74FvqyuH5E93HmHP7Zudnuylin6nmegXrdNuQ=
Subject: [PATCH 20/21] drivers: remaining users of aligned-endian get/put
	helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 11:06:09 -0700
Message-Id: <1211306770.5915.170.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/atm/lanai.c                    |    7 +++----
 drivers/cdrom/cdrom.c                  |    2 +-
 drivers/char/pcmcia/cm4040_cs.c        |    2 +-
 drivers/char/tpm/tpm_tis.c             |    4 ++--
 drivers/firewire/fw-card.c             |    2 +-
 drivers/firewire/fw-device.c           |    2 +-
 drivers/firewire/fw-ohci.c             |    3 +--
 drivers/hwmon/ibmpex.c                 |    2 +-
 drivers/input/joystick/xpad.c          |   24 ++++++++----------------
 drivers/input/tablet/wacom_sys.c       |    8 ++------
 drivers/isdn/hardware/eicon/platform.h |    8 ++++----
 11 files changed, 25 insertions(+), 39 deletions(-)

diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
index 144a49f..4ca3ee7 100644
--- a/drivers/atm/lanai.c
+++ b/drivers/atm/lanai.c
@@ -949,7 +949,7 @@ static int __devinit eeprom_read(struct lanai_dev *lanai)
 /* read a big-endian 4-byte value out of eeprom */
 static inline u32 eeprom_be4(const struct lanai_dev *lanai, int address)
 {
-	return be32_to_cpup((const u32 *) &lanai->eeprom[address]);
+	return get_be32(&lanai->eeprom[address]);
 }
 
 /* Checksum/validate EEPROM contents */
@@ -1409,7 +1409,7 @@ static void vcc_rx_aal5(struct lanai_vcc *lvcc, int endptr)
 	 * changes have arrived
 	 */
 	rmb();
-	size = be32_to_cpup(x) & 0xffff;
+	size = get_be32(x) & 0xffff;
 	if (unlikely(n != aal5_size(size))) {
 		/* Make sure size matches padding */
 		printk(KERN_INFO DEV_LABEL "(itf %d): Got bad AAL5 length "
@@ -1728,8 +1728,7 @@ static void run_service(struct lanai_dev *lanai)
 	u32 wreg = reg_read(lanai, ServWrite_Reg);
 	const u32 *end = lanai->service.start + wreg;
 	while (lanai->service.ptr != end) {
-		ntx += handle_service(lanai,
-		    le32_to_cpup(lanai->service.ptr++));
+		ntx += handle_service(lanai, get_le32(lanai->service.ptr++));
 		if (lanai->service.ptr >= lanai->service.end)
 			lanai->service.ptr = lanai->service.start;
 	}
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 69f26eb..88d0dbe 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -3032,7 +3032,7 @@ static int mmc_ioctl(struct cdrom_device_info *cdi, unsigned int cmd,
 		   how much data is available for transfer. buffer[1] is
 		   unfortunately ambigious and the only reliable way seem
 		   to be to simply skip over the block descriptor... */
-		offset = 8 + be16_to_cpu(*(__be16 *)(buffer+6));
+		offset = 8 + get_be16(buffer + 6);
 
 		if (offset + 16 > sizeof(buffer))
 			return -E2BIG;
diff --git a/drivers/char/pcmcia/cm4040_cs.c b/drivers/char/pcmcia/cm4040_cs.c
index 035084c..b4b9457 100644
--- a/drivers/char/pcmcia/cm4040_cs.c
+++ b/drivers/char/pcmcia/cm4040_cs.c
@@ -268,7 +268,7 @@ static ssize_t cm4040_read(struct file *filp, char __user *buf,
 	}
 #endif
 
-	bytes_to_read = 5 + le32_to_cpu(*(__le32 *)&dev->r_buf[1]);
+	bytes_to_read = 5 + get_le32(&dev->r_buf[1]);
 
 	DEBUGP(6, dev, "BytesToRead=%lu\n", bytes_to_read);
 
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 13a4bdd..78369eb 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -228,7 +228,7 @@ static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 		goto out;
 	}
 
-	expected = be32_to_cpu(*(__be32 *) (buf + 2));
+	expected = get_be32(buf + 2);
 	if (expected > count) {
 		size = -EIO;
 		goto out;
@@ -316,7 +316,7 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
 		 chip->vendor.iobase + TPM_STS(chip->vendor.locality));
 
 	if (chip->vendor.irq) {
-		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
+		ordinal = get_be32(buf + 6);
 		if (wait_for_stat
 		    (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 		     tpm_calc_ordinal_duration(chip, ordinal),
diff --git a/drivers/firewire/fw-card.c b/drivers/firewire/fw-card.c
index 5b4c0d9..5f85f24 100644
--- a/drivers/firewire/fw-card.c
+++ b/drivers/firewire/fw-card.c
@@ -204,7 +204,7 @@ complete_bm_lock(struct fw_card *card, int rcode,
 	struct bm_data *bmd = data;
 
 	if (rcode == RCODE_COMPLETE)
-		bmd->old = be32_to_cpu(*(__be32 *) payload);
+		bmd->old = get_be32(payload);
 	bmd->rcode = rcode;
 	complete(&bmd->done);
 }
diff --git a/drivers/firewire/fw-device.c b/drivers/firewire/fw-device.c
index d9c8daf..528eb08 100644
--- a/drivers/firewire/fw-device.c
+++ b/drivers/firewire/fw-device.c
@@ -394,7 +394,7 @@ complete_transaction(struct fw_card *card, int rcode,
 	struct read_quadlet_callback_data *callback_data = data;
 
 	if (rcode == RCODE_COMPLETE)
-		callback_data->data = be32_to_cpu(*(__be32 *)payload);
+		callback_data->data = get_be32(payload);
 	callback_data->rcode = rcode;
 	complete(&callback_data->done);
 }
diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 4f02c55..c50a8d1 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -1780,8 +1780,7 @@ static int handle_ir_dualbuffer_packet(struct context *context,
 		*(u32 *) (ctx->header + i) = __swab32(*(u32 *) (p + 4));
 		memcpy(ctx->header + i + 4, p + 8, ctx->base.header_size - 4);
 		i += ctx->base.header_size;
-		ctx->excess_bytes +=
-			(le32_to_cpu(*(__le32 *)(p + 4)) >> 16) & 0xffff;
+		ctx->excess_bytes += (get_le32(p + 4) >> 16) & 0xffff;
 		p += ctx->base.header_size + 4;
 	}
 	ctx->header_length = i;
diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
index 4e9b19c..d3adc0d 100644
--- a/drivers/hwmon/ibmpex.c
+++ b/drivers/hwmon/ibmpex.c
@@ -40,7 +40,7 @@
 
 static inline u16 extract_value(const char *data, int offset)
 {
-	return be16_to_cpup((u16 *)&data[offset]);
+	return get_be16(&data[offset]);
 }
 
 #define TEMP_SENSOR		1
diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index b29e3af..6633a6e 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -257,16 +257,12 @@ static void xpad_process_packet(struct usb_xpad *xpad, u16 cmd, unsigned char *d
 	struct input_dev *dev = xpad->dev;
 
 	/* left stick */
-	input_report_abs(dev, ABS_X,
-			 (__s16) le16_to_cpup((__le16 *)(data + 12)));
-	input_report_abs(dev, ABS_Y,
-			 ~(__s16) le16_to_cpup((__le16 *)(data + 14)));
+	input_report_abs(dev, ABS_X, (__s16)get_le16(data + 12));
+	input_report_abs(dev, ABS_Y, ~(__s16)get_le16(data + 14));
 
 	/* right stick */
-	input_report_abs(dev, ABS_RX,
-			 (__s16) le16_to_cpup((__le16 *)(data + 16)));
-	input_report_abs(dev, ABS_RY,
-			 ~(__s16) le16_to_cpup((__le16 *)(data + 18)));
+	input_report_abs(dev, ABS_RX, (__s16)get_le16(data + 16));
+	input_report_abs(dev, ABS_RY, ~(__s16)get_le16(data + 18));
 
 	/* triggers left/right */
 	input_report_abs(dev, ABS_Z, data[10]);
@@ -351,16 +347,12 @@ static void xpad360_process_packet(struct usb_xpad *xpad,
 	input_report_key(dev, BTN_MODE,	data[3] & 0x04);
 
 	/* left stick */
-	input_report_abs(dev, ABS_X,
-			 (__s16) le16_to_cpup((__le16 *)(data + 6)));
-	input_report_abs(dev, ABS_Y,
-			 ~(__s16) le16_to_cpup((__le16 *)(data + 8)));
+	input_report_abs(dev, ABS_X, (__s16)get_le16(data + 6));
+	input_report_abs(dev, ABS_Y, ~(__s16)get_le16(data + 8));
 
 	/* right stick */
-	input_report_abs(dev, ABS_RX,
-			 (__s16) le16_to_cpup((__le16 *)(data + 10)));
-	input_report_abs(dev, ABS_RY,
-			 ~(__s16) le16_to_cpup((__le16 *)(data + 12)));
+	input_report_abs(dev, ABS_RX, (__s16)get_le16(data + 10));
+	input_report_abs(dev, ABS_RY, ~(__s16)get_le16(data + 12));
 
 	/* triggers left/right */
 	input_report_abs(dev, ABS_Z, data[4]);
diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 71cc0c1..71788dc 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -103,16 +103,12 @@ void wacom_input_event(void *wcombo, unsigned int type, unsigned int code, int v
 
 __u16 wacom_be16_to_cpu(unsigned char *data)
 {
-	__u16 value;
-	value = be16_to_cpu(*(__be16 *) data);
-	return value;
+	return get_be16(data);
 }
 
 __u16 wacom_le16_to_cpu(unsigned char *data)
 {
-	__u16 value;
-	value = le16_to_cpu(*(__le16 *) data);
-	return value;
+	return get_le16(data);
 }
 
 void wacom_input_sync(void *wcombo)
diff --git a/drivers/isdn/hardware/eicon/platform.h b/drivers/isdn/hardware/eicon/platform.h
index 15d4942..a11d766 100644
--- a/drivers/isdn/hardware/eicon/platform.h
+++ b/drivers/isdn/hardware/eicon/platform.h
@@ -325,19 +325,19 @@ diva_os_atomic_decrement(diva_os_atomic_t* pv)
 
 static inline __u16 GET_WORD(void *addr)
 {
-	return le16_to_cpu(*(__le16 *)addr);
+	return get_le16(addr);
 }
 static inline __u32 GET_DWORD(void *addr)
 {
-	return le32_to_cpu(*(__le32 *)addr);
+	return get_le32(addr);
 }
 static inline void PUT_WORD(void *addr, __u16 v)
 {
-	*(__le16 *)addr = cpu_to_le16(v);
+	put_le16(v, addr);
 }
 static inline void PUT_DWORD(void *addr, __u32 v)
 {
-	*(__le32 *)addr = cpu_to_le32(v);
+	put_le32(v, addr);
 }
 
 /*
-- 
1.5.5.1.570.g26b5e


