Return-Path: <linux-kernel-owner+w=401wt.eu-S1759249AbZGGQUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249AbZGGQUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759202AbZGGQUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:20:33 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:19252 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759181AbZGGQUa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:20:30 -0400
MIME-Version: 1.0
Message-ID: <8fac37f5-450b-439e-a597-99ae02e3056d@default>
Date: Tue, 7 Jul 2009 09:18:21 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: npiggin@suse.de, akpm@osdl.org, jeremy@goop.org,
       xen-devel@lists.xensource.com, tmem-devel@oss.oracle.com,
       alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org, kurt.hackel@oracle.com,
       Rusty Russell <rusty@rustcorp.com.au>, Rik van Riel <riel@redhat.com>,
       dave.mccracken@oracle.com, Marcelo Tosatti <mtosatti@redhat.com>,
       sunil.mushran@oracle.com, Avi Kivity <avi@redhat.com>,
       Schwidefsky <schwidefsky@de.ibm.com>, chris.mason@oracle.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [RFC PATCH 2/4] (Take 2): tmem: Implement precache on top of tmem
 layer
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.2  (306040) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4A53757B.0085:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tmem [PATCH 2/4] (Take 2): Implement precache on top of tmem layer

Hooks added to existing page cache, VFS, and FS (ext3 only for now)
routines to:
1) create a tmem pool when filesystem is mounted and record its id
2) "put" clean pages that are being evicted
3) attempt to "get" pages prior to reading from a mounted FS and
   fallback to reading from the FS if "get" fails
4) "flush" as necessary to ensure coherency btwn page cache & precache
5) destroy the tmem pool when the FS is unmounted

Hooks for page cache and VFS placed by Chris Mason

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>


 fs/buffer.c                              |    5 
 fs/ext3/super.c                          |    2 
 fs/mpage.c                               |    8 +
 fs/super.c                               |    5 
 include/linux/fs.h                       |    7 +
 include/linux/precache.h                 |   50 +++++++
 mm/Kconfig                               |    8 +
 mm/Makefile                              |    1 
 mm/filemap.c                             |   11 +
 mm/precache.c                            |  134 +++++++++++++++++++++
 mm/truncate.c                            |   10 +
 11 files changed, 241 insertions(+)

--- linux-2.6.30/fs/super.c	2009-06-09 21:05:27.000000000 -0600
+++ linux-2.6.30-tmem/fs/super.c	2009-06-19 09:33:59.000000000 -0600
@@ -39,6 +39,7 @@
 #include <linux/mutex.h>
 #include <linux/file.h>
 #include <linux/async.h>
+#include <linux/precache.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -110,6 +111,9 @@ static struct super_block *alloc_super(s
 		s->s_qcop = sb_quotactl_ops;
 		s->s_op = &default_op;
 		s->s_time_gran = 1000000000;
+#ifdef CONFIG_PRECACHE
+		s->precache_poolid = -1;
+#endif
 	}
 out:
 	return s;
@@ -200,6 +204,7 @@ void deactivate_super(struct super_block
 		vfs_dq_off(s, 0);
 		down_write(&s->s_umount);
 		fs->kill_sb(s);
+		precache_flush_filesystem(s);
 		put_filesystem(fs);
 		put_super(s);
 	}
--- linux-2.6.30/fs/ext3/super.c	2009-06-09 21:05:27.000000000 -0600
+++ linux-2.6.30-tmem/fs/ext3/super.c	2009-06-19 09:33:59.000000000 -0600
@@ -37,6 +37,7 @@
 #include <linux/quotaops.h>
 #include <linux/seq_file.h>
 #include <linux/log2.h>
+#include <linux/precache.h>
 
 #include <asm/uaccess.h>
 
@@ -1306,6 +1307,7 @@ static int ext3_setup_super(struct super
 	} else {
 		printk("internal journal\n");
 	}
+	precache_init(sb);
 	return res;
 }
 
--- linux-2.6.30/include/linux/fs.h	2009-06-09 21:05:27.000000000 -0600
+++ linux-2.6.30-tmem/include/linux/fs.h	2009-06-19 09:33:59.000000000 -0600
@@ -1377,6 +1377,13 @@ struct super_block {
 	 * storage for asynchronous operations
 	 */
 	struct list_head s_async_list;
+
+#ifdef CONFIG_PRECACHE
+	/*
+	 * saved pool identifier for precache (-1 means none)
+	 */
+	u32 precache_poolid;
+#endif
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
--- linux-2.6.30/fs/buffer.c	2009-06-09 21:05:27.000000000 -0600
+++ linux-2.6.30-tmem/fs/buffer.c	2009-06-19 09:33:59.000000000 -0600
@@ -41,6 +41,7 @@
 #include <linux/bitops.h>
 #include <linux/mpage.h>
 #include <linux/bit_spinlock.h>
+#include <linux/precache.h>
 
 static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
 
@@ -271,6 +272,10 @@ void invalidate_bdev(struct block_device
 
 	invalidate_bh_lrus();
 	invalidate_mapping_pages(mapping, 0, -1);
+	/* 99% of the time, we don't need to flush the precache on the bdev.
+	 * But, for the strange corners, lets be cautious
+	 */
+	precache_flush_inode(mapping);
 }
 
 /*
--- linux-2.6.30/fs/mpage.c	2009-06-09 21:05:27.000000000 -0600
+++ linux-2.6.30-tmem/fs/mpage.c	2009-06-19 09:33:59.000000000 -0600
@@ -26,6 +26,7 @@
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
 #include <linux/pagevec.h>
+#include <linux/precache.h>
 
 /*
  * I/O completion handler for multipage BIOs.
@@ -285,6 +286,13 @@ do_mpage_readpage(struct bio *bio, struc
 		SetPageMappedToDisk(page);
 	}
 
+	if (fully_mapped &&
+	    blocks_per_page == 1 && !PageUptodate(page) &&
+	    precache_get(page->mapping, page->index, page) == 1) {
+		SetPageUptodate(page);
+		goto confused;
+	}
+
 	/*
 	 * This page will go to BIO.  Do we need to send this BIO off first?
 	 */
--- linux-2.6.30/mm/truncate.c	2009-06-09 21:05:27.000000000 -0600
+++ linux-2.6.30-tmem/mm/truncate.c	2009-06-19 09:37:42.000000000 -0600
@@ -18,6 +18,7 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/buffer_head.h>	/* grr. try_to_release_page,
 				   do_invalidatepage */
+#include <linux/precache.h>
 #include "internal.h"
 
 
@@ -50,6 +51,7 @@ void do_invalidatepage(struct page *page
 static inline void truncate_partial_page(struct page *page, unsigned partial)
 {
 	zero_user_segment(page, partial, PAGE_CACHE_SIZE);
+	precache_flush(page->mapping, page->index);
 	if (page_has_private(page))
 		do_invalidatepage(page, partial);
 }
@@ -107,6 +109,10 @@ truncate_complete_page(struct address_sp
 	clear_page_mlock(page);
 	remove_from_page_cache(page);
 	ClearPageMappedToDisk(page);
+	/* this must be after the remove_from_page_cache which
+	 * calls precache_put
+	 */
+	precache_flush(mapping, page->index);
 	page_cache_release(page);	/* pagecache ref */
 }
 
@@ -168,6 +174,7 @@ void truncate_inode_pages_range(struct a
 	pgoff_t next;
 	int i;
 
+	precache_flush_inode(mapping);
 	if (mapping->nrpages == 0)
 		return;
 
@@ -251,6 +258,7 @@ void truncate_inode_pages_range(struct a
 		}
 		pagevec_release(&pvec);
 	}
+	precache_flush_inode(mapping);
 }
 EXPORT_SYMBOL(truncate_inode_pages_range);
 
@@ -398,6 +406,7 @@ int invalidate_inode_pages2_range(struct
 	int did_range_unmap = 0;
 	int wrapped = 0;
 
+	precache_flush_inode(mapping);
 	pagevec_init(&pvec, 0);
 	next = start;
 	while (next <= end && !wrapped &&
@@ -454,6 +463,7 @@ int invalidate_inode_pages2_range(struct
 		pagevec_release(&pvec);
 		cond_resched();
 	}
+	precache_flush_inode(mapping);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(invalidate_inode_pages2_range);
--- linux-2.6.30/mm/filemap.c	2009-06-09 21:05:27.000000000 -0600
+++ linux-2.6.30-tmem/mm/filemap.c	2009-06-19 09:33:59.000000000 -0600
@@ -34,6 +34,7 @@
 #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
 #include <linux/memcontrol.h>
 #include <linux/mm_inline.h> /* for page_is_file_cache() */
+#include <linux/precache.h>
 #include "internal.h"
 
 /*
@@ -116,6 +117,16 @@ void __remove_from_page_cache(struct pag
 {
 	struct address_space *mapping = page->mapping;
 
+	/*
+	 * if we're uptodate, flush out into the precache, otherwise
+	 * invalidate any existing precache entries.  We can't leave
+	 * stale data around in the precache once our page is gone
+	 */
+	if (PageUptodate(page))
+		precache_put(page->mapping, page->index, page);
+	else
+		precache_flush(page->mapping, page->index);
+
 	radix_tree_delete(&mapping->page_tree, page->index);
 	page->mapping = NULL;
 	mapping->nrpages--;
--- linux-2.6.30/include/linux/precache.h	1969-12-31 17:00:00.000000000 -0700
+++ linux-2.6.30-tmem/include/linux/precache.h	2009-07-06 15:46:16.000000000 -0600
@@ -0,0 +1,50 @@
+#ifndef _LINUX_PRECACHE_H
+
+#include <linux/fs.h>
+#include <linux/mm.h>
+
+#ifdef CONFIG_PRECACHE
+extern void precache_init(struct super_block *sb);
+extern int precache_get(struct address_space *mapping, unsigned long index,
+	       struct page *empty_page);
+extern int precache_put(struct address_space *mapping, unsigned long index,
+		struct page *page);
+extern int precache_flush(struct address_space *mapping, unsigned long index);
+extern int precache_flush_inode(struct address_space *mapping);
+extern int precache_flush_filesystem(struct super_block *s);
+#else
+static inline void precache_init(struct super_block *sb)
+{
+}
+
+static inline int precache_get(struct address_space *mapping,
+		unsigned long index, struct page *empty_page)
+{
+	return 0;
+}
+
+static inline int precache_put(struct address_space *mapping,
+		unsigned long index, struct page *page)
+{
+	return 0;
+}
+
+static inline int precache_flush(struct address_space *mapping,
+		unsigned long index)
+{
+	return 0;
+}
+
+static inline int precache_flush_inode(struct address_space *mapping)
+{
+	return 0;
+}
+
+static inline int precache_flush_filesystem(struct super_block *s)
+{
+	return 0;
+}
+#endif
+
+#define _LINUX_PRECACHE_H
+#endif /* _LINUX_PRECACHE_H */
--- linux-2.6.30/mm/precache.c	1969-12-31 17:00:00.000000000 -0700
+++ linux-2.6.30-tmem/mm/precache.c	2009-07-06 15:50:04.000000000 -0600
@@ -0,0 +1,134 @@
+/*
+ * linux/mm/precache.c
+ *
+ * Implements "precache" for filesystems/pagecache on top of transcendent
+ * memory ("tmem") API.  A filesystem creates an "ephemeral tmem pool"
+ * and retains the returned pool_id in its superblock.  Clean pages evicted
+ * from pagecache may be "put" into the pool and associated with a "handle"
+ * consisting of the pool_id, an object (inode) id, and an index (page offset).
+ * Note that the page is copied to tmem; no kernel mappings are changed.
+ * If the page is later needed, the filesystem (or VFS) issues a "get", passing
+ * the same handle and an empty pageframe.  If successful, the page is copied
+ * into the pageframe and a disk read is avoided.  But since the tmem pool
+ * is of indeterminate size, a "put" page has indeterminate longevity
+ * ("ephemeral"), and the "get" may fail, in which case the filesystem must
+ * read the page from disk as before.  Note that the filesystem/pagecache are
+ * responsible for maintaining coherency between the pagecache, precache,
+ * and the disk, for which "flush page" and "flush object" actions are
+ * provided.  And when a filesystem is unmounted, it must "destroy" the pool.
+ *
+ * Tmem supports two different modes for a precache: "private" or "shared".
+ * Shared pools are still under development. For a private pool, a successful
+ * "get" always flushes, implementing "exclusive cache" semantics.  Note
+ * that a failed "duplicate" put (overwrite) always guarantees the old data
+ * is flushed.
+ *
+ * Note also that multiple accesses to a tmem pool may be concurrent and any
+ * ordering must be guaranteed by the caller.
+ *
+ * Copyright (C) 2008,2009 Dan Magenheimer, Oracle Corp.
+ */
+
+#include <linux/precache.h>
+#include <linux/module.h>
+#include <linux/tmem.h>
+
+static int precache_auto_allocate; /* set to 1 to auto_allocate */
+
+int precache_put(struct address_space *mapping, unsigned long index,
+ struct page *page)
+{
+	u32 tmem_pool = mapping->host->i_sb->precache_poolid;
+	u64 obj = (unsigned long) mapping->host->i_ino;
+	u32 ind = (u32) index;
+	unsigned long pfn = page_to_pfn(page);
+	struct tmem_pool_uuid uuid_private = TMEM_POOL_PRIVATE_UUID;
+	int ret;
+
+	if ((s32)tmem_pool < 0) {
+		if (!precache_auto_allocate)
+			return 0;
+		/* a put on a non-existent precache may auto-allocate one */
+		ret = tmem_new_pool(uuid_private, 0);
+		if (ret < 0)
+			return 0;
+		printk(KERN_INFO
+			"Mapping superblock for s_id=%s to precache_id=%d\n",
+			mapping->host->i_sb->s_id, tmem_pool);
+		mapping->host->i_sb->precache_poolid = tmem_pool;
+	}
+	if (ind != index)
+		return 0;
+	mb(); /* ensure page is quiescent; tmem may address it with an alias */
+	return tmem_put_page(tmem_pool, obj, ind, pfn);
+}
+
+int precache_get(struct address_space *mapping, unsigned long index,
+ struct page *empty_page)
+{
+	u32 tmem_pool = mapping->host->i_sb->precache_poolid;
+	u64 obj = (unsigned long) mapping->host->i_ino;
+	u32 ind = (u32) index;
+	unsigned long pfn = page_to_pfn(empty_page);
+
+	if ((s32)tmem_pool < 0)
+		return 0;
+	if (ind != index)
+		return 0;
+
+	return tmem_get_page(tmem_pool, obj, ind, pfn);
+}
+EXPORT_SYMBOL(precache_get);
+
+int precache_flush(struct address_space *mapping, unsigned long index)
+{
+	u32 tmem_pool = mapping->host->i_sb->precache_poolid;
+	u64 obj = (unsigned long) mapping->host->i_ino;
+	u32 ind = (u32) index;
+
+	if ((s32)tmem_pool < 0)
+		return 0;
+	if (ind != index)
+		return 0;
+
+	return tmem_flush_page(tmem_pool, obj, ind);
+}
+EXPORT_SYMBOL(precache_flush);
+
+int precache_flush_inode(struct address_space *mapping)
+{
+	u32 tmem_pool = mapping->host->i_sb->precache_poolid;
+	u64 obj = (unsigned long) mapping->host->i_ino;
+
+	if ((s32)tmem_pool < 0)
+		return 0;
+
+	return tmem_flush_object(tmem_pool, obj);
+}
+EXPORT_SYMBOL(precache_flush_inode);
+
+int precache_flush_filesystem(struct super_block *sb)
+{
+	u32 tmem_pool = sb->precache_poolid;
+	int ret;
+
+	if ((s32)tmem_pool < 0)
+		return 0;
+	ret = tmem_destroy_pool(tmem_pool);
+	if (!ret)
+		return 0;
+	printk(KERN_INFO
+		"Unmapping superblock for s_id=%s from precache_id=%d\n",
+		sb->s_id, ret);
+	sb->precache_poolid = 0;
+	return 1;
+}
+EXPORT_SYMBOL(precache_flush_filesystem);
+
+void precache_init(struct super_block *sb)
+{
+	struct tmem_pool_uuid uuid_private = TMEM_POOL_PRIVATE_UUID;
+
+	sb->precache_poolid = tmem_new_pool(uuid_private, 0);
+}
+EXPORT_SYMBOL(precache_init);
--- linux-2.6.30-tmem-tmem/mm/Kconfig	2009-07-06 16:36:31.000000000 -0600
+++ linux-2.6.30-tmem-precache/mm/Kconfig	2009-07-06 16:37:05.000000000 -0600
@@ -263,3 +263,11 @@ config TMEM
 	  In a virtualized environment, allows unused and underutilized
 	  system physical memory to be made accessible through a narrow
 	  well-defined page-copy-based API.
+
+config PRECACHE
+	bool "Cache clean pages in transcendent memory"
+	depends on TMEM
+	help
+	  Allows the transcendent memory pool to be used to store clean
+	  page-cache pages which, under some circumstances, will greatly
+	  reduce paging and thus improve performance.
--- linux-2.6.30-tmem-tmem/mm/Makefile	2009-07-06 16:36:52.000000000 -0600
+++ linux-2.6.30-tmem-precache/mm/Makefile	2009-07-06 16:37:10.000000000 -0600
@@ -17,6 +17,7 @@ obj-$(CONFIG_PROC_PAGE_MONITOR) += pagew
 obj-$(CONFIG_BOUNCE)	+= bounce.o
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
 obj-$(CONFIG_TMEM)	+= tmem.o
+obj-$(CONFIG_PRECACHE)	+= precache.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o
 obj-$(CONFIG_NUMA) 	+= mempolicy.o
