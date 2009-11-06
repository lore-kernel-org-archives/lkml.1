Return-Path: <linux-kernel-owner+w=401wt.eu-S933205AbZKFWmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205AbZKFWmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:42:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933191AbZKFWmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:42:03 -0500
Received: from www.tglx.de ([62.245.132.106]:54022 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932922AbZKFWl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:41:56 -0500
Message-Id: <20091106223806.721945005@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 06 Nov 2009 22:41:39 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [patch 08/16] sparc: Make atomic locks raw
References: <20091106223547.784916750@linutronix.de>
Content-Disposition: inline; filename=sparc-make-atomic-locks-raw.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCKED is deprecated and the locks which protect the
atomic operations have no dependency on other locks and the code is
well tested so the conversion to a raw lock is safe.

Make the lock array static while at it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
---
 arch/sparc/lib/atomic32.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

Index: linux-2.6/arch/sparc/lib/atomic32.c
===================================================================
--- linux-2.6.orig/arch/sparc/lib/atomic32.c
+++ linux-2.6/arch/sparc/lib/atomic32.c
@@ -15,8 +15,8 @@
 #define ATOMIC_HASH_SIZE	4
 #define ATOMIC_HASH(a)	(&__atomic_hash[(((unsigned long)a)>>8) & (ATOMIC_HASH_SIZE-1)])
 
-spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] = {
-	[0 ... (ATOMIC_HASH_SIZE-1)] = SPIN_LOCK_UNLOCKED
+static raw_spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] = {
+	[0 ... (ATOMIC_HASH_SIZE-1)] = __RAW_SPIN_LOCK_UNLOCKED
 };
 
 #else /* SMP */
@@ -31,11 +31,11 @@ int __atomic_add_return(int i, atomic_t 
 {
 	int ret;
 	unsigned long flags;
-	spin_lock_irqsave(ATOMIC_HASH(v), flags);
+	__raw_spin_lock_irqsave(ATOMIC_HASH(v), flags);
 
 	ret = (v->counter += i);
 
-	spin_unlock_irqrestore(ATOMIC_HASH(v), flags);
+	__raw_spin_unlock_irqrestore(ATOMIC_HASH(v), flags);
 	return ret;
 }
 EXPORT_SYMBOL(__atomic_add_return);
@@ -45,12 +45,12 @@ int atomic_cmpxchg(atomic_t *v, int old,
 	int ret;
 	unsigned long flags;
 
-	spin_lock_irqsave(ATOMIC_HASH(v), flags);
+	__raw_spin_lock_irqsave(ATOMIC_HASH(v), flags);
 	ret = v->counter;
 	if (likely(ret == old))
 		v->counter = new;
 
-	spin_unlock_irqrestore(ATOMIC_HASH(v), flags);
+	__raw_spin_unlock_irqrestore(ATOMIC_HASH(v), flags);
 	return ret;
 }
 EXPORT_SYMBOL(atomic_cmpxchg);
@@ -60,11 +60,11 @@ int atomic_add_unless(atomic_t *v, int a
 	int ret;
 	unsigned long flags;
 
-	spin_lock_irqsave(ATOMIC_HASH(v), flags);
+	__raw_spin_lock_irqsave(ATOMIC_HASH(v), flags);
 	ret = v->counter;
 	if (ret != u)
 		v->counter += a;
-	spin_unlock_irqrestore(ATOMIC_HASH(v), flags);
+	__raw_spin_unlock_irqrestore(ATOMIC_HASH(v), flags);
 	return ret != u;
 }
 EXPORT_SYMBOL(atomic_add_unless);
@@ -74,9 +74,9 @@ void atomic_set(atomic_t *v, int i)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(ATOMIC_HASH(v), flags);
+	__raw_spin_lock_irqsave(ATOMIC_HASH(v), flags);
 	v->counter = i;
-	spin_unlock_irqrestore(ATOMIC_HASH(v), flags);
+	__raw_spin_unlock_irqrestore(ATOMIC_HASH(v), flags);
 }
 EXPORT_SYMBOL(atomic_set);
 
@@ -84,10 +84,10 @@ unsigned long ___set_bit(unsigned long *
 {
 	unsigned long old, flags;
 
-	spin_lock_irqsave(ATOMIC_HASH(addr), flags);
+	__raw_spin_lock_irqsave(ATOMIC_HASH(addr), flags);
 	old = *addr;
 	*addr = old | mask;
-	spin_unlock_irqrestore(ATOMIC_HASH(addr), flags);
+	__raw_spin_unlock_irqrestore(ATOMIC_HASH(addr), flags);
 
 	return old & mask;
 }
@@ -97,10 +97,10 @@ unsigned long ___clear_bit(unsigned long
 {
 	unsigned long old, flags;
 
-	spin_lock_irqsave(ATOMIC_HASH(addr), flags);
+	__raw_spin_lock_irqsave(ATOMIC_HASH(addr), flags);
 	old = *addr;
 	*addr = old & ~mask;
-	spin_unlock_irqrestore(ATOMIC_HASH(addr), flags);
+	__raw_spin_unlock_irqrestore(ATOMIC_HASH(addr), flags);
 
 	return old & mask;
 }
@@ -110,10 +110,10 @@ unsigned long ___change_bit(unsigned lon
 {
 	unsigned long old, flags;
 
-	spin_lock_irqsave(ATOMIC_HASH(addr), flags);
+	__raw_spin_lock_irqsave(ATOMIC_HASH(addr), flags);
 	old = *addr;
 	*addr = old ^ mask;
-	spin_unlock_irqrestore(ATOMIC_HASH(addr), flags);
+	__raw_spin_unlock_irqrestore(ATOMIC_HASH(addr), flags);
 
 	return old & mask;
 }
@@ -124,10 +124,10 @@ unsigned long __cmpxchg_u32(volatile u32
 	unsigned long flags;
 	u32 prev;
 
-	spin_lock_irqsave(ATOMIC_HASH(ptr), flags);
+	__raw_spin_lock_irqsave(ATOMIC_HASH(ptr), flags);
 	if ((prev = *ptr) == old)
 		*ptr = new;
-	spin_unlock_irqrestore(ATOMIC_HASH(ptr), flags);
+	__raw_spin_unlock_irqrestore(ATOMIC_HASH(ptr), flags);
 
 	return (unsigned long)prev;
 }


