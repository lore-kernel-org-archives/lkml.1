Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbYI2SKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbYI2SKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbYI2SDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58638 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753988AbYI2SCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:53 -0400
Message-Id: <20080929180253.123921000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:03:12 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 22/31] cpumask: clean irq files
Content-Disposition: inline; filename=clean-irq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/irq_64.c |    6 +++---
 include/asm-x86/irq.h    |    2 +-
 include/linux/irq.h      |   10 +++++-----
 kernel/irq/manage.c      |   12 ++++++------
 kernel/irq/migration.c   |    6 +++---
 kernel/irq/proc.c        |   13 +++++++------
 6 files changed, 25 insertions(+), 24 deletions(-)

--- struct-cpumasks.orig/arch/x86/kernel/irq_64.c
+++ struct-cpumasks/arch/x86/kernel/irq_64.c
@@ -242,14 +242,14 @@ asmlinkage unsigned int do_IRQ(struct pt
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-void fixup_irqs(cpumask_t map)
+void fixup_irqs(const_cpumask_t map)
 {
 	unsigned int irq;
 	static int warned;
 	struct irq_desc *desc;
+	cpumask_var_t mask;
 
 	for_each_irq_desc(irq, desc) {
-		cpumask_t mask;
 		int break_affinity = 0;
 		int set_affinity = 1;
 
@@ -268,7 +268,7 @@ void fixup_irqs(cpumask_t map)
 		cpus_and(mask, desc->affinity, map);
 		if (cpus_empty(mask)) {
 			break_affinity = 1;
-			mask = map;
+			cpus_copy(mask, map);
 		}
 
 		if (desc->chip->mask)
--- struct-cpumasks.orig/include/asm-x86/irq.h
+++ struct-cpumasks/include/asm-x86/irq.h
@@ -37,7 +37,7 @@ extern int irqbalance_disable(char *str)
 
 #ifdef CONFIG_HOTPLUG_CPU
 #include <linux/cpumask.h>
-extern void fixup_irqs(cpumask_t map);
+extern void fixup_irqs(const_cpumask_t map);
 #endif
 
 extern unsigned int do_IRQ(struct pt_regs *regs);
--- struct-cpumasks.orig/include/linux/irq.h
+++ struct-cpumasks/include/linux/irq.h
@@ -111,7 +111,7 @@ struct irq_chip {
 	void		(*eoi)(unsigned int irq);
 
 	void		(*end)(unsigned int irq);
-	void		(*set_affinity)(unsigned int irq, cpumask_t dest);
+	void		(*set_affinity)(unsigned int irq, const_cpumask_t dest);
 	int		(*retrigger)(unsigned int irq);
 	int		(*set_type)(unsigned int irq, unsigned int flow_type);
 	int		(*set_wake)(unsigned int irq, unsigned int on);
@@ -180,11 +180,11 @@ struct irq_desc {
 	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
 	spinlock_t		lock;
 #ifdef CONFIG_SMP
-	cpumask_t		affinity;
+	cpumask_map_t		affinity;
 	unsigned int		cpu;
 #endif
 #ifdef CONFIG_GENERIC_PENDING_IRQ
-	cpumask_t		pending_mask;
+	cpumask_map_t		pending_mask;
 #endif
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry	*dir;
@@ -243,7 +243,7 @@ extern int setup_irq(unsigned int irq, s
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 
-void set_pending_irq(unsigned int irq, cpumask_t mask);
+void set_pending_irq(unsigned int irq, const_cpumask_t mask);
 void move_native_irq(int irq);
 void move_masked_irq(int irq);
 
@@ -261,7 +261,7 @@ static inline void move_masked_irq(int i
 {
 }
 
-static inline void set_pending_irq(unsigned int irq, cpumask_t mask)
+static inline void set_pending_irq(unsigned int irq, const_cpumask_t mask)
 {
 }
 
--- struct-cpumasks.orig/kernel/irq/manage.c
+++ struct-cpumasks/kernel/irq/manage.c
@@ -17,7 +17,7 @@
 
 #ifdef CONFIG_SMP
 
-cpumask_t irq_default_affinity = CPU_MASK_ALL;
+cpumask_map_t irq_default_affinity = CPU_MASK_ALL;
 
 /**
  *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
@@ -79,7 +79,7 @@ int irq_can_set_affinity(unsigned int ir
  *	@cpumask:	cpumask
  *
  */
-int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
+int irq_set_affinity(unsigned int irq, const_cpumask_t cpumask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
@@ -91,13 +91,13 @@ int irq_set_affinity(unsigned int irq, c
 		unsigned long flags;
 
 		spin_lock_irqsave(&desc->lock, flags);
-		desc->affinity = cpumask;
+		cpus_copy(desc->affinity, cpumask);
 		desc->chip->set_affinity(irq, cpumask);
 		spin_unlock_irqrestore(&desc->lock, flags);
 	} else
 		set_pending_irq(irq, cpumask);
 #else
-	desc->affinity = cpumask;
+	cpus_copy(desc->affinity, cpumask);
 	desc->chip->set_affinity(irq, cpumask);
 #endif
 	return 0;
@@ -109,7 +109,7 @@ int irq_set_affinity(unsigned int irq, c
  */
 int irq_select_affinity(unsigned int irq)
 {
-	cpumask_t mask;
+	cpumask_var_t mask;
 	struct irq_desc *desc;
 
 	if (!irq_can_set_affinity(irq))
@@ -118,7 +118,7 @@ int irq_select_affinity(unsigned int irq
 	cpus_and(mask, cpu_online_map, irq_default_affinity);
 
 	desc = irq_to_desc(irq);
-	desc->affinity = mask;
+	cpus_copy(desc->affinity, mask);
 	desc->chip->set_affinity(irq, mask);
 
 	return 0;
--- struct-cpumasks.orig/kernel/irq/migration.c
+++ struct-cpumasks/kernel/irq/migration.c
@@ -1,21 +1,21 @@
 
 #include <linux/irq.h>
 
-void set_pending_irq(unsigned int irq, cpumask_t mask)
+void set_pending_irq(unsigned int irq, const_cpumask_t mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
 
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->status |= IRQ_MOVE_PENDING;
-	desc->pending_mask = mask;
+	cpus_copy(desc->pending_mask, mask);
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
 
 void move_masked_irq(int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	cpumask_t tmp;
+	cpumask_var_t tmp;
 
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
--- struct-cpumasks.orig/kernel/irq/proc.c
+++ struct-cpumasks/kernel/irq/proc.c
@@ -20,11 +20,12 @@ static struct proc_dir_entry *root_irq_d
 static int irq_affinity_proc_show(struct seq_file *m, void *v)
 {
 	struct irq_desc *desc = irq_to_desc((long)m->private);
-	cpumask_t *mask = &desc->affinity;
+	cpumask_var_t mask;
 
+	cpus_copy(mask, desc->affinity);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	if (desc->status & IRQ_MOVE_PENDING)
-		mask = &desc->pending_mask;
+		cpus_copy(mask, desc->pending_mask);
 #endif
 	seq_cpumask(m, mask);
 	seq_putc(m, '\n');
@@ -40,7 +41,7 @@ static ssize_t irq_affinity_proc_write(s
 		const char __user *buffer, size_t count, loff_t *pos)
 {
 	unsigned int irq = (int)(long)PDE(file->f_path.dentry->d_inode)->data;
-	cpumask_t new_value;
+	cpumask_var_t new_value;
 	int err;
 
 	if (!irq_to_desc(irq)->chip->set_affinity || no_irq_affinity ||
@@ -84,7 +85,7 @@ static const struct file_operations irq_
 
 static int default_affinity_show(struct seq_file *m, void *v)
 {
-	seq_cpumask(m, &irq_default_affinity);
+	seq_cpumask(m, irq_default_affinity);
 	seq_putc(m, '\n');
 	return 0;
 }
@@ -92,7 +93,7 @@ static int default_affinity_show(struct 
 static ssize_t default_affinity_write(struct file *file,
 		const char __user *buffer, size_t count, loff_t *ppos)
 {
-	cpumask_t new_value;
+	cpumask_var_t new_value;
 	int err;
 
 	err = cpumask_parse_user(buffer, count, new_value);
@@ -110,7 +111,7 @@ static ssize_t default_affinity_write(st
 	if (!cpus_intersects(new_value, cpu_online_map))
 		return -EINVAL;
 
-	irq_default_affinity = new_value;
+	cpus_copy(irq_default_affinity, new_value);
 
 	return count;
 }

-- 
