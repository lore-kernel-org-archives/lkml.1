Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbZBVGsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbZBVGsd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 01:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbZBVGsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 01:48:22 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:6544 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbZBVGsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 01:48:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rCyDv8D5orqXvlhiUPnkr5aZAY4AaXHExjHPBYc5sI3MNQoX1MyK70raI/xioB13FD
         eG9ArKe5fNc+QACQYdIiFwQLuhoMzffoTPdeG1zusBhPuPNY8wRj8tI0WsjXleoLnOSp
         rUrgclcw4pZxD/CQ4PF03/jL3FvneIX5bi73Q=
Date: Sun, 22 Feb 2009 07:48:08 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mike Murphy <mamurph@cs.clemson.edu>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] (revision 1) input: xpad.c - Xbox 360 wireless and
	sysfs support
Message-ID: <20090222064806.GC8494@nowhere>
References: <5aa163d00902212131g7cf9218ewd8a6396a7f1c95fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5aa163d00902212131g7cf9218ewd8a6396a7f1c95fd@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 12:31:27AM -0500, Mike Murphy wrote:
> Greetings,
> 
> Attached is a revised version of my previous patch to
> drivers/input/joystick/xpad.c, which should apply without issues to
> the current stable tree (2.6.28.7 at the time of this writing). I have
> made a number of major changes since the original:
> 
> 1. Removed kobject and used input device's existing kobject for sysfs
> via DEVICE_ATTR. All attributes are part of a game_device group, which
> I will document once this patch has been reviewed. Thanks to Greg K-H
> for his help with the sysfs interface and helpful feedback. Return
> values for sscanf are also now checked, and the ugly strcmp code has
> been replaced by a cleaner solution (thanks Oliver Neukum). Wireless
> 360 controllers now produce an online/offline uevent when
> connecting/disconnecting, for later userspace use. Additionally, the
> whole sysfs interface is now dependent upon CONFIG_SYSFS (the driver
> should continue to work without it).
> 
> 2. urb submissions while holding mutexes have been reverted to
> GFP_KERNEL, and fixes have been made to the shared workqueue code to
> account for possible adverse events (such as removal of the device
> before the work gets done). Thanks to Oliver Neukum for his feedback.
> 
> 3. Re-factored the code a bit and split it into two pieces (xpad.h and
> xpad.c). The division of the main data structures into a header file
> makes development on the main body much easier.
> 
> 4. After extensive testing and debugging with a popular fighting game
> in an emulator (with 3-4 concurrent players on wireless 360
> controllers), I changed the original square axis algorithm to an axis
> limiting and scaling algorithm that works on a per-stick basis. This
> new algorithm is substantially less jumpy when using a square axis,
> and it permits the size of the inscribed square to be adjusted on a
> per-controller basis. The nominal value to use to achieve the largest
> possible inscribed square on "perfect" hardware is 23170, but
> manufacturing variations in the controllers might require a smaller
> number.
> 
> Comments and feedback on this revision are greatly appreciated, and I
> plan to test all the supported hardware I can get my hands on (need to
> borrow some wired classic and 360 devices) to be sure the new code
> doesn't break support for older devices. I will also document the
> userspace interface by submitting a Documentation/ABI/testing patch
> with the "final" version of the driver, once it has been nailed down.
> 
> Thanks,
> Mike
> -- 
> Mike Murphy
> Ph.D. Candidate and NSF Graduate Research Fellow
> Clemson University School of Computing
> 120 McAdams Hall
> Clemson, SC 29634-0974 USA
> Tel: +1 864.656.2838   Fax: +1 864.656.0145
> http://cirg.cs.clemson.edu/~mamurph

> diff -uNr origdrv/drivers/input/joystick/xpad.c newdrv/drivers/input/joystick/xpad.c
> --- origdrv/drivers/input/joystick/xpad.c	2009-02-14 22:39:20.000000000 -0500
> +++ newdrv/drivers/input/joystick/xpad.c	2009-02-21 23:58:21.000000000 -0500
> @@ -1,5 +1,8 @@
>  /*
> - * X-Box gamepad driver
> + * Xbox gamepad driver with Xbox 360 wired/wireless support
> + *
> + * Last Modified:	21 February 2009
> + *			Mike Murphy <mamurph@cs.clemson.edu>
>   *
>   * Copyright (c) 2002 Marko Friedemann <mfr@bmx-chemnitz.de>
>   *               2004 Oliver Schwartz <Oliver.Schwartz@gmx.de>,
> @@ -9,6 +12,8 @@
>   *               2005 Dominic Cerquetti <binary1230@yahoo.com>
>   *               2006 Adam Buchbinder <adam.buchbinder@gmail.com>
>   *               2007 Jan Kratochvil <honza@jikos.cz>
> + *               2009 Clemson University
> + *		      (contact: Mike Murphy <mamurph@cs.clemson.edu>)
>   *
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public License as
> @@ -24,224 +29,305 @@
>   * along with this program; if not, write to the Free Software
>   * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
>   *
> + * Please see xbox.h for the ChangeLog.
> + */
> +
> +
> +
> +#include "xpad.h"
> +
> +
> +/* The dead zone and stick limit both affect the behavior of the corresponding
> + * analog stick, since the output values reported for the stick inputs will
> + * be scaled onto [0,32767]. It is thus necessary to ensure that the dead zone
> + * is never larger than the stick limit. In fact, a minimal amount of stick
> + * travel space (1024) is maintained between the two values. In practice,
> + * however, the stick limit should always be much greater than the dead zone.
> + */
> +
> +static void set_dead_zone(unsigned int new_size, unsigned int *dz, unsigned int stick_limit)
> +{
> +	if ((new_size + 1024) >= stick_limit)
> +		new_size = (stick_limit > 1024) ? stick_limit - 1024 : 0;
> +	*dz = new_size;
> +}
> +
> +static void set_stick_limit(unsigned int new_size, unsigned int *sl, unsigned int dead_zone)
> +{
> +	if (new_size < (dead_zone + 1024))
> +		new_size = dead_zone + 1024;
> +	if (new_size > 32767)
> +		new_size = 32767;
> +	*sl = new_size;
> +}
> +
> +
> +/****************************************************************************/
> +/*
> + * SysFs interface functions
>   *
> - * This driver is based on:
> - *  - information from     http://euc.jp/periphs/xbox-controller.ja.html
> - *  - the iForce driver    drivers/char/joystick/iforce.c
> - *  - the skeleton-driver  drivers/usb/usb-skeleton.c
> - *  - Xbox 360 information http://www.free60.org/wiki/Gamepad
> - *
> - * Thanks to:
> - *  - ITO Takayuki for providing essential xpad information on his website
> - *  - Vojtech Pavlik     - iforce driver / input subsystem
> - *  - Greg Kroah-Hartman - usb-skeleton driver
> - *  - XBOX Linux project - extra USB id's
> - *
> - * TODO:
> - *  - fine tune axes (especially trigger axes)
> - *  - fix "analog" buttons (reported as digital now)
> - *  - get rumble working
> - *  - need USB IDs for other dance pads
> - *
> - * History:
> - *
> - * 2002-06-27 - 0.0.1 : first version, just said "XBOX HID controller"
> - *
> - * 2002-07-02 - 0.0.2 : basic working version
> - *  - all axes and 9 of the 10 buttons work (german InterAct device)
> - *  - the black button does not work
> - *
> - * 2002-07-14 - 0.0.3 : rework by Vojtech Pavlik
> - *  - indentation fixes
> - *  - usb + input init sequence fixes
> - *
> - * 2002-07-16 - 0.0.4 : minor changes, merge with Vojtech's v0.0.3
> - *  - verified the lack of HID and report descriptors
> - *  - verified that ALL buttons WORK
> - *  - fixed d-pad to axes mapping
> - *
> - * 2002-07-17 - 0.0.5 : simplified d-pad handling
> - *
> - * 2004-10-02 - 0.0.6 : DDR pad support
> - *  - borrowed from the XBOX linux kernel
> - *  - USB id's for commonly used dance pads are present
> - *  - dance pads will map D-PAD to buttons, not axes
> - *  - pass the module paramater 'dpad_to_buttons' to force
> - *    the D-PAD to map to buttons if your pad is not detected
> - *
> - * Later changes can be tracked in SCM.
> - */
> -
> -#include <linux/kernel.h>
> -#include <linux/init.h>
> -#include <linux/slab.h>
> -#include <linux/stat.h>
> -#include <linux/module.h>
> -#include <linux/usb/input.h>
> -
> -#define DRIVER_AUTHOR "Marko Friedemann <mfr@bmx-chemnitz.de>"
> -#define DRIVER_DESC "X-Box pad driver"
> -
> -#define XPAD_PKT_LEN 32
> -
> -/* xbox d-pads should map to buttons, as is required for DDR pads
> -   but we map them to axes when possible to simplify things */
> -#define MAP_DPAD_TO_BUTTONS    0
> -#define MAP_DPAD_TO_AXES       1
> -#define MAP_DPAD_UNKNOWN       2
> -
> -#define XTYPE_XBOX        0
> -#define XTYPE_XBOX360     1
> -#define XTYPE_XBOX360W    2
> -#define XTYPE_UNKNOWN     3
> -
> -static int dpad_to_buttons;
> -module_param(dpad_to_buttons, bool, S_IRUGO);
> -MODULE_PARM_DESC(dpad_to_buttons, "Map D-PAD to buttons rather than axes for unknown pads");
> -
> -static const struct xpad_device {
> -	u16 idVendor;
> -	u16 idProduct;
> -	char *name;
> -	u8 dpad_mapping;
> -	u8 xtype;
> -} xpad_device[] = {
> -	{ 0x045e, 0x0202, "Microsoft X-Box pad v1 (US)", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x045e, 0x0289, "Microsoft X-Box pad v2 (US)", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x045e, 0x0285, "Microsoft X-Box pad (Japan)", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x045e, 0x0287, "Microsoft Xbox Controller S", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x045e, 0x0719, "Xbox 360 Wireless Receiver", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360W },
> -	{ 0x0c12, 0x8809, "RedOctane Xbox Dance Pad", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
> -	{ 0x044f, 0x0f07, "Thrustmaster, Inc. Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x046d, 0xc242, "Logitech Chillstream Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX360 },
> -	{ 0x046d, 0xca84, "Logitech Xbox Cordless Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x046d, 0xca88, "Logitech Compact Controller for Xbox", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x05fd, 0x1007, "Mad Catz Controller (unverified)", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x05fd, 0x107a, "InterAct 'PowerPad Pro' X-Box pad (Germany)", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x0738, 0x4516, "Mad Catz Control Pad", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x0738, 0x4522, "Mad Catz LumiCON", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x0738, 0x4526, "Mad Catz Control Pad Pro", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x0738, 0x4536, "Mad Catz MicroCON", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x0738, 0x4540, "Mad Catz Beat Pad", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
> -	{ 0x0738, 0x4556, "Mad Catz Lynx Wireless Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x0738, 0x4716, "Mad Catz Wired Xbox 360 Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX360 },
> -	{ 0x0738, 0x6040, "Mad Catz Beat Pad Pro", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
> -	{ 0x0c12, 0x8802, "Zeroplus Xbox Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x0c12, 0x880a, "Pelican Eclipse PL-2023", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x0c12, 0x8810, "Zeroplus Xbox Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x0c12, 0x9902, "HAMA VibraX - *FAULTY HARDWARE*", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x0e4c, 0x1097, "Radica Gamester Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x0e4c, 0x2390, "Radica Games Jtech Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x0e6f, 0x0003, "Logic3 Freebird wireless Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x0e6f, 0x0005, "Eclipse wireless Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x0e6f, 0x0006, "Edge wireless Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x0e6f, 0x0006, "Pelican 'TSZ' Wired Xbox 360 Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX360 },
> -	{ 0x0e8f, 0x0201, "SmartJoy Frag Xpad/PS2 adaptor", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x0f30, 0x0202, "Joytech Advanced Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x0f30, 0x8888, "BigBen XBMiniPad Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x102c, 0xff0c, "Joytech Wireless Advanced Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x12ab, 0x8809, "Xbox DDR dancepad", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
> -	{ 0x1430, 0x4748, "RedOctane Guitar Hero X-plorer", MAP_DPAD_TO_AXES, XTYPE_XBOX360 },
> -	{ 0x1430, 0x8888, "TX6500+ Dance Pad (first generation)", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
> -	{ 0x045e, 0x028e, "Microsoft X-Box 360 pad", MAP_DPAD_TO_AXES, XTYPE_XBOX360 },
> -	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
> -	{ 0x0000, 0x0000, "Generic X-Box pad", MAP_DPAD_UNKNOWN, XTYPE_UNKNOWN }
> -};
> -
> -/* buttons shared with xbox and xbox360 */
> -static const signed short xpad_common_btn[] = {
> -	BTN_A, BTN_B, BTN_X, BTN_Y,			/* "analog" buttons */
> -	BTN_START, BTN_BACK, BTN_THUMBL, BTN_THUMBR,	/* start/back/sticks */
> -	-1						/* terminating entry */
> -};
> -
> -/* original xbox controllers only */
> -static const signed short xpad_btn[] = {
> -	BTN_C, BTN_Z,		/* "analog" buttons */
> -	-1			/* terminating entry */
> -};
> -
> -/* only used if MAP_DPAD_TO_BUTTONS */
> -static const signed short xpad_btn_pad[] = {
> -	BTN_LEFT, BTN_RIGHT,		/* d-pad left, right */
> -	BTN_0, BTN_1,			/* d-pad up, down (XXX names??) */
> -	-1				/* terminating entry */
> -};
> -
> -static const signed short xpad360_btn[] = {  /* buttons for x360 controller */
> -	BTN_TL, BTN_TR,		/* Button LB/RB */
> -	BTN_MODE,		/* The big X button */
> -	-1
> -};
> -
> -static const signed short xpad_abs[] = {
> -	ABS_X, ABS_Y,		/* left stick */
> -	ABS_RX, ABS_RY,		/* right stick */
> -	ABS_Z, ABS_RZ,		/* triggers left/right */
> -	-1			/* terminating entry */
> -};
> -
> -/* only used if MAP_DPAD_TO_AXES */
> -static const signed short xpad_abs_pad[] = {
> -	ABS_HAT0X, ABS_HAT0Y,	/* d-pad axes */
> -	-1			/* terminating entry */
> -};
> -
> -/* Xbox 360 has a vendor-specific class, so we cannot match it with only
> - * USB_INTERFACE_INFO (also specifically refused by USB subsystem), so we
> - * match against vendor id as well. Wired Xbox 360 devices have protocol 1,
> - * wireless controllers have protocol 129. */
> -#define XPAD_XBOX360_VENDOR_PROTOCOL(vend,pr) \
> -	.match_flags = USB_DEVICE_ID_MATCH_VENDOR | USB_DEVICE_ID_MATCH_INT_INFO, \
> -	.idVendor = (vend), \
> -	.bInterfaceClass = USB_CLASS_VENDOR_SPEC, \
> -	.bInterfaceSubClass = 93, \
> -	.bInterfaceProtocol = (pr)
> -#define XPAD_XBOX360_VENDOR(vend) \
> -	{ XPAD_XBOX360_VENDOR_PROTOCOL(vend,1) }, \
> -	{ XPAD_XBOX360_VENDOR_PROTOCOL(vend,129) }
> -
> -static struct usb_device_id xpad_table [] = {
> -	{ USB_INTERFACE_INFO('X', 'B', 0) },	/* X-Box USB-IF not approved class */
> -	XPAD_XBOX360_VENDOR(0x045e),		/* Microsoft X-Box 360 controllers */
> -	XPAD_XBOX360_VENDOR(0x046d),		/* Logitech X-Box 360 style controllers */
> -	XPAD_XBOX360_VENDOR(0x0738),		/* Mad Catz X-Box 360 controllers */
> -	XPAD_XBOX360_VENDOR(0x0e6f),		/* 0x0e6f X-Box 360 controllers */
> -	XPAD_XBOX360_VENDOR(0x1430),		/* RedOctane X-Box 360 controllers */
> -	{ }
> -};
> -
> -MODULE_DEVICE_TABLE (usb, xpad_table);
> -
> -struct usb_xpad {
> -	struct input_dev *dev;		/* input device interface */
> -	struct usb_device *udev;	/* usb device */
> -
> -	int pad_present;
> -
> -	struct urb *irq_in;		/* urb for interrupt in report */
> -	unsigned char *idata;		/* input data */
> -	dma_addr_t idata_dma;
> + * We use common functions, where possible, to implement the show/store
> + * routines. This design saves on code and reduces the burden of adding to or
> + * changing the interface.
> + */
> + 
> +#if defined(CONFIG_SYSFS)
>  
> -	struct urb *bulk_out;
> -	unsigned char *bdata;
> +static ssize_t xpad_show_uint(struct device *dev, struct device_attribute *attr,
> +		char *buf)
> +{
> +	struct usb_xpad *xpad = to_xpad(dev);
> +	unsigned int value;
> +	if (attr == &dev_attr_left_dead_zone)
> +		value = xpad->left_dead_zone;
> +	else if (attr == &dev_attr_right_dead_zone)
> +		value = xpad->right_dead_zone;
> +	else if (attr == &dev_attr_left_stick_limit)
> +		value = xpad->left_stick_limit;
> +	else if (attr == &dev_attr_right_stick_limit)
> +		value = xpad->right_stick_limit;
> +	else
> +		return -EIO;
> +	return snprintf(buf, PAGE_SIZE, "%u\n", value);
> +}
>  
> -#if defined(CONFIG_JOYSTICK_XPAD_FF) || defined(CONFIG_JOYSTICK_XPAD_LEDS)
> -	struct urb *irq_out;		/* urb for interrupt out report */
> -	unsigned char *odata;		/* output data */
> -	dma_addr_t odata_dma;
> -	struct mutex odata_mutex;
> -#endif
>  
> -#if defined(CONFIG_JOYSTICK_XPAD_LEDS)
> -	struct xpad_led *led;
> +static ssize_t xpad_store_uint(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct usb_xpad *xpad = to_xpad(dev);
> +	unsigned int new_value;
> +	if (1 != sscanf(buf, "%u", &new_value)) {
> +		return -EIO;
> +	}
> +	if (attr == &dev_attr_left_dead_zone)
> +		set_dead_zone(new_value, &xpad->left_dead_zone, xpad->left_stick_limit);
> +	else if (attr == &dev_attr_right_dead_zone)
> +		set_dead_zone(new_value, &xpad->right_dead_zone, xpad->right_stick_limit);
> +	else if (attr == &dev_attr_left_stick_limit)
> +		set_stick_limit(new_value, &xpad->left_stick_limit, xpad->left_dead_zone);
> +	else if (attr == &dev_attr_right_stick_limit)
> +		set_stick_limit(new_value, &xpad->right_stick_limit, xpad->right_dead_zone);
> +	else
> +		return -EIO;
> +	return strnlen(buf, PAGE_SIZE);
> +}
> +
> +
> +static ssize_t xpad_store_rumble_enable(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct usb_xpad *xpad = to_xpad(dev);
> +	int newrumble = xpad->rumble_enable;
> +	if (1 == sscanf(buf, "%d", &newrumble))


Oh, that's not wrong but it looks weird, usually, a code reader would
expect to see if (sscanf(...) == 1)


> +		xpad->rumble_enable = (newrumble) ? 1 : 0;
> +	return count;
> +}
> +
> +
> +/* read-only attributes share a common store function that returns an error */
> +static ssize_t xpad_store_ro(struct device *dev, struct device_attribute *attr,
> +		const char *buf, size_t count)
> +{
> +	return -EIO;
> +}
> +
> +
> +static ssize_t xpad_show_int(struct device *dev, struct device_attribute *attr,
> +		char *buf)
> +{
> +	struct usb_xpad *xpad = to_xpad(dev);
> +	int value;
> +	if (attr == &dev_attr_rumble_enable)
> +		value = xpad->rumble_enable;
> +	else if (attr == &dev_attr_controller_number)
> +		value = xpad->controller_number;
> +	else if (attr == &dev_attr_controller_present)
> +		value = xpad->controller_present;
> +	else if (attr == &dev_attr_controller_type)
> +		value = xpad->controller_type;
> +	else
> +		return -EIO;
> +	return snprintf(buf, PAGE_SIZE, "%d\n", value);
> +}
> +
> +
> +static ssize_t xpad_show_id(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct usb_xpad *xpad = to_xpad(dev);
> +	return snprintf(buf, PAGE_SIZE, "%s\n", xpad->controller_unique_id);
> +}
> +
>  #endif
> +/* end of sysfs interface */
> +/*****************************************************************************/
> +
> +/* Input section */
> +
> +/*	xpad_init_controller
> + *
> + *	Performs controller setup based on controller type.
> + *
> + *	NOTE: xpad->controller_data->controller_type needs to be set BEFORE
> + *	calling this function!
> + */
> + 
> +static void xpad_init_controller(struct usb_xpad *xpad)
> +{
> +	set_stick_limit(XSTICK_LIMIT_DEFAULT, &xpad->left_stick_limit, xpad->left_dead_zone);
> +	set_stick_limit(XSTICK_LIMIT_DEFAULT, &xpad->right_stick_limit, xpad->right_dead_zone);
> +	set_dead_zone(XDEAD_ZONE_DEFAULT, &xpad->left_dead_zone, xpad->left_stick_limit);
> +	set_dead_zone(XDEAD_ZONE_DEFAULT, &xpad->right_dead_zone, xpad->right_stick_limit);
> +	
> +	if (xpad->controller_type == XCONTROLLER_TYPE_GUITAR) {
> +		xpad->rumble_enable = 0;
> +	}
> +	else if (xpad->controller_type == XCONTROLLER_TYPE_DANCE_PAD) {
> +		xpad->rumble_enable = 0;
> +	}
> +	else {
> +		xpad->rumble_enable = 1;
> +	}


The brackets are not needed in these checks, may be you should run
scripts/checkpatch.pl to check obvious coding styles issues.


> +}
> +
>  
> -	char phys[64];			/* physical device path */
> +/*
> + *	xpad_work_controller
> + *
> + *	Submits command to set pad number on LED display of wireless 360
> + *	controllers. The shared workqueue is used for this purpose, so that
> + *	the interrupt handler is kept short.
> + */
> + 
> +static void xpad_work_controller(struct work_struct *w)
> +{
> +   struct usb_xpad * xpad = container_of(w, struct usb_xpad, work);
> +   xpad_send_led_command(xpad, xpad->controller_number + 1);
> +   xpad->work_pending = 0;
> +}
> +
> +
> +/*
> + *	xpad_process_sticks
> + *
> + *	Handles stick input, accounting for dead zones and square axes. Based
> + *	on the original handlers for the Xbox and Xbox 360 in
> + *	xpad_process_packet and xpad360_process_packet, but unified to avoid
> + *	duplication.
> + *
> + *	Whenever a dead zone is used, each axis is scaled so that moving the
> + *	stick slightly out of the dead zone range results in a low axis
> + *	value in jstest(1), while moving the stick to the maximum position
> + *	along any axis still results in 32767.
> + *
> + *	In order to provide the ability to map inputs to a square axis (used
> + *	by older games), the left_stick_limit and right_stick_limit can be
> + *	set. These limits specify at what point in the raw input coordinates
> + *	an axis is reported to be at maximum value (32767 or -32767).
> + *
> + *	Both the dead zone and stick limit algorithms are implemented
> + *	together as a coordinate transformation from "effective coordinates"
> + *	onto the output coordinates (which have absolute values from 0 to
> + *	32767 and are positive or negative based on direction). Effective
> + *	coordinates are defined as those input values that are greater than
> + *	the dead zone but less than the stick limit on the axis in question.
> + *
> + *	DANGER: All denominator values in division operations MUST be checked
> + *	for non-zero condition. Dividing by zero inside the kernel can cause
> + *	a system deadlock.
> + */
> +
> +static void xpad_process_sticks(struct usb_xpad *xpad, unsigned char *data)
> +{
> +	struct input_dev *dev = xpad->dev;
> +	int coords[4];    /* x, y, rx, ry */
> +	int x_offset, y_offset, rx_offset, ry_offset;
> +	int c;
> +	int range;
> +	int abs_magnitude, adjusted_magnitude, difference, scale_fraction;
> +	int dead_zone[2], stick_limit[2];
> +	
> +	dead_zone[0] = xpad->left_dead_zone;
> +	dead_zone[1] = xpad->right_dead_zone;
> +	stick_limit[0] = xpad->left_stick_limit;
> +	stick_limit[1] = xpad->right_stick_limit;
> +	
> +	if (xpad->xtype == XTYPE_XBOX) {
> +		x_offset = 12;
> +		y_offset = 14;
> +		rx_offset = 16;
> +		ry_offset = 18;
> +	}
> +	else {
> +		x_offset = 6;
> +		y_offset = 8;
> +		rx_offset = 10;
> +		ry_offset = 12;
> +	}
> +	
> +	coords[0] = (__s16) le16_to_cpup((__le16 *)(data + x_offset));
> +	coords[1] = ~(__s16) le16_to_cpup((__le16 *)(data + y_offset));
> +	coords[2] = (__s16) le16_to_cpup((__le16 *)(data + rx_offset));
> +	coords[3] = ~(__s16) le16_to_cpup((__le16 *)(data + ry_offset));
> +	
> +	/* Adjustment for dead zone and square axis */
> +	for (c = 0; c < 4; c++) {
> +		abs_magnitude = (int) coords[c];
> +		if (abs_magnitude < 0)
> +			abs_magnitude = -abs_magnitude;
> +		adjusted_magnitude = abs_magnitude;
> +		
> +		range = (stick_limit[c/2] - dead_zone[c/2]);
> +		
> +		if (abs_magnitude >= stick_limit[c/2]) {
> +			adjusted_magnitude = 32767;
> +		}
> +		else if (abs_magnitude <= dead_zone[c/2]) {
> +			adjusted_magnitude = 0;
> +		}
> +		else if (range > 0) {
> +			difference = 32767 - range;
> +			if (difference) {
> +				/* DIVISION: difference non-zero */
> +				scale_fraction = range / difference;
> +				adjusted_magnitude = abs_magnitude - dead_zone[c/2];
> +				
> +				/* Approximate floating-point division with a
> +				 * "catch-up" scaling algorithm that adds back
> +				 * to the adjusted_magnitude based on distance
> +				 * from the origin (0 in adjusted coordinates).
> +				 * If the range / difference is at least 1,
> +				 * then 1 needs to be added to the adjusted
> +				 * magnitude for every scale_fraction units
> +				 * from the origin. If the range / difference
> +				 * is less than 1 (0 in integer division),
> +				 * then divide the difference by the range to
> +				 * obtain the number of units to add per unit
> +				 * from the adjusted origin.
> +				 */
> +				if (scale_fraction) {
> +					/* DIVISION: scale_fraction non-zero */
> +					adjusted_magnitude += adjusted_magnitude / scale_fraction;
> +				}
> +				else {
> +					/* DIVISION: range non-zero */
> +					scale_fraction = difference / range;
> +					adjusted_magnitude += adjusted_magnitude * scale_fraction;
> +				}
> +				if (adjusted_magnitude > 32767)
> +					adjusted_magnitude = 32767;
> +			}
> +		}
> +		coords[c] = (coords[c] < 0) ? -adjusted_magnitude : adjusted_magnitude;
> +	}
> +	
> +	input_report_abs(dev, ABS_X, (__s16) coords[0]);
> +	input_report_abs(dev, ABS_Y, (__s16) coords[1]);
> +	input_report_abs(dev, ABS_RX, (__s16) coords[2]);
> +	input_report_abs(dev, ABS_RY, (__s16) coords[3]);
> +}
>  
> -	int dpad_mapping;		/* map d-pad to buttons or to axes */
> -	int xtype;			/* type of xbox device */
> -};
>  
>  /*
>   *	xpad_process_packet
> @@ -256,18 +342,9 @@
>  static void xpad_process_packet(struct usb_xpad *xpad, u16 cmd, unsigned char *data)
>  {
>  	struct input_dev *dev = xpad->dev;
> -
> -	/* left stick */
> -	input_report_abs(dev, ABS_X,
> -			 (__s16) le16_to_cpup((__le16 *)(data + 12)));
> -	input_report_abs(dev, ABS_Y,
> -			 ~(__s16) le16_to_cpup((__le16 *)(data + 14)));
> -
> -	/* right stick */
> -	input_report_abs(dev, ABS_RX,
> -			 (__s16) le16_to_cpup((__le16 *)(data + 16)));
> -	input_report_abs(dev, ABS_RY,
> -			 ~(__s16) le16_to_cpup((__le16 *)(data + 18)));
> +	
> +	/* left and right sticks */
> +	xpad_process_sticks(xpad, data);
>  
>  	/* triggers left/right */
>  	input_report_abs(dev, ABS_Z, data[10]);
> @@ -305,6 +382,7 @@
>  	input_sync(dev);
>  }
>  
> +
>  /*
>   *	xpad360_process_packet
>   *
> @@ -350,18 +428,9 @@
>  	input_report_key(dev, BTN_TL,	data[3] & 0x01);
>  	input_report_key(dev, BTN_TR,	data[3] & 0x02);
>  	input_report_key(dev, BTN_MODE,	data[3] & 0x04);
> -
> -	/* left stick */
> -	input_report_abs(dev, ABS_X,
> -			 (__s16) le16_to_cpup((__le16 *)(data + 6)));
> -	input_report_abs(dev, ABS_Y,
> -			 ~(__s16) le16_to_cpup((__le16 *)(data + 8)));
> -
> -	/* right stick */
> -	input_report_abs(dev, ABS_RX,
> -			 (__s16) le16_to_cpup((__le16 *)(data + 10)));
> -	input_report_abs(dev, ABS_RY,
> -			 ~(__s16) le16_to_cpup((__le16 *)(data + 12)));
> +	
> +	/* left and right sticks */
> +	xpad_process_sticks(xpad, data);
>  
>  	/* triggers left/right */
>  	input_report_abs(dev, ABS_Z, data[4]);
> @@ -370,6 +439,33 @@
>  	input_sync(dev);
>  }
>  
> +
> +static void xpad360w_identify_controller(struct usb_xpad *xpad, unsigned char *data)
> +{
> +	u32 id;
> +	int i;
> +	
> +	snprintf(xpad->controller_unique_id, 17,
> +		"%02x%02x%02x%02x%02x%02x%02x%02x",
> +		data[8], data[9], data[10], data[11], data[12], data[13],
> +		data[14], data[15]);
> +			
> +	/* Identify controller type */
> +	id = (u32) *(data + 22);
> +	xpad->controller_type = XCONTROLLER_TYPE_OTHER;
> +	for (i = 0; w360_id[i].id_bytes; i++) {
> +		if (id == w360_id[i].id_bytes) {
> +			xpad->controller_type =
> +				w360_id[i].controller_type;
> +			break;
> +		}
> +	}
> +	
> +	if (id == XCONTROLLER_TYPE_OTHER)
> +		printk(KERN_INFO "xpad: unknown wireless controller type: %08x\n", id);
> +}
> +
> +
>  /*
>   * xpad360w_process_packet
>   *
> @@ -379,6 +475,7 @@
>   * Byte.Bit
>   * 00.1 - Status change: The controller or headset has connected/disconnected
>   *                       Bits 01.7 and 01.6 are valid
> + * 01.f - Some kind of unique identifier message (see above)
>   * 01.7 - Controller present
>   * 01.6 - Headset present
>   * 01.1 - Pad state (Bytes 4+) valid
> @@ -387,22 +484,53 @@
>  
>  static void xpad360w_process_packet(struct usb_xpad *xpad, u16 cmd, unsigned char *data)
>  {
> -	/* Presence change */
> +	int padnum = 0;
> +
> +	/* Presence change */	
>  	if (data[0] & 0x08) {
> +		padnum = xpad->controller_number;
>  		if (data[1] & 0x80) {
> -			xpad->pad_present = 1;
> -			usb_submit_urb(xpad->bulk_out, GFP_ATOMIC);
> -		} else
> -			xpad->pad_present = 0;
> +			/* ignore duplicates */
> +			if (!xpad->controller_present) {
> +				xpad->controller_present = 1;
> +				
> +				if (xpad->work_pending)
> +					PREPARE_WORK(&xpad->work, &xpad_work_controller);
> +				else
> +					INIT_WORK(&xpad->work, &xpad_work_controller);
> +				xpad->work_pending = 1;
> +				schedule_work(&xpad->work);
> +				kobject_uevent(&xpad->dev->dev.kobj, KOBJ_ONLINE);
> +			}
> +		}
> +		else {
> +			kobject_uevent(&xpad->dev->dev.kobj, KOBJ_OFFLINE);
> +			xpad->controller_present = 0;
> +			xpad->controller_unique_id[0] = '\0';
> +			xpad->controller_type = XCONTROLLER_TYPE_NONE;
> +			/* We do NOT flush the shared workqueue here, because
> +			 * this function is called from an interrupt handler.
> +			 * If the controller has disconnected from the receiver,
> +			 * the worst that will happen from the work task running
> +			 * is that a packet will be transmitted from the
> +			 * receiver to a non-listening controller
> +			 */
> +		}
>  	}
>  
> -	/* Valid pad data */
> -	if (!(data[1] & 0x1))
> -		return;
> -
> -	xpad360_process_packet(xpad, cmd, &data[4]);
> +	/* Process packets according to type */
> +	if (data[1] == 0x0f) {
> +		if (! xpad->controller_unique_id[0]) {
> +			xpad360w_identify_controller(xpad, data);
> +			xpad_init_controller(xpad);
> +		}
> +	}
> +	else if (data[1] & 0x1) {
> +		xpad360_process_packet(xpad, cmd, &data[4]);
> +	}
>  }
>  
> +
>  static void xpad_irq_in(struct urb *urb)
>  {
>  	struct usb_xpad *xpad = urb->context;
> @@ -445,24 +573,16 @@
>  		     __func__, retval);
>  }
>  
> -static void xpad_bulk_out(struct urb *urb)
> -{
> -	switch (urb->status) {
> -	case 0:
> -		/* success */
> -		break;
> -	case -ECONNRESET:
> -	case -ENOENT:
> -	case -ESHUTDOWN:
> -		/* this urb is terminated, clean up */
> -		dbg("%s - urb shutting down with status: %d", __func__, urb->status);
> -		break;
> -	default:
> -		dbg("%s - nonzero urb status received: %d", __func__, urb->status);
> -	}
> -}
>  
> +/* end input section */
> +
> +/*****************************************************************************/
> +/* IRQ output section: present in object code only if the force feedback or
> + * LED interface is enabled.
> + */
> + 
>  #if defined(CONFIG_JOYSTICK_XPAD_FF) || defined(CONFIG_JOYSTICK_XPAD_LEDS)
> +
>  static void xpad_irq_out(struct urb *urb)
>  {
>  	int retval, status;
> @@ -493,12 +613,13 @@
>  		    __func__, retval);
>  }
>  
> +
>  static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad)
>  {
>  	struct usb_endpoint_descriptor *ep_irq_out;
>  	int error = -ENOMEM;
>  
> -	if (xpad->xtype != XTYPE_XBOX360)
> +	if ((xpad->xtype != XTYPE_XBOX360) && (xpad->xtype != XTYPE_XBOX360W))
>  		return 0;
>  
>  	xpad->odata = usb_buffer_alloc(xpad->udev, XPAD_PKT_LEN,
> @@ -526,45 +647,82 @@
>   fail1:	return error;
>  }
>  
> +
>  static void xpad_stop_output(struct usb_xpad *xpad)
>  {
> -	if (xpad->xtype == XTYPE_XBOX360)
> +	if ((xpad->xtype == XTYPE_XBOX360) || (xpad->xtype == XTYPE_XBOX360W))
>  		usb_kill_urb(xpad->irq_out);
>  }
>  
> +
>  static void xpad_deinit_output(struct usb_xpad *xpad)
>  {
> -	if (xpad->xtype == XTYPE_XBOX360) {
> +	if ((xpad->xtype == XTYPE_XBOX360) || (xpad->xtype == XTYPE_XBOX360W)) {
>  		usb_free_urb(xpad->irq_out);
>  		usb_buffer_free(xpad->udev, XPAD_PKT_LEN,
>  				xpad->odata, xpad->odata_dma);
>  	}
>  }
> +
>  #else
> +/* Dummy implementations for xpad_probe and xpad_disconnect */
>  static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad) { return 0; }
>  static void xpad_deinit_output(struct usb_xpad *xpad) {}
>  static void xpad_stop_output(struct usb_xpad *xpad) {}
>  #endif
>  
> -#ifdef CONFIG_JOYSTICK_XPAD_FF
> +/* end output section */
> +
> +/*****************************************************************************/
> +
> +/* Force feedback (rumble effect) section, depends on CONFIG_JOYSTICK_XPAD_FF */
> +
> +#if defined(CONFIG_JOYSTICK_XPAD_FF)
> +
> +/* Rumble support for wireless controllers follows protocol description
> + * from xboxdrv userspace driver:
> + *       http://pingus.seul.org/~grumbel/xboxdrv/
> + */
>  static int xpad_play_effect(struct input_dev *dev, void *data,
>  			    struct ff_effect *effect)
>  {
>  	struct usb_xpad *xpad = input_get_drvdata(dev);
> +	
> +	if (! xpad->rumble_enable)
> +		return 0;
>  
>  	if (effect->type == FF_RUMBLE) {
>  		__u16 strong = effect->u.rumble.strong_magnitude;
>  		__u16 weak = effect->u.rumble.weak_magnitude;
> -		xpad->odata[0] = 0x00;
> -		xpad->odata[1] = 0x08;
> -		xpad->odata[2] = 0x00;
> -		xpad->odata[3] = strong / 256;
> -		xpad->odata[4] = weak / 256;
> -		xpad->odata[5] = 0x00;
> -		xpad->odata[6] = 0x00;
> -		xpad->odata[7] = 0x00;
> -		xpad->irq_out->transfer_buffer_length = 8;
> +		mutex_lock(&xpad->odata_mutex);
> +		if (xpad->xtype == XTYPE_XBOX360W) {
> +			xpad->odata[0] = 0x00;
> +			xpad->odata[1] = 0x01;
> +			xpad->odata[2] = 0x0f;
> +			xpad->odata[3] = 0xc0;
> +			xpad->odata[4] = 0x00;
> +			xpad->odata[5] = strong / 256;
> +			xpad->odata[6] = weak / 256;
> +			xpad->odata[7] = 0x00;
> +			xpad->odata[8] = 0x00;
> +			xpad->odata[9] = 0x00;
> +			xpad->odata[10] = 0x00;
> +			xpad->odata[11] = 0x00;
> +			xpad->irq_out->transfer_buffer_length = 12;
> +		}
> +		else {
> +			xpad->odata[0] = 0x00;
> +			xpad->odata[1] = 0x08;
> +			xpad->odata[2] = 0x00;
> +			xpad->odata[3] = strong / 256;
> +			xpad->odata[4] = weak / 256;
> +			xpad->odata[5] = 0x00;
> +			xpad->odata[6] = 0x00;
> +			xpad->odata[7] = 0x00;
> +			xpad->irq_out->transfer_buffer_length = 8;
> +		}
>  		usb_submit_urb(xpad->irq_out, GFP_KERNEL);
> +		mutex_unlock(&xpad->odata_mutex);
>  	}
>  
>  	return 0;
> @@ -572,7 +730,7 @@
>  
>  static int xpad_init_ff(struct usb_xpad *xpad)
>  {
> -	if (xpad->xtype != XTYPE_XBOX360)
> +	if ((xpad->xtype != XTYPE_XBOX360) && (xpad->xtype != XTYPE_XBOX360W))
>  		return 0;
>  
>  	input_set_capability(xpad->dev, EV_FF, FF_RUMBLE);
> @@ -581,26 +739,50 @@
>  }
>  
>  #else
> +/* dummy implementation for xpad_probe */
>  static int xpad_init_ff(struct usb_xpad *xpad) { return 0; }
>  #endif
>  
> +
> +/* end force feedback section */
> +
> +/*****************************************************************************/
> +
> +/* LED handling section: provides support for the ring of LEDs on the 360
> + * controllers. */
> +
>  #if defined(CONFIG_JOYSTICK_XPAD_LEDS)
> -#include <linux/leds.h>
>  
> -struct xpad_led {
> -	char name[16];
> -	struct led_classdev led_cdev;
> -	struct usb_xpad *xpad;
> -};
>  
> +/* XBox 360 wireless controller follows protocol from xboxdrv userspace
> + * driver:
> + *    http://pingus.seul.org/~grumbel/xboxdrv/
> + */
>  static void xpad_send_led_command(struct usb_xpad *xpad, int command)
>  {
>  	if (command >= 0 && command < 14) {
>  		mutex_lock(&xpad->odata_mutex);
> -		xpad->odata[0] = 0x01;
> -		xpad->odata[1] = 0x03;
> -		xpad->odata[2] = command;
> -		xpad->irq_out->transfer_buffer_length = 3;
> +		if (xpad->xtype == XTYPE_XBOX360W) {
> +			xpad->odata[0] = 0x00;
> +			xpad->odata[1] = 0x00;
> +			xpad->odata[2] = 0x08;
> +			xpad->odata[3] = 0x40 + (command % 0x0e);
> +			xpad->odata[4] = 0x00;
> +			xpad->odata[5] = 0x00;
> +			xpad->odata[6] = 0x00;
> +			xpad->odata[7] = 0x00;
> +			xpad->odata[8] = 0x00;
> +			xpad->odata[9] = 0x00;
> +			xpad->odata[10] = 0x00;
> +			xpad->odata[11] = 0x00;
> +			xpad->irq_out->transfer_buffer_length = 12;
> +		}
> +		else {
> +			xpad->odata[0] = 0x01;
> +			xpad->odata[1] = 0x03;
> +			xpad->odata[2] = command;
> +			xpad->irq_out->transfer_buffer_length = 3;
> +		}
>  		usb_submit_urb(xpad->irq_out, GFP_KERNEL);
>  		mutex_unlock(&xpad->odata_mutex);
>  	}
> @@ -615,6 +797,7 @@
>  	xpad_send_led_command(xpad_led->xpad, value);
>  }
>  
> +
>  static int xpad_led_probe(struct usb_xpad *xpad)
>  {
>  	static atomic_t led_seq	= ATOMIC_INIT(0);
> @@ -623,7 +806,7 @@
>  	struct led_classdev *led_cdev;
>  	int error;
>  
> -	if (xpad->xtype != XTYPE_XBOX360)
> +	if ((xpad->xtype != XTYPE_XBOX360) && (xpad->xtype != XTYPE_XBOX360W))
>  		return 0;
>  
>  	xpad->led = led = kzalloc(sizeof(struct xpad_led), GFP_KERNEL);
> @@ -664,10 +847,16 @@
>  	}
>  }
>  #else
> +/* dummies for xpad_probe and xpad_disconnect */
>  static int xpad_led_probe(struct usb_xpad *xpad) { return 0; }
>  static void xpad_led_disconnect(struct usb_xpad *xpad) { }
>  #endif
>  
> +/* end LED section */
> +
> +/*****************************************************************************/
> +
> +/* Module and device functions */
>  
>  static int xpad_open(struct input_dev *dev)
>  {
> @@ -721,6 +910,7 @@
>  	struct usb_xpad *xpad;
>  	struct input_dev *input_dev;
>  	struct usb_endpoint_descriptor *ep_irq_in;
> +	int controller_type;
>  	int i;
>  	int error = -ENOMEM;
>  
> @@ -747,6 +937,7 @@
>  	xpad->udev = udev;
>  	xpad->dpad_mapping = xpad_device[i].dpad_mapping;
>  	xpad->xtype = xpad_device[i].xtype;
> +	controller_type = xpad_device[i].controller_type;
>  	if (xpad->dpad_mapping == MAP_DPAD_UNKNOWN)
>  		xpad->dpad_mapping = !dpad_to_buttons;
>  	if (xpad->xtype == XTYPE_UNKNOWN) {
> @@ -819,6 +1010,10 @@
>  		goto fail4;
>  
>  	usb_set_intfdata(intf, xpad);
> +	
> +	xpad->controller_type = controller_type;
> +	if (controller_type != XCONTROLLER_TYPE_NONE)
> +		xpad_init_controller(xpad);
>  
>  	/*
>  	 * Submit the int URB immediatly rather than waiting for open
> @@ -828,48 +1023,38 @@
>  	 * we're waiting for.
>  	 */
>  	if (xpad->xtype == XTYPE_XBOX360W) {
> +		xpad->controller_present = 0;
> +		xpad->controller_unique_id[0] = '\0';
> +		xpad->controller_number =
> +			(intf->cur_altsetting->desc.bInterfaceNumber / 2) + 1;
>  		xpad->irq_in->dev = xpad->udev;
>  		error = usb_submit_urb(xpad->irq_in, GFP_KERNEL);
>  		if (error)
> -			goto fail4;
> -
> -		/*
> -		 * Setup the message to set the LEDs on the
> -		 * controller when it shows up
> -		 */
> -		xpad->bulk_out = usb_alloc_urb(0, GFP_KERNEL);
> -		if(!xpad->bulk_out)
>  			goto fail5;
> -
> -		xpad->bdata = kzalloc(XPAD_PKT_LEN, GFP_KERNEL);
> -		if(!xpad->bdata)
> -			goto fail6;
> -
> -		xpad->bdata[2] = 0x08;
> -		switch (intf->cur_altsetting->desc.bInterfaceNumber) {
> -		case 0:
> -			xpad->bdata[3] = 0x42;
> -			break;
> -		case 2:
> -			xpad->bdata[3] = 0x43;
> -			break;
> -		case 4:
> -			xpad->bdata[3] = 0x44;
> -			break;
> -		case 6:
> -			xpad->bdata[3] = 0x45;
> -		}
> -
> -		ep_irq_in = &intf->cur_altsetting->endpoint[1].desc;
> -		usb_fill_bulk_urb(xpad->bulk_out, udev,
> -				usb_sndbulkpipe(udev, ep_irq_in->bEndpointAddress),
> -				xpad->bdata, XPAD_PKT_LEN, xpad_bulk_out, xpad);
>  	}
> +	else {
> +		xpad->controller_present = 1;
> +		strncpy(xpad->controller_unique_id, "wired", 17);
> +		xpad->controller_number = 0;
> +	}
> +	
> +	/* Set up device attributes */
> +#ifdef CONFIG_SYSFS
> +	xpad->sysfs_ok = 1;
> +	error = sysfs_create_group(&input_dev->dev.kobj, &xpad_default_attr_group);
> +	if (error) {
> +		/* Driver will work without the sysfs interface, but parameters
> +		 * will not be adjustable, so this failure is a warning. */
> +		printk(KERN_WARNING "xpad: sysfs_create_group failed with error %d\n", error);
> +		xpad->sysfs_ok = 0;
> +	}
> +#endif


No need to check for CONFIG_SYSFS, sysfs_create_group will be a no-op which returns 0
if not built.


>  
>  	return 0;
>  
> - fail6:	usb_free_urb(xpad->bulk_out);
> - fail5:	usb_kill_urb(xpad->irq_in);
> + fail5: usb_set_intfdata(intf, NULL);
> + 	input_unregister_device(xpad->dev);
> + 	xpad_led_disconnect(xpad);
>   fail4:	usb_free_urb(xpad->irq_in);
>   fail3:	xpad_deinit_output(xpad);
>   fail2:	usb_buffer_free(udev, XPAD_PKT_LEN, xpad->idata, xpad->idata_dma);
> @@ -885,12 +1070,19 @@
>  
>  	usb_set_intfdata(intf, NULL);
>  	if (xpad) {
> +		/* If a work task remains, get rid of it by flushing the
> +		 * shared work queue.
> +		 */
> +		if (xpad->work_pending)
> +			flush_scheduled_work();
> +#ifdef CONFIG_SYSFS
> +		if (xpad->sysfs_ok)
> +			sysfs_remove_group(&xpad->dev->dev.kobj, &xpad_default_attr_group);
> +#endif


Ditto.


>  		xpad_led_disconnect(xpad);
>  		input_unregister_device(xpad->dev);
>  		xpad_deinit_output(xpad);
>  		if (xpad->xtype == XTYPE_XBOX360W) {
> -			usb_kill_urb(xpad->bulk_out);
> -			usb_free_urb(xpad->bulk_out);
>  			usb_kill_urb(xpad->irq_in);
>  		}
>  		usb_free_urb(xpad->irq_in);
> @@ -900,12 +1092,7 @@
>  	}
>  }
>  
> -static struct usb_driver xpad_driver = {
> -	.name		= "xpad",
> -	.probe		= xpad_probe,
> -	.disconnect	= xpad_disconnect,
> -	.id_table	= xpad_table,
> -};
> +
>  
>  static int __init usb_xpad_init(void)
>  {
> @@ -920,9 +1107,4 @@
>  	usb_deregister(&xpad_driver);
>  }
>  
> -module_init(usb_xpad_init);
> -module_exit(usb_xpad_exit);
>  
> -MODULE_AUTHOR(DRIVER_AUTHOR);
> -MODULE_DESCRIPTION(DRIVER_DESC);
> -MODULE_LICENSE("GPL");
> diff -uNr origdrv/drivers/input/joystick/xpad.h newdrv/drivers/input/joystick/xpad.h
> --- origdrv/drivers/input/joystick/xpad.h	1969-12-31 19:00:00.000000000 -0500
> +++ newdrv/drivers/input/joystick/xpad.h	2009-02-21 23:49:36.000000000 -0500
> @@ -0,0 +1,578 @@
> +/*
> + * Xbox gamepad driver with Xbox 360 wired/wireless support
> + *
> + * Last Modified:	21 February 2009
> + *			Mike Murphy <mamurph@cs.clemson.edu>
> + *
> + * Copyright (c) 2002 Marko Friedemann <mfr@bmx-chemnitz.de>
> + *               2004 Oliver Schwartz <Oliver.Schwartz@gmx.de>,
> + *                    Steven Toth <steve@toth.demon.co.uk>,
> + *                    Franz Lehner <franz@caos.at>,
> + *                    Ivan Hawkes <blackhawk@ivanhawkes.com>
> + *               2005 Dominic Cerquetti <binary1230@yahoo.com>
> + *               2006 Adam Buchbinder <adam.buchbinder@gmail.com>
> + *               2007 Jan Kratochvil <honza@jikos.cz>
> + *               2009 Clemson University
> + *		      (contact: Mike Murphy <mamurph@cs.clemson.edu>)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + *
> + *
> + * This driver is based on:
> + *  - information from     http://euc.jp/periphs/xbox-controller.ja.html
> + *  - the iForce driver    drivers/char/joystick/iforce.c
> + *  - the skeleton-driver  drivers/usb/usb-skeleton.c
> + *  - Xbox 360 information http://www.free60.org/wiki/Gamepad
> + *  - xboxdrv docs         http://pingus.seul.org/~grumbel/xboxdrv/
> + *
> + * Thanks to:
> + *  - ITO Takayuki for providing essential xpad information on his website
> + *  - Vojtech Pavlik     - iforce driver / input subsystem
> + *  - Greg Kroah-Hartman - usb-skeleton driver
> + *  - XBOX Linux project - extra USB id's
> + *
> + * TODO:
> + *  - fix "analog" buttons (reported as digital now)
> + *  - need USB IDs for other dance pads
> + *
> + * Driver history is located at the bottom of this file.
> + */
> +
> +#ifndef _XPAD_H
> +#define _XPAD_H
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/stat.h>
> +#include <linux/module.h>
> +#include <linux/usb/input.h>
> +#include <linux/workqueue.h>
> +
> +#if defined(CONFIG_SYSFS)
> +#include <linux/kobject.h>
> +#include <linux/sysfs.h>
> +#include <linux/string.h>
> +#endif


Same here, conditionally including these files is not necessary.


> +
> +#if defined(CONFIG_JOYSTICK_XPAD_LEDS)
> +#include <linux/leds.h>
> +
> +struct xpad_led {
> +	char name[16];
> +	struct led_classdev led_cdev;
> +	struct usb_xpad *xpad;
> +};
> +#endif
> +


Ditto. Actually it's useful for data which consume memory,
or fields inside structures, but not for types themselves.

But well, these parts are a removing, not new code.

Anyway, looks like a nice work.


Frederic.


> +#define DRIVER_AUTHOR "Marko Friedemann <mfr@bmx-chemnitz.de>"
> +#define DRIVER_DESC "Xbox/360 pad driver"
> +
> +#define XPAD_PKT_LEN 32
> +
> +
> +/* xbox d-pads should map to buttons, as is required for DDR pads
> +   but we map them to axes when possible to simplify things */
> +#define MAP_DPAD_TO_BUTTONS    0
> +#define MAP_DPAD_TO_AXES       1
> +#define MAP_DPAD_UNKNOWN       2
> +
> +/* Type of controller *interface* (original, wired 360, wireless 360) */
> +#define XTYPE_XBOX        0
> +#define XTYPE_XBOX360     1
> +#define XTYPE_XBOX360W    2
> +#define XTYPE_UNKNOWN     3
> +
> +/* Type of controller (e.g. pad, guitar, other input device) */
> +#define XCONTROLLER_TYPE_NONE		0
> +#define XCONTROLLER_TYPE_PAD		1
> +#define XCONTROLLER_TYPE_GUITAR		2
> +#define XCONTROLLER_TYPE_DANCE_PAD	3
> +#define XCONTROLLER_TYPE_OTHER		255
> +
> +
> +/* The Xbox 360 controllers have sensitive sticks that often do not center
> + * exactly. A dead zone causes stick events below a certain threshhold to be
> + * reported as zero.
> + *
> + * The default dead zone size is 8192, which was obtained by testing a
> + * wireless 360 controller with jstest(1) and consulting gaming forums for
> + * a recommended dead zone for this controller. The consensus opinion was
> + * 0.25 (on a scale from 0 to 1), which corresponds to 8192 (out of 32767).
> + */
> +#define XDEAD_ZONE_DEFAULT   8192
> +
> +/* Default limit for the sticks is the maximum axis value (32767), which will
> + * cause the sticks to have a radial axis as designed in the hardware. To
> + * enable square axis support, set the stick limits to 23170 or lower at run
> + * time via the sysfs interface. */
> +#define XSTICK_LIMIT_DEFAULT 32767
> +
> +/* Rumble normally enabled */
> +#define XRUMBLE_DEFAULT		1
> +
> +
> +/* This module parameter is something of a relic, but it remains for
> + * compatibility. Importantly, the option to map the D-PAD buttons applies
> + * only to controller *interfaces* (i.e. vendor and product codes) not
> + * explicitly present in xpad_device[]. */
> +static int dpad_to_buttons = 0;
> +module_param(dpad_to_buttons, bool, S_IRUGO);
> +MODULE_PARM_DESC(dpad_to_buttons, "Map D-PAD to buttons rather than axes for unknown pads");
> +
> +
> +/* Table of various device interfaces recognized by this driver. Each supported
> + * device has a directional pad mapping, interface type, and controller type.
> + * Note that wireless 360 devices have XCONTROLLER_TYPE_NONE, as the actual
> + * type of the gaming controller is not known until the controller binds
> + * wirelessly with the receiver
> + */
> +static const struct xpad_device {
> +	u16 idVendor;
> +	u16 idProduct;
> +	char *name;
> +	u8 dpad_mapping;
> +	u8 xtype;
> +	u8 controller_type;
> +} xpad_device[] = {
> +	{ 0x045e, 0x0202, "Microsoft X-Box pad v1 (US)", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x045e, 0x0289, "Microsoft X-Box pad v2 (US)", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x045e, 0x0285, "Microsoft X-Box pad (Japan)", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x045e, 0x0287, "Microsoft Xbox Controller S", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x045e, 0x0719, "Xbox 360 Wireless Receiver", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360W,
> +		XCONTROLLER_TYPE_NONE },
> +	{ 0x0c12, 0x8809, "RedOctane Xbox Dance Pad", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_DANCE_PAD },
> +	{ 0x044f, 0x0f07, "Thrustmaster, Inc. Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x046d, 0xc242, "Logitech Chillstream Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX360,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x046d, 0xca84, "Logitech Xbox Cordless Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x046d, 0xca88, "Logitech Compact Controller for Xbox", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x05fd, 0x1007, "Mad Catz Controller (unverified)", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x05fd, 0x107a, "InterAct 'PowerPad Pro' X-Box pad (Germany)", MAP_DPAD_TO_AXES,
> +		XTYPE_XBOX, XCONTROLLER_TYPE_PAD },
> +	{ 0x0738, 0x4516, "Mad Catz Control Pad", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x0738, 0x4522, "Mad Catz LumiCON", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x0738, 0x4526, "Mad Catz Control Pad Pro", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x0738, 0x4536, "Mad Catz MicroCON", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x0738, 0x4540, "Mad Catz Beat Pad", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_DANCE_PAD },
> +	{ 0x0738, 0x4556, "Mad Catz Lynx Wireless Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x0738, 0x4716, "Mad Catz Wired Xbox 360 Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX360,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x0738, 0x6040, "Mad Catz Beat Pad Pro", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_DANCE_PAD },
> +	{ 0x0c12, 0x8802, "Zeroplus Xbox Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x0c12, 0x880a, "Pelican Eclipse PL-2023", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x0c12, 0x8810, "Zeroplus Xbox Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x0c12, 0x9902, "HAMA VibraX - *FAULTY HARDWARE*", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x0e4c, 0x1097, "Radica Gamester Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x0e4c, 0x2390, "Radica Games Jtech Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x0e6f, 0x0003, "Logic3 Freebird wireless Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x0e6f, 0x0005, "Eclipse wireless Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x0e6f, 0x0006, "Edge wireless Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x0e6f, 0x0006, "Pelican 'TSZ' Wired Xbox 360 Controller", MAP_DPAD_TO_AXES,
> +		XTYPE_XBOX360, XCONTROLLER_TYPE_PAD },
> +	{ 0x0e8f, 0x0201, "SmartJoy Frag Xpad/PS2 adaptor", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x0f30, 0x0202, "Joytech Advanced Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x0f30, 0x8888, "BigBen XBMiniPad Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x102c, 0xff0c, "Joytech Wireless Advanced Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x12ab, 0x8809, "Xbox DDR dancepad", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_DANCE_PAD },
> +	{ 0x1430, 0x4748, "RedOctane Guitar Hero X-plorer", MAP_DPAD_TO_AXES, XTYPE_XBOX360,
> +		XCONTROLLER_TYPE_GUITAR },
> +	{ 0x1430, 0x8888, "TX6500+ Dance Pad (first generation)", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_DANCE_PAD },
> +	{ 0x045e, 0x028e, "Microsoft X-Box 360 pad", MAP_DPAD_TO_AXES, XTYPE_XBOX360,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX,
> +		XCONTROLLER_TYPE_PAD },
> +	{ 0x0000, 0x0000, "Generic X-Box pad", MAP_DPAD_UNKNOWN, XTYPE_UNKNOWN,
> +		XCONTROLLER_TYPE_PAD }
> +};
> +
> +
> +/* buttons shared with xbox and xbox360 */
> +static const signed short xpad_common_btn[] = {
> +	BTN_A, BTN_B, BTN_X, BTN_Y,			/* "analog" buttons */
> +	BTN_START, BTN_BACK, BTN_THUMBL, BTN_THUMBR,	/* start/back/sticks */
> +	-1						/* terminating entry */
> +};
> +
> +/* original xbox controllers only */
> +static const signed short xpad_btn[] = {
> +	BTN_C, BTN_Z,		/* "analog" buttons */
> +	-1			/* terminating entry */
> +};
> +
> +/* only used if MAP_DPAD_TO_BUTTONS */
> +static const signed short xpad_btn_pad[] = {
> +	BTN_LEFT, BTN_RIGHT,		/* d-pad left, right */
> +	BTN_0, BTN_1,			/* d-pad up, down (XXX names??) */
> +	-1				/* terminating entry */
> +};
> +
> +/* buttons for x360 controller */
> +static const signed short xpad360_btn[] = {
> +	BTN_TL, BTN_TR,		/* Button LB/RB */
> +	BTN_MODE,		/* The big X button */
> +	-1
> +};
> +
> +/* sticks and triggers common to all devices */
> +static const signed short xpad_abs[] = {
> +	ABS_X, ABS_Y,		/* left stick */
> +	ABS_RX, ABS_RY,		/* right stick */
> +	ABS_Z, ABS_RZ,		/* triggers left/right */
> +	-1			/* terminating entry */
> +};
> +
> +/* only used if MAP_DPAD_TO_AXES */
> +static const signed short xpad_abs_pad[] = {
> +	ABS_HAT0X, ABS_HAT0Y,	/* d-pad axes */
> +	-1			/* terminating entry */
> +};
> +
> +
> +/* Xbox 360 has a vendor-specific class, so we cannot match it with only
> + * USB_INTERFACE_INFO (also specifically refused by USB subsystem), so we
> + * match against vendor id as well. Wired Xbox 360 devices have protocol 1,
> + * wireless controllers have protocol 129. */
> +#define XPAD_XBOX360_VENDOR_PROTOCOL(vend,pr) \
> +	.match_flags = USB_DEVICE_ID_MATCH_VENDOR | USB_DEVICE_ID_MATCH_INT_INFO, \
> +	.idVendor = (vend), \
> +	.bInterfaceClass = USB_CLASS_VENDOR_SPEC, \
> +	.bInterfaceSubClass = 93, \
> +	.bInterfaceProtocol = (pr)
> +#define XPAD_XBOX360_VENDOR(vend) \
> +	{ XPAD_XBOX360_VENDOR_PROTOCOL(vend,1) }, \
> +	{ XPAD_XBOX360_VENDOR_PROTOCOL(vend,129) }
> +
> +static struct usb_device_id xpad_table [] = {
> +	{ USB_INTERFACE_INFO('X', 'B', 0) },	/* X-Box USB-IF not approved class */
> +	XPAD_XBOX360_VENDOR(0x045e),		/* Microsoft X-Box 360 controllers */
> +	XPAD_XBOX360_VENDOR(0x046d),		/* Logitech X-Box 360 style controllers */
> +	XPAD_XBOX360_VENDOR(0x0738),		/* Mad Catz X-Box 360 controllers */
> +	XPAD_XBOX360_VENDOR(0x0e6f),		/* 0x0e6f X-Box 360 controllers */
> +	XPAD_XBOX360_VENDOR(0x1430),		/* RedOctane X-Box 360 controllers */
> +	{ }
> +};
> +
> +MODULE_DEVICE_TABLE (usb, xpad_table);
> +
> +
> +/* Wireless 360 device identification.
> + *
> + * When a wireless controller connects, the 2nd packet it sends SEEMS to
> + * be some kind of unique controller identification message. Using usbmon
> + * (see Documentation/usb/usbmon.txt), I tried 4 gamepads and a guitar, and
> + * I collected the following 5 ID packets from the 5 devices:
> + *
> + * 000f00f0 00ccfd27 0060e226 63700010 13e3201d 30034001 5001ffff ff
> + * 000f00f0 f0ccfd27 0060d8c4 e9600009 13e7201d 30034001 5001ffff ff
> + * 000f00f0 00ccfd27 0060578b 82f00010 13e3201d 30034001 5001ffff ff
> + * 000f00f0 f0ccfd27 0060da1c b1500009 13e7201d 30034001 5001ffff ff
> + * 000f00f0 f0ccfd27 006002d1 71d10000 13e3201d 30034430 5107ffff ff
> + *
> + * From this trace data, I concocted the following (potentially incorrect)
> + * scheme for detecting type and unique ID:
> + *
> + * ******** xx****xx xxxxxxxx xxxx**xx **xx**** ****tttt tttt**** **
> + *                |  unique id |                    |  type |
> + *
> + * It appears that some of the bytes in the first half of the message, noted
> + * above as "unique id" are some sort of serial number, though I cannot work
> + * out any correspondence between these bytes and the serial number printed
> + * under the battery pack. Many of the bytes in this possibly unique field
> + * are not unique across my controllers, and may not in fact be part of the
> + * controller's unique identification, but I figured it was better to have
> + * extra bytes on either end of the unique byte string instead of the
> + * alternative. In addition, the packet appears to indicate the type of
> + * the controller toward the end: the pads all send 4001 5001, while the
> + * guitar sends 4430 5107.
> + *
> + * Further testing over a wider variety of devices is probably needed to
> + * determine if changes need to be made to this scheme.
> + */
> +static const struct w360_id {
> +	u32 id_bytes;
> +	u8 controller_type;
> +} w360_id[] = {
> +	{ 0x40015001, XCONTROLLER_TYPE_PAD },
> +	{ 0x44305107, XCONTROLLER_TYPE_GUITAR },
> +	{ 0x00000000, XCONTROLLER_TYPE_NONE }
> +};
> +
> +
> +/* Some of the fields in the following structure are for later use with
> + * userspace applications to recognize individual controllers. The dead zones
> + * and axis limits can be changed "on the fly" and are effective immediately.
> + *
> + * The fields labeled "ro" and "rw" are intended to be read-only and
> + * read-write, respectively, when exposed in sysfs. Most of the read-only
> + * fields are to support *wireless* 360 controllers. The controller_number
> + * is used to set the LED, while controller_present tracks whether the
> + * controller is connected to the wireless receiver. Controller type applies
> + * to all models (wired and wireless), and tracks whether the device is a pad,
> + * guitar, etc. for later userspace use. See the comment above regarding
> + * type and unique ID detection on wireless 360 receivers.
> + */
> +struct usb_xpad {
> +	struct input_dev *dev;		/* input device interface */
> +	struct usb_device *udev;	/* usb device */
> +
> +	struct urb *irq_in;		/* urb for interrupt in report */
> +	unsigned char *idata;		/* input data */
> +	dma_addr_t idata_dma;
> +
> +#if defined(CONFIG_JOYSTICK_XPAD_FF) || defined(CONFIG_JOYSTICK_XPAD_LEDS)
> +	struct urb *irq_out;		/* urb for interrupt out report */
> +	unsigned char *odata;		/* output data */
> +	dma_addr_t odata_dma;
> +	struct mutex odata_mutex;
> +#endif
> +
> +#if defined(CONFIG_JOYSTICK_XPAD_LEDS)
> +	struct xpad_led *led;
> +#endif
> +
> +	char phys[64];			/* physical device path */
> +
> +	int dpad_mapping;		/* map d-pad to buttons or to axes */
> +	int xtype;			/* type of xbox device */
> +	
> +	/* Work structure for moving the call to xpad_send_led_command
> +	 * outside the interrupt handler for packet processing */
> +	struct work_struct work;
> +	int work_pending;
> +	
> +	int controller_number;		/* controller number (1-4) for 360w. ro */
> +	int controller_present;         /* 360w controller presence detection. ro */
> +	int controller_type;            /* controller type. ro */
> +	char controller_unique_id[17];  /* unique ID of controller (360w). ro */
> +	unsigned int left_dead_zone;    /* dead zone for left stick. rw */
> +	unsigned int right_dead_zone;   /* dead zone for right stick. rw */
> +	unsigned int left_stick_limit;  /* stick axis limit for left stick. rw */
> +	unsigned int right_stick_limit; /* stick axis limit for right stick. rw */
> +	int rumble_enable;              /* enable/disable rumble. rw */
> +	
> +#if defined(CONFIG_SYSFS)
> +	int sysfs_ok;                   /* sysfs interface OK */
> +#endif
> +};
> +#define to_xpad(d) input_get_drvdata(to_input_dev(d))
> +
> +
> +/* Function prototypes for non-sysfs interface functions */
> +static void set_dead_zone(unsigned int new_size, unsigned int *dz, unsigned int stick_limit);
> +static void set_stick_limit(unsigned int new_size, unsigned int *sl, unsigned int dead_zone);
> +static void xpad_init_controller(struct usb_xpad *xpad);
> +static void xpad_send_led_command(struct usb_xpad *xpad, int command);
> +static void xpad_work_controller(struct work_struct *w);
> +static void xpad_process_sticks(struct usb_xpad *xpad, unsigned char *data);
> +static void xpad_process_packet(struct usb_xpad *xpad, u16 cmd, unsigned char *data);
> +static void xpad360_process_packet(struct usb_xpad *xpad,
> +				   u16 cmd, unsigned char *data);
> +static void xpad360w_identify_controller(struct usb_xpad *xpad, unsigned char *data);
> +static void xpad360w_process_packet(struct usb_xpad *xpad, u16 cmd, unsigned char *data);
> +static void xpad_irq_in(struct urb *urb);
> +static void xpad_irq_out(struct urb *urb);
> +static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad);
> +static void xpad_stop_output(struct usb_xpad *xpad);
> +static void xpad_stop_output(struct usb_xpad *xpad);
> +static int xpad_play_effect(struct input_dev *dev, void *data,
> +			    struct ff_effect *effect);
> +static int xpad_init_ff(struct usb_xpad *xpad);
> +static void xpad_send_led_command(struct usb_xpad *xpad, int command);
> +static void xpad_led_set(struct led_classdev *led_cdev, enum led_brightness value);
> +static int xpad_led_probe(struct usb_xpad *xpad);
> +static void xpad_led_disconnect(struct usb_xpad *xpad);
> +static int xpad_open(struct input_dev *dev);
> +static void xpad_close(struct input_dev *dev);
> +static void xpad_set_up_abs(struct input_dev *input_dev, signed short abs);
> +static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id);
> +static void xpad_disconnect(struct usb_interface *intf);
> +static int __init usb_xpad_init(void);
> +static void __exit usb_xpad_exit(void);
> +
> +
> +/* sysfs interface */
> +#if defined(CONFIG_SYSFS)
> +static ssize_t xpad_show_uint(struct device *dev, struct device_attribute *attr,
> +		char *buf);
> +static ssize_t xpad_store_uint(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count);
> +static ssize_t xpad_store_rumble_enable(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count);
> +static ssize_t xpad_store_ro(struct device *dev, struct device_attribute *attr,
> +		const char *buf, size_t count);
> +static ssize_t xpad_show_int(struct device *dev, struct device_attribute *attr,
> +		char *buf);
> +static ssize_t xpad_show_id(struct device *dev,
> +		struct device_attribute *attr, char *buf);
> +
> +	
> +
> +/* Device attributes */
> +static DEVICE_ATTR(left_dead_zone, 0666, xpad_show_uint, xpad_store_uint);
> +static DEVICE_ATTR(right_dead_zone, 0666, xpad_show_uint, xpad_store_uint);
> +static DEVICE_ATTR(left_stick_limit, 0666, xpad_show_uint, xpad_store_uint);
> +static DEVICE_ATTR(right_stick_limit, 0666, xpad_show_uint, xpad_store_uint);
> +static DEVICE_ATTR(rumble_enable, 0666, xpad_show_int, xpad_store_rumble_enable);
> +static DEVICE_ATTR(controller_number, 0444, xpad_show_int, xpad_store_ro);
> +static DEVICE_ATTR(controller_present, 0444, xpad_show_int, xpad_store_ro);
> +static DEVICE_ATTR(controller_type, 0444, xpad_show_int, xpad_store_ro);
> +static DEVICE_ATTR(id, 0444, xpad_show_id, xpad_store_ro);
> +
> +static struct attribute *xpad_default_attrs[] = {
> +	&dev_attr_left_dead_zone.attr,
> +	&dev_attr_right_dead_zone.attr,
> +	&dev_attr_left_stick_limit.attr,
> +	&dev_attr_right_stick_limit.attr,
> +	&dev_attr_rumble_enable.attr,
> +	&dev_attr_controller_number.attr,
> +	&dev_attr_controller_present.attr,
> +	&dev_attr_controller_type.attr,
> +	&dev_attr_id.attr,
> +	NULL
> +};
> +
> +static struct attribute_group xpad_default_attr_group = {
> +	.attrs = xpad_default_attrs,
> +	.name = "game_device",
> +};
> +#endif
> +
> +
> +static struct usb_driver xpad_driver = {
> +	.name		= "xpad",
> +	.probe		= xpad_probe,
> +	.disconnect	= xpad_disconnect,
> +	.id_table	= xpad_table,
> +};
> +
> +module_init(usb_xpad_init);
> +module_exit(usb_xpad_exit);
> +
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);
> +MODULE_LICENSE("GPL");
> +
> +#endif
> +
> +/* Driver History:
> + *
> + * 2009-02-21 : Refactored and changed stick handling
> + *  - split code into two pieces (xpad.h and xpad.c)
> + *  - cleaned up sysfs interface
> + *  - changed square axis algorithm to an axis limit algorithm, which allows
> + *    size of inscribed square to be adjusted; available for both sticks
> + *  - dead zones now per-stick
> + *
> + * 2009-02-18 : Changes per mailing list (and some additions)
> + *  - revised sysfs interface (thanks Greg K-H)
> + *  - check return values of sscanf (thanks Oliver Neukum)
> + *  - urb submission while holding mutex now once again GFP_KERNEL (thanks Oliver Neukum)
> + *  - work structure fixes (thanks Oliver Neukum)
> + *  - uevents generated for wireless controller online/offline
> + *  - sysfs interface only if CONFIG_SYSFS is set
> + *
> + * 2009-02-15 : Minor adjustments
> + *  - added KOBJ_ONLINE/KOBJ_OFFLINE events when controllers are connected to
> + *    or disconnected from the wireless 360 receiver
> + *  - ignore duplicate connect messages on the same connection
> + *  - added option to enable/disable rumble on a per-controller basis
> + *  - rumble events are not sent to guitar or dance pad devices
> + *
> + * 2009-02-14 : Added sysfs interface
> + *  - dead zones and square axis settings can now be made per-controller
> + *  - removed dead_zone and square_axis module parameters (use sysfs)
> + *  - new square axis algorithm
> + *
> + * 2009-02-13 : Disable square axis for right stick
> + *  - square axis applies to left stick only
> + *
> + * 2009-02-12 : Scaling for dead zone and square axis support
> + *  - axes now scale from 0 to 32767 starting at edge of dead zone
> + *  - increased default dead zone to 8192
> + *  - initial square axis support (reliable only with left stick)
> + *
> + * 2009-02-07 : More wireless 360 controller fixes
> + *  - removed bulk urb completely
> + *  - use xpad_send_led_command to set controller number on LED display
> + *    (wireless 360 controller)
> + *  - dead_zone is now an adjustable module parameter
> + *
> + * 2009-02-06 : Axis handling improvements
> + *  - unified handler for left and right sticks
> + *  - initial support for dead zones
> + *
> + * 2009-02-02 : Wireless 360 controller fixes
> + *  - followed PROTOCOL description from xboxdrv userspace driver
> + *  - LED and rumble support added for wireless 360 controller (protocol
> + *    is different from wired!)
> + *
> + * 2004-10-02 - 0.0.6 : DDR pad support
> + *  - borrowed from the XBOX linux kernel
> + *  - USB id's for commonly used dance pads are present
> + *  - dance pads will map D-PAD to buttons, not axes
> + *  - pass the module paramater 'dpad_to_buttons' to force
> + *    the D-PAD to map to buttons if your pad is not detected
> + *
> + * 2002-07-17 - 0.0.5 : simplified d-pad handling
> + *
> + * 2002-07-16 - 0.0.4 : minor changes, merge with Vojtech's v0.0.3
> + *  - verified the lack of HID and report descriptors
> + *  - verified that ALL buttons WORK
> + *  - fixed d-pad to axes mapping
> + *
> + * 2002-07-14 - 0.0.3 : rework by Vojtech Pavlik
> + *  - indentation fixes
> + *  - usb + input init sequence fixes
> + *
> + * 2002-07-02 - 0.0.2 : basic working version
> + *  - all axes and 9 of the 10 buttons work (german InterAct device)
> + *  - the black button does not work
> + *
> + * 2002-06-27 - 0.0.1 : first version, just said "XBOX HID controller"
> + *
> + */


