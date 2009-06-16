Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237AbZFPJDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbZFPJDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZFPJC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:02:59 -0400
Received: from trinity.fluff.org ([89.16.178.74]:33740 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbZFPJC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:02:59 -0400
Date: Tue, 16 Jun 2009 10:02:58 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Alek Du <alek.du@intel.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Florian Fainelli <florian@openwrt.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpiolib: Add gpio_detect, gpio_debounce and gpio_alt_func features to GPIOLIB
Message-ID: <20090616090258.GD14476@trinity.fluff.org>
References: <20090615171502.2a981bf5@dxy.sh.intel.com> <20090615125146.GC19873@fluff.org.uk> <200906151504.51934.florian@openwrt.org> <20090616092121.3ed42b63@dxy.sh.intel.com> <20090616084524.GC14476@trinity.fluff.org> <20090616165135.2ef993a4@dxy.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616165135.2ef993a4@dxy.sh.intel.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 04:51:35PM +0800, Alek Du wrote:
> On Tue, 16 Jun 2009 16:45:24 +0800
> Ben Dooks <ben-linux@fluff.org> wrote:
> 
> under set_type callback.
> > 
> > Somehow you are still missing my point, this is the way it can be done
> > at the moment, without any extension to the API!
> > 
> > int attach_my_gpio_irq(int gpio, void *irqpw)
> > {
> > 	int ret;
> > 	int irq;
> > 
> > 	irq = gpio_to_irq(gpio);
> > 	if (irq < 0) {
> > 		printk(KERN_ERR "%s: no gpio irq available\n", __func__);
> > 		return irq;
> > 	}
> > 
> > 	ret = request_irq(irq, my_irq_handler, IRQF_TRIGGER_FALLING,
> > 			  "mygpio", irqpw);
> > 	if (ret < 0) 
> > 		printk(KERN_ERR "%s: cannot request irq\n", __func__);
> > 
> > 	return ret;
> > }
> > 
> I mean, in the set_type of the irq_chip driver, you need to call something like rb532_gpio_set_ilevel.

The correct place is for the code to live in the set_type of the IRQ chip,
I see no reason for this extra complexity of adding stuff to the GPIOLIB
where there is already an interface for it.

You seem to be trying to export some internal to the driver function
implementing an extant interface for no gain to the system as a whole.

> The GPIO driver needs to export rb532_gpio_set_ilevel, and this is specific to each GPIO driver. Ideally,
> I should always call gpio_detect(gpio, ...) here.
> 
> static int rb532_set_type(unsigned int irq_nr, unsigned type)
> {
> 	int gpio = irq_nr - GPIO_MAPPED_IRQ_BASE;
> 	int group = irq_to_group(irq_nr);
> 
> 	if (group != GPIO_MAPPED_IRQ_GROUP || irq_nr > (GROUP4_IRQ_BASE + 13))
> 		return (type == IRQ_TYPE_LEVEL_HIGH) ? 0 : -EINVAL;
> 
> 	switch (type) {
> 	case IRQ_TYPE_LEVEL_HIGH:
> 		rb532_gpio_set_ilevel(1, gpio);
> 		break;
> 	case IRQ_TYPE_LEVEL_LOW:
> 		rb532_gpio_set_ilevel(0, gpio);
> 		break;
> 	default:
> 		return -EINVAL;
> 	}
> 	return 0;
> }

My point is that there is an already extant way of configuring
IRQ polarities and types. This interface is exported from something
you must already implement if you want IRQs from GPIOs.

so:

1) This interface exists in the irq_chip struct
2) The GPIO driver needs to implement irq_chip to provide interrupts
3) Therefore the functionality is already covered.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

