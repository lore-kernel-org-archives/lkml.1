Return-Path: <linux-kernel-owner+w=401wt.eu-S1760464AbZFTBgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464AbZFTBgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZFTBgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:36:38 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:30211 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759432AbZFTBgh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:36:37 -0400
MIME-Version: 1.0
Message-ID: <67c05b05-c8e2-4e8f-a234-52a86e657404@default>
Date: Fri, 19 Jun 2009 18:35:47 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: dan.magenheimer@oracle.com, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, npiggin@suse.de, chris.mason@oracle.com,
       kurt.hackel@oracle.com, dave.mccracken@oracle.com,
       Avi Kivity <avi@redhat.com>, jeremy@goop.org,
       Rik van Riel <riel@redhat.com>, alan@lxorguk.ukuu.org.uk,
       Rusty Russell <rusty@rustcorp.com.au>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@osdl.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, tmem-devel@oss.oracle.com,
       sunil.mushran@oracle.com, linux-mm@kvack.org
Subject: [RFC PATCH 2/4] tmem: precache implementation (layered on tmem)
In-Reply-To: <cd40cd91-66e9-469d-b079-3a899a3ccadb@default>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1 (304090) [OL 9.0.0.6627]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.4A3C3CF7.003E:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 --- linux-2.6.30/fs/super.c	2009-06-09 21:05:27.000000000 -0600
+++ linux-2.6.30-tmem/fs/super.c	2009-06-19 09:33:59.000000000 -0600
@@ -39,6 +39,7 @@
 #include <linux/mutex.h>
 #include <linux/file.h>
 #include <linux/async.h>
+#include <linux/precache.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -110,6 +111,9 @@
 		s->s_qcop = sb_quotactl_ops;
 		s->s_op = &default_op;
 		s->s_time_gran = 1000000000;
+#ifdef CONFIG_PRECACHE
+		s->precache_poolid = -1;
+#endif
 	}
 out:
 	return s;
@@ -200,6 +204,7 @@
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
 
@@ -1306,6 +1307,7 @@
 	} else {
 		printk("internal journal\n");
 	}
+	precache_init(sb);
 	return res;
 }
 
--- linux-2.6.30/fs/ocfs2/super.c	2009-06-09 21:05:27.000000000 -0600
+++ linux-2.6.30-tmem/fs/ocfs2/super.c	2009-06-19 09:33:59.000000000 -0600
@@ -42,6 +42,7 @@
 #include <linux/mount.h>
 #include <linux/seq_file.h>
 #include <linux/quotaops.h>
+#include <linux/precache.h>
 
 #define MLOG_MASK_PREFIX ML_SUPER
 #include <cluster/masklog.h>
@@ -2162,6 +2163,7 @@
 		mlog_errno(status);
 		goto bail;
 	}
+	shared_precache_init(sb, &di->id2.i_super.s_uuid[0]);
 
 bail:
 	mlog_exit(status);
--- linux-2.6.30/include/linux/fs.h	2009-06-09 21:05:27.000000000 -0600
+++ linux-2.6.30-tmem/include/linux/fs.h	2009-06-19 09:33:59.000000000 -0600
@@ -1377,6 +1377,13 @@
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
 
@@ -271,6 +272,10 @@
 
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
@@ -285,6 +286,13 @@
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
 
 
@@ -50,6 +51,7 @@
 static inline void truncate_partial_page(struct page *page, unsigned partial)
 {
 	zero_user_segment(page, partial, PAGE_CACHE_SIZE);
+	precache_flush(page->mapping, page->index);
 	if (page_has_private(page))
 		do_invalidatepage(page, partial);
 }
@@ -107,6 +109,10 @@
 	clear_page_mlock(page);
 	remove_from_page_cache(page);
 	ClearPageMappedToDisk(page);
+	/* this must be after the remove_from_page_cache which
+	 * calls precache_put
+	 */
+	precache_flush(mapping, page->index);
 	page_cache_release(page);	/* pagecache ref */
 }
 
@@ -168,6 +174,7 @@
 	pgoff_t next;
 	int i;
 
+	precache_flush_inode(mapping);
 	if (mapping->nrpages == 0)
 		return;
 
@@ -251,6 +258,7 @@
 		}
 		pagevec_release(&pvec);
 	}
+	precache_flush_inode(mapping);
 }
 EXPORT_SYMBOL(truncate_inode_pages_range);
 
@@ -398,6 +406,7 @@
 	int did_range_unmap = 0;
 	int wrapped = 0;
 
+	precache_flush_inode(mapping);
 	pagevec_init(&pvec, 0);
 	next = start;
 	while (next <= end && !wrapped &&
@@ -454,6 +463,7 @@
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
@@ -116,6 +117,16 @@
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
+++ linux-2.6.30-tmem/include/linux/precache.h	2009-06-19 09:33:59.000000000 -0600
@@ -0,0 +1,55 @@
+#ifndef _LINUX_PRECACHE_H
+
+#include <linux/fs.h>
+#include <linux/mm.h>
+
+#ifdef CONFIG_PRECACHE
+extern void precache_init(struct super_block *sb);
+extern void shared_precache_init(struct super_block *sb, char *uuid);
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
+static inline void shared_precache_init(struct super_block *sb, char *uuid)
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
+++ linux-2.6.30-tmem/mm/precache.c	2009-06-19 15:03:32.000000000 -0600
@@ -0,0 +1,146 @@
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
+ * Two types of pools may be created for a precache: "private" or "shared".
+ * For a private pool, a successful "get" always flushes, implementing
+ * exclusive semantics; for a "shared" pool (which is intended for use by
+ * co-resident nodes of a cluster filesystem), the "flush" is not guaranteed.
+ * In either case, a failed "duplicate" put (overwrite) always guarantee
+ * the old data is flushed.
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
+	int ret;
+
+	if ((s32)tmem_pool < 0) {
+		if (!precache_auto_allocate)
+			return 0;
+		/* a put on a non-existent precache may auto-allocate one */
+		if (tmem_ops == NULL)
+			return 0;
+		ret = (*tmem_ops->new_pool)(0, 0, 0);
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
+	return (*tmem_ops->put_page)(tmem_pool, obj, ind, pfn);
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
+	return (tmem_ops->get_page)(tmem_pool, obj, ind, pfn);
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
+	return (*tmem_ops->flush_page)(tmem_pool, obj, ind);
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
+	return (*tmem_ops->flush_object)(tmem_pool, obj);
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
+	ret = (*tmem_ops->destroy_pool)(tmem_pool);
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
+	if (tmem_ops != NULL)
+		sb->precache_poolid = (*tmem_ops->new_pool)(0, 0, 0);
+}
+EXPORT_SYMBOL(precache_init);
+
+void shared_precache_init(struct super_block *sb, char *uuid)
+{
+	u64 uuid_lo = *(u64 *)uuid;
+	u64 uuid_hi = *(u64 *)(&uuid[8]);
+
+	if (tmem_ops != NULL)
+		sb->precache_poolid =(*tmem_ops->new_pool)(uuid_lo, uuid_hi,
+			TMEM_POOL_SHARED);
+}
+EXPORT_SYMBOL(shared_precache_init);
