Return-Path: <linux-kernel-owner+w=401wt.eu-S933182AbYEAXvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933182AbYEAXvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932264AbYEAXvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:51:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41312 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764230AbYEAXvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:51:21 -0400
Date: Thu, 1 May 2008 19:51:18 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: akpm@osdl.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Hellwig <hch@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Adrian Bunk <bunk@kernel.org>
Subject: [PATCH] add typecheck on irqsave and friends for correct flags
Message-ID: <Pine.LNX.4.58.0805011946290.12785@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There has been several areas in the kernel where an int has been used
for flags in local_irq_save and friends instead of a long. This can
cause some hard to debug problems on some architectures.

This patch adds a typecheck inside the irqsave and restore functions
to flag these cases.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/irqflags.h |   52 ++++++++++++++++++++++++----------
 include/linux/spinlock.h |   71 ++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 92 insertions(+), 31 deletions(-)

Index: linux-compile.git/include/linux/irqflags.h
===================================================================
--- linux-compile.git.orig/include/linux/irqflags.h	2008-05-01 18:52:52.000000000 -0400
+++ linux-compile.git/include/linux/irqflags.h	2008-05-01 19:21:05.000000000 -0400
@@ -49,18 +49,24 @@
 	do { trace_hardirqs_on(); raw_local_irq_enable(); } while (0)
 #define local_irq_disable() \
 	do { raw_local_irq_disable(); trace_hardirqs_off(); } while (0)
-#define local_irq_save(flags) \
-	do { raw_local_irq_save(flags); trace_hardirqs_off(); } while (0)
+#define local_irq_save(flags)				\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		raw_local_irq_save(flags);		\
+		trace_hardirqs_off();			\
+	} while (0)

-#define local_irq_restore(flags)				\
-	do {							\
-		if (raw_irqs_disabled_flags(flags)) {		\
-			raw_local_irq_restore(flags);		\
-			trace_hardirqs_off();			\
-		} else {					\
-			trace_hardirqs_on();			\
-			raw_local_irq_restore(flags);		\
-		}						\
+
+#define local_irq_restore(flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		if (raw_irqs_disabled_flags(flags)) {	\
+			raw_local_irq_restore(flags);	\
+			trace_hardirqs_off();		\
+		} else {				\
+			trace_hardirqs_on();		\
+			raw_local_irq_restore(flags);	\
+		}					\
 	} while (0)
 #else /* !CONFIG_TRACE_IRQFLAGS_SUPPORT */
 /*
@@ -69,8 +75,16 @@
  */
 # define raw_local_irq_disable()	local_irq_disable()
 # define raw_local_irq_enable()		local_irq_enable()
-# define raw_local_irq_save(flags)	local_irq_save(flags)
-# define raw_local_irq_restore(flags)	local_irq_restore(flags)
+# define raw_local_irq_save(flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		local_irq_save(flags);			\
+	} while (0)
+# define raw_local_irq_restore(flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		local_irq_restore(flags);		\
+	} while (0)
 #endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */

 #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
@@ -80,7 +94,11 @@
 		raw_safe_halt();				\
 	} while (0)

-#define local_save_flags(flags)		raw_local_save_flags(flags)
+#define local_save_flags(flags)				\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		raw_local_save_flags(flags);		\
+	} while(0)

 #define irqs_disabled()						\
 ({								\
@@ -90,7 +108,11 @@
 	raw_irqs_disabled_flags(_flags);			\
 })

-#define irqs_disabled_flags(flags)	raw_irqs_disabled_flags(flags)
+#define irqs_disabled_flags(flags)		\
+({						\
+	typecheck(unsigned long, flags);	\
+	raw_irqs_disabled_flags(flags);		\
+})
 #endif		/* CONFIG_X86 */

 #endif
Index: linux-compile.git/include/linux/spinlock.h
===================================================================
--- linux-compile.git.orig/include/linux/spinlock.h	2008-05-01 16:58:58.000000000 -0400
+++ linux-compile.git/include/linux/spinlock.h	2008-05-01 19:16:21.000000000 -0400
@@ -191,23 +191,53 @@ do {								\

 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)

-#define spin_lock_irqsave(lock, flags)	flags = _spin_lock_irqsave(lock)
-#define read_lock_irqsave(lock, flags)	flags = _read_lock_irqsave(lock)
-#define write_lock_irqsave(lock, flags)	flags = _write_lock_irqsave(lock)
+#define spin_lock_irqsave(lock, flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		flags = _spin_lock_irqsave(lock);	\
+	} while (0)
+#define read_lock_irqsave(lock, flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		flags = _read_lock_irqsave(lock);	\
+	} while (0)
+#define write_lock_irqsave(lock, flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		flags = _write_lock_irqsave(lock);	\
+	} while (0)

 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-#define spin_lock_irqsave_nested(lock, flags, subclass) \
-	flags = _spin_lock_irqsave_nested(lock, subclass)
+#define spin_lock_irqsave_nested(lock, flags, subclass)			\
+	do {								\
+		typecheck(unsigned long, flags);			\
+		flags = _spin_lock_irqsave_nested(lock, subclass);	\
+	} while (0)
 #else
-#define spin_lock_irqsave_nested(lock, flags, subclass) \
-	flags = _spin_lock_irqsave(lock)
+#define spin_lock_irqsave_nested(lock, flags, subclass)			\
+	do {								\
+		typecheck(unsigned long, flags);			\
+		flags = _spin_lock_irqsave(lock);			\
+	} while (0)
 #endif

 #else

-#define spin_lock_irqsave(lock, flags)	_spin_lock_irqsave(lock, flags)
-#define read_lock_irqsave(lock, flags)	_read_lock_irqsave(lock, flags)
-#define write_lock_irqsave(lock, flags)	_write_lock_irqsave(lock, flags)
+#define spin_lock_irqsave(lock, flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		_spin_lock_irqsave(lock, flags);	\
+	} while (0)
+#define read_lock_irqsave(lock, flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		_read_lock_irqsave(lock, flags);	\
+	} while (0)
+#define write_lock_irqsave(lock, flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		_write_lock_irqsave(lock, flags);	\
+	} while (0)
 #define spin_lock_irqsave_nested(lock, flags, subclass)	\
 	spin_lock_irqsave(lock, flags)

@@ -260,16 +290,25 @@ do {						\
 } while (0)
 #endif

-#define spin_unlock_irqrestore(lock, flags) \
-					_spin_unlock_irqrestore(lock, flags)
+#define spin_unlock_irqrestore(lock, flags)		\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		_spin_unlock_irqrestore(lock, flags);	\
+	} while (0)
 #define spin_unlock_bh(lock)		_spin_unlock_bh(lock)

-#define read_unlock_irqrestore(lock, flags) \
-					_read_unlock_irqrestore(lock, flags)
+#define read_unlock_irqrestore(lock, flags)		\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		_read_unlock_irqrestore(lock, flags);	\
+	} while (0)
 #define read_unlock_bh(lock)		_read_unlock_bh(lock)

-#define write_unlock_irqrestore(lock, flags) \
-					_write_unlock_irqrestore(lock, flags)
+#define write_unlock_irqrestore(lock, flags)		\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		_write_unlock_irqrestore(lock, flags);	\
+	} while (0)
 #define write_unlock_bh(lock)		_write_unlock_bh(lock)

 #define spin_trylock_bh(lock)	__cond_lock(lock, _spin_trylock_bh(lock))

