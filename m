Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbYHPQeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbYHPQeb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 12:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYHPQeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 12:34:21 -0400
Received: from gw.goop.org ([64.81.55.164]:47249 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbYHPQeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 12:34:20 -0400
Message-ID: <48A70185.2020600@goop.org>
Date: Sat, 16 Aug 2008 09:34:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christian Borntraeger <cborntra@de.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH RFC 1/3] Add a trigger API for efficient non-blocking waiting
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are various places in the kernel which wish to wait for a
condition to come true while in a non-blocking context.  Existing
examples of this are stop_machine() and smp_call_function_mask().
(No doubt there are other instances of this pattern in the tree.)

Thus far, the only way to achieve this is by spinning with a
cpu_relax() loop.  This is fine if the condition becomes true very
quickly, but it is not ideal:

 - There's little opportunity to put the CPUs into a low-power state.
   cpu_relax() may do this to some extent, but if the wait is
   relatively long, then we can probably do better.

 - In a virtual environment, spinning virtual CPUs just waste CPU
   resources, and may steal CPU time from vCPUs which need it to make
   progress.  The trigger API allows the vCPUs to give up their CPU
   entirely.  The s390 people observed a problem with stop_machine
   taking a very long time (seconds) when there are more vcpus than
   available cpus.

The trigger API is simple:

To initialize a trigger, you can either do it statically with:

   DEFINE_TRIGGER(trigger);

or dynamically with

   trigger_init(&trigger);

Then to use it, the wait side does:

   trigger_reset(&trigger);

   while(!condition)
	trigger_wait(&trigger);

   trigger_finish(&trigger);

and when the condition is set true:

   condition = true;
   trigger_kick(&trigger);

Some points to note:

- the wait side of the trigger must have preemption disabled (but
  interrupts may be enabled)

- the kick side may be any context

- the trigger is "sticky", so that if it's kicked before entering the
  wait, the wait terminates immediately

- you must check the condition between the trigger_reset() and
  trigger_wait(), and between calls to trigger_wait()

- trigger_wait() implicitly resets the trigger

- trigger_kick() is a write barrier

- trigger_wait() is a read barrier

- the implementation may disable interrupts between trigger_reset()
  and trigger_wait(); if interrupts were enabled at that point, they
  will be enabled during the wait, but disabled again by the time
  trigger_wait() returns.  trigger_finish() will restore the original
  interrupt state.

The initial generic implementation is just a simple polling
cpu_relax() loop.  Architectures may set CONFIG_ARCH_HAS_TRIGGER to
define more optimal architecture-specific implementations.

[ I haven't given much thought to how this might make use of lockdep yet. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/smp.h     |    2 
 include/linux/trigger.h |  145 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/smp.c            |   18 ++---
 kernel/stop_machine.c   |   39 +++++++-----
 4 files changed, 178 insertions(+), 26 deletions(-)

===================================================================
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -9,6 +9,7 @@
 #include <linux/errno.h>
 #include <linux/list.h>
 #include <linux/cpumask.h>
+#include <linux/trigger.h>
 
 extern void cpu_idle(void);
 
@@ -17,6 +18,7 @@
 	void (*func) (void *info);
 	void *info;
 	unsigned int flags;
+	trigger_t trigger;
 };
 
 #ifdef CONFIG_SMP
===================================================================
--- /dev/null
+++ b/include/linux/trigger.h
@@ -0,0 +1,145 @@
+#ifndef _LINUX_TRIGGER_H
+#define _LINUX_TRIGGER_H
+/*
+ * Triggers - a general purpose synchronization primitive
+ *
+ * A trigger is a primitive used for waiting for a condition to come
+ * true.  Sample usage:
+ *
+ * struct trigger trig;	// already initialized
+ *
+ * // wait for condition
+ * trigger_reset(&trig);
+ * while(!condition)
+ *   trigger_wait(&trig);
+ * trigger_finish(&trig);
+ *
+ * // set condition
+ * make_condition_true();
+ * trigger_kick(&trig);
+ *
+ * This would be used when:
+ * - we can't block (otherwise there are other primitives we could use), and
+ * - we expect it will take a while for the condition to come true
+ *
+ * The wait-side functions must be called with preemption disabled.
+ *
+ * The simplest implementation would just be a no-op, with
+ * trigger_wait() simply being a compiler barrier.  But a more
+ * sophisticated implementation could put the cpu into a low power
+ * state, or if virtualized, yield the cpu altogether.
+ *
+ * 2008 Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
+ */
+
+#ifdef CONFIG_ARCH_HAS_TRIGGER
+#include <asm/trigger.h>
+#else  /* !CONFIG_ARCH_HAS_TRIGGER */
+#include <asm/processor.h>
+#include <asm/system.h>
+
+typedef struct {} trigger_t;
+
+#define DEFINE_TRIGGER(n)	trigger_t n = {}
+
+static inline void __raw_trigger_init(trigger_t *t)
+{
+}
+
+static inline void __raw_trigger_reset(trigger_t *t)
+{
+}
+
+static inline void __raw_trigger_wait(trigger_t *t)
+{
+	/* cpu_relax() is a read barrier */
+	cpu_relax();
+}
+
+static inline void __raw_trigger_kick(trigger_t *t)
+{
+	/* make sure any memory writes a done before going on */
+	smp_wmb();
+}
+
+static inline void __raw_trigger_finish(trigger_t *t)
+{
+}
+#endif	/* CONFIG_ARCH_HAS_TRIGGER */
+
+/**
+ * trigger_init - Initialize a trigger for use
+ * @t - trigger to be initialized
+ */
+static inline void trigger_init(trigger_t *t)
+{
+	__raw_trigger_init(t);
+}
+
+/**
+ * trigger_reset - reset a trigger
+ * @t - trigger to be reset
+ *
+ * This resets the trigger state, allowing a trigger_wait to block.
+ * Note that preemption must be disabled between trigger_reset() and
+ * trigger_finish().
+ *
+ * The use of these functions is:
+ *	trigger_reset(&t);
+ *	while(!condition)
+ *		trigger_wait(&t);
+ *	trigger_finish(&t);
+ *
+ * and where the condition is set:
+ *	condition = true;
+ *	trigger_kick(&t);
+ */
+static inline void trigger_reset(trigger_t *t)
+{
+	__raw_trigger_reset(t);
+}
+
+/**
+ * trigger_wait - wait for a trigger to be kicked
+ * @t - trigger to be waited on
+ *
+ * This blocks until the trigger has been kicked.  If the trigger has
+ * already been kicked, it will return immediately.  It may also
+ * return without the trigger having been kicked at all; the caller
+ * must test the condition before calling trigger_wait() again.
+ *
+ * trigger_wait() acts as a read barrier.
+ *
+ * On return, the trigger will have always be reset.
+ */
+static inline void trigger_wait(trigger_t *t)
+{
+	__raw_trigger_wait(t);
+}
+
+/**
+ * trigger_kick - kick a trigger
+ * @t - trigger to kick
+ *
+ * This causes anyone waiting in trigger_wait to continue.  It may be
+ * called in any context.
+ *
+ * trigger_kick() acts as a write barrier.
+ */
+static inline void trigger_kick(trigger_t *t)
+{
+	__raw_trigger_kick(t);
+}
+
+/**
+ * trigger_finish - clean up trigger
+ * @t - trigger to be cleaned up
+ *
+ * This cleans up any implementation trigger state once we've finished
+ * with it.
+ */
+static inline void trigger_finish(trigger_t *t)
+{
+	__raw_trigger_finish(t);
+}
+#endif	/* _LINUX_TRIGGER_H */
===================================================================
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -50,15 +50,10 @@
 static void csd_flag_wait(struct call_single_data *data)
 {
 	/* Wait for response */
-	do {
-		/*
-		 * We need to see the flags store in the IPI handler
-		 */
-		smp_mb();
-		if (!(data->flags & CSD_FLAG_WAIT))
-			break;
-		cpu_relax();
-	} while (1);
+	trigger_reset(&data->trigger);
+	while(data->flags & CSD_FLAG_WAIT)
+		trigger_wait(&data->trigger);
+	trigger_finish(&data->trigger);
 }
 
 /*
@@ -70,6 +65,8 @@
 	struct call_single_queue *dst = &per_cpu(call_single_queue, cpu);
 	int wait = data->flags & CSD_FLAG_WAIT, ipi;
 	unsigned long flags;
+
+	trigger_init(&data->trigger);
 
 	spin_lock_irqsave(&dst->lock, flags);
 	ipi = list_empty(&dst->list);
@@ -135,6 +132,7 @@
 			 */
 			smp_wmb();
 			data->csd.flags &= ~CSD_FLAG_WAIT;
+			trigger_kick(&data->csd.trigger);
 		}
 		if (data->csd.flags & CSD_FLAG_ALLOC)
 			call_rcu(&data->rcu_head, rcu_free_call_data);
@@ -185,6 +183,7 @@
 			if (data_flags & CSD_FLAG_WAIT) {
 				smp_wmb();
 				data->flags &= ~CSD_FLAG_WAIT;
+				trigger_kick(&data->trigger);
 			} else if (data_flags & CSD_FLAG_ALLOC)
 				kfree(data);
 		}
@@ -357,6 +356,7 @@
 	}
 
 	spin_lock_init(&data->lock);
+	trigger_init(&data->csd.trigger);
 	data->csd.func = func;
 	data->csd.info = info;
 	data->refs = num_cpus;
===================================================================
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -9,6 +9,7 @@
 #include <linux/stop_machine.h>
 #include <linux/syscalls.h>
 #include <linux/interrupt.h>
+#include <linux/trigger.h>
 
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
@@ -35,6 +36,7 @@
 };
 
 /* Like num_online_cpus(), but hotplug cpu uses us, so we need this. */
+static DEFINE_TRIGGER(trigger);
 static unsigned int num_threads;
 static atomic_t thread_ack;
 static struct completion finished;
@@ -46,6 +48,7 @@
 	atomic_set(&thread_ack, num_threads);
 	smp_wmb();
 	state = newstate;
+	trigger_kick(&trigger);
 }
 
 /* Last one to ack a state moves to the next state. */
@@ -70,24 +73,26 @@
 	/* Simple state machine */
 	do {
 		/* Chill out and ensure we re-read stopmachine_state. */
-		cpu_relax();
-		if (state != curstate) {
-			curstate = state;
-			switch (curstate) {
-			case STOPMACHINE_DISABLE_IRQ:
-				local_irq_disable();
-				hard_irq_disable();
-				break;
-			case STOPMACHINE_RUN:
-				/* |= allows error detection if functions on
-				 * multiple CPUs. */
-				smdata->fnret |= smdata->fn(smdata->data);
-				break;
-			default:
-				break;
-			}
-			ack_state();
+		trigger_reset(&trigger);
+		while (state == curstate)
+			trigger_wait(&trigger);
+		trigger_finish(&trigger);
+
+		curstate = state;
+		switch (curstate) {
+		case STOPMACHINE_DISABLE_IRQ:
+			local_irq_disable();
+			hard_irq_disable();
+			break;
+		case STOPMACHINE_RUN:
+			/* |= allows error detection if functions on
+			 * multiple CPUs. */
+			smdata->fnret |= smdata->fn(smdata->data);
+			break;
+		default:
+			break;
 		}
+		ack_state();
 	} while (curstate != STOPMACHINE_EXIT);
 
 	local_irq_enable();


