Return-Path: <linux-kernel-owner+w=401wt.eu-S1761428AbXJDJ37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761428AbXJDJ37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759439AbXJDJSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:18:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759496AbXJDJSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:18:14 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 33/51] [GFS2] Introduce gfs2_remove_from_ail
Date: Thu,  4 Oct 2007 09:49:26 +0100
Message-Id: <11914878513555-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878492645-git-send-email-swhiteho@redhat.com>
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
 <11914878422398-git-send-email-swhiteho@redhat.com>
 <1191487844772-git-send-email-swhiteho@redhat.com>
 <1191487846406-git-send-email-swhiteho@redhat.com>
 <11914878472056-git-send-email-swhiteho@redhat.com>
 <11914878492645-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This collects together the operations required to remove a gfs2_bufdata
from the ail lists. Its only called from two places to start with, but
expect to see more of this function in future.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 7ef6b23..b17346a 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -60,11 +60,7 @@ static void gfs2_ail_empty_gl(struct gfs2_glock *gl)
 		blkno = bh->b_blocknr;
 		gfs2_assert_withdraw(sdp, !buffer_busy(bh));
 
-		bd->bd_ail = NULL;
-		list_del(&bd->bd_ail_st_list);
-		list_del(&bd->bd_ail_gl_list);
-		atomic_dec(&gl->gl_ail_count);
-		brelse(bh);
+		gfs2_remove_from_ail(NULL, bd);
 		gfs2_log_unlock(sdp);
 
 		gfs2_trans_add_revoke(sdp, blkno);
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index d0e6b42..d8232ec 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -60,6 +60,26 @@ unsigned int gfs2_struct2blk(struct gfs2_sbd *sdp, unsigned int nstruct,
 }
 
 /**
+ * gfs2_remove_from_ail - Remove an entry from the ail lists, updating counters
+ * @mapping: The associated mapping (maybe NULL)
+ * @bd: The gfs2_bufdata to remove
+ *
+ * The log lock _must_ be held when calling this function
+ *
+ */
+
+void gfs2_remove_from_ail(struct address_space *mapping, struct gfs2_bufdata *bd)
+{
+	bd->bd_ail = NULL;
+	list_del(&bd->bd_ail_st_list);
+	list_del(&bd->bd_ail_gl_list);
+	atomic_dec(&bd->bd_gl->gl_ail_count);
+	if (mapping)
+		gfs2_meta_cache_flush(GFS2_I(mapping->host));
+	brelse(bd->bd_bh);
+}
+
+/**
  * gfs2_ail1_start_one - Start I/O on a part of the AIL
  * @sdp: the filesystem
  * @tr: the part of the AIL
@@ -219,21 +239,12 @@ static void gfs2_ail2_empty_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
 {
 	struct list_head *head = &ai->ai_ail2_list;
 	struct gfs2_bufdata *bd;
-	struct gfs2_inode *bh_ip;
 
 	while (!list_empty(head)) {
 		bd = list_entry(head->prev, struct gfs2_bufdata,
 				bd_ail_st_list);
 		gfs2_assert(sdp, bd->bd_ail == ai);
-		bd->bd_ail = NULL;
-		list_del(&bd->bd_ail_st_list);
-		list_del(&bd->bd_ail_gl_list);
-		atomic_dec(&bd->bd_gl->gl_ail_count);
-		if (bd->bd_bh->b_page->mapping) {
-			bh_ip = GFS2_I(bd->bd_bh->b_page->mapping->host);
-			gfs2_meta_cache_flush(bh_ip);
-		}
-		brelse(bd->bd_bh);
+		gfs2_remove_from_ail(bd->bd_bh->b_page->mapping, bd);
 	}
 }
 
diff --git a/fs/gfs2/log.h b/fs/gfs2/log.h
index 8e7aa0f..6394235 100644
--- a/fs/gfs2/log.h
+++ b/fs/gfs2/log.h
@@ -58,6 +58,7 @@ struct buffer_head *gfs2_log_fake_buf(struct gfs2_sbd *sdp,
 				      struct buffer_head *real);
 void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl);
 void gfs2_log_commit(struct gfs2_sbd *sdp, struct gfs2_trans *trans);
+void gfs2_remove_from_ail(struct address_space *mapping, struct gfs2_bufdata *bd);
 
 void gfs2_log_shutdown(struct gfs2_sbd *sdp);
 void gfs2_meta_syncfs(struct gfs2_sbd *sdp);
-- 
1.5.1.2

