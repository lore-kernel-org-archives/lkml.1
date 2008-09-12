Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbYILOnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbYILOnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 10:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbYILOnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 10:43:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532AbYILOnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 10:43:41 -0400
Date: Fri, 12 Sep 2008 10:44:30 -0400 (EDT)
Message-Id: <20080912.104430.48801726.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, agk@redhat.com,
       James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 06/13] dm: remove unused DM_WQ_FLUSH_ALL
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
References: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes dead codes for the noflush suspend.
No functional change.

This patch is just a clean up of the codes and not functionally
related to request-based dm.  But included here due to literal
dependency.

The dm_queue_flush(md, DM_WQ_FLUSH_ALL, NULL) in dm_suspend()
is never invoked because:
  - The 'goto flush_and_out' is same as 'goto out', because
    the 'goto flush_and_out' is called only when '!noflush'
  - If the 'r && noflush' is true, the interrupt check code above
    is invoked and 'goto out'

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Milan Broz <mbroz@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |   14 +-------------
 1 files changed, 1 insertion(+), 13 deletions(-)

Index: 2.6.27-rc6/drivers/md/dm.c
===================================================================
--- 2.6.27-rc6.orig/drivers/md/dm.c
+++ 2.6.27-rc6/drivers/md/dm.c
@@ -76,7 +76,6 @@ union map_info *dm_get_mapinfo(struct bi
  */
 struct dm_wq_req {
 	enum {
-		DM_WQ_FLUSH_ALL,
 		DM_WQ_FLUSH_DEFERRED,
 	} type;
 	struct work_struct work;
@@ -1384,9 +1383,6 @@ static void dm_wq_work(struct work_struc
 
 	down_write(&md->io_lock);
 	switch (req->type) {
-	case DM_WQ_FLUSH_ALL:
-		__merge_pushback_list(md);
-		/* pass through */
 	case DM_WQ_FLUSH_DEFERRED:
 		__flush_deferred_io(md);
 		break;
@@ -1516,7 +1512,7 @@ int dm_suspend(struct mapped_device *md,
 		if (!md->suspended_bdev) {
 			DMWARN("bdget failed in dm_suspend");
 			r = -ENOMEM;
-			goto flush_and_out;
+			goto out;
 		}
 
 		/*
@@ -1567,14 +1563,6 @@ int dm_suspend(struct mapped_device *md,
 
 	set_bit(DMF_SUSPENDED, &md->flags);
 
-flush_and_out:
-	if (r && noflush)
-		/*
-		 * Because there may be already I/Os in the pushback list,
-		 * flush them before return.
-		 */
-		dm_queue_flush(md, DM_WQ_FLUSH_ALL, NULL);
-
 out:
 	if (r && md->suspended_bdev) {
 		bdput(md->suspended_bdev);
