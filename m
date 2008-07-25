Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbYGYVMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbYGYVMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 17:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbYGYVLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 17:11:21 -0400
Received: from relay2.sgi.com ([192.48.171.30]:42302 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755736AbYGYVLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 17:11:18 -0400
Message-Id: <20080725211117.947089000@polaris-admin.engr.sgi.com>
References: <20080725211117.586723000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Jul 2008 14:11:19 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Hugh Dickins <hugh@veritas.com>, Jack Steiner <steiner@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH 2/4] x86_64: Base percpu variables at zero
Content-Disposition: inline; filename=zero_based_only
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: There is still a FIXME in this patch (see arch/x86/kernel/acpi/sleep.c)
         [Advice on how to fix it most welcome... ;-)]

  * Make the x86_64 per cpu area start at zero.

  * Relocate the per_cpu(gdt_page) in head_64.S for the boot cpu (0).
    For secondary cpus, do_boot_cpu() sets up the correct gdt_page pointer.

  * Initialize per_cpu_offset to point to static pda in the per_cpu area
    (@ __per_cpu_load).

  * After allocation of the per cpu area for the boot cpu (0), reload the
    gdt page pointer.

Based on linux-2.6.tip/master

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/Kconfig                 |    3 ++
 arch/x86/kernel/acpi/sleep.c     |    9 ++++++++
 arch/x86/kernel/head_64.S        |   26 ++++++++++++++++++++++--
 arch/x86/kernel/setup_percpu.c   |   42 ++++++++++++++++++++++++++++++++-------
 arch/x86/kernel/vmlinux_64.lds.S |    1 
 5 files changed, 72 insertions(+), 9 deletions(-)

--- linux-2.6.tip.orig/arch/x86/Kconfig
+++ linux-2.6.tip/arch/x86/Kconfig
@@ -129,6 +129,9 @@ config HAVE_SETUP_PER_CPU_AREA
 config HAVE_CPUMASK_OF_CPU_MAP
 	def_bool X86_64_SMP
 
+config HAVE_ZERO_BASED_PER_CPU
+	def_bool X86_64_SMP
+
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
 	depends on !SMP || !X86_VOYAGER
--- linux-2.6.tip.orig/arch/x86/kernel/acpi/sleep.c
+++ linux-2.6.tip/arch/x86/kernel/acpi/sleep.c
@@ -99,6 +99,15 @@ int acpi_save_state_mem(void)
 #ifdef CONFIG_SMP
 	stack_start.sp = temp_stack + 4096;
 #endif
+	/*
+	 * FIXME: with zero-based percpu variables, the pda and gdt_page
+	 * addresses must be offset by the base of this cpu's percpu area.
+	 * Where/how should we do this?
+	 *
+	 * for secondary cpu startup in smpboot.c:do_boot_cpu() this is done:
+	 *	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
+	 *	initial_pda = (unsigned long)get_cpu_pda(cpu);
+	 */
 	initial_code = (unsigned long)wakeup_long64;
 	saved_magic = 0x123456789abcdef0;
 #endif /* CONFIG_64BIT */
--- linux-2.6.tip.orig/arch/x86/kernel/head_64.S
+++ linux-2.6.tip/arch/x86/kernel/head_64.S
@@ -12,6 +12,7 @@
 #include <linux/linkage.h>
 #include <linux/threads.h>
 #include <linux/init.h>
+#include <asm/asm-offsets.h>
 #include <asm/desc.h>
 #include <asm/segment.h>
 #include <asm/pgtable.h>
@@ -210,7 +211,27 @@ ENTRY(secondary_startup_64)
 	 * addresses where we're currently running on. We have to do that here
 	 * because in 32bit we couldn't load a 64bit linear address.
 	 */
-	lgdt	early_gdt_descr(%rip)
+
+#ifdef CONFIG_SMP
+	 /*
+	 * For zero-based percpu variables, the base (__per_cpu_load) must
+	 * be added to the offset of per_cpu__gdt_page.  This is only needed
+	 * for the boot cpu but we can't do this prior to secondary_startup_64.
+	 * So we use a NULL gdt adrs to indicate that we are starting up the
+	 * boot cpu and not the secondary cpus.  do_boot_cpu() will fixup
+	 * the gdt adrs for those cpus.
+	 */
+#define PER_CPU_GDT_PAGE	0
+	movq	early_gdt_descr_base(%rip), %rax
+	testq	%rax, %rax
+	jnz	1f
+	movq	$__per_cpu_load, %rax
+	addq	$per_cpu__gdt_page, %rax
+	movq	%rax, early_gdt_descr_base(%rip)
+#else
+#define PER_CPU_GDT_PAGE	per_cpu__gdt_page
+#endif
+1:	lgdt	early_gdt_descr(%rip)
 
 	/* set up data segments. actually 0 would do too */
 	movl $__KERNEL_DS,%eax
@@ -401,7 +422,8 @@ NEXT_PAGE(level2_spare_pgt)
 	.globl early_gdt_descr
 early_gdt_descr:
 	.word	GDT_ENTRIES*8-1
-	.quad   per_cpu__gdt_page
+early_gdt_descr_base:
+	.quad	PER_CPU_GDT_PAGE	# Overwritten for secondary CPUs
 
 ENTRY(phys_base)
 	/* This must match the first entry in level2_kernel_pgt */
--- linux-2.6.tip.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6.tip/arch/x86/kernel/setup_percpu.c
@@ -14,6 +14,7 @@
 #include <asm/mpspec.h>
 #include <asm/apicdef.h>
 #include <asm/highmem.h>
+#include <asm/desc.h>
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 # define DBG(x...) printk(KERN_DEBUG x)
@@ -119,16 +120,21 @@ static void __init setup_cpumask_of_cpu(
 static inline void setup_cpumask_of_cpu(void) { }
 #endif
 
-#ifdef CONFIG_X86_32
 /*
- * Great future not-so-futuristic plan: make i386 and x86_64 do it
- * the same way
+ * Pointers to per cpu areas for each cpu
  */
+#ifdef CONFIG_HAVE_ZERO_BASED_PER_CPU
+
+/* Initialize percpu offset for boot cpu (0) */
+unsigned long __per_cpu_offset[NR_CPUS] __read_mostly = {
+	[0] = (unsigned long)__per_cpu_load
+};
+#else
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
+#endif
 EXPORT_SYMBOL(__per_cpu_offset);
-static inline void setup_cpu_pda_map(void) { }
 
-#elif !defined(CONFIG_SMP)
+#if !defined(CONFIG_SMP) || !defined(CONFIG_X86_64)
 static inline void setup_cpu_pda_map(void) { }
 
 #else /* CONFIG_SMP && CONFIG_X86_64 */
@@ -160,8 +166,10 @@ static void __init setup_cpu_pda_map(voi
 		if (cpu == 0) {
 			/* leave boot cpu pda in place */
 			new_cpu_pda[0] = cpu_pda(0);
+			DBG("cpu %4d pda %p\n", cpu, cpu_pda(0));
 			continue;
 		}
+		DBG("cpu %4d pda %p\n", cpu, pda);
 		new_cpu_pda[cpu] = (struct x8664_pda *)pda;
 		new_cpu_pda[cpu]->in_bootmem = 1;
 		pda += size;
@@ -191,6 +199,8 @@ void __init setup_per_cpu_areas(void)
 	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
 			  size);
 
+	DBG("PERCPU: __per_cpu_start %p\n", __per_cpu_start);
+
 	for_each_possible_cpu(cpu) {
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 		ptr = alloc_bootmem_pages(size);
@@ -205,10 +215,28 @@ void __init setup_per_cpu_areas(void)
 		else
 			ptr = alloc_bootmem_pages_node(NODE_DATA(node), size);
 #endif
+		DBG("PERCPU: cpu %4d %p pda %p %p\n",
+			     cpu, ptr, _cpu_pda[cpu], cpu_pda(cpu));
+
+		/* Initialize each cpu's per_cpu area and save pointer */
+		memcpy(ptr, __per_cpu_load, __per_cpu_size);
 		per_cpu_offset(cpu) = ptr - __per_cpu_start;
-		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
 
-		DBG("PERCPU: cpu %4d %p\n", cpu, ptr);
+#ifdef CONFIG_X86_64
+		/* save for __my_cpu_offset() */
+		cpu_pda(cpu)->data_offset = (unsigned long)ptr;
+
+		/*
+		 * The boot cpu gdt page must be reloaded as we moved it
+		 * from the static per cpu area to the newly allocated area.
+		 */
+		if (cpu == 0) {
+			struct desc_ptr	gdt_descr = early_gdt_descr;
+
+			gdt_descr.address = (unsigned long)get_cpu_gdt_table(0);
+			native_load_gdt(&gdt_descr);
+		}
+#endif
 	}
 
 	printk(KERN_INFO "NR_CPUS: %d, nr_cpu_ids: %d, nr_node_ids: %d\n",
--- linux-2.6.tip.orig/arch/x86/kernel/vmlinux_64.lds.S
+++ linux-2.6.tip/arch/x86/kernel/vmlinux_64.lds.S
@@ -16,6 +16,7 @@ jiffies_64 = jiffies;
 _proxy_pda = 1;
 PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
+	percpu PT_LOAD FLAGS(7);	/* RWE */
 	data PT_LOAD FLAGS(7);	/* RWE */
 	user PT_LOAD FLAGS(7);	/* RWE */
 	data.init PT_LOAD FLAGS(7);	/* RWE */

-- 
