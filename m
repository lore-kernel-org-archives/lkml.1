Return-Path: <linux-kernel-owner+w=401wt.eu-S1760277AbZCQLhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277AbZCQLhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 07:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbZCQLhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 07:37:38 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:44656 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753268AbZCQLhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 07:37:36 -0400
Message-ID: <49BF8B4E.1030603@vflare.org>
Date: Tue, 17 Mar 2009 17:06:46 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3]: compressed RAM block device
References: <49BF8ABC.6040805@vflare.org>
In-Reply-To: <49BF8ABC.6040805@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 090316-0, 16-03-2009), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  drivers/block/Kconfig     |   22 +
  drivers/block/Makefile    |    1 +
  drivers/block/compcache.c |  995 +++++++++++++++++++++++++++++++++++++++++++++
  drivers/block/compcache.h |  160 ++++++++
  4 files changed, 1178 insertions(+), 0 deletions(-)

Creates RAM based block device (ramzswap0) which can be used as swap device.
Pages swapped to this are compressed and stored in memory itself.

The module is called compcache.ko. It depends on:
  - xvmalloc.ko: memory allocator
  - lzo_compress.ko
  - lzo_decompress.ko

See Documentation/blockdev/compcache.txt for usage details.

Project home: http://code.google.com/p/compcache/

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 0344a8a..cccf76c 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -348,6 +348,28 @@ config BLK_DEV_RAM_SIZE
  	  The default value is 4096 kilobytes. Only change this if you know
  	  what you are doing.

+config BLK_DEV_COMPCACHE
+	tristate "Compressed RAM swap device"
+	depends on XVMALLOC
+	depends on LZO_COMPRESS
+	depends on LZO_DECOMPRESS
+	help
+	  Saying Y here will allow you to use in-memory compressed swapping.
+	  It creates a pseudo block device (named ramzswap) which acts as
+	  swap device. Pages swapped to this device are compressed and stored
+	  in memory itself.
+
+	  Project home: http://code.google.com/p/compcache/
+	  For details, read <file:Documentation/blockdev/compcache.txt>
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called compcache.
+
+config BLK_DEV_COMPCACHE_STATS
+	bool "Collect statistics"
+	depends on BLK_DEV_COMPCACHE
+	default y
+
  config BLK_DEV_XIP
  	bool "Support XIP filesystems on RAM block device"
  	depends on BLK_DEV_RAM
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 204332b..6b2ee9e 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_PS3_DISK)		+= ps3disk.o
  obj-$(CONFIG_ATARI_FLOPPY)	+= ataflop.o
  obj-$(CONFIG_AMIGA_Z2RAM)	+= z2ram.o
  obj-$(CONFIG_BLK_DEV_RAM)	+= brd.o
+obj-$(CONFIG_BLK_DEV_COMPCACHE)	+= compcache.o
  obj-$(CONFIG_BLK_DEV_LOOP)	+= loop.o
  obj-$(CONFIG_BLK_DEV_XD)	+= xd.o
  obj-$(CONFIG_BLK_CPQ_DA)	+= cpqarray.o
diff --git a/drivers/block/compcache.c b/drivers/block/compcache.c
new file mode 100644
index 0000000..42bbb52
--- /dev/null
+++ b/drivers/block/compcache.c
@@ -0,0 +1,995 @@
+/*
+ * Compressed RAM based swap device
+ *
+ * Copyright (C) 2008, 2009  Nitin Gupta
+ *
+ * This RAM based block device acts as swap disk.
+ * Pages swapped to this device are compressed and
+ * stored in memory.
+ *
+ * Released under the terms of the GNU General Public
+ * License (version 2). See linux/COPYING for more information.
+ *
+ * Project home: http://code.google.com/p/compcache
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/bitops.h>
+#include <linux/blkdev.h>
+#include <linux/buffer_head.h>
+#include <linux/device.h>
+#include <linux/genhd.h>
+#include <linux/highmem.h>
+#include <linux/lzo.h>
+#include <linux/mutex.h>
+#include <linux/proc_fs.h>
+#include <linux/string.h>
+#include <linux/swap.h>
+#include <linux/swapops.h>
+#include <linux/vmalloc.h>
+#include <linux/xvmalloc.h>
+
+#include "compcache.h"
+
+/* Globals */
+static struct compcache compcache;
+static struct compcache_stats stats;
+
+/* Module params (documentation at end) */
+static unsigned long disksize_kb;
+static unsigned long memlimit_kb;
+static char *backing_dev;
+
+/*
+ * Pages that compress to larger than this size are
+ * forwarded to backing swap, if present or stored
+ * uncompressed in memory otherwise.
+ */
+static unsigned int MAX_CPAGE_SIZE;
+
+static int __init compcache_init(void);
+static struct block_device_operations compcache_devops = {
+	.owner = THIS_MODULE,
+};
+
+static void set_page_zero(u32 index)
+{
+	compcache.table[index].flags |= (1 << CC_zero);
+}
+
+static void set_page_uncompressed(u32 index)
+{
+	compcache.table[index].flags |= (1 << CC_uncompressed);
+}
+
+static void clear_page_zero(u32 index)
+{
+	compcache.table[index].flags &= ~(1 << CC_zero);
+}
+
+static void clear_page_uncompressed(u32 index)
+{
+	compcache.table[index].flags &= ~(1 << CC_uncompressed);
+}
+
+static int is_page_zero(u32 index)
+{
+	return compcache.table[index].flags & (1 << CC_zero);
+}
+
+static int is_page_uncompressed(u32 index)
+{
+	return compcache.table[index].flags & (1 << CC_uncompressed);
+}
+
+static int page_zero_filled(void *ptr)
+{
+	u32 pos;
+	u64 *page;
+
+	page = (u64 *)ptr;
+
+	for (pos = 0; pos != PAGE_SIZE / sizeof(*page); pos++) {
+		if (page[pos])
+			return 0;
+	}
+
+	return 1;
+}
+
+/*
+ * Given <pagenum, offset> pair, provide a dereferencable pointer.
+ */
+static void *get_ptr_atomic(u32 pagenum, u16 offset, enum km_type type)
+{
+	unsigned char *page;
+
+	page = kmap_atomic(pfn_to_page(pagenum), type);
+	return page + offset;
+}
+
+static void put_ptr_atomic(void *ptr, enum km_type type)
+{
+	kunmap_atomic(ptr, type);
+}
+
+#if defined(STATS)
+static struct proc_dir_entry *proc;
+
+static int proc_compcache_read(char *page, char **start, off_t off,
+				int count, int *eof, void *data)
+{
+	int len;
+	size_t succ_writes, mem_used;
+	unsigned int good_compress_perc = 0, no_compress_perc = 0;
+
+	mem_used = xvGetTotalSizeBytes(compcache.mem_pool)
+			+ (stats.pages_expand << PAGE_SHIFT);
+
+	if (off > 0) {
+		*eof = 1;
+		return 0;
+	}
+
+#define K(x)	((x) >> 10)
+	/* Basic stats */
+	len = sprintf(page,
+		"DiskSize:	%8zu kB\n",
+		(size_t)(K(compcache.disksize)));
+
+	if (compcache.backing_dev) {
+		/* This must always be less than ComprDataSize */
+		len += sprintf(page + len,
+			"MemLimit:	%8zu kB\n",
+			K(compcache.memlimit));
+	}
+
+	succ_writes = stats.num_writes - stats.failed_writes;
+	if (succ_writes) {
+		good_compress_perc = stats.good_compress * 100
+					/ stats.pages_stored;
+		no_compress_perc = stats.pages_expand * 100
+					/ stats.pages_stored;
+	}
+
+	/* Extended stats */
+	len += sprintf(page + len,
+		"NumReads:	%8llu\n"
+		"NumWrites:	%8llu\n"
+		"FailedReads:	%8llu\n"
+		"FailedWrites:	%8llu\n"
+		"InvalidIO:	%8llu\n"
+		"PagesDiscard:	%8llu\n"
+		"ZeroPages:	%8u\n"
+		"GoodCompress:	%8u %%\n"
+		"NoCompress:	%8u %%\n"
+		"PagesStored:	%8u\n"
+		"PagesUsed:	%8zu\n"
+		"OrigDataSize:	%8zu kB\n"
+		"ComprDataSize:	%8zu kB\n"
+		"MemUsedTotal:	%8zu kB\n",
+		stats.num_reads,
+		stats.num_writes,
+		stats.failed_reads,
+		stats.failed_writes,
+		stats.invalid_io,
+		stats.pages_discard,
+		stats.pages_zero,
+		good_compress_perc,
+		no_compress_perc,
+		stats.pages_stored,
+		mem_used >> PAGE_SHIFT,
+		(size_t)(K(stats.pages_stored << PAGE_SHIFT)),
+		(size_t)(K(stats.compr_size)),
+		(size_t)(K(mem_used)));
+
+	if (compcache.backing_dev) {
+		/* This must always be less than ComprDataSize */
+		len += sprintf(page + len,
+			"BDevNumReads:	%8llu\n"
+			"BDevNumWrites:	%8llu\n",
+			stats.bdev_num_reads,
+			stats.bdev_num_writes);
+	}
+
+
+	return len;
+}
+#endif	/* STATS */
+
+/*
+ * Check if value of backing_dev module param is sane.
+ * Claim this device and set compcache size equal to
+ * size of this block device.
+ */
+static int setup_backing_device(void)
+{
+	int error = 0;
+	struct inode *inode;
+	struct file *swap_file;
+	struct address_space *mapping;
+	struct block_device *bdev = NULL;
+
+	if (backing_dev == NULL) {
+		pr_debug(C "backing_dev param not given\n");
+		goto out;
+	}
+
+	pr_info(C "Using backing swap device: %s\n", backing_dev);
+
+	swap_file = filp_open(backing_dev, O_RDWR | O_LARGEFILE, 0);
+	if (IS_ERR(swap_file)) {
+		pr_err(C "Error opening backing device: %s\n", backing_dev);
+		error = -EINVAL;
+		goto out;
+	}
+
+	mapping = swap_file->f_mapping;
+	inode = mapping->host;
+
+	if (S_ISBLK(inode->i_mode)) {
+		bdev = I_BDEV(inode);
+		error = bd_claim(bdev, compcache_init);
+		if (error < 0) {
+			bdev = NULL;
+			goto bad_param;
+		}
+		compcache.old_block_size = block_size(bdev);
+		error = set_blocksize(bdev, PAGE_SIZE);
+		if (error < 0)
+			goto bad_param;
+	} else {
+		/* TODO: support for regular file as backing swap */
+		pr_info(C "%s is not a block device.\n", backing_dev);
+		error = -EINVAL;
+		goto out;
+	}
+
+	compcache.swap_file = swap_file;
+	compcache.backing_dev = bdev;
+	compcache.disksize = i_size_read(inode);
+	BUG_ON(!compcache.disksize);
+
+	return 0;
+
+bad_param:
+	if (bdev) {
+		set_blocksize(bdev, compcache.old_block_size);
+		bd_release(bdev);
+	}
+	filp_close(swap_file, NULL);
+
+out:
+	compcache.backing_dev = NULL;
+	return error;
+}
+
+/*
+ * Check if request is within bounds and page aligned.
+ */
+static inline int valid_swap_request(struct bio *bio)
+{
+	if (unlikely(
+		(bio->bi_sector >= (compcache.disksize >> SECTOR_SHIFT)) ||
+		(bio->bi_sector & (SECTORS_PER_PAGE - 1)) ||
+		(bio->bi_vcnt != 1) ||
+		(bio->bi_size != PAGE_SIZE) ||
+		(bio->bi_io_vec[0].bv_offset != 0))) {
+
+		return 0;
+	}
+
+	/* swap request is valid*/
+	return 1;
+}
+
+static void compcache_free_page(size_t index)
+{
+
+	u32 clen;
+	void *obj;
+
+
+	if (unlikely(is_page_uncompressed(index))) {
+		clen = PAGE_SIZE;
+		__free_page(pfn_to_page(
+			compcache.table[index].pageNum));
+		clear_page_uncompressed(index);
+		stat_dec(stats.pages_expand);
+	} else {
+		obj = get_ptr_atomic(compcache.table[index].pageNum,
+			compcache.table[index].offset, KM_USER0);
+		clen = xvGetObjectSize(obj) - sizeof(struct zobj_header);
+		put_ptr_atomic(obj, KM_USER0);
+		xvFree(compcache.mem_pool,
+			compcache.table[index].pageNum,
+			compcache.table[index].offset);
+		stat_dec_if_less(stats.good_compress, clen, PAGE_SIZE/2 + 1);
+	}
+
+	stats.compr_size -= clen;
+	stat_dec(stats.pages_stored);
+
+	compcache.table[index].pageNum = 0;
+	compcache.table[index].offset = 0;
+}
+
+static int compcache_prepare_discard(struct request_queue *q,
+					struct request *req)
+{
+	return 0;
+}
+
+/*
+ * Called by main I/O handler function. This helper
+ * function handles 'discard' I/O requests which means
+ * that  some swap pages are no longer required, so
+ * swap device can take needed action -- we free memory
+ * allocated for these pages.
+ */
+static void compcache_discard(struct bio *bio)
+{
+	size_t index, start_page, num_pages;
+
+	start_page = bio->bi_sector >> SECTORS_PER_PAGE_SHIFT;
+	num_pages = bio->bi_size >> (SECTOR_SHIFT + SECTORS_PER_PAGE_SHIFT);
+
+	for (index = start_page; index < start_page + num_pages;
+							index++) {
+		if (compcache.table[index].pageNum) {
+			compcache_free_page(index);
+			stat_inc(stats.pages_discard);
+		}
+	}
+	set_bit(BIO_UPTODATE, &bio->bi_flags);
+	bio_endio(bio, 0);
+	return;
+}
+
+/*
+ * Handler function for all compcache I/O requests.
+ */
+static int compcache_make_request(struct request_queue *queue, struct bio *bio)
+{
+	int ret, fwd_write_request = 0;
+	u32 offset;
+	size_t clen, index;
+	struct zobj_header *zheader;
+	struct page *page, *page_store;
+	unsigned char *user_mem, *cmem, *src;
+
+	if (bio_discard(bio)) {
+		compcache_discard(bio);
+		return 0;
+	}
+
+	if (!valid_swap_request(bio)) {
+		stat_inc(stats.invalid_io);
+		goto out;
+	}
+
+	page = bio->bi_io_vec[0].bv_page;
+	index = bio->bi_sector >> SECTORS_PER_PAGE_SHIFT;
+
+	switch (bio_data_dir(bio)) {
+	case READ:
+		stat_inc(stats.num_reads);
+
+		if (is_page_zero(index)) {
+			user_mem = get_ptr_atomic(page_to_pfn(page), 0,
+						KM_USER0);
+			memset(user_mem, 0, PAGE_SIZE);
+			put_ptr_atomic(user_mem, KM_USER0);
+			set_bit(BIO_UPTODATE, &bio->bi_flags);
+			bio_endio(bio, 0);
+			return 0;
+		}
+
+		/*
+		 * Requested page is not present in compressed area.
+		 * Its either in backing swap device (if present) or
+		 * this is an attempt to read before any previous write
+		 * to this location - this happens due to readahead when
+		 * swap device is read from user-space (e.g. during swapon)
+		 */
+		if (!compcache.table[index].pageNum) {
+			/*
+			 * Always forward such requests to backing swap
+			 * device (if present)
+			 */
+			if (compcache.backing_dev) {
+				stat_dec(stats.num_reads);
+				stat_inc(stats.bdev_num_reads);
+				bio->bi_bdev = compcache.backing_dev;
+				return 1;
+			}
+			/*
+			 * Its unlikely event in case backing dev is
+			 * not present
+			 */
+			pr_debug(C "Read before write on swap device: "
+				"sector=%lu, size=%u, offset=%u\n",
+				(ulong)(bio->bi_sector),
+				bio->bi_size,
+				bio->bi_io_vec[0].bv_offset);
+			user_mem = kmap(page);
+			memset(user_mem, 0, PAGE_SIZE);
+			kunmap(page);
+			set_bit(BIO_UPTODATE, &bio->bi_flags);
+			bio_endio(bio, 0);
+			return 0;
+		}
+
+		user_mem = get_ptr_atomic(page_to_pfn(page), 0, KM_USER0);
+
+		clen = PAGE_SIZE;
+		cmem = get_ptr_atomic(compcache.table[index].pageNum,
+				compcache.table[index].offset, KM_USER1);
+
+		/* Page is stored uncompressed since its incompressible */
+		if (unlikely(is_page_uncompressed(index))) {
+			memcpy(user_mem, cmem, PAGE_SIZE);
+			put_ptr_atomic(user_mem, KM_USER0);
+			put_ptr_atomic(cmem, KM_USER1);
+			set_bit(BIO_UPTODATE, &bio->bi_flags);
+			bio_endio(bio, 0);
+			return 0;
+		}
+
+		ret = lzo1x_decompress_safe(
+			cmem + sizeof(*zheader),
+			xvGetObjectSize(cmem) - sizeof(*zheader),
+			user_mem, &clen);
+
+		put_ptr_atomic(user_mem, KM_USER0);
+		put_ptr_atomic(cmem, KM_USER1);
+
+		/* should NEVER happen */
+		if (unlikely(ret != LZO_E_OK)) {
+			pr_err(C "Decompression failed! "
+				"err=%d, page=%zu\n",
+				ret, index);
+			stat_inc(stats.failed_reads);
+			goto out;
+		}
+
+		set_bit(BIO_UPTODATE, &bio->bi_flags);
+		bio_endio(bio, 0);
+		return 0;
+
+	case WRITE:
+		src = compcache.compress_buffer;
+		stat_inc(stats.num_writes);
+
+		/*
+		 * System swaps to same sector again when the stored page
+		 * is no longer referenced by any process. So, its now safe
+		 * to free the memory that was allocated for this page.
+		 */
+		if (compcache.table[index].pageNum)
+			compcache_free_page(index);
+
+		/*
+		 * No memory ia allocated for zero filled pages.
+		 * Simply clear zero page flag.
+		 */
+		if (is_page_zero(index)) {
+			stat_dec(stats.pages_zero);
+			clear_page_zero(index);
+		}
+
+		mutex_lock(&compcache.lock);
+
+		user_mem = get_ptr_atomic(page_to_pfn(page), 0, KM_USER0);
+		if (page_zero_filled(user_mem)) {
+			put_ptr_atomic(user_mem, KM_USER0);
+			mutex_unlock(&compcache.lock);
+			stat_inc(stats.pages_zero);
+			set_page_zero(index);
+			set_bit(BIO_UPTODATE, &bio->bi_flags);
+			bio_endio(bio, 0);
+			return 0;
+		}
+
+		if (compcache.backing_dev &&
+			(stats.compr_size > compcache.memlimit - PAGE_SIZE)) {
+			put_ptr_atomic(user_mem, KM_USER0);
+			mutex_unlock(&compcache.lock);
+			fwd_write_request = 1;
+			goto out;
+		}
+
+		ret = lzo1x_1_compress(user_mem, PAGE_SIZE,
+			src, &clen, compcache.compress_workmem);
+
+		put_ptr_atomic(user_mem, KM_USER0);
+
+		if (unlikely(ret != LZO_E_OK)) {
+			mutex_unlock(&compcache.lock);
+			pr_err(C "Compression failed! err=%d\n", ret);
+			stat_inc(stats.failed_writes);
+			goto out;
+		}
+
+		/* Page is incompressible - store it as is */
+		if (unlikely(clen > MAX_CPAGE_SIZE)) {
+			if (compcache.backing_dev) {
+				mutex_unlock(&compcache.lock);
+				fwd_write_request = 1;
+				goto out;
+			}
+			clen = PAGE_SIZE;
+			page_store = alloc_page(GFP_NOIO | __GFP_HIGHMEM);
+			if (unlikely(!page_store)) {
+				mutex_unlock(&compcache.lock);
+				stat_inc(stats.failed_writes);
+				goto out;
+			}
+			stat_inc(stats.pages_expand);
+			compcache.table[index].pageNum =
+						page_to_pfn(page_store);
+			set_page_uncompressed(index);
+			src = get_ptr_atomic(page_to_pfn(page), 0, KM_USER0);
+			offset = 0;
+		} else {
+			if (xvMalloc(compcache.mem_pool,
+				clen + sizeof(*zheader),
+				&compcache.table[index].pageNum,
+				&offset)) {
+				mutex_unlock(&compcache.lock);
+				pr_debug(C "Error allocating memory for "
+					"compressed page: %zu, size=%zu \n",
+					index, clen);
+				stat_inc(stats.failed_writes);
+				goto out;
+			}
+		}
+
+		compcache.table[index].offset = offset;
+
+		cmem = get_ptr_atomic(compcache.table[index].pageNum,
+				compcache.table[index].offset, KM_USER1);
+
+		if (!is_page_uncompressed(index)) {
+			zheader = (struct zobj_header *)cmem;
+			zheader->table_idx = index;
+			cmem += sizeof(*zheader);
+		}
+
+		memcpy(cmem, src, clen);
+
+		put_ptr_atomic(cmem, KM_USER1);
+		if (unlikely(is_page_uncompressed(index)))
+			put_ptr_atomic(src, KM_USER0);
+
+		/* Update stats */
+		stats.compr_size += clen;
+		stat_inc(stats.pages_stored);
+		stat_inc_if_less(stats.pages_expand, PAGE_SIZE - 1, clen);
+		stat_inc_if_less(stats.good_compress, clen, PAGE_SIZE/2 + 1);
+
+		mutex_unlock(&compcache.lock);
+
+		set_bit(BIO_UPTODATE, &bio->bi_flags);
+		bio_endio(bio, 0);
+		return 0;
+	}
+
+out:
+	if (fwd_write_request) {
+		stat_inc(stats.bdev_num_writes);
+		bio->bi_bdev = compcache.backing_dev;
+		return 1;
+	}
+
+	bio_io_error(bio);
+	return 0;
+}
+
+/*
+ * Swap header (1st page of swap device) contains information
+ * to indentify it as a swap partition. Prepare such a header
+ * for compcache device (ramzswap) so that swapon can identify
+ * it as swap partition. In case backing swap device is provided,
+ * copy its swap header.
+ */
+static int setup_swap_header(union swap_header *s)
+{
+	int ret = 0;
+	struct page *page;
+	struct address_space *mapping;
+	union swap_header *backing_dev_header;
+
+	/*
+	 * There is no backing swap device. Create a swap header
+	 * that is acceptable by swapon.
+	 */
+	if (compcache.backing_dev == NULL) {
+		s->info.version = 1;
+		s->info.last_page = compcache.disksize >> PAGE_SHIFT;
+		s->info.nr_badpages = 0;
+		memcpy(s->magic.magic, "SWAPSPACE2", 10);
+		return 0;
+	}
+
+	/*
+	 * We have a backing swap device. Copy its swap header
+	 * to compcache swap header. If this header contains
+	 * invalid information (backing device not a swap
+	 * partition, etc.), swapon will fail for compcache
+	 * which is correct behavior - we don't want to
+	 * swap over filesystem partition!
+	 */
+
+	/*
+	 * Read the backing swap header.
+	 * (code from sys_swapon)
+	 */
+
+	mapping = compcache.swap_file->f_mapping;
+	if (!mapping->a_ops->readpage) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	page = read_mapping_page(mapping, 0, compcache.swap_file);
+	if (IS_ERR(page)) {
+		ret = PTR_ERR(page);
+		goto out;
+	}
+
+	backing_dev_header = kmap(page);
+	*s = *backing_dev_header;
+	kunmap(page);
+
+out:
+	return ret;
+}
+
+static void compcache_set_disksize(size_t totalram_bytes)
+{
+	compcache.disksize = disksize_kb << 10;
+
+	if (!disksize_kb) {
+		pr_info(C
+		"disk size not provided. You can use disksize_kb module "
+		"param to specify size.\nUsing default: (%u%% of RAM).\n",
+		DEFAULT_DISKSIZE_PERC_RAM
+		);
+		compcache.disksize = DEFAULT_DISKSIZE_PERC_RAM *
+					(totalram_bytes / 100);
+	}
+
+	if (disksize_kb > 2 * (totalram_bytes >> 10)) {
+		pr_info(C
+		"There is little point creating a compcache of greater than "
+		"twice the size of memory since we expect a 2:1 compression "
+		"ratio. Note that compcache uses about 0.1%% of the size of "
+		"the swap device when not in use so a huge compcache is "
+		"wasteful.\n"
+		"\tMemory Size: %zu kB\n"
+		"\tSize you selected: %lu kB\n"
+		"Continuing anyway ...\n",
+		totalram_bytes >> 10, disksize_kb
+		);
+	}
+
+	compcache.disksize &= PAGE_MASK;
+
+	pr_info(C "disk size set to %zu kB\n", compcache.disksize >> 10);
+}
+
+/*
+ * memlimit cannot be greater than backing disk size.
+ */
+static void compcache_set_memlimit(size_t totalram_bytes)
+{
+	int memlimit_valid = 1;
+	compcache.memlimit = memlimit_kb << 10;
+
+	if (!compcache.memlimit) {
+		pr_info(C "memory limit not set. You can use "
+			"memlimit_kb module param to specify limit.");
+		memlimit_valid = 0;
+	}
+
+	if (compcache.memlimit > compcache.disksize) {
+		pr_info(C "memory limit cannot be greater than "
+			"disksize: limit=%zu, disksize=%zu",
+			compcache.memlimit,
+			compcache.disksize);
+		memlimit_valid = 0;
+	}
+
+	if (!memlimit_valid) {
+		size_t mempart, disksize;
+		pr_info(C "\nUsing default: MIN[(%u%% of RAM), "
+			"(backing disk size)].\n",
+			DEFAULT_MEMLIMIT_PERC_RAM);
+		mempart = DEFAULT_MEMLIMIT_PERC_RAM * (totalram_bytes / 100);
+		disksize = compcache.disksize;
+		compcache.memlimit = mempart > disksize ? disksize : mempart;
+	}
+
+	if (compcache.memlimit > totalram_bytes / 2) {
+		pr_info(C
+		"Its not advisable setting limit more than half of "
+		"size of memory since we expect a 2:1 compression ratio. "
+		"Limit represents amount of *compressed* data we can keep "
+		"in memory!\n"
+		"\tMemory Size: %zu kB\n"
+		"\tLimit you selected: %lu kB\n"
+		"Continuing anyway ...\n",
+		totalram_bytes >> 10, memlimit_kb
+		);
+	}
+
+	compcache.memlimit &= PAGE_MASK;
+	BUG_ON(!compcache.memlimit);
+
+	pr_info(C "memory limit set to %zu kB\n", compcache.memlimit >> 10);
+
+}
+
+static int __init compcache_init(void)
+{
+	int ret;
+	size_t num_pages, totalram_bytes;
+	struct sysinfo i;
+	struct page *page;
+	void *swap_header;
+
+	mutex_init(&compcache.lock);
+
+	ret = setup_backing_device();
+	if (ret)
+		goto fail;
+
+	si_meminfo(&i);
+	/* Here is a trivia: guess unit used for i.totalram !! */
+	totalram_bytes = i.totalram << PAGE_SHIFT;
+
+	if (compcache.backing_dev)
+		compcache_set_memlimit(totalram_bytes);
+	else
+		compcache_set_disksize(totalram_bytes);
+
+	compcache.compress_workmem = kmalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
+	if (compcache.compress_workmem == NULL) {
+		pr_err(C "Error allocating compressor working memory\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	compcache.compress_buffer = kmalloc(2 * PAGE_SIZE, GFP_KERNEL);
+	if (compcache.compress_buffer == NULL) {
+		pr_err(C "Error allocating compressor buffer space\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	num_pages = compcache.disksize >> PAGE_SHIFT;
+	compcache.table = vmalloc(num_pages * sizeof(*compcache.table));
+	if (compcache.table == NULL) {
+		pr_err(C "Error allocating compcache address table\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+	memset(compcache.table, 0, num_pages * sizeof(*compcache.table));
+
+	page = alloc_page(__GFP_ZERO);
+	if (page == NULL) {
+		pr_err(C "Error allocating swap header page\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+	compcache.table[0].pageNum = page_to_pfn(page);
+	set_page_uncompressed(0);
+
+	swap_header = kmap(page);
+	ret = setup_swap_header((union swap_header *)(swap_header));
+	kunmap(page);
+	if (ret) {
+		pr_err(C "Error setting swap header\n");
+		goto fail;
+	}
+
+	compcache.disk = alloc_disk(1);
+	if (compcache.disk == NULL) {
+		pr_err(C "Error allocating disk structure\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	compcache.disk->first_minor = 0;
+	compcache.disk->fops = &compcache_devops;
+	/*
+	 * It is named like this to prevent distro installers
+	 * from offering compcache as installation target. They
+	 * seem to ignore all devices beginning with 'ram'
+	 */
+	strcpy(compcache.disk->disk_name, "ramzswap0");
+
+	compcache.disk->major = register_blkdev(0, compcache.disk->disk_name);
+	if (compcache.disk->major < 0) {
+		pr_err(C "Cannot register block device\n");
+		ret = -EFAULT;
+		goto fail;
+	}
+
+	compcache.disk->queue = blk_alloc_queue(GFP_KERNEL);
+	if (compcache.disk->queue == NULL) {
+		pr_err(C "Cannot register disk queue\n");
+		ret = -EFAULT;
+		goto fail;
+	}
+
+	set_capacity(compcache.disk, compcache.disksize >> SECTOR_SHIFT);
+	blk_queue_make_request(compcache.disk->queue, compcache_make_request);
+
+	/*
+	 * Assuming backing device is "rotational" type.
+	 * TODO: check if its actually "non-rotational" (SSD).
+	 *
+	 * We have ident mapping of sectors for compcache and
+	 * and the backing swap device. So, this queue flag
+	 * should be according to backing dev.
+	 */
+	if (!compcache.backing_dev) {
+		queue_flag_set_unlocked(QUEUE_FLAG_NONROT,
+					compcache.disk->queue);
+	}
+	blk_queue_set_discard(compcache.disk->queue,
+				compcache_prepare_discard);
+	blk_queue_hardsect_size(compcache.disk->queue, PAGE_SIZE);
+	add_disk(compcache.disk);
+
+	compcache.mem_pool = xvCreateMemPool();
+	if (compcache.mem_pool == INVALID_POOL_ID) {
+		pr_err(C "Error creating memory pool\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+#if defined(STATS)
+	proc = create_proc_entry("compcache", S_IRUGO, NULL);
+	if (proc)
+		proc->read_proc = &proc_compcache_read;
+	else {
+		ret = -ENOMEM;
+		pr_warning(C "Error creating proc entry\n");
+		goto fail;
+	}
+#endif
+
+	/*
+	 * Pages that compress to size greater than this are forwarded
+	 * to physical swap disk (if backing dev is provided)
+	 */
+	if (compcache.backing_dev)
+		MAX_CPAGE_SIZE = MAX_CPAGE_SIZE_BDEV;
+	else
+		MAX_CPAGE_SIZE = MAX_CPAGE_SIZE_NOBDEV;
+
+	pr_debug(C "Max compressed page size: %u bytes\n", MAX_CPAGE_SIZE);
+
+	pr_debug(C "Initialization done!\n");
+	return 0;
+
+fail:
+	if (compcache.disk != NULL) {
+		if (compcache.disk->major > 0)
+			unregister_blkdev(compcache.disk->major,
+					compcache.disk->disk_name);
+		del_gendisk(compcache.disk);
+	}
+
+	if (compcache.table && compcache.table[0].pageNum)
+		__free_page(pfn_to_page(compcache.table[0].pageNum));
+	kfree(compcache.compress_workmem);
+	kfree(compcache.compress_buffer);
+	vfree(compcache.table);
+	xvDestroyMemPool(compcache.mem_pool);
+#if defined(STATS)
+	if (proc)
+		remove_proc_entry("compcache", proc->parent);
+#endif
+	pr_err(C "Initialization failed: err=%d\n", ret);
+	return ret;
+}
+
+static void __exit compcache_exit(void)
+{
+	size_t index, num_pages;
+	num_pages = compcache.disksize >> PAGE_SHIFT;
+
+	unregister_blkdev(compcache.disk->major, compcache.disk->disk_name);
+	del_gendisk(compcache.disk);
+
+	/* Close backing swap device (if present) */
+	if (compcache.backing_dev) {
+		set_blocksize(compcache.backing_dev, compcache.old_block_size);
+		bd_release(compcache.backing_dev);
+		filp_close(compcache.swap_file, NULL);
+	}
+
+	__free_page(pfn_to_page(compcache.table[0].pageNum));
+	kfree(compcache.compress_workmem);
+	kfree(compcache.compress_buffer);
+
+	/* Free all pages that are still in compcache */
+	for (index = 1; index < num_pages; index++) {
+		if (!compcache.table[index].pageNum)
+			continue;
+
+		if (unlikely(is_page_uncompressed(index))) {
+			__free_page(pfn_to_page(
+				compcache.table[index].pageNum));
+		} else {
+			xvFree(compcache.mem_pool,
+				compcache.table[index].pageNum,
+				compcache.table[index].offset);
+		}
+	}
+
+	vfree(compcache.table);
+	xvDestroyMemPool(compcache.mem_pool);
+
+#if defined(STATS)
+	remove_proc_entry("compcache", proc->parent);
+#endif
+	pr_debug(C "cleanup done!\n");
+}
+
+/*
+ * This param is applicable only when there is no backing swap device.
+ * We ignore this param in case backing dev is provided since then its
+ * always equal to size of the backing swap device.
+ *
+ * This size refers to amount of (uncompressed) data it can hold.
+ * For e.g. disksize_kb=1024 means it can hold 1024kb worth of
+ * uncompressed data even if this data compresses to just, say, 100kb.
+ *
+ * Default value is used if this param is missing or 0 (if its applicable).
+ * Default: [DEFAULT_DISKSIZE_PERC_RAM]% of RAM
+ */
+module_param(disksize_kb, ulong, 0);
+MODULE_PARM_DESC(disksize_kb, "compcache device size (kB)");
+
+/*
+ * This param is applicable only when backing swap device is provided.
+ * This refers to limit on amount of (compressed) data it can hold in
+ * memory. Note that total amount of memory used (MemUsedTotal) can
+ * exceed this memlimit since that includes memory wastage due to
+ * fragmentation and metadata overhead.
+ *
+ * Any additional data beyond this limit is forwarded to backing
+ * swap device. TODO: allow changing memlimit at runtime.
+ *
+ * Default value is used if this param is missing or 0 (if its applicable).
+ * Default: MIN([DEFAULT_MEMLIMIT_PERC_RAM]% of RAM, Backing Device Size)
+ */
+module_param(memlimit_kb, ulong, 0);
+MODULE_PARM_DESC(memlimit_kb, "compcache memory limit (kB)");
+
+/*
+ * This is block device to be used as backing store for compcache.
+ * When pages more than memlimit_kb as swapped to compcache, we store
+ * any additional pages in this device. We may also move some pages
+ * from compcache to this device in case system is really low on
+ * memory (TODO).
+ *
+ * This device is not directly visible to kernel as a swap device
+ * (/proc/swaps will only show /dev/ramzswap0 and not this device).
+ * Managing this backing device is the job of compcache module.
+ */
+module_param(backing_dev, charp, 0);
+MODULE_PARM_DESC(backing_dev, "Backing swap partition");
+
+module_init(compcache_init);
+module_exit(compcache_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Nitin Gupta <ngupta@vflare.org>");
+MODULE_DESCRIPTION("Compressed RAM Based Swap Device");
diff --git a/drivers/block/compcache.h b/drivers/block/compcache.h
new file mode 100644
index 0000000..23a58e7
--- /dev/null
+++ b/drivers/block/compcache.h
@@ -0,0 +1,160 @@
+/*
+ * Compressed RAM based swap device
+ *
+ * Copyright (C) 2008, 2009  Nitin Gupta
+ *
+ * This RAM based block device acts as swap disk.
+ * Pages swapped to this device are compressed and
+ * stored in memory.
+ *
+ * Released under the terms of the GNU General Public
+ * License (version 2). See linux/COPYING for more information.
+ *
+ * Project home: http://code.google.com/p/compcache
+ */
+
+#ifndef _COMPCACHE_H_
+#define _COMPCACHE_H_
+
+#include <linux/xvmalloc.h>
+
+/*
+ * Stored at beginning of each compressed object.
+ *
+ * It stores back-reference to table entry which points
+ * to this object. This will required when we implement
+ * memory defragmentation or migrating compressed pages
+ * to swap disk.
+ */
+struct zobj_header {
+	u32 table_idx;
+};
+
+/*-- Configurable parameters */
+
+/* Default compcache disk size: 25% of total RAM */
+#define DEFAULT_DISKSIZE_PERC_RAM	25
+#define DEFAULT_MEMLIMIT_PERC_RAM	15
+
+/*
+ * Max compressed page size when backing device is provided.
+ * Pages that compress to size greater than this are sent to
+ * physical swap disk.
+ */
+#define MAX_CPAGE_SIZE_BDEV	(PAGE_SIZE / 2)
+
+/*
+ * Max compressed page size when there is no backing dev.
+ * Pages that compress to size greater than this are stored
+ * uncompressed in memory.
+ */
+#define MAX_CPAGE_SIZE_NOBDEV	(PAGE_SIZE / 4 * 3)
+
+/*
+ * NOTE: MAX_CPAGE_SIZE_{BDEV,NOBDEV} sizes must be
+ * less than or equal to:
+ *   XV_MAX_ALLOC_SIZE - sizeof(struct zobj_header)
+ * since otherwise xvMalloc would always return failure.
+ */
+
+/*-- End of configurable params */
+
+#define SECTOR_SHIFT		9
+#define SECTOR_SIZE		(1 << SECTOR_SHIFT)
+#define SECTORS_PER_PAGE_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
+#define SECTORS_PER_PAGE	(1 << SECTORS_PER_PAGE_SHIFT)
+
+/* Message prefix */
+#define C "compcache: "
+
+/* Debugging and Stats */
+#define NOP	do { } while (0)
+
+#if defined(CONFIG_BLK_DEV_COMPCACHE_STATS)
+#define STATS
+#endif
+
+#if defined(STATS)
+#define stat_inc(stat)			((stat)++)
+#define stat_dec(stat)			((stat)--)
+#define stat_inc_if_less(stat, val1, val2) \
+				((stat) += ((val1) < (val2) ? 1 : 0))
+#define stat_dec_if_less(stat, val1, val2) \
+				((stat) -= ((val1) < (val2) ? 1 : 0))
+#else	/* STATS */
+#define stat_inc(x)			NOP
+#define stat_dec(x)			NOP
+#define stat_inc_if_less(x, v1, v2)	NOP
+#define stat_dec_if_less(x, v1, v2)	NOP
+#endif	/* STATS */
+
+/* Flags for compcache pages (table[page_no].flags) */
+enum cc_pageflags {
+	/* Page is stored uncompressed */
+	CC_uncompressed,
+
+	/* Page consists entirely of zeros */
+	CC_zero,
+
+	__NR_CC_PAGEFLAGS,
+};
+
+/*-- Data structures */
+
+/* Indexed by page no. */
+struct table {
+	u32 pageNum;
+	u16 offset;
+	u8 count;	/* object ref count (not yet used) */
+	u8 flags;
+};
+
+struct compcache {
+	struct Pool *mem_pool;
+	void *compress_workmem;
+	void *compress_buffer;
+	struct table *table;
+	struct mutex lock;
+	struct gendisk *disk;
+	/*
+	 * This is limit on compressed data size (stats.compr_size)
+	 * Its applicable only when backing swap device is present.
+	 */
+	size_t memlimit;	/* bytes */
+	/*
+	 * This is limit on amount of *uncompressed* worth of data
+	 * we can hold. When backing swap device is provided, it is
+	 * set equal to device size.
+	 */
+	size_t disksize;	/* bytes */
+
+
+	/* backing swap device info */
+	struct block_device *backing_dev;
+	struct file *swap_file;
+	int old_block_size;
+};
+
+struct compcache_stats {
+	/* basic stats */
+	size_t compr_size;	/* compressed size of pages stored -
+				 * needed to enforce memlimit */
+	/* more stats */
+#if defined(STATS)
+	u64 num_reads;		/* failed + successful */
+	u64 num_writes;		/* --do-- */
+	u64 failed_reads;	/* can happen when memory is too low */
+	u64 failed_writes;	/* should NEVER! happen */
+	u64 invalid_io;		/* non-swap I/O requests */
+	u64 pages_discard;	/* no. of pages freed by discard callback */
+	u32 pages_zero;		/* no. of zero filled pages */
+	u32 pages_stored;	/* no. of pages currently stored */
+	u32 good_compress;	/* no. of pages with compression ratio<=50% */
+	u32 pages_expand;	/* no. of incompressible pages */
+	u64 bdev_num_reads;	/* no. of reads on backing dev */
+	u64 bdev_num_writes;	/* no. of writes on backing dev */
+#endif
+};
+/*-- */
+
+#endif

