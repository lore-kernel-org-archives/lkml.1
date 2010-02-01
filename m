Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab0BAWyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 17:54:14 -0500
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:32451 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab0BAWyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 17:54:13 -0500
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Feb 2010 17:54:12 EST
X-Loopcount0: from 10.208.86.12
Message-ID: <4B675954.6000406@dell.com>
Date: Mon, 01 Feb 2010 16:44:36 -0600
From: Bob Rodgers <Robert_Rodgers@dell.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
CC: Michael E Brown <Michael_E_Brown@dell.com>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Mario Limonciello <Mario_Limonciello@dell.com>,
       Louis Davis <Louis_Davis@dell.com>, Jim Dailey <Jim_Dailey@dell.com>
Subject: [RFC] Dell activity led WMI driver
Content-Type: multipart/mixed;
 boundary="------------020808010501030001080803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020808010501030001080803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

My team has created a simple driver to control the Activity LED on Dell 
laptops intended for the Education market. The Activity LED is visible 
externally in the lid so Teachers can observe it from their desks. This 
driver works on the shipping Latitude 2100 series platforms as well as 
others to be released in the future. The driver follows the existing LED 
class driver API (leds-class.txt), so it will easily allow anybody to 
write an application to control the LED. Attached is dell_led.c

This has been internally reviewed, and we are ready for outside review 
and feedback. My colleagues have identified the dell-wmi module as a 
suitable container in lieu of a stand-alone module specifically for this 
driver, which makes sense, but we welcome advice. We are submitting it 
as a stand-alone module for now because that is how we developed and 
tested it. We would like this to be included upstream after it has been 
reviewed.

We look forward to your feedback. Thanks in advance.

Regards,
Bob Rodgers
Engineering Lead, Dell LED Control Project
Direct Tel: (512) 725-0665
Direct FAX: (512) 283-8994


--------------020808010501030001080803
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

// Error Result Codes:
#define INVALID_DEVICE_ID		250
#define INVALID_PARAMETER		251
#define INVALID_BUFFER			252
#define INTERFACE_ERROR			253
#define UNSUPPORTED_COMMAND		254
#define UNSPECIFIED_ERROR		255

// Devide ID
#define DEVICE_ID_PANEL_BACK	1

// LED Commands
#define CMD_LED_ON		16
#define CMD_LED_OFF		17
#define CMD_LED_BLINK	18

struct bios_args {
	unsigned char Length;
	unsigned char ResultCode;
	unsigned char DeviceId;
	unsigned char Command;
	unsigned char OnTime;
	unsigned char OffTime;
	unsigned char Reserved[122];
};

static int dell_led_perform_fn(u8 Length, u8 ResultCode, u8 DeviceId, u8 Command, u8 OnTime, u8 OffTime)
{
	struct bios_args bios_return;
	acpi_status status;
	union acpi_object *obj;
	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
	struct acpi_buffer input;

	struct bios_args args;
	args.Length = Length;
	args.ResultCode = ResultCode;
	args.DeviceId = DeviceId;
	args.Command = Command;
	args.OnTime = OnTime;
	args.OffTime = OffTime;

	input.length = sizeof(struct bios_args);
	input.pointer = &args;
	
	status = wmi_evaluate_method(DELL_LED_BIOS_GUID, 1, 1, &input, &output);

	obj = output.pointer;

	if (!obj || obj->type != ACPI_TYPE_BUFFER)
		return -EINVAL;

	bios_return = *((struct bios_args *)obj->buffer.pointer);

	// free the output ACPI object allocated by ACPI driver
	kfree(obj);
	
	return bios_return.ResultCode;
}

static void led_on(void)
{
	dell_led_perform_fn(3,		// Length of command
		INTERFACE_ERROR,		// Init result code to 	INTERFACE_ERROR
		DEVICE_ID_PANEL_BACK,	// Device ID
		CMD_LED_ON,				// Command
		0,						// not used
		0);						// not used
}

static void led_off(void)
{
	dell_led_perform_fn(3,		// Length of command
		INTERFACE_ERROR,		// Init result code to 	INTERFACE_ERROR
		DEVICE_ID_PANEL_BACK,	// Device ID
		CMD_LED_OFF,			// Command
		0,						// not used
		0);						// not used
}

static void led_blink(unsigned char on_eighths, unsigned char off_eighths)
{
	dell_led_perform_fn(5,		// Length of command
		INTERFACE_ERROR,		// Init result code to 	INTERFACE_ERROR
		DEVICE_ID_PANEL_BACK,	// Device ID
		CMD_LED_BLINK,			// Command
		on_eighths,				// blink on in eigths of a second
		off_eighths);			// blink off in eights of a second
}

static void dell_led_set(struct led_classdev *led_cdev,
				enum led_brightness value)
{

	if (value == LED_OFF)
	{
		led_off();
	}
	else
	{
		led_on();
	}
}

static int dell_led_blink(struct led_classdev *led_cdev,
				unsigned long *delay_on,
				unsigned long *delay_off)
{
	unsigned long on_eighths;
	unsigned long off_eighths;

	// The Dell LED delay is based on 125ms intervals.
	// Need to round up to next interval.
	
	on_eighths = (*delay_on + 124) / 125;
	if (0 == on_eighths) on_eighths = 1;
	if (on_eighths > 255) on_eighths = 255;
	*delay_on = on_eighths * 125;

	off_eighths = (*delay_off + 124) / 125;
	if (0 == off_eighths) off_eighths = 1;
	if (off_eighths > 255) off_eighths = 255;
	*delay_off = off_eighths * 125;

	led_blink(on_eighths, off_eighths);

	return 0;
}

static struct led_classdev dell_led = {
	.name			= "dell::lid",
	.brightness		= LED_OFF,
	.max_brightness	= 1,
	.brightness_set	= dell_led_set,
	.blink_set		= dell_led_blink,
	.flags			= LED_CORE_SUSPENDRESUME,
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
		.name		= KBUILD_MODNAME,
		.owner		= THIS_MODULE,
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

	led_off();

	error = platform_driver_register(&dell_led_driver);
	if ( error < 0 )
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


--------------020808010501030001080803--

