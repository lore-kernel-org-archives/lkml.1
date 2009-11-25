Return-Path: <linux-kernel-owner+w=401wt.eu-S964908AbZKYNg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964908AbZKYNg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934746AbZKYNg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:36:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934714AbZKYNgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:36:24 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 27/30] GFS2: Locking order fix in gfs2_check_blk_state
Date: Wed, 25 Nov 2009 14:30:59 +0000
Message-Id: <1259159462-28622-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259159462-28622-6-git-send-email-swhiteho@redhat.com>
References: <1259158975-28499-20-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-1-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-2-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-3-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-4-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-5-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-6-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases we already have the rindex lock when
we enter this function.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/rgrp.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 8f1cfb0..0608f49 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1710,11 +1710,16 @@ int gfs2_check_blk_type(struct gfs2_sbd *sdp, u64 no_addr, unsigned int type)
 {
 	struct gfs2_rgrpd *rgd;
 	struct gfs2_holder ri_gh, rgd_gh;
+	struct gfs2_inode *ip = GFS2_I(sdp->sd_rindex);
+	int ri_locked = 0;
 	int error;
 
-	error = gfs2_rindex_hold(sdp, &ri_gh);
-	if (error)
-		goto fail;
+	if (!gfs2_glock_is_locked_by_me(ip->i_gl)) {
+		error = gfs2_rindex_hold(sdp, &ri_gh);
+		if (error)
+			goto fail;
+		ri_locked = 1;
+	}
 
 	error = -EINVAL;
 	rgd = gfs2_blk2rgrpd(sdp, no_addr);
@@ -1730,7 +1735,8 @@ int gfs2_check_blk_type(struct gfs2_sbd *sdp, u64 no_addr, unsigned int type)
 
 	gfs2_glock_dq_uninit(&rgd_gh);
 fail_rindex:
-	gfs2_glock_dq_uninit(&ri_gh);
+	if (ri_locked)
+		gfs2_glock_dq_uninit(&ri_gh);
 fail:
 	return error;
 }
-- 
1.6.2.5

