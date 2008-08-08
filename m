Return-Path: <linux-kernel-owner+w=401wt.eu-S1764286AbYHHWGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764286AbYHHWGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762272AbYHHVzC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:55:02 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:58025 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762043AbYHHVyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:54:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=H9Glb1yb1kskxT6Pu2/c6HpUlhgWLUGdkvYs5CBvvPcupedG0PUPNXJboTC0684eM4
         9VGlmCjEyE27B6QenSoaEosPZsBe0Kv0UTVa9/Rsao7Yh5bwPP99HfnEP/VbH00gedJ6
         SgQItllau1g9egp66WWNhxBrtF9r/PO8lGYSs=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 31/42] replace loop with nr_irqs with for_each_irq_desc
Date: Fri,  8 Aug 2008 14:52:37 -0700
Message-Id: <1218232368-31228-32-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-31-git-send-email-yhlu.kernel@gmail.com>
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-2-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-3-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-4-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-5-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-6-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-7-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-8-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-9-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-10-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-11-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-12-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-13-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-14-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-15-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-16-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-17-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-18-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-19-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-20-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-21-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-22-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-23-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-24-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-25-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-26-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-27-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-28-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-29-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-30-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-31-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so don't all irq_desc at begining to allocate all.
and only call that when needed

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic_64.c |    6 +++---
 arch/x86/kernel/irq_64.c     |    5 ++---
 arch/x86/kernel/irqinit_64.c |   17 +++++------------
 fs/proc/proc_misc.c          |    7 +++++--
 include/linux/irq.h          |   18 ++++++++++++++++++
 kernel/irq/handle.c          |   27 ++++++++++++++++++++++++---
 kernel/irq/internals.h       |    4 ++--
 kernel/irq/manage.c          |    2 +-
 kernel/irq/proc.c            |   10 +++++-----
 9 files changed, 65 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index c1941b7..784a882 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -1845,10 +1845,10 @@ unmask:
 
 static void ir_irq_migration(struct work_struct *work)
 {
-	int irq;
+	unsigned int irq;
+	struct irq_desc *desc;
 
-	for (irq = 0; irq < nr_irqs; irq++) {
-		struct irq_desc *desc = irq_desc(irq);
+	for_each_irq_desc(irq, desc) {
 		if (desc->status & IRQ_MOVE_PENDING) {
 			unsigned long flags;
 
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 61fe896..f79b68b 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -224,17 +224,16 @@ void fixup_irqs(cpumask_t map)
 {
 	unsigned int irq;
 	static int warned;
+	struct irq_desc *desc;
 
-	for (irq = 0; irq < nr_irqs; irq++) {
+	for_each_irq_desc(irq, desc) {
 		cpumask_t mask;
 		int break_affinity = 0;
 		int set_affinity = 1;
-		struct irq_desc *desc;
 
 		if (irq == 2)
 			continue;
 
-		desc = irq_desc(irq);
 		/* interrupt's are disabled at this point */
 		spin_lock(&desc->lock);
 
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 583db8b..4c55edf 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -142,25 +142,18 @@ static void __init init_ISA_irqs (void)
 	init_bsp_APIC();
 	init_8259A(0);
 
-	for (i = 0; i < nr_irqs; i++) {
+	for (i = 0; i < 16; i++) {
 		struct irq_desc *desc = irq_desc(i);
 
 		desc->status = IRQ_DISABLED;
 		desc->action = NULL;
 		desc->depth = 1;
 
-		if (i < 16) {
-			/*
-			 * 16 old-style INTA-cycle interrupts:
-			 */
-			set_irq_chip_and_handler_name(i, &i8259A_chip,
+		/*
+		 * 16 old-style INTA-cycle interrupts:
+		 */
+		set_irq_chip_and_handler_name(i, &i8259A_chip,
 						      handle_level_irq, "XT");
-		} else {
-			/*
-			 * 'high' PCI IRQs filled in on demand
-			 */
-			desc->chip = &no_irq_chip;
-		}
 	}
 }
 
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index aeb0a40..32de344 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -502,6 +502,7 @@ static int show_stat(struct seq_file *p, void *v)
 	u64 sum = 0;
 	struct timespec boottime;
 	unsigned int *per_irq_sum;
+	struct irq_desc *desc;
 
 	per_irq_sum = kzalloc(sizeof(unsigned int)*nr_irqs, GFP_KERNEL);
 	if (!per_irq_sum)
@@ -525,8 +526,10 @@ static int show_stat(struct seq_file *p, void *v)
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
-		for (j = 0; j < nr_irqs; j++) {
-			unsigned int temp = kstat_irqs_cpu(j, i);
+		for_each_irq_desc(j, desc) {
+			unsigned int temp;
+
+			temp = kstat_irqs_cpu(j, i);
 			sum += temp;
 			per_irq_sum[j] += temp;
 		}
diff --git a/include/linux/irq.h b/include/linux/irq.h
index f802abd..a712287 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -193,10 +193,28 @@ struct irq_desc {
 } ____cacheline_internodealigned_in_smp;
 
 extern struct irq_desc *irq_desc(unsigned int irq);
+extern struct irq_desc *irq_desc_without_new(unsigned int irq);
+
+#ifndef CONFIG_HAVE_SPARSE_IRQ
+
 #ifndef CONFIG_HAVE_DYN_ARRAY
 /* could be removed if we get rid of all irq_desc reference */
 extern struct irq_desc irq_descX[NR_IRQS];
+#else
+extern struct irq_desc *irq_descX;
+#endif
+
+#define for_each_irq_desc(irq, desc)		\
+	for (irq = 0, desc = irq_descX; irq < nr_irqs; irq++, desc = &irq_descX[irq])
+
+#else
+
+extern struct irq_desc *irq_descX;
+#define for_each_irq_desc(irqX, desc)		\
+	for (desc = irq_descX, irqX = desc->irq; desc && irqX != -1U; desc = desc->next, irqX = desc ? desc->irq: -1U)
+
 #endif
+
 #define kstat_irqs_this_cpu(DESC) \
 	((DESC)->kstat_irqs[smp_processor_id()])
 
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 1f23f78..e2cfbb6 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -111,7 +111,6 @@ static void init_kstat_irqs(struct irq_desc *desc, int nr_desc, int nr)
 	}
 }
 
-
 static void __init init_work(void *data)
 {
 	struct dyn_array *da = data;
@@ -148,9 +147,27 @@ static int __init parse_nr_irq_desc(char *arg)
 
 early_param("nr_irq_desc", parse_nr_irq_desc);
 
-static struct irq_desc *irq_descX;
+struct irq_desc *irq_descX;
 DEFINE_DYN_ARRAY(irq_descX, sizeof(struct irq_desc), nr_irq_desc, PAGE_SIZE, init_work);
 
+struct irq_desc *irq_desc_without_new(unsigned int irq)
+{
+	struct irq_desc *desc;
+
+	BUG_ON(irq == -1U);
+
+	desc = &irq_descX[0];
+	while (desc) {
+		if (desc->irq == irq)
+			return desc;
+
+		if (desc->irq == -1U)
+			return NULL;
+
+		desc = desc->next;
+	}
+	return NULL;
+}
 struct irq_desc *irq_desc(unsigned int irq)
 {
 	struct irq_desc *desc, *desc_pri;
@@ -208,7 +225,7 @@ struct irq_desc *irq_desc(unsigned int irq)
 }
 #else
 
-static struct irq_desc *irq_descX;
+struct irq_desc *irq_descX;
 DEFINE_DYN_ARRAY(irq_descX, sizeof(struct irq_desc), nr_irqs, PAGE_SIZE, init_work);
 
 #endif
@@ -238,6 +255,10 @@ struct irq_desc *irq_desc(unsigned int irq)
 
 	return NULL;
 }
+struct irq_desc *irq_desc_without_new(unsigned int irq)
+{
+	return irq_desc(irq);
+}
 #endif
 
 /*
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 08a849a..605e88c 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -11,11 +11,11 @@ extern void irq_chip_set_defaults(struct irq_chip *chip);
 extern void compat_irq_chip_set_default_handler(struct irq_desc *desc);
 
 #ifdef CONFIG_PROC_FS
-extern void register_irq_proc(unsigned int irq);
+extern void register_irq_proc(unsigned int irq, struct irq_desc *desc);
 extern void register_handler_proc(unsigned int irq, struct irqaction *action);
 extern void unregister_handler_proc(unsigned int irq, struct irqaction *action);
 #else
-static inline void register_irq_proc(unsigned int irq) { }
+static inline void register_irq_proc(unsigned int irq, struct irq_desc *desc) { }
 static inline void register_handler_proc(unsigned int irq,
 					 struct irqaction *action) { }
 static inline void unregister_handler_proc(unsigned int irq,
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 4a31fc8..2bbe43e 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -466,7 +466,7 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 	spin_unlock_irqrestore(&desc->lock, flags);
 
 	new->irq = irq;
-	register_irq_proc(irq);
+	register_irq_proc(irq, desc);
 	new->dir = NULL;
 	register_handler_proc(irq, new);
 
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index ffb6000..32dd7b9 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -163,11 +163,10 @@ void register_handler_proc(unsigned int irq, struct irqaction *action)
 
 #define MAX_NAMELEN 10
 
-void register_irq_proc(unsigned int irq)
+void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 {
 	char name [MAX_NAMELEN];
 	struct proc_dir_entry *entry;
-	struct irq_desc *desc = irq_desc(irq);
 
 	if (!root_irq_dir ||
 		(desc->chip == &no_irq_chip) || desc->dir)
@@ -226,7 +225,8 @@ void register_default_affinity_proc(void)
 
 void init_irq_proc(void)
 {
-	int i;
+	unsigned int irq;
+	struct irq_desc *desc;
 
 	/* create /proc/irq */
 	root_irq_dir = proc_mkdir("irq", NULL);
@@ -238,7 +238,7 @@ void init_irq_proc(void)
 	/*
 	 * Create entries for all existing IRQs.
 	 */
-	for (i = 0; i < nr_irqs; i++)
-		register_irq_proc(i);
+	for_each_irq_desc(irq, desc)
+		register_irq_proc(irq, desc);
 }
 
-- 
1.5.4.5

