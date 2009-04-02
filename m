Return-Path: <linux-kernel-owner+w=401wt.eu-S1763247AbZDBVBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763247AbZDBVBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 17:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758145AbZDBVBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 17:01:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755441AbZDBVBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 17:01:37 -0400
Date: Thu, 2 Apr 2009 13:53:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: os@emlix.com, jw@emlix.com, dhowells@redhat.com, rmk@arm.linux.org.uk,
       cooloney@kernel.org, geert@linux-m68k.org, vapier.adi@gmail.com,
       gerg@uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v3] flat: fix data sections alignment
Message-Id: <20090402135343.d18d17a5.akpm@linux-foundation.org>
In-Reply-To: <20090310073350.GH10393@linux-sh.org>
References: <E1LfGwO-0007Kq-6c@mailer.emlix.com>
	<20090310073350.GH10393@linux-sh.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009 16:33:50 +0900
Paul Mundt <lethal@linux-sh.org> wrote:

> On Thu, Mar 05, 2009 at 06:00:59PM +0100, Oskar Schirmer wrote:
> > The flat loader uses an architecture's flat_stack_align() to align the
> > stack but assumes word-alignment is enough for the data sections.
> > 
> > However, on the Xtensa S6000 we have registers up to 128bit width
> > which can be used from userspace and therefor need userspace stack and
> > data-section alignment of at least this size.
> > 
> > This patch drops flat_stack_align() and uses the same alignment that
> > is required for slab caches, ARCH_SLAB_MINALIGN, or wordsize if it's
> > not defined by the architecture.
> > 
> > It also fixes m32r which was obviously kaput, aligning an
> > uninitialized stack entry instead of the stack pointer.
> > 
> > Signed-off-by: Oskar Schirmer <os@emlix.com>
> > Signed-off-by: Johannes Weiner <jw@emlix.com>
> > Cc: David Howells <dhowells@redhat.com>
> > Cc: Russell King <rmk@arm.linux.org.uk>
> > Cc: Bryan Wu <cooloney@kernel.org>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Paul Mundt <lethal@linux-sh.org>
> > Cc: Greg Ungerer <gerg@uclinux.org>
> > Cc: Mike Frysinger <vapier.adi@gmail.com>
> 
> The updated version looks ok to me anyways, and it's certainly an
> improvement over defining the same alignment requirements all over the
> place.
> 
> Acked-by: Paul Mundt <lethal@linux-sh.org>

Quite a few people expressed quite a few reservations over v2.

Are we all OK with a v3 merge?


From: Oskar Schirmer <os@emlix.com>

The flat loader uses an architecture's flat_stack_align() to align the
stack but assumes word-alignment is enough for the data sections.

However, on the Xtensa S6000 we have registers up to 128bit width
which can be used from userspace and therefor need userspace stack and
data-section alignment of at least this size.

This patch drops flat_stack_align() and uses the same alignment that
is required for slab caches, ARCH_SLAB_MINALIGN, or wordsize if it's
not defined by the architecture.

It also fixes m32r which was obviously kaput, aligning an
uninitialized stack entry instead of the stack pointer.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Oskar Schirmer <os@emlix.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Johannes Weiner <jw@emlix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/flat.h      |    3 -
 arch/blackfin/include/asm/flat.h |    1 
 arch/h8300/include/asm/flat.h    |    1 
 arch/m68k/include/asm/flat.h     |    1 
 arch/sh/include/asm/flat.h       |    1 
 fs/binfmt_flat.c                 |   46 +++++++++++++++++++----------
 include/asm-m32r/flat.h          |    1 
 7 files changed, 31 insertions(+), 23 deletions(-)

diff -puN arch/arm/include/asm/flat.h~flat-fix-data-sections-alignment arch/arm/include/asm/flat.h
--- a/arch/arm/include/asm/flat.h~flat-fix-data-sections-alignment
+++ a/arch/arm/include/asm/flat.h
@@ -5,9 +5,6 @@
 #ifndef __ARM_FLAT_H__
 #define __ARM_FLAT_H__
 
-/* An odd number of words will be pushed after this alignment, so
-   deliberately misalign the value.  */
-#define	flat_stack_align(sp)	sp = (void *)(((unsigned long)(sp) - 4) | 4)
 #define	flat_argvp_envp_on_stack()		1
 #define	flat_old_ram_flag(flags)		(flags)
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
diff -puN arch/blackfin/include/asm/flat.h~flat-fix-data-sections-alignment arch/blackfin/include/asm/flat.h
--- a/arch/blackfin/include/asm/flat.h~flat-fix-data-sections-alignment
+++ a/arch/blackfin/include/asm/flat.h
@@ -10,7 +10,6 @@
 
 #include <asm/unaligned.h>
 
-#define	flat_stack_align(sp)	/* nothing needed */
 #define	flat_argvp_envp_on_stack()		0
 #define	flat_old_ram_flag(flags)		(flags)
 
diff -puN arch/h8300/include/asm/flat.h~flat-fix-data-sections-alignment arch/h8300/include/asm/flat.h
--- a/arch/h8300/include/asm/flat.h~flat-fix-data-sections-alignment
+++ a/arch/h8300/include/asm/flat.h
@@ -5,7 +5,6 @@
 #ifndef __H8300_FLAT_H__
 #define __H8300_FLAT_H__
 
-#define	flat_stack_align(sp)			/* nothing needed */
 #define	flat_argvp_envp_on_stack()		1
 #define	flat_old_ram_flag(flags)		1
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
diff -puN arch/m68k/include/asm/flat.h~flat-fix-data-sections-alignment arch/m68k/include/asm/flat.h
--- a/arch/m68k/include/asm/flat.h~flat-fix-data-sections-alignment
+++ a/arch/m68k/include/asm/flat.h
@@ -5,7 +5,6 @@
 #ifndef __M68KNOMMU_FLAT_H__
 #define __M68KNOMMU_FLAT_H__
 
-#define	flat_stack_align(sp)			/* nothing needed */
 #define	flat_argvp_envp_on_stack()		1
 #define	flat_old_ram_flag(flags)		(flags)
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
diff -puN arch/sh/include/asm/flat.h~flat-fix-data-sections-alignment arch/sh/include/asm/flat.h
--- a/arch/sh/include/asm/flat.h~flat-fix-data-sections-alignment
+++ a/arch/sh/include/asm/flat.h
@@ -12,7 +12,6 @@
 #ifndef __ASM_SH_FLAT_H
 #define __ASM_SH_FLAT_H
 
-#define	flat_stack_align(sp)			/* nothing needed */
 #define	flat_argvp_envp_on_stack()		0
 #define	flat_old_ram_flag(flags)		(flags)
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
diff -puN fs/binfmt_flat.c~flat-fix-data-sections-alignment fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~flat-fix-data-sections-alignment
+++ a/fs/binfmt_flat.c
@@ -41,6 +41,7 @@
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
 #include <asm/cacheflush.h>
+#include <asm/page.h>
 
 /****************************************************************************/
 
@@ -54,6 +55,18 @@
 #define	DBG_FLT(a...)
 #endif
 
+/*
+ * User data (stack, data section and bss) needs to be aligned
+ * for the same reasons as SLAB memory is, and to the same amount.
+ * Avoid duplicating architecture specific code by using the same
+ * macro as with SLAB allocation:
+ */
+#ifdef ARCH_SLAB_MINALIGN
+#define FLAT_DATA_ALIGN	(ARCH_SLAB_MINALIGN)
+#else
+#define FLAT_DATA_ALIGN	(sizeof(void *))
+#endif
+
 #define RELOC_FAILED 0xff00ff01		/* Relocation incorrect somewhere */
 #define UNLOADED_LIB 0x7ff000ff		/* Placeholder for unused library */
 
@@ -114,20 +127,18 @@ static unsigned long create_flat_tables(
 	int envc = bprm->envc;
 	char uninitialized_var(dummy);
 
-	sp = (unsigned long *) ((-(unsigned long)sizeof(char *))&(unsigned long) p);
+	sp = (unsigned long *)p;
+	sp -= (envc + argc + 2) + 1 + (flat_argvp_envp_on_stack() ? 2 : 0);
+	sp = (unsigned long *) ((unsigned long)sp & -FLAT_DATA_ALIGN);
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
+	put_user(argc, sp);
 	current->mm->arg_start = (unsigned long) p;
 	while (argc-->0) {
 		put_user((unsigned long) p, argv++);
@@ -558,7 +569,9 @@ static int load_flat_file(struct linux_b
 			ret = realdatastart;
 			goto err;
 		}
-		datapos = realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long);
+		datapos = ALIGN(realdatastart +
+				MAX_SHARED_LIBS * sizeof(unsigned long),
+				FLAT_DATA_ALIGN);
 
 		DBG_FLT("BINFMT_FLAT: Allocated data+bss+stack (%d bytes): %x\n",
 				(int)(data_len + bss_len + stack_len), (int)datapos);
@@ -604,9 +617,12 @@ static int load_flat_file(struct linux_b
 		}
 
 		realdatastart = textpos + ntohl(hdr->data_start);
-		datapos = realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long);
-		reloc = (unsigned long *) (textpos + ntohl(hdr->reloc_start) +
-				MAX_SHARED_LIBS * sizeof(unsigned long));
+		datapos = ALIGN(realdatastart +
+				MAX_SHARED_LIBS * sizeof(unsigned long),
+				FLAT_DATA_ALIGN);
+
+		reloc = (unsigned long *)
+			(datapos + (ntohl(hdr->reloc_start) - text_len));
 		memp = textpos;
 		memp_size = len;
 #ifdef CONFIG_BINFMT_ZFLAT
@@ -854,7 +870,7 @@ static int load_flat_binary(struct linux
 	stack_len = TOP_OF_ARGS - bprm->p;             /* the strings */
 	stack_len += (bprm->argc + 1) * sizeof(char *); /* the argv array */
 	stack_len += (bprm->envc + 1) * sizeof(char *); /* the envp array */
-
+	stack_len += FLAT_DATA_ALIGN - 1;  /* reserve for upcoming alignment */
 	
 	res = load_flat_file(bprm, &libinfo, 0, &stack_len);
 	if (res > (unsigned long)-4096)
diff -puN include/asm-m32r/flat.h~flat-fix-data-sections-alignment include/asm-m32r/flat.h
--- a/include/asm-m32r/flat.h~flat-fix-data-sections-alignment
+++ a/include/asm-m32r/flat.h
@@ -12,7 +12,6 @@
 #ifndef __ASM_M32R_FLAT_H
 #define __ASM_M32R_FLAT_H
 
-#define	flat_stack_align(sp)		(*sp += (*sp & 3 ? (4 - (*sp & 3)): 0))
 #define	flat_argvp_envp_on_stack()		0
 #define	flat_old_ram_flag(flags)		(flags)
 #define	flat_set_persistent(relval, p)		0
_

