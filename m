Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbXK3UNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbXK3UNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 15:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbXK3UNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 15:13:37 -0500
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:3293 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751409AbXK3UNg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 15:13:36 -0500
Date: Fri, 30 Nov 2007 21:13:32 +0100
From: Jean Delvare <khali@linux-fr.org>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Felipe Balbi <felipebalbi@users.sourceforge.net>,
       Bill Gatliff <bgat@billgatliff.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <andrew@sanpeople.com>, Tony Lindgren <tony@atomide.com>,
       "eric miao" <eric.y.miao@gmail.com>, Kevin Hilman <khilman@mvista.com>,
       Paul Mundt <lethal@linux-sh.org>, Ben Dooks <ben@trinity.fluff.org>
Subject: Re: [patch/rfc 2/4] pcf875x I2C GPIO expander driver
Message-ID: <20071130211332.49a21a6b@hyperion.delvare>
In-Reply-To: <200711301040.54777.david-b@pacbell.net>
References: <200710291809.29936.david-b@pacbell.net>
	<200710291851.49057.david-b@pacbell.net>
	<20071130133256.72385ea8@hyperion.delvare>
	<200711301040.54777.david-b@pacbell.net>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Fri, 30 Nov 2007 10:40:54 -0800, David Brownell wrote:
> On Friday 30 November 2007, Jean Delvare wrote:
> > > --- a/drivers/i2c/chips/Kconfig	2007-10-28 21:04:06.000000000 -0700
> > > +++ b/drivers/i2c/chips/Kconfig	2007-10-29 14:16:01.000000000 -0700
> > > @@ -51,6 +51,24 @@ config SENSORS_EEPROM
> > >  	  This driver can also be built as a module.  If so, the module
> > >  	  will be called eeprom.
> > >  
> > > +config GPIO_PCF857X
> > > +	tristate "PCF875x GPIO expanders"
> > > +	depends on GPIO_LIB
> > > +	help
> > > +	  ...
> > > +
> > > +	  This driver provides only an in-kernel interface to those GPIOs.
> > > +	  Any sysfs interface to userspace would be provided separately.
> > 
> > How?
> 
> I'll take that out, to avoid the question.  The answer is still mostly
> TBD, but the gpiolib infrastructure provides a number of the hooks
> that such a userspace interface would need.

So the user-space interface would be part of the generic GPIO
infrastructure? I like the idea.

> > > +/**
> > > + * struct pcf857x_platform_data - data to set up pcf857x driver
> > > + * @gpio_base: number of the chip's first GPIO
> > > + * @n_latch: optional bit-inverse of initial output state
> > 
> > Strange name, and I can't make much sense of the description either.
> 
> Updated description:
> 
>  * @n_latch: optional bit-inverse of initial register value; if
>  *      you leave this initialized to zero, the driver will treat
>  *      all bits as inputs as if the chip was just reset
> 
> This chip is documented as being "pseudo-bidirectional", which is
> a sign that there are some confusing mechanisms lurking...
> 
> 
> Conventions for naming negative-true signals include a "#" suffix
> (illegal for C), a overbar (not expressible in ASCII), and prefixes
> including "/" (illegal for C) and "n" (aha!).  I morphed the latter
> into "n_" since it's often paired with all-caps signal names, as
> in "nRESET", which are bad kernel coding style.
> 
> Latches hold values; http://en.wikipedia.org/wiki/Latch_%28electronics%29
> talks about bit-level latching, but GPIO controllers use register-wide
> latches to record the value that should be driven on output pins.
> (As opposed to input pins, whose values are read without latching.)
> 
> 
> > After reading this paragraph I still have no idea what n_latch does.
> > But maybe that's just me.
> 
> It's a wierd little arrangement, maybe you have a better explanation.
> I tried hitting the confusing points more directly:
> 
>  * These GPIO chips are only "pseudo-bidirectional"; read the chip specs
>  * to understand the behavior.  They don't have separate registers to
>  * record which pins are used for input or output, record which output
>  * values are driven, or provide access to input values.  That must all
>  * be inferred by reading the chip's value and knowing the last value
>  * written to it.  If you don't initialize n_latch, that last written
>  * value is presumed to be all ones (as if the chip were just reset).

Much clearer now, thanks. I know what a latch is, I just couldn't get
how latching (or lack thereof) was related with an initial register
value. With the explanation above, I get it.

> > > --- a/drivers/i2c/chips/Makefile	2007-10-28 21:04:06.000000000 -0700
> > > +++ b/drivers/i2c/chips/Makefile	2007-10-28 21:09:49.000000000 -0700
> > > @@ -11,6 +11,7 @@ obj-$(CONFIG_SENSORS_M41T00)	+= m41t00.o
> > >  obj-$(CONFIG_SENSORS_PCA9539)	+= pca9539.o
> > >  obj-$(CONFIG_SENSORS_PCF8574)	+= pcf8574.o
> > >  obj-$(CONFIG_SENSORS_PCF8591)	+= pcf8591.o
> > > +obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
> > 
> > For alphabetical order, it would go one line above.
> 
> For alphabetical order it would go much sooner.
> GPIO precedes SENSOR.  ;)

We apply the alphabetical order to driver names, not configuration
symbols, as far as I know. Though for most directories it probably
doesn't make a difference; drivers/i2c/chips is admittedly a bit messy
in this respect.

Note that at some point I will attempt to get rid of the "SENSORS" part
of configuration options that have nothing to do with sensors, that
should help a bit.

> > > +#include <linux/pcf857x.h>
> > 
> > I suspect that there will be many more such header files in the future.
> > Would it make sense to move them to include/linux/gpio?
> 
> I was thinking more like <linux/i2c/...> myself.  There are many more
> I2C chips than GPIO expanders.

But most i2c chip drivers don't need a header file. Or is this going to
change with the new-style i2c drivers?

Along the same line, I am wondering if it would make sense to put the
various GPIO drivers in drivers/gpio. It's a much better practice to
group the drivers according to the functionality they provide than the
way they are connected to the system. drivers/i2c/chips is an exception
in this respect, it's meant for i2c drivers that have no obvious place
to live in. That's why there aren't many drivers there, and I hope it
will stay this way. In an ideal world we could even get rid of this
directory and move the remaining drivers to drivers/misc.

> > > +static int pcf857x_output8(struct gpio_chip *chip, unsigned offset, int value)
> > > +	...
> > > +
> > > +static void pcf857x_set8(struct gpio_chip *chip, unsigned offset, int value)
> > > +{
> > > +	pcf857x_output8(chip, offset, value);
> > > +}
> > 
> > It would be more efficient to drop pcf857x_set8 altogether and do
> > gpio->chip.set = pcf857x_output8.
> 
> No can do; return types differ, which means that on some platforms
> the calling conventions have significant differences.

Ah, right, sorry for missing that. I had only looked at the parameters
and forgot the return type.

> > > +                     dev_err(&client->dev, "%s --> %d\n",
> > > +                                     "teardown", status);
> >
> > Why %s instead of hard-coding "teardown"?
> 
> To share (current code) three copies of the "<3>%s %s: %s --> %d\n"
> string.  Every little bit of kernel bloat prevention helps.  ;)

Only two copies in the version you posted, but indeed there would be
three if the trick was applied consistently.

-- 
Jean Delvare
