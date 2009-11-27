Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZK0PJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZK0PJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 10:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbZK0PJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 10:09:09 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:10222 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbZK0PJI convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;3:1>);
	Fri, 27 Nov 2009 10:09:08 -0500
Message-Id: <4B0FF9AC0200007800022713@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 27 Nov 2009 15:09:16 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: slightly shorten __ticket_spin_trylock()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the callers generally expect a boolean value, there's no need to
zero-extend the outcome of the comparison. It just requires that all of
x86' trylock implementations return bool instead of int.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/paravirt.h       |    4 ++--
 arch/x86/include/asm/paravirt_types.h |    2 +-
 arch/x86/include/asm/spinlock.h       |   17 ++++++++---------
 arch/x86/xen/spinlock.c               |    2 +-
 4 files changed, 12 insertions(+), 13 deletions(-)

--- linux-2.6.32-rc8/arch/x86/include/asm/paravirt.h
+++ 2.6.32-rc8-x86-spin-trylock-simplify/arch/x86/include/asm/paravirt.h
@@ -753,9 +753,9 @@ static __always_inline void __raw_spin_l
 	PVOP_VCALL2(pv_lock_ops.spin_lock_flags, lock, flags);
 }
 
-static __always_inline int __raw_spin_trylock(struct raw_spinlock *lock)
+static __always_inline bool __raw_spin_trylock(struct raw_spinlock *lock)
 {
-	return PVOP_CALL1(int, pv_lock_ops.spin_trylock, lock);
+	return PVOP_CALL1(bool, pv_lock_ops.spin_trylock, lock);
 }
 
 static __always_inline void __raw_spin_unlock(struct raw_spinlock *lock)
--- linux-2.6.32-rc8/arch/x86/include/asm/paravirt_types.h
+++ 2.6.32-rc8-x86-spin-trylock-simplify/arch/x86/include/asm/paravirt_types.h
@@ -324,7 +324,7 @@ struct pv_lock_ops {
 	int (*spin_is_contended)(struct raw_spinlock *lock);
 	void (*spin_lock)(struct raw_spinlock *lock);
 	void (*spin_lock_flags)(struct raw_spinlock *lock, unsigned long flags);
-	int (*spin_trylock)(struct raw_spinlock *lock);
+	bool (*spin_trylock)(struct raw_spinlock *lock);
 	void (*spin_unlock)(struct raw_spinlock *lock);
 };
 
--- linux-2.6.32-rc8/arch/x86/include/asm/spinlock.h
+++ 2.6.32-rc8-x86-spin-trylock-simplify/arch/x86/include/asm/spinlock.h
@@ -77,9 +77,10 @@ static __always_inline void __ticket_spi
 		: "memory", "cc");
 }
 
-static __always_inline int __ticket_spin_trylock(raw_spinlock_t *lock)
+static __always_inline bool __ticket_spin_trylock(raw_spinlock_t *lock)
 {
-	int tmp, new;
+	int tmp;
+	union { int i; bool b; } new;
 
 	asm volatile("movzwl %2, %0\n\t"
 		     "cmpb %h0,%b0\n\t"
@@ -88,12 +89,11 @@ static __always_inline int __ticket_spin
 		     LOCK_PREFIX "cmpxchgw %w1,%2\n\t"
 		     "1:"
 		     "sete %b1\n\t"
-		     "movzbl %b1,%0\n\t"
 		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
 		     :
 		     : "memory", "cc");
 
-	return tmp;
+	return new.b;
 }
 
 static __always_inline void __ticket_spin_unlock(raw_spinlock_t *lock)
@@ -127,10 +127,10 @@ static __always_inline void __ticket_spi
 		     : "memory", "cc");
 }
 
-static __always_inline int __ticket_spin_trylock(raw_spinlock_t *lock)
+static __always_inline bool __ticket_spin_trylock(raw_spinlock_t *lock)
 {
 	int tmp;
-	int new;
+	union { int i; bool b; } new;
 
 	asm volatile("movl %2,%0\n\t"
 		     "movl %0,%1\n\t"
@@ -141,12 +141,11 @@ static __always_inline int __ticket_spin
 		     LOCK_PREFIX "cmpxchgl %1,%2\n\t"
 		     "1:"
 		     "sete %b1\n\t"
-		     "movzbl %b1,%0\n\t"
 		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
 		     :
 		     : "memory", "cc");
 
-	return tmp;
+	return new.b;
 }
 
 static __always_inline void __ticket_spin_unlock(raw_spinlock_t *lock)
@@ -190,7 +189,7 @@ static __always_inline void __raw_spin_l
 	__ticket_spin_lock(lock);
 }
 
-static __always_inline int __raw_spin_trylock(raw_spinlock_t *lock)
+static __always_inline bool __raw_spin_trylock(raw_spinlock_t *lock)
 {
 	return __ticket_spin_trylock(lock);
 }
--- linux-2.6.32-rc8/arch/x86/xen/spinlock.c
+++ 2.6.32-rc8-x86-spin-trylock-simplify/arch/x86/xen/spinlock.c
@@ -136,7 +136,7 @@ static int xen_spin_is_contended(struct 
 	return xl->spinners != 0;
 }
 
-static int xen_spin_trylock(struct raw_spinlock *lock)
+static bool xen_spin_trylock(struct raw_spinlock *lock)
 {
 	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
 	u8 old = 1;



