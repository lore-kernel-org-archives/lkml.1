Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbZJBB6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbZJBB6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134AbZJBB6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:58:38 -0400
Received: from kroah.org ([198.145.64.141]:32981 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755109AbZJBBcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:46 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:09 2009
Message-Id: <20091002012409.691327788@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [026/136] xen: only enable interrupts while actually blocking for spinlock
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=xen-only-enable-interrupts-while-actually-blocking-for-spinlock.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

commit 4d576b57b50a92801e6493e76e5243d6cff193d2 upstream.

Where possible we enable interrupts while waiting for a spinlock to
become free, in order to reduce big latency spikes in interrupt handling.

However, at present if we manage to pick up the spinlock just before
blocking, we'll end up holding the lock with interrupts enabled for a
while.  This will cause a deadlock if we recieve an interrupt in that
window, and the interrupt handler tries to take the lock too.

Solve this by shrinking the interrupt-enabled region to just around the
blocking call.

[ Impact: avoid race/deadlock when using Xen PV spinlocks ]

Reported-by: "Yang, Xiaowei" <xiaowei.yang@intel.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/spinlock.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -187,7 +187,6 @@ static noinline int xen_spin_lock_slow(s
 	struct xen_spinlock *prev;
 	int irq = __get_cpu_var(lock_kicker_irq);
 	int ret;
-	unsigned long flags;
 	u64 start;
 
 	/* If kicker interrupts not initialized yet, just spin */
@@ -199,16 +198,12 @@ static noinline int xen_spin_lock_slow(s
 	/* announce we're spinning */
 	prev = spinning_lock(xl);
 
-	flags = __raw_local_save_flags();
-	if (irq_enable) {
-		ADD_STATS(taken_slow_irqenable, 1);
-		raw_local_irq_enable();
-	}
-
 	ADD_STATS(taken_slow, 1);
 	ADD_STATS(taken_slow_nested, prev != NULL);
 
 	do {
+		unsigned long flags;
+
 		/* clear pending */
 		xen_clear_irq_pending(irq);
 
@@ -228,6 +223,12 @@ static noinline int xen_spin_lock_slow(s
 			goto out;
 		}
 
+		flags = __raw_local_save_flags();
+		if (irq_enable) {
+			ADD_STATS(taken_slow_irqenable, 1);
+			raw_local_irq_enable();
+		}
+
 		/*
 		 * Block until irq becomes pending.  If we're
 		 * interrupted at this point (after the trylock but
@@ -238,13 +239,15 @@ static noinline int xen_spin_lock_slow(s
 		 * pending.
 		 */
 		xen_poll_irq(irq);
+
+		raw_local_irq_restore(flags);
+
 		ADD_STATS(taken_slow_spurious, !xen_test_irq_pending(irq));
 	} while (!xen_test_irq_pending(irq)); /* check for spurious wakeups */
 
 	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
 
 out:
-	raw_local_irq_restore(flags);
 	unspinning_lock(xl, prev);
 	spin_time_accum_blocked(start);
 


