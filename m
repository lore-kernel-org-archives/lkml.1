Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbZF0OJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbZF0OJm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 10:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbZF0OIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 10:08:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:57562 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245AbZF0OIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 10:08:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5/6] score: make irq.h definitions local
Date: Sat, 27 Jun 2009 16:08:17 +0200
Message-Id: <9b05706a744da939655525eeeae23f1989b434ce.1246111364.git.arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1246111364.git.arnd@arndb.de>
References: <cover.1246111364.git.arnd@arndb.de>
In-Reply-To: <cover.1246111364.git.arnd@arndb.de>
References: <cover.1246111364.git.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18+4jVB6y/JRBpE7PnnIS1+sm5m9FH9YPMSlZ5
 1ENlDMnEXlYPequ41E3nkoBVKZ0vdQML+KzYA/rUID+BSgmjr4
 dAG1yw5MNjHFYJTbeu8Lg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some internal definitions of the interrupt controller are
only needed in irq.c, so move them out of the global irq.h
header. Also add proper __iomem annotations for sparse.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/score/include/asm/irq.h |   10 ----------
 arch/score/kernel/irq.c      |   33 +++++++++++++++++++++++----------
 2 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/arch/score/include/asm/irq.h b/arch/score/include/asm/irq.h
index 401f670..6edd2a2 100644
--- a/arch/score/include/asm/irq.h
+++ b/arch/score/include/asm/irq.h
@@ -18,16 +18,6 @@
 
 #define irq_canonicalize(irq)	(irq)
 
-#define P_INT_PNDL		0x95F50000
-#define P_INT_PNDH		0x95F50004
-#define P_INT_PRIORITY_M	0x95F50008
-#define P_INT_PRIORITY_SG0	0x95F50010
-#define P_INT_PRIORITY_SG1	0x95F50014
-#define P_INT_PRIORITY_SG2	0x95F50018
-#define P_INT_PRIORITY_SG3	0x95F5001C
-#define P_INT_MASKL		0x95F50020
-#define P_INT_MASKH		0x95F50024
-
 #define IRQ_TIMER (7)		/* Timer IRQ number of SPCT6600 */
 
 #endif /* _ASM_SCORE_IRQ_H */
diff --git a/arch/score/kernel/irq.c b/arch/score/kernel/irq.c
index 55474e8..47647dd 100644
--- a/arch/score/kernel/irq.c
+++ b/arch/score/kernel/irq.c
@@ -29,6 +29,19 @@
 
 #include <asm/io.h>
 
+/* the interrupt controller is hardcoded at this address */
+#define SCORE_PIC		((u32 __iomem __force *)0x95F50000)
+
+#define INT_PNDL		0
+#define INT_PNDH		1
+#define INT_PRIORITY_M		2
+#define INT_PRIORITY_SG0	4
+#define INT_PRIORITY_SG1	5
+#define INT_PRIORITY_SG2	6
+#define INT_PRIORITY_SG3	7
+#define INT_MASKL		8
+#define INT_MASKH		9
+
 /*
  * handles all normal device IRQs
  */
@@ -44,11 +57,11 @@ static void score_mask(unsigned int irq_nr)
 	unsigned int irq_source = 63 - irq_nr;
 
 	if (irq_source < 32)
-		__raw_writel((__raw_readl((void *)P_INT_MASKL) | \
-			(1 << irq_source)), (void *)P_INT_MASKL);
+		__raw_writel((__raw_readl(SCORE_PIC + INT_MASKL) | \
+			(1 << irq_source)), SCORE_PIC + INT_MASKL);
 	else
-		__raw_writel((__raw_readl((void *)P_INT_MASKH) | \
-			(1 << (irq_source - 32))), (void *)P_INT_MASKH);
+		__raw_writel((__raw_readl(SCORE_PIC + INT_MASKH) | \
+			(1 << (irq_source - 32))), SCORE_PIC + INT_MASKH);
 }
 
 static void score_unmask(unsigned int irq_nr)
@@ -56,11 +69,11 @@ static void score_unmask(unsigned int irq_nr)
 	unsigned int irq_source = 63 - irq_nr;
 
 	if (irq_source < 32)
-		__raw_writel((__raw_readl((void *)P_INT_MASKL) & \
-			~(1 << irq_source)), (void *)P_INT_MASKL);
+		__raw_writel((__raw_readl(SCORE_PIC + INT_MASKL) & \
+			~(1 << irq_source)), SCORE_PIC + INT_MASKL);
 	else
-		__raw_writel((__raw_readl((void *)P_INT_MASKH) & \
-			~(1 << (irq_source - 32))), (void *)P_INT_MASKH);
+		__raw_writel((__raw_readl(SCORE_PIC + INT_MASKH) & \
+			~(1 << (irq_source - 32))), SCORE_PIC + INT_MASKH);
 }
 
 struct irq_chip score_irq_chip = {
@@ -88,8 +101,8 @@ void __init init_IRQ(void)
 		memcpy((void *)target_addr, \
 			interrupt_exception_vector, IRQ_VECTOR_SIZE);
 
-	__raw_writel(0xffffffff, (void *)P_INT_MASKL);
-	__raw_writel(0xffffffff, (void *)P_INT_MASKH);
+	__raw_writel(0xffffffff, SCORE_PIC + INT_MASKL);
+	__raw_writel(0xffffffff, SCORE_PIC + INT_MASKH);
 
 	__asm__ __volatile__(
 		"mtcr	%0, cr3\n\t"
-- 
1.6.3.1

