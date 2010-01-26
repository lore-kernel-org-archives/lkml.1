Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646Ab0AZRnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab0AZRnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 12:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305Ab0AZRnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 12:43:49 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:54760 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754238Ab0AZRnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 12:43:49 -0500
Date: Tue, 26 Jan 2010 20:43:47 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <david-b@pacbell.net>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Gatliff <bgat@billgatliff.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] of/gpio: Add support for two-stage registration
 for the of_gpio_chips
Message-ID: <20100126174347.GB20319@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20100125180957.GA5380@oksana.dev.rtsoft.ru>
 <20100125181103.GB13805@oksana.dev.rtsoft.ru>
 <201001252236.16141.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201001252236.16141.david-b@pacbell.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 10:36:15PM -0800, David Brownell wrote:
> On Monday 25 January 2010, Anton Vorontsov wrote:
> > With this patch there are two ways to register OF GPIO controllers:
> > 
> > 1. Allocating the of_gpio_chip structure and passing the
> >    &of_gc->gc pointer to the gpiochip_add. (Can use container_of
> >    to convert the gpio_chip to the of_gpio_chip.)
> > 
> > 2. Allocating and registering the gpio_chip structure separately
> >    from the of_gpio_chip. (Since two allocations are separate,
> >    container_of won't work.)
> > 
> > As time goes by we'll kill the first option.
> 
> Why have two options, instead of just the first/simpler one??

Because I2C/SPI drivers allocate (and register) gpio_chip structures
by themselves, so the first option is a no-go.

You can see the first option in use in
arch/powerpc/sysdev/qe_lib/gpio.c:

struct qe_gpio_chip {
        struct of_mm_gpio_chip mm_gc;
	....
};

Now include/linux/of_gpio.h:

struct of_mm_gpio_chip {
        struct of_gpio_chip of_gc;
	...
};

struct of_gpio_chip {
        struct gpio_chip gc; <- here, I'm going to get rid of it
	...
};

I2C/SPI drivers allocate gpio_chip structure already, so we don't
need to store 'struct gpio_chip gc', instead we need to store just
a pointer, and then attach the already allocated gpio_chip to the
of_gpio_chip stuff.

Having two ways to store gpio_chip isn't good, that's why
I stated that the first option will have to go, i.e. I'm going to
convert arch/powerpc/sysdev/qe_lib/gpio.c and few other of_mm
gpio chips to the new registration scheme soon.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
