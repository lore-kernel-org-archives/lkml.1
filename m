Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbYDIVhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbYDIVhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 17:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbYDIVhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 17:37:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49521 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbYDIVhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 17:37:46 -0400
Date: Wed, 9 Apr 2008 22:37:09 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dmitry <dbaryshkov@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com,
       lethal@linux-sh.org, philipp.zabel@gmail.com, pavel@ucw.cz,
       tony@atomide.com, paul@pwsan.com
Subject: Re: [PATCH 5/6] Clocklib: Use correct clock for IrDA on pxa
Message-ID: <20080409213709.GC31386@flint.arm.linux.org.uk>
References: <20080403132402.GA27008@doriath.ww600.siemens.net> <20080407160029.f1f9ce4f.akpm@linux-foundation.org> <20080407230434.GA525@flint.arm.linux.org.uk> <bc64b4640804080247s82ba84chd740c08b2fbb9b1a@mail.gmail.com> <20080408193309.GA18053@flint.arm.linux.org.uk> <bc64b4640804090015m7dd640d5j31c54b99007f09a7@mail.gmail.com> <20080409190504.GA13891@flint.arm.linux.org.uk> <20080409200916.78615f39@core> <20080409192009.GB13891@flint.arm.linux.org.uk> <20080409215233.1a1c0002@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409215233.1a1c0002@core>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 09:52:33PM +0100, Alan Cox wrote:
> > > It's called a line discipline, we've had them for many years. We may need
> > > a way for ldiscs and drivers to co-operate a bit more but these days we
> > > support proper buffering and arbitary baud rates (except on a few
> > > platforms whose maintainers are not paying attention ;)).
> > 
> > I feel that's a "it would be nice if" solution - and something worth
> > aiming for, but the amount of work required to get there is not going
> > to be insignificant.
> 
> The work required to fix up the existing FIR hacks is not insignifcant
> either. Also right now the tty layer is getting a major rework so now is
> actually the time to sort out anything extra that is needed.
> 
> If you want 4MBit please just use an ldisc and do
> 
> 	struct ktermios tmp;
> 	mutex_lock(&tty->termios_mutex);
> 	tmp = *tty->termios;
> 	tty_encode_baud_rate(tty, 4000000, 4000000);
> 	tty->driver->set_termios(tty, &tmp);
> 	mutex_unlock(&tty->termios_mutex);

There's more to FIR than just a baud rate change.  On PXA for instance,
SIR is implemented using the standard UART device in "SIR" mode, but FIR
is a completely separate hardware block with its own IRQs and clocks -
you need to switch the pin muxing from the UART to the FIR device.

So it's not just a matter of setting the baud rate to 4Mbps.

However, you can't just say "have two separate drivers and only use
one or the other" - all IrDA link negotiation is done at SIR at 9600
baud and only when negotiation is complete will the selected rate
become effective - be that SIR or FIR based.

So yes, using a ldisc for SIR (with a hook into the driver to tell the
driver to setup the port for IR) sounds ideal, but we're still going to
need to deal with the FIR device and switch IrDA between that and the
SIR UART ldisc.

Note - there are other reasons for finally sorting this out as well -
there are systems with IR which want to support both IrDA up to FIR
and other uart-based IR applications.  IIRC this came up on the iPAQs.
I forget exactly which applications but I believe lirc might fall into
the "want a serial port not the FIR network device interface" class.
Having SIR always go via ldiscs should sort that out nicely as well.
(I'm thinking maybe we want some control to set a port into IR
transmission/reception mode independent of selecting the IrDA ldisc -
but I'd suggest further research first - I may be just handwaving
about an already solved problem.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
