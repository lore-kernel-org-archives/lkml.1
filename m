Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbXHNKPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbXHNKPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 06:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756930AbXHNKK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 06:10:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630AbXHNKKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 06:10:49 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] soft lockup detected in databuf_lo_before_commit
Date: Tue, 14 Aug 2007 10:47:11 +0100
Message-Id: <11870848533543-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11870848365-git-send-email-swhiteho@redhat.com>
References: <11870848365-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This is part 2 of the patch for bug #245832, part 1 of which is already
in the git tree.

The problem was that sdp->sd_log_num_databuf was not always being
protected by the gfs2_log_lock spinlock, but the sd_log_le_databuf
(which it is supposed to reflect) was protected.  That meant there
was a timing window during which gfs2_log_flush called
databuf_lo_before_commit and the count didn't match what was
really on the linked list in that window.  So when it ran out of
items on the linked list, it decremented total_dbuf from 0 to -1 and
thus never left the "while(total_dbuf)" loop.

The solution is to protect the variable sdp->sd_log_num_databuf so
that the value will always match the contents of the linked list,
and therefore the number will never go negative, and therefore, the
loop will be exited properly.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index aff70f0..3b395c4 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -486,8 +486,8 @@ static void databuf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 		gfs2_pin(sdp, bd->bd_bh);
 		tr->tr_num_databuf_new++;
 	}
-	sdp->sd_log_num_databuf++;
 	gfs2_log_lock(sdp);
+	sdp->sd_log_num_databuf++;
 	list_add(&le->le_list, &sdp->sd_log_le_databuf);
 	gfs2_log_unlock(sdp);
 }
@@ -523,7 +523,7 @@ static void databuf_lo_before_commit(struct gfs2_sbd *sdp)
 	struct buffer_head *bh = NULL,*bh1 = NULL;
 	struct gfs2_log_descriptor *ld;
 	unsigned int limit;
-	unsigned int total_dbuf = sdp->sd_log_num_databuf;
+	unsigned int total_dbuf;
 	unsigned int total_jdata = sdp->sd_log_num_jdata;
 	unsigned int num, n;
 	__be64 *ptr = NULL;
@@ -535,6 +535,7 @@ static void databuf_lo_before_commit(struct gfs2_sbd *sdp)
 	 * into the log along with a header
 	 */
 	gfs2_log_lock(sdp);
+	total_dbuf = sdp->sd_log_num_databuf;
 	bd2 = bd1 = list_prepare_entry(bd1, &sdp->sd_log_le_databuf,
 				       bd_le.le_list);
 	while(total_dbuf) {
@@ -653,6 +654,7 @@ static void databuf_lo_before_commit(struct gfs2_sbd *sdp)
 				break;
 		}
 		bh = NULL;
+		BUG_ON(total_dbuf < num);
 		total_dbuf -= num;
 		total_jdata -= num;
 	}
-- 
1.5.1.2

