Return-Path: <linux-kernel-owner+w=401wt.eu-S1752096AbYLYMlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbYLYMlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 07:41:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbYLYMk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 07:40:56 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45324 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbYLYMk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 07:40:56 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for -tip] proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081225200020.50F0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081225105915.GA11560@elte.hu> <20081225200020.50F0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081225213640.50F3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 25 Dec 2008 21:40:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +#include <linux/irq.h>
> > 
> > looks good, but linux/irq.h cannot be included on all architectures. (for 
> > example s390 has no notion of 'hardirqs'). But we created linux/irqnr.h 
> > for this purpose - so including that should work better.
> 
> Oh, thanks good explain.
> I'll fix soon.

next spin is here.
I confirmed three architecture.

 1. alpha (without SPARSE_IRQ, build test by cross compiler only)
 2. ia64 (without SPARSE_IRQ)
 3. x86_64 (with SPARSE_IRQ)


==
Subject: [PATCH] proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
Impact: cleanup

commit 240d367b4e6c6e3c5075e034db14dba60a6f5fa7 has a bit strange analysis.
irq_desc() can be used old architecuture.

but in old code, for_each_irq_desc() sit in <linux/irq.h> and its header
can't be included from architecture independend code.

Right solusion is 

 - move for_each_irq_desc() to <linux/irqnr.h>
 - stat.c include <linux/irqnr.h>


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>
---
 fs/proc/stat.c        |   11 +++++------
 include/linux/irq.h   |   14 ++------------
 include/linux/irqnr.h |   26 ++++++++++++++------------
 kernel/irq/handle.c   |    9 +++++++--
 4 files changed, 28 insertions(+), 32 deletions(-)

Index: b/fs/proc/stat.c
===================================================================
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -9,6 +9,7 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/time.h>
+#include <linux/irqnr.h>
 #include <asm/cputime.h>
 
 #ifndef arch_irq_stat_cpu
@@ -27,6 +28,7 @@ static int show_stat(struct seq_file *p,
 	u64 sum = 0;
 	struct timespec boottime;
 	unsigned int per_irq_sum;
+	struct irq_desc *desc;
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = cputime64_zero;
@@ -44,11 +46,10 @@ static int show_stat(struct seq_file *p,
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
-		for_each_irq_nr(j) {
-#ifdef CONFIG_SPARSE_IRQ
-			if (!irq_to_desc(j))
+		for_each_irq_desc(j, desc) {
+			if (!desc)
 				continue;
-#endif
+
 			sum += kstat_irqs_cpu(j, i);
 		}
 		sum += arch_irq_stat_cpu(i);
@@ -95,12 +96,10 @@ static int show_stat(struct seq_file *p,
 	/* sum again ? it could be updated? */
 	for_each_irq_nr(j) {
 		per_irq_sum = 0;
-#ifdef CONFIG_SPARSE_IRQ
 		if (!irq_to_desc(j)) {
 			seq_printf(p, " %u", per_irq_sum);
 			continue;
 		}
-#endif
 		for_each_possible_cpu(i)
 			per_irq_sum += kstat_irqs_cpu(j, i);
 
Index: b/include/linux/irq.h
===================================================================
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -204,32 +204,22 @@ extern void arch_free_chip_data(struct i
 #ifndef CONFIG_SPARSE_IRQ
 extern struct irq_desc irq_desc[NR_IRQS];
 
-static inline struct irq_desc *irq_to_desc(unsigned int irq)
-{
-	return (irq < NR_IRQS) ? irq_desc + irq : NULL;
-}
 static inline struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
 {
 	return irq_to_desc(irq);
 }
 
-#else
+#else /* CONFIG_SPARSE_IRQ */
 
-extern struct irq_desc *irq_to_desc(unsigned int irq);
 extern struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu);
 extern struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int cpu);
 
-# define for_each_irq_desc(irq, desc)		\
-	for (irq = 0, desc = irq_to_desc(irq); irq < nr_irqs; irq++, desc = irq_to_desc(irq))
-# define for_each_irq_desc_reverse(irq, desc)                          \
-	for (irq = nr_irqs - 1, desc = irq_to_desc(irq); irq >= 0; irq--, desc = irq_to_desc(irq))
-
 #define kstat_irqs_this_cpu(DESC) \
 	((DESC)->kstat_irqs[smp_processor_id()])
 #define kstat_incr_irqs_this_cpu(irqno, DESC) \
 	((DESC)->kstat_irqs[smp_processor_id()]++)
 
-#endif
+#endif /* CONFIG_SPARSE_IRQ */
 
 static inline struct irq_desc *
 irq_remap_to_desc(unsigned int irq, struct irq_desc *desc)
Index: b/include/linux/irqnr.h
===================================================================
--- a/include/linux/irqnr.h
+++ b/include/linux/irqnr.h
@@ -11,24 +11,26 @@
 # define nr_irqs		NR_IRQS
 
 # define for_each_irq_desc(irq, desc)		\
-	for (irq = 0; irq < nr_irqs; irq++)
+	for (irq = 0, desc = NULL; irq < nr_irqs; irq++)
 
 # define for_each_irq_desc_reverse(irq, desc)                          \
-	for (irq = nr_irqs - 1; irq >= 0; irq--)
-#else
+	for (irq = nr_irqs - 1, desc = NULL; irq >= 0; irq--)
+#else /* CONFIG_GENERIC_HARDIRQS */
 
 extern int nr_irqs;
+struct irq_desc;
 
-#ifndef CONFIG_SPARSE_IRQ
+# define for_each_irq_desc(irq, desc)					\
+	for (irq = 0, desc = irq_to_desc(irq); irq < nr_irqs; 		\
+	     irq++, desc = irq_to_desc(irq))
 
-struct irq_desc;
-# define for_each_irq_desc(irq, desc)		\
-	for (irq = 0, desc = irq_desc; irq < nr_irqs; irq++, desc++)
-# define for_each_irq_desc_reverse(irq, desc)                          \
-	for (irq = nr_irqs - 1, desc = irq_desc + (nr_irqs - 1);        \
-	    irq >= 0; irq--, desc--)
-#endif
-#endif
+# define for_each_irq_desc_reverse(irq, desc)				\
+	for (irq = nr_irqs - 1, desc = irq_to_desc(irq); irq >= 0;	\
+	     irq--, desc = irq_to_desc(irq))
+
+extern struct irq_desc *irq_to_desc(unsigned int irq);
+
+#endif /* CONFIG_GENERIC_HARDIRQS */
 
 #define for_each_irq_nr(irq)                   \
        for (irq = 0; irq < nr_irqs; irq++)
Index: b/kernel/irq/handle.c
===================================================================
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -203,7 +203,7 @@ out_unlock:
 	return desc;
 }
 
-#else
+#else /* !CONFIG_SPARSE_IRQ */
 
 struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS-1] = {
@@ -218,7 +218,12 @@ struct irq_desc irq_desc[NR_IRQS] __cach
 	}
 };
 
-#endif
+struct irq_desc *irq_to_desc(unsigned int irq)
+{
+	return (irq < nr_irqs) ? irq_desc + irq : NULL;
+}
+
+#endif /* !CONFIG_SPARSE_IRQ */
 
 /*
  * What should we do if we get a hw irq event on an illegal vector?



