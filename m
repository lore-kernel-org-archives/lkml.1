Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbYBYEeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbYBYEeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 23:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbYBYEd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 23:33:59 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:21335 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753284AbYBYEd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 23:33:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2dRgPFrX4IPqjI4N1yNUGU902mpXWvqs6quCXO4Es/tSS1f2tY9cS+Xl3JHHYqyq7v3RuUM7S5rp3rACfFxOpmOLUDfzF+Dqxj1ige+wRNBjr1DQ0D5q0jh51gn4ml1dAwlXosqdd1as64Xakyhf2Ate7kfF1jl8/th0yzFDf3E=  ;
X-YMail-OSG: BXudVFwVM1nRm1XZpH7z3ZykqOQx2K2VqU.KLclF7eEUrHWPssaFkP7oBqf_DmD_EkyHtip8Rg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Peter Zijlstra <peterz@infradead.org>
Subject: [patch 2.6.25-rc3] lockdep:  add spin_lock_irq_nested()
Date: Sun, 24 Feb 2008 20:33:51 -0800
User-Agent: KMail/1.9.6
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, mingo@redhat.com
References: <200801181429.00485.david-b@pacbell.net> <1200904299.6341.2.camel@lappy> <200801211022.36312.david-b@pacbell.net>
In-Reply-To: <200801211022.36312.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802242033.52208.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >     ==> LOCKDEP feature is evidently missing:
> > >             spin_lock_irq_nested(lock_ptr, lock_class)
> > 
> > This rant is more lines than adding the API :-/ the reason for it not
> > being there is simple, it wasn't needed up until now.
> 
> I suspected that was the case, but for all I knew there was some
> religious objection. 

Does this look about right?  Or, I suppose it could just call
the _spin_lock_irqsave_nested() routine and discard the result.

- Dave

=========	 CUT HERE
Add new spin_lock_irq_nested() call, so that lockdep can work with the
code which uses spin_*_irq() calls that don't save/restore flags.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Against 2.6.25-rc3

 include/linux/spinlock.h         |    6 ++++++
 include/linux/spinlock_api_smp.h |    2 ++
 kernel/spinlock.c                |   21 +++++++++++++++++++--
 3 files changed, 27 insertions(+), 2 deletions(-)

--- a/include/linux/spinlock.h	2008-02-24 18:50:50.000000000 -0800
+++ b/include/linux/spinlock.h	2008-02-24 19:02:39.000000000 -0800
@@ -196,9 +196,13 @@ do {								\
 #define write_lock_irqsave(lock, flags)	flags = _write_lock_irqsave(lock)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
+#define spin_lock_irq_nested(lock, subclass) \
+	_spin_lock_irq_nested(lock, subclass)
 #define spin_lock_irqsave_nested(lock, flags, subclass) \
 	flags = _spin_lock_irqsave_nested(lock, subclass)
 #else
+#define spin_lock_irq_nested(lock, subclass) \
+	_spin_lock_irq(lock)
 #define spin_lock_irqsave_nested(lock, flags, subclass) \
 	flags = _spin_lock_irqsave(lock)
 #endif
@@ -208,6 +212,8 @@ do {								\
 #define spin_lock_irqsave(lock, flags)	_spin_lock_irqsave(lock, flags)
 #define read_lock_irqsave(lock, flags)	_read_lock_irqsave(lock, flags)
 #define write_lock_irqsave(lock, flags)	_write_lock_irqsave(lock, flags)
+#define spin_lock_irq_nested(lock, subclass) \
+	spin_lock_irq(lock)
 #define spin_lock_irqsave_nested(lock, flags, subclass)	\
 	spin_lock_irqsave(lock, flags)
 
--- a/include/linux/spinlock_api_smp.h	2008-02-24 18:50:50.000000000 -0800
+++ b/include/linux/spinlock_api_smp.h	2008-02-24 19:02:39.000000000 -0800
@@ -28,6 +28,8 @@ void __lockfunc _spin_lock_bh(spinlock_t
 void __lockfunc _read_lock_bh(rwlock_t *lock)		__acquires(lock);
 void __lockfunc _write_lock_bh(rwlock_t *lock)		__acquires(lock);
 void __lockfunc _spin_lock_irq(spinlock_t *lock)	__acquires(lock);
+void __lockfunc _spin_lock_irq_nested(spinlock_t *lock, int subclass)
+							__acquires(lock);
 void __lockfunc _read_lock_irq(rwlock_t *lock)		__acquires(lock);
 void __lockfunc _write_lock_irq(rwlock_t *lock)		__acquires(lock);
 unsigned long __lockfunc _spin_lock_irqsave(spinlock_t *lock)
--- a/kernel/spinlock.c	2008-02-24 18:50:50.000000000 -0800
+++ b/kernel/spinlock.c	2008-02-24 19:02:39.000000000 -0800
@@ -290,8 +290,26 @@ void __lockfunc _spin_lock_nested(spinlo
 	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
-
 EXPORT_SYMBOL(_spin_lock_nested);
+
+void __lockfunc _spin_lock_irq_nested(spinlock_t *lock, int subclass)
+{
+	local_irq_disable();
+	preempt_disable();
+	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
+	/*
+	 * On lockdep we dont want the hand-coded irq-enable of
+	 * _raw_spin_lock_flags() code, because lockdep assumes
+	 * that interrupts are not re-enabled during lock-acquire:
+	 */
+#ifdef CONFIG_LOCKDEP
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+#else
+	_raw_spin_lock_flags(lock, &flags);
+#endif
+}
+EXPORT_SYMBOL(_spin_lock_irq_nested);
+
 unsigned long __lockfunc _spin_lock_irqsave_nested(spinlock_t *lock, int subclass)
 {
 	unsigned long flags;
@@ -311,7 +329,6 @@ unsigned long __lockfunc _spin_lock_irqs
 #endif
 	return flags;
 }
-
 EXPORT_SYMBOL(_spin_lock_irqsave_nested);
 
 #endif
