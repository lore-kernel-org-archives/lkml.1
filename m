Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbZDNRuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbZDNRuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757076AbZDNRtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:49:23 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56531 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980AbZDNRtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:49:21 -0400
Message-Id: <20090414174859.496563416@szeredi.hu>
References: <20090414174835.487031939@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 14 Apr 2009 19:48:40 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: jens.axboe@oracle.com, mfasheh@suse.com
Cc: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 5/6] splice: remove generic_file_splice_write_nolock()
Content-Disposition: inline; filename=splice_remove_unneeded_func.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the now unused generic_file_splice_write_nolock() function.
It's conceptually broken anyway, because splice may need to wait for
pipe events so holding locks across the whole operation is wrong.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/splice.c        |   59 -----------------------------------------------------
 include/linux/fs.h |    2 -
 2 files changed, 61 deletions(-)

Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c	2009-04-14 18:36:32.000000000 +0200
+++ linux-2.6/fs/splice.c	2009-04-14 19:01:16.000000000 +0200
@@ -811,65 +811,6 @@ ssize_t splice_from_pipe(struct pipe_ino
 }
 
 /**
- * generic_file_splice_write_nolock - generic_file_splice_write without mutexes
- * @pipe:	pipe info
- * @out:	file to write to
- * @ppos:	position in @out
- * @len:	number of bytes to splice
- * @flags:	splice modifier flags
- *
- * Description:
- *    Will either move or copy pages (determined by @flags options) from
- *    the given pipe inode to the given file. The caller is responsible
- *    for acquiring i_mutex on both inodes.
- *
- */
-ssize_t
-generic_file_splice_write_nolock(struct pipe_inode_info *pipe, struct file *out,
-				 loff_t *ppos, size_t len, unsigned int flags)
-{
-	struct address_space *mapping = out->f_mapping;
-	struct inode *inode = mapping->host;
-	struct splice_desc sd = {
-		.total_len = len,
-		.flags = flags,
-		.pos = *ppos,
-		.u.file = out,
-	};
-	ssize_t ret;
-	int err;
-
-	err = file_remove_suid(out);
-	if (unlikely(err))
-		return err;
-
-	ret = __splice_from_pipe(pipe, &sd, pipe_to_file);
-	if (ret > 0) {
-		unsigned long nr_pages;
-
-		*ppos += ret;
-		nr_pages = (ret + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-
-		/*
-		 * If file or inode is SYNC and we actually wrote some data,
-		 * sync it.
-		 */
-		if (unlikely((out->f_flags & O_SYNC) || IS_SYNC(inode))) {
-			err = generic_osync_inode(inode, mapping,
-						  OSYNC_METADATA|OSYNC_DATA);
-
-			if (err)
-				ret = err;
-		}
-		balance_dirty_pages_ratelimited_nr(mapping, nr_pages);
-	}
-
-	return ret;
-}
-
-EXPORT_SYMBOL(generic_file_splice_write_nolock);
-
-/**
  * generic_file_splice_write - splice data from a pipe to a file
  * @pipe:	pipe info
  * @out:	file to write to
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2009-04-14 16:35:15.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2009-04-14 19:01:16.000000000 +0200
@@ -2150,8 +2150,6 @@ extern ssize_t generic_file_splice_read(
 		struct pipe_inode_info *, size_t, unsigned int);
 extern ssize_t generic_file_splice_write(struct pipe_inode_info *,
 		struct file *, loff_t *, size_t, unsigned int);
-extern ssize_t generic_file_splice_write_nolock(struct pipe_inode_info *,
-		struct file *, loff_t *, size_t, unsigned int);
 extern ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe,
 		struct file *out, loff_t *, size_t len, unsigned int flags);
 extern long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,

--
