Return-Path: <linux-kernel-owner+w=401wt.eu-S1758167AbZEEQhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167AbZEEQhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 12:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbZEEQhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 12:37:24 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:43294 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756991AbZEEQhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 12:37:22 -0400
Date: Tue, 5 May 2009 18:39:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: fix build with older binutils
Message-ID: <20090505163930.GA18579@uranus.ravnborg.org>
References: <4A0055B3.76EA.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0055B3.76EA.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan.

> Impact: build fix
> 
> binutils prior to 2.17 can't deal with the currently possible situation
> of a new segment following the per-CPU segment, but that new segment
> being empty - objcopy misplaces the .bss (and perhaps also the .brk)
> sections outside of any segment. However, the current ordering of
> sections really just appears to be the effect of cumulative unrelated
> changes; re-ordering things allows to easily guarantee that the segment
> following the per-CPU one is non-empty, and at once eliminates the need
> for the bogus data.init2 segment.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

I like the way your patch simplies the linker scrip for x86.
We have recently merged the linker scripts for 32 and 64 bit,
and I tried to apply your patch on top of the unified version.
(Applied manually obviously).

With a 64 bit defconfig build I got:
/home/sam/x-tools/x86_64-unknown-linux-gnu/bin/x86_64-unknown-linux-gnu-ld: section .vsyscall_0 [00000000016c6000 -> 00000000016c60e7] overlaps section .init.rodata [00000000016c5a00 -> 00000000016c6348]
make[1]: *** [.tmp_vmlinux1] Error 1

I did not try to build a kernel with your original patch.

Can you spot anything obvious wrong in my patch.
It is on top of x86/kbuild in -tip.

	Sam

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 4c85b2e..477fa48 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -46,11 +46,10 @@ PHDRS {
 	data PT_LOAD FLAGS(7);          /* RWE */
 #ifdef CONFIG_X86_64
 	user PT_LOAD FLAGS(7);          /* RWE */
-	data.init PT_LOAD FLAGS(7);     /* RWE */
 #ifdef CONFIG_SMP
 	percpu PT_LOAD FLAGS(7);        /* RWE */
 #endif
-	data.init2 PT_LOAD FLAGS(7);    /* RWE */
+	init PT_LOAD FLAGS(7);          /* RWE */
 #endif
 	note PT_NOTE FLAGS(0);          /* ___ */
 }
@@ -103,70 +102,58 @@ SECTIONS
 		__stop___ex_table = .;
 	} :text = 0x9090
 
-	RODATA
+	RO_DATA(PAGE_SIZE)
 
 	/* Data */
 	. = ALIGN(PAGE_SIZE);
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {
-		DATA_DATA
-		CONSTRUCTORS
-
-#ifdef CONFIG_X86_64
-		/* End of data section */
-		_edata = .;
-#endif
-	} :data
+		/* init_task */
+		. = ALIGN(THREAD_SIZE);
+		*(.data.init_task)
 
-#ifdef CONFIG_X86_32
-	/* 32 bit has nosave before _edata */
-	. = ALIGN(PAGE_SIZE);
-	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
-		__nosave_begin = .;
-		*(.data.nosave)
 		. = ALIGN(PAGE_SIZE);
-		__nosave_end = .;
-	}
-#endif
-
-	. = ALIGN(PAGE_SIZE);
-	.data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
 		*(.data.page_aligned)
-		*(.data.idt)
-	}
 
 #ifdef CONFIG_X86_32
-	. = ALIGN(32);
+		. = ALIGN(32);
 #else
-	. = ALIGN(PAGE_SIZE);
-	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+		. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
 #endif
-	.data.cacheline_aligned :
-		AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
 		*(.data.cacheline_aligned)
-	}
 
-	/* rarely changed data like cpu maps */
+		DATA_DATA
+		CONSTRUCTORS
+
+		/* rarely changed data like cpu maps */
 #ifdef CONFIG_X86_32
-	. = ALIGN(32);
+		. = ALIGN(32);
 #else
-	. = ALIGN(CONFIG_X86_INTERNODE_CACHE_BYTES);
+		. = ALIGN(CONFIG_X86_INTERNODE_CACHE_BYTES);
 #endif
-	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
 		*(.data.read_mostly)
 
-#ifdef CONFIG_X86_32
 		/* End of data section */
 		_edata = .;
-#endif
+	} :data
+
+#ifdef CONFIG_X86_32
+	/* 32 bit has nosave before _edata */
+	. = ALIGN(PAGE_SIZE);
+	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
+		__nosave_begin = .;
+		*(.data.nosave)
+		. = ALIGN(PAGE_SIZE);
+		__nosave_end = .;
 	}
+#endif
 
 #ifdef CONFIG_X86_64
 
 #define VSYSCALL_ADDR (-10*1024*1024)
-#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data.read_mostly) + \
-                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
-#define VSYSCALL_VIRT_ADDR ((ADDR(.data.read_mostly) + \
-                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
+#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data) + \
+                            SIZEOF(.data) + PAGE_SIZE - 1) & ~(PAGE_SIZE - 1))
+#define VSYSCALL_VIRT_ADDR ((ADDR(.data) + \
+                            SIZEOF(.data) + PAGE_SIZE - 1) & ~(PAGE_SIZE - 1))
 
 #define VLOAD_OFFSET (VSYSCALL_ADDR - VSYSCALL_PHYS_ADDR)
 #define VLOAD(x) (ADDR(x) - VLOAD_OFFSET)
@@ -232,35 +219,31 @@ SECTIONS
 
 #endif /* CONFIG_X86_64 */
 
-	/* init_task */
-	. = ALIGN(THREAD_SIZE);
-	.data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
-		*(.data.init_task)
+	/* will be freed after init - paired with __init_end */
+	.init.start : AT(ADDR(.init.start) - LOAD_OFFSET) {
+		. = ALIGN(PAGE_SIZE);
+		__init_begin = .;
 	}
-#ifdef CONFIG_X86_64
-	 :data.init
-#endif
 
+#if defined(CONFIG_X86_64) && defined(CONFIG_SMP)
 	/*
-	 * smp_locks might be freed after init
-	 * start/end must be page aligned
+	 * percpu offsets are zero-based on SMP.  PERCPU_VADDR() changes the
+	 * output PHDR, so the next output section - .init.text - should
+	 * start another segment - init.
 	 */
 	. = ALIGN(PAGE_SIZE);
-	.smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
-		__smp_locks = .;
-		*(.smp_locks)
-		__smp_locks_end = .;
-		. = ALIGN(PAGE_SIZE);
-	}
+	PERCPU_VADDR(0, :percpu)
+#endif
 
-	/* Init code and data - will be freed after init */
-	. = ALIGN(PAGE_SIZE);
 	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
-		__init_begin = .; /* paired with __init_end */
 		_sinittext = .;
 		INIT_TEXT
 		_einittext = .;
 	}
+#ifdef CONFIG_X86_64
+	 :init
+#endif
+
 
 	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
 		INIT_DATA
@@ -331,17 +314,7 @@ SECTIONS
 	}
 #endif
 
-#if defined(CONFIG_X86_64) && defined(CONFIG_SMP)
-	/*
-	 * percpu offsets are zero-based on SMP.  PERCPU_VADDR() changes the
-	 * output PHDR, so the next output section - __data_nosave - should
-	 * start another section data.init2.  Also, pda should be at the head of
-	 * percpu area.  Preallocate it and define the percpu offset symbol
-	 * so that it can be accessed as a percpu variable.
-	 */
-	. = ALIGN(PAGE_SIZE);
-	PERCPU_VADDR(0, :percpu)
-#else
+#if defined(CONFIG_X86_32) || !defined(CONFIG_SMP)
 	PERCPU(PAGE_SIZE)
 #endif
 
@@ -352,6 +325,18 @@ SECTIONS
 		__init_end = .;
 	}
 
+	/*
+	 * smp_locks might be freed after init
+	 * start/end must be page aligned
+	 */
+	. = ALIGN(PAGE_SIZE);
+	.smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
+		__smp_locks = .;
+		*(.smp_locks)
+		__smp_locks_end = .;
+		. = ALIGN(PAGE_SIZE);
+	}
+
 #ifdef CONFIG_X86_64
 	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
 		. = ALIGN(PAGE_SIZE);
@@ -359,8 +344,7 @@ SECTIONS
 		*(.data.nosave)
 		. = ALIGN(PAGE_SIZE);
 		__nosave_end = .;
-	} :data.init2
-	/* use another section data.init2, see PERCPU_VADDR() above */
+	}
 #endif
 
 	/* BSS */
