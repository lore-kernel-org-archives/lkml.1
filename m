Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbZLCKA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbZLCKA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 05:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbZLCKA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 05:00:58 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:34888 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386AbZLCKA6 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;6:1>);
	Thu, 3 Dec 2009 05:00:58 -0500
Message-Id: <4B179A6D0200007800023542@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 03 Dec 2009 10:01:01 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: slightly shorten __ticket_spin_trylock() (v2)
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

Don't use bool for the return type though - this is being frowned on
and presently doesn't work with the pv-ops patching macros.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

---
 arch/x86/include/asm/paravirt.h       |    4 ++--
 arch/x86/include/asm/paravirt_types.h |    2 +-
 arch/x86/include/asm/spinlock.h       |   12 +++++-------
 arch/x86/xen/spinlock.c               |    2 +-
 4 files changed, 9 insertions(+), 11 deletions(-)

--- linux-2.6.32-rc8/arch/x86/include/asm/paravirt.h	2009-11-20 14:10:50.000000000 +0100
+++ 2.6.32-rc8-x86-spin-trylock-simplify/arch/x86/include/asm/paravirt.h	2009-12-03 10:24:51.000000000 +0100
@@ -753,9 +753,9 @@ static __always_inline void __raw_spin_l
 	PVOP_VCALL2(pv_lock_ops.spin_lock_flags, lock, flags);
 }
 
-static __always_inline int __raw_spin_trylock(struct raw_spinlock *lock)
+static __always_inline u8 __raw_spin_trylock(struct raw_spinlock *lock)
 {
-	return PVOP_CALL1(int, pv_lock_ops.spin_trylock, lock);
+	return PVOP_CALL1(u8, pv_lock_ops.spin_trylock, lock);
 }
 
 static __always_inline void __raw_spin_unlock(struct raw_spinlock *lock)
--- linux-2.6.32-rc8/arch/x86/include/asm/paravirt_types.h	2009-11-20 14:10:50.000000000 +0100
+++ 2.6.32-rc8-x86-spin-trylock-simplify/arch/x86/include/asm/paravirt_types.h	2009-12-03 10:24:58.000000000 +0100
@@ -324,7 +324,7 @@ struct pv_lock_ops {
 	int (*spin_is_contended)(struct raw_spinlock *lock);
 	void (*spin_lock)(struct raw_spinlock *lock);
 	void (*spin_lock_flags)(struct raw_spinlock *lock, unsigned long flags);
-	int (*spin_trylock)(struct raw_spinlock *lock);
+	u8 (*spin_trylock)(struct raw_spinlock *lock);
 	void (*spin_unlock)(struct raw_spinlock *lock);
 };
 
--- linux-2.6.32-rc8/arch/x86/include/asm/spinlock.h	2009-09-10 00:13:59.000000000 +0200
+++ 2.6.32-rc8-x86-spin-trylock-simplify/arch/x86/include/asm/spinlock.h	2009-12-03 10:26:07.000000000 +0100
@@ -77,7 +77,7 @@ static __always_inline void __ticket_spi
 		: "memory", "cc");
 }
 
-static __always_inline int __ticket_spin_trylock(raw_spinlock_t *lock)
+static __always_inline u8 __ticket_spin_trylock(raw_spinlock_t *lock)
 {
 	int tmp, new;
 
@@ -88,12 +88,11 @@ static __always_inline int __ticket_spin
 		     LOCK_PREFIX "cmpxchgw %w1,%2\n\t"
 		     "1:"
 		     "sete %b1\n\t"
-		     "movzbl %b1,%0\n\t"
 		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
 		     :
 		     : "memory", "cc");
 
-	return tmp;
+	return new;
 }
 
 static __always_inline void __ticket_spin_unlock(raw_spinlock_t *lock)
@@ -127,7 +126,7 @@ static __always_inline void __ticket_spi
 		     : "memory", "cc");
 }
 
-static __always_inline int __ticket_spin_trylock(raw_spinlock_t *lock)
+static __always_inline u8 __ticket_spin_trylock(raw_spinlock_t *lock)
 {
 	int tmp;
 	int new;
@@ -141,12 +140,11 @@ static __always_inline int __ticket_spin
 		     LOCK_PREFIX "cmpxchgl %1,%2\n\t"
 		     "1:"
 		     "sete %b1\n\t"
-		     "movzbl %b1,%0\n\t"
 		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
 		     :
 		     : "memory", "cc");
 
-	return tmp;
+	return new;
 }
 
 static __always_inline void __ticket_spin_unlock(raw_spinlock_t *lock)
@@ -190,7 +188,7 @@ static __always_inline void __raw_spin_l
 	__ticket_spin_lock(lock);
 }
 
-static __always_inline int __raw_spin_trylock(raw_spinlock_t *lock)
+static __always_inline u8 __raw_spin_trylock(raw_spinlock_t *lock)
 {
 	return __ticket_spin_trylock(lock);
 }
--- linux-2.6.32-rc8/arch/x86/xen/spinlock.c	2009-11-20 14:10:51.000000000 +0100
+++ 2.6.32-rc8-x86-spin-trylock-simplify/arch/x86/xen/spinlock.c	2009-12-03 10:26:47.000000000 +0100
@@ -136,7 +136,7 @@ static int xen_spin_is_contended(struct 
 	return xl->spinners != 0;
 }
 
-static int xen_spin_trylock(struct raw_spinlock *lock)
+static u8 xen_spin_trylock(struct raw_spinlock *lock)
 {
 	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
 	u8 old = 1;


