Return-Path: <linux-kernel-owner+w=401wt.eu-S1757674AbXEJGio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674AbXEJGio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 02:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbXEJGih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 02:38:37 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:36581 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092AbXEJGig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 02:38:36 -0400
From: Sripathi Kodi <sripathik@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PREEMPT_RT] [PATCH 1/2] Introduce write_trylock_irqsave
Date: Thu, 10 May 2007 12:07:48 +0530
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Roland McGrath <roland@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705101207.48906.sripathik@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I am trying to fix the BUG I mentioned here: 
http://lkml.org/lkml/2007/04/20/41. The problem arises because 
ptrace_attach() calls local_irq_disable() and write_trylock() and later calls 
write_unlock_irq. On -rt write_unlock_irq doesn't restore irqs for regular 
rwlock_t, so irqs remain disabled. I have also sent patches for mainline 
kernel. Please refer http://lkml.org/lkml/2007/05/09/76 , 
http://lkml.org/lkml/2007/05/09/79 and http://lkml.org/lkml/2007/05/09/550

This patch adds write_trylock_irqsave function.

Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>

Index: linux-2.6.21-rt1_patch/include/linux/spinlock.h
===================================================================
--- linux-2.6.21-rt1_patch.orig/include/linux/spinlock.h	2007-05-10 
11:28:35.000000000 +0530
+++ linux-2.6.21-rt1_patch/include/linux/spinlock.h	2007-05-10 
11:29:13.000000000 +0530
@@ -323,6 +323,7 @@
 
 # define _read_trylock(rwl)	rt_read_trylock(rwl)
 # define _write_trylock(rwl)	rt_write_trylock(rwl)
+#define _write_trylock_irqsave(rwl, flags)  rt_write_trylock_irqsave(rwl, 
flags)
 
 # define _read_lock(rwl)	rt_read_lock(rwl)
 # define _write_lock(rwl)	rt_write_lock(rwl)
@@ -398,6 +399,19 @@
 	else __bad_rwlock_type();					\
 } while (0)
 
+#define PICK_RW_OP2_RET(optype, op, lock, flags)			\
+({									\
+	unsigned long __ret;						\
+									\
+	if (TYPE_EQUAL((lock), raw_rwlock_t))				\
+		__ret = __##optype##op((raw_rwlock_t *)(lock), flags);	\
+	else if (TYPE_EQUAL(lock, rwlock_t))				\
+		__ret = _##optype##op((rwlock_t *)(lock), flags);	\
+	else __bad_rwlock_type();					\
+									\
+	__ret;								\
+})
+
 #ifdef CONFIG_DEBUG_SPINLOCK
   extern void __raw_spin_lock_init(raw_spinlock_t *lock, const char *name,
 				   struct lock_class_key *key);
@@ -473,6 +487,9 @@
 //#define write_trylock(lock)	_write_trylock(lock)
 #define write_trylock(lock)	__cond_lock(lock, PICK_RW_OP_RET(write, _trylock, 
lock))
 
+#define write_trylock_irqsave(lock, flags) \
+	__cond_lock(lock, PICK_RW_OP2_RET(write, _trylock_irqsave, lock, &flags))
+
 #define __spin_can_lock(lock)	__raw_spin_can_lock(&(lock)->raw_lock)
 #define __read_can_lock(lock)	__raw_read_can_lock(&(lock)->raw_lock)
 #define __write_can_lock(lock)	__raw_write_can_lock(&(lock)->raw_lock)
Index: linux-2.6.21-rt1_patch/include/linux/spinlock_api_smp.h
===================================================================
--- linux-2.6.21-rt1_patch.orig/include/linux/spinlock_api_smp.h	2007-05-10 
11:28:35.000000000 +0530
+++ linux-2.6.21-rt1_patch/include/linux/spinlock_api_smp.h	2007-05-10 
11:29:13.000000000 +0530
@@ -48,6 +48,8 @@
 __spin_trylock_irqsave(raw_spinlock_t *lock, unsigned long *flags);
 int __lockfunc __read_trylock(raw_rwlock_t *lock);
 int __lockfunc __write_trylock(raw_rwlock_t *lock);
+int __lockfunc
+__write_trylock_irqsave(raw_rwlock_t *lock, unsigned long *flags);
 int __lockfunc __spin_trylock_bh(raw_spinlock_t *lock);
 int __lockfunc __spin_trylock_irq(raw_spinlock_t *lock);
 void __lockfunc __spin_unlock(raw_spinlock_t *lock)		RELEASE_SPIN;
Index: linux-2.6.21-rt1_patch/include/linux/spinlock_api_up.h
===================================================================
--- linux-2.6.21-rt1_patch.orig/include/linux/spinlock_api_up.h	2007-05-10 
11:28:35.000000000 +0530
+++ linux-2.6.21-rt1_patch/include/linux/spinlock_api_up.h	2007-05-10 
11:29:13.000000000 +0530
@@ -41,6 +41,8 @@
 
 #define __spin_trylock_irqsave(lock, flags)	__TRYLOCK_IRQSAVE(lock, flags)
 
+#define __write_trylock_irqsave(lock, flags)	__TRYLOCK_IRQSAVE(lock, flags)
+
 #define __UNLOCK(lock) \
   do { preempt_enable(); __release(lock); (void)(lock); } while (0)
 
Index: linux-2.6.21-rt1_patch/kernel/rt.c
===================================================================
--- linux-2.6.21-rt1_patch.orig/kernel/rt.c	2007-05-10 11:28:35.000000000 
+0530
+++ linux-2.6.21-rt1_patch/kernel/rt.c	2007-05-10 11:29:13.000000000 +0530
@@ -173,6 +173,12 @@
 }
 EXPORT_SYMBOL(rt_write_trylock);
 
+int __lockfunc rt_write_trylock_irqsave(rwlock_t *rwlock, unsigned long 
*flags)
+{
+	*flags = 0;
+	return rt_write_trylock(rwlock);
+}
+
 int __lockfunc rt_read_trylock(rwlock_t *rwlock)
 {
 	struct rt_mutex *lock = &rwlock->lock;
Index: linux-2.6.21-rt1_patch/kernel/spinlock.c
===================================================================
--- linux-2.6.21-rt1_patch.orig/kernel/spinlock.c	2007-05-10 
11:28:35.000000000 +0530
+++ linux-2.6.21-rt1_patch/kernel/spinlock.c	2007-05-10 11:29:13.000000000 
+0530
@@ -97,6 +97,20 @@
 }
 EXPORT_SYMBOL(__write_trylock);
 
+int __lockfunc __write_trylock_irqsave(raw_rwlock_t *lock, unsigned long 
*flags)
+{
+	int ret;
+
+	local_irq_save(*flags);
+	ret = __write_trylock(lock);
+	if (ret)
+		return ret;
+
+	local_irq_restore(*flags);
+	return 0;
+}
+EXPORT_SYMBOL(__write_trylock_irqsave);
+
 /*
  * If lockdep is enabled then we use the non-preemption spin-ops
  * even on CONFIG_PREEMPT, because lockdep assumes that interrupts are
