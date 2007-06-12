Return-Path: <linux-kernel-owner+w=401wt.eu-S1759057AbXFLHCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057AbXFLHCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbXFLHAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:00:37 -0400
Received: from brick.kernel.dk ([80.160.20.94]:13571 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbXFLHAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:00:32 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 7/18] loop: convert to using splice_direct_to_actor() instead of sendfile()
Date: Tue, 12 Jun 2007 08:58:03 +0200
Message-Id: <118163149557-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.1.174.gcd03
In-Reply-To: <11816314942627-git-send-email-jens.axboe@oracle.com>
References: <11816314942627-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This gets rid of the dependency on ->sendfile() for receiving data
and converts loop to ->splice_read() instead.

Also includes an IV offset fix from Hugh Dickins.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/block/loop.c |   64 ++++++++++++++++++++++++++++++++++---------------
 1 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 0ed5470..562d329 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -74,6 +74,7 @@
 #include <linux/highmem.h>
 #include <linux/gfp.h>
 #include <linux/kthread.h>
+#include <linux/pipe_fs_i.h>
 
 #include <asm/uaccess.h>
 
@@ -401,50 +402,73 @@ struct lo_read_data {
 };
 
 static int
-lo_read_actor(read_descriptor_t *desc, struct page *page,
-	      unsigned long offset, unsigned long size)
+lo_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
+		struct splice_desc *sd)
 {
-	unsigned long count = desc->count;
-	struct lo_read_data *p = desc->arg.data;
+	struct lo_read_data *p = sd->data;
 	struct loop_device *lo = p->lo;
+	struct page *page = buf->page;
 	sector_t IV;
+	size_t size;
+	int ret;
 
-	IV = ((sector_t) page->index << (PAGE_CACHE_SHIFT - 9))+(offset >> 9);
+	ret = buf->ops->pin(pipe, buf);
+	if (unlikely(ret))
+		return ret;
 
-	if (size > count)
-		size = count;
+	IV = ((sector_t) page->index << (PAGE_CACHE_SHIFT - 9)) +
+							(buf->offset >> 9);
+	size = sd->len;
+	if (size > p->bsize)
+		size = p->bsize;
 
-	if (lo_do_transfer(lo, READ, page, offset, p->page, p->offset, size, IV)) {
-		size = 0;
+	if (lo_do_transfer(lo, READ, page, buf->offset, p->page, p->offset, size, IV)) {
 		printk(KERN_ERR "loop: transfer error block %ld\n",
 		       page->index);
-		desc->error = -EINVAL;
+		size = -EINVAL;
 	}
 
 	flush_dcache_page(p->page);
 
-	desc->count = count - size;
-	desc->written += size;
-	p->offset += size;
+	if (size > 0)
+		p->offset += size;
+
 	return size;
 }
 
 static int
+lo_direct_splice_actor(struct pipe_inode_info *pipe, struct splice_desc *sd)
+{
+	return __splice_from_pipe(pipe, sd, lo_splice_actor);
+}
+
+static int
 do_lo_receive(struct loop_device *lo,
 	      struct bio_vec *bvec, int bsize, loff_t pos)
 {
 	struct lo_read_data cookie;
+	struct splice_desc sd;
 	struct file *file;
-	int retval;
+	long retval;
 
 	cookie.lo = lo;
 	cookie.page = bvec->bv_page;
 	cookie.offset = bvec->bv_offset;
 	cookie.bsize = bsize;
+
+	sd.len = 0;
+	sd.total_len = bvec->bv_len;
+	sd.flags = 0;
+	sd.pos = pos;
+	sd.data = &cookie;
+
 	file = lo->lo_backing_file;
-	retval = file->f_op->sendfile(file, &pos, bvec->bv_len,
-			lo_read_actor, &cookie);
-	return (retval < 0)? retval: 0;
+	retval = splice_direct_to_actor(file, &sd, lo_direct_splice_actor);
+
+	if (retval < 0)
+		return retval;
+
+	return 0;
 }
 
 static int
@@ -679,8 +703,8 @@ static int loop_change_fd(struct loop_device *lo, struct file *lo_file,
 	if (!S_ISREG(inode->i_mode) && !S_ISBLK(inode->i_mode))
 		goto out_putf;
 
-	/* new backing store needs to support loop (eg sendfile) */
-	if (!inode->i_fop->sendfile)
+	/* new backing store needs to support loop (eg splice_read) */
+	if (!inode->i_fop->splice_read)
 		goto out_putf;
 
 	/* size of the new backing store needs to be the same */
@@ -760,7 +784,7 @@ static int loop_set_fd(struct loop_device *lo, struct file *lo_file,
 		 * If we can't read - sorry. If we only can't write - well,
 		 * it's going to be read-only.
 		 */
-		if (!file->f_op->sendfile)
+		if (!file->f_op->splice_read)
 			goto out_putf;
 		if (aops->prepare_write && aops->commit_write)
 			lo_flags |= LO_FLAGS_USE_AOPS;
-- 
1.5.2.1.174.gcd03

