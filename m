Return-Path: <linux-kernel-owner+w=401wt.eu-S1752454AbYHUADO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbYHUADO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 20:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYHUACn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 20:02:43 -0400
Received: from gw.goop.org ([64.81.55.164]:49150 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbYHUACm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 20:02:42 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 4] xen: save previous spinlock when blocking
X-Mercurial-Node: 2d82a7e950670974ce47b77e918712600dac909e
Message-Id: <2d82a7e950670974ce47.1219276938@localhost>
In-Reply-To: <patchbomb.1219276937@localhost>
Date: Wed, 20 Aug 2008 17:02:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A spinlock can be interrupted while spinning, so make sure we preserve
the previous lock of interest if we're taking a lock from within an
interrupt handler.

We also need to deal with the case where the blocking path gets
interrupted between testing to see if the lock is free and actually
blocking.  If we get interrupted there and end up in the state where
the lock is free but the irq isn't pending, then we'll block
indefinitely in the hypervisor.  This fix is to make sure that any
nested lock-takers will always leave the irq pending if there's any
chance the outer lock became free.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/spinlock.c |   65 ++++++++++++++++++++++++++++++++++++-----------
 drivers/xen/events.c    |   25 ++++++++++++++++++
 include/xen/events.h    |    2 +
 3 files changed, 77 insertions(+), 15 deletions(-)

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -47,25 +47,41 @@
 static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
 static DEFINE_PER_CPU(struct xen_spinlock *, lock_spinners);
 
-static inline void spinning_lock(struct xen_spinlock *xl)
+/*
+ * Mark a cpu as interested in a lock.  Returns the CPU's previous
+ * lock of interest, in case we got preempted by an interrupt.
+ */
+static inline struct xen_spinlock *spinning_lock(struct xen_spinlock *xl)
 {
+	struct xen_spinlock *prev;
+
+	prev = __get_cpu_var(lock_spinners);
 	__get_cpu_var(lock_spinners) = xl;
+
 	wmb();			/* set lock of interest before count */
+
 	asm(LOCK_PREFIX " incw %0"
 	    : "+m" (xl->spinners) : : "memory");
+
+	return prev;
 }
 
-static inline void unspinning_lock(struct xen_spinlock *xl)
+/*
+ * Mark a cpu as no longer interested in a lock.  Restores previous
+ * lock of interest (NULL for none).
+ */
+static inline void unspinning_lock(struct xen_spinlock *xl, struct xen_spinlock *prev)
 {
 	asm(LOCK_PREFIX " decw %0"
 	    : "+m" (xl->spinners) : : "memory");
-	wmb();			/* decrement count before clearing lock */
-	__get_cpu_var(lock_spinners) = NULL;
+	wmb();			/* decrement count before restoring lock */
+	__get_cpu_var(lock_spinners) = prev;
 }
 
 static noinline int xen_spin_lock_slow(struct raw_spinlock *lock)
 {
 	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
+	struct xen_spinlock *prev;
 	int irq = __get_cpu_var(lock_kicker_irq);
 	int ret;
 
@@ -74,23 +90,42 @@
 		return 0;
 
 	/* announce we're spinning */
-	spinning_lock(xl);
+	prev = spinning_lock(xl);
 
-	/* clear pending */
-	xen_clear_irq_pending(irq);
+	do {
+		/* clear pending */
+		xen_clear_irq_pending(irq);
 
-	/* check again make sure it didn't become free while
-	   we weren't looking  */
-	ret = xen_spin_trylock(lock);
-	if (ret)
-		goto out;
+		/* check again make sure it didn't become free while
+		   we weren't looking  */
+		ret = xen_spin_trylock(lock);
+		if (ret) {
+			/*
+			 * If we interrupted another spinlock while it
+			 * was blocking, make sure it doesn't block
+			 * without rechecking the lock.
+			 */
+			if (prev != NULL)
+				xen_set_irq_pending(irq);
+			goto out;
+		}
 
-	/* block until irq becomes pending */
-	xen_poll_irq(irq);
+		/*
+		 * Block until irq becomes pending.  If we're
+		 * interrupted at this point (after the trylock but
+		 * before entering the block), then the nested lock
+		 * handler guarantees that the irq will be left
+		 * pending if there's any chance the lock became free;
+		 * xen_poll_irq() returns immediately if the irq is
+		 * pending.
+		 */
+		xen_poll_irq(irq);
+	} while (!xen_test_irq_pending(irq)); /* check for spurious wakeups */
+
 	kstat_irqs_this_cpu(irq_to_desc(irq))++;
 
 out:
-	unspinning_lock(xl);
+	unspinning_lock(xl, prev);
 	return ret;
 }
 
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -166,6 +166,12 @@
 {
 	struct shared_info *s = HYPERVISOR_shared_info;
 	sync_set_bit(port, &s->evtchn_pending[0]);
+}
+
+static inline int test_evtchn(int port)
+{
+	struct shared_info *s = HYPERVISOR_shared_info;
+	return sync_test_bit(port, &s->evtchn_pending[0]);
 }
 
 
@@ -736,6 +742,25 @@
 		clear_evtchn(evtchn);
 }
 
+void xen_set_irq_pending(int irq)
+{
+	int evtchn = evtchn_from_irq(irq);
+
+	if (VALID_EVTCHN(evtchn))
+		set_evtchn(evtchn);
+}
+
+bool xen_test_irq_pending(int irq)
+{
+	int evtchn = evtchn_from_irq(irq);
+	bool ret = false;
+
+	if (VALID_EVTCHN(evtchn))
+		ret = test_evtchn(evtchn);
+
+	return ret;
+}
+
 /* Poll waiting for an irq to become pending.  In the usual case, the
    irq will be disabled so it won't deliver an interrupt. */
 void xen_poll_irq(int irq)
diff --git a/include/xen/events.h b/include/xen/events.h
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -46,6 +46,8 @@
 
 /* Clear an irq's pending state, in preparation for polling on it */
 void xen_clear_irq_pending(int irq);
+void xen_set_irq_pending(int irq);
+bool xen_test_irq_pending(int irq);
 
 /* Poll waiting for an irq to become pending.  In the usual case, the
    irq will be disabled so it won't deliver an interrupt. */


