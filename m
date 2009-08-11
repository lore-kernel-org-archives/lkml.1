Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZHKSKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZHKSKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbZHKSKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:10:16 -0400
Received: from www.tglx.de ([62.245.132.106]:46146 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755353AbZHKSKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:10:11 -0400
Date: Tue, 11 Aug 2009 20:09:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Will Schmidt <will_schmidt@vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>
Subject: Re: [ANNOUNCE] 2.6.31-rc4-rt1
In-Reply-To: <1249500006.4365.86.camel@lexx>
Message-ID: <alpine.LFD.2.00.0908112005190.1283@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>  <alpine.LFD.2.00.0904081937191.21577@localhost.localdomain>  <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain>  <alpine.LFD.2.00.0904110003370.21577@localhost.localdomain> 
 <alpine.LFD.2.00.0904181204420.21577@localhost.localdomain>  <alpine.LFD.2.00.0904251500150.4529@localhost.localdomain>  <alpine.LFD.2.00.0904290036500.4529@localhost.localdomain>  <alpine.LFD.2.00.0905012348200.3375@localhost.localdomain> 
 <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain>  <alpine.LFD.2.00.0905221459030.3570@localhost.localdomain>  <alpine.LFD.2.00.0906101803210.3367@localhost.localdomain>  <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain> 
 <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain>  <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>  <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain>  <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain> 
 <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain> <1249500006.4365.86.camel@lexx>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-474308224-1250014150=:1283"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-474308224-1250014150=:1283
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 5 Aug 2009, Will Schmidt wrote:
> /test/willschm/linux-2.6.31-rtx/kernel/spinlock.c:103: error: implicit
> declaration of function ‘_raw_atomic_spin_relax’

Fix below. Thanks,

    tglx

-------
commit ffc969930727238b847176c203bdbe1f9dffe403
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Tue Aug 11 20:03:47 2009 +0200

    locks: Fix PREEMPT=y, LOCKBREAK=y, DEBUG_LOCK_ALLOC=n compile
    
    Should be folded back into the atomic lock conversion
    
    Reported-by: Will Schmidt <will_schmidt@vnet.ibm.com>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/kernel/lock-internals.h b/kernel/lock-internals.h
index 4f0bc8b..76f694c 100644
--- a/kernel/lock-internals.h
+++ b/kernel/lock-internals.h
@@ -9,8 +9,8 @@
  * (We do this in a function because inlining it would be excessive.)
  */
 
-#define BUILD_LOCK_OPS(op, locktype)					\
-void __lockfunc _##op##_lock(locktype##_t *lock)			\
+#define BUILD_LOCK_OPS(prefix, op, locktype)				\
+void __lockfunc _##prefix##_lock(locktype##_t *lock)			\
 {									\
 	for (;;) {							\
 		preempt_disable();					\
@@ -20,15 +20,15 @@ void __lockfunc _##op##_lock(locktype##_t *lock)			\
 									\
 		if (!(lock)->break_lock)				\
 			(lock)->break_lock = 1;				\
-		while (!op##_can_lock(lock) && (lock)->break_lock)	\
+		while (!prefix##_can_lock(lock) && (lock)->break_lock)	\
 			_raw_##op##_relax(&lock->raw_lock);		\
 	}								\
 	(lock)->break_lock = 0;						\
 }									\
 									\
-EXPORT_SYMBOL(_##op##_lock);						\
+EXPORT_SYMBOL(_##prefix##_lock);					\
 									\
-unsigned long __lockfunc _##op##_lock_irqsave(locktype##_t *lock)	\
+unsigned long __lockfunc _##prefix##_lock_irqsave(locktype##_t *lock)	\
 {									\
 	unsigned long flags;						\
 									\
@@ -42,23 +42,23 @@ unsigned long __lockfunc _##op##_lock_irqsave(locktype##_t *lock)	\
 									\
 		if (!(lock)->break_lock)				\
 			(lock)->break_lock = 1;				\
-		while (!op##_can_lock(lock) && (lock)->break_lock)	\
+		while (!prefix##_can_lock(lock) && (lock)->break_lock)	\
 			_raw_##op##_relax(&lock->raw_lock);		\
 	}								\
 	(lock)->break_lock = 0;						\
 	return flags;							\
 }									\
 									\
-EXPORT_SYMBOL(_##op##_lock_irqsave);					\
+EXPORT_SYMBOL(_##prefix##_lock_irqsave);				\
 									\
-void __lockfunc _##op##_lock_irq(locktype##_t *lock)			\
+void __lockfunc _##prefix##_lock_irq(locktype##_t *lock)		\
 {									\
-	_##op##_lock_irqsave(lock);					\
+	_##prefix##_lock_irqsave(lock);					\
 }									\
 									\
-EXPORT_SYMBOL(_##op##_lock_irq);					\
+EXPORT_SYMBOL(_##prefix##_lock_irq);					\
 									\
-void __lockfunc _##op##_lock_bh(locktype##_t *lock)			\
+void __lockfunc _##prefix##_lock_bh(locktype##_t *lock)			\
 {									\
 	unsigned long flags;						\
 									\
@@ -67,9 +67,9 @@ void __lockfunc _##op##_lock_bh(locktype##_t *lock)			\
 	/* irq-disabling. We use the generic preemption-aware	*/	\
 	/* function:						*/	\
 	/**/								\
-	flags = _##op##_lock_irqsave(lock);				\
+	flags = _##prefix##_lock_irqsave(lock);				\
 	local_bh_disable();						\
 	local_irq_restore(flags);					\
 }									\
 									\
-EXPORT_SYMBOL(_##op##_lock_bh)
+EXPORT_SYMBOL(_##prefix##_lock_bh)
diff --git a/kernel/rwlock.c b/kernel/rwlock.c
index 35460b3..eaf34c8 100644
--- a/kernel/rwlock.c
+++ b/kernel/rwlock.c
@@ -146,8 +146,8 @@ EXPORT_SYMBOL(_write_lock);
  *         _[read|write]_lock_irqsave()
  *         _[read|write]_lock_bh()
  */
-BUILD_LOCK_OPS(read, rwlock);
-BUILD_LOCK_OPS(write, rwlock);
+BUILD_LOCK_OPS(read, read, rwlock);
+BUILD_LOCK_OPS(write, write, rwlock);
 
 #endif /* CONFIG_PREEMPT */
 
diff --git a/kernel/spinlock.c b/kernel/spinlock.c
index 6a3c0c4..e3194d5 100644
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -100,7 +100,7 @@ EXPORT_SYMBOL(_atomic_spin_lock);
  *         _atomic_spin_lock_irqsave()
  *         _atomic_spin_lock_bh()
  */
-BUILD_LOCK_OPS(atomic_spin, atomic_spinlock);
+BUILD_LOCK_OPS(atomic_spin, spin, atomic_spinlock);
 
 #endif /* CONFIG_PREEMPT */
 

--8323328-474308224-1250014150=:1283--
