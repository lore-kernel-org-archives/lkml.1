Return-Path: <linux-kernel-owner+w=401wt.eu-S1757786AbYHJHsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786AbYHJHsB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 03:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbYHJHjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 03:39:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:3859 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018AbYHJHix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 03:38:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ktqBL8ZTNB9sfcx4Ukn5GdlhgF5wsob2+MbeYbiESJx0lrV7v3XxnBwyOLcGJjHeJR
         MkdQ3Jp5560lVxH/dhX8bhdTCQLs/dl9vYM59Oc9yrB1xGMLWHylbjRRehHNd+AIF+WQ
         zOChorMXVjwYpNaDfOE6xF6/GXt+/BSb7mcAc=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 29/43] x86: put irq_2_pin pointer into irq_cfg
Date: Sun, 10 Aug 2008 00:36:18 -0700
Message-Id: <1218353792-3355-30-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218353792-3355-29-git-send-email-yhlu.kernel@gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

preallocate 32 irq_2_pin, and use get_one_free_irq_2_pin to get one
and link to irq_cfg if needed.
so don't waste one for no irq is enabled.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic_64.c |  161 +++++++++++++++++++++++++++++++-----------
 1 files changed, 120 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index ff72b6f..32a18a4 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -58,10 +58,11 @@
 #define __apicdebuginit(type) static type __init
 
 struct irq_cfg;
-
+struct irq_pin_list;
 struct irq_cfg {
 	unsigned int irq;
 	struct irq_cfg *next;
+	struct irq_pin_list *irq_2_pin;
 	cpumask_t domain;
 	cpumask_t old_domain;
 	unsigned move_cleanup_count;
@@ -252,13 +253,66 @@ int pin_map_size;
  * between pins and IRQs.
  */
 
-static struct irq_pin_list {
-	short apic, pin;
-	int next;
-} *irq_2_pin;
+struct irq_pin_list {
+	int apic, pin;
+	struct irq_pin_list *next;
+};
+
+static struct irq_pin_list *irq_2_pin_head;
+/* fill one page ? */
+static int nr_irq_2_pin = 0x100;
+static struct irq_pin_list *irq_2_pin_ptr;
+static void __init irq_2_pin_init_work(void *data)
+{
+	struct dyn_array *da = data;
+	struct irq_pin_list *pin;
+	int i;
+
+	pin = *da->name;
+
+	for (i = 1; i < *da->nr; i++)
+		pin[i-1].next = &pin[i];
+
+	irq_2_pin_ptr = &pin[0];
+}
+DEFINE_DYN_ARRAY(irq_2_pin_head, sizeof(struct irq_pin_list), nr_irq_2_pin, PAGE_SIZE, irq_2_pin_init_work);
+
+static struct irq_pin_list *get_one_free_irq_2_pin(void)
+{
+	struct irq_pin_list *pin;
+	int i;
+
+	pin = irq_2_pin_ptr;
+
+	if (pin) {
+		irq_2_pin_ptr = pin->next;
+		pin->next = NULL;
+		return pin;
+	}
+
+	/*
+	 *  we run out of pre-allocate ones, allocate more
+	 */
+	printk(KERN_DEBUG "try to get more irq_2_pin %d\n", nr_irq_2_pin);
+
+	if (after_bootmem)
+		pin = kzalloc(sizeof(struct irq_pin_list)*nr_irq_2_pin,
+				 GFP_ATOMIC);
+	else
+		pin = __alloc_bootmem_nopanic(sizeof(struct irq_pin_list) *
+				nr_irq_2_pin, PAGE_SIZE, 0);
+
+	if (!pin)
+		panic("can not get more irq_2_pin\n");
 
-DEFINE_DYN_ARRAY(irq_2_pin, sizeof(struct irq_pin_list), pin_map_size, sizeof(struct irq_pin_list), NULL);
+	for (i = 1; i < nr_irq_2_pin; i++)
+		pin[i-1].next = &pin[i];
 
+	irq_2_pin_ptr = pin->next;
+	pin->next = NULL;
+
+	return pin;
+}
 
 struct io_apic {
 	unsigned int index;
@@ -300,16 +354,17 @@ static bool io_apic_level_ack_pending(unsigned int irq)
 {
 	struct irq_pin_list *entry;
 	unsigned long flags;
+	struct irq_cfg *cfg = irq_cfg(irq);
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	entry = irq_2_pin + irq;
+	entry = cfg->irq_2_pin;
 	for (;;) {
 		unsigned int reg;
 		int pin;
 
-		pin = entry->pin;
-		if (pin == -1)
+		if (!entry)
 			break;
+		pin = entry->pin;
 		reg = io_apic_read(entry->apic, 0x10 + pin*2);
 		/* Is the remote IRR bit set? */
 		if (reg & IO_APIC_REDIR_REMOTE_IRR) {
@@ -318,7 +373,7 @@ static bool io_apic_level_ack_pending(unsigned int irq)
 		}
 		if (!entry->next)
 			break;
-		entry = irq_2_pin + entry->next;
+		entry = entry->next;
 	}
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
@@ -339,21 +394,24 @@ static inline void io_apic_sync(unsigned int apic)
 									\
 {									\
 	int pin;							\
-	struct irq_pin_list *entry = irq_2_pin + irq;			\
+	struct irq_cfg *cfg;						\
+	struct irq_pin_list *entry;					\
 									\
 	BUG_ON(irq >= nr_irqs);						\
+	cfg = irq_cfg(irq);						\
+	entry = cfg->irq_2_pin;						\
 	for (;;) {							\
 		unsigned int reg;					\
-		pin = entry->pin;					\
-		if (pin == -1)						\
+		if (!entry)						\
 			break;						\
+		pin = entry->pin;					\
 		reg = io_apic_read(entry->apic, 0x10 + R + pin*2);	\
 		reg ACTION;						\
 		io_apic_modify(entry->apic, reg);			\
 		FINAL;							\
 		if (!entry->next)					\
 			break;						\
-		entry = irq_2_pin + entry->next;			\
+		entry = entry->next;					\
 	}								\
 }
 
@@ -416,15 +474,20 @@ static void ioapic_mask_entry(int apic, int pin)
 static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, u8 vector)
 {
 	int apic, pin;
-	struct irq_pin_list *entry = irq_2_pin + irq;
+	struct irq_cfg *cfg;
+	struct irq_pin_list *entry;
 
 	BUG_ON(irq >= nr_irqs);
+	cfg = irq_cfg(irq);
+	entry = cfg->irq_2_pin;
 	for (;;) {
 		unsigned int reg;
+
+		if (!entry)
+			break;
+
 		apic = entry->apic;
 		pin = entry->pin;
-		if (pin == -1)
-			break;
 		/*
 		 * With interrupt-remapping, destination information comes
 		 * from interrupt-remapping table entry.
@@ -437,7 +500,7 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, u8 vector)
 		io_apic_modify(apic, reg);
 		if (!entry->next)
 			break;
-		entry = irq_2_pin + entry->next;
+		entry = entry->next;
 	}
 }
 
@@ -480,22 +543,35 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
 int first_free_entry;
 static void add_pin_to_irq(unsigned int irq, int apic, int pin)
 {
-	struct irq_pin_list *entry = irq_2_pin + irq;
+	struct irq_cfg *cfg;
+	struct irq_pin_list *entry;
 
 	BUG_ON(irq >= nr_irqs);
-	irq_cfg_with_new(irq);
+	/* first time to refer irq_cfg, so with new */
+	cfg = irq_cfg_with_new(irq);
+	entry = cfg->irq_2_pin;
+	if (!entry) {
+		entry = get_one_free_irq_2_pin();
+		cfg->irq_2_pin = entry;
+		entry->apic = apic;
+		entry->pin = pin;
+		printk(KERN_DEBUG " 0 add_pin_to_irq: irq %d --> apic %d pin %d\n", irq, apic, pin);
+		return;
+	}
 
-	while (entry->next)
-		entry = irq_2_pin + entry->next;
+	while (entry->next) {
+		/* not again, please */
+		if (entry->apic == apic && entry->pin == pin)
+			return;
 
-	if (entry->pin != -1) {
-		entry->next = first_free_entry;
-		entry = irq_2_pin + entry->next;
-		if (++first_free_entry >= pin_map_size)
-			panic("io_apic.c: ran out of irq_2_pin entries!");
+		entry = entry->next;
 	}
+
+	entry->next = get_one_free_irq_2_pin();
+	entry = entry->next;
 	entry->apic = apic;
 	entry->pin = pin;
+	printk(KERN_DEBUG " x add_pin_to_irq: irq %d --> apic %d pin %d\n", irq, apic, pin);
 }
 
 /*
@@ -505,17 +581,24 @@ static void __init replace_pin_at_irq(unsigned int irq,
 				      int oldapic, int oldpin,
 				      int newapic, int newpin)
 {
-	struct irq_pin_list *entry = irq_2_pin + irq;
+	struct irq_cfg *cfg = irq_cfg(irq);
+	struct irq_pin_list *entry = cfg->irq_2_pin;
+	int replaced = 0;
 
-	while (1) {
+	while (entry) {
 		if (entry->apic == oldapic && entry->pin == oldpin) {
 			entry->apic = newapic;
 			entry->pin = newpin;
-		}
-		if (!entry->next)
+			replaced = 1;
+			/* every one is different, right? */
 			break;
-		entry = irq_2_pin + entry->next;
+		}
+		entry = entry->next;
 	}
+
+	/* why? call replace before add? */
+	if (!replaced)
+		add_pin_to_irq(irq, newapic, newpin);
 }
 
 
@@ -1321,15 +1404,16 @@ __apicdebuginit(void) print_IO_APIC(void)
 	}
 	printk(KERN_DEBUG "IRQ to pin mappings:\n");
 	for (i = 0; i < nr_irqs; i++) {
-		struct irq_pin_list *entry = irq_2_pin + i;
-		if (entry->pin < 0)
+		struct irq_cfg *cfg = irq_cfg(i);
+		struct irq_pin_list *entry = cfg->irq_2_pin;
+		if (!entry)
 			continue;
 		printk(KERN_DEBUG "IRQ%d ", i);
 		for (;;) {
 			printk("-> %d:%d", entry->apic, entry->pin);
 			if (!entry->next)
 				break;
-			entry = irq_2_pin + entry->next;
+			entry = entry->next;
 		}
 		printk("\n");
 	}
@@ -1490,14 +1574,9 @@ void __init enable_IO_APIC(void)
 {
 	union IO_APIC_reg_01 reg_01;
 	int i8259_apic, i8259_pin;
-	int i, apic;
+	int apic;
 	unsigned long flags;
 
-	for (i = 0; i < pin_map_size; i++) {
-		irq_2_pin[i].pin = -1;
-		irq_2_pin[i].next = 0;
-	}
-
 	/*
 	 * The number of IO-APIC IRQ registers (== #pins):
 	 */
-- 
1.5.4.5

