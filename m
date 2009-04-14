Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbZDNJmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbZDNJmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbZDNJjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:39:48 -0400
Received: from mx1.emlix.com ([193.175.82.87]:34000 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039AbZDNJjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:39:42 -0400
From: Johannes Weiner <jw@emlix.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 09/12] xtensa: allow platform and variant to initialize own irq chips
Date: Tue, 14 Apr 2009 11:41:17 +0200
Message-Id: <1239702080-14355-10-git-send-email-jw@emlix.com>
In-Reply-To: <1239702080-14355-1-git-send-email-jw@emlix.com>
References: <1239702080-14355-1-git-send-email-jw@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Glöckner <dg@emlix.com>

There was already a PLATFORM_NR_IRQS define, which is now accompanied
by a VARIANT_NR_IRQS. To be able to initialize these interrupts,
init_IRQ now calls variant and platform specific hooks.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/include/asm/irq.h                     |   21 ++++++++++++++++++---
 arch/xtensa/kernel/irq.c                          |    3 +++
 arch/xtensa/variants/dc232b/include/variant/irq.h |    4 ++++
 arch/xtensa/variants/fsf/include/variant/irq.h    |    4 ++++
 arch/xtensa/variants/s6000/include/variant/irq.h  |    1 +
 5 files changed, 30 insertions(+), 3 deletions(-)
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
index a36c85e..61c03a3 100644
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
diff --git a/arch/xtensa/variants/s6000/include/variant/irq.h b/arch/xtensa/variants/s6000/include/variant/irq.h
index fa031cb..55403d1 100644
--- a/arch/xtensa/variants/s6000/include/variant/irq.h
+++ b/arch/xtensa/variants/s6000/include/variant/irq.h
@@ -2,6 +2,7 @@
 #define __XTENSA_S6000_IRQ_H
 
 #define NO_IRQ		(-1)
+#define VARIANT_NR_IRQS 8 /* GPIO interrupts */
 
 extern void variant_irq_enable(unsigned int irq);
 extern void variant_irq_disable(unsigned int irq);
-- 
1.6.2.107.ge47ee

