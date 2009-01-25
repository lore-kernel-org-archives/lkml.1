Return-Path: <linux-kernel-owner+w=401wt.eu-S1751487AbZAYUul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbZAYUul (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 15:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbZAYUu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 15:50:27 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:33977 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbZAYUu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 15:50:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:cc:subject;
        b=umv6GlZbZcpBfRXN+de66CUytxQBjXy6ZpM2/HFt0QmDKaxSXtwcMmypztLYMhi4fd
         Iaw845oLeTnbRTckwCkq2avRbi+/wNBV9PrJVcWyMz6H1bEcCuOyi7DVRfWzZbqsfwNi
         HMhL3I7ACC1D0F7/s7aAslMk4oCSX5eC5m/BE=
Message-ID: <497cd08f.0c11660a.33a7.ffffdf39@mx.google.com>
Date: Sun, 25 Jan 2009 12:50:23 -0800 (PST)
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mandeep Singh Baines <msb@google.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC][PATCH 2/2] add a counter for writers spinning on a rwlock
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a counter for writers that enter a rwlock slow path.
For example it can be useful for slow background tasks which perform some jobs
on the tasklist, such as the hung_task detector (kernel/hung_task.c).

It adds a inc/dec pair on the slow path and 4 bytes for each rwlocks, so the overhead
is not null.

Only x86 is supported for now, writers_spinning_lock() will return 0 on other archs (which
is perhaps not a good idea).

Comments?

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/Kconfig                          |    4 ++++
 arch/x86/Kconfig                      |    1 +
 arch/x86/include/asm/spinlock.h       |    5 +++++
 arch/x86/include/asm/spinlock_types.h |    1 +
 arch/x86/lib/rwlock_64.S              |   10 +++++++---
 include/linux/spinlock.h              |    7 +++++++
 6 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 550dab2..86c22e0 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -106,3 +106,7 @@ config HAVE_CLK
 	  The <linux/clk.h> calls support software clock gating and
 	  thus are a key power management tool on many systems.
 
+config HAVE_NB_WRITERS_SPINNING_LOCK
+	bool
+
+
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 967e114..0aeae17 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -40,6 +40,7 @@ config X86
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select USER_STACKTRACE_SUPPORT
+	select HAVE_NB_WRITERS_SPINNING_LOCK
 
 config ARCH_DEFCONFIG
 	string
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 139b424..d9ee21b 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -283,6 +283,11 @@ static inline int __raw_write_trylock(raw_rwlock_t *lock)
 	return 0;
 }
 
+static inline int __raw_writers_spinning_lock(raw_rwlock_t *lock)
+{
+	return lock->spinning_writers;
+}
+
 static inline void __raw_read_unlock(raw_rwlock_t *rw)
 {
 	asm volatile(LOCK_PREFIX "incl %0" :"+m" (rw->lock) : : "memory");
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index 845f81c..163e6de 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -13,6 +13,7 @@ typedef struct raw_spinlock {
 
 typedef struct {
 	unsigned int lock;
+	unsigned int spinning_writers;
 } raw_rwlock_t;
 
 #define __RAW_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
diff --git a/arch/x86/lib/rwlock_64.S b/arch/x86/lib/rwlock_64.S
index 05ea55f..9589b74 100644
--- a/arch/x86/lib/rwlock_64.S
+++ b/arch/x86/lib/rwlock_64.S
@@ -9,14 +9,18 @@
 ENTRY(__write_lock_failed)
 	CFI_STARTPROC
 	LOCK_PREFIX
+	incl 4(%rdi) /* add ourself as a spinning writer */
+1:	LOCK_PREFIX
 	addl $RW_LOCK_BIAS,(%rdi)
-1:	rep
+2:	rep
 	nop
 	cmpl $RW_LOCK_BIAS,(%rdi)
-	jne 1b
+	jne 2b
 	LOCK_PREFIX
 	subl $RW_LOCK_BIAS,(%rdi)
-	jnz  __write_lock_failed
+	jnz  1b
+	LOCK_PREFIX
+	decl 4(%rdi)
 	ret
 	CFI_ENDPROC
 END(__write_lock_failed)
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index e0c0fcc..8ce22af 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -121,6 +121,13 @@ do {								\
 
 #define spin_is_locked(lock)	__raw_spin_is_locked(&(lock)->raw_lock)
 
+#ifdef CONFIG_HAVE_NB_WRITERS_SPINNING_LOCK
+#define writers_spinning_lock(rwlock)				\
+	__raw_writers_spinning_lock(&(rwlock)->raw_lock)
+#else
+#define writers_spinning_lock(rwlock)	0
+#endif
+
 #ifdef CONFIG_GENERIC_LOCKBREAK
 #define spin_is_contended(lock) ((lock)->break_lock)
 #else
-- 
1.6.1


