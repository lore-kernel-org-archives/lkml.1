Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165AbYLCXBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbYLCXBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 18:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbYLCXBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 18:01:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753919AbYLCXBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 18:01:40 -0500
Date: Wed, 3 Dec 2008 15:00:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: bri@abrij.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] misc: Add oqo-wmi driver for model 2 OQO backlight and
 rfkill control
Message-Id: <20081203150019.7e272c19.akpm@linux-foundation.org>
In-Reply-To: <20081203195537.GB22560@srcf.ucam.org>
References: <20081127190517.GA25429@srcf.ucam.org>
	<alpine.LFD.2.00.0811281431320.3204@localhost.localdomain>
	<Pine.LNX.4.64.0811282215160.17453@sheavy.abrij.org>
	<20081129045045.GA13866@srcf.ucam.org>
	<20081203195537.GB22560@srcf.ucam.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008 19:55:37 +0000
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> oqo-wmi provides a WMI-based interface to backlight and rfkill control on
> model 2 OQO devices. It was originally written by Brian Julin
> (<bri@abrij.org>) - I've ported it to the rfkill layer and tidied it up a
> little.
>     
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 

Are the attributions and signoffs appropriate here?

>
> ...
>
> +#include <acpi/acpi_drivers.h>
> +
> +MODULE_AUTHOR("Brian Julin");

Add yourself?

> +MODULE_DESCRIPTION("OQO UPMC WMI Extras Driver");
> +MODULE_LICENSE("GPL");
> +
> +#define OQO_LOGPREFIX "oqo-wmi: "
> +#define OQO_ERR KERN_ERR OQO_LOGPREFIX
> +#define OQO_NOTICE KERN_NOTICE OQO_LOGPREFIX
> +#define OQO_INFO KERN_INFO OQO_LOGPREFIX
> +
> +#define OQO_KINE_MAXTRY 3
> +
> +/* Store defined devices globally since we only have one instance. */
> +static struct platform_device *oqo_platform_device;
> +static struct backlight_device *oqo_backlight_device;
> +static struct rfkill *oqo_rfkill;
> +static struct input_dev *oqo_kine;
> +static struct input_polled_dev *oqo_kine_polled;
> +
> +/* Likewise store current and original settings globally. */
> +struct oqo_settings {
> +	int lid_wakes;		/* not sure if ACPI handles/needs help here */
> +	int kine_itvl;
> +	int bl_bright;
> +};
> +
> +static struct oqo_settings orig, curr;
> +
> +/* Some of this code is left like in acer-wmi so we can add the older
> +   Model 01 and any future models more easily, but we should not expect
> +   it to be as complicated as Acer given each model is a leap rather than
> +   a subtle variant on the last, so we aren't using "quirks" perse.  Not
> +   sure if there is any real difference for our purposes between the o2
> +   and e2.
> +*/
> +struct oqo_model {
> +	const char *model;
> +	u16 model_subs;
> +};
> +#define MODEL_SUB_OQO_O2_SMB0 3
> +
> +static struct oqo_model oqo_models[] = {
> +	{
> +	 .model = "Model 2",
> +	 .model_subs = MODEL_SUB_OQO_O2_SMB0,
> +	 },
> +	{}
> +};

Might be able to make this and oqo_dmis[] const.  Although that tends
to be a pita, easily ignorable..

> +static struct oqo_model *model;
> +
>
> ...
>
> +/*
> + * Interface type flags
> + */
> +enum interface_type {
> +	OQO_O2_AMW0,
> +};
> +
> +/* Each low-level interface must define at least some of the following */
> +struct wmi_interface {
> +	/* The WMI device type */
> +	u32 type;

Can have type `enum interface_type'.

> +};
> +
> +static struct wmi_interface AMW0_interface = {
> +	.type = OQO_O2_AMW0,
> +};
> +
>
> ...
>
> +static acpi_status oqo_smbus_getb(u8 addr, u8 *result)
> +{
> +	struct acpi_buffer input, res;
> +	acpi_status status;
> +	union acpi_object *obj;
> +	u32 arg2;
> +
> +	input.length = 4;
> +	input.pointer = &arg2;
> +	res.length = ACPI_ALLOCATE_BUFFER;
> +	res.pointer = NULL;
> +
> +	arg2 = addr;
> +	arg2 <<= 8;
> +	arg2 |= 0x12;		/* HOSTCMD */
> +
> +	status = wmi_evaluate_method(OQO_O2_AMW0_GUID, 1, 1, &input, &res);
> +
> +	if (status != AE_OK)
> +		return status;
> +
> +	obj = (union acpi_object *)res.pointer;

Unneeded and undesirable cast of void*.

> +	if (!obj)
> +		return AE_NULL_OBJECT;

AE_NO_MEMORY, perhaps.

> +	if (obj->type != ACPI_TYPE_BUFFER
> +	    || obj->buffer.length != 1 || obj->buffer.pointer == NULL) {
> +		kfree(obj);
> +		return AE_TYPE;

I wish someone had documented all these in include/acpi/acexcep.h.

> +	}
> +	*result = ((u8 *) (obj->buffer.pointer))[0];
> +	kfree(obj);
> +	return status;
> +}
> +
> +static acpi_status oqo_smbus_setb(u8 addr, u8 val)
> +{
> +	struct acpi_buffer input, res;
> +	acpi_status status;
> +	union acpi_object *obj;
> +	u32 arg2;
> +
> +	input.length = 4;
> +	input.pointer = &arg2;
> +	res.length = ACPI_ALLOCATE_BUFFER;
> +	res.pointer = NULL;
> +
> +	arg2 = val;
> +	arg2 <<= 8;
> +	arg2 |= addr;
> +	arg2 <<= 8;
> +	arg2 |= 0x12;		/* HOSTCMD */
> +
> +	status = wmi_evaluate_method(OQO_O2_AMW0_GUID, 1, 2, &input, &res);
> +
> +	if (status != AE_OK)
> +		return status;
> +
> +	obj = (union acpi_object *)res.pointer;

unneeded cast

> +	if (!obj)
> +		return AE_NULL_OBJECT;

AE_NO_MEMORY?

> +	if (obj->type != ACPI_TYPE_INTEGER) {
> +		kfree(obj);
> +		return AE_TYPE;
> +	}
> +	kfree(obj);
> +	return status;
> +}
> +
> +/*
> + * We assume we are the only one using this ...ahem... "lock" on
> + * the SMBUS because it would be pathetically noneffective otherwise.
> + *
> + * Nonzero silly_lock will keep certain ACPI routines away from the
> + * SMBUS (if they aren't already on it when you call it.)  Zero
> + *  silly_lock will let them back on
> + *
> + * This is probably useful before sleeping the system, and one
> + * waits until any ACPI funcs would have long finished before
> + * proceeding.  It seems harmless enough and will work to wrap
> + * more accesses with it.
> + */
> +static acpi_status oqo_lock_smbus(int silly_lock)
> +{
> +	struct acpi_buffer input, res;
> +	acpi_status status;
> +	union acpi_object *obj;
> +	u32 arg2;
> +
> +	input.length = 4;
> +	input.pointer = &arg2;
> +	res.length = ACPI_ALLOCATE_BUFFER;
> +	res.pointer = NULL;
> +
> +	arg2 = !!silly_lock;
> +
> +	status = wmi_evaluate_method(OQO_O2_AMW0_GUID, 1, 4, &input, &res);
> +
> +	if (status != AE_OK)
> +		return status;
> +
> +	obj = (union acpi_object *)res.pointer;
> +	if (!obj)
> +		return AE_NULL_OBJECT;
> +
> +	if (obj->type != ACPI_TYPE_INTEGER) {
> +		kfree(obj);
> +		return AE_TYPE;
> +	}
> +	kfree(obj);
> +	return status;
> +}

dittoes

> +static int smread_s16(u8 hi_addr, u8 lo_addr)
> +{
> +	s16 ret = -1;
> +	acpi_status status;
> +	u8 r;
> +
> +	/* Keep some ACPI routines off the SMBUS */
> +	status = oqo_lock_smbus(1);
> +	if (ACPI_FAILURE(status))
> +		goto skip;

Does this mean that we didn't take the lock?  If so, will running
oqo_lock_smbus(0) be correct?

> +	status = oqo_smbus_getb(hi_addr, &r);
> +	if (ACPI_FAILURE(status))
> +		goto skip;
> +
> +	ret = r;
> +	ret <<= 8;
> +
> +	status = oqo_smbus_getb(lo_addr, &r);
> +	if (ACPI_FAILURE(status)) {
> +		ret = -1;
> +		goto skip;
> +	}
> +
> +	ret |= r;
> +	ret &= 0x7fff;
> +skip:
> +	/* Let ACPI routines back on the SMBUS */
> +	status = oqo_lock_smbus(0);
> +	if (ACPI_FAILURE(status))
> +		return -1;
> +	return (int)ret;
> +}
> +
> +static int smwrite_s16(u8 hi_addr, u8 lo_addr, s16 val)
> +{
> +	acpi_status status;
> +	u8 r;
> +	int ret = -1;
> +
> +	status = oqo_lock_smbus(1);
> +	if (ACPI_FAILURE(status))
> +		goto skip;

Ditto

> +	r = (val >> 8) & 0x7f;
> +	status = oqo_smbus_setb(hi_addr, r);
> +	if (ACPI_FAILURE(status))
> +		goto skip;
> +
> +	r = val & 0xff;
> +	status = oqo_smbus_setb(lo_addr, r);
> +	if (ACPI_FAILURE(status))
> +		goto skip;
> +
> +	ret = 0;
> +skip:
> +	status = oqo_lock_smbus(0);
> +	if (ACPI_FAILURE(status))
> +		return -1;
> +	return ret;
> +}
> +
> +static int smread_u8(u8 addr)
> +{
> +	int ret = -1;
> +	acpi_status status;
> +	u8 r;
> +
> +	status = oqo_lock_smbus(1);
> +	if (ACPI_FAILURE(status))
> +		goto skip;

etc..

> +	status = oqo_smbus_getb(addr, &r);
> +	if (ACPI_FAILURE(status))
> +		goto skip;
> +
> +	ret = r;
> +skip:
> +	status = oqo_lock_smbus(0);
> +	if (ACPI_FAILURE(status))
> +		return -1;
> +	return (int)ret;
> +}
> +
>
> ...
>
> +static acpi_status oqo_read_kine(int *good, s16 *x, s16 *y, s16 *z,
> +				 u16 *lumin)
> +{
> +	u8 hiregs[4] = { OQO_O2_SMB0_ACCEL_XHI,
> +		OQO_O2_SMB0_ACCEL_YHI,
> +		OQO_O2_SMB0_ACCEL_ZHI,
> +		OQO_O2_SMB0_LUMIN_HI
> +	};
> +	u8 loregs[4] = { OQO_O2_SMB0_ACCEL_XLO,
> +		OQO_O2_SMB0_ACCEL_YLO,
> +		OQO_O2_SMB0_ACCEL_ZLO,
> +		OQO_O2_SMB0_LUMIN_LO
> +	};
> +
> +	short ax[4] = { ABS_X, ABS_Y, ABS_Z, ABS_MISC };

The above arrays will be assembled on the stack each time this function
is called (unless the compiler is being particularly smart).  If there
is a way of making them static const, goodness will ensue.

> +	u8 realgood = 0;
> +	u16 res[4];
> +	acpi_status status;
> +	int i;
> +
> +	*good = 0;
> +
> +	/* Routine: Starting with the lo byte, read lo/hi bytes
> +	   alternately until two lo byte readings, match.  Then
> +	   take that reading and combine it with the hi reading
> +	   sandwiched between.  Errors can still happen when
> +	   jittering at wrap boundaries, but should be rare.
> +
> +	   Don't use this for missile guidance.
> +
> +	   Userspace post-processing error detection encouraged.
> +	 */
> +	for (i = 0; i < 4; i++) {
> +		int maxtry;
> +		u32 log;
> +		u8 r, lo, hi;
> +
> +		lo = loregs[i];
> +		hi = hiregs[i];
> +		log = 0;
> +
> +#define LOGRES(reg)  do { \
> +			status = oqo_smbus_getb(reg, &r);		\
> +			log <<= 8; log |= r; log &= 0xffffff;		\
> +			if (ACPI_FAILURE(status))			\
> +				goto leave;				\
> +		} while (0)

eww...

> +		maxtry = OQO_KINE_MAXTRY + 1;
> +		while (maxtry) {
> +			LOGRES(lo);
> +			if (maxtry <= OQO_KINE_MAXTRY &&
> +			    (log >> 16) == (log & 0xff)) {
> +				*(res + i) = log & 0xffff;
> +				break;
> +			}
> +			LOGRES(hi);
> +			maxtry--;
> +		}
> +
> +		if (maxtry == OQO_KINE_MAXTRY)
> +			realgood |= 1 << i;
> +
> +		if (maxtry) {
> +			*good |= 1 << i;
> +			/* JIC CYA: this bit may be reserved */
> +			res[3] &= 0x7fff;
> +			input_report_abs(oqo_kine, ax[i], (s16) res[i]);
> +		}
> +		/* else we had trouble getting the reading to lock
> +		   and we skip reporting this axis.
> +		 */
> +	}
> +
> +	*x = (u16) res[0];
> +	*y = (u16) res[1];
> +	*z = (u16) res[2];
> +	*lumin = (u16) res[3];

Those four casts are unneeded.

> +	return status;
> +leave:
> +	return status;
> +}
> +
> +/*
> + * Generic Device (interface-independent)
> + */
> +
> +static void oqo_kine_poll(struct input_polled_dev *dev)
> +{
> +	s16 x, y, z;
> +	u16 lumin;
> +	int good;
> +	/*      struct timeval tv1, tv2; */

?

> +	if (dev != oqo_kine_polled)
> +		return;
> +	if (orig.kine_itvl < 0)
> +		return;
> +
> +	x = y = z = 0;
> +	oqo_read_kine(&good, &x, &y, &z, &lumin);
> +}
> +
> +static int __devinit oqo_kine_init(void)
> +{
> +	int err;
> +
> +	oqo_kine = input_allocate_device();
> +	if (!oqo_kine)
> +		return -ENOMEM;
> +
> +	oqo_kine->name = "OQO embedded accelerometer";
> +	oqo_kine->phys = "platform:oqo-wmi:kine";
> +	oqo_kine->id.bustype = 0;
> +	oqo_kine->id.vendor = 0;
> +	oqo_kine->id.product = 2;
> +	oqo_kine->id.version = 0;
> +	oqo_kine->evbit[0] = BIT_MASK(EV_ABS);
> +	set_bit(ABS_X, oqo_kine->absbit);
> +	set_bit(ABS_Y, oqo_kine->absbit);
> +	set_bit(ABS_Z, oqo_kine->absbit);
> +	set_bit(ABS_MISC, oqo_kine->absbit);
> +	oqo_kine->absmin[ABS_X] =
> +	    oqo_kine->absmin[ABS_Y] =
> +	    oqo_kine->absmin[ABS_Z] = oqo_kine->absmin[ABS_MISC] = -32768;
> +	oqo_kine->absmax[ABS_X] =
> +	    oqo_kine->absmax[ABS_Y] =
> +	    oqo_kine->absmax[ABS_Z] = oqo_kine->absmax[ABS_MISC] = 32767;
> +
> +	memcpy(oqo_kine->dev.bus_id, "kine", 4);
> +
> +	oqo_kine_polled = input_allocate_polled_device();
> +	if (!oqo_kine_polled) {
> +		err = -ENOMEM;
> +		goto bail0;
> +	}
> +
> +	oqo_kine_polled->poll = oqo_kine_poll;
> +	oqo_kine_polled->poll_interval = 250;
> +	oqo_kine_polled->input = oqo_kine;
> +
> +	orig.kine_itvl = -1;	/* prevent callback from running */
> +	err = input_register_polled_device(oqo_kine_polled);
> +	if (err) {
> +		printk(OQO_ERR "Failed to register OQO kine input\n");
> +		goto bail1;
> +	}
> +
> +	/* This will allow the callback to run now if successful. */
> +	orig.kine_itvl = smread_u8(OQO_O2_SMB0_ACCEL_POLL_ITVL);
> +	smwrite_u8(OQO_O2_SMB0_ACCEL_POLL_ITVL, 250);
> +	curr.kine_itvl = smread_u8(OQO_O2_SMB0_ACCEL_POLL_ITVL);
> +	if (orig.kine_itvl < 0 || curr.kine_itvl != 250) {
> +		printk(OQO_ERR "Test communication with kine sensor failed\n");
> +		err = -ENODEV;
> +		goto bail2;
> +	}
> +
> +	printk(OQO_INFO "Created OQO kine input.\n");
> +	printk(OQO_INFO "Firmware interval %ims, driver interval %ims\n",
> +	       curr.kine_itvl, oqo_kine_polled->poll_interval);
> +	return 0;
> +bail2:
> +	input_unregister_polled_device(oqo_kine_polled);
> +bail1:
> +	input_free_polled_device(oqo_kine_polled);	/* frees oqo_kine */
> +	return err;
> +bail0:
> +	input_free_device(oqo_kine);
> +	return err;
> +}
> +
> +static void __devexit oqo_kine_fini(void)
> +{
> +	smwrite_u8(OQO_O2_SMB0_ACCEL_POLL_ITVL, orig.kine_itvl);
> +	input_unregister_polled_device(oqo_kine_polled);
> +	input_free_polled_device(oqo_kine_polled);
> +}
> +
> +/*
> + * Backlight device
> + */
> +static int read_brightness(struct backlight_device *bd)
> +{
> +	return (int)smread_s16(OQO_O2_SMB0_BL_HI, OQO_O2_SMB0_BL_LO);

smread_s16() already returns int.

> +}
> +
> +static int update_bl_status(struct backlight_device *bd)
> +{
> +	return smwrite_s16(OQO_O2_SMB0_BL_HI,
> +			   OQO_O2_SMB0_BL_LO, (s16) bd->props.brightness);

This driver does quite a lot of casting of things which the compiler
will happily do for us.  This could be viewed as having documentation
benefit, but not much, and it is atypical.

> +}
> +
>
> ...
>

