Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbZI2OQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbZI2OQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 10:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbZI2OQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 10:16:23 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:54128 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbZI2OQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 10:16:20 -0400
Date: Tue, 29 Sep 2009 11:16:19 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com, don@syst.com.br,
       linux-acpi@vger.kernel.org, linux-input@vger.kernel.org, dtor@mail.ru,
       dmitry.torokhov@gmail.com
Subject: Re: [PATCH] cmpc_acpi: Added support for Classmate PC ACPI devices.
Message-ID: <20090929141618.GD18847@vespa.holoscopio.com>
References: <1254188280-29155-1-git-send-email-cascardo@holoscopio.com> <9b2b86520909290220g6b5f6beal6337b17f1bdd339@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J5MfuwkIyy7RmF4Q"
Content-Disposition: inline
In-Reply-To: <9b2b86520909290220g6b5f6beal6337b17f1bdd339@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J5MfuwkIyy7RmF4Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 29, 2009 at 10:20:44AM +0100, Alan Jenkins wrote:
> On 9/29/09, Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:
> > This add supports for devices like keyboard, backlight, tablet and
> > accelerometer.
> >
> > This work is supported by International Syst S/A.
> >
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
>=20
> Hi!
>=20
> In general this driver was a pleasure to read.  It looks like you have
> a nice and clean ACPI interface to work with.  I haven't seen anything
> quite like the cmpc_{add,remove}_acpi_notify_device() functions
> before, but they make a lot of sense here.
>=20
> But I do have a few comments :-).
>=20
> The "-laptop" naming convention is more informative than "-acpi".
> Perhaps this driver should be called "classmate-laptop".  I would keep
> the cmpc_ prefix in the source code though.
>=20
> More comments inline.
>=20

Hello, Allan.

Thanks for the feedback. I am considering an investigation whether we
have lots of other ACPI input devices that could share some code like
{add,remove}_acpi_notify_device. Regarding the driver naming, I will
send a second version with it and other modifications considering your
feedback and that of other people too.

I will also ask for some explicit feedback and add linux-input and
Dmitry to the loop.

> > +/*
> > + * Generic input device code.
> > + */
> > +
> > +typedef void (*input_device_init)(struct input_dev *dev);
> > +
> > +static int cmpc_add_acpi_notify_device(struct acpi_device *acpi, char
> > *name,
> > +				       acpi_notify_handler handler,
> > +				       input_device_init idev_init)
> > +{
> > +	struct input_dev *inputdev;
> > +	acpi_status status;
> > +	int error;
> > +	inputdev =3D input_allocate_device();
> > +	if (!inputdev) {
> > +		error =3D -ENOMEM;
> > +		goto out;
> > +	}
> > +	inputdev->name =3D name;
> > +	inputdev->dev.parent =3D &acpi->dev;
> > +	idev_init(inputdev);
> > +	error =3D input_register_device(inputdev);
> > +	if (error)
> > +		goto err_reg;
> > +	dev_set_drvdata(&acpi->dev, inputdev);
> > +	status =3D acpi_install_notify_handler(acpi->handle, ACPI_DEVICE_NOTI=
FY,
> > +					     handler, inputdev);
> > +	if (ACPI_FAILURE(status)) {
> > +		error =3D -ENODEV;
> > +		goto err_acpi;
> > +	}
> > +	return 0;
> > +err_acpi:
> > +	input_unregister_device(inputdev);
> > +err_reg:
> > +	input_free_device(inputdev);
> > +out:
> > +	return error;
> > +}
> > +
> > +static int cmpc_remove_acpi_notify_device(struct acpi_device *acpi,
> > +					  acpi_notify_handler handler)
> > +{
> > +	struct input_dev *inputdev;
> > +	acpi_status status;
> > +	status =3D acpi_remove_notify_handler(acpi->handle, ACPI_DEVICE_NOTIF=
Y,
> > +					    handler);
> > +	inputdev =3D dev_get_drvdata(&acpi->dev);
> > +	input_unregister_device(inputdev);
> > +	input_free_device(inputdev);
>=20
> Dmitry the input maintainer says "input_free_device() should not be
> called after input_unregister_device()." (This also applies to the
> error handling in add_acpi_notify_device()).
>=20

That's right. My mistake here. And I've hit this mistake before.
input_free_device calls put_device (through input_put_device) and
input_unregister_device calls device_unregister, which also calls
put_device.

> > +	return 0;
> > +}
> > +
> > +
> > +/*
> > + * Accelerometer code.
> > + */
> > +
> > +static acpi_status cmpc_start_accel(acpi_handle handle)
> > +{
> > +	union acpi_object param[2];
> > +	struct acpi_object_list input;
> > +	acpi_status status;
> > +	param[0].type =3D ACPI_TYPE_INTEGER;
> > +	param[0].integer.value =3D 0x3;
> > +	param[1].type =3D ACPI_TYPE_INTEGER;
> > +	input.count =3D 2;
> > +	input.pointer =3D param;
> > +	status =3D acpi_evaluate_object(handle, "ACMD", &input, NULL);
> > +	return status;
> > +}
> > +
> > +static acpi_status cmpc_stop_accel(acpi_handle handle)
> > +{
> > +	union acpi_object param[2];
> > +	struct acpi_object_list input;
> > +	acpi_status status;
> > +	param[0].type =3D ACPI_TYPE_INTEGER;
> > +	param[0].integer.value =3D 0x4;
> > +	param[1].type =3D ACPI_TYPE_INTEGER;
> > +	input.count =3D 2;
> > +	input.pointer =3D param;
> > +	status =3D acpi_evaluate_object(handle, "ACMD", &input, NULL);
> > +	return status;
> > +}
> > +
> > +static acpi_status cmpc_accel_set_sense(acpi_handle handle, int val)
> > +{
> > +	union acpi_object param[2];
> > +	struct acpi_object_list input;
> > +	param[0].type =3D ACPI_TYPE_INTEGER;
> > +	param[0].integer.value =3D 0x02;
> > +	param[1].type =3D ACPI_TYPE_INTEGER;
> > +	param[1].integer.value =3D val;
> > +	input.count =3D 2;
> > +	input.pointer =3D param;
> > +	return acpi_evaluate_object(handle, "ACMD", &input, NULL);
> > +}
> > +
> > +static acpi_status cmpc_get_accel(acpi_handle handle,
> > +				  unsigned char *x,
> > +				  unsigned char *y,
> > +				  unsigned char *z)
> > +{
> > +	union acpi_object param[2];
> > +	struct acpi_object_list input;
> > +	struct acpi_buffer output =3D { ACPI_ALLOCATE_BUFFER, 0 };
> > +	unsigned char *locs;
> > +	acpi_status status;
> > +	param[0].type =3D ACPI_TYPE_INTEGER;
> > +	param[0].integer.value =3D 0x01;
> > +	param[1].type =3D ACPI_TYPE_INTEGER;
> > +	input.count =3D 2;
> > +	input.pointer =3D param;
> > +	status =3D acpi_evaluate_object(handle, "ACMD", &input, &output);
> > +	if (ACPI_SUCCESS(status)) {
> > +		union acpi_object *obj;
> > +		obj =3D output.pointer;
> > +		locs =3D obj->buffer.pointer;
> > +		*x =3D locs[0];
> > +		*y =3D locs[1];
> > +		*z =3D locs[2];
> > +		kfree(output.pointer);
> > +	}
> > +	return status;
> > +}
> > +
> > +static void cmpc_accel_handler(acpi_handle handle, u32 event, void *ct=
x)
> > +{
> > +	struct input_dev *inputdev =3D ctx;
> > +	acpi_status status;
> > +	unsigned char x, y, z;
> > +	if (event =3D=3D 0x81) {
> > +		status =3D cmpc_get_accel(handle, &x, &y, &z);
> > +		if (ACPI_SUCCESS(status)) {
> > +			input_report_abs(inputdev, ABS_X, x);
> > +			input_report_abs(inputdev, ABS_Y, y);
> > +			input_report_abs(inputdev, ABS_Z, z);
> > +			input_sync(inputdev);
> > +		}
> > +	}
> > +}
> > +
> > +static ssize_t cmpc_accel_sense_store(struct device *dev,
> > +				      struct device_attribute *attr,
> > +				      const char *buf, size_t count)
> > +{
> > +	struct acpi_device *acpi;
> > +	int sense;
> > +	acpi =3D to_acpi_device(dev);
> > +	if (sscanf(buf, "%d", &sense) <=3D 0)
> > +		return -EINVAL;
> > +	cmpc_accel_set_sense(acpi->handle, sense);
> > +	return strnlen(buf, count);
> > +}
> > +
> > +struct device_attribute cmpc_accel_sense_attr =3D {
> > +	.attr =3D { .name =3D "sense", .mode =3D 0220 },
> > +	.store =3D cmpc_accel_sense_store
> > +};
>=20
> What does this do?  What range of values can it take?  Is it a common
> attribute for input devices, or does it need specific documentation?
>=20
> Would it make sense for the driver to initialize it to a default
> value, so that we would always know what the current value is, and
> provide a .show() method as well?
>=20

This changes the accelerometer device sensitivity. I will take a look at
the ACPI tables to get a range. If very much sensitive, the device will
generate too much ACPI notifications, even when the classmate PC is no a
table and there seems to be no movement. If not very much sensitive, you
must throw it spinning into the air to get anything.  :-)

I will pick a default value, although I think we could let it to
userspace, but a sensible default value will not hurt here. As far as I
know, there is no ACPI method to do get_sense, but we can mirror the
last value written and provide a .show.

What do you recommend as a documentation? Something at
Documentation/ABI/testing/, perhaps? I don't know if there are any other
devices with something similar, but I would not be surprised if there
are some of them.

> > +
> > +static int cmpc_accel_open(struct input_dev *input)
> > +{
> > +	struct acpi_device *acpi;
> > +	acpi =3D to_acpi_device(input->dev.parent);
> > +	if (ACPI_SUCCESS(cmpc_start_accel(acpi->handle)))
> > +		return 0;
> > +	return -EIO;
> > +}
> > +
> > +static void cmpc_accel_close(struct input_dev *input)
> > +{
> > +	struct acpi_device *acpi;
> > +	acpi =3D to_acpi_device(input->dev.parent);
> > +	cmpc_stop_accel(acpi->handle);
> > +}
> > +
> > +static void cmpc_accel_idev_init(struct input_dev *inputdev)
> > +{
> > +	set_bit(EV_ABS, inputdev->evbit);
> > +	input_set_abs_params(inputdev, ABS_X, 0, 255, 8, 0);
> > +	input_set_abs_params(inputdev, ABS_Y, 0, 255, 8, 0);
> > +	input_set_abs_params(inputdev, ABS_Z, 0, 255, 8, 0);

Any hints on how to pick up values for this calibration? Any testing
procedure or anything?

> > +	inputdev->open =3D cmpc_accel_open;
> > +	inputdev->close =3D cmpc_accel_close;
> > +}
> > +
> > +static int cmpc_accel_add(struct acpi_device *acpi)
> > +{
> > +	int error;
> > +	error =3D device_create_file(&acpi->dev, &cmpc_accel_sense_attr);
> > +	if (error)
> > +		return error;
> > +	return cmpc_add_acpi_notify_device(acpi, "cmpc_accel",
> > +					   cmpc_accel_handler,
> > +					   cmpc_accel_idev_init);
> > +}
> > +
> > +static int cmpc_accel_remove(struct acpi_device *acpi, int type)
> > +{
> > +	device_remove_file(&acpi->dev, &cmpc_accel_sense_attr);
> > +	return cmpc_remove_acpi_notify_device(acpi, cmpc_accel_handler);
> > +}
> > +
> > +static const struct acpi_device_id cmpc_accel_device_ids[] =3D {
> > +	{"ACCE0000", 0},
> > +	{"", 0}
> > +};
> > +MODULE_DEVICE_TABLE(acpi, cmpc_accel_device_ids);
> > +
> > +static struct acpi_driver cmpc_accel_acpi_driver =3D {
> > +	.name =3D "cmpc_accel",
> > +	.class =3D "cmpc_accel",
> > +	.ids =3D cmpc_accel_device_ids,
> > +	.ops =3D {
> > +		.add =3D cmpc_accel_add,
> > +		.remove =3D cmpc_accel_remove
> > +	}
>=20
> Could you please set
>=20
> 	.owner =3D THIS_MODULE,
>=20
> on all the acpi drivers?  It will provide data in
> /sys/module/cmpc_acpi/drivers and
> /sys/bus/acpi/drivers/<driver>/module.  It seems to be forgotten
> knowledge, but I'm trying to revive it :-).
>=20

Consider it done. Although I think this could be done automatically
someday.

> > +};
> > +
> > +static bool cmpc_accel_driver_registered;
> > +
> > +
> > +/*
> > + * Tablet mode code.
> > + */
> > +static acpi_status cmpc_get_tablet(acpi_handle handle,
> > +				   unsigned long long *value)
> > +{
> > +	union acpi_object param;
> > +	struct acpi_object_list input;
> > +	unsigned long long output;
> > +	acpi_status status;
> > +	param.type =3D ACPI_TYPE_INTEGER;
> > +	param.integer.value =3D 0x01;
> > +	input.count =3D 1;
> > +	input.pointer =3D &param;
> > +	status =3D acpi_evaluate_integer(handle, "TCMD", &input, &output);
> > +	if (ACPI_SUCCESS(status))
> > +		*value =3D output;
> > +	return status;
> > +}
> > +
> > +static void cmpc_tablet_handler(acpi_handle handle, u32 event, void *c=
tx)
> > +{
> > +	unsigned long long val =3D 0;
> > +	struct input_dev *inputdev =3D ctx;
> > +	if (event =3D=3D 0x81) {
> > +		if (ACPI_SUCCESS(cmpc_get_tablet(handle, &val)))
> > +			input_report_switch(inputdev, SW_TABLET_MODE, !val);
> > +	}
> > +}
> > +
> > +static void cmpc_tablet_idev_init(struct input_dev *inputdev)
> > +{
> > +	set_bit(EV_SW, inputdev->evbit);
> > +	set_bit(SW_TABLET_MODE, inputdev->swbit);
>=20
> Don't you need to initialize the switch value here?
>=20

No, input_allocate_device does kzalloc. Otherwise, this would apply to
the other bitmaps as well.

> Also, have you tested this with changing the switch value while
> suspended?  I _think_ you need to update the switch state on resume.
> This is purely from looking at other acpi drivers and their evolution;
> I don't have any practical experience with input drivers.
>=20

Interesting point. I will do the testing.

> > +}
> > +
> > +static int cmpc_tablet_add(struct acpi_device *acpi)
> > +{
> > +	return cmpc_add_acpi_notify_device(acpi, "cmpc_tablet",
> > +					   cmpc_tablet_handler,
> > +					   cmpc_tablet_idev_init);
> > +}
> > +
> > +static int cmpc_tablet_remove(struct acpi_device *acpi, int type)
> > +{
> > +	return cmpc_remove_acpi_notify_device(acpi, cmpc_tablet_handler);
> > +}
> > +
> > +static const struct acpi_device_id cmpc_tablet_device_ids[] =3D {
> > +	{"TBLT0000", 0},
> > +	{"", 0}
> > +};
> > +MODULE_DEVICE_TABLE(acpi, cmpc_tablet_device_ids);
> > +
> > +static struct acpi_driver cmpc_tablet_acpi_driver =3D {
> > +	.name =3D "cmpc_tablet",
> > +	.class =3D "cmpc_tablet",
> > +	.ids =3D cmpc_tablet_device_ids,
> > +	.ops =3D {
> > +		.add =3D cmpc_tablet_add,
> > +		.remove =3D cmpc_tablet_remove
> > +	}
> > +};
> > +
> > +static bool cmpc_tablet_driver_registered;
> > +
> > +
> > +/*
> > + * Backlight code.
> > + */
> > +
> > +static acpi_status cmpc_get_brightness(acpi_handle handle,
> > +				       unsigned long long *value)
> > +{
> > +	union acpi_object param;
> > +	struct acpi_object_list input;
> > +	unsigned long long output;
> > +	acpi_status status;
> > +	param.type =3D ACPI_TYPE_INTEGER;
> > +	param.integer.value =3D 0xC0;
> > +	input.count =3D 1;
> > +	input.pointer =3D &param;
> > +	status =3D acpi_evaluate_integer(handle, "GRDI", &input, &output);
> > +	if (ACPI_SUCCESS(status))
> > +		*value =3D output;
> > +	return status;
> > +}
> > +
> > +static acpi_status cmpc_set_brightness(acpi_handle handle,
> > +				       unsigned long long value)
> > +{
> > +	union acpi_object param[2];
> > +	struct acpi_object_list input;
> > +	acpi_status status;
> > +	unsigned long long output;
> > +	param[0].type =3D ACPI_TYPE_INTEGER;
> > +	param[0].integer.value =3D 0xC0;
> > +	param[1].type =3D ACPI_TYPE_INTEGER;
> > +	param[1].integer.value =3D value;
> > +	input.count =3D 2;
> > +	input.pointer =3D param;
> > +	status =3D acpi_evaluate_integer(handle, "GWRI", &input, &output);
> > +	return status;
> > +}
> > +
> > +static int cmpc_bl_get_brightness(struct backlight_device *bd)
> > +{
> > +	acpi_status status;
> > +	acpi_handle handle;
> > +	unsigned long long brightness;
> > +	handle =3D bl_get_data(bd);
> > +	status =3D cmpc_get_brightness(handle, &brightness);
> > +	if (ACPI_SUCCESS(status))
> > +		return brightness;
> > +	else
> > +		return -1;
> > +}
> > +
> > +static int cmpc_bl_update_status(struct backlight_device *bd)
> > +{
> > +	acpi_status status;
> > +	acpi_handle handle;
> > +	handle =3D bl_get_data(bd);
> > +	status =3D cmpc_set_brightness(handle, bd->props.brightness);
> > +	if (ACPI_SUCCESS(status))
> > +		return 0;
> > +	else
> > +		return -1;
> > +}
> > +
> > +static struct backlight_ops cmpc_bl_ops =3D {
> > +	.get_brightness =3D cmpc_bl_get_brightness,
> > +	.update_status =3D cmpc_bl_update_status
> > +};
> > +
> > +static int cmpc_bl_add(struct acpi_device *acpi)
> > +{
> > +	struct backlight_device *bd;
> > +	bd =3D backlight_device_register("cmpc_bl", &acpi->dev,
> > +				       acpi->handle, &cmpc_bl_ops);
> > +	bd->props.max_brightness =3D 7;
> > +	dev_set_drvdata(&acpi->dev, bd);
> > +	return 0;
> > +}
> > +
> > +static int cmpc_bl_remove(struct acpi_device *acpi, int type)
> > +{
> > +	struct backlight_device *bd;
> > +	bd =3D dev_get_drvdata(&acpi->dev);
> > +	backlight_device_unregister(bd);
> > +	return 0;
> > +}
> > +
> > +static const struct acpi_device_id cmpc_device_ids[] =3D {
> > +	{"IPML200", 0},
> > +	{"", 0}
> > +};
> > +MODULE_DEVICE_TABLE(acpi, cmpc_device_ids);
> > +
> > +static struct acpi_driver cmpc_bl_acpi_driver =3D {
> > +	.name =3D "cmpc",
> > +	.class =3D "cmpc",
> > +	.ids =3D cmpc_device_ids,
> > +	.ops =3D {
> > +		.add =3D cmpc_bl_add,
> > +		.remove =3D cmpc_bl_remove
> > +	}
> > +};
> > +
> > +static bool cmpc_bl_driver_registered;
> > +
> > +
> > +/*
> > + * Extra keys code.
> > + */
> > +static int cmpc_keys_codes[] =3D {
> > +	KEY_UNKNOWN,
> > +	KEY_WLAN,
> > +	KEY_SWITCHVIDEOMODE,
>=20
> > +	KEY_BRIGHTNESSDOWN,
> > +	KEY_BRIGHTNESSUP,
>=20
> Please confirm that the brightness keys do not directly affect the
> backlight, and these key events are a signal for userspace to adjust
> the backlight itself.
>=20

AFAIK, they don't. We even had to write a simple userspace daemon that
would change the backlight values through sysfs when receiving an input
event.

> If they _do_ affect the backlight, you should call the newly added
> backlight_force_update() when they are pressed, and it will generate a
> uevent on the backlight device.  (I guess you will have to add an ugly
> global variable for the backlight device, sorry about that).  In this
> case you should ideally avoid generating _input_ events for brightness
> keys.
>=20
> Currently userspace is expected to handle annoying devices which
> generate KEY_BRIGHTNESS* while directly changing the brightness.  But
> requires a racy hack, so you should definitely try to avoid this for
> new devices.  It will encourage userspace to implement support for the
> backlight device uevents :-).
>=20
> > +	KEY_VENDOR,

This key is at the side of the LCD panel, not on the keyboard proper and
it has the drawing of a house. Any suggestions besides using KEY_VENDOR?

> > +	KEY_MAX
> > +};
> > +
> > +static void cmpc_keys_handler(acpi_handle handle, u32 event, void *ctx)
> > +{
> > +	struct input_dev *inputdev;
> > +	int code =3D KEY_MAX;
> > +	if ((event & 0x0F) < ARRAY_SIZE(cmpc_keys_codes))
> > +		code =3D cmpc_keys_codes[event & 0x0F];
> > +	inputdev =3D ctx;
> > +	input_report_key(inputdev, code, !(event & 0x10));
> > +}
> > +
> > +static void cmpc_keys_idev_init(struct input_dev *inputdev)
> > +{
> > +	int i;
> > +	set_bit(EV_KEY, inputdev->evbit);
> > +	for (i =3D 0; cmpc_keys_codes[i] !=3D KEY_MAX; i++)
> > +		set_bit(cmpc_keys_codes[i], inputdev->keybit);
> > +}
> > +
> > +static int cmpc_keys_add(struct acpi_device *acpi)
> > +{
> > +	return cmpc_add_acpi_notify_device(acpi, "cmpc_keys",
> > +					   cmpc_keys_handler,
> > +					   cmpc_keys_idev_init);
> > +}
> > +
> > +static int cmpc_keys_remove(struct acpi_device *acpi, int type)
> > +{
> > +	return cmpc_remove_acpi_notify_device(acpi, cmpc_keys_handler);
> > +}
> > +
> > +static const struct acpi_device_id cmpc_keys_device_ids[] =3D {
> > +	{"FnBT0000", 0},
> > +	{"", 0}
> > +};
> > +MODULE_DEVICE_TABLE(acpi, cmpc_keys_device_ids);
> > +
> > +static struct acpi_driver cmpc_keys_acpi_driver =3D {
> > +	.name =3D "cmpc_keys",
> > +	.class =3D "cmpc_keys",
> > +	.ids =3D cmpc_keys_device_ids,
> > +	.ops =3D {
> > +		.add =3D cmpc_keys_add,
> > +		.remove =3D cmpc_keys_remove
> > +	}
> > +};
> > +
> > +static bool cmpc_keys_driver_registered;
> > +
> > +
> > +/*
> > + * General init/exit code.
> > + */
> > +
> > +static int cmpc_init(void)
> > +{
> > +	int result;
> > +	result =3D acpi_bus_register_driver(&cmpc_keys_acpi_driver);
> > +	cmpc_keys_driver_registered =3D !!result;
> > +	result =3D acpi_bus_register_driver(&cmpc_bl_acpi_driver);
> > +	cmpc_bl_driver_registered =3D !!result;
> > +	result =3D acpi_bus_register_driver(&cmpc_tablet_acpi_driver);
> > +	cmpc_tablet_driver_registered =3D !!result;
> > +	result =3D acpi_bus_register_driver(&cmpc_accel_acpi_driver);
> > +	cmpc_accel_driver_registered =3D !!result;
>=20
> These _registered flags are not necessary.  Registration doesn't fail
> if the hardware doesn't exist.  It only fails if acpi=3Doff, or on
> -ENOMEM.  It would be reasonable to fail loading the module if one of
> the drivers fails to register.
>=20

OK. I had some doubts when writing it this way. I will rewrite it.

> > +	/*
> > +	 * Not every CMPC has every ACPI device supported here. So always ret=
urn
> > +	 * success.
> > +	 */
> > +	return 0;
> > +}
> > +
> > +static void cmpc_exit(void)
> > +{
> > +	if (cmpc_accel_driver_registered)
> > +		acpi_bus_unregister_driver(&cmpc_accel_acpi_driver);
> > +	if (cmpc_tablet_driver_registered)
> > +		acpi_bus_unregister_driver(&cmpc_tablet_acpi_driver);
> > +	if (cmpc_bl_driver_registered)
> > +		acpi_bus_unregister_driver(&cmpc_bl_acpi_driver);
> > +	if (cmpc_keys_driver_registered)
> > +		acpi_bus_unregister_driver(&cmpc_keys_acpi_driver);
> > +}
> > +
> > +module_init(cmpc_init);
> > +module_exit(cmpc_exit);
> > --
> > 1.6.3.3

Regards,
Thadeu Cascardo.

--J5MfuwkIyy7RmF4Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkrCFrIACgkQyTpryRcqtS27zQCfWHw0xSHKefYqPFPrbGiqGSYB
T5YAoJDBEi7ZR9rUQ1s/w8ezvmdZvFFe
=iCGI
-----END PGP SIGNATURE-----

--J5MfuwkIyy7RmF4Q--
