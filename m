Return-Path: <linux-kernel-owner+w=401wt.eu-S936923AbXGLABa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936923AbXGLABa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935336AbXGKXh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:37:28 -0400
Received: from mail.suse.de ([195.135.220.2]:34070 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935281AbXGKXhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:37:25 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 59/61] sysfs: implement sysfs_get_dentry()
Date: Wed, 11 Jul 2007 16:32:18 -0700
Message-Id: <11841970211456-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841970162061-git-send-email-gregkh@suse.de>
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
 <1184196954330-git-send-email-gregkh@suse.de>
 <11841969641445-git-send-email-gregkh@suse.de>
 <1184196968712-git-send-email-gregkh@suse.de>
 <11841969731234-git-send-email-gregkh@suse.de>
 <11841969771935-git-send-email-gregkh@suse.de>
 <11841969814023-git-send-email-gregkh@suse.de>
 <11841969873230-git-send-email-gregkh@suse.de>
 <11841969912096-git-send-email-gregkh@suse.de>
 <1184196995958-git-send-email-gregkh@suse.de>
 <11841970013184-git-send-email-gregkh@suse.de>
 <11841970052991-git-send-email-gregkh@suse.de>
 <11841970112965-git-send-email-gregkh@suse.de>
 <11841970162061-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Some sysfs operations require dentry and inode.  sysfs_get_dentry()
looks up and gets dentry for the specified sysfs_dirent.  It finds the
first ancestor with dentry attached and starts looking up dentries
from there.

Looking up from the nearest ancestor is necessary to support shadowed
directories because we can't reliably lookup dentry for one of the
shadows.  Dentries for each shadow will be pinned in memory such that
they can serve as the starting point for dentry lookup.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c   |   98 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/sysfs/sysfs.h |    1 +
 2 files changed, 99 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index c6f3b69..9872112 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -63,6 +63,104 @@ void sysfs_unlink_sibling(struct sysfs_dirent *sd)
 }
 
 /**
+ *	sysfs_get_dentry - get dentry for the given sysfs_dirent
+ *	@sd: sysfs_dirent of interest
+ *
+ *	Get dentry for @sd.  Dentry is looked up if currently not
+ *	present.  This function climbs sysfs_dirent tree till it
+ *	reaches a sysfs_dirent with valid dentry attached and descends
+ *	down from there looking up dentry for each step.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep)
+ *
+ *	RETURNS:
+ *	Pointer to found dentry on success, ERR_PTR() value on error.
+ */
+struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd)
+{
+	struct sysfs_dirent *cur;
+	struct dentry *parent_dentry, *dentry;
+	int i, depth;
+
+	/* Find the first parent which has valid s_dentry and get the
+	 * dentry.
+	 */
+	mutex_lock(&sysfs_mutex);
+ restart0:
+	spin_lock(&sysfs_assoc_lock);
+ restart1:
+	spin_lock(&dcache_lock);
+
+	dentry = NULL;
+	depth = 0;
+	cur = sd;
+	while (!cur->s_dentry || !cur->s_dentry->d_inode) {
+		if (cur->s_flags & SYSFS_FLAG_REMOVED) {
+			dentry = ERR_PTR(-ENOENT);
+			depth = 0;
+			break;
+		}
+		cur = cur->s_parent;
+		depth++;
+	}
+	if (!IS_ERR(dentry))
+		dentry = dget_locked(cur->s_dentry);
+
+	spin_unlock(&dcache_lock);
+	spin_unlock(&sysfs_assoc_lock);
+
+	/* from the found dentry, look up depth times */
+	while (depth--) {
+		/* find and get depth'th ancestor */
+		for (cur = sd, i = 0; cur && i < depth; i++)
+			cur = cur->s_parent;
+
+		/* This can happen if tree structure was modified due
+		 * to move/rename.  Restart.
+		 */
+		if (i != depth) {
+			dput(dentry);
+			goto restart0;
+		}
+
+		sysfs_get(cur);
+
+		mutex_unlock(&sysfs_mutex);
+
+		/* look it up */
+		parent_dentry = dentry;
+		dentry = lookup_one_len_kern(cur->s_name, parent_dentry,
+					     strlen(cur->s_name));
+		dput(parent_dentry);
+
+		if (IS_ERR(dentry)) {
+			sysfs_put(cur);
+			return dentry;
+		}
+
+		mutex_lock(&sysfs_mutex);
+		spin_lock(&sysfs_assoc_lock);
+
+		/* This, again, can happen if tree structure has
+		 * changed and we looked up the wrong thing.  Restart.
+		 */
+		if (cur->s_dentry != dentry) {
+			dput(dentry);
+			sysfs_put(cur);
+			goto restart1;
+		}
+
+		spin_unlock(&sysfs_assoc_lock);
+
+		sysfs_put(cur);
+	}
+
+	mutex_unlock(&sysfs_mutex);
+	return dentry;
+}
+
+/**
  *	sysfs_get_active - get an active reference to sysfs_dirent
  *	@sd: sysfs_dirent to get an active reference to
  *
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 92fe1e5..72530dc 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -54,6 +54,7 @@ struct sysfs_addrm_cxt {
 extern struct vfsmount * sysfs_mount;
 extern struct kmem_cache *sysfs_dir_cachep;
 
+extern struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd);
 extern void sysfs_link_sibling(struct sysfs_dirent *sd);
 extern void sysfs_unlink_sibling(struct sysfs_dirent *sd);
 extern struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd);
-- 
1.5.2.2

