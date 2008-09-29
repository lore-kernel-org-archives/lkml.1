Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbYI2NCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbYI2NCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 09:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbYI2NCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 09:02:38 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:44880 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbYI2NCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 09:02:37 -0400
Date: Mon, 29 Sep 2008 15:02:22 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Leisner, Martin" <Martin.Leisner@xerox.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, marty <martyleisner@yahoo.com>,
       linux-kernel@vger.kernel.org
Subject: Re: disk IO directly from PCI memory to block device sectors
Message-ID: <20080929130222.GX2677@kernel.dk>
References: <247018.46515.qm@web50603.mail.re2.yahoo.com> <20080926094653.1e0a9260@lxorguk.ukuu.org.uk> <20080926091135.GV2677@kernel.dk> <556445368AFA1C438794ABDA8901891C0999203A@USA0300MS03.na.xerox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <556445368AFA1C438794ABDA8901891C0999203A@USA0300MS03.na.xerox.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26 2008, Leisner, Martin wrote:
> 
> 
> >   -----Original Message-----
> >   From: Jens Axboe [mailto:jens.axboe@oracle.com]
> >   Sent: Friday, September 26, 2008 5:12 AM
> >   To: Alan Cox
> >   Cc: marty; linux-kernel@vger.kernel.org; Leisner, Martin
> >   Subject: Re: disk IO directly from PCI memory to block device
> sectors
> >   
> >   On Fri, Sep 26 2008, Alan Cox wrote:
> >   > > What I'm looking is for a more generic/driver independent way of
> >   sticking
> >   > > contents of PCI ram onto a disk.
> >   >
> >   > Ermm seriously why not have a userspace task with the PCI RAM
> mmapped
> >   > and just use write() like normal sane people do ?
> >   
> >   To avoid the fault and copy, I would assume.
> >   
> >   --
> >   Jens Axboe
> 
> Also:
>    a) to deal with interrupts from the hardware
>    b) using legacy code/design/architecture
>    
> The splice approaches look very interesting...thanks...

Just for kicks, I did the read part of the fast bdev interface as well.
As with the write, it's totally untested (apart from compiled). Just in
case anyone is curious... I plan to do a bit of testing on this this
week.

IMHO, this interface totally rocks. It's really async like splice was
intended, and it's fast too. I may have to look into some generic IO
mechanism to unify them all, O_DIRECT/page cache/splice. Famous last
words, I'm sure.


diff --git a/fs/block_dev.c b/fs/block_dev.c
index aff5421..f8df781 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -24,6 +24,7 @@
 #include <linux/uio.h>
 #include <linux/namei.h>
 #include <linux/log2.h>
+#include <linux/splice.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -1155,6 +1156,264 @@ static long block_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	return blkdev_ioctl(file->f_mapping->host, file, cmd, arg);
 }
 
+static void block_splice_write_end_io(struct bio *bio, int err)
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
+	bio->bi_end_io = block_splice_write_end_io;
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
+static void block_pipe_buf_release(struct pipe_inode_info *pipe,
+				   struct pipe_buffer *buf)
+{
+	struct bio *bio;
+
+	bio = (struct bio *) buf->private;
+	if (bio)
+		bio_put(bio);
+
+	__free_pages(buf->page, 0);
+}
+
+/*
+ * Wait for IO to be done on the bio that this buf belongs to
+ */
+static int block_pipe_buf_confirm(struct pipe_inode_info *pipe,
+				  struct pipe_buffer *buf)
+{
+	struct bio *bio = (struct bio *) buf->private;
+	struct completion *comp = bio->bi_private;
+
+	wait_for_completion(comp);
+	return 0;
+}
+
+static const struct pipe_buf_operations block_pipe_buf_ops = {
+	.can_merge = 0,
+	.map = generic_pipe_buf_map,
+	.unmap = generic_pipe_buf_unmap,
+	.confirm = block_pipe_buf_confirm,
+	.release = block_pipe_buf_release,
+	.steal = generic_pipe_buf_steal,
+	.get = generic_pipe_buf_get,
+};
+
+static void block_release_page(struct splice_pipe_desc *spd, unsigned int i)
+{
+	struct bio *bio;
+
+	bio = (struct bio *) spd->partial[i].private;
+	if (bio)
+		bio_put(bio);
+
+	__free_pages(spd->pages[i], 0);
+}
+
+/*
+ * READ end io handling completes the bio, so that we can wakeup
+ * anyone waiting in ->confirm().
+ */
+static void block_splice_read_end_io(struct bio *bio, int err)
+{
+	struct completion *comp = bio->bi_private;
+
+	complete(comp);
+	bio_put(bio);
+}
+
+static void block_splice_bio_destructor(struct bio *bio)
+{
+	kfree(bio->bi_private);
+	bio_free(bio, fs_bio_set);
+}
+
+/*
+ * Bypass the page cache and allocate pages for IO directly
+ */
+static ssize_t __block_splice_read(struct pipe_inode_info *pipe,
+				    struct file *in, loff_t *ppos, size_t len,
+				    unsigned int flags)
+{
+	struct page *pages[PIPE_BUFFERS];
+	struct partial_page partial[PIPE_BUFFERS];
+	struct splice_pipe_desc spd = {
+		.pages = pages,
+		.partial = partial,
+		.flags = flags,
+		.ops = &block_pipe_buf_ops,
+		.spd_release = block_release_page,
+	};
+	struct inode *inode = in->f_mapping->host;
+	struct block_device *bdev = I_BDEV(inode);
+	struct bio *bio;
+	sector_t sector;
+	loff_t isize, left;
+	int bs, err;
+
+	/*
+	 * First to alignment and length sanity checks
+	 */
+	bs = queue_hardsect_size(bdev_get_queue(bdev));
+	if (*ppos & (bs - 1))
+		return -EINVAL;
+
+	isize = i_size_read(inode);
+	if (unlikely(*ppos >= isize))
+		return 0;
+
+	left = isize - *ppos;
+	if (unlikely(left < len))
+		len = left;
+
+	err = 0;
+	spd.nr_pages = 0;
+	sector = *ppos / bs;
+	bio = NULL;
+	while (len) {
+		struct completion *comp;
+		unsigned int this_len;
+		struct page *page;
+
+		this_len = len;
+		if (this_len > PAGE_SIZE)
+			this_len = PAGE_SIZE;
+
+		page = alloc_page(GFP_KERNEL);
+		if (!page) {
+			err = -ENOMEM;
+			break;
+		}
+
+		if (!bio) {
+alloc_new_bio:
+			comp = kmalloc(sizeof(*comp), GFP_KERNEL);
+			if (!comp) {
+				err = -ENOMEM;
+				break;
+			}
+
+			init_completion(comp);
+
+			bio = bio_alloc(GFP_KERNEL, (len + PAGE_SIZE - 1) / PAGE_SIZE);
+			bio->bi_sector = sector;
+			bio->bi_bdev = bdev;
+			bio->bi_private = comp;
+			bio->bi_end_io = block_splice_read_end_io;
+
+			/*
+			 * Not too nice...
+			 */
+			bio->bi_destructor = block_splice_bio_destructor;
+		}
+
+		/*
+		 * if we fail adding page, then submit this bio and get
+		 * a new one
+		 */
+		if (bio_add_page(bio, page, this_len, 0) != this_len) {
+			submit_bio(READ, bio);
+			bio = NULL;
+			goto alloc_new_bio;
+		}
+
+		/*
+		 * The pipe buffer needs to hang on to the bio, so that we
+		 * can reuse it in the ->confirm() part of the pipe ops
+		 */
+		bio_get(bio);
+
+		sector += (this_len / bs);
+		len -= this_len;
+		partial[spd.nr_pages].offset = 0;
+		partial[spd.nr_pages].len = this_len;
+		partial[spd.nr_pages].private = (unsigned long) bio;
+		pages[spd.nr_pages] = page;
+		spd.nr_pages++;
+	}
+
+	if (bio)
+		submit_bio(READ, bio);
+
+	if (spd.nr_pages)
+		return splice_to_pipe(pipe, &spd);
+
+	return err;
+}
+
+static ssize_t block_splice_read(struct file *in, loff_t *ppos,
+				 struct pipe_inode_info *pipe, size_t len,
+				 unsigned int flags)
+{
+	if (in->f_flags & O_DIRECT)
+		return __block_splice_read(pipe, in, ppos, len, flags);
+
+	return generic_file_splice_read(in, ppos, pipe, len, flags);
+}
+
 static const struct address_space_operations def_blk_aops = {
 	.readpage	= blkdev_readpage,
 	.writepage	= blkdev_writepage,
@@ -1179,8 +1438,8 @@ const struct file_operations def_blk_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= compat_blkdev_ioctl,
 #endif
-	.splice_read	= generic_file_splice_read,
-	.splice_write	= generic_file_splice_write,
+	.splice_read	= block_splice_read,
+	.splice_write	= block_splice_write,
 };
 
 int ioctl_by_bdev(struct block_device *bdev, unsigned cmd, unsigned long arg)

-- 
Jens Axboe

