Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbZIWTMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbZIWTMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 15:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbZIWTMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 15:12:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:59699 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbZIWTMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 15:12:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=p6yXffU0jWBhD534M7BOPIB1MQp9d6mMVlbub6HNGULMRNhKkhubBcYkwvJKgAVjew
         7+i7bIsBeL4Kv+RmlJu0LAG5UHXh2MnkOFzve5fhTyRrER82sCF3CG1pGUQJmy5VQZZQ
         9ofGbOpp794qTPXlWT+DxenFsLJL9Y0Q4eu6w=
Date: Wed, 23 Sep 2009 21:12:41 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: lm-sensors@lm-sensors.org
Cc: linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
       Robert Hancock <hancockrwd@gmail.com>
Subject: [PATCH] asus_atk0110: add support for Asus P7P55D
Message-ID: <20090923191240.GA15198@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With P7P55D (and newer) boards Asus extended the output buffer (ASBF)
making the driver unable to read the data from the sensors.
Change the driver to use dynamic buffers (allocated by ACPI core); the
return value is cached, so the number of memory allocations is very low.

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
Tested-by: Robert Hancock <hancockrwd@gmail.com>

---
 drivers/hwmon/asus_atk0110.c |   50 ++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/hwmon/asus_atk0110.c b/drivers/hwmon/asus_atk0110.c
index fe4fa29..aed6e90 100644
--- a/drivers/hwmon/asus_atk0110.c
+++ b/drivers/hwmon/asus_atk0110.c
@@ -129,9 +129,15 @@ struct atk_sensor_data {
 	char const *acpi_name;
 };
 
-struct atk_acpi_buffer_u64 {
-	union acpi_object buf;
-	u64 value;
+/* Return buffer format:
+ * [0-3] "value" is valid flag
+ * [4-7] value
+ * [8- ] unknown stuff on newer mobos
+ */
+struct atk_acpi_ret_buffer {
+	u32 flags;
+	u32 value;
+	u8 data[];
 };
 
 static int atk_add(struct acpi_device *device);
@@ -446,8 +452,10 @@ static int atk_read_value_new(struct atk_sensor_data *sensor, u64 *value)
 	struct acpi_object_list params;
 	struct acpi_buffer ret;
 	union acpi_object id;
-	struct atk_acpi_buffer_u64 tmp;
+	union acpi_object *obj;
+	struct atk_acpi_ret_buffer *buf;
 	acpi_status status;
+	int err = 0;
 
 	id.type = ACPI_TYPE_INTEGER;
 	id.integer.value = sensor->id;
@@ -455,11 +463,7 @@ static int atk_read_value_new(struct atk_sensor_data *sensor, u64 *value)
 	params.count = 1;
 	params.pointer = &id;
 
-	tmp.buf.type = ACPI_TYPE_BUFFER;
-	tmp.buf.buffer.pointer = (u8 *)&tmp.value;
-	tmp.buf.buffer.length = sizeof(u64);
-	ret.length = sizeof(tmp);
-	ret.pointer = &tmp;
+	ret.length = ACPI_ALLOCATE_BUFFER;
 
 	status = acpi_evaluate_object_typed(data->read_handle, NULL, &params,
 			&ret, ACPI_TYPE_BUFFER);
@@ -468,23 +472,31 @@ static int atk_read_value_new(struct atk_sensor_data *sensor, u64 *value)
 				acpi_format_exception(status));
 		return -EIO;
 	}
+	obj = ret.pointer;
 
-	/* Return buffer format:
-	 * [0-3] "value" is valid flag
-	 * [4-7] value
-	 */
-	if (!(tmp.value & 0xffffffff)) {
+	/* Sanity check */
+	if (obj->buffer.length < 8) {
+		dev_warn(dev, "Unexpected ASBF length: %u\n",
+				obj->buffer.length);
+		err = -EIO;
+		goto out;
+	}
+	buf = (struct atk_acpi_ret_buffer *)obj->buffer.pointer;
+
+	if (!buf->flags) {
 		/* The reading is not valid, possible causes:
 		 * - sensor failure
 		 * - enumeration was FUBAR (and we didn't notice)
 		 */
-		dev_info(dev, "Failure: %#llx\n", tmp.value);
-		return -EIO;
+		dev_warn(dev, "Failure: %#x\n", buf->flags);
+		err = -EIO;
+		goto out;
 	}
 
-	*value = (tmp.value & 0xffffffff00000000ULL) >> 32;
-
-	return 0;
+	*value = buf->value;
+out:
+	ACPI_FREE(ret.pointer);
+	return err;
 }
 
 static int atk_read_value(struct atk_sensor_data *sensor, u64 *value)


Luca
-- 
Al termine di un pranzo di nozze mi hanno dato un
amaro alle erbe cosi' schifoso che perfino sull'etichetta
c'era un frate che vomitava.
