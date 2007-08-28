Return-Path: <linux-kernel-owner+w=401wt.eu-S1761383AbXH1TU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761383AbXH1TU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761398AbXH1TIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:08:54 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58347 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756589AbXH1THg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:36 -0400
Message-Id: <20070828190735.292638294@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:06:22 -0700
From: clameter@sgi.com
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [31/36] Large Blocksize: Core piece
Content-Disposition: inline; filename=0031-Large-Blocksize-Core-piece.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Provide an alternate definition for the page_cache_xxx(mapping, ...)
functions that can determine the current page size from the mapping
and generate the appropriate shifts, sizes and mask for the page cache
operations. Change the basic functions that allocate pages for the
page cache to be able to handle higher order allocations.

Provide a new function

mapping_setup(stdruct address_space *, gfp_t mask, int order)

that allows the setup of a mapping of any compound page order.

mapping_set_gfp_mask() is still provided but it sets mappings to order 0.
Calls to mapping_set_gfp_mask() must be converted to mapping_setup() in
order for the filesystem to be able to use larger pages. For some key block
devices and filesystems the conversion is done here.

mapping_setup() for higher order is only allowed if the mapping does not
use DMA mappings or HIGHMEM since we do not support bouncing at the moment.
Thus BUG() on DMA mappings and clear the highmem bit of higher order mappings.

Modify the set_blocksize() function so that an arbitrary blocksize can be set.
Blocksizes up to MAX_ORDER - 1 can be set. This is typically 8MB on many
platforms (order 11). Typically file systems are not only limited by the core
VM but also by the structure of their internal data structures. The core VM
limitations fall away with this patch. The functionality provided here
can do nothing about the internal limitations of filesystems.

Known internal limitations:

Ext2            64k
XFS             64k
Reiserfs        8k
Ext3            4k (rumor has it that changing a constant can remove the limit)
Ext4            4k

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 block/Kconfig               |   17 ++++++
 drivers/block/rd.c          |    6 ++-
 fs/block_dev.c              |   29 +++++++---
 fs/buffer.c                 |    4 +-
 fs/inode.c                  |    7 ++-
 fs/xfs/linux-2.6/xfs_buf.c  |    3 +-
 include/linux/buffer_head.h |   12 ++++-
 include/linux/fs.h          |    5 ++
 include/linux/pagemap.h     |  121 ++++++++++++++++++++++++++++++++++++++++--
 mm/filemap.c                |   17 ++++--
 10 files changed, 192 insertions(+), 29 deletions(-)

Index: linux-2.6/block/Kconfig
===================================================================
--- linux-2.6.orig/block/Kconfig	2007-08-27 19:22:13.000000000 -0700
+++ linux-2.6/block/Kconfig	2007-08-27 21:16:38.000000000 -0700
@@ -62,6 +62,20 @@ config BLK_DEV_BSG
 	protocols (e.g. Task Management Functions and SMP in Serial
 	Attached SCSI).
 
+#
+# The functions to switch on larger pages in a filesystem will return an error
+# if the gfp flags for a mapping require only DMA pages. Highmem will always
+# be switched off for higher order mappings.
+#
+config LARGE_BLOCKSIZE
+	bool "Support blocksizes larger than page size"
+	default n
+	depends on EXPERIMENTAL
+	help
+	  Allows the page cache to support higher orders of pages. Higher
+	  order page cache pages may be useful to increase I/O performance
+	  anbd support special devices like CD or DVDs and Flash.
+
 endif # BLOCK
 
 source block/Kconfig.iosched
Index: linux-2.6/drivers/block/rd.c
===================================================================
--- linux-2.6.orig/drivers/block/rd.c	2007-08-27 20:59:27.000000000 -0700
+++ linux-2.6/drivers/block/rd.c	2007-08-27 21:10:38.000000000 -0700
@@ -121,7 +121,8 @@ static void make_page_uptodate(struct pa
 			}
 		} while ((bh = bh->b_this_page) != head);
 	} else {
-		memset(page_address(page), 0, page_cache_size(page_mapping(page)));
+		memset(page_address(page), 0,
+			page_cache_size(page_mapping(page)));
 	}
 	flush_dcache_page(page);
 	SetPageUptodate(page);
@@ -380,7 +381,8 @@ static int rd_open(struct inode *inode, 
 		gfp_mask = mapping_gfp_mask(mapping);
 		gfp_mask &= ~(__GFP_FS|__GFP_IO);
 		gfp_mask |= __GFP_HIGH;
-		mapping_set_gfp_mask(mapping, gfp_mask);
+		mapping_setup(mapping, gfp_mask,
+			page_cache_blkbits_to_order(inode->i_blkbits));
 	}
 
 	return 0;
Index: linux-2.6/fs/block_dev.c
===================================================================
--- linux-2.6.orig/fs/block_dev.c	2007-08-27 19:22:13.000000000 -0700
+++ linux-2.6/fs/block_dev.c	2007-08-27 21:10:38.000000000 -0700
@@ -63,36 +63,46 @@ static void kill_bdev(struct block_devic
 		return;
 	invalidate_bh_lrus();
 	truncate_inode_pages(bdev->bd_inode->i_mapping, 0);
-}	
+}
 
 int set_blocksize(struct block_device *bdev, int size)
 {
-	/* Size must be a power of two, and between 512 and PAGE_SIZE */
-	if (size > PAGE_SIZE || size < 512 || !is_power_of_2(size))
+	int order;
+
+	if (size > (PAGE_SIZE << (MAX_ORDER - 1)) ||
+			size < 512 || !is_power_of_2(size))
 		return -EINVAL;
 
 	/* Size cannot be smaller than the size supported by the device */
 	if (size < bdev_hardsect_size(bdev))
 		return -EINVAL;
 
+	order = page_cache_blocksize_to_order(size);
+
 	/* Don't change the size if it is same as current */
 	if (bdev->bd_block_size != size) {
+		int bits = blksize_bits(size);
+		struct address_space *mapping =
+			bdev->bd_inode->i_mapping;
+
 		sync_blockdev(bdev);
-		bdev->bd_block_size = size;
-		bdev->bd_inode->i_blkbits = blksize_bits(size);
 		kill_bdev(bdev);
+		bdev->bd_block_size = size;
+		bdev->bd_inode->i_blkbits = bits;
+		mapping_setup(mapping, GFP_NOFS, order);
 	}
 	return 0;
 }
-
 EXPORT_SYMBOL(set_blocksize);
 
 int sb_set_blocksize(struct super_block *sb, int size)
 {
 	if (set_blocksize(sb->s_bdev, size))
 		return 0;
-	/* If we get here, we know size is power of two
-	 * and it's value is between 512 and PAGE_SIZE */
+	/*
+	 * If we get here, we know size is power of two
+	 * and it's value is valid for the page cache
+	 */
 	sb->s_blocksize = size;
 	sb->s_blocksize_bits = blksize_bits(size);
 	return sb->s_blocksize;
@@ -574,7 +584,8 @@ struct block_device *bdget(dev_t dev)
 		inode->i_rdev = dev;
 		inode->i_bdev = bdev;
 		inode->i_data.a_ops = &def_blk_aops;
-		mapping_set_gfp_mask(&inode->i_data, GFP_USER);
+		mapping_setup(&inode->i_data, GFP_USER,
+			page_cache_blkbits_to_order(inode->i_blkbits));
 		inode->i_data.backing_dev_info = &default_backing_dev_info;
 		spin_lock(&bdev_lock);
 		list_add(&bdev->bd_list, &all_bdevs);
Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c	2007-08-27 21:09:19.000000000 -0700
+++ linux-2.6/fs/buffer.c	2007-08-27 21:10:38.000000000 -0700
@@ -1090,7 +1090,7 @@ __getblk_slow(struct block_device *bdev,
 {
 	/* Size must be multiple of hard sectorsize */
 	if (unlikely(size & (bdev_hardsect_size(bdev)-1) ||
-			(size < 512 || size > PAGE_SIZE))) {
+		size < 512 || size > (PAGE_SIZE << (MAX_ORDER - 1)))) {
 		printk(KERN_ERR "getblk(): invalid block size %d requested\n",
 					size);
 		printk(KERN_ERR "hardsect size: %d\n",
@@ -1811,7 +1811,7 @@ static int __block_prepare_write(struct 
 				if (block_end > to || block_start < from)
 					zero_user_segments(page,
 						to, block_end,
-						block_start, from)
+						block_start, from);
 				continue;
 			}
 		}
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2007-08-27 19:22:13.000000000 -0700
+++ linux-2.6/fs/inode.c	2007-08-27 21:10:38.000000000 -0700
@@ -145,7 +145,8 @@ static struct inode *alloc_inode(struct 
 		mapping->a_ops = &empty_aops;
  		mapping->host = inode;
 		mapping->flags = 0;
-		mapping_set_gfp_mask(mapping, GFP_HIGHUSER_PAGECACHE);
+		mapping_setup(mapping, GFP_HIGHUSER_PAGECACHE,
+				page_cache_blkbits_to_order(inode->i_blkbits));
 		mapping->assoc_mapping = NULL;
 		mapping->backing_dev_info = &default_backing_dev_info;
 
@@ -243,7 +244,7 @@ void clear_inode(struct inode *inode)
 {
 	might_sleep();
 	invalidate_inode_buffers(inode);
-       
+
 	BUG_ON(inode->i_data.nrpages);
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
@@ -528,7 +529,7 @@ repeat:
  *	for allocations related to inode->i_mapping is GFP_HIGHUSER_PAGECACHE.
  *	If HIGHMEM pages are unsuitable or it is known that pages allocated
  *	for the page cache are not reclaimable or migratable,
- *	mapping_set_gfp_mask() must be called with suitable flags on the
+ *	mapping_setup() must be called with suitable flags and bits on the
  *	newly created inode's mapping
  *
  */
Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c	2007-08-27 19:22:13.000000000 -0700
+++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c	2007-08-27 21:10:38.000000000 -0700
@@ -1547,7 +1547,8 @@ xfs_mapping_buftarg(
 	mapping = &inode->i_data;
 	mapping->a_ops = &mapping_aops;
 	mapping->backing_dev_info = bdi;
-	mapping_set_gfp_mask(mapping, GFP_NOFS);
+	mapping_setup(mapping, GFP_NOFS,
+		page_cache_blkbits_to_order(inode->i_blkbits));
 	btp->bt_mapping = mapping;
 	return 0;
 }
Index: linux-2.6/include/linux/buffer_head.h
===================================================================
--- linux-2.6.orig/include/linux/buffer_head.h	2007-08-27 19:22:13.000000000 -0700
+++ linux-2.6/include/linux/buffer_head.h	2007-08-27 21:10:38.000000000 -0700
@@ -129,7 +129,17 @@ BUFFER_FNS(Ordered, ordered)
 BUFFER_FNS(Eopnotsupp, eopnotsupp)
 BUFFER_FNS(Unwritten, unwritten)
 
-#define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
+static inline unsigned long bh_offset(struct buffer_head *bh)
+{
+	/*
+	 * No mapping available. Use page struct to obtain
+	 * order.
+	 */
+	unsigned long mask = compound_size(bh->b_page) - 1;
+
+	return (unsigned long)bh->b_data & mask;
+}
+
 #define touch_buffer(bh)	mark_page_accessed(bh->b_page)
 
 /* If we *know* page->private refers to buffer_heads */
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2007-08-27 19:22:13.000000000 -0700
+++ linux-2.6/include/linux/fs.h	2007-08-27 21:10:38.000000000 -0700
@@ -446,6 +446,11 @@ struct address_space {
 	spinlock_t		i_mmap_lock;	/* protect tree, count, list */
 	unsigned int		truncate_count;	/* Cover race condition with truncate */
 	unsigned long		nrpages;	/* number of total pages */
+#ifdef CONFIG_LARGE_BLOCKSIZE
+	loff_t			offset_mask;	/* Mask to get to offset bits */
+	unsigned int		order;		/* Page order of the pages in here */
+	unsigned int		shift;		/* Shift of index */
+#endif
 	pgoff_t			writeback_index;/* writeback starts here */
 	const struct address_space_operations *a_ops;	/* methods */
 	unsigned long		flags;		/* error bits/gfp mask */
Index: linux-2.6/include/linux/pagemap.h
===================================================================
--- linux-2.6.orig/include/linux/pagemap.h	2007-08-27 19:29:55.000000000 -0700
+++ linux-2.6/include/linux/pagemap.h	2007-08-27 21:15:58.000000000 -0700
@@ -39,10 +39,35 @@ static inline gfp_t mapping_gfp_mask(str
  * This is non-atomic.  Only to be used before the mapping is activated.
  * Probably needs a barrier...
  */
-static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
+static inline void mapping_setup(struct address_space *m,
+					gfp_t mask, int order)
 {
 	m->flags = (m->flags & ~(__force unsigned long)__GFP_BITS_MASK) |
 				(__force unsigned long)mask;
+
+#ifdef CONFIG_LARGE_BLOCKSIZE
+	m->order = order;
+	m->shift = order + PAGE_SHIFT;
+	m->offset_mask = (PAGE_SIZE << order) - 1;
+	if (order) {
+		/*
+		 * Bouncing is not supported. Requests for DMA
+		 * memory will not work
+		 */
+		BUG_ON(m->flags & (__GFP_DMA|__GFP_DMA32));
+		/*
+		 * Bouncing not supported. We cannot use HIGHMEM
+		 */
+		m->flags &= ~__GFP_HIGHMEM;
+		m->flags |= __GFP_COMP;
+		/*
+		 * If we could raise the kswapd order then it should be
+		 * done here.
+		 *
+		 * raise_kswapd_order(order);
+		 */
+	}
+#endif
 }
 
 /*
@@ -62,6 +87,78 @@ static inline void mapping_set_gfp_mask(
 #define PAGE_CACHE_ALIGN(addr)	(((addr)+PAGE_CACHE_SIZE-1)&PAGE_CACHE_MASK)
 
 /*
+ * The next set of functions allow to write code that is capable of dealing
+ * with multiple page sizes.
+ */
+#ifdef CONFIG_LARGE_BLOCKSIZE
+/*
+ * Determine page order from the blkbits in the inode structure
+ */
+static inline int page_cache_blkbits_to_order(int shift)
+{
+	BUG_ON(shift < 9);
+
+	if (shift < PAGE_SHIFT)
+		return 0;
+
+	return shift - PAGE_SHIFT;
+}
+
+/*
+ * Determine page order from a given blocksize
+ */
+static inline int page_cache_blocksize_to_order(unsigned long size)
+{
+	return page_cache_blkbits_to_order(ilog2(size));
+}
+
+static inline int mapping_order(struct address_space *a)
+{
+	return a->order;
+}
+
+static inline int page_cache_shift(struct address_space *a)
+{
+	return a->shift;
+}
+
+static inline unsigned int page_cache_size(struct address_space *a)
+{
+	return a->offset_mask + 1;
+}
+
+static inline loff_t page_cache_mask(struct address_space *a)
+{
+	return ~a->offset_mask;
+}
+
+static inline unsigned int page_cache_offset(struct address_space *a,
+		loff_t pos)
+{
+	return pos & a->offset_mask;
+}
+#else
+/*
+ * Kernel configured for a fixed PAGE_SIZEd page cache
+ */
+static inline int page_cache_blkbits_to_order(int shift)
+{
+	if (shift < 9)
+		return -EINVAL;
+	if (shift > PAGE_SHIFT)
+		return -EINVAL;
+	return 0;
+}
+
+static inline int page_cache_blocksize_to_order(unsigned long size)
+{
+	if (size >= 512 && size <= PAGE_SIZE)
+		return 0;
+
+	return -EINVAL;
+}
+
+/*
  * Functions that are currently setup for a fixed PAGE_SIZEd. The use of
  * these will allow a variable page size pagecache in the future.
  */
@@ -90,6 +187,7 @@ static inline unsigned int page_cache_of
 {
 	return pos & ~PAGE_MASK;
 }
+#endif
 
 static inline pgoff_t page_cache_index(struct address_space *a,
 		loff_t pos)
@@ -112,27 +210,37 @@ static inline loff_t page_cache_pos(stru
 	return ((loff_t)index << page_cache_shift(a)) + offset;
 }
 
+/*
+ * Legacy function. Only supports order 0 pages.
+ */
+static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
+{
+	BUG_ON(mapping_order(m));
+	mapping_setup(m, mask, 0);
+}
+
 #define page_cache_get(page)		get_page(page)
 #define page_cache_release(page)	put_page(page)
 void release_pages(struct page **pages, int nr, int cold);
 
 #ifdef CONFIG_NUMA
-extern struct page *__page_cache_alloc(gfp_t gfp);
+extern struct page *__page_cache_alloc(gfp_t gfp, int);
 #else
-static inline struct page *__page_cache_alloc(gfp_t gfp)
+static inline struct page *__page_cache_alloc(gfp_t gfp, int order)
 {
-	return alloc_pages(gfp, 0);
+	return alloc_pages(gfp, order);
 }
 #endif
 
 static inline struct page *page_cache_alloc(struct address_space *x)
 {
-	return __page_cache_alloc(mapping_gfp_mask(x));
+	return __page_cache_alloc(mapping_gfp_mask(x), mapping_order(x));
 }
 
 static inline struct page *page_cache_alloc_cold(struct address_space *x)
 {
-	return __page_cache_alloc(mapping_gfp_mask(x)|__GFP_COLD);
+	return __page_cache_alloc(mapping_gfp_mask(x)|__GFP_COLD,
+				mapping_order(x));
 }
 
 typedef int filler_t(void *, struct page *);
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2007-08-27 21:09:19.000000000 -0700
+++ linux-2.6/mm/filemap.c	2007-08-27 21:14:55.000000000 -0700
@@ -471,13 +471,13 @@ int add_to_page_cache_lru(struct page *p
 }
 
 #ifdef CONFIG_NUMA
-struct page *__page_cache_alloc(gfp_t gfp)
+struct page *__page_cache_alloc(gfp_t gfp, int order)
 {
 	if (cpuset_do_page_mem_spread()) {
 		int n = cpuset_mem_spread_node();
-		return alloc_pages_node(n, gfp, 0);
+		return alloc_pages_node(n, gfp, order);
 	}
-	return alloc_pages(gfp, 0);
+	return alloc_pages(gfp, order);
 }
 EXPORT_SYMBOL(__page_cache_alloc);
 #endif
@@ -678,7 +678,7 @@ repeat:
 	if (!page) {
 		if (!cached_page) {
 			cached_page =
-				__page_cache_alloc(gfp_mask);
+				__page_cache_alloc(gfp_mask, mapping_order(mapping));
 			if (!cached_page)
 				return NULL;
 		}
@@ -818,7 +818,8 @@ grab_cache_page_nowait(struct address_sp
 		page_cache_release(page);
 		return NULL;
 	}
-	page = __page_cache_alloc(mapping_gfp_mask(mapping) & ~__GFP_FS);
+	page = __page_cache_alloc(mapping_gfp_mask(mapping) & ~__GFP_FS,
+				mapping_order(mapping));
 	if (page && add_to_page_cache_lru(page, mapping, index, GFP_KERNEL)) {
 		page_cache_release(page);
 		page = NULL;
@@ -1479,6 +1480,12 @@ int generic_file_mmap(struct file * file
 {
 	struct address_space *mapping = file->f_mapping;
 
+	/*
+	 * Forbid mmap access to higher order mappings.
+	 */
+	if (mapping_order(mapping))
+		return -ENOSYS;
+
 	if (!mapping->a_ops->readpage)
 		return -ENOEXEC;
 	file_accessed(file);

-- 
