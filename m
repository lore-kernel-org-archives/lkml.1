Return-Path: <linux-kernel-owner+w=401wt.eu-S1751687AbXBFIdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbXBFIdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 03:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbXBFIdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 03:33:36 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:31448 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbXBFIdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 03:33:35 -0500
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@osdl.org>, Nick Piggin <npiggin@suse.de>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 0/1][RFC] mm: prepare_write positive return value
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Tue, 06 Feb 2007 11:33:46 +0300
Message-ID: <87ejp37kid.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Almost all read/write operation handles data with chunks(segments or pages)
and result has integral behaviour for folowing scenario: 
for_each_chunk() {
     res = op(....);
     if(IS_ERROR(res))
           return progress ? progress : res;
     progress += res;
}
prepare_write may has integral behaviour in case of blksize < pgsize,
for example we successfully allocated/read some blocks, but not all of them,
and than some error happend. Currently we eliminate this progress by doing
vmtrunate() after prepare_has failed.
It is good to have ability to signal about this progress. Interprete positive
prepare_write() ret code as bytes num that fs ready to handle at this moment.
I've ask SAW, he think it is sane. This size always less than PAGE_CACHE_SIZE
so it less than AOP_TRUNCATED_PAGE too.
 
BTH: This approach was used in OpenVZ 2.6.9 kernel in order to make FS with 
delayed allocation more correct, and its works well.
I think not everybody will happy about this,  but let's discuss all advantages
and disadvantages of this change.

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
-------------

--=-=-=
Content-Disposition: inline; filename=diff-mm-fs-prepare_write-retval

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 62632f5..b4f6eac 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -239,7 +239,11 @@ static int do_lo_send_aops(struct loop_device *lo, struct bio_vec *bvec,
 				page_cache_release(page);
 				continue;
 			}
-			goto unlock;
+			if (ret > 0 && ret < PAGE_CACHE_SIZE)
+			/* prepare_write demands limit size of bytes. */
+				size = min(size, (unsigned)ret);
+			else
+				goto unlock;
 		}
 		transfer_result = lo_do_transfer(lo, WRITE, page, offset,
 				bvec->bv_page, bv_offs, size, IV);
diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 1e5d2ba..b5eebe8 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -454,6 +454,17 @@ static int ecryptfs_write_inode_size_to_header(struct file *lower_file,
 	}
 	lower_a_ops = lower_inode->i_mapping->a_ops;
 	rc = lower_a_ops->prepare_write(lower_file, header_page, 0, 8);
+	if (unlikely(rc > 0 && rc < PAGE_CACHE_SIZE)) {
+	/* 
+	 * prepare_write can handle less bytes whan we need. This is not likely
+	 * to happend realy because usualy we need only one block. In order to
+	 * preserve prepare/commit balanced invoke commit end fail.
+	 */
+		int ret;
+		ret = lower_a_ops->commit_write(lower_file, header_page, 0, rc);
+		rc = ret ? ret : -ENOSPC;
+		goto unlock;
+	}
 	file_size = (u64)i_size_read(inode);
 	ecryptfs_printk(KERN_DEBUG, "Writing size: [0x%.16x]\n", file_size);
 	file_size = cpu_to_be64(file_size);
@@ -462,6 +473,7 @@ static int ecryptfs_write_inode_size_to_header(struct file *lower_file,
 	kunmap_atomic(header_virt, KM_USER0);
 	flush_dcache_page(header_page);
 	rc = lower_a_ops->commit_write(lower_file, header_page, 0, 8);
+unlock:
 	if (rc < 0)
 		ecryptfs_printk(KERN_ERR, "Error commiting header page "
 				"write\n");
diff --git a/fs/namei.c b/fs/namei.c
index b305589..723db81 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2704,6 +2704,16 @@ retry:
 		page_cache_release(page);
 		goto retry;
 	}
+	if (unlikely(err > 0 && err < PAGE_CACHE_SIZE)) {
+	/* 
+	 * prepare_write can handle less bytes whan we need. This is not likely
+	 * to happend realy because usualy we need only one block. In order to
+	 * preserve prepare/commit balanced invoke commit end fail.
+	 */
+		int ret;
+		ret = mapping->a_ops->commit_write(NULL, page, 0, err);
+		err = ret ? ret : -ENOSPC;
+	}
 	if (err)
 		goto fail_map;
 	kaddr = kmap_atomic(page, KM_USER0);
diff --git a/fs/splice.c b/fs/splice.c
index 2fca6eb..d2b92bf 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -652,6 +652,17 @@ find_page:
 	if (unlikely(ret)) {
 		loff_t isize = i_size_read(mapping->host);
 
+		if (ret > 0 && ret < PAGE_CACHE_SIZE) {
+		/* 
+	 	 * prepare_write demands limit size of bytes. In order to
+	 	 * preserve prepare/commit balanced invoke commit end fail. 
+	 	 * Initial i_size saved, so vmtruncate safely restore it later.
+		 */
+			int ret2;
+			ret2 = mapping->a_ops->commit_write(file, page, offset,
+				offset + ret);
+			ret = ret2 ? ret2 : -ENOSPC;
+		}
 		if (ret != AOP_TRUNCATED_PAGE)
 			unlock_page(page);
 		page_cache_release(page);
diff --git a/mm/filemap.c b/mm/filemap.c
index 5fe315a..529eb9e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2188,6 +2188,11 @@ generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
 		}
 
 		status = a_ops->prepare_write(file, page, offset, offset+bytes);
+		if (unlikely(status > 0 && status < PAGE_CACHE_SIZE)) {
+		/* prepare_write demands limit size of bytes at this iteration.*/
+			bytes = min(bytes, (size_t)status);
+			status = 0;
+		}
 		if (unlikely(status)) {
 			loff_t isize = i_size_read(inode);
 

--=-=-=--

