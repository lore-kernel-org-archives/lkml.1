Return-Path: <linux-kernel-owner+w=401wt.eu-S1760327AbZFNMDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760327AbZFNMDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758646AbZFNMBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:01:37 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52665 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758736AbZFNMBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:01:33 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 07/17] Blackfin: convert user/elf to asm-generic
Date: Sun, 14 Jun 2009 08:01:08 -0400
Message-Id: <1244980878-2124-8-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/elf.h  |    2 +-
 arch/blackfin/include/asm/user.h |   90 +-------------------------------------
 2 files changed, 2 insertions(+), 90 deletions(-)

diff --git a/arch/blackfin/include/asm/elf.h b/arch/blackfin/include/asm/elf.h
index 230e160..5a87baf 100644
--- a/arch/blackfin/include/asm/elf.h
+++ b/arch/blackfin/include/asm/elf.h
@@ -20,7 +20,7 @@
 
 typedef unsigned long elf_greg_t;
 
-#define ELF_NGREG (sizeof(struct user_regs_struct) / sizeof(elf_greg_t))
+#define ELF_NGREG 40 /* (sizeof(struct user_regs_struct) / sizeof(elf_greg_t)) */
 typedef elf_greg_t elf_gregset_t[ELF_NGREG];
 
 typedef struct user_bfinfp_struct elf_fpregset_t;
diff --git a/arch/blackfin/include/asm/user.h b/arch/blackfin/include/asm/user.h
index afe6a0e..4792a60 100644
--- a/arch/blackfin/include/asm/user.h
+++ b/arch/blackfin/include/asm/user.h
@@ -1,89 +1 @@
-#ifndef _BFIN_USER_H
-#define _BFIN_USER_H
-
-/* Changes by Tony Kou   Lineo, Inc.  July, 2001
- *
- * Based include/asm-m68knommu/user.h
- *
- */
-
-/* Core file format: The core file is written in such a way that gdb
-   can understand it and provide useful information to the user (under
-   linux we use the 'trad-core' bfd).  There are quite a number of
-   obstacles to being able to view the contents of the floating point
-   registers, and until these are solved you will not be able to view the
-   contents of them.  Actually, you can read in the core file and look at
-   the contents of the user struct to find out what the floating point
-   registers contain.
-   The actual file contents are as follows:
-   UPAGE: 1 page consisting of a user struct that tells gdb what is present
-   in the file.  Directly after this is a copy of the task_struct, which
-   is currently not used by gdb, but it may come in useful at some point.
-   All of the registers are stored as part of the upage.  The upage should
-   always be only one page.
-   DATA: The data area is stored.  We use current->end_text to
-   current->brk to pick up all of the user variables, plus any memory
-   that may have been malloced.  No attempt is made to determine if a page
-   is demand-zero or if a page is totally unused, we just cover the entire
-   range.  All of the addresses are rounded in such a way that an integral
-   number of pages is written.
-   STACK: We need the stack information in order to get a meaningful
-   backtrace.  We need to write the data from (esp) to
-   current->start_stack, so we round each of these off in order to be able
-   to write an integer number of pages.
-   The minimum core file size is 3 pages, or 12288 bytes.
-*/
-struct user_bfinfp_struct {
-};
-
-/* This is the old layout of "struct pt_regs" as of Linux 1.x, and
-   is still the layout used by user (the new pt_regs doesn't have
-   all registers). */
-struct user_regs_struct {
-	long r0, r1, r2, r3, r4, r5, r6, r7;
-	long p0, p1, p2, p3, p4, p5, usp, fp;
-	long i0, i1, i2, i3;
-	long l0, l1, l2, l3;
-	long b0, b1, b2, b3;
-	long m0, m1, m2, m3;
-	long a0w, a1w;
-	long a0x, a1x;
-	unsigned long rets;
-	unsigned long astat;
-	unsigned long pc;
-	unsigned long orig_p0;
-};
-
-/* When the kernel dumps core, it starts by dumping the user struct -
-   this will be used by gdb to figure out where the data and stack segments
-   are within the file, and what virtual addresses to use. */
-
-struct user {
-/* We start with the registers, to mimic the way that "memory" is returned
-   from the ptrace(3,...) function.  */
-
-	struct user_regs_struct regs;	/* Where the registers are actually stored */
-
-/* The rest of this junk is to help gdb figure out what goes where */
-	unsigned long int u_tsize;	/* Text segment size (pages). */
-	unsigned long int u_dsize;	/* Data segment size (pages). */
-	unsigned long int u_ssize;	/* Stack segment size (pages). */
-	unsigned long start_code;	/* Starting virtual address of text. */
-	unsigned long start_stack;	/* Starting virtual address of stack area.
-					   This is actually the bottom of the stack,
-					   the top of the stack is always found in the
-					   esp register.  */
-	long int signal;	/* Signal that caused the core dump. */
-	int reserved;		/* No longer used */
-	unsigned long u_ar0;
-	/* Used by gdb to help find the values for */
-	/* the registers. */
-	unsigned long magic;	/* To uniquely identify a core file */
-	char u_comm[32];	/* User command that was responsible */
-};
-#define NBPG PAGE_SIZE
-#define UPAGES 1
-#define HOST_TEXT_START_ADDR (u.start_code)
-#define HOST_STACK_END_ADDR (u.start_stack + u.u_ssize * NBPG)
-
-#endif
+#include <asm-generic/user.h>
-- 
1.6.3.1

