Return-Path: <linux-kernel-owner+w=401wt.eu-S1751459AbZG3Mqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbZG3Mqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 08:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZG3Mqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 08:46:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46422 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbZG3Mqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 08:46:43 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/7] GFS2: Shrink the shrinker
Date: Thu, 30 Jul 2009 14:45:18 +0100
Message-Id: <1248961524-30913-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1248961524-30913-1-git-send-email-swhiteho@redhat.com>
References: <1248961524-30913-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some of the special cases that the shrinker
was trying to deal with. As a result we leave fewer items on
the list and none at all which cannot be demoted. This makes
the list scanning more efficient and solves some issues seen
with large numbers of inodes.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/glock.c |   23 +++++------------------
 1 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 297421c..fdb796c 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1300,7 +1300,6 @@ static int gfs2_shrink_glock_memory(int nr, gfp_t gfp_mask)
 	struct gfs2_glock *gl;
 	int may_demote;
 	int nr_skipped = 0;
-	int got_ref = 0;
 	LIST_HEAD(skipped);
 
 	if (nr == 0)
@@ -1318,7 +1317,6 @@ static int gfs2_shrink_glock_memory(int nr, gfp_t gfp_mask)
 		/* Test for being demotable */
 		if (!test_and_set_bit(GLF_LOCK, &gl->gl_flags)) {
 			gfs2_glock_hold(gl);
-			got_ref = 1;
 			spin_unlock(&lru_lock);
 			spin_lock(&gl->gl_spin);
 			may_demote = demote_ok(gl);
@@ -1327,25 +1325,14 @@ static int gfs2_shrink_glock_memory(int nr, gfp_t gfp_mask)
 			if (may_demote) {
 				handle_callback(gl, LM_ST_UNLOCKED, 0);
 				nr--;
-				if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
-					gfs2_glock_put(gl);
-				got_ref = 0;
 			}
+			if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
+				gfs2_glock_put(gl);
 			spin_lock(&lru_lock);
-			if (may_demote)
-				continue;
-		}
-		if (list_empty(&gl->gl_lru) &&
-		    (atomic_read(&gl->gl_ref) <= (2 + got_ref))) {
-			nr_skipped++;
-			list_add(&gl->gl_lru, &skipped);
-		}
-		if (got_ref) {
-			spin_unlock(&lru_lock);
-			gfs2_glock_put(gl);
-			spin_lock(&lru_lock);
-			got_ref = 0;
+			continue;
 		}
+		nr_skipped++;
+		list_add(&gl->gl_lru, &skipped);
 	}
 	list_splice(&skipped, &lru_list);
 	atomic_add(nr_skipped, &lru_count);
-- 
1.6.2.2

