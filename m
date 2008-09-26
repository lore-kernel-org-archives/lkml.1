Return-Path: <linux-kernel-owner+w=401wt.eu-S1754455AbYIZMzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbYIZMzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYIZMy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:54:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57603 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbYIZMyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:54:25 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/12] GFS2: Fix race relating to glock min-hold time
Date: Fri, 26 Sep 2008 13:00:48 +0100
Message-Id: <1222430455-4632-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1222430455-4632-5-git-send-email-swhiteho@redhat.com>
References: <1222430455-4632-1-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-2-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-3-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-4-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-5-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case that a request for a glock arrives right after the
grant reply has arrived, it sometimes means that the gl_tstamp
field hasn't been updated recently enough. The net result is that
the min-hold time for the glock is ignored. If this happens
often enough, it leads to poor performance.

This patch adds an additional test, so that if the reply pending
bit is set on a glock, then it will select the maximum length of
time for the min-hold time, rather than looking at gl_tstamp.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 4cbb695..806e1eb 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1265,6 +1265,8 @@ static void blocking_cb(struct gfs2_sbd *sdp, struct lm_lockname *name,
 	holdtime = gl->gl_tchange + gl->gl_ops->go_min_hold_time;
 	if (time_before(now, holdtime))
 		delay = holdtime - now;
+	if (test_bit(GLF_REPLY_PENDING, &gl->gl_flags))
+		delay = gl->gl_ops->go_min_hold_time;
 
 	spin_lock(&gl->gl_spin);
 	handle_callback(gl, state, 1, delay);
-- 
1.5.5.1

