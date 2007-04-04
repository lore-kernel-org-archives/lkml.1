Return-Path: <linux-kernel-owner+w=401wt.eu-S2992985AbXDDQG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992985AbXDDQG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992986AbXDDQG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:06:57 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3508 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992985AbXDDQGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:06:54 -0400
Date: Wed, 4 Apr 2007 17:06:40 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Paul Mackerras <paulus@samba.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, dwmw2@infradead.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070404160640.GA18990@flint.arm.linux.org.uk>
Mail-Followup-To: Paul Mackerras <paulus@samba.org>,
	David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
	linuxppc-dev@ozlabs.org, dwmw2@infradead.org,
	alan@lxorguk.ukuu.org.uk
References: <17938.57292.870224.132415@cargo.ozlabs.ibm.com> <20070403.165518.55726194.davem@davemloft.net> <20070404021924.71e87580@the-village.bc.nu> <20070403.182125.77058566.davem@davemloft.net> <20070404074736.GA3440@flint.arm.linux.org.uk> <17939.30226.339390.709561@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17939.30226.339390.709561@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 07:55:30PM +1000, Paul Mackerras wrote:
> Russell King writes:
> > FACT: there is no way to know at any particular driver registration time
> >  how many "generic" serial ports will be available - as required for the
> >  chardev and tty layers.
> 
> I think the thing that davem and I have in common is that we have a
> data structure that the firmware gives us that (at least) enumerates
> all of the on-board serial ports for us, thus we *can* know very early
> in the boot process how many "generic" serial ports will be available.

Goodo.  However, that's not the case elsewhere, and the lack of that
information makes it *extremely* hard to provide any generic solution,
especially with a driver as ubiquous as the 8250 driver.

How do I know how many serial ports are connected to an ARM device?
What about that expansion pack I might decide to slip onto the back of
my ARM PDA which wasn't known about when the device was first booted
some years ago?

> > There are very real issues that need fixing deep within the kernel
> > before you can even think about the possibility of *PROPERLY* supporting
> > all serial ports beneath one namespace.
> 
> I don't actually want to do that; I'm perfectly happy for various
> kinds of plug-in cards to each have their own namespace.  If you're
> plugging in a Cyclades card for instance I think it's quite reasonable
> for the ports to be named /dev/ttyCn.

Well, Cyclades is irrelevant in this discussion because it has nothing
to do with serial_core, and therefore nothing to do with the 8250 driver,
and, therefore, nothing to do with the problem of the major 4 / ttyS
namespace.  Ergo, it's utterly irrelevant to even mention it.

> It's the built-in serial ports on the motherboard where I think the
> user should not have to know what sort of chip was used to implement
> the serial port.  We don't require users to know whether the
> manufacturer used an 8250 or a 16450 or a 16550, so why should it
> matter if the manufacturer used an 8530?

I'm going to answer this *technically*.  It's the *technicalities* that
are causing this restriction.  Solve those technicalities and the problem
goes away.

We don't require users to know if it's an 8250, 16450, 16550 because
they're all compatible with the previous models, and therefore
*technically* it makes sense for them to be driven by the same driver.

However, an 8530 isn't compatible with an 8250 and requires a separate
driver.

The restriction on serial namespace isn't *hardware* based, it's *driver*
based, and that restriction comes from the way the tty and chardev
subsystems work.  When you register a tty driver, you need to tell the
tty subsystem how many ttys that driver will *ever* support.  The only
way to change that number is to unregister all ttys connected with the
driver, unregister the driver, change the number, reallocate arrays,
re-register the driver, and re-register the ttys.

If any one of those ttys is in use, there's a problem - you have to
hangup that user and have them close/reopen the tty.  That's fairly
disruptive, especially if it happens to be a modem that some user has
dialed in from (you end up logging them out of the system every time
you need to increase the number of serial ttys).

So, you see, this is a big problem that needs *technically*
resolving *with* *patches* before we can think about having a single
serial namespace.

> BTW, are you still maintaining the serial layer?

That's irrelevant to the discussion at hand.  For the record, because
others have different opinions to me, and persisted in trying to tell
me what I should be doing without providing patches, I stepped back
from the maintainership role, and have only been reviewing the odd
patch as I see fit.

Maybe it'll be different this time around, but so far all I've seen in
this thread is lots of people providing opinions and very little code
to achieve their aims.  Or even technical *discussion* about how to go
about implementing those opinions.

Therefore, I put it to those arguing for a single serial major that the
reason it hasn't happened is that no one is *really* that bothered about
it to solve the underlying issues.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
