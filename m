Return-Path: <linux-kernel-owner+w=401wt.eu-S932933AbXBEOeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbXBEOeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932934AbXBEOeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:34:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932933AbXBEOee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:34:34 -0500
Subject: [GFS2] Fix list corruption in lops.c [44/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:42:38 +0000
Message-Id: <1170686558.11001.359.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6cdaba9600410b53607f7f6233956ae2b9d02013 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Thu, 25 Jan 2007 10:04:20 +0000
Subject: [PATCH] [GFS2] Fix list corruption in lops.c

The patch below appears to fix the list corruption that we are seeing on
occasion. Although the transaction structure is private to a single
thread, when the queued structures are dismantled during an in-core
commit, its possible for a different thread to be trying to add the same
structure to another, new, transaction at the same time.

To avoid this, this patch takes the log spinlock during this operation.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 4d7f94d..16bb4b4 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -69,13 +69,16 @@ static void buf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 	struct gfs2_bufdata *bd = container_of(le, struct gfs2_bufdata, bd_le);
 	struct gfs2_trans *tr;
 
-	if (!list_empty(&bd->bd_list_tr))
+	gfs2_log_lock(sdp);
+	if (!list_empty(&bd->bd_list_tr)) {
+		gfs2_log_unlock(sdp);
 		return;
-
+	}
 	tr = current->journal_info;
 	tr->tr_touched = 1;
 	tr->tr_num_buf++;
 	list_add(&bd->bd_list_tr, &tr->tr_list_buf);
+	gfs2_log_unlock(sdp);
 
 	if (!list_empty(&le->le_list))
 		return;
@@ -84,7 +87,6 @@ static void buf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 
 	gfs2_meta_check(sdp, bd->bd_bh);
 	gfs2_pin(sdp, bd->bd_bh);
-
 	gfs2_log_lock(sdp);
 	sdp->sd_log_num_buf++;
 	list_add(&le->le_list, &sdp->sd_log_le_buf);
@@ -98,11 +100,13 @@ static void buf_lo_incore_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 	struct list_head *head = &tr->tr_list_buf;
 	struct gfs2_bufdata *bd;
 
+	gfs2_log_lock(sdp);
 	while (!list_empty(head)) {
 		bd = list_entry(head->next, struct gfs2_bufdata, bd_list_tr);
 		list_del_init(&bd->bd_list_tr);
 		tr->tr_num_buf--;
 	}
+	gfs2_log_unlock(sdp);
 	gfs2_assert_warn(sdp, !tr->tr_num_buf);
 }
 
@@ -462,13 +466,17 @@ static void databuf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 	struct address_space *mapping = bd->bd_bh->b_page->mapping;
 	struct gfs2_inode *ip = GFS2_I(mapping->host);
 
+	gfs2_log_lock(sdp);
 	tr->tr_touched = 1;
 	if (list_empty(&bd->bd_list_tr) &&
 	    (ip->i_di.di_flags & GFS2_DIF_JDATA)) {
 		tr->tr_num_buf++;
 		list_add(&bd->bd_list_tr, &tr->tr_list_buf);
+		gfs2_log_unlock(sdp);
 		gfs2_pin(sdp, bd->bd_bh);
 		tr->tr_num_buf_new++;
+	} else {
+		gfs2_log_unlock(sdp);
 	}
 	gfs2_trans_add_gl(bd->bd_gl);
 	gfs2_log_lock(sdp);
-- 
1.4.4.2



