Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab0BQLnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 06:43:06 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:61014 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab0BQLm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 06:42:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=PWGRGfoCI7pkEDd4an7lT7AeObTdD6tkg8I3hiC8D8B4ssx5+6ZiQwLE6JRvTib546
         56nRfGzr1IEMceLEicnY51Cl3H6LcfR1ksJqTT7Jnkbz8x2f+YpDS5x2g8X49NcShstH
         /fI+BTF2cjqpnhxaBEs9VPsqXgotAfJtFq20E=
From: Luca Barbieri <luca@luca-barbieri.com>
To: mingo@elte.hu
Cc: hpa@zytor.com, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 07/10] lib: move generic atomic64 to atomic64-impl.h
Date: Wed, 17 Feb 2010 12:42:39 +0100
Message-Id: <1266406962-17463-8-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
In-Reply-To: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the generic implementation of the atomic64 functions
from atomic64.c to atomic64-impl.h

This file will be reused by x86-32 for 386/486 support.

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
---
 include/asm-generic/atomic64-impl.h |  167 ++++++++++++++++++++++++++++++++
 include/asm-generic/atomic64.h      |   31 ++++--
 lib/atomic64.c                      |  183 +++--------------------------------
 3 files changed, 203 insertions(+), 178 deletions(-)
 create mode 100644 include/asm-generic/atomic64-impl.h

diff --git a/include/asm-generic/atomic64-impl.h b/include/asm-generic/atomic64-impl.h
new file mode 100644
index 0000000..a0a76f4
--- /dev/null
+++ b/include/asm-generic/atomic64-impl.h
@@ -0,0 +1,167 @@
+#ifndef _ASM_GENERIC_ATOMIC64_IMPL_H
+#define _ASM_GENERIC_ATOMIC64_IMPL_H
+
+#include <linux/spinlock.h>
+
+/*
+ * We use a hashed array of spinlocks to provide exclusive access
+ * to each atomic64_t variable.  Since this is expected to used on
+ * systems with small numbers of CPUs (<= 4 or so), we use a
+ * relatively small array of 16 spinlocks to avoid wasting too much
+ * memory on the spinlock array.
+ */
+#ifndef ATOMIC64_NR_LOCKS
+#define ATOMIC64_NR_LOCKS	16
+#endif
+
+/*
+ * Ensure each lock is in a separate cacheline.
+ */
+union generic_atomic64_lock {
+	spinlock_t lock;
+	char pad[L1_CACHE_BYTES];
+};
+
+extern union generic_atomic64_lock generic_atomic64_lock[ATOMIC64_NR_LOCKS] __cacheline_aligned_in_smp;
+
+static inline int init_generic_atomic64_lock(void)
+{
+	int i;
+
+	for (i = 0; i < ATOMIC64_NR_LOCKS; ++i)
+		spin_lock_init(&generic_atomic64_lock[i].lock);
+	return 0;
+}
+
+static inline spinlock_t *generic_atomic64_lock_addr(const atomic64_t *v)
+{
+	unsigned long addr = (unsigned long) v;
+
+	addr >>= L1_CACHE_SHIFT;
+	addr ^= (addr >> 8) ^ (addr >> 16);
+	return &generic_atomic64_lock[addr & (ATOMIC64_NR_LOCKS - 1)].lock;
+}
+
+long long generic_atomic64_read(const atomic64_t *v)
+{
+	unsigned long flags;
+	spinlock_t *lock = generic_atomic64_lock_addr(v);
+	long long val;
+
+	spin_lock_irqsave(lock, flags);
+	val = v->counter;
+	spin_unlock_irqrestore(lock, flags);
+	return val;
+}
+
+void generic_atomic64_set(atomic64_t *v, long long i)
+{
+	unsigned long flags;
+	spinlock_t *lock = generic_atomic64_lock_addr(v);
+
+	spin_lock_irqsave(lock, flags);
+	v->counter = i;
+	spin_unlock_irqrestore(lock, flags);
+}
+
+void generic_atomic64_add(long long a, atomic64_t *v)
+{
+	unsigned long flags;
+	spinlock_t *lock = generic_atomic64_lock_addr(v);
+
+	spin_lock_irqsave(lock, flags);
+	v->counter += a;
+	spin_unlock_irqrestore(lock, flags);
+}
+
+long long generic_atomic64_add_return(long long a, atomic64_t *v)
+{
+	unsigned long flags;
+	spinlock_t *lock = generic_atomic64_lock_addr(v);
+	long long val;
+
+	spin_lock_irqsave(lock, flags);
+	val = v->counter += a;
+	spin_unlock_irqrestore(lock, flags);
+	return val;
+}
+
+void generic_atomic64_sub(long long a, atomic64_t *v)
+{
+	unsigned long flags;
+	spinlock_t *lock = generic_atomic64_lock_addr(v);
+
+	spin_lock_irqsave(lock, flags);
+	v->counter -= a;
+	spin_unlock_irqrestore(lock, flags);
+}
+
+long long generic_atomic64_sub_return(long long a, atomic64_t *v)
+{
+	unsigned long flags;
+	spinlock_t *lock = generic_atomic64_lock_addr(v);
+	long long val;
+
+	spin_lock_irqsave(lock, flags);
+	val = v->counter -= a;
+	spin_unlock_irqrestore(lock, flags);
+	return val;
+}
+
+long long generic_atomic64_dec_if_positive(atomic64_t *v)
+{
+	unsigned long flags;
+	spinlock_t *lock = generic_atomic64_lock_addr(v);
+	long long val;
+
+	spin_lock_irqsave(lock, flags);
+	val = v->counter - 1;
+	if (val >= 0)
+		v->counter = val;
+	spin_unlock_irqrestore(lock, flags);
+	return val;
+}
+
+long long generic_atomic64_cmpxchg(atomic64_t *v, long long o, long long n)
+{
+	unsigned long flags;
+	spinlock_t *lock = generic_atomic64_lock_addr(v);
+	long long val;
+
+	spin_lock_irqsave(lock, flags);
+	val = v->counter;
+	if (val == o)
+		v->counter = n;
+	spin_unlock_irqrestore(lock, flags);
+	return val;
+}
+
+long long generic_atomic64_xchg(atomic64_t *v, long long new)
+{
+	unsigned long flags;
+	spinlock_t *lock = generic_atomic64_lock_addr(v);
+	long long val;
+
+	spin_lock_irqsave(lock, flags);
+	val = v->counter;
+	v->counter = new;
+	spin_unlock_irqrestore(lock, flags);
+	return val;
+}
+
+int generic_atomic64_add_unless(atomic64_t *v, long long a, long long u)
+{
+	unsigned long flags;
+	spinlock_t *lock = generic_atomic64_lock_addr(v);
+	int ret = 1;
+
+	spin_lock_irqsave(lock, flags);
+	if (v->counter != u) {
+		v->counter += a;
+		ret = 0;
+	}
+	spin_unlock_irqrestore(lock, flags);
+	return ret;
+}
+
+#endif /*  _ASM_GENERIC_ATOMIC64_IMPL_H  */
diff --git a/include/asm-generic/atomic64.h b/include/asm-generic/atomic64.h
index b18ce4f..d6775fd 100644
--- a/include/asm-generic/atomic64.h
+++ b/include/asm-generic/atomic64.h
@@ -18,16 +18,27 @@ typedef struct {
 
 #define ATOMIC64_INIT(i)	{ (i) }
 
-extern long long atomic64_read(const atomic64_t *v);
-extern void	 atomic64_set(atomic64_t *v, long long i);
-extern void	 atomic64_add(long long a, atomic64_t *v);
-extern long long atomic64_add_return(long long a, atomic64_t *v);
-extern void	 atomic64_sub(long long a, atomic64_t *v);
-extern long long atomic64_sub_return(long long a, atomic64_t *v);
-extern long long atomic64_dec_if_positive(atomic64_t *v);
-extern long long atomic64_cmpxchg(atomic64_t *v, long long o, long long n);
-extern long long atomic64_xchg(atomic64_t *v, long long new);
-extern int	 atomic64_add_unless(atomic64_t *v, long long a, long long u);
+extern long long generic_atomic64_read(const atomic64_t *v);
+extern void	 generic_atomic64_set(atomic64_t *v, long long i);
+extern void	 generic_atomic64_add(long long a, atomic64_t *v);
+extern long long generic_atomic64_add_return(long long a, atomic64_t *v);
+extern void	 generic_atomic64_sub(long long a, atomic64_t *v);
+extern long long generic_atomic64_sub_return(long long a, atomic64_t *v);
+extern long long generic_atomic64_dec_if_positive(atomic64_t *v);
+extern long long generic_atomic64_cmpxchg(atomic64_t *v, long long o, long long n);
+extern long long generic_atomic64_xchg(atomic64_t *v, long long new);
+extern int	 generic_atomic64_add_unless(atomic64_t *v, long long a, long long u);
+
+#define atomic64_read generic_atomic64_read
+#define atomic64_set generic_atomic64_set
+#define atomic64_add generic_atomic64_add
+#define atomic64_add_return generic_atomic64_add_return
+#define atomic64_sub generic_atomic64_sub
+#define atomic64_sub_return generic_atomic64_sub_return
+#define atomic64_dec_if_positive generic_atomic64_dec_if_positive
+#define atomic64_cmpxchg generic_atomic64_cmpxchg
+#define atomic64_xchg generic_atomic64_xchg
+#define atomic64_add_unless generic_atomic64_add_unless
 
 #define atomic64_add_negative(a, v)	(atomic64_add_return((a), (v)) < 0)
 #define atomic64_inc(v)			atomic64_add(1LL, (v))
diff --git a/lib/atomic64.c b/lib/atomic64.c
index 8bee16e..2565f63 100644
--- a/lib/atomic64.c
+++ b/lib/atomic64.c
@@ -16,171 +16,18 @@
 #include <linux/module.h>
 #include <asm/atomic.h>
 
-/*
- * We use a hashed array of spinlocks to provide exclusive access
- * to each atomic64_t variable.  Since this is expected to used on
- * systems with small numbers of CPUs (<= 4 or so), we use a
- * relatively small array of 16 spinlocks to avoid wasting too much
- * memory on the spinlock array.
- */
-#define NR_LOCKS	16
-
-/*
- * Ensure each lock is in a separate cacheline.
- */
-static union {
-	spinlock_t lock;
-	char pad[L1_CACHE_BYTES];
-} atomic64_lock[NR_LOCKS] __cacheline_aligned_in_smp;
-
-static inline spinlock_t *lock_addr(const atomic64_t *v)
-{
-	unsigned long addr = (unsigned long) v;
-
-	addr >>= L1_CACHE_SHIFT;
-	addr ^= (addr >> 8) ^ (addr >> 16);
-	return &atomic64_lock[addr & (NR_LOCKS - 1)].lock;
-}
-
-long long atomic64_read(const atomic64_t *v)
-{
-	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
-	long long val;
-
-	spin_lock_irqsave(lock, flags);
-	val = v->counter;
-	spin_unlock_irqrestore(lock, flags);
-	return val;
-}
-EXPORT_SYMBOL(atomic64_read);
-
-void atomic64_set(atomic64_t *v, long long i)
-{
-	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
-
-	spin_lock_irqsave(lock, flags);
-	v->counter = i;
-	spin_unlock_irqrestore(lock, flags);
-}
-EXPORT_SYMBOL(atomic64_set);
-
-void atomic64_add(long long a, atomic64_t *v)
-{
-	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
-
-	spin_lock_irqsave(lock, flags);
-	v->counter += a;
-	spin_unlock_irqrestore(lock, flags);
-}
-EXPORT_SYMBOL(atomic64_add);
-
-long long atomic64_add_return(long long a, atomic64_t *v)
-{
-	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
-	long long val;
-
-	spin_lock_irqsave(lock, flags);
-	val = v->counter += a;
-	spin_unlock_irqrestore(lock, flags);
-	return val;
-}
-EXPORT_SYMBOL(atomic64_add_return);
-
-void atomic64_sub(long long a, atomic64_t *v)
-{
-	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
-
-	spin_lock_irqsave(lock, flags);
-	v->counter -= a;
-	spin_unlock_irqrestore(lock, flags);
-}
-EXPORT_SYMBOL(atomic64_sub);
-
-long long atomic64_sub_return(long long a, atomic64_t *v)
-{
-	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
-	long long val;
-
-	spin_lock_irqsave(lock, flags);
-	val = v->counter -= a;
-	spin_unlock_irqrestore(lock, flags);
-	return val;
-}
-EXPORT_SYMBOL(atomic64_sub_return);
-
-long long atomic64_dec_if_positive(atomic64_t *v)
-{
-	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
-	long long val;
-
-	spin_lock_irqsave(lock, flags);
-	val = v->counter - 1;
-	if (val >= 0)
-		v->counter = val;
-	spin_unlock_irqrestore(lock, flags);
-	return val;
-}
-EXPORT_SYMBOL(atomic64_dec_if_positive);
-
-long long atomic64_cmpxchg(atomic64_t *v, long long o, long long n)
-{
-	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
-	long long val;
-
-	spin_lock_irqsave(lock, flags);
-	val = v->counter;
-	if (val == o)
-		v->counter = n;
-	spin_unlock_irqrestore(lock, flags);
-	return val;
-}
-EXPORT_SYMBOL(atomic64_cmpxchg);
-
-long long atomic64_xchg(atomic64_t *v, long long new)
-{
-	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
-	long long val;
-
-	spin_lock_irqsave(lock, flags);
-	val = v->counter;
-	v->counter = new;
-	spin_unlock_irqrestore(lock, flags);
-	return val;
-}
-EXPORT_SYMBOL(atomic64_xchg);
-
-int atomic64_add_unless(atomic64_t *v, long long a, long long u)
-{
-	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
-	int ret = 1;
-
-	spin_lock_irqsave(lock, flags);
-	if (v->counter != u) {
-		v->counter += a;
-		ret = 0;
-	}
-	spin_unlock_irqrestore(lock, flags);
-	return ret;
-}
-EXPORT_SYMBOL(atomic64_add_unless);
-
-static int init_atomic64_lock(void)
-{
-	int i;
-
-	for (i = 0; i < NR_LOCKS; ++i)
-		spin_lock_init(&atomic64_lock[i].lock);
-	return 0;
-}
-
-pure_initcall(init_atomic64_lock);
+#include <asm-generic/atomic64-impl.h>
+
+union generic_atomic64_lock generic_atomic64_lock[ATOMIC64_NR_LOCKS] __cacheline_aligned_in_smp;
+pure_initcall(init_generic_atomic64_lock);
+
+EXPORT_SYMBOL(generic_atomic64_read);
+EXPORT_SYMBOL(generic_atomic64_set);
+EXPORT_SYMBOL(generic_atomic64_add);
+EXPORT_SYMBOL(generic_atomic64_add_return);
+EXPORT_SYMBOL(generic_atomic64_sub);
+EXPORT_SYMBOL(generic_atomic64_sub_return);
+EXPORT_SYMBOL(generic_atomic64_dec_if_positive);
+EXPORT_SYMBOL(generic_atomic64_cmpxchg);
+EXPORT_SYMBOL(generic_atomic64_xchg);
+EXPORT_SYMBOL(generic_atomic64_add_unless);
-- 
1.6.6.1.476.g01ddb

