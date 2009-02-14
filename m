Return-Path: <linux-kernel-owner+w=401wt.eu-S1757740AbZBNARV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740AbZBNARV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 19:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbZBNARM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 19:17:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:7810 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbZBNARK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 19:17:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=afSD3DRxB2uhFtfPV+WM/rOaLjTQCGw3lH09ZkoaETzEWWiJjun4SQQrY3XvwZM7DW
         s6fOkTFGvpMjsO31iDBKCsCOJBjUAHl1FusfCLl/q9TZssnmzAdTD5aivVBaT2LKgnrS
         tzqlmo/kf7dvLp8T3kCugjQjBtj2jjEyhZ/70=
Date: Sat, 14 Feb 2009 03:23:24 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, srostedt@redhat.com
Subject: irqflags.h changes
Message-ID: <20090214002324.GA22590@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, linux/irqflags.h defines local_irq_enable() and friends
through raw_* counterparts.

Sometimes it defines raw_* counterparts through local_irq_enable() and
friends.

I'm going to end this subtle joke and make on all archs:

	local_irq_enable()	via	raw_local_irq_enable()
	local_irq_disable()	via	raw_local_irq_disable()
	local_irq_save()	via	raw_local_irq_save()
	local_irq_restore()	via	raw_local_irq_restore() + stuff
	local_save_flags()	via	raw_local_save_flags()
	irqs_disabled()		via	raw_irqs_disabled_flags() + stuff

linux/irqflags.h will include asm/irqflags.h unconditionally.
Arches that don't have asm/irqflags.h will get it through extraction
from asm/system.h or whatever.

Users will just include <linux/irqflags.h>

Irq tracing will remain the same (it's nop depending on config option,
after all).

Typechecking will be preserved.

Compilation will be fixed.

And possibly changing some defines into static inlines.

OK?


All of this is orthogonal to irq_flags_t stuff, but I'd like to do this
first.

Below is patch for alpha and fallout:

 arch/alpha/include/asm/io.h      |    1 
 arch/alpha/include/asm/system.h  |    8 ---
 drivers/base/devres.c            |    1 
 drivers/input/joystick/gamecon.c |    1 
 include/linux/irqflags.h         |   81 +++++++++++++++------------------------
 include/linux/kfifo.h            |    1 
 include/linux/proportions.h      |    1 
 include/linux/spinlock_api_up.h  |    2 
 include/linux/spinlock_up.h      |    2 
 kernel/notifier.c                |    1 
 kernel/params.c                  |    1 
 kernel/smp.c                     |    1 
 lib/idr.c                        |    1 
 lib/ratelimit.c                  |    1 
 mm/internal.h                    |    1 
 mm/page_isolation.c              |    2 
 16 files changed, 49 insertions(+), 57 deletions(-)

diff --git a/arch/alpha/include/asm/io.h b/arch/alpha/include/asm/io.h
index eda9b90..b435d35 100644
--- a/arch/alpha/include/asm/io.h
+++ b/arch/alpha/include/asm/io.h
@@ -3,6 +3,7 @@
 
 #ifdef __KERNEL__
 
+#include <linux/irqflags.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <asm/compiler.h>
diff --git a/arch/alpha/include/asm/system.h b/arch/alpha/include/asm/system.h
index afe20fa..6384be8 100644
--- a/arch/alpha/include/asm/system.h
+++ b/arch/alpha/include/asm/system.h
@@ -279,14 +279,6 @@ extern int __min_ipl;
 #define getipl()		(rdps() & 7)
 #define setipl(ipl)		((void) swpipl(ipl))
 
-#define local_irq_disable()			do { setipl(IPL_MAX); barrier(); } while(0)
-#define local_irq_enable()			do { barrier(); setipl(IPL_MIN); } while(0)
-#define local_save_flags(flags)	((flags) = rdps())
-#define local_irq_save(flags)	do { (flags) = swpipl(IPL_MAX); barrier(); } while(0)
-#define local_irq_restore(flags)	do { barrier(); setipl(flags); barrier(); } while(0)
-
-#define irqs_disabled()	(getipl() == IPL_MAX)
-
 /*
  * TB routines..
  */
diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index e8beb8e..a145055 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/irqflags.h>
 #include <linux/module.h>
 
 #include "base.h"
diff --git a/drivers/input/joystick/gamecon.c b/drivers/input/joystick/gamecon.c
index 07a32af..3a97bd5 100644
--- a/drivers/input/joystick/gamecon.c
+++ b/drivers/input/joystick/gamecon.c
@@ -34,6 +34,7 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/irqflags.h>
 #include <linux/parport.h>
 #include <linux/input.h>
 #include <linux/mutex.h>
diff --git a/include/linux/irqflags.h b/include/linux/irqflags.h
index 74bde13..820642c 100644
--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
@@ -52,14 +52,20 @@
 # define start_critical_timings() do { } while (0)
 #endif
 
-#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
-
 #include <asm/irqflags.h>
 
-#define local_irq_enable() \
-	do { trace_hardirqs_on(); raw_local_irq_enable(); } while (0)
-#define local_irq_disable() \
-	do { raw_local_irq_disable(); trace_hardirqs_off(); } while (0)
+static inline void local_irq_enable(void)
+{
+	trace_hardirqs_on();
+	raw_local_irq_enable();
+}
+
+static inline void local_irq_disable(void)
+{
+	raw_local_irq_disable();
+	trace_hardirqs_off();
+}
+
 #define local_irq_save(flags)				\
 	do {						\
 		typecheck(unsigned long, flags);	\
@@ -68,35 +74,16 @@
 	} while (0)
 
 
-#define local_irq_restore(flags)			\
-	do {						\
-		typecheck(unsigned long, flags);	\
-		if (raw_irqs_disabled_flags(flags)) {	\
-			raw_local_irq_restore(flags);	\
-			trace_hardirqs_off();		\
-		} else {				\
-			trace_hardirqs_on();		\
-			raw_local_irq_restore(flags);	\
-		}					\
-	} while (0)
-#else /* !CONFIG_TRACE_IRQFLAGS_SUPPORT */
-/*
- * The local_irq_*() APIs are equal to the raw_local_irq*()
- * if !TRACE_IRQFLAGS.
- */
-# define raw_local_irq_disable()	local_irq_disable()
-# define raw_local_irq_enable()		local_irq_enable()
-# define raw_local_irq_save(flags)			\
-	do {						\
-		typecheck(unsigned long, flags);	\
-		local_irq_save(flags);			\
-	} while (0)
-# define raw_local_irq_restore(flags)			\
-	do {						\
-		typecheck(unsigned long, flags);	\
-		local_irq_restore(flags);		\
-	} while (0)
-#endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */
+static inline void local_irq_restore(unsigned long flags)
+{
+	if (raw_irqs_disabled_flags(flags)) {
+		raw_local_irq_restore(flags);
+		trace_hardirqs_off();
+	} else {
+		trace_hardirqs_on();
+		raw_local_irq_restore(flags);
+	}
+}
 
 #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
 #define safe_halt()						\
@@ -104,6 +91,7 @@
 		trace_hardirqs_on();				\
 		raw_safe_halt();				\
 	} while (0)
+#endif
 
 #define local_save_flags(flags)				\
 	do {						\
@@ -111,19 +99,16 @@
 		raw_local_save_flags(flags);		\
 	} while (0)
 
-#define irqs_disabled()						\
-({								\
-	unsigned long _flags;					\
-								\
-	raw_local_save_flags(_flags);				\
-	raw_irqs_disabled_flags(_flags);			\
-})
+static inline int irqs_disabled(void)
+{
+	unsigned long flags;
 
-#define irqs_disabled_flags(flags)		\
-({						\
-	typecheck(unsigned long, flags);	\
-	raw_irqs_disabled_flags(flags);		\
-})
-#endif		/* CONFIG_X86 */
+	raw_local_save_flags(flags);
+	return raw_irqs_disabled_flags(flags);
+}
 
+static inline int irqs_disabled_flags(unsigned long flags)
+{
+	return raw_irqs_disabled_flags(flags);
+}
 #endif
diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index 29f62e1..e0953cc 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -22,6 +22,7 @@
 #define _LINUX_KFIFO_H
 
 #include <linux/kernel.h>
+#include <linux/irqflags.h>
 #include <linux/spinlock.h>
 
 struct kfifo {
diff --git a/include/linux/proportions.h b/include/linux/proportions.h
index cf793bb..3eaf516 100644
--- a/include/linux/proportions.h
+++ b/include/linux/proportions.h
@@ -9,6 +9,7 @@
 #ifndef _LINUX_PROPORTIONS_H
 #define _LINUX_PROPORTIONS_H
 
+#include <linux/irqflags.h>
 #include <linux/percpu_counter.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
diff --git a/include/linux/spinlock_api_up.h b/include/linux/spinlock_api_up.h
index 04e1d31..4f8fbde 100644
--- a/include/linux/spinlock_api_up.h
+++ b/include/linux/spinlock_api_up.h
@@ -5,6 +5,8 @@
 # error "please don't include this file directly"
 #endif
 
+#include <linux/irqflags.h>
+
 /*
  * include/linux/spinlock_api_up.h
  *
diff --git a/include/linux/spinlock_up.h b/include/linux/spinlock_up.h
index 938234c..d162b4a 100644
--- a/include/linux/spinlock_up.h
+++ b/include/linux/spinlock_up.h
@@ -18,6 +18,8 @@
  */
 
 #ifdef CONFIG_DEBUG_SPINLOCK
+#include <linux/irqflags.h>
+
 #define __raw_spin_is_locked(x)		((x)->slock == 0)
 
 static inline void __raw_spin_lock(raw_spinlock_t *lock)
diff --git a/kernel/notifier.c b/kernel/notifier.c
index 61d5aa5..a22ea41 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -1,3 +1,4 @@
+#include <linux/irqflags.h>
 #include <linux/kdebug.h>
 #include <linux/kprobes.h>
 #include <linux/module.h>
diff --git a/kernel/params.c b/kernel/params.c
index a1e3025..5eaf15b 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/errno.h>
+#include <linux/irqflags.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/err.h>
diff --git a/kernel/smp.c b/kernel/smp.c
index bbedbb7..d9b5e1c 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -5,6 +5,7 @@
  *
  */
 #include <linux/init.h>
+#include <linux/irqflags.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
 #include <linux/rcupdate.h>
diff --git a/lib/idr.c b/lib/idr.c
index c11c576..b3fe4e6 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -29,6 +29,7 @@
 #ifndef TEST                        // to test in user space...
 #include <linux/slab.h>
 #include <linux/init.h>
+#include <linux/irqflags.h>
 #include <linux/module.h>
 #endif
 #include <linux/err.h>
diff --git a/lib/ratelimit.c b/lib/ratelimit.c
index 26187ed..eb528f0 100644
--- a/lib/ratelimit.c
+++ b/lib/ratelimit.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/irqflags.h>
 #include <linux/jiffies.h>
 #include <linux/module.h>
 
diff --git a/mm/internal.h b/mm/internal.h
index 478223b..163419b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -11,6 +11,7 @@
 #ifndef __MM_INTERNAL_H
 #define __MM_INTERNAL_H
 
+#include <linux/irqflags.h>
 #include <linux/mm.h>
 
 void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 5e0ffd9..2f4b396 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -1,7 +1,7 @@
 /*
  * linux/mm/page_isolation.c
  */
-
+#include <linux/irqflags.h>
 #include <linux/mm.h>
 #include <linux/page-isolation.h>
 #include <linux/pageblock-flags.h>
