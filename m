Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbXKTBYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbXKTBYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756680AbXKTBOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:14:11 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36874 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756126AbXKTBNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:40 -0500
Message-Id: <20071120011340.110250064@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:12:07 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 35/45] X86_64: Declare pda as per cpu data thereby moving it into the cpu area
Content-Disposition: inline; filename=x86_64_fold_pda
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Declare the pda as a per cpu variable. This will have the effect of moving
the pda data into the cpu area managed by cpu alloc.

The boot_pdas are only needed in head64.c so move the declaration
over there and make it static.

Remove the code that allocates special pda data structures.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/kernel/head64.c     |    6 ++++++
 arch/x86/kernel/setup64.c    |   11 ++++++++++-
 arch/x86/kernel/smpboot_64.c |   16 ----------------
 include/asm-x86/pda.h        |    1 -
 include/asm-x86/percpu_64.h  |    1 +
 5 files changed, 17 insertions(+), 18 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup64.c	2007-11-19 16:29:09.045139782 -0800
+++ linux-2.6/arch/x86/kernel/setup64.c	2007-11-19 16:29:15.693140270 -0800
@@ -30,7 +30,9 @@ cpumask_t cpu_initialized __cpuinitdata 
 
 struct x8664_pda *_cpu_pda[NR_CPUS] __read_mostly;
 EXPORT_SYMBOL(_cpu_pda);
-struct x8664_pda boot_cpu_pda[NR_CPUS] __cacheline_aligned;
+
+DEFINE_PER_CPU(struct x8664_pda, pda);
+EXPORT_PER_CPU_SYMBOL(pda);
 
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
@@ -105,7 +107,13 @@ void __init setup_per_cpu_areas(void)
 
 		memcpy(CPU_PTR(base, i), __load_per_cpu_start,
 				__per_cpu_end - __per_cpu_start);
+
+		/* Relocate the pda */
+		memcpy(&per_cpu(pda, i), cpu_pda(i), sizeof(struct x8664_pda));
+		cpu_pda(i) = &per_cpu(pda, i);
 	}
+	/* Fix up pda for this processor .... */
+	pda_init(0);
 	count_vm_events(CPU_BYTES, PERCPU_ENOUGH_ROOM);
 }
 
@@ -120,6 +128,7 @@ void pda_init(int cpu)
 	wrmsrl(MSR_GS_BASE, pda);
 	mb();
 
+	printk(KERN_INFO "Processor #%d: GS for cpu variable access set to %p\n",cpu, pda);
 	pda->cpunumber = cpu; 
 	pda->irqcount = -1;
 	pda->kernelstack = 
Index: linux-2.6/arch/x86/kernel/smpboot_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot_64.c	2007-11-19 16:28:00.781640288 -0800
+++ linux-2.6/arch/x86/kernel/smpboot_64.c	2007-11-19 16:29:15.693140270 -0800
@@ -556,22 +556,6 @@ static int __cpuinit do_boot_cpu(int cpu
 		return -1;
 	}
 
-	/* Allocate node local memory for AP pdas */
-	if (cpu_pda(cpu) == &boot_cpu_pda[cpu]) {
-		struct x8664_pda *newpda, *pda;
-		int node = cpu_to_node(cpu);
-		pda = cpu_pda(cpu);
-		newpda = kmalloc_node(sizeof (struct x8664_pda), GFP_ATOMIC,
-				      node);
-		if (newpda) {
-			memcpy(newpda, pda, sizeof (struct x8664_pda));
-			cpu_pda(cpu) = newpda;
-		} else
-			printk(KERN_ERR
-		"Could not allocate node local PDA for CPU %d on node %d\n",
-				cpu, node);
-	}
-
 	alternatives_smp_switch(1);
 
 	c_idle.idle = get_idle_for_cpu(cpu);
Index: linux-2.6/arch/x86/kernel/head64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head64.c	2007-11-19 16:28:00.789640087 -0800
+++ linux-2.6/arch/x86/kernel/head64.c	2007-11-19 16:29:15.693140270 -0800
@@ -20,6 +20,12 @@
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
 
+/*
+ * Only used before the per cpu areas are setup. The use for the non possible
+ * cpus continues after boot
+ */
+static struct x8664_pda boot_cpu_pda[NR_CPUS];
+
 static void __init zap_identity_mappings(void)
 {
 	pgd_t *pgd = pgd_offset_k(0UL);
Index: linux-2.6/include/asm-x86/pda.h
===================================================================
--- linux-2.6.orig/include/asm-x86/pda.h	2007-11-19 16:28:00.801640345 -0800
+++ linux-2.6/include/asm-x86/pda.h	2007-11-19 16:29:15.693140270 -0800
@@ -39,7 +39,6 @@ struct x8664_pda {
 } ____cacheline_aligned_in_smp;
 
 extern struct x8664_pda *_cpu_pda[];
-extern struct x8664_pda boot_cpu_pda[];
 
 #define cpu_pda(i) (_cpu_pda[i])
 
Index: linux-2.6/include/asm-x86/percpu_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/percpu_64.h	2007-11-19 16:28:33.611190669 -0800
+++ linux-2.6/include/asm-x86/percpu_64.h	2007-11-19 16:29:39.569139671 -0800
@@ -61,6 +61,7 @@ extern void setup_per_cpu_areas(void);
 #endif	/* SMP */
 
 #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
+DECLARE_PER_CPU(struct x8664_pda, pda);
 
 #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
 #define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)

-- 
