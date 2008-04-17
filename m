Return-Path: <linux-kernel-owner+w=401wt.eu-S1765111AbYDQJr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765111AbYDQJr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933582AbYDQJ03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933552AbYDQJ0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:14 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
       Bob Peterson <rpeterso@redhat.com>
Subject: [PATCH 30/48] [GFS2] Fix bug where we called drop_bh incorrectly
Date: Thu, 17 Apr 2008 09:39:06 +0100
Message-Id: <12084216301107-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216281152-git-send-email-swhiteho@redhat.com>
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
 <12084216061172-git-send-email-swhiteho@redhat.com>
 <12084216082638-git-send-email-swhiteho@redhat.com>
 <12084216101961-git-send-email-swhiteho@redhat.com>
 <12084216121811-git-send-email-swhiteho@redhat.com>
 <12084216153016-git-send-email-swhiteho@redhat.com>
 <1208421617421-git-send-email-swhiteho@redhat.com>
 <12084216182363-git-send-email-swhiteho@redhat.com>
 <12084216204027-git-send-email-swhiteho@redhat.com>
 <12084216222853-git-send-email-swhiteho@redhat.com>
 <12084216241802-git-send-email-swhiteho@redhat.com>
 <12084216262937-git-send-email-swhiteho@redhat.com>
 <12084216281152-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

As a result of an earlier patch, drop_bh was being called in cases
when it shouldn't have been. Since we never have a gh in the drop
case and we always have a gh in the promote case, we can use that
extra information to tell which case has been seen.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index d00dc37..63981e2 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -765,7 +765,6 @@ static void drop_bh(struct gfs2_glock *gl, unsigned int ret)
 {
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
-	struct gfs2_holder *gh = gl->gl_req_gh;
 
 	gfs2_assert_warn(sdp, test_bit(GLF_LOCK, &gl->gl_flags));
 	gfs2_assert_warn(sdp, list_empty(&gl->gl_holders));
@@ -776,23 +775,11 @@ static void drop_bh(struct gfs2_glock *gl, unsigned int ret)
 	if (glops->go_inval)
 		glops->go_inval(gl, DIO_METADATA);
 
-	if (gh) {
-		spin_lock(&gl->gl_spin);
-		list_del_init(&gh->gh_list);
-		gh->gh_error = 0;
-		spin_unlock(&gl->gl_spin);
-	}
-
 	spin_lock(&gl->gl_spin);
 	gfs2_demote_wake(gl);
-	gl->gl_req_gh = NULL;
 	clear_bit(GLF_LOCK, &gl->gl_flags);
 	spin_unlock(&gl->gl_spin);
-
 	gfs2_glock_put(gl);
-
-	if (gh)
-		gfs2_holder_wake(gh);
 }
 
 /**
@@ -810,7 +797,7 @@ static void xmote_bh(struct gfs2_glock *gl, unsigned int ret)
 	int prev_state = gl->gl_state;
 	int op_done = 1;
 
-	if ((ret & LM_OUT_ST_MASK) == LM_ST_UNLOCKED) {
+	if (!gh && (ret & LM_OUT_ST_MASK) == LM_ST_UNLOCKED) {
 		drop_bh(gl, ret);
 		return;
 	}
-- 
1.5.1.2

