Return-Path: <linux-kernel-owner+w=401wt.eu-S933572AbXCaEyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572AbXCaEyc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 00:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965242AbXCaExs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 00:53:48 -0400
Received: from gw.goop.org ([64.81.55.164]:34191 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965217AbXCaExp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 00:53:45 -0400
Message-Id: <20070331020054.806023902@goop.org>
References: <20070331020042.003398870@goop.org>
User-Agent: quilt/0.46-1
Date: Fri, 30 Mar 2007 19:00:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 2/6] Allow percpu variables to be page-aligned
Content-Disposition: inline; filename=allow-per-cpu-variables-to-be-page-aligned.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Let's allow page-alignment in general for per-cpu data (wanted by Xen, and
Ingo suggested KVM as well).

Because larger alignments can use more room, we increase the max per-cpu
memory to 64k rather than 32k: it's getting a little tight.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
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
 init/main.c                       |    4 ++--
 kernel/module.c                   |    8 ++++----
 21 files changed, 29 insertions(+), 31 deletions(-)

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
@@ -194,7 +194,7 @@ SECTIONS
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
--- a/init/main.c
+++ b/init/main.c
@@ -370,8 +370,8 @@ static void __init setup_per_cpu_areas(v
 
 	/* Copy section for each CPU (we discard the original) */
 
-	size = ALIGN(PERCPU_ENOUGH_ROOM, SMP_CACHE_BYTES);
-	ptr = alloc_bootmem(size * nr_possible_cpus);
+	size = ALIGN(PERCPU_ENOUGH_ROOM, PAGE_SIZE);
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

-- 

