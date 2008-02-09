Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbYBIApL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbYBIApL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 19:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768AbYBIAo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 19:44:58 -0500
Received: from mail.gmx.net ([213.165.64.20]:58677 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754305AbYBIAo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 19:44:57 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18Bi6AXUk4Bt8Q3bbVoQcHs6K2Eajry55aalrA0HL
	jXTyuVX0sM0EYw
Date: Sat, 9 Feb 2008 01:45:01 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
X-X-Sender: lyakh@axis700.grange
To: David Brownell <david-b@pacbell.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] prevent gpio chip drivers from unloading while used
In-Reply-To: <200802081601.10673.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.64.0802090132010.8364@axis700.grange>
References: <Pine.LNX.4.64.0802081159580.5301@axis700.grange>
 <200802081601.10673.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008, David Brownell wrote:

> On Friday 08 February 2008, Guennadi Liakhovetski wrote:
> > As long as one or more GPIOs on a gpio chip are used its driver should not 
> > be unloaded.
> 
> The mechanism currently in place is to have gpiochip_remove() fail
> if the platform's teardown() logic doesn't reject it.  (It may be
> practical to have the teardown code get rid of the users...)  That
> would be reflected as an "rmmod" failure.
> 
> Are you saying that doesn't work?

Yes, that's what I'm saying. I had a GPIO in use and rmmod-ed pca953x. It 
did produce an error message

pca953x 0-0041: gpiochip_remove() failed, -16

, but rmmod completed. AFAIU, the only 2 ways currently to prevent rmmod 
from completing, are: increment module use-count, then the respective 
module_exit() function is not called at all and rmmod fails with -EBUSY. 
Or block in rmmod until the resource becomes free. None of these has 
happened. BTW, I think, there's the same problem with i2c adapter drivers.

> I'm not a huge fan of explicit manipulation of module refcounts,

Neither am I.

> though there can be a place for such things.
> 
> Supporting removal of a gpio_chip is my least favorite feature of
> this framework.  Especially for controller drivers which could
> realistically manage per-GPIO IRQs ... since genirq doesn't seem to
> like the notion of irq_chip removal.  (The MCP23s08 and its I2C
> sibling the MCP23008 have real IRQ control logic, but the pca953x
> and pcf857x chips have a much less functional IRQ mechanism.)

Well, if all GPIOs of a gpio-chip are free, is there a reason why the 
module cannot be removed? That's what you have the request-free mechanism 
for, isn't it?

> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
> > 
> > ---
> > 
> > Note, that existing drivers do not have to be modified,
> 
> If they call gpiochip_remove(), they should be modified to ensure
> they initialize this new "owner" field.  That would be all of the
> drivers currently in drivers/gpio (not just pca953x).
> 
> 
> > for example those,  
> > that are always statically linked in the kernel, as long as the respective 
> > struct gpio_chip is nullified before calling gpiochip_add().
> 
> By "nullified", I presume you mean to suggest that the "owner" field
> be initialized to NULL ... which will normally be the case, when the
> gpio_chip is a static data structure or comes from kzalloc().

Exactly this is what I meant. And this is why most existing drivers will 
not be immediately broken if this patches are accepted. But we can and 
should update them too.

Thanks
Guennadi

> > diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> > index d8db2f8..dd535e1 100644
> > --- a/drivers/gpio/gpiolib.c
> > +++ b/drivers/gpio/gpiolib.c
> > @@ -177,6 +177,9 @@ int gpio_request(unsigned gpio, const char *label)
> >  	if (desc->chip == NULL)
> >  		goto done;
> >  
> > +	if (!try_module_get(desc->chip->owner))
> > +		goto done;
> > +
> >  	/* NOTE:  gpio_request() can be called in early boot,
> >  	 * before IRQs are enabled.
> >  	 */
> > @@ -184,8 +187,10 @@ int gpio_request(unsigned gpio, const char *label)
> >  	if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
> >  		desc_set_label(desc, label ? : "?");
> >  		status = 0;
> > -	} else
> > +	} else {
> >  		status = -EBUSY;
> > +		module_put(desc->chip->owner);
> > +	}
> >  
> >  done:
> >  	if (status)
> > @@ -209,9 +214,10 @@ void gpio_free(unsigned gpio)
> >  	spin_lock_irqsave(&gpio_lock, flags);
> >  
> >  	desc = &gpio_desc[gpio];
> > -	if (desc->chip && test_and_clear_bit(FLAG_REQUESTED, &desc->flags))
> > +	if (desc->chip && test_and_clear_bit(FLAG_REQUESTED, &desc->flags)) {
> >  		desc_set_label(desc, NULL);
> > -	else
> > +		module_put(desc->chip->owner);
> > +	} else
> >  		WARN_ON(extra_checks);
> >  
> >  	spin_unlock_irqrestore(&gpio_lock, flags);
> > diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> > index 806b86c..f6d389a 100644
> > --- a/include/asm-generic/gpio.h
> > +++ b/include/asm-generic/gpio.h
> > @@ -3,6 +3,8 @@
> >  
> >  #ifdef CONFIG_HAVE_GPIO_LIB
> >  
> > +#include <linux/module.h>
> > +
> >  /* Platforms may implement their GPIO interface with library code,
> >   * at a small performance cost for non-inlined operations and some
> >   * extra memory (for code and for per-GPIO table entries).
> > @@ -52,6 +54,7 @@ struct seq_file;
> >   */
> >  struct gpio_chip {
> >  	char			*label;
> > +	struct module		*owner;
> >  
> >  	int			(*direction_input)(struct gpio_chip *chip,
> >  						unsigned offset);
> > 
> 
> 

---
Guennadi Liakhovetski
