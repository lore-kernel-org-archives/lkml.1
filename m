Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbXKNMOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbXKNMOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 07:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbXKNMOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 07:14:34 -0500
Received: from www.tglx.de ([62.245.132.106]:59992 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbXKNMOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 07:14:33 -0500
Date: Wed, 14 Nov 2007 13:14:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Brownell <david-b@pacbell.net>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
In-Reply-To: <200711121726.39263.david-b@pacbell.net>
Message-ID: <alpine.LFD.0.9999.0711141228210.3265@localhost.localdomain>
References: <200711091136.20051.david-b@pacbell.net> <200711121432.54307.david-b@pacbell.net> <20071112152857.a60643b0.akpm@linux-foundation.org> <200711121726.39263.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2007, David Brownell wrote:
> > I'm still trying to understand what you've observed here.  Is it the case
> > that a single gpio operation went from 6.4 up to 11.2 usecs?
> 
> That was a single bitbanged I2C bit transfer, with embedded udelay()s.
> I believe that was four gpio operations, as summarized at the end of
> that email above.  Enabling preempt + debug increased the cost of
> each GPIO call from whatever it was (reasonable) by 1.2 usecs.

This raw lock change is just pampering over the design problem of the
gpio lib:

There is no need to check for every single access to a GPIO pin,
whether the pin has a valid number and the chip, which provides access
to the pin, is still registered.

Each driver, which wants to access a pin, needs to make sure that

- the pin is available
- the pin is associated to this driver
- the chip reference count is incremented

_before_ it starts to do anything with the pin. Once this is done the
access to the pin is completely lock free except for the protection of
the chip hardware itself.

What you really need is a different API to request and free the access
to a particular pin like:

struct gpio_desc {
       struct gpio_chip *chip;
       int pinoffset;
};

int gpio_request_pin(int nr, struct gpio_desc *desc);
void gpio_release_pin(struct gpio_desc *desc);

where the description structure is caller provided to avoid static
allocation overhead for a large number of unused gpios.

The modification functions just use the description to access the pin
instead of the number and the per access lookup/locking.

The protection of the chip list can be converted to a mutex and
does not need to be a spinlock at all.

Thanks,

	tglx
