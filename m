Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab0BOU73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 15:59:29 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:55080 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756549Ab0BOU71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 15:59:27 -0500
Date: Mon, 15 Feb 2010 23:59:24 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, Michal Simek <monstr@monstr.eu>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH 3/3] of/gpio: Introduce of_put_gpio(), add ref counting
 for OF GPIO chips
Message-ID: <20100215205924.GA23654@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20100205204949.GA2575@oksana.dev.rtsoft.ru>
 <20100205205045.GC4178@oksana.dev.rtsoft.ru>
 <fa686aa41002090928o6911d095ydca1e1e670a0fc22@mail.gmail.com>
 <20100209191427.GA18263@oksana.dev.rtsoft.ru>
 <fa686aa41002151149u158bc2fbn5af16f6bd714d36c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fa686aa41002151149u158bc2fbn5af16f6bd714d36c@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 12:49:56PM -0700, Grant Likely wrote:
[...]
> Okay, I'm convinced now.  The model is wrong.  struct of_gc does need
> to be a member of struct gpio_chip and conditionally compiled against
> CONFIG_OF_GPIO.  This locking requirement is just too plain ugly,

And how would you implement of_get_gpio(np, index) then?
You don't have 'struct gpio_chip' in of_get_gpio(), so you can't
get of_gc out of it.

It's possible to lookup all GPIOs (gpio[0..ARCH_NR_GPIOS]) matching
on chip->dev->archdata.node == np, but you're just moving this stuff
into gpiolib, where you'll have to grab global gpio_lock instead of
devtree lock. And just as with np->data_lock or global devtree lock,
you'll have to grab gpio_lock in of_gpio_put(), of_gpio_chip_register
and of_gpio_chip_unregister().

See? Your suggestion doesn't make things better or simpler, instead
it turns the OF GPIO inside out, exposing arch details to the generic
code.

There is really no excuse for the arch-specific (OF) stuff being in
the generic code. Not in the irq subsystem, not in the gpio
subsystem. My implementation actually proves that.

> and
> dereferencing the np->data pointer in this way is dangerous
> (what if
> something that is not struct of_gc is stored there).

Not possible with the safe np->data accessors.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
