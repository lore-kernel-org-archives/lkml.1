Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbZGCQx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbZGCQx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 12:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbZGCQxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 12:53:52 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:36030 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755281AbZGCQxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 12:53:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ds6vR/Z3Pk4ADE3d21IRn86ZPm1MDThyj+mKoYPDiYsqyjs54pzLlmGjfzzVllLMJw4BCLt4dOQyVqSRlAI8/qZ/hqpKqz4UCI6OVOd5ZLfCQrQBQp1r+ZXvycmsZMg6P1otpAnu7dKbuj+iPxGlamkirg6Rykch0f3g7A0qpms=  ;
X-YMail-OSG: I7n_EQEVM1kH.G.8PWCTW7a6QbDKJ5lY8rTFbeAkAPevzn1WBpSbyM6.8pscPB7WFM.xp_E1hmBZCZpAeSwUZe.2_nQgQqqc._Ps76YphK0frqty2tuzjj5Z58svie9FOmFXvQIakYNFiH513nSVAGgo.0ARrOhPQMnM7fWruUf_7MUXJX0jVoEMP8hVRMmQ0RImpgtPyhkumK3DIeEP3tILusB4L9Ku1DEg6y0uoPUv9Wl5V6PuB8pZ_s7uqNY704CLiaKuKGjQ9lY8HoiyxwtkPmsq4CLFNseOMdpJ3seC1K87yg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alek Du <alek.du@intel.com>, peterz@infradead.org
Subject: Re: [PATCH] gpio: pca953x: add irq_chip for irq demuxing
Date: Fri, 3 Jul 2009 09:53:53 -0700
User-Agent: KMail/1.9.10
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20090703211034.47fc0880@dxy.sh.intel.com>
In-Reply-To: <20090703211034.47fc0880@dxy.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907030953.54006.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 July 2009, Alek Du wrote:
> From 02227060687d8ce8254714d9812e19b815463dd4 Mon Sep 17 00:00:00 2001
> From: Alek Du <alek.du@intel.com>
> Date: Wed, 1 Jul 2009 17:07:00 +0800
> Subject: [PATCH] gpio: pca953x: add irq_chip for irq demuxing
> 
> This patch is required when using this gpio driver with gpio_keys driver

Two fundamental comments:

 - I don't think these chips (or pcf857x chips) present the
   model that irq_chip support implies ... what they expose
   is more like a "poll now" hint than what a SoC-integrated
   GPIO does. 

   More complex external chips (like mcp23s08 gpio expanders,
   or some MFDs) can implement what an irq_chip impies ...
   they latch status, provide pin-level control for IRQ masking,
   acking, and trigger modes, etc.

 - You're using a model -- need to use it! -- which has gotten
   zero support or cooperation from the folk who currently
   claim ownership of genirq.

   Specifically:  IRQ chaining through an irq_chip whose
   operation requires methods that sleep.

In short, I wouldn't try to use irq_chip in these cases ...
but if you strongly believe that's the answer, doing it
"right" is going require (overdue) genirq updates.

Plus ... last time I looked, some of the procedures you
call were not available to modular drivers.  Raising
two technical issues (in addition to the ones below):

 - There is no code handling the case where this I2c driver
   gets unbound.  The relevant genirq state would need to
   be cleaned up.

 - This code is still kicking in for non-modular builds.
   (Which could be OK if those procedures are now available
   to modules.)



> Signed-off-by: Alek Du <alek.du@intel.com>
> CC: David Brownell <david-b@pacbell.net>
> ---
>  drivers/gpio/pca953x.c      |   54 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/i2c/pca953x.h |    3 ++
>  2 files changed, 57 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
> index 8ab1308..47c1d99 100644
> --- a/drivers/gpio/pca953x.c
> +++ b/drivers/gpio/pca953x.c
> @@ -13,6 +13,7 @@
>  
>  #include <linux/module.h>
>  #include <linux/init.h>
> +#include <linux/interrupt.h>
>  #include <linux/i2c.h>
>  #include <linux/i2c/pca953x.h>
>  #ifdef CONFIG_OF_GPIO
> @@ -51,6 +52,7 @@ MODULE_DEVICE_TABLE(i2c, pca953x_id);
>  
>  struct pca953x_chip {
>  	unsigned gpio_start;
> +	unsigned irq_base;
>  	uint16_t reg_output;
>  	uint16_t reg_direction;
>  
> @@ -183,6 +185,13 @@ static void pca953x_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
>  	chip->reg_output = reg_val;
>  }
>  
> +static int pca953x_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
> +{
> +	struct pca953x_chip *chip = container_of(gc, struct pca953x_chip,
> +								gpio_chip);
> +	return chip->irq_base + offset;
> +}
> +
>  static void pca953x_setup_gpio(struct pca953x_chip *chip, int gpios)
>  {
>  	struct gpio_chip *gc;
> @@ -193,6 +202,7 @@ static void pca953x_setup_gpio(struct pca953x_chip *chip, int gpios)
>  	gc->direction_output = pca953x_gpio_direction_output;
>  	gc->get = pca953x_gpio_get_value;
>  	gc->set = pca953x_gpio_set_value;
> +	gc->to_irq = pca953x_gpio_to_irq;
>  	gc->can_sleep = 1;
>  
>  	gc->base = chip->gpio_start;
> @@ -251,6 +261,34 @@ pca953x_get_alt_pdata(struct i2c_client *client)
>  }
>  #endif
>  
> +/* the irq_chip at least needs one handler */
> +static void pca953x_irq_unmask(unsigned irq)
> +{
> +}
> +
> +static struct irq_chip pca953x_irqchip = {
> +	.name		= "pca953x_irqchip",

Just "pca953x" would suffice.  And it wouldn't cause
misdisplaying of /proc/interrupts output.  :)


> +	.unmask		= pca953x_irq_unmask,
> +};
> +
> +static void pca953x_irq_handler(unsigned irq, struct irq_desc *desc)
> +{
> +	struct pca953x_chip *chip = (struct pca953x_chip *)get_irq_data(irq);
> +	int i;
> +
> +	if (desc->chip->ack)
> +		desc->chip->ack(irq);

This top-level IRQ chaining handler is clelarly incorrect.
Reading from a pca9539 spec I have handy:

	Resetting the interrupt circuit is achieved when
	data on the port is changed to the original setting,
	data is read from the port that generated the
	interrupt, or in a Stop event.

You're not guaranteeing *any* of those happens.  Since
the chip's nINT output is level-active, it's possible
that the hardware is still raising this interrupt when
this hander returns ...

The *best* you could do here would be to ensure this
chaining handler runs in thread context, then have it
read the GPIO input port register(s) to ensure nINT
is cleared.



> +	/* we must call all sub-irqs, since there is no way to read
> +	 * I2C gpio expander's status in irq context. The driver itself
> +	 * would be reponsible to check if the irq is for him.
> +	 */
> +	for (i = 0; i < chip->gpio_chip.ngpio; i++)
> +		generic_handle_irq(chip->irq_base + i);

You should only do that for pins configured as inputs.
The nIRQ signal is not triggered for changes on output pins.

Also, see the second point above.  So far as I know, the
dragons guarding the genirq den are still intent on not
providing any support for chained handlers in cases like
this one...


> +
> +	if (desc->chip->unmask)
> +		desc->chip->unmask(irq);
> +}
> +
>  static int __devinit pca953x_probe(struct i2c_client *client,
>  				   const struct i2c_device_id *id)
>  {
> @@ -284,6 +322,8 @@ static int __devinit pca953x_probe(struct i2c_client *client,
>  
>  	chip->names = pdata->names;
>  
> +	chip->irq_base = pdata->irq_base;
> +
>  	/* initialize cached registers from their original values.
>  	 * we can't share this chip with another i2c master.
>  	 */
> @@ -315,6 +355,20 @@ static int __devinit pca953x_probe(struct i2c_client *client,
>  	}
>  
>  	i2c_set_clientdata(client, chip);
> +
> +	if (chip->irq_base) {
> +		int i;
> +
> +		set_irq_type(client->irq,
> +				IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING);

Won't work on all hardware.  And surely you'd want just
EDGE_FALLING, so you get only half as many IRQs, if you
happen to be hooking this up to an interrupt line which
supports edge-sensitive IRQ triggers (and not through
some kind of signal inverter)?


> +		set_irq_chained_handler(client->irq, pca953x_irq_handler);

I'd set the handler *last* in case one of the pins
changes between here and the time you've finished
setting up the chained-to IRQs ...


> +		set_irq_data(client->irq, chip);
> +		for (i = 0; i < chip->gpio_chip.ngpio; i++) {
> +			set_irq_chip_and_handler_name(i + chip->irq_base,
> +				&pca953x_irqchip, handle_simple_irq, "demux");
> +			set_irq_chip_data(i + chip->irq_base, chip);

This is insufficient.  IRQF_VALID isn't necessarily
going to be set.  And ... I suppose you haven't
actually run this with LOCKDEP?  If you do, you
will likely notice you need to set the lock class
for those chained-to interrupts so it's something
different from the class of the chained-from IRQ.

> +		}
> +	}
>  	return 0;
>  
>  out_failed:
> diff --git a/include/linux/i2c/pca953x.h b/include/linux/i2c/pca953x.h
> index 81736d6..bf7c0a3 100644
> --- a/include/linux/i2c/pca953x.h
> +++ b/include/linux/i2c/pca953x.h
> @@ -4,6 +4,9 @@ struct pca953x_platform_data {
>  	/* number of the first GPIO */
>  	unsigned	gpio_base;
>  
> +	/* number of the first IRQ */
> +	unsigned	irq_base;
> +
>  	/* initial polarity inversion setting */
>  	uint16_t	invert;
>  
> -- 
> 1.6.0.4
> 
> 


