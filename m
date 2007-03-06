Return-Path: <linux-kernel-owner+w=401wt.eu-S1751010AbXCFNBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751010AbXCFNBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 08:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbXCFNBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 08:01:30 -0500
Received: from ozlabs.org ([203.10.76.45]:56622 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbXCFNB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 08:01:29 -0500
Subject: [PATCH 6/8] Allow per-cpu variables to be page-aligned
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
In-Reply-To: <1173185909.4644.36.camel@localhost.localdomain>
References: <1173184747.4644.23.camel@localhost.localdomain>
	 <1173185592.4644.28.camel@localhost.localdomain>
	 <1173185666.4644.30.camel@localhost.localdomain>
	 <1173185734.4644.32.camel@localhost.localdomain>
	 <1173185827.4644.34.camel@localhost.localdomain>
	 <1173185909.4644.36.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 00:00:20 +1100
Message-Id: <1173186021.4644.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xen wants page-aligned GDT (and PDA must not cross a page-boundary,
but that doesn't happen at the moment since it's so close to start of
page).  Let's allow page-alignment in general for per-cpu data.

Because larger alignments can use more room, we increase the max
per-cpu memory to 64k rather than 32k: it's getting a little tight.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 213b1ec27001 arch/alpha/kernel/vmlinux.lds.S
--- a/arch/alpha/kernel/vmlinux.lds.S	Tue Mar 06 19:01:59 2007 +1100
+++ b/arch/alpha/kernel/vmlinux.lds.S	Tue Mar 06 19:02:03 2007 +1100
@@ -69,7 +69,7 @@ SECTIONS
   . = ALIGN(8);
   SECURITY_INIT
 
-  . = ALIGN(64);
+  . = ALIGN(8192);
   __per_cpu_start = .;
   .data.percpu : { *(.data.percpu) }
   __per_cpu_end = .;
diff -r 213b1ec27001 arch/arm/kernel/vmlinux.lds.S
--- a/arch/arm/kernel/vmlinux.lds.S	Tue Mar 06 19:01:59 2007 +1100
+++ b/arch/arm/kernel/vmlinux.lds.S	Tue Mar 06 19:02:03 2007 +1100
@@ -59,7 +59,7 @@ SECTIONS
 			usr/built-in.o(.init.ramfs)
 		__initramfs_end = .;
 #endif
-		. = ALIGN(64);
+		. = ALIGN(4096);
 		__per_cpu_start = .;
 			*(.data.percpu)
 		__per_cpu_end = .;
diff -r 213b1ec27001 arch/cris/arch-v32/vmlinux.lds.S
--- a/arch/cris/arch-v32/vmlinux.lds.S	Tue Mar 06 19:01:59 2007 +1100
+++ b/arch/cris/arch-v32/vmlinux.lds.S	Tue Mar 06 19:02:03 2007 +1100
@@ -91,6 +91,7 @@ SECTIONS
 	}
 	SECURITY_INIT
 
+	. =  ALIGN (8192);
 	__per_cpu_start = .;
 	.data.percpu  : { *(.data.percpu) }
 	__per_cpu_end = .;
diff -r 213b1ec27001 arch/frv/kernel/vmlinux.lds.S
--- a/arch/frv/kernel/vmlinux.lds.S	Tue Mar 06 19:01:59 2007 +1100
+++ b/arch/frv/kernel/vmlinux.lds.S	Tue Mar 06 19:02:03 2007 +1100
@@ -57,6 +57,7 @@ SECTIONS
   __alt_instructions_end = .;
  .altinstr_replacement : { *(.altinstr_replacement) }
 
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
diff -r 213b1ec27001 arch/i386/kernel/vmlinux.lds.S
--- a/arch/i386/kernel/vmlinux.lds.S	Tue Mar 06 19:01:59 2007 +1100
+++ b/arch/i386/kernel/vmlinux.lds.S	Tue Mar 06 19:02:03 2007 +1100
@@ -196,7 +196,7 @@ SECTIONS
 	__initramfs_end = .;
   }
 #endif
-  . = ALIGN(L1_CACHE_BYTES);
+  . = ALIGN(4096);
   .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
 	__per_cpu_start = .;
 	*(.data.percpu)
diff -r 213b1ec27001 arch/m32r/kernel/vmlinux.lds.S
--- a/arch/m32r/kernel/vmlinux.lds.S	Tue Mar 06 19:01:59 2007 +1100
+++ b/arch/m32r/kernel/vmlinux.lds.S	Tue Mar 06 19:02:03 2007 +1100
@@ -110,7 +110,7 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-  . = ALIGN(32);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
diff -r 213b1ec27001 arch/mips/kernel/vmlinux.lds.S
--- a/arch/mips/kernel/vmlinux.lds.S	Tue Mar 06 19:01:59 2007 +1100
+++ b/arch/mips/kernel/vmlinux.lds.S	Tue Mar 06 19:02:03 2007 +1100
@@ -119,7 +119,7 @@ SECTIONS
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
 #endif
-  . = ALIGN(32);
+  . = ALIGN(_PAGE_SIZE);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
diff -r 213b1ec27001 arch/parisc/kernel/vmlinux.lds.S
--- a/arch/parisc/kernel/vmlinux.lds.S	Tue Mar 06 19:01:59 2007 +1100
+++ b/arch/parisc/kernel/vmlinux.lds.S	Tue Mar 06 19:02:03 2007 +1100
@@ -181,7 +181,7 @@ SECTIONS
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
 #endif
-  . = ALIGN(32);
+  . = ALIGN(ASM_PAGE_SIZE);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
diff -r 213b1ec27001 arch/powerpc/kernel/vmlinux.lds.S
--- a/arch/powerpc/kernel/vmlinux.lds.S	Tue Mar 06 19:01:59 2007 +1100
+++ b/arch/powerpc/kernel/vmlinux.lds.S	Tue Mar 06 19:02:03 2007 +1100
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
diff -r 213b1ec27001 arch/ppc/kernel/vmlinux.lds.S
--- a/arch/ppc/kernel/vmlinux.lds.S	Tue Mar 06 19:01:59 2007 +1100
+++ b/arch/ppc/kernel/vmlinux.lds.S	Tue Mar 06 19:02:03 2007 +1100
@@ -130,7 +130,7 @@ SECTIONS
   __ftr_fixup : { *(__ftr_fixup) }
   __stop___ftr_fixup = .;
 
-  . = ALIGN(32);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
diff -r 213b1ec27001 arch/s390/kernel/vmlinux.lds.S
--- a/arch/s390/kernel/vmlinux.lds.S	Tue Mar 06 19:01:59 2007 +1100
+++ b/arch/s390/kernel/vmlinux.lds.S	Tue Mar 06 19:02:03 2007 +1100
@@ -99,7 +99,7 @@ SECTIONS
   . = ALIGN(2);
   __initramfs_end = .;
 #endif
-  . = ALIGN(256);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
diff -r 213b1ec27001 arch/sh/kernel/vmlinux.lds.S
--- a/arch/sh/kernel/vmlinux.lds.S	Tue Mar 06 19:01:59 2007 +1100
+++ b/arch/sh/kernel/vmlinux.lds.S	Tue Mar 06 19:02:25 2007 +1100
@@ -54,7 +54,7 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   .data.page_aligned : { *(.data.page_aligned) }
 
-  . = ALIGN(L1_CACHE_BYTES);
+  . = ALIGN(PAGE_SIZE);
   __per_cpu_start = .;
   .data.percpu : { *(.data.percpu) }
   __per_cpu_end = .;
diff -r 213b1ec27001 arch/sh64/kernel/vmlinux.lds.S
--- a/arch/sh64/kernel/vmlinux.lds.S	Tue Mar 06 19:01:59 2007 +1100
+++ b/arch/sh64/kernel/vmlinux.lds.S	Tue Mar 06 19:02:03 2007 +1100
@@ -85,7 +85,7 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   .data.page_aligned : C_PHYS(.data.page_aligned) { *(.data.page_aligned) }
 
-  . = ALIGN(L1_CACHE_BYTES);
+  . = ALIGN(PAGE_SIZE);
   __per_cpu_start = .;
   .data.percpu : C_PHYS(.data.percpu) { *(.data.percpu) }
   __per_cpu_end = . ;
diff -r 213b1ec27001 arch/sparc/kernel/vmlinux.lds.S
--- a/arch/sparc/kernel/vmlinux.lds.S	Tue Mar 06 19:01:59 2007 +1100
+++ b/arch/sparc/kernel/vmlinux.lds.S	Tue Mar 06 19:02:03 2007 +1100
@@ -65,7 +65,7 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-  . = ALIGN(32);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
diff -r 213b1ec27001 arch/x86_64/kernel/vmlinux.lds.S
--- a/arch/x86_64/kernel/vmlinux.lds.S	Tue Mar 06 19:01:59 2007 +1100
+++ b/arch/x86_64/kernel/vmlinux.lds.S	Tue Mar 06 19:02:03 2007 +1100
@@ -194,7 +194,7 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
-    . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) { *(.data.percpu) }
   __per_cpu_end = .;
diff -r 213b1ec27001 arch/xtensa/kernel/vmlinux.lds.S
--- a/arch/xtensa/kernel/vmlinux.lds.S	Tue Mar 06 19:01:59 2007 +1100
+++ b/arch/xtensa/kernel/vmlinux.lds.S	Tue Mar 06 19:02:03 2007 +1100
@@ -198,7 +198,7 @@ SECTIONS
   __ftr_fixup : { *(__ftr_fixup) }
   __stop___ftr_fixup = .;
 
-  . = ALIGN(32);
+  . = ALIGN(4096);
   __per_cpu_start = .;
   .data.percpu  : { *(.data.percpu) }
   __per_cpu_end = .;
diff -r 213b1ec27001 include/linux/percpu.h
--- a/include/linux/percpu.h	Tue Mar 06 19:01:59 2007 +1100
+++ b/include/linux/percpu.h	Tue Mar 06 23:32:35 2007 +1100
@@ -11,7 +11,7 @@
 
 /* Enough to cover all DEFINE_PER_CPUs in kernel, including modules. */
 #ifndef PERCPU_ENOUGH_ROOM
-#define PERCPU_ENOUGH_ROOM 32768
+#define PERCPU_ENOUGH_ROOM 65536
 #endif
 
 /*
diff -r 213b1ec27001 init/main.c
--- a/init/main.c	Tue Mar 06 19:01:59 2007 +1100
+++ b/init/main.c	Tue Mar 06 19:02:03 2007 +1100
@@ -368,12 +368,12 @@ static void __init setup_per_cpu_areas(v
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
diff -r 213b1ec27001 kernel/module.c
--- a/kernel/module.c	Tue Mar 06 19:01:59 2007 +1100
+++ b/kernel/module.c	Tue Mar 06 19:02:03 2007 +1100
@@ -544,10 +544,10 @@ static void *percpu_modalloc(unsigned lo
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
@@ -628,7 +628,7 @@ static int percpu_modinit(void)
 	pcpu_size = kmalloc(sizeof(pcpu_size[0]) * pcpu_num_allocated,
 			    GFP_KERNEL);
 	/* Static in-kernel percpu data (used). */
-	pcpu_size[0] = -ALIGN(__per_cpu_end-__per_cpu_start, SMP_CACHE_BYTES);
+	pcpu_size[0] = -ALIGN(__per_cpu_end-__per_cpu_start, PAGE_SIZE);
 	/* Free room. */
 	pcpu_size[1] = PERCPU_ENOUGH_ROOM + pcpu_size[0];
 	if (pcpu_size[1] < 0) {


