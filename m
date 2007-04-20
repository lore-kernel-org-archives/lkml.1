Return-Path: <linux-kernel-owner+w=401wt.eu-S1767145AbXDTQBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767145AbXDTQBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 12:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767153AbXDTQAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 12:00:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767145AbXDTQAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 12:00:30 -0400
Message-Id: <20070420155502.540627566@chello.nl>
References: <20070420155154.898600123@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 20 Apr 2007 17:51:56 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com
Subject: [PATCH 02/10] nfs: remove congestion_end()
Content-Disposition: inline; filename=nfs_congestion_fixup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Its redundant, clear_bdi_congested() already wakes the waiters.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/nfs/write.c              |    4 +---
 include/linux/backing-dev.h |    1 -
 mm/backing-dev.c            |   13 -------------
 3 files changed, 1 insertion(+), 17 deletions(-)

Index: linux-2.6-mm/fs/nfs/write.c
===================================================================
--- linux-2.6-mm.orig/fs/nfs/write.c	2007-04-05 16:24:50.000000000 +0200
+++ linux-2.6-mm/fs/nfs/write.c	2007-04-05 16:25:04.000000000 +0200
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
Index: linux-2.6-mm/include/linux/backing-dev.h
===================================================================
--- linux-2.6-mm.orig/include/linux/backing-dev.h	2007-04-05 16:24:50.000000000 +0200
+++ linux-2.6-mm/include/linux/backing-dev.h	2007-04-05 16:25:08.000000000 +0200
@@ -96,7 +96,6 @@ void clear_bdi_congested(struct backing_
 void set_bdi_congested(struct backing_dev_info *bdi, int rw);
 long congestion_wait(int rw, long timeout);
 long congestion_wait_interruptible(int rw, long timeout);
-void congestion_end(int rw);
 
 #define bdi_cap_writeback_dirty(bdi) \
 	(!((bdi)->capabilities & BDI_CAP_NO_WRITEBACK))
Index: linux-2.6-mm/mm/backing-dev.c
===================================================================
--- linux-2.6-mm.orig/mm/backing-dev.c	2007-04-05 16:24:50.000000000 +0200
+++ linux-2.6-mm/mm/backing-dev.c	2007-04-05 16:25:16.000000000 +0200
@@ -70,16 +70,3 @@ long congestion_wait_interruptible(int r
 	return ret;
 }
 EXPORT_SYMBOL(congestion_wait_interruptible);
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

