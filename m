Return-Path: <linux-kernel-owner+w=401wt.eu-S1758258AbYHUAEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbYHUAEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 20:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbYHUACq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 20:02:46 -0400
Received: from gw.goop.org ([64.81.55.164]:49166 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbYHUACn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 20:02:43 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4 of 4] xen: measure how long spinlocks spend blocking
X-Mercurial-Node: 60e01d097a1e08124f1eaeb6ac8e08de7ddc7c9e
Message-Id: <60e01d097a1e08124f1e.1219276941@localhost>
In-Reply-To: <patchbomb.1219276937@localhost>
Date: Wed, 20 Aug 2008 17:02:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Measure how long spinlocks spend blocked.  Also rename some fields to
be more consistent.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/spinlock.c |   60 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 41 insertions(+), 19 deletions(-)

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -29,12 +29,14 @@
 	u32 released_slow;
 	u32 released_slow_kicked;
 
-#define HISTO_BUCKETS	20
-	u32 histo_spin_fast[HISTO_BUCKETS+1];
-	u32 histo_spin[HISTO_BUCKETS+1];
+#define HISTO_BUCKETS	30
+	u32 histo_spin_total[HISTO_BUCKETS+1];
+	u32 histo_spin_spinning[HISTO_BUCKETS+1];
+	u32 histo_spin_blocked[HISTO_BUCKETS+1];
 
-	u64 spinning_time;
-	u64 total_time;
+	u64 time_total;
+	u64 time_spinning;
+	u64 time_blocked;
 } spinlock_stats;
 
 static u8 zero_stats;
@@ -70,20 +72,28 @@
 		array[HISTO_BUCKETS]++;
 }
 
-static inline void spin_time_accum_fast(u64 start)
+static inline void spin_time_accum_spinning(u64 start)
 {
 	u32 delta = xen_clocksource_read() - start;
 
-	__spin_time_accum(delta, spinlock_stats.histo_spin_fast);
-	spinlock_stats.spinning_time += delta;
+	__spin_time_accum(delta, spinlock_stats.histo_spin_spinning);
+	spinlock_stats.time_spinning += delta;
 }
 
-static inline void spin_time_accum(u64 start)
+static inline void spin_time_accum_total(u64 start)
 {
 	u32 delta = xen_clocksource_read() - start;
 
-	__spin_time_accum(delta, spinlock_stats.histo_spin);
-	spinlock_stats.total_time += delta;
+	__spin_time_accum(delta, spinlock_stats.histo_spin_total);
+	spinlock_stats.time_total += delta;
+}
+
+static inline void spin_time_accum_blocked(u64 start)
+{
+	u32 delta = xen_clocksource_read() - start;
+
+	__spin_time_accum(delta, spinlock_stats.histo_spin_blocked);
+	spinlock_stats.time_blocked += delta;
 }
 #else  /* !CONFIG_XEN_DEBUG_FS */
 #define TIMEOUT			(1 << 10)
@@ -94,10 +104,13 @@
 	return 0;
 }
 
-static inline void spin_time_accum_fast(u64 start)
+static inline void spin_time_accum_total(u64 start)
 {
 }
-static inline void spin_time_accum(u64 start)
+static inline void spin_time_accum_spinning(u64 start)
+{
+}
+static inline void spin_time_accum_blocked(u64 start)
 {
 }
 #endif  /* CONFIG_XEN_DEBUG_FS */
@@ -175,10 +188,13 @@
 	int irq = __get_cpu_var(lock_kicker_irq);
 	int ret;
 	unsigned long flags;
+	u64 start;
 
 	/* If kicker interrupts not initialized yet, just spin */
 	if (irq == -1)
 		return 0;
+
+	start = spin_time_start();
 
 	/* announce we're spinning */
 	prev = spinning_lock(xl);
@@ -230,6 +246,8 @@
 out:
 	raw_local_irq_restore(flags);
 	unspinning_lock(xl, prev);
+	spin_time_accum_blocked(start);
+
 	return ret;
 }
 
@@ -262,12 +280,12 @@
 		    : "1" (1)
 		    : "memory");
 
-		spin_time_accum_fast(start_spin_fast);
+		spin_time_accum_spinning(start_spin_fast);
 
 	} while (unlikely(oldval != 0 &&
 			  (TIMEOUT == ~0 || !xen_spin_lock_slow(lock, irq_enable))));
 
-	spin_time_accum(start_spin);
+	spin_time_accum_total(start_spin);
 }
 
 static void xen_spin_lock(struct raw_spinlock *lock)
@@ -385,14 +403,18 @@
 			   &spinlock_stats.released_slow_kicked);
 
 	debugfs_create_u64("time_spinning", 0444, d_spin_debug,
-			   &spinlock_stats.spinning_time);
+			   &spinlock_stats.time_spinning);
+	debugfs_create_u64("time_blocked", 0444, d_spin_debug,
+			   &spinlock_stats.time_blocked);
 	debugfs_create_u64("time_total", 0444, d_spin_debug,
-			   &spinlock_stats.total_time);
+			   &spinlock_stats.time_total);
 
 	xen_debugfs_create_u32_array("histo_total", 0444, d_spin_debug,
-				     spinlock_stats.histo_spin, HISTO_BUCKETS + 1);
+				     spinlock_stats.histo_spin_total, HISTO_BUCKETS + 1);
 	xen_debugfs_create_u32_array("histo_spinning", 0444, d_spin_debug,
-				     spinlock_stats.histo_spin_fast, HISTO_BUCKETS + 1);
+				     spinlock_stats.histo_spin_spinning, HISTO_BUCKETS + 1);
+	xen_debugfs_create_u32_array("histo_blocked", 0444, d_spin_debug,
+				     spinlock_stats.histo_spin_blocked, HISTO_BUCKETS + 1);
 
 	return 0;
 }


