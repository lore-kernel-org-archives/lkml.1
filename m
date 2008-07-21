Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbYGUUls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbYGUUls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbYGUUlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:41:40 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:38923 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750724AbYGUUlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:41:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=y2Oy782XiZywiAGdMMm995XxoOwNu0Q3hDJqAPCyi05HqDBiQgflWhMWGTlUp6VfoC4DybG4mWSIDZCt4vmvWhT8p18QejwZoh7ArdgKwYaCR6mSbfYvbKcF1BPUJzmW6V8oGqEEwgKhr68yOEpFSw6M2tIA4vcHXOBZLduHezM=  ;
X-YMail-OSG: w4tEw7oVM1nsL1wzzFXMFw2Z5i9Mz3X7.gWIBjfjAXxDQigmiu6tDdUPGftFfTAelke9JiPox_jNBmZ64UlxwgcZADcXEeWRjoAoOU2RnAEMFjN.oHBOdVYQPAEjSBk-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH v2] Add GPIO-based MMC/SD driver
Date: Mon, 21 Jul 2008 13:41:35 -0700
User-Agent: KMail/1.9.9
Cc: Randy Dunlap <randy.dunlap@oracle.com>, gregkh <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Piot Skamruk <piotr.skamruk@gmail.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, openwrt-devel@lists.openwrt.org
References: <200807182201.33913.mb@bu3sch.de> <20080718151037.a54dec8a.randy.dunlap@oracle.com>
In-Reply-To: <20080718151037.a54dec8a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807211341.35766.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ I see "v3" switches to configfs ... same comments apply. ]

On Friday 18 July 2008, Randy Dunlap wrote:
> On Fri, 18 Jul 2008 22:01:33 +0200 Michael Buesch wrote:
> 
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-next/drivers/mmc/host/gpiommc.c	2008-07-18 21:54:05.000000000 +0200
> > @@ -0,0 +1,328 @@
> > +/*
> > + * Driver an MMC/SD card on a bitbanging GPIO SPI bus.

Driver "for" an MMC/SD card ...


> > + * This module hooks up the mmc_spi and spi_gpio modules and also
> > + * provides a sysfs interface.

I'm not quite following things here.  The mmc_spi driver has
no particular issues running over any correct implementation
of SPI, whether it uses GPIO or anything else.

In fact, I did doing a bunch of early mmc_spi work using a
SPI-over-GPIO bitbanger.  (Also some tuning for the GPIO
interfaces, making sure those calls inlined transparently
to get more usable speeds.)  So I know that already works
just fine ...


So what this driver adds is mostly a userspace interface, yes?
The reason to select THIS feature is to get the userspace
configuration ... not to get the MMC/SD-over-GPIO, since
that can already be done without this code.


If so, please refocus the descriptions a bit more on that;
it's not actually a "GPIO based MMC/SD driver"; it's really
a "Configfs creation interface for GPIO based MMC/SD".


> > +	res = sscanf(buf, "%" GPIOMMC_MAX_NAMELEN_STR "s %u %u %u %u %u %u %u %u",

Kind of ugly, yes?  ;)


> > +		     pdata->p.name,
> > +		     &pdata->p.pins.gpio_di,
> > +		     &pdata->p.pins.gpio_do,

Can we avoid that DI/DO convention?  The master DI is the slave DO,
and vice versa.  Your documentation doesn't say which is which; and
for such ambiguous names, that's critical.  Since these GPIOs are
on the master side, I'd expect these labels are for the master
side not the slave side.

Please switch to the more conventional "MOSI" (Master Out, Slave In)
and "MISO" (Master In, Slave Out).  That's unambiguous.  If you want
to be a bit more clear you could say that MOSI goes to the MMC/SD
card pin 2 (card data in), and MISO goes to MMC/SD card pin 7 (card
data out).


> > +		     &pdata->p.pins.gpio_clk,
> > +		     &pdata->p.pins.gpio_cs,
> > +		     &mode,
> > +		     &pdata->p.max_bus_speed,
> > +		     &no_spi_delay,
> > +		     &csactivelow);
> > +	pdata->p.mode = mode;
> > +	pdata->p.no_spi_delay = !!no_spi_delay;
> > +	pdata->p.pins.cs_activelow = !!csactivelow;
> > +	if (res < 9)
> > +		pdata->p.pins.cs_activelow = 1; /* Default: CS = activelow */

Do you actually need this?  If so, why?  The MMC (and SD) specs
say that pin 1 (chipselect) is active low, and that's normal
for all SPI interfaces.  This may need a comment that it's never
needed unless there's an inverter in that signal path.


> > +	if (res < 8)
> > +		pdata->p.no_spi_delay = 0; /* Default: Delay turned on */
> > +	if (res < 7)
> > +		pdata->p.max_bus_speed = 5000000; /* Default: 5Mhz */

Maybe it's just the hardware I've used, but I've had a hard time
getting bitbanged SPI to run that fast ... more like 2.5 MHz unless
you're using big word sizes (and MMC is stuck at 8-bit words), and
that speed assumes inlined gpio code not subroutine-call-per-bit.

So I'd default to leaving the delay off, and wouldn't bother trying
to place a ceiling on the speeds which is lower than the 25 MHz that
SD cards allow.


> > +	if (res < 6)
> > +		pdata->p.mode = 0; /* Default: SPI mode 0 */

Don't need to do this.  The mmc_spi driver forces mode 0 in
any case...



> > --- linux-next.orig/drivers/mmc/host/Kconfig	2008-07-18 21:52:46.000000000 +0200
> > +++ linux-next/drivers/mmc/host/Kconfig	2008-07-18 21:57:08.000000000 +0200
> > @@ -164,3 +164,23 @@ config MMC_S3C
> >  
> >  	  If unsure, say N.
> >  
> > +config GPIOMMC
> > +	tristate "MMC/SD over GPIO-based SPI"

"Sysfs interface for ..."

Because we can already do MMC/SD over GPIO-SPI,
without using this code.


> > +	depends on MMC && MMC_SPI && SPI_GPIO
> > +	help
> > +	  This driver hooks up the mmc_spi and spi_gpio modules so that
> > +	  MMC/SD cards can be used on a GPIO based bus by bitbanging
> > +	  the SPI protocol in software.
> > +
> > +	  This driver provides a sysfs interface to dynamically create
> > +	  and destroy GPIO-based MMC/SD card interfaces. It also provides
> > +	  a platform device interface API.

Probably best to just switch those two paragraphs around,
and highlight that this SPI bus can't be used for anything
except that MMC/SD slot even if we someday extend the SPI
interfaces with exclusive access primitives.

The platform device interface API is not actually needed
to implement MMC/SD-over-bitbanged-SPI; it's only really
needed to implement this driver.  So I'd not mention the
presence of such a module-internal interface.


Now, if you were to implement the MMC protocol directly
over GPIOs, rather than indirectly through SPI-over-GPIO,
that would be worth packaging for general use.  (Such a
thing would be worth doing.  The latest JEDEC versions
of the "embedded MMC" specs -- parallel 8 bit data paths,
used for SMT chips not just cards -- omit SPI support.
Using platform-specific parallel GPIO support to support
4 or 8 bit data widths would give a big speedup too.)


> > +	  See Documentation/gpiommc.txt for details.
> > +
> > +	  The module will be called gpiommc.
> > +
> > +	  If unsure, say N.
> > +
> > +config MMC_S3C
> > +	tristate "Samsung S3C SD/MMC Card Interface support"
> > +	depends on ARCH_S3C2410 && MMC

MMC_S3C doesn't belong in this patch...



> > + * @no_spi_delay: Do not use delays in the lowlevel SPI bitbanging code.
> > + *                This is not standards compliant, but may be required for some
> > + *                embedded machines to gain reasonable speed.

Rather than emphasize "not standards compliant", I'd instead emphasize that
bitbanged SPI is so slow that you probably don't want to slow it down any
more by additional delays between per-bit operations!


> > Index: linux-next/Documentation/gpiommc.txt
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-next/Documentation/gpiommc.txt	2008-07-18 21:54:05.000000000 +0200

Should there be a  Documentation/mmc/... for such stuff, instead?
The toplevel Documentation directory is getting unmanageable.


> > @@ -0,0 +1,96 @@
> > +GPIOMMC - Driver for an MMC/SD card on a bitbanging GPIO SPI bus
> > +================================================================
> > +
> > +The gpiommc module hooks up the mmc_spi and spi_gpio modules for running an
> > +MMC or SD card on GPIO pins.
> > +
> > +Two interfaces for registering a new MMC/SD card device are provided.
> 
>                                                            are provided:
>    a static
> 
> > +A static platform-device based mechanism and a dynamic sysfs based interface.

Again, please don't promote a *SECOND* platform-device based mechanism
for this.  The current one works just fine:  standard definition of
a SPI bus (in this case using GPIO bitbanging), combined with standard
definition of an mmc-over-spi card slot.

(I notice you don't support card detect and writeprotect detect GPIOs
in your configfs interface.  Such omissions are easy to address through
the standard mmc-over-spi card slot mechanism ...)


> > +
> > +
> > +Registering devices via platform-device
> > +=======================================
> > +
> > +The platform-device interface is used for registering MMC/SD devices that are
> > +part of the hardware platform. This is most useful only for embedded machines
> > +with MMC/SD devices statically connected to the platform GPIO bus.

There is no "platform GPIO bus" ... 

This is the interface I'd rather just not see exposed ...

> > +The data structures are declared in <linux/mmc/gpiommc.h>

... and just see internal to this driver, without a new header
duplicating existing mechanisms.



> > +Registering devices via sysfs
> > +=============================

This is the interface I don't have any particular issues with.


> > +
> > +MMC/SD cards connected via GPIO often are a pretty dynamic thing. For example
> > +selfmade hacks for soldering an MMC/SD card to standard GPIO pins on embedded
> > +hardware are a common situation.
> 
> I think that the two sentences above/below would be better if joined with a comma...

I certainly wouldn't say "often", even though I've done it!

How about:  "... via GPIO may be easier to configure through
sysfs than through the normal platform device declaration
mechanisms.  For example, selfmade ... situation, and using
sysfs to verify the pin assignments may save a few iterations
of a kernel modify/build/install/test cycle."

