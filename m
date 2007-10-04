Return-Path: <linux-kernel-owner+w=401wt.eu-S1759765AbXJDJTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765AbXJDJTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759395AbXJDJR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:17:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759351AbXJDJRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:17:24 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/51] [GFS2] Move some code inside the log lock
Date: Thu,  4 Oct 2007 09:48:59 +0100
Message-Id: <11914878002186-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914877993073-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This is the first of five patches for bug #248176:

There were still some critical variables being manipulated outside
the log_lock spinlock.  That usually resulted in a hang.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 3b395c4..a0371f8 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -117,7 +117,7 @@ static void buf_lo_before_commit(struct gfs2_sbd *sdp)
 	struct buffer_head *bh;
 	struct gfs2_log_descriptor *ld;
 	struct gfs2_bufdata *bd1 = NULL, *bd2;
-	unsigned int total = sdp->sd_log_num_buf;
+	unsigned int total;
 	unsigned int offset = BUF_OFFSET;
 	unsigned int limit;
 	unsigned int num;
@@ -127,12 +127,16 @@ static void buf_lo_before_commit(struct gfs2_sbd *sdp)
 	limit = buf_limit(sdp);
 	/* for 4k blocks, limit = 503 */
 
+	gfs2_log_lock(sdp);
+	total = sdp->sd_log_num_buf;
 	bd1 = bd2 = list_prepare_entry(bd1, &sdp->sd_log_le_buf, bd_le.le_list);
 	while(total) {
 		num = total;
 		if (total > limit)
 			num = limit;
+		gfs2_log_unlock(sdp);
 		bh = gfs2_log_get_buf(sdp);
+		gfs2_log_lock(sdp);
 		ld = (struct gfs2_log_descriptor *)bh->b_data;
 		ptr = (__be64 *)(bh->b_data + offset);
 		ld->ld_header.mh_magic = cpu_to_be32(GFS2_MAGIC);
@@ -152,21 +156,27 @@ static void buf_lo_before_commit(struct gfs2_sbd *sdp)
 				break;
 		}
 
+		gfs2_log_unlock(sdp);
 		set_buffer_dirty(bh);
 		ll_rw_block(WRITE, 1, &bh);
+		gfs2_log_lock(sdp);
 
 		n = 0;
 		list_for_each_entry_continue(bd2, &sdp->sd_log_le_buf,
 					     bd_le.le_list) {
+			gfs2_log_unlock(sdp);
 			bh = gfs2_log_fake_buf(sdp, bd2->bd_bh);
 			set_buffer_dirty(bh);
 			ll_rw_block(WRITE, 1, &bh);
+			gfs2_log_lock(sdp);
 			if (++n >= num)
 				break;
 		}
 
+		BUG_ON(total < num);
 		total -= num;
 	}
+	gfs2_log_unlock(sdp);
 }
 
 static void buf_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
@@ -524,7 +534,7 @@ static void databuf_lo_before_commit(struct gfs2_sbd *sdp)
 	struct gfs2_log_descriptor *ld;
 	unsigned int limit;
 	unsigned int total_dbuf;
-	unsigned int total_jdata = sdp->sd_log_num_jdata;
+	unsigned int total_jdata;
 	unsigned int num, n;
 	__be64 *ptr = NULL;
 
@@ -536,6 +546,7 @@ static void databuf_lo_before_commit(struct gfs2_sbd *sdp)
 	 */
 	gfs2_log_lock(sdp);
 	total_dbuf = sdp->sd_log_num_databuf;
+	total_jdata = sdp->sd_log_num_jdata;
 	bd2 = bd1 = list_prepare_entry(bd1, &sdp->sd_log_le_databuf,
 				       bd_le.le_list);
 	while(total_dbuf) {
@@ -621,10 +632,10 @@ static void databuf_lo_before_commit(struct gfs2_sbd *sdp)
 		}
 		gfs2_log_unlock(sdp);
 		if (bh) {
-			set_buffer_mapped(bh);
 			set_buffer_dirty(bh);
 			ll_rw_block(WRITE, 1, &bh);
 			bh = NULL;
+			ptr = NULL;
 		}
 		n = 0;
 		gfs2_log_lock(sdp);
-- 
1.5.1.2

