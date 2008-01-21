Return-Path: <linux-kernel-owner+w=401wt.eu-S1760826AbYAUKN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760826AbYAUKN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759908AbYAUKCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759858AbYAUKCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:43 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Abhijith Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 31/58] [GFS2] patch to check for recursive lock requests in gfs2_rename code path
Date: Mon, 21 Jan 2008 09:21:49 +0000
Message-Id: <12009073953412-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073933630-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
 <12009073542596-git-send-email-swhiteho@redhat.com>
 <1200907356883-git-send-email-swhiteho@redhat.com>
 <12009073571991-git-send-email-swhiteho@redhat.com>
 <12009073591688-git-send-email-swhiteho@redhat.com>
 <12009073611695-git-send-email-swhiteho@redhat.com>
 <1200907362266-git-send-email-swhiteho@redhat.com>
 <12009073642512-git-send-email-swhiteho@redhat.com>
 <12009073662309-git-send-email-swhiteho@redhat.com>
 <12009073671755-git-send-email-swhiteho@redhat.com>
 <12009073698-git-send-email-swhiteho@redhat.com>
 <12009073701982-git-send-email-swhiteho@redhat.com>
 <12009073722253-git-send-email-swhiteho@redhat.com>
 <1200907374616-git-send-email-swhiteho@redhat.com>
 <12009073753723-git-send-email-swhiteho@redhat.com>
 <12009073771883-git-send-email-swhiteho@redhat.com>
 <1200907378664-git-send-email-swhiteho@redhat.com>
 <12009073803732-git-send-email-swhiteho@redhat.com>
 <12009073823161-git-send-email-swhiteho@redhat.com>
 <12009073841692-git-send-email-swhiteho@redhat.com>
 <12009073862261-git-send-email-swhiteho@redhat.com>
 <12009073883125-git-send-email-swhiteho@redhat.com>
 <12009073891848-git-send-email-swhiteho@redhat.com>
 <12009073913676-git-send-email-swhiteho@redhat.com>
 <12009073933630-git-send-email-swhiteho@redhat.com>
Message-Id: <43ddd9bb92c549ac3e7021a1ae5f4657a162c878.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

A certain scenario in the rename code path triggers a kernel BUG()
because it accidentally does recursive locking The first lock is
requested to unlink an already existing inode (replacing a file) and the
second lock is requested when the destination directory needs to alloc
some space. It is rare that these two
events happen during the same rename call, and even more rare that these
two instances try to lock the same rgrp. It is, however, possible.
https://bugzilla.redhat.com/show_bug.cgi?id=404711

Signed-off-by: Abhijith Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 09848aa..e0ee195 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1063,22 +1063,30 @@ static struct inode *get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 	int flags = LM_FLAG_TRY;
 	int skipped = 0;
 	int loops = 0;
-	int error;
+	int error, rg_locked;
 
 	/* Try recently successful rgrps */
 
 	rgd = recent_rgrp_first(sdp, ip->i_last_rg_alloc);
 
 	while (rgd) {
-		error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_EXCLUSIVE,
-					   LM_FLAG_TRY, &al->al_rgd_gh);
+		rg_locked = 0;
+
+		if (gfs2_glock_is_locked_by_me(rgd->rd_gl)) {
+			rg_locked = 1;
+			error = 0;
+		} else {
+			error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_EXCLUSIVE,
+						   LM_FLAG_TRY, &al->al_rgd_gh);
+		}
 		switch (error) {
 		case 0:
 			if (try_rgrp_fit(rgd, al))
 				goto out;
 			if (rgd->rd_flags & GFS2_RDF_CHECK)
 				inode = try_rgrp_unlink(rgd, last_unlinked);
-			gfs2_glock_dq_uninit(&al->al_rgd_gh);
+			if (!rg_locked)
+				gfs2_glock_dq_uninit(&al->al_rgd_gh);
 			if (inode)
 				return inode;
 			rgd = recent_rgrp_next(rgd, 1);
@@ -1098,15 +1106,23 @@ static struct inode *get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 	begin = rgd = forward_rgrp_get(sdp);
 
 	for (;;) {
-		error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_EXCLUSIVE, flags,
-					  &al->al_rgd_gh);
+		rg_locked = 0;
+
+		if (gfs2_glock_is_locked_by_me(rgd->rd_gl)) {
+			rg_locked = 1;
+			error = 0;
+		} else {
+			error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_EXCLUSIVE, flags,
+						   &al->al_rgd_gh);
+		}
 		switch (error) {
 		case 0:
 			if (try_rgrp_fit(rgd, al))
 				goto out;
 			if (rgd->rd_flags & GFS2_RDF_CHECK)
 				inode = try_rgrp_unlink(rgd, last_unlinked);
-			gfs2_glock_dq_uninit(&al->al_rgd_gh);
+			if (!rg_locked)
+				gfs2_glock_dq_uninit(&al->al_rgd_gh);
 			if (inode)
 				return inode;
 			break;
@@ -1213,7 +1229,8 @@ void gfs2_inplace_release(struct gfs2_inode *ip)
 			     al->al_line);
 
 	al->al_rgd = NULL;
-	gfs2_glock_dq_uninit(&al->al_rgd_gh);
+	if (al->al_rgd_gh.gh_gl)
+		gfs2_glock_dq_uninit(&al->al_rgd_gh);
 	if (ip != GFS2_I(sdp->sd_rindex))
 		gfs2_glock_dq_uninit(&al->al_ri_gh);
 }
-- 
1.5.1.2

