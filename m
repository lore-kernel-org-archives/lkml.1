Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbZAMVPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbZAMVPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 16:15:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbZAMVOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 16:14:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755118AbZAMVOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 16:14:52 -0500
Date: Tue, 13 Jan 2009 13:14:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: dsilvers@simtec.co.uk
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] GPIOLIB: Allow GPIOs to be named
Message-Id: <20090113131417.fe36d9bb.akpm@linux-foundation.org>
In-Reply-To: <1231504690.8511.8.camel@petitemort>
References: <1231504690.8511.8.camel@petitemort>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Jan 2009 12:38:10 +0000
Daniel Silverstone <dsilvers@simtec.co.uk> wrote:

> Hello,
> 
> During recent work for a customer, we needed to export named GPIOs to
> userland for them. I investigated various possible ways of doing so, and
> eventually reached the conclusion that there were two reasonable ways.
> The first required adding the ability to register symbolic links for
> classes in sysfs. So that I could have /sys/class/gpio/my-named-gpio be
> a symlink to /sys/class/gpio/gpio0 or similar.
> 
> However, I felt that would be a touch invasive and so I looked for a
> simpler way and decided that simply allowing the gpio_chip struct to
> carry an optional names array would be best (and much less invasive).
> 
> I was unable to find anything in MAINTAINERS or at the top of gpiolib.c
> to indicate who to CC, hence sending this only to the list. Below is a
> patch against 2150edc6c5cf00f7adb54538b9ea2a3e9cedca3f.

gpio core is developed/maintained by David Brownell.  Who owes us a
MAINTAINERS update ;)

> I'd appreciate comments and ideas for how to do this better, or if it is
> acceptable, I'd love to see it merged.
> 
> ...
>
> GPIOLIB: Allow GPIOs to be named
> 
> This patch allows GPIOs in GPIOLIB chips to be named. This name is
> then used when the GPIO is exported to sysfs, although it could be
> used elsewhere if deemed useful.
> 
> Signed-off-by: Daniel Silverstone <dsilvers@simtec.co.uk>
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 35e7aea..de2f114 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -438,6 +438,7 @@ int gpio_export(unsigned gpio, bool direction_may_change)
>  	unsigned long		flags;
>  	struct gpio_desc	*desc;
>  	int			status = -EINVAL;
> +	char			*ioname = NULL;
>  
>  	/* can't export until sysfs is available ... */
>  	if (!gpio_class.p) {
> @@ -461,11 +462,14 @@ int gpio_export(unsigned gpio, bool direction_may_change)
>  	}
>  	spin_unlock_irqrestore(&gpio_lock, flags);
>  
> +	if (desc->chip->names && desc->chip->names[gpio - desc->chip->base])
> +		ioname = desc->chip->names[gpio - desc->chip->base];
> +
>  	if (status == 0) {
>  		struct device	*dev;
>  
>  		dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
> -					desc, "gpio%d", gpio);
> +				    desc, ioname ? ioname : "gpio%d", gpio);
>  		if (dev) {
>  			if (direction_may_change)
>  				status = sysfs_create_group(&dev->kobj,
> @@ -513,6 +517,7 @@ void gpio_unexport(unsigned gpio)
>  	mutex_lock(&sysfs_lock);
>  
>  	desc = &gpio_desc[gpio];
> +
>  	if (test_bit(FLAG_EXPORT, &desc->flags)) {
>  		struct device	*dev = NULL;
>  
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index 81797ec..d6c379d 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -55,6 +55,10 @@ struct module;
>   *	handled is (base + ngpio - 1).
>   * @can_sleep: flag must be set iff get()/set() methods sleep, as they
>   *	must while accessing GPIO expander chips over I2C or SPI
> + * @names: if set, must be an array of strings to use as alternative
> + *      names for the GPIOs in this chip. Any entry in the array
> + *      may be NULL if there is no alias for the GPIO, however the
> + *      array must be @ngpio entries long.
>   *
>   * A gpio_chip can help platforms abstract various sources of GPIOs so
>   * they can all be accessed through a common programing interface.
> @@ -92,6 +96,7 @@ struct gpio_chip {
>  						struct gpio_chip *chip);
>  	int			base;
>  	u16			ngpio;
> +	char			**names;
>  	unsigned		can_sleep:1;
>  	unsigned		exported:1;
>  };
> 

Well it's nice and simple.
