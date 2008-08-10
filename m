Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbYHJHrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbYHJHrm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 03:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755760AbYHJHjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 03:39:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:3148 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbYHJHiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 03:38:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AijZYMvGIBoih3vvz/x0qFLbIN6tWUQD1AG59k6GbszFOFMvvK46UMDq+SRHfqsYzi
         /z+QLX4yzt7yfrnMb6pPXSIB3PfbcBikAQ3nsH5p0Z9gqBi2ZtxxKbiOSPZMTqzP6gLL
         KSFjTeF0Qnqd88K0I8CRojdKbk7bC3Jp/0cYU=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 28/43] x86: add irq_cfg in io_apic_64.c
Date: Sun, 10 Aug 2008 00:36:17 -0700
Message-Id: <1218353792-3355-29-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218353792-3355-28-git-send-email-yhlu.kernel@gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

preallocate size is 32, and if is not enough, irq_cfg will more with alloc_bootmem or kzalloc

v2: fix typo about size of init_one_irq_cfg ... should use sizeof(struct irq_cfg)
v3: according to Eric, change get_irq_cfg() to irq_cfg()
v4: squash add irq_cfg_with_new in

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic_64.c |  209 ++++++++++++++++++++++++++++++++++--------
 1 files changed, 169 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 9dbd189..ff72b6f 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -57,7 +57,11 @@
 
 #define __apicdebuginit(type) static type __init
 
+struct irq_cfg;
+
 struct irq_cfg {
+	unsigned int irq;
+	struct irq_cfg *next;
 	cpumask_t domain;
 	cpumask_t old_domain;
 	unsigned move_cleanup_count;
@@ -67,34 +71,132 @@ struct irq_cfg {
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
 static struct irq_cfg irq_cfg_legacy[] __initdata = {
-	[0]  = { .domain = CPU_MASK_ALL, .vector = IRQ0_VECTOR,  },
-	[1]  = { .domain = CPU_MASK_ALL, .vector = IRQ1_VECTOR,  },
-	[2]  = { .domain = CPU_MASK_ALL, .vector = IRQ2_VECTOR,  },
-	[3]  = { .domain = CPU_MASK_ALL, .vector = IRQ3_VECTOR,  },
-	[4]  = { .domain = CPU_MASK_ALL, .vector = IRQ4_VECTOR,  },
-	[5]  = { .domain = CPU_MASK_ALL, .vector = IRQ5_VECTOR,  },
-	[6]  = { .domain = CPU_MASK_ALL, .vector = IRQ6_VECTOR,  },
-	[7]  = { .domain = CPU_MASK_ALL, .vector = IRQ7_VECTOR,  },
-	[8]  = { .domain = CPU_MASK_ALL, .vector = IRQ8_VECTOR,  },
-	[9]  = { .domain = CPU_MASK_ALL, .vector = IRQ9_VECTOR,  },
-	[10] = { .domain = CPU_MASK_ALL, .vector = IRQ10_VECTOR, },
-	[11] = { .domain = CPU_MASK_ALL, .vector = IRQ11_VECTOR, },
-	[12] = { .domain = CPU_MASK_ALL, .vector = IRQ12_VECTOR, },
-	[13] = { .domain = CPU_MASK_ALL, .vector = IRQ13_VECTOR, },
-	[14] = { .domain = CPU_MASK_ALL, .vector = IRQ14_VECTOR, },
-	[15] = { .domain = CPU_MASK_ALL, .vector = IRQ15_VECTOR, },
+	[0]  = { .irq =  0, .domain = CPU_MASK_ALL, .vector = IRQ0_VECTOR,  },
+	[1]  = { .irq =  1, .domain = CPU_MASK_ALL, .vector = IRQ1_VECTOR,  },
+	[2]  = { .irq =  2, .domain = CPU_MASK_ALL, .vector = IRQ2_VECTOR,  },
+	[3]  = { .irq =  3, .domain = CPU_MASK_ALL, .vector = IRQ3_VECTOR,  },
+	[4]  = { .irq =  4, .domain = CPU_MASK_ALL, .vector = IRQ4_VECTOR,  },
+	[5]  = { .irq =  5, .domain = CPU_MASK_ALL, .vector = IRQ5_VECTOR,  },
+	[6]  = { .irq =  6, .domain = CPU_MASK_ALL, .vector = IRQ6_VECTOR,  },
+	[7]  = { .irq =  7, .domain = CPU_MASK_ALL, .vector = IRQ7_VECTOR,  },
+	[8]  = { .irq =  8, .domain = CPU_MASK_ALL, .vector = IRQ8_VECTOR,  },
+	[9]  = { .irq =  9, .domain = CPU_MASK_ALL, .vector = IRQ9_VECTOR,  },
+	[10] = { .irq = 10, .domain = CPU_MASK_ALL, .vector = IRQ10_VECTOR, },
+	[11] = { .irq = 11, .domain = CPU_MASK_ALL, .vector = IRQ11_VECTOR, },
+	[12] = { .irq = 12, .domain = CPU_MASK_ALL, .vector = IRQ12_VECTOR, },
+	[13] = { .irq = 13, .domain = CPU_MASK_ALL, .vector = IRQ13_VECTOR, },
+	[14] = { .irq = 14, .domain = CPU_MASK_ALL, .vector = IRQ14_VECTOR, },
+	[15] = { .irq = 15, .domain = CPU_MASK_ALL, .vector = IRQ15_VECTOR, },
 };
 
-static struct irq_cfg *irq_cfg;
+static struct irq_cfg irq_cfg_init = { .irq =  -1U, };
+/* need to be biger than size of irq_cfg_legacy */
+static int nr_irq_cfg = 32;
+
+static int __init parse_nr_irq_cfg(char *arg)
+{
+	if (arg) {
+		nr_irq_cfg = simple_strtoul(arg, NULL, 0);
+		if (nr_irq_cfg < 32)
+			nr_irq_cfg = 32;
+	}
+	return 0;
+}
+
+early_param("nr_irq_cfg", parse_nr_irq_cfg);
+
+static void init_one_irq_cfg(struct irq_cfg *cfg)
+{
+	memcpy(cfg, &irq_cfg_init, sizeof(struct irq_cfg));
+}
 
 static void __init init_work(void *data)
 {
 	struct dyn_array *da = data;
+	struct irq_cfg *cfg;
+	int i;
 
-	memcpy(*da->name, irq_cfg_legacy, sizeof(irq_cfg_legacy));
+	cfg = *da->name;
+
+	memcpy(cfg, irq_cfg_legacy, sizeof(irq_cfg_legacy));
+
+	i = sizeof(irq_cfg_legacy)/sizeof(irq_cfg_legacy[0]);
+	for (; i < *da->nr; i++)
+		init_one_irq_cfg(&cfg[i]);
+
+	for (i = 1; i < *da->nr; i++)
+		cfg[i-1].next = &cfg[i];
 }
 
-DEFINE_DYN_ARRAY(irq_cfg, sizeof(struct irq_cfg), nr_irqs, PAGE_SIZE, init_work);
+static struct irq_cfg *irq_cfgx;
+DEFINE_DYN_ARRAY(irq_cfgx, sizeof(struct irq_cfg), nr_irq_cfg, PAGE_SIZE, init_work);
+
+static struct irq_cfg *irq_cfg(unsigned int irq)
+{
+	struct irq_cfg *cfg;
+
+	BUG_ON(irq == -1U);
+
+	cfg = &irq_cfgx[0];
+	while (cfg) {
+		if (cfg->irq == irq)
+			return cfg;
+
+		if (cfg->irq == -1U)
+			return NULL;
+
+		cfg = cfg->next;
+	}
+
+	return NULL;
+}
+
+static struct irq_cfg *irq_cfg_with_new(unsigned int irq)
+{
+	struct irq_cfg *cfg, *cfg_pri;
+	int i;
+	int count = 0;
+
+	BUG_ON(irq == -1U);
+
+	cfg_pri = cfg = &irq_cfgx[0];
+	while (cfg) {
+		if (cfg->irq == irq)
+			return cfg;
+
+		if (cfg->irq == -1U) {
+			cfg->irq = irq;
+			return cfg;
+		}
+		cfg_pri = cfg;
+		cfg = cfg->next;
+		count++;
+	}
+
+	/*
+	 *  we run out of pre-allocate ones, allocate more
+	 */
+	printk(KERN_DEBUG "try to get more irq_cfg %d\n", nr_irq_cfg);
+
+	if (after_bootmem)
+		cfg = kzalloc(sizeof(struct irq_cfg)*nr_irq_cfg, GFP_ATOMIC);
+	else
+		cfg = __alloc_bootmem_nopanic(sizeof(struct irq_cfg)*nr_irq_cfg, PAGE_SIZE, 0);
+
+	if (!cfg)
+		panic("please boot with nr_irq_cfg= %d\n", count * 2);
+
+	for (i = 0; i < nr_irq_cfg; i++)
+		init_one_irq_cfg(&cfg[i]);
+
+	for (i = 1; i < nr_irq_cfg; i++)
+		cfg[i-1].next = &cfg[i];
+
+	cfg->irq = irq;
+	cfg_pri->next = cfg;
+
+	return cfg;
+}
 
 static int assign_irq_vector(int irq, cpumask_t mask);
 
@@ -341,7 +443,7 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, u8 vector)
 
 static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned long flags;
 	unsigned int dest;
 	cpumask_t tmp;
@@ -381,6 +483,8 @@ static void add_pin_to_irq(unsigned int irq, int apic, int pin)
 	struct irq_pin_list *entry = irq_2_pin + irq;
 
 	BUG_ON(irq >= nr_irqs);
+	irq_cfg_with_new(irq);
+
 	while (entry->next)
 		entry = irq_2_pin + entry->next;
 
@@ -806,7 +910,7 @@ static int __assign_irq_vector(int irq, cpumask_t mask)
 	struct irq_cfg *cfg;
 
 	BUG_ON((unsigned)irq >= nr_irqs);
-	cfg = &irq_cfg[irq];
+	cfg = irq_cfg(irq);
 
 	/* Only try and allocate irqs on cpus that are present */
 	cpus_and(mask, mask, cpu_online_map);
@@ -880,7 +984,7 @@ static void __clear_irq_vector(int irq)
 	int cpu, vector;
 
 	BUG_ON((unsigned)irq >= nr_irqs);
-	cfg = &irq_cfg[irq];
+	cfg = irq_cfg(irq);
 	BUG_ON(!cfg->vector);
 
 	vector = cfg->vector;
@@ -900,17 +1004,23 @@ static void __setup_vector_irq(int cpu)
 
 	/* Mark the inuse vectors */
 	for (irq = 0; irq < nr_irqs; ++irq) {
-		if (!cpu_isset(cpu, irq_cfg[irq].domain))
+		struct irq_cfg *cfg = irq_cfg(irq);
+
+		if (!cpu_isset(cpu, cfg->domain))
 			continue;
-		vector = irq_cfg[irq].vector;
+		vector = cfg->vector;
 		per_cpu(vector_irq, cpu)[vector] = irq;
 	}
 	/* Mark the free vectors */
 	for (vector = 0; vector < NR_VECTORS; ++vector) {
+		struct irq_cfg *cfg;
+
 		irq = per_cpu(vector_irq, cpu)[vector];
 		if (irq < 0)
 			continue;
-		if (!cpu_isset(cpu, irq_cfg[irq].domain))
+
+		cfg = irq_cfg(irq);
+		if (!cpu_isset(cpu, cfg->domain))
 			per_cpu(vector_irq, cpu)[vector] = -1;
 	}
 }
@@ -1024,13 +1134,15 @@ static int setup_ioapic_entry(int apic, int irq,
 static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
 			      int trigger, int polarity)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg;
 	struct IO_APIC_route_entry entry;
 	cpumask_t mask;
 
 	if (!IO_APIC_IRQ(irq))
 		return;
 
+	cfg = irq_cfg(irq);
+
 	mask = TARGET_CPUS;
 	if (assign_irq_vector(irq, mask))
 		return;
@@ -1550,7 +1662,7 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
 
 static int ioapic_retrigger_irq(unsigned int irq)
 {
-	struct irq_cfg *cfg = &irq_cfg[irq];
+	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned long flags;
 
 	spin_lock_irqsave(&vector_lock, flags);
@@ -1597,7 +1709,7 @@ static DECLARE_DELAYED_WORK(ir_migration_work, ir_irq_migration);
  */
 static void migrate_ioapic_irq(int irq, cpumask_t mask)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg;
 	struct irq_desc *desc;
 	cpumask_t tmp, cleanup_mask;
 	struct irte irte;
@@ -1615,6 +1727,7 @@ static void migrate_ioapic_irq(int irq, cpumask_t mask)
 	if (assign_irq_vector(irq, mask))
 		return;
 
+	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -1732,7 +1845,7 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 			continue;
 
 		desc = irq_desc(irq);
-		cfg = irq_cfg + irq;
+		cfg = irq_cfg(irq);
 		spin_lock(&desc->lock);
 		if (!cfg->move_cleanup_count)
 			goto unlock;
@@ -1751,7 +1864,7 @@ unlock:
 
 static void irq_complete_move(unsigned int irq)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned vector, me;
 
 	if (likely(!cfg->move_in_progress))
@@ -1888,7 +2001,10 @@ static inline void init_IO_APIC_traps(void)
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
 	for (irq = 0; irq < nr_irqs ; irq++) {
-		if (IO_APIC_IRQ(irq) && !irq_cfg[irq].vector) {
+		struct irq_cfg *cfg;
+
+		cfg = irq_cfg(irq);
+		if (IO_APIC_IRQ(irq) && !cfg->vector) {
 			/*
 			 * Hmm.. We don't have an entry for this,
 			 * so default to an old-fashioned 8259
@@ -2025,7 +2141,7 @@ static inline void __init unlock_ExtINT_logic(void)
  */
 static inline void __init check_timer(void)
 {
-	struct irq_cfg *cfg = irq_cfg + 0;
+	struct irq_cfg *cfg = irq_cfg(0);
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
 	int no_pin1 = 0;
@@ -2303,14 +2419,19 @@ int create_irq(void)
 	int irq;
 	int new;
 	unsigned long flags;
+	struct irq_cfg *cfg_new;
 
 	irq = -ENOSPC;
 	spin_lock_irqsave(&vector_lock, flags);
 	for (new = (nr_irqs - 1); new >= 0; new--) {
 		if (platform_legacy_irq(new))
 			continue;
-		if (irq_cfg[new].vector != 0)
+		cfg_new = irq_cfg(new);
+		if (cfg_new && cfg_new->vector != 0)
 			continue;
+		/* check if need to create one */
+		if (!cfg_new)
+			cfg_new = irq_cfg_with_new(new);
 		if (__assign_irq_vector(new, TARGET_CPUS) == 0)
 			irq = new;
 		break;
@@ -2343,7 +2464,7 @@ void destroy_irq(unsigned int irq)
 #ifdef CONFIG_PCI_MSI
 static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_msg *msg)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg;
 	int err;
 	unsigned dest;
 	cpumask_t tmp;
@@ -2353,6 +2474,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 	if (err)
 		return err;
 
+	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, tmp);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -2410,7 +2532,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 #ifdef CONFIG_SMP
 static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
@@ -2423,6 +2545,7 @@ static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 	if (assign_irq_vector(irq, mask))
 		return;
 
+	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -2445,7 +2568,7 @@ static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
  */
 static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg;
 	unsigned int dest;
 	cpumask_t tmp, cleanup_mask;
 	struct irte irte;
@@ -2461,6 +2584,7 @@ static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 	if (assign_irq_vector(irq, mask))
 		return;
 
+	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -2667,7 +2791,7 @@ void arch_teardown_msi_irq(unsigned int irq)
 #ifdef CONFIG_SMP
 static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
@@ -2680,6 +2804,7 @@ static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
 	if (assign_irq_vector(irq, mask))
 		return;
 
+	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -2746,7 +2871,7 @@ static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
 
 static void set_ht_irq_affinity(unsigned int irq, cpumask_t mask)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg;
 	unsigned int dest;
 	cpumask_t tmp;
 	struct irq_desc *desc;
@@ -2758,6 +2883,7 @@ static void set_ht_irq_affinity(unsigned int irq, cpumask_t mask)
 	if (assign_irq_vector(irq, mask))
 		return;
 
+	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -2780,7 +2906,7 @@ static struct irq_chip ht_irq_chip = {
 
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 {
-	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_cfg *cfg;
 	int err;
 	cpumask_t tmp;
 
@@ -2790,6 +2916,7 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 		struct ht_irq_msg msg;
 		unsigned dest;
 
+		cfg = irq_cfg(irq);
 		cpus_and(tmp, cfg->domain, tmp);
 		dest = cpu_mask_to_apicid(tmp);
 
@@ -2888,6 +3015,7 @@ int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
 void __init setup_ioapic_dest(void)
 {
 	int pin, ioapic, irq, irq_entry;
+	struct irq_cfg *cfg;
 
 	if (skip_ioapic_setup == 1)
 		return;
@@ -2903,7 +3031,8 @@ void __init setup_ioapic_dest(void)
 			 * when you have too many devices, because at that time only boot
 			 * cpu is online.
 			 */
-			if (!irq_cfg[irq].vector)
+			cfg = irq_cfg(irq);
+			if (!cfg->vector)
 				setup_IO_APIC_irq(ioapic, pin, irq,
 						  irq_trigger(irq_entry),
 						  irq_polarity(irq_entry));
-- 
1.5.4.5

