Return-Path: <linux-kernel-owner+w=401wt.eu-S1755765AbZCBVqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbZCBVqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbZCBVqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:46:07 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:16469 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbZCBVqE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:46:04 -0500
MIME-Version: 1.0
In-Reply-To: <20090302130425.23cc628d.akpm@linux-foundation.org>
References: <5aa163d00902282053h38b0febbyb37fc30855fdc985@mail.gmail.com>
	 <20090302130425.23cc628d.akpm@linux-foundation.org>
Date: Mon, 2 Mar 2009 16:46:01 -0500
X-Google-Sender-Auth: c0277ad812654bf9
Message-ID: <5aa163d00903021346g59d90241v11f384eb97641e43@mail.gmail.com>
Subject: Re: PATCH [1/3] drivers/input/xpad.c: Improve Xbox 360 wireless 
	support and add sysfs interface
From: Mike Murphy <mamurph@cs.clemson.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, greg@kroah.com, oliver@neukum.org,
       fweisbec@gmail.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 2, 2009 at 4:04 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> my brain hurts.
>
>> +static void set_stick_limit(unsigned int new_size, unsigned int *sl,
>> +             unsigned int dead_zone)
>> +{
>> +     if (new_size < (dead_zone + 1024))
>> +             new_size = dead_zone + 1024;
>> +     if (new_size > 32767)
>> +             new_size = 32767;
>> +     *sl = new_size;
>> +}
>
> Perhaps the intent of these functions would be a bit clearer if they
> were to use min() and max().
>

I was not aware these functions were available inside the kernel...
ditto for abs(). I had done a search to see if they were, but came up
inconclusive.

>>
>> ...
>>
>> +static ssize_t xpad_show_int(struct device *dev, struct device_attribute *attr,
>> +             char *buf)
>> +{
>> +     struct usb_xpad *xpad = to_xpad(dev);
>> +     int value;
>> +     if (attr == &dev_attr_rumble_enable)
>> +             value = xpad->rumble_enable;
>> +     else if (attr == &dev_attr_controller_number)
>> +             value = xpad->controller_number;
>> +     else if (attr == &dev_attr_controller_present)
>> +             value = xpad->controller_present;
>> +     else if (attr == &dev_attr_controller_type)
>> +             value = xpad->controller_type;
>> +     else if (attr == &dev_attr_left_trigger_full_axis)
>> +             value = xpad->left_trigger_full_axis;
>> +     else if (attr == &dev_attr_right_trigger_full_axis)
>> +             value = xpad->right_trigger_full_axis;
>> +     else
>> +             return -EIO;
>> +     return snprintf(buf, PAGE_SIZE, "%d\n", value);
>> +}
>
> The code's a bit unusual.  Most drivers don't have all that
> if-then-else stuff.  They use a separate function for each sysfs file
> and then they wrap it all up into a macro which emits all the data and
> code for each file.
>

I think if I were to do a cleanup on this, my first instinct would be
to do a switch on attr, instead of a nested if/else setup like this
(internally, they are equivalent). I'm not entirely sure how I would
decompose this into a macro... other than to emit a separate
*function* for each show/store. But since the show/store pairs do the
same things for different variables, it seems like having a separate
function for each makes the module a lot bigger than it needs to be.

>>
>> ...
>>
>> +static void xpad_process_sticks(struct usb_xpad *xpad, unsigned char *data)
>> +{
>> +     struct input_dev *dev = xpad->dev;
>> +     int coords[4];    /* x, y, rx, ry */
>> +     int x_offset, y_offset, rx_offset, ry_offset;
>> +     int c;
>> +     int range;
>> +     int abs_magnitude, adjusted_magnitude, difference, scale_fraction;
>> +     int dead_zone[2], stick_limit[2];
>> +
>> +     dead_zone[0] = xpad->left_dead_zone;
>> +     dead_zone[1] = xpad->right_dead_zone;
>> +     stick_limit[0] = xpad->left_stick_limit;
>> +     stick_limit[1] = xpad->right_stick_limit;
>> +
>> +     if (xpad->xtype == XTYPE_XBOX) {
>> +             x_offset = 12;
>> +             y_offset = 14;
>> +             rx_offset = 16;
>> +             ry_offset = 18;
>> +     } else {
>> +             x_offset = 6;
>> +             y_offset = 8;
>> +             rx_offset = 10;
>> +             ry_offset = 12;
>> +     }
>> +
>> +     coords[0] = (__s16) le16_to_cpup((__le16 *)(data + x_offset));
>> +     coords[1] = ~(__s16) le16_to_cpup((__le16 *)(data + y_offset));
>> +     coords[2] = (__s16) le16_to_cpup((__le16 *)(data + rx_offset));
>> +     coords[3] = ~(__s16) le16_to_cpup((__le16 *)(data + ry_offset));
>
> We don't need the first typecast here and if `data' were to have type
> `void *', we could do away with the second cast as well.
>

These two typecasts are in the original xpad driver, which is
presently in-tree (see drivers/input/joystick/xpad.c in the current
stable branch). I did not change the logic here, because I'm not clear
on the intent of the __s16 data type.

The actual device raw data is little-endian from the docs I've read.
What happens if the user is trying to run this driver on a big-endian
architecture? Does __le16 take care of it?

>
>> +     /* Adjustment for dead zone and square axis */
>> +     for (c = 0; c < 4; c++) {
>> +             abs_magnitude = (int) coords[c];
>
> `coords[c]' already has type `int'.
>
>> +             if (abs_magnitude < 0)
>> +                     abs_magnitude = -abs_magnitude;
>
> use abs()?

See above regarding max/min. abs() is certainly what I want here.

>> +     input_report_abs(dev, ABS_X, (__s16) coords[0]);
>> +     input_report_abs(dev, ABS_Y, (__s16) coords[1]);
>> +     input_report_abs(dev, ABS_RX, (__s16) coords[2]);
>> +     input_report_abs(dev, ABS_RY, (__s16) coords[3]);
>> +}
>
> The third argument to input_report_abs() has type `int', and coords[n]
> has type `int'.  Why go and put a __s16 cast in the middle there?
>
> Please review all the typecasting which this patch does with a view to
> deleting as much as possible.
>
> In fact, delete all of it.  If the code then warns or stops working,
> then something was probably already wrongly designed and the
> typecasting was covering up the breakage.
>

I will give this a try... but I only have Intel (little-endian)
systems on which to test the results. I do see that the
input_report_abs takes an int, so I see the type-cast is unnecessary
in this specific section. Once again, I was trying to follow the
original driver, perhaps a little too closely.

>> -     int dpad_mapping;               /* map d-pad to buttons or to axes */
>> -     int xtype;                      /* type of xbox device */
>> -};
>>
>>  /*
>>   *   xpad_process_packet
>>
>> ...
>>
>> +static void xpad360w_identify_controller(struct usb_xpad *xpad,
>> +             unsigned char *data)
>> +{
>> +     u32 id;
>> +     int i;
>> +
>> +     snprintf(xpad->controller_unique_id, 17,
>> +             "%02x%02x%02x%02x%02x%02x%02x%02x",
>> +             data[8], data[9], data[10], data[11], data[12], data[13],
>> +             data[14], data[15]);
>> +
>> +     /* Identify controller type */
>> +     id = (u32) *(data + 22);
>
> Another unneeded cast.

I could do something here as simple as:

id = data[22];

But in that case, someone reading the code might see that data is a
byte array (be it unsigned char * or void *) and assume that id is one
byte in size. In reality, id is 4 bytes, and it is really a byte
string. To be less clever, I should probably just do another snprintf
and change the id field to be unsigned char[5]. If I make this change,
however, the check to identify the controller type will take longer
(basically a strncmp).

Since the code currently runs in an interrupt handler (for wireless
360 devices, at least), I will also need to move the call to this
function to my workqueue task.

>>
>> -#ifdef CONFIG_JOYSTICK_XPAD_FF
>> +/* end output section */
>> +
>> +/*****************************************************************************/
>> +
>> +/* Force feedback (rumble effect) section, depends on CONFIG_JOYSTICK_XPAD_FF */
>> +
>> +#if defined(CONFIG_JOYSTICK_XPAD_FF)
>
> #ifdef CONFIG_JOYSTICK_XPAD_FF
>
> is more typical.
>

I had that form originally in my new code... but the old code used #if
defined(...), so I changed mine to be uniform. I suppose I should be
less ready to accept something just because it's already in the stable
tree... but on the flip side, I didn't want to change parts that were
known to be working.

>
>>
>> ...
>>
>> --- origdrv/drivers/input/joystick/xpad.h     1969-12-31 19:00:00.000000000 -0500
>> +++ newdrv/drivers/input/joystick/xpad.h      2009-02-28 23:20:20.000000000 -0500
>
> This header file contains a large number of statements which emit data.
>
> Such as this:
>
>> +static int dpad_to_buttons;
>> +module_param(dpad_to_buttons, bool, S_IRUGO);
>> +MODULE_PARM_DESC(dpad_to_buttons,
>> +     "Map D-PAD to buttons rather than axes for unknown pads");
>
> and this:
>
>> +static const struct xpad_device {
>> +     u16 idVendor;
>> +     u16 idProduct;
>> +     char *name;
>> +     u8 dpad_mapping;
>> +     u8 xtype;
>> +     u8 controller_type;
>> +} xpad_device[] = {
>
> This is all wrong - those statements should be in a .c file.
>

I had looked up another driver that used a header file in the stable
tree (don't remember which one) and tried to place things according to
where that driver had them. I guess I picked the wrong one :). I'll
move those declarations to the .c file.

There may be some delay in getting an update done. I have a fairly
full plate at the moment, and I always make a test run with the actual
hardware and actual userspace software (read: a video game) prior to
posting a new version of the patch.

Thanks,
Mike
-- 
Mike Murphy
Ph.D. Candidate and NSF Graduate Research Fellow
Clemson University School of Computing
120 McAdams Hall
Clemson, SC 29634-0974 USA
Tel: +1 864.656.2838   Fax: +1 864.656.0145
http://cirg.cs.clemson.edu/~mamurph
