Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbXEIIm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbXEIIm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbXEIImS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 04:42:18 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:34561 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbXEIImQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 04:42:16 -0400
From: Sripathi Kodi <sripathik@in.ibm.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Introduce write_trylock_irqsave
Date: Wed, 9 May 2007 14:11:54 +0530
User-Agent: KMail/1.9.5
Cc: akpm@osdl.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705091411.54774.sripathik@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to fix the BUG I mentioned here: 
http://lkml.org/lkml/2007/04/20/41. I noticed that an elegant way to solve 
this problem is to have a write_trylock_irqsave helper function. Since we 
don't have this now, the code in ptrace_attach  implements it using 
local_irq_disable and write_trylock. I wish to add write_trylock_irqsave to 
mainline kernel and then fix the -rt specific problem using this.

The patch below adds write_trylock_irqsave function.

Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>
---
 include/linux/spinlock.h         |    2 ++
 include/linux/spinlock_api_smp.h |    1 +
 include/linux/spinlock_api_up.h  |    2 ++
 kernel/spinlock.c                |   14 ++++++++++++++
 4 files changed, 19 insertions(+)

Index: linux-2.6.21/include/linux/spinlock.h
===================================================================
--- linux-2.6.21.orig/include/linux/spinlock.h
+++ linux-2.6.21/include/linux/spinlock.h
@@ -171,6 +171,8 @@ do {								\
 #define spin_trylock(lock)		__cond_lock(lock, _spin_trylock(lock))
 #define read_trylock(lock)		__cond_lock(lock, _read_trylock(lock))
 #define write_trylock(lock)		__cond_lock(lock, _write_trylock(lock))
+#define write_trylock_irqsave(lock, flags) \
+		__cond_lock(lock, _write_trylock_irqsave(lock, flags))
 
 #define spin_lock(lock)			_spin_lock(lock)
 
Index: linux-2.6.21/include/linux/spinlock_api_smp.h
===================================================================
--- linux-2.6.21.orig/include/linux/spinlock_api_smp.h
+++ linux-2.6.21/include/linux/spinlock_api_smp.h
@@ -41,6 +41,7 @@ unsigned long __lockfunc _write_lock_irq
 int __lockfunc _spin_trylock(spinlock_t *lock);
 int __lockfunc _read_trylock(rwlock_t *lock);
 int __lockfunc _write_trylock(rwlock_t *lock);
+int __lockfunc _write_trylock_irqsave(rwlock_t *lock, unsigned long flags);
 int __lockfunc _spin_trylock_bh(spinlock_t *lock);
 void __lockfunc _spin_unlock(spinlock_t *lock)		__releases(lock);
 void __lockfunc _read_unlock(rwlock_t *lock)		__releases(lock);
Index: linux-2.6.21/include/linux/spinlock_api_up.h
===================================================================
--- linux-2.6.21.orig/include/linux/spinlock_api_up.h
+++ linux-2.6.21/include/linux/spinlock_api_up.h
@@ -64,6 +64,8 @@
 #define _spin_trylock(lock)			({ __LOCK(lock); 1; })
 #define _read_trylock(lock)			({ __LOCK(lock); 1; })
 #define _write_trylock(lock)			({ __LOCK(lock); 1; })
+#define _write_trylock_irqsave(lock, flags) \
+				({ __LOCK_IRQSAVE(lock, flags); 1; })
 #define _spin_trylock_bh(lock)			({ __LOCK_BH(lock); 1; })
 #define _spin_unlock(lock)			__UNLOCK(lock)
 #define _read_unlock(lock)			__UNLOCK(lock)
Index: linux-2.6.21/kernel/spinlock.c
===================================================================
--- linux-2.6.21.orig/kernel/spinlock.c
+++ linux-2.6.21/kernel/spinlock.c
@@ -60,6 +60,20 @@ int __lockfunc _write_trylock(rwlock_t *
 }
 EXPORT_SYMBOL(_write_trylock);
 
+int __lockfunc _write_trylock_irqsave(rwlock_t *lock, unsigned long flags)
+{
+	int ret;
+
+	local_irq_save(flags);
+	ret = _write_trylock(lock);
+	if (ret)
+		return ret;
+
+	local_irq_restore(flags);
+	return 0;
+}
+EXPORT_SYMBOL(_write_trylock_irqsave);
+
 /*
  * If lockdep is enabled then we use the non-preemption spin-ops
  * even on CONFIG_PREEMPT, because lockdep assumes that interrupts are
