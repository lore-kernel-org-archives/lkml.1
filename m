Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbZAMKkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbZAMKkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 05:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbZAMKjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 05:39:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:51104 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbZAMKjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 05:39:02 -0500
From: Tejun Heo <tj@kernel.org>
To: ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       mingo@elte.hu, travis@sgi.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, akpm@linux-foundation.org, steiner@sgi.com,
       hugh@veritas.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/13] x86_64: fold pda into percpu area on SMP
Date: Tue, 13 Jan 2009 19:38:12 +0900
Message-Id: <1231843097-18003-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1231843097-18003-1-git-send-email-tj@kernel.org>
References: <1231843097-18003-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Jan 2009 10:38:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently pdas and percpu areas are allocated separately.  %gs points
to local pda and percpu area can be reached using pda->data_offset.
This patch folds pda into percpu area.

Due to strange gcc requirement, pda needs to be at the beginning of
the percpu area so that pda->stack_canary is at %gs:40.  To achieve
this, a new percpu output section macro - PERCPU_VADDR_PREALLOC() - is
added and used to reserve pda sized chunk at the start of the percpu
area.

After this change, for boot cpu, %gs first points to pda in the
data.init area and later during setup_per_cpu_areas() gets updated to
point to the actual pda.  This means that setup_per_cpu_areas() need
to reload %gs for CPU0 while clearing pda area for other cpus as cpu0
already has modified it when control reaches setup_per_cpu_areas().

This patch also removes now unnecessary get_local_pda() and its call
sites.

A lot of this patch is taken from Mike Travis' "x86_64: Fold pda into
per cpu area" patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mike Travis <travis@sgi.com>
---
 arch/x86/include/asm/percpu.h     |    8 ++++
 arch/x86/include/asm/smp.h        |    2 -
 arch/x86/kernel/asm-offsets_64.c  |    1 +
 arch/x86/kernel/cpu/common.c      |    6 +--
 arch/x86/kernel/head64.c          |    8 ++++-
 arch/x86/kernel/head_64.S         |   15 ++++++--
 arch/x86/kernel/setup_percpu.c    |   65 ++++++++++++++----------------------
 arch/x86/kernel/smpboot.c         |   60 +---------------------------------
 arch/x86/kernel/vmlinux_64.lds.S  |    6 ++-
 arch/x86/xen/smp.c                |   10 ------
 include/asm-generic/vmlinux.lds.h |   25 +++++++++++++-
 11 files changed, 83 insertions(+), 123 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index df644f3..0ed77cf 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -1,6 +1,14 @@
 #ifndef _ASM_X86_PERCPU_H
 #define _ASM_X86_PERCPU_H
 
+#ifndef __ASSEMBLY__
+#ifdef CONFIG_X86_64
+extern void load_pda_offset(int cpu);
+#else
+static inline void load_pda_offset(int cpu) { }
+#endif
+#endif
+
 #ifdef CONFIG_X86_64
 #include <linux/compiler.h>
 
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index d12811c..288a89e 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -25,8 +25,6 @@ extern cpumask_t cpu_callin_map;
 extern void (*mtrr_hook)(void);
 extern void zap_low_mappings(void);
 
-extern int __cpuinit get_local_pda(int cpu);
-
 extern int smp_num_siblings;
 extern unsigned int num_processors;
 extern cpumask_t cpu_initialized;
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 1d41d3f..f8d1b04 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -56,6 +56,7 @@ int main(void)
 	ENTRY(cpunumber);
 	ENTRY(irqstackptr);
 	ENTRY(data_offset);
+	DEFINE(pda_size, sizeof(struct x8664_pda));
 	BLANK();
 #undef ENTRY
 #ifdef CONFIG_PARAVIRT
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 5c3d6b3..cdd419a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -873,10 +873,8 @@ void __cpuinit pda_init(int cpu)
 	/* Setup up data that may be needed in __get_free_pages early */
 	loadsegment(fs, 0);
 	loadsegment(gs, 0);
-	/* Memory clobbers used to order PDA accessed */
-	mb();
-	wrmsrl(MSR_GS_BASE, pda);
-	mb();
+
+	load_pda_offset(cpu);
 
 	pda->cpunumber = cpu;
 	pda->irqcount = -1;
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 84b96b9..ff39bdd 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -26,12 +26,18 @@
 #include <asm/bios_ebda.h>
 #include <asm/trampoline.h>
 
-/* boot cpu pda, referenced by head_64.S to initialize %gs for boot CPU */
+#ifndef CONFIG_SMP
+/* boot cpu pda, referenced by head_64.S to initialize %gs on UP */
 struct x8664_pda _boot_cpu_pda __read_mostly;
+#endif
 
 void __init x86_64_init_pda(void)
 {
+#ifdef CONFIG_SMP
+	cpu_pda(0) = (void *)__per_cpu_load;
+#else
 	cpu_pda(0) = &_boot_cpu_pda;
+#endif
 	cpu_pda(0)->data_offset =
 		(unsigned long)(__per_cpu_load - __per_cpu_start);
 	pda_init(0);
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 3f56a8f..519185f 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -245,10 +245,13 @@ ENTRY(secondary_startup_64)
 
 	/* Set up %gs.
 	 *
-	 * %gs should point to the pda.  For initial boot, make %gs point
-	 * to the _boot_cpu_pda in data section.  For a secondary CPU,
-	 * initial_gs should be set to its pda address before the CPU runs
-	 * this code.
+	 * On SMP, %gs should point to the per-cpu area.  For initial
+	 * boot, make %gs point to the init data section.  For a
+	 * secondary CPU,initial_gs should be set to its pda address
+	 * before the CPU runs this code.
+	 *
+	 * On UP, initial_gs points to _boot_cpu_pda and doesn't
+	 * change.
 	 */
 	movl	$MSR_GS_BASE,%ecx
 	movq	initial_gs(%rip),%rax
@@ -278,7 +281,11 @@ ENTRY(secondary_startup_64)
 	ENTRY(initial_code)
 	.quad	x86_64_start_kernel
 	ENTRY(initial_gs)
+#ifdef CONFIG_SMP
+	.quad	__per_cpu_load
+#else
 	.quad	_boot_cpu_pda
+#endif
 	__FINITDATA
 
 	ENTRY(stack_start)
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index bd47bbd..24d3e0d 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -14,6 +14,7 @@
 #include <asm/mpspec.h>
 #include <asm/apicdef.h>
 #include <asm/highmem.h>
+#include <asm/proto.h>
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 # define DBG(x...) printk(KERN_DEBUG x)
@@ -65,6 +66,16 @@ static void __init setup_node_to_cpumask_map(void);
 static inline void setup_node_to_cpumask_map(void) { }
 #endif
 
+#ifdef CONFIG_X86_64
+void __cpuinit load_pda_offset(int cpu)
+{
+	/* Memory clobbers used to order pda/percpu accesses */
+	mb();
+	wrmsrl(MSR_GS_BASE, cpu_pda(cpu));
+	mb();
+}
+#endif
+
 #ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 /*
  * Copy data used in early init routines from the initial arrays to the
@@ -101,42 +112,6 @@ static void __init setup_per_cpu_maps(void)
  */
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 EXPORT_SYMBOL(__per_cpu_offset);
-static inline void setup_cpu_pda_map(void) { }
-
-#elif !defined(CONFIG_SMP)
-static inline void setup_cpu_pda_map(void) { }
-
-#else /* CONFIG_SMP && CONFIG_X86_64 */
-
-/*
- * Allocate cpu_pda pointer table and array via alloc_bootmem.
- */
-static void __init setup_cpu_pda_map(void)
-{
-	char *pda;
-	unsigned long size;
-	int cpu;
-
-	size = roundup(sizeof(struct x8664_pda), cache_line_size());
-
-	/* allocate cpu_pda array and pointer table */
-	{
-		unsigned long asize = size * (nr_cpu_ids - 1);
-
-		pda = alloc_bootmem(asize);
-	}
-
-	/* initialize pointer table to static pda's */
-	for_each_possible_cpu(cpu) {
-		if (cpu == 0) {
-			/* leave boot cpu pda in place */
-			continue;
-		}
-		cpu_pda(cpu) = (struct x8664_pda *)pda;
-		cpu_pda(cpu)->in_bootmem = 1;
-		pda += size;
-	}
-}
 #endif
 
 /*
@@ -151,9 +126,6 @@ void __init setup_per_cpu_areas(void)
 	int cpu;
 	unsigned long align = 1;
 
-	/* Setup cpu_pda map */
-	setup_cpu_pda_map();
-
 	/* Copy section for each CPU (we discard the original) */
 	old_size = PERCPU_ENOUGH_ROOM;
 	align = max_t(unsigned long, PAGE_SIZE, align);
@@ -185,8 +157,21 @@ void __init setup_per_cpu_areas(void)
 					 cpu, node, __pa(ptr));
 		}
 #endif
-		per_cpu_offset(cpu) = ptr - __per_cpu_start;
+
 		memcpy(ptr, __per_cpu_load, __per_cpu_end - __per_cpu_start);
+#ifdef CONFIG_X86_64
+		cpu_pda(cpu) = (void *)ptr;
+
+		/*
+		 * CPU0 modified pda in the init data area, reload pda
+		 * offset for CPU0 and clear the area for others.
+		 */
+		if (cpu == 0)
+			load_pda_offset(0);
+		else
+			memset(cpu_pda(cpu), 0, sizeof(*cpu_pda(cpu)));
+#endif
+		per_cpu_offset(cpu) = ptr - __per_cpu_start;
 
 		DBG("PERCPU: cpu %4d %p\n", cpu, ptr);
 	}
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7cd97d9..3a0fec6 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -750,52 +750,6 @@ static void __cpuinit do_fork_idle(struct work_struct *work)
 	complete(&c_idle->done);
 }
 
-#ifdef CONFIG_X86_64
-
-/* __ref because it's safe to call free_bootmem when after_bootmem == 0. */
-static void __ref free_bootmem_pda(struct x8664_pda *oldpda)
-{
-	if (!after_bootmem)
-		free_bootmem((unsigned long)oldpda, sizeof(*oldpda));
-}
-
-/*
- * Allocate node local memory for the AP pda.
- *
- * Must be called after the _cpu_pda pointer table is initialized.
- */
-int __cpuinit get_local_pda(int cpu)
-{
-	struct x8664_pda *oldpda, *newpda;
-	unsigned long size = sizeof(struct x8664_pda);
-	int node = cpu_to_node(cpu);
-
-	if (cpu_pda(cpu) && !cpu_pda(cpu)->in_bootmem)
-		return 0;
-
-	oldpda = cpu_pda(cpu);
-	newpda = kmalloc_node(size, GFP_ATOMIC, node);
-	if (!newpda) {
-		printk(KERN_ERR "Could not allocate node local PDA "
-			"for CPU %d on node %d\n", cpu, node);
-
-		if (oldpda)
-			return 0;	/* have a usable pda */
-		else
-			return -1;
-	}
-
-	if (oldpda) {
-		memcpy(newpda, oldpda, size);
-		free_bootmem_pda(oldpda);
-	}
-
-	newpda->in_bootmem = 0;
-	cpu_pda(cpu) = newpda;
-	return 0;
-}
-#endif /* CONFIG_X86_64 */
-
 static int __cpuinit do_boot_cpu(int apicid, int cpu)
 /*
  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
@@ -813,16 +767,6 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 	};
 	INIT_WORK(&c_idle.work, do_fork_idle);
 
-#ifdef CONFIG_X86_64
-	/* Allocate node local memory for AP pdas */
-	if (cpu > 0) {
-		boot_error = get_local_pda(cpu);
-		if (boot_error)
-			goto restore_state;
-			/* if can't get pda memory, can't start cpu */
-	}
-#endif
-
 	alternatives_smp_switch(1);
 
 	c_idle.idle = get_idle_for_cpu(cpu);
@@ -937,9 +881,7 @@ do_rest:
 				inquire_remote_apic(apicid);
 		}
 	}
-#ifdef CONFIG_X86_64
-restore_state:
-#endif
+
 	if (boot_error) {
 		/* Try to put things back the way they were before ... */
 		numa_remove_cpu(cpu); /* was set by numa_add_cpu */
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index f50280d..962f21f 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -5,6 +5,7 @@
 #define LOAD_OFFSET __START_KERNEL_map
 
 #include <asm-generic/vmlinux.lds.h>
+#include <asm/asm-offsets.h>
 #include <asm/page.h>
 
 #undef i386	/* in case the preprocessor is a 32bit one */
@@ -215,10 +216,11 @@ SECTIONS
   /*
    * percpu offsets are zero-based on SMP.  PERCPU_VADDR() changes the
    * output PHDR, so the next output section - __data_nosave - should
-   * switch it back to data.init.
+   * switch it back to data.init.  Also, pda should be at the head of
+   * percpu area.  Preallocate it.
    */
   . = ALIGN(PAGE_SIZE);
-  PERCPU_VADDR(0, :percpu)
+  PERCPU_VADDR_PREALLOC(0, :percpu, pda_size)
 #else
   PERCPU(PAGE_SIZE)
 #endif
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index acd9b67..ae22284 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -280,16 +280,6 @@ static int __cpuinit xen_cpu_up(unsigned int cpu)
 	struct task_struct *idle = idle_task(cpu);
 	int rc;
 
-#ifdef CONFIG_X86_64
-	/* Allocate node local memory for AP pdas */
-	WARN_ON(cpu == 0);
-	if (cpu > 0) {
-		rc = get_local_pda(cpu);
-		if (rc)
-			return rc;
-	}
-#endif
-
 #ifdef CONFIG_X86_32
 	init_gdt(cpu);
 	per_cpu(current_task, cpu) = idle;
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index fc2f55f..e53319c 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -441,9 +441,10 @@
 	. = __per_cpu_load + SIZEOF(.data.percpu);
 
 /**
- * PERCPU_VADDR - define output section for percpu area
+ * PERCPU_VADDR_PREALLOC - define output section for percpu area with prealloc
  * @vaddr: explicit base address (optional)
  * @phdr: destination PHDR (optional)
+ * @prealloc: the size of prealloc area
  *
  * Macro which expands to output section for percpu area.  If @vaddr
  * is not blank, it specifies explicit base address and all percpu
@@ -455,11 +456,33 @@
  * section in the linker script will go there too.  @phdr should have
  * a leading colon.
  *
+ * If @prealloc is non-zero, the specified number of bytes will be
+ * reserved at the start of percpu area.  As the prealloc area is
+ * likely to break alignment, this macro puts areas in increasing
+ * alignment order.
+ *
  * This macro defines three symbols, __per_cpu_load, __per_cpu_start
  * and __per_cpu_end.  The first one is the vaddr of loaded percpu
  * init data.  __per_cpu_start equals @vaddr and __per_cpu_end is the
  * end offset.
  */
+#define PERCPU_VADDR_PREALLOC(vaddr, segment, prealloc)			\
+	PERCPU_PROLOG(vaddr)						\
+		. += prealloc;						\
+		*(.data.percpu)						\
+		*(.data.percpu.shared_aligned)				\
+		*(.data.percpu.page_aligned)				\
+	PERCPU_EPILOG(segment)
+
+/**
+ * PERCPU_VADDR - define output section for percpu area
+ * @vaddr: explicit base address (optional)
+ * @phdr: destination PHDR (optional)
+ *
+ * Macro which expands to output section for percpu area.  Mostly
+ * identical to PERCPU_VADDR_PREALLOC(@vaddr, @phdr, 0) other than
+ * using slighly different layout.
+ */
 #define PERCPU_VADDR(vaddr, phdr)					\
 	PERCPU_PROLOG(vaddr)						\
 		*(.data.percpu.page_aligned)				\
-- 
1.5.6

