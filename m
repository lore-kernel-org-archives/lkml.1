Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbZHNKDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbZHNKDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 06:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbZHNKDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 06:03:41 -0400
Received: from www.tglx.de ([62.245.132.106]:56095 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbZHNKDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 06:03:40 -0400
Date: Fri, 14 Aug 2009 11:59:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Brian Swetland <swetland@google.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>,
       arve@android.com, Barry Song <21cnbao@gmail.com>
Subject: Re: [RFC patch 2/3] genirq: Add buslock support for irq chips on
 slow busses
In-Reply-To: <20090814091819.GA27687@elte.hu>
Message-ID: <alpine.LFD.2.00.0908141156240.1283@localhost.localdomain>
References: <20090813191535.945521006@linutronix.de> <20090813193116.509070851@linutronix.de> <1250239811.5241.1198.camel@twins> <alpine.LFD.2.00.0908141101540.1283@localhost.localdomain> <20090814091819.GA27687@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Aug 2009, Ingo Molnar wrote:
> > Yeah, that's what I wanted to avoid with the first version, which 
> > did the conditional locking and did not require a separate API, 
> > but Ingo frowned upon the conditional lock.
> 
> Mind posting that version too?
> 
> Conditional locking is really nasty but if the only other option is 
> nastier there's not much we can do, is there?

Here you go.

Thanks,

	tglx
----
Subject: genirq: Add buslock support
From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 13 Aug 2009 12:17:48 +0200

Some interrupt chips are connected to a "slow" bus (i2c, spi ...). The
bus access needs to sleep and therefor cannot be called in atomic
contexts.

Some of the generic interrupt management functions like disable_irq(),
enable_irq() ... call interrupt chip functions with the irq_desc->lock
held and interrupts disabled. This does not work for such devices.

Provide a separate synchronization mechanism for such interrupt
chips. The irq_chip structure is extended by two optional functions
(bus_lock and bus_sync_and_unlock).

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

The irq_chip implementation as pseudo code:

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

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/irq.h |    6 ++++++
 kernel/irq/manage.c |   34 +++++++++++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -101,6 +101,9 @@ struct msi_desc;
  * @set_type:		set the flow type (IRQ_TYPE_LEVEL/etc.) of an IRQ
  * @set_wake:		enable/disable power-management wake-on of an IRQ
  *
+ * @bus_lock:		function to lock access to slow bus (i2c) chips
+ * @bus_sync_unlock:	function to sync and unlock slow bus (i2c) chips
+ *
  * @release:		release function solely used by UML
  * @typename:		obsoleted by name, kept as migration helper
  */
@@ -124,6 +127,9 @@ struct irq_chip {
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
 
@@ -854,7 +875,14 @@ EXPORT_SYMBOL_GPL(remove_irq);
  */
 void free_irq(unsigned int irq, void *dev_id)
 {
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (!desc)
+		return;
+
+	chip_bus_lock(irq, desc);
 	kfree(__free_irq(irq, dev_id));
+	chip_bus_sync_unlock(irq, desc);
 }
 EXPORT_SYMBOL(free_irq);
 
@@ -955,10 +983,14 @@ int request_threaded_irq(unsigned int ir
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
