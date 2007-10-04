Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbXJDJSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbXJDJSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758296AbXJDJRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:17:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757138AbXJDJRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:17:17 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Josef Whiter <jwhiter@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 02/51] [GFS2] Fix calculation of demote state
Date: Thu,  4 Oct 2007 09:48:55 +0100
Message-Id: <11914877934041-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914877912880-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josef Whiter <jwhiter@redhat.com>

If a glock is in the exclusive state and a request for demote to
deferred has been received, then further requests for demote to
shared are being ignored. This patch fixes that by ensuring that
we demote to unlocked in that case.

Signed-off-by: Josef Whiter <jwhiter@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 6a3eeba..6b6ae45 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -697,8 +697,9 @@ static void handle_callback(struct gfs2_glock *gl, unsigned int state, int remot
 			}
 			return;
 		}
-	} else if (gl->gl_demote_state != LM_ST_UNLOCKED) {
-		gl->gl_demote_state = state;
+	} else if (gl->gl_demote_state != LM_ST_UNLOCKED &&
+			gl->gl_demote_state != state) {
+		gl->gl_demote_state = LM_ST_UNLOCKED;
 	}
 	spin_unlock(&gl->gl_spin);
 }
-- 
1.5.1.2

