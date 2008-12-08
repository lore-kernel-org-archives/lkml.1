Return-Path: <linux-kernel-owner+w=401wt.eu-S1753771AbYLHWHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbYLHWHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 17:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbYLHWHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 17:07:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:34778 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbYLHWHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 17:07:35 -0500
Message-ID: <493D9A59.2030508@kernel.org>
Date: Mon, 08 Dec 2008 14:06:17 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix compiling with alpha
References: <86802c440812050120i6f5557dfo9c05bb43272ec807@mail.gmail.com> <20081205103002.GA5325@elte.hu> <49397CD0.9030301@kernel.org> <20081208142307.GE14856@elte.hu> <20081208150129.GA21496@elte.hu>
In-Reply-To: <20081208150129.GA21496@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix

can not use irq_desc in stat.c for some arch

Signed-off-by: Yinghai Lu <yinghai@kernel.orgg>

---
 fs/proc/stat.c        |   20 +++++++++++++-------
 include/linux/irq.h   |    9 ---------
 include/linux/irqnr.h |   19 ++++++++++++++++---
 3 files changed, 29 insertions(+), 19 deletions(-)

Index: linux-2.6/fs/proc/stat.c
===================================================================
--- linux-2.6.orig/fs/proc/stat.c
+++ linux-2.6/fs/proc/stat.c
@@ -45,9 +45,12 @@ static int show_stat(struct seq_file *p,
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
-		for_each_irq_desc(j, desc) {
+		for_each_irq_nr(j) {
+#ifdef CONFIG_SPARSE_IRQ
+			desc = irq_to_desc(j);
 			if (!desc)
 				continue;
+#endif
 			sum += kstat_irqs_cpu(j, i);
 		}
 		sum += arch_irq_stat_cpu(i);
@@ -92,14 +95,17 @@ static int show_stat(struct seq_file *p,
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
 	/* sum again ? it could be updated? */
-	for (j = 0; j < NR_IRQS; j++) {
-		desc = irq_to_desc(j);
+	for_each_irq_nr(j) {
 		per_irq_sum = 0;
-
-		if (desc) {
-			for_each_possible_cpu(i)
-				per_irq_sum += kstat_irqs_cpu(j, i);
+#ifdef CONFIG_SPARSE_IRQ
+		desc = irq_to_desc(j);
+		if (!desc) {
+			seq_printf(p, " %u", per_irq_sum);
+			continue;
 		}
+#endif
+		for_each_possible_cpu(i)
+			per_irq_sum += kstat_irqs_cpu(j, i);
 
 		seq_printf(p, " %u", per_irq_sum);
 	}
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -198,7 +198,6 @@ extern void arch_init_copy_chip_data(str
 extern void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc);
 
 #ifndef CONFIG_SPARSE_IRQ
-
 extern struct irq_desc irq_desc[NR_IRQS];
 
 static inline struct irq_desc *irq_to_desc(unsigned int irq)
@@ -210,14 +209,6 @@ static inline struct irq_desc *irq_to_de
 	return irq_to_desc(irq);
 }
 
-#ifdef CONFIG_GENERIC_HARDIRQS
-# define for_each_irq_desc(irq, desc)		\
-	for (irq = 0, desc = irq_desc; irq < nr_irqs; irq++, desc++)
-# define for_each_irq_desc_reverse(irq, desc)                          \
-	for (irq = nr_irqs - 1, desc = irq_desc + (nr_irqs - 1);        \
-	    irq >= 0; irq--, desc--)
-#endif
-
 #else
 
 extern struct irq_desc *irq_to_desc(unsigned int irq);
Index: linux-2.6/include/linux/irqnr.h
===================================================================
--- linux-2.6.orig/include/linux/irqnr.h
+++ linux-2.6/include/linux/irqnr.h
@@ -8,9 +8,22 @@
 # define for_each_irq_desc(irq, desc)		\
 	for (irq = 0; irq < nr_irqs; irq++)
 
-static inline early_sparse_irq_init(void)
-{
-}
+# define for_each_irq_desc_reverse(irq, desc)                          \
+	for (irq = nr_irqs - 1; irq >= 0; irq--)
+#else
+#ifndef CONFIG_SPARSE_IRQ
+
+struct irq_desc;
+extern int nr_irqs;
+# define for_each_irq_desc(irq, desc)		\
+	for (irq = 0, desc = irq_desc; irq < nr_irqs; irq++, desc++)
+# define for_each_irq_desc_reverse(irq, desc)                          \
+	for (irq = nr_irqs - 1, desc = irq_desc + (nr_irqs - 1);        \
+	    irq >= 0; irq--, desc--)
 #endif
+#endif
+
+#define for_each_irq_nr(irq)                   \
+       for (irq = 0; irq < nr_irqs; irq++)
 
 #endif

