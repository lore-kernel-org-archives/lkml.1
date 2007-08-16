Return-Path: <linux-kernel-owner+w=401wt.eu-S935149AbXHPIif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935149AbXHPIif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 04:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764897AbXHPI3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 04:29:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759602AbXHPI3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 04:29:00 -0400
Message-Id: <20070816074624.713614000@chello.nl>
References: <20070816074525.065850000@chello.nl>
User-Agent: quilt/0.45-1
Date: Thu, 16 Aug 2007 09:45:26 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk,
       torvalds@linux-foundation.org
Subject: [PATCH 01/23] nfs: remove congestion_end()
Content-Disposition: inline; filename=nfs_congestion_fixup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Its redundant, clear_bdi_congested() already wakes the waiters.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/nfs/write.c              |    5 ++---
 include/linux/backing-dev.h |    1 -
 mm/backing-dev.c            |   13 -------------
 3 files changed, 2 insertions(+), 17 deletions(-)

Index: linux-2.6/fs/nfs/write.c
===================================================================
--- linux-2.6.orig/fs/nfs/write.c
+++ linux-2.6/fs/nfs/write.c
@@ -235,10 +235,8 @@ static void nfs_end_page_writeback(struc
 	struct nfs_server *nfss = NFS_SERVER(inode);
 
 	end_page_writeback(page);
-	if (atomic_long_dec_return(&nfss->writeback) < NFS_CONGESTION_OFF_THRESH) {
+	if (atomic_long_dec_return(&nfss->writeback) < NFS_CONGESTION_OFF_THRESH)
 		clear_bdi_congested(&nfss->backing_dev_info, WRITE);
-		congestion_end(WRITE);
-	}
 }
 
 /*
Index: linux-2.6/include/linux/backing-dev.h
===================================================================
--- linux-2.6.orig/include/linux/backing-dev.h
+++ linux-2.6/include/linux/backing-dev.h
@@ -93,7 +93,6 @@ static inline int bdi_rw_congested(struc
 void clear_bdi_congested(struct backing_dev_info *bdi, int rw);
 void set_bdi_congested(struct backing_dev_info *bdi, int rw);
 long congestion_wait(int rw, long timeout);
-void congestion_end(int rw);
 
 #define bdi_cap_writeback_dirty(bdi) \
 	(!((bdi)->capabilities & BDI_CAP_NO_WRITEBACK))
Index: linux-2.6/mm/backing-dev.c
===================================================================
--- linux-2.6.orig/mm/backing-dev.c
+++ linux-2.6/mm/backing-dev.c
@@ -54,16 +54,3 @@ long congestion_wait(int rw, long timeou
 	return ret;
 }
 EXPORT_SYMBOL(congestion_wait);
-
-/**
- * congestion_end - wake up sleepers on a congested backing_dev_info
- * @rw: READ or WRITE
- */
-void congestion_end(int rw)
-{
-	wait_queue_head_t *wqh = &congestion_wqh[rw];
-
-	if (waitqueue_active(wqh))
-		wake_up(wqh);
-}
-EXPORT_SYMBOL(congestion_end);

--

