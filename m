Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbZHBTbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbZHBTbR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 15:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbZHBTbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 15:31:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:55093 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbZHBTbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 15:31:13 -0400
Date: Sun, 2 Aug 2009 19:30:36 GMT
From: tip-bot for David Kilroy <kilroyd@googlemail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       kilroyd@googlemail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       kilroyd@googlemail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1249238465-4929-1-git-send-email-kilroyd@googlemail.com>
References: <1249238465-4929-1-git-send-email-kilroyd@googlemail.com>
Subject: [tip:core/locking] locking: Check spinlock_t/rwlock_t argument type on non-SMP builds too
Message-ID: <tip-8d19bd347e1073e7f1ef9f8057c560a5f6be63d7@git.kernel.org>
Git-Commit-ID: 8d19bd347e1073e7f1ef9f8057c560a5f6be63d7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 02 Aug 2009 19:30:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d19bd347e1073e7f1ef9f8057c560a5f6be63d7
Gitweb:     http://git.kernel.org/tip/8d19bd347e1073e7f1ef9f8057c560a5f6be63d7
Author:     David Kilroy <kilroyd@googlemail.com>
AuthorDate: Sun, 2 Aug 2009 19:41:05 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 2 Aug 2009 21:29:07 +0200

locking: Check spinlock_t/rwlock_t argument type on non-SMP builds too

When writing code for UP without CONFIG_DEBUG_SPINLOCK it's
easy to get the first argument to the spinlock/rwlock functions
wrong. This is because the parameter is not actually used in
this configuration.

Typically you will only find out it's wrong:

 * by rebuilding with CONFIG_SMP or CONFIG_DEBUG_SPINLOCK
 * after you've submitted your beautiful patch series

The first means a long wait, and the latter is a bit late.

Change the intermediate macros into inline functions.

-v2: Use C inlines instead of in-macro type-checks
-v3: Correct bug in _spin_trylock_bh

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: akpm@linux-foundation.org
LKML-Reference: <1249238465-4929-1-git-send-email-kilroyd@googlemail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/spinlock.h        |    6 +-
 include/linux/spinlock_api_up.h |  118 +++++++++++++++++++++++++++++----------
 2 files changed, 92 insertions(+), 32 deletions(-)

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 4be57ab..3dd492f 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -249,17 +249,17 @@ static inline void smp_mb__after_lock(void) { smp_mb(); }
 #define spin_lock_irqsave(lock, flags)			\
 	do {						\
 		typecheck(unsigned long, flags);	\
-		_spin_lock_irqsave(lock, flags);	\
+		_spin_lock_irqsave(lock, &flags);	\
 	} while (0)
 #define read_lock_irqsave(lock, flags)			\
 	do {						\
 		typecheck(unsigned long, flags);	\
-		_read_lock_irqsave(lock, flags);	\
+		_read_lock_irqsave(lock, &flags);	\
 	} while (0)
 #define write_lock_irqsave(lock, flags)			\
 	do {						\
 		typecheck(unsigned long, flags);	\
-		_write_lock_irqsave(lock, flags);	\
+		_write_lock_irqsave(lock, &flags);	\
 	} while (0)
 #define spin_lock_irqsave_nested(lock, flags, subclass)	\
 	spin_lock_irqsave(lock, flags)
diff --git a/include/linux/spinlock_api_up.h b/include/linux/spinlock_api_up.h
index 04e1d31..432d4b6 100644
--- a/include/linux/spinlock_api_up.h
+++ b/include/linux/spinlock_api_up.h
@@ -48,34 +48,94 @@
 #define __UNLOCK_IRQRESTORE(lock, flags) \
   do { local_irq_restore(flags); __UNLOCK(lock); } while (0)
 
-#define _spin_lock(lock)			__LOCK(lock)
-#define _spin_lock_nested(lock, subclass)	__LOCK(lock)
-#define _read_lock(lock)			__LOCK(lock)
-#define _write_lock(lock)			__LOCK(lock)
-#define _spin_lock_bh(lock)			__LOCK_BH(lock)
-#define _read_lock_bh(lock)			__LOCK_BH(lock)
-#define _write_lock_bh(lock)			__LOCK_BH(lock)
-#define _spin_lock_irq(lock)			__LOCK_IRQ(lock)
-#define _read_lock_irq(lock)			__LOCK_IRQ(lock)
-#define _write_lock_irq(lock)			__LOCK_IRQ(lock)
-#define _spin_lock_irqsave(lock, flags)		__LOCK_IRQSAVE(lock, flags)
-#define _read_lock_irqsave(lock, flags)		__LOCK_IRQSAVE(lock, flags)
-#define _write_lock_irqsave(lock, flags)	__LOCK_IRQSAVE(lock, flags)
-#define _spin_trylock(lock)			({ __LOCK(lock); 1; })
-#define _read_trylock(lock)			({ __LOCK(lock); 1; })
-#define _write_trylock(lock)			({ __LOCK(lock); 1; })
-#define _spin_trylock_bh(lock)			({ __LOCK_BH(lock); 1; })
-#define _spin_unlock(lock)			__UNLOCK(lock)
-#define _read_unlock(lock)			__UNLOCK(lock)
-#define _write_unlock(lock)			__UNLOCK(lock)
-#define _spin_unlock_bh(lock)			__UNLOCK_BH(lock)
-#define _write_unlock_bh(lock)			__UNLOCK_BH(lock)
-#define _read_unlock_bh(lock)			__UNLOCK_BH(lock)
-#define _spin_unlock_irq(lock)			__UNLOCK_IRQ(lock)
-#define _read_unlock_irq(lock)			__UNLOCK_IRQ(lock)
-#define _write_unlock_irq(lock)			__UNLOCK_IRQ(lock)
-#define _spin_unlock_irqrestore(lock, flags)	__UNLOCK_IRQRESTORE(lock, flags)
-#define _read_unlock_irqrestore(lock, flags)	__UNLOCK_IRQRESTORE(lock, flags)
-#define _write_unlock_irqrestore(lock, flags)	__UNLOCK_IRQRESTORE(lock, flags)
+static inline void _spin_lock(spinlock_t *lock)
+{ __LOCK(lock); }
+
+static inline void _spin_lock_nested(spinlock_t *lock, int subclass)
+{ __LOCK(lock); }
+
+static inline void _read_lock(rwlock_t *lock)
+{ __LOCK(lock); }
+
+static inline void _write_lock(rwlock_t *lock)
+{ __LOCK(lock); }
+
+static inline void _spin_lock_bh(spinlock_t *lock)
+{ __LOCK_BH(lock); }
+
+static inline void _read_lock_bh(rwlock_t *lock)
+{ __LOCK_BH(lock); }
+
+static inline void _write_lock_bh(rwlock_t *lock)
+{ __LOCK_BH(lock); }
+
+static inline void _spin_lock_irq(spinlock_t *lock)
+{ __LOCK_IRQ(lock); }
+
+static inline void _read_lock_irq(rwlock_t *lock)
+{ __LOCK_IRQ(lock); }
+
+static inline void _write_lock_irq(rwlock_t *lock)
+{ __LOCK_IRQ(lock); }
+
+static inline void _spin_lock_irqsave(spinlock_t *lock, unsigned long *flags)
+{ __LOCK_IRQSAVE(lock, *flags); }
+
+static inline void _read_lock_irqsave(rwlock_t *lock, unsigned long *flags)
+{ __LOCK_IRQSAVE(lock, *flags); }
+
+static inline void _write_lock_irqsave(rwlock_t *lock, unsigned long *flags)
+{ __LOCK_IRQSAVE(lock, *flags); }
+
+static inline int _spin_trylock(spinlock_t *lock)
+{ __LOCK(lock); return 1; }
+
+static inline int _read_trylock(rwlock_t *lock)
+{ __LOCK(lock); return 1; }
+
+static inline int _write_trylock(rwlock_t *lock)
+{ __LOCK(lock); return 1; }
+
+static inline int _spin_trylock_bh(spinlock_t *lock)
+{ __LOCK_BH(lock); return 1; }
+
+static inline void _spin_unlock(spinlock_t *lock)
+{ __UNLOCK(lock); }
+
+static inline void _read_unlock(rwlock_t *lock)
+{ __UNLOCK(lock); }
+
+static inline void _write_unlock(rwlock_t *lock)
+{ __UNLOCK(lock); }
+
+static inline void _spin_unlock_bh(spinlock_t *lock)
+{ __UNLOCK_BH(lock); }
+
+static inline void _read_unlock_bh(rwlock_t *lock)
+{ __UNLOCK_BH(lock); }
+
+static inline void _write_unlock_bh(rwlock_t *lock)
+{ __UNLOCK_BH(lock); }
+
+static inline void _spin_unlock_irq(spinlock_t *lock)
+{ __UNLOCK_IRQ(lock); }
+
+static inline void _read_unlock_irq(rwlock_t *lock)
+{ __UNLOCK_IRQ(lock); }
+
+static inline void _write_unlock_irq(rwlock_t *lock)
+{ __UNLOCK_IRQ(lock); }
+
+static inline void _spin_unlock_irqrestore(spinlock_t *lock,
+					   unsigned long flags)
+{ __UNLOCK_IRQRESTORE(lock, flags); }
+
+static inline void _read_unlock_irqrestore(rwlock_t *lock,
+					   unsigned long flags)
+{ __UNLOCK_IRQRESTORE(lock, flags); }
+
+static inline void _write_unlock_irqrestore(rwlock_t *lock,
+					    unsigned long flags)
+{ __UNLOCK_IRQRESTORE(lock, flags); }
 
 #endif /* __LINUX_SPINLOCK_API_UP_H */
