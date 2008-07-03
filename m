Return-Path: <linux-kernel-owner+w=401wt.eu-S1760048AbYGCMmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048AbYGCMmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbYGCMmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:42:19 -0400
Received: from bu3sch.de ([62.75.166.246]:37309 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885AbYGCMmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:42:17 -0400
From: Michael Buesch <mb@bu3sch.de>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] gpiolib: Allow user-selection
Date: Thu, 3 Jul 2008 10:42:16 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org
References: <200807022346.53222.mb@bu3sch.de> <20080702170431.56d4c929.akpm@linux-foundation.org> <200807030125.08247.david-b@pacbell.net>
In-Reply-To: <200807030125.08247.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807031042.16296.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 July 2008 10:25:08 David Brownell wrote:
> On Wednesday 02 July 2008, Andrew Morton wrote:
> > drivers/gpio/gpiolib.c: In function 'gpio_export':
> > drivers/gpio/gpiolib.c:432: error: 'struct class' has no member named 'devices'
> > drivers/gpio/gpiolib.c:456: error: implicit declaration of function 'device_create'
> > drivers/gpio/gpiolib.c:457: warning: assignment makes pointer from integer without a cast
> > drivers/gpio/gpiolib.c: In function 'gpio_unexport':
> > drivers/gpio/gpiolib.c:509: warning: passing argument 2 of 'class_find_device' from incompatible pointer type
> > drivers/gpio/gpiolib.c:509: error: too few arguments to function 'class_find_device'
> > drivers/gpio/gpiolib.c: In function 'gpiochip_export':
> > drivers/gpio/gpiolib.c:536: error: 'struct class' has no member named 'devices'
> > drivers/gpio/gpiolib.c:542: warning: assignment makes pointer from integer without a cast
> > drivers/gpio/gpiolib.c: In function 'gpiochip_unexport':
> > drivers/gpio/gpiolib.c:575: warning: passing argument 2 of 'class_find_device' from incompatible pointer type
> > drivers/gpio/gpiolib.c:575: error: too few arguments to function 'class_find_device'
> 
> Should be addressed by the following, at least in
> terms of build problems aginst linux-next.
> 
> The resulting kernel doesn't seem bootable on any
> board I currently have set up for testing gpio calls.
> The build dies in the TTY stack.


Thanks a lot Dave.
I'm going to try this with my bt878 card, once I got linux-next pulled and built.

> - Dave
> 
> 
> =============	CUT HERE
> Cope with some backwards-incompatible driver model API changes
> now in the linux-next tree:
> 
>  - device_create() is going away, even for drivers using it safely,
>    in favor of device_create_drvdata().
>  - class->devices is gone, but testing class->p serves the same
>    purpose (non-null when class is usable with driver model calls).
>  - class_find_device() needs a new argument #2 (NULL)
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  drivers/gpio/gpiolib.c |   16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> --- a/drivers/gpio/gpiolib.c	2008-07-02 23:29:58.000000000 -0700
> +++ b/drivers/gpio/gpiolib.c	2008-07-03 00:04:57.000000000 -0700
> @@ -429,7 +429,7 @@ int gpio_export(unsigned gpio, bool dire
>  	int			status = -EINVAL;
>  
>  	/* can't export until sysfs is available ... */
> -	if (!gpio_class.devices.next) {
> +	if (!gpio_class.p) {
>  		pr_debug("%s: called too early!\n", __func__);
>  		return -ENOENT;
>  	}
> @@ -453,10 +453,9 @@ int gpio_export(unsigned gpio, bool dire
>  	if (status == 0) {
>  		struct device	*dev;
>  
> -		dev = device_create(&gpio_class, desc->chip->dev, 0,
> -				"gpio%d", gpio);
> +		dev = device_create_drvdata(&gpio_class, desc->chip->dev, 0,
> +				desc, "gpio%d", gpio);
>  		if (dev) {
> -			dev_set_drvdata(dev, desc);
>  			if (direction_may_change)
>  				status = sysfs_create_group(&dev->kobj,
>  						&gpio_attr_group);
> @@ -506,7 +505,7 @@ void gpio_unexport(unsigned gpio)
>  	if (test_bit(FLAG_EXPORT, &desc->flags)) {
>  		struct device	*dev = NULL;
>  
> -		dev = class_find_device(&gpio_class, desc, match_export);
> +		dev = class_find_device(&gpio_class, NULL, desc, match_export);
>  		if (dev) {
>  			clear_bit(FLAG_EXPORT, &desc->flags);
>  			put_device(dev);
> @@ -533,15 +532,14 @@ static int gpiochip_export(struct gpio_c
>  	 * export this later, in gpiolib_sysfs_init() ... here we just
>  	 * verify that _some_ field of gpio_class got initialized.
>  	 */
> -	if (!gpio_class.devices.next)
> +	if (!gpio_class.p)
>  		return 0;
>  
>  	/* use chip->base for the ID; it's already known to be unique */
>  	mutex_lock(&sysfs_lock);
> -	dev = device_create(&gpio_class, chip->dev, 0,
> +	dev = device_create_drvdata(&gpio_class, chip->dev, 0, chip,
>  			"gpiochip%d", chip->base);
>  	if (dev) {
> -		dev_set_drvdata(dev, chip);
>  		status = sysfs_create_group(&dev->kobj,
>  				&gpiochip_attr_group);
>  	} else
> @@ -572,7 +570,7 @@ static void gpiochip_unexport(struct gpi
>  	struct device		*dev;
>  
>  	mutex_lock(&sysfs_lock);
> -	dev = class_find_device(&gpio_class, chip, match_export);
> +	dev = class_find_device(&gpio_class, NULL, chip, match_export);
>  	if (dev) {
>  		put_device(dev);
>  		device_unregister(dev);
> 
> 
> 



-- 
Greetings Michael.
