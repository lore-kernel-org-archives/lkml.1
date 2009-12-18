Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbZLRQBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbZLRQBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 11:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbZLRQBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 11:01:14 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:39923 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbZLRQBH convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;6:1>);
	Fri, 18 Dec 2009 11:01:07 -0500
Message-Id: <4B2BB5830200007800026AC7@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 18 Dec 2009 16:01:55 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: slightly shorten __ticket_spin_trylock() (v3)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the callers generally expect a boolean value, there's no need to
zero-extend the outcome of the comparison. It just requires that all
of x86' trylock implementations have their return type changed
accordingly.

v2: Don't use bool for the return type though - this is being frowned
on and presently doesn't work with the pv-ops patching macros.

v3: Keep the return value in %eax (or really, %al).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

---
 arch/x86/include/asm/paravirt.h       |    4 ++--
 arch/x86/include/asm/paravirt_types.h |    2 +-
 arch/x86/include/asm/spinlock.h       |   14 ++++++--------
 arch/x86/xen/spinlock.c               |    2 +-
 4 files changed, 10 insertions(+), 12 deletions(-)

--- linux-2.6.33-rc1/arch/x86/include/asm/paravirt.h	2009-12-18 16:05:40.000000000 +0100
+++ 2.6.33-rc1-x86-spin-trylock-simplify/arch/x86/include/asm/paravirt.h	2009-12-03 09:43:42.000000000 +0100
@@ -753,9 +753,9 @@ static __always_inline void arch_spin_lo
 	PVOP_VCALL2(pv_lock_ops.spin_lock_flags, lock, flags);
 }
 
-static __always_inline int arch_spin_trylock(struct arch_spinlock *lock)
+static __always_inline u8 arch_spin_trylock(struct arch_spinlock *lock)
 {
-	return PVOP_CALL1(int, pv_lock_ops.spin_trylock, lock);
+	return PVOP_CALL1(u8, pv_lock_ops.spin_trylock, lock);
 }
 
 static __always_inline void arch_spin_unlock(struct arch_spinlock *lock)
--- linux-2.6.33-rc1/arch/x86/include/asm/paravirt_types.h	2009-12-18 16:05:40.000000000 +0100
+++ 2.6.33-rc1-x86-spin-trylock-simplify/arch/x86/include/asm/paravirt_types.h	2009-12-03 09:43:50.000000000 +0100
@@ -324,7 +324,7 @@ struct pv_lock_ops {
 	int (*spin_is_contended)(struct arch_spinlock *lock);
 	void (*spin_lock)(struct arch_spinlock *lock);
 	void (*spin_lock_flags)(struct arch_spinlock *lock, unsigned long flags);
-	int (*spin_trylock)(struct arch_spinlock *lock);
+	u8 (*spin_trylock)(struct arch_spinlock *lock);
 	void (*spin_unlock)(struct arch_spinlock *lock);
 };
 
--- linux-2.6.33-rc1/arch/x86/include/asm/spinlock.h	2009-12-18 16:05:40.000000000 +0100
+++ 2.6.33-rc1-x86-spin-trylock-simplify/arch/x86/include/asm/spinlock.h	2009-12-10 15:30:52.000000000 +0100
@@ -77,7 +77,7 @@ static __always_inline void __ticket_spi
 		: "memory", "cc");
 }
 
-static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
+static __always_inline u8 __ticket_spin_trylock(arch_spinlock_t *lock)
 {
 	int tmp, new;
 
@@ -87,8 +87,7 @@ static __always_inline int __ticket_spin
 		     "jne 1f\n\t"
 		     LOCK_PREFIX "cmpxchgw %w1,%2\n\t"
 		     "1:"
-		     "sete %b1\n\t"
-		     "movzbl %b1,%0\n\t"
+		     "sete %b0\n\t"
 		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
 		     :
 		     : "memory", "cc");
@@ -127,7 +126,7 @@ static __always_inline void __ticket_spi
 		     : "memory", "cc");
 }
 
-static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
+static __always_inline u8 __ticket_spin_trylock(arch_spinlock_t *lock)
 {
 	int tmp;
 	int new;
@@ -140,9 +139,8 @@ static __always_inline int __ticket_spin
 		     "jne 1f\n\t"
 		     LOCK_PREFIX "cmpxchgl %1,%2\n\t"
 		     "1:"
-		     "sete %b1\n\t"
-		     "movzbl %b1,%0\n\t"
-		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
+		     "sete %b0\n\t"
+		     : "=&a" (tmp), "=&r" (new), "+m" (lock->slock)
 		     :
 		     : "memory", "cc");
 
@@ -190,7 +188,7 @@ static __always_inline void arch_spin_lo
 	__ticket_spin_lock(lock);
 }
 
-static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
+static __always_inline u8 arch_spin_trylock(arch_spinlock_t *lock)
 {
 	return __ticket_spin_trylock(lock);
 }
--- linux-2.6.33-rc1/arch/x86/xen/spinlock.c	2009-12-18 16:05:40.000000000 +0100
+++ 2.6.33-rc1-x86-spin-trylock-simplify/arch/x86/xen/spinlock.c	2009-12-03 09:44:33.000000000 +0100
@@ -136,7 +136,7 @@ static int xen_spin_is_contended(struct 
 	return xl->spinners != 0;
 }
 
-static int xen_spin_trylock(struct arch_spinlock *lock)
+static u8 xen_spin_trylock(struct arch_spinlock *lock)
 {
 	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
 	u8 old = 1;


