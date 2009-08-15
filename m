Return-Path: <linux-kernel-owner+w=401wt.eu-S1751606AbZHORtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbZHORtS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 13:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbZHORtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 13:49:17 -0400
Received: from www.tglx.de ([62.245.132.106]:49835 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbZHORtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 13:49:14 -0400
Message-Id: <20090815174537.934668714@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 15 Aug 2009 17:48:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Brian Swetland <swetland@google.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>,
       arve@android.com, Barry Song <21cnbao@gmail.com>
Subject: [RFC patch 2/3] genirq: Add buslock support
References: <20090815174512.491425246@linutronix.de>
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

The device drivers can use request_threaded_irq, free_irq, disable_irq
and enable_irq as usual with the only restriction that the calls need
to come from non atomic context.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Trilok Soni <soni.trilok@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: m.szyprowski@samsung.com
Cc: t.fujak@samsung.com
Cc: kyungmin.park@samsung.com,
Cc: David Brownell <david-b@pacbell.net>
Cc: Daniel Ribeiro <drwyrm@gmail.com>
Cc: arve@android.com
Cc: Barry Song <21cnbao@gmail.com>

---
 include/linux/irq.h    |    6 ++++++
 kernel/irq/chip.c      |    2 ++
 kernel/irq/internals.h |   13 +++++++++++++
 kernel/irq/manage.c    |   19 ++++++++++++++++++-
 4 files changed, 39 insertions(+), 1 deletion(-)

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
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -597,6 +597,7 @@ __set_irq_handler(unsigned int irq, irq_
 		desc->chip = &dummy_irq_chip;
 	}
 
+	chip_bus_lock(irq, desc);
 	spin_lock_irqsave(&desc->lock, flags);
 
 	/* Uninstall? */
@@ -616,6 +617,7 @@ __set_irq_handler(unsigned int irq, irq_
 		desc->chip->startup(irq);
 	}
 	spin_unlock_irqrestore(&desc->lock, flags);
+	chip_bus_sync_unlock(irq, desc);
 }
 EXPORT_SYMBOL_GPL(__set_irq_handler);
 
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -45,6 +45,19 @@ extern int irq_select_affinity_usr(unsig
 extern void
 irq_set_thread_affinity(struct irq_desc *desc, const struct cpumask *cpumask);
 
+/* Inline functions for support of irq chips on slow busses */
+static inline void chip_bus_lock(unsigned int irq, struct irq_desc *desc)
+{
+	if (unlikely(desc->chip->bus_lock))
+		desc->chip->bus_lock(irq);
+}
+
+static inline void chip_bus_sync_unlock(unsigned int irq, struct irq_desc *desc)
+{
+	if (unlikely(desc->chip->bus_sync_unlock))
+		desc->chip->bus_sync_unlock(irq);
+}
+
 /*
  * Debugging printout:
  */
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -222,9 +222,11 @@ void disable_irq_nosync(unsigned int irq
 	if (!desc)
 		return;
 
+	chip_bus_lock(irq, desc);
 	spin_lock_irqsave(&desc->lock, flags);
 	__disable_irq(desc, irq, false);
 	spin_unlock_irqrestore(&desc->lock, flags);
+	chip_bus_sync_unlock(irq, desc);
 }
 EXPORT_SYMBOL(disable_irq_nosync);
 
@@ -286,7 +288,8 @@ void __enable_irq(struct irq_desc *desc,
  *	matches the last disable, processing of interrupts on this
  *	IRQ line is re-enabled.
  *
- *	This function may be called from IRQ context.
+ *	This function may be called from IRQ context only when
+ *	desc->chip->bus_lock and desc->chip->bus_sync_unlock are NULL !
  */
 void enable_irq(unsigned int irq)
 {
@@ -296,9 +299,11 @@ void enable_irq(unsigned int irq)
 	if (!desc)
 		return;
 
+	chip_bus_lock(irq, desc);
 	spin_lock_irqsave(&desc->lock, flags);
 	__enable_irq(desc, irq, false);
 	spin_unlock_irqrestore(&desc->lock, flags);
+	chip_bus_sync_unlock(irq, desc);
 }
 EXPORT_SYMBOL(enable_irq);
 
@@ -450,12 +455,14 @@ static int irq_wait_for_interrupt(struct
  */
 static void irq_finalize_oneshot(unsigned int irq, struct irq_desc *desc)
 {
+	chip_bus_lock(irq, desc);
 	spin_lock_irq(&desc->lock);
 	if (!(desc->status & IRQ_DISABLED) && (desc->status & IRQ_MASKED)) {
 		desc->status &= ~IRQ_MASKED;
 		desc->chip->unmask(irq);
 	}
 	spin_unlock_irq(&desc->lock);
+	chip_bus_sync_unlock(irq, desc);
 }
 
 /*
@@ -854,7 +861,14 @@ EXPORT_SYMBOL_GPL(remove_irq);
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
 
@@ -955,7 +969,10 @@ int request_threaded_irq(unsigned int ir
 	action->name = devname;
 	action->dev_id = dev_id;
 
+	chip_bus_lock(irq, desc);
 	retval = __setup_irq(irq, desc, action);
+	chip_bus_sync_unlock(irq, desc);
+
 	if (retval)
 		kfree(action);
 


