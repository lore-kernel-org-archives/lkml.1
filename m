Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbZALLx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbZALLx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbZALLxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:53:47 -0500
Received: from styx.suse.cz ([82.119.242.94]:39406 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751350AbZALLxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:53:46 -0500
Date: Mon, 12 Jan 2009 12:53:45 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@xensource.com>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: remove byte locks
Message-ID: <alpine.LNX.1.10.0901121247430.5377@jikos.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove byte locks implementation, which was introduced by Jeremy in 
8efcbab6 ("paravirt: introduce a "lock-byte" spinlock implementation"), 
but turned out to be dead code that is not used by any in-kernel 
virtualization guest (Xen uses its own variant of spinlocks implementation 
and KVM is not planning to move to byte locks).

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 arch/x86/include/asm/paravirt.h      |    2 -
 arch/x86/include/asm/spinlock.h      |   66 +--------------------------------
 arch/x86/kernel/paravirt-spinlocks.c |   10 -----
 3 files changed, 2 insertions(+), 76 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index ba3e2ff..32bc6c2 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -1389,8 +1389,6 @@ static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
 void _paravirt_nop(void);
 #define paravirt_nop	((void *)_paravirt_nop)
 
-void paravirt_use_bytelocks(void);
-
 #ifdef CONFIG_SMP
 
 static inline int __raw_spin_is_locked(struct raw_spinlock *lock)
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index d17c919..2bd6b11 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -172,70 +172,8 @@ static inline int __ticket_spin_is_contended(raw_spinlock_t *lock)
 	return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) > 1;
 }
 
-#ifdef CONFIG_PARAVIRT
-/*
- * Define virtualization-friendly old-style lock byte lock, for use in
- * pv_lock_ops if desired.
- *
- * This differs from the pre-2.6.24 spinlock by always using xchgb
- * rather than decb to take the lock; this allows it to use a
- * zero-initialized lock structure.  It also maintains a 1-byte
- * contention counter, so that we can implement
- * __byte_spin_is_contended.
- */
-struct __byte_spinlock {
-	s8 lock;
-	s8 spinners;
-};
-
-static inline int __byte_spin_is_locked(raw_spinlock_t *lock)
-{
-	struct __byte_spinlock *bl = (struct __byte_spinlock *)lock;
-	return bl->lock != 0;
-}
-
-static inline int __byte_spin_is_contended(raw_spinlock_t *lock)
-{
-	struct __byte_spinlock *bl = (struct __byte_spinlock *)lock;
-	return bl->spinners != 0;
-}
-
-static inline void __byte_spin_lock(raw_spinlock_t *lock)
-{
-	struct __byte_spinlock *bl = (struct __byte_spinlock *)lock;
-	s8 val = 1;
-
-	asm("1: xchgb %1, %0\n"
-	    "   test %1,%1\n"
-	    "   jz 3f\n"
-	    "   " LOCK_PREFIX "incb %2\n"
-	    "2: rep;nop\n"
-	    "   cmpb $1, %0\n"
-	    "   je 2b\n"
-	    "   " LOCK_PREFIX "decb %2\n"
-	    "   jmp 1b\n"
-	    "3:"
-	    : "+m" (bl->lock), "+q" (val), "+m" (bl->spinners): : "memory");
-}
-
-static inline int __byte_spin_trylock(raw_spinlock_t *lock)
-{
-	struct __byte_spinlock *bl = (struct __byte_spinlock *)lock;
-	u8 old = 1;
-
-	asm("xchgb %1,%0"
-	    : "+m" (bl->lock), "+q" (old) : : "memory");
+#ifndef CONFIG_PARAVIRT
 
-	return old == 0;
-}
-
-static inline void __byte_spin_unlock(raw_spinlock_t *lock)
-{
-	struct __byte_spinlock *bl = (struct __byte_spinlock *)lock;
-	smp_wmb();
-	bl->lock = 0;
-}
-#else  /* !CONFIG_PARAVIRT */
 static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
 {
 	return __ticket_spin_is_locked(lock);
@@ -267,7 +205,7 @@ static __always_inline void __raw_spin_lock_flags(raw_spinlock_t *lock,
 	__raw_spin_lock(lock);
 }
 
-#endif	/* CONFIG_PARAVIRT */
+#endif
 
 static inline void __raw_spin_unlock_wait(raw_spinlock_t *lock)
 {
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index 95777b0..3a7c5a4 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -26,13 +26,3 @@ struct pv_lock_ops pv_lock_ops = {
 };
 EXPORT_SYMBOL(pv_lock_ops);
 
-void __init paravirt_use_bytelocks(void)
-{
-#ifdef CONFIG_SMP
-	pv_lock_ops.spin_is_locked = __byte_spin_is_locked;
-	pv_lock_ops.spin_is_contended = __byte_spin_is_contended;
-	pv_lock_ops.spin_lock = __byte_spin_lock;
-	pv_lock_ops.spin_trylock = __byte_spin_trylock;
-	pv_lock_ops.spin_unlock = __byte_spin_unlock;
-#endif
-}
-- 
1.6.0.2

