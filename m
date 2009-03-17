Return-Path: <linux-kernel-owner+w=401wt.eu-S1762991AbZCQMMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762991AbZCQMMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 08:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbZCQMMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 08:12:31 -0400
Received: from mail.suse.de ([195.135.220.2]:50021 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbZCQMMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 08:12:30 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Block - Honour barrier requests in loop driver
Date: Tue, 17 Mar 2009 17:39:49 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc8-default; KDE/4.1.3; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Gerd Hoffmann <kraxel@redhat.com>,
       Constantine Sapuntzakis <csapuntz@gmail.com>,
       Miklos Szeredi <miklos@szeredi.hu>, nikanth@gmail.com,
       linux-kernel@vger.kernel.org
References: <200903171417.16760.knikanth@suse.de> <20090317091926.GA26016@infradead.org>
In-Reply-To: <20090317091926.GA26016@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903171739.50658.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 March 2009 14:49:26 Christoph Hellwig wrote:
> On Tue, Mar 17, 2009 at 02:17:16PM +0530, Nikanth Karthikesan wrote:
> > +static int sync_file(struct file *file)
> > +{
> > +	struct address_space *mapping;
> > +	int ret;
> > +
> > +	if (!file->f_op || !file->f_op->fsync)
> > +		return -EOPNOTSUPP;
> > +
> > +	mapping = file->f_mapping;
> > +
> > +	ret = filemap_fdatawrite(mapping);
> > +	if (!ret) {
> > +		int ret2;
> > +
> > +		mutex_lock(&mapping->host->i_mutex);
> > +		ret = file->f_op->fsync(file, file->f_dentry, 1);
> > +		mutex_unlock(&mapping->host->i_mutex);
> > +
> > +		ret2 = filemap_fdatawait(mapping);
> > +		if (!ret)
> > +			ret = ret2;
>
> Please use vfs_fsync.

Ok.

>
> > +	int barrier = bio_barrier(bio);
> > +
> > +	if (barrier) {
> > +		ret = sync_file(lo->lo_backing_file);
> > +		if (unlikely(ret))
> > +			goto out;
> > +	}
> >
> >  	pos = ((loff_t) bio->bi_sector << 9) + lo->lo_offset;
> > +	if (bio_rw(bio) == WRITE) {
> >  		ret = lo_send(lo, bio, pos);
> > +		if (barrier && !ret)
> > +			ret = sync_file(lo->lo_backing_file);
> > +	} else
> >  		ret = lo_receive(lo, bio, lo->lo_blocksize, pos);
> > +
> > +out:
> >  	return ret;
>
> We only use barrier requests for reads, which this code relies on for
> the second sync, too.  So just move the whole thing into one if block,
> 

you meant barriers only for writes, right? done.

>
> You also should advertise the barrier capability with a queue flag.

Added QUEUE_ORDERED_DRAIN flag.

Here is the updated patch with the above comments from Christoph
incorporated.

Thanks
Nikanth

Honour barrier requests in the loop back block device driver.
In case of barrier bios, flush the backing file once before processing the
barrier and once after to guarantee ordering. In case of filesystems that does
not support fsync, barrier bios would be failed with -EOPNOTSUPP.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index bf03455..8520322 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -474,10 +474,35 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
 	int ret;
 
 	pos = ((loff_t) bio->bi_sector << 9) + lo->lo_offset;
-	if (bio_rw(bio) == WRITE)
+
+	if (bio_rw(bio) == WRITE) {
+		int barrier = bio_barrier(bio);
+		struct file *file = lo->lo_backing_file;
+
+		if (barrier) {
+			if (!file->f_op || !file->f_op->fsync) {
+				ret = -EOPNOTSUPP;
+				goto out;
+			}
+
+			ret = vfs_fsync(file, file->f_path.dentry, 0);
+			if (unlikely(ret)) {
+				ret = -EIO;
+				goto out;
+			}
+		}
+
 		ret = lo_send(lo, bio, pos);
-	else
+
+		if (barrier && !ret) {
+			ret = vfs_fsync(file, file->f_path.dentry, 0);
+			if (unlikely(ret))
+				ret = -EIO;
+		}
+	} else
 		ret = lo_receive(lo, bio, lo->lo_blocksize, pos);
+
+out:
 	return ret;
 }
 
@@ -825,6 +850,10 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	blk_queue_make_request(lo->lo_queue, loop_make_request);
 	lo->lo_queue->queuedata = lo;
 	lo->lo_queue->unplug_fn = loop_unplug;
+	if (!(lo_flags & LO_FLAGS_READ_ONLY) && file->f_op &&
+						file->f_op->fsync) {
+		blk_queue_ordered(lo->lo_queue, QUEUE_ORDERED_DRAIN, NULL);
+	}
 
 	set_capacity(lo->lo_disk, size);
 	bd_set_size(bdev, size << 9);

