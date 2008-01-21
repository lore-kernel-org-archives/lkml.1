Return-Path: <linux-kernel-owner+w=401wt.eu-S1760115AbYAUKDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115AbYAUKDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:03:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759106AbYAUKB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:01:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758955AbYAUKB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:01:56 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Wendy Cheng <wcheng@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 01/58] [GFS2] Handle multiple glock demote requests
Date: Mon, 21 Jan 2008 09:21:19 +0000
Message-Id: <12009073443813-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1200907336293-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
Message-Id: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wendy Cheng <wcheng@redhat.com>

Fix a race condition where multiple glock demote requests are sent to
a node back-to-back. This patch does a check inside handle_callback()
to see whether a demote request is in progress. If true, it sets a flag
to make sure run_queue() will loop again to handle the new request,
instead of erronously setting gl_demote_state to a different state.

Signed-off-by: S. Wendy Cheng <wcheng@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index a37efe4..104e83f 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -567,7 +567,10 @@ static int rq_demote(struct gfs2_glock *gl)
 		gfs2_demote_wake(gl);
 		return 0;
 	}
+
 	set_bit(GLF_LOCK, &gl->gl_flags);
+	set_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags);
+
 	if (gl->gl_demote_state == LM_ST_UNLOCKED ||
 	    gl->gl_state != LM_ST_EXCLUSIVE) {
 		spin_unlock(&gl->gl_spin);
@@ -576,7 +579,9 @@ static int rq_demote(struct gfs2_glock *gl)
 		spin_unlock(&gl->gl_spin);
 		gfs2_glock_xmote_th(gl, NULL);
 	}
+
 	spin_lock(&gl->gl_spin);
+	clear_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags);
 
 	return 0;
 }
@@ -606,6 +611,11 @@ static void run_queue(struct gfs2_glock *gl)
 
 		} else if (test_bit(GLF_DEMOTE, &gl->gl_flags)) {
 			blocked = rq_demote(gl);
+			if (gl->gl_waiters2 && !blocked) {
+				set_bit(GLF_DEMOTE, &gl->gl_flags);
+				gl->gl_demote_state = LM_ST_UNLOCKED;
+			}
+			gl->gl_waiters2 = 0;
 		} else if (!list_empty(&gl->gl_waiters3)) {
 			gh = list_entry(gl->gl_waiters3.next,
 					struct gfs2_holder, gh_list);
@@ -722,7 +732,10 @@ static void handle_callback(struct gfs2_glock *gl, unsigned int state,
 		}
 	} else if (gl->gl_demote_state != LM_ST_UNLOCKED &&
 			gl->gl_demote_state != state) {
-		gl->gl_demote_state = LM_ST_UNLOCKED;
+		if (test_bit(GLF_DEMOTE_IN_PROGRESS,  &gl->gl_flags)) 
+			gl->gl_waiters2 = 1;
+		else 
+			gl->gl_demote_state = LM_ST_UNLOCKED;
 	}
 	spin_unlock(&gl->gl_spin);
 }
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index eaddfb5..662182b 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -171,6 +171,7 @@ enum {
 	GLF_DEMOTE		= 3,
 	GLF_PENDING_DEMOTE	= 4,
 	GLF_DIRTY		= 5,
+	GLF_DEMOTE_IN_PROGRESS	= 6,
 };
 
 struct gfs2_glock {
@@ -190,6 +191,7 @@ struct gfs2_glock {
 	struct list_head gl_holders;
 	struct list_head gl_waiters1;	/* HIF_MUTEX */
 	struct list_head gl_waiters3;	/* HIF_PROMOTE */
+	int gl_waiters2;		/* GIF_DEMOTE */
 
 	const struct gfs2_glock_operations *gl_ops;
 
-- 
1.5.1.2

