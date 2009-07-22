Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbZGVM7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbZGVM7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 08:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbZGVM7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 08:59:05 -0400
Received: from www.tglx.de ([62.245.132.106]:58583 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683AbZGVM7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 08:59:01 -0400
Date: Wed, 22 Jul 2009 14:58:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
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
In-Reply-To: <20090722121800.GD21171@rakim.wolfsonmicro.main>
Message-ID: <alpine.LFD.2.00.0907221427380.2813@localhost.localdomain>
References: <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com> <20090721105924.GK4133@elf.ucw.cz> <20090721113642.GC13286@sirena.org.uk> <5d5443650907210518i6ee4df1evdc04d9ae9453707c@mail.gmail.com> <5d5443650907210530x4aaa03d6gd47ef5f79a3ef8a4@mail.gmail.com>
 <20090721124933.GA5668@rakim.wolfsonmicro.main> <20090721160436.GD4352@dtor-d630.eng.vmware.com> <alpine.LFD.2.00.0907212225030.2813@localhost.localdomain> <20090721222547.GA1948@opensource.wolfsonmicro.com> <alpine.LFD.2.00.0907221022190.2813@localhost.localdomain>
 <20090722121800.GD21171@rakim.wolfsonmicro.main>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Wed, 22 Jul 2009, Mark Brown wrote:

> On Wed, Jul 22, 2009 at 12:44:01PM +0200, Thomas Gleixner wrote:
> > On Tue, 21 Jul 2009, Mark Brown wrote:
> 
> > > I'll need to have a more detailed look at that but it's not immediately
> > > clear to me how a driver (or even machine) should use that code - it
> > > looks more like it's intended to be called from within the IRQ
> > > infrastructure than from random driver code.
> 
> > All it needs is to set handle_level_oneshot_irq for the interrupt line
> > of your I2C or whatever devices. 
> 
> >    set_irq_handler(irq, handle_level_oneshot_irq);
> 
> Yeah, I know - the issue I was having was that the use of set_irq_handler()
> seemed rather rude for driver code.  Grepping around I see that there
> are actually a small number of drivers using it already but at first
> glance most of them appear to be implementing interrupt controllers.  It
> was setting off alarm bells about abstraction layer violation like
> set_irq_type() does.

I don't think it belongs into the driver code. It belongs into the
platform code which sets up the system and knows what's on which
interrupt line.
 
> > > Nothing if the above works, though I guess more documentation wouldn't
> > > hurt (and possibly a more friendly wrapper).  From the name and
> 
> > Wrapper for what ? 
> 
> Something to package up the set_irq_handler() and request_threaded_irq()
> (possibly a flag for request_threaded_irq()).  This is such a common
> thing and request_threaded_irq() looks so much like it should Just Work
> that I'd expect it'll help usability a lot to have a single function
> which says "this is the idiomatic way to implement this".

Yeah, we might do with a flag, but I'd prefer that the platform code
aka arch/xxx/yourmachine/setup.c does this. That's the canonical place.

> > After that bus_sync_unlock() is called outside the atomic context. Now
> > the chip implementation issues the bus commands, waits for completion
> > and unlocks the interrupt controller bus.
> 
> I'll try to find time to implement some use of it and give it a spin -
> it looks good at first glance but I'll need to convert one of my drivers
> to genirq in order to test.  Someone working on a chip that already uses
> genirq might get there first.

That'd be great to get some feedback. Both patches need some more
thought, but I think they are a good start to do some testing. One
thing which I definitely want to change is the thread_eoi function. We
probably want to have it customizable for the following reason:

main interrupt
     hardirq handler wakes main thread handler

main thread handler
    bus magic
   	subdevice1 "hardirq" handler wakes subdevice1 irq thread
   	subdevice2 "hardirq" handler wakes subdevice2 irq thread
    main thread handler waits for subdevice1/2 handlers to complete

subdevice1 thread handler
    bus magic
    ....
    thread_fn returns
    signal main thread handler via completion

subdevice2 thread handler
    bus magic
    ....
    thread_fn returns
    signal main thread handler via completion

main thread handler resumes
    bus magic
    main thread handler returns from thread_fn
    unmask main interrupt

So the thread_eoi function is useful for both the main and the
subdevice handlers. The main handler probably just issues the unmask
while the subdevice handlers probably want to call a completion to
notify the main thread handler that they are done. That would be a
fairly proper design I think and would encourage driver writers to
follow the common scheme instead of doing their own black magic.

Thinking further we should even provide some infrastructure for that
in the common code which would handle the completion and attach it to
the interrupts in question, so the driver authors would not have to
deal with that at all. They just would return from thread_fn and let
the generic code deal with the notification. The notification has to
be set up by the interrupt controller code. That way you can use the
same device driver code w/o knowledge of the interrupt controller
implementation it is attached to.

Thoughts ?

Thanks,

	tglx
