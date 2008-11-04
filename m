Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237AbYKDMcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbYKDMcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 07:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYKDMbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 07:31:31 -0500
Received: from relay2.sgi.com ([192.48.179.30]:37104 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751532AbYKDMb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 07:31:27 -0500
Message-Id: <20081104122418.842777026@attica.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 04 Nov 2008 06:24:06 -0600
From: holt@sgi.com
To: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Cc: Petr Tesarik <ptesarik@suse.cz>, Tony Ernst <tee@sgi.com>,
       Robin Holt <holt@sgi.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [Patch V3 1/3] Factor out #ifdefs from kernel/spinlock.c to LOCK_CONTENDED_FLAGS
References: <20081104122405.046233722@attica.americas.sgi.com>
Content-Disposition: inline; filename=rwlocks_1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new macro LOCK_CONTENDED_FLAGS expands to the correct implementation
depending on the config options, so that IRQ's are re-enabled when
possible, but they remain disabled if CONFIG_LOCKDEP is set.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
Signed-off-by: Robin Holt <holt@sgi.com>
---
 include/linux/lockdep.h |   17 +++++++++++++++++
 kernel/spinlock.c       |   12 ++----------
 2 files changed, 19 insertions(+), 10 deletions(-)

Index: rwlock/include/linux/lockdep.h
===================================================================
--- rwlock.orig/include/linux/lockdep.h	2008-11-04 05:54:18.456411408 -0600
+++ rwlock/include/linux/lockdep.h	2008-11-04 05:55:43.335302610 -0600
@@ -376,6 +376,23 @@ do {								\
 
 #endif /* CONFIG_LOCK_STAT */
 
+#ifdef CONFIG_LOCKDEP
+
+/*
+ * On lockdep we dont want the hand-coded irq-enable of
+ * _raw_*_lock_flags() code, because lockdep assumes
+ * that interrupts are not re-enabled during lock-acquire:
+ */
+#define LOCK_CONTENDED_FLAGS(_lock, try, lock, lockfl, flags) \
+	LOCK_CONTENDED((_lock), (try), (lock))
+
+#else /* CONFIG_LOCKDEP */
+
+#define LOCK_CONTENDED_FLAGS(_lock, try, lock, lockfl, flags) \
+	lockfl((_lock), (flags))
+
+#endif /* CONFIG_LOCKDEP */
+
 #if defined(CONFIG_TRACE_IRQFLAGS) && defined(CONFIG_GENERIC_HARDIRQS)
 extern void early_init_irq_lock_class(void);
 #else
Index: rwlock/kernel/spinlock.c
===================================================================
--- rwlock.orig/kernel/spinlock.c	2008-11-04 05:54:18.456411408 -0600
+++ rwlock/kernel/spinlock.c	2008-11-04 06:00:35.504744806 -0600
@@ -299,16 +299,8 @@ unsigned long __lockfunc _spin_lock_irqs
 	local_irq_save(flags);
 	preempt_disable();
 	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
-	/*
-	 * On lockdep we dont want the hand-coded irq-enable of
-	 * _raw_spin_lock_flags() code, because lockdep assumes
-	 * that interrupts are not re-enabled during lock-acquire:
-	 */
-#ifdef CONFIG_LOCKDEP
-	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
-#else
-	_raw_spin_lock_flags(lock, &flags);
-#endif
+	LOCK_CONTENDED_FLAGS(lock, _raw_spin_trylock, _raw_spin_lock,
+				_raw_spin_lock_flags, &flags);
 	return flags;
 }
 EXPORT_SYMBOL(_spin_lock_irqsave_nested);

