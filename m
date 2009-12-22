Return-Path: <linux-kernel-owner+w=401wt.eu-S1751576AbZLVE4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbZLVE4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 23:56:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbZLVE4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 23:56:06 -0500
Received: from wm34.inbox.com ([64.135.83.34]:4947 "HELO WM34.inbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751295AbZLVE4F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 23:56:05 -0500
Mime-Version: 1.0
Date: Mon, 21 Dec 2009 20:55:16 -0800
Message-ID: <09708B4D5B0.0000098Bstartww3@inbox.com>
From: startww3@inbox.com
Subject: PATCH: irqflags.h
To: linux-kernel@vger.kernel.org
X-Mailer: INBOX.COM
X-Originating-IP: 142.132.6.18
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-IWM-ACU: OvG5GXAvsJTz8id9qHUtzCPGxl5LG1IcQhMbsmgmzO9P4IBS1_dDGGX6SjLK
  XAKLPIZSNlx6XKxPtBs1aB0T9bijkMvwJWvVlvgCGekzAfp9PKLgZ26TPe-A
  Z4ELtRGLInA8-8Mqsaw@@
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following diff -up patch was tested OK
on AMD K8 2.6.31.5-127 (Fedora 12 standard release)
for the file: include/linux/irqflags.h

Other platforms are untested.
===================================================================================

--- linux-2.6.31/include/linux/irqflags.h.orig  2009-12-21 21:24:55.000000000 -0500
+++ linux-2.6.31/include/linux/irqflags.h       2009-12-21 22:35:44.000000000 -0500
@@ -1,4 +1,22 @@
 /*
+
+ * PATCH Description -
+ *
+ * fixes defines for:
+ * local_irq_enable, local_irq_disable, local_irq_save, local_irq_restore,
+ * safe_halt, local_save_flags, irqs_disabled, irqs_disabled_flags
+ * when CONFIG_TRACE_IRQFLAGS_SUPPORT=n
+ * i.e. (arch/x86/Kconfig.debug contains:
+ *          config TRACE_IRQFLAGS_SUPPORT def_bool n)
+ *
+ * applies to kernel-2.6.31.5-127 (Fedora 12 standard release).
+ *
+ * This patch has tested ok on AMD K8 Fedora 12.
+ *
+ * Signed-off-by: RF <startww3@inbox.com>
+
+
+
  * include/linux/irqflags.h
  *
  * IRQ flags tracing: follow the state of the hardirq and softirq flags and
@@ -80,24 +98,29 @@
                }                                       \
        } while (0)
 #else /* !CONFIG_TRACE_IRQFLAGS_SUPPORT */
-/*
- * The local_irq_*() APIs are equal to the raw_local_irq*()
- * if !TRACE_IRQFLAGS.
- */
-# define raw_local_irq_disable()       local_irq_disable()
-# define raw_local_irq_enable()                local_irq_enable()
-# define raw_local_irq_save(flags)                     \
-       do {                                            \
-               typecheck(unsigned long, flags);        \
-               local_irq_save(flags);                  \
-       } while (0)
-# define raw_local_irq_restore(flags)                  \
-       do {                                            \
-               typecheck(unsigned long, flags);        \
-               local_irq_restore(flags);               \
-       } while (0)
+
+#include <asm/irqflags.h>
+
+#define local_irq_enable()             raw_local_irq_enable()
+#define local_irq_disable()            raw_local_irq_disable()
+
+#define local_irq_save(flags)                                          \
+({                                                             \
+       typecheck(unsigned long, flags);                        \
+       raw_local_irq_save(flags);                              \
+})
+
+#define local_irq_restore(flags)                                       \
+({                                                             \
+       typecheck(unsigned long, flags);                        \
+       raw_local_irq_restore(flags);                           \
+})
+
 #endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */

+
+
+
 #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
 #define safe_halt()                                            \
        do {                                                    \
@@ -105,25 +128,39 @@
                raw_safe_halt();                                \
        } while (0)

-#define local_save_flags(flags)                                \
-       do {                                            \
-               typecheck(unsigned long, flags);        \
-               raw_local_save_flags(flags);            \
+#define local_save_flags(flags)                                        \
+       do {                                                    \
+               typecheck(unsigned long, flags);                \
+               raw_local_save_flags(flags);                    \
        } while (0)

-#define irqs_disabled()                                                \
+
+#else
+
+#define safe_halt()                     raw_safe_halt()
+
+#define local_save_flags(flags)                                \
 ({                                                             \
-       unsigned long _flags;                                   \
-                                                               \
-       raw_local_save_flags(_flags);                           \
-       raw_irqs_disabled_flags(_flags);                        \
+       typecheck(unsigned long, flags);                        \
+       raw_local_save_flags(flags);                            \
+})
+
+
+#endif          /* CONFIG_TRACE_IRQFLAGS_SUPPORT */
+
+
+
+
+#define irqs_disabled()                                         \
+({                                                              \
+       unsigned long _flags;                                   \
+       raw_irqs_disabled();                                    \
 })

-#define irqs_disabled_flags(flags)             \
-({                                             \
-       typecheck(unsigned long, flags);        \
-       raw_irqs_disabled_flags(flags);         \
+#define irqs_disabled_flags(flags)                             \
+({                                                             \
+       typecheck(unsigned long, flags);                        \
+       raw_irqs_disabled_flags(flags);                         \
 })
-#endif         /* CONFIG_X86 */

 #endif

____________________________________________________________
FREE 3D EARTH SCREENSAVER - Watch the Earth right on your desktop!
Check it out at http://www.inbox.com/earth
