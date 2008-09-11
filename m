Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbYIKP1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbYIKP1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 11:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYIKP1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 11:27:35 -0400
Received: from relay2.sgi.com ([192.48.171.30]:49718 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751848AbYIKP1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 11:27:33 -0400
Date: Thu, 11 Sep 2008 10:27:32 -0500
From: Dean Nelson <dcn@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Mayer <ajm@sgi.com>, Ingo Molnar <mingo@elte.hu>, jeremy@goop.org,
       rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: [RFC 2/4] introduce dynamically allocated system vectors
Message-ID: <20080911152732.GC13655@sgi.com>
References: <489C6844.9050902@sgi.com> <20080811165930.GI4524@elte.hu> <48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org> <20080911152304.GA13655@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080911152304.GA13655@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce the dynamic allocation and deallocation of system vectors which
are mapped to irq numbers allowing the use of request_irq()/free_irq().

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

 arch/x86/kernel/apic.c        |    3 
 arch/x86/kernel/io_apic.c     |  264 +++++++++++++++++++++++++++++++++-----
 arch/x86/kernel/irqinit_64.c  |    4 
 include/asm-x86/desc.h        |   13 +
 include/asm-x86/irq_vectors.h |    1 
 include/linux/irq.h           |   13 +
 6 files changed, 258 insertions(+), 40 deletions(-)

Index: linux/arch/x86/kernel/io_apic.c
===================================================================
--- linux.orig/arch/x86/kernel/io_apic.c	2008-09-10 12:08:46.000000000 -0500
+++ linux/arch/x86/kernel/io_apic.c	2008-09-11 07:17:33.000000000 -0500
@@ -1205,7 +1205,34 @@ void unlock_vector_lock(void)
 	spin_unlock(&vector_lock);
 }
 
-static int __assign_irq_vector(int irq, cpumask_t mask)
+bool __grab_irq_vector(struct irq_desc *desc, unsigned int vector,
+		       cpumask_t *new_domain_mask)
+{
+	/* Must be called with vector lock */
+	struct irq_cfg *cfg;
+	int cpu;
+
+	for_each_cpu_mask_nr(cpu, *new_domain_mask) {
+		if (per_cpu(vector_irq, cpu)[vector] != NULL)
+			return false;
+	}
+
+	/* Available reserve it */
+	for_each_cpu_mask_nr(cpu, *new_domain_mask)
+		per_cpu(vector_irq, cpu)[vector] = desc;
+
+	cfg = irq_cfg(desc->irq);
+	if (cfg->vector) {
+		cfg->move_in_progress = 1;
+		cfg->old_domain = cfg->domain;
+	}
+	cfg->vector = vector;
+	cfg->domain = *new_domain_mask;
+
+	return true;
+}
+
+static int __assign_irq_vector(int irq, cpumask_t *mask)
 {
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -1219,42 +1246,40 @@ static int __assign_irq_vector(int irq, 
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
 	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
-	unsigned int old_vector;
+	cpumask_t target_cpus_mask;
 	int cpu;
 	struct irq_cfg *cfg;
 	struct irq_desc *desc;
 
 	cfg = irq_cfg(irq);
 
-	/* Only try and allocate irqs on cpus that are present */
-	cpus_and(mask, mask, cpu_online_map);
-
 	if ((cfg->move_in_progress) || cfg->move_cleanup_count)
 		return -EBUSY;
 
-	old_vector = cfg->vector;
-	if (old_vector) {
+	/* Only try and allocate irqs on cpus that are present */
+	cpus_and(target_cpus_mask, *mask, cpu_online_map);
+
+	if (cfg->vector) {
 		cpumask_t tmp;
-		cpus_and(tmp, cfg->domain, mask);
+		cpus_and(tmp, cfg->domain, target_cpus_mask);
 		if (!cpus_empty(tmp))
 			return 0;
 	}
 
 	desc = irq_to_desc_alloc(irq);
 
-	for_each_cpu_mask_nr(cpu, mask) {
-		cpumask_t domain, new_mask;
-		int new_cpu;
+	for_each_cpu_mask_nr(cpu, target_cpus_mask) {
+		cpumask_t domain, new_domain_mask;
 		int vector, offset;
 
 		domain = vector_allocation_domain(cpu);
-		cpus_and(new_mask, domain, cpu_online_map);
+		cpus_and(new_domain_mask, domain, cpu_online_map);
 
 		vector = current_vector;
 		offset = current_offset;
 next:
 		vector += 8;
-		if (vector >= first_system_vector) {
+		if (vector > last_device_vector) {
 			/* If we run out of vectors on large boxen, must share them. */
 			offset = (offset + 1) % 8;
 			vector = FIRST_DEVICE_VECTOR + offset;
@@ -1268,20 +1293,12 @@ next:
 		if (vector == SYSCALL_VECTOR)
 			goto next;
 #endif
-		for_each_cpu_mask_nr(new_cpu, new_mask)
-			if (per_cpu(vector_irq, new_cpu)[vector] != NULL)
-				goto next;
+		if (!__grab_irq_vector(desc, vector, &new_domain_mask))
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
@@ -1293,11 +1310,51 @@ static int assign_irq_vector(int irq, cp
 	unsigned long flags;
 
 	spin_lock_irqsave(&vector_lock, flags);
-	err = __assign_irq_vector(irq, mask);
+	err = __assign_irq_vector(irq, &mask);
 	spin_unlock_irqrestore(&vector_lock, flags);
 	return err;
 }
 
+static int __assign_irq_system_vector(int irq, cpumask_t *mask, int priority)
+{
+	int vector;
+	cpumask_t target_cpus_mask;
+	int cpu;
+	cpumask_t domain;
+	cpumask_t new_domain_mask = CPU_MASK_NONE;
+	struct irq_desc *desc;
+
+	if (priority == IRQ_PRIORITY_HIGH)
+		vector = first_static_system_vector;
+	else if (priority == IRQ_PRIORITY_LOW)
+		vector = FIRST_DEVICE_VECTOR - 1;
+	else
+		BUG();
+
+	cpus_and(target_cpus_mask, *mask, cpu_possible_map);
+	for_each_cpu_mask_nr(cpu, target_cpus_mask) {
+		domain = vector_allocation_domain(cpu);
+		cpus_and(domain, domain, cpu_possible_map);
+		cpus_or(new_domain_mask, new_domain_mask, domain);
+	}
+
+	desc = irq_to_desc_alloc(irq);
+
+	do {
+		if (priority == IRQ_PRIORITY_HIGH) {
+			if (--vector < FIRST_DEVICE_VECTOR)
+				return -ENOSPC;
+		} else {	/* IRQ_PRIORITY_LOW */
+			if (++vector == first_static_system_vector)
+				return -ENOSPC;
+		}
+
+	} while (!__grab_irq_vector(desc, vector, &new_domain_mask));
+
+	/* found one */
+	return 0;
+}
+
 static void __clear_irq_vector(int irq)
 {
 	struct irq_cfg *cfg;
@@ -3045,21 +3102,22 @@ static int __init ioapic_init_sysfs(void
 
 device_initcall(ioapic_init_sysfs);
 
-/*
- * Dynamic irq allocate and deallocation
- */
-unsigned int create_irq_nr(unsigned int irq_want)
+#define DEVICE_VECTOR	1
+#define SYSTEM_VECTOR	2
+
+static unsigned int __create_irq_nr(int vector_type, unsigned int irq_want,
+				    cpumask_t *mask, int priority)
 {
 	/* Allocate an unused irq */
 	unsigned int irq;
 	unsigned int new;
 	unsigned long flags;
 	struct irq_cfg *cfg_new;
+	int ret;
 
 #ifndef CONFIG_HAVE_SPARSE_IRQ
 	irq_want = nr_irqs - 1;
 #endif
-
 	irq = 0;
 	spin_lock_irqsave(&vector_lock, flags);
 	for (new = irq_want; new > 0; new--) {
@@ -3071,18 +3129,34 @@ unsigned int create_irq_nr(unsigned int 
 		/* check if need to create one */
 		if (!cfg_new)
 			cfg_new = irq_cfg_alloc(new);
-		if (__assign_irq_vector(new, TARGET_CPUS) == 0)
+		if (vector_type == DEVICE_VECTOR)
+			ret = __assign_irq_vector(new, mask);
+		else
+			ret = __assign_irq_system_vector(new, mask, priority);
+
+		if (ret == 0)
 			irq = new;
 		break;
 	}
 	spin_unlock_irqrestore(&vector_lock, flags);
 
-	if (irq > 0) {
+	if (irq > 0)
 		dynamic_irq_init(irq);
-	}
+
 	return irq;
 }
 
+unsigned int create_irq_nr(unsigned int irq_want)
+{
+	cpumask_t mask = TARGET_CPUS;
+
+	return __create_irq_nr(DEVICE_VECTOR, irq_want, &mask,
+			       IRQ_PRIORITY_LOW);
+}
+
+/*
+ * Dynamic irq device vector allocation.
+ */
 int create_irq(void)
 {
 	int irq;
@@ -3095,6 +3169,9 @@ int create_irq(void)
 	return irq;
 }
 
+/*
+ * Dynamic irq device vector deallocation.
+ */
 void destroy_irq(unsigned int irq)
 {
 	unsigned long flags;
@@ -3109,6 +3186,127 @@ void destroy_irq(unsigned int irq)
 	spin_unlock_irqrestore(&vector_lock, flags);
 }
 
+static void noop(unsigned int irq)
+{
+}
+
+static unsigned int noop_ret(unsigned int irq)
+{
+	return 0;
+}
+
+static void ack_apic(unsigned int irq)
+{
+	ack_APIC_irq();
+}
+
+static struct irq_chip ack_apic_chip = {
+	.name		= "ack_apic",
+	.startup	= noop_ret,
+	.shutdown	= noop,
+	.enable		= noop,
+	.disable	= noop,
+	.ack		= noop,
+	.mask		= noop,
+	.unmask		= noop,
+	.eoi		= ack_apic,
+	.end		= noop,
+};
+
+unsigned int create_irq_system_vector_nr(unsigned int irq_want, cpumask_t *mask,
+					 int priority)
+{
+	return __create_irq_nr(SYSTEM_VECTOR, irq_want, mask, priority);
+}
+
+/*
+ * Dynamic irq system vector allocation.
+ */
+unsigned int create_irq_system_vector(cpumask_t *mask, int priority,
+				      char *irq_name, int *assigned_vector)
+{
+	unsigned long flags;
+	struct irq_cfg *cfg;
+	int irq;
+
+	/* allocate an available irq and vector mapping */
+	irq = create_irq_system_vector_nr(nr_irqs - 1, mask, priority);
+	if (irq == 0)
+		return -1;
+
+	spin_lock_irqsave(&vector_lock, flags);
+	set_irq_chip_and_handler_name(irq, &ack_apic_chip, handle_percpu_irq,
+				      irq_name);
+	spin_unlock_irqrestore(&vector_lock, flags);
+
+	cfg = irq_cfg(irq);
+	*assigned_vector = cfg->vector;
+	return irq;
+}
+EXPORT_SYMBOL(create_irq_system_vector);
+
+/*
+ * Dynamic irq system vector deallocation.
+ */
+void destroy_irq_system_vector(unsigned int irq)
+{
+	unsigned long flags;
+	struct irq_cfg *cfg;
+	int cpu;
+
+	if (irq >= nr_irqs)
+		return;
+	cfg = irq_cfg(irq);
+	if (cfg->vector == 0)
+		return;
+
+#ifdef CONFIG_SMP
+	synchronize_irq(irq);
+#endif
+	dynamic_irq_cleanup(irq);
+	disable_irq(irq);
+
+	spin_lock_irqsave(&vector_lock, flags);
+
+	for_each_cpu_mask_nr(cpu, cfg->domain)
+		per_cpu(vector_irq, cpu)[cfg->vector] = NULL;
+
+	cfg->vector = 0;
+	cpus_clear(cfg->domain);
+
+	spin_unlock_irqrestore(&vector_lock, flags);
+}
+EXPORT_SYMBOL(destroy_irq_system_vector);
+
+int reserve_system_vectors(int number)
+{
+	unsigned long flags;
+	int new_last_device_vector;
+	int vector;
+	int cpu;
+	int ret = -EBUSY;
+
+	spin_lock_irqsave(&vector_lock, flags);
+
+	new_last_device_vector = last_device_vector - number;
+	if (new_last_device_vector < MIN_LAST_DEVICE_VECTOR)
+		goto out;
+
+	for (vector = last_device_vector; vector > new_last_device_vector;
+	     vector--) {
+		for_each_cpu_mask_nr(cpu, cpu_possible_map) {
+			if (per_cpu(vector_irq, cpu)[vector] != NULL)
+				goto out;
+		}
+	}
+
+	last_device_vector = new_last_device_vector;
+	ret = 0;
+out:
+	spin_unlock_irqrestore(&vector_lock, flags);
+	return ret;
+}
+
 /*
  * MSI message composition
  */
Index: linux/include/linux/irq.h
===================================================================
--- linux.orig/include/linux/irq.h	2008-09-10 12:08:46.000000000 -0500
+++ linux/include/linux/irq.h	2008-09-11 06:53:16.000000000 -0500
@@ -390,11 +390,22 @@ set_irq_chained_handler(unsigned int irq
 extern void set_irq_noprobe(unsigned int irq);
 extern void set_irq_probe(unsigned int irq);
 
-/* Handle dynamic irq creation and destruction */
+/* Handle dynamic irq device vector allocation and deallocation */
 extern unsigned int create_irq_nr(unsigned int irq_want);
 extern int create_irq(void);
 extern void destroy_irq(unsigned int irq);
 
+/* Handle dynamic irq system vector allocation and deallocation */
+extern unsigned int create_irq_system_vector(cpumask_t *mask, int priority,
+					     char *irq_name,
+					     int *assigned_vector);
+#define IRQ_PRIORITY_LOW	1
+#define IRQ_PRIORITY_HIGH	2
+
+extern void destroy_irq_system_vector(unsigned int irq);
+
+extern int reserve_system_vectors(int number);
+
 /* Test to see if a driver has successfully requested an irq */
 static inline int irq_has_action(unsigned int irq)
 {
Index: linux/arch/x86/kernel/apic.c
===================================================================
--- linux.orig/arch/x86/kernel/apic.c	2008-09-10 12:08:46.000000000 -0500
+++ linux/arch/x86/kernel/apic.c	2008-09-11 06:42:34.000000000 -0500
@@ -116,7 +116,8 @@ static int disable_apic_timer __cpuinitd
 int local_apic_timer_c2_ok;
 EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
 
-int first_system_vector = 0xfe;
+int first_static_system_vector = 0xfe;
+int last_device_vector = 0xfd;
 
 char system_vectors[NR_VECTORS] = { [0 ... NR_VECTORS-1] = SYS_VECTOR_FREE};
 
Index: linux/include/asm-x86/desc.h
===================================================================
--- linux.orig/include/asm-x86/desc.h	2008-09-10 12:08:46.000000000 -0500
+++ linux/include/asm-x86/desc.h	2008-09-11 06:42:34.000000000 -0500
@@ -323,22 +323,25 @@ static inline void set_intr_gate(unsigne
 #define SYS_VECTOR_FREE		0
 #define SYS_VECTOR_ALLOCED	1
 
-extern int first_system_vector;
+extern int first_static_system_vector;
+extern int last_device_vector;
 extern char system_vectors[];
 
-static inline void alloc_system_vector(int vector)
+static inline void alloc_static_system_vector(int vector)
 {
 	if (system_vectors[vector] == SYS_VECTOR_FREE) {
 		system_vectors[vector] = SYS_VECTOR_ALLOCED;
-		if (first_system_vector > vector)
-			first_system_vector = vector;
+		if (first_static_system_vector > vector)
+			first_static_system_vector = vector;
+		if (last_device_vector > vector - 1)
+			last_device_vector = vector - 1;
 	} else
 		BUG();
 }
 
 static inline void alloc_intr_gate(unsigned int n, void *addr)
 {
-	alloc_system_vector(n);
+	alloc_static_system_vector(n);
 	set_intr_gate(n, addr);
 }
 
Index: linux/include/asm-x86/irq_vectors.h
===================================================================
--- linux.orig/include/asm-x86/irq_vectors.h	2008-09-05 08:38:48.000000000 -0500
+++ linux/include/asm-x86/irq_vectors.h	2008-09-11 07:14:54.000000000 -0500
@@ -92,6 +92,7 @@
  * levels. (0x80 is the syscall vector)
  */
 #define FIRST_DEVICE_VECTOR	(IRQ15_VECTOR + 2)
+#define MIN_LAST_DEVICE_VECTOR	(LOCAL_TIMER_VECTOR - 16)
 
 #define NR_VECTORS		256
 
Index: linux/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux.orig/arch/x86/kernel/irqinit_64.c	2008-09-09 12:57:13.000000000 -0500
+++ linux/arch/x86/kernel/irqinit_64.c	2008-09-11 07:21:41.000000000 -0500
@@ -22,6 +22,7 @@
 #include <asm/desc.h>
 #include <asm/apic.h>
 #include <asm/i8259.h>
+#include <asm/genapic.h>
 
 /*
  * Common place to define all x86 IRQ vectors
@@ -202,6 +203,9 @@ void __init native_init_IRQ(void)
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
 
+	if (is_uv_system())
+		reserve_system_vectors(8);
+
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
 }
