Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbZHYOB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbZHYOB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 10:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbZHYOB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 10:01:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:51031 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975AbZHYOB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 10:01:56 -0400
Date: Tue, 25 Aug 2009 14:01:23 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       sam@ravnborg.org, jbeulich@novell.com, JBeulich@novell.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, sam@ravnborg.org, JBeulich@novell.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A94085D02000078000119A5@vpn.id2.novell.com>
References: <4A94085D02000078000119A5@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix build with older binutils and consolidate linker script
Message-ID: <tip-c62e43202e7cf50ca24bce58b255df7bf5de69d0@git.kernel.org>
Git-Commit-ID: c62e43202e7cf50ca24bce58b255df7bf5de69d0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 25 Aug 2009 14:01:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c62e43202e7cf50ca24bce58b255df7bf5de69d0
Gitweb:     http://git.kernel.org/tip/c62e43202e7cf50ca24bce58b255df7bf5de69d0
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Tue, 25 Aug 2009 14:50:53 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 25 Aug 2009 15:54:16 +0200

x86: Fix build with older binutils and consolidate linker script

binutils prior to 2.17 can't deal with the currently possible
situation of a new segment following the per-CPU segment, but
that new segment being empty - objcopy misplaces the .bss (and
perhaps also the .brk) sections outside of any segment.

However, the current ordering of sections really just appears
to be the effect of cumulative unrelated changes; re-ordering
things allows to easily guarantee that the segment following
the per-CPU one is non-empty, and at once eliminates the need
for the bogus data.init2 segment.

Once touching this code, also use the various data section
helper macros from include/asm-generic/vmlinux.lds.h.

-v2: fix !SMP builds.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: <sam@ravnborg.org>
LKML-Reference: <4A94085D02000078000119A5@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/vmlinux.lds.S |  126 +++++++++++++++-------------------------
 1 files changed, 47 insertions(+), 79 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 78d185d..9fc1782 100644
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
@@ -103,65 +102,43 @@ SECTIONS
 		__stop___ex_table = .;
 	} :text = 0x9090
 
-	RODATA
+	RO_DATA(PAGE_SIZE)
 
 	/* Data */
-	. = ALIGN(PAGE_SIZE);
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {
 		/* Start of data section */
 		_sdata = .;
-		DATA_DATA
-		CONSTRUCTORS
-	} :data
+
+		/* init_task */
+		INIT_TASK_DATA(THREAD_SIZE)
 
 #ifdef CONFIG_X86_32
-	/* 32 bit has nosave before _edata */
-	. = ALIGN(PAGE_SIZE);
-	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
-		__nosave_begin = .;
-		*(.data.nosave)
-		. = ALIGN(PAGE_SIZE);
-		__nosave_end = .;
-	}
+		/* 32 bit has nosave before _edata */
+		NOSAVE_DATA
 #endif
 
-	. = ALIGN(PAGE_SIZE);
-	.data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
-		*(.data.page_aligned)
+		PAGE_ALIGNED_DATA(PAGE_SIZE)
 		*(.data.idt)
-	}
 
-#ifdef CONFIG_X86_32
-	. = ALIGN(32);
-#else
-	. = ALIGN(PAGE_SIZE);
-	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-#endif
-	.data.cacheline_aligned :
-		AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
-		*(.data.cacheline_aligned)
-	}
+		CACHELINE_ALIGNED_DATA(CONFIG_X86_L1_CACHE_BYTES)
 
-	/* rarely changed data like cpu maps */
-#ifdef CONFIG_X86_32
-	. = ALIGN(32);
-#else
-	. = ALIGN(CONFIG_X86_INTERNODE_CACHE_BYTES);
-#endif
-	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
-		*(.data.read_mostly)
+		DATA_DATA
+		CONSTRUCTORS
+
+		/* rarely changed data like cpu maps */
+		READ_MOSTLY_DATA(CONFIG_X86_INTERNODE_CACHE_BYTES)
 
 		/* End of data section */
 		_edata = .;
-	}
+	} :data
 
 #ifdef CONFIG_X86_64
 
 #define VSYSCALL_ADDR (-10*1024*1024)
-#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data.read_mostly) + \
-                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
-#define VSYSCALL_VIRT_ADDR ((ADDR(.data.read_mostly) + \
-                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
+#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data) + SIZEOF(.data) + \
+                            PAGE_SIZE - 1) & ~(PAGE_SIZE - 1))
+#define VSYSCALL_VIRT_ADDR ((ADDR(.data) + SIZEOF(.data) + \
+                            PAGE_SIZE - 1) & ~(PAGE_SIZE - 1))
 
 #define VLOAD_OFFSET (VSYSCALL_ADDR - VSYSCALL_PHYS_ADDR)
 #define VLOAD(x) (ADDR(x) - VLOAD_OFFSET)
@@ -227,35 +204,29 @@ SECTIONS
 
 #endif /* CONFIG_X86_64 */
 
-	/* init_task */
-	. = ALIGN(THREAD_SIZE);
-	.data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
-		*(.data.init_task)
+	/* Init code and data - will be freed after init */
+	. = ALIGN(PAGE_SIZE);
+	.init.begin : AT(ADDR(.init.begin) - LOAD_OFFSET) {
+		__init_begin = .; /* paired with __init_end */
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
-	. = ALIGN(PAGE_SIZE);
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
+	:init
+#endif
 
 	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
 		INIT_DATA
@@ -326,17 +297,7 @@ SECTIONS
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
+#if !defined(CONFIG_X86_64) || !defined(CONFIG_SMP)
 	PERCPU(PAGE_SIZE)
 #endif
 
@@ -347,15 +308,22 @@ SECTIONS
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
-		. = ALIGN(PAGE_SIZE);
-		__nosave_begin = .;
-		*(.data.nosave)
-		. = ALIGN(PAGE_SIZE);
-		__nosave_end = .;
-	} :data.init2
-	/* use another section data.init2, see PERCPU_VADDR() above */
+		NOSAVE_DATA
+	}
 #endif
 
 	/* BSS */
