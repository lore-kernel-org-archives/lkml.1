Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbYDITGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbYDITGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 15:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbYDITGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 15:06:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55505 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245AbYDITGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 15:06:10 -0400
Date: Wed, 9 Apr 2008 20:05:04 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Dmitry <dbaryshkov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       haavard.skinnemoen@atmel.com, lethal@linux-sh.org,
       philipp.zabel@gmail.com, pavel@ucw.cz, tony@atomide.com, paul@pwsan.com
Subject: Re: [PATCH 5/6] Clocklib: Use correct clock for IrDA on pxa
Message-ID: <20080409190504.GA13891@flint.arm.linux.org.uk>
References: <20080403132142.GA26882@doriath.ww600.siemens.net> <20080403132402.GA27008@doriath.ww600.siemens.net> <20080407160029.f1f9ce4f.akpm@linux-foundation.org> <20080407230434.GA525@flint.arm.linux.org.uk> <bc64b4640804080247s82ba84chd740c08b2fbb9b1a@mail.gmail.com> <20080408193309.GA18053@flint.arm.linux.org.uk> <bc64b4640804090015m7dd640d5j31c54b99007f09a7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc64b4640804090015m7dd640d5j31c54b99007f09a7@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 11:15:51AM +0400, Dmitry wrote:
> 2008/4/8, Russell King <rmk+lkml@arm.linux.org.uk>:
> > On Tue, Apr 08, 2008 at 01:47:35PM +0400, Dmitry wrote:
> >  > Yes, it works currently. But there are a few problems: we declare
> >  > STUART's UARTCLK with dev=NULL (all other UARTCLKs are declared with
> >  > proper devices).  Therefore,  I consider it as a hack and would like
> >  > to remove it.
> >
> > I don't consider it a hack at all - it's a work around for the fact
> >  that the PXA FIR driver shares the UART, but the FIR driver doesn't
> >  bind to the UART itself.
> 
> Would you then accept the patch that still contains UARTCLK bound to
> pxa uart device, and IrDA requesting clock STUARTCLK?

See below - fixing the underlying issue makes this problem vanish.

> >  The _real_ issue is with IrDA itself, and is larger than just the
> >  clock library.  Any serial port which supports IrDA, even on x86,
> >  has to be shared between the serial driver and the IrDA driver -
> >  there's no way for them to quietly co-exist and "just work" as
> >  requested.
> 
> Yes. I wonder how this is solved in other platforms.

As I've suggested, it isn't.  On x86, for instance, you have to use
setserial to deconfigure the serial port from the serial driver (by
setserial /dev/ttyS1 uart none) and then load the IrDA driver.

Unfortunately, there's currently no way to properly hand off a real
serial device to the IrDA layer when the UART is connected to an IrDA
interface.

TBH, I'm not sure what the status of the kernel-side IrDA drivers are -
maybe this is an issue which Samuel Ortiz could tackle if he has time.
That would solve this issue on both 8250-based ports as well as SA11x0
and PXA platforms.

Basically what I'm thinking is a serial_core function which could be
called to say "I'm an IrDA driver, and I think I should be using the
serial port located <here>, please give me control of it" and it'd
pass over the various parameters including the struct device for it.
Or something like that.

> See my proposition above. I highly dislike the UARTCLK w/o device declared.
> Once it has already lead me to (small) problems due to messed other
> UARTCLKs  declarations on pxa25x.

If we get the underlying issue fixed, that issue magically goes away.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
