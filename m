Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbYD2Fvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbYD2Fvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 01:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbYD2Fvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 01:51:41 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:32901 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbYD2Fvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 01:51:40 -0400
Date: Mon, 28 Apr 2008 22:48:33 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: David Brownell <david-b@pacbell.net>
cc: lkml <linux-kernel@vger.kernel.org>,
       hartleys <hartleys@visionengravers.com>,
       Ben Nizette <bn@niasdigital.com>, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
In-Reply-To: <200804281745.59442.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.64.0804282202340.8286@t2.domain.actdsltmp>
References: <200804281239.51729.david-b@pacbell.net>
 <Pine.LNX.4.64.0804281507160.6832@t2.domain.actdsltmp>
 <200804281745.59442.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008, David Brownell wrote:
> On Monday 28 April 2008, Trent Piepho wrote:
>> On Mon, 28 Apr 2008, David Brownell wrote:
>>> Simple sysfs interface for GPIOs.
>>>
>>>    /sys/class/gpio
>>>        /gpio-N ... for each exported GPIO #N
>>
>> I liked it better they way I had it, "label:N".
>
> Those labels may not be available though; or valid in pathnames.

So just fall back to "gpio" if there is no label?  The only character that's
not valid in a pathname is '/', so that's trivial to check for.

const char *label = chip->label && !strchr(chip->label, '/') ?
 	chip->label : "gpio"; /* or "generic" or "unknown", or ...*/

This means you don't need a file with number to device assignents.  It makes
shell scripting a lot easier too.  Say I want the first gpio on a pca9557 gpio
expander?  It's will be something like:  /sys/class/gpio/pca9557-0:0

You don't have to worry about dynamic assigments.  You don't have to resort to
convoluted shell script code to extract the proper range from a mapping file
and then construct the name.

>>> 	    /value ... always readable, writes fail except for output GPIOs
>>> 	    /direction ... writable as: in, out (default low), high, low
>>
>> You took away the code for the label field?  That was one of the features of
>> my code that Ben Nizette mentioned as an advantage over a char-device
>> interface.
>
> Since it's not always available, I removed it.  Note that you're
> talking about the label passed to gpio_request() here, not the one
> applied to the gpio_chip.  I could restore this as a "gpio_label"
> attribute, that's not always present ... but I'd rather not have
> such "optional" stuff.

It's nice to be able to see what a driver is using a gpio for.  You could also
assign labels from userspace this way.

>>>    	/control ... to request a GPIO be exported or unexported
>>>
>>> GPIOs may be exported by kernel code using gpio_export(), which should
>>> be most useful for driver debugging.  Userspace may also ask that they
>>> be exported by writing to the sysfs control file, helping to cope with
>>> incomplete board support:
>>
>> Why can't all gpios appear read-only in sysfs by default?
>
> Typical SOC based systems have up to a few hundred pins that could
> be used as GPIOs.  The number actually used as GPIOs is rarely more
> than a dozen or two, with other pins generally muxed to a peripheral

So make them appear when something in the kernel requests them, explictly
exports them to user-space, or they are requested from user space.  The last
two can offer write access, the first only read.  I don't see why the explicit
request is necessary for something to show up in sysfs.  Nothing else in sysfs
seems to work this way.  At least, I see plenty of files in there that I
didn't have to manually make appear.

> There's no point in having a few hundred useless nodes in sysfs!

$ ls /sys/class/tty/ | wc
     579     579    4042

What's a few hundred more?

>>> This adds a device pointer to "struct gpio_chip".  When GPIO providers
>>> initialize that, sysfs gpio class devices become children of that device
>>> instead of being "virtual" devices.  The (few) gpio_chip providers which
>>> have such a device node have been updated.  (Some also needed to update
>>> their module "owner" field ... for which missing kerneldoc was added.)
>>
>> I don't see what's wrong with having devices add to gpiolib create a device
>
> It can't know where in the device tree to put such device nodes,
> or how to implement operations like suspend() and resume() for
> such nodes.  Creating such nodes, and their drivers, is NOT a role
> for generic code like gpiolib.

I didn't mean for gpiolib to create that device, that's obviously wrong.  What
I meant was the platform code, e.g. the code the calls gpiochip_add(), could
just call that one function and then it would have a device for the gpios to
appear under in sysfs.  You said that many systems "can't" have a device for
the gpios and I don't see how this is so.  Could you give me an example of
something that calls gpiochip_add() and can't provide a dev field in the
gpio_chip struct?

>> for the gpio's to be the children of.  You said that some devices can't do
>> this, but I don't see the difficulty.
>>
>> platform_device_register_simple("my-gpio", 0, NULL, 0);
>>
>> How hard is that?
>
> Most GPIOs come from platform code that doesn't create such a device
> today.  In cases like OMAP, GPIOs are usable even before memory
> allocations can work, so creating and using device nodes for GPIO
> controllers would involve updating code running VERY early in boot...

If memory allocations don't work, then gpiochip_add() can't possibly do
anything with sysfs, so having a device to parent the sysfs files from is a
moot point.

> You're free to write patches creating such device nodes, and work
> with the platform maintainers to convert their GPIO support to use
> standard driver model devices and drivers, then merge the results.

It's one line of code.

>>> Based on a patch from Trent Piepho <tpiepho@freescale.com>, and comments
>>> from various folk including Hartley Sweeten.
>>
>> I don't recall seeing those comments.  Where were they posted?
>
> Some were on-list, some were off-list.  The comments have been
> coming off and on for a few years now, so I'm certain you would
> not have seen all of them.  (I wouldn't have, either!)

I thought you meant comments to my patch.
