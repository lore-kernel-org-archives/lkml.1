Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbZFTSse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbZFTSse (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757860AbZFTSq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:46:26 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48104 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757459AbZFTSqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:46:25 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Philippe Gerum <rpm@xenomai.org>
Subject: [PATCH 13/25] Blackfin: allow CONFIG_TICKSOURCE_GPTMR0 with interrupt pipeline
Date: Sat, 20 Jun 2009 14:44:36 -0400
Message-Id: <1245523488-26536-14-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Gerum <rpm@xenomai.org>

Signed-off-by: Philippe Gerum <rpm@xenomai.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig                     |    1 -
 arch/blackfin/include/asm/ipipe.h         |    7 ++++-
 arch/blackfin/mach-common/ints-priority.c |   47 +++++++++++++---------------
 3 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index c2c4a62..8140a2f 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -623,7 +623,6 @@ choice
 config TICKSOURCE_GPTMR0
 	bool "Gptimer0 (SCLK domain)"
 	select BFIN_GPTIMERS
-	depends on !IPIPE
 
 config TICKSOURCE_CORETMR
 	bool "Core timer (CCLK domain)"
diff --git a/arch/blackfin/include/asm/ipipe.h b/arch/blackfin/include/asm/ipipe.h
index bbe1c37..ffa5e60 100644
--- a/arch/blackfin/include/asm/ipipe.h
+++ b/arch/blackfin/include/asm/ipipe.h
@@ -207,7 +207,7 @@ void ipipe_init_irq_threads(void);
 
 int ipipe_start_irq_thread(unsigned irq, struct irq_desc *desc);
 
-#ifdef CONFIG_GENERIC_CLOCKEVENTS
+#ifdef CONFIG_TICKSOURCE_CORETMR
 #define IRQ_SYSTMR		IRQ_CORETMR
 #define IRQ_PRIOTMR		IRQ_CORETMR
 #else
@@ -240,8 +240,13 @@ int ipipe_start_irq_thread(unsigned irq, struct irq_desc *desc);
 #define ipipe_init_irq_threads()		do { } while (0)
 #define ipipe_start_irq_thread(irq, desc)	0
 
+#ifndef CONFIG_TICKSOURCE_GPTMR0
 #define IRQ_SYSTMR		IRQ_CORETMR
 #define IRQ_PRIOTMR		IRQ_CORETMR
+#else
+#define IRQ_SYSTMR		IRQ_TIMER0
+#define IRQ_PRIOTMR		CONFIG_IRQ_TIMER0
+#endif
 
 #define __ipipe_root_tick_p(regs)	1
 
diff --git a/arch/blackfin/mach-common/ints-priority.c b/arch/blackfin/mach-common/ints-priority.c
index af70f09..b421501 100644
--- a/arch/blackfin/mach-common/ints-priority.c
+++ b/arch/blackfin/mach-common/ints-priority.c
@@ -1052,35 +1052,34 @@ int __init init_arch_irq(void)
 			set_irq_chained_handler(irq, bfin_demux_error_irq);
 			break;
 #endif
-#if defined(CONFIG_TICKSOURCE_GPTMR0)
-		case IRQ_TIMER0:
-			set_irq_handler(irq, handle_percpu_irq);
-			break;
-#endif
 #ifdef CONFIG_SMP
 		case IRQ_SUPPLE_0:
 		case IRQ_SUPPLE_1:
 			set_irq_handler(irq, handle_percpu_irq);
 			break;
 #endif
-		default:
 #ifdef CONFIG_IPIPE
-			/*
-			 * We want internal interrupt sources to be
-			 * masked, because ISRs may trigger interrupts
-			 * recursively (e.g. DMA), but interrupts are
-			 * _not_ masked at CPU level. So let's handle
-			 * most of them as level interrupts, except
-			 * the timer interrupt which is special.
-			 */
-			if (irq == IRQ_SYSTMR || irq == IRQ_CORETMR)
-				set_irq_handler(irq, handle_simple_irq);
-			else
-				set_irq_handler(irq, handle_level_irq);
+#ifndef CONFIG_TICKSOURCE_CORETMR
+		case IRQ_TIMER0:
+			set_irq_handler(irq, handle_simple_irq);
+			break;
+#endif /* !CONFIG_TICKSOURCE_CORETMR */
+		case IRQ_CORETMR:
+			set_irq_handler(irq, handle_simple_irq);
+			break;
+		default:
+			set_irq_handler(irq, handle_level_irq);
+			break;
 #else /* !CONFIG_IPIPE */
+#ifdef CONFIG_TICKSOURCE_GPTMR0
+		case IRQ_TIMER0:
+			set_irq_handler(irq, handle_percpu_irq);
+			break;
+#endif /* CONFIG_TICKSOURCE_GPTMR0 */
+		default:
 			set_irq_handler(irq, handle_simple_irq);
-#endif /* !CONFIG_IPIPE */
 			break;
+#endif	/* !CONFIG_IPIPE */
 		}
 	}
 
@@ -1224,15 +1223,14 @@ __attribute__((l1_text))
 asmlinkage int __ipipe_grab_irq(int vec, struct pt_regs *regs)
 {
 	struct ipipe_percpu_domain_data *p = ipipe_root_cpudom_ptr();
-	struct ipipe_domain *this_domain = ipipe_current_domain;
+	struct ipipe_domain *this_domain = __ipipe_current_domain;
 	struct ivgx *ivg_stop = ivg7_13[vec-IVG7].istop;
 	struct ivgx *ivg = ivg7_13[vec-IVG7].ifirst;
 	int irq, s;
 
-	if (likely(vec == EVT_IVTMR_P)) {
+	if (likely(vec == EVT_IVTMR_P))
 		irq = IRQ_CORETMR;
-
-	} else {
+	else {
 #if defined(SIC_ISR0) || defined(SICA_ISR0)
 		unsigned long sic_status[3];
 
@@ -1262,12 +1260,11 @@ asmlinkage int __ipipe_grab_irq(int vec, struct pt_regs *regs)
 				break;
 		}
 #endif
-
 		irq = ivg->irqno;
 	}
 
 	if (irq == IRQ_SYSTMR) {
-#ifndef CONFIG_GENERIC_CLOCKEVENTS
+#if !defined(CONFIG_GENERIC_CLOCKEVENTS) || defined(CONFIG_TICKSOURCE_GPTMR0)
 		bfin_write_TIMER_STATUS(1); /* Latch TIMIL0 */
 #endif
 		/* This is basically what we need from the register frame. */
-- 
1.6.3.1

