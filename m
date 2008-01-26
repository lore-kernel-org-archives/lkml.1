Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbYAZUpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbYAZUpg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 15:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbYAZUp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 15:45:28 -0500
Received: from verein.lst.de ([213.95.11.210]:47824 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbYAZUp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 15:45:27 -0500
Date: Sat, 26 Jan 2008 21:45:14 +0100
From: Christoph Hellwig <hch@lst.de>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kill do_generic_mapping_read
Message-ID: <20080126204514.GA10581@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_generic_mapping_read was used by gfs2 for internals reads, but this
use of the interface was rather suboptimal (as was the whole interface)
and has been replaced by an internal helper now.  This patch kills
do_generic_mapping_read and surrounding damage in preparation of additional
cleanups for the buffered read path.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-01-26 20:56:55.000000000 +0100
+++ linux-2.6/include/linux/fs.h	2008-01-26 20:57:12.000000000 +0100
@@ -1803,9 +1803,6 @@ extern ssize_t generic_file_buffered_wri
 		unsigned long, loff_t, loff_t *, size_t, ssize_t);
 extern ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos);
 extern ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos);
-extern void do_generic_mapping_read(struct address_space *mapping,
-				    struct file_ra_state *, struct file *,
-				    loff_t *, read_descriptor_t *, read_actor_t);
 extern int generic_segment_checks(const struct iovec *iov,
 		unsigned long *nr_segs, size_t *count, int access_flags);
 
@@ -1843,18 +1840,6 @@ static inline int xip_truncate_page(stru
 }
 #endif
 
-static inline void do_generic_file_read(struct file * filp, loff_t *ppos,
-					read_descriptor_t * desc,
-					read_actor_t actor)
-{
-	do_generic_mapping_read(filp->f_mapping,
-				&filp->f_ra,
-				filp,
-				ppos,
-				desc,
-				actor);
-}
-
 #ifdef CONFIG_BLOCK
 ssize_t __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	struct block_device *bdev, const struct iovec *iov, loff_t offset,
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2008-01-26 20:56:55.000000000 +0100
+++ linux-2.6/mm/filemap.c	2008-01-26 20:57:12.000000000 +0100
@@ -852,9 +852,7 @@ static void shrink_readahead_size_eio(st
 }
 
 /**
- * do_generic_mapping_read - generic file read routine
- * @mapping:	address_space to be read
- * @ra:		file's readahead state
+ * do_generic_file_read - generic file read routine
  * @filp:	the file to read
  * @ppos:	current file position
  * @desc:	read_descriptor
@@ -865,18 +863,13 @@ static void shrink_readahead_size_eio(st
  *
  * This is really ugly. But the goto's actually try to clarify some
  * of the logic when it comes to error handling etc.
- *
- * Note the struct file* is only passed for the use of readpage.
- * It may be NULL.
  */
-void do_generic_mapping_read(struct address_space *mapping,
-			     struct file_ra_state *ra,
-			     struct file *filp,
-			     loff_t *ppos,
-			     read_descriptor_t *desc,
-			     read_actor_t actor)
+static void do_generic_file_read(struct file *filp, loff_t *ppos,
+		read_descriptor_t *desc, read_actor_t actor)
 {
+	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
+	struct file_ra_state *ra = &filp->f_ra;
 	pgoff_t index;
 	pgoff_t last_index;
 	pgoff_t prev_index;
@@ -1065,7 +1058,6 @@ out:
 	if (filp)
 		file_accessed(filp);
 }
-EXPORT_SYMBOL(do_generic_mapping_read);
 
 int file_read_actor(read_descriptor_t *desc, struct page *page,
 			unsigned long offset, unsigned long size)
