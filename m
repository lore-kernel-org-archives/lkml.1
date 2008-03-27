Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbYC0XRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbYC0XRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 19:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYC0XQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 19:16:56 -0400
Received: from relay2.sgi.com ([192.48.171.30]:43161 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751988AbYC0XQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 19:16:55 -0400
Message-Id: <20080327231654.464266000@polaris-admin.engr.sgi.com>
References: <20080327231654.284673000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Mar 2008 16:16:55 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 1/2] x86: Convert cpumask_of_cpu macro to allocated array
Content-Disposition: inline; filename=cpumask_of_cpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a simple patch to use an allocated array of cpumasks to
represent cpumask_of_cpu() instead of constructing one on the stack.
It's based on the Kconfig option "HAVE_CPUMASK_OF_CPU_MAP" which is
currently only set for x86_64 SMP.

Note that the existing cpumask_of_cpu() macro is also changed to
produce an lvalue so a pointer to it can be used.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/Kconfig        |    3 +++
 arch/x86/kernel/setup.c |   39 +++++++++++++++++++++++++++++++++++++++
 include/linux/cpumask.h |   12 +++++++++---
 3 files changed, 51 insertions(+), 3 deletions(-)

--- linux.trees.git.orig/arch/x86/Kconfig
+++ linux.trees.git/arch/x86/Kconfig
@@ -123,6 +123,9 @@ config ARCH_HAS_CPU_RELAX
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool X86_64 || (X86_SMP && !X86_VOYAGER)
 
+config HAVE_CPUMASK_OF_CPU_MAP
+	def_bool X86_64_SMP
+
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
 	depends on !SMP || !X86_VOYAGER
--- linux.trees.git.orig/arch/x86/kernel/setup.c
+++ linux.trees.git/arch/x86/kernel/setup.c
@@ -10,6 +10,21 @@
 #include <asm/setup.h>
 #include <asm/topology.h>
 
+#ifdef CONFIG_SMP
+/* setup nr_cpu_ids early */
+static void __init setup_nr_cpu_ids(void)
+{
+	int cpu, highest_cpu = 0;
+
+	for_each_possible_cpu(cpu)
+		highest_cpu = cpu;
+
+	nr_cpu_ids = highest_cpu + 1;
+}
+#else
+static inline void setup_nr_cpu_ids(void) { }
+#endif
+
 #if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_SMP)
 /*
  * Copy data used in early init routines from the initial arrays to the
@@ -38,6 +53,24 @@ static void __init setup_per_cpu_maps(vo
 #endif
 }
 
+#ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
+cpumask_t *cpumask_of_cpu_map __read_mostly;
+EXPORT_SYMBOL(cpumask_of_cpu_map);
+
+/* requires nr_cpu_ids to be initialized */
+static void __init setup_cpumask_of_cpu(void)
+{
+	int i;
+
+	/* alloc_bootmem zeroes memory */
+	cpumask_of_cpu_map = alloc_bootmem_low(sizeof(cpumask_t) * nr_cpu_ids);
+	for (i = 0; i < nr_cpu_ids; i++)
+		cpu_set(i, cpumask_of_cpu_map[i]);
+}
+#else
+static inline void setup_cpumask_of_cpu(void) { }
+#endif
+
 #ifdef CONFIG_X86_32
 /*
  * Great future not-so-futuristic plan: make i386 and x86_64 do it
@@ -90,8 +123,14 @@ void __init setup_per_cpu_areas(void)
 		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
 	}
 
+	/* Setup nr_cpu_ids */
+	setup_nr_cpu_ids();
+
 	/* Setup percpu data maps */
 	setup_per_cpu_maps();
+
+	/* Setup cpumask_of_cpu map */
+	setup_cpumask_of_cpu();
 }
 
 #endif
--- linux.trees.git.orig/include/linux/cpumask.h
+++ linux.trees.git/include/linux/cpumask.h
@@ -222,8 +222,13 @@ int __next_cpu(int n, const cpumask_t *s
 #define next_cpu(n, src)	({ (void)(src); 1; })
 #endif
 
+#ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
+extern cpumask_t *cpumask_of_cpu_map;
+#define cpumask_of_cpu(cpu)    (cpumask_of_cpu_map[cpu])
+
+#else
 #define cpumask_of_cpu(cpu)						\
-({									\
+(*({									\
 	typeof(_unused_cpumask_arg_) m;					\
 	if (sizeof(m) == sizeof(unsigned long)) {			\
 		m.bits[0] = 1UL<<(cpu);					\
@@ -231,8 +236,9 @@ int __next_cpu(int n, const cpumask_t *s
 		cpus_clear(m);						\
 		cpu_set((cpu), m);					\
 	}								\
-	m;								\
-})
+	&m;								\
+}))
+#endif
 
 #define CPU_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(NR_CPUS)
 

-- 
