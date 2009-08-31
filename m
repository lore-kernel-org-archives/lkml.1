Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbZHaRLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbZHaRLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 13:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbZHaRLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 13:11:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:33042 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbZHaRLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 13:11:13 -0400
Date: Mon, 31 Aug 2009 17:08:20 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: mingo@redhat.com, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       schwidefsky@de.ibm.com, ehrhardt@linux.vnet.ibm.com, arnd@arndb.de,
       akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
       zippel@linux-m68k.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       hpa@zytor.com, paulus@samba.org, horsth@linux.vnet.ibm.com,
       davem@davemloft.net, benh@kernel.crashing.org, geert@linux-m68k.org,
       linux-arch@vger.kernel.org, mingo@elte.hu, nickpiggin@yahoo.com.au
Reply-To: mingo@redhat.com, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, schwidefsky@de.ibm.com,
       ehrhardt@linux.vnet.ibm.com, arnd@arndb.de, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, zippel@linux-m68k.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       horsth@linux.vnet.ibm.com, davem@davemloft.net,
       benh@kernel.crashing.org, geert@linux-m68k.org,
       linux-arch@vger.kernel.org, nickpiggin@yahoo.com.au, mingo@elte.hu
In-Reply-To: <20090831124418.848735034@de.ibm.com>
References: <20090831124418.848735034@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking: Simplify spinlock inlining
Message-ID: <tip-bb7bed082500179519c7caf0678ba3bed9752658@git.kernel.org>
Git-Commit-ID: bb7bed082500179519c7caf0678ba3bed9752658
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 31 Aug 2009 17:08:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bb7bed082500179519c7caf0678ba3bed9752658
Gitweb:     http://git.kernel.org/tip/bb7bed082500179519c7caf0678ba3bed9752658
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Mon, 31 Aug 2009 14:43:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 Aug 2009 18:08:51 +0200

locking: Simplify spinlock inlining

For !DEBUG_SPINLOCK && !PREEMPT && SMP the spin_unlock()
functions were always inlined by using special defines which
would call the __raw* functions.

The out-of-line variants for these functions would be generated
anyway.

Use the new per unlock/locking variant mechanism to force
inlining of the unlock functions like before. This is not a
functional change, we just get rid of one additional way to
force inlining.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Horst Hartmann <horsth@linux.vnet.ibm.com>
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: <linux-arch@vger.kernel.org>
LKML-Reference: <20090831124418.848735034@de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/spinlock.h         |   46 +++++---------------------------------
 include/linux/spinlock_api_smp.h |   12 ++++++++++
 2 files changed, 18 insertions(+), 40 deletions(-)

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index da76a06..f0ca7a7 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -259,50 +259,16 @@ static inline void smp_mb__after_lock(void) { smp_mb(); }
 
 #define spin_lock_irq(lock)		_spin_lock_irq(lock)
 #define spin_lock_bh(lock)		_spin_lock_bh(lock)
-
 #define read_lock_irq(lock)		_read_lock_irq(lock)
 #define read_lock_bh(lock)		_read_lock_bh(lock)
-
 #define write_lock_irq(lock)		_write_lock_irq(lock)
 #define write_lock_bh(lock)		_write_lock_bh(lock)
-
-/*
- * We inline the unlock functions in the nondebug case:
- */
-#if defined(CONFIG_DEBUG_SPINLOCK) || defined(CONFIG_PREEMPT) || \
-	!defined(CONFIG_SMP)
-# define spin_unlock(lock)		_spin_unlock(lock)
-# define read_unlock(lock)		_read_unlock(lock)
-# define write_unlock(lock)		_write_unlock(lock)
-# define spin_unlock_irq(lock)		_spin_unlock_irq(lock)
-# define read_unlock_irq(lock)		_read_unlock_irq(lock)
-# define write_unlock_irq(lock)		_write_unlock_irq(lock)
-#else
-# define spin_unlock(lock) \
-    do {__raw_spin_unlock(&(lock)->raw_lock); __release(lock); } while (0)
-# define read_unlock(lock) \
-    do {__raw_read_unlock(&(lock)->raw_lock); __release(lock); } while (0)
-# define write_unlock(lock) \
-    do {__raw_write_unlock(&(lock)->raw_lock); __release(lock); } while (0)
-# define spin_unlock_irq(lock)			\
-do {						\
-	__raw_spin_unlock(&(lock)->raw_lock);	\
-	__release(lock);			\
-	local_irq_enable();			\
-} while (0)
-# define read_unlock_irq(lock)			\
-do {						\
-	__raw_read_unlock(&(lock)->raw_lock);	\
-	__release(lock);			\
-	local_irq_enable();			\
-} while (0)
-# define write_unlock_irq(lock)			\
-do {						\
-	__raw_write_unlock(&(lock)->raw_lock);	\
-	__release(lock);			\
-	local_irq_enable();			\
-} while (0)
-#endif
+#define spin_unlock(lock)		_spin_unlock(lock)
+#define read_unlock(lock)		_read_unlock(lock)
+#define write_unlock(lock)		_write_unlock(lock)
+#define spin_unlock_irq(lock)		_spin_unlock_irq(lock)
+#define read_unlock_irq(lock)		_read_unlock_irq(lock)
+#define write_unlock_irq(lock)		_write_unlock_irq(lock)
 
 #define spin_unlock_irqrestore(lock, flags)		\
 	do {						\
diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index 1a411e3..7a7e18f 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -60,6 +60,18 @@ void __lockfunc _read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 							__releases(lock);
 
+/*
+ * We inline the unlock functions in the nondebug case:
+ */
+#if !defined(CONFIG_DEBUG_SPINLOCK) && !defined(CONFIG_PREEMPT)
+#define __always_inline__spin_unlock
+#define __always_inline__read_unlock
+#define __always_inline__write_unlock
+#define __always_inline__spin_unlock_irq
+#define __always_inline__read_unlock_irq
+#define __always_inline__write_unlock_irq
+#endif
+
 #ifndef CONFIG_DEBUG_SPINLOCK
 #ifndef CONFIG_GENERIC_LOCKBREAK
 
