Return-Path: <linux-kernel-owner+w=401wt.eu-S1764021AbXK3SlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764021AbXK3SlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 13:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761923AbXK3SlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 13:41:02 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:48139 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756974AbXK3SlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 13:41:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vjEnp53zQAjyMYhptpwZhLg0YxKSVniFOsdhWz3WnrkgSOkKe+wM4sE73m10ktywQhSV2w5UH1Ht1XT0qUM8BzDS5UU0zYPz9wXRGhgr9i4tZW91WaHE5Gw6AXjQLR2s1aR/HKs59GVV6Bza3KFVJwtfx2gqCphMUetmQ0CUuD0=  ;
X-YMail-OSG: TbcI8KQVM1k2JKbjaUMcd8BAETqcMdlLN78SMIvoeU1SxuEHom4d_c7LLb9tHTUizCZGvkKobAki0aq5Osq74aI7HcfvcksMA.nAw7_UuzbZI8kXmcWe89gNRoZN
From: David Brownell <david-b@pacbell.net>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [patch/rfc 2/4] pcf875x I2C GPIO expander driver
Date: Fri, 30 Nov 2007 10:40:54 -0800
User-Agent: KMail/1.9.6
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Felipe Balbi <felipebalbi@users.sourceforge.net>,
       Bill Gatliff <bgat@billgatliff.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <andrew@sanpeople.com>, Tony Lindgren <tony@atomide.com>,
       "eric miao" <eric.y.miao@gmail.com>, Kevin Hilman <khilman@mvista.com>,
       Paul Mundt <lethal@linux-sh.org>, Ben Dooks <ben@trinity.fluff.org>
References: <200710291809.29936.david-b@pacbell.net> <200710291851.49057.david-b@pacbell.net> <20071130133256.72385ea8@hyperion.delvare>
In-Reply-To: <20071130133256.72385ea8@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200711301040.54777.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 November 2007, Jean Delvare wrote:
> Hi David,
> 
> Sorry for the late review.

I've got patches in my queue too, sigh ...

Thanks for the review.  I'll snip out typos and similar trivial
comments (and fix them!), using responses here for more the
substantive feedback.

- Dave


> > --- a/drivers/i2c/chips/Kconfig	2007-10-28 21:04:06.000000000 -0700
> > +++ b/drivers/i2c/chips/Kconfig	2007-10-29 14:16:01.000000000 -0700
> > @@ -51,6 +51,24 @@ config SENSORS_EEPROM
> >  	  This driver can also be built as a module.  If so, the module
> >  	  will be called eeprom.
> >  
> > +config GPIO_PCF857X
> > +	tristate "PCF875x GPIO expanders"
> > +	depends on GPIO_LIB
> > +	help
> > +	  ...
> > +
> > +	  This driver provides only an in-kernel interface to those GPIOs.
> > +	  Any sysfs interface to userspace would be provided separately.
> 
> How?

I'll take that out, to avoid the question.  The answer is still mostly
TBD, but the gpiolib infrastructure provides a number of the hooks
that such a userspace interface would need.


> > +/**
> > + * struct pcf857x_platform_data - data to set up pcf857x driver
> > + * @gpio_base: number of the chip's first GPIO
> > + * @n_latch: optional bit-inverse of initial output state
> 
> Strange name, and I can't make much sense of the description either.

Updated description:

 * @n_latch: optional bit-inverse of initial register value; if
 *      you leave this initialized to zero, the driver will treat
 *      all bits as inputs as if the chip was just reset

This chip is documented as being "pseudo-bidirectional", which is
a sign that there are some confusing mechanisms lurking...


Conventions for naming negative-true signals include a "#" suffix
(illegal for C), a overbar (not expressible in ASCII), and prefixes
including "/" (illegal for C) and "n" (aha!).  I morphed the latter
into "n_" since it's often paired with all-caps signal names, as
in "nRESET", which are bad kernel coding style.

Latches hold values; http://en.wikipedia.org/wiki/Latch_%28electronics%29
talks about bit-level latching, but GPIO controllers use register-wide
latches to record the value that should be driven on output pins.
(As opposed to input pins, whose values are read without latching.)


> After reading this paragraph I still have no idea what n_latch does.
> But maybe that's just me.

It's a wierd little arrangement, maybe you have a better explanation.
I tried hitting the confusing points more directly:

 * These GPIO chips are only "pseudo-bidirectional"; read the chip specs
 * to understand the behavior.  They don't have separate registers to
 * record which pins are used for input or output, record which output
 * values are driven, or provide access to input values.  That must all
 * be inferred by reading the chip's value and knowing the last value
 * written to it.  If you don't initialize n_latch, that last written
 * value is presumed to be all ones (as if the chip were just reset).


> > --- a/drivers/i2c/chips/Makefile	2007-10-28 21:04:06.000000000 -0700
> > +++ b/drivers/i2c/chips/Makefile	2007-10-28 21:09:49.000000000 -0700
> > @@ -11,6 +11,7 @@ obj-$(CONFIG_SENSORS_M41T00)	+= m41t00.o
> >  obj-$(CONFIG_SENSORS_PCA9539)	+= pca9539.o
> >  obj-$(CONFIG_SENSORS_PCF8574)	+= pcf8574.o
> >  obj-$(CONFIG_SENSORS_PCF8591)	+= pcf8591.o
> > +obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
> 
> For alphabetical order, it would go one line above.

For alphabetical order it would go much sooner.
GPIO precedes SENSOR.  ;)


> >  obj-$(CONFIG_ISP1301_OMAP)	+= isp1301_omap.o
> >  obj-$(CONFIG_TPS65010)		+= tps65010.o
> >  obj-$(CONFIG_SENSORS_TLV320AIC23) += tlv320aic23.o
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ b/drivers/i2c/chips/pcf857x.c	2007-10-29 14:12:21.000000000 -0700
> > @@ -0,0 +1,309 @@
> > +/*
> > + * pcf857x - driver for pcf857{4,4a,5,5c} I2C GPIO expanders
> 
> I recommend spelling out chip names completely, as it lets people grep
> the kernel tree for chip names when they look for support.

I'll do that -- but note that the names *are* spelled out later.


> > +#include <linux/pcf857x.h>
> 
> I suspect that there will be many more such header files in the future.
> Would it make sense to move them to include/linux/gpio?

I was thinking more like <linux/i2c/...> myself.  There are many more
I2C chips than GPIO expanders.


> > +static int pcf857x_output8(struct gpio_chip *chip, unsigned offset, int value)
> > +	...
> > +
> > +static void pcf857x_set8(struct gpio_chip *chip, unsigned offset, int value)
> > +{
> > +	pcf857x_output8(chip, offset, value);
> > +}
> 
> It would be more efficient to drop pcf857x_set8 altogether and do
> gpio->chip.set = pcf857x_output8.

No can do; return types differ, which means that on some platforms
the calling conventions have significant differences.


> > +                     dev_err(&client->dev, "%s --> %d\n",
> > +                                     "teardown", status);
>
> Why %s instead of hard-coding "teardown"?

To share (current code) three copies of the "<3>%s %s: %s --> %d\n"
string.  Every little bit of kernel bloat prevention helps.  ;)
