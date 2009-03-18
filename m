Return-Path: <linux-kernel-owner+w=401wt.eu-S1758711AbZCRNc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711AbZCRNc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 09:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757890AbZCRN20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 09:28:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757884AbZCRN2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 09:28:25 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Benjamin Marzinski <bmarzins@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 17/18] GFS2: Fix locking bug in failed shared to exclusive conversion
Date: Wed, 18 Mar 2009 12:23:52 +0000
Message-Id: <1237379033-28095-18-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1237379033-28095-17-git-send-email-swhiteho@redhat.com>
References: <1237379033-28095-1-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-2-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-3-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-4-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-5-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-6-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-7-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-8-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-9-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-10-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-11-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-12-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-13-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-14-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-15-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-16-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-17-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

After calling out to the dlm, GFS2 sets the new state of a glock to
gl_target in gdlm_ast().  However, gl_target is not always the lock
state that was requested. If a conversion from shared to exclusive
fails, finish_xmote() will call do_xmote() with LM_ST_UNLOCKED, instead
of gl->gl_target, so that it can reacquire the lock in exlusive the next
time around.  In this case, setting the lock to gl_target in gdlm_ast()
will make GFS2 think that it has the glock in exclusive mode, when
really, it doesn't have the glock locked at all.  This patch adds a new
field to the gfs2_glock structure, gl_req, to track the mode that was
requested.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 980a086..399d1b9 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -203,6 +203,7 @@ struct gfs2_glock {
 	unsigned int gl_target;
 	unsigned int gl_reply;
 	unsigned int gl_hash;
+	unsigned int gl_req;
 	unsigned int gl_demote_state; /* state requested by remote node */
 	unsigned long gl_demote_time; /* time of first demote request */
 	struct list_head gl_holders;
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index a0bb7d2..46df988 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -46,11 +46,11 @@ static void gdlm_ast(void *arg)
 		BUG();
 	}
 
-	ret = gl->gl_target;
+	ret = gl->gl_req;
 	if (gl->gl_lksb.sb_flags & DLM_SBF_ALTMODE) {
-		if (gl->gl_target == LM_ST_SHARED)
+		if (gl->gl_req == LM_ST_SHARED)
 			ret = LM_ST_DEFERRED;
-		else if (gl->gl_target == LM_ST_DEFERRED)
+		else if (gl->gl_req == LM_ST_DEFERRED)
 			ret = LM_ST_SHARED;
 		else
 			BUG();
@@ -147,6 +147,7 @@ static unsigned int gdlm_lock(struct gfs2_glock *gl,
 	int req;
 	u32 lkf;
 
+	gl->gl_req = req_state;
 	req = make_mode(req_state);
 	lkf = make_flags(gl->gl_lksb.sb_lkid, flags, req);
 
-- 
1.6.0.3

