Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbZBRAyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbZBRAyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbZBRAx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:53:59 -0500
Received: from bu3sch.de ([62.75.166.246]:45689 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbZBRAx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:53:58 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] bcm47xx: Fix GPIO API return codes
Date: Wed, 18 Feb 2009 01:52:16 +0100
User-Agent: KMail/1.9.9
Cc: openwrt-devel@lists.openwrt.org, linux-kernel@vger.kernel.org
References: <200902142127.19521.mb@bu3sch.de> <20090217162918.d88bc543.akpm@linux-foundation.org>
In-Reply-To: <20090217162918.d88bc543.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902180152.16346.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009 01:29:18 Andrew Morton wrote:
> On Sat, 14 Feb 2009 21:27:19 +0100
> Michael Buesch <mb@bu3sch.de> wrote:
> 
> > The GPIO API is supposed to return 0 or a negative error code,
> > but the SSB GPIO functions return the bitmask of the GPIO register.
> > Fix this by ignoring the bitmask and always returning 0. The SSB GPIO functions can't fail.
> > 
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> > 
> > ---
> > 
> > Index: linux-2.6/arch/mips/include/asm/mach-bcm47xx/gpio.h
> > ===================================================================
> > --- linux-2.6.orig/arch/mips/include/asm/mach-bcm47xx/gpio.h	2009-01-01 19:27:06.000000000 +0100
> > +++ linux-2.6/arch/mips/include/asm/mach-bcm47xx/gpio.h	2009-02-14 21:26:14.000000000 +0100
> > @@ -31,24 +31,28 @@ static inline void gpio_set_value(unsign
> >  
> >  static inline int gpio_direction_input(unsigned gpio)
> >  {
> > -	return ssb_gpio_outen(&ssb_bcm47xx, 1 << gpio, 0);
> > +	ssb_gpio_outen(&ssb_bcm47xx, 1 << gpio, 0);
> > +	return 0;
> >  }
> >  
> >  static inline int gpio_direction_output(unsigned gpio, int value)
> >  {
> > -	return ssb_gpio_outen(&ssb_bcm47xx, 1 << gpio, 1 << gpio);
> > +	ssb_gpio_outen(&ssb_bcm47xx, 1 << gpio, 1 << gpio);
> > +	return 0;
> >  }
> >  
> > -static int gpio_intmask(unsigned gpio, int value)
> > +static inline int gpio_intmask(unsigned gpio, int value)
> >  {
> > -	return ssb_gpio_intmask(&ssb_bcm47xx, 1 << gpio,
> > -				value ? 1 << gpio : 0);
> > +	ssb_gpio_intmask(&ssb_bcm47xx, 1 << gpio,
> > +			 value ? 1 << gpio : 0);
> > +	return 0;
> >  }
> >  
> > -static int gpio_polarity(unsigned gpio, int value)
> > +static inline int gpio_polarity(unsigned gpio, int value)
> >  {
> > -	return ssb_gpio_polarity(&ssb_bcm47xx, 1 << gpio,
> > -				 value ? 1 << gpio : 0);
> > +	ssb_gpio_polarity(&ssb_bcm47xx, 1 << gpio,
> > +			  value ? 1 << gpio : 0);
> > +	return 0;
> >  }
> 
> What are the consequences of the bug which you fixed?  User-visible
> runtime failures?  Something else?
> 
> Please always include this information in the changelogs - without it I
> cannot make which-kernel-needs-this decisions.

Well, it fixes all users of the API that don't ignore the return value.
"Fixes" means "turns them from completely not working at all into - working properly".
This is the case for gpio-spi, for example. gpio-spi doesn't work on bcm47xx without
this fix. gpio-spi is in 2.6.29.
I didn't search for other API-users that might be broken.

So I'd like to see this going to Linus as soon as possible.

-- 
Greetings, Michael.
