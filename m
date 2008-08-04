Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbYHDKMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbYHDKMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 06:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbYHDKLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 06:11:03 -0400
Received: from qb-out-0506.google.com ([72.14.204.233]:26698 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064AbYHDKLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:11:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vtO4BdwicyQS8xj/REsp1NP4YDVK7MwjocS2S0aNU0ICSevvzDpytAoB4oIUPW5Wch
         dXQNs+icgflHbwOCFKwx6M7R82lsjaYQw6qizKnFoVxXo70bfUzrKtXw/g+ByByytCwV
         BjiZXJgXu+DQDZllkNePBFiqzdfGiYNY4Sf5I=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 04/04] x86: put irq_2_pin pointer into irq_cfg - 64bit
Date: Mon,  4 Aug 2008 03:10:01 -0700
Message-Id: <1217844601-4298-5-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217844601-4298-4-git-send-email-yhlu.kernel@gmail.com>
References: <1217844601-4298-1-git-send-email-yhlu.kernel@gmail.com>
 <1217844601-4298-2-git-send-email-yhlu.kernel@gmail.com>
 <1217844601-4298-3-git-send-email-yhlu.kernel@gmail.com>
 <1217844601-4298-4-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

preallocate 32 irq_2_pin, and use get_one_free_irq_2_pin to get one
and link to irq_cfg if needed.
so don't waste one for no irq is enabled.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/io_apic_64.c |  134 +++++++++++++++++++++++++++++++------------
 1 file changed, 97 insertions(+), 37 deletions(-)

Index: linux-2.6/arch/x86/kernel/io_apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_64.c
+++ linux-2.6/arch/x86/kernel/io_apic_64.c
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
@@ -232,13 +233,62 @@ int pin_map_size;
  * between pins and IRQs.
  */
 
-static struct irq_pin_list {
+struct irq_pin_list {
 	short apic, pin;
-	int next;
-} *irq_2_pin;
+	struct irq_pin_list *next;
+};
+
+static struct irq_pin_list *irq_2_pin_head;
+static int nr_irq_2_pin = 32;
+static struct irq_pin_list *irq_2_pin_ptr;
+static void __init irq_2_pin_init_work(void *data)
+{
+	struct dyn_array *da = data;
+	struct irq_pin_list *pin;
+	int i;
+
+	pin = *da->name;
 
-DEFINE_DYN_ARRAY(irq_2_pin, sizeof(struct irq_pin_list), pin_map_size, sizeof(struct irq_pin_list), NULL);
+	for (i = 1; i < *da->nr; i++)
+		pin[i-1].next = &pin[i];
+
+	irq_2_pin_ptr = &pin[0];
+}
+DEFINE_DYN_ARRAY(irq_2_pin_head, sizeof(struct irq_pin_list), nr_irq_2_pin, sizeof(struct irq_pin_list), irq_2_pin_init_work);
+
+static struct irq_pin_list *get_one_free_irq_2_pin(void)
+{
+	struct irq_pin_list *pin;
+	int i;
 
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
+		pin = __alloc_bootmem_nopanic( sizeof(struct irq_pin_list) *
+				nr_irq_2_pin, PAGE_SIZE, 0);
+
+	for (i = 1; i < nr_irq_2_pin; i++)
+		pin[i-1].next = &pin[i];
+
+	irq_2_pin_ptr = pin->next;
+	pin->next = NULL;
+
+	return pin;
+}
 
 struct io_apic {
 	unsigned int index;
@@ -280,16 +330,17 @@ static bool io_apic_level_ack_pending(un
 {
 	struct irq_pin_list *entry;
 	unsigned long flags;
+	struct irq_cfg *cfg = get_irq_cfg(irq);
 
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
@@ -298,7 +349,7 @@ static bool io_apic_level_ack_pending(un
 		}
 		if (!entry->next)
 			break;
-		entry = irq_2_pin + entry->next;
+		entry = entry->next;
 	}
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
@@ -319,7 +370,8 @@ static inline void io_apic_sync(unsigned
 									\
 {									\
 	int pin;							\
-	struct irq_pin_list *entry = irq_2_pin + irq;			\
+	struct irq_cfg *cfg = get_irq_cfg(irq);				\
+	struct irq_pin_list *entry = cfg->irq_2_pin;			\
 									\
 	BUG_ON(irq >= nr_irqs);						\
 	for (;;) {							\
@@ -333,7 +385,7 @@ static inline void io_apic_sync(unsigned
 		FINAL;							\
 		if (!entry->next)					\
 			break;						\
-		entry = irq_2_pin + entry->next;			\
+		entry = entry->next;					\
 	}								\
 }
 
@@ -396,15 +448,20 @@ static void ioapic_mask_entry(int apic,
 static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, u8 vector)
 {
 	int apic, pin;
-	struct irq_pin_list *entry = irq_2_pin + irq;
+	struct irq_cfg *cfg;
+	struct irq_pin_list *entry;
 
 	BUG_ON(irq >= nr_irqs);
+	cfg = get_irq_cfg(irq);
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
@@ -417,7 +474,7 @@ static void __target_IO_APIC_irq(unsigne
 		io_apic_modify(apic, reg);
 		if (!entry->next)
 			break;
-		entry = irq_2_pin + entry->next;
+		entry = entry->next;
 	}
 }
 
@@ -460,18 +517,25 @@ static void set_ioapic_affinity_irq(unsi
 int first_free_entry;
 static void add_pin_to_irq(unsigned int irq, int apic, int pin)
 {
-	struct irq_pin_list *entry = irq_2_pin + irq;
+	struct irq_cfg *cfg;
+	struct irq_pin_list *entry;
 
 	BUG_ON(irq >= nr_irqs);
-	while (entry->next)
-		entry = irq_2_pin + entry->next;
+	cfg = get_irq_cfg(irq);
+	entry = cfg->irq_2_pin;
+	if (!entry) {
+		entry = get_one_free_irq_2_pin();
+		cfg->irq_2_pin = entry;
+		entry->apic = apic;
+		entry->pin = pin;
 
-	if (entry->pin != -1) {
-		entry->next = first_free_entry;
-		entry = irq_2_pin + entry->next;
-		if (++first_free_entry >= pin_map_size)
-			panic("io_apic.c: ran out of irq_2_pin entries!");
+		return;
 	}
+	while (entry->next)
+		entry = entry->next;
+
+	entry->next = get_one_free_irq_2_pin();
+	entry = entry->next;
 	entry->apic = apic;
 	entry->pin = pin;
 }
@@ -483,16 +547,16 @@ static void __init replace_pin_at_irq(un
 				      int oldapic, int oldpin,
 				      int newapic, int newpin)
 {
-	struct irq_pin_list *entry = irq_2_pin + irq;
+	struct irq_cfg *cfg = get_irq_cfg(irq);
+	struct irq_pin_list *entry = cfg->irq_2_pin;
 
-	while (1) {
+	while (entry) {
 		if (entry->apic == oldapic && entry->pin == oldpin) {
 			entry->apic = newapic;
 			entry->pin = newpin;
-		}
-		if (!entry->next)
 			break;
-		entry = irq_2_pin + entry->next;
+		}
+		entry = entry->next;
 	}
 }
 
@@ -1297,15 +1361,16 @@ __apicdebuginit(void) print_IO_APIC(void
 	}
 	printk(KERN_DEBUG "IRQ to pin mappings:\n");
 	for (i = 0; i < nr_irqs; i++) {
-		struct irq_pin_list *entry = irq_2_pin + i;
-		if (entry->pin < 0)
+		struct irq_cfg *cfg = get_irq_cfg(i);
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
@@ -1466,14 +1531,9 @@ void __init enable_IO_APIC(void)
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
