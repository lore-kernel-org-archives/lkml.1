Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbYFXGBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbYFXGBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 02:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbYFXGBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 02:01:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbYFXGBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 02:01:06 -0400
Date: Tue, 24 Jun 2008 02:01:04 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
cc: davem@davemloft.net
Subject: [8/10 PATCH] inline filemap_fdatawrite
In-Reply-To: <Pine.LNX.4.64.0806240154140.27784@engineering.redhat.com>
Message-ID: <Pine.LNX.4.64.0806240159520.27784@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240136200.27784@engineering.redhat.com>
 <Pine.LNX.4.64.0806240154140.27784@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make filemap_fdatawrite and filemap_flush calls inlined.

This needs to move WB_SYNC_* definitions from writeback.h to fs.h.
writeback.h requires fs.h, so it creates no problem.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6.26-rc7-devel/include/linux/fs.h
===================================================================
--- linux-2.6.26-rc7-devel.orig/include/linux/fs.h	2008-06-24 07:28:06.000000000 +0200
+++ linux-2.6.26-rc7-devel/include/linux/fs.h	2008-06-24 07:37:48.000000000 +0200
@@ -1731,8 +1731,6 @@
  extern int invalidate_inode_pages2_range(struct address_space *mapping,
  					 pgoff_t start, pgoff_t end);
  extern int write_inode_now(struct inode *, int);
-extern int filemap_fdatawrite(struct address_space *);
-extern int filemap_flush(struct address_space *);
  extern int filemap_fdatawait(struct address_space *);
  extern int filemap_write_and_wait(struct address_space *mapping);
  extern int filemap_write_and_wait_range(struct address_space *mapping,
@@ -1742,6 +1740,38 @@
  extern int __filemap_fdatawrite_range(struct address_space *mapping,
  				loff_t start, loff_t end, int sync_mode);

+/*
+ * fs/fs-writeback.c
+ */
+enum writeback_sync_modes {
+	WB_SYNC_NONE,	/* Don't wait on anything */
+	WB_SYNC_ALL,	/* Wait on every mapping */
+	WB_SYNC_HOLD,	/* Hold the inode on sb_dirty for sys_sync() */
+};
+
+static __always_inline int __filemap_fdatawrite(struct address_space *mapping,
+	int sync_mode)
+{
+	return __filemap_fdatawrite_range(mapping, 0, LLONG_MAX, sync_mode);
+}
+
+static __always_inline int filemap_fdatawrite(struct address_space *mapping)
+{
+	return __filemap_fdatawrite(mapping, WB_SYNC_ALL);
+}
+
+/**
+ * filemap_flush - mostly a non-blocking flush
+ * @mapping:	target address_space
+ *
+ * This is a mostly non-blocking flush.  Not suitable for data-integrity
+ * purposes - I/O may not be started against all dirty pages.
+ */
+static __always_inline int filemap_flush(struct address_space *mapping)
+{
+	return __filemap_fdatawrite(mapping, WB_SYNC_NONE);
+}
+
  extern long do_fsync(struct file *file, int datasync);
  extern void sync_supers(void);
  extern void sync_filesystems(int wait);
@@ -2000,7 +2030,10 @@
  extern int simple_pin_fs(struct file_system_type *, struct vfsmount **mount, int *count);
  extern void simple_release_fs(struct vfsmount **mount, int *count);

-extern ssize_t simple_read_from_buffer(void __user *, size_t, loff_t *, const void *, size_t);
+extern ssize_t simple_read_from_buffer(void __user *to, size_t count,
+			loff_t *ppos, const void *from, size_t available);
+extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
+			const void *from, size_t available);

  #ifdef CONFIG_MIGRATION
  extern int buffer_migrate_page(struct address_space *,
Index: linux-2.6.26-rc7-devel/include/linux/writeback.h
===================================================================
--- linux-2.6.26-rc7-devel.orig/include/linux/writeback.h	2008-06-24 07:28:07.000000000 +0200
+++ linux-2.6.26-rc7-devel/include/linux/writeback.h	2008-06-24 07:37:49.000000000 +0200
@@ -25,15 +25,6 @@
  #define current_is_pdflush()	task_is_pdflush(current)

  /*
- * fs/fs-writeback.c
- */
-enum writeback_sync_modes {
-	WB_SYNC_NONE,	/* Don't wait on anything */
-	WB_SYNC_ALL,	/* Wait on every mapping */
-	WB_SYNC_HOLD,	/* Hold the inode on sb_dirty for sys_sync() */
-};
-
-/*
   * A control structure which tells the writeback code what to do.  These are
   * always on the stack, and hence need no locking.  They are always initialised
   * in a manner such that unspecified fields are set to zero.
Index: linux-2.6.26-rc7-devel/mm/filemap.c
===================================================================
--- linux-2.6.26-rc7-devel.orig/mm/filemap.c	2008-06-24 07:28:07.000000000 +0200
+++ linux-2.6.26-rc7-devel/mm/filemap.c	2008-06-24 07:37:49.000000000 +0200
@@ -223,39 +223,15 @@
  	ret = do_writepages(mapping, &wbc);
  	return ret;
  }
+EXPORT_SYMBOL(__filemap_fdatawrite_range);

-static inline int __filemap_fdatawrite(struct address_space *mapping,
-	int sync_mode)
-{
-	return __filemap_fdatawrite_range(mapping, 0, LLONG_MAX, sync_mode);
-}
-
-int filemap_fdatawrite(struct address_space *mapping)
-{
-	return __filemap_fdatawrite(mapping, WB_SYNC_ALL);
-}
-EXPORT_SYMBOL(filemap_fdatawrite);
-
-static int filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
+static __always_inline int filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
  				loff_t end)
  {
  	return __filemap_fdatawrite_range(mapping, start, end, WB_SYNC_ALL);
  }

  /**
- * filemap_flush - mostly a non-blocking flush
- * @mapping:	target address_space
- *
- * This is a mostly non-blocking flush.  Not suitable for data-integrity
- * purposes - I/O may not be started against all dirty pages.
- */
-int filemap_flush(struct address_space *mapping)
-{
-	return __filemap_fdatawrite(mapping, WB_SYNC_NONE);
-}
-EXPORT_SYMBOL(filemap_flush);
-
-/**
   * wait_on_page_writeback_range - wait for writeback to complete
   * @mapping:	target address_space
   * @start:	beginning page index

