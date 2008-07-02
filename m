Return-Path: <linux-kernel-owner+w=401wt.eu-S1760880AbYGAWhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbYGAWhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758679AbYGAWgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:36:49 -0400
Received: from hu-out-0506.google.com ([72.14.214.235]:18022 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757947AbYGAWgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:36:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :content-type:content-transfer-encoding:message-id;
        b=g6VJRClT+7XAsGUttNqh/tf2WA5+Iz9n+gpoa7Xzoq/hDwRkQhdSZpeqlaUHxUqaVq
         HVIJDnNK8ceL1q3AvVSBXvK3zrvAAB2osJUCVnDSESIva4MAHyHBVJEo1oZAF+CrjqXx
         FCNbEpvKW2J9VLTo+3Aiy3qhVljvl/a/ljcYM=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 9/23] make section names compatible with -ffunction-sections -fdata-sections: ia64
Date: Wed, 2 Jul 2008 02:36:52 +0200
User-Agent: KMail/1.8.2
Cc: Russell King <rmk@arm.linux.org.uk>, David Howells <dhowells@redhat.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Dave Miller <davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200807020236.52729.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch is to make kernel buildable
with "gcc -ffunction-sections -fdata-sections".
This patch fixes ia64 architecture.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda


--- 0.org/arch/ia64/kernel/Makefile	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/ia64/kernel/Makefile	Wed Jul  2 00:46:44 2008
@@ -66,7 +66,7 @@
 $(obj)/gate-syms.o: $(obj)/gate.lds $(obj)/gate.o FORCE
 	$(call if_changed,gate)
 
-# gate-data.o contains the gate DSO image as data in section .data.gate.
+# gate-data.o contains the gate DSO image as data in section .gate..data
 # We must build gate.so before we can assemble it.
 # Note: kbuild does not track this dependency due to usage of .incbin
 $(obj)/gate-data.o: $(obj)/gate.so
--- 0.org/arch/ia64/kernel/gate-data.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/ia64/kernel/gate-data.S	Wed Jul  2 00:46:44 2008
@@ -1,3 +1,3 @@
-	.section .data.gate, "aw"
+	.section .gate.data, "aw"
 
 	.incbin "arch/ia64/kernel/gate.so"
--- 0.org/arch/ia64/kernel/gate.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/ia64/kernel/gate.S	Wed Jul  2 00:46:20 2008
@@ -20,18 +20,18 @@
  * to targets outside the shared object) and to avoid multi-phase kernel builds, we
  * simply create minimalistic "patch lists" in special ELF sections.
  */
-	.section ".data.patch.fsyscall_table", "a"
+	.section ".patch.fsyscall_table.data", "a"
 	.previous
 #define LOAD_FSYSCALL_TABLE(reg)			\
 [1:]	movl reg=0;					\
-	.xdata4 ".data.patch.fsyscall_table", 1b-.
+	.xdata4 ".patch.fsyscall_table.data", 1b-.
 
-	.section ".data.patch.brl_fsys_bubble_down", "a"
+	.section ".patch.brl_fsys_bubble_down.data", "a"
 	.previous
 #define BRL_COND_FSYS_BUBBLE_DOWN(pr)			\
 [1:](pr)brl.cond.sptk 0;				\
 	;;						\
-	.xdata4 ".data.patch.brl_fsys_bubble_down", 1b-.
+	.xdata4 ".patch.brl_fsys_bubble_down.data", 1b-.
 
 GLOBAL_ENTRY(__kernel_syscall_via_break)
 	.prologue
--- 0.org/arch/ia64/kernel/gate.lds.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/ia64/kernel/gate.lds.S	Wed Jul  2 00:46:20 2008
@@ -32,21 +32,21 @@
 	 */
 	. = GATE_ADDR + 0x600;
 
-	.data.patch		: {
+	.patch.data		: {
 		__start_gate_mckinley_e9_patchlist = .;
-		*(.data.patch.mckinley_e9)
+		*(.patch.mckinley_e9.data)
 		__end_gate_mckinley_e9_patchlist = .;
 
 		__start_gate_vtop_patchlist = .;
-		*(.data.patch.vtop)
+		*(.patch.vtop.data)
 		__end_gate_vtop_patchlist = .;
 
 		__start_gate_fsyscall_patchlist = .;
-		*(.data.patch.fsyscall_table)
+		*(.patch.fsyscall_table.data)
 		__end_gate_fsyscall_patchlist = .;
 
 		__start_gate_brl_fsys_bubble_down_patchlist = .;
-		*(.data.patch.brl_fsys_bubble_down)
+		*(.patch.brl_fsys_bubble_down.data)
 		__end_gate_brl_fsys_bubble_down_patchlist = .;
 	}						:readable
 
--- 0.org/arch/ia64/kernel/head.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/ia64/kernel/head.S	Wed Jul  2 00:44:22 2008
@@ -178,7 +178,7 @@
 halt_msg:
 	stringz "Halting kernel\n"
 
-	.section .text.head,"ax"
+	.section .head.text,"ax"
 
 	.global start_ap
 
--- 0.org/arch/ia64/kernel/init_task.c	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/ia64/kernel/init_task.c	Wed Jul  2 00:45:57 2008
@@ -28,7 +28,7 @@
  * Initial task structure.
  *
  * We need to make sure that this is properly aligned due to the way process stacks are
- * handled. This is done by having a special ".data.init_task" section...
+ * handled. This is done by having a special ".init_task.data" section...
  */
 #define init_thread_info	init_task_mem.s.thread_info
 
@@ -38,7 +38,7 @@
 		struct thread_info thread_info;
 	} s;
 	unsigned long stack[KERNEL_STACK_SIZE/sizeof (unsigned long)];
-} init_task_mem asm ("init_task") __attribute__((section(".data.init_task"))) = {{
+} init_task_mem asm ("init_task") __attribute__((section(".init_task.data"))) = {{
 	.task =		INIT_TASK(init_task_mem.s.task),
 	.thread_info =	INIT_THREAD_INFO(init_task_mem.s.task)
 }};
--- 0.org/arch/ia64/kernel/ivt.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/ia64/kernel/ivt.S	Wed Jul  2 00:45:33 2008
@@ -75,7 +75,7 @@
 	mov r19=n;;			/* prepare to save predicates */		\
 	br.sptk.many dispatch_to_fault_handler
 
-	.section .text.ivt,"ax"
+	.section .ivt.text,"ax"
 
 	.align 32768	// align on 32KB boundary
 	.global ia64_ivt
--- 0.org/arch/ia64/kernel/minstate.h	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/ia64/kernel/minstate.h	Wed Jul  2 00:46:20 2008
@@ -15,7 +15,7 @@
 #define ACCOUNT_SYS_ENTER
 #endif
 
-.section ".data.patch.rse", "a"
+.section ".patch.rse.data", "a"
 .previous
 
 /*
@@ -214,7 +214,7 @@
 (pUStk) extr.u r17=r18,3,6;			\
 (pUStk)	sub r16=r18,r22;			\
 [1:](pKStk)	br.cond.sptk.many 1f;		\
-	.xdata4 ".data.patch.rse",1b-.		\
+	.xdata4 ".patch.rse.data",1b-.		\
 	;;					\
 	cmp.ge p6,p7 = 33,r17;			\
 	;;					\
--- 0.org/arch/ia64/kernel/vmlinux.lds.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/ia64/kernel/vmlinux.lds.S	Wed Jul  2 00:46:44 2008
@@ -9,7 +9,7 @@
 
 #define IVT_TEXT							\
 		VMLINUX_SYMBOL(__start_ivt_text) = .;			\
-		*(.text.ivt)						\
+		*(.ivt.text)						\
 		VMLINUX_SYMBOL(__end_ivt_text) = .;
 
 OUTPUT_FORMAT("elf64-ia64-little")
@@ -52,13 +52,13 @@
 	KPROBES_TEXT
 	*(.gnu.linkonce.t*)
     }
-  .text.head : AT(ADDR(.text.head) - LOAD_OFFSET)
-	{ *(.text.head) }
+  .head.text : AT(ADDR(.head.text) - LOAD_OFFSET)
+	{ *(.head.text) }
   .text2 : AT(ADDR(.text2) - LOAD_OFFSET)
 	{ *(.text2) }
 #ifdef CONFIG_SMP
-  .text.lock : AT(ADDR(.text.lock) - LOAD_OFFSET)
-	{ *(.text.lock) }
+  .lock.text : AT(ADDR(.lock.text) - LOAD_OFFSET)
+	{ *(.lock.text) }
 #endif
   _etext = .;
 
@@ -85,10 +85,10 @@
 	  __stop___mca_table = .;
 	}
 
-  .data.patch.phys_stack_reg : AT(ADDR(.data.patch.phys_stack_reg) - LOAD_OFFSET)
+  .patch.phys_stack_reg.data : AT(ADDR(.patch.phys_stack_reg.data) - LOAD_OFFSET)
 	{
 	  __start___phys_stack_reg_patchlist = .;
-	  *(.data.patch.phys_stack_reg)
+	  *(.patch.phys_stack_reg.data)
 	  __end___phys_stack_reg_patchlist = .;
 	}
 
@@ -149,24 +149,24 @@
 	  __initcall_end = .;
 	}
 
-  .data.patch.vtop : AT(ADDR(.data.patch.vtop) - LOAD_OFFSET)
+  .patch.vtop.data : AT(ADDR(.patch.vtop.data) - LOAD_OFFSET)
 	{
 	  __start___vtop_patchlist = .;
-	  *(.data.patch.vtop)
+	  *(.patch.vtop.data)
 	  __end___vtop_patchlist = .;
 	}
 
-  .data.patch.rse : AT(ADDR(.data.patch.rse) - LOAD_OFFSET)
+  .patch.rse.data : AT(ADDR(.patch.rse.data) - LOAD_OFFSET)
 	{
 	  __start___rse_patchlist = .;
-	  *(.data.patch.rse)
+	  *(.patch.rse.data)
 	  __end___rse_patchlist = .;
 	}
 
-  .data.patch.mckinley_e9 : AT(ADDR(.data.patch.mckinley_e9) - LOAD_OFFSET)
+  .patch.mckinley_e9.data : AT(ADDR(.patch.mckinley_e9.data) - LOAD_OFFSET)
 	{
 	  __start___mckinley_e9_bundles = .;
-	  *(.data.patch.mckinley_e9)
+	  *(.patch.mckinley_e9.data)
 	  __end___mckinley_e9_bundles = .;
 	}
 
@@ -194,34 +194,34 @@
   __init_end = .;
 
   /* The initial task and kernel stack */
-  .data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET)
-	{ *(.data.init_task) }
+  .init_task.data : AT(ADDR(.init_task.data) - LOAD_OFFSET)
+	{ *(.init_task.data) }
 
-  .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET)
+  .page_aligned.data : AT(ADDR(.page_aligned.data) - LOAD_OFFSET)
         { *(__special_page_section)
 	  __start_gate_section = .;
-	  *(.data.gate)
+	  *(.gate.data)
 	  __stop_gate_section = .;
 	}
   . = ALIGN(PAGE_SIZE);		/* make sure the gate page doesn't expose
   				 * kernel data
 				 */
 
-  .data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET)
-        { *(.data.read_mostly) }
+  .read_mostly.data : AT(ADDR(.read_mostly.data) - LOAD_OFFSET)
+        { *(.read_mostly.data) }
 
-  .data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET)
-        { *(.data.cacheline_aligned) }
+  .cacheline_aligned.data : AT(ADDR(.cacheline_aligned.data) - LOAD_OFFSET)
+        { *(.cacheline_aligned.data) }
 
   /* Per-cpu data: */
   percpu : { } :percpu
   . = ALIGN(PERCPU_PAGE_SIZE);
   __phys_per_cpu_start = .;
-  .data.percpu PERCPU_ADDR : AT(__phys_per_cpu_start - LOAD_OFFSET)
+  .percpu.data PERCPU_ADDR : AT(__phys_per_cpu_start - LOAD_OFFSET)
 	{
 		__per_cpu_start = .;
-		*(.data.percpu)
-		*(.data.percpu.shared_aligned)
+		*(.percpu.data)
+		*(.percpu.shared_aligned.data)
 		__per_cpu_end = .;
 	}
   . = __phys_per_cpu_start + PERCPU_PAGE_SIZE;	/* ensure percpu data fits
--- 0.org/arch/ia64/kvm/vmm_ivt.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/ia64/kvm/vmm_ivt.S	Wed Jul  2 00:45:33 2008
@@ -97,7 +97,7 @@
 
 
 
-    .section .text.ivt,"ax"
+    .section .ivt.text,"ax"
 
     .align 32768    // align on 32KB boundary
     .global kvm_ia64_ivt
--- 0.org/include/asm-ia64/asmmacro.h	Wed Jul  2 00:40:50 2008
+++ 1.fixname/include/asm-ia64/asmmacro.h	Wed Jul  2 00:46:20 2008
@@ -70,12 +70,12 @@
  * path (ivt.S - TLB miss processing) or in places where it might not be
  * safe to use a "tpa" instruction (mca_asm.S - error recovery).
  */
-	.section ".data.patch.vtop", "a"	// declare section & section attributes
+	.section ".patch.vtop.data", "a"	// declare section & section attributes
 	.previous
 
 #define	LOAD_PHYSICAL(pr, reg, obj)		\
 [1:](pr)movl reg = obj;				\
-	.xdata4 ".data.patch.vtop", 1b-.
+	.xdata4 ".patch.vtop.data", 1b-.
 
 /*
  * For now, we always put in the McKinley E9 workaround.  On CPUs that don't need it,
@@ -84,11 +84,11 @@
 #define DO_MCKINLEY_E9_WORKAROUND
 
 #ifdef DO_MCKINLEY_E9_WORKAROUND
-	.section ".data.patch.mckinley_e9", "a"
+	.section ".patch.mckinley_e9.data", "a"
 	.previous
 /* workaround for Itanium 2 Errata 9: */
 # define FSYS_RETURN					\
-	.xdata4 ".data.patch.mckinley_e9", 1f-.;	\
+	.xdata4 ".patch.mckinley_e9.data", 1f-.;	\
 1:{ .mib;						\
 	nop.m 0;					\
 	mov r16=ar.pfs;					\
@@ -107,11 +107,11 @@
  * If physical stack register size is different from DEF_NUM_STACK_REG,
  * dynamically patch the kernel for correct size.
  */
-	.section ".data.patch.phys_stack_reg", "a"
+	.section ".patch.phys_stack_reg.data", "a"
 	.previous
 #define LOAD_PHYS_STACK_REG_SIZE(reg)			\
 [1:]	adds reg=IA64_NUM_PHYS_STACK_REG*8+8,r0;	\
-	.xdata4 ".data.patch.phys_stack_reg", 1b-.
+	.xdata4 ".patch.phys_stack_reg.data", 1b-.
 
 /*
  * Up until early 2004, use of .align within a function caused bad unwind info.
--- 0.org/include/asm-ia64/cache.h	Wed Jul  2 00:40:50 2008
+++ 1.fixname/include/asm-ia64/cache.h	Wed Jul  2 00:45:45 2008
@@ -24,6 +24,6 @@
 # define SMP_CACHE_BYTES	(1 << 3)
 #endif
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".read_mostly.data")))
 
 #endif /* _ASM_IA64_CACHE_H */
--- 0.org/include/asm-ia64/percpu.h	Wed Jul  2 00:40:50 2008
+++ 1.fixname/include/asm-ia64/percpu.h	Wed Jul  2 00:45:39 2008
@@ -27,7 +27,7 @@
 
 #else /* ! SMP */
 
-#define PER_CPU_ATTRIBUTES	__attribute__((__section__(".data.percpu")))
+#define PER_CPU_ATTRIBUTES	__attribute__((__section__(".percpu.data")))
 
 #define per_cpu_init()				(__phys_per_cpu_start)
 
