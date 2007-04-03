Return-Path: <linux-kernel-owner+w=401wt.eu-S965104AbXDCJiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965104AbXDCJiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 05:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965440AbXDCJiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 05:38:16 -0400
Received: from koto.vergenet.net ([210.128.90.7]:49737 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965104AbXDCJiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 05:38:15 -0400
Date: Tue, 3 Apr 2007 18:37:47 +0900
From: Simon Horman <horms@verge.net.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, fastboot@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH] kdump/kexec: calculate note size at compile time
Message-ID: <20070403093745.GA7145@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] kdump/kexec: calculate note size at compile time

Currently the size of the per-cpu region reserved to save crash
notes is set by the per-architecture value MAX_NOTE_BYTES. Which
in turn is currently set to 1024 on all supported architectures.

While testing ia64 I recently discovered that this value is
in fact too small. The particular setup I was using actually
needs 1172 bytes. This lead to very tedious failure mode
where the tail of one elf note would overwrite the head of
another if they ended up being alocated sequentially by kmalloc,
which was often the case.

It seems to me that a far better approach is to caclculate the size
that the area needs to be. This patch does just that.

If a simpler stop-gap patch for ia64 to be squeezed into 2.6.21(.X)
is needed then this should be as easy as making MAX_NOTE_BYTES
larger in arch/asm-ia64/kexec.h. Perhaps 2048 would be a good choice.
However, I think that the approach in this patch is a much more robust
idea.

Signed-off-by: Simon Horman <horms@verge.net.au>
Acked-by:  Vivek Goyal <vgoyal@in.ibm.com>
--- 

 As suggested by Milton Miller

 * Changed KEXEC_NOTE_NAME_BYTES to KEXEC_CORE_NOTE_NAME_BYTES and
   KEXEC_NOTE_DESC_BYTES to KEXEC_CORE_NOTE_DESC_BYTES to avoid
   a possible name-clash if additional notes are added in the future.

 * Use KEXEC_CORE_NOTE_NAME in the definition of KEXEC_CORE_NOTE_NAME_BYTES

 * Clean up comment about the notes area being a lit of notes

 arch/ia64/kernel/crash.c    |    2 +-
 include/asm-arm/kexec.h     |    2 --
 include/asm-i386/kexec.h    |    2 --
 include/asm-ia64/kexec.h    |    2 --
 include/asm-mips/kexec.h    |    2 --
 include/asm-powerpc/kexec.h |    2 --
 include/asm-s390/kexec.h    |    2 --
 include/asm-sh/kexec.h      |    2 --
 include/asm-x86_64/kexec.h  |    2 --
 include/linux/kexec.h       |   17 ++++++++++++++++-
 kernel/kexec.c              |    4 ++--
 11 files changed, 19 insertions(+), 20 deletions(-)
Index: linux-2.6/include/asm-ia64/kexec.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/kexec.h	2007-04-02 21:50:46.000000000 +0900
+++ linux-2.6/include/asm-ia64/kexec.h	2007-04-03 18:14:39.000000000 +0900
@@ -14,8 +14,6 @@
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_IA_64
 
-#define MAX_NOTE_BYTES 1024
-
 #define kexec_flush_icache_page(page) do { \
                 unsigned long page_addr = (unsigned long)page_address(page); \
                 flush_icache_range(page_addr, page_addr + PAGE_SIZE); \
Index: linux-2.6/include/linux/kexec.h
===================================================================
--- linux-2.6.orig/include/linux/kexec.h	2007-04-02 21:50:46.000000000 +0900
+++ linux-2.6/include/linux/kexec.h	2007-04-03 18:19:03.000000000 +0900
@@ -7,6 +7,8 @@
 #include <linux/linkage.h>
 #include <linux/compat.h>
 #include <linux/ioport.h>
+#include <linux/elfcore.h>
+#include <linux/elf.h>
 #include <asm/kexec.h>
 
 /* Verify architecture specific macros are defined */
@@ -31,6 +33,19 @@
 #error KEXEC_ARCH not defined
 #endif
 
+#define KEXEC_NOTE_HEAD_BYTES ALIGN(sizeof(struct elf_note), 4)
+#define KEXEC_CORE_NOTE_NAME "CORE"
+#define KEXEC_CORE_NOTE_NAME_BYTES ALIGN(sizeof(KEXEC_CORE_NOTE_NAME), 4)
+#define KEXEC_CORE_NOTE_DESC_BYTES ALIGN(sizeof(struct elf_prstatus), 4)
+/*
+ * The per-cpu notes area is a list of notes terminated by a "NULL"
+ * note header.  For kdump, the code in vmcore.c runs in the context
+ * of the second kernel to combine them into one note.
+ */
+#define KEXEC_NOTE_BYTES ( (KEXEC_NOTE_HEAD_BYTES * 2) +		\
+			    KEXEC_CORE_NOTE_NAME_BYTES +		\
+			    KEXEC_CORE_NOTE_DESC_BYTES )
+
 /*
  * This structure is used to hold the arguments that are used when loading
  * kernel binaries.
@@ -136,7 +151,7 @@
 /* Location of a reserved region to hold the crash kernel.
  */
 extern struct resource crashk_res;
-typedef u32 note_buf_t[MAX_NOTE_BYTES/4];
+typedef u32 note_buf_t[KEXEC_NOTE_BYTES/4];
 extern note_buf_t *crash_notes;
 
 
Index: linux-2.6/include/asm-arm/kexec.h
===================================================================
--- linux-2.6.orig/include/asm-arm/kexec.h	2007-04-02 21:50:46.000000000 +0900
+++ linux-2.6/include/asm-arm/kexec.h	2007-04-03 18:14:39.000000000 +0900
@@ -16,8 +16,6 @@
 
 #ifndef __ASSEMBLY__
 
-#define MAX_NOTE_BYTES 1024
-
 struct kimage;
 /* Provide a dummy definition to avoid build failures. */
 static inline void crash_setup_regs(struct pt_regs *newregs,
Index: linux-2.6/include/asm-i386/kexec.h
===================================================================
--- linux-2.6.orig/include/asm-i386/kexec.h	2007-04-02 21:50:46.000000000 +0900
+++ linux-2.6/include/asm-i386/kexec.h	2007-04-03 18:14:39.000000000 +0900
@@ -47,8 +47,6 @@
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_386
 
-#define MAX_NOTE_BYTES 1024
-
 /* CPU does not save ss and esp on stack if execution is already
  * running in kernel mode at the time of NMI occurrence. This code
  * fixes it.
Index: linux-2.6/include/asm-mips/kexec.h
===================================================================
--- linux-2.6.orig/include/asm-mips/kexec.h	2007-04-02 21:50:46.000000000 +0900
+++ linux-2.6/include/asm-mips/kexec.h	2007-04-03 18:14:39.000000000 +0900
@@ -21,8 +21,6 @@
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_MIPS
 
-#define MAX_NOTE_BYTES 1024
-
 static inline void crash_setup_regs(struct pt_regs *newregs,
 				    struct pt_regs *oldregs)
 {
Index: linux-2.6/include/asm-powerpc/kexec.h
===================================================================
--- linux-2.6.orig/include/asm-powerpc/kexec.h	2007-04-02 21:50:46.000000000 +0900
+++ linux-2.6/include/asm-powerpc/kexec.h	2007-04-03 18:14:39.000000000 +0900
@@ -108,8 +108,6 @@
 					struct pt_regs *oldregs) { }
 #endif /* !__powerpc64 __ */
 
-#define MAX_NOTE_BYTES 1024
-
 extern void kexec_smp_wait(void);	/* get and clear naca physid, wait for
 					  master to copy new code to 0 */
 extern int crashing_cpu;
Index: linux-2.6/include/asm-s390/kexec.h
===================================================================
--- linux-2.6.orig/include/asm-s390/kexec.h	2007-04-02 21:50:46.000000000 +0900
+++ linux-2.6/include/asm-s390/kexec.h	2007-04-03 18:14:39.000000000 +0900
@@ -34,8 +34,6 @@
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_S390
 
-#define MAX_NOTE_BYTES 1024
-
 /* Provide a dummy definition to avoid build failures. */
 static inline void crash_setup_regs(struct pt_regs *newregs,
 					struct pt_regs *oldregs) { }
Index: linux-2.6/include/asm-sh/kexec.h
===================================================================
--- linux-2.6.orig/include/asm-sh/kexec.h	2007-04-02 21:50:46.000000000 +0900
+++ linux-2.6/include/asm-sh/kexec.h	2007-04-03 18:14:39.000000000 +0900
@@ -23,8 +23,6 @@
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_SH
 
-#define MAX_NOTE_BYTES 1024
-
 /* Provide a dummy definition to avoid build failures. */
 static inline void crash_setup_regs(struct pt_regs *newregs,
 					struct pt_regs *oldregs) { }
Index: linux-2.6/include/asm-x86_64/kexec.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/kexec.h	2007-04-02 21:50:46.000000000 +0900
+++ linux-2.6/include/asm-x86_64/kexec.h	2007-04-03 18:14:39.000000000 +0900
@@ -48,8 +48,6 @@
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_X86_64
 
-#define MAX_NOTE_BYTES 1024
-
 /*
  * Saving the registers of the cpu on which panic occured in
  * crash_kexec to save a valid sp. The registers of other cpus
Index: linux-2.6/arch/ia64/kernel/crash.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/crash.c	2007-04-02 21:50:46.000000000 +0900
+++ linux-2.6/arch/ia64/kernel/crash.c	2007-04-03 18:19:36.000000000 +0900
@@ -74,7 +74,7 @@
 	buf = (u64 *) per_cpu_ptr(crash_notes, cpu);
 	if (!buf)
 		return;
-	buf = append_elf_note(buf, "CORE", NT_PRSTATUS, prstatus,
+	buf = append_elf_note(buf, KEXEC_CORE_NOTE_NAME, NT_PRSTATUS, prstatus,
 			sizeof(*prstatus));
 	final_note(buf);
 }
Index: linux-2.6/kernel/kexec.c
===================================================================
--- linux-2.6.orig/kernel/kexec.c	2007-04-02 21:50:46.000000000 +0900
+++ linux-2.6/kernel/kexec.c	2007-04-03 18:20:36.000000000 +0900
@@ -1118,8 +1118,8 @@
 	memset(&prstatus, 0, sizeof(prstatus));
 	prstatus.pr_pid = current->pid;
 	elf_core_copy_regs(&prstatus.pr_reg, regs);
-	buf = append_elf_note(buf, "CORE", NT_PRSTATUS, &prstatus,
-				sizeof(prstatus));
+	buf = append_elf_note(buf, KEXEC_CORE_NOTE_NAME, NT_PRSTATUS,
+		      	      &prstatus, sizeof(prstatus));
 	final_note(buf);
 }
 
