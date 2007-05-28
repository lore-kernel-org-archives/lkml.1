Return-Path: <linux-kernel-owner+w=401wt.eu-S1762092AbXE1QYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762092AbXE1QYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757143AbXE1QYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:24:15 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:50151 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbXE1QYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:24:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=h3bCaypLDWX7K1MtNSTwkRgVW9NYmiNGebSjCGYAhOjK6Uc6QcnAmlBemawkSYDofDiddlCI5SpLNJvrwQ7nBw3glbol+HmhJuj+KGz3n/I5bDdA9ZMxO5giUB97Z0Uq5KnDxtugtkcWUyl3F3PN/nZ36p332vVRx33L/cNv2Lo=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 1/3] sysfs: move s_active functions to fs/sysfs/dir.c
In-Reply-To: <118036944617-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Tue, 29 May 2007 01:24:06 +0900
Message-Id: <11803694461752-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These functions are about to receive more complexity and doesn't
really need to be inlined in the first place.  Move them from
fs/sysfs/sysfs.h to fs/sysfs/dir.c.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c   |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/sysfs/sysfs.h |   94 +++--------------------------------------------------
 2 files changed, 94 insertions(+), 88 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 06dff2c..f5f0b93 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -20,6 +20,94 @@ spinlock_t kobj_sysfs_assoc_lock = SPIN_
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
@@ -104,94 +110,6 @@ static inline void sysfs_put(struct sysf
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
1.4.3.4


