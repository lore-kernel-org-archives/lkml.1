Return-Path: <linux-kernel-owner+w=401wt.eu-S1030283AbXDMVGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030283AbXDMVGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 17:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030284AbXDMVGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 17:06:13 -0400
Received: from gw.goop.org ([64.81.55.164]:34457 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030283AbXDMVGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 17:06:13 -0400
Message-ID: <461FF09D.4020902@goop.org>
Date: Fri, 13 Apr 2007 14:05:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Crash while mapping memory in pagetable_init() (Was: Re: .config)
References: <20070413174913.GA25234@ezr.goop.org> <20070413183841.GP10574@sequoia.sous-sol.org> <20070413190552.GQ10574@sequoia.sous-sol.org> <461FD97B.1010203@goop.org> <461FE36D.1050205@vmware.com> <461FE77A.6020307@zytor.com> <461FE7C7.7050204@goop.org> <461FE8EC.3090304@zytor.com> <461FE9D1.1000803@goop.org> <461FEB46.3000702@zytor.com>
In-Reply-To: <461FEB46.3000702@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Even with PSE?

Perhaps not.

> However, the main reason I wanted it done that way is to avoid cargo
> cult programming; this makes it much clearer where the numbers
> actually come from.

Well, how about this then?

Subject: i386: map enough initial memory to create lowmem mappings

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
Cc: Andi Kleen <ak@suse.de>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@osdl.org>,

---
 arch/i386/kernel/asm-offsets.c |    5 +++++
 arch/i386/kernel/head.S        |   25 ++++++++++++++++++++-----
 2 files changed, 25 insertions(+), 5 deletions(-)

===================================================================
--- a/arch/i386/kernel/asm-offsets.c
+++ b/arch/i386/kernel/asm-offsets.c
@@ -96,6 +96,11 @@ void foo(void)
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

