Return-Path: <linux-kernel-owner+w=401wt.eu-S1761638AbYAUKII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761638AbYAUKII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759572AbYAUKCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759503AbYAUKCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:16 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 16/58] [GFS2] Remove flags no longer required
Date: Mon, 21 Jan 2008 09:21:34 +0000
Message-Id: <12009073698-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073671755-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
 <12009073542596-git-send-email-swhiteho@redhat.com>
 <1200907356883-git-send-email-swhiteho@redhat.com>
 <12009073571991-git-send-email-swhiteho@redhat.com>
 <12009073591688-git-send-email-swhiteho@redhat.com>
 <12009073611695-git-send-email-swhiteho@redhat.com>
 <1200907362266-git-send-email-swhiteho@redhat.com>
 <12009073642512-git-send-email-swhiteho@redhat.com>
 <12009073662309-git-send-email-swhiteho@redhat.com>
 <12009073671755-git-send-email-swhiteho@redhat.com>
Message-Id: <344c0973a755378c913d9e6a71630ed909aaec2f.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The HIF_MUTEX and HIF_PROMOTE flags were set on the glock holders
depending upon which of the two waiters lists they were going to
be queued upon. They were then tested when the holders were taken
off the lists to ensure that the right type of holder was being
dequeued.

Since we are already using separate lists, there doesn't seem a
lot of point having these flags as well, and since setting them
and testing them is in the fast path for locking and unlocking
glock, this patch removes them.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index e668808..5fbd9d3 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -594,12 +594,7 @@ static void run_queue(struct gfs2_glock *gl)
 		if (!list_empty(&gl->gl_waiters1)) {
 			gh = list_entry(gl->gl_waiters1.next,
 					struct gfs2_holder, gh_list);
-
-			if (test_bit(HIF_MUTEX, &gh->gh_iflags))
-				blocked = rq_mutex(gh);
-			else
-				gfs2_assert_warn(gl->gl_sbd, 0);
-
+			blocked = rq_mutex(gh);
 		} else if (test_bit(GLF_DEMOTE, &gl->gl_flags)) {
 			blocked = rq_demote(gl);
 			if (gl->gl_waiters2 && !blocked) {
@@ -610,12 +605,7 @@ static void run_queue(struct gfs2_glock *gl)
 		} else if (!list_empty(&gl->gl_waiters3)) {
 			gh = list_entry(gl->gl_waiters3.next,
 					struct gfs2_holder, gh_list);
-
-			if (test_bit(HIF_PROMOTE, &gh->gh_iflags))
-				blocked = rq_promote(gh);
-			else
-				gfs2_assert_warn(gl->gl_sbd, 0);
-
+			blocked = rq_promote(gh);
 		} else
 			break;
 
@@ -636,7 +626,6 @@ static void gfs2_glmutex_lock(struct gfs2_glock *gl)
 	struct gfs2_holder gh;
 
 	gfs2_holder_init(gl, 0, 0, &gh);
-	set_bit(HIF_MUTEX, &gh.gh_iflags);
 	if (test_and_set_bit(HIF_WAIT, &gh.gh_iflags))
 		BUG();
 
@@ -1160,8 +1149,6 @@ restart:
 		return -EIO;
 	}
 
-	set_bit(HIF_PROMOTE, &gh->gh_iflags);
-
 	spin_lock(&gl->gl_spin);
 	add_to_queue(gh);
 	run_queue(gl);
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 089dba4..478023e 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -141,10 +141,6 @@ struct gfs2_glock_operations {
 };
 
 enum {
-	/* Actions */
-	HIF_MUTEX		= 0,
-	HIF_PROMOTE		= 1,
-
 	/* States */
 	HIF_HOLDER		= 6,
 	HIF_FIRST		= 7,
-- 
1.5.1.2

