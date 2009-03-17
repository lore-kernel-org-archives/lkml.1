Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbZCQIt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbZCQIt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 04:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbZCQItr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 04:49:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56647 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbZCQItq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 04:49:46 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] Block - Honour barrier requests in loop driver
Date: Tue, 17 Mar 2009 14:17:16 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.27.19-3.2-default; KDE/4.1.3; x86_64; ; )
Cc: Gerd Hoffmann <kraxel@redhat.com>,
       Constantine Sapuntzakis <csapuntz@gmail.com>,
       Miklos Szeredi <miklos@szeredi.hu>, nikanth@gmail.com,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903171417.16760.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the patch[1] posted by Constantine Sapuntzakis back in May 2006,
and various other similar patches by Jens Axboe, Gerd Hoffmann and Miklos
Szeredi for Suse Kernels, this patch adds barrier support to loop back
devices. I am not sure why this support was not merged earlier.

Jens can you please review this?

Thanks
Nikanth

[1] http://lkml.indiana.edu/hypermail/linux/kernel/0605.0/1172.html

Honour barrier requests in the loop back block device driver.
In case of barrier bios, flush the backing file once before processing the
barrier and once after to guarantee ordering. In case of filesystems that does
not support fsync, barrier bios would be failed with -EOPNOTSUPP.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index bf03455..e805985 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -202,6 +202,35 @@ lo_do_transfer(struct loop_device *lo, int cmd,
 	return lo->transfer(lo, cmd, rpage, roffs, lpage, loffs, size, rblock);
 }
 
+static int sync_file(struct file *file)
+{
+	struct address_space *mapping;
+	int ret;
+
+	if (!file->f_op || !file->f_op->fsync)
+		return -EOPNOTSUPP;
+
+	mapping = file->f_mapping;
+
+	ret = filemap_fdatawrite(mapping);
+	if (!ret) {
+		int ret2;
+
+		mutex_lock(&mapping->host->i_mutex);
+		ret = file->f_op->fsync(file, file->f_dentry, 1);
+		mutex_unlock(&mapping->host->i_mutex);
+
+		ret2 = filemap_fdatawait(mapping);
+		if (!ret)
+			ret = ret2;
+	}
+
+	if (unlikely(ret))
+		ret = -EIO;
+
+	return ret;
+}
+
 /**
  * do_lo_send_aops - helper for writing data to a loop device
  *
@@ -472,12 +501,23 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
 {
 	loff_t pos;
 	int ret;
+	int barrier = bio_barrier(bio);
+
+	if (barrier) {
+		ret = sync_file(lo->lo_backing_file);
+		if (unlikely(ret))
+			goto out;
+	}
 
 	pos = ((loff_t) bio->bi_sector << 9) + lo->lo_offset;
-	if (bio_rw(bio) == WRITE)
+	if (bio_rw(bio) == WRITE) {
 		ret = lo_send(lo, bio, pos);
-	else
+		if (barrier && !ret)
+			ret = sync_file(lo->lo_backing_file);
+	} else
 		ret = lo_receive(lo, bio, lo->lo_blocksize, pos);
+
+out:
 	return ret;
 }
 

