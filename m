Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbXD3Kar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbXD3Kar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbXD3K3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:29:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:43038 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965461AbXD3K2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:28:13 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: jeremy@goop.org, ak@suse.de, zach@vmware.com, chrisw@sous-sol.org,
       ebiederm@xmission.com, torvalds@linux-foundation.org,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [29/40] i386: map enough initial memory to create lowmem mappings
Message-Id: <20070430102803.C9463151D2@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:28:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
head.S creates the very initial pagetable for the kernel.  This just
maps enough space for the kernel itself, and an allocation bitmap.
The amount of mapped memory is rounded up to 4Mbytes, and so this
typically ends up mapping 8Mbytes of memory.

When booting, pagetable_init() needs to create mappings for all
lowmem, and the pagetables for these mappings are allocated from the
free pages around the kernel in low memory.  If the number of
pagetable pages + kernel size exceeds head.S's initial mapping, it
will end up faulting on an unmapped page.  This will only happen with
specific combinations of kernel size and memory size.

This patch makes sure that head.S also maps enough space to fit the
kernel pagetables as well as the kernel itself.  It ends up using an
additional two pages of unreclaimable memory.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,

---
 arch/i386/kernel/asm-offsets.c |    6 ++++++
 arch/i386/kernel/head.S        |   23 +++++++++++++++++++----
 2 files changed, 25 insertions(+), 4 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/asm-offsets.c
===================================================================
--- linux.orig/arch/i386/kernel/asm-offsets.c
+++ linux/arch/i386/kernel/asm-offsets.c
@@ -11,6 +11,7 @@
 #include <linux/suspend.h>
 #include <asm/ucontext.h>
 #include "sigframe.h"
+#include <asm/pgtable.h>
 #include <asm/fixmap.h>
 #include <asm/processor.h>
 #include <asm/thread_info.h>
@@ -96,6 +97,11 @@ void foo(void)
 		 sizeof(struct tss_struct));
 
 	DEFINE(PAGE_SIZE_asm, PAGE_SIZE);
+	DEFINE(PAGE_SHIFT_asm, PAGE_SHIFT);
+	DEFINE(PTRS_PER_PTE, PTRS_PER_PTE);
+	DEFINE(PTRS_PER_PMD, PTRS_PER_PMD);
+	DEFINE(PTRS_PER_PGD, PTRS_PER_PGD);
+
 	DEFINE(VDSO_PRELINK_asm, VDSO_PRELINK);
 
 	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
Index: linux/arch/i386/kernel/head.S
===================================================================
--- linux.orig/arch/i386/kernel/head.S
+++ linux/arch/i386/kernel/head.S
@@ -34,17 +34,32 @@
 
 /*
  * This is how much memory *in addition to the memory covered up to
- * and including _end* we need mapped initially.  We need one bit for
- * each possible page, but only in low memory, which means
- * 2^32/4096/8 = 128K worst case (4G/4G split.)
+ * and including _end* we need mapped initially.
+ * We need:
+ *  - one bit for each possible page, but only in low memory, which means
+ *     2^32/4096/8 = 128K worst case (4G/4G split.)
+ *  - enough space to map all low memory, which means
+ *     (2^32/4096) / 1024 pages (worst case, non PAE)
+ *     (2^32/4096) / 512 + 4 pages (worst case for PAE)
+ *  - a few pages for allocator use before the kernel pagetable has
+ *     been set up
  *
  * Modulo rounding, each megabyte assigned here requires a kilobyte of
  * memory, which is currently unreclaimed.
  *
  * This should be a multiple of a page.
  */
-#define INIT_MAP_BEYOND_END	(128*1024)
+LOW_PAGES = 1<<(32-PAGE_SHIFT_asm)
 
+#if PTRS_PER_PMD > 1
+PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PMD) + PTRS_PER_PGD
+#else
+PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PGD)
+#endif
+BOOTBITMAP_SIZE = LOW_PAGES / 8
+ALLOCATOR_SLOP = 4
+
+INIT_MAP_BEYOND_END = BOOTBITMAP_SIZE + (PAGE_TABLE_SIZE + ALLOCATOR_SLOP)*PAGE_SIZE_asm
 
 /*
  * 32-bit kernel entrypoint; only used by the boot CPU.  On entry,
