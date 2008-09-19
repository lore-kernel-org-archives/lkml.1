Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbYISUGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbYISUGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 16:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbYISUGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 16:06:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60199 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753590AbYISUGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 16:06:46 -0400
Date: Fri, 19 Sep 2008 15:06:45 -0500
From: Dean Nelson <dcn@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Alan Mayer <ajm@sgi.com>, jeremy@goop.org, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: [PATCH 2/3] switch static system vector allocation to use vector_irq[] v2
Message-ID: <20080919200645.GC6528@sgi.com>
References: <20080919200212.GA6528@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080919200212.GA6528@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the current use of system_vectors[] for the allocation of static
system vectors by also using the per_cpu variable vector_irq[].

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

 arch/x86/kernel/Makefile     |    2 
 arch/x86/kernel/apic.c       |    2 
 arch/x86/kernel/io_apic.c    |  112 ++++++++++++++++++++-------------------
 arch/x86/kernel/irq.c        |   22 +++++++
 arch/x86/kernel/irq_32.c     |    2 
 arch/x86/kernel/irq_64.c     |    2 
 arch/x86/kernel/irqinit_32.c |   11 ++-
 arch/x86/kernel/irqinit_64.c |   11 ++-
 include/asm-x86/desc.h       |   21 +++----
 include/asm-x86/hw_irq.h     |    4 -
 include/asm-x86/irq.h        |    8 ++
 11 files changed, 118 insertions(+), 79 deletions(-)

Index: linux/arch/x86/kernel/apic.c
===================================================================
--- linux.orig/arch/x86/kernel/apic.c	2008-09-19 14:12:25.000000000 -0500
+++ linux/arch/x86/kernel/apic.c	2008-09-19 14:13:17.000000000 -0500
@@ -118,8 +118,6 @@ EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok
 
 int first_system_vector = 0xfe;
 
-char system_vectors[NR_VECTORS] = { [0 ... NR_VECTORS-1] = SYS_VECTOR_FREE};
-
 /*
  * Debug level, exported for io_apic.c
  */
Index: linux/include/asm-x86/desc.h
===================================================================
--- linux.orig/include/asm-x86/desc.h	2008-09-19 14:12:25.000000000 -0500
+++ linux/include/asm-x86/desc.h	2008-09-19 14:13:17.000000000 -0500
@@ -5,6 +5,7 @@
 #include <asm/desc_defs.h>
 #include <asm/ldt.h>
 #include <asm/mmu.h>
+#include <asm/irq.h>
 #include <linux/smp.h>
 
 static inline void fill_ldt(struct desc_struct *desc,
@@ -320,20 +321,20 @@ static inline void set_intr_gate(unsigne
 	_set_gate(n, GATE_INTERRUPT, addr, 0, 0, __KERNEL_CS);
 }
 
-#define SYS_VECTOR_FREE		0
-#define SYS_VECTOR_ALLOCED	1
-
 extern int first_system_vector;
-extern char system_vectors[];
 
 static inline void alloc_system_vector(int vector)
 {
-	if (system_vectors[vector] == SYS_VECTOR_FREE) {
-		system_vectors[vector] = SYS_VECTOR_ALLOCED;
-		if (first_system_vector > vector)
-			first_system_vector = vector;
-	} else
-		BUG();
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&vector_lock, flags);
+	ret = grab_irq_vector(NON_IRQ_DESC, vector, &cpu_possible_map);
+	BUG_ON(ret != vector);
+
+	if (first_system_vector > vector)
+		first_system_vector = vector;
+	spin_unlock_irqrestore(&vector_lock, flags);
 }
 
 static inline void alloc_intr_gate(unsigned int n, void *addr)
Index: linux/arch/x86/kernel/io_apic.c
===================================================================
--- linux.orig/arch/x86/kernel/io_apic.c	2008-09-19 14:13:09.000000000 -0500
+++ linux/arch/x86/kernel/io_apic.c	2008-09-19 14:13:17.000000000 -0500
@@ -72,7 +72,6 @@
 int sis_apic_bug = -1;
 
 static DEFINE_SPINLOCK(ioapic_lock);
-static DEFINE_SPINLOCK(vector_lock);
 
 /*
  * # of IRQ routing registers
@@ -546,7 +545,7 @@ static void __target_IO_APIC_irq(unsigne
 	}
 }
 
-static int assign_irq_vector(int irq, cpumask_t mask);
+static int assign_irq_vector(int irq, cpumask_t *mask);
 
 static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
 {
@@ -561,7 +560,7 @@ static void set_ioapic_affinity_irq(unsi
 		return;
 
 	cfg = irq_cfg(irq);
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, &mask))
 		return;
 
 	cpus_and(tmp, cfg->domain, mask);
@@ -1196,20 +1195,33 @@ static int pin_2_irq(int idx, int apic, 
 	return irq;
 }
 
-void lock_vector_lock(void)
+static int ioapic_grab_irq_vector(struct irq_desc *desc, unsigned int vector,
+				  cpumask_t *domain, cpumask_t *domain_online)
 {
-	/* Used to the online set of cpus does not change
-	 * during assign_irq_vector.
-	 */
-	spin_lock(&vector_lock);
-}
+	struct irq_cfg *cfg;
+	int ret;
 
-void unlock_vector_lock(void)
-{
-	spin_unlock(&vector_lock);
+	BUG_ON(!spin_is_locked(&vector_lock));
+
+	ret = grab_irq_vector(desc, vector, domain_online);
+	if (ret == vector) {
+		cfg = irq_cfg(desc->irq);
+		if (cfg->vector) {
+			cfg->move_in_progress = 1;
+			cfg->old_domain = cfg->domain;
+		}
+		cfg->vector = vector;
+		cfg->domain = *domain;
+	}
+	return ret;
 }
 
-static int __assign_irq_vector(int irq, cpumask_t mask)
+/* The following scratch cpumask_t variables are protected by vector lock. */
+static cpumask_t eligible_cpus;
+static cpumask_t domain;
+static cpumask_t domain_online;
+
+static int __assign_irq_vector(int irq, cpumask_t *mask)
 {
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -1223,36 +1235,34 @@ static int __assign_irq_vector(int irq, 
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
 	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
-	unsigned int old_vector;
 	int cpu;
 	struct irq_cfg *cfg;
 	struct irq_desc *desc;
+	int ret;
 
-	cfg = irq_cfg(irq);
+	BUG_ON(!spin_is_locked(&vector_lock));
 
-	/* Only try and allocate irqs on cpus that are present */
-	cpus_and(mask, mask, cpu_online_map);
+	cfg = irq_cfg(irq);
 
 	if ((cfg->move_in_progress) || cfg->move_cleanup_count)
 		return -EBUSY;
 
-	old_vector = cfg->vector;
-	if (old_vector) {
-		cpumask_t tmp;
-		cpus_and(tmp, cfg->domain, mask);
-		if (!cpus_empty(tmp))
+	/* Only try and allocate irqs on cpus that are present */
+	cpus_and(eligible_cpus, *mask, cpu_online_map);
+
+	if (cfg->vector) {
+		cpus_and(domain, cfg->domain, eligible_cpus);
+		if (!cpus_empty(domain))
 			return 0;
 	}
 
 	desc = irq_to_desc_alloc(irq);
 
-	for_each_cpu_mask_nr(cpu, mask) {
-		cpumask_t domain, new_mask;
-		int new_cpu;
+	for_each_cpu_mask_nr(cpu, eligible_cpus) {
 		int vector, offset;
 
 		domain = vector_allocation_domain(cpu);
-		cpus_and(new_mask, domain, cpu_online_map);
+		cpus_and(domain_online, domain, cpu_online_map);
 
 		vector = current_vector;
 		offset = current_offset;
@@ -1272,26 +1282,20 @@ next:
 		if (vector == SYSCALL_VECTOR)
 			goto next;
 #endif
-		for_each_cpu_mask_nr(new_cpu, new_mask)
-			if (per_cpu(vector_irq, new_cpu)[vector] != NULL)
-				goto next;
+		ret = ioapic_grab_irq_vector(desc, vector, &domain,
+					     &domain_online);
+		if (ret != vector)
+			goto next;
+
 		/* Found one! */
 		current_vector = vector;
 		current_offset = offset;
-		if (old_vector) {
-			cfg->move_in_progress = 1;
-			cfg->old_domain = cfg->domain;
-		}
-		for_each_cpu_mask_nr(new_cpu, new_mask)
-			per_cpu(vector_irq, new_cpu)[vector] = desc;
-		cfg->vector = vector;
-		cfg->domain = domain;
 		return 0;
 	}
 	return -ENOSPC;
 }
 
-static int assign_irq_vector(int irq, cpumask_t mask)
+static int assign_irq_vector(int irq, cpumask_t *mask)
 {
 	int err;
 	unsigned long flags;
@@ -1334,13 +1338,13 @@ void __setup_vector_irq(int cpu)
 			continue;
 		vector = cfg->vector;
 		desc = irq_to_desc(irq);
-		BUG_ON(desc == NULL);
+		BUG_ON(desc == NULL || desc == NON_IRQ_DESC);
 		per_cpu(vector_irq, cpu)[vector] = desc;
 	}
 	/* Mark the free vectors */
 	for (vector = 0; vector < NR_VECTORS; ++vector) {
 		desc = per_cpu(vector_irq, cpu)[vector];
-		if (desc == NULL)
+		if (desc == NULL || desc == NON_IRQ_DESC)
 			continue;
 
 		cfg = irq_cfg(desc->irq);
@@ -1495,7 +1499,7 @@ static void setup_IO_APIC_irq(int apic, 
 	cfg = irq_cfg(irq);
 
 	mask = TARGET_CPUS;
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, &mask))
 		return;
 
 	cpus_and(mask, cfg->domain, mask);
@@ -2280,7 +2284,7 @@ static void migrate_ioapic_irq(int irq, 
 	if (get_irte(irq, &irte))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, &mask))
 		return;
 
 	cfg = irq_cfg(irq);
@@ -2399,7 +2403,7 @@ asmlinkage void smp_irq_move_cleanup_int
 		struct irq_cfg *cfg;
 
 		desc = __get_cpu_var(vector_irq)[vector];
-		if (desc == NULL)
+		if (desc == NULL || desc == NON_IRQ_DESC)
 			continue;
 
 		cfg = irq_cfg(desc->irq);
@@ -2764,6 +2768,7 @@ static inline void __init check_timer(vo
 	unsigned long flags;
 	unsigned int ver;
 	int no_pin1 = 0;
+	cpumask_t mask;
 
 	local_irq_save(flags);
 
@@ -2774,7 +2779,8 @@ static inline void __init check_timer(vo
 	 * get/set the timer IRQ vector:
 	 */
 	disable_8259A_irq(0);
-	assign_irq_vector(0, TARGET_CPUS);
+	mask = TARGET_CPUS;
+	assign_irq_vector(0, &mask);
 
 	/*
 	 * As IRQ0 is to be enabled in the 8259A, the virtual
@@ -3074,10 +3080,12 @@ unsigned int create_irq_nr(unsigned int 
 	unsigned int new;
 	unsigned long flags;
 	struct irq_cfg *cfg_new;
+	cpumask_t mask;
 
 #ifndef CONFIG_HAVE_SPARSE_IRQ
 	irq_want = nr_irqs - 1;
 #endif
+	mask = TARGET_CPUS;
 
 	irq = 0;
 	spin_lock_irqsave(&vector_lock, flags);
@@ -3090,7 +3098,7 @@ unsigned int create_irq_nr(unsigned int 
 		/* check if need to create one */
 		if (!cfg_new)
 			cfg_new = irq_cfg_alloc(new);
-		if (__assign_irq_vector(new, TARGET_CPUS) == 0)
+		if (__assign_irq_vector(new, &mask) == 0)
 			irq = new;
 		break;
 	}
@@ -3140,7 +3148,7 @@ static int msi_compose_msg(struct pci_de
 	cpumask_t tmp;
 
 	tmp = TARGET_CPUS;
-	err = assign_irq_vector(irq, tmp);
+	err = assign_irq_vector(irq, &tmp);
 	if (err)
 		return err;
 
@@ -3212,7 +3220,7 @@ static void set_msi_irq_affinity(unsigne
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, &mask))
 		return;
 
 	cfg = irq_cfg(irq);
@@ -3251,7 +3259,7 @@ static void ir_set_msi_irq_affinity(unsi
 	if (get_irte(irq, &irte))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, &mask))
 		return;
 
 	cfg = irq_cfg(irq);
@@ -3491,7 +3499,7 @@ static void dmar_msi_set_affinity(unsign
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, &mask))
 		return;
 
 	cfg = irq_cfg(irq);
@@ -3552,7 +3560,7 @@ static void hpet_msi_set_affinity(unsign
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, &mask))
 		return;
 
 	cfg = irq_cfg(irq);
@@ -3632,7 +3640,7 @@ static void set_ht_irq_affinity(unsigned
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, &mask))
 		return;
 
 	cfg = irq_cfg(irq);
@@ -3663,7 +3671,7 @@ int arch_setup_ht_irq(unsigned int irq, 
 	cpumask_t tmp;
 
 	tmp = TARGET_CPUS;
-	err = assign_irq_vector(irq, tmp);
+	err = assign_irq_vector(irq, &tmp);
 	if (!err) {
 		struct ht_irq_msg msg;
 		unsigned dest;
Index: linux/arch/x86/kernel/irq_32.c
===================================================================
--- linux.orig/arch/x86/kernel/irq_32.c	2008-09-19 14:13:09.000000000 -0500
+++ linux/arch/x86/kernel/irq_32.c	2008-09-19 14:13:17.000000000 -0500
@@ -234,7 +234,7 @@ unsigned int do_IRQ(struct pt_regs *regs
 	overflow = check_stack_overflow();
 
 	desc = __get_cpu_var(vector_irq)[vector];
-	if (unlikely(desc == NULL)) {
+	if (unlikely(desc == NULL || desc == NON_IRQ_DESC)) {
 		printk(KERN_EMERG "%s: cannot handle IRQ vector %#x cpu %d\n",
 					__func__, vector, smp_processor_id());
 		BUG();
Index: linux/arch/x86/kernel/irq_64.c
===================================================================
--- linux.orig/arch/x86/kernel/irq_64.c	2008-09-19 14:13:09.000000000 -0500
+++ linux/arch/x86/kernel/irq_64.c	2008-09-19 14:13:17.000000000 -0500
@@ -222,7 +222,7 @@ asmlinkage unsigned int do_IRQ(struct pt
 #endif
 
 	desc = __get_cpu_var(vector_irq)[vector];
-	if (likely(desc != NULL)) {
+	if (likely(desc != NULL && desc != NON_IRQ_DESC)) {
 		generic_handle_irq_desc(desc->irq, desc);
 	} else {
 		if (!disable_apic)
Index: linux/include/asm-x86/irq.h
===================================================================
--- linux.orig/include/asm-x86/irq.h	2008-09-19 14:12:25.000000000 -0500
+++ linux/include/asm-x86/irq.h	2008-09-19 14:13:17.000000000 -0500
@@ -47,4 +47,12 @@ extern void native_init_IRQ(void);
 /* Interrupt vector management */
 extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
 
+struct irq_desc;
+extern int grab_irq_vector(struct irq_desc *desc, unsigned int vector,
+			   cpumask_t *new_domain_mask);
+
+#define NON_IRQ_DESC	((struct irq_desc *)-1UL)
+
+extern spinlock_t vector_lock;
+
 #endif /* ASM_X86__IRQ_H */
Index: linux/arch/x86/kernel/Makefile
===================================================================
--- linux.orig/arch/x86/kernel/Makefile	2008-09-19 14:12:25.000000000 -0500
+++ linux/arch/x86/kernel/Makefile	2008-09-19 14:13:17.000000000 -0500
@@ -24,7 +24,7 @@ CFLAGS_tsc.o		:= $(nostackp)
 CFLAGS_paravirt.o	:= $(nostackp)
 
 obj-y			:= process_$(BITS).o signal_$(BITS).o entry_$(BITS).o
-obj-y			+= traps_$(BITS).o irq_$(BITS).o
+obj-y			+= traps_$(BITS).o irq.o irq_$(BITS).o
 obj-y			+= time_$(BITS).o ioport.o ldt.o
 obj-y			+= setup.o i8259.o irqinit_$(BITS).o setup_percpu.o
 obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
Index: linux/arch/x86/kernel/irq.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/arch/x86/kernel/irq.c	2008-09-19 14:13:17.000000000 -0500
@@ -0,0 +1,22 @@
+#include <linux/irq.h>
+
+DEFINE_SPINLOCK(vector_lock);
+
+int grab_irq_vector(struct irq_desc *desc, unsigned int vector,
+		   cpumask_t *domain)
+{
+	int cpu;
+
+	BUG_ON(!spin_is_locked(&vector_lock));
+
+	for_each_cpu_mask_nr(cpu, *domain) {
+		if (per_cpu(vector_irq, cpu)[vector] != NULL)
+			return -EBUSY;
+	}
+
+	/* it's available, reserve it */
+	for_each_cpu_mask_nr(cpu, *domain)
+		per_cpu(vector_irq, cpu)[vector] = desc;
+
+	return vector;
+}
Index: linux/include/asm-x86/hw_irq.h
===================================================================
--- linux.orig/include/asm-x86/hw_irq.h	2008-09-19 14:13:09.000000000 -0500
+++ linux/include/asm-x86/hw_irq.h	2008-09-19 14:13:17.000000000 -0500
@@ -117,8 +117,8 @@ typedef struct irq_desc *vector_irq_t[NR
 DECLARE_PER_CPU(vector_irq_t, vector_irq);
 
 #ifdef CONFIG_X86_IO_APIC
-extern void lock_vector_lock(void);
-extern void unlock_vector_lock(void);
+static inline void lock_vector_lock(void) { spin_lock(&vector_lock); }
+static inline void unlock_vector_lock(void) { spin_unlock(&vector_lock); }
 extern void __setup_vector_irq(int cpu);
 #else
 static inline void lock_vector_lock(void) {}
Index: linux/arch/x86/kernel/irqinit_32.c
===================================================================
--- linux.orig/arch/x86/kernel/irqinit_32.c	2008-09-19 14:13:09.000000000 -0500
+++ linux/arch/x86/kernel/irqinit_32.c	2008-09-19 14:13:17.000000000 -0500
@@ -59,8 +59,9 @@ static struct irqaction fpu_irq = {
 void __init init_ISA_irqs (void)
 {
 	int i;
-	int cpu;
+	int ret;
 	unsigned int vector;
+	unsigned long flags;
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	init_bsp_APIC();
@@ -79,10 +80,10 @@ void __init init_ISA_irqs (void)
 		desc->depth = 1;
 
 		vector = IRQ0_VECTOR + i;
-		for_each_possible_cpu(cpu) {
-			BUG_ON(per_cpu(vector_irq, cpu)[vector] != NULL);
-			per_cpu(vector_irq, cpu)[vector] = desc;
-		}
+		spin_lock_irqsave(&vector_lock, flags);
+		ret = grab_irq_vector(desc, vector, &cpu_possible_map);
+		BUG_ON(ret != vector);
+		spin_unlock_irqrestore(&vector_lock, flags);
 
 		set_irq_chip_and_handler_name(i, &i8259A_chip,
 					      handle_level_irq, "XT");
Index: linux/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux.orig/arch/x86/kernel/irqinit_64.c	2008-09-19 14:13:09.000000000 -0500
+++ linux/arch/x86/kernel/irqinit_64.c	2008-09-19 14:13:17.000000000 -0500
@@ -119,8 +119,9 @@ DEFINE_PER_CPU(vector_irq_t, vector_irq)
 static void __init init_ISA_irqs (void)
 {
 	int i;
-	int cpu;
+	int ret;
 	unsigned int vector;
+	unsigned long flags;
 
 	init_bsp_APIC();
 	init_8259A(0);
@@ -134,10 +135,10 @@ static void __init init_ISA_irqs (void)
 		desc->depth = 1;
 
 		vector = IRQ0_VECTOR + i;
-		for_each_possible_cpu(cpu) {
-			BUG_ON(per_cpu(vector_irq, cpu)[vector] != NULL);
-			per_cpu(vector_irq, cpu)[vector] = desc;
-		}
+		spin_lock_irqsave(&vector_lock, flags);
+		ret = grab_irq_vector(desc, vector, &cpu_possible_map);
+		BUG_ON(ret != vector);
+		spin_unlock_irqrestore(&vector_lock, flags);
 
 		/*
 		 * 16 old-style INTA-cycle interrupts:
