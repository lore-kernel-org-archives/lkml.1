Return-Path: <linux-kernel-owner+w=401wt.eu-S934085AbXK3Got@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934085AbXK3Got (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 01:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932586AbXK3GoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 01:44:07 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51770 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755981AbXK3GoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 01:44:02 -0500
Message-Id: <20071130064359.824070182@sgi.com>
References: <20071130064305.459255715@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 Nov 2007 22:43:07 -0800
From: Christoph Lameter <clameter@sgi.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 2/3] X86_64: Declare pda as per cpu data thereby moving it into the cpu area
Content-Disposition: inline; filename=x86_64_fold_pda
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Declare the pda as a per cpu variable. This will have the effect of moving
the pda data into the cpu area managed by cpu alloc.

The boot_pdas are only needed in head64.c so move the declaration
over there and make it static.

Remove the code that allocates special pda data structures.

The pda is moved to the beginning of the per cpu area. gs is pointing to the
pda. And therefore gs: is now pointing to the per cpu area of the current
processor. A per cpu variable can then be reached at

%gs:[&per_cpu_xxxx - __per_cpu_start]

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/kernel/head64.c          |    6 ++++++
 arch/x86/kernel/setup64.c         |   13 ++++++++++---
 arch/x86/kernel/smpboot_64.c      |   16 ----------------
 include/asm-generic/vmlinux.lds.h |    1 +
 include/asm-x86/pda.h             |    1 -
 include/linux/percpu.h            |    4 ++++
 6 files changed, 21 insertions(+), 20 deletions(-)

Index: linux-2.6.24-rc3-mm2/arch/x86/kernel/setup64.c
===================================================================
--- linux-2.6.24-rc3-mm2.orig/arch/x86/kernel/setup64.c	2007-11-28 20:59:13.124188194 -0800
+++ linux-2.6.24-rc3-mm2/arch/x86/kernel/setup64.c	2007-11-28 21:08:50.473347382 -0800
@@ -30,7 +30,9 @@ cpumask_t cpu_initialized __cpuinitdata 
 
 struct x8664_pda *_cpu_pda[NR_CPUS] __read_mostly;
 EXPORT_SYMBOL(_cpu_pda);
-struct x8664_pda boot_cpu_pda[NR_CPUS] __cacheline_aligned;
+
+DEFINE_PER_CPU_FIRST(struct x8664_pda, pda);
+EXPORT_PER_CPU_SYMBOL(pda);
 
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
@@ -109,10 +111,15 @@ void __init setup_per_cpu_areas(void)
 		}
 		if (!ptr)
 			panic("Cannot allocate cpu data for CPU %d\n", i);
-		cpu_pda(i)->data_offset = ptr - __per_cpu_start;
 		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
+		/* Relocate the pda */
+		memcpy(ptr, cpu_pda(i), sizeof(struct x8664_pda));
+		cpu_pda(i) = (struct x8664_pda *)ptr;
+		cpu_pda(i)->data_offset = ptr - __per_cpu_start;
 	}
-} 
+	/* Fix up pda for this processor .... */
+	pda_init(0);
+}
 
 void pda_init(int cpu)
 { 
Index: linux-2.6.24-rc3-mm2/arch/x86/kernel/smpboot_64.c
===================================================================
--- linux-2.6.24-rc3-mm2.orig/arch/x86/kernel/smpboot_64.c	2007-11-28 20:59:13.136188167 -0800
+++ linux-2.6.24-rc3-mm2/arch/x86/kernel/smpboot_64.c	2007-11-28 20:59:35.399937395 -0800
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
Index: linux-2.6.24-rc3-mm2/arch/x86/kernel/head64.c
===================================================================
--- linux-2.6.24-rc3-mm2.orig/arch/x86/kernel/head64.c	2007-11-28 20:59:13.152187359 -0800
+++ linux-2.6.24-rc3-mm2/arch/x86/kernel/head64.c	2007-11-28 20:59:35.403937534 -0800
@@ -22,6 +22,12 @@
 #include <asm/sections.h>
 #include <asm/kdebug.h>
 
+/*
+ * Only used before the per cpu areas are setup. The use for the non possible
+ * cpus continues after boot
+ */
+static struct x8664_pda boot_cpu_pda[NR_CPUS] __cacheline_aligned;
+
 static void __init zap_identity_mappings(void)
 {
 	pgd_t *pgd = pgd_offset_k(0UL);
Index: linux-2.6.24-rc3-mm2/include/asm-x86/pda.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-x86/pda.h	2007-11-28 20:59:13.164187921 -0800
+++ linux-2.6.24-rc3-mm2/include/asm-x86/pda.h	2007-11-28 20:59:35.403937534 -0800
@@ -39,7 +39,6 @@ struct x8664_pda {
 } ____cacheline_aligned_in_smp;
 
 extern struct x8664_pda *_cpu_pda[];
-extern struct x8664_pda boot_cpu_pda[];
 extern void pda_init(int);
 
 #define cpu_pda(i) (_cpu_pda[i])
Index: linux-2.6.24-rc3-mm2/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-generic/vmlinux.lds.h	2007-11-28 20:59:13.176187886 -0800
+++ linux-2.6.24-rc3-mm2/include/asm-generic/vmlinux.lds.h	2007-11-28 20:59:35.403937534 -0800
@@ -259,6 +259,7 @@
 	. = ALIGN(align);						\
 	__per_cpu_start = .;						\
 	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {		\
+		*(.data.percpu.first)					\
 		*(.data.percpu)						\
 		*(.data.percpu.shared_aligned)				\
 	}								\
Index: linux-2.6.24-rc3-mm2/include/linux/percpu.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/linux/percpu.h	2007-11-28 20:59:13.188187940 -0800
+++ linux-2.6.24-rc3-mm2/include/linux/percpu.h	2007-11-28 21:09:23.399307556 -0800
@@ -23,6 +23,10 @@
 	DEFINE_PER_CPU(type, name)
 #endif
 
+#define DEFINE_PER_CPU_FIRST(type, name)				\
+	__attribute__((__section__(".data.percpu.first")))		\
+	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
+
 #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
 #define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
 

-- 
