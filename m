Return-Path: <linux-kernel-owner+w=401wt.eu-S1760174AbYFIOUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174AbYFIOUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759152AbYFIOSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:18:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758808AbYFIOSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:18:33 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
Subject: [PATCH 04/15] x86: move x86_64 gdt closer to i386
Date: Mon,  9 Jun 2008 11:16:47 -0300
Message-Id: <1213021018-14159-5-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1213021018-14159-4-git-send-email-gcosta@redhat.com>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
 <1213021018-14159-2-git-send-email-gcosta@redhat.com>
 <1213021018-14159-3-git-send-email-gcosta@redhat.com>
 <1213021018-14159-4-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i386 and x86_64 used two different schemes for maintaining the gdt.
With this patch, x86_64 initial gdt table is defined in a .c file,
same way as i386 is now. Also, we call it "gdt_page", and the descriptor,
"early_gdt_descr". This way we achieve common naming, which can allow for
more code integration.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/head_64.S        |   48 ++++----------------------------------
 arch/x86/kernel/setup64.c        |    5 +---
 arch/x86/kernel/setup_64.c       |   27 +++++++++++++++++++++
 arch/x86/kernel/smpboot.c        |   10 +------
 arch/x86/kernel/x8664_ksyms_64.c |    5 ----
 include/asm-x86/desc.h           |   24 ++++++++-----------
 include/asm-x86/segment.h        |   23 +++++++++--------
 7 files changed, 57 insertions(+), 85 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 4949c32..febeabb 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -203,7 +203,7 @@ ENTRY(secondary_startup_64)
 	 * addresses where we're currently running on. We have to do that here
 	 * because in 32bit we couldn't load a 64bit linear address.
 	 */
-	lgdt	cpu_gdt_descr(%rip)
+	lgdt	early_gdt_descr(%rip)
 
 	/* set up data segments. actually 0 would do too */
 	movl $__KERNEL_DS,%eax
@@ -391,54 +391,16 @@ NEXT_PAGE(level2_spare_pgt)
 
 	.data
 	.align 16
-	.globl cpu_gdt_descr
-cpu_gdt_descr:
-	.word	gdt_end-cpu_gdt_table-1
-gdt:
-	.quad	cpu_gdt_table
-#ifdef CONFIG_SMP
-	.rept	NR_CPUS-1
-	.word	0
-	.quad	0
-	.endr
-#endif
+	.globl early_gdt_descr
+early_gdt_descr:
+	.word	GDT_ENTRIES*8-1
+	.quad   per_cpu__gdt_page
 
 ENTRY(phys_base)
 	/* This must match the first entry in level2_kernel_pgt */
 	.quad   0x0000000000000000
 
-/* We need valid kernel segments for data and code in long mode too
- * IRET will check the segment types  kkeil 2000/10/28
- * Also sysret mandates a special GDT layout 
- */
-		 		
-	.section .data.page_aligned, "aw"
-	.align PAGE_SIZE
-
-/* The TLS descriptors are currently at a different place compared to i386.
-   Hopefully nobody expects them at a fixed place (Wine?) */
 	
-ENTRY(cpu_gdt_table)
-	.quad	0x0000000000000000	/* NULL descriptor */
-	.quad	0x00cf9b000000ffff	/* __KERNEL32_CS */
-	.quad	0x00af9b000000ffff	/* __KERNEL_CS */
-	.quad	0x00cf93000000ffff	/* __KERNEL_DS */
-	.quad	0x00cffb000000ffff	/* __USER32_CS */
-	.quad	0x00cff3000000ffff	/* __USER_DS, __USER32_DS  */
-	.quad	0x00affb000000ffff	/* __USER_CS */
-	.quad	0x0			/* unused */
-	.quad	0,0			/* TSS */
-	.quad	0,0			/* LDT */
-	.quad   0,0,0			/* three TLS descriptors */ 
-	.quad	0x0000f40000000000	/* node/CPU stored in limit */
-gdt_end:	
-	/* asm/segment.h:GDT_ENTRIES must match this */	
-	/* This should be a multiple of the cache line size */
-	/* GDTs of other CPUs are now dynamically allocated */
-
-	/* zero the remaining page */
-	.fill PAGE_SIZE / 8 - GDT_ENTRIES,8,0
-
 	.section .bss, "aw", @nobits
 	.align L1_CACHE_BYTES
 ENTRY(idt_table)
diff --git a/arch/x86/kernel/setup64.c b/arch/x86/kernel/setup64.c
index fc1a56d..70ff071 100644
--- a/arch/x86/kernel/setup64.c
+++ b/arch/x86/kernel/setup64.c
@@ -202,11 +202,8 @@ void __cpuinit cpu_init (void)
 	 * Initialize the per-CPU GDT with the boot GDT,
 	 * and set up the GDT descriptor:
 	 */
-	if (cpu)
-		memcpy(get_cpu_gdt_table(cpu), cpu_gdt_table, GDT_SIZE);
 
-	cpu_gdt_descr[cpu].size = GDT_SIZE;
-	load_gdt((const struct desc_ptr *)&cpu_gdt_descr[cpu]);
+	switch_to_new_gdt();
 	load_idt((const struct desc_ptr *)&idt_descr);
 
 	memset(me->thread.tls_array, 0, GDT_ENTRY_TLS_ENTRIES * 8);
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 2aee441..c57223f 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -83,6 +83,22 @@
 #define ARCH_SETUP
 #endif
 
+/* We need valid kernel segments for data and code in long mode too
+ * IRET will check the segment types  kkeil 2000/10/28
+ * Also sysret mandates a special GDT layout
+ */
+/* The TLS descriptors are currently at a different place compared to i386.
+   Hopefully nobody expects them at a fixed place (Wine?) */
+DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
+	[GDT_ENTRY_KERNEL32_CS] = { { { 0x0000ffff, 0x00cf9b00 } } },
+	[GDT_ENTRY_KERNEL_CS] = { { { 0x0000ffff, 0x00af9b00 } } },
+	[GDT_ENTRY_KERNEL_DS] = { { { 0x0000ffff, 0x00cf9300 } } },
+	[GDT_ENTRY_DEFAULT_USER32_CS] = { { { 0x0000ffff, 0x00cffb00 } } },
+	[GDT_ENTRY_DEFAULT_USER_DS] = { { { 0x0000ffff, 0x00cff300 } } },
+	[GDT_ENTRY_DEFAULT_USER_CS] = { { { 0x0000ffff, 0x00affb00 } } },
+} };
+EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
+
 /*
  * Machine setup..
  */
@@ -273,6 +289,17 @@ void __attribute__((weak)) __init memory_setup(void)
        machine_specific_memory_setup();
 }
 
+/* Current gdt points %fs at the "master" per-cpu area: after this,
+ * it's on the real one. */
+void switch_to_new_gdt(void)
+{
+	struct desc_ptr gdt_descr;
+
+	gdt_descr.address = (long)get_cpu_gdt_table(smp_processor_id());
+	gdt_descr.size = GDT_SIZE - 1;
+	load_gdt(&gdt_descr);
+}
+
 /*
  * setup_arch - architecture-specific boot-time initializations
  *
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 181b109..69639fd 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -849,14 +849,8 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 		.done = COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
 	};
 	INIT_WORK(&c_idle.work, do_fork_idle);
-#ifdef CONFIG_X86_64
-	/* allocate memory for gdts of secondary cpus. Hotplug is considered */
-	if (!cpu_gdt_descr[cpu].address &&
-		!(cpu_gdt_descr[cpu].address = get_zeroed_page(GFP_KERNEL))) {
-		printk(KERN_ERR "Failed to allocate GDT for CPU %d\n", cpu);
-		return -1;
-	}
 
+#ifdef CONFIG_X86_64
 	/* Allocate node local memory for AP pdas */
 	if (cpu > 0) {
 		boot_error = get_local_pda(cpu);
@@ -1253,8 +1247,8 @@ void __init native_smp_prepare_boot_cpu(void)
 	int me = smp_processor_id();
 #ifdef CONFIG_X86_32
 	init_gdt(me);
-	switch_to_new_gdt();
 #endif
+	switch_to_new_gdt();
 	/* already set me in cpu_online_map in boot_cpu_init() */
 	cpu_set(me, cpu_callout_map);
 	per_cpu(cpu_state, me) = CPU_ONLINE;
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index 122885b..16a6751 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -60,8 +60,3 @@ EXPORT_SYMBOL(init_level4_pgt);
 EXPORT_SYMBOL(load_gs_index);
 
 EXPORT_SYMBOL(_proxy_pda);
-
-#ifdef CONFIG_PARAVIRT
-/* Virtualized guests may want to use it */
-EXPORT_SYMBOL_GPL(cpu_gdt_descr);
-#endif
diff --git a/include/asm-x86/desc.h b/include/asm-x86/desc.h
index b3875d4..07f9f2b 100644
--- a/include/asm-x86/desc.h
+++ b/include/asm-x86/desc.h
@@ -29,11 +29,17 @@ static inline void fill_ldt(struct desc_struct *desc,
 extern struct desc_ptr idt_descr;
 extern gate_desc idt_table[];
 
+struct gdt_page {
+	struct desc_struct gdt[GDT_ENTRIES];
+} __attribute__((aligned(PAGE_SIZE)));
+DECLARE_PER_CPU(struct gdt_page, gdt_page);
+
+static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
+{
+	return per_cpu(gdt_page, cpu).gdt;
+}
+
 #ifdef CONFIG_X86_64
-extern struct desc_struct cpu_gdt_table[GDT_ENTRIES];
-extern struct desc_ptr cpu_gdt_descr[];
-/* the cpu gdt accessor */
-#define get_cpu_gdt_table(x) ((struct desc_struct *)cpu_gdt_descr[x].address)
 
 static inline void pack_gate(gate_desc *gate, unsigned type, unsigned long func,
 			     unsigned dpl, unsigned ist, unsigned seg)
@@ -51,16 +57,6 @@ static inline void pack_gate(gate_desc *gate, unsigned type, unsigned long func,
 }
 
 #else
-struct gdt_page {
-	struct desc_struct gdt[GDT_ENTRIES];
-} __attribute__((aligned(PAGE_SIZE)));
-DECLARE_PER_CPU(struct gdt_page, gdt_page);
-
-static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
-{
-	return per_cpu(gdt_page, cpu).gdt;
-}
-
 static inline void pack_gate(gate_desc *gate, unsigned char type,
 			     unsigned long base, unsigned dpl, unsigned flags,
 			     unsigned short seg)
diff --git a/include/asm-x86/segment.h b/include/asm-x86/segment.h
index ed5131d..dfc8601 100644
--- a/include/asm-x86/segment.h
+++ b/include/asm-x86/segment.h
@@ -61,18 +61,14 @@
 #define GDT_ENTRY_TLS_MAX 	(GDT_ENTRY_TLS_MIN + GDT_ENTRY_TLS_ENTRIES - 1)
 
 #define GDT_ENTRY_DEFAULT_USER_CS	14
-#define __USER_CS (GDT_ENTRY_DEFAULT_USER_CS * 8 + 3)
 
 #define GDT_ENTRY_DEFAULT_USER_DS	15
-#define __USER_DS (GDT_ENTRY_DEFAULT_USER_DS * 8 + 3)
 
 #define GDT_ENTRY_KERNEL_BASE	12
 
 #define GDT_ENTRY_KERNEL_CS		(GDT_ENTRY_KERNEL_BASE + 0)
-#define __KERNEL_CS (GDT_ENTRY_KERNEL_CS * 8)
 
 #define GDT_ENTRY_KERNEL_DS		(GDT_ENTRY_KERNEL_BASE + 1)
-#define __KERNEL_DS (GDT_ENTRY_KERNEL_DS * 8)
 
 #define GDT_ENTRY_TSS			(GDT_ENTRY_KERNEL_BASE + 4)
 #define GDT_ENTRY_LDT			(GDT_ENTRY_KERNEL_BASE + 5)
@@ -139,10 +135,11 @@
 #else
 #include <asm/cache.h>
 
-#define __KERNEL_CS	0x10
-#define __KERNEL_DS	0x18
+#define GDT_ENTRY_KERNEL32_CS 1
+#define GDT_ENTRY_KERNEL_CS 2
+#define GDT_ENTRY_KERNEL_DS 3
 
-#define __KERNEL32_CS   0x08
+#define __KERNEL32_CS   (GDT_ENTRY_KERNEL32_CS * 8)
 
 /*
  * we cannot use the same code segment descriptor for user and kernel
@@ -150,10 +147,10 @@
  * The segment offset needs to contain a RPL. Grr. -AK
  * GDT layout to get 64bit syscall right (sysret hardcodes gdt offsets)
  */
-
-#define __USER32_CS   0x23   /* 4*8+3 */
-#define __USER_DS     0x2b   /* 5*8+3 */
-#define __USER_CS     0x33   /* 6*8+3 */
+#define GDT_ENTRY_DEFAULT_USER32_CS 4
+#define GDT_ENTRY_DEFAULT_USER_DS 5
+#define GDT_ENTRY_DEFAULT_USER_CS 6
+#define __USER32_CS   (GDT_ENTRY_DEFAULT_USER32_CS * 8 + 3)
 #define __USER32_DS	__USER_DS
 
 #define GDT_ENTRY_TSS 8	/* needs two entries */
@@ -175,6 +172,10 @@
 
 #endif
 
+#define __KERNEL_CS	(GDT_ENTRY_KERNEL_CS * 8)
+#define __KERNEL_DS	(GDT_ENTRY_KERNEL_DS * 8)
+#define __USER_DS     (GDT_ENTRY_DEFAULT_USER_DS* 8 + 3)
+#define __USER_CS     (GDT_ENTRY_DEFAULT_USER_CS* 8 + 3)
 #ifndef CONFIG_PARAVIRT
 #define get_kernel_rpl()  0
 #endif
-- 
1.5.4.5

