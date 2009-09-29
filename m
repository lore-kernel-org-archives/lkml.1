Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbZI2JUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbZI2JUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 05:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZI2JUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 05:20:44 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:52784 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbZI2JUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 05:20:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BadDxucedMWhOwAUArWOKyanJF3y7lLRw4W+KRlZoC/0Xd+Xvsi07mSbjpsfFGcuMV
         XFPlsFq22QkaOuRDTNIkSbvOUBD2LES+fiq+44SnhrTQm3emp5nsYM0m+8887amUP8es
         40ZSpFwURoPhaFsximE8MLtcCAn9uTJ1t0+GE=
MIME-Version: 1.0
In-Reply-To: <1254188280-29155-1-git-send-email-cascardo@holoscopio.com>
References: <1254188280-29155-1-git-send-email-cascardo@holoscopio.com>
Date: Tue, 29 Sep 2009 10:20:44 +0100
Message-ID: <9b2b86520909290220g6b5f6beal6337b17f1bdd339@mail.gmail.com>
Subject: Re: [PATCH] cmpc_acpi: Added support for Classmate PC ACPI devices.
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com, don@syst.com.br,
       linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/29/09, Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:
> This add supports for devices like keyboard, backlight, tablet and
> accelerometer.
>
> This work is supported by International Syst S/A.
>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Hi!

In general this driver was a pleasure to read.  It looks like you have
a nice and clean ACPI interface to work with.  I haven't seen anything
quite like the cmpc_{add,remove}_acpi_notify_device() functions
before, but they make a lot of sense here.

But I do have a few comments :-).

The "-laptop" naming convention is more informative than "-acpi".
Perhaps this driver should be called "classmate-laptop".  I would keep
the cmpc_ prefix in the source code though.

More comments inline.

> +/*
> + * Generic input device code.
> + */
> +
> +typedef void (*input_device_init)(struct input_dev *dev);
> +
> +static int cmpc_add_acpi_notify_device(struct acpi_device *acpi, char
> *name,
> +				       acpi_notify_handler handler,
> +				       input_device_init idev_init)
> +{
> +	struct input_dev *inputdev;
> +	acpi_status status;
> +	int error;
> +	inputdev = input_allocate_device();
> +	if (!inputdev) {
> +		error = -ENOMEM;
> +		goto out;
> +	}
> +	inputdev->name = name;
> +	inputdev->dev.parent = &acpi->dev;
> +	idev_init(inputdev);
> +	error = input_register_device(inputdev);
> +	if (error)
> +		goto err_reg;
> +	dev_set_drvdata(&acpi->dev, inputdev);
> +	status = acpi_install_notify_handler(acpi->handle, ACPI_DEVICE_NOTIFY,
> +					     handler, inputdev);
> +	if (ACPI_FAILURE(status)) {
> +		error = -ENODEV;
> +		goto err_acpi;
> +	}
> +	return 0;
> +err_acpi:
> +	input_unregister_device(inputdev);
> +err_reg:
> +	input_free_device(inputdev);
> +out:
> +	return error;
> +}
> +
> +static int cmpc_remove_acpi_notify_device(struct acpi_device *acpi,
> +					  acpi_notify_handler handler)
> +{
> +	struct input_dev *inputdev;
> +	acpi_status status;
> +	status = acpi_remove_notify_handler(acpi->handle, ACPI_DEVICE_NOTIFY,
> +					    handler);
> +	inputdev = dev_get_drvdata(&acpi->dev);
> +	input_unregister_device(inputdev);
> +	input_free_device(inputdev);

Dmitry the input maintainer says "input_free_device() should not be
called after input_unregister_device()." (This also applies to the
error handling in add_acpi_notify_device()).

> +	return 0;
> +}
> +
> +
> +/*
> + * Accelerometer code.
> + */
> +
> +static acpi_status cmpc_start_accel(acpi_handle handle)
> +{
> +	union acpi_object param[2];
> +	struct acpi_object_list input;
> +	acpi_status status;
> +	param[0].type = ACPI_TYPE_INTEGER;
> +	param[0].integer.value = 0x3;
> +	param[1].type = ACPI_TYPE_INTEGER;
> +	input.count = 2;
> +	input.pointer = param;
> +	status = acpi_evaluate_object(handle, "ACMD", &input, NULL);
> +	return status;
> +}
> +
> +static acpi_status cmpc_stop_accel(acpi_handle handle)
> +{
> +	union acpi_object param[2];
> +	struct acpi_object_list input;
> +	acpi_status status;
> +	param[0].type = ACPI_TYPE_INTEGER;
> +	param[0].integer.value = 0x4;
> +	param[1].type = ACPI_TYPE_INTEGER;
> +	input.count = 2;
> +	input.pointer = param;
> +	status = acpi_evaluate_object(handle, "ACMD", &input, NULL);
> +	return status;
> +}
> +
> +static acpi_status cmpc_accel_set_sense(acpi_handle handle, int val)
> +{
> +	union acpi_object param[2];
> +	struct acpi_object_list input;
> +	param[0].type = ACPI_TYPE_INTEGER;
> +	param[0].integer.value = 0x02;
> +	param[1].type = ACPI_TYPE_INTEGER;
> +	param[1].integer.value = val;
> +	input.count = 2;
> +	input.pointer = param;
> +	return acpi_evaluate_object(handle, "ACMD", &input, NULL);
> +}
> +
> +static acpi_status cmpc_get_accel(acpi_handle handle,
> +				  unsigned char *x,
> +				  unsigned char *y,
> +				  unsigned char *z)
> +{
> +	union acpi_object param[2];
> +	struct acpi_object_list input;
> +	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, 0 };
> +	unsigned char *locs;
> +	acpi_status status;
> +	param[0].type = ACPI_TYPE_INTEGER;
> +	param[0].integer.value = 0x01;
> +	param[1].type = ACPI_TYPE_INTEGER;
> +	input.count = 2;
> +	input.pointer = param;
> +	status = acpi_evaluate_object(handle, "ACMD", &input, &output);
> +	if (ACPI_SUCCESS(status)) {
> +		union acpi_object *obj;
> +		obj = output.pointer;
> +		locs = obj->buffer.pointer;
> +		*x = locs[0];
> +		*y = locs[1];
> +		*z = locs[2];
> +		kfree(output.pointer);
> +	}
> +	return status;
> +}
> +
> +static void cmpc_accel_handler(acpi_handle handle, u32 event, void *ctx)
> +{
> +	struct input_dev *inputdev = ctx;
> +	acpi_status status;
> +	unsigned char x, y, z;
> +	if (event == 0x81) {
> +		status = cmpc_get_accel(handle, &x, &y, &z);
> +		if (ACPI_SUCCESS(status)) {
> +			input_report_abs(inputdev, ABS_X, x);
> +			input_report_abs(inputdev, ABS_Y, y);
> +			input_report_abs(inputdev, ABS_Z, z);
> +			input_sync(inputdev);
> +		}
> +	}
> +}
> +
> +static ssize_t cmpc_accel_sense_store(struct device *dev,
> +				      struct device_attribute *attr,
> +				      const char *buf, size_t count)
> +{
> +	struct acpi_device *acpi;
> +	int sense;
> +	acpi = to_acpi_device(dev);
> +	if (sscanf(buf, "%d", &sense) <= 0)
> +		return -EINVAL;
> +	cmpc_accel_set_sense(acpi->handle, sense);
> +	return strnlen(buf, count);
> +}
> +
> +struct device_attribute cmpc_accel_sense_attr = {
> +	.attr = { .name = "sense", .mode = 0220 },
> +	.store = cmpc_accel_sense_store
> +};

What does this do?  What range of values can it take?  Is it a common
attribute for input devices, or does it need specific documentation?

Would it make sense for the driver to initialize it to a default
value, so that we would always know what the current value is, and
provide a .show() method as well?

> +
> +static int cmpc_accel_open(struct input_dev *input)
> +{
> +	struct acpi_device *acpi;
> +	acpi = to_acpi_device(input->dev.parent);
> +	if (ACPI_SUCCESS(cmpc_start_accel(acpi->handle)))
> +		return 0;
> +	return -EIO;
> +}
> +
> +static void cmpc_accel_close(struct input_dev *input)
> +{
> +	struct acpi_device *acpi;
> +	acpi = to_acpi_device(input->dev.parent);
> +	cmpc_stop_accel(acpi->handle);
> +}
> +
> +static void cmpc_accel_idev_init(struct input_dev *inputdev)
> +{
> +	set_bit(EV_ABS, inputdev->evbit);
> +	input_set_abs_params(inputdev, ABS_X, 0, 255, 8, 0);
> +	input_set_abs_params(inputdev, ABS_Y, 0, 255, 8, 0);
> +	input_set_abs_params(inputdev, ABS_Z, 0, 255, 8, 0);
> +	inputdev->open = cmpc_accel_open;
> +	inputdev->close = cmpc_accel_close;
> +}
> +
> +static int cmpc_accel_add(struct acpi_device *acpi)
> +{
> +	int error;
> +	error = device_create_file(&acpi->dev, &cmpc_accel_sense_attr);
> +	if (error)
> +		return error;
> +	return cmpc_add_acpi_notify_device(acpi, "cmpc_accel",
> +					   cmpc_accel_handler,
> +					   cmpc_accel_idev_init);
> +}
> +
> +static int cmpc_accel_remove(struct acpi_device *acpi, int type)
> +{
> +	device_remove_file(&acpi->dev, &cmpc_accel_sense_attr);
> +	return cmpc_remove_acpi_notify_device(acpi, cmpc_accel_handler);
> +}
> +
> +static const struct acpi_device_id cmpc_accel_device_ids[] = {
> +	{"ACCE0000", 0},
> +	{"", 0}
> +};
> +MODULE_DEVICE_TABLE(acpi, cmpc_accel_device_ids);
> +
> +static struct acpi_driver cmpc_accel_acpi_driver = {
> +	.name = "cmpc_accel",
> +	.class = "cmpc_accel",
> +	.ids = cmpc_accel_device_ids,
> +	.ops = {
> +		.add = cmpc_accel_add,
> +		.remove = cmpc_accel_remove
> +	}

Could you please set

	.owner = THIS_MODULE,

on all the acpi drivers?  It will provide data in
/sys/module/cmpc_acpi/drivers and
/sys/bus/acpi/drivers/<driver>/module.  It seems to be forgotten
knowledge, but I'm trying to revive it :-).

> +};
> +
> +static bool cmpc_accel_driver_registered;
> +
> +
> +/*
> + * Tablet mode code.
> + */
> +static acpi_status cmpc_get_tablet(acpi_handle handle,
> +				   unsigned long long *value)
> +{
> +	union acpi_object param;
> +	struct acpi_object_list input;
> +	unsigned long long output;
> +	acpi_status status;
> +	param.type = ACPI_TYPE_INTEGER;
> +	param.integer.value = 0x01;
> +	input.count = 1;
> +	input.pointer = &param;
> +	status = acpi_evaluate_integer(handle, "TCMD", &input, &output);
> +	if (ACPI_SUCCESS(status))
> +		*value = output;
> +	return status;
> +}
> +
> +static void cmpc_tablet_handler(acpi_handle handle, u32 event, void *ctx)
> +{
> +	unsigned long long val = 0;
> +	struct input_dev *inputdev = ctx;
> +	if (event == 0x81) {
> +		if (ACPI_SUCCESS(cmpc_get_tablet(handle, &val)))
> +			input_report_switch(inputdev, SW_TABLET_MODE, !val);
> +	}
> +}
> +
> +static void cmpc_tablet_idev_init(struct input_dev *inputdev)
> +{
> +	set_bit(EV_SW, inputdev->evbit);
> +	set_bit(SW_TABLET_MODE, inputdev->swbit);

Don't you need to initialize the switch value here?

Also, have you tested this with changing the switch value while
suspended?  I _think_ you need to update the switch state on resume.
This is purely from looking at other acpi drivers and their evolution;
I don't have any practical experience with input drivers.

> +}
> +
> +static int cmpc_tablet_add(struct acpi_device *acpi)
> +{
> +	return cmpc_add_acpi_notify_device(acpi, "cmpc_tablet",
> +					   cmpc_tablet_handler,
> +					   cmpc_tablet_idev_init);
> +}
> +
> +static int cmpc_tablet_remove(struct acpi_device *acpi, int type)
> +{
> +	return cmpc_remove_acpi_notify_device(acpi, cmpc_tablet_handler);
> +}
> +
> +static const struct acpi_device_id cmpc_tablet_device_ids[] = {
> +	{"TBLT0000", 0},
> +	{"", 0}
> +};
> +MODULE_DEVICE_TABLE(acpi, cmpc_tablet_device_ids);
> +
> +static struct acpi_driver cmpc_tablet_acpi_driver = {
> +	.name = "cmpc_tablet",
> +	.class = "cmpc_tablet",
> +	.ids = cmpc_tablet_device_ids,
> +	.ops = {
> +		.add = cmpc_tablet_add,
> +		.remove = cmpc_tablet_remove
> +	}
> +};
> +
> +static bool cmpc_tablet_driver_registered;
> +
> +
> +/*
> + * Backlight code.
> + */
> +
> +static acpi_status cmpc_get_brightness(acpi_handle handle,
> +				       unsigned long long *value)
> +{
> +	union acpi_object param;
> +	struct acpi_object_list input;
> +	unsigned long long output;
> +	acpi_status status;
> +	param.type = ACPI_TYPE_INTEGER;
> +	param.integer.value = 0xC0;
> +	input.count = 1;
> +	input.pointer = &param;
> +	status = acpi_evaluate_integer(handle, "GRDI", &input, &output);
> +	if (ACPI_SUCCESS(status))
> +		*value = output;
> +	return status;
> +}
> +
> +static acpi_status cmpc_set_brightness(acpi_handle handle,
> +				       unsigned long long value)
> +{
> +	union acpi_object param[2];
> +	struct acpi_object_list input;
> +	acpi_status status;
> +	unsigned long long output;
> +	param[0].type = ACPI_TYPE_INTEGER;
> +	param[0].integer.value = 0xC0;
> +	param[1].type = ACPI_TYPE_INTEGER;
> +	param[1].integer.value = value;
> +	input.count = 2;
> +	input.pointer = param;
> +	status = acpi_evaluate_integer(handle, "GWRI", &input, &output);
> +	return status;
> +}
> +
> +static int cmpc_bl_get_brightness(struct backlight_device *bd)
> +{
> +	acpi_status status;
> +	acpi_handle handle;
> +	unsigned long long brightness;
> +	handle = bl_get_data(bd);
> +	status = cmpc_get_brightness(handle, &brightness);
> +	if (ACPI_SUCCESS(status))
> +		return brightness;
> +	else
> +		return -1;
> +}
> +
> +static int cmpc_bl_update_status(struct backlight_device *bd)
> +{
> +	acpi_status status;
> +	acpi_handle handle;
> +	handle = bl_get_data(bd);
> +	status = cmpc_set_brightness(handle, bd->props.brightness);
> +	if (ACPI_SUCCESS(status))
> +		return 0;
> +	else
> +		return -1;
> +}
> +
> +static struct backlight_ops cmpc_bl_ops = {
> +	.get_brightness = cmpc_bl_get_brightness,
> +	.update_status = cmpc_bl_update_status
> +};
> +
> +static int cmpc_bl_add(struct acpi_device *acpi)
> +{
> +	struct backlight_device *bd;
> +	bd = backlight_device_register("cmpc_bl", &acpi->dev,
> +				       acpi->handle, &cmpc_bl_ops);
> +	bd->props.max_brightness = 7;
> +	dev_set_drvdata(&acpi->dev, bd);
> +	return 0;
> +}
> +
> +static int cmpc_bl_remove(struct acpi_device *acpi, int type)
> +{
> +	struct backlight_device *bd;
> +	bd = dev_get_drvdata(&acpi->dev);
> +	backlight_device_unregister(bd);
> +	return 0;
> +}
> +
> +static const struct acpi_device_id cmpc_device_ids[] = {
> +	{"IPML200", 0},
> +	{"", 0}
> +};
> +MODULE_DEVICE_TABLE(acpi, cmpc_device_ids);
> +
> +static struct acpi_driver cmpc_bl_acpi_driver = {
> +	.name = "cmpc",
> +	.class = "cmpc",
> +	.ids = cmpc_device_ids,
> +	.ops = {
> +		.add = cmpc_bl_add,
> +		.remove = cmpc_bl_remove
> +	}
> +};
> +
> +static bool cmpc_bl_driver_registered;
> +
> +
> +/*
> + * Extra keys code.
> + */
> +static int cmpc_keys_codes[] = {
> +	KEY_UNKNOWN,
> +	KEY_WLAN,
> +	KEY_SWITCHVIDEOMODE,

> +	KEY_BRIGHTNESSDOWN,
> +	KEY_BRIGHTNESSUP,

Please confirm that the brightness keys do not directly affect the
backlight, and these key events are a signal for userspace to adjust
the backlight itself.

If they _do_ affect the backlight, you should call the newly added
backlight_force_update() when they are pressed, and it will generate a
uevent on the backlight device.  (I guess you will have to add an ugly
global variable for the backlight device, sorry about that).  In this
case you should ideally avoid generating _input_ events for brightness
keys.

Currently userspace is expected to handle annoying devices which
generate KEY_BRIGHTNESS* while directly changing the brightness.  But
requires a racy hack, so you should definitely try to avoid this for
new devices.  It will encourage userspace to implement support for the
backlight device uevents :-).

> +	KEY_VENDOR,
> +	KEY_MAX
> +};
> +
> +static void cmpc_keys_handler(acpi_handle handle, u32 event, void *ctx)
> +{
> +	struct input_dev *inputdev;
> +	int code = KEY_MAX;
> +	if ((event & 0x0F) < ARRAY_SIZE(cmpc_keys_codes))
> +		code = cmpc_keys_codes[event & 0x0F];
> +	inputdev = ctx;
> +	input_report_key(inputdev, code, !(event & 0x10));
> +}
> +
> +static void cmpc_keys_idev_init(struct input_dev *inputdev)
> +{
> +	int i;
> +	set_bit(EV_KEY, inputdev->evbit);
> +	for (i = 0; cmpc_keys_codes[i] != KEY_MAX; i++)
> +		set_bit(cmpc_keys_codes[i], inputdev->keybit);
> +}
> +
> +static int cmpc_keys_add(struct acpi_device *acpi)
> +{
> +	return cmpc_add_acpi_notify_device(acpi, "cmpc_keys",
> +					   cmpc_keys_handler,
> +					   cmpc_keys_idev_init);
> +}
> +
> +static int cmpc_keys_remove(struct acpi_device *acpi, int type)
> +{
> +	return cmpc_remove_acpi_notify_device(acpi, cmpc_keys_handler);
> +}
> +
> +static const struct acpi_device_id cmpc_keys_device_ids[] = {
> +	{"FnBT0000", 0},
> +	{"", 0}
> +};
> +MODULE_DEVICE_TABLE(acpi, cmpc_keys_device_ids);
> +
> +static struct acpi_driver cmpc_keys_acpi_driver = {
> +	.name = "cmpc_keys",
> +	.class = "cmpc_keys",
> +	.ids = cmpc_keys_device_ids,
> +	.ops = {
> +		.add = cmpc_keys_add,
> +		.remove = cmpc_keys_remove
> +	}
> +};
> +
> +static bool cmpc_keys_driver_registered;
> +
> +
> +/*
> + * General init/exit code.
> + */
> +
> +static int cmpc_init(void)
> +{
> +	int result;
> +	result = acpi_bus_register_driver(&cmpc_keys_acpi_driver);
> +	cmpc_keys_driver_registered = !!result;
> +	result = acpi_bus_register_driver(&cmpc_bl_acpi_driver);
> +	cmpc_bl_driver_registered = !!result;
> +	result = acpi_bus_register_driver(&cmpc_tablet_acpi_driver);
> +	cmpc_tablet_driver_registered = !!result;
> +	result = acpi_bus_register_driver(&cmpc_accel_acpi_driver);
> +	cmpc_accel_driver_registered = !!result;

These _registered flags are not necessary.  Registration doesn't fail
if the hardware doesn't exist.  It only fails if acpi=off, or on
-ENOMEM.  It would be reasonable to fail loading the module if one of
the drivers fails to register.

> +	/*
> +	 * Not every CMPC has every ACPI device supported here. So always return
> +	 * success.
> +	 */
> +	return 0;
> +}
> +
> +static void cmpc_exit(void)
> +{
> +	if (cmpc_accel_driver_registered)
> +		acpi_bus_unregister_driver(&cmpc_accel_acpi_driver);
> +	if (cmpc_tablet_driver_registered)
> +		acpi_bus_unregister_driver(&cmpc_tablet_acpi_driver);
> +	if (cmpc_bl_driver_registered)
> +		acpi_bus_unregister_driver(&cmpc_bl_acpi_driver);
> +	if (cmpc_keys_driver_registered)
> +		acpi_bus_unregister_driver(&cmpc_keys_acpi_driver);
> +}
> +
> +module_init(cmpc_init);
> +module_exit(cmpc_exit);
> --
> 1.6.3.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
