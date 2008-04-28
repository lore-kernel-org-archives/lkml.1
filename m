Return-Path: <linux-kernel-owner+w=401wt.eu-S968800AbYD1XOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968800AbYD1XOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967835AbYD1XLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 19:11:48 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:38887 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968509AbYD1XLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 19:11:47 -0400
Date: Mon, 28 Apr 2008 16:09:05 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: David Brownell <david-b@pacbell.net>
cc: lkml <linux-kernel@vger.kernel.org>,
       hartleys <hartleys@visionengravers.com>,
       Ben Nizette <bn@niasdigital.com>, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
In-Reply-To: <200804281239.51729.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.64.0804281507160.6832@t2.domain.actdsltmp>
References: <200804281239.51729.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008, David Brownell wrote:
> Simple sysfs interface for GPIOs.
>
>    /sys/class/gpio
>        /gpio-N ... for each exported GPIO #N

I liked it better they way I had it, "label:N".

When you have multiple GPIO sources, it's a lot easier to see where they are
comming from if they use the chip label.  Especially if support for dynamic
allocation of gpio numbers is written.


> 	    /value ... always readable, writes fail except for output GPIOs
> 	    /direction ... writable as: in, out (default low), high, low

You took away the code for the label field?  That was one of the features of
my code that Ben Nizette mentioned as an advantage over a char-device
interface.

>    	/control ... to request a GPIO be exported or unexported
>
> GPIOs may be exported by kernel code using gpio_export(), which should
> be most useful for driver debugging.  Userspace may also ask that they
> be exported by writing to the sysfs control file, helping to cope with
> incomplete board support:

Why can't all gpios appear read-only in sysfs by default?

> This adds a device pointer to "struct gpio_chip".  When GPIO providers
> initialize that, sysfs gpio class devices become children of that device
> instead of being "virtual" devices.  The (few) gpio_chip providers which
> have such a device node have been updated.  (Some also needed to update
> their module "owner" field ... for which missing kerneldoc was added.)

I don't see what's wrong with having devices add to gpiolib create a device
for the gpio's to be the children of.  You said that some devices can't do
this, but I don't see the difficulty.

platform_device_register_simple("my-gpio", 0, NULL, 0);

How hard is that?

> Based on a patch from Trent Piepho <tpiepho@freescale.com>, and comments
> from various folk including Hartley Sweeten.

I don't recall seeing those comments.  Where were they posted?

> +		status = gpio_export(gpio);
> +		if (status < 0)
> +			gpio_free(gpio);
> +		else
> +			set_bit(FLAG_SYSFS, &gpio_desc[gpio].flags);
> +
> +	} else if (strcmp(cmd, "unexport") == 0) {
> +		/* reject bogus commands (gpio_unexport ignores them) */
> +		if (!gpio_is_valid(gpio))
> +			goto fail;
> +		if (!test_and_clear_bit(FLAG_SYSFS, &gpio_desc[gpio].flags))
> +			goto fail;
> +
> +		gpio_free(gpio);

Maybe you could simplify the text parsing by having positive gpio numbers
export the gpio and negative numbers un-export the gpio?  Then there would not
be any need to parse a command with arguments.
