Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbXDNVXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbXDNVXI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 17:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbXDNVV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 17:21:58 -0400
Received: from gw.goop.org ([64.81.55.164]:59550 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbXDNVUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 17:20:16 -0400
Message-Id: <20070414204924.125386443@goop.org>
References: <20070414204154.871250608@goop.org>
User-Agent: quilt/0.46-1
Date: Sat, 14 Apr 2007 13:42:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 10/28] i386: map enough initial memory to create lowmem mappings
Content-Disposition: inline; filename=x86-map-enough-initial-memory.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
Acked-by: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,

---
 arch/i386/kernel/asm-offsets.c |    6 ++++++
 arch/i386/kernel/head.S        |   25 ++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 5 deletions(-)

===================================================================
--- a/arch/i386/kernel/asm-offsets.c
+++ b/arch/i386/kernel/asm-offsets.c
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
===================================================================
--- a/arch/i386/kernel/head.S
+++ b/arch/i386/kernel/head.S
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
-
+LOW_PAGES = 1<<(32-PAGE_SHIFT_asm)
+
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

-- 

