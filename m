Return-Path: <linux-kernel-owner+w=401wt.eu-S932151AbYGQTYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151AbYGQTYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932319AbYGQTWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:22:51 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:49742 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759206AbYGQTWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:22:44 -0400
Message-Id: <20080717191750.804735376@mail.of.borg>
References: <20080717191607.955742542@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 21:16:12 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 05/29] m68k: Allow no CPU/platform type for allnoconfig
Content-Disposition: inline; filename=m68k-allnoconfig.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

Allow no CPU/platform type for allnoconfig
  - Provide a dummy value for FPSTATESIZE if no CPU type was selected
  - Provide a dummy value for NR_IRQS if no platform type was selected
  - Warn the user if no CPU or platform type was selected

Note: you still cannot build an allnoconfig kernel, as CONFIG_SWAP=n doesn't
build and we cannot easily fix that
(http://groups.google.com/group/linux.kernel/browse_thread/thread/d430c78b07e1827b)

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/kernel/setup.c    |    6 ++++++
 include/asm-m68k/fpu.h      |   10 +++++-----
 include/asm-m68k/irq.h      |    2 +-
 include/asm-m68k/tlbflush.h |    8 ++++----
 4 files changed, 16 insertions(+), 10 deletions(-)

--- a/arch/m68k/kernel/setup.c
+++ b/arch/m68k/kernel/setup.c
@@ -26,6 +26,7 @@
 
 #include <asm/bootinfo.h>
 #include <asm/setup.h>
+#include <asm/fpu.h>
 #include <asm/irq.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
@@ -40,6 +41,11 @@
 #include <asm/dvma.h>
 #endif
 
+#if !FPSTATESIZE || !NR_IRQS
+#warning No CPU/platform type selected, your kernel will not work!
+#warning Are you building an allnoconfig kernel?
+#endif
+
 unsigned long m68k_machtype;
 EXPORT_SYMBOL(m68k_machtype);
 unsigned long m68k_cputype;
--- a/include/asm-m68k/fpu.h
+++ b/include/asm-m68k/fpu.h
@@ -7,15 +7,15 @@
  */
 
 #if defined(CONFIG_M68020) || defined(CONFIG_M68030)
-#define FPSTATESIZE (216/sizeof(unsigned char))
+#define FPSTATESIZE (216)
 #elif defined(CONFIG_M68040)
-#define FPSTATESIZE (96/sizeof(unsigned char))
+#define FPSTATESIZE (96)
 #elif defined(CONFIG_M68KFPU_EMU)
-#define FPSTATESIZE (28/sizeof(unsigned char))
+#define FPSTATESIZE (28)
 #elif defined(CONFIG_M68060)
-#define FPSTATESIZE (12/sizeof(unsigned char))
+#define FPSTATESIZE (12)
 #else
-#define FPSTATESIZE error no_cpu_type_configured
+#define FPSTATESIZE (0)
 #endif
 
 #endif /* __M68K_FPU_H */
--- a/include/asm-m68k/irq.h
+++ b/include/asm-m68k/irq.h
@@ -24,7 +24,7 @@
 #elif defined(CONFIG_HP300)
 #define NR_IRQS	8
 #else
-#error unknown nr of irqs
+#define NR_IRQS	0
 #endif
 
 /*
--- a/include/asm-m68k/tlbflush.h
+++ b/include/asm-m68k/tlbflush.h
@@ -16,7 +16,7 @@ static inline void flush_tlb_kernel_page
 				     ".chip 68k"
 				     : : "a" (addr));
 		set_fs(old_fs);
-	} else
+	} else if (CPU_IS_020_OR_030)
 		__asm__ __volatile__("pflush #4,#4,(%0)" : : "a" (addr));
 }
 
@@ -29,7 +29,7 @@ static inline void __flush_tlb(void)
 		__asm__ __volatile__(".chip 68040\n\t"
 				     "pflushan\n\t"
 				     ".chip 68k");
-	else
+	else if (CPU_IS_020_OR_030)
 		__asm__ __volatile__("pflush #0,#4");
 }
 
@@ -45,7 +45,7 @@ static inline void __flush_tlb_one(unsig
 {
 	if (CPU_IS_040_OR_060)
 		__flush_tlb040_one(addr);
-	else
+	else if (CPU_IS_020_OR_030)
 		__asm__ __volatile__("pflush #0,#4,(%0)" : : "a" (addr));
 }
 
@@ -60,7 +60,7 @@ static inline void flush_tlb_all(void)
 		__asm__ __volatile__(".chip 68040\n\t"
 				     "pflusha\n\t"
 				     ".chip 68k");
-	else
+	else if (CPU_IS_020_OR_030)
 		__asm__ __volatile__("pflusha");
 }
 

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

