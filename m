Return-Path: <linux-kernel-owner+w=401wt.eu-S932938AbXBEO3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbXBEO3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932874AbXBEO3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:29:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932938AbXBEO3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:29:12 -0500
Subject: [GFS2] Remove queue_empty() function [36/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:37:15 +0000
Message-Id: <1170686235.11001.343.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5eaeb9b4dc1299eba6065ab2e5c9e5b23e55a9f3 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Mon, 22 Jan 2007 13:09:04 -0500
Subject: [PATCH] [GFS2] Remove queue_empty() function

This function is not longer required since we do not do recursive
locking in the glock layer. As a result all its callers can be
replaceed with list_empty() calls.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 5b772bb..1509481 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -211,30 +211,6 @@ out:
 }
 
 /**
- * queue_empty - check to see if a glock's queue is empty
- * @gl: the glock
- * @head: the head of the queue to check
- *
- * This function protects the list in the event that a process already
- * has a holder on the list and is adding a second holder for itself.
- * The glmutex lock is what generally prevents processes from working
- * on the same glock at once, but the special case of adding a second
- * holder for yourself ("recursive" locking) doesn't involve locking
- * glmutex, making the spin lock necessary.
- *
- * Returns: 1 if the queue is empty
- */
-
-static inline int queue_empty(struct gfs2_glock *gl, struct list_head *head)
-{
-	int empty;
-	spin_lock(&gl->gl_spin);
-	empty = list_empty(head);
-	spin_unlock(&gl->gl_spin);
-	return empty;
-}
-
-/**
  * search_bucket() - Find struct gfs2_glock by lock number
  * @bucket: the bucket to search
  * @name: The lock name
@@ -814,7 +790,7 @@ static void xmote_bh(struct gfs2_glock *gl, unsigned int ret)
 	int op_done = 1;
 
 	gfs2_assert_warn(sdp, test_bit(GLF_LOCK, &gl->gl_flags));
-	gfs2_assert_warn(sdp, queue_empty(gl, &gl->gl_holders));
+	gfs2_assert_warn(sdp, list_empty(&gl->gl_holders));
 	gfs2_assert_warn(sdp, !(ret & LM_OUT_ASYNC));
 
 	state_change(gl, ret & LM_OUT_ST_MASK);
@@ -925,7 +901,7 @@ void gfs2_glock_xmote_th(struct gfs2_holder *gh)
 		glops->go_xmote_th(gl);
 
 	gfs2_assert_warn(sdp, test_bit(GLF_LOCK, &gl->gl_flags));
-	gfs2_assert_warn(sdp, queue_empty(gl, &gl->gl_holders));
+	gfs2_assert_warn(sdp, list_empty(&gl->gl_holders));
 	gfs2_assert_warn(sdp, state != LM_ST_UNLOCKED);
 	gfs2_assert_warn(sdp, state != gl->gl_state);
 
@@ -960,7 +936,7 @@ static void drop_bh(struct gfs2_glock *gl, unsigned int ret)
 	struct gfs2_holder *gh = gl->gl_req_gh;
 
 	gfs2_assert_warn(sdp, test_bit(GLF_LOCK, &gl->gl_flags));
-	gfs2_assert_warn(sdp, queue_empty(gl, &gl->gl_holders));
+	gfs2_assert_warn(sdp, list_empty(&gl->gl_holders));
 	gfs2_assert_warn(sdp, !ret);
 
 	state_change(gl, LM_ST_UNLOCKED);
@@ -1007,7 +983,7 @@ static void gfs2_glock_drop_th(struct gfs2_glock *gl)
 		glops->go_drop_th(gl);
 
 	gfs2_assert_warn(sdp, test_bit(GLF_LOCK, &gl->gl_flags));
-	gfs2_assert_warn(sdp, queue_empty(gl, &gl->gl_holders));
+	gfs2_assert_warn(sdp, list_empty(&gl->gl_holders));
 	gfs2_assert_warn(sdp, gl->gl_state != LM_ST_UNLOCKED);
 
 	gfs2_glock_hold(gl);
@@ -1697,7 +1673,7 @@ void gfs2_reclaim_glock(struct gfs2_sbd *sdp)
 	atomic_inc(&sdp->sd_reclaimed);
 
 	if (gfs2_glmutex_trylock(gl)) {
-		if (queue_empty(gl, &gl->gl_holders) &&
+		if (list_empty(&gl->gl_holders) &&
 		    gl->gl_state != LM_ST_UNLOCKED && demote_ok(gl))
 			handle_callback(gl, LM_ST_UNLOCKED);
 		gfs2_glmutex_unlock(gl);
@@ -1761,7 +1737,7 @@ static void scan_glock(struct gfs2_glock *gl)
 		return;
 
 	if (gfs2_glmutex_trylock(gl)) {
-		if (queue_empty(gl, &gl->gl_holders) &&
+		if (list_empty(&gl->gl_holders) &&
 		    gl->gl_state != LM_ST_UNLOCKED && demote_ok(gl))
 			goto out_schedule;
 		gfs2_glmutex_unlock(gl);
@@ -1810,7 +1786,7 @@ static void clear_glock(struct gfs2_glock *gl)
 	}
 
 	if (gfs2_glmutex_trylock(gl)) {
-		if (queue_empty(gl, &gl->gl_holders) &&
+		if (list_empty(gl, &gl->gl_holders) &&
 		    gl->gl_state != LM_ST_UNLOCKED)
 			handle_callback(gl, LM_ST_UNLOCKED);
 		gfs2_glmutex_unlock(gl);
-- 
1.4.4.2



