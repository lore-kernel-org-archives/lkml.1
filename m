Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbZBRVzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbZBRVzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZBRVzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:55:10 -0500
Received: from bu3sch.de ([62.75.166.246]:38443 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbZBRVzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:55:09 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] spi-gpio: Sanitize MISO bitvalue
Date: Wed, 18 Feb 2009 22:52:42 +0100
User-Agent: KMail/1.9.9
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       openwrt-devel@lists.openwrt.org
References: <200902151630.41426.mb@bu3sch.de> <20090218130426.a12e6bfa.akpm@linux-foundation.org>
In-Reply-To: <20090218130426.a12e6bfa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902182252.42519.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009 22:04:26 Andrew Morton wrote:
> On Sun, 15 Feb 2009 16:30:41 +0100
> Michael Buesch <mb@bu3sch.de> wrote:
> 
> > gpio_get_value() returns 0 or nonzero, but getmiso() expects 0 or 1.
> > Sanitize the value to a 0/1 boolean.
> > 
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> > 
> > ---
> > 
> > Well, we could also change the bitbang helpers in linux/spi/spi_bitbang.h
> > or change the way the gpio_get_value API is defined, but I personally think
> > this patch is pretty good as is.
> > In any case, it fixes a real bug on platforms like the bcm47xx which
> > return 0 or nonzero for gpio_get_value.
> > 
> > Index: linux-2.6/drivers/spi/spi_gpio.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/spi/spi_gpio.c	2009-02-14 21:37:14.000000000 +0100
> > +++ linux-2.6/drivers/spi/spi_gpio.c	2009-02-15 16:27:16.000000000 +0100
> > @@ -114,7 +114,7 @@ static inline void setmosi(const struct 
> >  
> >  static inline int getmiso(const struct spi_device *spi)
> >  {
> > -	return gpio_get_value(SPI_MISO_GPIO);
> > +	return !!gpio_get_value(SPI_MISO_GPIO);
> >  }
> >  
> >  #undef pdata
> > 
> 
> Seems somewhat pointless, really.  It's a very common C idiom to treat
> any non-zero value as true, and the above just adds a couple more
> instructions which we didn't need to execute.

No you must look at the user of getmiso().
It does something like this:

	for (bitnr = 0; bitnr < x; bitnr++) {
		foo = getmiso() << bitnr;
		...
	}

> If this function is speed-critical (which is what David's comment
> implies) then perhaps this should be "fixed" by tightening up the
> (presently apparently undocumented) interface?  And then speeding up
> all the other getmiso() implementations?

He was talking about gpio_get_value() and my (silly) suggestion to change
it to return 0 or 1. I knew that he would reject that, because we already talked
about this in the past. So changing getmiso() _is_ the way to go. It is the cheapest
way to do this, in fact. Doing it _inside_ of getmiso() would mean that it could
possibly be redundant, if upper layers already did it.

David suggested documenting the fact that getmiso() expects 0/1.
He can easily do that in yet another patch if he likes this.

My patch is just supposed to fix a real-world bug, which isn't in a released kernel, yet.
So if we hurry up, we can still get it into .29.

The documentation change can still go in later.

-- 
Greetings, Michael.
