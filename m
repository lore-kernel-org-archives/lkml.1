Return-Path: <linux-kernel-owner+w=401wt.eu-S1764839AbXJSMCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764839AbXJSMCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 08:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755599AbXJSMCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 08:02:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:4391 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227AbXJSMCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 08:02:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GURxvaU5cwkyQM0dVrf638hj9QcvpOEL3ZQ4aXD3gRtXmE0vykYJhYUbBccid6vPCk+VF3sQJLqp/l/dIGkWfPZZD7jFe4ZkHV2gbnpNKTm85sgFQvPlIOl6vPqu9Ng/OxsHQXE5s7CGWc48T0+l+Q9Ie/sGCV2mzRdPxhZPCo8=
Message-ID: <74d0deb30710190502o746e8c5mdaa3930f0a99e81d@mail.gmail.com>
Date: Fri, 19 Oct 2007 14:02:00 +0200
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: "Samuel Ortiz" <sameo@openedhand.com>
Subject: Re: [RFC] [PATCH -mm] ASIC3 driver
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Paul Sokolovsky" <pmiscml@gmail.com>,
       "Ben Dooks" <ben@trinity.fluff.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "David Brownell" <david-b@pacbell.net>
In-Reply-To: <20071019105258.GA15170@caravaggio>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071018091239.GA11360@caravaggio>
	 <20071018150544.6852d5c9.akpm@linux-foundation.org>
	 <20071019105258.GA15170@caravaggio>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/07, Samuel Ortiz <sameo@openedhand.com> wrote:
> On Thu, Oct 18, 2007 at 03:05:44PM -0700, Andrew Morton wrote:
> > On Thu, 18 Oct 2007 11:12:41 +0200
> > Samuel Ortiz <sameo@openedhand.com> wrote:
> > You're not a big fan of checkpatch, I see.
> Well, now I am :-)
> I fixed all the errors, there are only a couple lines being more than 80
> characters left.
>
> > > +#include <linux/module.h>
> > > +#include <linux/version.h>
> > > +#include <linux/irq.h>
> >
> > Please see the large comment at the top of linux/irq.h.  I believe this
> > driver will fial to compile on at least arm.
> It doesn't build as a module, since we need the irq.h symbols.
> I changed MFD_ASIC3 to bool. I somehow feel that this is not the cleanest
> solution, but OTOH I think that dynamically adding IRQs and GPIOs to an
> embedded board doesn't make much sense.
>
> > We really should fix this.
> As I explained to Thomas, asic3 defines an additional range of IRQs for the
> board, so we really need to access the irq API.
> There may be another way, but I'm not aware of it.
>
> > > +static inline void asic3_write_register(struct asic3 *asic,
> > > +                            unsigned int reg, u32 value)
> > > +{
> > > +   iowrite16(value, (unsigned long)asic->mapping +
> > > +             (reg >> (2 - asic->bus_shift)));
> > > +}
> > > +
> > > +static inline u32 asic3_read_register(struct asic3 *asic,
> > > +                          unsigned int reg)
> > > +{
> > > +   return ioread16((unsigned long)asic->mapping +
> > > +                   (reg >> (2 - asic->bus_shift)));
> > > +}
> >
> > You'd get faster code if that "2 - asic->bus_shift" was cached in struct
> > asic3 rather than recalculated each time.
> Done.
>
> > > +static void asic3_irq_demux(unsigned int irq, struct irq_desc *desc)
> > > +{
> > > +   int iter, i;
> > > +   struct asic3 *asic;
> > > +
> > > +   desc->chip->ack(irq);
> >
> > hm, so this delves into the innards of the IRQ management.  Does it work OK
> > with and without CONFIG_GENERIC_HARDIRQS?  If not, some Kconfig work will
> > be needed.
> It needs CONFIG_GENERIC_HARDIRQS, I fixed Kconfig.
>
>
> > > +                           for (i = 0; i < ASIC3_GPIOS_PER_BANK; i++) {
> > > +                                   int bit = (1 << i);
> > > +                                   unsigned int irqnr;
> > > +                                   if (!(istat & bit))
> > > +                                           continue;
> >
> > Most people prefer a blank line between end-of-definitions and start-of-code.
> Done.
>
> > > +static void asic3_unmask_gpio_irq(unsigned int irq)
> > > +{
> > > +   struct asic3 *asic = get_irq_chip_data(irq);
> > > +   u32 val, bank, index;
> > > +
> > > +   bank = asic3_irq_to_bank(asic, irq);
> > > +   index = asic3_irq_to_index(asic, irq);
> > > +
> > > +   spin_lock(&asic->lock);
> > > +   val = asic3_read_register(asic, bank + ASIC3_GPIO_Mask);
> > > +   val &= ~(1 << index);
> > > +   asic3_write_register(asic, bank + ASIC3_GPIO_Mask, val);
> > > +   spin_unlock(&asic->lock);
> > > +}
> >
> > Am wondering about the handling of asic->lock.  As it is taken from hard
> > interrupts, it is a bug to take it with local interrupts enabled.  afacit
> > that is what this code is doing and is hence deadlockable.  But I didn't
> > look very hard.
> No, I think you're right, the lock should be taken with local interrupts
> disabled. I fixed that too.
>
> > Has this code been exercised with lockdep enabled?
> Yes, I'm running it with lockdep enabled.
>
>
> > > +int asic3_gpio_get_value(struct asic3 *asic, unsigned gpio)
> > > +{
> > > +   u32 mask = ASIC3_GPIO_bit(gpio);
> > > +
> > > +   switch (gpio >> 4) {
> > > +   case ASIC3_GPIO_BANK_A:
> > > +           return asic3_get_gpio_a(asic, Status) & mask;
> > > +   case ASIC3_GPIO_BANK_B:
> > > +           return asic3_get_gpio_b(asic, Status) & mask;
> > > +   case ASIC3_GPIO_BANK_C:
> > > +           return asic3_get_gpio_c(asic, Status) & mask;
> > > +   case ASIC3_GPIO_BANK_D:
> > > +           return asic3_get_gpio_d(asic, Status) & mask;
> > > +   default:
> > > +           printk(KERN_ERR "%s: invalid GPIO value 0x%x",
> > > +                  __FUNCTION__, gpio);
> > > +           return -EINVAL;
> > > +   }
> > > +}
> > > +EXPORT_SYMBOL(asic3_gpio_get_value);
> > > ...
> > > +EXPORT_SYMBOL(asic3_gpio_set_value);
> >
> > To what are these exported?
> Currently nothing, but the plan is to push several drivers (leds, MMC,
> buttons...) based on the ASIC3, and they need to access the ASIC3 GPIOs.
> Do you want me to remove the EXPORT_SYMBOL until we actually add those
> drivers ?

I'd love to see this converted to use the GPIO API before all the
drivers are going in.
Any chance we can use this as an opportunity to look at David
Brownell's gpiolib again? (http://lkml.org/lkml/2007/4/15/127).
I want to do the same for a similar chip (a GPIO/IRQ extender
implemented in a Xilinx CPLD used on several HTC phones), but I
couldn't figure out how to do GPIO<->IRQ conversion properly with
gpiolib and how to handle the CPU's internal GPIOs, which are more
than ARCH_GPIOS_PER_CHIP in gpiolib.

regards
Philipp
