Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbYBIABx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbYBIABx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 19:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755751AbYBIAB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 19:01:27 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:32499 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759206AbYBIABZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 19:01:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=yAPqU8GNwGKg4P2n1i+xmLvkbJFrxgJKqJ8Ae0lzEMN99CBOZOWD8DeWVZts8M1CYNv59k8YMOkybuCnVRqDhSlfMc64aizNuqqP34+6fm5Qs60nxJrOkdO6S/y9rUpaU1Q4I9KNPBNHUY8X1erNB8Df4l9Wz3f0HbO067pafLA=  ;
X-YMail-OSG: DFfp.H0VM1ldAhIE2t9AK7ybY9tac6ctKAj_tHobEE7K7lC56qwieQuyiYUK6WTov4UtaeBbiw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Subject: Re: [PATCH 1/2] prevent gpio chip drivers from unloading while used
Date: Fri, 8 Feb 2008 16:01:10 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0802081159580.5301@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0802081159580.5301@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802081601.10673.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 February 2008, Guennadi Liakhovetski wrote:
> As long as one or more GPIOs on a gpio chip are used its driver should not 
> be unloaded.

The mechanism currently in place is to have gpiochip_remove() fail
if the platform's teardown() logic doesn't reject it.  (It may be
practical to have the teardown code get rid of the users...)  That
would be reflected as an "rmmod" failure.

Are you saying that doesn't work?


I'm not a huge fan of explicit manipulation of module refcounts,
though there can be a place for such things.

Supporting removal of a gpio_chip is my least favorite feature of
this framework.  Especially for controller drivers which could
realistically manage per-GPIO IRQs ... since genirq doesn't seem to
like the notion of irq_chip removal.  (The MCP23s08 and its I2C
sibling the MCP23008 have real IRQ control logic, but the pca953x
and pcf857x chips have a much less functional IRQ mechanism.)


> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
> 
> ---
> 
> Note, that existing drivers do not have to be modified,

If they call gpiochip_remove(), they should be modified to ensure
they initialize this new "owner" field.  That would be all of the
drivers currently in drivers/gpio (not just pca953x).


> for example those,  
> that are always statically linked in the kernel, as long as the respective 
> struct gpio_chip is nullified before calling gpiochip_add().

By "nullified", I presume you mean to suggest that the "owner" field
be initialized to NULL ... which will normally be the case, when the
gpio_chip is a static data structure or comes from kzalloc().

 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index d8db2f8..dd535e1 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -177,6 +177,9 @@ int gpio_request(unsigned gpio, const char *label)
>  	if (desc->chip == NULL)
>  		goto done;
>  
> +	if (!try_module_get(desc->chip->owner))
> +		goto done;
> +
>  	/* NOTE:  gpio_request() can be called in early boot,
>  	 * before IRQs are enabled.
>  	 */
> @@ -184,8 +187,10 @@ int gpio_request(unsigned gpio, const char *label)
>  	if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
>  		desc_set_label(desc, label ? : "?");
>  		status = 0;
> -	} else
> +	} else {
>  		status = -EBUSY;
> +		module_put(desc->chip->owner);
> +	}
>  
>  done:
>  	if (status)
> @@ -209,9 +214,10 @@ void gpio_free(unsigned gpio)
>  	spin_lock_irqsave(&gpio_lock, flags);
>  
>  	desc = &gpio_desc[gpio];
> -	if (desc->chip && test_and_clear_bit(FLAG_REQUESTED, &desc->flags))
> +	if (desc->chip && test_and_clear_bit(FLAG_REQUESTED, &desc->flags)) {
>  		desc_set_label(desc, NULL);
> -	else
> +		module_put(desc->chip->owner);
> +	} else
>  		WARN_ON(extra_checks);
>  
>  	spin_unlock_irqrestore(&gpio_lock, flags);
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index 806b86c..f6d389a 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -3,6 +3,8 @@
>  
>  #ifdef CONFIG_HAVE_GPIO_LIB
>  
> +#include <linux/module.h>
> +
>  /* Platforms may implement their GPIO interface with library code,
>   * at a small performance cost for non-inlined operations and some
>   * extra memory (for code and for per-GPIO table entries).
> @@ -52,6 +54,7 @@ struct seq_file;
>   */
>  struct gpio_chip {
>  	char			*label;
> +	struct module		*owner;
>  
>  	int			(*direction_input)(struct gpio_chip *chip,
>  						unsigned offset);
> 


