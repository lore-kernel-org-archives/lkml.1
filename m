Return-Path: <linux-kernel-owner+w=401wt.eu-S1761041AbXJDJcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761041AbXJDJcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759473AbXJDJSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:18:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759281AbXJDJSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:18:23 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 38/51] [GFS2] Replace revoke structure with bufdata structure
Date: Thu,  4 Oct 2007 09:49:31 +0100
Message-Id: <11914878592314-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878571888-git-send-email-swhiteho@redhat.com>
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
 <11914878513555-git-send-email-swhiteho@redhat.com>
 <11914878521254-git-send-email-swhiteho@redhat.com>
 <119148785427-git-send-email-swhiteho@redhat.com>
 <11914878551328-git-send-email-swhiteho@redhat.com>
 <11914878571888-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

Both the revoke structure and the bufdata structure are quite similar.
They are basically small tags which are put on lists. In addition to
which the revoke structure is always allocated when there is a bufdata
structure which is (or can be) freed. As such it should be possible to
reduce the number of frees and allocations by using the same structure
for both purposes.

This patch is the first step along that path. It replaces existing uses
of the revoke structure with the bufdata structure.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 388dc1b..8aa5780 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -114,7 +114,13 @@ struct gfs2_bufdata {
 	struct buffer_head *bd_bh;
 	struct gfs2_glock *bd_gl;
 
-	struct list_head bd_list_tr;
+	union {
+		struct list_head list_tr;
+		u64 blkno;
+	} u;
+#define bd_list_tr u.list_tr
+#define bd_blkno u.blkno
+
 	struct gfs2_log_element bd_le;
 
 	struct gfs2_ail *bd_ail;
@@ -298,11 +304,6 @@ struct gfs2_file {
 	struct gfs2_holder f_fl_gh;
 };
 
-struct gfs2_revoke {
-	struct gfs2_log_element rv_le;
-	u64 rv_blkno;
-};
-
 struct gfs2_revoke_replay {
 	struct list_head rr_list;
 	u64 rr_blkno;
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 7e2d4e6..cf6fe36 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -357,7 +357,7 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 	struct buffer_head *bh;
 	unsigned int offset;
 	struct list_head *head = &sdp->sd_log_le_revoke;
-	struct gfs2_revoke *rv;
+	struct gfs2_bufdata *bd;
 
 	if (!sdp->sd_log_num_revoke)
 		return;
@@ -376,8 +376,8 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 	offset = sizeof(struct gfs2_log_descriptor);
 
 	while (!list_empty(head)) {
-		rv = list_entry(head->next, struct gfs2_revoke, rv_le.le_list);
-		list_del_init(&rv->rv_le.le_list);
+		bd = list_entry(head->next, struct gfs2_bufdata, bd_le.le_list);
+		list_del_init(&bd->bd_le.le_list);
 		sdp->sd_log_num_revoke--;
 
 		if (offset + sizeof(u64) > sdp->sd_sb.sb_bsize) {
@@ -392,8 +392,8 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 			offset = sizeof(struct gfs2_meta_header);
 		}
 
-		*(__be64 *)(bh->b_data + offset) = cpu_to_be64(rv->rv_blkno);
-		kfree(rv);
+		*(__be64 *)(bh->b_data + offset) = cpu_to_be64(bd->bd_blkno);
+		kfree(bd);
 
 		offset += sizeof(u64);
 	}
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index f8dabf8..eadf96e 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -144,23 +144,23 @@ void gfs2_trans_add_bh(struct gfs2_glock *gl, struct buffer_head *bh, int meta)
 
 void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, u64 blkno)
 {
-	struct gfs2_revoke *rv = kmalloc(sizeof(struct gfs2_revoke),
-					 GFP_NOFS | __GFP_NOFAIL);
-	lops_init_le(&rv->rv_le, &gfs2_revoke_lops);
-	rv->rv_blkno = blkno;
-	lops_add(sdp, &rv->rv_le);
+	struct gfs2_bufdata *bd = kmalloc(sizeof(struct gfs2_bufdata),
+					  GFP_NOFS | __GFP_NOFAIL);
+	lops_init_le(&bd->bd_le, &gfs2_revoke_lops);
+	bd->bd_blkno = blkno;
+	lops_add(sdp, &bd->bd_le);
 }
 
 void gfs2_trans_add_unrevoke(struct gfs2_sbd *sdp, u64 blkno)
 {
-	struct gfs2_revoke *rv;
+	struct gfs2_bufdata *bd;
 	int found = 0;
 
 	gfs2_log_lock(sdp);
 
-	list_for_each_entry(rv, &sdp->sd_log_le_revoke, rv_le.le_list) {
-		if (rv->rv_blkno == blkno) {
-			list_del(&rv->rv_le.le_list);
+	list_for_each_entry(bd, &sdp->sd_log_le_revoke, bd_le.le_list) {
+		if (bd->bd_blkno == blkno) {
+			list_del(&bd->bd_le.le_list);
 			gfs2_assert_withdraw(sdp, sdp->sd_log_num_revoke);
 			sdp->sd_log_num_revoke--;
 			found = 1;
@@ -172,7 +172,7 @@ void gfs2_trans_add_unrevoke(struct gfs2_sbd *sdp, u64 blkno)
 
 	if (found) {
 		struct gfs2_trans *tr = current->journal_info;
-		kfree(rv);
+		kfree(bd);
 		tr->tr_num_revoke_rm++;
 	}
 }
-- 
1.5.1.2

