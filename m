Return-Path: <linux-kernel-owner+w=401wt.eu-S1751840AbYDEBMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbYDEBMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbYDEBLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:11:09 -0400
Received: from relay1.sgi.com ([192.48.171.29]:57915 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751725AbYDEBLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:11:04 -0400
Message-Id: <20080405011101.067931000@polaris-admin.engr.sgi.com>
References: <20080405011100.720014000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 18:11:01 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 01/12] x86: Convert cpumask_of_cpu macro to allocated array
Content-Disposition: inline; filename=cpumask_of_cpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Here is a simple patch to use an allocated array of cpumasks to
    represent cpumask_of_cpu() instead of constructing one on the stack.
    It's based on the Kconfig option "HAVE_CPUMASK_OF_CPU_MAP" which is
    currently only set for x86_64 SMP.  Otherwise the the existing
    cpumask_of_cpu() is used but has been changed to produce an lvalue
    so a pointer to it can be used.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/Kconfig        |    3 +++
 arch/x86/kernel/setup.c |   28 +++++++++++++++++++++++++++-
 include/linux/cpumask.h |   12 +++++++++---
 3 files changed, 39 insertions(+), 4 deletions(-)

--- linux-2.6.x86.orig/arch/x86/Kconfig
+++ linux-2.6.x86/arch/x86/Kconfig
@@ -124,6 +124,9 @@ config ARCH_HAS_CPU_RELAX
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool X86_64 || (X86_SMP && !X86_VOYAGER)
 
+config HAVE_CPUMASK_OF_CPU_MAP
+	def_bool X86_64_SMP
+
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
 	depends on !SMP || !X86_VOYAGER
--- linux-2.6.x86.orig/arch/x86/kernel/setup.c
+++ linux-2.6.x86/arch/x86/kernel/setup.c
@@ -38,6 +38,24 @@ static void __init setup_per_cpu_maps(vo
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
@@ -54,7 +72,7 @@ EXPORT_SYMBOL(__per_cpu_offset);
  */
 void __init setup_per_cpu_areas(void)
 {
-	int i;
+	int i, highest_cpu = 0;
 	unsigned long size;
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -88,10 +106,18 @@ void __init setup_per_cpu_areas(void)
 		__per_cpu_offset[i] = ptr - __per_cpu_start;
 #endif
 		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
+
+		highest_cpu = i;
 	}
 
+	nr_cpu_ids = highest_cpu + 1;
+	printk(KERN_DEBUG "NR_CPUS: %d, nr_cpu_ids: %d\n", NR_CPUS, nr_cpu_ids);
+
 	/* Setup percpu data maps */
 	setup_per_cpu_maps();
+
+	/* Setup cpumask_of_cpu map */
+	setup_cpumask_of_cpu();
 }
 
 #endif
--- linux-2.6.x86.orig/include/linux/cpumask.h
+++ linux-2.6.x86/include/linux/cpumask.h
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
