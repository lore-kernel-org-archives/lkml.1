Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbZCCQdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbZCCQdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 11:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZCCQdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 11:33:40 -0500
Received: from mx1.emlix.com ([193.175.82.87]:44773 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbZCCQdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 11:33:39 -0500
Date: Tue, 3 Mar 2009 17:33:13 +0100
From: Johannes Weiner <jw@emlix.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oskar Schirmer <os@emlix.com>, David Howells <dhowells@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>, Bryan Wu <cooloney@kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Subject: [patch] binfmt_flat: fix data sections alignment
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Message-Id: <E1LeXY0-0007Fb-KQ@mailer.emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oskar Schirmer <os@emlix.com>

The flat loader uses an architecture's flat_stack_align() to align the
stack but assumes word-alignment is enough for the data sections.

However, on the Xtensa S6000 we need an alignment of more than
wordsize for data that is loaded to 128bit wide registers.

This patch replaces the specific flat_stack_align() with a more
generic flat_data_align() that is then used for both stack, the data
and bss section.

It also fixes m32r which was obviously kaput, aligning an
uninitialized stack entry instead of the stack pointer.

Signed-off-by: Oskar Schirmer <os@emlix.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 arch/arm/include/asm/flat.h      |    4 +---
 arch/blackfin/include/asm/flat.h |    2 +-
 arch/h8300/include/asm/flat.h    |    2 +-
 arch/m68k/include/asm/flat.h     |    2 +-
 arch/sh/include/asm/flat.h       |    2 +-
 fs/binfmt_flat.c                 |   28 ++++++++++++++--------------
 include/asm-m32r/flat.h          |    2 +-
 7 files changed, 20 insertions(+), 22 deletions(-)

We tried to verify brain-wise that all the alignments on other archs
are still correct but please note that we have only one xtensa-based
box to test this patch on.  It works here with a required data
alignment of 16 bytes.

--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -115,19 +115,17 @@ static unsigned long create_flat_tables(
 	char uninitialized_var(dummy);
 
 	sp = (unsigned long *) ((-(unsigned long)sizeof(char *))&(unsigned long) p);
+	sp -= (envc + argc + 2) + 1 + (flat_argvp_envp_on_stack() ? 2 : 0);
+	sp = (unsigned long *) ((-(unsigned long)flat_data_align())&(unsigned long) sp);
+	argv = sp + 1 + (flat_argvp_envp_on_stack() ? 2 : 0);
+	envp = argv + (argc + 1);
 
-	sp -= envc+1;
-	envp = sp;
-	sp -= argc+1;
-	argv = sp;
-
-	flat_stack_align(sp);
 	if (flat_argvp_envp_on_stack()) {
-		--sp; put_user((unsigned long) envp, sp);
-		--sp; put_user((unsigned long) argv, sp);
+		put_user((unsigned long) envp, sp + 2);
+		put_user((unsigned long) argv, sp + 1);
 	}
 
-	put_user(argc,--sp);
+	put_user(argc,sp);
 	current->mm->arg_start = (unsigned long) p;
 	while (argc-->0) {
 		put_user((unsigned long) p, argv++);
@@ -558,7 +556,8 @@ static int load_flat_file(struct linux_b
 			ret = realdatastart;
 			goto err;
 		}
-		datapos = realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long);
+		datapos = ALIGN(realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long),
+				flat_data_align());
 
 		DBG_FLT("BINFMT_FLAT: Allocated data+bss+stack (%d bytes): %x\n",
 				(int)(data_len + bss_len + stack_len), (int)datapos);
@@ -604,9 +603,10 @@ static int load_flat_file(struct linux_b
 		}
 
 		realdatastart = textpos + ntohl(hdr->data_start);
-		datapos = realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long);
-		reloc = (unsigned long *) (textpos + ntohl(hdr->reloc_start) +
-				MAX_SHARED_LIBS * sizeof(unsigned long));
+		datapos = ALIGN(realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long),
+				flat_data_align());
+
+		reloc = (unsigned long *) (datapos+(ntohl(hdr->reloc_start)-text_len));
 		memp = textpos;
 		memp_size = len;
 #ifdef CONFIG_BINFMT_ZFLAT
@@ -854,7 +854,7 @@ static int load_flat_binary(struct linux
 	stack_len = TOP_OF_ARGS - bprm->p;             /* the strings */
 	stack_len += (bprm->argc + 1) * sizeof(char *); /* the argv array */
 	stack_len += (bprm->envc + 1) * sizeof(char *); /* the envp array */
-
+	stack_len += flat_data_align();
 	
 	res = load_flat_file(bprm, &libinfo, 0, &stack_len);
 	if (res > (unsigned long)-4096)
--- a/arch/arm/include/asm/flat.h
+++ b/arch/arm/include/asm/flat.h
@@ -5,9 +5,7 @@
 #ifndef __ARM_FLAT_H__
 #define __ARM_FLAT_H__
 
-/* An odd number of words will be pushed after this alignment, so
-   deliberately misalign the value.  */
-#define	flat_stack_align(sp)	sp = (void *)(((unsigned long)(sp) - 4) | 4)
+#define	flat_data_align()			8
 #define	flat_argvp_envp_on_stack()		1
 #define	flat_old_ram_flag(flags)		(flags)
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
--- a/arch/blackfin/include/asm/flat.h
+++ b/arch/blackfin/include/asm/flat.h
@@ -10,7 +10,7 @@
 
 #include <asm/unaligned.h>
 
-#define	flat_stack_align(sp)	/* nothing needed */
+#define	flat_data_align()			sizeof(void *)
 #define	flat_argvp_envp_on_stack()		0
 #define	flat_old_ram_flag(flags)		(flags)
 
--- a/arch/h8300/include/asm/flat.h
+++ b/arch/h8300/include/asm/flat.h
@@ -5,7 +5,7 @@
 #ifndef __H8300_FLAT_H__
 #define __H8300_FLAT_H__
 
-#define	flat_stack_align(sp)			/* nothing needed */
+#define	flat_data_align()			sizeof(void *)
 #define	flat_argvp_envp_on_stack()		1
 #define	flat_old_ram_flag(flags)		1
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
--- a/arch/m68k/include/asm/flat.h
+++ b/arch/m68k/include/asm/flat.h
@@ -5,7 +5,7 @@
 #ifndef __M68KNOMMU_FLAT_H__
 #define __M68KNOMMU_FLAT_H__
 
-#define	flat_stack_align(sp)			/* nothing needed */
+#define	flat_data_align(sp)			sizeof(void *)
 #define	flat_argvp_envp_on_stack()		1
 #define	flat_old_ram_flag(flags)		(flags)
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
--- a/arch/sh/include/asm/flat.h
+++ b/arch/sh/include/asm/flat.h
@@ -12,7 +12,7 @@
 #ifndef __ASM_SH_FLAT_H
 #define __ASM_SH_FLAT_H
 
-#define	flat_stack_align(sp)			/* nothing needed */
+#define	flat_data_align(sp)			sizeof(void *)
 #define	flat_argvp_envp_on_stack()		0
 #define	flat_old_ram_flag(flags)		(flags)
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
--- a/include/asm-m32r/flat.h
+++ b/include/asm-m32r/flat.h
@@ -12,7 +12,7 @@
 #ifndef __ASM_M32R_FLAT_H
 #define __ASM_M32R_FLAT_H
 
-#define	flat_stack_align(sp)		(*sp += (*sp & 3 ? (4 - (*sp & 3)): 0))
+#define	flat_data_align()			sizeof(void *)
 #define	flat_argvp_envp_on_stack()		0
 #define	flat_old_ram_flag(flags)		(flags)
 #define	flat_set_persistent(relval, p)		0
