Return-Path: <linux-kernel-owner+w=401wt.eu-S1759193AbXKTBYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193AbXKTBYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756673AbXKTBOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:14:10 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36895 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756104AbXKTBNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:40 -0500
Message-Id: <20071120011339.867853374@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:12:06 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 34/45] x86_64: Fold percpu area into the cpu area.
Content-Disposition: inline; filename=x86_64_fold_percpu_into_cpu_area
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use boot_cpu_alloc to allocate a cpu area chunk that is needed to store the
statically declared per cpu data and then point the per_cpu_offset pointers
to the cpu area.

The per cpu area is moved to a ZERO offset using some linker scripting.
All per cpu variable addresses become true offsets into a cpu area to their
respective variable. The addresses of per cpu variables can be treated
like the offsets that are returned by CPU_ALLOC.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/kernel/setup64.c         |   29 ++++++++++++-----------------
 arch/x86/kernel/vmlinux_64.lds.S  |    3 ++-
 include/asm-generic/sections.h    |    1 +
 include/asm-generic/vmlinux.lds.h |   17 +++++++++++++++++
 4 files changed, 32 insertions(+), 18 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup64.c	2007-11-18 22:39:24.706247819 -0800
+++ linux-2.6/arch/x86/kernel/setup64.c	2007-11-19 10:31:49.088824106 -0800
@@ -87,35 +87,30 @@ __setup("noexec32=", nonx32_setup);
 void __init setup_per_cpu_areas(void)
 { 
 	int i;
-	unsigned long size;
+	char *base;
 
 #ifdef CONFIG_HOTPLUG_CPU
 	prefill_possible_map();
 #endif
 
 	/* Copy section for each CPU (we discard the original) */
-	size = PERCPU_ENOUGH_ROOM;
+	base = boot_cpu_alloc(PERCPU_ENOUGH_ROOM);
+	if (base)
+		panic("Cannot allocate per cpu data at 0\n");
 
-	printk(KERN_INFO "PERCPU: Allocating %lu bytes of per cpu data\n", size);
+	printk(KERN_INFO "PERCPU: Allocating %lu bytes of per cpu data\n",
+					PERCPU_ENOUGH_ROOM);
 	for_each_cpu_mask (i, cpu_possible_map) {
-		char *ptr;
+		cpu_pda(i)->data_offset = cpu_offset(i);
 
-		if (!NODE_DATA(cpu_to_node(i))) {
-			printk("cpu with no node %d, num_online_nodes %d\n",
-			       i, num_online_nodes());
-			ptr = alloc_bootmem_pages(size);
-		} else { 
-			ptr = alloc_bootmem_pages_node(NODE_DATA(cpu_to_node(i)), size);
-		}
-		if (!ptr)
-			panic("Cannot allocate cpu data for CPU %d\n", i);
-		cpu_pda(i)->data_offset = ptr - __per_cpu_start;
-		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
+		memcpy(CPU_PTR(base, i), __load_per_cpu_start,
+				__per_cpu_end - __per_cpu_start);
 	}
-} 
+	count_vm_events(CPU_BYTES, PERCPU_ENOUGH_ROOM);
+}
 
 void pda_init(int cpu)
-{ 
+{
 	struct x8664_pda *pda = cpu_pda(cpu);
 
 	/* Setup up data that may be needed in __get_free_pages early */
Index: linux-2.6/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6.orig/include/asm-generic/vmlinux.lds.h	2007-11-18 22:39:23.370497641 -0800
+++ linux-2.6/include/asm-generic/vmlinux.lds.h	2007-11-19 10:30:20.095586336 -0800
@@ -258,8 +258,25 @@
 #define PERCPU(align)							\
 	. = ALIGN(align);						\
 	__per_cpu_start = .;						\
+	__load_per_cpu_start = .;					\
 	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {		\
 		*(.data.percpu)						\
 		*(.data.percpu.shared_aligned)				\
 	}								\
+	 __load_per_cpu_end = .;					\
 	__per_cpu_end = .;
+
+#define ZERO_BASED_PERCPU						\
+	percpu : { } :percpu						\
+	__load_per_cpu_start = .;					\
+	.data.percpu 0 : AT(__load_per_cpu_start - LOAD_OFFSET) {	\
+		__per_cpu_start = .;					\
+		*(.data.percpu)						\
+		*(.data.percpu.shared_aligned)				\
+		__per_cpu_end = .;					\
+	}								\
+	. = __load_per_cpu_start + __per_cpu_end - __per_cpu_start;	\
+	__load_per_cpu_end = .;						\
+	data : { } :data
+
+
Index: linux-2.6/arch/x86/kernel/vmlinux_64.lds.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmlinux_64.lds.S	2007-11-18 22:41:39.261997209 -0800
+++ linux-2.6/arch/x86/kernel/vmlinux_64.lds.S	2007-11-18 22:42:33.119247430 -0800
@@ -19,6 +19,7 @@ cpu_area = CPU_AREA_BASE;
 
 PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
+	percpu PT_LOAD FLAGS(4); /* R__ */
 	data PT_LOAD FLAGS(7);	/* RWE */
 	user PT_LOAD FLAGS(7);	/* RWE */
 	data.init PT_LOAD FLAGS(7);	/* RWE */
@@ -206,7 +207,7 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-  PERCPU(4096)
+  ZERO_BASED_PERCPU
 
   . = ALIGN(4096);
   __init_end = .;
Index: linux-2.6/include/asm-generic/sections.h
===================================================================
--- linux-2.6.orig/include/asm-generic/sections.h	2007-11-18 22:39:23.374497627 -0800
+++ linux-2.6/include/asm-generic/sections.h	2007-11-18 22:45:33.073997351 -0800
@@ -12,6 +12,7 @@ extern char _sextratext[] __attribute__(
 extern char _eextratext[] __attribute__((weak));
 extern char _end[];
 extern char __per_cpu_start[], __per_cpu_end[];
+extern char __load_per_cpu_start[], __load_per_cpu_end[];
 extern char __kprobes_text_start[], __kprobes_text_end[];
 extern char __initdata_begin[], __initdata_end[];
 extern char __start_rodata[], __end_rodata[];

-- 
