Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512Ab0AaVMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab0AaVMW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 16:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299Ab0AaVMT
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 16:12:19 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:60138 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459Ab0AaVMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 16:12:18 -0500
X-Greylist: delayed 565 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Jan 2010 16:12:16 EST
Message-Id: <20100131210013.265317204@polymtl.ca>
References: <20100131205254.407214951@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 31 Jan 2010 15:52:55 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 1/3] Create spin lock/spin unlock with distinct memory barrier
Content-Disposition: inline; filename=spinlock-mb.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sun, 31 Jan 2010 21:00:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create the primitive family:

spin_lock__no_acquire
spin_unlock__no_release
spin_lock_irq__no_acquire
spin_unlock_irq__no_release

raw_spin_lock__no_acquire
raw_spin_unlock__no_release
raw_spin_lock_irq__no_acquire
raw_spin_unlock_irq__no_release

smp_acquire__after_spin_lock()
smp_release__before_spin_unlock()
smp_mb__after_spin_lock()
smp_mb__before_spin_unlock()

This family of locks permits to combine the acquire/release ordering implied by
the spin lock and full memory barriers placed just after spin lock and before
spin unlock. Combining these memory barriers permits to decrease the overhead.

The first user of these primitives is the scheduler code, where a full memory
barrier is wanted before and after runqueue data structure modifications so
these can be read safely by sys_membarrier without holding the rq lock.

Replacing the spin lock acquire/release barriers with these memory barriers
imply either no overhead (x86 spinlock atomic instruction already implies a full
mb) or some hopefully small overhead caused by the upgrade of the spinlock
acquire/release barriers to more heavyweight smp_mb().

The "generic" version of spinlock-mb.h declares both a mapping to standard
spinlocks and full memory barriers. Each architecture can specialize this header
following their own need and declare CONFIG_HAVE_SPINLOCK_MB to use their own
spinlock-mb.h. This initial implementation only specializes the x86
architecture.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Nicholas Miell <nmiell@comcast.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: mingo@elte.hu
CC: laijs@cn.fujitsu.com
CC: dipankar@in.ibm.com
CC: akpm@linux-foundation.org
CC: josh@joshtriplett.org
CC: dvhltc@us.ibm.com
CC: niv@us.ibm.com
CC: tglx@linutronix.de
CC: peterz@infradead.org
CC: Valdis.Kletnieks@vt.edu
CC: dhowells@redhat.com
---
 arch/x86/Kconfig                   |    1 +
 arch/x86/include/asm/spinlock-mb.h |   28 ++++++++++++++++++++++++++++
 include/asm-generic/spinlock-mb.h  |   27 +++++++++++++++++++++++++++
 include/linux/spinlock.h           |    6 ++++++
 init/Kconfig                       |    3 +++
 5 files changed, 65 insertions(+)

Index: linux-2.6-lttng/include/asm-generic/spinlock-mb.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-generic/spinlock-mb.h	2010-01-31 15:12:16.000000000 -0500
@@ -0,0 +1,27 @@
+#ifndef ASM_GENERIC_SPINLOCK_MB_H
+#define ASM_GENERIC_SPINLOCK_MB_H
+
+/*
+ * Generic spinlock-mb mappings. Use standard spinlocks with acquire/release
+ * semantics, and define the associated memory barriers as full memory barriers.
+ */
+
+#define spin_lock__no_acquire			spin_lock
+#define spin_unlock__no_release			spin_unlock
+
+#define spin_lock_irq__no_acquire		spin_lock_irq
+#define spin_unlock_irq__no_release		spin_unlock_irq
+
+#define raw_spin_lock__no_acquire		raw_spin_lock
+#define raw_spin_unlock__no_release		raw_spin_unlock
+
+#define raw_spin_lock_irq__no_acquire		raw_spin_lock_irq
+#define raw_spin_unlock_irq__no_release		raw_spin_unlock_irq
+
+#define smp_acquire__after_spin_lock()		do { } while (0)
+#define smp_release__before_spin_unlock()	do { } while (0)
+
+#define smp_mb__after_spin_lock()		smp_mb()
+#define smp_mb__before_spin_unlock()		smp_mb()
+
+#endif /* ASM_GENERIC_SPINLOCK_MB_H */
Index: linux-2.6-lttng/include/linux/spinlock.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/spinlock.h	2010-01-31 14:59:42.000000000 -0500
+++ linux-2.6-lttng/include/linux/spinlock.h	2010-01-31 15:00:40.000000000 -0500
@@ -393,4 +393,10 @@ extern int _atomic_dec_and_lock(atomic_t
 #define atomic_dec_and_lock(atomic, lock) \
 		__cond_lock(lock, _atomic_dec_and_lock(atomic, lock))
 
+#ifdef CONFIG_HAVE_SPINLOCK_MB
+# include <asm/spinlock-mb.h>
+#else
+# include <asm-generic/spinlock-mb.h>
+#endif
+
 #endif /* __LINUX_SPINLOCK_H */
Index: linux-2.6-lttng/arch/x86/include/asm/spinlock-mb.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/arch/x86/include/asm/spinlock-mb.h	2010-01-31 15:11:28.000000000 -0500
@@ -0,0 +1,28 @@
+#ifndef ASM_X86_SPINLOCK_MB_H
+#define ASM_X86_SPINLOCK_MB_H
+
+/*
+ * X86 spinlock-mb mappings. Use standard spinlocks with acquire/release
+ * semantics. Associated memory barriers are defined as no-ops, because the
+ * spinlock LOCK-prefixed atomic operations imply a full memory barrier.
+ */
+
+#define spin_lock__no_acquire			spin_lock
+#define spin_unlock__no_release			spin_unlock
+
+#define spin_lock_irq__no_acquire		spin_lock_irq
+#define spin_unlock_irq__no_release		spin_unlock_irq
+
+#define raw_spin_lock__no_acquire		raw_spin_lock
+#define raw_spin_unlock__no_release		raw_spin_unlock
+
+#define raw_spin_lock_irq__no_acquire		raw_spin_lock_irq
+#define raw_spin_unlock_irq__no_release		raw_spin_unlock_irq
+
+#define smp_acquire__after_spin_lock()		do { } while (0)
+#define smp_release__before_spin_unlock()	do { } while (0)
+
+#define smp_mb__after_spin_lock()		do { } while (0)
+#define smp_mb__before_spin_unlock()		do { } while (0)
+
+#endif /* ASM_X86_SPINLOCK_MB_H */
Index: linux-2.6-lttng/arch/x86/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/x86/Kconfig	2010-01-31 14:59:32.000000000 -0500
+++ linux-2.6-lttng/arch/x86/Kconfig	2010-01-31 15:01:09.000000000 -0500
@@ -55,6 +55,7 @@ config X86
 	select ANON_INODES
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
+	select HAVE_SPINLOCK_MB
 
 config OUTPUT_FORMAT
 	string
Index: linux-2.6-lttng/init/Kconfig
===================================================================
--- linux-2.6-lttng.orig/init/Kconfig	2010-01-31 14:59:42.000000000 -0500
+++ linux-2.6-lttng/init/Kconfig	2010-01-31 15:00:40.000000000 -0500
@@ -320,6 +320,9 @@ config AUDIT_TREE
 	depends on AUDITSYSCALL
 	select INOTIFY
 
+config HAVE_SPINLOCK_MB
+	def_bool n
+
 menu "RCU Subsystem"
 
 choice

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
