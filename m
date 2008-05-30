Return-Path: <linux-kernel-owner+w=401wt.eu-S1760613AbYE3EK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613AbYE3EK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbYE3EBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:01:08 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56616 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753355AbYE3EAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:25 -0400
Message-Id: <20080530040023.488608389@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:57 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org, Mike Travis <travis@sgi.com>
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 37/41] x86_64: Fold pda into per cpu area
Content-Disposition: inline; filename=zero_based_fold
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Declare the pda as a per cpu variable.
  * Make the x86_64 per cpu area start at zero.

  * Since %gs is pointing to the pda, it will then also point to the per cpu
    variables and can be accessed thusly:

	%gs:[&per_cpu_xxxx - __per_cpu_start]

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/Kconfig                 |    3 +++
 arch/x86/kernel/setup.c          |   22 ++++++++++++++++++++--
 arch/x86/kernel/smpboot.c        |   16 ----------------
 arch/x86/kernel/vmlinux_64.lds.S |    1 +
 include/asm-x86/percpu.h         |   19 +++++++++----------
 5 files changed, 33 insertions(+), 28 deletions(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig	2008-05-29 17:57:39.588714025 -0700
+++ linux-2.6/arch/x86/Kconfig	2008-05-29 18:16:38.743452832 -0700
@@ -126,6 +126,9 @@ config HAVE_SETUP_PER_CPU_AREA
 config HAVE_CPUMASK_OF_CPU_MAP
 	def_bool X86_64_SMP
 
+config HAVE_ZERO_BASED_PER_CPU
+	def_bool X86_64 && SMP
+
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
 	depends on !SMP || !X86_VOYAGER
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c	2008-05-29 18:02:56.229889675 -0700
+++ linux-2.6/arch/x86/kernel/setup.c	2008-05-29 18:17:35.835953108 -0700
@@ -26,6 +26,11 @@ EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid)
 physid_mask_t phys_cpu_present_map;
 #endif
 
+#ifdef CONFIG_X86_64
+DEFINE_PER_CPU_FIRST(struct x8664_pda, pda);
+EXPORT_PER_CPU_SYMBOL(pda);
+#endif
+
 #if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_X86_SMP)
 /*
  * Copy data used in early init routines from the initial arrays to the
@@ -115,13 +120,20 @@ void __init setup_per_cpu_areas(void)
 #endif
 		if (!ptr)
 			panic("Cannot allocate cpu data for CPU %d\n", i);
+
+		memcpy(ptr, __per_cpu_load, __per_cpu_size);
+
 #ifdef CONFIG_X86_64
+		/*
+		 * So far an embryonic per cpu area was used containing only
+		 * the pda. Move the pda contents into the full per cpu area.
+		  */
 		cpu_pda(i)->data_offset = ptr - __per_cpu_start;
+		memcpy(ptr, cpu_pda(i), sizeof(struct x8664_pda));
+		cpu_pda(i) = (struct x8664_pda *)ptr;
 #else
 		__per_cpu_offset[i] = ptr - __per_cpu_start;
 #endif
-		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
-
 		highest_cpu = i;
 	}
 
@@ -132,6 +144,12 @@ void __init setup_per_cpu_areas(void)
 	setup_boot_pagesets();
 
 	nr_cpu_ids = highest_cpu + 1;
+
+#ifdef CONFIG_X86_64
+	/* Fix up pda for boot processor */
+	pda_init(0);
+#endif
+
 	printk(KERN_DEBUG "NR_CPUS: %d, nr_cpu_ids: %d\n", NR_CPUS, nr_cpu_ids);
 
 	/* Setup percpu data maps */
Index: linux-2.6/arch/x86/kernel/vmlinux_64.lds.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmlinux_64.lds.S	2008-05-29 17:57:39.600964822 -0700
+++ linux-2.6/arch/x86/kernel/vmlinux_64.lds.S	2008-05-29 18:05:08.514214613 -0700
@@ -16,6 +16,7 @@ jiffies_64 = jiffies;
 _proxy_pda = 1;
 PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
+	percpu PT_LOAD FLAGS(4);	/* R__ */
 	data PT_LOAD FLAGS(7);	/* RWE */
 	user PT_LOAD FLAGS(7);	/* RWE */
 	data.init PT_LOAD FLAGS(7);	/* RWE */
Index: linux-2.6/include/asm-x86/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-x86/percpu.h	2008-05-29 17:57:39.616964037 -0700
+++ linux-2.6/include/asm-x86/percpu.h	2008-05-29 18:17:20.419452945 -0700
@@ -3,21 +3,16 @@
 
 #ifdef CONFIG_X86_64
 #include <linux/compiler.h>
-
-/* Same as asm-generic/percpu.h, except that we store the per cpu offset
-   in the PDA. Longer term the PDA and every per cpu variable
-   should be just put into a single section and referenced directly
-   from %gs */
-
-#ifdef CONFIG_SMP
 #include <asm/pda.h>
 
+#ifdef CONFIG_SMP
 #define __per_cpu_offset(cpu) (cpu_pda(cpu)->data_offset)
 #define __my_cpu_offset read_pda(data_offset)
-
 #define per_cpu_offset(x) (__per_cpu_offset(x))
-
 #endif
+
+#define __percpu_seg "%%gs:"
+
 #include <asm-generic/percpu.h>
 
 DECLARE_PER_CPU(struct x8664_pda, pda);
@@ -81,6 +76,11 @@ DECLARE_PER_CPU(struct x8664_pda, pda);
 /* We can use this directly for local CPU (faster). */
 DECLARE_PER_CPU(unsigned long, this_cpu_off);
 
+#endif /* __ASSEMBLY__ */
+#endif /* !CONFIG_X86_64 */
+
+#ifndef __ASSEMBLY__
+
 /* For arch-specific code, we can use direct single-insn ops (they
  * don't give an lvalue though). */
 extern void __bad_percpu_size(void);
@@ -142,5 +142,4 @@ do {							\
 #define x86_sub_percpu(var, val) percpu_to_op("sub", per_cpu__##var, val)
 #define x86_or_percpu(var, val) percpu_to_op("or", per_cpu__##var, val)
 #endif /* !__ASSEMBLY__ */
-#endif /* !CONFIG_X86_64 */
 #endif /* _ASM_X86_PERCPU_H_ */
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c	2008-05-29 17:57:39.608964052 -0700
+++ linux-2.6/arch/x86/kernel/smpboot.c	2008-05-29 18:17:18.539452880 -0700
@@ -855,22 +855,6 @@ static int __cpuinit do_boot_cpu(int api
 		printk(KERN_ERR "Failed to allocate GDT for CPU %d\n", cpu);
 		return -1;
 	}
-
-	/* Allocate node local memory for AP pdas */
-	if (cpu_pda(cpu) == &boot_cpu_pda[cpu]) {
-		struct x8664_pda *newpda, *pda;
-		int node = cpu_to_node(cpu);
-		pda = cpu_pda(cpu);
-		newpda = kmalloc_node(sizeof(struct x8664_pda), GFP_ATOMIC,
-				      node);
-		if (newpda) {
-			memcpy(newpda, pda, sizeof(struct x8664_pda));
-			cpu_pda(cpu) = newpda;
-		} else
-			printk(KERN_ERR
-		"Could not allocate node local PDA for CPU %d on node %d\n",
-				cpu, node);
-	}
 #endif
 
 	alternatives_smp_switch(1);

-- 
