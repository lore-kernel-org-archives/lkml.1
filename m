Return-Path: <linux-kernel-owner+w=401wt.eu-S1763987AbYAUKPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763987AbYAUKPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759992AbYAUKCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759953AbYAUKCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:51 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 36/58] [GFS2] Journal extent mapping
Date: Mon, 21 Jan 2008 09:21:54 +0000
Message-Id: <12009074032614-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009074021586-git-send-email-swhiteho@redhat.com>
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
 <12009073953412-git-send-email-swhiteho@redhat.com>
 <1200907397123-git-send-email-swhiteho@redhat.com>
 <12009073981159-git-send-email-swhiteho@redhat.com>
 <12009074002775-git-send-email-swhiteho@redhat.com>
 <12009074021586-git-send-email-swhiteho@redhat.com>
Message-Id: <fb8217df7708e3f6d72442476d2b25178db21a66.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch saves a little time when gfs2 writes to the journals by
keeping a mapping between logical and physical blocks on disk.
That's better than constantly looking up indirect pointers in
buffers, when the journals are several levels of indirection
(which they typically are).

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 743ebba..14862d1 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -360,8 +360,17 @@ struct gfs2_ail {
 	u64 ai_sync_gen;
 };
 
+struct gfs2_journal_extent {
+	struct list_head extent_list;
+
+	unsigned int lblock; /* First logical block */
+	u64 dblock; /* First disk block */
+	u64 blocks;
+};
+
 struct gfs2_jdesc {
 	struct list_head jd_list;
+	struct list_head extent_list;
 
 	struct inode *jd_inode;
 	unsigned int jd_jid;
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 9bece94..0833e27 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -332,18 +332,14 @@ retry:
 
 static u64 log_bmap(struct gfs2_sbd *sdp, unsigned int lbn)
 {
-	struct inode *inode = sdp->sd_jdesc->jd_inode;
-	int error;
-	struct buffer_head bh_map = { .b_state = 0, .b_blocknr = 0 };
-
-	bh_map.b_size = 1 << inode->i_blkbits;
-	error = gfs2_block_map(inode, lbn, &bh_map, 0);
-	if (error || !bh_map.b_blocknr)
-		printk(KERN_INFO "error=%d, dbn=%llu lbn=%u", error,
-		       (unsigned long long)bh_map.b_blocknr, lbn);
-	gfs2_assert_withdraw(sdp, !error && bh_map.b_blocknr);
-
-	return bh_map.b_blocknr;
+	struct gfs2_journal_extent *je;
+
+	list_for_each_entry(je, &sdp->sd_jdesc->extent_list, extent_list) {
+		if (lbn >= je->lblock && lbn < je->lblock + je->blocks)
+			return je->dblock + lbn;
+	}
+
+	return -1;
 }
 
 /**
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 6f5fa5e..35ec630 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -21,6 +21,7 @@
 
 #include "gfs2.h"
 #include "incore.h"
+#include "bmap.h"
 #include "daemon.h"
 #include "glock.h"
 #include "glops.h"
@@ -303,6 +304,68 @@ out:
 	return error;
 }
 
+/**
+ * map_journal_extents - create a reusable "extent" mapping from all logical
+ * blocks to all physical blocks for the given journal.  This will save
+ * us time when writing journal blocks.  Most journals will have only one
+ * extent that maps all their logical blocks.  That's because gfs2.mkfs
+ * arranges the journal blocks sequentially to maximize performance.
+ * So the extent would map the first block for the entire file length.
+ * However, gfs2_jadd can happen while file activity is happening, so
+ * those journals may not be sequential.  Less likely is the case where
+ * the users created their own journals by mounting the metafs and
+ * laying it out.  But it's still possible.  These journals might have
+ * several extents.
+ *
+ * TODO: This should be done in bigger chunks rather than one block at a time,
+ *       but since it's only done at mount time, I'm not worried about the
+ *       time it takes.
+ */
+static int map_journal_extents(struct gfs2_sbd *sdp)
+{
+	struct gfs2_jdesc *jd = sdp->sd_jdesc;
+	unsigned int lb;
+	u64 db, prev_db; /* logical block, disk block, prev disk block */
+	struct gfs2_inode *ip = GFS2_I(jd->jd_inode);
+	struct gfs2_journal_extent *jext = NULL;
+	struct buffer_head bh;
+	int rc = 0;
+
+	INIT_LIST_HEAD(&jd->extent_list);
+	prev_db = 0;
+
+	for (lb = 0; lb < ip->i_di.di_size / sdp->sd_sb.sb_bsize; lb++) {
+		bh.b_state = 0;
+		bh.b_blocknr = 0;
+		bh.b_size = 1 << ip->i_inode.i_blkbits;
+		rc = gfs2_block_map(jd->jd_inode, lb, &bh, 0);
+		db = bh.b_blocknr;
+		if (rc || !db) {
+			printk(KERN_INFO "GFS2 journal mapping error %d: lb="
+			       "%u db=%llu\n", rc, lb, (unsigned long long)db);
+			break;
+		}
+		if (!prev_db || db != prev_db + 1) {
+			jext = kzalloc(sizeof(struct gfs2_journal_extent),
+				       GFP_KERNEL);
+			if (!jext) {
+				printk(KERN_INFO "GFS2 error: out of memory "
+				       "mapping journal extents.\n");
+				rc = -ENOMEM;
+				break;
+			}
+			jext->dblock = db;
+			jext->lblock = lb;
+			jext->blocks = 1;
+			list_add_tail(&jext->extent_list, &jd->extent_list);
+		} else {
+			jext->blocks++;
+		}
+		prev_db = db;
+	}
+	return rc;
+}
+
 static int init_journal(struct gfs2_sbd *sdp, int undo)
 {
 	struct gfs2_holder ji_gh;
@@ -382,6 +445,9 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 		atomic_set(&sdp->sd_log_blks_free, sdp->sd_jdesc->jd_blocks);
 		atomic_set(&sdp->sd_log_thresh1, 2*sdp->sd_jdesc->jd_blocks/5);
 		atomic_set(&sdp->sd_log_thresh2, 4*sdp->sd_jdesc->jd_blocks/5);
+
+		/* Map the extents for this journal's blocks */
+		map_journal_extents(sdp);
 	}
 
 	if (sdp->sd_lockstruct.ls_first) {
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 850df2b..dda7747 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -414,8 +414,9 @@ int gfs2_jindex_hold(struct gfs2_sbd *sdp, struct gfs2_holder *ji_gh)
 
 void gfs2_jindex_free(struct gfs2_sbd *sdp)
 {
-	struct list_head list;
+	struct list_head list, *head;
 	struct gfs2_jdesc *jd;
+	struct gfs2_journal_extent *jext;
 
 	spin_lock(&sdp->sd_jindex_spin);
 	list_add(&list, &sdp->sd_jindex_list);
@@ -425,6 +426,14 @@ void gfs2_jindex_free(struct gfs2_sbd *sdp)
 
 	while (!list_empty(&list)) {
 		jd = list_entry(list.next, struct gfs2_jdesc, jd_list);
+		head = &jd->extent_list;
+		while (!list_empty(head)) {
+			jext = list_entry(head->next,
+					  struct gfs2_journal_extent,
+					  extent_list);
+			list_del(&jext->extent_list);
+			kfree(jext);
+		}
 		list_del(&jd->jd_list);
 		iput(jd->jd_inode);
 		kfree(jd);
-- 
1.5.1.2

