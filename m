Return-Path: <linux-kernel-owner+w=401wt.eu-S934313AbYDQJmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934313AbYDQJmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933353AbYDQJ0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933685AbYDQJ0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:06 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 18/48] [GFS2] Remove rgrp and glock version numbers
Date: Thu, 17 Apr 2008 09:38:54 +0100
Message-Id: <12084216061172-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216044123-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
 <12084215802470-git-send-email-swhiteho@redhat.com>
 <12084215833555-git-send-email-swhiteho@redhat.com>
 <12084215851158-git-send-email-swhiteho@redhat.com>
 <120842158797-git-send-email-swhiteho@redhat.com>
 <12084215891940-git-send-email-swhiteho@redhat.com>
 <12084215913125-git-send-email-swhiteho@redhat.com>
 <12084215931509-git-send-email-swhiteho@redhat.com>
 <12084215961690-git-send-email-swhiteho@redhat.com>
 <1208421597980-git-send-email-swhiteho@redhat.com>
 <12084216003676-git-send-email-swhiteho@redhat.com>
 <12084216023999-git-send-email-swhiteho@redhat.com>
 <12084216044123-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch further reduces GFS2's memory requirements by
eliminating the 64-bit version number fields in lieu of
a couple bits.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 611f84d..d00dc37 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2004-2008 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -348,7 +348,6 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	gl->gl_ip = 0;
 	gl->gl_ops = glops;
 	gl->gl_req_gh = NULL;
-	gl->gl_vn = 0;
 	gl->gl_stamp = jiffies;
 	gl->gl_tchange = jiffies;
 	gl->gl_object = NULL;
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index c663b7a..d31bada 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2004-2008 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -126,7 +126,13 @@ static void meta_go_inval(struct gfs2_glock *gl, int flags)
 		return;
 
 	gfs2_meta_inval(gl);
-	gl->gl_vn++;
+	if (gl->gl_object == GFS2_I(gl->gl_sbd->sd_rindex))
+		gl->gl_sbd->sd_rindex_uptodate = 0;
+	else if (gl->gl_ops == &gfs2_rgrp_glops && gl->gl_object) {
+		struct gfs2_rgrpd *rgd = (struct gfs2_rgrpd *)gl->gl_object;
+
+		rgd->rd_flags &= ~GFS2_RDF_UPTODATE;
+	}
 }
 
 /**
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 8dee467..e9c58dc 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -85,7 +85,6 @@ struct gfs2_rgrpd {
 	u32 rd_data;			/* num of data blocks in rgrp */
 	u32 rd_bitbytes;		/* number of bytes in data bitmaps */
 	struct gfs2_rgrp_host rd_rg;
-	u64 rd_rg_vn;
 	struct gfs2_bitmap *rd_bits;
 	unsigned int rd_bh_count;
 	struct mutex rd_mutex;
@@ -97,6 +96,7 @@ struct gfs2_rgrpd {
 	unsigned char rd_flags;
 #define GFS2_RDF_CHECK        0x01      /* Need to check for unlinked inodes */
 #define GFS2_RDF_NOALLOC      0x02      /* rg prohibits allocation */
+#define GFS2_RDF_UPTODATE     0x04      /* rg is up to date */
 };
 
 enum gfs2_state_bits {
@@ -196,7 +196,6 @@ struct gfs2_glock {
 	char *gl_lvb;
 	atomic_t gl_lvb_count;
 
-	u64 gl_vn;
 	unsigned long gl_stamp;
 	unsigned long gl_tchange;
 	void *gl_object;
@@ -533,7 +532,7 @@ struct gfs2_sbd {
 
 	/* Resource group stuff */
 
-	u64 sd_rindex_vn;
+	int sd_rindex_uptodate;
 	spinlock_t sd_rindex_spin;
 	struct mutex sd_rindex_mutex;
 	struct list_head sd_rindex_list;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 5b6a345..c4b7a21 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2004-2008 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -548,7 +548,7 @@ static int init_inodes(struct gfs2_sbd *sdp, int undo)
 	}
 	ip = GFS2_I(sdp->sd_rindex);
 	set_bit(GLF_STICKY, &ip->i_gl->gl_flags);
-	sdp->sd_rindex_vn = ip->i_gl->gl_vn - 1;
+	sdp->sd_rindex_uptodate = 0;
 
 	/* Read in the quota inode */
 	sdp->sd_quota_inode = gfs2_lookup_simple(sdp->sd_master_dir, "quota");
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 5fd8710..3f10b1f 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -540,7 +540,7 @@ static int read_rindex_entry(struct gfs2_inode *ip,
 		return error;
 
 	rgd->rd_gl->gl_object = rgd;
-	rgd->rd_rg_vn = rgd->rd_gl->gl_vn - 1;
+	rgd->rd_flags &= ~GFS2_RDF_UPTODATE;
 	rgd->rd_flags |= GFS2_RDF_CHECK;
 	return error;
 }
@@ -576,7 +576,7 @@ static int gfs2_ri_update(struct gfs2_inode *ip)
 		}
 	}
 
-	sdp->sd_rindex_vn = ip->i_gl->gl_vn;
+	sdp->sd_rindex_uptodate = 1;
 	return 0;
 }
 
@@ -610,7 +610,7 @@ static int gfs2_ri_update_special(struct gfs2_inode *ip)
 		}
 	}
 
-	sdp->sd_rindex_vn = ip->i_gl->gl_vn;
+	sdp->sd_rindex_uptodate = 1;
 	return 0;
 }
 
@@ -643,9 +643,9 @@ int gfs2_rindex_hold(struct gfs2_sbd *sdp, struct gfs2_holder *ri_gh)
 		return error;
 
 	/* Read new copy from disk if we don't have the latest */
-	if (sdp->sd_rindex_vn != gl->gl_vn) {
+	if (!sdp->sd_rindex_uptodate) {
 		mutex_lock(&sdp->sd_rindex_mutex);
-		if (sdp->sd_rindex_vn != gl->gl_vn) {
+		if (!sdp->sd_rindex_uptodate) {
 			error = gfs2_ri_update(ip);
 			if (error)
 				gfs2_glock_dq_uninit(ri_gh);
@@ -737,9 +737,9 @@ int gfs2_rgrp_bh_get(struct gfs2_rgrpd *rgd)
 		}
 	}
 
-	if (rgd->rd_rg_vn != gl->gl_vn) {
+	if (!(rgd->rd_flags & GFS2_RDF_UPTODATE)) {
 		gfs2_rgrp_in(rgd, (rgd->rd_bits[0].bi_bh)->b_data);
-		rgd->rd_rg_vn = gl->gl_vn;
+		rgd->rd_flags |= GFS2_RDF_UPTODATE;
 	}
 
 	spin_lock(&sdp->sd_rindex_spin);
-- 
1.5.1.2

