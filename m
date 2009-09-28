Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbZI1NRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbZI1NRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 09:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbZI1NRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 09:17:03 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:34955 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbZI1NRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 09:17:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gzaibmC7DIVRo4LHopAEiqYivAjc1rH3MHjBseYfwVZHbny1ieQI3nA6f+1veGdAio
         g10htTZNcXvrdla0plpaXldUIkuU0hH8h2iouAmuoIX+kRDln8WNs84oe8OxH46a5oP5
         5sY0Xomyl/d3tes6KL/Cjpd3FHI3w3G3dRcOU=
Date: Mon, 28 Sep 2009 15:17:00 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] asus_atk0110: add support for Asus P7P55D
Message-ID: <20090928131700.GA19243@nb-core2.darkstar.lan>
References: <20090923191240.GA15198@dreamland.darkstar.lan>
 <51f3faa70909232018v7e621190m84deb648b08d2135@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51f3faa70909232018v7e621190m84deb648b08d2135@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 09:18:45PM -0600, Robert Hancock wrote:
> On Wed, Sep 23, 2009 at 1:12 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
> > With P7P55D (and newer) boards Asus extended the output buffer (ASBF)
> > making the driver unable to read the data from the sensors.
> > Change the driver to use dynamic buffers (allocated by ACPI core); the
> > return value is cached, so the number of memory allocations is very low.
> >
> > Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
> > Tested-by: Robert Hancock <hancockrwd@gmail.com>
> 
> I just noticed a problem (either with this patch or some other issue
> with the driver on this board): The readings don't seem to be
> updating, I get the same values all the time. (Just now I started
> compiling a kernel and coretemp reports temperatures in the 60 degree
> plus range but atk0110-acpi still reports 35 degrees as it did
> before..)

Hi Robert,
I have a new patch for you :)
It contains the previous changes to handle the bigger ASBF buffer plus a new
method to enable the EC as suggested by Asus. Be sure to compile with
HWMON_DEBUG_CHIP enabled.

diff --git a/drivers/hwmon/asus_atk0110.c b/drivers/hwmon/asus_atk0110.c
index fe4fa29..319618d 100644
--- a/drivers/hwmon/asus_atk0110.c
+++ b/drivers/hwmon/asus_atk0110.c
@@ -35,18 +35,21 @@
 #define METHOD_OLD_ENUM_FAN	"FSIF"
 
 #define ATK_MUX_HWMON		0x00000006ULL
+#define ATK_MUX_EC		0x00000011ULL
 
 #define ATK_CLASS_MASK		0xff000000ULL
 #define ATK_CLASS_FREQ_CTL	0x03000000ULL
 #define ATK_CLASS_FAN_CTL	0x04000000ULL
 #define ATK_CLASS_HWMON		0x06000000ULL
+#define ATK_CLASS_MGMT		0x11000000ULL
 
 #define ATK_TYPE_MASK		0x00ff0000ULL
 #define HWMON_TYPE_VOLT		0x00020000ULL
 #define HWMON_TYPE_TEMP		0x00030000ULL
 #define HWMON_TYPE_FAN		0x00040000ULL
 
-#define HWMON_SENSOR_ID_MASK	0x0000ffffULL
+#define ELEMENT_ID_MASK		0x0000ffffULL
+#define ATK_EC_ID		0x0004
 
 enum atk_pack_member {
 	HWMON_PACK_FLAGS,
@@ -89,6 +92,7 @@ struct atk_data {
 	/* new inteface */
 	acpi_handle enumerate_handle;
 	acpi_handle read_handle;
+	acpi_handle write_handle;
 
 	int voltage_count;
 	int temperature_count;
@@ -129,9 +133,21 @@ struct atk_sensor_data {
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
+};
+
+struct atk_sitm_buffer {
+	u32 id;
+	u32 value1;
+	u32 value2;
 };
 
 static int atk_add(struct acpi_device *device);
@@ -446,8 +462,10 @@ static int atk_read_value_new(struct atk_sensor_data *sensor, u64 *value)
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
@@ -455,11 +473,7 @@ static int atk_read_value_new(struct atk_sensor_data *sensor, u64 *value)
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
@@ -468,23 +482,31 @@ static int atk_read_value_new(struct atk_sensor_data *sensor, u64 *value)
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
@@ -713,6 +735,96 @@ cleanup:
 	return ret;
 }
 
+static int atk_enable_ec(struct atk_data *data)
+{
+	struct device *dev = &data->acpi_dev->dev;
+	struct acpi_buffer buf;
+	acpi_status ret;
+	struct acpi_object_list params;
+	union acpi_object id;
+	union acpi_object *pack;
+	union acpi_object *ec;
+	struct atk_sitm_buffer sitm;
+	int err = 0;
+	u32 ec_ret;
+	int i;
+
+	id.type = ACPI_TYPE_INTEGER;
+	id.integer.value = ATK_MUX_EC;
+	params.count = 1;
+	params.pointer = &id;
+
+	buf.length = ACPI_ALLOCATE_BUFFER;
+	ret = acpi_evaluate_object(data->enumerate_handle, NULL, &params, &buf);
+	if (ret != AE_OK) {
+		dev_warn(dev, METHOD_ENUMERATE ": ACPI exception: %s\n",
+				acpi_format_exception(ret));
+		return -ENODEV;
+	}
+
+	pack = buf.pointer;
+	if (pack->type != ACPI_TYPE_PACKAGE) {
+		/* EC not present in the enumeration - that's ok */
+		dev_dbg(dev, "GGRP: %#llx not found\n", ATK_MUX_EC);
+		goto out;
+	}
+
+	/* Search the EC */
+	ec = NULL;
+	for (i = 0; i < pack->package.count; i++) {
+		union acpi_object *id;
+		union acpi_object *obj = &pack->package.elements[i];
+		if (obj->type != ACPI_TYPE_PACKAGE)
+			continue;
+
+		id = &obj->package.elements[0];
+		if (id->type != ACPI_TYPE_INTEGER)
+			continue;
+
+		if ((id->integer.value & ELEMENT_ID_MASK) == ATK_EC_ID) {
+			ec = obj;
+			break;
+		}
+	}
+	if (ec == NULL) {
+		/* EC not present */
+		dev_dbg(dev, "EC not found\n");
+		goto out;
+	}
+
+	ACPI_FREE(buf.pointer);
+
+	/* Enable */
+	sitm.id = ec->package.elements[0].integer.value & 0xffffffff;
+	sitm.value1 = 1;
+	sitm.value2 = 0;
+	id.type = ACPI_TYPE_BUFFER;
+	id.buffer.pointer = (u8 *)&sitm;
+	id.buffer.length = sizeof(sitm);
+
+	buf.length = ACPI_ALLOCATE_BUFFER;
+
+	ret = acpi_evaluate_object_typed(data->write_handle, NULL, &params,
+			&buf, ACPI_TYPE_BUFFER);
+	if (ret != AE_OK) {
+		/* Failed to enable the EC */
+		dev_warn(dev, "Failed to enable EC: %s\n",
+				acpi_format_exception(ret));
+		err = -ENODEV;
+		goto out;
+	}
+	ec_ret = *(u32 *)(((union acpi_object *)buf.pointer)->buffer.pointer);
+	if (ec_ret == 0) {
+		dev_warn(dev, "Failed to enable EC\n");
+		err = -ENODEV;
+	} else {
+		dev_info(dev, "EC enabled\n");
+	}
+out:
+	ACPI_FREE(buf.pointer);
+	return err;
+}
+
 static int atk_enumerate_new_hwmon(struct atk_data *data)
 {
 	struct device *dev = &data->acpi_dev->dev;
@@ -724,6 +836,10 @@ static int atk_enumerate_new_hwmon(struct atk_data *data)
 	int err;
 	int i;
 
+	err = atk_enable_ec(data);
+	if (err)
+		return err;
+
 	dev_dbg(dev, "Enumerating hwmon sensors\n");
 
 	id.type = ACPI_TYPE_INTEGER;
@@ -895,6 +1011,15 @@ static int atk_check_new_if(struct atk_data *data)
 	}
 	data->read_handle = ret;
 
+	/* De-multiplexer (write) */
+	status = acpi_get_handle(data->atk_handle, METHOD_WRITE, &ret);
+	if (status != AE_OK) {
+		dev_dbg(dev, "method " METHOD_READ " not found: %s\n",
+				acpi_format_exception(status));
+		return -ENODEV;
+	}
+	data->write_handle = ret;
+
 	return 0;
 }
 

Luca
