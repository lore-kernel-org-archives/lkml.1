Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab0BDJz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:55:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757499Ab0BDJzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:55:19 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/2] GFS2: Extend umount wait coverage to full glock lifetime
Date: Thu,  4 Feb 2010 09:46:21 +0000
Message-Id: <1265276781-4648-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1265276781-4648-2-git-send-email-swhiteho@redhat.com>
References: <1265276781-4648-1-git-send-email-swhiteho@redhat.com>
 <1265276781-4648-2-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although all glocks are, by the time of the umount glock wait,
scheduled for demotion, some of them haven't made it far
enough through the process for the original set of waiting
code to wait for them.

This extends the ref count to the whole glock lifetime in order
to ensure that the waiting does catch all glocks. It does make
it a bit more invasive, but it seems the only sensible solution
at the moment.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/glock.c      |    4 ++++
 fs/gfs2/glock.h      |    2 +-
 fs/gfs2/lock_dlm.c   |    6 +++---
 fs/gfs2/ops_fstype.c |   10 +++++++++-
 fs/gfs2/super.c      |    2 --
 5 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index f455a03..f426633 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -769,6 +769,7 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	if (!gl)
 		return -ENOMEM;
 
+	atomic_inc(&sdp->sd_glock_disposal);
 	gl->gl_flags = 0;
 	gl->gl_name = name;
 	atomic_set(&gl->gl_ref, 1);
@@ -1538,6 +1539,9 @@ void gfs2_gl_hash_clear(struct gfs2_sbd *sdp)
 		up_write(&gfs2_umount_flush_sem);
 		msleep(10);
 	}
+	flush_workqueue(glock_workqueue);
+	wait_event(sdp->sd_glock_wait, atomic_read(&sdp->sd_glock_disposal) == 0);
+	gfs2_dump_lockstate(sdp);
 }
 
 void gfs2_glock_finish_truncate(struct gfs2_inode *ip)
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 13f0bd2..c0262fa 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -123,7 +123,7 @@ struct lm_lockops {
 	int (*lm_mount) (struct gfs2_sbd *sdp, const char *fsname);
  	void (*lm_unmount) (struct gfs2_sbd *sdp);
 	void (*lm_withdraw) (struct gfs2_sbd *sdp);
-	void (*lm_put_lock) (struct kmem_cache *cachep, void *gl);
+	void (*lm_put_lock) (struct kmem_cache *cachep, struct gfs2_glock *gl);
 	unsigned int (*lm_lock) (struct gfs2_glock *gl,
 				 unsigned int req_state, unsigned int flags);
 	void (*lm_cancel) (struct gfs2_glock *gl);
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index cdd0755..0e5e0e7 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -167,15 +167,16 @@ static unsigned int gdlm_lock(struct gfs2_glock *gl,
 	return LM_OUT_ASYNC;
 }
 
-static void gdlm_put_lock(struct kmem_cache *cachep, void *ptr)
+static void gdlm_put_lock(struct kmem_cache *cachep, struct gfs2_glock *gl)
 {
-	struct gfs2_glock *gl = ptr;
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
 	int error;
 
 	if (gl->gl_lksb.sb_lkid == 0) {
 		kmem_cache_free(cachep, gl);
+		if (atomic_dec_and_test(&sdp->sd_glock_disposal))
+			wake_up(&sdp->sd_glock_wait);
 		return;
 	}
 
@@ -187,7 +188,6 @@ static void gdlm_put_lock(struct kmem_cache *cachep, void *ptr)
 		       (unsigned long long)gl->gl_name.ln_number, error);
 		return;
 	}
-	atomic_inc(&sdp->sd_glock_disposal);
 }
 
 static void gdlm_cancel(struct gfs2_glock *gl)
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 9390fc7..8a102f7 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -985,9 +985,17 @@ static const match_table_t nolock_tokens = {
 	{ Opt_err, NULL },
 };
 
+static void nolock_put_lock(struct kmem_cache *cachep, struct gfs2_glock *gl)
+{
+	struct gfs2_sbd *sdp = gl->gl_sbd;
+	kmem_cache_free(cachep, gl);
+	if (atomic_dec_and_test(&sdp->sd_glock_disposal))
+		wake_up(&sdp->sd_glock_wait);
+}
+
 static const struct lm_lockops nolock_ops = {
 	.lm_proto_name = "lock_nolock",
-	.lm_put_lock = kmem_cache_free,
+	.lm_put_lock = nolock_put_lock,
 	.lm_tokens = &nolock_tokens,
 };
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 66242b3..b9dd3da 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -861,8 +861,6 @@ restart:
 	gfs2_jindex_free(sdp);
 	/*  Take apart glock structures and buffer lists  */
 	gfs2_gl_hash_clear(sdp);
-	/* Wait for dlm to reply to all our unlock requests */
-	wait_event(sdp->sd_glock_wait, atomic_read(&sdp->sd_glock_disposal) == 0);
 	/*  Unmount the locking protocol  */
 	gfs2_lm_unmount(sdp);
 
-- 
1.6.2.5

