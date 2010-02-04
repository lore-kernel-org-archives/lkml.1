Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775Ab0BDJzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:55:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756484Ab0BDJzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:55:17 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/2] GFS2: Wait for unlock completion on umount
Date: Thu,  4 Feb 2010 09:46:20 +0000
Message-Id: <1265276781-4648-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1265276781-4648-1-git-send-email-swhiteho@redhat.com>
References: <1265276781-4648-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a wait on umount between the point at which we
dispose of all glocks and the point at which we unmount the
lock protocol. This ensures that we've received all the replies
to our unlock requests before we stop the locking.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Reported-by: Fabio M. Di Nitto <fdinitto@redhat.com>
---
 fs/gfs2/incore.h     |    2 ++
 fs/gfs2/lock_dlm.c   |    7 ++++++-
 fs/gfs2/ops_fstype.c |    2 ++
 fs/gfs2/super.c      |    3 +++
 4 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 4792200..bc0ad15 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -544,6 +544,8 @@ struct gfs2_sbd {
 	struct gfs2_holder sd_live_gh;
 	struct gfs2_glock *sd_rename_gl;
 	struct gfs2_glock *sd_trans_gl;
+	wait_queue_head_t sd_glock_wait;
+	atomic_t sd_glock_disposal;
 
 	/* Inode Stuff */
 
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 46df988..cdd0755 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -21,6 +21,7 @@ static void gdlm_ast(void *arg)
 {
 	struct gfs2_glock *gl = arg;
 	unsigned ret = gl->gl_state;
+	struct gfs2_sbd *sdp = gl->gl_sbd;
 
 	BUG_ON(gl->gl_lksb.sb_flags & DLM_SBF_DEMOTED);
 
@@ -30,6 +31,8 @@ static void gdlm_ast(void *arg)
 	switch (gl->gl_lksb.sb_status) {
 	case -DLM_EUNLOCK: /* Unlocked, so glock can be freed */
 		kmem_cache_free(gfs2_glock_cachep, gl);
+		if (atomic_dec_and_test(&sdp->sd_glock_disposal))
+			wake_up(&sdp->sd_glock_wait);
 		return;
 	case -DLM_ECANCEL: /* Cancel while getting lock */
 		ret |= LM_OUT_CANCELED;
@@ -167,7 +170,8 @@ static unsigned int gdlm_lock(struct gfs2_glock *gl,
 static void gdlm_put_lock(struct kmem_cache *cachep, void *ptr)
 {
 	struct gfs2_glock *gl = ptr;
-	struct lm_lockstruct *ls = &gl->gl_sbd->sd_lockstruct;
+	struct gfs2_sbd *sdp = gl->gl_sbd;
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
 	int error;
 
 	if (gl->gl_lksb.sb_lkid == 0) {
@@ -183,6 +187,7 @@ static void gdlm_put_lock(struct kmem_cache *cachep, void *ptr)
 		       (unsigned long long)gl->gl_name.ln_number, error);
 		return;
 	}
+	atomic_inc(&sdp->sd_glock_disposal);
 }
 
 static void gdlm_cancel(struct gfs2_glock *gl)
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index edfee24..9390fc7 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -82,6 +82,8 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 
 	gfs2_tune_init(&sdp->sd_tune);
 
+	init_waitqueue_head(&sdp->sd_glock_wait);
+	atomic_set(&sdp->sd_glock_disposal, 0);
 	spin_lock_init(&sdp->sd_statfs_spin);
 
 	spin_lock_init(&sdp->sd_rindex_spin);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index c282ad4..66242b3 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -21,6 +21,7 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
 #include <linux/time.h>
+#include <linux/wait.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -860,6 +861,8 @@ restart:
 	gfs2_jindex_free(sdp);
 	/*  Take apart glock structures and buffer lists  */
 	gfs2_gl_hash_clear(sdp);
+	/* Wait for dlm to reply to all our unlock requests */
+	wait_event(sdp->sd_glock_wait, atomic_read(&sdp->sd_glock_disposal) == 0);
 	/*  Unmount the locking protocol  */
 	gfs2_lm_unmount(sdp);
 
-- 
1.6.2.5

