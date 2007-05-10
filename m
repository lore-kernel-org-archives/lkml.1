Return-Path: <linux-kernel-owner+w=401wt.eu-S1760996AbXEJTCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760996AbXEJTCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757109AbXEJTC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:02:28 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:54325 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627AbXEJTC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:02:27 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Fri, 11 May 2007 00:31:03 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: linux-kernel@vger.kernel.org
cc: akpm@linux-foundation.org, mingo@elte.hu, sripathik@in.ibm.com
Subject: [PATCH -mm 1/2] Kill old write_trylock_irqsave()
Message-ID: <Pine.LNX.4.64.0705110029270.30531@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kill the old write_trylock_irqsave() implementation, as it is slower -- we can
do better with the new version. Also the older patch is more invasive and
inconsistent in style with the spin_trylock_irqsave() of mainline and -mm.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Sripathi Kodi <sripathik@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>

---

  include/linux/spinlock.h         |    2 --
  include/linux/spinlock_api_smp.h |    1 -
  include/linux/spinlock_api_up.h  |    2 --
  kernel/spinlock.c                |   14 --------------
  4 files changed, 19 deletions(-)

---

diff -ruNp a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
--- a/include/linux/spinlock_api_smp.h	2007-05-10 23:26:09.000000000 +0530
+++ b/include/linux/spinlock_api_smp.h	2007-05-10 23:34:25.000000000 +0530
@@ -41,7 +41,6 @@ unsigned long __lockfunc _write_lock_irq
  int __lockfunc _spin_trylock(spinlock_t *lock);
  int __lockfunc _read_trylock(rwlock_t *lock);
  int __lockfunc _write_trylock(rwlock_t *lock);
-int __lockfunc _write_trylock_irqsave(rwlock_t *lock, unsigned long flags);
  int __lockfunc _spin_trylock_bh(spinlock_t *lock);
  void __lockfunc _spin_unlock(spinlock_t *lock)		__releases(lock);
  void __lockfunc _read_unlock(rwlock_t *lock)		__releases(lock);
diff -ruNp a/include/linux/spinlock_api_up.h b/include/linux/spinlock_api_up.h
--- a/include/linux/spinlock_api_up.h	2007-05-10 23:26:09.000000000 +0530
+++ b/include/linux/spinlock_api_up.h	2007-05-10 23:34:11.000000000 +0530
@@ -64,8 +64,6 @@
  #define _spin_trylock(lock)			({ __LOCK(lock); 1; })
  #define _read_trylock(lock)			({ __LOCK(lock); 1; })
  #define _write_trylock(lock)			({ __LOCK(lock); 1; })
-#define _write_trylock_irqsave(lock, flags) \
-				({ __LOCK_IRQSAVE(lock, flags); 1; })
  #define _spin_trylock_bh(lock)			({ __LOCK_BH(lock); 1; })
  #define _spin_unlock(lock)			__UNLOCK(lock)
  #define _read_unlock(lock)			__UNLOCK(lock)
diff -ruNp a/include/linux/spinlock.h b/include/linux/spinlock.h
--- a/include/linux/spinlock.h	2007-05-10 23:26:09.000000000 +0530
+++ b/include/linux/spinlock.h	2007-05-10 23:33:41.000000000 +0530
@@ -171,8 +171,6 @@ do {								\
  #define spin_trylock(lock)		__cond_lock(lock, _spin_trylock(lock))
  #define read_trylock(lock)		__cond_lock(lock, _read_trylock(lock))
  #define write_trylock(lock)		__cond_lock(lock, _write_trylock(lock))
-#define write_trylock_irqsave(lock, flags) \
-		__cond_lock(lock, _write_trylock_irqsave(lock, flags))

  #define spin_lock(lock)			_spin_lock(lock)

diff -ruNp a/kernel/spinlock.c b/kernel/spinlock.c
--- a/kernel/spinlock.c	2007-05-10 23:26:09.000000000 +0530
+++ b/kernel/spinlock.c	2007-05-10 23:35:08.000000000 +0530
@@ -60,20 +60,6 @@ int __lockfunc _write_trylock(rwlock_t *
  }
  EXPORT_SYMBOL(_write_trylock);

-int __lockfunc _write_trylock_irqsave(rwlock_t *lock, unsigned long flags)
-{
-	int ret;
-
-	local_irq_save(flags);
-	ret = _write_trylock(lock);
-	if (ret)
-		return ret;
-
-	local_irq_restore(flags);
-	return 0;
-}
-EXPORT_SYMBOL(_write_trylock_irqsave);
-
  /*
   * If lockdep is enabled then we use the non-preemption spin-ops
   * even on CONFIG_PREEMPT, because lockdep assumes that interrupts are

