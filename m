Return-Path: <linux-kernel-owner+w=401wt.eu-S934535AbYDQJgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934535AbYDQJgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933350AbYDQJZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:25:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765034AbYDQJZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:25:23 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/48] [GFS2] Only do lo_incore_commit once
Date: Thu, 17 Apr 2008 09:38:41 +0100
Message-Id: <12084215781246-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084215763647-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch is performance related.  When we're doing a log flush,
I noticed we were calling buf_lo_incore_commit twice: once for
data bufs and once for metadata bufs.  Since this is the same
function and does the same thing in both cases, there should be
no reason to call it twice.  Since we only need to call it once,
we can also make it faster by removing it from the generic "lops"
code and making it a stand-along static function.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 43472ba..7ae12d2 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -44,7 +44,6 @@ struct gfs2_log_header_host {
 
 struct gfs2_log_operations {
 	void (*lo_add) (struct gfs2_sbd *sdp, struct gfs2_log_element *le);
-	void (*lo_incore_commit) (struct gfs2_sbd *sdp, struct gfs2_trans *tr);
 	void (*lo_before_commit) (struct gfs2_sbd *sdp);
 	void (*lo_after_commit) (struct gfs2_sbd *sdp, struct gfs2_ail *ai);
 	void (*lo_before_scan) (struct gfs2_jdesc *jd,
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 161ab6f..b335304 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -779,6 +779,21 @@ static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 	gfs2_log_unlock(sdp);
 }
 
+static void buf_lo_incore_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
+{
+	struct list_head *head = &tr->tr_list_buf;
+	struct gfs2_bufdata *bd;
+
+	gfs2_log_lock(sdp);
+	while (!list_empty(head)) {
+		bd = list_entry(head->next, struct gfs2_bufdata, bd_list_tr);
+		list_del_init(&bd->bd_list_tr);
+		tr->tr_num_buf--;
+	}
+	gfs2_log_unlock(sdp);
+	gfs2_assert_warn(sdp, !tr->tr_num_buf);
+}
+
 /**
  * gfs2_log_commit - Commit a transaction to the log
  * @sdp: the filesystem
@@ -790,7 +805,7 @@ static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 void gfs2_log_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 {
 	log_refund(sdp, tr);
-	lops_incore_commit(sdp, tr);
+	buf_lo_incore_commit(sdp, tr);
 
 	sdp->sd_vfs->s_dirt = 1;
 	up_read(&sdp->sd_log_flush_lock);
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index fae59d6..7138737 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -152,21 +152,6 @@ out:
 	unlock_buffer(bd->bd_bh);
 }
 
-static void buf_lo_incore_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
-{
-	struct list_head *head = &tr->tr_list_buf;
-	struct gfs2_bufdata *bd;
-
-	gfs2_log_lock(sdp);
-	while (!list_empty(head)) {
-		bd = list_entry(head->next, struct gfs2_bufdata, bd_list_tr);
-		list_del_init(&bd->bd_list_tr);
-		tr->tr_num_buf--;
-	}
-	gfs2_log_unlock(sdp);
-	gfs2_assert_warn(sdp, !tr->tr_num_buf);
-}
-
 static void buf_lo_before_commit(struct gfs2_sbd *sdp)
 {
 	struct buffer_head *bh;
@@ -737,7 +722,6 @@ static void databuf_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
 
 const struct gfs2_log_operations gfs2_buf_lops = {
 	.lo_add = buf_lo_add,
-	.lo_incore_commit = buf_lo_incore_commit,
 	.lo_before_commit = buf_lo_before_commit,
 	.lo_after_commit = buf_lo_after_commit,
 	.lo_before_scan = buf_lo_before_scan,
@@ -763,7 +747,6 @@ const struct gfs2_log_operations gfs2_rg_lops = {
 
 const struct gfs2_log_operations gfs2_databuf_lops = {
 	.lo_add = databuf_lo_add,
-	.lo_incore_commit = buf_lo_incore_commit,
 	.lo_before_commit = databuf_lo_before_commit,
 	.lo_after_commit = databuf_lo_after_commit,
 	.lo_scan_elements = databuf_lo_scan_elements,
diff --git a/fs/gfs2/lops.h b/fs/gfs2/lops.h
index 41a00df..3c0b273 100644
--- a/fs/gfs2/lops.h
+++ b/fs/gfs2/lops.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2004-2008 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -57,15 +57,6 @@ static inline void lops_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 		le->le_ops->lo_add(sdp, le);
 }
 
-static inline void lops_incore_commit(struct gfs2_sbd *sdp,
-				      struct gfs2_trans *tr)
-{
-	int x;
-	for (x = 0; gfs2_log_ops[x]; x++)
-		if (gfs2_log_ops[x]->lo_incore_commit)
-			gfs2_log_ops[x]->lo_incore_commit(sdp, tr);
-}
-
 static inline void lops_before_commit(struct gfs2_sbd *sdp)
 {
 	int x;
-- 
1.5.1.2

