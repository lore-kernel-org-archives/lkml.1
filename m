Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbZGKOMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbZGKOMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 10:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZGKOML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 10:12:11 -0400
Received: from mx2.netapp.com ([216.240.18.37]:10651 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbZGKOMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 10:12:10 -0400
X-IronPort-AV: E=Sophos;i="4.42,383,1243839600"; 
   d="scan'208";a="203809395"
Subject: RE: commit 097041e576ee3a50d92dd643ee8ca65bf6a62e21 (fuse: Fix
 build error)
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Sat, 11 Jul 2009 10:06:54 -0400
Message-Id: <1247321214.5615.6.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
X-OriginalArrivalTime: 11 Jul 2009 14:12:07.0652 (UTC) FILETIME=[93021240:01CA0231]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

Please revert this commit. Instead of fixing the compile problem, it
adds a new dependency on CONFIG_BLOCK to both NFS and FUSE. Neither one
of them has such a dependency today, nor is there a reason to introduce
one. 

The correct fix should rather be to move the definitions of BLK_RW_SYNC
and BLK_RW_ASYNC into backing-dev.h as per the patch below.

Cheers
  Trond

---------------------------------------------------------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Fix compile error due to congestion_wait() changes

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


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
