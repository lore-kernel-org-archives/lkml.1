Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbYG3Vv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbYG3Vv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbYG3Vvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:51:46 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40250 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758094AbYG3Vvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:51:44 -0400
Date: Thu, 31 Jul 2008 00:51:41 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Matt Mackall <mpm@selenic.com>, Christoph Lameter <clameter@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hugh@veritas.com>,
       Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       vegard.nossum@gmail.com, hannes@saeurebad.de
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
In-Reply-To: <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0807310045020.22702@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com> 
 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com> 
 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org> 
 <1199314218.4497.109.camel@cinder.waste.org>  <20080103085239.GA10813@elte.hu>
  <1199378818.8274.25.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com> 
 <1199419890.4608.77.camel@cinder.waste.org>  <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>
  <1199641910.8215.28.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI> 
 <1199906151.6245.57.camel@cinder.waste.org>  <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI>
 <1199919548.6245.74.camel@cinder.waste.org> <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI>
 <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI>
 <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

(I'm replying to an old thread.)

On Thu, 10 Jan 2008, Linus Torvalds wrote:
> I would suggest that if you guys are really serious about memory use, try 
> to do a size-based heap thing, and do best-fit in that heap. Or just some 
> really simple size-based binning, eg
> 
> 	if (size > 2*PAGE_SIZE)
> 		goto page_allocator;
> 	bin = lookup_bin[(size+31) >> 5];
> 
> or whatever. Because first-fit is *known* to be bad.
> 
> At try to change it to address-ordered first-fit or something (which is 
> much more complex than just plain LIFO, but hey, that's life).
> 
> I haven't checked much, but I *think* SLOB is just basic first-fit 
> (perhaps the "next-fit" variation?) Next-fit is known to be EVEN WORSE 
> than the simple first-fit when it comes to fragmentation (so no, Knuth was 
> not always right - let's face it, much of Knuth is simply outdated).

In case you're interested, it turns out that best-fit with binning gives 
roughly the same results as SLOB (or alternatively, I messed something up 
with the design and implementation). The interesting bit here is that 
BINALLOC is more stable than SLOB (almost as stable as SLUB in my tests).

		Pekka

Subject: [PATCH] binalloc: best-fit allocation with binning
From: Pekka Enberg <penberg@cs.helsinki.fi>

As suggested by Linus, to optimize memory use, I have implemented a best-fit
general purpose kernel memory allocator with binning. You can find the original
discussion here:

  http://lkml.org/lkml/2008/1/10/229

The results are as follows:

[ the minimum, maximum, and average are of captured from 25 individual runs ]

                Total   Free (kB)                          Used (kB)
                (kB)    min     max     average    sd      min   max   average
SLOB		122372  117676  117768  117721.12  20.51   4604  4696  4650.88
BINALLOC        122368  117672  117732  117699.68  16.74   4636  4696  4668.32
SLUB (no debug) 122360  117284  117328  117308.96  15.27   5032  5076  5051.04

Thanks to Vegard Nossum for his help with debugging and testing the allocator
and to Johannes Weiner for fixing my bugs.

Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
diff --git a/include/linux/binalloc_def.h b/include/linux/binalloc_def.h
new file mode 100644
index 0000000..a6ea99e
--- /dev/null
+++ b/include/linux/binalloc_def.h
@@ -0,0 +1,34 @@
+#ifndef __LINUX_BINALLOC_DEF_H
+#define __LINUX_BINALLOC_DEF_H
+
+void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
+
+static inline void *kmem_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
+{
+	return kmem_cache_alloc_node(cachep, flags, -1);
+}
+
+void *__kmalloc_node(size_t size, gfp_t flags, int node);
+
+static inline void *kmalloc_node(size_t size, gfp_t flags, int node)
+{
+	return __kmalloc_node(size, flags, node);
+}
+
+/**
+ * kmalloc - allocate memory
+ * @size: how many bytes of memory are required.
+ * @flags: the type of memory to allocate (see kcalloc).
+ *
+ * kmalloc is the normal method of allocating memory
+ * in the kernel.
+ */
+static inline void *kmalloc(size_t size, gfp_t flags)
+{
+	return __kmalloc_node(size, flags, -1);
+}
+
+void *__kmalloc(size_t size, gfp_t flags);
+
+#endif /* __LINUX_BINALLOC_DEF_H */
+
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 5ff9676..eeda03d 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -124,6 +124,8 @@ size_t ksize(const void *);
 #include <linux/slub_def.h>
 #elif defined(CONFIG_SLOB)
 #include <linux/slob_def.h>
+#elif defined(CONFIG_BINALLOC)
+#include <linux/binalloc_def.h>
 #else
 #include <linux/slab_def.h>
 #endif
@@ -186,7 +188,7 @@ static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
 	return __kmalloc(n * size, flags | __GFP_ZERO);
 }
 
-#if !defined(CONFIG_NUMA) && !defined(CONFIG_SLOB)
+#if !defined(CONFIG_NUMA) && !defined(CONFIG_SLOB) && !defined(CONFIG_BINALLOC)
 /**
  * kmalloc_node - allocate memory from a specific node
  * @size: how many bytes of memory are required.
diff --git a/init/Kconfig b/init/Kconfig
index 250e02c..b9a6325 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -774,6 +774,13 @@ config SLOB
 	   allocator. SLOB is generally more space efficient but
 	   does not perform as well on large systems.
 
+config BINALLOC
+	depends on EMBEDDED
+	bool "BINALLOC"
+	help
+	   A best-fit general-purpose kernel memory allocator with binning
+	   that tries to be as memory efficient as possible.
+
 endchoice
 
 config PROFILING
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index e1d4764..29e253a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -290,6 +290,13 @@ config SLUB_STATS
 	  out which slabs are relevant to a particular load.
 	  Try running: slabinfo -DA
 
+config BINALLOC_DEBUG
+	bool "Debug binalloc memory allocations"
+	default n
+	help
+	  Say Y here to have the memory allocator to do sanity checks for
+	  allocation and deallocation.
+
 config DEBUG_PREEMPT
 	bool "Debug preemptible kernel"
 	depends on DEBUG_KERNEL && PREEMPT && (TRACE_IRQFLAGS_SUPPORT || PPC64)
diff --git a/mm/Makefile b/mm/Makefile
index da4ccf0..94ed767 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_SLOB) += slob.o
 obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o
 obj-$(CONFIG_SLAB) += slab.o
 obj-$(CONFIG_SLUB) += slub.o
+obj-$(CONFIG_BINALLOC) += binalloc.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
 obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
diff --git a/mm/binalloc.c b/mm/binalloc.c
new file mode 100644
index 0000000..ecdfd33
--- /dev/null
+++ b/mm/binalloc.c
@@ -0,0 +1,826 @@
+/*
+ * A best-fit general purpose kernel memory allocator with binning.
+ *
+ * Copyright (C) 2008  Pekka Enberg
+ *
+ * This file is release under the GPLv2
+ *
+ * I. Overview
+ *
+ * This is a best-fit general purpose kernel memory allocator with binning. We
+ * use the page allocator to allocate one big contiguous chunk that is split
+ * into smaller chunks for successive kmalloc() calls until we run out of space
+ * after which a new page is allocated.
+ *
+ * This memory allocator bears close resemblance to the "Lea" memory allocator
+ * described in:
+ *
+ *   http://g.oswego.edu/dl/html/malloc.html
+ *
+ * II. Anatomy of a chunk
+ *
+ * To detect page boundaries, a zero-sized sentinel chunk is placed at the end
+ * of a page. Objects are aligned by padding bytes at the beginning of a chunk
+ * after the boundary tag. The padding is included in the allocated object size
+ * so that neighbor boundary tags can be calculated. Likewise, boundary tags
+ * are aligned by padding bytes at the end of a chunk when splitting the chunk
+ * so that the first non-allocated byte is properly aligned.
+ *
+ * III. Operation
+ *
+ * In the following example, we assume a 64-byte page although on real machines
+ * the page size ranges from 4 KB to 64 KB. The size of the boundary tag in
+ * this example is 4 bytes and the mandatory alignment required by the machine
+ * is 4 bytes.
+ *
+ * Initially, the kernel memory allocator allocates one page from the page
+ * allocator and turns that into contiguous chunk with sentinel. You can see
+ * the boundary tag bytes marked as 'B' and the sentinel chunk boundary tag
+ * bytes as 'S' in the following diagram:
+ *
+ *   0       8       16      24      32      40      48      56
+ *   +-------+-------+-------+-------+-------+-------+-------+-------
+ *   BBBB                                                        SSSS
+ *
+ * Now lets assume a kmalloc() call comes in and wants to allocate 3 bytes. As
+ * we find a big enough chunk, we simply split it in two parts as follows:
+ *
+ *   0       8       16      24      32      40      48      56
+ *   +-------+-------+-------+-------+-------+-------+-------+-------
+ *   BBBBOOOPBBBB                                                SSSS
+ *
+ * As the pointer after the boundary tag of the chunk is already aligned to the
+ * mandatory alignment 4, the object marked as 'O' starts immediately after the
+ * boundary tag. However, to make sure the boundary tag of the next chunk is
+ * also aligned propery, one byte of padding is added to the end of the object
+ * marked as 'P'.
+ *
+ * Now assume that a kmem_cache_alloc() call comes in to allocate 16 bytes of
+ * memory with mandatory alignment of 16. Now, as the location after the
+ * boundary tag of the second chunk is not aligned to 16 byte boundary, we add
+ * 8 bytes of padding in front of the object as illustarted in the following
+ * diagram:
+ *
+ *   0       8       16      24      32      40      48      56
+ *   +-------+-------+-------+-------+-------+-------+-------+-------
+ *   BBBBOOOPBBBBPPPPOOOOOOOOOOOOOOOOBBBB                        SSSS
+ *
+ * Note that the boundary tag is naturally aligned due to the fact that the
+ * object size is already aligned to 4 byte boundary which is the mandatory
+ * alignment for this machine.
+ */
+
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/rbtree.h>
+#include <linux/rcupdate.h>
+#include <linux/slab.h>
+
+/*
+ * Minimum alignments
+ */
+#ifndef ARCH_KMALLOC_MINALIGN
+#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long)
+#endif
+
+#ifndef ARCH_SLAB_MINALIGN
+#define ARCH_SLAB_MINALIGN __alignof__(unsigned long)
+#endif
+
+#define MANDATORY_ALIGN max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN)
+
+struct kmem_rcu {
+	struct rcu_head		head;
+	size_t			size;
+};
+
+#define KMEM_CHUNK_RESERVED	0xababababUL
+#define KMEM_CHUNK_COALESCED	0xbcbcbcbcUL
+#define KMEM_CHUNK_FREE		0xfefefefeUL
+
+/*
+ * Each chunk has a boundary tag at the beginning of the chunk. The tag
+ * contains the size of this chunk and the size of the previous chunk which is
+ * required by chuck coalescing when an object is freed.
+ */
+struct kmem_boundary_tag {
+#ifdef CONFIG_BINALLOC_DEBUG
+	unsigned long		magic;
+#endif
+	unsigned short		prev_size;
+	unsigned short		size;
+	unsigned short		reserved;
+	unsigned short		align;
+};
+
+struct kmem_chunk {
+	struct kmem_boundary_tag	tag;
+	/* The following fields are defined only if the chunk is available */
+	struct rb_node			bin_tree;
+};
+
+/*
+ * The code assumes that the end of a boundary tag is aligned by power of two
+ * for calculating the alignment of an object in a chunk.
+ */
+#define BOUNDARY_TAG_SIZE roundup_pow_of_two(sizeof(struct kmem_boundary_tag))
+
+struct kmem_bin {
+	struct rb_root		freelist;
+};
+
+/*
+ * The chunk needs to be big enough to fit the freelist node pointers when it's
+ * available.
+ */
+#define MIN_CHUNK_SIZE \
+	(sizeof(struct kmem_chunk) - sizeof(struct kmem_boundary_tag))
+
+#define BIN_SHIFT 5
+#define NR_BINS ((PAGE_SIZE) / (1 << BIN_SHIFT))
+
+static struct kmem_bin bins[NR_BINS];
+static DEFINE_SPINLOCK(kmem_lock);
+
+static unsigned long chunk_size(struct kmem_chunk *chunk)
+{
+	return chunk->tag.size;
+}
+
+static void __chunk_set_size(struct kmem_chunk *chunk, unsigned long size)
+{
+	chunk->tag.size = size;
+}
+
+static void ptr_set_align(void *p, unsigned short align)
+{
+	unsigned short *buf = (void *)p - sizeof(unsigned short);
+
+	*buf = align;
+}
+
+static unsigned short ptr_get_align(const void *p)
+{
+	unsigned short *buf = (void *)p - sizeof(unsigned short);
+
+	return *buf;
+}
+
+static struct kmem_chunk *rawptr_to_chunk(const void *p)
+{
+	void *q = (void *)p - BOUNDARY_TAG_SIZE;
+	return q;
+}
+
+static void *chunk_to_rawptr(struct kmem_chunk *chunk)
+{
+	return (void *)chunk + BOUNDARY_TAG_SIZE;
+}
+
+static struct kmem_chunk *ptr_to_chunk(const void *p, unsigned short align)
+{
+	return rawptr_to_chunk(p - align);
+}
+
+static void *chunk_to_ptr(struct kmem_chunk *chunk, unsigned short align)
+{
+	void *p;
+
+	p = chunk_to_rawptr(chunk);
+	return PTR_ALIGN(p, align);
+}
+
+static struct kmem_chunk *prev_chunk(struct kmem_chunk *chunk)
+{
+	void *p = rawptr_to_chunk((void *) chunk - chunk->tag.prev_size);
+
+	BUG_ON(!virt_addr_valid(p));
+
+	return p;
+}
+
+static struct kmem_chunk *next_chunk(struct kmem_chunk *chunk)
+{
+	return chunk_to_rawptr(chunk) + chunk_size(chunk);
+}
+
+static bool chunk_is_first(struct kmem_chunk *b)
+{
+	return b->tag.prev_size == 0;
+}
+
+static bool chunk_is_last(struct kmem_chunk *b)
+{
+	struct kmem_chunk *next = next_chunk(b);
+
+	return chunk_size(next) == 0;
+}
+
+static void chunk_set_size(struct kmem_chunk *chunk, unsigned long size)
+{
+	BUG_ON(size < MIN_CHUNK_SIZE);
+	BUG_ON(size > PAGE_SIZE);
+
+	__chunk_set_size(chunk, size);
+
+	if (!chunk_is_last(chunk)) {
+		struct kmem_chunk *next = next_chunk(chunk);
+
+		next->tag.prev_size = size;
+	}
+}
+
+#ifdef CONFIG_BINALLOC_DEBUG
+
+#define DUMP_BYTES	128
+
+static void kmem_dump_chunk(struct kmem_chunk *chunk)
+{
+	print_hex_dump(KERN_ERR, "kmem: ", DUMP_PREFIX_ADDRESS, 16, 1,
+		chunk, DUMP_BYTES, 1);
+}
+
+static void kmem_verify_chunk(struct kmem_chunk *chunk, unsigned long magic)
+{
+	if (chunk->tag.magic != magic) {
+		printk(KERN_ERR "kmem: bad chunk magic: %lx, expected: %lx\n",
+				chunk->tag.magic, magic);
+		kmem_dump_chunk(chunk);
+		BUG();
+	}
+}
+
+static void chunk_set_magic(struct kmem_chunk *chunk, unsigned long magic)
+{
+	chunk->tag.magic = magic;
+}
+
+static void kmem_verify_page(struct page *page)
+{
+	struct kmem_chunk *chunk = page_address(page);
+
+	do {
+		BUG_ON(chunk_size(chunk) < MIN_CHUNK_SIZE);
+		BUG_ON(virt_to_page(chunk) != page);
+		chunk = next_chunk(chunk);
+	} while (chunk_size(chunk) != 0);
+}
+#else
+
+static inline void
+kmem_verify_chunk(struct kmem_chunk *chunk, unsigned long magic)
+{
+}
+
+static inline void
+chunk_set_magic(struct kmem_chunk *chunk, unsigned long magic)
+{
+}
+
+static inline void kmem_verify_page(struct page *page)
+{
+}
+#endif /* CONFIG_BINALLOC_DEBUG */
+
+static bool chunk_is_available(struct kmem_chunk *chunk)
+{
+	return chunk->tag.reserved != 1;
+}
+
+static void chunk_mark_reserved(struct kmem_chunk *chunk)
+{
+	chunk_set_magic(chunk, KMEM_CHUNK_RESERVED);
+	chunk->tag.reserved = 1;
+}
+
+static void chunk_mark_available(struct kmem_chunk *chunk)
+{
+	chunk_set_magic(chunk, KMEM_CHUNK_FREE);
+	chunk->tag.reserved = 0;
+}
+
+#define ALLOC_MASK (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK)
+
+static void *kmem_alloc_large(size_t size, gfp_t gfpflags, int node)
+{
+	struct page *page;
+	int order;
+
+	order = get_order(size);
+	page = alloc_pages_node(node, gfpflags & ALLOC_MASK, order);
+	if (!page)
+		return NULL;
+	page->private = size;
+
+	return page_address(page);
+}
+
+static int lookup_bin_idx(unsigned long size)
+{
+	return (size-1) >> BIN_SHIFT;
+}
+
+static struct kmem_bin *lookup_bin(unsigned long size)
+{
+	int idx = lookup_bin_idx(size);
+
+	BUG_ON(idx > NR_BINS);
+
+	return &bins[idx];
+}
+
+static struct kmem_bin *chunk_get_bin(struct kmem_chunk *chunk)
+{
+	unsigned long size = chunk_size(chunk);
+
+	return lookup_bin(size);
+}
+
+static void __insert_to_freelist(struct kmem_bin *bin, struct kmem_chunk *chunk)
+{
+	struct rb_node **p = &bin->freelist.rb_node;
+	struct rb_node *parent = NULL;
+
+	while (*p) {
+		struct kmem_chunk *this;
+		parent = *p;
+
+		this = rb_entry(parent, struct kmem_chunk, bin_tree);
+
+		if (chunk_size(chunk) < chunk_size(this))
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&chunk->bin_tree, parent, p);
+	rb_insert_color(&chunk->bin_tree, &bin->freelist);
+}
+
+static void insert_to_freelist(struct kmem_chunk *chunk)
+{
+	struct kmem_bin *bin;
+
+	kmem_verify_chunk(chunk, KMEM_CHUNK_FREE);
+
+	bin = chunk_get_bin(chunk);
+	__insert_to_freelist(bin, chunk);
+}
+
+static void remove_from_freelist(struct kmem_chunk *chunk)
+{
+	struct kmem_bin *bin = chunk_get_bin(chunk);
+
+	rb_erase(&chunk->bin_tree, &bin->freelist);
+}
+
+static struct kmem_chunk *chunk_page_alloc(gfp_t gfpflags)
+{
+	struct kmem_chunk *chunk, *sentinel;
+	struct page *page;
+
+	page = alloc_pages_node(-1, gfpflags & ALLOC_MASK, 0);
+	if (!page)
+		return NULL;
+
+	__SetPageSlab(page);
+
+	chunk = page_address(page);
+	chunk->tag.prev_size = 0;
+	__chunk_set_size(chunk, PAGE_SIZE - BOUNDARY_TAG_SIZE*2);
+	chunk_mark_available(chunk);
+
+	/*
+	 * The sentinel chunk marks the end of a page and it's the only one
+	 * that can have size zero.
+	 */
+	sentinel = page_address(page) + PAGE_SIZE - BOUNDARY_TAG_SIZE;
+	sentinel->tag.prev_size = chunk_size(chunk);
+	__chunk_set_size(sentinel, 0);
+	chunk_mark_reserved(sentinel);
+
+	return chunk;
+}
+
+static void split_chunk(struct kmem_chunk *chunk, size_t new_size)
+{
+	struct kmem_chunk *upper_half;
+	size_t size, remaining;
+
+	BUG_ON(new_size < MIN_CHUNK_SIZE);
+	BUG_ON(new_size > PAGE_SIZE);
+
+	kmem_verify_chunk(chunk, KMEM_CHUNK_FREE);
+
+	size = chunk_size(chunk);
+	BUG_ON(size < new_size);
+
+	remaining = size - new_size;
+
+	/*
+	 * Don't split if remaining half would end up too small.
+	 */
+	if (remaining < (BOUNDARY_TAG_SIZE + MIN_CHUNK_SIZE))
+		return;
+
+	chunk_set_size(chunk, new_size);
+
+	upper_half = next_chunk(chunk);
+	upper_half->tag.prev_size = chunk_size(chunk);
+	chunk_set_size(upper_half, remaining - BOUNDARY_TAG_SIZE);
+
+	chunk_mark_available(upper_half);
+	insert_to_freelist(upper_half);
+}
+
+static struct kmem_chunk *__kmem_alloc(struct kmem_bin *bin, size_t size)
+{
+	struct rb_node *n = bin->freelist.rb_node;
+	struct kmem_chunk *ret = NULL;
+
+	while (n) {
+		struct kmem_chunk *chunk = rb_entry(n, struct kmem_chunk, bin_tree);
+
+		if (chunk_size(chunk) < size) {
+			/*
+			 * The chunk is not big enough.
+			 */
+			n = n->rb_right;
+		} else {
+			/*
+			 * Look up the smallest possible chunk that is big
+			 * enough for us but bail out early if we find a
+			 * perfect fit.
+			 */
+			ret = chunk;
+			if (chunk_size(chunk) == size)
+				break;
+			n = n->rb_left;
+		}
+	}
+	if (ret)
+		remove_from_freelist(ret);
+
+	return ret;
+}
+
+/*
+ * This is the heart of the kernel memory allocator.
+ */
+static void *
+kmem_alloc(size_t size, gfp_t gfpflags, unsigned short align)
+{
+	struct kmem_chunk *chunk;
+	unsigned long flags;
+	void *p;
+	int i;
+
+	if (size < MIN_CHUNK_SIZE)
+		size = MIN_CHUNK_SIZE;
+
+	/*
+	 * The boundary tags are aligned to mandatory alignment so there's no
+	 * need to reserve extra space if the user also requested the same
+	 * mandatory alignment.
+	 */
+	if (align != MANDATORY_ALIGN)
+		size += align;
+
+	size = ALIGN(size, MANDATORY_ALIGN);
+
+	spin_lock_irqsave(&kmem_lock, flags);
+	/*
+	 * Look for available chunks from all bins starting from the smallest
+	 * one that is big enough for the requested size.
+	 */
+	for (i = lookup_bin_idx(size); i < NR_BINS; i++) {
+		struct kmem_bin *bin = &bins[i];
+
+		chunk = __kmem_alloc(bin, size);
+
+		/*
+		 * If we found a free chunk, return a pointer it; otherwise
+		 * continue scanning.
+		 */
+		if (chunk)
+			goto allocate_obj;
+	}
+
+	/*
+	 * Ok, we need more pages.
+	 */
+	spin_unlock_irqrestore(&kmem_lock, flags);
+	chunk = chunk_page_alloc(gfpflags);
+	if (!chunk)
+		return NULL;
+	spin_lock_irqsave(&kmem_lock, flags);
+
+allocate_obj:
+	split_chunk(chunk, size);
+	chunk_mark_reserved(chunk);
+	spin_unlock_irqrestore(&kmem_lock, flags);
+
+	p = chunk_to_ptr(chunk, align);
+	ptr_set_align(p, p - chunk_to_rawptr(chunk));
+
+	BUG_ON(!IS_ALIGNED((unsigned long) p, align));
+	return p;
+}
+
+static void *
+kmem_alloc_node(size_t size, gfp_t gfpflags, unsigned short align, int node)
+{
+	void *p;
+
+	if (unlikely(!size))
+		return ZERO_SIZE_PTR;
+
+	if (size < PAGE_SIZE)
+		p = kmem_alloc(size, gfpflags, align);
+	else
+		p = kmem_alloc_large(size, gfpflags, node);
+
+	if ((gfpflags & __GFP_ZERO) && p)
+		memset(p, 0, size);
+
+	if (size < PAGE_SIZE)
+		kmem_verify_page(virt_to_page(p));
+
+	return p;
+}
+
+void *__kmalloc_node(size_t size, gfp_t gfpflags, int node)
+{
+	return kmem_alloc_node(size, gfpflags, MANDATORY_ALIGN, node);
+}
+EXPORT_SYMBOL(__kmalloc_node);
+
+void *__kmalloc(size_t size, gfp_t gfpflags)
+{
+	return kmem_alloc_node(size, gfpflags, MANDATORY_ALIGN, -1);
+}
+EXPORT_SYMBOL(__kmalloc);
+
+static void
+coalesce_chunks(struct kmem_chunk *chunk, struct kmem_chunk *right_neighbor)
+{
+	unsigned long new_size;
+
+	kmem_verify_chunk(right_neighbor, KMEM_CHUNK_FREE);
+	kmem_verify_chunk(chunk, KMEM_CHUNK_FREE);
+
+	chunk_set_magic(right_neighbor, KMEM_CHUNK_COALESCED);
+
+	new_size = chunk_size(chunk) + chunk_size(right_neighbor);
+
+	/*
+	 * The boundary tag of the right-side neighbor is coalesced into the
+	 * chunk as well.
+	 */
+	chunk_set_size(chunk, new_size + BOUNDARY_TAG_SIZE);
+}
+
+static void kmem_free_chunk(struct kmem_chunk *chunk, struct page *page)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&kmem_lock, flags);
+
+	chunk_mark_available(chunk);
+
+	/*
+	 * Coalesce chunk with neighbor chunks that not reserved.
+	 */
+	if (likely(!chunk_is_first(chunk))) {
+		struct kmem_chunk *prev = prev_chunk(chunk);
+
+		if (chunk_is_available(prev)) {
+			remove_from_freelist(prev);
+			coalesce_chunks(prev, chunk);
+			chunk = prev;
+		}
+	}
+	if (likely(!chunk_is_last(chunk))) {
+		struct kmem_chunk *next = next_chunk(chunk);
+
+		if (chunk_is_available(next)) {
+			remove_from_freelist(next);
+			coalesce_chunks(chunk, next);
+		}
+	}
+
+	/*
+	 * If the chunk now covers a whole page, give it back to the page
+	 * allocator; otherwise insert it to the freelist.
+	 */
+	if (unlikely(chunk_size(chunk) == PAGE_SIZE-BOUNDARY_TAG_SIZE*2)) {
+		__ClearPageSlab(page);
+		__free_pages(page, 0);
+	} else
+		insert_to_freelist(chunk);
+
+	spin_unlock_irqrestore(&kmem_lock, flags);
+}
+
+static void kmem_free(const void *p, struct page *page)
+{
+	struct kmem_chunk *chunk;
+	unsigned short align;
+
+	kmem_verify_page(page);
+
+	align = ptr_get_align(p);
+	chunk = ptr_to_chunk(p, align);
+
+	kmem_free_chunk(chunk, page);
+}
+
+static void __kfree(const void *p)
+{
+	struct page *page = virt_to_page(p);
+
+	if (PageSlab(page))
+		kmem_free(p, page);
+	else
+		put_page(page);
+}
+
+void kfree(const void *p)
+{
+	if (unlikely(ZERO_OR_NULL_PTR(p)))
+		return;
+
+	__kfree(p);
+}
+EXPORT_SYMBOL(kfree);
+
+static size_t __ksize(const void *p)
+{
+	struct kmem_chunk *chunk;
+	unsigned short align;
+
+	align = ptr_get_align(p);
+	chunk = ptr_to_chunk(p, align);
+
+	/*
+	 * No need for locking here: the size of a reserved chunk can never
+	 * change.
+	 */
+	return chunk_size(chunk);	/* XXX */
+}
+
+size_t ksize(const void *p)
+{
+	struct page *page;
+
+	BUG_ON(!p);
+
+	if (unlikely(ZERO_OR_NULL_PTR(p)))
+		return 0;
+
+	page = virt_to_page(p);
+
+	if (PageSlab(page))
+		return __ksize(p);
+
+	return page->private;
+}
+EXPORT_SYMBOL(ksize);
+
+struct kmem_cache {
+	unsigned int size, align;
+	unsigned long gfpflags;
+	const char *name;
+	void (*ctor)(void *);
+};
+
+struct kmem_cache *
+kmem_cache_create(const char *name, size_t size, size_t align,
+		  unsigned long gfpflags,
+		  void (*ctor)(void *))
+{
+	struct kmem_cache *cache;
+
+	BUG_ON(size == 0);
+
+	cache = kmalloc(sizeof(*cache), GFP_KERNEL);
+	if (cache) {
+		cache->size = size;
+		if (gfpflags & SLAB_DESTROY_BY_RCU) {
+			/* leave room for rcu footer at the end of chunk */
+			cache->size += sizeof(struct kmem_rcu);
+		}
+		cache->align = max(align, ARCH_SLAB_MINALIGN);
+		cache->gfpflags = gfpflags;
+		cache->name = name;
+		cache->ctor = ctor;
+	}
+	return cache;
+}
+EXPORT_SYMBOL(kmem_cache_create);
+
+void kmem_cache_destroy(struct kmem_cache *cache)
+{
+	kfree(cache);
+}
+EXPORT_SYMBOL(kmem_cache_destroy);
+
+void *
+kmem_cache_alloc_node(struct kmem_cache *cache, gfp_t gfpflags, int node)
+{
+	void *p;
+
+	p = kmem_alloc_node(cache->size, gfpflags, cache->align, node);
+	if (!p)
+		return NULL;
+
+	if (cache->ctor)
+		cache->ctor(p);
+	return p;
+}
+EXPORT_SYMBOL(kmem_cache_alloc_node);
+
+static void kmem_rcu_free(struct rcu_head *head)
+{
+	struct kmem_rcu *kmem_rcu = (struct kmem_rcu *)head;
+	void *p = (void *)kmem_rcu - (kmem_rcu->size - sizeof(struct kmem_rcu));
+
+	__kfree(p);
+}
+
+void kmem_cache_free(struct kmem_cache *cache, void *p)
+{
+	if (unlikely(ZERO_OR_NULL_PTR(p)))
+		return;
+
+	if (unlikely(cache->gfpflags & SLAB_DESTROY_BY_RCU)) {
+		struct kmem_rcu *kmem_rcu;
+
+		kmem_rcu = p + (cache->size - sizeof(struct kmem_rcu));
+		INIT_RCU_HEAD(&kmem_rcu->head);
+		kmem_rcu->size = cache->size;
+		call_rcu(&kmem_rcu->head, kmem_rcu_free);
+	} else
+		__kfree(p);
+}
+EXPORT_SYMBOL(kmem_cache_free);
+
+unsigned int kmem_cache_size(struct kmem_cache *cache)
+{
+	return cache->size;
+}
+EXPORT_SYMBOL(kmem_cache_size);
+
+const char *kmem_cache_name(struct kmem_cache *cache)
+{
+	return cache->name;
+}
+EXPORT_SYMBOL(kmem_cache_name);
+
+int kmem_cache_shrink(struct kmem_cache *cache)
+{
+	return 0;
+}
+EXPORT_SYMBOL(kmem_cache_shrink);
+
+int kmem_ptr_validate(struct kmem_cache *cache, const void *p)
+{
+	return 0;
+}
+
+static unsigned int kmem_ready __read_mostly;
+
+int slab_is_available(void)
+{
+	return kmem_ready;
+}
+
+static void kmem_init_bin(struct kmem_bin *bin)
+{
+	bin->freelist = RB_ROOT;
+}
+
+#define NR_ALLOCS 64
+#define ALLOC_SIZE 128
+
+static void kmem_selftest(void)
+{
+	void *objs[NR_ALLOCS];
+	int i;
+
+	for (i = 0; i < NR_ALLOCS; i++)
+		objs[i] = kmalloc(ALLOC_SIZE, GFP_KERNEL);
+
+	for (i = 0; i < NR_ALLOCS; i++)
+		kfree(objs[i]);
+}
+
+void __init kmem_cache_init(void)
+{
+	int i;
+
+	for (i = 0; i < NR_BINS; i++)
+		kmem_init_bin(&bins[i]);
+	kmem_ready = 1;
+
+	kmem_selftest();
+}
