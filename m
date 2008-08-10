Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbYHJHtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbYHJHtZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 03:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909AbYHJHjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 03:39:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:7020 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064AbYHJHjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 03:39:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UCXvf7N/CBLD4UJ8I851F+bF4wDReHqpnO/BQBZdAaISsXqSkpgXlXEcTfbLOXuo9z
         TFO3HGChc1ygLDlbBxnhx5YhKtgF6Is/oLbkMtLbgbANhNoOiv/WZAt4Sxg8M0PY5TBV
         RvFhGZoDpVfUYqPCEi6lFQHk69CfziVblH1Qs=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 33/43] replace loop with nr_irqs with for_each_irq_desc
Date: Sun, 10 Aug 2008 00:36:22 -0700
Message-Id: <1218353792-3355-34-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218353792-3355-33-git-send-email-yhlu.kernel@gmail.com>
References: <1218353792-3355-1-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-2-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-3-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-4-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-5-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-6-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-7-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-8-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-9-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-10-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-11-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-12-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-13-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-14-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-15-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-16-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-17-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-18-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-19-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-20-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-21-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-22-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-23-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-24-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-25-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-26-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-27-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-28-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-29-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-30-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-31-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-32-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-33-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so don't all irq_desc at begining to allocate all.
and only call that when needed

v2: make sure arch without GENERIC_HARDIRQS works too

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic_64.c |    6 +++---
 arch/x86/kernel/irq_64.c     |    5 ++---
 arch/x86/kernel/irqinit_64.c |   17 +++++------------
 include/linux/irq.h          |    5 +++++
 kernel/irq/internals.h       |    4 ++--
 kernel/irq/manage.c          |    2 +-
 kernel/irq/proc.c            |   10 +++++-----
 7 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 32a18a4..0fc7f5a 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -1868,10 +1868,10 @@ unmask:
 
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
index 71b04bd..ee5ee2d 100644
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
 
diff --git a/include/linux/irq.h b/include/linux/irq.h
index c13e645..4e39f2d 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -202,9 +202,14 @@ extern struct irq_desc irq_descX[NR_IRQS];
 extern struct irq_desc *irq_descX;
 #endif
 
+#define for_each_irq_desc(irq, desc)		\
+	for (irq = 0, desc = irq_descX; irq < nr_irqs; irq++, desc = &irq_descX[irq])
+
 #else
 
 extern struct irq_desc *irq_descX;
+#define for_each_irq_desc(irqX, desc)		\
+	for (desc = irq_descX, irqX = desc->irq; desc && irqX != -1U; desc = desc->next, irqX = desc ? desc->irq : -1U)
 
 #endif
 
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
index c6b0edf..b7e30f2 100644
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

