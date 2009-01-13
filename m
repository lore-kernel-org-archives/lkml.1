Return-Path: <linux-kernel-owner+w=401wt.eu-S1759492AbZAMKla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492AbZAMKla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 05:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756846AbZAMKjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 05:39:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:51160 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756518AbZAMKjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 05:39:20 -0500
From: Tejun Heo <tj@kernel.org>
To: ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       mingo@elte.hu, travis@sgi.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, akpm@linux-foundation.org, steiner@sgi.com,
       hugh@veritas.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/13] x86_64: make percpu symbols zerobased on SMP
Date: Tue, 13 Jan 2009 19:38:09 +0900
Message-Id: <1231843097-18003-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1231843097-18003-1-git-send-email-tj@kernel.org>
References: <1231843097-18003-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Jan 2009 10:38:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes percpu symbols zerobased on x86_64 SMP by adding
PERCPU_VADDR() to vmlinux.lds.h which helps setting explicit vaddr on
the percpu output section and using it in vmlinux_64.lds.S.  A new
PHDR is added as existing ones cannot contain sections near address
zero.  PERCPU_VADDR() also adds a new symbol __per_cpu_load which
always points to the vaddr of the loaded percpu data.init region.

The following adjustments have been made to accomodate the address
change.

* code to locate percpu gdt_page in head_64.S is updated to add the
  load address to the gdt_page offset.

* __per_cpu_load is used in places where access to the init data area
  is necessary.

* pda->data_offset is initialized soon after C code is entered as zero
  value doesn't work anymore.

This patch is mostly taken from Mike Travis' "x86_64: Base percpu
variables at zero" patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/head64.c          |    2 +
 arch/x86/kernel/head_64.S         |   24 ++++++++++++++++-
 arch/x86/kernel/setup_percpu.c    |    2 +-
 arch/x86/kernel/vmlinux_64.lds.S  |   17 +++++++++++-
 include/asm-generic/sections.h    |    2 +-
 include/asm-generic/vmlinux.lds.h |   51 ++++++++++++++++++++++++++++++++----
 6 files changed, 88 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 388e05a..a63261b 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -44,6 +44,8 @@ void __init x86_64_init_pda(void)
 {
 	_cpu_pda = __cpu_pda;
 	cpu_pda(0) = &_boot_cpu_pda;
+	cpu_pda(0)->data_offset =
+		(unsigned long)(__per_cpu_load - __per_cpu_start);
 	pda_init(0);
 }
 
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 26cfdc1..5ab77b3 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -204,6 +204,23 @@ ENTRY(secondary_startup_64)
 	pushq $0
 	popfq
 
+#ifdef CONFIG_SMP
+	/*
+	 * early_gdt_base should point to the gdt_page in static percpu init
+	 * data area.  Computing this requires two symbols - __per_cpu_load
+	 * and per_cpu__gdt_page.  As linker can't do no such relocation, do
+	 * it by hand.  As early_gdt_descr is manipulated by C code for
+	 * secondary CPUs, this should be done only once for the boot CPU
+	 * when early_gdt_descr_base contains zero.
+	 */
+	movq	early_gdt_descr_base(%rip), %rax
+	testq	%rax, %rax
+	jnz	1f
+	movq	$__per_cpu_load, %rax
+	addq	$per_cpu__gdt_page, %rax
+	movq	%rax, early_gdt_descr_base(%rip)
+1:
+#endif
 	/*
 	 * We must switch to a new descriptor in kernel space for the GDT
 	 * because soon the kernel won't have access anymore to the userspace
@@ -401,7 +418,12 @@ NEXT_PAGE(level2_spare_pgt)
 	.globl early_gdt_descr
 early_gdt_descr:
 	.word	GDT_ENTRIES*8-1
-	.quad   per_cpu__gdt_page
+#ifdef CONFIG_SMP
+early_gdt_descr_base:
+	.quad   0x0000000000000000
+#else
+	.quad	per_cpu__gdt_page
+#endif
 
 ENTRY(phys_base)
 	/* This must match the first entry in level2_kernel_pgt */
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index ee55e3b..8a22c94 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -194,7 +194,7 @@ void __init setup_per_cpu_areas(void)
 		}
 #endif
 		per_cpu_offset(cpu) = ptr - __per_cpu_start;
-		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
+		memcpy(ptr, __per_cpu_load, __per_cpu_end - __per_cpu_start);
 
 		DBG("PERCPU: cpu %4d %p\n", cpu, ptr);
 	}
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 1a614c0..f50280d 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -19,6 +19,9 @@ PHDRS {
 	data PT_LOAD FLAGS(7);	/* RWE */
 	user PT_LOAD FLAGS(7);	/* RWE */
 	data.init PT_LOAD FLAGS(7);	/* RWE */
+#ifdef CONFIG_SMP
+	percpu PT_LOAD FLAGS(7);	/* RWE */
+#endif
 	note PT_NOTE FLAGS(0);	/* ___ */
 }
 SECTIONS
@@ -208,14 +211,26 @@ SECTIONS
   __initramfs_end = .;
 #endif
 
+#ifdef CONFIG_SMP
+  /*
+   * percpu offsets are zero-based on SMP.  PERCPU_VADDR() changes the
+   * output PHDR, so the next output section - __data_nosave - should
+   * switch it back to data.init.
+   */
+  . = ALIGN(PAGE_SIZE);
+  PERCPU_VADDR(0, :percpu)
+#else
   PERCPU(PAGE_SIZE)
+#endif
 
   . = ALIGN(PAGE_SIZE);
   __init_end = .;
 
   . = ALIGN(PAGE_SIZE);
   __nosave_begin = .;
-  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) { *(.data.nosave) }
+  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
+      *(.data.nosave)
+  } :data.init	/* switch back to data.init, see PERCPU_VADDR() above */
   . = ALIGN(PAGE_SIZE);
   __nosave_end = .;
 
diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
index 79a7ff9..4ce48e8 100644
--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
@@ -9,7 +9,7 @@ extern char __bss_start[], __bss_stop[];
 extern char __init_begin[], __init_end[];
 extern char _sinittext[], _einittext[];
 extern char _end[];
-extern char __per_cpu_start[], __per_cpu_end[];
+extern char __per_cpu_load[], __per_cpu_start[], __per_cpu_end[];
 extern char __kprobes_text_start[], __kprobes_text_end[];
 extern char __initdata_begin[], __initdata_end[];
 extern char __start_rodata[], __end_rodata[];
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index c61fab1..fc2f55f 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -430,12 +430,51 @@
   	*(.initcall7.init)						\
   	*(.initcall7s.init)
 
-#define PERCPU(align)							\
-	. = ALIGN(align);						\
-	VMLINUX_SYMBOL(__per_cpu_start) = .;				\
-	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {		\
+#define PERCPU_PROLOG(vaddr)						\
+	VMLINUX_SYMBOL(__per_cpu_load) = .;				\
+	.data.percpu vaddr : AT(__per_cpu_load - LOAD_OFFSET) {		\
+		VMLINUX_SYMBOL(__per_cpu_start) = .;
+
+#define PERCPU_EPILOG(phdr)						\
+		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
+	} phdr								\
+	. = __per_cpu_load + SIZEOF(.data.percpu);
+
+/**
+ * PERCPU_VADDR - define output section for percpu area
+ * @vaddr: explicit base address (optional)
+ * @phdr: destination PHDR (optional)
+ *
+ * Macro which expands to output section for percpu area.  If @vaddr
+ * is not blank, it specifies explicit base address and all percpu
+ * symbols will be offset from the given address.  If blank, @vaddr
+ * always equals @laddr + LOAD_OFFSET.
+ *
+ * @phdr defines the output PHDR to use if not blank.  Be warned that
+ * output PHDR is sticky.  If @phdr is specified, the next output
+ * section in the linker script will go there too.  @phdr should have
+ * a leading colon.
+ *
+ * This macro defines three symbols, __per_cpu_load, __per_cpu_start
+ * and __per_cpu_end.  The first one is the vaddr of loaded percpu
+ * init data.  __per_cpu_start equals @vaddr and __per_cpu_end is the
+ * end offset.
+ */
+#define PERCPU_VADDR(vaddr, phdr)					\
+	PERCPU_PROLOG(vaddr)						\
 		*(.data.percpu.page_aligned)				\
 		*(.data.percpu)						\
 		*(.data.percpu.shared_aligned)				\
-	}								\
-	VMLINUX_SYMBOL(__per_cpu_end) = .;
+	PERCPU_EPILOG(phdr)
+
+/**
+ * PERCPU - define output section for percpu area, simple version
+ * @align: required alignment
+ *
+ * Align to @align and outputs output section for percpu area.  This
+ * macro doesn't maniuplate @vaddr or @phdr and __per_cpu_load and
+ * __per_cpu_start will be identical.
+ */
+#define PERCPU(align)							\
+	. = ALIGN(align);						\
+	PERCPU_VADDR( , )
-- 
1.5.6

