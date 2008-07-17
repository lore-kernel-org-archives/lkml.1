Return-Path: <linux-kernel-owner+w=401wt.eu-S932859AbYGQUNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859AbYGQUNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 16:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759725AbYGQUNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 16:13:25 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:49100 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758534AbYGQUNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 16:13:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=KUAOS9uDnMHMAvmRTSiyfZBS63QYSA7sVW6VmhJSn0MlZJdYMpAF+lU6OBGncMUupz
         TxVF2SmpegQn1qizcF4XjNc+2LtdS0ZaQNs6ploYYYabX0EeJ/mXYjo/LlkjalHSwsi2
         4ID5y0fBZPMkFiPJMjpJ/laD7k4ZC9vUv65aw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, x86@kernel.org,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: [PATCH] (updated, rolled up) make section names compatible with -ffunction-sections -fdata-sections
Date: Thu, 17 Jul 2008 22:13:37 +0200
User-Agent: KMail/1.8.2
Cc: Russell King <rmk@arm.linux.org.uk>, David Howells <dhowells@redhat.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       torvalds@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Dave Miller <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807172213.37411.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here is the update against current Linus tree,
rolled up into one patch.

James Bottomley suggested a different naming scheme:
instead of swapping parts (.text.head -> .head.text),
prepend .kernel to our special section names.
This patch implements his idea.

ppc and v850 are dropped per comments from arch people.
parisc and x86 had minor fixes. x86 fix added proper
executable bits to a section:

-.section ".text.head"
+.section ".kernel.text.head","ax",@progbits

Does arch/m68k/kernel/sun3-head.S need the same fix?

The patch is run-tested on x86_64.

I would like to ask arch maintainers to ACK/NAK this patch,
and Andrew to act accordingly.

Changelog follows:



The purpose of these patches is to make kernel buildable
with "gcc -ffunction-sections -fdata-sections".

The problem is that with -ffunction-sections -fdata-sections gcc
creates sections like .text.head and .data.nosave
whenever someone has innocuous code like this:

static void head(...) {...}

or this:

int f(...) { static int nosave; ... }

somewhere in the kernel.

Kernel linker script is confused by such names and puts these sections
in wrong places.

This patch renames all "magic" section names used by kernel
to not have this format, eliminating the possibility of such collisions.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda


--- gc.0/Documentation/mutex-design.txt	Thu Jul 17 16:42:29 2008
+++ gc.1/Documentation/mutex-design.txt	Thu Jul 17 21:07:22 2008
@@ -66,14 +66,14 @@
 
     c0377ccb <mutex_lock>:
     c0377ccb:       f0 ff 08                lock decl (%eax)
-    c0377cce:       78 0e                   js     c0377cde <.text.lock.mutex>
+    c0377cce:       78 0e                   js     c0377cde <.kernel.text.lock.mutex>
     c0377cd0:       c3                      ret
 
    the unlocking fastpath is equally tight:
 
     c0377cd1 <mutex_unlock>:
     c0377cd1:       f0 ff 00                lock incl (%eax)
-    c0377cd4:       7e 0f                   jle    c0377ce5 <.text.lock.mutex+0x7>
+    c0377cd4:       7e 0f                   jle    c0377ce5 <.kernel.text.lock.mutex+0x7>
     c0377cd6:       c3                      ret
 
  - 'struct mutex' semantics are well-defined and are enforced if
--- gc.0/arch/alpha/kernel/head.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/alpha/kernel/head.S	Thu Jul 17 21:07:22 2008
@@ -10,7 +10,7 @@
 #include <asm/system.h>
 #include <asm/asm-offsets.h>
 
-.section .text.head, "ax"
+.section .kernel.text.head, "ax"
 .globl swapper_pg_dir
 .globl _stext
 swapper_pg_dir=SWAPPER_PGD
--- gc.0/arch/alpha/kernel/init_task.c	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/alpha/kernel/init_task.c	Thu Jul 17 21:07:22 2008
@@ -18,5 +18,5 @@
 EXPORT_SYMBOL(init_task);
 
 union thread_union init_thread_union
-	__attribute__((section(".data.init_thread")))
+	__attribute__((section(".kernel.data.init_thread")))
 	= { INIT_THREAD_INFO(init_task) };
--- gc.0/arch/alpha/kernel/vmlinux.lds.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/alpha/kernel/vmlinux.lds.S	Thu Jul 17 21:07:22 2008
@@ -16,7 +16,7 @@
 
 	_text = .;	/* Text and read-only data */
 	.text : {
-	*(.text.head)
+	*(.kernel.text.head)
 		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
@@ -93,18 +93,18 @@
 	/* Freed after init ends here */
 
 	/* Note 2 page alignment above.  */
-	.data.init_thread : {
-		*(.data.init_thread)
+	.kernel.data.init_thread : {
+		*(.kernel.data.init_thread)
 	}
 
 	. = ALIGN(PAGE_SIZE);
-	.data.page_aligned : {
-		*(.data.page_aligned)
+	.kernel.data.page_aligned : {
+		*(.kernel.data.page_aligned)
 	}
 
 	. = ALIGN(64);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
+	.kernel.data.cacheline_aligned : {
+		*(.kernel.data.cacheline_aligned)
 	}
 
 	_data = .;
--- gc.0/arch/arm/kernel/head-nommu.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/arm/kernel/head-nommu.S	Thu Jul 17 21:07:22 2008
@@ -33,7 +33,7 @@
  * numbers for r1.
  *
  */
-	.section ".text.head", "ax"
+	.section ".kernel.text.head", "ax"
 	.type	stext, %function
 ENTRY(stext)
 	msr	cpsr_c, #PSR_F_BIT | PSR_I_BIT | SVC_MODE @ ensure svc mode
--- gc.0/arch/arm/kernel/head.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/arm/kernel/head.S	Thu Jul 17 21:07:22 2008
@@ -74,7 +74,7 @@
  * crap here - that's what the boot loader (or in extreme, well justified
  * circumstances, zImage) is for.
  */
-	.section ".text.head", "ax"
+	.section ".kernel.text.head", "ax"
 	.type	stext, %function
 ENTRY(stext)
 	msr	cpsr_c, #PSR_F_BIT | PSR_I_BIT | SVC_MODE @ ensure svc mode
--- gc.0/arch/arm/kernel/init_task.c	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/arm/kernel/init_task.c	Thu Jul 17 21:07:22 2008
@@ -30,7 +30,7 @@
  * The things we do for performance..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".kernel.data.init_task"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
--- gc.0/arch/arm/kernel/vmlinux.lds.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/arm/kernel/vmlinux.lds.S	Thu Jul 17 21:07:22 2008
@@ -23,10 +23,10 @@
 #else
 	. = PAGE_OFFSET + TEXT_OFFSET;
 #endif
-	.text.head : {
+	.kernel.text.head : {
 		_stext = .;
 		_sinittext = .;
-		*(.text.head)
+		*(.kernel.text.head)
 	}
 
 	.init : {			/* Init code and data		*/
@@ -65,8 +65,8 @@
 #endif
 		. = ALIGN(4096);
 		__per_cpu_start = .;
-			*(.data.percpu)
-			*(.data.percpu.shared_aligned)
+			*(.kernel.data.percpu)
+			*(.kernel.data.percpu.shared_aligned)
 		__per_cpu_end = .;
 #ifndef CONFIG_XIP_KERNEL
 		__init_begin = _stext;
@@ -125,7 +125,7 @@
 		 * first, the init task union, aligned
 		 * to an 8192 byte boundary.
 		 */
-		*(.data.init_task)
+		*(.kernel.data.init_task)
 
 #ifdef CONFIG_XIP_KERNEL
 		. = ALIGN(4096);
@@ -137,7 +137,7 @@
 
 		. = ALIGN(4096);
 		__nosave_begin = .;
-		*(.data.nosave)
+		*(.kernel.data.nosave)
 		. = ALIGN(4096);
 		__nosave_end = .;
 
@@ -145,7 +145,7 @@
 		 * then the cacheline aligned data
 		 */
 		. = ALIGN(32);
-		*(.data.cacheline_aligned)
+		*(.kernel.data.cacheline_aligned)
 
 		/*
 		 * The exception fixup table (might need resorting at runtime)
--- gc.0/arch/arm/mm/proc-v6.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/arm/mm/proc-v6.S	Thu Jul 17 21:07:22 2008
@@ -164,7 +164,7 @@
 	.asciz	"ARMv6-compatible processor"
 	.align
 
-	.section ".text.init", #alloc, #execinstr
+	.section ".kernel.text.init", #alloc, #execinstr
 
 /*
  *	__v6_setup
--- gc.0/arch/arm/mm/proc-v7.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/arm/mm/proc-v7.S	Thu Jul 17 21:07:22 2008
@@ -146,7 +146,7 @@
 	.ascii	"ARMv7 Processor"
 	.align
 
-	.section ".text.init", #alloc, #execinstr
+	.section ".kernel.text.init", #alloc, #execinstr
 
 /*
  *	__v7_setup
--- gc.0/arch/arm/mm/tlb-v6.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/arm/mm/tlb-v6.S	Thu Jul 17 21:07:22 2008
@@ -87,7 +87,7 @@
 	mcr	p15, 0, r2, c7, c5, 4		@ prefetch flush
 	mov	pc, lr
 
-	.section ".text.init", #alloc, #execinstr
+	.section ".kernel.text.init", #alloc, #execinstr
 
 	.type	v6wbi_tlb_fns, #object
 ENTRY(v6wbi_tlb_fns)
--- gc.0/arch/arm/mm/tlb-v7.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/arm/mm/tlb-v7.S	Thu Jul 17 21:07:22 2008
@@ -78,7 +78,7 @@
 	isb
 	mov	pc, lr
 
-	.section ".text.init", #alloc, #execinstr
+	.section ".kernel.text.init", #alloc, #execinstr
 
 	.type	v7wbi_tlb_fns, #object
 ENTRY(v7wbi_tlb_fns)
--- gc.0/arch/avr32/kernel/init_task.c	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/avr32/kernel/init_task.c	Thu Jul 17 21:07:22 2008
@@ -24,7 +24,7 @@
  * Initial thread structure. Must be aligned on an 8192-byte boundary.
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".kernel.data.init_task"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
--- gc.0/arch/avr32/kernel/vmlinux.lds.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/avr32/kernel/vmlinux.lds.S	Thu Jul 17 21:07:22 2008
@@ -95,15 +95,15 @@
 		/*
 		 * First, the init task union, aligned to an 8K boundary.
 		 */
-		*(.data.init_task)
+		*(.kernel.data.init_task)
 
 		/* Then, the page-aligned data */
 		. = ALIGN(PAGE_SIZE);
-		*(.data.page_aligned)
+		*(.kernel.data.page_aligned)
 
 		/* Then, the cacheline aligned data */
 		. = ALIGN(L1_CACHE_BYTES);
-		*(.data.cacheline_aligned)
+		*(.kernel.data.cacheline_aligned)
 
 		/* And the rest... */
 		*(.data.rel*)
--- gc.0/arch/avr32/mm/init.c	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/avr32/mm/init.c	Thu Jul 17 21:07:22 2008
@@ -24,7 +24,7 @@
 #include <asm/setup.h>
 #include <asm/sections.h>
 
-#define __page_aligned	__attribute__((section(".data.page_aligned")))
+#define __page_aligned	__attribute__((section(".kernel.data.page_aligned")))
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
--- gc.0/arch/blackfin/kernel/vmlinux.lds.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/blackfin/kernel/vmlinux.lds.S	Thu Jul 17 21:07:22 2008
@@ -91,7 +91,7 @@
 		__sdata = .;
 		/* This gets done first, so the glob doesn't suck it in */
 		. = ALIGN(32);
-		*(.data.cacheline_aligned)
+		*(.kernel.data.cacheline_aligned)
 
 #if !L1_DATA_A_LENGTH
 		. = ALIGN(32);
--- gc.0/arch/cris/arch-v10/vmlinux.lds.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/cris/arch-v10/vmlinux.lds.S	Thu Jul 17 21:07:22 2008
@@ -51,7 +51,7 @@
 	_edata = . ;
 
 	. = ALIGN(PAGE_SIZE);	/* init_task and stack, must be aligned */
-  	.data.init_task : { *(.data.init_task) }
+  	.kernel.data.init_task : { *(.kernel.data.init_task) }
 
 	. = ALIGN(PAGE_SIZE);	/* Init code and data */
   	__init_begin = .;
--- gc.0/arch/cris/arch-v32/vmlinux.lds.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/cris/arch-v32/vmlinux.lds.S	Thu Jul 17 21:07:22 2008
@@ -63,7 +63,7 @@
 	_edata = . ;
 
 	. = ALIGN(PAGE_SIZE);	/* init_task and stack, must be aligned. */
-	.data.init_task : { *(.data.init_task) }
+	.kernel.data.init_task : { *(.kernel.data.init_task) }
 
 	. = ALIGN(PAGE_SIZE);	/* Init code and data. */
 	__init_begin = .;
--- gc.0/arch/cris/kernel/process.c	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/cris/kernel/process.c	Thu Jul 17 21:07:22 2008
@@ -52,7 +52,7 @@
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union 
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".kernel.data.init_task"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
--- gc.0/arch/frv/kernel/break.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/frv/kernel/break.S	Thu Jul 17 21:07:22 2008
@@ -21,7 +21,7 @@
 #
 # the break handler has its own stack
 #
-	.section	.bss.stack
+	.section	.bss.kernel.stack
 	.globl		__break_user_context
 	.balign		THREAD_SIZE
 __break_stack:
@@ -63,7 +63,7 @@
 # entry point for Break Exceptions/Interrupts
 #
 ###############################################################################
-	.section	.text.break
+	.section	.kernel.text.break
 	.balign		4
 	.globl		__entry_break
 __entry_break:
--- gc.0/arch/frv/kernel/entry.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/frv/kernel/entry.S	Thu Jul 17 21:07:22 2008
@@ -38,7 +38,7 @@
 
 #define nr_syscalls ((syscall_table_size)/4)
 
-	.section	.text.entry
+	.section	.kernel.text.entry
 	.balign		4
 
 .macro LEDS val
--- gc.0/arch/frv/kernel/head-mmu-fr451.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/frv/kernel/head-mmu-fr451.S	Thu Jul 17 21:07:22 2008
@@ -31,7 +31,7 @@
 #define __400_LCR	0xfe000100
 #define __400_LSBR	0xfe000c00
 
-	.section	.text.init,"ax"
+	.section	.kernel.text.init,"ax"
 	.balign		4
 
 ###############################################################################
--- gc.0/arch/frv/kernel/head-uc-fr401.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/frv/kernel/head-uc-fr401.S	Thu Jul 17 21:07:22 2008
@@ -30,7 +30,7 @@
 #define __400_LCR	0xfe000100
 #define __400_LSBR	0xfe000c00
 
-	.section	.text.init,"ax"
+	.section	.kernel.text.init,"ax"
 	.balign		4
 
 ###############################################################################
--- gc.0/arch/frv/kernel/head-uc-fr451.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/frv/kernel/head-uc-fr451.S	Thu Jul 17 21:07:22 2008
@@ -30,7 +30,7 @@
 #define __400_LCR	0xfe000100
 #define __400_LSBR	0xfe000c00
 
-	.section	.text.init,"ax"
+	.section	.kernel.text.init,"ax"
 	.balign		4
 
 ###############################################################################
--- gc.0/arch/frv/kernel/head-uc-fr555.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/frv/kernel/head-uc-fr555.S	Thu Jul 17 21:07:22 2008
@@ -29,7 +29,7 @@
 #define __551_LCR	0xfeff1100
 #define __551_LSBR	0xfeff1c00
 
-	.section	.text.init,"ax"
+	.section	.kernel.text.init,"ax"
 	.balign		4
 
 ###############################################################################
--- gc.0/arch/frv/kernel/head.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/frv/kernel/head.S	Thu Jul 17 21:07:22 2008
@@ -27,7 +27,7 @@
 #   command line string
 #
 ###############################################################################
-	.section	.text.head,"ax"
+	.section	.kernel.text.head,"ax"
 	.balign		4
 
 	.globl		_boot, __head_reference
@@ -541,7 +541,7 @@
 	.size		_boot, .-_boot
 
 	# provide a point for GDB to place a break
-	.section	.text.start,"ax"
+	.section	.kernel.text.start,"ax"
 	.globl		_start
 	.balign		4
 _start:
--- gc.0/arch/frv/kernel/init_task.c	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/frv/kernel/init_task.c	Thu Jul 17 21:07:22 2008
@@ -25,7 +25,7 @@
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".kernel.data.init_task"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
--- gc.0/arch/frv/kernel/vmlinux.lds.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/frv/kernel/vmlinux.lds.S	Thu Jul 17 21:07:22 2008
@@ -26,7 +26,7 @@
 
   _sinittext = .;
   .init.text : {
-	*(.text.head)
+	*(.kernel.text.head)
 #ifndef CONFIG_DEBUG_INFO
 	INIT_TEXT
 	EXIT_TEXT
@@ -71,13 +71,13 @@
 
   /* put sections together that have massive alignment issues */
   . = ALIGN(THREAD_SIZE);
-  .data.init_task : {
+  .kernel.data.init_task : {
 	  /* init task record & stack */
-	  *(.data.init_task)
+	  *(.kernel.data.init_task)
   }
 
   . = ALIGN(L1_CACHE_BYTES);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
+  .kernel.data.cacheline_aligned : { *(.kernel.data.cacheline_aligned) }
 
   .trap : {
 	/* trap table management - read entry-table.S before modifying */
@@ -94,10 +94,10 @@
   _text = .;
   _stext = .;
   .text : {
-	*(.text.start)
-	*(.text.entry)
-	*(.text.break)
-	*(.text.tlbmiss)
+	*(.kernel.text.start)
+	*(.kernel.text.entry)
+	*(.kernel.text.break)
+	*(.kernel.text.tlbmiss)
 	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
@@ -152,7 +152,7 @@
 
   .sbss		: { *(.sbss .sbss.*) }
   .bss		: { *(.bss .bss.*) }
-  .bss.stack	: { *(.bss) }
+  .bss.kernel.stack	: { *(.bss) }
 
   __bss_stop = .;
   _end = . ;
--- gc.0/arch/frv/mm/tlb-miss.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/frv/mm/tlb-miss.S	Thu Jul 17 21:07:22 2008
@@ -16,7 +16,7 @@
 #include <asm/highmem.h>
 #include <asm/spr-regs.h>
 
-	.section	.text.tlbmiss
+	.section	.kernel.text.tlbmiss
 	.balign		4
 
 	.globl		__entry_insn_mmu_miss
--- gc.0/arch/h8300/boot/compressed/head.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/h8300/boot/compressed/head.S	Thu Jul 17 21:07:22 2008
@@ -9,7 +9,7 @@
 
 #define SRAM_START 0xff4000
 
-	.section	.text.startup
+	.section	.kernel.text.startup
 	.global	startup
 startup:
 	mov.l	#SRAM_START+0x8000, sp
--- gc.0/arch/h8300/boot/compressed/vmlinux.lds	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/h8300/boot/compressed/vmlinux.lds	Thu Jul 17 21:07:22 2008
@@ -4,7 +4,7 @@
         {
         __stext = . ;
 	__text = .;
-	       *(.text.startup)
+	       *(.kernel.text.startup)
 	       *(.text)
         __etext = . ;
         }
--- gc.0/arch/h8300/kernel/init_task.c	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/h8300/kernel/init_task.c	Thu Jul 17 21:07:22 2008
@@ -37,6 +37,6 @@
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".kernel.data.init_task"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
--- gc.0/arch/h8300/kernel/vmlinux.lds.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/h8300/kernel/vmlinux.lds.S	Thu Jul 17 21:07:22 2008
@@ -101,7 +101,7 @@
 	___data_start = . ;
 
 	. = ALIGN(0x2000) ;
-		*(.data.init_task)
+		*(.kernel.data.init_task)
 	. = ALIGN(0x4) ;
 		DATA_DATA
 	. = ALIGN(0x4) ;
--- gc.0/arch/ia64/kernel/Makefile	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/ia64/kernel/Makefile	Thu Jul 17 21:07:22 2008
@@ -66,7 +66,7 @@
 $(obj)/gate-syms.o: $(obj)/gate.lds $(obj)/gate.o FORCE
 	$(call if_changed,gate)
 
-# gate-data.o contains the gate DSO image as data in section .data.gate.
+# gate-data.o contains the gate DSO image as data in section .kernel.data.gate.
 # We must build gate.so before we can assemble it.
 # Note: kbuild does not track this dependency due to usage of .incbin
 $(obj)/gate-data.o: $(obj)/gate.so
--- gc.0/arch/ia64/kernel/gate-data.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/ia64/kernel/gate-data.S	Thu Jul 17 21:07:22 2008
@@ -1,3 +1,3 @@
-	.section .data.gate, "aw"
+	.section .kernel.data.gate, "aw"
 
 	.incbin "arch/ia64/kernel/gate.so"
--- gc.0/arch/ia64/kernel/gate.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/ia64/kernel/gate.S	Thu Jul 17 21:07:22 2008
@@ -20,18 +20,18 @@
  * to targets outside the shared object) and to avoid multi-phase kernel builds, we
  * simply create minimalistic "patch lists" in special ELF sections.
  */
-	.section ".data.patch.fsyscall_table", "a"
+	.section ".kernel.data.patch.fsyscall_table", "a"
 	.previous
 #define LOAD_FSYSCALL_TABLE(reg)			\
 [1:]	movl reg=0;					\
-	.xdata4 ".data.patch.fsyscall_table", 1b-.
+	.xdata4 ".kernel.data.patch.fsyscall_table", 1b-.
 
-	.section ".data.patch.brl_fsys_bubble_down", "a"
+	.section ".kernel.data.patch.brl_fsys_bubble_down", "a"
 	.previous
 #define BRL_COND_FSYS_BUBBLE_DOWN(pr)			\
 [1:](pr)brl.cond.sptk 0;				\
 	;;						\
-	.xdata4 ".data.patch.brl_fsys_bubble_down", 1b-.
+	.xdata4 ".kernel.data.patch.brl_fsys_bubble_down", 1b-.
 
 GLOBAL_ENTRY(__kernel_syscall_via_break)
 	.prologue
--- gc.0/arch/ia64/kernel/gate.lds.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/ia64/kernel/gate.lds.S	Thu Jul 17 21:07:22 2008
@@ -32,21 +32,21 @@
 	 */
 	. = GATE_ADDR + 0x600;
 
-	.data.patch		: {
+	.kernel.data.patch		: {
 		__start_gate_mckinley_e9_patchlist = .;
-		*(.data.patch.mckinley_e9)
+		*(.kernel.data.patch.mckinley_e9)
 		__end_gate_mckinley_e9_patchlist = .;
 
 		__start_gate_vtop_patchlist = .;
-		*(.data.patch.vtop)
+		*(.kernel.data.patch.vtop)
 		__end_gate_vtop_patchlist = .;
 
 		__start_gate_fsyscall_patchlist = .;
-		*(.data.patch.fsyscall_table)
+		*(.kernel.data.patch.fsyscall_table)
 		__end_gate_fsyscall_patchlist = .;
 
 		__start_gate_brl_fsys_bubble_down_patchlist = .;
-		*(.data.patch.brl_fsys_bubble_down)
+		*(.kernel.data.patch.brl_fsys_bubble_down)
 		__end_gate_brl_fsys_bubble_down_patchlist = .;
 	}						:readable
 
--- gc.0/arch/ia64/kernel/head.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/ia64/kernel/head.S	Thu Jul 17 21:07:22 2008
@@ -178,7 +178,7 @@
 halt_msg:
 	stringz "Halting kernel\n"
 
-	.section .text.head,"ax"
+	.section .kernel.text.head,"ax"
 
 	.global start_ap
 
--- gc.0/arch/ia64/kernel/init_task.c	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/ia64/kernel/init_task.c	Thu Jul 17 21:07:22 2008
@@ -28,7 +28,7 @@
  * Initial task structure.
  *
  * We need to make sure that this is properly aligned due to the way process stacks are
- * handled. This is done by having a special ".data.init_task" section...
+ * handled. This is done by having a special ".kernel.data.init_task" section...
  */
 #define init_thread_info	init_task_mem.s.thread_info
 
@@ -38,7 +38,7 @@
 		struct thread_info thread_info;
 	} s;
 	unsigned long stack[KERNEL_STACK_SIZE/sizeof (unsigned long)];
-} init_task_mem asm ("init_task") __attribute__((section(".data.init_task"))) = {{
+} init_task_mem asm ("init_task") __attribute__((section(".kernel.data.init_task"))) = {{
 	.task =		INIT_TASK(init_task_mem.s.task),
 	.thread_info =	INIT_THREAD_INFO(init_task_mem.s.task)
 }};
--- gc.0/arch/ia64/kernel/ivt.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/ia64/kernel/ivt.S	Thu Jul 17 21:07:22 2008
@@ -75,7 +75,7 @@
 	mov r19=n;;			/* prepare to save predicates */		\
 	br.sptk.many dispatch_to_fault_handler
 
-	.section .text.ivt,"ax"
+	.section .kernel.text.ivt,"ax"
 
 	.align 32768	// align on 32KB boundary
 	.global ia64_ivt
--- gc.0/arch/ia64/kernel/minstate.h	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/ia64/kernel/minstate.h	Thu Jul 17 21:07:22 2008
@@ -15,7 +15,7 @@
 #define ACCOUNT_SYS_ENTER
 #endif
 
-.section ".data.patch.rse", "a"
+.section ".kernel.data.patch.rse", "a"
 .previous
 
 /*
@@ -214,7 +214,7 @@
 (pUStk) extr.u r17=r18,3,6;			\
 (pUStk)	sub r16=r18,r22;			\
 [1:](pKStk)	br.cond.sptk.many 1f;		\
-	.xdata4 ".data.patch.rse",1b-.		\
+	.xdata4 ".kernel.data.patch.rse",1b-.		\
 	;;					\
 	cmp.ge p6,p7 = 33,r17;			\
 	;;					\
--- gc.0/arch/ia64/kernel/vmlinux.lds.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/ia64/kernel/vmlinux.lds.S	Thu Jul 17 21:07:22 2008
@@ -9,7 +9,7 @@
 
 #define IVT_TEXT							\
 		VMLINUX_SYMBOL(__start_ivt_text) = .;			\
-		*(.text.ivt)						\
+		*(.kernel.text.ivt)						\
 		VMLINUX_SYMBOL(__end_ivt_text) = .;
 
 OUTPUT_FORMAT("elf64-ia64-little")
@@ -52,13 +52,13 @@
 	KPROBES_TEXT
 	*(.gnu.linkonce.t*)
     }
-  .text.head : AT(ADDR(.text.head) - LOAD_OFFSET)
-	{ *(.text.head) }
+  .kernel.text.head : AT(ADDR(.kernel.text.head) - LOAD_OFFSET)
+	{ *(.kernel.text.head) }
   .text2 : AT(ADDR(.text2) - LOAD_OFFSET)
 	{ *(.text2) }
 #ifdef CONFIG_SMP
-  .text.lock : AT(ADDR(.text.lock) - LOAD_OFFSET)
-	{ *(.text.lock) }
+  .kernel.text.lock : AT(ADDR(.kernel.text.lock) - LOAD_OFFSET)
+	{ *(.kernel.text.lock) }
 #endif
   _etext = .;
 
@@ -85,10 +85,10 @@
 	  __stop___mca_table = .;
 	}
 
-  .data.patch.phys_stack_reg : AT(ADDR(.data.patch.phys_stack_reg) - LOAD_OFFSET)
+  .kernel.data.patch.phys_stack_reg : AT(ADDR(.kernel.data.patch.phys_stack_reg) - LOAD_OFFSET)
 	{
 	  __start___phys_stack_reg_patchlist = .;
-	  *(.data.patch.phys_stack_reg)
+	  *(.kernel.data.patch.phys_stack_reg)
 	  __end___phys_stack_reg_patchlist = .;
 	}
 
@@ -149,24 +149,24 @@
 	  __initcall_end = .;
 	}
 
-  .data.patch.vtop : AT(ADDR(.data.patch.vtop) - LOAD_OFFSET)
+  .kernel.data.patch.vtop : AT(ADDR(.kernel.data.patch.vtop) - LOAD_OFFSET)
 	{
 	  __start___vtop_patchlist = .;
-	  *(.data.patch.vtop)
+	  *(.kernel.data.patch.vtop)
 	  __end___vtop_patchlist = .;
 	}
 
-  .data.patch.rse : AT(ADDR(.data.patch.rse) - LOAD_OFFSET)
+  .kernel.data.patch.rse : AT(ADDR(.kernel.data.patch.rse) - LOAD_OFFSET)
 	{
 	  __start___rse_patchlist = .;
-	  *(.data.patch.rse)
+	  *(.kernel.data.patch.rse)
 	  __end___rse_patchlist = .;
 	}
 
-  .data.patch.mckinley_e9 : AT(ADDR(.data.patch.mckinley_e9) - LOAD_OFFSET)
+  .kernel.data.patch.mckinley_e9 : AT(ADDR(.kernel.data.patch.mckinley_e9) - LOAD_OFFSET)
 	{
 	  __start___mckinley_e9_bundles = .;
-	  *(.data.patch.mckinley_e9)
+	  *(.kernel.data.patch.mckinley_e9)
 	  __end___mckinley_e9_bundles = .;
 	}
 
@@ -194,34 +194,34 @@
   __init_end = .;
 
   /* The initial task and kernel stack */
-  .data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET)
-	{ *(.data.init_task) }
+  .kernel.data.init_task : AT(ADDR(.kernel.data.init_task) - LOAD_OFFSET)
+	{ *(.kernel.data.init_task) }
 
-  .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET)
+  .kernel.data.page_aligned : AT(ADDR(.kernel.data.page_aligned) - LOAD_OFFSET)
         { *(__special_page_section)
 	  __start_gate_section = .;
-	  *(.data.gate)
+	  *(.kernel.data.gate)
 	  __stop_gate_section = .;
 	}
   . = ALIGN(PAGE_SIZE);		/* make sure the gate page doesn't expose
   				 * kernel data
 				 */
 
-  .data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET)
-        { *(.data.read_mostly) }
+  .kernel.data.read_mostly : AT(ADDR(.kernel.data.read_mostly) - LOAD_OFFSET)
+        { *(.kernel.data.read_mostly) }
 
-  .data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET)
-        { *(.data.cacheline_aligned) }
+  .kernel.data.cacheline_aligned : AT(ADDR(.kernel.data.cacheline_aligned) - LOAD_OFFSET)
+        { *(.kernel.data.cacheline_aligned) }
 
   /* Per-cpu data: */
   percpu : { } :percpu
   . = ALIGN(PERCPU_PAGE_SIZE);
   __phys_per_cpu_start = .;
-  .data.percpu PERCPU_ADDR : AT(__phys_per_cpu_start - LOAD_OFFSET)
+  .kernel.data.percpu PERCPU_ADDR : AT(__phys_per_cpu_start - LOAD_OFFSET)
 	{
 		__per_cpu_start = .;
-		*(.data.percpu)
-		*(.data.percpu.shared_aligned)
+		*(.kernel.data.percpu)
+		*(.kernel.data.percpu.shared_aligned)
 		__per_cpu_end = .;
 	}
   . = __phys_per_cpu_start + PERCPU_PAGE_SIZE;	/* ensure percpu data fits
--- gc.0/arch/ia64/kvm/vmm_ivt.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/ia64/kvm/vmm_ivt.S	Thu Jul 17 21:07:22 2008
@@ -97,7 +97,7 @@
 
 
 
-    .section .text.ivt,"ax"
+    .section .kernel.text.ivt,"ax"
 
     .align 32768    // align on 32KB boundary
     .global kvm_ia64_ivt
--- gc.0/arch/m32r/kernel/init_task.c	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/m32r/kernel/init_task.c	Thu Jul 17 21:07:22 2008
@@ -26,7 +26,7 @@
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".kernel.data.init_task"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
--- gc.0/arch/m32r/kernel/vmlinux.lds.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/m32r/kernel/vmlinux.lds.S	Thu Jul 17 21:07:22 2008
@@ -56,17 +56,17 @@
 
   . = ALIGN(4096);
   __nosave_begin = .;
-  .data_nosave : { *(.data.nosave) }
+  .data_nosave : { *(.kernel.data.nosave) }
   . = ALIGN(4096);
   __nosave_end = .;
 
   . = ALIGN(32);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
+  .kernel.data.cacheline_aligned : { *(.kernel.data.cacheline_aligned) }
 
   _edata = .;			/* End of data section */
 
   . = ALIGN(8192);		/* init_task */
-  .data.init_task : { *(.data.init_task) }
+  .kernel.data.init_task : { *(.kernel.data.init_task) }
 
   /* will be freed after init */
   . = ALIGN(4096);		/* Init code and data */
--- gc.0/arch/m68k/kernel/head.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/m68k/kernel/head.S	Thu Jul 17 21:07:22 2008
@@ -577,7 +577,7 @@
 #endif
 .endm
 
-.section ".text.head","ax"
+.section ".kernel.text.head","ax"
 ENTRY(_stext)
 /*
  * Version numbers of the bootinfo interface
--- gc.0/arch/m68k/kernel/process.c	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/m68k/kernel/process.c	Thu Jul 17 21:07:22 2008
@@ -48,7 +48,7 @@
 EXPORT_SYMBOL(init_mm);
 
 union thread_union init_thread_union
-__attribute__((section(".data.init_task"), aligned(THREAD_SIZE)))
+__attribute__((section(".kernel.data.init_task"), aligned(THREAD_SIZE)))
        = { INIT_THREAD_INFO(init_task) };
 
 /* initial task structure */
--- gc.0/arch/m68k/kernel/sun3-head.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/m68k/kernel/sun3-head.S	Thu Jul 17 21:07:22 2008
@@ -29,7 +29,7 @@
 .globl kernel_pg_dir
 .equ    kernel_pg_dir,kernel_pmd_table
 
-	.section .text.head
+	.section .kernel.text.head
 ENTRY(_stext)
 ENTRY(_start)
 
--- gc.0/arch/m68k/kernel/vmlinux-std.lds	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/m68k/kernel/vmlinux-std.lds	Thu Jul 17 21:07:22 2008
@@ -11,7 +11,7 @@
   . = 0x1000;
   _text = .;			/* Text and read-only data */
   .text : {
-	*(.text.head)
+	*(.kernel.text.head)
 	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
@@ -36,7 +36,7 @@
   .bss : { *(.bss) }		/* BSS */
 
   . = ALIGN(16);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) } :data
+  .kernel.data.cacheline_aligned : { *(.kernel.data.cacheline_aligned) } :data
 
   _edata = .;			/* End of data section */
 
@@ -76,7 +76,7 @@
   . = ALIGN(8192);
   __init_end = .;
 
-  .data.init_task : { *(.data.init_task) }	/* The initial task and kernel stack */
+  .kernel.data.init_task : { *(.kernel.data.init_task) }	/* The initial task and kernel stack */
 
   _end = . ;
 
--- gc.0/arch/m68k/kernel/vmlinux-sun3.lds	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/m68k/kernel/vmlinux-sun3.lds	Thu Jul 17 21:07:22 2008
@@ -11,7 +11,7 @@
   . = 0xE002000;
   _text = .;			/* Text and read-only data */
   .text : {
-	*(.text.head)
+	*(.kernel.text.head)
 	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
@@ -68,7 +68,7 @@
 #endif
 	. = ALIGN(8192);
 	__init_end = .;
-	.data.init.task : { *(.data.init_task) }
+	.kernel.data.init.task : { *(.kernel.data.init_task) }
 
 
   .bss : { *(.bss) }		/* BSS */
--- gc.0/arch/m68knommu/kernel/init_task.c	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/m68knommu/kernel/init_task.c	Thu Jul 17 21:07:22 2008
@@ -37,6 +37,6 @@
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".kernel.data.init_task"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
--- gc.0/arch/m68knommu/kernel/vmlinux.lds.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/m68knommu/kernel/vmlinux.lds.S	Thu Jul 17 21:07:22 2008
@@ -55,7 +55,7 @@
 	.romvec : {
 		__rom_start = . ;
 		_romvec = .;
-		*(.data.initvect)
+		*(.kernel.data.initvect)
 	} > romvec
 #endif
 
@@ -65,7 +65,7 @@
 		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
-        	*(.text.lock)
+        	*(.kernel.text.lock)
 
 		. = ALIGN(16);          /* Exception table              */
 		__start___ex_table = .;
@@ -147,7 +147,7 @@
 		_sdata = . ;
 		DATA_DATA
 		. = ALIGN(8192) ;
-		*(.data.init_task)
+		*(.kernel.data.init_task)
 		_edata = . ;
 	} > DATA
 
--- gc.0/arch/m68knommu/platform/68360/head-ram.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/m68knommu/platform/68360/head-ram.S	Thu Jul 17 21:07:22 2008
@@ -280,7 +280,7 @@
      * and then overwritten as needed.
      */
  
-.section ".data.initvect","awx"
+.section ".kernel.data.initvect","awx"
     .long   RAMEND	/* Reset: Initial Stack Pointer                 - 0.  */
     .long   _start      /* Reset: Initial Program Counter               - 1.  */
     .long   buserr      /* Bus Error                                    - 2.  */
--- gc.0/arch/m68knommu/platform/68360/head-rom.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/m68knommu/platform/68360/head-rom.S	Thu Jul 17 21:07:22 2008
@@ -291,7 +291,7 @@
      * and then overwritten as needed.
      */
  
-.section ".data.initvect","awx"
+.section ".kernel.data.initvect","awx"
     .long   RAMEND	/* Reset: Initial Stack Pointer                 - 0.  */
     .long   _start      /* Reset: Initial Program Counter               - 1.  */
     .long   buserr      /* Bus Error                                    - 2.  */
--- gc.0/arch/mips/kernel/init_task.c	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/mips/kernel/init_task.c	Thu Jul 17 21:07:22 2008
@@ -27,7 +27,7 @@
  * The things we do for performance..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"),
+	__attribute__((__section__(".kernel.data.init_task"),
 	               __aligned__(THREAD_SIZE))) =
 		{ INIT_THREAD_INFO(init_task) };
 
--- gc.0/arch/mips/kernel/vmlinux.lds.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/mips/kernel/vmlinux.lds.S	Thu Jul 17 21:07:22 2008
@@ -76,7 +76,7 @@
 		 * object file alignment.  Using 32768
 		 */
 		. = ALIGN(_PAGE_SIZE);
-		*(.data.init_task)
+		*(.kernel.data.init_task)
 
 		DATA_DATA
 		CONSTRUCTORS
@@ -98,14 +98,14 @@
 	. = ALIGN(_PAGE_SIZE);
 	.data_nosave : {
 		__nosave_begin = .;
-		*(.data.nosave)
+		*(.kernel.data.nosave)
 	}
 	. = ALIGN(_PAGE_SIZE);
 	__nosave_end = .;
 
 	. = ALIGN(32);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
+	.kernel.data.cacheline_aligned : {
+		*(.kernel.data.cacheline_aligned)
 	}
 	_edata =  .;			/* End of data section */
 
--- gc.0/arch/mips/lasat/image/head.S	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/mips/lasat/image/head.S	Thu Jul 17 21:07:22 2008
@@ -1,7 +1,7 @@
 #include <asm/lasat/head.h>
 
 	.text
-	.section .text.start, "ax"
+	.section .kernel.text.start, "ax"
 	.set noreorder
 	.set mips3
 
--- gc.0/arch/mips/lasat/image/romscript.normal	Thu Jul 17 16:42:29 2008
+++ gc.1/arch/mips/lasat/image/romscript.normal	Thu Jul 17 21:07:22 2008
@@ -4,7 +4,7 @@
 {
   .text :
   {
-    *(.text.start)
+    *(.kernel.text.start)
   }
 
   /* Data in ROM */
--- gc.0/arch/mn10300/kernel/head.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/mn10300/kernel/head.S	Thu Jul 17 21:07:22 2008
@@ -19,7 +19,7 @@
 #include <asm/param.h>
 #include <asm/unit/serial.h>
 
-	.section .text.head,"ax"
+	.section .kernel.text.head,"ax"
 
 ###############################################################################
 #
--- gc.0/arch/mn10300/kernel/init_task.c	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/mn10300/kernel/init_task.c	Thu Jul 17 21:07:22 2008
@@ -32,7 +32,7 @@
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".kernel.data.init_task"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
--- gc.0/arch/mn10300/kernel/vmlinux.lds.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/mn10300/kernel/vmlinux.lds.S	Thu Jul 17 21:07:22 2008
@@ -27,7 +27,7 @@
   _text = .;			/* Text and read-only data */
   .text : {
 	*(
-	.text.head
+	.kernel.text.head
 	.text
 	)
 	TEXT_TEXT
@@ -57,25 +57,25 @@
 
   . = ALIGN(4096);
   __nosave_begin = .;
-  .data_nosave : { *(.data.nosave) }
+  .data_nosave : { *(.kernel.data.nosave) }
   . = ALIGN(4096);
   __nosave_end = .;
 
   . = ALIGN(4096);
-  .data.page_aligned : { *(.data.idt) }
+  .kernel.data.page_aligned : { *(.kernel.data.idt) }
 
   . = ALIGN(32);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
+  .kernel.data.cacheline_aligned : { *(.kernel.data.cacheline_aligned) }
 
   /* rarely changed data like cpu maps */
   . = ALIGN(32);
-  .data.read_mostly : AT(ADDR(.data.read_mostly)) {
-	*(.data.read_mostly)
+  .kernel.data.read_mostly : AT(ADDR(.kernel.data.read_mostly)) {
+	*(.kernel.data.read_mostly)
 	_edata = .;		/* End of data section */
   }
 
   . = ALIGN(THREAD_SIZE);	/* init_task */
-  .data.init_task : { *(.data.init_task) }
+  .kernel.data.init_task : { *(.kernel.data.init_task) }
 
   /* might get freed after init */
   . = ALIGN(4096);
@@ -128,7 +128,7 @@
 
   . = ALIGN(32);
   __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
+  .kernel.data.percpu  : { *(.kernel.data.percpu) }
   __per_cpu_end = .;
   . = ALIGN(4096);
   __init_end = .;
@@ -136,7 +136,7 @@
 
   __bss_start = .;		/* BSS */
   .bss : {
-	*(.bss.page_aligned)
+	*(.bss.kernel.page_aligned)
 	*(.bss)
   }
   . = ALIGN(4);
--- gc.0/arch/parisc/kernel/head.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/parisc/kernel/head.S	Thu Jul 17 21:07:22 2008
@@ -345,7 +345,7 @@
 ENDPROC(stext)
 
 #ifndef CONFIG_64BIT
-	.section .data.read_mostly
+	.section .kernel.data.read_mostly
 
 	.align	4
 	.export	$global$,data
--- gc.0/arch/parisc/kernel/init_task.c	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/parisc/kernel/init_task.c	Thu Jul 17 21:07:22 2008
@@ -49,7 +49,7 @@
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union
-	__attribute__((aligned(128))) __attribute__((__section__(".data.init_task"))) =
+	__attribute__((aligned(128))) __attribute__((__section__(".kernel.data.init_task"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 #if PT_NLEVELS == 3
@@ -58,11 +58,11 @@
  * guarantee that global objects will be laid out in memory in the same order 
  * as the order of declaration, so put these in different sections and use
  * the linker script to order them. */
-pmd_t pmd0[PTRS_PER_PMD] __attribute__ ((__section__ (".data.vm0.pmd"), aligned(PAGE_SIZE)));
+pmd_t pmd0[PTRS_PER_PMD] __attribute__ ((__section__ (".kernel.data.vm0.pmd"), aligned(PAGE_SIZE)));
 #endif
 
-pgd_t swapper_pg_dir[PTRS_PER_PGD] __attribute__ ((__section__ (".data.vm0.pgd"), aligned(PAGE_SIZE)));
-pte_t pg0[PT_INITIAL * PTRS_PER_PTE] __attribute__ ((__section__ (".data.vm0.pte"), aligned(PAGE_SIZE)));
+pgd_t swapper_pg_dir[PTRS_PER_PGD] __attribute__ ((__section__ (".kernel.data.vm0.pgd"), aligned(PAGE_SIZE)));
+pte_t pg0[PT_INITIAL * PTRS_PER_PTE] __attribute__ ((__section__ (".kernel.data.vm0.pte"), aligned(PAGE_SIZE)));
 
 /*
  * Initial task structure.
--- gc.0/arch/parisc/kernel/vmlinux.lds.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/parisc/kernel/vmlinux.lds.S	Thu Jul 17 21:07:22 2008
@@ -94,8 +94,8 @@
 
 	/* rarely changed data like cpu maps */
 	. = ALIGN(16);
-	.data.read_mostly : {
-		*(.data.read_mostly)
+	.kernel.data.read_mostly : {
+		*(.kernel.data.read_mostly)
 	}
 
 	. = ALIGN(L1_CACHE_BYTES);
@@ -106,14 +106,14 @@
 	}
 
 	. = ALIGN(L1_CACHE_BYTES);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
+	.kernel.data.cacheline_aligned : {
+		*(.kernel.data.cacheline_aligned)
 	}
 
 	/* PA-RISC locks requires 16-byte alignment */
 	. = ALIGN(16);
-	.data.lock_aligned : {
-		*(.data.lock_aligned)
+	.kernel.data.lock_aligned : {
+		*(.kernel.data.lock_aligned)
 	}
 
 	/* nosave data is really only used for software suspend...it's here
@@ -122,7 +122,7 @@
 	. = ALIGN(PAGE_SIZE);
 	__nosave_begin = .;
 	.data_nosave : {
-		*(.data.nosave)
+		*(.kernel.data.nosave)
 	}
 	. = ALIGN(PAGE_SIZE);
 	__nosave_end = .;
@@ -134,10 +134,10 @@
 	__bss_start = .;
 	/* page table entries need to be PAGE_SIZE aligned */
 	. = ALIGN(PAGE_SIZE);
-	.data.vmpages : {
-		*(.data.vm0.pmd)
-		*(.data.vm0.pgd)
-		*(.data.vm0.pte)
+	.kernel.data.vmpages : {
+		*(.kernel.data.vm0.pmd)
+		*(.kernel.data.vm0.pgd)
+		*(.kernel.data.vm0.pte)
 	}
 	.bss : {
 		*(.bss)
@@ -149,8 +149,8 @@
 	/* assembler code expects init_task to be 16k aligned */
 	. = ALIGN(16384);
 	/* init_task */
-	.data.init_task : {
-		*(.data.init_task)
+	.kernel.data.init_task : {
+		*(.kernel.data.init_task)
 	}
 
 #ifdef CONFIG_64BIT
--- gc.0/arch/powerpc/kernel/head_32.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/powerpc/kernel/head_32.S	Thu Jul 17 21:07:22 2008
@@ -49,7 +49,7 @@
 	mtspr	SPRN_DBAT##n##L,RB;	\
 1:
 
-	.section	.text.head, "ax"
+	.section	.kernel.text.head, "ax"
 	.stabs	"arch/powerpc/kernel/",N_SO,0,0,0f
 	.stabs	"head_32.S",N_SO,0,0,0f
 0:
--- gc.0/arch/powerpc/kernel/head_40x.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/powerpc/kernel/head_40x.S	Thu Jul 17 21:07:22 2008
@@ -52,7 +52,7 @@
  *
  * This is all going to change RSN when we add bi_recs.......  -- Dan
  */
-	.section	.text.head, "ax"
+	.section	.kernel.text.head, "ax"
 _ENTRY(_stext);
 _ENTRY(_start);
 
--- gc.0/arch/powerpc/kernel/head_44x.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/powerpc/kernel/head_44x.S	Thu Jul 17 21:07:22 2008
@@ -50,7 +50,7 @@
  *   r7 - End of kernel command line string
  *
  */
-	.section	.text.head, "ax"
+	.section	.kernel.text.head, "ax"
 _ENTRY(_stext);
 _ENTRY(_start);
 	/*
--- gc.0/arch/powerpc/kernel/head_8xx.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/powerpc/kernel/head_8xx.S	Thu Jul 17 21:07:22 2008
@@ -38,7 +38,7 @@
 #else
 #define DO_8xx_CPU6(val, reg)
 #endif
-	.section	.text.head, "ax"
+	.section	.kernel.text.head, "ax"
 _ENTRY(_stext);
 _ENTRY(_start);
 
--- gc.0/arch/powerpc/kernel/head_fsl_booke.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/powerpc/kernel/head_fsl_booke.S	Thu Jul 17 21:07:22 2008
@@ -53,7 +53,7 @@
  *   r7 - End of kernel command line string
  *
  */
-	.section	.text.head, "ax"
+	.section	.kernel.text.head, "ax"
 _ENTRY(_stext);
 _ENTRY(_start);
 	/*
--- gc.0/arch/powerpc/kernel/init_task.c	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/powerpc/kernel/init_task.c	Thu Jul 17 21:07:22 2008
@@ -22,7 +22,7 @@
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union 
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".kernel.data.init_task"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
--- gc.0/arch/powerpc/kernel/machine_kexec_64.c	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/powerpc/kernel/machine_kexec_64.c	Thu Jul 17 21:07:22 2008
@@ -250,7 +250,7 @@
  * current, but that audit has not been performed.
  */
 static union thread_union kexec_stack
-	__attribute__((__section__(".data.init_task"))) = { };
+	__attribute__((__section__(".kernel.data.init_task"))) = { };
 
 /* Our assembly helper, in kexec_stub.S */
 extern NORET_TYPE void kexec_sequence(void *newstack, unsigned long start,
--- gc.0/arch/powerpc/kernel/vdso.c	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/powerpc/kernel/vdso.c	Thu Jul 17 21:07:22 2008
@@ -74,7 +74,7 @@
 static union {
 	struct vdso_data	data;
 	u8			page[PAGE_SIZE];
-} vdso_data_store __attribute__((__section__(".data.page_aligned")));
+} vdso_data_store __attribute__((__section__(".kernel.data.page_aligned")));
 struct vdso_data *vdso_data = &vdso_data_store.data;
 
 /* Format of the patch table */
--- gc.0/arch/powerpc/kernel/vdso32/vdso32_wrapper.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/powerpc/kernel/vdso32/vdso32_wrapper.S	Thu Jul 17 21:07:22 2008
@@ -1,7 +1,7 @@
 #include <linux/init.h>
 #include <asm/page.h>
 
-	.section ".data.page_aligned"
+	.section ".kernel.data.page_aligned"
 
 	.globl vdso32_start, vdso32_end
 	.balign PAGE_SIZE
--- gc.0/arch/powerpc/kernel/vdso64/vdso64_wrapper.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/powerpc/kernel/vdso64/vdso64_wrapper.S	Thu Jul 17 21:07:22 2008
@@ -1,7 +1,7 @@
 #include <linux/init.h>
 #include <asm/page.h>
 
-	.section ".data.page_aligned"
+	.section ".kernel.data.page_aligned"
 
 	.globl vdso64_start, vdso64_end
 	.balign PAGE_SIZE
--- gc.0/arch/powerpc/kernel/vmlinux.lds.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/powerpc/kernel/vmlinux.lds.S	Thu Jul 17 21:07:22 2008
@@ -33,9 +33,9 @@
 	/* Text and gots */
 	.text : AT(ADDR(.text) - LOAD_OFFSET) {
 		ALIGN_FUNCTION();
-		*(.text.head)
+		*(.kernel.text.head)
 		_text = .;
-		*(.text .fixup .text.init.refok .exit.text.refok __ftr_alt_*)
+		*(.text .fixup .kernel.text.init.refok .kernel.exit.text.refok __ftr_alt_*)
 		SCHED_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
@@ -148,10 +148,10 @@
 	}
 #endif
 	. = ALIGN(PAGE_SIZE);
-	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
+	.kernel.data.percpu  : AT(ADDR(.kernel.data.percpu) - LOAD_OFFSET) {
 		__per_cpu_start = .;
-		*(.data.percpu)
-		*(.data.percpu.shared_aligned)
+		*(.kernel.data.percpu)
+		*(.kernel.data.percpu.shared_aligned)
 		__per_cpu_end = .;
 	}
 
@@ -208,28 +208,28 @@
 #else
 	. = ALIGN(16384);
 #endif
-	.data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
-		*(.data.init_task)
+	.kernel.data.init_task : AT(ADDR(.kernel.data.init_task) - LOAD_OFFSET) {
+		*(.kernel.data.init_task)
 	}
 
 	. = ALIGN(PAGE_SIZE);
-	.data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
-		*(.data.page_aligned)
+	.kernel.data.page_aligned : AT(ADDR(.kernel.data.page_aligned) - LOAD_OFFSET) {
+		*(.kernel.data.page_aligned)
 	}
 
-	.data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
-		*(.data.cacheline_aligned)
+	.kernel.data.cacheline_aligned : AT(ADDR(.kernel.data.cacheline_aligned) - LOAD_OFFSET) {
+		*(.kernel.data.cacheline_aligned)
 	}
 
 	. = ALIGN(L1_CACHE_BYTES);
-	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
-		*(.data.read_mostly)
+	.kernel.data.read_mostly : AT(ADDR(.kernel.data.read_mostly) - LOAD_OFFSET) {
+		*(.kernel.data.read_mostly)
 	}
 
 	. = ALIGN(PAGE_SIZE);
 	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
 		__nosave_begin = .;
-		*(.data.nosave)
+		*(.kernel.data.nosave)
 		. = ALIGN(PAGE_SIZE);
 		__nosave_end = .;
 	}
--- gc.0/arch/s390/kernel/head.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/s390/kernel/head.S	Thu Jul 17 21:07:22 2008
@@ -35,7 +35,7 @@
 #define ARCH_OFFSET	0
 #endif
 
-.section ".text.head","ax"
+.section ".kernel.text.head","ax"
 #ifndef CONFIG_IPL
 	.org   0
 	.long  0x00080000,0x80000000+startup	# Just a restart PSW
--- gc.0/arch/s390/kernel/init_task.c	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/s390/kernel/init_task.c	Thu Jul 17 21:07:22 2008
@@ -31,7 +31,7 @@
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union 
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".kernel.data.init_task"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
--- gc.0/arch/s390/kernel/vmlinux.lds.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/s390/kernel/vmlinux.lds.S	Thu Jul 17 21:07:22 2008
@@ -28,7 +28,7 @@
 	. = 0x00000000;
 	.text : {
 	_text = .;		/* Text and read-only data */
-		*(.text.head)
+		*(.kernel.text.head)
 	TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
@@ -65,30 +65,30 @@
 	. = ALIGN(PAGE_SIZE);
 	.data_nosave : {
 	__nosave_begin = .;
-		*(.data.nosave)
+		*(.kernel.data.nosave)
 	}
 	. = ALIGN(PAGE_SIZE);
 	__nosave_end = .;
 
 	. = ALIGN(PAGE_SIZE);
-	.data.page_aligned : {
-		*(.data.idt)
+	.kernel.data.page_aligned : {
+		*(.kernel.data.idt)
 	}
 
 	. = ALIGN(0x100);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
+	.kernel.data.cacheline_aligned : {
+		*(.kernel.data.cacheline_aligned)
 	}
 
 	. = ALIGN(0x100);
-	.data.read_mostly : {
-		*(.data.read_mostly)
+	.kernel.data.read_mostly : {
+		*(.kernel.data.read_mostly)
 	}
 	_edata = .;		/* End of data section */
 
 	. = ALIGN(2 * PAGE_SIZE);	/* init_task */
-	.data.init_task : {
-		*(.data.init_task)
+	.kernel.data.init_task : {
+		*(.kernel.data.init_task)
 	}
 
 	/* will be freed after init */
--- gc.0/arch/sh/kernel/cpu/sh5/entry.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/sh/kernel/cpu/sh5/entry.S	Thu Jul 17 21:07:22 2008
@@ -2063,10 +2063,10 @@
 
 
 /*
- * --- .text.init Section
+ * --- .kernel.text.init Section
  */
 
-	.section	.text.init, "ax"
+	.section	.kernel.text.init, "ax"
 
 /*
  * void trap_init (void)
--- gc.0/arch/sh/kernel/head_32.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/sh/kernel/head_32.S	Thu Jul 17 21:07:22 2008
@@ -40,7 +40,7 @@
 1:
 	.skip	PAGE_SIZE - empty_zero_page - 1b
 
-	.section	.text.head, "ax"
+	.section	.kernel.text.head, "ax"
 
 /*
  * Condition at the entry of _stext:
--- gc.0/arch/sh/kernel/head_64.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/sh/kernel/head_64.S	Thu Jul 17 21:07:22 2008
@@ -110,7 +110,7 @@
 fpu_in_use:	.quad	0
 
 
-	.section	.text.head, "ax"
+	.section	.kernel.text.head, "ax"
 	.balign L1_CACHE_BYTES
 /*
  * Condition at the entry of __stext:
--- gc.0/arch/sh/kernel/init_task.c	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/sh/kernel/init_task.c	Thu Jul 17 21:07:22 2008
@@ -22,7 +22,7 @@
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".kernel.data.init_task"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
--- gc.0/arch/sh/kernel/irq.c	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/sh/kernel/irq.c	Thu Jul 17 21:07:22 2008
@@ -158,10 +158,10 @@
 
 #ifdef CONFIG_IRQSTACKS
 static char softirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__section__(".bss.page_aligned")));
+		__attribute__((__section__(".bss.kernel.page_aligned")));
 
 static char hardirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__section__(".bss.page_aligned")));
+		__attribute__((__section__(".bss.kernel.page_aligned")));
 
 /*
  * allocate per-cpu stacks for hardirq and for softirq processing
--- gc.0/arch/sh/kernel/vmlinux_32.lds.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/sh/kernel/vmlinux_32.lds.S	Thu Jul 17 21:07:22 2008
@@ -28,7 +28,7 @@
 	} = 0
 
 	.text : {
-		*(.text.head)
+		*(.kernel.text.head)
 		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
@@ -58,19 +58,19 @@
 
 	. = ALIGN(THREAD_SIZE);
 	.data : {			/* Data */
-		*(.data.init_task)
+		*(.kernel.data.init_task)
 
 		. = ALIGN(L1_CACHE_BYTES);
-		*(.data.cacheline_aligned)
+		*(.kernel.data.cacheline_aligned)
 
 		. = ALIGN(L1_CACHE_BYTES);
-		*(.data.read_mostly)
+		*(.kernel.data.read_mostly)
 
 		. = ALIGN(PAGE_SIZE);
-		*(.data.page_aligned)
+		*(.kernel.data.page_aligned)
 
 		__nosave_begin = .;
-		*(.data.nosave)
+		*(.kernel.data.nosave)
 		. = ALIGN(PAGE_SIZE);
 		__nosave_end = .;
 
@@ -128,7 +128,7 @@
 	.bss : {
 		__init_end = .;
 		__bss_start = .;		/* BSS */
-		*(.bss.page_aligned)
+		*(.bss.kernel.page_aligned)
 		*(.bss)
 		*(COMMON)
 		. = ALIGN(4);
--- gc.0/arch/sh/kernel/vmlinux_64.lds.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/sh/kernel/vmlinux_64.lds.S	Thu Jul 17 21:07:22 2008
@@ -42,7 +42,7 @@
 	} = 0
 
 	.text : C_PHYS(.text) {
-		*(.text.head)
+		*(.kernel.text.head)
 		TEXT_TEXT
 		*(.text64)
 		*(.text..SHmedia32)
@@ -70,19 +70,19 @@
 
 	. = ALIGN(THREAD_SIZE);
 	.data : C_PHYS(.data) {			/* Data */
-		*(.data.init_task)
+		*(.kernel.data.init_task)
 
 		. = ALIGN(L1_CACHE_BYTES);
-		*(.data.cacheline_aligned)
+		*(.kernel.data.cacheline_aligned)
 
 		. = ALIGN(L1_CACHE_BYTES);
-		*(.data.read_mostly)
+		*(.kernel.data.read_mostly)
 
 		. = ALIGN(PAGE_SIZE);
-		*(.data.page_aligned)
+		*(.kernel.data.page_aligned)
 
 		__nosave_begin = .;
-		*(.data.nosave)
+		*(.kernel.data.nosave)
 		. = ALIGN(PAGE_SIZE);
 		__nosave_end = .;
 
@@ -140,7 +140,7 @@
 	.bss : C_PHYS(.bss) {
 		__init_end = .;
 		__bss_start = .;		/* BSS */
-		*(.bss.page_aligned)
+		*(.bss.kernel.page_aligned)
 		*(.bss)
 		*(COMMON)
 		. = ALIGN(4);
--- gc.0/arch/sparc/boot/btfixupprep.c	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/sparc/boot/btfixupprep.c	Thu Jul 17 21:07:22 2008
@@ -171,7 +171,7 @@
 			}
 		} else if (buffer[nbase+4] != '_')
 			continue;
-		if (!strcmp (sect, ".text.exit"))
+		if (!strcmp (sect, ".kernel.text.exit"))
 			continue;
 		if (strcmp (sect, ".text") &&
 		    strcmp (sect, ".init.text") &&
@@ -325,7 +325,7 @@
 		(*rr)->next = NULL;
 	}
 	printf("! Generated by btfixupprep. Do not edit.\n\n");
-	printf("\t.section\t\".data.init\",#alloc,#write\n\t.align\t4\n\n");
+	printf("\t.section\t\".kernel.data.init\",#alloc,#write\n\t.align\t4\n\n");
 	printf("\t.global\t___btfixup_start\n___btfixup_start:\n\n");
 	for (i = 0; i < last; i++) {
 		f = array + i;
--- gc.0/arch/sparc/kernel/head.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/sparc/kernel/head.S	Thu Jul 17 21:07:22 2008
@@ -742,7 +742,7 @@
 		 nop
 
 /* The code above should be at beginning and we have to take care about
- * short jumps, as branching to .text.init section from .text is usually
+ * short jumps, as branching to .kernel.text.init section from .text is usually
  * impossible */
 		__INIT
 /* Acquire boot time privileged register values, this will help debugging.
--- gc.0/arch/sparc/kernel/vmlinux.lds.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/sparc/kernel/vmlinux.lds.S	Thu Jul 17 21:07:22 2008
@@ -86,12 +86,12 @@
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
 	. = ALIGN(32);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
+	.kernel.data.cacheline_aligned : {
+		*(.kernel.data.cacheline_aligned)
 	}
 	. = ALIGN(32);
-	.data.read_mostly : {
-		*(.data.read_mostly)
+	.kernel.data.read_mostly : {
+		*(.kernel.data.read_mostly)
 	}
 
 	__bss_start = .;
--- gc.0/arch/sparc64/kernel/head.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/sparc64/kernel/head.S	Thu Jul 17 21:07:22 2008
@@ -466,7 +466,7 @@
 	jmpl    %g2 + %g0, %g0
 	 nop
 
-	.section	.text.init.refok
+	.section	.kernel.text.init.refok
 sun4u_init:
 	BRANCH_IF_SUN4V(g1, sun4v_init)
 
--- gc.0/arch/sparc64/kernel/vmlinux.lds.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/sparc64/kernel/vmlinux.lds.S	Thu Jul 17 21:07:22 2008
@@ -32,12 +32,12 @@
 		*(.data1)
 	}
 	. = ALIGN(64);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
+	.kernel.data.cacheline_aligned : {
+		*(.kernel.data.cacheline_aligned)
 	}
 	. = ALIGN(64);
-	.data.read_mostly : {
-		*(.data.read_mostly)
+	.kernel.data.read_mostly : {
+		*(.kernel.data.read_mostly)
 	}
 	_edata = .;
 	PROVIDE (edata = .);
--- gc.0/arch/um/kernel/dyn.lds.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/um/kernel/dyn.lds.S	Thu Jul 17 21:07:22 2008
@@ -97,9 +97,9 @@
   .fini_array     : { *(.fini_array) }
   .data           : {
     . = ALIGN(KERNEL_STACK_SIZE);		/* init_task */
-    *(.data.init_task)
+    *(.kernel.data.init_task)
     . = ALIGN(KERNEL_STACK_SIZE);
-    *(.data.init_irqstack)
+    *(.kernel.data.init_irqstack)
     DATA_DATA
     *(.data.* .gnu.linkonce.d.*)
     SORT(CONSTRUCTORS)
--- gc.0/arch/um/kernel/init_task.c	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/um/kernel/init_task.c	Thu Jul 17 21:07:22 2008
@@ -35,9 +35,9 @@
  */
 
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".kernel.data.init_task"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 union thread_union cpu0_irqstack
-	__attribute__((__section__(".data.init_irqstack"))) =
+	__attribute__((__section__(".kernel.data.init_irqstack"))) =
 		{ INIT_THREAD_INFO(init_task) };
--- gc.0/arch/um/kernel/uml.lds.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/um/kernel/uml.lds.S	Thu Jul 17 21:07:22 2008
@@ -53,9 +53,9 @@
   .data    :
   {
     . = ALIGN(KERNEL_STACK_SIZE);		/* init_task */
-    *(.data.init_task)
+    *(.kernel.data.init_task)
     . = ALIGN(KERNEL_STACK_SIZE);
-    *(.data.init_irqstack)
+    *(.kernel.data.init_irqstack)
     DATA_DATA
     *(.gnu.linkonce.d*)
     CONSTRUCTORS
--- gc.0/arch/v850/kernel/vmlinux.lds.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/v850/kernel/vmlinux.lds.S	Thu Jul 17 21:07:22 2008
@@ -95,8 +95,8 @@
 		TEXT_TEXT						      \
 		SCHED_TEXT						      \
 			*(.exit.text)	/* 2.5 convention */		      \
-			*(.text.exit)	/* 2.4 convention */		      \
-			*(.text.lock)					      \
+			*(.kernel.text.exit)	/* 2.4 convention */	      \
+			*(.kernel.text.lock)				      \
 			*(.exitcall.exit)				      \
 		__real_etext = . ;	/* There may be data after here.  */  \
 		RODATA_CONTENTS						      \
@@ -115,11 +115,11 @@
 		__sdata = . ;						      \
 		DATA_DATA						      \
 			EXIT_DATA	/* 2.5 convention */		      \
-			*(.data.exit)	/* 2.4 convention */		      \
+			*(.kernel.data.exit)	/* 2.4 convention */	      \
 		. = ALIGN (16) ;					      \
-		*(.data.cacheline_aligned)				      \
+		*(.kernel.data.cacheline_aligned)			      \
 		. = ALIGN (0x2000) ;					      \
-        	*(.data.init_task)					      \
+        	*(.kernel.data.init_task)				      \
 		. = ALIGN (0x2000) ;					      \
 		__edata = . ;
 
@@ -160,8 +160,8 @@
 			INIT_TEXT	/* 2.5 convention */		      \
 			__einittext = .;				      \
 			INIT_DATA					      \
-			*(.text.init)	/* 2.4 convention */		      \
-			*(.data.init)					      \
+			*(.kernel.text.init)	/* 2.4 convention */	      \
+			*(.kernel.data.init)				      \
 		INITCALL_CONTENTS					      \
 		INITRAMFS_CONTENTS
 
@@ -171,7 +171,7 @@
 		. = ALIGN (4096) ;					      \
 		__init_start = . ;					      \
 			INIT_DATA	/* 2.5 convention */		      \
-			*(.data.init)	/* 2.4 convention */		      \
+			*(.kernel.data.init)	/* 2.4 convention */	      \
 		__init_end = . ;					      \
 		. = ALIGN (4096) ;
 
@@ -181,7 +181,7 @@
 			_sinittext = .;					      \
 			INIT_TEXT	/* 2.5 convention */		      \
 			_einittext = .;					      \
-			*(.text.init)	/* 2.4 convention */		      \
+			*(.kernel.text.init)	/* 2.4 convention */	      \
 		INITCALL_CONTENTS					      \
 		INITRAMFS_CONTENTS
 
--- gc.0/arch/x86/boot/compressed/head_32.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/x86/boot/compressed/head_32.S	Thu Jul 17 21:07:22 2008
@@ -29,7 +29,7 @@
 #include <asm/boot.h>
 #include <asm/asm-offsets.h>
 
-.section ".text.head","ax",@progbits
+.section ".kernel.text.head","ax",@progbits
 	.globl startup_32
 
 startup_32:
--- gc.0/arch/x86/boot/compressed/head_64.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/x86/boot/compressed/head_64.S	Thu Jul 17 21:07:22 2008
@@ -33,7 +33,7 @@
 #include <asm/processor-flags.h>
 #include <asm/asm-offsets.h>
 
-.section ".text.head"
+.section ".kernel.text.head","ax",@progbits
 	.code32
 	.globl startup_32
 
--- gc.0/arch/x86/boot/compressed/vmlinux.scr	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/x86/boot/compressed/vmlinux.scr	Thu Jul 17 21:07:22 2008
@@ -1,6 +1,6 @@
 SECTIONS
 {
-  .rodata.compressed : {
+  .kernel.rodata.compressed : {
 	input_len = .;
 	LONG(input_data_end - input_data) input_data = .;
 	*(.data)
--- gc.0/arch/x86/boot/compressed/vmlinux_32.lds	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/x86/boot/compressed/vmlinux_32.lds	Thu Jul 17 21:08:52 2008
@@ -7,23 +7,23 @@
 	 * address 0.
 	 */
 	. = 0;
-	.text.head : {
+	.kernel.text.head : {
 		_head = . ;
-		*(.text.head)
+		*(.kernel.text.head)
 		_ehead = . ;
 	}
-	.rodata.compressed : {
-		*(.rodata.compressed)
+	.kernel.rodata.compressed : {
+		*(.kernel.rodata.compressed)
 	}
 	.text :	{
-		_text = .; 	/* Text */
+		_text = .;
 		*(.text)
 		*(.text.*)
 		_etext = . ;
 	}
 	.rodata : {
 		_rodata = . ;
-		*(.rodata)	 /* read-only data */
+		*(.rodata)
 		*(.rodata.*)
 		_erodata = . ;
 	}
@@ -40,4 +40,6 @@
 		*(COMMON)
 		_end = . ;
 	}
+	/* Be bold, and discard everything not explicitly mentioned */
+	/DISCARD/ : { *(*) }
 }
--- gc.0/arch/x86/boot/compressed/vmlinux_64.lds	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/x86/boot/compressed/vmlinux_64.lds	Thu Jul 17 21:08:35 2008
@@ -7,23 +7,23 @@
 	 * address 0.
 	 */
 	. = 0;
-	.text.head : {
+	.kernel.text.head : {
 		_head = . ;
-		*(.text.head)
+		*(.kernel.text.head)
 		_ehead = . ;
 	}
-	.rodata.compressed : {
-		*(.rodata.compressed)
+	.kernel.rodata.compressed : {
+		*(.kernel.rodata.compressed)
 	}
 	.text :	{
-		_text = .; 	/* Text */
+		_text = .;
 		*(.text)
 		*(.text.*)
 		_etext = . ;
 	}
 	.rodata : {
 		_rodata = . ;
-		*(.rodata)	 /* read-only data */
+		*(.rodata)
 		*(.rodata.*)
 		_erodata = . ;
 	}
@@ -45,4 +45,6 @@
 		. = . + 4096 * 6;
 		_ebss = .;
 	}
+	/* Be bold, and discard everything not explicitly mentioned */
+	/DISCARD/ : { *(*) }
 }
--- gc.0/arch/x86/kernel/acpi/wakeup_32.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/x86/kernel/acpi/wakeup_32.S	Thu Jul 17 21:07:22 2008
@@ -1,4 +1,4 @@
-	.section .text.page_aligned
+	.section .kernel.text.page_aligned
 #include <linux/linkage.h>
 #include <asm/segment.h>
 #include <asm/page.h>
--- gc.0/arch/x86/kernel/cpu/common_64.c	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/x86/kernel/cpu/common_64.c	Thu Jul 17 21:07:22 2008
@@ -518,7 +518,7 @@
 
 char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ +
 			   DEBUG_STKSZ]
-__attribute__((section(".bss.page_aligned")));
+__attribute__((section(".bss.kernel.page_aligned")));
 
 extern asmlinkage void ignore_sysret(void);
 
--- gc.0/arch/x86/kernel/head_32.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/x86/kernel/head_32.S	Thu Jul 17 21:07:22 2008
@@ -81,7 +81,7 @@
  * any particular GDT layout, because we load our own as soon as we
  * can.
  */
-.section .text.head,"ax",@progbits
+.section .kernel.text.head,"ax",@progbits
 ENTRY(startup_32)
 	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
 		us to not reload segments */
@@ -611,7 +611,7 @@
 /*
  * BSS section
  */
-.section ".bss.page_aligned","wa"
+.section ".bss.kernel.page_aligned","wa"
 	.align PAGE_SIZE_asm
 #ifdef CONFIG_X86_PAE
 swapper_pg_pmd:
@@ -628,7 +628,7 @@
  * This starts the data section.
  */
 #ifdef CONFIG_X86_PAE
-.section ".data.page_aligned","wa"
+.section ".kernel.data.page_aligned","wa"
 	/* Page-aligned for the benefit of paravirt? */
 	.align PAGE_SIZE_asm
 ENTRY(swapper_pg_dir)
--- gc.0/arch/x86/kernel/head_64.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/x86/kernel/head_64.S	Thu Jul 17 21:07:22 2008
@@ -40,7 +40,7 @@
 L3_START_KERNEL = pud_index(__START_KERNEL_map)
 
 	.text
-	.section .text.head
+	.section .kernel.text.head
 	.code64
 	.globl startup_64
 startup_64:
@@ -413,7 +413,7 @@
 ENTRY(idt_table)
 	.skip 256 * 16
 
-	.section .bss.page_aligned, "aw", @nobits
+	.section .bss.kernel.page_aligned, "aw", @nobits
 	.align PAGE_SIZE
 ENTRY(empty_zero_page)
 	.skip PAGE_SIZE
--- gc.0/arch/x86/kernel/init_task.c	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/x86/kernel/init_task.c	Thu Jul 17 21:07:22 2008
@@ -24,7 +24,7 @@
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".kernel.data.init_task"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
@@ -38,7 +38,7 @@
 /*
  * per-CPU TSS segments. Threads are completely 'soft' on Linux,
  * no more per-task TSS's. The TSS size is kept cacheline-aligned
- * so they are allowed to end up in the .data.cacheline_aligned
+ * so they are allowed to end up in the .kernel.data.cacheline_aligned
  * section. Since TSS's are completely CPU-local, we want them
  * on exact cacheline boundaries, to eliminate cacheline ping-pong.
  */
--- gc.0/arch/x86/kernel/irq_32.c	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/x86/kernel/irq_32.c	Thu Jul 17 21:07:22 2008
@@ -84,10 +84,10 @@
 static union irq_ctx *softirq_ctx[NR_CPUS] __read_mostly;
 
 static char softirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__section__(".bss.page_aligned")));
+		__attribute__((__section__(".bss.kernel.page_aligned")));
 
 static char hardirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__section__(".bss.page_aligned")));
+		__attribute__((__section__(".bss.kernel.page_aligned")));
 
 static void call_on_stack(void *func, void *stack)
 {
--- gc.0/arch/x86/kernel/traps_32.c	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/x86/kernel/traps_32.c	Thu Jul 17 21:07:22 2008
@@ -75,7 +75,7 @@
  * for this.
  */
 gate_desc idt_table[256]
-	__attribute__((__section__(".data.idt"))) = { { { { 0, 0 } } }, };
+	__attribute__((__section__(".kernel.data.idt"))) = { { { { 0, 0 } } }, };
 
 asmlinkage void divide_error(void);
 asmlinkage void debug(void);
--- gc.0/arch/x86/kernel/vmlinux_32.lds.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/x86/kernel/vmlinux_32.lds.S	Thu Jul 17 21:07:22 2008
@@ -31,15 +31,15 @@
   . = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
   phys_startup_32 = startup_32 - LOAD_OFFSET;
 
-  .text.head : AT(ADDR(.text.head) - LOAD_OFFSET) {
+  .kernel.text.head : AT(ADDR(.kernel.text.head) - LOAD_OFFSET) {
   	_text = .;			/* Text and read-only data */
-	*(.text.head)
+	*(.kernel.text.head)
   } :text = 0x9090
 
   /* read-only */
   .text : AT(ADDR(.text) - LOAD_OFFSET) {
 	. = ALIGN(PAGE_SIZE); /* not really needed, already page aligned */
-	*(.text.page_aligned)
+	*(.kernel.text.page_aligned)
 	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
@@ -70,32 +70,32 @@
   . = ALIGN(PAGE_SIZE);
   .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
   	__nosave_begin = .;
-	*(.data.nosave)
+	*(.kernel.data.nosave)
   	. = ALIGN(PAGE_SIZE);
   	__nosave_end = .;
   }
 
   . = ALIGN(PAGE_SIZE);
-  .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
-	*(.data.page_aligned)
-	*(.data.idt)
+  .kernel.data.page_aligned : AT(ADDR(.kernel.data.page_aligned) - LOAD_OFFSET) {
+	*(.kernel.data.page_aligned)
+	*(.kernel.data.idt)
   }
 
   . = ALIGN(32);
-  .data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
-	*(.data.cacheline_aligned)
+  .kernel.data.cacheline_aligned : AT(ADDR(.kernel.data.cacheline_aligned) - LOAD_OFFSET) {
+	*(.kernel.data.cacheline_aligned)
   }
 
   /* rarely changed data like cpu maps */
   . = ALIGN(32);
-  .data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
-	*(.data.read_mostly)
+  .kernel.data.read_mostly : AT(ADDR(.kernel.data.read_mostly) - LOAD_OFFSET) {
+	*(.kernel.data.read_mostly)
 	_edata = .;		/* End of data section */
   }
 
   . = ALIGN(THREAD_SIZE);	/* init_task */
-  .data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
-	*(.data.init_task)
+  .kernel.data.init_task : AT(ADDR(.kernel.data.init_task) - LOAD_OFFSET) {
+	*(.kernel.data.init_task)
   }
 
   /* might get freed after init */
@@ -178,10 +178,10 @@
   }
 #endif
   . = ALIGN(PAGE_SIZE);
-  .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
+  .kernel.data.percpu  : AT(ADDR(.kernel.data.percpu) - LOAD_OFFSET) {
 	__per_cpu_start = .;
-	*(.data.percpu)
-	*(.data.percpu.shared_aligned)
+	*(.kernel.data.percpu)
+	*(.kernel.data.percpu.shared_aligned)
 	__per_cpu_end = .;
   }
   . = ALIGN(PAGE_SIZE);
@@ -190,7 +190,7 @@
   .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
 	__init_end = .;
 	__bss_start = .;		/* BSS */
-	*(.bss.page_aligned)
+	*(.bss.kernel.page_aligned)
 	*(.bss)
 	. = ALIGN(4);
 	__bss_stop = .;
--- gc.0/arch/x86/kernel/vmlinux_64.lds.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/x86/kernel/vmlinux_64.lds.S	Thu Jul 17 21:07:22 2008
@@ -28,7 +28,7 @@
   _text = .;			/* Text and read-only data */
   .text :  AT(ADDR(.text) - LOAD_OFFSET) {
 	/* First the code that has to be first for bootstrapping */
-	*(.text.head)
+	*(.kernel.text.head)
 	_stext = .;
 	/* Then the rest */
 	TEXT_TEXT
@@ -62,17 +62,17 @@
 
   . = ALIGN(PAGE_SIZE);
   . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-  .data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
-	*(.data.cacheline_aligned)
+  .kernel.data.cacheline_aligned : AT(ADDR(.kernel.data.cacheline_aligned) - LOAD_OFFSET) {
+	*(.kernel.data.cacheline_aligned)
   }
   . = ALIGN(CONFIG_X86_INTERNODE_CACHE_BYTES);
-  .data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
-  	*(.data.read_mostly)
+  .kernel.data.read_mostly : AT(ADDR(.kernel.data.read_mostly) - LOAD_OFFSET) {
+  	*(.kernel.data.read_mostly)
   }
 
 #define VSYSCALL_ADDR (-10*1024*1024)
-#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data.read_mostly) + SIZEOF(.data.read_mostly) + 4095) & ~(4095))
-#define VSYSCALL_VIRT_ADDR ((ADDR(.data.read_mostly) + SIZEOF(.data.read_mostly) + 4095) & ~(4095))
+#define VSYSCALL_PHYS_ADDR ((LOADADDR(.kernel.data.read_mostly) + SIZEOF(.kernel.data.read_mostly) + 4095) & ~(4095))
+#define VSYSCALL_VIRT_ADDR ((ADDR(.kernel.data.read_mostly) + SIZEOF(.kernel.data.read_mostly) + 4095) & ~(4095))
 
 #define VLOAD_OFFSET (VSYSCALL_ADDR - VSYSCALL_PHYS_ADDR)
 #define VLOAD(x) (ADDR(x) - VLOAD_OFFSET)
@@ -121,13 +121,13 @@
 #undef VVIRT
 
   . = ALIGN(THREAD_SIZE);	/* init_task */
-  .data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
-	*(.data.init_task)
+  .kernel.data.init_task : AT(ADDR(.kernel.data.init_task) - LOAD_OFFSET) {
+	*(.kernel.data.init_task)
   }:data.init
 
   . = ALIGN(PAGE_SIZE);
-  .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
-	*(.data.page_aligned)
+  .kernel.data.page_aligned : AT(ADDR(.kernel.data.page_aligned) - LOAD_OFFSET) {
+	*(.kernel.data.page_aligned)
   }
 
   /* might get freed after init */
@@ -215,13 +215,13 @@
 
   . = ALIGN(PAGE_SIZE);
   __nosave_begin = .;
-  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) { *(.data.nosave) }
+  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) { *(.kernel.data.nosave) }
   . = ALIGN(PAGE_SIZE);
   __nosave_end = .;
 
   __bss_start = .;		/* BSS */
   .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
-	*(.bss.page_aligned)
+	*(.bss.kernel.page_aligned)
 	*(.bss)
 	}
   __bss_stop = .;
--- gc.0/arch/x86/xen/mmu.c	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/x86/xen/mmu.c	Thu Jul 17 21:07:22 2008
@@ -61,21 +61,21 @@
 
 /* Placeholder for holes in the address space */
 static unsigned long p2m_missing[P2M_ENTRIES_PER_PAGE]
-	__attribute__((section(".data.page_aligned"))) =
+	__attribute__((section(".kernel.data.page_aligned"))) =
 		{ [ 0 ... P2M_ENTRIES_PER_PAGE-1 ] = ~0UL };
 
  /* Array of pointers to pages containing p2m entries */
 static unsigned long *p2m_top[TOP_ENTRIES]
-	__attribute__((section(".data.page_aligned"))) =
+	__attribute__((section(".kernel.data.page_aligned"))) =
 		{ [ 0 ... TOP_ENTRIES - 1] = &p2m_missing[0] };
 
 /* Arrays of p2m arrays expressed in mfns used for save/restore */
 static unsigned long p2m_top_mfn[TOP_ENTRIES]
-	__attribute__((section(".bss.page_aligned")));
+	__attribute__((section(".bss.kernel.page_aligned")));
 
 static unsigned long p2m_top_mfn_list[
 			PAGE_ALIGN(TOP_ENTRIES / P2M_ENTRIES_PER_PAGE)]
-	__attribute__((section(".bss.page_aligned")));
+	__attribute__((section(".bss.kernel.page_aligned")));
 
 static inline unsigned p2m_top_index(unsigned long pfn)
 {
--- gc.0/arch/xtensa/kernel/head.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/xtensa/kernel/head.S	Thu Jul 17 21:07:22 2008
@@ -234,7 +234,7 @@
  * BSS section
  */
 	
-.section ".bss.page_aligned", "w"
+.section ".bss.kernel.page_aligned", "w"
 ENTRY(swapper_pg_dir)
 	.fill	PAGE_SIZE, 1, 0
 ENTRY(empty_zero_page)
--- gc.0/arch/xtensa/kernel/init_task.c	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/xtensa/kernel/init_task.c	Thu Jul 17 21:07:22 2008
@@ -29,7 +29,7 @@
 EXPORT_SYMBOL(init_mm);
 
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".kernel.data.init_task"))) =
 { INIT_THREAD_INFO(init_task) };
 
 struct task_struct init_task = INIT_TASK(init_task);
--- gc.0/arch/xtensa/kernel/vmlinux.lds.S	Thu Jul 17 16:42:30 2008
+++ gc.1/arch/xtensa/kernel/vmlinux.lds.S	Thu Jul 17 21:07:22 2008
@@ -121,14 +121,14 @@
     DATA_DATA
     CONSTRUCTORS
     . = ALIGN(XCHAL_ICACHE_LINESIZE);
-    *(.data.cacheline_aligned)
+    *(.kernel.data.cacheline_aligned)
   }
 
   _edata = .;
 
   /* The initial task */
   . = ALIGN(8192);
-  .data.init_task : { *(.data.init_task) }
+  .kernel.data.init_task : { *(.kernel.data.init_task) }
 
   /* Initialization code and data: */
 
@@ -259,7 +259,7 @@
 
   /* BSS section */
   _bss_start = .;
-  .bss : { *(.bss.page_aligned) *(.bss) }
+  .bss : { *(.bss.kernel.page_aligned) *(.bss) }
   _bss_end = .;
 
   _end = .;
--- gc.0/include/asm-frv/init.h	Thu Jul 17 16:42:35 2008
+++ gc.1/include/asm-frv/init.h	Thu Jul 17 21:07:22 2008
@@ -1,12 +1,12 @@
 #ifndef _ASM_INIT_H
 #define _ASM_INIT_H
 
-#define __init __attribute__ ((__section__ (".text.init")))
-#define __initdata __attribute__ ((__section__ (".data.init")))
+#define __init __attribute__ ((__section__ (".kernel.text.init")))
+#define __initdata __attribute__ ((__section__ (".kernel.data.init")))
 /* For assembly routines */
-#define __INIT		.section	".text.init",#alloc,#execinstr
+#define __INIT		.section	".kernel.text.init",#alloc,#execinstr
 #define __FINIT		.previous
-#define __INITDATA	.section	".data.init",#alloc,#write
+#define __INITDATA	.section	".kernel.data.init",#alloc,#write
 
 #endif
 
--- gc.0/include/asm-generic/vmlinux.lds.h	Thu Jul 17 16:42:35 2008
+++ gc.1/include/asm-generic/vmlinux.lds.h	Thu Jul 17 21:07:22 2008
@@ -41,7 +41,7 @@
 /* .data section */
 #define DATA_DATA							\
 	*(.data)							\
-	*(.data.init.refok)						\
+	*(.kernel.data.init.refok)					\
 	*(.ref.data)							\
 	DEV_KEEP(init.data)						\
 	DEV_KEEP(exit.data)						\
@@ -223,8 +223,8 @@
 		ALIGN_FUNCTION();					\
 		*(.text)						\
 		*(.ref.text)						\
-		*(.text.init.refok)					\
-		*(.exit.text.refok)					\
+		*(.kernel.text.init.refok)				\
+		*(.kernel.exit.text.refok)				\
 	DEV_KEEP(init.text)						\
 	DEV_KEEP(exit.text)						\
 	CPU_KEEP(init.text)						\
@@ -380,8 +380,8 @@
 #define PERCPU(align)							\
 	. = ALIGN(align);						\
 	__per_cpu_start = .;						\
-	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {		\
-		*(.data.percpu)						\
-		*(.data.percpu.shared_aligned)				\
+	.kernel.data.percpu  : AT(ADDR(.kernel.data.percpu) - LOAD_OFFSET) { \
+		*(.kernel.data.percpu)					\
+		*(.kernel.data.percpu.shared_aligned)			\
 	}								\
 	__per_cpu_end = .;
--- gc.0/include/asm-ia64/asmmacro.h	Thu Jul 17 16:42:35 2008
+++ gc.1/include/asm-ia64/asmmacro.h	Thu Jul 17 21:07:22 2008
@@ -70,12 +70,12 @@
  * path (ivt.S - TLB miss processing) or in places where it might not be
  * safe to use a "tpa" instruction (mca_asm.S - error recovery).
  */
-	.section ".data.patch.vtop", "a"	// declare section & section attributes
+	.section ".kernel.data.patch.vtop", "a"	// declare section & section attributes
 	.previous
 
 #define	LOAD_PHYSICAL(pr, reg, obj)		\
 [1:](pr)movl reg = obj;				\
-	.xdata4 ".data.patch.vtop", 1b-.
+	.xdata4 ".kernel.data.patch.vtop", 1b-.
 
 /*
  * For now, we always put in the McKinley E9 workaround.  On CPUs that don't need it,
@@ -84,11 +84,11 @@
 #define DO_MCKINLEY_E9_WORKAROUND
 
 #ifdef DO_MCKINLEY_E9_WORKAROUND
-	.section ".data.patch.mckinley_e9", "a"
+	.section ".kernel.data.patch.mckinley_e9", "a"
 	.previous
 /* workaround for Itanium 2 Errata 9: */
 # define FSYS_RETURN					\
-	.xdata4 ".data.patch.mckinley_e9", 1f-.;	\
+	.xdata4 ".kernel.data.patch.mckinley_e9", 1f-.;	\
 1:{ .mib;						\
 	nop.m 0;					\
 	mov r16=ar.pfs;					\
@@ -107,11 +107,11 @@
  * If physical stack register size is different from DEF_NUM_STACK_REG,
  * dynamically patch the kernel for correct size.
  */
-	.section ".data.patch.phys_stack_reg", "a"
+	.section ".kernel.data.patch.phys_stack_reg", "a"
 	.previous
 #define LOAD_PHYS_STACK_REG_SIZE(reg)			\
 [1:]	adds reg=IA64_NUM_PHYS_STACK_REG*8+8,r0;	\
-	.xdata4 ".data.patch.phys_stack_reg", 1b-.
+	.xdata4 ".kernel.data.patch.phys_stack_reg", 1b-.
 
 /*
  * Up until early 2004, use of .align within a function caused bad unwind info.
--- gc.0/include/asm-ia64/cache.h	Thu Jul 17 16:42:35 2008
+++ gc.1/include/asm-ia64/cache.h	Thu Jul 17 21:07:22 2008
@@ -24,6 +24,6 @@
 # define SMP_CACHE_BYTES	(1 << 3)
 #endif
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".kernel.data.read_mostly")))
 
 #endif /* _ASM_IA64_CACHE_H */
--- gc.0/include/asm-ia64/percpu.h	Thu Jul 17 16:42:35 2008
+++ gc.1/include/asm-ia64/percpu.h	Thu Jul 17 21:07:22 2008
@@ -27,7 +27,7 @@
 
 #else /* ! SMP */
 
-#define PER_CPU_ATTRIBUTES	__attribute__((__section__(".data.percpu")))
+#define PER_CPU_ATTRIBUTES	__attribute__((__section__(".kernel.data.percpu")))
 
 #define per_cpu_init()				(__phys_per_cpu_start)
 
--- gc.0/include/asm-parisc/cache.h	Thu Jul 17 16:42:36 2008
+++ gc.1/include/asm-parisc/cache.h	Thu Jul 17 21:07:22 2008
@@ -28,7 +28,7 @@
 
 #define SMP_CACHE_BYTES L1_CACHE_BYTES
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".kernel.data.read_mostly")))
 
 void parisc_cache_init(void);	/* initializes cache-flushing */
 void disable_sr_hashing_asm(int); /* low level support for above */
--- gc.0/include/asm-parisc/system.h	Thu Jul 17 16:42:36 2008
+++ gc.1/include/asm-parisc/system.h	Thu Jul 17 21:07:22 2008
@@ -174,7 +174,7 @@
 })
 
 #ifdef CONFIG_SMP
-# define __lock_aligned __attribute__((__section__(".data.lock_aligned")))
+# define __lock_aligned __attribute__((__section__(".kernel.data.lock_aligned")))
 #endif
 
 #define arch_align_stack(x) (x)
--- gc.0/include/asm-powerpc/cache.h	Thu Jul 17 16:42:36 2008
+++ gc.1/include/asm-powerpc/cache.h	Thu Jul 17 21:07:22 2008
@@ -38,7 +38,7 @@
 #endif /* __powerpc64__ && ! __ASSEMBLY__ */
 
 #if !defined(__ASSEMBLY__)
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".kernel.data.read_mostly")))
 #endif
 
 #endif /* __KERNEL__ */
--- gc.0/include/asm-powerpc/page_64.h	Thu Jul 17 16:42:36 2008
+++ gc.1/include/asm-powerpc/page_64.h	Thu Jul 17 21:07:22 2008
@@ -156,7 +156,7 @@
 #else
 #define __page_aligned \
 	__attribute__((__aligned__(PAGE_SIZE), \
-		__section__(".data.page_aligned")))
+		__section__(".kernel.data.page_aligned")))
 #endif
 
 #define VM_DATA_DEFAULT_FLAGS \
--- gc.0/include/asm-powerpc/ppc_asm.h	Thu Jul 17 16:42:36 2008
+++ gc.1/include/asm-powerpc/ppc_asm.h	Thu Jul 17 21:07:22 2008
@@ -193,7 +193,7 @@
 GLUE(.,name):
 
 #define _INIT_GLOBAL(name) \
-	.section ".text.init.refok"; \
+	.section ".kernel.text.init.refok"; \
 	.align 2 ; \
 	.globl name; \
 	.globl GLUE(.,name); \
@@ -233,7 +233,7 @@
 GLUE(.,name):
 
 #define _INIT_STATIC(name) \
-	.section ".text.init.refok"; \
+	.section ".kernel.text.init.refok"; \
 	.align 2 ; \
 	.section ".opd","aw"; \
 name: \
--- gc.0/include/asm-s390/cache.h	Thu Jul 17 16:42:36 2008
+++ gc.1/include/asm-s390/cache.h	Thu Jul 17 21:07:22 2008
@@ -14,6 +14,6 @@
 #define L1_CACHE_BYTES     256
 #define L1_CACHE_SHIFT     8
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".kernel.data.read_mostly")))
 
 #endif
--- gc.0/include/asm-sh/cache.h	Thu Jul 17 16:42:36 2008
+++ gc.1/include/asm-sh/cache.h	Thu Jul 17 21:07:22 2008
@@ -14,7 +14,7 @@
 
 #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".kernel.data.read_mostly")))
 
 #ifndef __ASSEMBLY__
 struct cache_info {
--- gc.0/include/asm-sparc/cache.h	Thu Jul 17 16:42:36 2008
+++ gc.1/include/asm-sparc/cache.h	Thu Jul 17 21:07:22 2008
@@ -19,7 +19,7 @@
 
 #define SMP_CACHE_BYTES (1 << SMP_CACHE_BYTES_SHIFT)
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".kernel.data.read_mostly")))
 
 #ifdef CONFIG_SPARC32
 #include <asm/asi.h>
--- gc.0/include/asm-um/common.lds.S	Thu Jul 17 16:42:36 2008
+++ gc.1/include/asm-um/common.lds.S	Thu Jul 17 21:07:22 2008
@@ -49,9 +49,9 @@
   }
 
   . = ALIGN(32);
-  .data.percpu : {
+  .kernel.data.percpu : {
 	__per_cpu_start = . ;
-	*(.data.percpu)
+	*(.kernel.data.percpu)
 	__per_cpu_end = . ;
   }
 	
--- gc.0/include/asm-x86/cache.h	Thu Jul 17 16:42:36 2008
+++ gc.1/include/asm-x86/cache.h	Thu Jul 17 21:07:22 2008
@@ -5,7 +5,7 @@
 #define L1_CACHE_SHIFT	(CONFIG_X86_L1_CACHE_SHIFT)
 #define L1_CACHE_BYTES	(1 << L1_CACHE_SHIFT)
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".kernel.data.read_mostly")))
 
 #ifdef CONFIG_X86_VSMP
 /* vSMP Internode cacheline shift */
@@ -13,7 +13,7 @@
 #ifdef CONFIG_SMP
 #define __cacheline_aligned_in_smp					\
 	__attribute__((__aligned__(1 << (INTERNODE_CACHE_SHIFT))))	\
-	__attribute__((__section__(".data.page_aligned")))
+	__attribute__((__section__(".kernel.data.page_aligned")))
 #endif
 #endif
 
--- gc.0/include/linux/cache.h	Thu Jul 17 16:42:36 2008
+++ gc.1/include/linux/cache.h	Thu Jul 17 21:07:22 2008
@@ -31,7 +31,7 @@
 #ifndef __cacheline_aligned
 #define __cacheline_aligned					\
   __attribute__((__aligned__(SMP_CACHE_BYTES),			\
-		 __section__(".data.cacheline_aligned")))
+		 __section__(".kernel.data.cacheline_aligned")))
 #endif /* __cacheline_aligned */
 
 #ifndef __cacheline_aligned_in_smp
--- gc.0/include/linux/init.h	Thu Jul 17 16:42:36 2008
+++ gc.1/include/linux/init.h	Thu Jul 17 21:07:22 2008
@@ -62,9 +62,9 @@
 
 /* backward compatibility note
  *  A few places hardcode the old section names:
- *  .text.init.refok
- *  .data.init.refok
- *  .exit.text.refok
+ *  .kernel.text.init.refok
+ *  .kernel.data.init.refok
+ *  .kernel.exit.text.refok
  *  They should be converted to use the defines from this file
  */
 
@@ -299,7 +299,7 @@
 #endif
 
 /* Data marked not to be saved by software suspend */
-#define __nosavedata __section(.data.nosave)
+#define __nosavedata __section(.kernel.data.nosave)
 
 /* This means "can be init if no module support, otherwise module load
    may call it." */
--- gc.0/include/linux/linkage.h	Thu Jul 17 16:42:36 2008
+++ gc.1/include/linux/linkage.h	Thu Jul 17 21:07:22 2008
@@ -20,8 +20,8 @@
 # define asmregparm
 #endif
 
-#define __page_aligned_data	__section(.data.page_aligned) __aligned(PAGE_SIZE)
-#define __page_aligned_bss	__section(.bss.page_aligned) __aligned(PAGE_SIZE)
+#define __page_aligned_data	__section(.kernel.data.page_aligned) __aligned(PAGE_SIZE)
+#define __page_aligned_bss	__section(.bss.kernel.page_aligned) __aligned(PAGE_SIZE)
 
 /*
  * This is used by architectures to keep arguments on the stack
--- gc.0/include/linux/percpu.h	Thu Jul 17 16:42:36 2008
+++ gc.1/include/linux/percpu.h	Thu Jul 17 21:07:22 2008
@@ -10,13 +10,13 @@
 
 #ifdef CONFIG_SMP
 #define DEFINE_PER_CPU(type, name)					\
-	__attribute__((__section__(".data.percpu")))			\
+	__attribute__((__section__(".kernel.data.percpu")))		\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
 
 #ifdef MODULE
-#define SHARED_ALIGNED_SECTION ".data.percpu"
+#define SHARED_ALIGNED_SECTION ".kernel.data.percpu"
 #else
-#define SHARED_ALIGNED_SECTION ".data.percpu.shared_aligned"
+#define SHARED_ALIGNED_SECTION ".kernel.data.percpu.shared_aligned"
 #endif
 
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
--- gc.0/include/linux/spinlock.h	Thu Jul 17 16:42:36 2008
+++ gc.1/include/linux/spinlock.h	Thu Jul 17 21:07:22 2008
@@ -59,7 +59,7 @@
 /*
  * Must define these before including other files, inline functions need them
  */
-#define LOCK_SECTION_NAME ".text.lock."KBUILD_BASENAME
+#define LOCK_SECTION_NAME ".kernel.text.lock."KBUILD_BASENAME
 
 #define LOCK_SECTION_START(extra)               \
         ".subsection 1\n\t"                     \
--- gc.0/kernel/module.c	Thu Jul 17 16:42:37 2008
+++ gc.1/kernel/module.c	Thu Jul 17 21:07:22 2008
@@ -433,7 +433,7 @@
 				 Elf_Shdr *sechdrs,
 				 const char *secstrings)
 {
-	return find_sec(hdr, sechdrs, secstrings, ".data.percpu");
+	return find_sec(hdr, sechdrs, secstrings, ".kernel.data.percpu");
 }
 
 static void percpu_modcopy(void *pcpudest, const void *from, unsigned long size)
--- gc.0/scripts/mod/modpost.c	Thu Jul 17 16:42:38 2008
+++ gc.1/scripts/mod/modpost.c	Thu Jul 17 21:07:22 2008
@@ -794,9 +794,9 @@
 /* sections that may refer to an init/exit section with no warning */
 static const char *initref_sections[] =
 {
-	".text.init.refok*",
-	".exit.text.refok*",
-	".data.init.refok*",
+	".kernel.text.init.refok*",
+	".kernel.exit.text.refok*",
+	".kernel.data.init.refok*",
 	NULL
 };
 
@@ -915,7 +915,7 @@
  * Pattern 0:
  *   Do not warn if funtion/data are marked with __init_refok/__initdata_refok.
  *   The pattern is identified by:
- *   fromsec = .text.init.refok* | .data.init.refok*
+ *   fromsec = .kernel.text.init.refok* | .kernel.data.init.refok*
  *
  * Pattern 1:
  *   If a module parameter is declared __initdata and permissions=0
@@ -939,8 +939,8 @@
  *           *probe_one, *_console, *_timer
  *
  * Pattern 3:
- *   Whitelist all refereces from .text.head to .init.data
- *   Whitelist all refereces from .text.head to .init.text
+ *   Whitelist all refereces from .kernel.text.head to .init.data
+ *   Whitelist all refereces from .kernel.text.head to .init.text
  *
  * Pattern 4:
  *   Some symbols belong to init section but still it is ok to reference
