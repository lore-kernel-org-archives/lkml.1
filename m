Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZIUTEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZIUTEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 15:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbZIUTEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 15:04:11 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:50915 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbZIUTEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 15:04:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=A9jTKKQ5ALeW9ZPUh2cPA94xl16qF7Urx20JA4T3cZTRWnmAdDX3ZHev5M4JgbmCPl
         PKL5ckXvVZ71Wx5M3Z5k4zuchGh3Ku3lJ/09ivhTi3kR1iFc9yW9yyAe7vuJO7VXkiWF
         2reoV9wkEj3j7BRW5Grn2dJ4cHmSKKzk44AYY=
Date: Mon, 21 Sep 2009 21:04:34 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: asus_atk0110 not working on Asus P7P55D PRO
Message-ID: <20090921190434.GA10101@dreamland.darkstar.lan>
References: <4AB1C907.1070503@gmail.com>
 <20090920162306.GA18214@dreamland.darkstar.lan>
 <51f3faa70909201047x56313d99q7cdc49bcc4634b01@mail.gmail.com>
 <20090920185824.GA23206@dreamland.darkstar.lan>
 <51f3faa70909201551k70ace90x2b25351bfc04c555@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51f3faa70909201551k70ace90x2b25351bfc04c555@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il Sun, Sep 20, 2009 at 04:51:10PM -0600, Robert Hancock ha scritto: 
> On Sun, Sep 20, 2009 at 12:58 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
> >> >> I'm guessing this board uses a different format than what the driver
> >> >> is expecting. I'm attaching the gzipped decompiled DSDT from the
> >> >> board, hopefully it's useful to somebody..
> >> >
> >> > Please try the following patch, it should detect the proper buffer size.
> >> >
> >>
> >> Obviously something not quite right:
> >
> > Ah yes, the pointer for the output buffer was pointing to the wrong
> > variable. Sorry for that ;)
> 
> Cool, seems to be working.

Excellent :)

> Though the high and critical temperatures
> seem a bit odd, but maybe that's what the BIOS actually reports:
[...]
> CPU Temperature:    +32.5°C  (high = +45.0°C, crit = +45.5°C)
> MB Temperature:     +31.0°C  (high = +45.0°C, crit = +46.0°C)

The limits are declared in the DSDT, the driver doesn't do any
calculation.
It's possible that Asus changed the encoding (again); so far I've been
unable to locate a "version" field that would allow the driver to detect
a change in the data structures.

I've got a new patch for you: instead of probing and preallocating the
buffer this version lets ACPI code do the allocation; the return value
is cached anyway, so there won't be a big number of allocations.
Can you please test and see if it works?

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


thanks,
Luca
-- 
"Perché è così che ti frega, la vita. Ti piglia quando hai ancora l'anima
 addormentata e ti semina dentro un'immagine, o un odore, o un suono che
 poi non te lo togli più. E quella lì era la felicità."
