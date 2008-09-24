Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbYIXSzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbYIXSzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbYIXSzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:55:05 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:30850 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752768AbYIXSzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:55:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xUr3BNOb8k0LEXvtS4BkRrS2D2Vm63jsJ/UQuM7sVkphb4jiA6t9sbsJ4cXIajo+E2+IhQenM0kG7EsJza7k+EgXMohdIiWqatR/4xOmwo12mTp79GB8/7mp2O644DUyTW7yS1aPTSyGN8PxczO//wdILV82mx61NrI/x1KaCFU=  ;
X-YMail-OSG: wgEPwvcVM1nFgPDjrx8gwSV4PozNpXT4OFcbMUL5jkzywXAKFaaueJVcyICla7L4dWLJ9VXRP.izh_P_3pIFAGVUA_VLxcFIMp6zcsr26I6hp4XvKDCAaWAnUk7O21I1UnE-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH 2/4] powerpc/qe: new call to revert a gpio to a dedicated function
Date: Wed, 24 Sep 2008 11:54:24 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>, linuxppc-dev@ozlabs.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080924000255.GA28054@oksana.dev.rtsoft.ru> <20080924000336.GB29733@oksana.dev.rtsoft.ru>
In-Reply-To: <20080924000336.GB29733@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809241154.25722.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2008, Anton Vorontsov wrote:
> qe_gpio_set_dedicated() is a platform specific function, which is used
> to revert a pin to a dedicated function. Caller should have already
> obtained the gpio via gpio_request().

Note the missing sibling function:  putting the pin back into
GPIO mode!!  You seem to assume that some of the GPIO calls
will be performing that pinmux function.  But those calls are
explicitly defined as NOT incorporating any pinmux tasks.

Also note your nonportable assumption that GPIOs and pins are
the same concept ... they aren't.


You'd be better off calling something other than of_get_gpio()
for those three pins in of_fhci_probe() ... call something
that returns a "qe_pin" structure (e.g. wrapping an instance of
the misnamed qe_gpio_chip plus an offset) which holds the
pinmux primitives you need.  Like this one to put the pin into
its normal mode.

When I look at patch 4 of this series I observe that only
two pins are true GPIOs:  the optional POWER and SPEED pins.
(External transceiver support?)


> +int qe_gpio_set_dedicated(unsigned int gpio)
> +{
> +	struct gpio_chip *gc = gpio_to_chip(gpio);

So the caller must already have requested it, yes -- that's a
needed for any stable mapping between GPIO and controller inside
the GPIO library.

For the record, this single call seems to be the entire reason
motivating that rather ugly patch #1.  (Ugly for more than just
the confusion between pin, which is what you need, and GPIO.
There's no need to export those internal data structures.)


And in turn, the reason to want this call is so that you can
have io_port_generate_reset() generate a short reset on the
single downstream USB port.  ("Short" meaning "45 msec below
USB spec requirements for root hub resets" ...)

And to top it off ... that driver does gpio_request(), runs
those pins as GPIOs for virtually no time, and then uses
them as "dedicated functions" the rest of the time (after
the reset completes)!!


Which highlights the fact that these pins are fundamentally
NOT used as GPIOs.  They're function pins that need brief
detours as GPIOs because, it seems, those functions only
support differential signaling (USB J and K states) instead
of the full set of USB states.  (It's not quite clear from
the driver.  Are the pins expected to be using a 3-wire
external transciever hookup?  4-wire?  6-wire?)



But there are other requirements for this no-kerneldoc call:

> +	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);

... it must be part of an of_mm_gpio_chip (in <linux/of_gpio.h>,
which might seem less odd to me if I read its supporting code).

Can you first ensure that it *is* an of_mm_gpio_chip
instance?  When it isn't, this code will oops rudely.


> +	struct qe_gpio_chip *qe_gc = to_qe_gpio_chip(mm_gc);

... it must be the qe_gpio_chip flavor (defined only in this
very file, arch/powerpc/sysdev/qe_lib/gpio.c); IMO the code
would be cleaner if you just did

	qe_gc = container_of(gpio_to_chip(gpio),
			struct qe_gpio_chip, mm_gc.of_gc.gc);

and had just one pointer (not three!) for all these purposes.

(And cleaner still if it didn't require whacking the GPIO
framework out of shape to have a hope of working.)

But again:  you're trusting, with no evident basis for that
trust, that it's a qe_gpio_chip instance.  Oops if it isn't.
Much better for these calls to take e.g. a "qe_pin" parameter,
struct pointer or whatever ... not a GPIO number.


> +	struct qe_pio_regs __iomem *regs = mm_gc->regs;
> +	struct qe_pio_regs *sregs = &qe_gc->saved_regs;
> +	u8 pin = gpio - gc->base;
> +	u32 mask1 = 1 << (QE_PIO_PINS - (pin + 1));
> +	u32 mask2 = 0x3 << (QE_PIO_PINS - (pin % (QE_PIO_PINS / 2) + 1) * 2);
> +	bool second_reg = pin > (QE_PIO_PINS / 2) - 1;
>	...
