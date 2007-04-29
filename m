Return-Path: <linux-kernel-owner+w=401wt.eu-S1161595AbXD2XvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161595AbXD2XvA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161608AbXD2Xqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:46:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38485 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161605AbXD2Xqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:46:31 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430146.588463000@suse.de>
In-Reply-To: <20070430146.588463000@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [20/26] x86: Allow percpu variables to be page-aligned
Message-Id: <20070429234630.0DF42151C5@wotan.suse.de>
Date: Mon, 30 Apr 2007 01:46:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
Let's allow page-alignment in general for per-cpu data (wanted by Xen, and
Ingo suggested KVM as well).

Because larger alignments can use more room, we increase the max per-cpu
memory to 64k rather than 32k: it's getting a little tight.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 arch/alpha/kernel/vmlinux.lds.S   |    2 +-
 arch/arm/kernel/vmlinux.lds.S     |    2 +-
 arch/cris/arch-v32/vmlinux.lds.S  |    1 +
 arch/frv/kernel/vmlinux.lds.S     |    1 +
 arch/i386/kernel/vmlinux.lds.S    |    2 +-
 arch/m32r/kernel/vmlinux.lds.S    |    2 +-
 arch/mips/kernel/vmlinux.lds.S    |    2 +-
 arch/parisc/kernel/vmlinux.lds.S  |    2 +-
 arch/powerpc/kernel/setup_64.c    |    4 ++--
 arch/powerpc/kernel/vmlinux.lds.S |    6 +-----
 arch/ppc/kernel/vmlinux.lds.S     |    2 +-
 arch/s390/kernel/vmlinux.lds.S    |    2 +-
 arch/sh/kernel/vmlinux.lds.S      |    2 +-
 arch/sh64/kernel/vmlinux.lds.S    |    2 +-
 arch/sparc/kernel/vmlinux.lds.S   |    2 +-
 arch/sparc64/kernel/smp.c         |    6 +++---
 arch/x86_64/kernel/setup64.c      |    4 ++--
 arch/x86_64/kernel/vmlinux.lds.S  |    2 +-
 arch/xtensa/kernel/vmlinux.lds.S  |    2 +-
 init/main.c                       |    8 ++------
 kernel/module.c                   |    8 ++++----
 21 files changed, 29 insertions(+), 35 deletions(-)

===================================================================
Index: linux/arch/alpha/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/alpha/kernel/vmlinux.lds.S
+++ linux/arch/alpha/kernel/vmlinux.lds.S
@@ -69,7 +69,7 @@ SECTIONS
   . = ALIGN(8);
   SECURITY_INIT
 
-  . = ALIGN(64);
+  . = ALIGN(8192);
   __per_cpu_start = .;
   .data.percpu : { *(.data.percpu) }
   __per_cpu_end = .;
Index: linux/arch/arm/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/arm/kernel/vmlinux.lds.S
+++ linux/arch/arm/kernel/vmlinux.lds.S
@@ -59,7 +59,7 @@ SECTIONS
 			usr/built-in.o(.init.ramfs)
 		__initramfs_end = .;
 #endif
-		. = ALIGN(64);
+		. = ALIGN(4096);
 		__per_cpu_start = .;
 			*(.data.percpu)
 		__per_cpu_end = .;
Index: linux/arch/cris/arch-v32/vmlinux.lds.S
===================================================================
--- linux.orig/arch/cris/arch-v32/vmlinux.lds.S
+++ linux/arch/cris/arch-v32/vmlinux.lds.S
@@ -91,6 +91,7 @@ SECTIONS
 	}
 	SECURITY_INIT
 
+	. =  ALIGN (8192);
 	__per_cpu_start = .;
 	.data.percpu  : { *(.data.percpu) }
 	__per_cpu_end = .;
Index: linux/arch/frv/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/frv/kernel/vmlinux.lds.S
+++ linux/arch/frv/kernel/vmlinux.lds.S
@@ -57,6 +57,7 @@ SECTIONS
   __alt_instructions_end = .;
  .altinstr_replacement : { *(.altinstr_replacement) }
 
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
Index: linux/arch/i386/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/i386/kernel/vmlinux.lds.S
+++ linux/arch/i386/kernel/vmlinux.lds.S
@@ -194,7 +194,7 @@ SECTIONS
 	__initramfs_end = .;
   }
 #endif
-  . = ALIGN(L1_CACHE_BYTES);
+  . = ALIGN(4096);
   .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
 	__per_cpu_start = .;
 	*(.data.percpu)
Index: linux/arch/m32r/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/m32r/kernel/vmlinux.lds.S
+++ linux/arch/m32r/kernel/vmlinux.lds.S
@@ -110,7 +110,7 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-  . = ALIGN(32);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
Index: linux/arch/mips/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/mips/kernel/vmlinux.lds.S
+++ linux/arch/mips/kernel/vmlinux.lds.S
@@ -119,7 +119,7 @@ SECTIONS
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
 #endif
-  . = ALIGN(32);
+  . = ALIGN(_PAGE_SIZE);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
Index: linux/arch/parisc/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/parisc/kernel/vmlinux.lds.S
+++ linux/arch/parisc/kernel/vmlinux.lds.S
@@ -181,7 +181,7 @@ SECTIONS
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
 #endif
-  . = ALIGN(32);
+  . = ALIGN(ASM_PAGE_SIZE);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
Index: linux/arch/powerpc/kernel/setup_64.c
===================================================================
--- linux.orig/arch/powerpc/kernel/setup_64.c
+++ linux/arch/powerpc/kernel/setup_64.c
@@ -583,14 +583,14 @@ void __init setup_per_cpu_areas(void)
 	char *ptr;
 
 	/* Copy section for each CPU (we discard the original) */
-	size = ALIGN(__per_cpu_end - __per_cpu_start, SMP_CACHE_BYTES);
+	size = ALIGN(__per_cpu_end - __per_cpu_start, PAGE_SIZE);
 #ifdef CONFIG_MODULES
 	if (size < PERCPU_ENOUGH_ROOM)
 		size = PERCPU_ENOUGH_ROOM;
 #endif
 
 	for_each_possible_cpu(i) {
-		ptr = alloc_bootmem_node(NODE_DATA(cpu_to_node(i)), size);
+		ptr = alloc_bootmem_pages_node(NODE_DATA(cpu_to_node(i)), size);
 		if (!ptr)
 			panic("Cannot allocate cpu data for CPU %d\n", i);
 
Index: linux/arch/powerpc/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/powerpc/kernel/vmlinux.lds.S
+++ linux/arch/powerpc/kernel/vmlinux.lds.S
@@ -139,11 +139,7 @@ SECTIONS
 		__initramfs_end = .;
 	}
 #endif
-#ifdef CONFIG_PPC32
-	. = ALIGN(32);
-#else
-	. = ALIGN(128);
-#endif
+	. = ALIGN(PAGE_SIZE);
 	.data.percpu : {
 		__per_cpu_start = .;
 		*(.data.percpu)
Index: linux/arch/ppc/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/ppc/kernel/vmlinux.lds.S
+++ linux/arch/ppc/kernel/vmlinux.lds.S
@@ -130,7 +130,7 @@ SECTIONS
   __ftr_fixup : { *(__ftr_fixup) }
   __stop___ftr_fixup = .;
 
-  . = ALIGN(32);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
Index: linux/arch/s390/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/s390/kernel/vmlinux.lds.S
+++ linux/arch/s390/kernel/vmlinux.lds.S
@@ -107,7 +107,7 @@ SECTIONS
   . = ALIGN(2);
   __initramfs_end = .;
 #endif
-  . = ALIGN(256);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
Index: linux/arch/sh/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/sh/kernel/vmlinux.lds.S
+++ linux/arch/sh/kernel/vmlinux.lds.S
@@ -54,7 +54,7 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   .data.page_aligned : { *(.data.page_aligned) }
 
-  . = ALIGN(L1_CACHE_BYTES);
+  . = ALIGN(PAGE_SIZE);
   __per_cpu_start = .;
   .data.percpu : { *(.data.percpu) }
   __per_cpu_end = .;
Index: linux/arch/sh64/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/sh64/kernel/vmlinux.lds.S
+++ linux/arch/sh64/kernel/vmlinux.lds.S
@@ -85,7 +85,7 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   .data.page_aligned : C_PHYS(.data.page_aligned) { *(.data.page_aligned) }
 
-  . = ALIGN(L1_CACHE_BYTES);
+  . = ALIGN(PAGE_SIZE);
   __per_cpu_start = .;
   .data.percpu : C_PHYS(.data.percpu) { *(.data.percpu) }
   __per_cpu_end = . ;
Index: linux/arch/sparc/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/sparc/kernel/vmlinux.lds.S
+++ linux/arch/sparc/kernel/vmlinux.lds.S
@@ -65,7 +65,7 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-  . = ALIGN(32);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
Index: linux/arch/sparc64/kernel/smp.c
===================================================================
--- linux.orig/arch/sparc64/kernel/smp.c
+++ linux/arch/sparc64/kernel/smp.c
@@ -1343,11 +1343,11 @@ void __init setup_per_cpu_areas(void)
 	/* Copy section for each CPU (we discard the original) */
 	goal = PERCPU_ENOUGH_ROOM;
 
-	__per_cpu_shift = 0;
-	for (size = 1UL; size < goal; size <<= 1UL)
+	__per_cpu_shift = PAGE_SHIFT;
+	for (size = PAGE_SIZE; size < goal; size <<= 1UL)
 		__per_cpu_shift++;
 
-	ptr = alloc_bootmem(size * NR_CPUS);
+	ptr = alloc_bootmem_pages(size * NR_CPUS);
 
 	__per_cpu_base = ptr - __per_cpu_start;
 
Index: linux/arch/x86_64/kernel/setup64.c
===================================================================
--- linux.orig/arch/x86_64/kernel/setup64.c
+++ linux/arch/x86_64/kernel/setup64.c
@@ -103,9 +103,9 @@ void __init setup_per_cpu_areas(void)
 		if (!NODE_DATA(cpu_to_node(i))) {
 			printk("cpu with no node %d, num_online_nodes %d\n",
 			       i, num_online_nodes());
-			ptr = alloc_bootmem(size);
+			ptr = alloc_bootmem_pages(size);
 		} else { 
-			ptr = alloc_bootmem_node(NODE_DATA(cpu_to_node(i)), size);
+			ptr = alloc_bootmem_pages_node(NODE_DATA(cpu_to_node(i)), size);
 		}
 		if (!ptr)
 			panic("Cannot allocate cpu data for CPU %d\n", i);
Index: linux/arch/x86_64/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/x86_64/kernel/vmlinux.lds.S
+++ linux/arch/x86_64/kernel/vmlinux.lds.S
@@ -195,7 +195,7 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-    . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) { *(.data.percpu) }
   __per_cpu_end = .;
Index: linux/arch/xtensa/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/xtensa/kernel/vmlinux.lds.S
+++ linux/arch/xtensa/kernel/vmlinux.lds.S
@@ -198,7 +198,7 @@ SECTIONS
   __ftr_fixup : { *(__ftr_fixup) }
   __stop___ftr_fixup = .;
 
-  . = ALIGN(32);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
Index: linux/init/main.c
===================================================================
--- linux.orig/init/main.c
+++ linux/init/main.c
@@ -369,12 +369,8 @@ static void __init setup_per_cpu_areas(v
 	unsigned long nr_possible_cpus = num_possible_cpus();
 
 	/* Copy section for each CPU (we discard the original) */
-	size = ALIGN(__per_cpu_end - __per_cpu_start, SMP_CACHE_BYTES);
-#ifdef CONFIG_MODULES
-	if (size < PERCPU_ENOUGH_ROOM)
-		size = PERCPU_ENOUGH_ROOM;
-#endif
-	ptr = alloc_bootmem(size * nr_possible_cpus);
+	size = ALIGN(PERCPU_ENOUGH_ROOM, PAGE_SIZE);
+	ptr = alloc_bootmem_pages(size * nr_possible_cpus);
 
 	for_each_possible_cpu(i) {
 		__per_cpu_offset[i] = ptr - __per_cpu_start;
Index: linux/kernel/module.c
===================================================================
--- linux.orig/kernel/module.c
+++ linux/kernel/module.c
@@ -346,10 +346,10 @@ static void *percpu_modalloc(unsigned lo
 	unsigned int i;
 	void *ptr;
 
-	if (align > SMP_CACHE_BYTES) {
-		printk(KERN_WARNING "%s: per-cpu alignment %li > %i\n",
-		       name, align, SMP_CACHE_BYTES);
-		align = SMP_CACHE_BYTES;
+	if (align > PAGE_SIZE) {
+		printk(KERN_WARNING "%s: per-cpu alignment %li > %li\n",
+		       name, align, PAGE_SIZE);
+		align = PAGE_SIZE;
 	}
 
 	ptr = __per_cpu_start;
