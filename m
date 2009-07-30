Return-Path: <linux-kernel-owner+w=401wt.eu-S1751767AbZG3Mr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbZG3Mr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 08:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbZG3MrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 08:47:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46426 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbZG3Mqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 08:46:48 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 5/7] GFS2: Don't put unlikely reclaim candidates on the reclaim list.
Date: Thu, 30 Jul 2009 14:45:22 +0100
Message-Id: <1248961524-30913-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1248961524-30913-5-git-send-email-swhiteho@redhat.com>
References: <1248961524-30913-1-git-send-email-swhiteho@redhat.com>
 <1248961524-30913-2-git-send-email-swhiteho@redhat.com>
 <1248961524-30913-3-git-send-email-swhiteho@redhat.com>
 <1248961524-30913-4-git-send-email-swhiteho@redhat.com>
 <1248961524-30913-5-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

GFS2 was placing far too many glocks on the reclaim list that were not good
candidates for freeing up from cache.  These locks would sit there and
repeatedly get scanned to see if they could be reclaimed, wasting a lot
of time when there was memory pressure. This fix does more checks on the
locks to see if they are actually likely to be removable from cache.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/glock.c |   72 +++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 46 insertions(+), 26 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 827136e..f041a89 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -174,6 +174,26 @@ static void gfs2_glock_hold(struct gfs2_glock *gl)
 }
 
 /**
+ * demote_ok - Check to see if it's ok to unlock a glock
+ * @gl: the glock
+ *
+ * Returns: 1 if it's ok
+ */
+
+static int demote_ok(const struct gfs2_glock *gl)
+{
+	const struct gfs2_glock_operations *glops = gl->gl_ops;
+
+	if (gl->gl_state == LM_ST_UNLOCKED)
+		return 0;
+	if (!list_empty(&gl->gl_holders))
+		return 0;
+	if (glops->go_demote_ok)
+		return glops->go_demote_ok(gl);
+	return 1;
+}
+
+/**
  * gfs2_glock_schedule_for_reclaim - Add a glock to the reclaim list
  * @gl: the glock
  *
@@ -181,8 +201,13 @@ static void gfs2_glock_hold(struct gfs2_glock *gl)
 
 static void gfs2_glock_schedule_for_reclaim(struct gfs2_glock *gl)
 {
+	int may_reclaim;
+	may_reclaim = (demote_ok(gl) &&
+		       (atomic_read(&gl->gl_ref) == 1 ||
+			(gl->gl_name.ln_type == LM_TYPE_INODE &&
+			 atomic_read(&gl->gl_ref) <= 2)));
 	spin_lock(&lru_lock);
-	if (list_empty(&gl->gl_lru) && gl->gl_state != LM_ST_UNLOCKED) {
+	if (list_empty(&gl->gl_lru) && may_reclaim) {
 		list_add_tail(&gl->gl_lru, &lru_list);
 		atomic_inc(&lru_count);
 	}
@@ -190,6 +215,21 @@ static void gfs2_glock_schedule_for_reclaim(struct gfs2_glock *gl)
 }
 
 /**
+ * gfs2_glock_put_nolock() - Decrement reference count on glock
+ * @gl: The glock to put
+ *
+ * This function should only be used if the caller has its own reference
+ * to the glock, in addition to the one it is dropping.
+ */
+
+static void gfs2_glock_put_nolock(struct gfs2_glock *gl)
+{
+	if (atomic_dec_and_test(&gl->gl_ref))
+		GLOCK_BUG_ON(gl, 1);
+	gfs2_glock_schedule_for_reclaim(gl);
+}
+
+/**
  * gfs2_glock_put() - Decrement reference count on glock
  * @gl: The glock to put
  *
@@ -214,9 +254,9 @@ int gfs2_glock_put(struct gfs2_glock *gl)
 		rv = 1;
 		goto out;
 	}
-	/* 1 for being hashed, 1 for having state != LM_ST_UNLOCKED */
-	if (atomic_read(&gl->gl_ref) == 2)
-		gfs2_glock_schedule_for_reclaim(gl);
+	spin_lock(&gl->gl_spin);
+	gfs2_glock_schedule_for_reclaim(gl);
+	spin_unlock(&gl->gl_spin);
 	write_unlock(gl_lock_addr(gl->gl_hash));
 out:
 	return rv;
@@ -398,7 +438,7 @@ static void state_change(struct gfs2_glock *gl, unsigned int new_state)
 		if (held2)
 			gfs2_glock_hold(gl);
 		else
-			gfs2_glock_put(gl);
+			gfs2_glock_put_nolock(gl);
 	}
 
 	gl->gl_state = new_state;
@@ -633,7 +673,7 @@ out:
 out_sched:
 	gfs2_glock_hold(gl);
 	if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
-		gfs2_glock_put(gl);
+		gfs2_glock_put_nolock(gl);
 out_unlock:
 	clear_bit(GLF_LOCK, &gl->gl_flags);
 	goto out;
@@ -1274,26 +1314,6 @@ void gfs2_glock_complete(struct gfs2_glock *gl, int ret)
 		gfs2_glock_put(gl);
 }
 
-/**
- * demote_ok - Check to see if it's ok to unlock a glock
- * @gl: the glock
- *
- * Returns: 1 if it's ok
- */
-
-static int demote_ok(const struct gfs2_glock *gl)
-{
-	const struct gfs2_glock_operations *glops = gl->gl_ops;
-
-	if (gl->gl_state == LM_ST_UNLOCKED)
-		return 0;
-	if (!list_empty(&gl->gl_holders))
-		return 0;
-	if (glops->go_demote_ok)
-		return glops->go_demote_ok(gl);
-	return 1;
-}
-
 
 static int gfs2_shrink_glock_memory(int nr, gfp_t gfp_mask)
 {
-- 
1.6.2.2

