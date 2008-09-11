Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbYIKP2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbYIKP2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 11:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYIKP2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 11:28:38 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53426 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752007AbYIKP2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 11:28:37 -0400
Date: Thu, 11 Sep 2008 10:28:36 -0500
From: Dean Nelson <dcn@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Mayer <ajm@sgi.com>, Ingo Molnar <mingo@elte.hu>, jeremy@goop.org,
       rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: [RFC 3/4] switch static system vector allocation to use vector_irq[]
Message-ID: <20080911152836.GD13655@sgi.com>
References: <489C6844.9050902@sgi.com> <20080811165930.GI4524@elte.hu> <48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org> <20080911152304.GA13655@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080911152304.GA13655@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the current use of system_vectors[] for the allocation of static
system vectors by also using the per_cpu variable vector_irq[].

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

 arch/x86/kernel/apic.c    |    2 --
 arch/x86/kernel/io_apic.c |   22 ++++++++++++----------
 arch/x86/kernel/irq_32.c  |    2 +-
 arch/x86/kernel/irq_64.c  |    2 +-
 include/asm-x86/desc.h    |   21 +++++++++++++--------
 include/asm-x86/irq.h     |    2 ++
 include/linux/irq.h       |    5 +++++
 7 files changed, 34 insertions(+), 22 deletions(-)

Index: linux/arch/x86/kernel/apic.c
===================================================================
--- linux.orig/arch/x86/kernel/apic.c	2008-09-10 12:09:43.000000000 -0500
+++ linux/arch/x86/kernel/apic.c	2008-09-10 12:10:35.000000000 -0500
@@ -119,8 +119,6 @@ EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok
 int first_static_system_vector = 0xfe;
 int last_device_vector = 0xfd;
 
-char system_vectors[NR_VECTORS] = { [0 ... NR_VECTORS-1] = SYS_VECTOR_FREE};
-
 /*
  * Debug level, exported for io_apic.c
  */
Index: linux/include/asm-x86/desc.h
===================================================================
--- linux.orig/include/asm-x86/desc.h	2008-09-10 12:09:43.000000000 -0500
+++ linux/include/asm-x86/desc.h	2008-09-10 12:10:35.000000000 -0500
@@ -6,6 +6,7 @@
 #include <asm/ldt.h>
 #include <asm/mmu.h>
 #include <linux/smp.h>
+#include <linux/irq.h>
 
 static inline void fill_ldt(struct desc_struct *desc,
 			    const struct user_desc *info)
@@ -329,14 +330,18 @@ extern char system_vectors[];
 
 static inline void alloc_static_system_vector(int vector)
 {
-	if (system_vectors[vector] == SYS_VECTOR_FREE) {
-		system_vectors[vector] = SYS_VECTOR_ALLOCED;
-		if (first_static_system_vector > vector)
-			first_static_system_vector = vector;
-		if (last_device_vector > vector - 1)
-			last_device_vector = vector - 1;
-	} else
-		BUG();
+	unsigned long flags;
+	bool ret;
+
+	spin_lock_irqsave(&vector_lock, flags);
+	ret = __grab_irq_vector(NON_IRQ_DESC, vector, &cpu_possible_map);
+	BUG_ON(ret == false);
+
+	if (first_static_system_vector > vector)
+		first_static_system_vector = vector;
+	if (last_device_vector > vector - 1)
+		last_device_vector = vector - 1;
+	spin_unlock_irqrestore(&vector_lock, flags);
 }
 
 static inline void alloc_intr_gate(unsigned int n, void *addr)
Index: linux/arch/x86/kernel/io_apic.c
===================================================================
--- linux.orig/arch/x86/kernel/io_apic.c	2008-09-10 12:09:43.000000000 -0500
+++ linux/arch/x86/kernel/io_apic.c	2008-09-10 14:17:12.000000000 -0500
@@ -70,7 +70,7 @@
 int sis_apic_bug = -1;
 
 static DEFINE_SPINLOCK(ioapic_lock);
-static DEFINE_SPINLOCK(vector_lock);
+DEFINE_SPINLOCK(vector_lock);
 
 /*
  * # of IRQ routing registers
@@ -1221,13 +1221,15 @@ bool __grab_irq_vector(struct irq_desc *
 	for_each_cpu_mask_nr(cpu, *new_domain_mask)
 		per_cpu(vector_irq, cpu)[vector] = desc;
 
-	cfg = irq_cfg(desc->irq);
-	if (cfg->vector) {
-		cfg->move_in_progress = 1;
-		cfg->old_domain = cfg->domain;
+	if (desc != NON_IRQ_DESC) {
+		cfg = irq_cfg(desc->irq);
+		if (cfg->vector) {
+			cfg->move_in_progress = 1;
+			cfg->old_domain = cfg->domain;
+		}
+		cfg->vector = vector;
+		cfg->domain = *new_domain_mask;
 	}
-	cfg->vector = vector;
-	cfg->domain = *new_domain_mask;
 
 	return true;
 }
@@ -1387,13 +1389,13 @@ void __setup_vector_irq(int cpu)
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
@@ -2437,7 +2439,7 @@ asmlinkage void smp_irq_move_cleanup_int
 		struct irq_cfg *cfg;
 
 		desc = __get_cpu_var(vector_irq)[vector];
-		if (desc == NULL)
+		if (desc == NULL || desc == NON_IRQ_DESC)
 			continue;
 
 		cfg = irq_cfg(desc->irq);
Index: linux/include/linux/irq.h
===================================================================
--- linux.orig/include/linux/irq.h	2008-09-10 12:09:43.000000000 -0500
+++ linux/include/linux/irq.h	2008-09-10 12:10:35.000000000 -0500
@@ -390,6 +390,11 @@ set_irq_chained_handler(unsigned int irq
 extern void set_irq_noprobe(unsigned int irq);
 extern void set_irq_probe(unsigned int irq);
 
+extern bool __grab_irq_vector(struct irq_desc *desc, unsigned int vector,
+			      cpumask_t *new_domain_mask);
+
+#define NON_IRQ_DESC	((struct irq_desc *)-1UL)
+
 /* Handle dynamic irq device vector allocation and deallocation */
 extern unsigned int create_irq_nr(unsigned int irq_want);
 extern int create_irq(void);
Index: linux/arch/x86/kernel/irq_32.c
===================================================================
--- linux.orig/arch/x86/kernel/irq_32.c	2008-09-10 12:08:37.000000000 -0500
+++ linux/arch/x86/kernel/irq_32.c	2008-09-10 12:10:35.000000000 -0500
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
--- linux.orig/arch/x86/kernel/irq_64.c	2008-09-10 12:08:37.000000000 -0500
+++ linux/arch/x86/kernel/irq_64.c	2008-09-10 12:10:35.000000000 -0500
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
--- linux.orig/include/asm-x86/irq.h	2008-09-10 12:07:29.000000000 -0500
+++ linux/include/asm-x86/irq.h	2008-09-10 14:22:12.000000000 -0500
@@ -47,4 +47,6 @@ extern void native_init_IRQ(void);
 /* Interrupt vector management */
 extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
 
+extern spinlock_t vector_lock;
+
 #endif /* ASM_X86__IRQ_H */
