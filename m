Return-Path: <linux-kernel-owner+w=401wt.eu-S1756484AbZEEPDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbZEEPDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 11:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbZEEPDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 11:03:23 -0400
Received: from mx1.emlix.com ([193.175.82.87]:38599 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755895AbZEEPDW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 11:03:22 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [PATCH v2 1/2] xtensa: allow variant to initialize own irq chips
Date: Tue,  5 May 2009 17:03:21 +0200
Message-Id: <1241535802-17516-1-git-send-email-dg@emlix.com>
In-Reply-To: <1237816990-29108-1-git-send-email-dg@emlix.com>
References: <1237816990-29108-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was already a PLATFORM_NR_IRQS define, which is now accompanied
by a VARIANT_NR_IRQS. To be able to initialize these interrupts,
init_IRQ now calls a variant specific hook.

Changes compared to v1:
- adapted to new CONFIG_VARIANT_IRQ_EXT
- removed definition and call of platform_init_IRQ as there already
  is a platform_init_irq defined in asm/platform.h with a weak default
  in kernel/platform.c
- renamed variant_init_IRQ to variant_init_irq

Note that I could not find the call site of platform_init_irq although
it is stated in platform.h that it is called from init_IRQ.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/include/asm/irq.h |   12 +++++++++++-
 arch/xtensa/kernel/irq.c      |    2 ++
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/xtensa/include/asm/irq.h b/arch/xtensa/include/asm/irq.h
index 4a39bb5..f10ee86 100644
--- a/arch/xtensa/include/asm/irq.h
+++ b/arch/xtensa/include/asm/irq.h
@@ -11,6 +11,7 @@
 #ifndef _XTENSA_IRQ_H
 #define _XTENSA_IRQ_H
 
+#include <linux/init.h>
 #include <platform/hardware.h>
 #include <variant/core.h>
 
@@ -23,11 +24,20 @@ static inline void variant_irq_enable(unsigned int irq) { }
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
+static inline void variant_init_irq(void) { }
+#else
+void variant_init_irq(void) __init;
+#endif
 
 static __inline__ int irq_canonicalize(int irq)
 {
diff --git a/arch/xtensa/kernel/irq.c b/arch/xtensa/kernel/irq.c
index a36c85e..a1badb3 100644
--- a/arch/xtensa/kernel/irq.c
+++ b/arch/xtensa/kernel/irq.c
@@ -197,4 +197,6 @@ void __init init_IRQ(void)
 	}
 
 	cached_irq_mask = 0;
+
+	variant_init_irq();
 }
-- 
1.6.1.3

