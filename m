Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbZJEP2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbZJEP2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 11:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbZJEP2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 11:28:35 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:57583 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbZJEP2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 11:28:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qxq4lgBKGlD/703naOklQT6yohWtdFO8B+uqPjlqCZuz9desECzJHt+9SgT9aSPA8f
         o0DhXQqaRUl+mLwpqP9pxAszSDqfMxYe1dk8oaOYV52RsAHtf1BQ/MO+8eb0S5GTe1Hj
         GDHLDhIDjIslKBB2X9UpB/hT5iMXMGO68v1Hw=
Date: Mon, 5 Oct 2009 17:27:51 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Thomas Backlund <tmb@mandriva.org>
Cc: Robert Hancock <hancockrwd@gmail.com>, Jean Delvare <khali@linux-fr.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "astarikovskiy@suse.de" <astarikovskiy@suse.de>
Subject: Re: [PATCH] asus_atk0110: add support for Asus P7P55D
Message-ID: <20091005152751.GA10011@nb-core2.darkstar.lan>
References: <51f3faa70909290740l4f4df186w114bf48e1db3a948@mail.gmail.com>
 <4AC21E7B.70000@mandriva.org>
 <51f3faa70909301638s4eff14edg46420e2e8877fd15@mail.gmail.com>
 <20091001085002.1dbc7eee@hyperion.delvare>
 <51f3faa70910010740s2a412d07qf29f56ad8a3c59eb@mail.gmail.com>
 <20091001144914.GA18675@nb-core2.darkstar.lan>
 <4AC4D6F5.6080005@mandriva.org>
 <68676e00910011205t506604e5y5a0a04fec0821dc0@mail.gmail.com>
 <20091002122636.GA25505@nb-core2.darkstar.lan>
 <4AC665E4.8060200@mandriva.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC665E4.8060200@mandriva.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 11:43:16PM +0300, Thomas Backlund wrote:
> Luca Tettamanti wrote:
> >On Thu, Oct 01, 2009 at 09:05:36PM +0200, Luca Tettamanti wrote:
> >>On Thu, Oct 1, 2009 at 6:21 PM, Thomas Backlund <tmb@mandriva.org> wrote:
> >>>>
> >>>I tried your latest patch on a P7P55D Deluxe and get this:
> >>>>[   10.419119] ACPI Error: Field [PR11] at 64 exceeds Buffer [NULL] size
> >>>>32 (bits) (20090903/dsopcode-596)
> >>>>[   10.419125] ACPI Error (psparse-0537): Method parse/execution failed
> >>>>[\_SB_.PCI0.SBRG.ASOC.GITM] (Node ffff88023f8147a0), AE_AML_BUFFER_LIMIT
> >>>>[   10.419157] ATK0110 ATK0110:00: GITM[0x11060004] ACPI exception:
> >>>>AE_AML_BUFFER_LIMIT
> >>>>[   10.419158] ATK0110 ATK0110:00: Unable to query EC status
> >>>>[   10.419161] ATK0110: probe of ATK0110:00 failed with error -5
> >>I see. GITM probably expects the same buffer structure as SITM, though
> >>in older models the upper bits were never used (hence I never noticed
> >>the problem). Working on a patch.
> >
> >Ok, here it is:
> 
> no go...

Ok, I should have fixed the OOPS.

diff --git a/drivers/hwmon/asus_atk0110.c b/drivers/hwmon/asus_atk0110.c
index fe4fa29..5a3ee00 100644
--- a/drivers/hwmon/asus_atk0110.c
+++ b/drivers/hwmon/asus_atk0110.c
@@ -35,18 +35,22 @@
 #define METHOD_OLD_ENUM_FAN	"FSIF"
 
 #define ATK_MUX_HWMON		0x00000006ULL
+#define ATK_MUX_MGMT		0x00000011ULL
 
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
+#define ATK_ELEMENT_ID_MASK	0x0000ffffULL
+
+#define ATK_EC_ID		0x11060004ULL
 
 enum atk_pack_member {
 	HWMON_PACK_FLAGS,
@@ -89,6 +93,9 @@ struct atk_data {
 	/* new inteface */
 	acpi_handle enumerate_handle;
 	acpi_handle read_handle;
+	acpi_handle write_handle;
+
+	bool disable_ec;
 
 	int voltage_count;
 	int temperature_count;
@@ -129,9 +136,22 @@ struct atk_sensor_data {
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
+/* Input buffer used for GITM and SITM methods */
+struct atk_acpi_input_buf {
+	u32 id;
+	u32 param1;
+	u32 param2;
 };
 
 static int atk_add(struct acpi_device *device);
@@ -439,52 +459,147 @@ static int atk_read_value_old(struct atk_sensor_data *sensor, u64 *value)
 	return 0;
 }
 
-static int atk_read_value_new(struct atk_sensor_data *sensor, u64 *value)
+static union acpi_object *atk_ggrp(struct atk_data *data, u16 mux)
 {
-	struct atk_data *data = sensor->data;
 	struct device *dev = &data->acpi_dev->dev;
+	struct acpi_buffer buf;
+	acpi_status ret;
 	struct acpi_object_list params;
-	struct acpi_buffer ret;
 	union acpi_object id;
-	struct atk_acpi_buffer_u64 tmp;
-	acpi_status status;
+	union acpi_object *pack;
 
 	id.type = ACPI_TYPE_INTEGER;
-	id.integer.value = sensor->id;
-
+	id.integer.value = mux;
 	params.count = 1;
 	params.pointer = &id;
 
-	tmp.buf.type = ACPI_TYPE_BUFFER;
-	tmp.buf.buffer.pointer = (u8 *)&tmp.value;
-	tmp.buf.buffer.length = sizeof(u64);
-	ret.length = sizeof(tmp);
-	ret.pointer = &tmp;
+	buf.length = ACPI_ALLOCATE_BUFFER;
+	ret = acpi_evaluate_object(data->enumerate_handle, NULL, &params, &buf);
+	if (ret != AE_OK) {
+		dev_err(dev, "GGRP[%#x] ACPI exception: %s\n", mux,
+				acpi_format_exception(ret));
+		return ERR_PTR(-EIO);
+	}
+	pack = buf.pointer;
+	if (pack->type != ACPI_TYPE_PACKAGE) {
+		/* Execution was successful, but the id was not found */
+		ACPI_FREE(pack);
+		return ERR_PTR(-ENOENT);
+	}
+
+	if (pack->package.count < 1) {
+		dev_err(dev, "GGRP[%#x] package is too small\n", mux);
+		ACPI_FREE(pack);
+		return ERR_PTR(-EIO);
+	}
+	return pack;
+}
+
+static union acpi_object *atk_gitm(struct atk_data *data, u64 id)
+{
+	struct device *dev = &data->acpi_dev->dev;
+	struct atk_acpi_input_buf buf;
+	union acpi_object tmp;
+	struct acpi_object_list params;
+	struct acpi_buffer ret;
+	union acpi_object *obj;
+	acpi_status status;
+
+	buf.id = id;
+	buf.param1 = 0;
+	buf.param2 = 0;
 
+	tmp.type = ACPI_TYPE_BUFFER;
+	tmp.buffer.pointer = (u8 *)&buf;
+	tmp.buffer.length = sizeof(buf);
+
+	params.count = 1;
+	params.pointer = (void *)&tmp;
+
+	ret.length = ACPI_ALLOCATE_BUFFER;
 	status = acpi_evaluate_object_typed(data->read_handle, NULL, &params,
 			&ret, ACPI_TYPE_BUFFER);
 	if (status != AE_OK) {
-		dev_warn(dev, "%s: ACPI exception: %s\n", __func__,
+		dev_warn(dev, "GITM[%#llx] ACPI exception: %s\n", id,
 				acpi_format_exception(status));
-		return -EIO;
+		return ERR_PTR(-EIO);
+	}
+	obj = ret.pointer;
+
+	/* Sanity check */
+	if (obj->buffer.length < 8) {
+		dev_warn(dev, "Unexpected ASBF length: %u\n",
+				obj->buffer.length);
+		ACPI_FREE(obj);
+		return ERR_PTR(-EIO);
 	}
+	return obj;
+}
 
-	/* Return buffer format:
-	 * [0-3] "value" is valid flag
-	 * [4-7] value
-	 */
-	if (!(tmp.value & 0xffffffff)) {
+static union acpi_object *atk_sitm(struct atk_data *data,
+		struct atk_acpi_input_buf *buf)
+{
+	struct device *dev = &data->acpi_dev->dev;
+	struct acpi_object_list params;
+	union acpi_object tmp;
+	struct acpi_buffer ret;
+	union acpi_object *obj;
+	acpi_status status;
+
+	tmp.type = ACPI_TYPE_BUFFER;
+	tmp.buffer.pointer = (u8 *)buf;
+	tmp.buffer.length = sizeof(*buf);
+
+	params.count = 1;
+	params.pointer = &tmp;
+
+	ret.length = ACPI_ALLOCATE_BUFFER;
+	status = acpi_evaluate_object_typed(data->write_handle, NULL, &params,
+			&ret, ACPI_TYPE_BUFFER);
+	if (status != AE_OK) {
+		dev_warn(dev, "SITM[%#x] ACPI exception: %s\n", buf->id,
+				acpi_format_exception(status));
+		return ERR_PTR(-EIO);
+	}
+	obj = ret.pointer;
+
+	/* Sanity check */
+	if (obj->buffer.length < 8) {
+		dev_warn(dev, "Unexpected ASBF length: %u\n",
+				obj->buffer.length);
+		ACPI_FREE(obj);
+		return ERR_PTR(-EIO);
+	}
+	return obj;
+}
+
+static int atk_read_value_new(struct atk_sensor_data *sensor, u64 *value)
+{
+	struct atk_data *data = sensor->data;
+	struct device *dev = &data->acpi_dev->dev;
+	union acpi_object *obj;
+	struct atk_acpi_ret_buffer *buf;
+	int err = 0;
+
+	obj = atk_gitm(data, sensor->id);
+	if (IS_ERR(obj))
+		return PTR_ERR(obj);
+
+	buf = (struct atk_acpi_ret_buffer *)obj->buffer.pointer;
+	if (buf->flags == 0) {
 		/* The reading is not valid, possible causes:
 		 * - sensor failure
 		 * - enumeration was FUBAR (and we didn't notice)
 		 */
-		dev_info(dev, "Failure: %#llx\n", tmp.value);
-		return -EIO;
+		dev_warn(dev, "Read failed, sensor = %#llx\n", sensor->id);
+		err = -EIO;
+		goto out;
 	}
 
-	*value = (tmp.value & 0xffffffff00000000ULL) >> 32;
-
-	return 0;
+	*value = buf->value;
+out:
+	ACPI_FREE(obj);
+	return err;
 }
 
 static int atk_read_value(struct atk_sensor_data *sensor, u64 *value)
@@ -713,43 +828,141 @@ cleanup:
 	return ret;
 }
 
-static int atk_enumerate_new_hwmon(struct atk_data *data)
+static int atk_ec_present(struct atk_data *data)
 {
 	struct device *dev = &data->acpi_dev->dev;
-	struct acpi_buffer buf;
-	acpi_status ret;
-	struct acpi_object_list params;
-	union acpi_object id;
 	union acpi_object *pack;
-	int err;
+	union acpi_object *ec;
+	int ret;
 	int i;
 
-	dev_dbg(dev, "Enumerating hwmon sensors\n");
+	pack = atk_ggrp(data, ATK_MUX_MGMT);
+	if (IS_ERR(pack)) {
+		if (PTR_ERR(pack) == -ENOENT) {
+			/* The MGMT class does not exists - that's ok */
+			dev_dbg(dev, "Class %#llx not found\n", ATK_MUX_MGMT);
+			return 0;
+		}
+		return PTR_ERR(pack);
+	}
 
-	id.type = ACPI_TYPE_INTEGER;
-	id.integer.value = ATK_MUX_HWMON;
-	params.count = 1;
-	params.pointer = &id;
+	/* Search the EC */
+	ec = NULL;
+	for (i = 0; i < pack->package.count; i++) {
+		union acpi_object *obj = &pack->package.elements[i];
+		union acpi_object *id;
 
-	buf.length = ACPI_ALLOCATE_BUFFER;
-	ret = acpi_evaluate_object_typed(data->enumerate_handle, NULL, &params,
-			&buf, ACPI_TYPE_PACKAGE);
-	if (ret != AE_OK) {
-		dev_warn(dev, METHOD_ENUMERATE ": ACPI exception: %s\n",
-				acpi_format_exception(ret));
-		return -ENODEV;
+		if (obj->type != ACPI_TYPE_PACKAGE)
+			continue;
+
+		id = &obj->package.elements[0];
+		if (id->type != ACPI_TYPE_INTEGER)
+			continue;
+
+		if (id->integer.value == ATK_EC_ID) {
+			ec = obj;
+			break;
+		}
 	}
 
-	/* Result must be a package */
-	pack = buf.pointer;
+	ret = (ec != NULL);
+	if (!ret)
+		/* The system has no EC */
+		dev_dbg(dev, "EC not found\n");
 
-	if (pack->package.count < 1) {
-		dev_dbg(dev, "%s: hwmon package is too small: %d\n", __func__,
-				pack->package.count);
-		err = -EINVAL;
-		goto out;
+	ACPI_FREE(pack);
+	return ret;
+}
+
+static int atk_ec_enabled(struct atk_data *data)
+{
+	struct device *dev = &data->acpi_dev->dev;
+	union acpi_object *obj;
+	struct atk_acpi_ret_buffer *buf;
+	int err;
+
+	obj = atk_gitm(data, ATK_EC_ID);
+	if (IS_ERR(obj)) {
+		dev_err(dev, "Unable to query EC status\n");
+		return PTR_ERR(obj);
+	}
+	buf = (struct atk_acpi_ret_buffer *)obj->buffer.pointer;
+
+	if (buf->flags == 0) {
+		dev_err(dev, "Unable to query EC status\n");
+		err = -EIO;
+	} else {
+		err = (buf->value != 0);
+		dev_dbg(dev, "EC is %sabled\n",
+				err ? "en" : "dis");
+	}
+
+	ACPI_FREE(obj);
+	return err;
+}
+
+static int atk_ec_ctl(struct atk_data *data, int enable)
+{
+	struct device *dev = &data->acpi_dev->dev;
+	union acpi_object *obj;
+	struct atk_acpi_input_buf sitm;
+	struct atk_acpi_ret_buffer *ec_ret;
+	int err = 0;
+
+	sitm.id = ATK_EC_ID;
+	sitm.param1 = enable;
+	sitm.param2 = 0;
+
+	obj = atk_sitm(data, &sitm);
+	if (IS_ERR(obj)) {
+		dev_err(dev, "Failed to %sable the EC\n",
+				enable ? "en" : "dis");
+		return PTR_ERR(obj);
+	}
+	ec_ret = (struct atk_acpi_ret_buffer *)obj->buffer.pointer;
+	if (ec_ret->flags == 0) {
+		dev_err(dev, "Failed to %sable the EC\n",
+				enable ? "en" : "dis");
+		err = -EIO;
+	} else {
+		dev_info(dev, "EC %sabled\n",
+				enable ? "en" : "dis");
+	}
+
+	ACPI_FREE(obj);
+	return err;
+}
+
+static int atk_enumerate_new_hwmon(struct atk_data *data)
+{
+	struct device *dev = &data->acpi_dev->dev;
+	union acpi_object *pack;
+	int err;
+	int i;
+
+	err = atk_ec_present(data);
+	if (err < 0)
+		return err;
+	if (err) {
+		err = atk_ec_enabled(data);
+		if (err < 0)
+			return err;
+		/* If the EC was disabled we will disable it again on unload */
+		data->disable_ec = err;
+
+		err = atk_ec_ctl(data, 1);
+		if (err) {
+			data->disable_ec = false;
+			return err;
+		}
 	}
 
+	dev_dbg(dev, "Enumerating hwmon sensors\n");
+
+	pack = atk_ggrp(data, ATK_MUX_HWMON);
+	if (IS_ERR(pack))
+		return PTR_ERR(pack);
+
 	for (i = 0; i < pack->package.count; i++) {
 		union acpi_object *obj = &pack->package.elements[i];
 
@@ -758,8 +971,7 @@ static int atk_enumerate_new_hwmon(struct atk_data *data)
 
 	err = data->voltage_count + data->temperature_count + data->fan_count;
 
-out:
-	ACPI_FREE(buf.pointer);
+	ACPI_FREE(pack);
 	return err;
 }
 
@@ -895,6 +1107,15 @@ static int atk_check_new_if(struct atk_data *data)
 	}
 	data->read_handle = ret;
 
+	/* De-multiplexer (write) */
+	status = acpi_get_handle(data->atk_handle, METHOD_WRITE, &ret);
+	if (status != AE_OK) {
+		dev_dbg(dev, "method " METHOD_READ " not found: %s\n",
+				 acpi_format_exception(status));
+		return -ENODEV;
+	}
+	data->write_handle = ret;
+
 	return 0;
 }
 
@@ -915,6 +1136,7 @@ static int atk_add(struct acpi_device *device)
 	data->acpi_dev = device;
 	data->atk_handle = device->handle;
 	INIT_LIST_HEAD(&data->sensor_list);
+	data->disable_ec = false;
 
 	buf.length = ACPI_ALLOCATE_BUFFER;
 	ret = acpi_evaluate_object_typed(data->atk_handle, BOARD_ID, NULL,
@@ -973,6 +1195,8 @@ static int atk_add(struct acpi_device *device)
 cleanup:
 	atk_free_sensors(data);
 out:
+	if (data->disable_ec)
+		atk_ec_ctl(data, 0);
 	kfree(data);
 	return err;
 }
@@ -988,6 +1212,11 @@ static int atk_remove(struct acpi_device *device, int type)
 	atk_free_sensors(data);
 	hwmon_device_unregister(data->hwmon_dev);
 
+	if (data->disable_ec) {
+		if (atk_ec_ctl(data, 0))
+			dev_err(&device->dev, "Failed to disable EC\n");
+	}
+
 	kfree(data);
 
 	return 0;


Luca
