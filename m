Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064AbZHRWnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbZHRWnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZHRWnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:43:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:59634 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbZHRWnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:43:00 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       linuxppc-dev@ozlabs.org, peterz@infradead.org, rostedt@goodmis.org
Subject: [PATCH] spinlock: __raw_spin_is_locked() should return true for UP
Date: Tue, 18 Aug 2009 17:42:23 -0500
Message-Id: <1250635343-32546-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason __raw_spin_is_locked() has been returning false for the
uni-processor, non-CONFIG_DEBUG_SPINLOCK.  The UP + CONFIG_DEBUG_SPINLOCK
handles this correctly.

Found this by enabling CONFIG_DEBUG_VM on PPC and hitting always hitting
a BUG_ON that was testing to make sure the pte_lock was held.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---

Linus, a fix for 2.6.31

 include/linux/spinlock_up.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/spinlock_up.h b/include/linux/spinlock_up.h
index d4841ed..2b372e0 100644
--- a/include/linux/spinlock_up.h
+++ b/include/linux/spinlock_up.h
@@ -57,7 +57,7 @@ static inline void __raw_spin_unlock(raw_spinlock_t *lock)
 #define __raw_write_unlock(lock)	do { (void)(lock); } while (0)
 
 #else /* DEBUG_SPINLOCK */
-#define __raw_spin_is_locked(lock)	((void)(lock), 0)
+#define __raw_spin_is_locked(lock)	((void)(lock), 1)
 /* for sched.c and kernel_lock.c: */
 # define __raw_spin_lock(lock)		do { (void)(lock); } while (0)
 # define __raw_spin_lock_flags(lock, flags)	do { (void)(lock); } while (0)
-- 
1.6.0.6

