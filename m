Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068AbZLCFxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbZLCFxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 00:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZLCFxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 00:53:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbZLCFxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 00:53:43 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 5/5] fanotify: infrastructure to add an remove marks on
	vfsmounts
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
       eparis@redhat.com
Date: Thu, 03 Dec 2009 00:53:41 -0500
Message-ID: <20091203055341.21918.36598.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091203055315.21918.83562.stgit@paris.rdu.redhat.com>
References: <20091203055315.21918.83562.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

infrastructure work to add and remove marks on vfsmounts.  This should get
every set up except wiring the functions to the syscalls.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify/fanotify_user.c |  185 ++++++++++++++++++++++++++----------
 1 files changed, 133 insertions(+), 52 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 79376ec..f5bf1db 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -300,31 +300,83 @@ out:
 	return ret;
 }
 
-static int fanotify_remove_mark(struct fsnotify_group *group,
-				struct inode *inode,
-				__u32 mask)
+static void fanotify_update_object_mask(struct fsnotify_group *group,
+					struct inode *inode,
+					struct vfsmount *mnt,
+					struct fsnotify_mark *fsn_mark,
+					unsigned int flags,
+					__u32 mask)
 {
-	struct fsnotify_mark *fsn_mark;
-	__u32 new_mask;
-
-	pr_debug("%s: group=%p inode=%p mask=%x\n", __func__,
-		 group, inode, mask);
+	__u32 old_mask, new_mask;
 
-	fsn_mark = fsnotify_find_inode_mark(group, inode);
-	if (!fsn_mark)
-		return -ENOENT;
+	pr_debug("%s: group=%p inode=%p mnt=%p fsn_mark=%p flags=%x mask=%x\n",
+		 __func__, group, inode, mnt, fsn_mark, flags, mask);
 
 	spin_lock(&fsn_mark->lock);
-	fsn_mark->mask &= ~mask;
+	old_mask = fsn_mark->mask;
+	if (flags & FAN_MARK_ADD)
+		fsn_mark->mask |= mask;
+	else if (flags & FAN_MARK_REMOVE)
+		fsn_mark->mask &= ~mask;
+	else
+		BUG();
 	new_mask = fsn_mark->mask;
 	spin_unlock(&fsn_mark->lock);
 
 	if (!new_mask)
 		fsnotify_destroy_mark(fsn_mark);
+
+	/* we made changes to a mask, update the group mask and the object mask
+	 * so things happen quickly. */
+	if (old_mask != new_mask) {
+		__u32 dropped, do_object, do_group;
+
+		/* more bits in old than in new? */
+		dropped = (old_mask & ~new_mask);
+		/* more bits in this fsn_mark than the group? */
+		do_group = (new_mask & ~group->mask);
+
+		if (inode) {
+			/* more bits in this fsn_mark than the object's mask? */
+			do_object = (new_mask & ~inode->i_fsnotify_mask);
+			/* update the object with this new fsn_mark */
+			if (dropped || do_object)
+				fsnotify_recalc_inode_mask(inode);
+		} else if (mnt) {
+			/* more bits in this fsn_mark than the object's mask? */
+			do_object = (new_mask & ~mnt->mnt_fsnotify_mask);
+			/* update the object with this new fsn_mark */
+			if (dropped || do_object)
+				fsnotify_recalc_vfsmount_mask(mnt);
+		} else {
+			BUG();
+		}
+
+		/* update the group mask with the new mask */
+		if (dropped || do_group)
+			fsnotify_recalc_group_mask(group);
+	}
+}
+
+static int fanotify_remove_mark(struct fsnotify_group *group, struct inode *inode,
+				struct vfsmount *mnt, unsigned int flags, __u32 mask)
+{
+	struct fsnotify_mark *fsn_mark = NULL;
+
+	BUG_ON(inode && mnt);
+	BUG_ON(!inode && !mnt);
+
+	if (inode)
+		fsn_mark = fsnotify_find_inode_mark(group, inode);
+	else if (mnt)
+		fsn_mark = fsnotify_find_vfsmount_mark(group, mnt);
 	else
-		fsnotify_recalc_inode_mask(inode);
+		BUG();
 
-	fsnotify_recalc_group_mask(group);
+	if (!fsn_mark)
+		return -ENOENT;
+
+	fanotify_update_object_mask(group, inode, mnt, fsn_mark, flags, mask);
 
 	/* matches the fsnotify_find_inode_mark() */
 	fsnotify_put_mark(fsn_mark);
@@ -332,22 +384,48 @@ static int fanotify_remove_mark(struct fsnotify_group *group,
 	return 0;
 }
 
-static int fanotify_add_mark(struct fsnotify_group *group,
-			     struct inode *inode,
-			     __u32 mask)
+static struct fsnotify_mark *fanotify_add_vfsmount_mark(struct fsnotify_group *group,
+							struct vfsmount *mnt)
 {
 	struct fsnotify_mark *fsn_mark;
-	__u32 old_mask, new_mask;
-	int ret;
 
-	pr_debug("%s: group=%p inode=%p mask=%x\n", __func__,
-		 group, inode, mask);
+	fsn_mark = fsnotify_find_vfsmount_mark(group, mnt);
+	if (!fsn_mark) {
+		struct fsnotify_mark *new_fsn_mark;
+		int ret;
+
+		fsn_mark = ERR_PTR(-ENOMEM);
+		new_fsn_mark = kmem_cache_alloc(fanotify_mark_cache, GFP_KERNEL);
+		if (!new_fsn_mark)
+			goto out;
+
+		fsnotify_init_mark(new_fsn_mark, fanotify_free_mark);
+		ret = fsnotify_add_mark(new_fsn_mark, group, NULL, mnt, 0);
+		if (ret) {
+			fsn_mark = ERR_PTR(ret);
+			fanotify_free_mark(new_fsn_mark);
+			goto out;
+		}
+
+		fsn_mark = new_fsn_mark;
+	}
+out:
+	return fsn_mark;
+}
+
+static struct fsnotify_mark *fanotify_add_inode_mark(struct fsnotify_group *group,
+						     struct inode *inode)
+{
+	struct fsnotify_mark *fsn_mark;
+
+	pr_debug("%s: group=%p inode=%p\n", __func__, group, inode);
 
 	fsn_mark = fsnotify_find_inode_mark(group, inode);
 	if (!fsn_mark) {
 		struct fsnotify_mark *new_fsn_mark;
+		int ret;
 
-		ret = -ENOMEM;
+		fsn_mark = ERR_PTR(-ENOMEM);
 		new_fsn_mark = kmem_cache_alloc(fanotify_mark_cache, GFP_KERNEL);
 		if (!new_fsn_mark)
 			goto out;
@@ -355,57 +433,60 @@ static int fanotify_add_mark(struct fsnotify_group *group,
 		fsnotify_init_mark(new_fsn_mark, fanotify_free_mark);
 		ret = fsnotify_add_mark(new_fsn_mark, group, inode, NULL, 0);
 		if (ret) {
+			fsn_mark = ERR_PTR(ret);
 			fanotify_free_mark(new_fsn_mark);
 			goto out;
 		}
 
 		fsn_mark = new_fsn_mark;
 	}
+out:
+	return fsn_mark;
+}
 
-	ret = 0;
+static int fanotify_add_mark(struct fsnotify_group *group, struct inode *inode,
+			     struct vfsmount *mnt, unsigned int flags, __u32 mask)
+{
+	struct fsnotify_mark *fsn_mark;
 
-	spin_lock(&fsn_mark->lock);
-	old_mask = fsn_mark->mask;
-	fsn_mark->mask |= mask;
-	new_mask = fsn_mark->mask;
-	spin_unlock(&fsn_mark->lock);
+	pr_debug("%s: group=%p inode=%p mnt=%p flags=%x mask=%x\n",
+		 __func__, group, inode, mnt, flags, mask);
 
-	/* we made changes to a mask, update the group mask and the inode mask
-	 * so things happen quickly. */
-	if (old_mask != new_mask) {
-		/* more bits in old than in new? */
-		int dropped = (old_mask & ~new_mask);
-		/* more bits in this mark than the inode's mask? */
-		int do_inode = (new_mask & ~inode->i_fsnotify_mask);
-		/* more bits in this mark than the group? */
-		int do_group = (new_mask & ~group->mask);
+	BUG_ON(inode && mnt);
+	BUG_ON(!inode && !mnt);
 
-		/* update the inode with this new mark */
-		if (dropped || do_inode)
-			fsnotify_recalc_inode_mask(inode);
+	if (inode)
+		fsn_mark = fanotify_add_inode_mark(group, inode);
+	else if (mnt)
+		fsn_mark = fanotify_add_vfsmount_mark(group, mnt);
+	else
+		BUG();
 
-		/* update the group mask with the new mask */
-		if (dropped || do_group)
-			fsnotify_recalc_group_mask(group);
-	}
+	if (IS_ERR(fsn_mark))
+		goto out;
+
+	fanotify_update_object_mask(group, inode, mnt, fsn_mark, flags, mask);
 
 	/* match the init or the find.... */
 	fsnotify_put_mark(fsn_mark);
 out:
-	return ret;
+	return PTR_ERR(fsn_mark);
 }
 
 static int fanotify_update_mark(struct fsnotify_group *group,
-				struct inode *inode, int flags,
-				__u32 mask)
+				struct inode *inode, struct vfsmount *mnt,
+				int flags, __u32 mask)
 {
-	pr_debug("%s: group=%p inode=%p flags=%x mask=%x\n", __func__,
-		 group, inode, flags, mask);
+	pr_debug("%s: group=%p inode=%p mnt=%p flags=%x mask=%x\n",
+		 __func__, group, inode, mnt, flags, mask);
+
+	BUG_ON(inode && mnt);
+	BUG_ON(!inode && !mnt);
 
 	if (flags & FAN_MARK_ADD)
-		fanotify_add_mark(group, inode, mask);
+		fanotify_add_mark(group, inode, mnt, flags, mask);
 	else if (flags & FAN_MARK_REMOVE)
-		fanotify_remove_mark(group, inode, mask);
+		fanotify_remove_mark(group, inode, mnt, flags, mask);
 	else
 		BUG();
 
@@ -507,7 +588,7 @@ SYSCALL_DEFINE(fanotify_mark)(int fanotify_fd, unsigned int flags,
 	group = filp->private_data;
 
 	/* create/update an inode mark */
-	ret = fanotify_update_mark(group, inode, flags, mask);
+	ret = fanotify_update_mark(group, inode, NULL, flags, mask);
 
 	path_put(&path);
 fput_and_out:

