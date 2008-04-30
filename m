Return-Path: <linux-kernel-owner+w=401wt.eu-S1764442AbYD3X20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764442AbYD3X20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbYD3X2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:28:18 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:27121
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916AbYD3X2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:28:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEBACOdGEh8qMj2/2dsb2JhbAAIrV8
X-IronPort-AV: E=Sophos;i="4.25,730,1199631600"; 
   d="scan'208";a="214350333"
Subject: Re: [patch/rfc 2.6.25-git v2] gpio: sysfs interface
From: Ben Nizette <bn@niasdigital.com>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Trent Piepho <tpiepho@freescale.com>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
In-Reply-To: <200804301434.25211.david-b@pacbell.net>
References: <200804281239.51729.david-b@pacbell.net>
	 <1209521291.311.99.camel@moss.renham>
	 <200804301042.42513.david-b@pacbell.net>
	 <200804301434.25211.david-b@pacbell.net>
Content-Type: text/plain
Organization: Nias Digital
Date: Thu, 01 May 2008 09:28:13 +1000
Message-Id: <1209598093.3377.30.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-30 at 14:34 -0700, David Brownell wrote:
> Simple sysfs interface for GPIOs.
> 
>     /sys/class/gpio
>     	/control ... to request a GPIO be imported or returned
>         /gpioN ... for each exported GPIO #N
> 	    /value ... always readable, writes fail for input GPIOs
> 	    /direction ... r/w as: in, out (default low); write high, low
> 	/gpiochipN ... for each gpiochip; #N is its first GPIO
> 	    /base ... (r/o) same as N
> 	    /label ... (r/o) descriptive, not necessarily unique
> 	    /ngpio ... (r/o) number of GPIOs; numbered N .. N+(ngpio - 1)

You dropped the 'device' symlink?  Sure it won't always be available but
I did quite like the idea of being able to walk back through sysfs and
discover, for example, the SPI chip select to which it's attached.

> 
> GPIOs may be exported by kernel code using gpio_export(), which should
> be most useful for driver debugging.  Userspace may also ask that they
> be imported by writing to the sysfs control file, helping to cope with
> incomplete board support:
> 
>   echo "23" > /sys/class/gpio/control
> 	... will gpio_request(23, "sysfs") and gpio_export(23); use
> 	/sys/class/gpio/gpio-23/direction to configure it.
>   echo "-23" > /sys/class/gpio/control
> 	... will gpio_free(23)
> 
> The extra D-space footprint is a few hundred bytes, except for the sysfs
> resources associated with each exported GPIO.  The additional I-space
> footprint is about two thirds of the current size of gpiolib (!).  Since
> no /dev node creation is involved, no "udev" support is needed.
> 
> This adds a device pointer to "struct gpio_chip".  When GPIO providers
> initialize that, sysfs gpio class devices become children of that device
> instead of being "virtual" devices.  The (few) gpio_chip providers which
> have such a device node have been updated.  (Some also needed to update
> their module "owner" field ... for which missing kerneldoc was added.)
> 
> Based on a patch from Trent Piepho <tpiepho@freescale.com>, and comments
> from various folk including most recently Hartley Sweeten and Ben Nizette.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
> Notable updates from previous version:  doc update, mutex protection
> for sysfs access, export basic gpio_chip info ("what GPIOs exist"),
> depend on new sysfs_streq() call, simplified control file syntax.
> 
[...]
> +
> +/*
> + * /sys/class/gpio/control ... write-only
> + *	integer N:  non-negative == export; negative == unexport
> + */
> +static ssize_t control_store(struct class *class, const char *buf, size_t len)
> +{
> +	long	gpio;
> +	int	status;
> +
> +	status = strict_strtol(buf, 0, &gpio);
> +	if (status < 0)
> +		goto done;
> +
> +	/* No extra locking here; FLAG_SYSFS just signifies that the
> +	 * request and export were done by on behalf of userspace, so
> +	 * they may be undone on its behalf too.
> +	 */
> +
> +	if (gpio >= 0) {			/* export */
> +		status = gpio_request(gpio, "sysfs");
> +		if (status < 0)
> +			goto done;
> +
> +		status = gpio_export(gpio);
> +		if (status < 0)
> +			gpio_free(gpio);
> +		else
> +			set_bit(FLAG_SYSFS, &gpio_desc[gpio].flags);
> +
> +	} else {				/* unexport */

Unexport gpio 0?

> +		gpio = -gpio;
> +
> +		/* reject bogus commands (gpio_unexport ignores them) */
> +		if (!gpio_is_valid(gpio))
> +			goto fail;
> +		if (!test_and_clear_bit(FLAG_SYSFS, &gpio_desc[gpio].flags))
> +			goto fail;
> +		status = 0;
> +		gpio_free(gpio);
> +	}
> +done:
> +	if (status)
> +		pr_debug("%s: status %d\n", __func__, status);
> +	return status ? : len;
> +fail:
> +	pr_debug("%s: fail\n", __func__);
> +	return -EINVAL;
> +}
> +
