Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbZGVNbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbZGVNbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbZGVNbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:31:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45183 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753015AbZGVNbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:31:33 -0400
Date: Wed, 22 Jul 2009 14:31:31 +0100
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
Message-ID: <20090722133131.GA28355@rakim.wolfsonmicro.main>
References: <20090721113642.GC13286@sirena.org.uk>
 <5d5443650907210518i6ee4df1evdc04d9ae9453707c@mail.gmail.com>
 <5d5443650907210530x4aaa03d6gd47ef5f79a3ef8a4@mail.gmail.com>
 <20090721124933.GA5668@rakim.wolfsonmicro.main>
 <20090721160436.GD4352@dtor-d630.eng.vmware.com>
 <alpine.LFD.2.00.0907212225030.2813@localhost.localdomain>
 <20090721222547.GA1948@opensource.wolfsonmicro.com>
 <alpine.LFD.2.00.0907221022190.2813@localhost.localdomain>
 <20090722121800.GD21171@rakim.wolfsonmicro.main>
 <alpine.LFD.2.00.0907221427380.2813@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0907221427380.2813@localhost.localdomain>
X-Cookie: Biggest security gap -- an open mouth.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 02:58:24PM +0200, Thomas Gleixner wrote:
> On Wed, 22 Jul 2009, Mark Brown wrote:
> > On Wed, Jul 22, 2009 at 12:44:01PM +0200, Thomas Gleixner wrote:

> > >    set_irq_handler(irq, handle_level_oneshot_irq);

> > Yeah, I know - the issue I was having was that the use of set_irq_handler()
> > seemed rather rude for driver code.  Grepping around I see that there

> I don't think it belongs into the driver code. It belongs into the
> platform code which sets up the system and knows what's on which
> interrupt line.

Yeah, that is doable - but it'd be good for usability if it could be
handled transparently by the driver.  Even in board code it's fairly
rare to need to explicitly set the handler if you're not actually
implementing an interrupt controller.  Most of the board-specific code
doing this is doing so for a CPLD, FPGA or similar on the board rather
than configuring a preexisting IRQ for use by a leaf device.

Half the trouble is that if you're not implementing interrupt controller
code then calling set_irq_*() is normally a sign that you're doing
something wrong (for example, for set_irq_type() you should be using
flags on request_irq()).

> Thinking further we should even provide some infrastructure for that
> in the common code which would handle the completion and attach it to
> the interrupts in question, so the driver authors would not have to
> deal with that at all. They just would return from thread_fn and let
> the generic code deal with the notification. The notification has to
> be set up by the interrupt controller code. That way you can use the
> same device driver code w/o knowledge of the interrupt controller
> implementation it is attached to.

Yes, I think that'll be required for users like gpiolib.  If someone's
done something like have a button implemented by attaching switch to a
GPIO input on for something like jack detect on an audio CODEC or a wake
source for a PMIC then we've got generic code that expects to just take
a gpio/irq and interact with it.
