Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934107Ab0BZKyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 05:54:38 -0500
Received: from cantor.suse.de ([195.135.220.2]:39623 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933370Ab0BZKyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 05:54:36 -0500
Subject: [GIT PATCH] Fix XFS to work with Virtually indexed architectures
From: James Bottomley <James.Bottomley@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, hch@lst.de
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Feb 2010 16:24:24 +0530
Message-ID: <1267181664.2902.304.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches represents essential fixes to get XFS working on
PARISC and other VI architectures.  Following the negative feedback on
the block API, that's been removed and the patches reworked twice on
linux-arch.  The whole lot has been in linux-next for a couple of weeks
(via the parisc tree) to try to shake out any other bugs.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/xfs-vipt

The short changelog is

James Bottomley (5):
      mm: add coherence API for DMA to vmalloc/vmap areas
      parisc: add mm API for DMA to vmalloc/vmap areas
      arm: add mm API for DMA to vmalloc/vmap areas
      sh: add mm API for DMA to vmalloc/vmap areas
      xfs: fix xfs to work with Virtually Indexed architectures

And the diffstat:

 Documentation/cachetlb.txt           |   24 ++++++++++++++++++++++++
 arch/arm/include/asm/cacheflush.h    |   10 ++++++++++
 arch/parisc/include/asm/cacheflush.h |   12 ++++++++++++
 arch/sh/include/asm/cacheflush.h     |    8 ++++++++
 fs/xfs/linux-2.6/xfs_buf.c           |   30 +++++++++++++++++++++++++++++-
 include/linux/highmem.h              |    6 ++++++
 6 files changed, 89 insertions(+), 1 deletions(-)

Since it's short enough, the full diff is below.

James

---

diff --git a/Documentation/cachetlb.txt b/Documentation/cachetlb.txt
index da42ab4..b231414 100644
--- a/Documentation/cachetlb.txt
+++ b/Documentation/cachetlb.txt
@@ -377,3 +377,27 @@ maps this page at its virtual address.
 	All the functionality of flush_icache_page can be implemented in
 	flush_dcache_page and update_mmu_cache. In 2.7 the hope is to
 	remove this interface completely.
+
+The final category of APIs is for I/O to deliberately aliased address
+ranges inside the kernel.  Such aliases are set up by use of the
+vmap/vmalloc API.  Since kernel I/O goes via physical pages, the I/O
+subsystem assumes that the user mapping and kernel offset mapping are
+the only aliases.  This isn't true for vmap aliases, so anything in
+the kernel trying to do I/O to vmap areas must manually manage
+coherency.  It must do this by flushing the vmap range before doing
+I/O and invalidating it after the I/O returns.
+
+  void flush_kernel_vmap_range(void *vaddr, int size)
+       flushes the kernel cache for a given virtual address range in
+       the vmap area.  This is to make sure that any data the kernel
+       modified in the vmap range is made visible to the physical
+       page.  The design is to make this area safe to perform I/O on.
+       Note that this API does *not* also flush the offset map alias
+       of the area.
+
+  void invalidate_kernel_vmap_range(void *vaddr, int size) invalidates
+       the cache for a given virtual address range in the vmap area
+       which prevents the processor from making the cache stale by
+       speculatively reading data while the I/O was occurring to the
+       physical pages.  This is only necessary for data reads into the
+       vmap area.
diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index 730aefc..4ae503c 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -432,6 +432,16 @@ static inline void __flush_icache_all(void)
 	    : "r" (0));
 #endif
 }
+static inline void flush_kernel_vmap_range(void *addr, int size)
+{
+	if ((cache_is_vivt() || cache_is_vipt_aliasing()))
+	  __cpuc_flush_dcache_area(addr, (size_t)size);
+}
+static inline void invalidate_kernel_vmap_range(void *addr, int size)
+{
+	if ((cache_is_vivt() || cache_is_vipt_aliasing()))
+	  __cpuc_flush_dcache_area(addr, (size_t)size);
+}
 
 #define ARCH_HAS_FLUSH_ANON_PAGE
 static inline void flush_anon_page(struct vm_area_struct *vma,
diff --git a/arch/parisc/include/asm/cacheflush.h b/arch/parisc/include/asm/cacheflush.h
index 7a73b61..4772777 100644
--- a/arch/parisc/include/asm/cacheflush.h
+++ b/arch/parisc/include/asm/cacheflush.h
@@ -38,6 +38,18 @@ void flush_cache_mm(struct mm_struct *mm);
 
 #define flush_kernel_dcache_range(start,size) \
 	flush_kernel_dcache_range_asm((start), (start)+(size));
+/* vmap range flushes and invalidates.  Architecturally, we don't need
+ * the invalidate, because the CPU should refuse to speculate once an
+ * area has been flushed, so invalidate is left empty */
+static inline void flush_kernel_vmap_range(void *vaddr, int size)
+{
+	unsigned long start = (unsigned long)vaddr;
+
+	flush_kernel_dcache_range_asm(start, start + size);
+}
+static inline void invalidate_kernel_vmap_range(void *vaddr, int size)
+{
+}
 
 #define flush_cache_vmap(start, end)		flush_cache_all()
 #define flush_cache_vunmap(start, end)		flush_cache_all()
diff --git a/arch/sh/include/asm/cacheflush.h b/arch/sh/include/asm/cacheflush.h
index dda96eb..da3ebec 100644
--- a/arch/sh/include/asm/cacheflush.h
+++ b/arch/sh/include/asm/cacheflush.h
@@ -63,6 +63,14 @@ static inline void flush_anon_page(struct vm_area_struct *vma,
 	if (boot_cpu_data.dcache.n_aliases && PageAnon(page))
 		__flush_anon_page(page, vmaddr);
 }
+static inline void flush_kernel_vmap_range(void *addr, int size)
+{
+	__flush_wback_region(addr, size);
+}
+static inline void invalidate_kernel_vmap_range(void *addr, int size)
+{
+	__flush_invalidate_region(addr, size);
+}
 
 #define ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE
 static inline void flush_kernel_dcache_page(struct page *page)
diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 77b8be8..6f3ebb6 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -76,6 +76,27 @@ struct workqueue_struct *xfsconvertd_workqueue;
 #define xfs_buf_deallocate(bp) \
 	kmem_zone_free(xfs_buf_zone, (bp));
 
+static inline int
+xfs_buf_is_vmapped(
+	struct xfs_buf	*bp)
+{
+	/*
+	 * Return true if the buffer is vmapped.
+	 *
+	 * The XBF_MAPPED flag is set if the buffer should be mapped, but the
+	 * code is clever enough to know it doesn't have to map a single page,
+	 * so the check has to be both for XBF_MAPPED and bp->b_page_count > 1.
+	 */
+	return (bp->b_flags & XBF_MAPPED) && bp->b_page_count > 1;
+}
+
+static inline int
+xfs_buf_vmap_len(
+	struct xfs_buf	*bp)
+{
+	return (bp->b_page_count * PAGE_SIZE) - bp->b_offset;
+}
+
 /*
  *	Page Region interfaces.
  *
@@ -314,7 +335,7 @@ xfs_buf_free(
 	if (bp->b_flags & (_XBF_PAGE_CACHE|_XBF_PAGES)) {
 		uint		i;
 
-		if ((bp->b_flags & XBF_MAPPED) && (bp->b_page_count > 1))
+		if (xfs_buf_is_vmapped(bp))
 			free_address(bp->b_addr - bp->b_offset);
 
 		for (i = 0; i < bp->b_page_count; i++) {
@@ -1107,6 +1128,9 @@ xfs_buf_bio_end_io(
 
 	xfs_buf_ioerror(bp, -error);
 
+	if (!error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
+		invalidate_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
+
 	do {
 		struct page	*page = bvec->bv_page;
 
@@ -1216,6 +1240,10 @@ next_chunk:
 
 submit_io:
 	if (likely(bio->bi_size)) {
+		if (xfs_buf_is_vmapped(bp)) {
+			flush_kernel_vmap_range(bp->b_addr,
+						xfs_buf_vmap_len(bp));
+		}
 		submit_bio(rw, bio);
 		if (size)
 			goto next_chunk;
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 211ff44..adfe101 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -17,6 +17,12 @@ static inline void flush_anon_page(struct vm_area_struct *vma, struct page *page
 static inline void flush_kernel_dcache_page(struct page *page)
 {
 }
+static inline void flush_kernel_vmap_range(void *vaddr, int size)
+{
+}
+static inline void invalidate_kernel_vmap_range(void *vaddr, int size)
+{
+}
 #endif
 
 #include <asm/kmap_types.h>


