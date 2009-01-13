Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbZAMKjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbZAMKjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 05:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbZAMKjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 05:39:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:51099 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbZAMKjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 05:39:01 -0500
From: Tejun Heo <tj@kernel.org>
To: ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       mingo@elte.hu, travis@sgi.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, akpm@linux-foundation.org, steiner@sgi.com,
       hugh@veritas.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/13] x86_32: make percpu symbols zerobased on SMP
Date: Tue, 13 Jan 2009 19:38:17 +0900
Message-Id: <1231843097-18003-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1231843097-18003-1-git-send-email-tj@kernel.org>
References: <1231843097-18003-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Jan 2009 10:38:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes percpu symbols zerobased on x86_32 SMP by using
PERCPU_VADDR() with 0 vaddr in vmlinux_32.lds.S.  A new PHDR is added
as existing ones cannot contain sections near address zero.

The following adjustments have been made to accomodate the address
change.

* code to locate percpu gdt_page in head_64.S is updated to add the
  load address to the gdt_page offset.

* for boot CPU, we can't use __KERNEL_DS for %fs.  initialize
  gdt_page.gdt[GDT_ENTRY_PERCPU] with flags and limit and set the base
  address to __per_cpu_load from head_32.S and load it.  the base
  address needs to be set manually because linker can't shift bits as
  required for segment descriptors.

* __per_cpu_offset[0] is now initialized to __per_cpu_load like on
  x86_64.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/cpu/common.c     |    8 ++++++++
 arch/x86/kernel/head_32.S        |   37 ++++++++++++++++++++++++++++++++++---
 arch/x86/kernel/setup_percpu.c   |    4 ----
 arch/x86/kernel/vmlinux_32.lds.S |   16 +++++++++++++++-
 4 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index bd38a0f..376e142 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -90,7 +90,15 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 	[GDT_ENTRY_APMBIOS_BASE+2] = { { { 0x0000ffff, 0x00409200 } } },
 
 	[GDT_ENTRY_ESPFIX_SS] = { { { 0x00000000, 0x00c09200 } } },
+#ifdef CONFIG_SMP
+	/*
+	 * Linker can't handle the address bit shifting.  Address will
+	 * be set in head_32.S for boot CPU and init_gdt for others.
+	 */
+	[GDT_ENTRY_PERCPU] = { { { 0x0000ffff, 0x00cf9200 } } },
+#else
 	[GDT_ENTRY_PERCPU] = { { { 0x00000000, 0x00000000 } } },
+#endif
 } };
 #endif
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index e835b4e..3284199 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -19,6 +19,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/setup.h>
 #include <asm/processor-flags.h>
+#include <asm/percpu.h>
 
 /* Physical address */
 #define pa(X) ((X) - __PAGE_OFFSET)
@@ -424,12 +425,39 @@ is386:	movl $2,%ecx		# set MP
 	movl %eax,%cr0
 
 	call check_x87
+#ifdef CONFIG_SMP
+	/*
+	 * early_gdt_base should point to the gdt_page in static percpu init
+	 * data area.  Computing this requires two symbols - __per_cpu_load
+	 * and per_cpu__gdt_page.  As linker can't do no such relocation, do
+	 * it by hand.  As early_gdt_descr is manipulated by C code for
+	 * secondary CPUs, this should be done only once for the boot CPU
+	 * when early_gdt_descr_base contains zero.
+	 *
+	 * Also, manually load __per_cpu_load into address fields of PERCPU
+	 * segment descriptor for boot CPU.  Linker can't do it.
+	 */
+	movl	early_gdt_descr_base, %eax
+	testl	%eax, %eax
+	jnz	3f
+	movl	$__per_cpu_load, %eax
+	movl	%eax, %ecx
+	addl	$per_cpu__gdt_page, %eax
+	movl	%eax, early_gdt_descr_base
+
+	movw	%cx, 8 * GDT_ENTRY_PERCPU + 2(%eax)
+	shrl	$16, %ecx
+	movb	%cl, 8 * GDT_ENTRY_PERCPU + 4(%eax)
+	movb	%ch, 8 * GDT_ENTRY_PERCPU + 7(%eax)
+3:
+#endif /* CONFIG_SMP */
 	lgdt early_gdt_descr
 	lidt idt_descr
 	ljmp $(__KERNEL_CS),$1f
 1:	movl $(__KERNEL_DS),%eax	# reload all the segment registers
 	movl %eax,%ss			# after changing gdt.
-	movl %eax,%fs			# gets reset once there's real percpu
+	movl $(__KERNEL_PERCPU),%eax
+	movl %eax,%fs			# will be reloaded for boot cpu
 
 	movl $(__USER_DS),%eax		# DS/ES contains default USER segment
 	movl %eax,%ds
@@ -446,8 +474,6 @@ is386:	movl $2,%ecx		# set MP
 	movb $1, ready
 	cmpb $0,%cl		# the first CPU calls start_kernel
 	je   1f
-	movl $(__KERNEL_PERCPU), %eax
-	movl %eax,%fs		# set this cpu's percpu
 	movl (stack_start), %esp
 1:
 #endif /* CONFIG_SMP */
@@ -702,7 +728,12 @@ idt_descr:
 	.word 0				# 32 bit align gdt_desc.address
 ENTRY(early_gdt_descr)
 	.word GDT_ENTRIES*8-1
+#ifdef CONFIG_SMP
+early_gdt_descr_base:
+	.long 0x00000000
+#else
 	.long per_cpu__gdt_page		/* Overwritten for secondary CPUs */
+#endif
 
 /*
  * The boot_gdt must mirror the equivalent in setup.S and is
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 9edc081..6f47227 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -119,13 +119,9 @@ static void __init setup_per_cpu_maps(void)
 #endif
 }
 
-#ifdef CONFIG_X86_64
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly = {
 	[0] = (unsigned long)__per_cpu_load,
 };
-#else
-unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
-#endif
 EXPORT_SYMBOL(__per_cpu_offset);
 
 /*
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 3eba7f7..03abadf 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -24,6 +24,9 @@ jiffies = jiffies_64;
 PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
 	data PT_LOAD FLAGS(7);	/* RWE */
+#ifdef CONFIG_SMP
+	percpu PT_LOAD FLAGS(7);	/* RWE */
+#endif
 	note PT_NOTE FLAGS(0);	/* ___ */
 }
 SECTIONS
@@ -178,7 +181,18 @@ SECTIONS
 	__initramfs_end = .;
   }
 #endif
+
+#ifdef CONFIG_SMP
+  /*
+   * percpu offsets are zero-based on SMP.  PERCPU_VADDR() changes the
+   * output PHDR, so the next output section - bss - should switch it
+   * back to data.
+   */
+  . = ALIGN(PAGE_SIZE);
+  PERCPU_VADDR(0, :percpu)
+#else
   PERCPU(PAGE_SIZE)
+#endif
   . = ALIGN(PAGE_SIZE);
   /* freed after init ends here */
 
@@ -193,7 +207,7 @@ SECTIONS
 	/* This is where the kernel creates the early boot page tables */
 	. = ALIGN(PAGE_SIZE);
 	pg0 = . ;
-  }
+  } :data	/* switch back to data, see PERCPU_VADDR() above */
 
   /* Sections to be discarded */
   /DISCARD/ : {
-- 
1.5.6

