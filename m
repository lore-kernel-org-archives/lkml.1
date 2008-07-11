Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbYGKLGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbYGKLGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756667AbYGKLBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:01:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607AbYGKLBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:01:54 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
       Bob Peterson <rpeterso@redhat.com>
Subject: [PATCH 14/18] [GFS2] Fix delayed demote race
Date: Fri, 11 Jul 2008 11:11:15 +0100
Message-Id: <12157711133727-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12157711093284-git-send-email-swhiteho@redhat.com>
References: <121577107950-git-send-email-swhiteho@redhat.com>
 <12157710872782-git-send-email-swhiteho@redhat.com>
 <1215771089769-git-send-email-swhiteho@redhat.com>
 <1215771091790-git-send-email-swhiteho@redhat.com>
 <12157710931623-git-send-email-swhiteho@redhat.com>
 <12157710954145-git-send-email-swhiteho@redhat.com>
 <12157710973601-git-send-email-swhiteho@redhat.com>
 <12157710983282-git-send-email-swhiteho@redhat.com>
 <12157711013356-git-send-email-swhiteho@redhat.com>
 <12157711023743-git-send-email-swhiteho@redhat.com>
 <12157711041157-git-send-email-swhiteho@redhat.com>
 <1215771106247-git-send-email-swhiteho@redhat.com>
 <12157711073280-git-send-email-swhiteho@redhat.com>
 <12157711093284-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

There is a race in the delayed demote code where it does the wrong thing
if a demotion to UN has occurred for other reasons before the delay has
expired. This patch adds an assert to catch that condition as well as
fixing the root cause by adding an additional check for the UN state.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 8d5450f..cd0aa21 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -587,6 +587,7 @@ static void run_queue(struct gfs2_glock *gl, const int nonblock)
 		if (nonblock)
 			goto out_sched;
 		set_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags);
+		GLOCK_BUG_ON(gl, gl->gl_demote_state == LM_ST_EXCLUSIVE);
 		gl->gl_target = gl->gl_demote_state;
 	} else {
 		if (test_bit(GLF_DEMOTE, &gl->gl_flags))
@@ -617,7 +618,9 @@ static void glock_work_func(struct work_struct *work)
 	if (test_and_clear_bit(GLF_REPLY_PENDING, &gl->gl_flags))
 		finish_xmote(gl, gl->gl_reply);
 	spin_lock(&gl->gl_spin);
-	if (test_and_clear_bit(GLF_PENDING_DEMOTE, &gl->gl_flags)) {
+	if (test_and_clear_bit(GLF_PENDING_DEMOTE, &gl->gl_flags) &&
+	    gl->gl_state != LM_ST_UNLOCKED &&
+	    gl->gl_demote_state != LM_ST_EXCLUSIVE) {
 		unsigned long holdtime, now = jiffies;
 		holdtime = gl->gl_tchange + gl->gl_ops->go_min_hold_time;
 		if (time_before(now, holdtime))
-- 
1.5.1.2

