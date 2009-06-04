Return-Path: <linux-kernel-owner+w=401wt.eu-S1756979AbZFDQAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbZFDQAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbZFDP7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:59:55 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:55148 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904AbZFDP7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:59:54 -0400
Date: Thu, 4 Jun 2009 18:58:39 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH v3] gpio: driver for PrimeCell PL061 GPIO controller
Message-ID: <20090604155824.GA25782@tarshish>
References: <1243975690-12073-1-git-send-email-baruch@tkos.co.il> <20090604092835.GJ29926@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604092835.GJ29926@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Thank you very much for your review. See my comments below.

On Thu, Jun 04, 2009 at 10:28:35AM +0100, Russell King - ARM Linux wrote:
> On Tue, Jun 02, 2009 at 11:48:10PM +0300, Baruch Siach wrote:
> > +static u32 (*pl061_pending_irq)(int irq);
> 
> Hmm, not sure this is entirely a good idea, especially when some
> platforms may have more than one of these.  It'll work provided they
> all point at the same function, but if they don't, it's bad news.
> 
> IRQs do have the ability to have chip specific data attached to them.
> See set_irq_chip_data() and get_irq_chip_data().

The trouble is that my chip has two PL061 blocks that are both connected to 
the same IRQ on the VIC. The driver, then, has no way to know which PL061 has 
triggered the interrupt. That's why I moved this responsibility to the 
platform code.

A different approach would be to use a per-IRQ linked list containing all 
PL061s connected to this IRQ.  Is this a reasonable solution?

> 
> > +static unsigned int pl061_irq_startup(unsigned irq)
> > +{
> > +	int ret;
> > +
> > +	ret = gpio_request(irq_to_gpio(irq), "IRQ");
> > +	if (ret < 0) {
> > +		pr_warning("%s: warning: gpio_request(%d) returned %d\n",
> > +				__func__, irq_to_gpio(irq), ret);
> > +		return 0;
> > +	}
> > +
> > +	gpio_direction_input(irq_to_gpio(irq));
> 
> I thought that it was not expected that claiming an interrupt would claim
> a GPIO automatically - in other words, it's the responsibility of the
> driver or platform itself to claim GPIOs for interrupts and ensure that
> they're properly configured.

OK. I guess that emitting a warning in the case of an un-claimed GPIO is OK,  
isn't it?

> > +static int __init pl061_probe(struct amba_device *dev, struct amba_id 
> > *id)
> > +{
> > +	struct pl061_platform_data *pdata;
> > +	struct pl061_gpio *chip;
> > +	int ret, irq, i;
> > +
> > +	pdata = dev->dev.platform_data;
> > +	if (pdata == NULL)
> > +		return -ENODEV;
> 
> -EINVAL would be better.

OK.

> > +
> > +	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
> > +	if (chip == NULL)
> > +		return -ENOMEM;
> > +
> > +	if (request_mem_region(dev->res.start, SZ_4K, "pl061") == NULL) {
> 
> It would be better to keep SZ_* constants out of what are essentially
> generic drivers - or we move them into some generic kernel header (but
> I don't hold out that much hope of that happening.)

OK.

> > diff --git a/include/linux/amba/pl061.h b/include/linux/amba/pl061.h
> > new file mode 100644
> > index 0000000..9e18fa3
> > --- /dev/null
> > +++ b/include/linux/amba/pl061.h
> > @@ -0,0 +1,18 @@
> > +/* platform data for the PL061 GPIO driver */
> > +
> > +#define GPIODIR 0x400
> > +#define GPIOIS  0x404
> > +#define GPIOIBE 0x408
> > +#define GPIOIEV 0x40C
> > +#define GPIOIE  0x410
> > +#define GPIORIS 0x414
> > +#define GPIOMIS 0x418
> > +#define GPIOIC  0x41C
> 
> I think it would make sense to have the above register definitions in
> the .c file.

I put the register definitions here for the platform code that needs access to 
those registers to determine IRQ sources.

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
