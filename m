Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbYDDTIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbYDDTIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 15:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbYDDTHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 15:07:50 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:38285 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbYDDTHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 15:07:50 -0400
Date: Fri, 4 Apr 2008 12:07:12 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Jean Delvare <khali@linux-fr.org>
cc: David Brownell <david-b@pacbell.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch/rfc 2/4] pcf875x I2C GPIO expander driver
In-Reply-To: <20080404100933.077bee33@hyperion.delvare>
Message-ID: <Pine.LNX.4.64.0804041102230.20532@t2.domain.actdsltmp>
References: <200710291809.29936.david-b@pacbell.net> <200711301040.54777.david-b@pacbell.net>
 <20071130211332.49a21a6b@hyperion.delvare> <200711301259.22666.david-b@pacbell.net>
 <Pine.LNX.4.64.0804031844500.11928@t2.domain.actdsltmp>
 <20080404100933.077bee33@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2008, Jean Delvare wrote:
> On Thu, 3 Apr 2008 19:06:27 -0700 (PDT), Trent Piepho wrote:
>> From c65d0fb239b79de7f595e47edb2fb641217e7309 Mon Sep 17 00:00:00 2001
>> From: Trent Piepho <tpiepho@freescale.com>
>> Date: Thu, 3 Apr 2008 18:37:23 -0700
>> Subject: GPIO: Create a sysfs gpio class for messing with GPIOs from userspace
>>
>> struct gpio_chip gets a new field, dev, which points to the struct device
>> of whatever the gpio lines are part of.  If this is non-NULL, gpio class
>> entries are created for this device when gpiochip_add() is called, by a new
>> function gpiochip_classdev_register().
>>
>> It creates a sysfs directory for each gpio the chip defines.  Each device
>> has three attributes so far, direction, value, and label.  label is
>> read-only, and will only be present if DEBUG_FS is on, as without DEBUG_FS
>> the gpio layer doesn't keep track of any labels.
>>
>
> Purely technical review (I can't say whether this interface is better
> than what has been proposed elsewhere or not):
>
>> +	strcpy(buf, test_bit(FLAG_IS_OUT, &gdesc->flags) ? "out\n" : "in\n\0");
>> +
>> +	return 5;
>
> Confusing construct... I suggest using sprintf instead, which will
> automatically return the correct number of bytes for you.

But it's less efficient!  Will nobody think of the wasted cycles?

>> +	} else {
>> +		d = simple_strtoul(buf, NULL, 0);
>
> This exposes to user-space the so far internal-only decision to encode
> output as 1 and input as 0. I don't see much benefit in doing this, in
> particular when you don't check for errors so for example an input of
> "Out" would result in value 0 i.e. input mode. I'd rather support only
> "in" and "out" as valid values and return -EINVAL otherwise.

I guess I wanted to support the interface of using out or 1 vs in or 0, since
both seemed like the two most obvious ways of setting it.  But direction uses
in/out for output, so that's probably the most obvious single interface.

>> +	const struct gpio_desc *gdesc = dev_get_drvdata(dev);
>> +	int n = gdesc - gpio_desc;
>> +
>> +	if (test_bit(FLAG_IS_OUT, &gdesc->flags)) {
>> +		return -EINVAL;
>> +		/* strcpy(buf, "-1\n"); return 4; */ /* Or this? */
>
> Why not just return gpio_get_value(n) in all cases? User might want to
> know which value is currently being output.

I thought the gpiolib layer didn't let you read an output, but I see that's
not the case now.  Maybe it's changed since the first revision?  I've changed
this to call gpio_get_value(n) for outputs too.

Though for the MPC8572 GPIO driver I wrote, it doesn't support reading
outputs.  The hardware doesn't allow it (IMHO, a design flaw), and working
around this significantly slows down GPIO functions.  What I'm trying to do
with the GPIO lines is going to be slower than desired no matter how fast I
make the gpio code (which is almost entirely responsible for the final speed),
so slowing down reads by a factor of four or more just to read back outputs
isn't desirable.

>> +static void __exit gpio_class_exit(void)
>> +{
>> +	/* FIXME:  Code to remove all the sysfs devices and files created
>> +	 * should go here */
>
> Oh yes it really should ;)

I know, but I'm not using modules for the system this is in, so it will never
get called.  What's the point of writing code I'll never use if this isn't
useful for the kernel?

>> @@ -118,6 +290,22 @@ int gpiochip_add(struct gpio_chip *chip)
>>   	}
>>
>>   	spin_unlock_irqrestore(&gpio_lock, flags);
>> +
>> +	if (status)
>> +		goto fail;
>> +
>> +	if (chip->dev) {
>> +		/* can sleep, so can't call with the spinlock held */
>
> You don't actually hold the spinlock at this point.

It would be easier to call gpiochip_classdev_register() earlier when the spin
lock is held, but one can't because it could sleep.  The comment was a warning
to anyone who thought they could simplify the logic.

>>    *	state (such as pullup/pulldown configuration).
>> + * @dev: optional device for the GPIO chip.  Used to create sysfs files.
>
> Broken indentation.

Looks like mailer damage from something, it's correct in my patch file.
