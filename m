Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab0CJLFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 06:05:53 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:22222 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab0CJLFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 06:05:47 -0500
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2010 06:05:41 EST
X-IronPort-AV: E=Sophos;i="4.49,613,1262581200"; 
   d="scan'208";a="87456555"
From: ijc@hellion.org.uk
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yinghai@kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       x86@kernel.org
Subject: [PATCH] x86: namespace some I/O APIC related structures and functions.
Date: Wed, 10 Mar 2010 10:55:57 +0000
Message-Id: <1268218559-26784-1-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1268218524.11737.68547.camel@zakaz.uk.xensource.com>
References: <1268218524.11737.68547.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 10 Mar 2010 10:56:07.0426 (UTC) FILETIME=[49557E20:01CAC040]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

It is not obvious that certain functions relate specifically to the
I/O APIC. Rename structures and functions as follows:

  struct irq_cfg -> struct ioapic_irq_cfg
  irq_cfg() -> ioapic_irq_cfg()
  assign_irq_vector() -> ioapic_assign_irq_vector()
  send_cleanup_vector() -> ioapic_send_cleanup_vector()

There is a slight preference towards ioapic vs io_apic in the current
code (563 occurances vs 146) so I went with that.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/include/asm/hw_irq.h  |   14 ++--
 arch/x86/kernel/apic/io_apic.c |  174 +++++++++++++++++++++-------------------
 arch/x86/kernel/uv_irq.c       |   14 ++--
 3 files changed, 106 insertions(+), 96 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index a929c9e..0642186 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -83,7 +83,7 @@ static inline void set_io_apic_irq_attr(struct io_apic_irq_attr *irq_attr,
  *
  * Most irqs are mapped 1:1 with pins.
  */
-struct irq_cfg {
+struct ioapic_irq_cfg {
 	struct irq_pin_list	*irq_2_pin;
 	cpumask_var_t		domain;
 	cpumask_var_t		old_domain;
@@ -91,13 +91,15 @@ struct irq_cfg {
 	u8			move_in_progress : 1;
 };
 
-extern struct irq_cfg *irq_cfg(unsigned int);
-extern int assign_irq_vector(int, struct irq_cfg *, const struct cpumask *);
-extern void send_cleanup_vector(struct irq_cfg *);
+extern struct ioapic_irq_cfg *ioapic_irq_cfg(unsigned int);
+extern int ioapic_assign_irq_vector(int, struct ioapic_irq_cfg *,
+				    const struct cpumask *);
+extern void ioapic_send_cleanup_vector(struct ioapic_irq_cfg *);
 
 struct irq_desc;
-extern unsigned int set_desc_affinity(struct irq_desc *, const struct cpumask *,
-				      unsigned int *dest_id);
+extern unsigned int ioapic_set_desc_affinity(struct irq_desc *,
+					     const struct cpumask *,
+					     unsigned int *dest_id);
 extern int IO_APIC_get_PCI_irq_vector(int bus, int devfn, int pin, struct io_apic_irq_attr *irq_attr);
 extern void setup_ioapic_dest(void);
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e4e0ddc..a57d974 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -138,14 +138,14 @@ static struct irq_pin_list *get_one_free_irq_2_pin(int node)
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
 #ifdef CONFIG_SPARSE_IRQ
-static struct irq_cfg irq_cfgx[NR_IRQS_LEGACY];
+static struct ioapic_irq_cfg irq_cfgx[NR_IRQS_LEGACY];
 #else
-static struct irq_cfg irq_cfgx[NR_IRQS];
+static struct ioapic_irq_cfg irq_cfgx[NR_IRQS];
 #endif
 
 int __init arch_early_irq_init(void)
 {
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 	struct irq_desc *desc;
 	int count;
 	int node;
@@ -179,9 +179,9 @@ int __init arch_early_irq_init(void)
 }
 
 #ifdef CONFIG_SPARSE_IRQ
-struct irq_cfg *irq_cfg(unsigned int irq)
+struct ioapic_irq_cfg *ioapic_irq_cfg(unsigned int irq)
 {
-	struct irq_cfg *cfg = NULL;
+	struct ioapic_irq_cfg *cfg = NULL;
 	struct irq_desc *desc;
 
 	desc = irq_to_desc(irq);
@@ -191,9 +191,9 @@ struct irq_cfg *irq_cfg(unsigned int irq)
 	return cfg;
 }
 
-static struct irq_cfg *get_one_free_irq_cfg(int node)
+static struct ioapic_irq_cfg *get_one_free_irq_cfg(int node)
 {
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 
 	cfg = kzalloc_node(sizeof(*cfg), GFP_ATOMIC, node);
 	if (cfg) {
@@ -213,7 +213,7 @@ static struct irq_cfg *get_one_free_irq_cfg(int node)
 
 int arch_init_chip_data(struct irq_desc *desc, int node)
 {
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 
 	cfg = desc->chip_data;
 	if (!cfg) {
@@ -229,7 +229,8 @@ int arch_init_chip_data(struct irq_desc *desc, int node)
 
 /* for move_irq_desc */
 static void
-init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg, int node)
+init_copy_irq_2_pin(struct ioapic_irq_cfg *old_cfg,
+		    struct ioapic_irq_cfg *cfg, int node)
 {
 	struct irq_pin_list *old_entry, *head, *tail, *entry;
 
@@ -270,7 +271,8 @@ init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg, int node)
 	cfg->irq_2_pin = head;
 }
 
-static void free_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg)
+static void free_irq_2_pin(struct ioapic_irq_cfg *old_cfg,
+			   struct ioapic_irq_cfg *cfg)
 {
 	struct irq_pin_list *entry, *next;
 
@@ -290,8 +292,8 @@ static void free_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg)
 void arch_init_copy_chip_data(struct irq_desc *old_desc,
 				 struct irq_desc *desc, int node)
 {
-	struct irq_cfg *cfg;
-	struct irq_cfg *old_cfg;
+	struct ioapic_irq_cfg *cfg;
+	struct ioapic_irq_cfg *old_cfg;
 
 	cfg = get_one_free_irq_cfg(node);
 
@@ -302,19 +304,19 @@ void arch_init_copy_chip_data(struct irq_desc *old_desc,
 
 	old_cfg = old_desc->chip_data;
 
-	memcpy(cfg, old_cfg, sizeof(struct irq_cfg));
+	memcpy(cfg, old_cfg, sizeof(struct ioapic_irq_cfg));
 
 	init_copy_irq_2_pin(old_cfg, cfg, node);
 }
 
-static void free_irq_cfg(struct irq_cfg *old_cfg)
+static void free_irq_cfg(struct ioapic_irq_cfg *old_cfg)
 {
 	kfree(old_cfg);
 }
 
 void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
 {
-	struct irq_cfg *old_cfg, *cfg;
+	struct ioapic_irq_cfg *old_cfg, *cfg;
 
 	old_cfg = old_desc->chip_data;
 	cfg = desc->chip_data;
@@ -331,7 +333,7 @@ void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
 /* end for move_irq_desc */
 
 #else
-struct irq_cfg *irq_cfg(unsigned int irq)
+struct ioapic_irq_cfg *ioapic_irq_cfg(unsigned int irq)
 {
 	return irq < nr_irqs ? irq_cfgx + irq : NULL;
 }
@@ -387,7 +389,7 @@ static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned
 	writel(value, &io_apic->data);
 }
 
-static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
+static bool io_apic_level_ack_pending(struct ioapic_irq_cfg *cfg)
 {
 	struct irq_pin_list *entry;
 	unsigned long flags;
@@ -472,7 +474,8 @@ static void ioapic_mask_entry(int apic, int pin)
  * fast in the common case, and fast for shared ISA-space IRQs.
  */
 static int
-add_pin_to_irq_node_nopanic(struct irq_cfg *cfg, int node, int apic, int pin)
+add_pin_to_irq_node_nopanic(struct ioapic_irq_cfg *cfg, int node,
+			    int apic, int pin)
 {
 	struct irq_pin_list **last, *entry;
 
@@ -497,7 +500,8 @@ add_pin_to_irq_node_nopanic(struct irq_cfg *cfg, int node, int apic, int pin)
 	return 0;
 }
 
-static void add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
+static void add_pin_to_irq_node(struct ioapic_irq_cfg *cfg, int node,
+				int apic, int pin)
 {
 	if (add_pin_to_irq_node_nopanic(cfg, node, apic, pin))
 		panic("IO-APIC: failed to add irq-pin. Can not proceed\n");
@@ -506,7 +510,7 @@ static void add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin
 /*
  * Reroute an IRQ to a different pin.
  */
-static void __init replace_pin_at_irq_node(struct irq_cfg *cfg, int node,
+static void __init replace_pin_at_irq_node(struct ioapic_irq_cfg *cfg, int node,
 					   int oldapic, int oldpin,
 					   int newapic, int newpin)
 {
@@ -540,7 +544,7 @@ static void __io_apic_modify_irq(struct irq_pin_list *entry,
 		final(entry);
 }
 
-static void io_apic_modify_irq(struct irq_cfg *cfg,
+static void io_apic_modify_irq(struct ioapic_irq_cfg *cfg,
 			       int mask_and, int mask_or,
 			       void (*final)(struct irq_pin_list *entry))
 {
@@ -562,7 +566,7 @@ static void __unmask_and_level_IO_APIC_irq(struct irq_pin_list *entry)
 			     IO_APIC_REDIR_LEVEL_TRIGGER, NULL);
 }
 
-static void __unmask_IO_APIC_irq(struct irq_cfg *cfg)
+static void __unmask_IO_APIC_irq(struct ioapic_irq_cfg *cfg)
 {
 	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_MASKED, 0, NULL);
 }
@@ -578,14 +582,14 @@ static void io_apic_sync(struct irq_pin_list *entry)
 	readl(&io_apic->data);
 }
 
-static void __mask_IO_APIC_irq(struct irq_cfg *cfg)
+static void __mask_IO_APIC_irq(struct ioapic_irq_cfg *cfg)
 {
 	io_apic_modify_irq(cfg, ~0, IO_APIC_REDIR_MASKED, &io_apic_sync);
 }
 
 static void mask_IO_APIC_irq_desc(struct irq_desc *desc)
 {
-	struct irq_cfg *cfg = desc->chip_data;
+	struct ioapic_irq_cfg *cfg = desc->chip_data;
 	unsigned long flags;
 
 	BUG_ON(!cfg);
@@ -597,7 +601,7 @@ static void mask_IO_APIC_irq_desc(struct irq_desc *desc)
 
 static void unmask_IO_APIC_irq_desc(struct irq_desc *desc)
 {
-	struct irq_cfg *cfg = desc->chip_data;
+	struct ioapic_irq_cfg *cfg = desc->chip_data;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
@@ -1124,7 +1128,7 @@ EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector);
 void lock_vector_lock(void)
 {
 	/* Used to the online set of cpus does not change
-	 * during assign_irq_vector.
+	 * during ioapic_assign_irq_vector.
 	 */
 	raw_spin_lock(&vector_lock);
 }
@@ -1135,7 +1139,8 @@ void unlock_vector_lock(void)
 }
 
 static int
-__assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
+__ioapic_assign_irq_vector(int irq, struct ioapic_irq_cfg *cfg,
+			   const struct cpumask *mask)
 {
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -1214,18 +1219,19 @@ next:
 	return err;
 }
 
-int assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
+int ioapic_assign_irq_vector(int irq, struct ioapic_irq_cfg *cfg,
+			     const struct cpumask *mask)
 {
 	int err;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&vector_lock, flags);
-	err = __assign_irq_vector(irq, cfg, mask);
+	err = __ioapic_assign_irq_vector(irq, cfg, mask);
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 	return err;
 }
 
-static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
+static void __clear_irq_vector(int irq, struct ioapic_irq_cfg *cfg)
 {
 	int cpu, vector;
 
@@ -1256,7 +1262,7 @@ void __setup_vector_irq(int cpu)
 {
 	/* Initialize vector_irq on a new cpu */
 	int irq, vector;
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 	struct irq_desc *desc;
 
 	/*
@@ -1279,7 +1285,7 @@ void __setup_vector_irq(int cpu)
 		if (irq < 0)
 			continue;
 
-		cfg = irq_cfg(irq);
+		cfg = ioapic_irq_cfg(irq);
 		if (!cpumask_test_cpu(cpu, cfg->domain))
 			per_cpu(vector_irq, cpu)[vector] = -1;
 	}
@@ -1424,7 +1430,7 @@ int setup_ioapic_entry(int apic_id, int irq,
 static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq_desc *desc,
 			      int trigger, int polarity)
 {
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 	struct IO_APIC_route_entry entry;
 	unsigned int dest;
 
@@ -1441,7 +1447,7 @@ static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq
 	if (irq < legacy_pic->nr_legacy_irqs && cpumask_test_cpu(0, cfg->domain))
 		apic->vector_allocation_domain(0, cfg->domain);
 
-	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
+	if (ioapic_assign_irq_vector(irq, cfg, apic->target_cpus()))
 		return;
 
 	dest = apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
@@ -1477,7 +1483,7 @@ static void __init setup_IO_APIC_irqs(void)
 	int apic_id, pin, idx, irq;
 	int notcon = 0;
 	struct irq_desc *desc;
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 	int node = cpu_to_node(boot_cpu_id);
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
@@ -1545,7 +1551,7 @@ void setup_IO_APIC_irq_extra(u32 gsi)
 	int apic_id = 0, pin, idx, irq;
 	int node = cpu_to_node(boot_cpu_id);
 	struct irq_desc *desc;
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 
 	/*
 	 * Convert 'gsi' to 'ioapic.pin'.
@@ -1631,7 +1637,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 	union IO_APIC_reg_02 reg_02;
 	union IO_APIC_reg_03 reg_03;
 	unsigned long flags;
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 	struct irq_desc *desc;
 	unsigned int irq;
 
@@ -2243,7 +2249,7 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
 {
 	int was_pending = 0;
 	unsigned long flags;
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	if (irq < legacy_pic->nr_legacy_irqs) {
@@ -2251,7 +2257,7 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
 		if (legacy_pic->irq_pending(irq))
 			was_pending = 1;
 	}
-	cfg = irq_cfg(irq);
+	cfg = ioapic_irq_cfg(irq);
 	__unmask_IO_APIC_irq(cfg);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
@@ -2261,7 +2267,7 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
 static int ioapic_retrigger_irq(unsigned int irq)
 {
 
-	struct irq_cfg *cfg = irq_cfg(irq);
+	struct ioapic_irq_cfg *cfg = ioapic_irq_cfg(irq);
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&vector_lock, flags);
@@ -2281,7 +2287,7 @@ static int ioapic_retrigger_irq(unsigned int irq)
  */
 
 #ifdef CONFIG_SMP
-void send_cleanup_vector(struct irq_cfg *cfg)
+void ioapic_send_cleanup_vector(struct ioapic_irq_cfg *cfg)
 {
 	cpumask_var_t cleanup_mask;
 
@@ -2297,7 +2303,8 @@ void send_cleanup_vector(struct irq_cfg *cfg)
 	cfg->move_in_progress = 0;
 }
 
-static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq_cfg *cfg)
+static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest,
+				 struct ioapic_irq_cfg *cfg)
 {
 	int apic, pin;
 	struct irq_pin_list *entry;
@@ -2327,10 +2334,10 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq
  * leaves desc->affinity untouched.
  */
 unsigned int
-set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask,
+ioapic_set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask,
 		  unsigned int *dest_id)
 {
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 	unsigned int irq;
 
 	if (!cpumask_intersects(mask, cpu_online_mask))
@@ -2338,7 +2345,7 @@ set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask,
 
 	irq = desc->irq;
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, mask))
+	if (ioapic_assign_irq_vector(irq, cfg, mask))
 		return -1;
 
 	cpumask_copy(desc->affinity, mask);
@@ -2350,7 +2357,7 @@ set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask,
 static int
 set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 	unsigned long flags;
 	unsigned int dest;
 	unsigned int irq;
@@ -2360,7 +2367,7 @@ set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 	cfg = desc->chip_data;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	ret = set_desc_affinity(desc, mask, &dest);
+	ret = ioapic_set_desc_affinity(desc, mask, &dest);
 	if (!ret) {
 		/* Only the high 8 bits are valid. */
 		dest = SET_APIC_LOGICAL_ID(dest);
@@ -2397,7 +2404,7 @@ set_ioapic_affinity_irq(unsigned int irq, const struct cpumask *mask)
 static int
 migrate_ioapic_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 	struct irte irte;
 	unsigned int dest;
 	unsigned int irq;
@@ -2411,7 +2418,7 @@ migrate_ioapic_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 		return ret;
 
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, mask))
+	if (ioapic_assign_irq_vector(irq, cfg, mask))
 		return ret;
 
 	dest = apic->cpu_mask_to_apicid_and(cfg->domain, mask);
@@ -2425,7 +2432,7 @@ migrate_ioapic_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 	modify_irte(irq, &irte);
 
 	if (cfg->move_in_progress)
-		send_cleanup_vector(cfg);
+		ioapic_send_cleanup_vector(cfg);
 
 	cpumask_copy(desc->affinity, mask);
 
@@ -2468,7 +2475,7 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 		unsigned int irq;
 		unsigned int irr;
 		struct irq_desc *desc;
-		struct irq_cfg *cfg;
+		struct ioapic_irq_cfg *cfg;
 		irq = __get_cpu_var(vector_irq)[vector];
 
 		if (irq == -1)
@@ -2478,7 +2485,7 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 		if (!desc)
 			continue;
 
-		cfg = irq_cfg(irq);
+		cfg = ioapic_irq_cfg(irq);
 		raw_spin_lock(&desc->lock);
 
 		/*
@@ -2514,7 +2521,7 @@ unlock:
 static void __irq_complete_move(struct irq_desc **descp, unsigned vector)
 {
 	struct irq_desc *desc = *descp;
-	struct irq_cfg *cfg = desc->chip_data;
+	struct ioapic_irq_cfg *cfg = desc->chip_data;
 	unsigned me;
 
 	if (likely(!cfg->move_in_progress))
@@ -2523,7 +2530,7 @@ static void __irq_complete_move(struct irq_desc **descp, unsigned vector)
 	me = smp_processor_id();
 
 	if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
-		send_cleanup_vector(cfg);
+		ioapic_send_cleanup_vector(cfg);
 }
 
 static void irq_complete_move(struct irq_desc **descp)
@@ -2534,7 +2541,7 @@ static void irq_complete_move(struct irq_desc **descp)
 void irq_force_complete_move(int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_cfg *cfg = desc->chip_data;
+	struct ioapic_irq_cfg *cfg = desc->chip_data;
 
 	__irq_complete_move(&desc, cfg->vector);
 }
@@ -2569,7 +2576,7 @@ atomic_t irq_mis_count;
  * Otherwise, we simulate the EOI message manually by changing the trigger
  * mode to edge and then back to level, with RTE being masked during this.
 */
-static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
+static void __eoi_ioapic_irq(unsigned int irq, struct ioapic_irq_cfg *cfg)
 {
 	struct irq_pin_list *entry;
 
@@ -2594,7 +2601,7 @@ static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
 
 static void eoi_ioapic_irq(struct irq_desc *desc)
 {
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 	unsigned long flags;
 	unsigned int irq;
 
@@ -2611,7 +2618,7 @@ static void ack_apic_level(unsigned int irq)
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long v;
 	int i;
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 	int do_unmask_irq = 0;
 
 	irq_complete_move(&desc);
@@ -2760,7 +2767,7 @@ static inline void init_IO_APIC_traps(void)
 {
 	int irq;
 	struct irq_desc *desc;
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -2928,7 +2935,7 @@ int timer_through_8259 __initdata;
 static inline void __init check_timer(void)
 {
 	struct irq_desc *desc = irq_to_desc(0);
-	struct irq_cfg *cfg = desc->chip_data;
+	struct ioapic_irq_cfg *cfg = desc->chip_data;
 	int node = cpu_to_node(boot_cpu_id);
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
@@ -2940,7 +2947,7 @@ static inline void __init check_timer(void)
 	 * get/set the timer IRQ vector:
 	 */
 	legacy_pic->chip->mask(0);
-	assign_irq_vector(0, cfg, apic->target_cpus());
+	ioapic_assign_irq_vector(0, cfg, apic->target_cpus());
 
 	/*
 	 * As IRQ0 is to be enabled in the 8259A, the virtual
@@ -3247,7 +3254,7 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
 	unsigned int irq;
 	unsigned int new;
 	unsigned long flags;
-	struct irq_cfg *cfg_new = NULL;
+	struct ioapic_irq_cfg *cfg_new = NULL;
 	struct irq_desc *desc_new = NULL;
 
 	irq = 0;
@@ -3269,7 +3276,8 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
 		desc_new = move_irq_desc(desc_new, node);
 		cfg_new = desc_new->chip_data;
 
-		if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
+		if (__ioapic_assign_irq_vector(new, cfg_new,
+					       apic->target_cpus()) == 0)
 			irq = new;
 		break;
 	}
@@ -3315,15 +3323,15 @@ void destroy_irq(unsigned int irq)
 static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 			   struct msi_msg *msg, u8 hpet_id)
 {
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 	int err;
 	unsigned dest;
 
 	if (disable_apic)
 		return -ENXIO;
 
-	cfg = irq_cfg(irq);
-	err = assign_irq_vector(irq, cfg, apic->target_cpus());
+	cfg = ioapic_irq_cfg(irq);
+	err = ioapic_assign_irq_vector(irq, cfg, apic->target_cpus());
 	if (err)
 		return err;
 
@@ -3392,11 +3400,11 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 static int set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
 
-	if (set_desc_affinity(desc, mask, &dest))
+	if (ioapic_set_desc_affinity(desc, mask, &dest))
 		return -1;
 
 	cfg = desc->chip_data;
@@ -3421,14 +3429,14 @@ static int
 ir_set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_cfg *cfg = desc->chip_data;
+	struct ioapic_irq_cfg *cfg = desc->chip_data;
 	unsigned int dest;
 	struct irte irte;
 
 	if (get_irte(irq, &irte))
 		return -1;
 
-	if (set_desc_affinity(desc, mask, &dest))
+	if (ioapic_set_desc_affinity(desc, mask, &dest))
 		return -1;
 
 	irte.vector = cfg->vector;
@@ -3445,7 +3453,7 @@ ir_set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 	 * vector allocation.
 	 */
 	if (cfg->move_in_progress)
-		send_cleanup_vector(cfg);
+		ioapic_send_cleanup_vector(cfg);
 
 	return 0;
 }
@@ -3606,11 +3614,11 @@ void arch_teardown_msi_irq(unsigned int irq)
 static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
 
-	if (set_desc_affinity(desc, mask, &dest))
+	if (ioapic_set_desc_affinity(desc, mask, &dest))
 		return -1;
 
 	cfg = desc->chip_data;
@@ -3661,11 +3669,11 @@ int arch_setup_dmar_msi(unsigned int irq)
 static int hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
 
-	if (set_desc_affinity(desc, mask, &dest))
+	if (ioapic_set_desc_affinity(desc, mask, &dest))
 		return -1;
 
 	cfg = desc->chip_data;
@@ -3768,10 +3776,10 @@ static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
 static int set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 	unsigned int dest;
 
-	if (set_desc_affinity(desc, mask, &dest))
+	if (ioapic_set_desc_affinity(desc, mask, &dest))
 		return -1;
 
 	cfg = desc->chip_data;
@@ -3796,14 +3804,14 @@ static struct irq_chip ht_irq_chip = {
 
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 {
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 	int err;
 
 	if (disable_apic)
 		return -ENXIO;
 
-	cfg = irq_cfg(irq);
-	err = assign_irq_vector(irq, cfg, apic->target_cpus());
+	cfg = ioapic_irq_cfg(irq);
+	err = ioapic_assign_irq_vector(irq, cfg, apic->target_cpus());
 	if (!err) {
 		struct ht_irq_msg msg;
 		unsigned dest;
@@ -3897,7 +3905,7 @@ static int __io_apic_set_pci_routing(struct device *dev, int irq,
 				struct io_apic_irq_attr *irq_attr)
 {
 	struct irq_desc *desc;
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 	int node;
 	int ioapic, pin;
 	int trigger, polarity;
@@ -4305,7 +4313,7 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 /* Enable IOAPIC early just for system timer */
 void __init pre_init_apic_IRQ0(void)
 {
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 	struct irq_desc *desc;
 
 	printk(KERN_INFO "Early APIC setup for system timer0\n");
@@ -4316,7 +4324,7 @@ void __init pre_init_apic_IRQ0(void)
 
 	setup_local_APIC();
 
-	cfg = irq_cfg(0);
+	cfg = ioapic_irq_cfg(0);
 	add_pin_to_irq_node(cfg, 0, 0, 0);
 	set_irq_chip_and_handler_name(0, &ioapic_chip, handle_edge_irq, "edge");
 
diff --git a/arch/x86/kernel/uv_irq.c b/arch/x86/kernel/uv_irq.c
index ece73d8..3520564 100644
--- a/arch/x86/kernel/uv_irq.c
+++ b/arch/x86/kernel/uv_irq.c
@@ -144,7 +144,7 @@ arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 {
 	const struct cpumask *eligible_cpu = cpumask_of(cpu);
 	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_cfg *cfg;
+	struct ioapic_irq_cfg *cfg;
 	int mmr_pnode;
 	unsigned long mmr_value;
 	struct uv_IO_APIC_route_entry *entry;
@@ -153,9 +153,9 @@ arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 	BUILD_BUG_ON(sizeof(struct uv_IO_APIC_route_entry) !=
 			sizeof(unsigned long));
 
-	cfg = irq_cfg(irq);
+	cfg = ioapic_irq_cfg(irq);
 
-	err = assign_irq_vector(irq, cfg, eligible_cpu);
+	err = ioapic_assign_irq_vector(irq, cfg, eligible_cpu);
 	if (err != 0)
 		return err;
 
@@ -181,7 +181,7 @@ arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
 
 	if (cfg->move_in_progress)
-		send_cleanup_vector(cfg);
+		ioapic_send_cleanup_vector(cfg);
 
 	return irq;
 }
@@ -208,14 +208,14 @@ static void arch_disable_uv_irq(int mmr_pnode, unsigned long mmr_offset)
 static int uv_set_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_cfg *cfg = desc->chip_data;
+	struct ioapic_irq_cfg *cfg = desc->chip_data;
 	unsigned int dest;
 	unsigned long mmr_value;
 	struct uv_IO_APIC_route_entry *entry;
 	unsigned long mmr_offset;
 	unsigned mmr_pnode;
 
-	if (set_desc_affinity(desc, mask, &dest))
+	if (ioapic_set_desc_affinity(desc, mask, &dest))
 		return -1;
 
 	mmr_value = 0;
@@ -236,7 +236,7 @@ static int uv_set_irq_affinity(unsigned int irq, const struct cpumask *mask)
 	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
 
 	if (cfg->move_in_progress)
-		send_cleanup_vector(cfg);
+		ioapic_send_cleanup_vector(cfg);
 
 	return 0;
 }
-- 
1.5.6.5

