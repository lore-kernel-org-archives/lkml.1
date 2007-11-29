Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbXK2GI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbXK2GI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 01:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbXK2GIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 01:08:20 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35795 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751957AbXK2GIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 01:08:19 -0500
Date: Wed, 28 Nov 2007 22:08:18 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch
 specific percpu setup
In-Reply-To: <474E4E2F.9010801@goop.org>
Message-ID: <Pine.LNX.4.64.0711282206510.21631@schroedinger.engr.sgi.com>
References: <20071127001407.859743255@sgi.com> <200711281236.02014.rusty@rustcorp.com.au>
 <Pine.LNX.4.64.0711281050470.11968@schroedinger.engr.sgi.com>
 <200711291017.52727.rusty@rustcorp.com.au> <474DFD7E.907@goop.org>
 <Pine.LNX.4.64.0711281604560.17738@schroedinger.engr.sgi.com>
 <474E163E.2070702@goop.org> <Pine.LNX.4.64.0711281731410.19914@schroedinger.engr.sgi.com>
 <474E1900.1010209@goop.org> <Pine.LNX.4.64.0711281800100.20125@schroedinger.engr.sgi.com>
 <474E4E2F.9010801@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the first of two patches for x86_64 that move the pda into the per 
cpu area and then make the x86 percpu macros work for x86_64. This needs 
to be generalized for other arches. The __per_cpu_start offsets can be 
taken care of by the linker. We can also tell the linker to completely 
relocate the percpu area to 0.



X86_64: Declare pda as per cpu data thereby moving it into the cpu area

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
 

