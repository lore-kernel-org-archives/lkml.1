Return-Path: <linux-kernel-owner+w=401wt.eu-S1761503AbXJDJca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761503AbXJDJca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759100AbXJDJSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:18:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759578AbXJDJSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:18:25 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 39/51] [GFS2] Use slab operations for all gfs2_bufdata allocations
Date: Thu,  4 Oct 2007 09:49:32 +0100
Message-Id: <1191487861683-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878592314-git-send-email-swhiteho@redhat.com>
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
 <11914878592314-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The old revoke structure was allocated using kalloc/kfree but
there is a slab cache for gfs2_bufdata, so we should use that
now that the structures have been converted.

This is part two of the patch series to merge the revoke
and gfs2_bufdata structures.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index cf6fe36..4cbef4c 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -393,7 +393,7 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 		}
 
 		*(__be64 *)(bh->b_data + offset) = cpu_to_be64(bd->bd_blkno);
-		kfree(bd);
+		kmem_cache_free(gfs2_bufdata_cachep, bd);
 
 		offset += sizeof(u64);
 	}
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index eadf96e..01cc27f 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -144,7 +144,7 @@ void gfs2_trans_add_bh(struct gfs2_glock *gl, struct buffer_head *bh, int meta)
 
 void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, u64 blkno)
 {
-	struct gfs2_bufdata *bd = kmalloc(sizeof(struct gfs2_bufdata),
+	struct gfs2_bufdata *bd = kmem_cache_alloc(gfs2_bufdata_cachep,
 					  GFP_NOFS | __GFP_NOFAIL);
 	lops_init_le(&bd->bd_le, &gfs2_revoke_lops);
 	bd->bd_blkno = blkno;
@@ -172,7 +172,7 @@ void gfs2_trans_add_unrevoke(struct gfs2_sbd *sdp, u64 blkno)
 
 	if (found) {
 		struct gfs2_trans *tr = current->journal_info;
-		kfree(bd);
+		kmem_cache_free(gfs2_bufdata_cachep, bd);
 		tr->tr_num_revoke_rm++;
 	}
 }
-- 
1.5.1.2

