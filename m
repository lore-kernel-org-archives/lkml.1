Return-Path: <linux-kernel-owner+w=401wt.eu-S1758203AbYHUADc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbYHUADc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 20:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbYHUACo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 20:02:44 -0400
Received: from gw.goop.org ([64.81.55.164]:49162 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbYHUACm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 20:02:42 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 4] xen: allow interrupts to be enabled while doing a
	blocking spin
X-Mercurial-Node: af2a7805bbb84b3843b86bf05bc69150150d9da8
Message-Id: <af2a7805bbb84b3843b8.1219276940@localhost>
In-Reply-To: <patchbomb.1219276937@localhost>
Date: Wed, 20 Aug 2008 17:02:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If spin_lock is called in an interrupts-enabled context, we can safely
enable interrupts while spinning.  We don't bother for the actual spin
loop, but if we timeout and fall back to blocking, it's definitely
worthwhile enabling interrupts if possible.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/spinlock.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -23,6 +23,7 @@
 	u32 taken_slow_nested;
 	u32 taken_slow_pickup;
 	u32 taken_slow_spurious;
+	u32 taken_slow_irqenable;
 
 	u64 released;
 	u32 released_slow;
@@ -167,12 +168,13 @@
 	__get_cpu_var(lock_spinners) = prev;
 }
 
-static noinline int xen_spin_lock_slow(struct raw_spinlock *lock)
+static noinline int xen_spin_lock_slow(struct raw_spinlock *lock, bool irq_enable)
 {
 	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
 	struct xen_spinlock *prev;
 	int irq = __get_cpu_var(lock_kicker_irq);
 	int ret;
+	unsigned long flags;
 
 	/* If kicker interrupts not initialized yet, just spin */
 	if (irq == -1)
@@ -180,6 +182,12 @@
 
 	/* announce we're spinning */
 	prev = spinning_lock(xl);
+
+	flags = __raw_local_save_flags();
+	if (irq_enable) {
+		ADD_STATS(taken_slow_irqenable, 1);
+		raw_local_irq_enable();
+	}
 
 	ADD_STATS(taken_slow, 1);
 	ADD_STATS(taken_slow_nested, prev != NULL);
@@ -220,11 +228,12 @@
 	kstat_irqs_this_cpu(irq_to_desc(irq))++;
 
 out:
+	raw_local_irq_restore(flags);
 	unspinning_lock(xl, prev);
 	return ret;
 }
 
-static void xen_spin_lock(struct raw_spinlock *lock)
+static inline void __xen_spin_lock(struct raw_spinlock *lock, bool irq_enable)
 {
 	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
 	unsigned timeout;
@@ -254,9 +263,21 @@
 		    : "memory");
 
 		spin_time_accum_fast(start_spin_fast);
-	} while (unlikely(oldval != 0 && (TIMEOUT == ~0 || !xen_spin_lock_slow(lock))));
+
+	} while (unlikely(oldval != 0 &&
+			  (TIMEOUT == ~0 || !xen_spin_lock_slow(lock, irq_enable))));
 
 	spin_time_accum(start_spin);
+}
+
+static void xen_spin_lock(struct raw_spinlock *lock)
+{
+	__xen_spin_lock(lock, false);
+}
+
+static void xen_spin_lock_flags(struct raw_spinlock *lock, unsigned long flags)
+{
+	__xen_spin_lock(lock, !raw_irqs_disabled_flags(flags));
 }
 
 static noinline void xen_spin_unlock_slow(struct xen_spinlock *xl)
@@ -323,6 +344,7 @@
 	pv_lock_ops.spin_is_locked = xen_spin_is_locked;
 	pv_lock_ops.spin_is_contended = xen_spin_is_contended;
 	pv_lock_ops.spin_lock = xen_spin_lock;
+	pv_lock_ops.spin_lock_flags = xen_spin_lock_flags;
 	pv_lock_ops.spin_trylock = xen_spin_trylock;
 	pv_lock_ops.spin_unlock = xen_spin_unlock;
 }
@@ -353,6 +375,8 @@
 			   &spinlock_stats.taken_slow_pickup);
 	debugfs_create_u32("taken_slow_spurious", 0444, d_spin_debug,
 			   &spinlock_stats.taken_slow_spurious);
+	debugfs_create_u32("taken_slow_irqenable", 0444, d_spin_debug,
+			   &spinlock_stats.taken_slow_irqenable);
 
 	debugfs_create_u64("released", 0444, d_spin_debug, &spinlock_stats.released);
 	debugfs_create_u32("released_slow", 0444, d_spin_debug,


