Return-Path: <linux-kernel-owner+w=401wt.eu-S933906AbZHEA3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933906AbZHEA3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 20:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933873AbZHEA2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 20:28:53 -0400
Received: from n17.bullet.mail.mud.yahoo.com ([68.142.206.144]:20355 "HELO
	n17.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933845AbZHEA2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 20:28:32 -0400
X-Yahoo-Newman-Id: 316120.18854.bm@omp408.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LYJ0gSoZdF1KYlCf3V0x1qidNvz/bDlRAXmZkUqWef+f9ofW6etxnl9UGeW9QZXy1RAb121+T0F+Vh96L7jZaHixmE8DkIv0/O5DIBP8r+Qp4FBO8jSi5V+vchDYpvZq8KHrhwZJDb3a7xLukKFELu4RKN+3TmG3PHYCWdshvgc=  ;
X-YMail-OSG: vkpWouwVM1mr7Y7Jj65CM3Y1zNWvFpxFb9roVhlIqQKsfRcuiUgw3mhfRYboVlj3MAdI5DgMz61xdGVZpMn_co.4dOiy45MGawNg0Fb9f7NqURLam5tmB_NQIIgLBM6YyN.MPtZnsPUnDlOmGXWkyu7fC8VvS1hvbB0SSZqvgu4FLU.qwjSoImb9OjZ63swGIzNSSI63nGwIe1nI6ycJNkc6eoH2.854ed6n6uFmWmFB4eeEsfgl2CloYo29JwEOXEUCqYPdM6tnzmoAYDy5eFYWTTFgd4Xn1dnhs_rHhjy8wVpdIzYZQRfobV7TI7fdLFqNQE6Im7JnkH2kB4zadM9RspYIOFcxrQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH] gpiolib: introduce for_each_gpio_in_chip macro
Date: Tue, 4 Aug 2009 14:14:26 -0700
User-Agent: KMail/1.9.10
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <200907311027.06370.hartleys@visionengravers.com>
In-Reply-To: <200907311027.06370.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908041414.26112.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 July 2009, H Hartley Sweeten wrote:
> gpiolib: introduce for_each_gpio_in_chip macro
> 
> There are a number of places in gpiolib where all the gpio's handled by a
> chip are walked thru using a for() loop.  This introduces a for_each_*
> macro to clarify the code.

I'd rather not.  There are four such loops, and these are
really simple iterators.  Such a macro IMO just obfuscates,
when it's just hiding such trivial index ops.

NAK.

> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> 
> ---
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 51a8d41..b060f73 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -56,6 +56,11 @@ struct gpio_desc {
>  };
>  static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
>  
> +#define for_each_gpio_in_chip(__gpio, __chip)			\
> +	for ((__gpio) = (__chip)->base;				\
> +		(__gpio) < (__chip)->base + (__chip)->ngpio;	\
> +		(__gpio)++)
> +
>  static inline void desc_set_label(struct gpio_desc *d, const char *label)
>  {
>  #ifdef CONFIG_DEBUG_FS
> @@ -694,14 +699,14 @@ int gpiochip_add(struct gpio_chip *chip)
>  	}
>  
>  	/* these GPIO numbers must not be managed by another gpio_chip */
> -	for (id = base; id < base + chip->ngpio; id++) {
> +	for_each_gpio_in_chip(id, chip) {
>  		if (gpio_desc[id].chip != NULL) {
>  			status = -EBUSY;
>  			break;
>  		}
>  	}
>  	if (status == 0) {
> -		for (id = base; id < base + chip->ngpio; id++) {
> +		for_each_gpio_in_chip(id, chip) {
>  			gpio_desc[id].chip = chip;
>  
>  			/* REVISIT:  most hardware initializes GPIOs as
> @@ -744,14 +749,14 @@ int gpiochip_remove(struct gpio_chip *chip)
>  
>  	spin_lock_irqsave(&gpio_lock, flags);
>  
> -	for (id = chip->base; id < chip->base + chip->ngpio; id++) {
> +	for_each_gpio_in_chip(id, chip) {
>  		if (test_bit(FLAG_REQUESTED, &gpio_desc[id].flags)) {
>  			status = -EBUSY;
>  			break;
>  		}
>  	}
>  	if (status == 0) {
> -		for (id = chip->base; id < chip->base + chip->ngpio; id++)
> +		for_each_gpio_in_chip(id, chip)
>  			gpio_desc[id].chip = NULL;
>  	}
>  
> 
> 



