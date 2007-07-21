Return-Path: <linux-kernel-owner+w=401wt.eu-S1757718AbXGUWaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718AbXGUWaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 18:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbXGUW3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 18:29:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53277 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbXGUW3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 18:29:13 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 3/3] take declarations of enable_irq() et.al. to linux/interrupt.h
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <E1ICNRo-0000lx-G2@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 21 Jul 2007 23:29:12 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Now that the last inlined instances are gone, all that is left to do
is turning disable_irq_nosync on arm26 and m68k from defines to aliases
and we are all set - we can make these externs in linux/interrupt.h
uncoditional and kill remaining instances in asm/irq.h

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/arm26/kernel/armksyms.c |    2 --
 arch/arm26/kernel/irq.c      |    6 ++++++
 arch/m68k/kernel/ints.c      |    4 ++++
 include/asm-alpha/irq.h      |    4 ----
 include/asm-arm26/irq.h      |    5 -----
 include/asm-h8300/irq.h      |    3 ---
 include/asm-ia64/irq.h       |    3 ---
 include/asm-m68k/irq.h       |    3 ---
 include/asm-sh64/irq.h       |    4 ----
 include/asm-sparc/irq.h      |    4 ----
 include/asm-v850/irq.h       |   10 ----------
 include/linux/interrupt.h    |    2 +-
 12 files changed, 11 insertions(+), 39 deletions(-)

diff --git a/arch/arm26/kernel/armksyms.c b/arch/arm26/kernel/armksyms.c
index f735d7e..fe1e3ce 100644
--- a/arch/arm26/kernel/armksyms.c
+++ b/arch/arm26/kernel/armksyms.c
@@ -107,8 +107,6 @@ EXPORT_SYMBOL(__bug);
 #endif
 EXPORT_SYMBOL(__bad_xchg);
 EXPORT_SYMBOL(__readwrite_bug);
-EXPORT_SYMBOL(enable_irq);
-EXPORT_SYMBOL(disable_irq);
 EXPORT_SYMBOL(set_irq_type);
 EXPORT_SYMBOL(pm_idle);
 EXPORT_SYMBOL(pm_power_off);
diff --git a/arch/arm26/kernel/irq.c b/arch/arm26/kernel/irq.c
index d53382c..2ffe695 100644
--- a/arch/arm26/kernel/irq.c
+++ b/arch/arm26/kernel/irq.c
@@ -95,6 +95,11 @@ void disable_irq(unsigned int irq)
 		desc->enabled = 0;
 	spin_unlock_irqrestore(&irq_controller_lock, flags);
 }
+EXPORT_SYMBOL(disable_irq);
+
+void disable_irq_nosync(unsigned int irq) __attribute__((alias("disable_irq")));
+
+EXPORT_SYMBOL(disable_irq_nosync);
 
 /**
  *	enable_irq - enable interrupt handling on an irq
@@ -131,6 +136,7 @@ void enable_irq(unsigned int irq)
 	}
 	spin_unlock_irqrestore(&irq_controller_lock, flags);
 }
+EXPORT_SYMBOL(enable_irq);
 
 int show_interrupts(struct seq_file *p, void *v)
 {
diff --git a/arch/m68k/kernel/ints.c b/arch/m68k/kernel/ints.c
index 60d4d75..2b41245 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -326,6 +326,10 @@ void disable_irq(unsigned int irq)
 
 EXPORT_SYMBOL(disable_irq);
 
+void disable_irq_nosync(unsigned int irq) __attribute__((alias("disable_irq")));
+
+EXPORT_SYMBOL(disable_irq_nosync);
+
 int m68k_irq_startup(unsigned int irq)
 {
 	if (irq <= IRQ_AUTO_7)
diff --git a/include/asm-alpha/irq.h b/include/asm-alpha/irq.h
index 917b9fe..0637740 100644
--- a/include/asm-alpha/irq.h
+++ b/include/asm-alpha/irq.h
@@ -85,10 +85,6 @@ static __inline__ int irq_canonicalize(int irq)
 	return ((irq == 2) ? 9 : irq);
 }
 
-extern void disable_irq(unsigned int);
-extern void disable_irq_nosync(unsigned int);
-extern void enable_irq(unsigned int);
-
 struct pt_regs;
 extern void (*perf_irq)(unsigned long, struct pt_regs *);
 
diff --git a/include/asm-arm26/irq.h b/include/asm-arm26/irq.h
index 9aaac87..52971b4 100644
--- a/include/asm-arm26/irq.h
+++ b/include/asm-arm26/irq.h
@@ -24,11 +24,6 @@
 
 struct irqaction;
 
-#define disable_irq_nosync(i) disable_irq(i)
-
-extern void disable_irq(unsigned int);
-extern void enable_irq(unsigned int);
-
 #define __IRQT_FALEDGE	(1 << 0)
 #define __IRQT_RISEDGE	(1 << 1)
 #define __IRQT_LOWLVL	(1 << 2)
diff --git a/include/asm-h8300/irq.h b/include/asm-h8300/irq.h
index 96600b0..5fb0599 100644
--- a/include/asm-h8300/irq.h
+++ b/include/asm-h8300/irq.h
@@ -59,7 +59,4 @@ static __inline__ int irq_canonicalize(int irq)
 	return irq;
 }
 
-extern void enable_irq(unsigned int);
-extern void disable_irq(unsigned int);
-
 #endif /* _H8300_IRQ_H_ */
diff --git a/include/asm-ia64/irq.h b/include/asm-ia64/irq.h
index 35b360b..a66d268 100644
--- a/include/asm-ia64/irq.h
+++ b/include/asm-ia64/irq.h
@@ -33,9 +33,6 @@ irq_canonicalize (int irq)
 	return ((irq == 2) ? 9 : irq);
 }
 
-extern void disable_irq (unsigned int);
-extern void disable_irq_nosync (unsigned int);
-extern void enable_irq (unsigned int);
 extern void set_irq_affinity_info (unsigned int irq, int dest, int redir);
 bool is_affinity_mask_valid(cpumask_t cpumask);
 
diff --git a/include/asm-m68k/irq.h b/include/asm-m68k/irq.h
index 4901cb1..eb29a52 100644
--- a/include/asm-m68k/irq.h
+++ b/include/asm-m68k/irq.h
@@ -59,9 +59,6 @@
 #define IRQ_USER	8
 
 extern unsigned int irq_canonicalize(unsigned int irq);
-extern void enable_irq(unsigned int);
-extern void disable_irq(unsigned int);
-#define disable_irq_nosync	disable_irq
 
 struct pt_regs;
 
diff --git a/include/asm-sh64/irq.h b/include/asm-sh64/irq.h
index 1ca49e2..5c9e6a8 100644
--- a/include/asm-sh64/irq.h
+++ b/include/asm-sh64/irq.h
@@ -114,10 +114,6 @@
 #define	IRL0_PRIORITY	13
 #define TOP_PRIORITY	15
 
-extern void disable_irq(unsigned int);
-extern void disable_irq_nosync(unsigned int);
-extern void enable_irq(unsigned int);
-
 extern int intc_evt_to_irq[(0xE20/0x20)+1];
 int intc_irq_describe(char* p, int irq);
 
diff --git a/include/asm-sparc/irq.h b/include/asm-sparc/irq.h
index afb88a5..61fb996 100644
--- a/include/asm-sparc/irq.h
+++ b/include/asm-sparc/irq.h
@@ -13,10 +13,6 @@
 
 #define irq_canonicalize(irq)	(irq)
 
-extern void disable_irq_nosync(unsigned int irq);
-extern void disable_irq(unsigned int irq);
-extern void enable_irq(unsigned int irq);
-
 extern int request_fast_irq(unsigned int irq, irq_handler_t handler, unsigned long flags, __const__ char *devname);
 
 #endif
diff --git a/include/asm-v850/irq.h b/include/asm-v850/irq.h
index 88687c1..7d0d4cd 100644
--- a/include/asm-v850/irq.h
+++ b/include/asm-v850/irq.h
@@ -50,16 +50,6 @@ init_irq_handlers (int base_irq, int num, int interval,
    interrupt.  */
 extern unsigned int handle_irq (int irq, struct pt_regs *regs);
 
-
-/* Enable interrupt handling on an irq.  */
-extern void enable_irq(unsigned int irq);
-
-/* Disable an irq and wait for completion.  */
-extern void disable_irq (unsigned int irq);
-
-/* Disable an irq without waiting. */
-extern void disable_irq_nosync (unsigned int irq);
-
 #endif /* !__ASSEMBLY__ */
 
 #endif /* __V850_IRQ_H__ */
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 5323f62..0a3c2eb 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -120,11 +120,11 @@ extern void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id);
 # define local_irq_enable_in_hardirq()	local_irq_enable()
 #endif
 
-#ifdef CONFIG_GENERIC_HARDIRQS
 extern void disable_irq_nosync(unsigned int irq);
 extern void disable_irq(unsigned int irq);
 extern void enable_irq(unsigned int irq);
 
+#ifdef CONFIG_GENERIC_HARDIRQS
 /*
  * Special lockdep variants of irq disabling/enabling.
  * These should be used for locking constructs that
-- 
1.5.3.GIT

