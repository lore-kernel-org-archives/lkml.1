Return-Path: <linux-kernel-owner+w=401wt.eu-S1757676AbZGJWsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676AbZGJWsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 18:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756737AbZGJWs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 18:48:28 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:52850 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755719AbZGJWs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 18:48:27 -0400
Subject: Fix compile error due to congestion_wait() changes
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: linux-kernel@vger.kernel.org,
       Linux Filesystem Development <linux-fsdevel@vger.kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jul 2009 18:48:22 -0400
Message-Id: <1247266102.8254.33.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 3 sum rcpts/h 9 sum msgs/h 3 total rcpts 825 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=_URIID_)
X-UiO-Scanned: C9B5A8A612FD71F422FB305939AA97315CB92E8C
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 3 total 39 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the definition of BLK_RW_ASYNC/BLK_RW_SYNC into linux/backing-dev.h so
that it is available to all callers of set/clear_bdi_congested().

This fixes a compile error in fs/fuse/dev.c:
linux-2.6/fs/fuse/dev.c: In function ‘request_end’:
linux-2.6/fs/fuse/dev.c:289: error: ‘BLK_RW_SYNC’ undeclared (first use in this function)
linux-2.6/fs/fuse/dev.c:289: error: (Each undeclared identifier is reported only once
linux-2.6/fs/fuse/dev.c:289: error: for each function it appears in.)
linux-2.6/fs/fuse/dev.c:290: error: ‘BLK_RW_ASYNC’ undeclared (first use in this function)
linux-2.6/fs/fuse/dev.c: In function ‘fuse_request_send_nowait_locked’:
linux-2.6/fs/fuse/dev.c:417: error: ‘BLK_RW_SYNC’ undeclared (first use in this function)
linux-2.6/fs/fuse/dev.c:418: error: ‘BLK_RW_ASYNC’ undeclared (first use in this function)
make[3]: *** [fs/fuse/dev.o] Error 1
make[2]: *** [fs/fuse] Error 2

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
---

 include/linux/backing-dev.h |    5 +++++
 include/linux/blkdev.h      |    5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 3a52a63..1d52425 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -229,6 +229,11 @@ static inline int bdi_rw_congested(struct backing_dev_info *bdi)
 				  (1 << BDI_async_congested));
 }
 
+enum {
+	BLK_RW_ASYNC	= 0,
+	BLK_RW_SYNC	= 1,
+};
+
 void clear_bdi_congested(struct backing_dev_info *bdi, int sync);
 void set_bdi_congested(struct backing_dev_info *bdi, int sync);
 long congestion_wait(int sync, long timeout);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0146e0f..e7cb5db 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -70,11 +70,6 @@ enum rq_cmd_type_bits {
 	REQ_TYPE_ATA_PC,
 };
 
-enum {
-	BLK_RW_ASYNC	= 0,
-	BLK_RW_SYNC	= 1,
-};
-
 /*
  * For request of type REQ_TYPE_LINUX_BLOCK, rq->cmd[0] is the opcode being
  * sent down (similar to how REQ_TYPE_BLOCK_PC means that ->cmd[] holds a


