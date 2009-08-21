Return-Path: <linux-kernel-owner+w=401wt.eu-S932591AbZHURAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591AbZHURAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932508AbZHURAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:00:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:51063 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932534AbZHURAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:00:02 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: hch@lst.de, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 06/17] vfs: Rename generic_file_aio_write_nolock
Date: Fri, 21 Aug 2009 18:59:50 +0200
Message-Id: <1250874001-15483-6-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1250874001-15483-1-git-send-email-jack@suse.cz>
References: <1250874001-15483-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

generic_file_aio_write_nolock() is now used only by block devices and raw
character device. Filesystems should use __generic_file_aio_write() in case
generic_file_aio_write() doesn't suit them. So rename the function to
device_aio_write().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/char/raw.c |    2 +-
 fs/block_dev.c     |    2 +-
 include/linux/fs.h |    4 ++--
 mm/filemap.c       |    9 ++++-----
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index 05f9d18..c43c7a7 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -246,7 +246,7 @@ static const struct file_operations raw_fops = {
 	.read	=	do_sync_read,
 	.aio_read = 	generic_file_aio_read,
 	.write	=	do_sync_write,
-	.aio_write = 	generic_file_aio_write_nolock,
+	.aio_write =	device_aio_write,
 	.open	=	raw_open,
 	.release=	raw_release,
 	.ioctl	=	raw_ioctl,
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 94dfda2..67fc1c9 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1436,7 +1436,7 @@ const struct file_operations def_blk_fops = {
 	.read		= do_sync_read,
 	.write		= do_sync_write,
   	.aio_read	= generic_file_aio_read,
-  	.aio_write	= generic_file_aio_write_nolock,
+	.aio_write	= device_aio_write,
 	.mmap		= generic_file_mmap,
 	.fsync		= block_fsync,
 	.unlocked_ioctl	= block_ioctl,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1edd159..29fc8da 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2198,8 +2198,8 @@ extern ssize_t generic_file_aio_read(struct kiocb *, const struct iovec *, unsig
 extern ssize_t __generic_file_aio_write(struct kiocb *, const struct iovec *, unsigned long,
 		loff_t *);
 extern ssize_t generic_file_aio_write(struct kiocb *, const struct iovec *, unsigned long, loff_t);
-extern ssize_t generic_file_aio_write_nolock(struct kiocb *, const struct iovec *,
-		unsigned long, loff_t);
+extern ssize_t device_aio_write(struct kiocb *iocb, const struct iovec *iov,
+				unsigned long nr_segs, loff_t pos);
 extern ssize_t generic_file_direct_write(struct kiocb *, const struct iovec *,
 		unsigned long *, loff_t, loff_t *, size_t, size_t);
 extern ssize_t generic_file_buffered_write(struct kiocb *, const struct iovec *,
diff --git a/mm/filemap.c b/mm/filemap.c
index b523e42..ef9f635 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2462,9 +2462,8 @@ out:
 }
 EXPORT_SYMBOL(__generic_file_aio_write);
 
-
 /**
- * generic_file_aio_write_nolock - write data, usually to a device
+ * device_aio_write - write data
  * @iocb:	IO state structure
  * @iov:	vector with data to write
  * @nr_segs:	number of segments in the vector
@@ -2477,8 +2476,8 @@ EXPORT_SYMBOL(__generic_file_aio_write);
  * do a write but already holds i_mutex, use __generic_file_aio_write()
  * directly and then sync the file like generic_file_aio_write().
  */
-ssize_t generic_file_aio_write_nolock(struct kiocb *iocb,
-		const struct iovec *iov, unsigned long nr_segs, loff_t pos)
+ssize_t device_aio_write(struct kiocb *iocb, const struct iovec *iov,
+			 unsigned long nr_segs, loff_t pos)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
@@ -2499,7 +2498,7 @@ ssize_t generic_file_aio_write_nolock(struct kiocb *iocb,
 	}
 	return ret;
 }
-EXPORT_SYMBOL(generic_file_aio_write_nolock);
+EXPORT_SYMBOL(device_aio_write);
 
 /**
  * generic_file_aio_write - write data to a file
-- 
1.6.0.2

