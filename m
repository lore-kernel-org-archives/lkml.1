Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbYGVLD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbYGVLD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 07:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbYGVLDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 07:03:21 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:29689 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751277AbYGVLDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 07:03:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LnaIlpcpBrVfmkpsJWgr/7Gderg3rc7n3+PIFsyalgeMOatw4qtXlteGpNL/mhPG2hp1y1NNPhTC73EtdcBnxcaAN5nhgILOK3/AVw1Ojl/nQAhjVKWTgakFOySiQOLkLXUGMs66BFq9V85ozrlDGCxjQsDr57Tez6zvBmd3QgY=  ;
X-YMail-OSG: KCYYBKEVM1keUjrY9JrE_i60JdFPVvYydiS0PSJ80VAkFzjrioMkdy8sICBUvl6aiyQP3IP__ISYXBsU3XG6TpIXA057OxUWZRHM9Q910w--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Ben Dooks" <ben-linux@fluff.org>
Subject: Re: Add to_irq fields to gpiolib (with sample implementation)
Date: Tue, 22 Jul 2008 04:03:18 -0700
User-Agent: KMail/1.9.9
Cc: linux-arm-kernel@lists.arm.linux.org.uk, "Ramax Lo" <ramaxlo@gmail.com>,
       linux-kernel@vger.kernel.org
References: <20080718130433.GA24568@fluff.org.uk> <901c91090807210343r3c483656p6c9b2ef77ffee2a0@mail.gmail.com>
In-Reply-To: <901c91090807210343r3c483656p6c9b2ef77ffee2a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807220403.18880.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 July 2008, Ramax Lo wrote:
> 2008/7/18 Ben Dooks <ben-linux@fluff.org>:
> > The two patches form a pair of patches to show
> > that we should consider adding an to_irq field
> > to the gpio_chip structure and gpiolib support.
> >
> 
> Indeed, it's necessary to add a new field to provide
> a general interface.
> 
> > The reason is that if we add support for devices
> > registering gpio to also register interrputs, then
> > a single arch-dependant interrupt mapping is not
> > going to be sufficient.

Fair enough, I guess ... although this does change
the cost of that mapping, and using this code also
presumes cooperation from that arch code.  (It must
at least avoid pre-allocating every IRQ number so
that new chips -- MFD or otherwise -- can't add more.)

What about irq_to_gpio() calls though?


> > Note, this set does not remove any clashing
> > definitions that may have of gpio_to_irq.

And it shouldn't even define that call.  It should
define an __gpio_to_irq() call so that arch code
can switch over incrementally (where it wants to).


> > ---
> > GPIO: Add generic gpio_to_irq call.
> >
> > Add gpio_to_irq() implementation allowing the
> > gpio_chip registration to also specify an function
> > to map GPIO offsets into IRQs.
> >
> > Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Diffstats please ... and relevant update to Documentation/gpio.txt,
minimally the stuff saying gpio_to_irq() costs on the order of an
addition or subtraction.

Right now drivers/input/keyboard/gpio_keys.c would be most
affected by increasing those costs; most other callers are
during setup code.  It might need updates.


> >
> > Index: linux-2.6.26-quilt3/drivers/gpio/gpiolib.c
> > ===================================================================
> > --- linux-2.6.26-quilt3.orig/drivers/gpio/gpiolib.c     2008-07-18 00:40:52.000000000 +0100
> > +++ linux-2.6.26-quilt3/drivers/gpio/gpiolib.c  2008-07-18 00:52:07.000000000 +0100
> > @@ -339,6 +339,36 @@ const char *gpiochip_is_requested(struct
> >  }
> >  EXPORT_SYMBOL_GPL(gpiochip_is_requested);
> >
> > +int gpio_to_irq(unsigned gpio)
> > +{
> > +       struct gpio_chip        *chip;
> > +       struct gpio_desc        *desc = &gpio_desc[gpio];
> > +       unsigned long           flags;
> > +       int                     status = -EINVAL;
> > +
> > +       spin_lock_irqsave(&gpio_lock, flags);
> > +
> > +       if (!gpio_is_valid(gpio))
> > +               goto fail;

Notice that since it's defined to be an error to use this call
on anything that's not had gpio_direction_input() called, and
thus anything that's not been requested... you could avoid grabbing
that spinlock, testing whether the GPIO is valid, and whether
the gpio_chip is null.


> > +
> > +       chip = desc->chip;
> > +       if (!chip || !chip->to_irq)
> > +               goto fail;
> > +
> > +       gpio -= chip->base;
> > +       if (gpio >= chip->ngpio)
> > +               goto fail;
> > +
> > +       status = chip->to_irq(chip, gpio);
> > +
> > + fail:
> > +       spin_unlock_irqrestore(&gpio_lock, flags);
> > +       if (status)
> > +               pr_debug("%s: gpio-%d status %d\n",
> > +                       __func__, gpio, status);
> > +       return status;
> > +}
> > +EXPORT_SYMBOL_GPL(gpio_to_irq);
> >
> 
> Is it possible to define it as __gpio_to_irq(), and let people
> define their macro or inline function, like the case of
> __gpio_get_value(), to maintain compatibility?

Yes, and IMO that should be done.  Along with kerneldoc
for this new __gpio_to_irq() call.



> > --- linux-2.6.26-quilt3.orig/include/asm-generic/gpio.h 2008-07-18 00:40:52.000000000 +0100
> > +++ linux-2.6.26-quilt3/include/asm-generic/gpio.h      2008-07-18 00:46:32.000000000 +0100
> > @@ -40,6 +40,7 @@ struct module;
> >  * @dbg_show: optional routine to show contents in debugfs; default code
> >  *     will be used when this is omitted, but custom code can show extra
> >  *     state (such as pullup/pulldown configuration).
> > + * @to_irq: convert gpio offset to IRQ number.
> >  * @base: identifies the first GPIO number handled by this chip; or, if
> >  *     negative during registration, requests dynamic ID allocation.
> >  * @ngpio: the number of GPIOs handled by this controller; the last GPIO
> > @@ -71,6 +72,9 @@ struct gpio_chip {
> >                                                unsigned offset, int value);
> >        void                    (*dbg_show)(struct seq_file *s,
> >                                                struct gpio_chip *chip);
> > +       int                     (*to_irq)(struct gpio_chip *chip,
> > +                                         unsigned offset);
> > +
> >        int                     base;
> >        u16                     ngpio;
> >        unsigned                can_sleep:1;
> > @@ -97,6 +101,7 @@ extern int gpio_direction_output(unsigne
> >  extern int gpio_get_value_cansleep(unsigned gpio);
> >  extern void gpio_set_value_cansleep(unsigned gpio, int value);
> >
> > +extern int gpio_to_irq(unsigned gpio);
> >
> >  /* A platform's <asm/gpio.h> code may want to inline the I/O calls when
> >  * the GPIO is constant and refers to some always-present controller,
> >
> >
