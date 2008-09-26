Return-Path: <linux-kernel-owner+w=401wt.eu-S1753011AbYIZLev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbYIZLev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 07:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYIZLem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 07:34:42 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:33560 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbYIZLel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 07:34:41 -0400
Date: Fri, 26 Sep 2008 13:34:04 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: marty <martyleisner@yahoo.com>, linux-kernel@vger.kernel.org,
       martin.leisner@xerox.com
Subject: Re: disk IO directly from PCI memory to block device sectors
Message-ID: <20080926113404.GY2677@kernel.dk>
References: <247018.46515.qm@web50603.mail.re2.yahoo.com> <20080926094653.1e0a9260@lxorguk.ukuu.org.uk> <20080926091135.GV2677@kernel.dk> <20080926110610.17603d30@lxorguk.ukuu.org.uk> <20080926101954.GW2677@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080926101954.GW2677@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26 2008, Jens Axboe wrote:
> Another alternative would be using splice - if the pci device exposed a
> char device node, you could support ->splice_read() there which would
> just fill the pages into the pipe buffer. Then change the block device
> fops ->splice_write() to go direct to the block device through a bio
> instead of using the page cache based generic_file_splice_write(). Such
> a change would actually make sense to do, if the block device has been
> opened with O_DIRECT. And it would get you about the same performance as
> doing it in-kernel, the only extra overhead would be two syscalls per
> 64k (well probably only one extra syscall, since you probably need an
> ioctl/syscall to initiate the in-kernel activity as well). So just about
> as free as you could get.

Something like this, totally untested but should get the point across.

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 57e2786..fd06032 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -24,6 +24,7 @@
 #include <linux/uio.h>
 #include <linux/namei.h>
 #include <linux/log2.h>
+#include <linux/splice.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -1224,6 +1225,77 @@ static long block_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	return blkdev_ioctl(file->f_mapping->host, file, cmd, arg);
 }
 
+static void block_splice_end_io(struct bio *bio, int err)
+{
+	bio_put(bio);
+}
+
+static int pipe_to_disk(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
+			struct splice_desc *sd)
+{
+	struct block_device *bdev = I_BDEV(sd->u.file->f_mapping->host);
+	struct bio *bio;
+	int ret, bs;
+
+	bs = queue_hardsect_size(bdev_get_queue(bdev));
+	if (sd->pos & (bs - 1))
+		return -EINVAL;
+
+	ret = buf->ops->confirm(pipe, buf);
+	if (unlikely(ret))
+		return ret;
+
+	bio = bio_alloc(GFP_KERNEL, 1);
+	bio->bi_sector = sd->pos / bs;
+	bio->bi_bdev = bdev;
+	bio->bi_end_io = block_splice_end_io;
+
+	bio_add_page(bio, buf->page, buf->len, buf->offset);
+
+	submit_bio(WRITE, bio);
+	return buf->len;
+}
+
+/*
+ * Splice to file opened with O_DIRECT. Bypass caching completely and
+ * just go direct-to-bio
+ */
+static ssize_t __block_splice_write(struct pipe_inode_info *pipe,
+				    struct file *out, loff_t *ppos, size_t len,
+				    unsigned int flags)
+{
+	struct splice_desc sd = {
+		.total_len = len,
+		.flags = flags,
+		.pos = *ppos,
+		.u.file = out,
+	};
+	struct inode *inode = out->f_mapping->host;
+	ssize_t ret;
+
+	if (unlikely(*ppos & 511))
+		return -EINVAL;
+
+	inode_double_lock(inode, pipe->inode);
+	ret = __splice_from_pipe(pipe, &sd, pipe_to_disk);
+	inode_double_unlock(inode, pipe->inode);
+
+	if (ret > 0)
+		*ppos += ret;
+
+	return ret;
+}
+
+static ssize_t block_splice_write(struct pipe_inode_info *pipe,
+				  struct file *out, loff_t *ppos, size_t len,
+				  unsigned int flags)
+{
+	if (out->f_flags & O_DIRECT)
+		return __block_splice_write(pipe, out, ppos, len, flags);
+
+	return generic_file_splice_write(pipe, out, ppos, len, flags);
+}
+
 static const struct address_space_operations def_blk_aops = {
 	.readpage	= blkdev_readpage,
 	.writepage	= blkdev_writepage,
@@ -1249,7 +1321,7 @@ const struct file_operations def_blk_fops = {
 	.compat_ioctl	= compat_blkdev_ioctl,
 #endif
 	.splice_read	= generic_file_splice_read,
-	.splice_write	= generic_file_splice_write,
+	.splice_write	= block_splice_write,
 };
 
 int ioctl_by_bdev(struct block_device *bdev, unsigned cmd, unsigned long arg)

-- 
Jens Axboe

