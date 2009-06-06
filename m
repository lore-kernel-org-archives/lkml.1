Return-Path: <linux-kernel-owner+w=401wt.eu-S1752229AbZFFFT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbZFFFT4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 01:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbZFFFTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 01:19:47 -0400
Received: from smtp110.sbc.mail.gq1.yahoo.com ([67.195.14.95]:42527 "HELO
	smtp110.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750898AbZFFFTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 01:19:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=pRkfNmTqXNe8pHKqBXHbZXpCRFwUPG4l1CSiZiJRYF7O+veOmIBMqgiWRgEda6TxWa3im1f3Tpr5J6hQp91u3Z0VqppkjUlXbJGtlJqyrHM2o7+q2yQjSJpLPV6dYzqq6AiitBtvjCHImcf7cPIEE0+ZrP7kilbTwdjSV2b9Ie4=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: N9MuM3MVM1kCM_uO5nI2PCpGidWMte_8dfB8sf1CSmzQ4LehIkCgxy.DFCM2slhU_obXi4KdCne14O_OyHL2ocTmCX96NZbUaC85NBLFQaxp_6E1phD8eSrHru9WbSzlGIXAXW28L38DKAZutkb9okudJSk6EWsMTYWSez9NhiZxqSeM6R2HCnfm9myWr4iF0QDvepPqCTD0o5QAK6Rpw2Xi8TYUlJPNEuB6r.gpiXYKOppfSUGRpISV4eNnEHqJB70O.Oy8mp2FDtSOjMcjf9X7DaywbNfYavCTob5MBHUUOpDwDfu6vUIt
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH] gpiolib: add gpio_request/free_irq
Date: Fri, 5 Jun 2009 22:19:47 -0700
User-Agent: KMail/1.9.10
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <200906051151.05779.hartleys@visionengravers.com>
In-Reply-To: <200906051151.05779.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906052219.47888.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 June 2009, H Hartley Sweeten wrote:
> Add support functions to gpiolib to request/free gpio irqs.

I'm not keen on this.

 - At best it's a convenience layer ... for something that's
   not the least bit awkward to do otherwise.

 - Coupling it to gpiolib sort of defeats the point of saying
   that gpiolib is just an *implementation* of the interface.
   Where's the code to run for non-gpiolib platforms?

 - Since it implicitly couples gpio_request() to a flavor of
   request_irq(), it precludes sharing those IRQs.

Basically, board setup can know that the GPIO is being used
as an IRQ, and do the request()/direction_input() before it
passes gpio_to_irq() to the driver. That's worked in every
case I've happened across so far...

- Dave



> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> 
> ---
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 51a8d41..5b4b864 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1103,6 +1103,52 @@ int __gpio_to_irq(unsigned gpio)
>  }
>  EXPORT_SYMBOL_GPL(__gpio_to_irq);
>  
> +/**
> + * gpio_request_irq() - allocate a gpio interrupt line
> + * @gpio: gpio whose IRQ will be allocated
> + * @handler: function to be called when the IRQ occurs
> + * @irqflags: interrupt type flags
> + * @label: an ascii name for the claiming device
> + * @data: a cookie passed back to the handling function
> + */
> +int gpio_request_irq(unsigned gpio, irq_handler_t handler,
> +			unsigned long irqflags, const char *label, void *data)
> +{
> +	int err;
> +
> +	err = gpio_request(gpio, label);
> +	if (err)
> +		goto fail;
> +
> +	err = gpio_direction_input(gpio);
> +	if (err)
> +		goto free;
> +
> +	err = request_irq(gpio_to_irq(gpio), handler, irqflags, label, data);
> +	if (err)
> +		goto free;
> +
> +	return 0;
> +
> +free:
> +	gpio_free(gpio);
> +fail:
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(gpio_request_irq);
> +
> +/**
> + * gpio_free_irq() - free an interrupt allocated with gpio_request_irq
> + * @irq: gpio interrupt line to free
> + * @data: device identity to free
> + */
> +void gpio_free_irq(unsigned int irq, void *data)
> +{
> +	free_irq(irq, data);
> +	gpio_free(irq_to_gpio(irq));
> +}
> +EXPORT_SYMBOL_GPL(gpio_free_irq);
> +
>  
>  
>  /* There's no value in making it easy to inline GPIO calls that may sleep.
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index d6c379d..c0ab7cf 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -3,6 +3,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/errno.h>
> +#include <linux/interrupt.h>
>  
>  #ifdef CONFIG_GPIOLIB
>  
> @@ -134,6 +135,11 @@ extern int __gpio_cansleep(unsigned gpio);
>  
>  extern int __gpio_to_irq(unsigned gpio);
>  
> +/* request/free gpio interrupt */
> +extern int gpio_request_irq(unsigned gpio, irq_handler_t handler,
> +			unsigned long irqflags, const char *label, void *data);
> +extern void gpio_free_irq(unsigned int irq, void *data);
> +
>  #ifdef CONFIG_GPIO_SYSFS
>  
>  /*
> diff --git a/include/linux/gpio.h b/include/linux/gpio.h
> index e10c49a..eaf7b27 100644
> --- a/include/linux/gpio.h
> +++ b/include/linux/gpio.h
> @@ -109,6 +109,18 @@ static inline int irq_to_gpio(unsigned irq)
>  	return -EINVAL;
>  }
>  
> +static inline int gpio_request_irq(unsigned gpio, irq_handler_t handler,
> +			unsigned long irqflags, const char *label, void *data)
> +{
> +	return -ENOSYS;
> +}
> +
> +static inline void gpio_free_irq(unsigned int irq, void *data)
> +{
> +	/* GPIO irq can never have been requested */
> +	WARN_ON(1);
> +}
> +
>  #endif
>  
>  #endif /* __LINUX_GPIO_H */
> 
> 


