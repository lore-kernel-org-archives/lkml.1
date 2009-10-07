Return-Path: <linux-kernel-owner+w=401wt.eu-S933309AbZJGNER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933309AbZJGNER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933112AbZJGNER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:04:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48514 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933097AbZJGNEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:04:15 -0400
Date: Wed, 7 Oct 2009 14:03:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: Mike Frysinger <vapier@gentoo.org>, Samuel Ortiz <sameo@linux.intel.com>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH v3] mfd: ADP5520 Multifunction LCD Backlight and
 KeypadInput Device Driver
Message-ID: <20091007130337.GA18135@rakim.wolfsonmicro.main>
References: <20091006123658.GA31079@rakim.wolfsonmicro.main>
 <8A42379416420646B9BFAC9682273B6D0E3F4420@limkexm3.ad.analog.com>
 <20091006135836.GA3926@rakim.wolfsonmicro.main>
 <8A42379416420646B9BFAC9682273B6D0E3F46A7@limkexm3.ad.analog.com>
 <20091006144805.GA10987@rakim.wolfsonmicro.main>
 <8A42379416420646B9BFAC9682273B6D0E3F4769@limkexm3.ad.analog.com>
 <20091006160549.GA8881@rakim.wolfsonmicro.main>
 <8A42379416420646B9BFAC9682273B6D0E3F4CEE@limkexm3.ad.analog.com>
 <20091007100638.GB3169@rakim.wolfsonmicro.main>
 <8A42379416420646B9BFAC9682273B6D0E442F71@limkexm3.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A42379416420646B9BFAC9682273B6D0E442F71@limkexm3.ad.analog.com>
X-Cookie: I smell a wumpus.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 01:11:40PM +0100, Hennerich, Michael wrote:

> In case I would have done the whole ADP5520 in a single file exposing
> functionality to the input, backlight, led and gpio infrastructure - I
> probably wouldn't find a subtree maintainer that is likely to merge this
> blob.

Why do you say this?

> But apart from the GPIO interrupt capabilities - I wouldn't need doing
> an interrupt controller.
> I think you agree.

I'm not sure I do, TBH - if there's more than one

> So this notifier chain seemed like a good approach to notifiy the
> input/keypad/adp5520-keys about some work. BTW - this approach is used
> by other drivers for exactly the same reason too.

The only ones using the specific approach are da903x and ab3100, both of
which predate the availability of the genirq improvements.

> Honestly - I'm not yet convinced that this new irq stuff really works in
> combination with my ADP5520 Low Level IRQ. 
> My chained_handler (for demux) as well as irq_desc .mask .unmask .ack
> and .set_type need to also be allowed to invoke sleeping i2c
> transfers!!!?

You don't need to use chained_handler explicitly.  You can just use a
regular threaded IRQ handler for the primary IRQ, register an IRQ chip
for the IRQs it provides then call handle_nested_irq() from within the
primary IRQ handler.  The chaining is only needed if running in hard
IRQ context.

The bus_lock stuff is there so that mask, unmask and ack don't need to
do I2C interactions.  The idea is that you update local variables in
those and then when sync_unlock() is called you write out all the
changes to the device.  The framework is set up to cope with this.

> I should do following: (unfortunately this is all on the bleeding edge
> of technology, with no example driver actually using this craft)

I have a patch for wm831x which does the switchover to the new model - I
hope to be able to publish it very soon, I did some blind changes that I
need to test.  I'll include you in the CCs when I post it.

> >I think I forgot to mention it previously but there's some work on >
>getting a standard ALS interface in the kernel too.  I'd really expect
> >the GPIOs to end up being used as GPIOs in some designs as well.

> This is really interesting. Do you know where this discussion
currently > takes place, and who is taking the lead (came up with a
proposal)?

Not precisely, though there's an active thread 'New home for DS1682
driver' on the I2C list with some mutterings about it - it should at
least give some pointers for further archive trawling.
