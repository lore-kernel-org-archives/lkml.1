Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbZLaPvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbZLaPvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 10:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbZLaPvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 10:51:07 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44132 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbZLaPs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 10:48:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FJv2BgI3xARG7LlwHnAGmS+4TW5SElCnOzcVnW4nVAICw9Sv8RsPzCanA3COzlkWL8
         9xW+EEcsXCAXXJq0SlJDq5WGy1x8G2U7X6scORMDyvv38kkbTm92XyrG42AaIFE8j9O5
         RzUYmEkX3ilpi9yZQkIKFR51GaFwEyyDkqI3c=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 06/13] USB: io_ti: fix DMA buffers on stack
Date: Thu, 31 Dec 2009 16:48:02 +0100
Message-Id: <1262274489-12447-7-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/io_ti.c |   66 ++++++++++++++++++++++++++++++++------------
 1 files changed, 48 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index d4cc0f7..1691f07 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -413,11 +413,18 @@ static int write_boot_mem(struct edgeport_serial *serial,
 {
 	int status = 0;
 	int i;
-	__u8 temp;
+	u8 *temp;
 
 	/* Must do a read before write */
 	if (!serial->TiReadI2C) {
-		status = read_boot_mem(serial, 0, 1, &temp);
+		temp = kmalloc(1, GFP_KERNEL);
+		if (!temp) {
+			dev_err(&serial->serial->dev->dev,
+					"%s - out of memory\n", __func__);
+			return -ENOMEM;
+		}
+		status = read_boot_mem(serial, 0, 1, temp);
+		kfree(temp);
 		if (status)
 			return status;
 	}
@@ -935,37 +942,47 @@ static int build_i2c_fw_hdr(__u8 *header, struct device *dev)
 static int i2c_type_bootmode(struct edgeport_serial *serial)
 {
 	int status;
-	__u8 data;
+	u8 *data;
+
+	data = kmalloc(1, GFP_KERNEL);
+	if (!data) {
+		dev_err(&serial->serial->dev->dev,
+				"%s - out of memory\n", __func__);
+		return -ENOMEM;
+	}
 
 	/* Try to read type 2 */
 	status = ti_vread_sync(serial->serial->dev, UMPC_MEMORY_READ,
-				DTK_ADDR_SPACE_I2C_TYPE_II, 0, &data, 0x01);
+				DTK_ADDR_SPACE_I2C_TYPE_II, 0, data, 0x01);
 	if (status)
 		dbg("%s - read 2 status error = %d", __func__, status);
 	else
-		dbg("%s - read 2 data = 0x%x", __func__, data);
-	if ((!status) && (data == UMP5152 || data == UMP3410)) {
+		dbg("%s - read 2 data = 0x%x", __func__, *data);
+	if ((!status) && (*data == UMP5152 || *data == UMP3410)) {
 		dbg("%s - ROM_TYPE_II", __func__);
 		serial->TI_I2C_Type = DTK_ADDR_SPACE_I2C_TYPE_II;
-		return 0;
+		goto out;
 	}
 
 	/* Try to read type 3 */
 	status = ti_vread_sync(serial->serial->dev, UMPC_MEMORY_READ,
-				DTK_ADDR_SPACE_I2C_TYPE_III, 0,	&data, 0x01);
+				DTK_ADDR_SPACE_I2C_TYPE_III, 0,	data, 0x01);
 	if (status)
 		dbg("%s - read 3 status error = %d", __func__, status);
 	else
-		dbg("%s - read 2 data = 0x%x", __func__, data);
-	if ((!status) && (data == UMP5152 || data == UMP3410)) {
+		dbg("%s - read 2 data = 0x%x", __func__, *data);
+	if ((!status) && (*data == UMP5152 || *data == UMP3410)) {
 		dbg("%s - ROM_TYPE_III", __func__);
 		serial->TI_I2C_Type = DTK_ADDR_SPACE_I2C_TYPE_III;
-		return 0;
+		goto out;
 	}
 
 	dbg("%s - Unknown", __func__);
 	serial->TI_I2C_Type = DTK_ADDR_SPACE_I2C_TYPE_II;
-	return -ENODEV;
+	status = -ENODEV;
+out:
+	kfree(data);
+	return status;
 }
 
 static int bulk_xfer(struct usb_serial *serial, void *buffer,
@@ -1113,7 +1130,7 @@ static int download_fw(struct edgeport_serial *serial)
 				I2C_DESC_TYPE_FIRMWARE_BASIC, rom_desc);
 		if (start_address != 0) {
 			struct ti_i2c_firmware_rec *firmware_version;
-			__u8 record;
+			u8 *record;
 
 			dbg("%s - Found Type FIRMWARE (Type 2) record",
 								__func__);
@@ -1165,6 +1182,15 @@ static int download_fw(struct edgeport_serial *serial)
 				    OperationalMajorVersion,
 				    OperationalMinorVersion);
 
+				record = kmalloc(1, GFP_KERNEL);
+				if (!record) {
+					dev_err(dev, "%s - out of memory.\n",
+							__func__);
+					kfree(firmware_version);
+					kfree(rom_desc);
+					kfree(ti_manuf_desc);
+					return -ENOMEM;
+				}
 				/* In order to update the I2C firmware we must
 				 * change the type 2 record to type 0xF2. This
 				 * will force the UMP to come up in Boot Mode.
@@ -1177,13 +1203,14 @@ static int download_fw(struct edgeport_serial *serial)
 				 * firmware will update the record type from
 				 * 0xf2 to 0x02.
 				 */
-				record = I2C_DESC_TYPE_FIRMWARE_BLANK;
+				*record = I2C_DESC_TYPE_FIRMWARE_BLANK;
 
 				/* Change the I2C Firmware record type to
 				   0xf2 to trigger an update */
 				status = write_rom(serial, start_address,
-						sizeof(record),	&record);
+						sizeof(*record), record);
 				if (status) {
+					kfree(record);
 					kfree(firmware_version);
 					kfree(rom_desc);
 					kfree(ti_manuf_desc);
@@ -1196,19 +1223,21 @@ static int download_fw(struct edgeport_serial *serial)
 				 */
 				status = read_rom(serial,
 							start_address,
-							sizeof(record),
-							&record);
+							sizeof(*record),
+							record);
 				if (status) {
+					kfree(record);
 					kfree(firmware_version);
 					kfree(rom_desc);
 					kfree(ti_manuf_desc);
 					return status;
 				}
 
-				if (record != I2C_DESC_TYPE_FIRMWARE_BLANK) {
+				if (*record != I2C_DESC_TYPE_FIRMWARE_BLANK) {
 					dev_err(dev,
 						"%s - error resetting device\n",
 						__func__);
+					kfree(record);
 					kfree(firmware_version);
 					kfree(rom_desc);
 					kfree(ti_manuf_desc);
@@ -1226,6 +1255,7 @@ static int download_fw(struct edgeport_serial *serial)
 						__func__, status);
 
 				/* return an error on purpose. */
+				kfree(record);
 				kfree(firmware_version);
 				kfree(rom_desc);
 				kfree(ti_manuf_desc);
-- 
1.6.6

