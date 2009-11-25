Return-Path: <linux-kernel-owner+w=401wt.eu-S933805AbZKYBBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805AbZKYBBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 20:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933698AbZKYBBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 20:01:33 -0500
Received: from mail-ew0-f215.google.com ([209.85.219.215]:49495 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933674AbZKYBBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 20:01:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=TO+TS8Z+kTc5hzOaDxlXAhqtyITbHL/NcgQOqSGXIEa9pOefSQTP9rZDNDsjPlndRL
         UnDvEWpTtDxN21DM0Ep8m6dySaJiwQOkkUxwRde8y18mXES35nDzAU4Y21CqZyCVHzUv
         HBUtctA+6ZbU4RxViOfl4ThsgbVSxVxkQHlCA=
Date: Wed, 25 Nov 2009 04:01:33 +0300
From: Ilya Loginov <isloginov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, Peter Horton <phorton@bitbox.co.uk>,
       "Ed L. Cashin" <ecashin@coraid.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] mtd: fix mtd_blkdevs problem with caches on some
 architectures (2.6.31)
Message-Id: <20091125040133.7f443176.isloginov@gmail.com>
In-Reply-To: <20091124124830.395115a0.akpm@linux-foundation.org>
References: <20091118170810.2bb9cd54.isloginov@gmail.com>
	<20091120163751.731781e8.akpm@linux-foundation.org>
	<20091121170437.0839daef.isloginov@gmail.com>
	<20091121095429.1378828c.akpm@linux-foundation.org>
	<20091122021128.db47e202.isloginov@gmail.com>
	<20091121152633.8c79e341.akpm@linux-foundation.org>
	<20091122124631.908a32c4.isloginov@gmail.com>
	<20091122132915.GA3046@elte.hu>
	<20091122165521.0b488e05.isloginov@gmail.com>
	<20091122104816.b6920ede.akpm@linux-foundation.org>
	<20091122221836.d2d7535d.isloginov@gmail.com>
	<20091122115103.f57f0d0c.akpm@linux-foundation.org>
	<20091122235539.be1f7814.isloginov@gmail.com>
	<20091124124830.395115a0.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Patch doesn't vaguely apply to linux-next because of arch/sh changes. 
> I was going to fix that but afaict your assertion that sh doesn't
> implement flush_dcache_page() appears to be untrue in linux-next and a
> bit of thought is needed there.

	You right. The sh architecture changed in linux-next and scope 
arch was added. I created new patch and tested it on linux-next.
 
> Also, please provide a nice chagnelog whcih describes the change, and
> our reasons for making it.

Mtdblock driver doesn't call flush_dcache_page for pages in request. So,
this cause problem on architectures where icache doesn't fill from dcache
or with dcache aliases. Patch fix this. The ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
symbol was introduced to avoid pointless empty cache-thrashing loops on 
architectures for which flush_dcache_page() is a no-op. Every architecture was
provided with this #define. New functions bio_flush_dcache_pages and
rq_flush_dcache_pages flush pages on architectires where
ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE is equal 1 or do nothing otherwise.

See "fix mtd_blkdevs problem with caches on some architectures" discussion
on LKML for more information.

Signed-off-by: Ilya Loginov <isloginov@gmail.com>
---
 arch/alpha/include/asm/cacheflush.h      |    1 +
 arch/arm/include/asm/cacheflush.h        |    1 +
 arch/avr32/include/asm/cacheflush.h      |    1 +
 arch/blackfin/include/asm/cacheflush.h   |    2 ++
 arch/cris/include/asm/cacheflush.h       |    1 +
 arch/frv/include/asm/cacheflush.h        |    1 +
 arch/h8300/include/asm/cacheflush.h      |    1 +
 arch/ia64/include/asm/cacheflush.h       |    1 +
 arch/m32r/include/asm/cacheflush.h       |    3 +++
 arch/m68k/include/asm/cacheflush_mm.h    |    1 +
 arch/m68k/include/asm/cacheflush_no.h    |    1 +
 arch/microblaze/include/asm/cacheflush.h |    1 +
 arch/mips/include/asm/cacheflush.h       |    1 +
 arch/mn10300/include/asm/cacheflush.h    |    1 +
 arch/parisc/include/asm/cacheflush.h     |    1 +
 arch/powerpc/include/asm/cacheflush.h    |    1 +
 arch/s390/include/asm/cacheflush.h       |    1 +
 arch/score/include/asm/cacheflush.h      |    1 +
 arch/sh/include/asm/cacheflush.h         |    1 +
 arch/sparc/include/asm/cacheflush_32.h   |    1 +
 arch/sparc/include/asm/cacheflush_64.h   |    1 +
 arch/x86/include/asm/cacheflush.h        |    1 +
 arch/xtensa/include/asm/cacheflush.h     |    1 +
 block/blk-core.c                         |   19 +++++++++++++++++++
 drivers/mtd/mtd_blkdevs.c                |    2 ++
 fs/bio.c                                 |   12 ++++++++++++
 include/asm-generic/cacheflush.h         |    1 +
 include/linux/bio.h                      |   12 ++++++++++++
 include/linux/blkdev.h                   |   11 +++++++++++
 29 files changed, 83 insertions(+)

diff --git a/arch/alpha/include/asm/cacheflush.h b/arch/alpha/include/asm/cacheflush.h
index b686cc7..01d71e1 100644
--- a/arch/alpha/include/asm/cacheflush.h
+++ b/arch/alpha/include/asm/cacheflush.h
@@ -9,6 +9,7 @@
 #define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do { } while (0)
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index 9fd6d3a..73eceb8 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -418,6 +418,7 @@ extern void flush_ptrace_access(struct vm_area_struct *vma, struct page *page,
  * about to change to user space.  This is the same method as used on SPARC64.
  * See update_mmu_cache for the user space part.
  */
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 extern void flush_dcache_page(struct page *);
 
 static inline void __flush_icache_all(void)
diff --git a/arch/avr32/include/asm/cacheflush.h b/arch/avr32/include/asm/cacheflush.h
index 6706747..96e5382 100644
--- a/arch/avr32/include/asm/cacheflush.h
+++ b/arch/avr32/include/asm/cacheflush.h
@@ -107,6 +107,7 @@ extern void flush_icache_page(struct vm_area_struct *vma, struct page *page);
  * do something here, but only for certain configurations.  No such
  * configurations exist at this time.
  */
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do { } while (0)
 #define flush_dcache_mmap_lock(page)		do { } while (0)
 #define flush_dcache_mmap_unlock(page)		do { } while (0)
diff --git a/arch/blackfin/include/asm/cacheflush.h b/arch/blackfin/include/asm/cacheflush.h
index af03a36..417eaac 100644
--- a/arch/blackfin/include/asm/cacheflush.h
+++ b/arch/blackfin/include/asm/cacheflush.h
@@ -68,9 +68,11 @@ do { memcpy(dst, src, len);						\
 #endif
 #if defined(CONFIG_BFIN_EXTMEM_WRITEBACK) || defined(CONFIG_BFIN_L2_WRITEBACK)
 # define flush_dcache_range(start,end)		blackfin_dcache_flush_range((start), (end))
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 # define flush_dcache_page(page)		blackfin_dflush_page(page_address(page))
 #else
 # define flush_dcache_range(start,end)		do { } while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 # define flush_dcache_page(page)		do { } while (0)
 #endif
 
diff --git a/arch/cris/include/asm/cacheflush.h b/arch/cris/include/asm/cacheflush.h
index cf60e3f..36795bc 100644
--- a/arch/cris/include/asm/cacheflush.h
+++ b/arch/cris/include/asm/cacheflush.h
@@ -12,6 +12,7 @@
 #define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do { } while (0)
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
diff --git a/arch/frv/include/asm/cacheflush.h b/arch/frv/include/asm/cacheflush.h
index 432a69e..edbac54 100644
--- a/arch/frv/include/asm/cacheflush.h
+++ b/arch/frv/include/asm/cacheflush.h
@@ -47,6 +47,7 @@ static inline void __flush_cache_all(void)
 }
 
 /* dcache/icache coherency... */
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 #ifdef CONFIG_MMU
 extern void flush_dcache_page(struct page *page);
 #else
diff --git a/arch/h8300/include/asm/cacheflush.h b/arch/h8300/include/asm/cacheflush.h
index 5ffdca2..4cf2df2 100644
--- a/arch/h8300/include/asm/cacheflush.h
+++ b/arch/h8300/include/asm/cacheflush.h
@@ -15,6 +15,7 @@
 #define	flush_cache_dup_mm(mm)		do { } while (0)
 #define	flush_cache_range(vma,a,b)
 #define	flush_cache_page(vma,p,pfn)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define	flush_dcache_page(page)
 #define	flush_dcache_mmap_lock(mapping)
 #define	flush_dcache_mmap_unlock(mapping)
diff --git a/arch/ia64/include/asm/cacheflush.h b/arch/ia64/include/asm/cacheflush.h
index c8ce271..429eefc 100644
--- a/arch/ia64/include/asm/cacheflush.h
+++ b/arch/ia64/include/asm/cacheflush.h
@@ -25,6 +25,7 @@
 #define flush_cache_vmap(start, end)		do { } while (0)
 #define flush_cache_vunmap(start, end)		do { } while (0)
 
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 #define flush_dcache_page(page)			\
 do {						\
 	clear_bit(PG_arch_1, &(page)->flags);	\
diff --git a/arch/m32r/include/asm/cacheflush.h b/arch/m32r/include/asm/cacheflush.h
index 78587c9..8e8e045 100644
--- a/arch/m32r/include/asm/cacheflush.h
+++ b/arch/m32r/include/asm/cacheflush.h
@@ -12,6 +12,7 @@ extern void _flush_cache_copyback_all(void);
 #define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do { } while (0)
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
@@ -33,6 +34,7 @@ extern void smp_flush_cache_all(void);
 #define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do { } while (0)
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
@@ -46,6 +48,7 @@ extern void smp_flush_cache_all(void);
 #define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do { } while (0)
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
diff --git a/arch/m68k/include/asm/cacheflush_mm.h b/arch/m68k/include/asm/cacheflush_mm.h
index 16bf375..73de7c8 100644
--- a/arch/m68k/include/asm/cacheflush_mm.h
+++ b/arch/m68k/include/asm/cacheflush_mm.h
@@ -128,6 +128,7 @@ static inline void __flush_page_to_ram(void *vaddr)
 	}
 }
 
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 #define flush_dcache_page(page)		__flush_page_to_ram(page_address(page))
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
diff --git a/arch/m68k/include/asm/cacheflush_no.h b/arch/m68k/include/asm/cacheflush_no.h
index c65f00a..89f1956 100644
--- a/arch/m68k/include/asm/cacheflush_no.h
+++ b/arch/m68k/include/asm/cacheflush_no.h
@@ -12,6 +12,7 @@
 #define flush_cache_range(vma, start, end)	__flush_cache_all()
 #define flush_cache_page(vma, vmaddr)		do { } while (0)
 #define flush_dcache_range(start,len)		__flush_cache_all()
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do { } while (0)
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
diff --git a/arch/microblaze/include/asm/cacheflush.h b/arch/microblaze/include/asm/cacheflush.h
index d3f3f75..1f04b91 100644
--- a/arch/microblaze/include/asm/cacheflush.h
+++ b/arch/microblaze/include/asm/cacheflush.h
@@ -37,6 +37,7 @@
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
 
 #define flush_dcache_range(start, end)	__invalidate_dcache_range(start, end)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do { } while (0)
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
diff --git a/arch/mips/include/asm/cacheflush.h b/arch/mips/include/asm/cacheflush.h
index 03b1d69..40bb9fd 100644
--- a/arch/mips/include/asm/cacheflush.h
+++ b/arch/mips/include/asm/cacheflush.h
@@ -38,6 +38,7 @@ extern void (*flush_cache_range)(struct vm_area_struct *vma,
 extern void (*flush_cache_page)(struct vm_area_struct *vma, unsigned long page, unsigned long pfn);
 extern void __flush_dcache_page(struct page *page);
 
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 static inline void flush_dcache_page(struct page *page)
 {
 	if (cpu_has_dc_aliases || !cpu_has_ic_fills_f_dc)
diff --git a/arch/mn10300/include/asm/cacheflush.h b/arch/mn10300/include/asm/cacheflush.h
index 1a55d61..29e692f 100644
--- a/arch/mn10300/include/asm/cacheflush.h
+++ b/arch/mn10300/include/asm/cacheflush.h
@@ -26,6 +26,7 @@
 #define flush_cache_page(vma, vmaddr, pfn)	do {} while (0)
 #define flush_cache_vmap(start, end)		do {} while (0)
 #define flush_cache_vunmap(start, end)		do {} while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do {} while (0)
 #define flush_dcache_mmap_lock(mapping)		do {} while (0)
 #define flush_dcache_mmap_unlock(mapping)	do {} while (0)
diff --git a/arch/parisc/include/asm/cacheflush.h b/arch/parisc/include/asm/cacheflush.h
index 7243951..7a73b61 100644
--- a/arch/parisc/include/asm/cacheflush.h
+++ b/arch/parisc/include/asm/cacheflush.h
@@ -42,6 +42,7 @@ void flush_cache_mm(struct mm_struct *mm);
 #define flush_cache_vmap(start, end)		flush_cache_all()
 #define flush_cache_vunmap(start, end)		flush_cache_all()
 
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 extern void flush_dcache_page(struct page *page);
 
 #define flush_dcache_mmap_lock(mapping) \
diff --git a/arch/powerpc/include/asm/cacheflush.h b/arch/powerpc/include/asm/cacheflush.h
index ba667a3..ab9e402 100644
--- a/arch/powerpc/include/asm/cacheflush.h
+++ b/arch/powerpc/include/asm/cacheflush.h
@@ -25,6 +25,7 @@
 #define flush_cache_vmap(start, end)		do { } while (0)
 #define flush_cache_vunmap(start, end)		do { } while (0)
 
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 extern void flush_dcache_page(struct page *page);
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
diff --git a/arch/s390/include/asm/cacheflush.h b/arch/s390/include/asm/cacheflush.h
index 49d5af9..405cc97 100644
--- a/arch/s390/include/asm/cacheflush.h
+++ b/arch/s390/include/asm/cacheflush.h
@@ -10,6 +10,7 @@
 #define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do { } while (0)
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
diff --git a/arch/score/include/asm/cacheflush.h b/arch/score/include/asm/cacheflush.h
index 07cc8fc..caaba24 100644
--- a/arch/score/include/asm/cacheflush.h
+++ b/arch/score/include/asm/cacheflush.h
@@ -16,6 +16,7 @@ extern void flush_icache_range(unsigned long start, unsigned long end);
 extern void flush_dcache_range(unsigned long start, unsigned long end);
 
 #define flush_cache_dup_mm(mm)			do {} while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do {} while (0)
 #define flush_dcache_mmap_lock(mapping)		do {} while (0)
 #define flush_dcache_mmap_unlock(mapping)	do {} while (0)
diff --git a/arch/sh/include/asm/cacheflush.h b/arch/sh/include/asm/cacheflush.h
index c29918f..dda96eb 100644
--- a/arch/sh/include/asm/cacheflush.h
+++ b/arch/sh/include/asm/cacheflush.h
@@ -42,6 +42,7 @@ extern void flush_cache_page(struct vm_area_struct *vma,
 				unsigned long addr, unsigned long pfn);
 extern void flush_cache_range(struct vm_area_struct *vma,
 				 unsigned long start, unsigned long end);
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 extern void flush_dcache_page(struct page *page);
 extern void flush_icache_range(unsigned long start, unsigned long end);
 extern void flush_icache_page(struct vm_area_struct *vma,
diff --git a/arch/sparc/include/asm/cacheflush_32.h b/arch/sparc/include/asm/cacheflush_32.h
index 68ac109..2e46877 100644
--- a/arch/sparc/include/asm/cacheflush_32.h
+++ b/arch/sparc/include/asm/cacheflush_32.h
@@ -75,6 +75,7 @@ BTFIXUPDEF_CALL(void, flush_sig_insns, struct mm_struct *, unsigned long)
 
 extern void sparc_flush_page_to_ram(struct page *page);
 
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 #define flush_dcache_page(page)			sparc_flush_page_to_ram(page)
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
diff --git a/arch/sparc/include/asm/cacheflush_64.h b/arch/sparc/include/asm/cacheflush_64.h
index c433217..b953840 100644
--- a/arch/sparc/include/asm/cacheflush_64.h
+++ b/arch/sparc/include/asm/cacheflush_64.h
@@ -37,6 +37,7 @@ extern void flush_dcache_page_all(struct mm_struct *mm, struct page *page);
 #endif
 
 extern void __flush_dcache_range(unsigned long start, unsigned long end);
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 extern void flush_dcache_page(struct page *page);
 
 #define flush_icache_page(vma, pg)	do { } while(0)
diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index eebb2cd..634c40a 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -12,6 +12,7 @@ static inline void flush_cache_range(struct vm_area_struct *vma,
 				     unsigned long start, unsigned long end) { }
 static inline void flush_cache_page(struct vm_area_struct *vma,
 				    unsigned long vmaddr, unsigned long pfn) { }
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 static inline void flush_dcache_page(struct page *page) { }
 static inline void flush_dcache_mmap_lock(struct address_space *mapping) { }
 static inline void flush_dcache_mmap_unlock(struct address_space *mapping) { }
diff --git a/arch/xtensa/include/asm/cacheflush.h b/arch/xtensa/include/asm/cacheflush.h
index b7b8fbe..a508f2f 100644
--- a/arch/xtensa/include/asm/cacheflush.h
+++ b/arch/xtensa/include/asm/cacheflush.h
@@ -101,6 +101,7 @@ static inline void __invalidate_icache_page_alias(unsigned long virt,
 #define flush_cache_vmap(start,end)	flush_cache_all()
 #define flush_cache_vunmap(start,end)	flush_cache_all()
 
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 extern void flush_dcache_page(struct page*);
 extern void flush_cache_range(struct vm_area_struct*, ulong, ulong);
 extern void flush_cache_page(struct vm_area_struct*, unsigned long, unsigned long);
diff --git a/block/blk-core.c b/block/blk-core.c
index 71da511..ae5de91 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2358,6 +2358,25 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 		rq->rq_disk = bio->bi_bdev->bd_disk;
 }
 
+#if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
+/**
+ * rq_flush_dcache_pages - Helper function to flush all pages in a request
+ * @rq: the request to be flushed
+ *
+ * Description:
+ *     Flush all pages in @rq.
+ */
+void rq_flush_dcache_pages(struct request *rq)
+{
+	struct req_iterator iter;
+	struct bio_vec* bvec;
+
+	rq_for_each_segment(bvec, rq, iter)
+		flush_dcache_page(bvec->bv_page);
+}
+EXPORT_SYMBOL_GPL(rq_flush_dcache_pages);
+#endif
+
 /**
  * blk_lld_busy - Check if underlying low-level drivers of a device are busy
  * @q : the queue of the device being checked
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index b76d6e5..1ab47d5 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -59,12 +59,14 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 		for (; nsect > 0; nsect--, block++, buf += tr->blksize)
 			if (tr->readsect(dev, block, buf))
 				return -EIO;
+		rq_flush_dcache_pages(req);
 		return 0;
 
 	case WRITE:
 		if (!tr->writesect)
 			return -EIO;
 
+		rq_flush_dcache_pages(req);
 		for (; nsect > 0; nsect--, block++, buf += tr->blksize)
 			if (tr->writesect(dev, block, buf))
 				return -EIO;
diff --git a/fs/bio.c b/fs/bio.c
index 2bd671a..ca1245c 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1393,6 +1393,18 @@ void bio_check_pages_dirty(struct bio *bio)
 	}
 }
 
+#if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
+void bio_flush_dcache_pages(struct bio *bi)
+{
+	int i;
+	struct bio_vec* bvec;
+
+	bio_for_each_segment(bvec, bi, i)
+		flush_dcache_page(bvec->bv_page);
+}
+EXPORT_SYMBOL(bio_flush_dcache_pages);
+#endif
+
 /**
  * bio_endio - end I/O on a bio
  * @bio:	bio
diff --git a/include/asm-generic/cacheflush.h b/include/asm-generic/cacheflush.h
index ba4ec39..57b5c3c 100644
--- a/include/asm-generic/cacheflush.h
+++ b/include/asm-generic/cacheflush.h
@@ -13,6 +13,7 @@
 #define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do { } while (0)
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 474792b..5a81c8e 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -391,6 +391,18 @@ extern struct bio *bio_copy_kern(struct request_queue *, void *, unsigned int,
 				 gfp_t, int);
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
+
+#ifndef ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
+# error	"You should to define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE for your platform."
+#endif
+#if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
+extern void bio_flush_dcache_pages(struct bio *bi);
+#else
+static inline void bio_flush_dcache_pages(struct bio *bi)
+{
+}
+#endif
+
 extern struct bio *bio_copy_user(struct request_queue *, struct rq_map_data *,
 				 unsigned long, unsigned int, int, gfp_t);
 extern struct bio *bio_copy_user_iov(struct request_queue *,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1cc0297..099a2db 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -752,6 +752,17 @@ struct req_iterator {
 #define rq_iter_last(rq, _iter)					\
 		(_iter.bio->bi_next == NULL && _iter.i == _iter.bio->bi_vcnt-1)
 
+#ifndef ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
+# error	"You should to define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE for your platform."
+#endif
+#if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
+extern void rq_flush_dcache_pages(struct request *rq);
+#else
+static inline void rq_flush_dcache_pages(struct request *rq)
+{
+}
+#endif
+
 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
 extern void register_disk(struct gendisk *dev);
