Return-Path: <linux-kernel-owner+w=401wt.eu-S1758152AbYCKVMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbYCKVMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbYCKVLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:11:44 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:34261 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753969AbYCKVLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:11:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QY9nBg3bQbZGGwFViWktj7JcJncL7PzPA1kynE/ZAFo4rBb04qdsE6feCfzyrgHocmSQ3bHgNehbGGY6tsZWPMA3QwdIFRQkeAuykdU7xrK5G/pn5dpvroOnD8N1tLElt70mfQ1Fky9+C9+fU8MDFVm9I5IQF/7Ph7Ft2aymWiQ=  ;
X-YMail-OSG: R5Bi7u4VM1nYUc2kmbqDV_fuK2L6MmAY301HLirEUQ9wOh53IJ3g4ix5QDV3r1suqaqJLv3a4Q--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH 2/3] gpiolib: implement gpiochip_reserve
Date: Tue, 11 Mar 2008 13:11:37 -0800
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20080311174118.GB12397@localhost.localdomain>
In-Reply-To: <20080311174118.GB12397@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803111411.38287.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008, Anton Vorontsov wrote:
> Function gpiochip_reserve() reserves range of gpios to use with
> platform code only, that is, this function used to mark specified
> range of gpios unavailable for the dynamic gpio base allocator.

Since this is for platform code only, it doesn't need to stick
around after initcalls have run.  So please mark it as __init so
that we minimize the footprint cost.

- Dave

> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
>  drivers/gpio/gpiolib.c     |   51 +++++++++++++++++++++++++++++++++++++++++--
>  include/asm-generic/gpio.h |    1 +
>  2 files changed, 49 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 81d81c9..2149e0c 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -43,6 +43,7 @@ struct gpio_desc {
>  /* flag symbols are bit numbers */
>  #define FLAG_REQUESTED	0
>  #define FLAG_IS_OUT	1
> +#define FLAG_RESERVED	2
>  
>  #ifdef CONFIG_DEBUG_FS
>  	const char		*label;
> @@ -80,6 +81,48 @@ static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
>  	return gpio_desc[gpio].chip;
>  }
>  
> +/**
> + * gpiochip_reserve() - reserve range of gpios to use with platform code only
> + * @start: starting gpio number
> + * @ngpio: number of gpios to reserve
> + * Context: potentially before irqs or kmalloc will work
> + *
> + * Returns a negative errno if any gpio within the range already reserved
> + * or registered. Otherwise it returns zero as a success code.
> + * Use this function to mark specified range of gpios unavailable for the
> + * dynamic gpio base allocator.
> + */
> +int __must_check gpiochip_reserve(int start, int ngpio)
> +{
> +	int ret = 0;
> +	unsigned long flags;
> +	int i;
> +
> +	if (!gpio_is_valid(start) || !gpio_is_valid(start + ngpio))
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(&gpio_lock, flags);
> +
> +	for (i = start; i < start + ngpio; i++) {
> +		struct gpio_desc *desc = &gpio_desc[i];
> +
> +		if (desc->chip || test_bit(FLAG_RESERVED, &desc->flags)) {
> +			ret = -EBUSY;
> +			goto err;
> +		}
> +
> +		set_bit(FLAG_RESERVED, &desc->flags);
> +	}
> +
> +	pr_debug("%s: reserved gpios from %d to %d\n",
> +		 __func__, start, start + ngpio - 1);
> +err:
> +	spin_unlock_irqrestore(&gpio_lock, flags);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(gpiochip_reserve);
> +
>  static int gpiochip_find_base(int ngpio)
>  {
>  	int i;
> @@ -87,9 +130,10 @@ static int gpiochip_find_base(int ngpio)
>  	int base = -ENOSPC;
>  
>  	for (i = ARCH_NR_GPIOS - 1; i >= 0 ; i--) {
> -		struct gpio_chip *chip = gpio_desc[i].chip;
> +		struct gpio_desc *desc = &gpio_desc[i];
> +		struct gpio_chip *chip = desc->chip;
>  
> -		if (!chip) {
> +		if (!chip && !test_bit(FLAG_RESERVED, &desc->flags)) {
>  			spare++;
>  			if (spare == ngpio) {
>  				base = i;
> @@ -97,7 +141,8 @@ static int gpiochip_find_base(int ngpio)
>  			}
>  		} else {
>  			spare = 0;
> -			i -= chip->ngpio - 1;
> +			if (chip)
> +				i -= chip->ngpio - 1;

Isn't this little optimization a bit error prone?  It
presumes the reserved bits and gpio chips are in fairly
close synch.  I'd just remove it ... it shouldn't be a
common path.

>  		}
>  	}
>  
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index 464c5b3..20f5d67 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -74,6 +74,7 @@ struct gpio_chip {
>  
>  extern const char *gpiochip_is_requested(struct gpio_chip *chip,
>  			unsigned offset);
> +extern int __must_check gpiochip_reserve(int start, int ngpio);
>  
>  /* add/remove chips */
>  extern int gpiochip_add(struct gpio_chip *chip);
> -- 
> 1.5.2.2
> 


