Return-Path: <linux-kernel-owner+w=401wt.eu-S1765446AbYD3Ww0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765446AbYD3Ww0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758963AbYD3WwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:52:14 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:38580 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761510AbYD3WwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:52:13 -0400
Date: Wed, 30 Apr 2008 15:47:50 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: David Brownell <david-b@pacbell.net>
cc: lkml <linux-kernel@vger.kernel.org>, Ben Nizette <bn@niasdigital.com>,
       Trent Piepho <tpiepho@freescale.com>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: Re: [patch/rfc 2.6.25-git v2] gpio: sysfs interface
In-Reply-To: <200804301434.25211.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.64.0804301511120.1537@t2.domain.actdsltmp>
References: <200804281239.51729.david-b@pacbell.net> <1209521291.311.99.camel@moss.renham>
 <200804301042.42513.david-b@pacbell.net> <200804301434.25211.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008, David Brownell wrote:
> Simple sysfs interface for GPIOs.
>
>    /sys/class/gpio
>    	/control ... to request a GPIO be imported or returned
>        /gpioN ... for each exported GPIO #N
> 	    /value ... always readable, writes fail for input GPIOs
> 	    /direction ... r/w as: in, out (default low); write high, low
> 	/gpiochipN ... for each gpiochip; #N is its first GPIO
> 	    /base ... (r/o) same as N
> 	    /label ... (r/o) descriptive, not necessarily unique
> 	    /ngpio ... (r/o) number of GPIOs; numbered N .. N+(ngpio - 1)

"simple"?  What I had was a lot simpler.

So, I want to set gpio 5 on a pcf9557 extender.

cat 1 > /sys/class/gpio/pcf9557-0:0

But now I can't do this anymore, it has to be harder.  So how do I do it?  It
doesn't seem very considerate to ignore the real use cases of the person who
wrote the code to begin with.

> GPIOs may be exported by kernel code using gpio_export(), which should
> be most useful for driver debugging.  Userspace may also ask that they

I have a JTAG interface implemented via GPIOs.  With my system, one can see
the gpios used in sysfs with the proper labels (TCK, TDO, TDI, etc.).  This is
very helpful for people connecting something to the interface to know they
have the write gpio lines connected.  What's the point of allowing
one to label gpio lines if it's not going to be easy to see?

It also means that if they have trouble getting what their connecting to work,
they can always control the line via sysfs and see with a probe that it
changes.  They can raise TRST (which they know is the right line from the
label) and see the system reset.

Adding gpio_export() calls to the kernel source and recompiling and
re-flashing just isn't going to happen for a large portion of users.

Why can't the gpio lines just show up when something requests them?

> be imported by writing to the sysfs control file, helping to cope with
> incomplete board support:
>
>  echo "23" > /sys/class/gpio/control
> 	... will gpio_request(23, "sysfs") and gpio_export(23); use

So if a driver is already using gpio 23, then there is no way to see it in
sysfs, since the gpio_request() will fail?

> 	/sys/class/gpio/gpio-23/direction to configure it.
>  echo "-23" > /sys/class/gpio/control
> 	... will gpio_free(23)

So if a driver was already using gpio 23 and you wanted to look at it from
userspace, you'll free it from both sysfs and the driver that was using it
when you're done?

> +When a kernel driver has requested a GPIO, it may only be made available
> +in the sysfs interface by gpio_export().  This prevents userspace code
> +from clobbering important state.

You could say the same about 90% of the writable files in sysfs.
