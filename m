Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbZCBVGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbZCBVGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbZCBVFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:05:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755966AbZCBVF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:05:28 -0500
Date: Mon, 2 Mar 2009 13:04:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Murphy <mamurph@cs.clemson.edu>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, greg@kroah.com, oliver@neukum.org,
       fweisbec@gmail.com, torvalds@linux-foundation.org
Subject: Re: PATCH [1/3] drivers/input/xpad.c: Improve Xbox 360 wireless
 support  and add sysfs interface
Message-Id: <20090302130425.23cc628d.akpm@linux-foundation.org>
In-Reply-To: <5aa163d00902282053h38b0febbyb37fc30855fdc985@mail.gmail.com>
References: <5aa163d00902282053h38b0febbyb37fc30855fdc985@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Feb 2009 23:53:03 -0500
Mike Murphy <mamurph@cs.clemson.edu> wrote:

> Improved support for Xbox 360 wireless devices by enabling rumble and
> LED control, improved general usability by adding input controls, and
> added a sysfs interface for tuning driver behavior.
> 
> Signed-off-by: Mike Murphy <mamurph[at]cs.clemson.edu>
> 

>
> ...
>
> +/* The dead zone and stick limit both affect the behavior of the corresponding
> + * analog stick, since the output values reported for the stick inputs will
> + * be scaled onto [0,32767]. It is thus necessary to ensure that the dead zone
> + * is never larger than the stick limit. In fact, a minimal amount of stick
> + * travel space (1024) is maintained between the two values. In practice,
> + * however, the stick limit should always be much greater than the dead zone.
> + */
> +
> +static void set_dead_zone(unsigned int new_size, unsigned int *dz,
> +		unsigned int stick_limit)
> +{
> +	if ((new_size + 1024) >= stick_limit)
> +		new_size = (stick_limit > 1024) ? stick_limit - 1024 : 0;
> +	*dz = new_size;
> +}

my brain hurts.

> +static void set_stick_limit(unsigned int new_size, unsigned int *sl,
> +		unsigned int dead_zone)
> +{
> +	if (new_size < (dead_zone + 1024))
> +		new_size = dead_zone + 1024;
> +	if (new_size > 32767)
> +		new_size = 32767;
> +	*sl = new_size;
> +}

Perhaps the intent of these functions would be a bit clearer if they
were to use min() and max().

>
> ...
>
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
> +	else if (attr == &dev_attr_left_trigger_full_axis)
> +		value = xpad->left_trigger_full_axis;
> +	else if (attr == &dev_attr_right_trigger_full_axis)
> +		value = xpad->right_trigger_full_axis;
> +	else
> +		return -EIO;
> +	return snprintf(buf, PAGE_SIZE, "%d\n", value);
> +}

The code's a bit unusual.  Most drivers don't have all that
if-then-else stuff.  They use a separate function for each sysfs file
and then they wrap it all up into a macro which emits all the data and
code for each file.

>
> ...
>
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
> +	} else {
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

We don't need the first typecast here and if `data' were to have type
`void *', we could do away with the second cast as well.


> +	/* Adjustment for dead zone and square axis */
> +	for (c = 0; c < 4; c++) {
> +		abs_magnitude = (int) coords[c];

`coords[c]' already has type `int'.

> +		if (abs_magnitude < 0)
> +			abs_magnitude = -abs_magnitude;

use abs()?

> +		adjusted_magnitude = abs_magnitude;
> +
> +		range = (stick_limit[c/2] - dead_zone[c/2]);
> +
> +		if (abs_magnitude >= stick_limit[c/2]) {
> +			adjusted_magnitude = 32767;
> +		} else if (abs_magnitude <= dead_zone[c/2]) {
> +			adjusted_magnitude = 0;
> +		} else if (range > 0) {
> +			difference = 32767 - range;
> +			if (difference) {
> +				/* DIVISION: difference non-zero */
> +				scale_fraction = range / difference;
> +				adjusted_magnitude =
> +					abs_magnitude - dead_zone[c/2];
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
> +					adjusted_magnitude +=
> +						adjusted_magnitude
> +						/ scale_fraction;
> +				} else {
> +					/* DIVISION: range non-zero */
> +					scale_fraction = difference / range;
> +					adjusted_magnitude +=
> +						adjusted_magnitude
> +						* scale_fraction;
> +				}
> +				if (adjusted_magnitude > 32767)
> +					adjusted_magnitude = 32767;
> +			}
> +		}
> +		coords[c] = (coords[c] < 0) ?
> +				-adjusted_magnitude : adjusted_magnitude;
> +	}
> +
> +	input_report_abs(dev, ABS_X, (__s16) coords[0]);
> +	input_report_abs(dev, ABS_Y, (__s16) coords[1]);
> +	input_report_abs(dev, ABS_RX, (__s16) coords[2]);
> +	input_report_abs(dev, ABS_RY, (__s16) coords[3]);
> +}

The third argument to input_report_abs() has type `int', and coords[n]
has type `int'.  Why go and put a __s16 cast in the middle there?

Please review all the typecasting which this patch does with a view to
deleting as much as possible.

In fact, delete all of it.  If the code then warns or stops working,
then something was probably already wrongly designed and the
typecasting was covering up the breakage.

> -	int dpad_mapping;		/* map d-pad to buttons or to axes */
> -	int xtype;			/* type of xbox device */
> -};
>  
>  /*
>   *	xpad_process_packet
>
> ...
>
> +static void xpad360w_identify_controller(struct usb_xpad *xpad,
> +		unsigned char *data)
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

Another unneeded cast.

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
> +		printk(KERN_INFO
> +			"xpad: unknown wireless controller type: %08x\n", id);
> +}
> +
> +
>  /*
>   * xpad360w_process_packet
>   *
>
> ...
>
> -#ifdef CONFIG_JOYSTICK_XPAD_FF
> +/* end output section */
> +
> +/*****************************************************************************/
> +
> +/* Force feedback (rumble effect) section, depends on CONFIG_JOYSTICK_XPAD_FF */
> +
> +#if defined(CONFIG_JOYSTICK_XPAD_FF)

#ifdef CONFIG_JOYSTICK_XPAD_FF

is more typical.


>
> ...
>
> --- origdrv/drivers/input/joystick/xpad.h	1969-12-31 19:00:00.000000000 -0500
> +++ newdrv/drivers/input/joystick/xpad.h	2009-02-28 23:20:20.000000000 -0500

This header file contains a large number of statements which emit data.

Such as this:

> +static int dpad_to_buttons;
> +module_param(dpad_to_buttons, bool, S_IRUGO);
> +MODULE_PARM_DESC(dpad_to_buttons,
> +	"Map D-PAD to buttons rather than axes for unknown pads");

and this:

> +static const struct xpad_device {
> +	u16 idVendor;
> +	u16 idProduct;
> +	char *name;
> +	u8 dpad_mapping;
> +	u8 xtype;
> +	u8 controller_type;
> +} xpad_device[] = {

This is all wrong - those statements should be in a .c file.
