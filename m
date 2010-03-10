Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab0CJBBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 20:01:05 -0500
Received: from c60.cesmail.net ([216.154.195.49]:65471 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064Ab0CJBBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 20:01:03 -0500
Subject: [PATCH] locking: annotate inline spinlocks and rwlocks on SMP
From: Pavel Roskin <proski@gnu.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 09 Mar 2010 20:00:59 -0500
Message-Id: <1268182859.2615.8.camel@mj>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When spinlock or rwlock functions are inlined on SMP, their definitions
are not annotated for sparse.

In particular, SMP kernels without CONFIG_PREEMPT and lock debugging
would inline spin_unlock(), but not spin_lock(), resulting in bogus
sparse warnings about locking.

Use __acquire() and __release() to annotate inline spinlocks in the same
way as their non-inline implementations are annotated.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

The new code has been tested by forcing all spinlocks and rwlocks to be
inlined.  The _raw_*_irqsave() functions return long (the flags) on SMP,
so compound statements are used for them.  I ran sparse on the whole
kernel, and whenever sparse complains about locking, the code is
non-trivial.  I'm running the patched kernel now.

 include/linux/rwlock_api_smp.h   |   98 +++++++++++++++++++++++++++++++-------
 include/linux/spinlock_api_smp.h |   48 ++++++++++++++++---
 2 files changed, 120 insertions(+), 26 deletions(-)

diff --git a/include/linux/rwlock_api_smp.h b/include/linux/rwlock_api_smp.h
index 9c9f049..c16c3ee 100644
--- a/include/linux/rwlock_api_smp.h
+++ b/include/linux/rwlock_api_smp.h
@@ -41,35 +41,67 @@ _raw_write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 							__releases(lock);
 
 #ifdef CONFIG_INLINE_READ_LOCK
-#define _raw_read_lock(lock) __raw_read_lock(lock)
+#define _raw_read_lock(lock)			\
+	do {					\
+		__acquire(lock);		\
+		__raw_read_lock(lock);		\
+	} while (0)
 #endif
 
 #ifdef CONFIG_INLINE_WRITE_LOCK
-#define _raw_write_lock(lock) __raw_write_lock(lock)
+#define _raw_write_lock(lock)			\
+	do {					\
+		__acquire(lock);		\
+		__raw_write_lock(lock);		\
+	} while (0)
 #endif
 
 #ifdef CONFIG_INLINE_READ_LOCK_BH
-#define _raw_read_lock_bh(lock) __raw_read_lock_bh(lock)
+#define _raw_read_lock_bh(lock)			\
+	do {					\
+		__acquire(lock);		\
+		__raw_read_lock_bh(lock);	\
+	} while (0)
 #endif
 
 #ifdef CONFIG_INLINE_WRITE_LOCK_BH
-#define _raw_write_lock_bh(lock) __raw_write_lock_bh(lock)
+#define _raw_write_lock_bh(lock)		\
+	do {					\
+		__acquire(lock);		\
+		__raw_write_lock_bh(lock);	\
+	} while (0)
 #endif
 
 #ifdef CONFIG_INLINE_READ_LOCK_IRQ
-#define _raw_read_lock_irq(lock) __raw_read_lock_irq(lock)
+#define _raw_read_lock_irq(lock)		\
+	do {					\
+		__acquire(lock);		\
+		__raw_read_lock_irq(lock);	\
+	} while (0)
 #endif
 
 #ifdef CONFIG_INLINE_WRITE_LOCK_IRQ
-#define _raw_write_lock_irq(lock) __raw_write_lock_irq(lock)
+#define _raw_write_lock_irq(lock)		\
+	do {					\
+		__acquire(lock);		\
+		__raw_write_lock_irq(lock);	\
+	} while (0)
 #endif
 
 #ifdef CONFIG_INLINE_READ_LOCK_IRQSAVE
-#define _raw_read_lock_irqsave(lock) __raw_read_lock_irqsave(lock)
+#define _raw_read_lock_irqsave(lock)		\
+	({					\
+		__acquire(lock);		\
+		__raw_read_lock_irqsave(lock);	\
+	})
 #endif
 
 #ifdef CONFIG_INLINE_WRITE_LOCK_IRQSAVE
-#define _raw_write_lock_irqsave(lock) __raw_write_lock_irqsave(lock)
+#define _raw_write_lock_irqsave(lock)		\
+	({					\
+		__acquire(lock);		\
+		__raw_write_lock_irqsave(lock);	\
+	})
 #endif
 
 #ifdef CONFIG_INLINE_READ_TRYLOCK
@@ -81,37 +113,67 @@ _raw_write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 #endif
 
 #ifdef CONFIG_INLINE_READ_UNLOCK
-#define _raw_read_unlock(lock) __raw_read_unlock(lock)
+#define _raw_read_unlock(lock)			\
+	do {					\
+		__raw_read_unlock(lock);	\
+		__release(lock);		\
+	} while (0)
 #endif
 
 #ifdef CONFIG_INLINE_WRITE_UNLOCK
-#define _raw_write_unlock(lock) __raw_write_unlock(lock)
+#define _raw_write_unlock(lock)			\
+	do {					\
+		__raw_write_unlock(lock);	\
+		__release(lock);		\
+	} while (0)
 #endif
 
 #ifdef CONFIG_INLINE_READ_UNLOCK_BH
-#define _raw_read_unlock_bh(lock) __raw_read_unlock_bh(lock)
+#define _raw_read_unlock_bh(lock)		\
+	do {					\
+		__raw_read_unlock_bh(lock);	\
+		__release(lock);		\
+	} while (0)
 #endif
 
 #ifdef CONFIG_INLINE_WRITE_UNLOCK_BH
-#define _raw_write_unlock_bh(lock) __raw_write_unlock_bh(lock)
+#define _raw_write_unlock_bh(lock)		\
+	do {					\
+		__raw_write_unlock_bh(lock);	\
+		__release(lock);		\
+	} while (0)
 #endif
 
 #ifdef CONFIG_INLINE_READ_UNLOCK_IRQ
-#define _raw_read_unlock_irq(lock) __raw_read_unlock_irq(lock)
+#define _raw_read_unlock_irq(lock)		\
+	do {					\
+		__raw_read_unlock_irq(lock);	\
+		__release(lock);		\
+	} while (0)
 #endif
 
 #ifdef CONFIG_INLINE_WRITE_UNLOCK_IRQ
-#define _raw_write_unlock_irq(lock) __raw_write_unlock_irq(lock)
+#define _raw_write_unlock_irq(lock)		\
+	do {					\
+		__raw_write_unlock_irq(lock);	\
+		__release(lock);		\
+	} while (0)
 #endif
 
 #ifdef CONFIG_INLINE_READ_UNLOCK_IRQRESTORE
-#define _raw_read_unlock_irqrestore(lock, flags) \
-	__raw_read_unlock_irqrestore(lock, flags)
+#define _raw_read_unlock_irqrestore(lock, flags)		\
+	do {							\
+		__raw_read_unlock_irqrestore(lock, flags);	\
+		__release(lock);				\
+	} while (0)
 #endif
 
 #ifdef CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE
-#define _raw_write_unlock_irqrestore(lock, flags) \
-	__raw_write_unlock_irqrestore(lock, flags)
+#define _raw_write_unlock_irqrestore(lock, flags)		\
+	do {							\
+		__raw_write_unlock_irqrestore(lock, flags);	\
+		__release(lock);				\
+	} while (0)
 #endif
 
 static inline int __raw_read_trylock(rwlock_t *lock)
diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index e253ccd..6fb9ecb 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -44,19 +44,35 @@ _raw_spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
 								__releases(lock);
 
 #ifdef CONFIG_INLINE_SPIN_LOCK
-#define _raw_spin_lock(lock) __raw_spin_lock(lock)
+#define _raw_spin_lock(lock)			\
+	do {					\
+		__acquire(lock);		\
+		__raw_spin_lock(lock);		\
+	} while (0)
 #endif
 
 #ifdef CONFIG_INLINE_SPIN_LOCK_BH
-#define _raw_spin_lock_bh(lock) __raw_spin_lock_bh(lock)
+#define _raw_spin_lock_bh(lock)			\
+	do {					\
+		__acquire(lock);		\
+		__raw_spin_lock_bh(lock);	\
+	} while (0)
 #endif
 
 #ifdef CONFIG_INLINE_SPIN_LOCK_IRQ
-#define _raw_spin_lock_irq(lock) __raw_spin_lock_irq(lock)
+#define _raw_spin_lock_irq(lock)		\
+	do {					\
+		__acquire(lock);		\
+		__raw_spin_lock_irq(lock);	\
+	} while (0)
 #endif
 
 #ifdef CONFIG_INLINE_SPIN_LOCK_IRQSAVE
-#define _raw_spin_lock_irqsave(lock) __raw_spin_lock_irqsave(lock)
+#define _raw_spin_lock_irqsave(lock)		\
+	({					\
+		__acquire(lock);		\
+		__raw_spin_lock_irqsave(lock);	\
+	})
 #endif
 
 #ifdef CONFIG_INLINE_SPIN_TRYLOCK
@@ -68,19 +84,35 @@ _raw_spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
 #endif
 
 #ifdef CONFIG_INLINE_SPIN_UNLOCK
-#define _raw_spin_unlock(lock) __raw_spin_unlock(lock)
+#define _raw_spin_unlock(lock)			\
+	do {					\
+		__raw_spin_unlock(lock);	\
+		__release(lock);		\
+	} while (0)
 #endif
 
 #ifdef CONFIG_INLINE_SPIN_UNLOCK_BH
-#define _raw_spin_unlock_bh(lock) __raw_spin_unlock_bh(lock)
+#define _raw_spin_unlock_bh(lock)		\
+	do {					\
+		__raw_spin_unlock_bh(lock);	\
+		__release(lock);		\
+	} while (0)
 #endif
 
 #ifdef CONFIG_INLINE_SPIN_UNLOCK_IRQ
-#define _raw_spin_unlock_irq(lock) __raw_spin_unlock_irq(lock)
+#define _raw_spin_unlock_irq(lock)		\
+	do {					\
+		__raw_spin_unlock_irq(lock);	\
+		__release(lock);		\
+	} while (0)
 #endif
 
 #ifdef CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE
-#define _raw_spin_unlock_irqrestore(lock, flags) __raw_spin_unlock_irqrestore(lock, flags)
+#define _raw_spin_unlock_irqrestore(lock, flags)		\
+	do {							\
+		__raw_spin_unlock_irqrestore(lock, flags);	\
+		__release(lock);				\
+	} while (0)
 #endif
 
 static inline int __raw_spin_trylock(raw_spinlock_t *lock)

