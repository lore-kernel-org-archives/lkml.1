Return-Path: <linux-kernel-owner+w=401wt.eu-S1760848AbYBSTc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760848AbYBSTc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761370AbYBSTbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:31:34 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49220 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761348AbYBSTbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:31:33 -0500
Date: Tue, 19 Feb 2008 21:30:57 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jonathan Brassow <jbrassow@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6.25 patch] dm-raid1.c: fix NULL dereferences
Message-ID: <20080219193057.GJ31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes two NULL dereferences introduced by
commit 06386bbfd2441416875d0403d405c56822f6ebac and spotted by the 
Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/md/dm-raid1.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- linux-2.6/drivers/md/dm-raid1.c.old	2008-02-19 21:14:33.000000000 +0200
+++ linux-2.6/drivers/md/dm-raid1.c	2008-02-19 21:17:04.000000000 +0200
@@ -1673,58 +1673,59 @@ static int mirror_end_io(struct dm_targe
 	struct mirror *m = NULL;
 	struct dm_bio_details *bd = NULL;
 	struct dm_raid1_read_record *read_record = map_context->ptr;
 
 	/*
 	 * We need to dec pending if this was a write.
 	 */
 	if (rw == WRITE) {
 		rh_dec(&ms->rh, map_context->ll);
 		return error;
 	}
 
 	if (error == -EOPNOTSUPP)
 		goto out;
 
 	if ((error == -EWOULDBLOCK) && bio_rw_ahead(bio))
 		goto out;
 
 	if (unlikely(error)) {
 		if (!read_record) {
 			/*
 			 * There wasn't enough memory to record necessary
 			 * information for a retry or there was no other
 			 * mirror in-sync.
 			 */
-			DMERR_LIMIT("Mirror read failed from %s.",
-				    m->dev->name);
+			DMERR_LIMIT("Mirror read failed.");
 			return -EIO;
 		}
+
+		m = read_record->m;
+
 		DMERR("Mirror read failed from %s. Trying alternative device.",
 		      m->dev->name);
 
-		m = read_record->m;
 		fail_mirror(m, DM_RAID1_READ_ERROR);
 
 		/*
 		 * A failed read is requeued for another attempt using an intact
 		 * mirror.
 		 */
 		if (default_ok(m) || mirror_available(ms, bio)) {
 			bd = &read_record->details;
 
 			dm_bio_restore(bd, bio);
 			mempool_free(read_record, ms->read_record_pool);
 			map_context->ptr = NULL;
 			queue_bio(ms, bio, rw);
 			return 1;
 		}
 		DMERR("All replicated volumes dead, failing I/O");
 	}
 
 out:
 	if (read_record) {
 		mempool_free(read_record, ms->read_record_pool);
 		map_context->ptr = NULL;
 	}
 
 	return error;

