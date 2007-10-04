Return-Path: <linux-kernel-owner+w=401wt.eu-S1759483AbXJDJRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483AbXJDJRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756584AbXJDJRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:17:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756070AbXJDJRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:17:15 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 01/51] [GFS2] Fix two races relating to glock callbacks
Date: Thu,  4 Oct 2007 09:48:54 +0100
Message-Id: <11914877912880-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914877842142-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

One of the races relates to referencing a variable while not holding
its protecting spinlock. The patch simply moves the test inside the
spin lock. The other races occurs when a demote to unlocked request
occurs during the time a demote to shared request is already running.
This of course only happens in the case that the lock was in the
exclusive mode to start with. The patch adds a check to see if another
demote request has occurred in the mean time and if it has, then it
performs a second demote.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 3f0974e..6a3eeba 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -545,12 +545,14 @@ static int rq_demote(struct gfs2_glock *gl)
 		return 0;
 	}
 	set_bit(GLF_LOCK, &gl->gl_flags);
-	spin_unlock(&gl->gl_spin);
 	if (gl->gl_demote_state == LM_ST_UNLOCKED ||
-	    gl->gl_state != LM_ST_EXCLUSIVE)
+	    gl->gl_state != LM_ST_EXCLUSIVE) {
+		spin_unlock(&gl->gl_spin);
 		gfs2_glock_drop_th(gl);
-	else
+	} else {
+		spin_unlock(&gl->gl_spin);
 		gfs2_glock_xmote_th(gl, NULL);
+	}
 	spin_lock(&gl->gl_spin);
 
 	return 0;
@@ -760,10 +762,20 @@ static void xmote_bh(struct gfs2_glock *gl, unsigned int ret)
 
 	if (!gh) {
 		gl->gl_stamp = jiffies;
-		if (ret & LM_OUT_CANCELED)
+		if (ret & LM_OUT_CANCELED) {
 			op_done = 0;
-		else
+		} else {
+			spin_lock(&gl->gl_spin);
+			if (gl->gl_state != gl->gl_demote_state) {
+				gl->gl_req_bh = NULL;
+				spin_unlock(&gl->gl_spin);
+				gfs2_glock_drop_th(gl);
+				gfs2_glock_put(gl);
+				return;
+			}
 			gfs2_demote_wake(gl);
+			spin_unlock(&gl->gl_spin);
+		}
 	} else {
 		spin_lock(&gl->gl_spin);
 		list_del_init(&gh->gh_list);
@@ -817,7 +829,7 @@ out:
  *
  */
 
-void gfs2_glock_xmote_th(struct gfs2_glock *gl, struct gfs2_holder *gh)
+static void gfs2_glock_xmote_th(struct gfs2_glock *gl, struct gfs2_holder *gh)
 {
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	int flags = gh ? gh->gh_flags : 0;
-- 
1.5.1.2

