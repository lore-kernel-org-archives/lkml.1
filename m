Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbZCWOCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbZCWOCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 10:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbZCWOCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 10:02:09 -0400
Received: from mx1.emlix.com ([193.175.82.87]:55635 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbZCWOCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 10:02:08 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 1/2] xtensa: allow platform and variant to initialize own irq chips
Date: Mon, 23 Mar 2009 15:03:09 +0100
Message-Id: <1237816990-29108-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was already a PLATFORM_NR_IRQS define, which is now accompanied
by a VARIANT_NR_IRQS. To be able to initialize these interrupts,
init_IRQ now calls variant and platform specific hooks.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/include/asm/irq.h                     |   21 ++++++++++++++++++---
 arch/xtensa/kernel/irq.c                          |    3 +++
 arch/xtensa/variants/dc232b/include/variant/irq.h |    4 ++++
 arch/xtensa/variants/fsf/include/variant/irq.h    |    4 ++++
 4 files changed, 29 insertions(+), 3 deletions(-)
 create mode 100644 arch/xtensa/variants/dc232b/include/variant/irq.h
 create mode 100644 arch/xtensa/variants/fsf/include/variant/irq.h

diff --git a/arch/xtensa/include/asm/irq.h b/arch/xtensa/include/asm/irq.h
index dfac82d..c3c10a7 100644
--- a/arch/xtensa/include/asm/irq.h
+++ b/arch/xtensa/include/asm/irq.h
@@ -11,21 +11,36 @@
 #ifndef _XTENSA_IRQ_H
 #define _XTENSA_IRQ_H
 
+#include <linux/init.h>
 #include <platform/hardware.h>
 #include <variant/core.h>
 
-#ifdef CONFIG_VARIANT_IRQ_SWITCH
 #include <variant/irq.h>
-#else
+#ifndef CONFIG_VARIANT_IRQ_SWITCH
 static inline void variant_irq_enable(unsigned int irq) { }
 static inline void variant_irq_disable(unsigned int irq) { }
 #endif
 
+#ifndef VARIANT_NR_IRQS
+# define VARIANT_NR_IRQS 0
+#endif
 #ifndef PLATFORM_NR_IRQS
 # define PLATFORM_NR_IRQS 0
 #endif
 #define XTENSA_NR_IRQS XCHAL_NUM_INTERRUPTS
-#define NR_IRQS (XTENSA_NR_IRQS + PLATFORM_NR_IRQS)
+#define NR_IRQS (XTENSA_NR_IRQS + VARIANT_NR_IRQS + PLATFORM_NR_IRQS)
+
+#if VARIANT_NR_IRQS == 0
+static inline void variant_init_IRQ(void) { }
+#else
+void variant_init_IRQ(void) __init;
+#endif
+
+#if PLATFORM_NR_IRQS == 0
+static inline void platform_init_IRQ(void) { }
+#else
+void platform_init_IRQ(void) __init;
+#endif
 
 static __inline__ int irq_canonicalize(int irq)
 {
diff --git a/arch/xtensa/kernel/irq.c b/arch/xtensa/kernel/irq.c
index 2068445..89bb970 100644
--- a/arch/xtensa/kernel/irq.c
+++ b/arch/xtensa/kernel/irq.c
@@ -197,4 +197,7 @@ void __init init_IRQ(void)
 	}
 
 	cached_irq_mask = 0;
+
+	variant_init_IRQ();
+	platform_init_IRQ();
 }
diff --git a/arch/xtensa/variants/dc232b/include/variant/irq.h b/arch/xtensa/variants/dc232b/include/variant/irq.h
new file mode 100644
index 0000000..070b9f5
--- /dev/null
+++ b/arch/xtensa/variants/dc232b/include/variant/irq.h
@@ -0,0 +1,4 @@
+#ifndef __XTENSA_VARIANT_IRQ_H
+#define __XTENSA_VARIANT_IRQ_H
+
+#endif
diff --git a/arch/xtensa/variants/fsf/include/variant/irq.h b/arch/xtensa/variants/fsf/include/variant/irq.h
new file mode 100644
index 0000000..070b9f5
--- /dev/null
+++ b/arch/xtensa/variants/fsf/include/variant/irq.h
@@ -0,0 +1,4 @@
+#ifndef __XTENSA_VARIANT_IRQ_H
+#define __XTENSA_VARIANT_IRQ_H
+
+#endif
-- 
1.6.2.107.ge47ee

