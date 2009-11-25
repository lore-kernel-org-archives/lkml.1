Return-Path: <linux-kernel-owner+w=401wt.eu-S964860AbZKYN21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964860AbZKYN21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933159AbZKYN2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:28:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934542AbZKYN2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:28:23 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 12/30] GFS2: Remove obsolete code in quota.c
Date: Wed, 25 Nov 2009 14:22:37 +0000
Message-Id: <1259158975-28499-13-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259158975-28499-12-git-send-email-swhiteho@redhat.com>
References: <1259158975-28499-1-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-2-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-3-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-4-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-5-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-6-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-7-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-8-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-9-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-10-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-11-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-12-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point in testing for GLF_DEMOTE here, we might as
well always release the glock at that point.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/glock.h |    9 ---------
 fs/gfs2/quota.c |   13 +++++--------
 2 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index c609894..13f0bd2 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -180,15 +180,6 @@ static inline int gfs2_glock_is_held_shrd(struct gfs2_glock *gl)
 	return gl->gl_state == LM_ST_SHARED;
 }
 
-static inline int gfs2_glock_is_blocking(struct gfs2_glock *gl)
-{
-	int ret;
-	spin_lock(&gl->gl_spin);
-	ret = test_bit(GLF_DEMOTE, &gl->gl_flags);
-	spin_unlock(&gl->gl_spin);
-	return ret;
-}
-
 int gfs2_glock_get(struct gfs2_sbd *sdp,
 		   u64 number, const struct gfs2_glock_operations *glops,
 		   int create, struct gfs2_glock **glp);
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 73a43ce..6aaa6c5 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -843,9 +843,8 @@ restart:
 	if (force_refresh || qd->qd_qb.qb_magic != cpu_to_be32(GFS2_MAGIC)) {
 		loff_t pos;
 		gfs2_glock_dq_uninit(q_gh);
-		error = gfs2_glock_nq_init(qd->qd_gl,
-					   LM_ST_EXCLUSIVE, GL_NOCACHE,
-					   q_gh);
+		error = gfs2_glock_nq_init(qd->qd_gl, LM_ST_EXCLUSIVE,
+					   GL_NOCACHE, q_gh);
 		if (error)
 			return error;
 
@@ -871,11 +870,9 @@ restart:
 		qlvb->qb_value = cpu_to_be64(q.qu_value);
 		qd->qd_qb = *qlvb;
 
-		if (gfs2_glock_is_blocking(qd->qd_gl)) {
-			gfs2_glock_dq_uninit(q_gh);
-			force_refresh = 0;
-			goto restart;
-		}
+		gfs2_glock_dq_uninit(q_gh);
+		force_refresh = 0;
+		goto restart;
 	}
 
 	return 0;
-- 
1.6.2.5

