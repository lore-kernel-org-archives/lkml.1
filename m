Return-Path: <linux-kernel-owner+w=401wt.eu-S1764944AbZFQHLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764944AbZFQHLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 03:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764563AbZFQHLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 03:11:15 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:60171 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753422AbZFQHLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 03:11:12 -0400
Date: Wed, 17 Jun 2009 17:11:09 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200906170711.n5H7B9CR009025@localhost.localdomain>
To: linux-kernel@vger.kernel.org
Subject: PATCH] m68k: merge mmu and non-mmu versions of irq.h
Cc: gerg@uclinux.org, linux-m68k@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] m68k: merge mmu and non-mmu versions of irq.h

It is reasonably strait forward to merge the mmu and non-mmu versions
of irq.h. Most of the defines and structs are not needed on no-mmu.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---
 arch/m68k/include/asm/{irq_mm.h => irq.h} |   12 ++++++++++--
 arch/m68k/include/asm/irq_no.h            |   26 --------------------------
 2 files changed, 10 insertions(+), 28 deletions(-)
 rename arch/m68k/include/asm/{irq_mm.h => irq.h} (93%)
 delete mode 100644 arch/m68k/include/asm/irq_no.h

diff --git a/arch/m68k/include/asm/irq_mm.h b/arch/m68k/include/asm/irq.h
similarity index 93%
rename from arch/m68k/include/asm/irq_mm.h
rename to arch/m68k/include/asm/irq.h
index 0cab42c..cc0614a 100644
--- a/arch/m68k/include/asm/irq_mm.h
+++ b/arch/m68k/include/asm/irq.h
@@ -12,13 +12,15 @@
  * Currently the Atari has 72 and the Amiga 24, but if both are
  * supported in the kernel it is better to make room for 72.
  */
-#if defined(CONFIG_VME) || defined(CONFIG_SUN3) || defined(CONFIG_SUN3X)
+#if defined(CONFIG_COLDFIRE)
+#define NR_IRQS 256
+#elif defined(CONFIG_VME) || defined(CONFIG_SUN3) || defined(CONFIG_SUN3X)
 #define NR_IRQS 200
 #elif defined(CONFIG_ATARI) || defined(CONFIG_MAC)
 #define NR_IRQS 72
 #elif defined(CONFIG_Q40)
 #define NR_IRQS	43
-#elif defined(CONFIG_AMIGA)
+#elif defined(CONFIG_AMIGA) || !defined(CONFIG_MMU)
 #define NR_IRQS	32
 #elif defined(CONFIG_APOLLO)
 #define NR_IRQS	24
@@ -37,6 +39,8 @@
 # error HARDIRQ_BITS is too low!
 #endif
 
+#ifdef CONFIG_MMU
+
 /*
  * Interrupt source definitions
  * General interrupt sources are the level 1-7.
@@ -123,4 +127,8 @@ extern void m68k_setup_irq_controller(struct irq_controller *, unsigned int, uns
 asmlinkage void m68k_handle_int(unsigned int);
 asmlinkage void __m68k_handle_int(unsigned int, struct pt_regs *);
 
+#else
+#define irq_canonicalize(irq)	(irq)
+#endif /* CONFIG_MMU */
+
 #endif /* _M68K_IRQ_H_ */
diff --git a/arch/m68k/include/asm/irq_no.h b/arch/m68k/include/asm/irq_no.h
deleted file mode 100644
index 9373c31..0000000
--- a/arch/m68k/include/asm/irq_no.h
+++ /dev/null
@@ -1,26 +0,0 @@
-#ifndef _M68KNOMMU_IRQ_H_
-#define _M68KNOMMU_IRQ_H_
-
-#ifdef CONFIG_COLDFIRE
-/*
- * On the ColdFire we keep track of all vectors. That way drivers
- * can register whatever vector number they wish, and we can deal
- * with it.
- */
-#define	SYS_IRQS	256
-#define	NR_IRQS		SYS_IRQS
-
-#else
-
-/*
- * # of m68k interrupts
- */
-#define SYS_IRQS	8
-#define NR_IRQS		(24 + SYS_IRQS)
-
-#endif /* CONFIG_COLDFIRE */
-
-
-#define irq_canonicalize(irq)	(irq)
-
-#endif /* _M68KNOMMU_IRQ_H_ */
