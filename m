Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab0BBV1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 16:27:15 -0500
Received: from ausxippc101.us.dell.com ([143.166.85.207]:34477 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013Ab0BBV1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 16:27:13 -0500
X-Loopcount0: from 10.208.86.12
Message-ID: <4B6898AF.5060703@dell.com>
Date: Tue, 02 Feb 2010 15:27:11 -0600
From: Bob Rodgers <Robert_Rodgers@dell.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, lenb@kernel.org,
       rpurdie@rpsys.net
Subject: Re: Re: [RFC] Dell activity led WMI driver
Content-Type: multipart/mixed;
 boundary="------------010404050607060707000306"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010404050607060707000306
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On Mon, Feb 01, 2010 at 04:44:36PM -0600, Bob Rodgers wrote:

 > This has been internally reviewed, and we are ready for outside review

 > and feedback. My colleagues have identified the dell-wmi module as a

 > suitable container in lieu of a stand-alone module specifically for

 > this driver, which makes sense, but we welcome advice. We are

 > submitting it as a stand-alone module for now because that is how we

 > developed and tested it. We would like this to be included upstream

 > after it has been reviewed.

On Mon, Feb 01, 2010 at 5:02 PM, Matthew Garrett wrote:


 > It uses a different GUID to the event interface used by dell-wmi,
 > so right now there's no inherent reason to integrate it into that
 > rather than keeping it as a separate driver. On the other hand,
 > if the GUID is useful for other kinds of system control rather
 > than just the LED then dell-wmi may want to make use of that
 > functionality in the future. In that case we'd need it to be
 > incorporated into the dell-wmi driver.

 >

 > So, really, it depends on the interface. If this GUID is specific to 
LEDs,
 > then keep it separate. Otherwise it should be integrated.

 >

 > I've got a few comments on the code...

 >

 > > // Error Result Codes:

 >

 > C99 style comments are usually discouraged in the kernel.

 >

 > > // Devide ID

 >

 > Typo?

 >

 > > // LED Commands

 > > #define CMD_LED_ON 16

 > > #define CMD_LED_OFF 17

 > > #define CMD_LED_BLINK 18

 >

 > Use of whitespace isn't very consistent here.

 >

 > > struct bios_args {

 > > unsigned char Length;

 > > unsigned char ResultCode;

 > > unsigned char DeviceId;

 > > unsigned char Command;

 > > unsigned char OnTime;

 > > unsigned char OffTime;

 > > unsigned char Reserved[122];

 > > };

 > Mm. We're also not usually big on CamelCasing in variable names -
 > it'd be preferable to use underscores. That's true for the rest of 
this, too.

 >

 > > // free the output ACPI object allocated by ACPI driver

 >

 > Probably don't need this comment.

 >

 > > static void led_on(void)

 > > {

 > > dell_led_perform_fn(3, // Length of command

 > > INTERFACE_ERROR, // Init result code to INTERFACE_ERROR

 > > DEVICE_ID_PANEL_BACK, // Device ID

 > > CMD_LED_ON, // Command

 > > 0, // not used

 > > 0); // not used

 > > }

 >

 > Whitespace is a bit odd here, again.

 >

 > Other than that, it looks good. You probably want to run it
 > through Scripts/checkpatch.pl in the kernel tree to perform
 > further style checks, but I can't see any functional issues.

 > --


On Tue, Feb 02, 2010 at 6:15 AM, Dan Carpenter wrote:


 > It would be better to not put the bios_return struct on the stack.
 > Make it a pointer and use kmalloc().

 >

 > It's a pity the Makefile bits weren't included.



Thank you for all the feedback. We have reviewed the feedback and made 
the recommended changes/corrections.


 > So, really, it depends on the interface. If this GUID is specific to 
LEDs,
 > then keep it separate. Otherwise it should be integrated.


Since the GUID is specific to LEDs, we will keep the driver separate 
rather than integrate it into the dell-wmi module.


 > C99 style comments are usually discouraged in the kernel.


Removed.


 > > // Devide ID

 >

 > Typo?


Yes. Fixed.


 > Use of whitespace isn't very consistent here.


Fixed.


 > Mm. We're also not usually big on CamelCasing in variable names -
 > it'd be preferable to use underscores. That's true for the rest of 
this, too.


Corrected. Changed to underscores.


 > > // free the output ACPI object allocated by ACPI driver

 >
 > Probably don't need this comment.


Removed.


 > > CMD_LED_ON, // Command

 > > 0, // not used

 > > 0); // not used

 > > }

 >

 > Whitespace is a bit odd here, again.


Fixed.


 > Other than that, it looks good. You probably want to run it
 > through Scripts/checkpatch.pl in the kernel tree to perform
 > further style checks, but I can't see any functional issues.

We ran the file through Scripts/checkpatch.pl and the script reported 0 
errors and 0 warnings.


 > It would be better to not put the bios_return struct on the stack.
 > Make it a pointer and use kmalloc().


Changed to a pointer.


 > It's a pity the Makefile bits weren't included.


The Makefile is now included.


The updated dell_led.c file and the Makefile are attached.


Regards,
Bob Rodgers
Louis Davis




--------------010404050607060707000306
Content-Type: text/plain;
 name="Makefile"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Makefile"

ifneq ($(KERNELRELEASE),)
# call from kernel build system

obj-m := dell_led.o

else

KERNELDIR ?= /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

default:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

endif

clean:
	rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c .tmp_versions modules.* Module.*

--------------010404050607060707000306
Content-Type: text/plain;
 name="dell_led.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dell_led.c"

/*
 * dell_led.c - Dell LED Driver
 *
 * Copyright (C) 2010 Dell Inc.
 * Louis Davis <louis_davis@dell.com>
 * Jim Dailey <jim_dailey@dell.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as
 * published by the Free Software Foundation.
 *
 */

#include <linux/platform_device.h>
#include <linux/acpi.h>
#include <linux/leds.h>

MODULE_AUTHOR("Louis Davis/Jim Dailey");
MODULE_DESCRIPTION("Dell LED Control Driver");
MODULE_LICENSE("GPL");

#define DELL_LED_BIOS_GUID "F6E4FE6E-909D-47cb-8BAB-C9F6F2F8D396"
MODULE_ALIAS("wmi:" DELL_LED_BIOS_GUID);

/* Error Result Codes: */
#define INVALID_DEVICE_ID	250
#define INVALID_PARAMETER	251
#define INVALID_BUFFER		252
#define INTERFACE_ERROR		253
#define UNSUPPORTED_COMMAND	254
#define UNSPECIFIED_ERROR	255

/* Device ID */
#define DEVICE_ID_PANEL_BACK	1

/* LED Commands */
#define CMD_LED_ON	16
#define CMD_LED_OFF	17
#define CMD_LED_BLINK	18

struct bios_args {
	unsigned char length;
	unsigned char result_code;
	unsigned char device_id;
	unsigned char command;
	unsigned char on_time;
	unsigned char off_time;
};

static u8 dell_led_perform_fn(u8 length,
		u8 result_code,
		u8 device_id,
		u8 command,
		u8 on_time,
		u8 off_time)
{
	struct bios_args *bios_return;
	u8 return_code;
	union acpi_object *obj;
	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
	struct acpi_buffer input;

	struct bios_args args;
	args.length = length;
	args.result_code = result_code;
	args.device_id = device_id;
	args.command = command;
	args.on_time = on_time;
	args.off_time = off_time;

	input.length = sizeof(struct bios_args);
	input.pointer = &args;

	wmi_evaluate_method(DELL_LED_BIOS_GUID,
		1,
		1,
		&input,
		&output);

	obj = output.pointer;

	if (!obj || obj->type != ACPI_TYPE_BUFFER)
		return -EINVAL;

	bios_return = ((struct bios_args *)obj->buffer.pointer);
	return_code = bios_return->result_code;

	kfree(obj);

	return return_code;
}

static u8 led_on(void)
{
	return dell_led_perform_fn(3,	/* Length of command */
		INTERFACE_ERROR,	/* Init to  INTERFACE_ERROR */
		DEVICE_ID_PANEL_BACK,	/* Device ID */
		CMD_LED_ON,		/* Command */
		0,			/* not used */
		0);			/* not used */
}

static u8 led_off(void)
{
	return dell_led_perform_fn(3,	/* Length of command */
		INTERFACE_ERROR,	/* Init to  INTERFACE_ERROR */
		DEVICE_ID_PANEL_BACK,	/* Device ID */
		CMD_LED_OFF,		/* Command */
		0,			/* not used */
		0);			/* not used */
}

static u8 led_blink(unsigned char on_eighths,
		unsigned char off_eighths)
{
	return dell_led_perform_fn(5,	/* Length of command */
		INTERFACE_ERROR,	/* Init to  INTERFACE_ERROR */
		DEVICE_ID_PANEL_BACK,	/* Device ID */
		CMD_LED_BLINK,		/* Command */
		on_eighths,		/* blink on in eigths of a second */
		off_eighths);		/* blink off in eights of a second */
}

static void dell_led_set(struct led_classdev *led_cdev,
		enum led_brightness value)
{
	if (value == LED_OFF)
		led_off();
	else
		led_on();
}

static int dell_led_blink(struct led_classdev *led_cdev,
		unsigned long *delay_on,
		unsigned long *delay_off)
{
	unsigned long on_eighths;
	unsigned long off_eighths;

	/* The Dell LED delay is based on 125ms intervals.
	   Need to round up to next interval. */

	on_eighths = (*delay_on + 124) / 125;
	if (0 == on_eighths)
		on_eighths = 1;
	if (on_eighths > 255)
		on_eighths = 255;
	*delay_on = on_eighths * 125;

	off_eighths = (*delay_off + 124) / 125;
	if (0 == off_eighths)
		off_eighths = 1;
	if (off_eighths > 255)
		off_eighths = 255;
	*delay_off = off_eighths * 125;

	led_blink(on_eighths, off_eighths);

	return 0;
}

static struct led_classdev dell_led = {
	.name		= "dell::lid",
	.brightness	= LED_OFF,
	.max_brightness = 1,
	.brightness_set = dell_led_set,
	.blink_set	= dell_led_blink,
	.flags		= LED_CORE_SUSPENDRESUME,
};

static int __init dell_led_probe(struct platform_device *pdev)
{
	return led_classdev_register(&pdev->dev, &dell_led);
}

static int dell_led_remove(struct platform_device *pdev)
{
	led_classdev_unregister(&dell_led);
	return 0;
}

static struct platform_driver dell_led_driver = {
	.probe		= dell_led_probe,
	.remove		= dell_led_remove,
	.driver		= {
		.name	= KBUILD_MODNAME,
		.owner	= THIS_MODULE,
	},
};

static struct platform_device *pdev;

static int __init dell_led_init(void)
{
	int error = 0;

	if (!wmi_has_guid(DELL_LED_BIOS_GUID)) {
		printk(KERN_DEBUG KBUILD_MODNAME
			": could not find: DELL_LED_BIOS_GUID\n");
		return -ENODEV;
	}

	error = led_off();
	if (error != 0) {
		printk(KERN_DEBUG KBUILD_MODNAME
			": could not communicate with LED"
			": error %d\n", error);
		return -ENODEV;
	}

	error = platform_driver_register(&dell_led_driver);
	if (error < 0)
		return error;

	pdev = platform_device_register_simple(KBUILD_MODNAME, -1, NULL, 0);
	if (IS_ERR(pdev)) {
		error = PTR_ERR(pdev);
		platform_driver_unregister(&dell_led_driver);
	}

	return error;
}

static void __exit dell_led_exit(void)
{
	platform_driver_unregister(&dell_led_driver);
	platform_device_unregister(pdev);

	led_off();
}

module_init(dell_led_init);
module_exit(dell_led_exit);

--------------010404050607060707000306--

