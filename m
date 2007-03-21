Return-Path: <linux-kernel-owner+w=401wt.eu-S932081AbXCUGKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbXCUGKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 02:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932178AbXCUGKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 02:10:47 -0400
Received: from ozlabs.org ([203.10.76.45]:54540 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081AbXCUGKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 02:10:45 -0400
Subject: [PATCH] Allow per-cpu variables to be page-aligned
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 17:10:26 +1100
Message-Id: <1174457426.11680.132.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[This was part of the GDT cleanups and per-cpu-> pda changes, which I
have revised, but this stands on its own.  The only change is catching
the x86-64 per-cpu allocator too].
==
Let's allow page-alignment in general for per-cpu data (wanted by Xen,
and Ingo suggested KVM as well).

Because larger alignments can use more room, we increase the max
per-cpu memory to 64k rather than 32k: it's getting a little tight.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Ingo Molnar <mingo@elte.hu>
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
 include/linux/percpu.h            |    2 +-
 init/main.c                       |    4 ++--
 kernel/module.c                   |   10 +++++-----
 22 files changed, 31 insertions(+), 33 deletions(-)

===================================================================
--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -69,7 +69,7 @@ SECTIONS
   . = ALIGN(8);
   SECURITY_INIT
 
-  . = ALIGN(64);
+  . = ALIGN(8192);
   __per_cpu_start = .;
   .data.percpu : { *(.data.percpu) }
   __per_cpu_end = .;
===================================================================
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -59,7 +59,7 @@ SECTIONS
 			usr/built-in.o(.init.ramfs)
 		__initramfs_end = .;
 #endif
-		. = ALIGN(64);
+		. = ALIGN(4096);
 		__per_cpu_start = .;
 			*(.data.percpu)
 		__per_cpu_end = .;
===================================================================
--- a/arch/cris/arch-v32/vmlinux.lds.S
+++ b/arch/cris/arch-v32/vmlinux.lds.S
@@ -91,6 +91,7 @@ SECTIONS
 	}
 	SECURITY_INIT
 
+	. =  ALIGN (8192);
 	__per_cpu_start = .;
 	.data.percpu  : { *(.data.percpu) }
 	__per_cpu_end = .;
===================================================================
--- a/arch/frv/kernel/vmlinux.lds.S
+++ b/arch/frv/kernel/vmlinux.lds.S
@@ -57,6 +57,7 @@ SECTIONS
   __alt_instructions_end = .;
  .altinstr_replacement : { *(.altinstr_replacement) }
 
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
===================================================================
--- a/arch/i386/kernel/vmlinux.lds.S
+++ b/arch/i386/kernel/vmlinux.lds.S
@@ -195,7 +195,7 @@ SECTIONS
 	__initramfs_end = .;
   }
 #endif
-  . = ALIGN(L1_CACHE_BYTES);
+  . = ALIGN(4096);
   .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
 	__per_cpu_start = .;
 	*(.data.percpu)
===================================================================
--- a/arch/m32r/kernel/vmlinux.lds.S
+++ b/arch/m32r/kernel/vmlinux.lds.S
@@ -110,7 +110,7 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-  . = ALIGN(32);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
===================================================================
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -119,7 +119,7 @@ SECTIONS
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
 #endif
-  . = ALIGN(32);
+  . = ALIGN(_PAGE_SIZE);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
===================================================================
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -181,7 +181,7 @@ SECTIONS
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
 #endif
-  . = ALIGN(32);
+  . = ALIGN(ASM_PAGE_SIZE);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
===================================================================
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
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
 
===================================================================
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
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
===================================================================
--- a/arch/ppc/kernel/vmlinux.lds.S
+++ b/arch/ppc/kernel/vmlinux.lds.S
@@ -130,7 +130,7 @@ SECTIONS
   __ftr_fixup : { *(__ftr_fixup) }
   __stop___ftr_fixup = .;
 
-  . = ALIGN(32);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
===================================================================
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -99,7 +99,7 @@ SECTIONS
   . = ALIGN(2);
   __initramfs_end = .;
 #endif
-  . = ALIGN(256);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
===================================================================
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -54,7 +54,7 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   .data.page_aligned : { *(.data.page_aligned) }
 
-  . = ALIGN(L1_CACHE_BYTES);
+  . = ALIGN(PAGE_SIZE);
   __per_cpu_start = .;
   .data.percpu : { *(.data.percpu) }
   __per_cpu_end = .;
===================================================================
--- a/arch/sh64/kernel/vmlinux.lds.S
+++ b/arch/sh64/kernel/vmlinux.lds.S
@@ -85,7 +85,7 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   .data.page_aligned : C_PHYS(.data.page_aligned) { *(.data.page_aligned) }
 
-  . = ALIGN(L1_CACHE_BYTES);
+  . = ALIGN(PAGE_SIZE);
   __per_cpu_start = .;
   .data.percpu : C_PHYS(.data.percpu) { *(.data.percpu) }
   __per_cpu_end = . ;
===================================================================
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -65,7 +65,7 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-  . = ALIGN(32);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
===================================================================
--- a/arch/sparc64/kernel/smp.c
+++ b/arch/sparc64/kernel/smp.c
@@ -1449,11 +1449,11 @@ void __init setup_per_cpu_areas(void)
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
 
===================================================================
--- a/arch/x86_64/kernel/setup64.c
+++ b/arch/x86_64/kernel/setup64.c
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
===================================================================
--- a/arch/x86_64/kernel/vmlinux.lds.S
+++ b/arch/x86_64/kernel/vmlinux.lds.S
@@ -194,7 +194,7 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-    . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) { *(.data.percpu) }
   __per_cpu_end = .;
===================================================================
--- a/arch/xtensa/kernel/vmlinux.lds.S
+++ b/arch/xtensa/kernel/vmlinux.lds.S
@@ -198,7 +198,7 @@ SECTIONS
   __ftr_fixup : { *(__ftr_fixup) }
   __stop___ftr_fixup = .;
 
-  . = ALIGN(32);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
===================================================================
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -11,7 +11,7 @@
 
 /* Enough to cover all DEFINE_PER_CPUs in kernel, including modules. */
 #ifndef PERCPU_ENOUGH_ROOM
-#define PERCPU_ENOUGH_ROOM 32768
+#define PERCPU_ENOUGH_ROOM 65536
 #endif
 
 /*
===================================================================
--- a/init/main.c
+++ b/init/main.c
@@ -369,12 +369,12 @@ static void __init setup_per_cpu_areas(v
 	unsigned long nr_possible_cpus = num_possible_cpus();
 
 	/* Copy section for each CPU (we discard the original) */
-	size = ALIGN(__per_cpu_end - __per_cpu_start, SMP_CACHE_BYTES);
+	size = ALIGN(__per_cpu_end - __per_cpu_start, PAGE_SIZE);
 #ifdef CONFIG_MODULES
 	if (size < PERCPU_ENOUGH_ROOM)
 		size = PERCPU_ENOUGH_ROOM;
 #endif
-	ptr = alloc_bootmem(size * nr_possible_cpus);
+	ptr = alloc_bootmem_pages(size * nr_possible_cpus);
 
 	for_each_possible_cpu(i) {
 		__per_cpu_offset[i] = ptr - __per_cpu_start;
===================================================================
--- a/kernel/module.c
+++ b/kernel/module.c
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
@@ -430,7 +430,7 @@ static int percpu_modinit(void)
 	pcpu_size = kmalloc(sizeof(pcpu_size[0]) * pcpu_num_allocated,
 			    GFP_KERNEL);
 	/* Static in-kernel percpu data (used). */
-	pcpu_size[0] = -ALIGN(__per_cpu_end-__per_cpu_start, SMP_CACHE_BYTES);
+	pcpu_size[0] = -ALIGN(__per_cpu_end-__per_cpu_start, PAGE_SIZE);
 	/* Free room. */
 	pcpu_size[1] = PERCPU_ENOUGH_ROOM + pcpu_size[0];
 	if (pcpu_size[1] < 0) {




