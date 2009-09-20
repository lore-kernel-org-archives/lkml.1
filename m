Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbZITQWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbZITQWp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 12:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbZITQWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 12:22:44 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:45620 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbZITQWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 12:22:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=R0ycPn1btvaojMMy0H9O7onSvZ9TluX04rRLP6Y6FDm/qQ2CNnJ/HFLLtKmflEG5TI
         z05TZs4U4TM1J1BNlfa/OX+GlaZ+ofBx4tds8G+rCNRTX7CrzqDljRaGQpZmgySfdJVk
         8VTEO5zn5Js2vn2dU/+aE+SfetP9ARC6mwdYw=
Date: Sun, 20 Sep 2009 18:23:06 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: asus_atk0110 not working on Asus P7P55D PRO
Message-ID: <20090920162306.GA18214@dreamland.darkstar.lan>
References: <4AB1C907.1070503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB1C907.1070503@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il Wed, Sep 16, 2009 at 11:28:39PM -0600, Robert Hancock ha scritto: 
> Just built a new system with an Asus P7P55D PRO motherboard. The
> ATK0110 driver doesn't seem to be able to retrieve any hardware
> monitoring parameters successfully, sensors gives:
> 
> atk0110-acpi-0
> Adapter: ACPI interface
> ERROR: Can't get value of subfeature in0_input: I/O error
> Vcore Voltage:      +0.00 V  (min =  +0.80 V, max =  +1.60 V)
> ERROR: Can't get value of subfeature in1_input: I/O error
> +3.3V Voltage:      +0.00 V  (min =  +2.97 V, max =  +3.63 V)
> ERROR: Can't get value of subfeature in2_input: I/O error
> +5V Voltage:        +0.00 V  (min =  +4.50 V, max =  +5.50 V)
> 
> etc. and dmesg spits out a bunch of these:
> 
> ATK0110 ATK0110:00: atk_read_value_new: ACPI exception: AE_BUFFER_OVERFLOW
> 
> I'm guessing this board uses a different format than what the driver
> is expecting. I'm attaching the gzipped decompiled DSDT from the
> board, hopefully it's useful to somebody..

Please try the following patch, it should detect the proper buffer size.

diff --git a/drivers/hwmon/asus_atk0110.c b/drivers/hwmon/asus_atk0110.c
index fe4fa29..4f6f5ec 100644
--- a/drivers/hwmon/asus_atk0110.c
+++ b/drivers/hwmon/asus_atk0110.c
@@ -75,6 +75,13 @@ enum atk_pack_member {
 #define _HWMON_OLD_PACK_ENABLE	4
 
 
+struct atk_acpi_out_buffer {
+	union acpi_object buf;
+	u32 flags;
+	u32 value;
+	u8 data[];
+};
+
 struct atk_data {
 	struct device *hwmon_dev;
 	acpi_handle atk_handle;
@@ -94,6 +101,10 @@ struct atk_data {
 	int temperature_count;
 	int fan_count;
 	struct list_head sensor_list;
+	
+	struct atk_acpi_out_buffer *buffer;
+	size_t buffer_size;
+	struct mutex buffer_lock;
 };
 
 
@@ -129,11 +140,6 @@ struct atk_sensor_data {
 	char const *acpi_name;
 };
 
-struct atk_acpi_buffer_u64 {
-	union acpi_object buf;
-	u64 value;
-};
-
 static int atk_add(struct acpi_device *device);
 static int atk_remove(struct acpi_device *device, int type);
 static void atk_print_sensor(struct atk_data *data, union acpi_object *obj);
@@ -446,8 +452,9 @@ static int atk_read_value_new(struct atk_sensor_data *sensor, u64 *value)
 	struct acpi_object_list params;
 	struct acpi_buffer ret;
 	union acpi_object id;
-	struct atk_acpi_buffer_u64 tmp;
+	union acpi_object buf;
 	acpi_status status;
+	int err = 0;
 
 	id.type = ACPI_TYPE_INTEGER;
 	id.integer.value = sensor->id;
@@ -455,36 +462,35 @@ static int atk_read_value_new(struct atk_sensor_data *sensor, u64 *value)
 	params.count = 1;
 	params.pointer = &id;
 
-	tmp.buf.type = ACPI_TYPE_BUFFER;
-	tmp.buf.buffer.pointer = (u8 *)&tmp.value;
-	tmp.buf.buffer.length = sizeof(u64);
-	ret.length = sizeof(tmp);
-	ret.pointer = &tmp;
+	mutex_lock(&data->buffer_lock);
+
+	ret.length = data->buffer_size;
+	ret.pointer = &buf;
 
 	status = acpi_evaluate_object_typed(data->read_handle, NULL, &params,
 			&ret, ACPI_TYPE_BUFFER);
 	if (status != AE_OK) {
 		dev_warn(dev, "%s: ACPI exception: %s\n", __func__,
 				acpi_format_exception(status));
-		return -EIO;
+		err = -EIO;
+		goto out;
 	}
 
-	/* Return buffer format:
-	 * [0-3] "value" is valid flag
-	 * [4-7] value
-	 */
-	if (!(tmp.value & 0xffffffff)) {
+	if (!data->buffer->flags) {
 		/* The reading is not valid, possible causes:
 		 * - sensor failure
 		 * - enumeration was FUBAR (and we didn't notice)
 		 */
-		dev_info(dev, "Failure: %#llx\n", tmp.value);
-		return -EIO;
+		dev_info(dev, "Failure: %#x\n", data->buffer->flags);
+	
+		err = -EIO;
+		goto out;
 	}
 
-	*value = (tmp.value & 0xffffffff00000000ULL) >> 32;
-
-	return 0;
+	*value = data->buffer->value;
+out:
+	mutex_unlock(&data->buffer_lock);
+	return err;
 }
 
 static int atk_read_value(struct atk_sensor_data *sensor, u64 *value)
@@ -721,11 +727,40 @@ static int atk_enumerate_new_hwmon(struct atk_data *data)
 	struct acpi_object_list params;
 	union acpi_object id;
 	union acpi_object *pack;
+	union acpi_object *asbf;
 	int err;
 	int i;
 
 	dev_dbg(dev, "Enumerating hwmon sensors\n");
 
+	/* Probe ASBF */
+	buf.length = ACPI_ALLOCATE_BUFFER;
+	ret = acpi_evaluate_object_typed(data->atk_handle, "ASBF", NULL, &buf,
+			ACPI_TYPE_BUFFER);
+	if (ret != AE_OK) {
+		dev_warn(dev, "Failed to evaluate ASBF: %s\n",
+				acpi_format_exception(ret));
+		return -ENODEV;
+	}
+	asbf = buf.pointer;
+	data->buffer_size = asbf->buffer.length;
+	ACPI_FREE(buf.pointer);
+	buf.pointer = NULL;
+	
+	dev_dbg(dev, "ASBF buffer size: %zu\n", data->buffer_size);
+	/* Sanity check */
+	if (data->buffer_size < 8 || data->buffer_size > 512) {
+		dev_warn(dev, "Invalid ASBF buffer size: %zu\n",
+				data->buffer_size);
+		return -EINVAL;
+	}
+	data->buffer_size += sizeof(union acpi_object);
+
+	data->buffer = kzalloc(data->buffer_size, GFP_KERNEL);
+	if (!data->buffer)
+		return -ENOMEM;
+	mutex_init(&data->buffer_lock);
+
 	id.type = ACPI_TYPE_INTEGER;
 	id.integer.value = ATK_MUX_HWMON;
 	params.count = 1;
@@ -737,7 +772,8 @@ static int atk_enumerate_new_hwmon(struct atk_data *data)
 	if (ret != AE_OK) {
 		dev_warn(dev, METHOD_ENUMERATE ": ACPI exception: %s\n",
 				acpi_format_exception(ret));
-		return -ENODEV;
+		err = -ENODEV;
+		goto out;
 	}
 
 	/* Result must be a package */
@@ -759,6 +795,8 @@ static int atk_enumerate_new_hwmon(struct atk_data *data)
 	err = data->voltage_count + data->temperature_count + data->fan_count;
 
 out:
+	if (err < 0)
+		kfree(data->buffer);
 	ACPI_FREE(buf.pointer);
 	return err;
 }
@@ -988,6 +1026,7 @@ static int atk_remove(struct acpi_device *device, int type)
 	atk_free_sensors(data);
 	hwmon_device_unregister(data->hwmon_dev);
 
+	kfree(data->buffer);
 	kfree(data);
 
 	return 0;

Luca
-- 
"La vita potrebbe non avere alcun significato. Oppure, ancora peggio,
 potrebbe averne uno che disapprovo". -- Ashleigh Brilliant
