Return-Path: <linux-kernel-owner+w=401wt.eu-S1760808AbZE1JWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808AbZE1JWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 05:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZE1JWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 05:22:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53529 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbZE1JV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 05:21:59 -0400
Date: Thu, 28 May 2009 10:15:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Scott Wood <scottwood@freescale.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090528091513.GA14789@n2100.arm.linux.org.uk>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> <1243496236.3171.140.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243496236.3171.140.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 05:37:16PM +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2009-05-27 at 18:56 +0100, Russell King wrote:
> > 
> > smc91x is a prime example of the kind of information drivers need - base
> > address and irq are very much insufficient to describe how this device is
> > connected.  There's much more information required to specify this device
> > fully, and throwing it into the driver doesn't work.  We've been there
> > and proven that point.
> 
> The device-tree is a very nice and convenient way to convey all the
> informations the driver need straight to the driver without any platform
> code in the middle :-)

I'm still uncertain whether that's actually a true statement.  For some
cases, of course it's true, but I have a nasty suspicion that we have
corner cases where OF won't cope well with.

As I see it, if we were to convert to OF, we're boxing ourselves in to
a corner that would be extremely difficult to get out of.  We would
never be able to step back from OF.  Lets take an example.  If we were
to convert PXA to OF including all the PXA SoC drivers, and a board
configuration came along which required hacks to a driver.  Later on
we find that most platform authors are applying similar hacks because
their hardware is subtly different but those differences can't be
expressed via OF.  At this point, what do we do?  We can't say "well,
OF doesn't work well on this platform, we want to get rid of it" that
would be extremely difficult to impossible to do.


For example, how would an IrDA transceiver be expressed in OF?

Obviously it would have to start off with some sort of UART definition
for SIR, with a separate (and sometimes unrelated in terms of register
space and SoC pin configuration) FIR unit.  Whether FIR is used or not
is platform specific.  So far so good, I don't see a problem yet.

We then have one or two GPIOs doing some function - eg, one GPIO might
be a simple power on/off while the other controls FIR or SIR mode in
the transceiver itself.  Or the two lines might be a bit combination
which selects 'off', 'on + sir', 'on + fir' modes depending on the
transceiver used.  In the case of one GPIO it might be the mode select
or it might be the power control.

I suspect this can be expressed by having some sort of OF table specifying
several gpios & their value for each combination of power & mode...
except some platforms have special control registers in FPGAs which do
not appear as GPIOs... so how are those expressed?  We have function
pointers back into platform code to cope with this at present.


Another example - LCD displays.  Some platforms need a certain sequence
of GPIO activations with delays between when powering up and down the
LCD display.  Currently we express this in the platform support file and
pass a function pointer into the LCD Driver.  Can this be expressed with
OF?


Another example - backlights.  Some platforms need to twiddle a GPIO
at a certain point in the brightness scale and reset the PWM, and they
currently do this via an (optional) function pointer in the generic PWM
backlight driver.  Can this be expressed with OF?


That's just a few examples of areas where we haven't been able to describe
platforms using pure data-based descriptions, and they're all things that
we don't want to stuff into the individual drivers (doing so involves lots
of ifdefs and namespace pollution - we saw that in 2.4 kernels.)

In order for me to be convinced that OF is not going to cause us grief,
I'd like to see a range of platforms converted to OF to check that we're
not going to find any unexpected problems - eg, a load of PXA platforms,
particularly those with the above kinds of problems.

And no, Dave Miller saying "I've been using this for 15 years on Sparc"
"Three architectures are using it" isn't going to convince me.  The proof
is in the code, not the waffle.
