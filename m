Return-Path: <linux-kernel-owner+w=401wt.eu-S936522AbXGKXzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936522AbXGKXzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935226AbXGKXg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:36:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:33450 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935252AbXGKXgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:36:24 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 46/61] sysfs: move s_active functions to fs/sysfs/dir.c
Date: Wed, 11 Jul 2007 16:32:05 -0700
Message-Id: <1184196954330-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841969502188-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
 <11841967992975-git-send-email-gregkh@suse.de>
 <11841968032469-git-send-email-gregkh@suse.de>
 <11841968071826-git-send-email-gregkh@suse.de>
 <11841968111201-git-send-email-gregkh@suse.de>
 <11841968151257-git-send-email-gregkh@suse.de>
 <1184196818497-git-send-email-gregkh@suse.de>
 <11841968231043-git-send-email-gregkh@suse.de>
 <11841968271925-git-send-email-gregkh@suse.de>
 <11841968303508-git-send-email-gregkh@suse.de>
 <11841968352439-git-send-email-gregkh@suse.de>
 <11841968392043-git-send-email-gregkh@suse.de>
 <11841968431153-git-send-email-gregkh@suse.de>
 <11841968471598-git-send-email-gregkh@suse.de>
 <11841968512510-git-send-email-gregkh@suse.de>
 <1184196856662-git-send-email-gregkh@suse.de>
 <1184196860992-git-send-email-gregkh@suse.de>
 <11841968643630-git-send-email-gregkh@suse.de>
 <11841968683554-git-send-email-gregkh@suse.de>
 <11841968731843-git-send-email-gregkh@suse.de>
 <11841968773426-git-send-email-gregkh@suse.de>
 <118419688284-git-send-email-gregkh@suse.de>
 <11841968872456-git-send-email-gregkh@suse.de>
 <11841968903726-git-send-email-gregkh@suse.de>
 <11841968951572-git-send-email-gregkh@suse.de>
 <11841968992181-git-send-email-gregkh@suse.de>
 <1184196905515-git-send-email-gregkh@suse.de>
 <11841969101299-git-send-email-gregkh@suse.de>
 <11841969142368-git-send-email-gregkh@suse.de>
 <11841969191116-git-send-email-gregkh@suse.de>
 <118419692665-git-send-email-gregkh@suse.de>
 <11841969323515-git-send-email-gregkh@suse.de>
 <11841969361535-git-send-email-gregkh@suse.de>
 <11841969401152-git-send-email-gregkh@suse.de>
 <11841969453004-git-send-email-gregkh@suse.de>
 <11841969502188-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

These functions are about to receive more complexity and doesn't
really need to be inlined in the first place.  Move them from
fs/sysfs/sysfs.h to fs/sysfs/dir.c.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c   |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/sysfs/sysfs.h |   94 +++--------------------------------------------------
 2 files changed, 94 insertions(+), 88 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 06dff2c..f5f0b93 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -20,6 +20,94 @@ spinlock_t kobj_sysfs_assoc_lock = SPIN_LOCK_UNLOCKED;
 static spinlock_t sysfs_ino_lock = SPIN_LOCK_UNLOCKED;
 static DEFINE_IDA(sysfs_ino_ida);
 
+/**
+ *	sysfs_get_active - get an active reference to sysfs_dirent
+ *	@sd: sysfs_dirent to get an active reference to
+ *
+ *	Get an active reference of @sd.  This function is noop if @sd
+ *	is NULL.
+ *
+ *	RETURNS:
+ *	Pointer to @sd on success, NULL on failure.
+ */
+struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd)
+{
+	if (sd) {
+		if (unlikely(!down_read_trylock(&sd->s_active)))
+			sd = NULL;
+	}
+	return sd;
+}
+
+/**
+ *	sysfs_put_active - put an active reference to sysfs_dirent
+ *	@sd: sysfs_dirent to put an active reference to
+ *
+ *	Put an active reference to @sd.  This function is noop if @sd
+ *	is NULL.
+ */
+void sysfs_put_active(struct sysfs_dirent *sd)
+{
+	if (sd)
+		up_read(&sd->s_active);
+}
+
+/**
+ *	sysfs_get_active_two - get active references to sysfs_dirent and parent
+ *	@sd: sysfs_dirent of interest
+ *
+ *	Get active reference to @sd and its parent.  Parent's active
+ *	reference is grabbed first.  This function is noop if @sd is
+ *	NULL.
+ *
+ *	RETURNS:
+ *	Pointer to @sd on success, NULL on failure.
+ */
+struct sysfs_dirent *sysfs_get_active_two(struct sysfs_dirent *sd)
+{
+	if (sd) {
+		if (sd->s_parent && unlikely(!sysfs_get_active(sd->s_parent)))
+			return NULL;
+		if (unlikely(!sysfs_get_active(sd))) {
+			sysfs_put_active(sd->s_parent);
+			return NULL;
+		}
+	}
+	return sd;
+}
+
+/**
+ *	sysfs_put_active_two - put active references to sysfs_dirent and parent
+ *	@sd: sysfs_dirent of interest
+ *
+ *	Put active references to @sd and its parent.  This function is
+ *	noop if @sd is NULL.
+ */
+void sysfs_put_active_two(struct sysfs_dirent *sd)
+{
+	if (sd) {
+		sysfs_put_active(sd);
+		sysfs_put_active(sd->s_parent);
+	}
+}
+
+/**
+ *	sysfs_deactivate - deactivate sysfs_dirent
+ *	@sd: sysfs_dirent to deactivate
+ *
+ *	Deny new active references and drain existing ones.  s_active
+ *	will be unlocked when the sysfs_dirent is released.
+ */
+void sysfs_deactivate(struct sysfs_dirent *sd)
+{
+	down_write_nested(&sd->s_active, SYSFS_S_ACTIVE_DEACTIVATE);
+
+	/* s_active will be unlocked by the thread doing the final put
+	 * on @sd.  Lie to lockdep.
+	 */
+	rwsem_release(&sd->s_active.dep_map, 1, _RET_IP_);
+}
+
 static int sysfs_alloc_ino(ino_t *pino)
 {
 	int ino, rc;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 627bf39..f8779ea 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -56,6 +56,12 @@ enum sysfs_s_active_class
 extern struct vfsmount * sysfs_mount;
 extern struct kmem_cache *sysfs_dir_cachep;
 
+extern struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd);
+extern void sysfs_put_active(struct sysfs_dirent *sd);
+extern struct sysfs_dirent *sysfs_get_active_two(struct sysfs_dirent *sd);
+extern void sysfs_put_active_two(struct sysfs_dirent *sd);
+extern void sysfs_deactivate(struct sysfs_dirent *sd);
+
 extern void sysfs_delete_inode(struct inode *inode);
 extern void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode);
 extern struct inode * sysfs_get_inode(struct sysfs_dirent *sd);
@@ -104,94 +110,6 @@ static inline void sysfs_put(struct sysfs_dirent * sd)
 		release_sysfs_dirent(sd);
 }
 
-/**
- *	sysfs_get_active - get an active reference to sysfs_dirent
- *	@sd: sysfs_dirent to get an active reference to
- *
- *	Get an active reference of @sd.  This function is noop if @sd
- *	is NULL.
- *
- *	RETURNS:
- *	Pointer to @sd on success, NULL on failure.
- */
-static inline struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd)
-{
-	if (sd) {
-		if (unlikely(!down_read_trylock(&sd->s_active)))
-			sd = NULL;
-	}
-	return sd;
-}
-
-/**
- *	sysfs_put_active - put an active reference to sysfs_dirent
- *	@sd: sysfs_dirent to put an active reference to
- *
- *	Put an active reference to @sd.  This function is noop if @sd
- *	is NULL.
- */
-static inline void sysfs_put_active(struct sysfs_dirent *sd)
-{
-	if (sd)
-		up_read(&sd->s_active);
-}
-
-/**
- *	sysfs_get_active_two - get active references to sysfs_dirent and parent
- *	@sd: sysfs_dirent of interest
- *
- *	Get active reference to @sd and its parent.  Parent's active
- *	reference is grabbed first.  This function is noop if @sd is
- *	NULL.
- *
- *	RETURNS:
- *	Pointer to @sd on success, NULL on failure.
- */
-static inline struct sysfs_dirent *sysfs_get_active_two(struct sysfs_dirent *sd)
-{
-	if (sd) {
-		if (sd->s_parent && unlikely(!sysfs_get_active(sd->s_parent)))
-			return NULL;
-		if (unlikely(!sysfs_get_active(sd))) {
-			sysfs_put_active(sd->s_parent);
-			return NULL;
-		}
-	}
-	return sd;
-}
-
-/**
- *	sysfs_put_active_two - put active references to sysfs_dirent and parent
- *	@sd: sysfs_dirent of interest
- *
- *	Put active references to @sd and its parent.  This function is
- *	noop if @sd is NULL.
- */
-static inline void sysfs_put_active_two(struct sysfs_dirent *sd)
-{
-	if (sd) {
-		sysfs_put_active(sd);
-		sysfs_put_active(sd->s_parent);
-	}
-}
-
-/**
- *	sysfs_deactivate - deactivate sysfs_dirent
- *	@sd: sysfs_dirent to deactivate
- *
- *	Deny new active references and drain existing ones.  s_active
- *	will be unlocked when the sysfs_dirent is released.
- */
-static inline void sysfs_deactivate(struct sysfs_dirent *sd)
-{
-	down_write_nested(&sd->s_active, SYSFS_S_ACTIVE_DEACTIVATE);
-
-	/* s_active will be unlocked by the thread doing the final put
-	 * on @sd.  Lie to lockdep.
-	 */
-	rwsem_release(&sd->s_active.dep_map, 1, _RET_IP_);
-}
-
 static inline int sysfs_is_shadowed_inode(struct inode *inode)
 {
 	return S_ISDIR(inode->i_mode) && inode->i_op->follow_link;
-- 
1.5.2.2

