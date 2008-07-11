Return-Path: <linux-kernel-owner+w=401wt.eu-S1759012AbYGKLHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012AbYGKLHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756698AbYGKLB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:01:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851AbYGKLB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:01:56 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 16/18] [GFS2] Replace rgrp "recent list" with mru list
Date: Fri, 11 Jul 2008 11:11:17 +0100
Message-Id: <12157711171692-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12157711153366-git-send-email-swhiteho@redhat.com>
References: <121577107950-git-send-email-swhiteho@redhat.com>
 <12157710872782-git-send-email-swhiteho@redhat.com>
 <1215771089769-git-send-email-swhiteho@redhat.com>
 <1215771091790-git-send-email-swhiteho@redhat.com>
 <12157710931623-git-send-email-swhiteho@redhat.com>
 <12157710954145-git-send-email-swhiteho@redhat.com>
 <12157710973601-git-send-email-swhiteho@redhat.com>
 <12157710983282-git-send-email-swhiteho@redhat.com>
 <12157711013356-git-send-email-swhiteho@redhat.com>
 <12157711023743-git-send-email-swhiteho@redhat.com>
 <12157711041157-git-send-email-swhiteho@redhat.com>
 <1215771106247-git-send-email-swhiteho@redhat.com>
 <12157711073280-git-send-email-swhiteho@redhat.com>
 <12157711093284-git-send-email-swhiteho@redhat.com>
 <12157711133727-git-send-email-swhiteho@redhat.com>
 <12157711153366-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch removes the "recent list" which is used during allocation
and replaces it with the (already existing) mru list used during
deletion. The "recent list" was not a true mru list leading to a number
of inefficiencies including a "next" function which made scanning the
list an order N^2 operation wrt to the number of list elements.

This should increase allocation performance with large numbers of rgrps.
Its also a useful preparation and cleanup before some further changes
which are planned in this area.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 4b734c6..4ab3c3a 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -77,7 +77,6 @@ struct gfs2_rgrp_host {
 struct gfs2_rgrpd {
 	struct list_head rd_list;	/* Link with superblock */
 	struct list_head rd_list_mru;
-	struct list_head rd_recent;	/* Recently used rgrps */
 	struct gfs2_glock *rd_gl;	/* Glock for this rgrp */
 	u64 rd_addr;			/* grp block disk address */
 	u64 rd_data0;			/* first data location */
@@ -529,7 +528,6 @@ struct gfs2_sbd {
 	struct mutex sd_rindex_mutex;
 	struct list_head sd_rindex_list;
 	struct list_head sd_rindex_mru_list;
-	struct list_head sd_rindex_recent_list;
 	struct gfs2_rgrpd *sd_rindex_forward;
 	unsigned int sd_rgrps;
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 6ba69dd..b4d1d64 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -64,7 +64,6 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 	mutex_init(&sdp->sd_rindex_mutex);
 	INIT_LIST_HEAD(&sdp->sd_rindex_list);
 	INIT_LIST_HEAD(&sdp->sd_rindex_mru_list);
-	INIT_LIST_HEAD(&sdp->sd_rindex_recent_list);
 
 	INIT_LIST_HEAD(&sdp->sd_jindex_list);
 	spin_lock_init(&sdp->sd_jindex_spin);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 3401628..2d90fb2 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -371,11 +371,6 @@ static void clear_rgrpdi(struct gfs2_sbd *sdp)
 
 	spin_lock(&sdp->sd_rindex_spin);
 	sdp->sd_rindex_forward = NULL;
-	head = &sdp->sd_rindex_recent_list;
-	while (!list_empty(head)) {
-		rgd = list_entry(head->next, struct gfs2_rgrpd, rd_recent);
-		list_del(&rgd->rd_recent);
-	}
 	spin_unlock(&sdp->sd_rindex_spin);
 
 	head = &sdp->sd_rindex_list;
@@ -945,107 +940,30 @@ static struct inode *try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked)
 }
 
 /**
- * recent_rgrp_first - get first RG from "recent" list
- * @sdp: The GFS2 superblock
- * @rglast: address of the rgrp used last
- *
- * Returns: The first rgrp in the recent list
- */
-
-static struct gfs2_rgrpd *recent_rgrp_first(struct gfs2_sbd *sdp,
-					    u64 rglast)
-{
-	struct gfs2_rgrpd *rgd;
-
-	spin_lock(&sdp->sd_rindex_spin);
-
-	if (rglast) {
-		list_for_each_entry(rgd, &sdp->sd_rindex_recent_list, rd_recent) {
-			if (rgrp_contains_block(rgd, rglast))
-				goto out;
-		}
-	}
-	rgd = NULL;
-	if (!list_empty(&sdp->sd_rindex_recent_list))
-		rgd = list_entry(sdp->sd_rindex_recent_list.next,
-				 struct gfs2_rgrpd, rd_recent);
-out:
-	spin_unlock(&sdp->sd_rindex_spin);
-	return rgd;
-}
-
-/**
  * recent_rgrp_next - get next RG from "recent" list
  * @cur_rgd: current rgrp
- * @remove:
  *
  * Returns: The next rgrp in the recent list
  */
 
-static struct gfs2_rgrpd *recent_rgrp_next(struct gfs2_rgrpd *cur_rgd,
-					   int remove)
+static struct gfs2_rgrpd *recent_rgrp_next(struct gfs2_rgrpd *cur_rgd)
 {
 	struct gfs2_sbd *sdp = cur_rgd->rd_sbd;
 	struct list_head *head;
 	struct gfs2_rgrpd *rgd;
 
 	spin_lock(&sdp->sd_rindex_spin);
-
-	head = &sdp->sd_rindex_recent_list;
-
-	list_for_each_entry(rgd, head, rd_recent) {
-		if (rgd == cur_rgd) {
-			if (cur_rgd->rd_recent.next != head)
-				rgd = list_entry(cur_rgd->rd_recent.next,
-						 struct gfs2_rgrpd, rd_recent);
-			else
-				rgd = NULL;
-
-			if (remove)
-				list_del(&cur_rgd->rd_recent);
-
-			goto out;
-		}
+	head = &sdp->sd_rindex_mru_list;
+	if (unlikely(cur_rgd->rd_list_mru.next == head)) {
+		spin_unlock(&sdp->sd_rindex_spin);
+		return NULL;
 	}
-
-	rgd = NULL;
-	if (!list_empty(head))
-		rgd = list_entry(head->next, struct gfs2_rgrpd, rd_recent);
-
-out:
+	rgd = list_entry(cur_rgd->rd_list_mru.next, struct gfs2_rgrpd, rd_list_mru);
 	spin_unlock(&sdp->sd_rindex_spin);
 	return rgd;
 }
 
 /**
- * recent_rgrp_add - add an RG to tail of "recent" list
- * @new_rgd: The rgrp to add
- *
- */
-
-static void recent_rgrp_add(struct gfs2_rgrpd *new_rgd)
-{
-	struct gfs2_sbd *sdp = new_rgd->rd_sbd;
-	struct gfs2_rgrpd *rgd;
-	unsigned int count = 0;
-	unsigned int max = sdp->sd_rgrps / gfs2_jindex_size(sdp);
-
-	spin_lock(&sdp->sd_rindex_spin);
-
-	list_for_each_entry(rgd, &sdp->sd_rindex_recent_list, rd_recent) {
-		if (rgd == new_rgd)
-			goto out;
-
-		if (++count >= max)
-			goto out;
-	}
-	list_add_tail(&new_rgd->rd_recent, &sdp->sd_rindex_recent_list);
-
-out:
-	spin_unlock(&sdp->sd_rindex_spin);
-}
-
-/**
  * forward_rgrp_get - get an rgrp to try next from full list
  * @sdp: The GFS2 superblock
  *
@@ -1112,9 +1030,7 @@ static struct inode *get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 	int loops = 0;
 	int error, rg_locked;
 
-	/* Try recently successful rgrps */
-
-	rgd = recent_rgrp_first(sdp, ip->i_goal);
+	rgd = gfs2_blk2rgrpd(sdp, ip->i_goal);
 
 	while (rgd) {
 		rg_locked = 0;
@@ -1136,11 +1052,9 @@ static struct inode *get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 				gfs2_glock_dq_uninit(&al->al_rgd_gh);
 			if (inode)
 				return inode;
-			rgd = recent_rgrp_next(rgd, 1);
-			break;
-
+			/* fall through */
 		case GLR_TRYFAILED:
-			rgd = recent_rgrp_next(rgd, 0);
+			rgd = recent_rgrp_next(rgd);
 			break;
 
 		default:
@@ -1199,7 +1113,9 @@ static struct inode *get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 
 out:
 	if (begin) {
-		recent_rgrp_add(rgd);
+		spin_lock(&sdp->sd_rindex_spin);
+		list_move(&rgd->rd_list_mru, &sdp->sd_rindex_mru_list);
+		spin_unlock(&sdp->sd_rindex_spin);
 		rgd = gfs2_rgrpd_get_next(rgd);
 		if (!rgd)
 			rgd = gfs2_rgrpd_get_first(sdp);
-- 
1.5.1.2

