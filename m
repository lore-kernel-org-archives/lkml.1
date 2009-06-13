Return-Path: <linux-kernel-owner+w=401wt.eu-S1762126AbZFMHOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762126AbZFMHOW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 03:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758310AbZFMHNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 03:13:52 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:54465 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709AbZFMHNu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 03:13:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <18995.20685.227683.561827@cargo.ozlabs.ibm.com>
Date: Sat, 13 Jun 2009 17:10:05 +1000
From: Paul Mackerras <paulus@samba.org>
To: benh@kernel.crashing.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] lib: Provide generic atomic64_t implementation
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many processor architectures have no 64-bit atomic instructions, but
we need atomic64_t in order to support the perf_counter subsystem.

This adds an implementation of 64-bit atomic operations using hashed
spinlocks to provide atomicity.  For each atomic operation, the address
of the atomic64_t variable is hashed to an index into an array of 16
spinlocks.  That spinlock is taken (with interrupts disabled) around the
operation, which can then be coded non-atomically within the lock.

On UP, all the spinlock manipulation goes away and we simply disable
interrupts around each operation.  In fact gcc eliminates the whole
atomic64_lock variable as well.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
Linus, Andrew: OK if this goes in via the powerpc tree?

 include/asm-generic/atomic64.h |   42 ++++++++++
 lib/Kconfig                    |    6 ++
 lib/Makefile                   |    2 +
 lib/atomic64.c                 |  175 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 225 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/atomic64.h
 create mode 100644 lib/atomic64.c

diff --git a/include/asm-generic/atomic64.h b/include/asm-generic/atomic64.h
new file mode 100644
index 0000000..b18ce4f
--- /dev/null
+++ b/include/asm-generic/atomic64.h
@@ -0,0 +1,42 @@
+/*
+ * Generic implementation of 64-bit atomics using spinlocks,
+ * useful on processors that don't have 64-bit atomic instructions.
+ *
+ * Copyright © 2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#ifndef _ASM_GENERIC_ATOMIC64_H
+#define _ASM_GENERIC_ATOMIC64_H
+
+typedef struct {
+	long long counter;
+} atomic64_t;
+
+#define ATOMIC64_INIT(i)	{ (i) }
+
+extern long long atomic64_read(const atomic64_t *v);
+extern void	 atomic64_set(atomic64_t *v, long long i);
+extern void	 atomic64_add(long long a, atomic64_t *v);
+extern long long atomic64_add_return(long long a, atomic64_t *v);
+extern void	 atomic64_sub(long long a, atomic64_t *v);
+extern long long atomic64_sub_return(long long a, atomic64_t *v);
+extern long long atomic64_dec_if_positive(atomic64_t *v);
+extern long long atomic64_cmpxchg(atomic64_t *v, long long o, long long n);
+extern long long atomic64_xchg(atomic64_t *v, long long new);
+extern int	 atomic64_add_unless(atomic64_t *v, long long a, long long u);
+
+#define atomic64_add_negative(a, v)	(atomic64_add_return((a), (v)) < 0)
+#define atomic64_inc(v)			atomic64_add(1LL, (v))
+#define atomic64_inc_return(v)		atomic64_add_return(1LL, (v))
+#define atomic64_inc_and_test(v) 	(atomic64_inc_return(v) == 0)
+#define atomic64_sub_and_test(a, v)	(atomic64_sub_return((a), (v)) == 0)
+#define atomic64_dec(v)			atomic64_sub(1LL, (v))
+#define atomic64_dec_return(v)		atomic64_sub_return(1LL, (v))
+#define atomic64_dec_and_test(v)	(atomic64_dec_return((v)) == 0)
+#define atomic64_inc_not_zero(v) 	atomic64_add_unless((v), 1LL, 0LL)
+
+#endif  /*  _ASM_GENERIC_ATOMIC64_H  */
diff --git a/lib/Kconfig b/lib/Kconfig
index 9960be0..bb1326d 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -194,4 +194,10 @@ config DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
 config NLATTR
 	bool
 
+#
+# Generic 64-bit atomic support is selected if needed
+#
+config GENERIC_ATOMIC64
+       bool
+
 endmenu
diff --git a/lib/Makefile b/lib/Makefile
index 34c5c0e..8e9bcf9 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -95,6 +95,8 @@ obj-$(CONFIG_DMA_API_DEBUG) += dma-debug.o
 
 obj-$(CONFIG_GENERIC_CSUM) += checksum.o
 
+obj-$(CONFIG_GENERIC_ATOMIC64) += atomic64.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/atomic64.c b/lib/atomic64.c
new file mode 100644
index 0000000..c5e7255
--- /dev/null
+++ b/lib/atomic64.c
@@ -0,0 +1,175 @@
+/*
+ * Generic implementation of 64-bit atomics using spinlocks,
+ * useful on processors that don't have 64-bit atomic instructions.
+ *
+ * Copyright © 2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/types.h>
+#include <linux/cache.h>
+#include <linux/spinlock.h>
+#include <linux/init.h>
+#include <asm/atomic.h>
+
+/*
+ * We use a hashed array of spinlocks to provide exclusive access
+ * to each atomic64_t variable.  Since this is expected to used on
+ * systems with small numbers of CPUs (<= 4 or so), we use a
+ * relatively small array of 16 spinlocks to avoid wasting too much
+ * memory on the spinlock array.
+ */
+#define NR_LOCKS	16
+
+/*
+ * Ensure each lock is in a separate cacheline.
+ */
+static union {
+	spinlock_t lock;
+	char pad[L1_CACHE_BYTES];
+} atomic64_lock[NR_LOCKS] __cacheline_aligned_in_smp;
+
+static inline spinlock_t *lock_addr(const atomic64_t *v)
+{
+	unsigned long addr = (unsigned long) v;
+
+	addr >>= L1_CACHE_SHIFT;
+	addr ^= (addr >> 8) ^ (addr >> 16);
+	return &atomic64_lock[addr & (NR_LOCKS - 1)].lock;
+}
+
+long long atomic64_read(const atomic64_t *v)
+{
+	unsigned long flags;
+	spinlock_t *lock = lock_addr(v);
+	long long val;
+
+	spin_lock_irqsave(lock, flags);
+	val = v->counter;
+	spin_unlock_irqrestore(lock, flags);
+	return val;
+}
+
+void atomic64_set(atomic64_t *v, long long i)
+{
+	unsigned long flags;
+	spinlock_t *lock = lock_addr(v);
+
+	spin_lock_irqsave(lock, flags);
+	v->counter = i;
+	spin_unlock_irqrestore(lock, flags);
+}
+
+void atomic64_add(long long a, atomic64_t *v)
+{
+	unsigned long flags;
+	spinlock_t *lock = lock_addr(v);
+
+	spin_lock_irqsave(lock, flags);
+	v->counter += a;
+	spin_unlock_irqrestore(lock, flags);
+}
+
+long long atomic64_add_return(long long a, atomic64_t *v)
+{
+	unsigned long flags;
+	spinlock_t *lock = lock_addr(v);
+	long long val;
+
+	spin_lock_irqsave(lock, flags);
+	val = v->counter += a;
+	spin_unlock_irqrestore(lock, flags);
+	return val;
+}
+
+void atomic64_sub(long long a, atomic64_t *v)
+{
+	unsigned long flags;
+	spinlock_t *lock = lock_addr(v);
+
+	spin_lock_irqsave(lock, flags);
+	v->counter -= a;
+	spin_unlock_irqrestore(lock, flags);
+}
+
+long long atomic64_sub_return(long long a, atomic64_t *v)
+{
+	unsigned long flags;
+	spinlock_t *lock = lock_addr(v);
+	long long val;
+
+	spin_lock_irqsave(lock, flags);
+	val = v->counter -= a;
+	spin_unlock_irqrestore(lock, flags);
+	return val;
+}
+
+long long atomic64_dec_if_positive(atomic64_t *v)
+{
+	unsigned long flags;
+	spinlock_t *lock = lock_addr(v);
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
+long long atomic64_cmpxchg(atomic64_t *v, long long o, long long n)
+{
+	unsigned long flags;
+	spinlock_t *lock = lock_addr(v);
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
+long long atomic64_xchg(atomic64_t *v, long long new)
+{
+	unsigned long flags;
+	spinlock_t *lock = lock_addr(v);
+	long long val;
+
+	spin_lock_irqsave(lock, flags);
+	val = v->counter;
+	v->counter = new;
+	spin_unlock_irqrestore(lock, flags);
+	return val;
+}
+
+int atomic64_add_unless(atomic64_t *v, long long a, long long u)
+{
+	unsigned long flags;
+	spinlock_t *lock = lock_addr(v);
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
+static int init_atomic64_lock(void)
+{
+	int i;
+
+	for (i = 0; i < NR_LOCKS; ++i)
+		spin_lock_init(&atomic64_lock[i].lock);
+	return 0;
+}
+
+pure_initcall(init_atomic64_lock);
-- 
1.6.0.4

