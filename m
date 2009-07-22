Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbZGVMSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbZGVMSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 08:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbZGVMSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 08:18:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48453 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751040AbZGVMSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 08:18:03 -0400
Date: Wed, 22 Jul 2009 13:18:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Daniel Ribeiro <drwyrm@gmail.com>
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
Message-ID: <20090722121800.GD21171@rakim.wolfsonmicro.main>
References: <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com>
 <20090721105924.GK4133@elf.ucw.cz>
 <20090721113642.GC13286@sirena.org.uk>
 <5d5443650907210518i6ee4df1evdc04d9ae9453707c@mail.gmail.com>
 <5d5443650907210530x4aaa03d6gd47ef5f79a3ef8a4@mail.gmail.com>
 <20090721124933.GA5668@rakim.wolfsonmicro.main>
 <20090721160436.GD4352@dtor-d630.eng.vmware.com>
 <alpine.LFD.2.00.0907212225030.2813@localhost.localdomain>
 <20090721222547.GA1948@opensource.wolfsonmicro.com>
 <alpine.LFD.2.00.0907221022190.2813@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0907221022190.2813@localhost.localdomain>
X-Cookie: Biology grows on you.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 12:44:01PM +0200, Thomas Gleixner wrote:
> On Tue, 21 Jul 2009, Mark Brown wrote:

> > I'll need to have a more detailed look at that but it's not immediately
> > clear to me how a driver (or even machine) should use that code - it
> > looks more like it's intended to be called from within the IRQ
> > infrastructure than from random driver code.

> All it needs is to set handle_level_oneshot_irq for the interrupt line
> of your I2C or whatever devices. 

>    set_irq_handler(irq, handle_level_oneshot_irq);

Yeah, I know - the issue I was having was that the use of set_irq_handler()
seemed rather rude for driver code.  Grepping around I see that there
are actually a small number of drivers using it already but at first
glance most of them appear to be implementing interrupt controllers.  It
was setting off alarm bells about abstraction layer violation like
set_irq_type() does.

> > Nothing if the above works, though I guess more documentation wouldn't
> > hurt (and possibly a more friendly wrapper).  From the name and

> Wrapper for what ? 

Something to package up the set_irq_handler() and request_threaded_irq()
(possibly a flag for request_threaded_irq()).  This is such a common
thing and request_threaded_irq() looks so much like it should Just Work
that I'd expect it'll help usability a lot to have a single function
which says "this is the idiomatic way to implement this".

> The irq thread finds out which interrupt(s) are active in the
> device. So it raises the interrupt handlers for those from the thread
> which will wake up the relevant interrupt threads for those
> devices. Once all the thread handlers have finished you return from
> the main thread and the interrupt line gets unmasked again.

Yes, this bit of it isn't too much of a problem, it's what's going on in
all the non-genirq infrastructures, but...

> The driver which controls the interrupt device has to expose the
> demultiplexed interrupts via its own irq_chip implementation. Of
> course the chip functions like mask/ack/unmask cannot run in atomic
> context as they require bus access again.

...as you say this is the tricky bit.

> Here in deed we need to put some thought into common infrastructure
> as it seems that such excellent hardware designs are becoming more
> popular :(

This isn't a new issue - it's more that you're seeing a greater degree
of mainline activity from embedded systems.  

FWIW the hardware tradeoff here is in a large part down to the fact that
many of these devices are heavily size (and therefore pin count)
constrained, often on both the device and CPU end of things.  Adding
more pins would either mean a bigger device or a device that's more
expensive to manufacture and use.  This pushes to minimal wire, low
speed control interfaces and for the sort of low volume control these
things need there's not much operational problem there.  These things
are *normally* either pushing events that either won't happen very often
(eg, RTC alarm expiry) or shouldn't happen at all (eg, power failures)
and so aren't performance critical.

> After that bus_sync_unlock() is called outside the atomic context. Now
> the chip implementation issues the bus commands, waits for completion
> and unlocks the interrupt controller bus.

I'll try to find time to implement some use of it and give it a spin -
it looks good at first glance but I'll need to convert one of my drivers
to genirq in order to test.  Someone working on a chip that already uses
genirq might get there first.
