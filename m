Return-Path: <linux-kernel-owner+w=401wt.eu-S1760594AbXJDJ2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594AbXJDJ2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759554AbXJDJSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:18:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755839AbXJDJSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:18:06 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 28/51] [GFS2] Patch to protect sd_log_num_jdata
Date: Thu,  4 Oct 2007 09:49:21 +0100
Message-Id: <11914878422398-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878401428-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
 <1191487802255-git-send-email-swhiteho@redhat.com>
 <11914878043598-git-send-email-swhiteho@redhat.com>
 <11914878063121-git-send-email-swhiteho@redhat.com>
 <11914878081562-git-send-email-swhiteho@redhat.com>
 <11914878102813-git-send-email-swhiteho@redhat.com>
 <1191487812928-git-send-email-swhiteho@redhat.com>
 <11914878141625-git-send-email-swhiteho@redhat.com>
 <1191487815172-git-send-email-swhiteho@redhat.com>
 <11914878173677-git-send-email-swhiteho@redhat.com>
 <11914878191964-git-send-email-swhiteho@redhat.com>
 <11914878214113-git-send-email-swhiteho@redhat.com>
 <11914878231394-git-send-email-swhiteho@redhat.com>
 <11914878252873-git-send-email-swhiteho@redhat.com>
 <11914878271468-git-send-email-swhiteho@redhat.com>
 <11914878283252-git-send-email-swhiteho@redhat.com>
 <11914878304004-git-send-email-swhiteho@redhat.com>
 <11914878323899-git-send-email-swhiteho@redhat.com>
 <11914878342921-git-send-email-swhiteho@redhat.com>
 <11914878361239-git-send-email-swhiteho@redhat.com>
 <11914878383633-git-send-email-swhiteho@redhat.com>
 <11914878401428-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This is a patch to GFS2 to protect sd_log_num_jdata with the
gfs2_log_lock.  Without this patch, there is a timing window
where you can get hit the following assert from function
gfs2_log_flush():

gfs2_assert_withdraw(sdp,
			sdp->sd_log_num_buf + sdp->sd_log_num_jdata ==
			sdp->sd_log_commited_buf +
			sdp->sd_log_commited_databuf);

I've tested it on my roth cluster and it fixes the problem.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index a0371f8..7ef3356 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -492,11 +492,12 @@ static void databuf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 
 	gfs2_trans_add_gl(bd->bd_gl);
 	if (gfs2_is_jdata(ip)) {
-		sdp->sd_log_num_jdata++;
 		gfs2_pin(sdp, bd->bd_bh);
 		tr->tr_num_databuf_new++;
 	}
 	gfs2_log_lock(sdp);
+	if (gfs2_is_jdata(ip))
+		sdp->sd_log_num_jdata++;
 	sdp->sd_log_num_databuf++;
 	list_add(&le->le_list, &sdp->sd_log_le_databuf);
 	gfs2_log_unlock(sdp);
-- 
1.5.1.2

