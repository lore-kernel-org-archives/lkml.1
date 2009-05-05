Return-Path: <linux-kernel-owner+w=401wt.eu-S1755651AbZEENEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbZEENEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 09:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbZEENEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 09:04:10 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:16687 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbZEENEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 09:04:08 -0400
Message-Id: <4A0055B3.76EA.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 05 May 2009 14:05:23 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: fix build with older binutils
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: build fix

binutils prior to 2.17 can't deal with the currently possible situation
of a new segment following the per-CPU segment, but that new segment
being empty - objcopy misplaces the .bss (and perhaps also the .brk)
sections outside of any segment. However, the current ordering of
sections really just appears to be the effect of cumulative unrelated
changes; re-ordering things allows to easily guarantee that the segment
following the per-CPU one is non-empty, and at once eliminates the need
for the bogus data.init2 segment.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/vmlinux_64.lds.S |   91 +++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 50 deletions(-)

--- linux-2.6.30-rc4/arch/x86/kernel/vmlinux_64.lds.S	2009-04-30 09:42:42.000000000 +0200
+++ 2.6.30-rc4-x86_64-link-order/arch/x86/kernel/vmlinux_64.lds.S	2009-04-29 15:21:20.000000000 +0200
@@ -18,11 +18,10 @@ PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
 	data PT_LOAD FLAGS(7);	/* RWE */
 	user PT_LOAD FLAGS(7);	/* RWE */
-	data.init PT_LOAD FLAGS(7);	/* RWE */
 #ifdef CONFIG_SMP
 	percpu PT_LOAD FLAGS(7);	/* RWE */
 #endif
-	data.init2 PT_LOAD FLAGS(7);	/* RWE */
+	init PT_LOAD FLAGS(7);	/* RWE */
 	note PT_NOTE FLAGS(0);	/* ___ */
 }
 SECTIONS
@@ -54,30 +53,31 @@ SECTIONS
   	__stop___ex_table = .;
   } :text = 0x9090
 
-  RODATA
+  RO_DATA(PAGE_SIZE)
 
-  . = ALIGN(PAGE_SIZE);		/* Align data segment to page size boundary */
 				/* Data */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
-	DATA_DATA
-	CONSTRUCTORS
-	_edata = .;			/* End of data section */
-	} :data
-
+	. = ALIGN(THREAD_SIZE);	/* init_task */
+	*(.data.init_task)
 
-  .data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
 	. = ALIGN(PAGE_SIZE);
+	*(.data.page_aligned)
+
 	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
 	*(.data.cacheline_aligned)
-  }
-  . = ALIGN(CONFIG_X86_INTERNODE_CACHE_BYTES);
-  .data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
+
+	DATA_DATA
+	CONSTRUCTORS
+
+	. = ALIGN(CONFIG_X86_INTERNODE_CACHE_BYTES);
   	*(.data.read_mostly)
-  }
+
+	_edata = .;			/* End of data section */
+  } :data
 
 #define VSYSCALL_ADDR (-10*1024*1024)
-#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data.read_mostly) + SIZEOF(.data.read_mostly) + 4095) & ~(4095))
-#define VSYSCALL_VIRT_ADDR ((ADDR(.data.read_mostly) + SIZEOF(.data.read_mostly) + 4095) & ~(4095))
+#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data) + SIZEOF(.data) + PAGE_SIZE - 1) & ~(PAGE_SIZE - 1))
+#define VSYSCALL_VIRT_ADDR ((ADDR(.data) + SIZEOF(.data) + PAGE_SIZE - 1) & ~(PAGE_SIZE - 1))
 
 #define VLOAD_OFFSET (VSYSCALL_ADDR - VSYSCALL_PHYS_ADDR)
 #define VLOAD(x) (ADDR(x) - VLOAD_OFFSET)
@@ -125,34 +125,24 @@ SECTIONS
 #undef VVIRT_OFFSET
 #undef VVIRT
 
-  .data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
-	. = ALIGN(THREAD_SIZE);	/* init_task */
-	*(.data.init_task)
-  }:data.init
-
-  .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
-	. = ALIGN(PAGE_SIZE);
-	*(.data.page_aligned)
-  }
-
-  .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
-	/* might get freed after init */
-	. = ALIGN(PAGE_SIZE);
-	__smp_alt_begin = .;
-	__smp_locks = .;
-	*(.smp_locks)
-	__smp_locks_end = .;
-	. = ALIGN(PAGE_SIZE);
-	__smp_alt_end = .;
-  }
-
   . = ALIGN(PAGE_SIZE);		/* Init code and data */
   __init_begin = .;	/* paired with __init_end */
+
+#ifdef CONFIG_SMP
+  /*
+   * percpu offsets are zero-based on SMP.  PERCPU_VADDR() changes the
+   * output PHDR, so the next output section - .init.text - should
+   * start another segment - init.
+   */
+  . = ALIGN(PAGE_SIZE);
+  PERCPU_VADDR(0, :percpu)
+#endif
+
   .init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
 	_sinittext = .;
 	INIT_TEXT
 	_einittext = .;
-  }
+  } :init
   .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
 	__initdata_begin = .;
 	INIT_DATA
@@ -216,30 +206,31 @@ SECTIONS
   }
 #endif
 
-#ifdef CONFIG_SMP
-  /*
-   * percpu offsets are zero-based on SMP.  PERCPU_VADDR() changes the
-   * output PHDR, so the next output section - __data_nosave - should
-   * start another section data.init2.  Also, pda should be at the head of
-   * percpu area.  Preallocate it and define the percpu offset symbol
-   * so that it can be accessed as a percpu variable.
-   */
-  . = ALIGN(PAGE_SIZE);
-  PERCPU_VADDR(0, :percpu)
-#else
+#ifndef CONFIG_SMP
   PERCPU(PAGE_SIZE)
 #endif
 
   . = ALIGN(PAGE_SIZE);
   __init_end = .;
 
+  .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
+	/* might get freed after init */
+	. = ALIGN(PAGE_SIZE);
+	__smp_alt_begin = .;
+	__smp_locks = .;
+	*(.smp_locks)
+	__smp_locks_end = .;
+	. = ALIGN(PAGE_SIZE);
+	__smp_alt_end = .;
+  }
+
   .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
 	. = ALIGN(PAGE_SIZE);
 	__nosave_begin = .;
 	*(.data.nosave)
 	. = ALIGN(PAGE_SIZE);
 	__nosave_end = .;
-  } :data.init2 /* use another section data.init2, see PERCPU_VADDR() above */
+  }
 
   .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
 	. = ALIGN(PAGE_SIZE);


