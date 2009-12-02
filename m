Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbZLBKrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbZLBKrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 05:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbZLBKrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 05:47:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:33610 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbZLBKrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 05:47:05 -0500
Date: Wed, 2 Dec 2009 10:45:36 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, npiggin@suse.de,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: npiggin@suse.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, jbeulich@novell.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       JBeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B0FF9AC0200007800022713@vpn.id2.novell.com>
References: <4B0FF9AC0200007800022713@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking, x86: Slightly shorten __ticket_spin_trylock()
Message-ID: <tip-133ec7a235160dd44cbd4d82fff65a9983331df9@git.kernel.org>
Git-Commit-ID: 133ec7a235160dd44cbd4d82fff65a9983331df9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  133ec7a235160dd44cbd4d82fff65a9983331df9
Gitweb:     http://git.kernel.org/tip/133ec7a235160dd44cbd4d82fff65a9983331df9
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Fri, 27 Nov 2009 15:09:16 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Dec 2009 11:11:11 +0100

locking, x86: Slightly shorten __ticket_spin_trylock()

Since the callers generally expect a boolean value, there's no
need to zero-extend the outcome of the comparison. It just
requires that all of x86' trylock implementations return bool
instead of int.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <4B0FF9AC0200007800022713@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/paravirt.h       |    4 ++--
 arch/x86/include/asm/paravirt_types.h |    2 +-
 arch/x86/include/asm/spinlock.h       |   17 ++++++++---------
 arch/x86/xen/spinlock.c               |    2 +-
 4 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index efb3899..5418dfd 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -753,9 +753,9 @@ static __always_inline void __raw_spin_lock_flags(struct raw_spinlock *lock,
 	PVOP_VCALL2(pv_lock_ops.spin_lock_flags, lock, flags);
 }
 
-static __always_inline int __raw_spin_trylock(struct raw_spinlock *lock)
+static __always_inline bool __raw_spin_trylock(struct raw_spinlock *lock)
 {
-	return PVOP_CALL1(int, pv_lock_ops.spin_trylock, lock);
+	return PVOP_CALL1(bool, pv_lock_ops.spin_trylock, lock);
 }
 
 static __always_inline void __raw_spin_unlock(struct raw_spinlock *lock)
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 9357473..e289f81 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -324,7 +324,7 @@ struct pv_lock_ops {
 	int (*spin_is_contended)(struct raw_spinlock *lock);
 	void (*spin_lock)(struct raw_spinlock *lock);
 	void (*spin_lock_flags)(struct raw_spinlock *lock, unsigned long flags);
-	int (*spin_trylock)(struct raw_spinlock *lock);
+	bool (*spin_trylock)(struct raw_spinlock *lock);
 	void (*spin_unlock)(struct raw_spinlock *lock);
 };
 
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 4e77853..f3db56f 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -77,9 +77,10 @@ static __always_inline void __ticket_spin_lock(raw_spinlock_t *lock)
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
@@ -88,12 +89,11 @@ static __always_inline int __ticket_spin_trylock(raw_spinlock_t *lock)
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
@@ -127,10 +127,10 @@ static __always_inline void __ticket_spin_lock(raw_spinlock_t *lock)
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
@@ -141,12 +141,11 @@ static __always_inline int __ticket_spin_trylock(raw_spinlock_t *lock)
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
@@ -190,7 +189,7 @@ static __always_inline void __raw_spin_lock(raw_spinlock_t *lock)
 	__ticket_spin_lock(lock);
 }
 
-static __always_inline int __raw_spin_trylock(raw_spinlock_t *lock)
+static __always_inline bool __raw_spin_trylock(raw_spinlock_t *lock)
 {
 	return __ticket_spin_trylock(lock);
 }
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 36a5141..5d2e67e 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -136,7 +136,7 @@ static int xen_spin_is_contended(struct raw_spinlock *lock)
 	return xl->spinners != 0;
 }
 
-static int xen_spin_trylock(struct raw_spinlock *lock)
+static bool xen_spin_trylock(struct raw_spinlock *lock)
 {
 	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
 	u8 old = 1;
