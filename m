Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117AbZGVSMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbZGVSMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 14:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbZGVSMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 14:12:35 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:59223 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZGVSMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 14:12:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EfFHM4HbKIHySHOUasouuQWbDRlE0R/fZQSHq8JweDkxW4WWUPXZkIK0pQXQnr6jda
         Ahdiz3F9AZjbX9tzy6Yhvj8JeTcjYJSIAIBuNaiwmUWvn0oHg5vELzUiEqmwZNRyq2Ys
         q33f8T8rpMu+KNjx9v/p7HD9PS8bH9g7E4YK8=
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH v2] check spinlock_t/rwlock_t argument type on non-SMP builds
Date: Wed, 22 Jul 2009 19:11:35 +0100
Message-Id: <1248286295-8304-1-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090718121413.GE31007@elte.hu>
References: <20090718121413.GE31007@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When writing code for UP without CONFIG_DEBUG_SPINLOCK it's easy to get
the first argument to the spinlock/rwlock functions wrong. This is
because the parameter is not actually used in this configuration.

Typically you will only find out it's wrong
 * by rebuilding with CONFIG_SMP or CONFIG_DEBUG_SPINLOCK
 * after you've submitted your beautiful patch series.

The first means a long wait, and the latter is a bit late.

Change the intermediate macros into inline functions.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

The previous version of this patch achieved the typechecking by
explicitly calling typecheck() within the macros. This version, at the
behest of Ingo, turns the macros into proper C functions. One benefit of
this is that the compiler no longer complains about how net/ipv4/route.c
passes NULL into spinlock_xx()

I've made the functions static inline, so there should be minimal impact
on generated code (assuming the compiler is listening). I haven't done
any comparisons yet.

In an allyesconfig build, compiler warnings are unchanged. One
side-effect of this is that sparse (with -Wcontext) reports certain
locking errors against spinlock_api_up.h instead of the file containing
the function doing the spinlock call. For example:

  CHECK   kernel/rtmutex.c
kernel/rtmutex.c:149:5: warning: symbol 'max_lock_depth' was not declared. Should it be static?
kernel/rtmutex.c:291:2: warning: context imbalance in 'rt_mutex_adjust_prio_chain' - different lock contexts for basic block
kernel/rtmutex.c:675:3: warning: context imbalance in '__rt_mutex_slowlock' - unexpected unlock
kernel/rtmutex.c:1029:5: warning: context imbalance in 'rt_mutex_start_proxy_lock' - wrong count at exit
  CC      kernel/rtmutex.o

becomes...

  CHECK   kernel/rtmutex.c
kernel/rtmutex.c:149:5: warning: symbol 'max_lock_depth' was not declared. Should it be static?
kernel/rtmutex.c:291:2: warning: context imbalance in 'rt_mutex_adjust_prio_chain' - different lock contexts for basic block
include/linux/spinlock_api_up.h:103:3: warning: context imbalance in '__rt_mutex_slowlock' - unexpected unlock
kernel/rtmutex.c:1029:5: warning: context imbalance in 'rt_mutex_start_proxy_lock' - wrong count at exit
  CC      kernel/rtmutex.o

This might just be my version of sparse. I tried adding the __acquires()
tag to the inline functions, but sparse didn't behave any differently.

Ingo - is this what you were thinking of?


Thanks,

Dave.

---
 include/linux/spinlock.h        |    6 +-
 include/linux/spinlock_api_up.h |  118 +++++++++++++++++++++++++++++----------
 2 files changed, 92 insertions(+), 32 deletions(-)

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 252b245..6462de1 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -244,17 +244,17 @@ do {								\
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
index 04e1d31..ed9197d 100644
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
+{ __LOCK(lock); return 1; }
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
-- 
1.6.3.3

