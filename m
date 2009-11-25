Return-Path: <linux-kernel-owner+w=401wt.eu-S934741AbZKYNgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934741AbZKYNgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934714AbZKYNgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:36:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934716AbZKYNgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:36:17 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 23/30] GFS2: remove division from new statfs code
Date: Wed, 25 Nov 2009 14:30:55 +0000
Message-Id: <1259159462-28622-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259159462-28622-2-git-send-email-swhiteho@redhat.com>
References: <1259158975-28499-20-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-1-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-2-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

It's not necessary to do any 64bit division for the statfs sync code, so
remove it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/super.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 3fee2fd..b1dcfab 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -472,7 +472,8 @@ void gfs2_statfs_change(struct gfs2_sbd *sdp, s64 total, s64 free,
 	struct gfs2_statfs_change_host *l_sc = &sdp->sd_statfs_local;
 	struct gfs2_statfs_change_host *m_sc = &sdp->sd_statfs_master;
 	struct buffer_head *l_bh;
-	int percent, sync_percent;
+	s64 x, y;
+	int need_sync = 0;
 	int error;
 
 	error = gfs2_meta_inode_buffer(l_ip, &l_bh);
@@ -486,16 +487,16 @@ void gfs2_statfs_change(struct gfs2_sbd *sdp, s64 total, s64 free,
 	l_sc->sc_free += free;
 	l_sc->sc_dinodes += dinodes;
 	gfs2_statfs_change_out(l_sc, l_bh->b_data + sizeof(struct gfs2_dinode));
-	if (m_sc->sc_free)
-		percent = (100 * l_sc->sc_free) / m_sc->sc_free;
-	else
-		percent = 100;
+	if (sdp->sd_args.ar_statfs_percent) {
+		x = 100 * l_sc->sc_free;
+		y = m_sc->sc_free * sdp->sd_args.ar_statfs_percent;
+		if (x >= y || x <= -y)
+			need_sync = 1;
+	}
 	spin_unlock(&sdp->sd_statfs_spin);
 
 	brelse(l_bh);
-	sync_percent = sdp->sd_args.ar_statfs_percent;
-	if (sync_percent && (percent >= sync_percent ||
-			     percent <= -sync_percent))
+	if (need_sync)
 		gfs2_wake_up_statfs(sdp);
 }
 
-- 
1.6.2.5

