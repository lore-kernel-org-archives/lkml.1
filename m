Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbZGVKph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbZGVKph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 06:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbZGVKpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 06:45:35 -0400
Received: from www.tglx.de ([62.245.132.106]:48533 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbZGVKpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 06:45:31 -0400
Date: Wed, 22 Jul 2009 12:44:01 +0200 (CEST)
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
In-Reply-To: <20090721222547.GA1948@opensource.wolfsonmicro.com>
Message-ID: <alpine.LFD.2.00.0907221022190.2813@localhost.localdomain>
References: <5d5443650907140320w334864f4uc1ee13ed32fdb874@mail.gmail.com> <20090715133627.GA2538@elf.ucw.cz> <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com> <20090721105924.GK4133@elf.ucw.cz> <20090721113642.GC13286@sirena.org.uk>
 <5d5443650907210518i6ee4df1evdc04d9ae9453707c@mail.gmail.com> <5d5443650907210530x4aaa03d6gd47ef5f79a3ef8a4@mail.gmail.com> <20090721124933.GA5668@rakim.wolfsonmicro.main> <20090721160436.GD4352@dtor-d630.eng.vmware.com> <alpine.LFD.2.00.0907212225030.2813@localhost.localdomain>
 <20090721222547.GA1948@opensource.wolfsonmicro.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009, Mark Brown wrote:

> On Tue, Jul 21, 2009 at 10:30:26PM +0200, Thomas Gleixner wrote:
> > On Tue, 21 Jul 2009, Dmitry Torokhov wrote:
> > > On Tue, Jul 21, 2009 at 01:49:33PM +0100, Mark Brown wrote:
> 
> > > >  - Ordinary devices on interrupt driven or slow buses like I2C.  These
> > > >    need something along the lines of request_threaded_irq() that's allows
> > > >    them to schedule the main IRQ handler outside hardirq context so
> > > >    that they can interact with the device.  They need to do something in
> 
> > There is already a sane solution to the problem:
> 
> >       See http://lkml.org/lkml/2009/7/17/174 
> 
> I'll need to have a more detailed look at that but it's not immediately
> clear to me how a driver (or even machine) should use that code - it
> looks more like it's intended to be called from within the IRQ
> infrastructure than from random driver code.

All it needs is to set handle_level_oneshot_irq for the interrupt line
of your I2C or whatever devices. 

   set_irq_handler(irq, handle_level_oneshot_irq);

The core code masks the interrupt in the hard irq path and runs the
primary handler. It's expected that the primary handler returns
IRQ_WAKE_THREAD, which will wake up the thread handler. Now the
handle_level_oneshot_irq() flow control does _NOT_ unmask the
interrupt line, so no interrupt storm can happen.

Now the thread handler runs handles its bus magic. When it returns to
the core code then desc->thread_eoi is called which unmasks the
interrupt line again.
 
> > > >    My immediate thought when I noticed this was that we should probably
> > > >    fix request_threaded_irq() so that it's useful for them; I'd been
> > > >    intending to do some digging and try to understand why it is
> > > >    currently implemented as it is.
> 
> > What's to fix there ? 
> 
> Nothing if the above works, though I guess more documentation wouldn't
> hurt (and possibly a more friendly wrapper).  From the name and

Wrapper for what ? 

> documentation request_threaded_irq() looks like it should be exactly
> what's needed.
> 
> > > >  - Multi-function devices like the twl4030 which have an interrupt
> > > >    controller on them and would like to expose that interrupt controller
> > > >    via the generic IRQ subsystem.  This was a large part of the
> > > >    discussion in the thread above is a much trickier problem.
> 
> > Why ?
> 
> Partly just because it's idiomatic for the devices - these things are
> from a software point of view essentially a small stack of devices glued
> together and one of the devices on them is an interrupt controller so
> the natural thing is to want to represent that interrupt controller in
> the way Linux normally represents interrupt controllers and be able to
> reuse all the core code rather than having to implement a clone of it.

Sure.
 
> The other part of it is that it gets you all the interfaces for
> interrupts that the rest of the kernel expects which is needed when the
> device interacts with others.  The biggest issue here is that these
> devices often have GPIOs on them (especially PMICs and audio CODECs).
> These have all the facilities one expects of GPIOs, including being used
> as interrupt sources.  If we need to use chip-specific APIs to interact
> with the interrupts they raise then the drivers for anything using them
> need to know about those APIs and have special cases to work with them
> which obviously doesn't scale.

Ok, you have a main interrupt line which is triggered when any of the
interrupts in the device is raised. Now you cannot decide which of the
interrupt sources in the device triggered the interrupt because you
need to query the bus which can not be done in hard interrupt
context. Fine, use the oneshot handler for the main interrupt and do
the query in the irq thread.

The irq thread finds out which interrupt(s) are active in the
device. So it raises the interrupt handlers for those from the thread
which will wake up the relevant interrupt threads for those
devices. Once all the thread handlers have finished you return from
the main thread and the interrupt line gets unmasked again.

That's the easy part. Now some other details:

The driver which controls the interrupt device has to expose the
demultiplexed interrupts via its own irq_chip implementation. Of
course the chip functions like mask/ack/unmask cannot run in atomic
context as they require bus access again.

Here in deed we need to put some thought into common infrastructure
as it seems that such excellent hardware designs are becoming more
popular :(

The most interesting functions are request_irq, free_irq, enable_irq
and disable_irq. The main challange is to get the sychronization
straight. As Dmitry said the synchronization seems to be the most
common problem which driver writers get wrong. I can only agree with
that. 

While writing this I looked into the code and came up with the
following completely untested patch.

The idea is to serialize the bus access for those operations in the
core code so that drivers which are behind that bus operated interrupt
controller do not have to worry about it and just can use the normal
interfaces. To achieve this we add two function pointers to the
irq_chip: bus_lock and bus_sync_unlock.

bus_lock() is called to serialize access to the interrupt controller
bus.

Now the core code can issue chip->mask/unmask ... commands without
changing the fast path code at all. The chip implementation merily
stores that information in a chip private data structure and
returns. No bus interaction as these functions are called from atomic
context.

After that bus_sync_unlock() is called outside the atomic context. Now
the chip implementation issues the bus commands, waits for completion
and unlocks the interrupt controller bus.

So for the interrupt controller this would look like:

struct irq_chip_data {
       struct mutex   mutex;
       unsigned int   irq_offset;
       unsigned long  mask;
       unsigned long  mask_status;
}

static void bus_lock(unsigned int irq)
{
	struct irq_chip_data *data = get_irq_desc_chip_data(irq);

	mutex_lock(&data->mutex);
}

static void mask(unsigned int irq)
{
	struct irq_chip_data *data = get_irq_desc_chip_data(irq);

	irq -= data->irq_offset;
	data->mask |= (1 << irq);
}

static void unmask(unsigned int irq)
{
	struct irq_chip_data *data = get_irq_desc_chip_data(irq);

	irq -= data->irq_offset;
	data->mask &= ~(1 << irq);
}

static void bus_sync_unlock(unsigned int irq)
{
	struct irq_chip_data *data = get_irq_desc_chip_data(irq);

	if (data->mask != data->mask_status) {
		do_bus_magic_to_set_mask(data->mask);
		data->mask_status = data->mask;
	}
	mutex_unlock(&data->mutex);
}

The device drivers can use request_threaded_irq, free_irq, disable_irq
and enable_irq as usual with the only restriction that the calls need
to come from non atomic context.

So in combination with the handle_onshot_level_irq patch this should
solve most of these problems.

Thanks,

	tglx
----
Subject: genirq-sync-slow-bus-controlled-chips.patch
From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 22 Jul 2009 11:14:54 +0200

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h |    6 ++++++
 kernel/irq/manage.c |   34 +++++++++++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -100,6 +100,9 @@ struct msi_desc;
  * @set_type:		set the flow type (IRQ_TYPE_LEVEL/etc.) of an IRQ
  * @set_wake:		enable/disable power-management wake-on of an IRQ
  *
+ * @bus_lock:		function to lock access to slow bus (i2c) chips
+ * @bus_sync_unlock:	function to sync and unlock slow bus (i2c) chips
+ *
  * @release:		release function solely used by UML
  * @typename:		obsoleted by name, kept as migration helper
  */
@@ -123,6 +126,9 @@ struct irq_chip {
 	int		(*set_type)(unsigned int irq, unsigned int flow_type);
 	int		(*set_wake)(unsigned int irq, unsigned int on);
 
+	void		(*bus_lock)(unsigned int irq);
+	void		(*bus_sync_unlock)(unsigned int irq);
+
 	/* Currently used only by UML, might disappear one day.*/
 #ifdef CONFIG_IRQ_RELEASE_METHOD
 	void		(*release)(unsigned int irq, void *dev_id);
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -17,6 +17,22 @@
 
 #include "internals.h"
 
+static inline void chip_bus_lock(unsigned int irq, struct irq_desc *desc)
+{
+	if (unlikely(desc->chip->bus_lock)) {
+		might_sleep();
+		desc->chip->bus_lock(irq);
+	}
+}
+
+static inline void chip_bus_sync_unlock(unsigned int irq, struct irq_desc *desc)
+{
+	if (unlikely(desc->chip->bus_sync_unlock)) {
+		might_sleep();
+		desc->chip->bus_sync_unlock(irq);
+	}
+}
+
 /**
  *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
  *	@irq: interrupt number to wait for
@@ -222,9 +238,11 @@ void disable_irq_nosync(unsigned int irq
 	if (!desc)
 		return;
 
+	chip_bus_lock(irq, desc);
 	spin_lock_irqsave(&desc->lock, flags);
 	__disable_irq(desc, irq, false);
 	spin_unlock_irqrestore(&desc->lock, flags);
+	chip_bus_sync_unlock(irq, desc);
 }
 EXPORT_SYMBOL(disable_irq_nosync);
 
@@ -286,7 +304,8 @@ void __enable_irq(struct irq_desc *desc,
  *	matches the last disable, processing of interrupts on this
  *	IRQ line is re-enabled.
  *
- *	This function may be called from IRQ context.
+ *	This function may be called from IRQ context only when
+ *	desc->chip->bus_lock and desc->chip->bus_sync_unlock are NULL !
  */
 void enable_irq(unsigned int irq)
 {
@@ -296,9 +315,11 @@ void enable_irq(unsigned int irq)
 	if (!desc)
 		return;
 
+	chip_bus_lock(irq, desc);
 	spin_lock_irqsave(&desc->lock, flags);
 	__enable_irq(desc, irq, false);
 	spin_unlock_irqrestore(&desc->lock, flags);
+	chip_bus_sync_unlock(irq, desc);
 }
 EXPORT_SYMBOL(enable_irq);
 
@@ -831,7 +852,14 @@ EXPORT_SYMBOL_GPL(remove_irq);
  */
 void free_irq(unsigned int irq, void *dev_id)
 {
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (!desc)
+		return;
+
+	chip_bus_sync_lock(irq, desc);
 	kfree(__free_irq(irq, dev_id));
+	chip_bus_sync_unlock(irq, desc);
 }
 EXPORT_SYMBOL(free_irq);
 
@@ -932,10 +960,14 @@ int request_threaded_irq(unsigned int ir
 	action->name = devname;
 	action->dev_id = dev_id;
 
+	chip_bus_lock(irq, desc);
+
 	retval = __setup_irq(irq, desc, action);
 	if (retval)
 		kfree(action);
 
+	chip_bus_sync_unlock(irq, desc);
+
 #ifdef CONFIG_DEBUG_SHIRQ
 	if (irqflags & IRQF_SHARED) {
 		/*
