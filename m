Return-Path: <linux-kernel-owner+w=401wt.eu-S932255AbYEGSug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbYEGSug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763634AbYEGStx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:49:53 -0400
Received: from relay2.sgi.com ([192.48.171.30]:40752 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761936AbYEGStv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:49:51 -0400
Date: Wed, 7 May 2008 11:49:49 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin with
 irqs disable
In-Reply-To: <Pine.LNX.4.64.0805071022230.3173@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0805071148240.8441@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com>
 <20080507073017.GJ32195@elte.hu> <Pine.LNX.4.64.0805071002330.3110@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0805071022230.3173@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin with irqs disabled

The nice spinlock functions that enable interrupts while spinning are only
usable if GENERIC_LOCKBREAK is set (and we do not debug locks but lock
debugging would not be used for a production configuration).

Factor out the dependencies on the ->lock_break field from the nice functions
into a set of BREAKLOCK macros (cannot be functions since the type of the lock
variable varies).

The nice spinlock function can then also be used if !GENERIC_LOCKBREAK

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 kernel/spinlock.c |   40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

Index: linux-2.6/kernel/spinlock.c
===================================================================
--- linux-2.6.orig/kernel/spinlock.c	2008-05-07 11:19:31.000000000 -0700
+++ linux-2.6/kernel/spinlock.c	2008-05-07 11:40:56.000000000 -0700
@@ -65,7 +65,7 @@ EXPORT_SYMBOL(_write_trylock);
  * even on CONFIG_PREEMPT, because lockdep assumes that interrupts are
  * not re-enabled during lock-acquire (which the preempt-spin-ops do):
  */
-#if !defined(CONFIG_GENERIC_LOCKBREAK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
 
 void __lockfunc _read_lock(rwlock_t *lock)
 {
@@ -192,7 +192,7 @@ void __lockfunc _write_lock(rwlock_t *lo
 
 EXPORT_SYMBOL(_write_lock);
 
-#else /* CONFIG_PREEMPT: */
+#else /* CONFIG_DEBUG_LOCK_ALLOC: */
 
 /*
  * This could be a long-held lock. We both prepare to spin for a long
@@ -201,6 +201,28 @@ EXPORT_SYMBOL(_write_lock);
  *
  * (We do this in a function because inlining it would be excessive.)
  */
+#ifdef CONFIG_GENERIC_LOCKBREAK
+
+#define BREAKLOCK(lock) (lock)->break_lock
+
+#define BREAKLOCK_ENABLE(lock)						\
+do {									\
+	if (!(lock)->break_lock)					\
+		(lock)->break_lock = 1;					\
+} while (0)
+
+#define BREAKLOCK_DISABLE(lock)						\
+do {									\
+	 (lock)->break_lock = 0;					\
+} while (0)
+
+#else
+
+#define BREAKLOCK(lock)	0
+#define BREAKLOCK_ENABLE(lock)	do { } while (0)
+#define BREAKLOCK_DISABLE(lock) do { } while (0)
+
+#endif
 
 #define BUILD_LOCK_OPS(op, locktype)					\
 void __lockfunc _##op##_lock(locktype##_t *lock)			\
@@ -211,12 +233,11 @@ void __lockfunc _##op##_lock(locktype##_
 			break;						\
 		preempt_enable();					\
 									\
-		if (!(lock)->break_lock)				\
-			(lock)->break_lock = 1;				\
-		while (!op##_can_lock(lock) && (lock)->break_lock)	\
+		BREAKLOCK_ENABLE(lock);					\
+		while (!op##_can_lock(lock) && BREAKLOCK(lock))		\
 			_raw_##op##_relax(&lock->raw_lock);		\
 	}								\
-	(lock)->break_lock = 0;						\
+	BREAKLOCK_DISABLE(lock);					\
 }									\
 									\
 EXPORT_SYMBOL(_##op##_lock);						\
@@ -233,12 +254,11 @@ unsigned long __lockfunc _##op##_lock_ir
 		local_irq_restore(flags);				\
 		preempt_enable();					\
 									\
-		if (!(lock)->break_lock)				\
-			(lock)->break_lock = 1;				\
-		while (!op##_can_lock(lock) && (lock)->break_lock)	\
+		BREAKLOCK_ENABLE(lock);					\
+		while (!op##_can_lock(lock) && BREAKLOCK(lock))		\
 			_raw_##op##_relax(&lock->raw_lock);		\
 	}								\
-	(lock)->break_lock = 0;						\
+	BREAKLOCK_DISABLE(lock);					\
 	return flags;							\
 }									\
 									\

