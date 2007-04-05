Return-Path: <linux-kernel-owner+w=401wt.eu-S1767152AbXDERnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767152AbXDERnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 13:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767158AbXDERnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 13:43:49 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:14216 "EHLO
	amsfep18-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1767152AbXDERns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 13:43:48 -0400
Message-Id: <20070405174317.592853325@programming.kicks-ass.net>
References: <20070405174209.498059336@programming.kicks-ass.net>
User-Agent: quilt/0.45-1
Date: Thu, 05 Apr 2007 19:42:10 +0200
From: root@programming.kicks-ass.net
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com
Subject: [PATCH 01/12] nfs: remove congestion_end()
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

