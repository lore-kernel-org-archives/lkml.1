Return-Path: <linux-kernel-owner+w=401wt.eu-S1757613AbZHQKei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbZHQKei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 06:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757425AbZHQKeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 06:34:36 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44346 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757467AbZHQKed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 06:34:33 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: zach.brown@oracle.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/3] direct-io: add a "IO for kernel" flag to kiocb
Date: Mon, 17 Aug 2009 12:34:33 +0200
Message-Id: <1250505274-17108-3-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.53.g3f55e
In-Reply-To: <1250505274-17108-2-git-send-email-jens.axboe@oracle.com>
References: <1250505274-17108-1-git-send-email-jens.axboe@oracle.com>
 <1250505274-17108-2-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/direct-io.c      |   12 +++++++++++-
 include/linux/aio.h |    3 +++
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index b962a39..b39ccc2 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -117,6 +117,7 @@ struct dio {
 	struct kiocb *iocb;		/* kiocb */
 	int is_async;			/* is IO async ? */
 	int io_error;			/* IO error in completion path */
+	int is_kernel;
 	ssize_t result;                 /* IO result */
 };
 
@@ -336,7 +337,7 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
 
 	if (dio->is_async && dio->rw == READ) {
 		bio_check_pages_dirty(bio);	/* transfers ownership */
-	} else {
+	} else if (!dio->is_kernel) {
 		for (page_no = 0; page_no < bio->bi_vcnt; page_no++) {
 			struct page *page = bvec[page_no].bv_page;
 
@@ -345,6 +346,14 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
 			page_cache_release(page);
 		}
 		bio_put(bio);
+	} else {
+		for (page_no = 0; page_no < bio->bi_vcnt; page_no++) {
+			struct page *page = bvec[page_no].bv_page;
+
+			if (!dio->io_error)
+				SetPageUptodate(page);
+		}
+		bio_put(bio);
 	}
 	return uptodate ? 0 : -EIO;
 }
@@ -1105,6 +1114,7 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	 */
 	dio->is_async = !is_sync_kiocb(iocb) && !((rw & WRITE) &&
 		(end > i_size_read(inode)));
+	dio->is_kernel = kiocbIsKernel(iocb);
 
 	retval = direct_io_worker(rw, iocb, inode, args, blkbits, get_block,
 					end_io, dio);
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 47f7d93..ce3f34b 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -34,6 +34,7 @@ struct kioctx;
 /* #define KIF_LOCKED		0 */
 #define KIF_KICKED		1
 #define KIF_CANCELLED		2
+#define KIF_KERNEL_PAGES	3
 
 #define kiocbTryLock(iocb)	test_and_set_bit(KIF_LOCKED, &(iocb)->ki_flags)
 #define kiocbTryKick(iocb)	test_and_set_bit(KIF_KICKED, &(iocb)->ki_flags)
@@ -41,6 +42,7 @@ struct kioctx;
 #define kiocbSetLocked(iocb)	set_bit(KIF_LOCKED, &(iocb)->ki_flags)
 #define kiocbSetKicked(iocb)	set_bit(KIF_KICKED, &(iocb)->ki_flags)
 #define kiocbSetCancelled(iocb)	set_bit(KIF_CANCELLED, &(iocb)->ki_flags)
+#define kiocbSetKernel(iocb)	set_bit(KIF_KERNEL_PAGES, &(iocb)->ki_flags)
 
 #define kiocbClearLocked(iocb)	clear_bit(KIF_LOCKED, &(iocb)->ki_flags)
 #define kiocbClearKicked(iocb)	clear_bit(KIF_KICKED, &(iocb)->ki_flags)
@@ -49,6 +51,7 @@ struct kioctx;
 #define kiocbIsLocked(iocb)	test_bit(KIF_LOCKED, &(iocb)->ki_flags)
 #define kiocbIsKicked(iocb)	test_bit(KIF_KICKED, &(iocb)->ki_flags)
 #define kiocbIsCancelled(iocb)	test_bit(KIF_CANCELLED, &(iocb)->ki_flags)
+#define kiocbIsKernel(iocb)	test_bit(KIF_KERNEL_PAGES, &(iocb)->ki_flags)
 
 /* is there a better place to document function pointer methods? */
 /**
-- 
1.6.4.53.g3f55e

