Return-Path: <linux-kernel-owner+w=401wt.eu-S1752353AbYJTHaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbYJTHaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 03:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYJTHaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 03:30:01 -0400
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:26413 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750966AbYJTHaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 03:30:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=16uJPR9IeB/rnkns5d9Nde1LDAq2WJUDNN6jdCDqpWpJ5LbGxUyPuL7c8JsDaJpoUgqpZItQUSalyx01hXLZXmnYtVk+dT2Wvd2ghBFaMWcY8HO+L1yf2neL9hAE6Mcw/UdXez7HIkvQYll6mrx9gEixdyJC5+qEu2VP3IbDgyA=  ;
X-YMail-OSG: wQzKrbgVM1naEjjBl0TXauK1KHN9t8L8_xQH3d7j55lPNp0yaQ94WxsS1otJH7woG8oDl3cfHxbB5cXGTGVk8BjsRPlFlS6MhtO8leFvxr2q1GwQcHx8VlzbrcKKZl6Dsk760Vaee5NmXqL4G26KfuFzkDynZ35cirb1cUI-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH 4/7] gpiolib: implement dev_gpiochip_{add,remove} calls
Date: Mon, 20 Oct 2008 00:29:57 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       "Steven A. Falco" <sfalco@harris.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>,
       i2c@lm-sensors.org, linuxppc-dev@ozlabs.org
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru> <200810171324.42650.david-b@pacbell.net> <20081017212942.GA1919@oksana.dev.rtsoft.ru>
In-Reply-To: <20081017212942.GA1919@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200810200029.58312.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 October 2008, Anton Vorontsov wrote:
> On Fri, Oct 17, 2008 at 01:24:42PM -0700, David Brownell wrote:
> > On Thursday 16 October 2008, Anton Vorontsov wrote:
> > > +/*
> > > + * Platforms can define their own __dev_ versions to glue gpio_chips with the
> > > + * architecture-specific code.
> > > + */
> > > +#ifndef __dev_gpiochip_add
> > > +#define __dev_gpiochip_add __dev_gpiochip_add
> > > +static inline int __dev_gpiochip_add(struct device *dev,
> > > +                                    struct gpio_chip *chip)
> > > +{
> > > +       chip->dev = dev;
> > > +       return gpiochip_add(chip);
> > > +}
> > > +#endif /* __dev_gpiochip_add */
> > 
> > This is pretty ugly, especially the implication that *EVERY* gpio_chip
> > provider needs modification to use these calls.
> 
> Anyway most of them need some modifications to work with OF...

The changes I saw were just to cope with not having
the system-specific platform_data provided:  don't
fail if that pointer is NULL, and arrange for dynamic
allocation of some GPIO numbers.

With OpenFirmware, presumably the implication is that
the relevant data is in the OF device tree...


I think that it *barely* makes sense to allow the chips
to bind to drivers without platform data when there's
not even OF in the environment.  ONLY in the case where
the GPIOs are exported through sysfs, in fact, since
otherwise there's no way for other system components
to know those GPIOs even exist!!  And even that seems
pretty marginal to me...


> > Surely it would be a lot simpler to just add platform-specific hooks
> > to gpiochip_{add,remove}(), [...]
> 
> We have printk and dev_printk. kzalloc and devm_kzalloc (though I
> aware that devm_ are different than just dev_).  So I thought that
> dev_gpiochip_* would be logical order of things...

Those aren't platform hook mechanisms though, and
there's no need to modify every driver to use them
in order to work *at all* on OpenFirmware systems.


> If you don't like it, I can readily implement hooks for
> gpiochip_{add,remove}().

It seems a better way to a clean solution, IMO.  For
example, the OF hook for adding a gpio_chip might
know that it's got to stuff chip->base with a number
other than "-1" (say, "42") since that was stored in
some property of the device's OF shadow, and other
devices have properties associating them with GPIO
numbers derived from that (3rd gpio on that chip,
42 + 3 == 45) and so forth.

That said ... there's a LOT of configuration that
doesn't seem to me like it can be generic.  Pullups,
pulldowns, default values, polarity inversion,
what devices depend on those GPIOs being available
before they can come up (GPIO leds and power switches
come quickly to mind), all kinds of chip-specific
details, and more.

Did you look at providing chip-aware OF glue drivers
for this stuff?  Doing stuff like just turn the OF
device properties into the right platform_data, and
maybe runing FORTH bytecodes to do other configuration
magic needed...

- Dave
