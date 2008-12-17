Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760918AbYLQMgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918AbYLQMgv (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755794AbYLQM3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53750 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350AbYLQM32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:28 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 20/24] GFS2: Move four functions from super.c
Date: Wed, 17 Dec 2008 11:30:19 +0000
Message-Id: <1229513423-19105-21-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-20-git-send-email-swhiteho@redhat.com>
References: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-2-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-3-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-4-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-5-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-6-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-7-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-8-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-9-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-10-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-11-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-12-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-13-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-14-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-15-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-16-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-17-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-18-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-19-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-20-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The functions which are being moved can all be marked
static in their new locations, since they only have
a single caller each. Their new locations are more
logical than before and some of the functions are
small enough that the compiler might well inline them.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 07ffc81..6e298b0 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1317,6 +1317,20 @@ static void blocking_cb(struct gfs2_sbd *sdp, struct lm_lockname *name,
 		gfs2_glock_put(gl);
 }
 
+static void gfs2_jdesc_make_dirty(struct gfs2_sbd *sdp, unsigned int jid)
+{
+	struct gfs2_jdesc *jd;
+
+	spin_lock(&sdp->sd_jindex_spin);
+	list_for_each_entry(jd, &sdp->sd_jindex_list, jd_list) {
+		if (jd->jd_jid != jid)
+			continue;
+		jd->jd_dirty = 1;
+		break;
+	}
+	spin_unlock(&sdp->sd_jindex_spin);
+}
+
 /**
  * gfs2_glock_cb - Callback used by locking module
  * @sdp: Pointer to the superblock
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index 29f8a5c..08837a7 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -257,6 +257,137 @@ static void gfs2_unlockfs(struct super_block *sb)
 }
 
 /**
+ * statfs_fill - fill in the sg for a given RG
+ * @rgd: the RG
+ * @sc: the sc structure
+ *
+ * Returns: 0 on success, -ESTALE if the LVB is invalid
+ */
+
+static int statfs_slow_fill(struct gfs2_rgrpd *rgd,
+			    struct gfs2_statfs_change_host *sc)
+{
+	gfs2_rgrp_verify(rgd);
+	sc->sc_total += rgd->rd_data;
+	sc->sc_free += rgd->rd_free;
+	sc->sc_dinodes += rgd->rd_dinodes;
+	return 0;
+}
+
+/**
+ * gfs2_statfs_slow - Stat a filesystem using asynchronous locking
+ * @sdp: the filesystem
+ * @sc: the sc info that will be returned
+ *
+ * Any error (other than a signal) will cause this routine to fall back
+ * to the synchronous version.
+ *
+ * FIXME: This really shouldn't busy wait like this.
+ *
+ * Returns: errno
+ */
+
+static int gfs2_statfs_slow(struct gfs2_sbd *sdp, struct gfs2_statfs_change_host *sc)
+{
+	struct gfs2_holder ri_gh;
+	struct gfs2_rgrpd *rgd_next;
+	struct gfs2_holder *gha, *gh;
+	unsigned int slots = 64;
+	unsigned int x;
+	int done;
+	int error = 0, err;
+
+	memset(sc, 0, sizeof(struct gfs2_statfs_change_host));
+	gha = kcalloc(slots, sizeof(struct gfs2_holder), GFP_KERNEL);
+	if (!gha)
+		return -ENOMEM;
+
+	error = gfs2_rindex_hold(sdp, &ri_gh);
+	if (error)
+		goto out;
+
+	rgd_next = gfs2_rgrpd_get_first(sdp);
+
+	for (;;) {
+		done = 1;
+
+		for (x = 0; x < slots; x++) {
+			gh = gha + x;
+
+			if (gh->gh_gl && gfs2_glock_poll(gh)) {
+				err = gfs2_glock_wait(gh);
+				if (err) {
+					gfs2_holder_uninit(gh);
+					error = err;
+				} else {
+					if (!error)
+						error = statfs_slow_fill(
+							gh->gh_gl->gl_object, sc);
+					gfs2_glock_dq_uninit(gh);
+				}
+			}
+
+			if (gh->gh_gl)
+				done = 0;
+			else if (rgd_next && !error) {
+				error = gfs2_glock_nq_init(rgd_next->rd_gl,
+							   LM_ST_SHARED,
+							   GL_ASYNC,
+							   gh);
+				rgd_next = gfs2_rgrpd_get_next(rgd_next);
+				done = 0;
+			}
+
+			if (signal_pending(current))
+				error = -ERESTARTSYS;
+		}
+
+		if (done)
+			break;
+
+		yield();
+	}
+
+	gfs2_glock_dq_uninit(&ri_gh);
+
+out:
+	kfree(gha);
+	return error;
+}
+
+/**
+ * gfs2_statfs_i - Do a statfs
+ * @sdp: the filesystem
+ * @sg: the sg structure
+ *
+ * Returns: errno
+ */
+
+static int gfs2_statfs_i(struct gfs2_sbd *sdp, struct gfs2_statfs_change_host *sc)
+{
+	struct gfs2_statfs_change_host *m_sc = &sdp->sd_statfs_master;
+	struct gfs2_statfs_change_host *l_sc = &sdp->sd_statfs_local;
+
+	spin_lock(&sdp->sd_statfs_spin);
+
+	*sc = *m_sc;
+	sc->sc_total += l_sc->sc_total;
+	sc->sc_free += l_sc->sc_free;
+	sc->sc_dinodes += l_sc->sc_dinodes;
+
+	spin_unlock(&sdp->sd_statfs_spin);
+
+	if (sc->sc_free < 0)
+		sc->sc_free = 0;
+	if (sc->sc_free > sc->sc_total)
+		sc->sc_free = sc->sc_total;
+	if (sc->sc_dinodes < 0)
+		sc->sc_dinodes = 0;
+
+	return 0;
+}
+
+/**
  * gfs2_statfs - Gather and return stats about the filesystem
  * @sb: The superblock
  * @statfsbuf: The buffer
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index b56ba3d..efd09c3 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -585,6 +585,28 @@ fail:
 	return error;
 }
 
+static struct gfs2_jdesc *gfs2_jdesc_find_dirty(struct gfs2_sbd *sdp)
+{
+	struct gfs2_jdesc *jd;
+	int found = 0;
+
+	spin_lock(&sdp->sd_jindex_spin);
+
+	list_for_each_entry(jd, &sdp->sd_jindex_list, jd_list) {
+		if (jd->jd_dirty) {
+			jd->jd_dirty = 0;
+			found = 1;
+			break;
+		}
+	}
+	spin_unlock(&sdp->sd_jindex_spin);
+
+	if (!found)
+		jd = NULL;
+
+	return jd;
+}
+
 /**
  * gfs2_check_journals - Recover any dirty journals
  * @sdp: the filesystem
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 3dd9f57..141b781 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -96,39 +96,6 @@ struct gfs2_jdesc *gfs2_jdesc_find(struct gfs2_sbd *sdp, unsigned int jid)
 	return jd;
 }
 
-void gfs2_jdesc_make_dirty(struct gfs2_sbd *sdp, unsigned int jid)
-{
-	struct gfs2_jdesc *jd;
-
-	spin_lock(&sdp->sd_jindex_spin);
-	jd = jdesc_find_i(&sdp->sd_jindex_list, jid);
-	if (jd)
-		jd->jd_dirty = 1;
-	spin_unlock(&sdp->sd_jindex_spin);
-}
-
-struct gfs2_jdesc *gfs2_jdesc_find_dirty(struct gfs2_sbd *sdp)
-{
-	struct gfs2_jdesc *jd;
-	int found = 0;
-
-	spin_lock(&sdp->sd_jindex_spin);
-
-	list_for_each_entry(jd, &sdp->sd_jindex_list, jd_list) {
-		if (jd->jd_dirty) {
-			jd->jd_dirty = 0;
-			found = 1;
-			break;
-		}
-	}
-	spin_unlock(&sdp->sd_jindex_spin);
-
-	if (!found)
-		jd = NULL;
-
-	return jd;
-}
-
 int gfs2_jdesc_check(struct gfs2_jdesc *jd)
 {
 	struct gfs2_inode *ip = GFS2_I(jd->jd_inode);
@@ -353,137 +320,6 @@ out:
 	return error;
 }
 
-/**
- * gfs2_statfs_i - Do a statfs
- * @sdp: the filesystem
- * @sg: the sg structure
- *
- * Returns: errno
- */
-
-int gfs2_statfs_i(struct gfs2_sbd *sdp, struct gfs2_statfs_change_host *sc)
-{
-	struct gfs2_statfs_change_host *m_sc = &sdp->sd_statfs_master;
-	struct gfs2_statfs_change_host *l_sc = &sdp->sd_statfs_local;
-
-	spin_lock(&sdp->sd_statfs_spin);
-
-	*sc = *m_sc;
-	sc->sc_total += l_sc->sc_total;
-	sc->sc_free += l_sc->sc_free;
-	sc->sc_dinodes += l_sc->sc_dinodes;
-
-	spin_unlock(&sdp->sd_statfs_spin);
-
-	if (sc->sc_free < 0)
-		sc->sc_free = 0;
-	if (sc->sc_free > sc->sc_total)
-		sc->sc_free = sc->sc_total;
-	if (sc->sc_dinodes < 0)
-		sc->sc_dinodes = 0;
-
-	return 0;
-}
-
-/**
- * statfs_fill - fill in the sg for a given RG
- * @rgd: the RG
- * @sc: the sc structure
- *
- * Returns: 0 on success, -ESTALE if the LVB is invalid
- */
-
-static int statfs_slow_fill(struct gfs2_rgrpd *rgd,
-			    struct gfs2_statfs_change_host *sc)
-{
-	gfs2_rgrp_verify(rgd);
-	sc->sc_total += rgd->rd_data;
-	sc->sc_free += rgd->rd_free;
-	sc->sc_dinodes += rgd->rd_dinodes;
-	return 0;
-}
-
-/**
- * gfs2_statfs_slow - Stat a filesystem using asynchronous locking
- * @sdp: the filesystem
- * @sc: the sc info that will be returned
- *
- * Any error (other than a signal) will cause this routine to fall back
- * to the synchronous version.
- *
- * FIXME: This really shouldn't busy wait like this.
- *
- * Returns: errno
- */
-
-int gfs2_statfs_slow(struct gfs2_sbd *sdp, struct gfs2_statfs_change_host *sc)
-{
-	struct gfs2_holder ri_gh;
-	struct gfs2_rgrpd *rgd_next;
-	struct gfs2_holder *gha, *gh;
-	unsigned int slots = 64;
-	unsigned int x;
-	int done;
-	int error = 0, err;
-
-	memset(sc, 0, sizeof(struct gfs2_statfs_change_host));
-	gha = kcalloc(slots, sizeof(struct gfs2_holder), GFP_KERNEL);
-	if (!gha)
-		return -ENOMEM;
-
-	error = gfs2_rindex_hold(sdp, &ri_gh);
-	if (error)
-		goto out;
-
-	rgd_next = gfs2_rgrpd_get_first(sdp);
-
-	for (;;) {
-		done = 1;
-
-		for (x = 0; x < slots; x++) {
-			gh = gha + x;
-
-			if (gh->gh_gl && gfs2_glock_poll(gh)) {
-				err = gfs2_glock_wait(gh);
-				if (err) {
-					gfs2_holder_uninit(gh);
-					error = err;
-				} else {
-					if (!error)
-						error = statfs_slow_fill(
-							gh->gh_gl->gl_object, sc);
-					gfs2_glock_dq_uninit(gh);
-				}
-			}
-
-			if (gh->gh_gl)
-				done = 0;
-			else if (rgd_next && !error) {
-				error = gfs2_glock_nq_init(rgd_next->rd_gl,
-							   LM_ST_SHARED,
-							   GL_ASYNC,
-							   gh);
-				rgd_next = gfs2_rgrpd_get_next(rgd_next);
-				done = 0;
-			}
-
-			if (signal_pending(current))
-				error = -ERESTARTSYS;
-		}
-
-		if (done)
-			break;
-
-		yield();
-	}
-
-	gfs2_glock_dq_uninit(&ri_gh);
-
-out:
-	kfree(gha);
-	return error;
-}
-
 struct lfcc {
 	struct list_head list;
 	struct gfs2_holder gh;
diff --git a/fs/gfs2/super.h b/fs/gfs2/super.h
index c625459..f6b8b00 100644
--- a/fs/gfs2/super.h
+++ b/fs/gfs2/super.h
@@ -28,8 +28,6 @@ static inline unsigned int gfs2_jindex_size(struct gfs2_sbd *sdp)
 void gfs2_jindex_free(struct gfs2_sbd *sdp);
 
 struct gfs2_jdesc *gfs2_jdesc_find(struct gfs2_sbd *sdp, unsigned int jid);
-void gfs2_jdesc_make_dirty(struct gfs2_sbd *sdp, unsigned int jid);
-struct gfs2_jdesc *gfs2_jdesc_find_dirty(struct gfs2_sbd *sdp);
 int gfs2_jdesc_check(struct gfs2_jdesc *jd);
 
 int gfs2_lookup_in_master_dir(struct gfs2_sbd *sdp, char *filename,
@@ -41,8 +39,6 @@ int gfs2_statfs_init(struct gfs2_sbd *sdp);
 void gfs2_statfs_change(struct gfs2_sbd *sdp,
 			s64 total, s64 free, s64 dinodes);
 int gfs2_statfs_sync(struct gfs2_sbd *sdp);
-int gfs2_statfs_i(struct gfs2_sbd *sdp, struct gfs2_statfs_change_host *sc);
-int gfs2_statfs_slow(struct gfs2_sbd *sdp, struct gfs2_statfs_change_host *sc);
 
 int gfs2_freeze_fs(struct gfs2_sbd *sdp);
 void gfs2_unfreeze_fs(struct gfs2_sbd *sdp);
-- 
1.6.0.3

