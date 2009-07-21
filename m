Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbZGUWZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbZGUWZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 18:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756422AbZGUWZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 18:25:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58275 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754609AbZGUWZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 18:25:49 -0400
Date: Tue, 21 Jul 2009 23:25:48 +0100
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
Message-ID: <20090721222547.GA1948@opensource.wolfsonmicro.com>
References: <5d5443650907140320w334864f4uc1ee13ed32fdb874@mail.gmail.com> <20090715133627.GA2538@elf.ucw.cz> <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com> <20090721105924.GK4133@elf.ucw.cz> <20090721113642.GC13286@sirena.org.uk> <5d5443650907210518i6ee4df1evdc04d9ae9453707c@mail.gmail.com> <5d5443650907210530x4aaa03d6gd47ef5f79a3ef8a4@mail.gmail.com> <20090721124933.GA5668@rakim.wolfsonmicro.main> <20090721160436.GD4352@dtor-d630.eng.vmware.com> <alpine.LFD.2.00.0907212225030.2813@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0907212225030.2813@localhost.localdomain>
X-Cookie: Q: Are we not men?
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 10:30:26PM +0200, Thomas Gleixner wrote:
> On Tue, 21 Jul 2009, Dmitry Torokhov wrote:
> > On Tue, Jul 21, 2009 at 01:49:33PM +0100, Mark Brown wrote:

> > >  - Ordinary devices on interrupt driven or slow buses like I2C.  These
> > >    need something along the lines of request_threaded_irq() that's allows
> > >    them to schedule the main IRQ handler outside hardirq context so
> > >    that they can interact with the device.  They need to do something in

> There is already a sane solution to the problem:

>       See http://lkml.org/lkml/2009/7/17/174 

I'll need to have a more detailed look at that but it's not immediately
clear to me how a driver (or even machine) should use that code - it
looks more like it's intended to be called from within the IRQ
infrastructure than from random driver code.

> > >    My immediate thought when I noticed this was that we should probably
> > >    fix request_threaded_irq() so that it's useful for them; I'd been
> > >    intending to do some digging and try to understand why it is
> > >    currently implemented as it is.

> What's to fix there ? 

Nothing if the above works, though I guess more documentation wouldn't
hurt (and possibly a more friendly wrapper).  From the name and
documentation request_threaded_irq() looks like it should be exactly
what's needed.

> > >  - Multi-function devices like the twl4030 which have an interrupt
> > >    controller on them and would like to expose that interrupt controller
> > >    via the generic IRQ subsystem.  This was a large part of the
> > >    discussion in the thread above is a much trickier problem.

> Why ?

Partly just because it's idiomatic for the devices - these things are
from a software point of view essentially a small stack of devices glued
together and one of the devices on them is an interrupt controller so
the natural thing is to want to represent that interrupt controller in
the way Linux normally represents interrupt controllers and be able to
reuse all the core code rather than having to implement a clone of it.

The other part of it is that it gets you all the interfaces for
interrupts that the rest of the kernel expects which is needed when the
device interacts with others.  The biggest issue here is that these
devices often have GPIOs on them (especially PMICs and audio CODECs).
These have all the facilities one expects of GPIOs, including being used
as interrupt sources.  If we need to use chip-specific APIs to interact
with the interrupts they raise then the drivers for anything using them
need to know about those APIs and have special cases to work with them
which obviously doesn't scale.

> > >From my part I would like to have the threaded IRQ available to all
> > drivers since it seens to be hanlding driver shutdown cleanly and
> > without races which is a big plus for me since very few drivers get it
> > right.

> :)

It's also wasteful having to write the code in every single driver that
needs to handle interrupts on interrupt driven buses.
