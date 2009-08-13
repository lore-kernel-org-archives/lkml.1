Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbZHMTlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbZHMTlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbZHMTlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:41:39 -0400
Received: from www.tglx.de ([62.245.132.106]:56316 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524AbZHMTlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:41:37 -0400
Message-Id: <20090813193116.509070851@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 13 Aug 2009 19:40:47 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Brian Swetland <swetland@google.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>,
       arve@android.com, Barry Song <21cnbao@gmail.com>
Subject: [RFC patch 2/3] genirq: Add buslock support for irq chips on slow
	busses
References: <20090813191535.945521006@linutronix.de>
Content-Disposition: inline; filename=genirq-add-buslock-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

For the device drivers a new set of functions is provided:
request_threaded_slowbus_irq, free_slowbus_irq, disable_slowbus_irq
and enable_slowbus_irq. They work the same as the !slowbus variants
with the only restriction that the calls need to come from non atomic
context.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/interrupt.h |    9 +++
 include/linux/irq.h       |    6 ++
 kernel/irq/manage.c       |  117 +++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 131 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/include/linux/interrupt.h
===================================================================
--- linux-2.6-tip.orig/include/linux/interrupt.h
+++ linux-2.6-tip/include/linux/interrupt.h
@@ -113,6 +113,11 @@ request_threaded_irq(unsigned int irq, i
 		     irq_handler_t thread_fn,
 		     unsigned long flags, const char *name, void *dev);
 
+extern int __must_check
+request_threaded_slowbus_irq(unsigned int irq, irq_handler_t handler,
+			     irq_handler_t thread_fn,
+			     unsigned long flags, const char *name, void *dev);
+
 static inline int __must_check
 request_irq(unsigned int irq, irq_handler_t handler, unsigned long flags,
 	    const char *name, void *dev)
@@ -145,6 +150,7 @@ static inline void exit_irq_thread(void)
 #endif
 
 extern void free_irq(unsigned int, void *);
+extern void free_slowbus_irq(unsigned int irq, void *dev_id);
 
 struct device;
 
@@ -186,6 +192,9 @@ extern void disable_irq_nosync(unsigned 
 extern void disable_irq(unsigned int irq);
 extern void enable_irq(unsigned int irq);
 
+extern void disable_slowbus_irq(unsigned int irq);
+extern void enable_slowbus_irq(unsigned int irq);
+
 /* The following three functions are for the core kernel use only. */
 #ifdef CONFIG_GENERIC_HARDIRQS
 extern void suspend_device_irqs(void);
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
@@ -253,6 +253,33 @@ void disable_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(disable_irq);
 
+/**
+ *	disable_slowbus_irq - disable an slowbus irq and wait for completion
+ *	@irq: Interrupt to disable
+ *
+ *	Disable the selected interrupt line.  Enables and Disables are
+ *	nested.
+ *	This function waits for any pending IRQ handlers for this interrupt
+ *	to complete before returning. If you use this function while
+ *	holding a resource the IRQ handler may need you will deadlock.
+ *
+ *	This function must not be called from IRQ context.
+ */
+void disable_slowbus_irq(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (!desc || !desc->chip || !desc->chip->bus_lock)
+		return;
+
+	desc->chip->bus_lock(irq);
+	disable_irq_nosync(irq);
+	if (desc->action)
+		synchronize_irq(irq);
+	desc->chip->bus_sync_unlock(irq);
+}
+EXPORT_SYMBOL(disable_slowbus_irq);
+
 void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
 {
 	if (resume)
@@ -302,6 +329,32 @@ void enable_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(enable_irq);
 
+/**
+ *	enable_slowbus_irq - enable handling of a slowbus irq
+ *	@irq: Interrupt to enable
+ *
+ *	Undoes the effect of one call to disable_irq(). If this
+ *	matches the last disable, processing of interrupts on this
+ *	IRQ line is re-enabled.
+ *
+ *	This function must not be called from IRQ context
+ */
+void enable_slowbus_irq(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned long flags;
+
+	if (!desc || !desc->chip || !desc->chip->bus_lock)
+		return;
+
+	desc->chip->bus_lock(irq);
+	spin_lock_irqsave(&desc->lock, flags);
+	__enable_irq(desc, irq, false);
+	spin_unlock_irqrestore(&desc->lock, flags);
+	desc->chip->bus_sync_unlock(irq);
+}
+EXPORT_SYMBOL(enable_slowbus_irq);
+
 static int set_irq_wake_real(unsigned int irq, unsigned int on)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
@@ -859,6 +912,33 @@ void free_irq(unsigned int irq, void *de
 EXPORT_SYMBOL(free_irq);
 
 /**
+ *	free_slowbus_irq - free an interrupt allocated with request_slowbus_irq
+ *	@irq: Interrupt line to free
+ *	@dev_id: Device identity to free
+ *
+ *	Remove an interrupt handler. The handler is removed and if the
+ *	interrupt line is no longer in use by any driver it is disabled.
+ *	On a shared IRQ the caller must ensure the interrupt is disabled
+ *	on the card it drives before calling this function. The function
+ *	does not return until any executing interrupts for this IRQ
+ *	have completed.
+ *
+ *	This function must not be called from interrupt context.
+ */
+void free_slowbus_irq(unsigned int irq, void *dev_id)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (!desc || !desc->chip || !desc->chip->bus_lock)
+		return;
+
+	desc->chip->bus_lock(irq);
+	kfree(__free_irq(irq, dev_id));
+	desc->chip->bus_sync_unlock(irq);
+}
+EXPORT_SYMBOL(free_slowbus_irq);
+
+/**
  *	request_threaded_irq - allocate an interrupt line
  *	@irq: Interrupt line to allocate
  *	@handler: Function to be called when the IRQ occurs.
@@ -981,3 +1061,37 @@ int request_threaded_irq(unsigned int ir
 	return retval;
 }
 EXPORT_SYMBOL(request_threaded_irq);
+
+/**
+ *	request_slowbus_threaded_irq - allocate a slowbus interrupt line
+ *	@irq: Interrupt line to allocate
+ *	@handler: Function to be called when the IRQ occurs.
+ *		  Primary handler for threaded interrupts
+ *	@thread_fn: Function called from the irq handler thread
+ *		    If NULL, no irq thread is created
+ *	@irqflags: Interrupt type flags
+ *	@devname: An ascii name for the claiming device
+ *	@dev_id: A cookie passed back to the handler function
+ *
+ *	See request_threaded_irq for further information
+ */
+int request_slowbus_threaded_irq(unsigned int irq, irq_handler_t handler,
+				 irq_handler_t thread_fn,
+				 unsigned long irqflags,
+				 const char *devname, void *dev_id)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	int res;
+
+	if (!desc || !desc->chip || !desc->chip->bus_lock)
+		return -EINVAL;
+
+	desc->chip->bus_lock(irq);
+	res = request_threaded_irq(irq, handler, thread_fn, irqflags, devname,
+				   dev_id);
+
+	desc->chip->bus_sync_unlock(irq);
+
+	return res;
+}
+EXPORT_SYMBOL(request_slowbus_threaded_irq);


