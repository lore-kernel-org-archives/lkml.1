Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbYGXMRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbYGXMRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbYGXMRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:17:13 -0400
Received: from aun.it.uu.se ([130.238.12.36]:57643 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbYGXMRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:17:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18568.29372.218800.510498@harpo.it.uu.se>
Date: Thu, 24 Jul 2008 14:17:00 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, david-b@pacbell.net
Subject: Re: GPIO: Add generic gpio_to_irq call.
In-Reply-To: <20080724114627.574586848@fluff.org.uk>
References: <20080724114627.574586848@fluff.org.uk>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Dooks writes:
 > Add gpio_to_irq() implementation allowing the
 > gpio_chip registration to also specify an function
 > to map GPIO offsets into IRQs.
 > 
 > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
 > 
 > Index: linux-2.6.26-quilt3/drivers/gpio/gpiolib.c
 > ===================================================================
 > --- linux-2.6.26-quilt3.orig/drivers/gpio/gpiolib.c	2008-07-18 13:50:32.000000000 +0100
 > +++ linux-2.6.26-quilt3/drivers/gpio/gpiolib.c	2008-07-22 15:20:26.000000000 +0100
 > @@ -339,6 +339,36 @@ const char *gpiochip_is_requested(struct
 >  }
 >  EXPORT_SYMBOL_GPL(gpiochip_is_requested);
 >  
 > +int __gpio_to_irq(unsigned gpio)
 > +{
 > +	struct gpio_chip	*chip;
 > +	struct gpio_desc	*desc = &gpio_desc[gpio];
 > +	unsigned long		flags;
 > +	int			status = -EINVAL;
 > +
 > +	spin_lock_irqsave(&gpio_lock, flags);
 > +
 > +	if (!gpio_is_valid(gpio))
 > +		goto fail;

Please move the &gpio_desc[gpio] expression after the gpio_is_valid(gpio)
test. Otherwise you risk violating C's pointer rules if the gpio is invalid.

 > +
 > +	chip = desc->chip;
 > +	if (!chip || !chip->to_irq)
 > +		goto fail;
 > +
 > +	gpio -= chip->base;
 > +	if (gpio >= chip->ngpio)
 > +		goto fail;
 > +
 > +	status = chip->to_irq(chip, gpio);
 > +
 > + fail:
 > +	spin_unlock_irqrestore(&gpio_lock, flags);
 > +	if (status)
 > +		pr_debug("%s: gpio-%d status %d\n",
 > +			__func__, gpio, status);
 > +	return status;
 > +}
