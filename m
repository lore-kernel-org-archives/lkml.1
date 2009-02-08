Return-Path: <linux-kernel-owner+w=401wt.eu-S1753508AbZBHO64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbZBHO64 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 09:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbZBHO6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 09:58:47 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:38270 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbZBHO6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 09:58:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ARevUoa9B2iCak66CLL9kuLbD+Ion+6gOCRASea54DiIxPyhqPdb+GXOR+zlQZB7K0
         zIMyOb0ja+CrtQnYKTLTYVnFxuvm0MqACLHbUPXKRQUjeGmjvyw4vVAckI4PzBL78K++
         pw34C3awGSAW9gKrJwFwqU/HyLDpyfxxPVTUw=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/3] x86: Use linker to offset symbols by __per_cpu_load
Date: Sun,  8 Feb 2009 09:58:39 -0500
Message-Id: <1234105120-19731-2-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1234105120-19731-1-git-send-email-brgerst@gmail.com>
References: <1234105120-19731-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup and bug fix

Use the linker to create symbols for certain per-cpu variables
that are offset by __per_cpu_load.  This allows the removal of
the runtime fixup of the GDT pointer, which fixes a bug with
resume reported by Jiri Slaby.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
---
 arch/x86/include/asm/percpu.h    |   22 ++++++++++++++++++++++
 arch/x86/include/asm/processor.h |    2 ++
 arch/x86/kernel/cpu/common.c     |    6 +-----
 arch/x86/kernel/head_64.S        |   21 ++-------------------
 arch/x86/kernel/vmlinux_64.lds.S |    8 ++++++++
 5 files changed, 35 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 0b64af4..aee103b 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -34,6 +34,12 @@
 #define PER_CPU_VAR(var)	per_cpu__##var
 #endif	/* SMP */
 
+#ifdef CONFIG_X86_64_SMP
+#define INIT_PER_CPU_VAR(var)  init_per_cpu__##var
+#else
+#define INIT_PER_CPU_VAR(var)  per_cpu__##var
+#endif
+
 #else /* ...!ASSEMBLY */
 
 #include <linux/stringify.h>
@@ -45,6 +51,22 @@
 #define __percpu_arg(x)		"%" #x
 #endif
 
+/*
+ * Initialized pointers to per-cpu variables needed for the boot
+ * processor need to use these macros to get the proper address
+ * offset from __per_cpu_load on SMP.
+ *
+ * There also must be an entry in vmlinux_64.lds.S
+ */
+#define DECLARE_INIT_PER_CPU(var) \
+       extern typeof(per_cpu_var(var)) init_per_cpu_var(var)
+
+#ifdef CONFIG_X86_64_SMP
+#define init_per_cpu_var(var)  init_per_cpu__##var
+#else
+#define init_per_cpu_var(var)  per_cpu_var(var)
+#endif
+
 /* For arch-specific code, we can use direct single-insn ops (they
  * don't give an lvalue though). */
 extern void __bad_percpu_size(void);
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 656d02e..373d3f6 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -393,6 +393,8 @@ union irq_stack_union {
 };
 
 DECLARE_PER_CPU(union irq_stack_union, irq_stack_union);
+DECLARE_INIT_PER_CPU(irq_stack_union);
+
 DECLARE_PER_CPU(char *, irq_stack_ptr);
 #endif
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 0f73ea4..41b0de6 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -902,12 +902,8 @@ struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
 DEFINE_PER_CPU_FIRST(union irq_stack_union,
 		     irq_stack_union) __aligned(PAGE_SIZE);
-#ifdef CONFIG_SMP
-DEFINE_PER_CPU(char *, irq_stack_ptr);	/* will be set during per cpu init */
-#else
 DEFINE_PER_CPU(char *, irq_stack_ptr) =
-	per_cpu_var(irq_stack_union.irq_stack) + IRQ_STACK_SIZE - 64;
-#endif
+	init_per_cpu_var(irq_stack_union.irq_stack) + IRQ_STACK_SIZE - 64;
 
 DEFINE_PER_CPU(unsigned long, kernel_stack) =
 	(unsigned long)&init_thread_union - KERNEL_STACK_OFFSET + THREAD_SIZE;
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index a0a2b5c..2e648e3 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -205,19 +205,6 @@ ENTRY(secondary_startup_64)
 	pushq $0
 	popfq
 
-#ifdef CONFIG_SMP
-	/*
-	 * Fix up static pointers that need __per_cpu_load added.  The assembler
-	 * is unable to do this directly.  This is only needed for the boot cpu.
-	 * These values are set up with the correct base addresses by C code for
-	 * secondary cpus.
-	 */
-	movq	initial_gs(%rip), %rax
-	cmpl	$0, per_cpu__cpu_number(%rax)
-	jne	1f
-	addq	%rax, early_gdt_descr_base(%rip)
-1:
-#endif
 	/*
 	 * We must switch to a new descriptor in kernel space for the GDT
 	 * because soon the kernel won't have access anymore to the userspace
@@ -275,11 +262,7 @@ ENTRY(secondary_startup_64)
 	ENTRY(initial_code)
 	.quad	x86_64_start_kernel
 	ENTRY(initial_gs)
-#ifdef CONFIG_SMP
-	.quad	__per_cpu_load
-#else
-	.quad	PER_CPU_VAR(irq_stack_union)
-#endif
+	.quad	INIT_PER_CPU_VAR(irq_stack_union)
 	__FINITDATA
 
 	ENTRY(stack_start)
@@ -425,7 +408,7 @@ NEXT_PAGE(level2_spare_pgt)
 early_gdt_descr:
 	.word	GDT_ENTRIES*8-1
 early_gdt_descr_base:
-	.quad	per_cpu__gdt_page
+	.quad	INIT_PER_CPU_VAR(gdt_page)
 
 ENTRY(phys_base)
 	/* This must match the first entry in level2_kernel_pgt */
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 07f62d2..087a7f2 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -257,6 +257,14 @@ SECTIONS
   DWARF_DEBUG
 }
 
+ /*
+  * Per-cpu symbols which need to be offset from __per_cpu_load
+  * for the boot processor.
+  */
+#define INIT_PER_CPU(x) init_per_cpu__##x = per_cpu__##x + __per_cpu_load
+INIT_PER_CPU(gdt_page);
+INIT_PER_CPU(irq_stack_union);
+
 /*
  * Build-time check on the image size:
  */
-- 
1.6.1

