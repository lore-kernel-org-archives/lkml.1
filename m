Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbZGGCJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbZGGCJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 22:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbZGGCJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 22:09:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59190 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbZGGCJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 22:09:46 -0400
Subject: Re: Possible memory leak via inotify_add_watch
From: Eric Paris <eparis@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <b0943d9e0907061503r7a89a4e2lb5bc76b89e3e8ca6@mail.gmail.com>
References: <b0943d9e0907061503r7a89a4e2lb5bc76b89e3e8ca6@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 06 Jul 2009 22:09:31 -0400
Message-Id: <1246932571.2866.90.camel@dhcp235-23.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-06 at 23:03 +0100, Catalin Marinas wrote:
> Hi Eric,
> 
> I'm getting a few kmemleak reports like the one below (it may as well
> be just a false positive). All of these allocations happened during
> udevd.

Any chance you could give this a shot and see if it fixes it up for you?

-Eric

commit 27d13f5ef42fc4c976eae8318c860ea88c2076aa
Author: Eric Paris <eparis@redhat.com>
Date:   Mon Jul 6 22:07:19 2009 -0400

    inotify: do not leak inode marks on inotify_rm_watch
    
    inotify had a ref cnt problem and inode marks were being leaked when they
    were destroyed using inotify_rm_watch.
    
    Signed-off-by: Eric Paris <eparis@redhat.com>

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 2808e30..3ba2e1a 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -365,6 +365,17 @@ static int inotify_find_inode(const char __user *dirname, struct path *path, uns
 	return error;
 }
 
+static void inotify_remove_from_idr(struct fsnotify_group *group,
+				    struct inotify_inode_mark_entry *ientry)
+{
+	struct idr *idr;
+
+	spin_lock(&group->inotify_data.idr_lock);
+	idr = &group->inotify_data.idr;
+	idr_remove(idr, ientry->wd);
+	spin_unlock(&group->inotify_data.idr_lock);
+	ientry->wd = -1;
+}
 /*
  * Send IN_IGNORED for this wd, remove this wd from the idr, and drop the
  * internal reference help on the mark because it is in the idr.
@@ -375,7 +386,6 @@ void inotify_ignored_and_remove_idr(struct fsnotify_mark_entry *entry,
 	struct inotify_inode_mark_entry *ientry;
 	struct inotify_event_private_data *event_priv;
 	struct fsnotify_event_private_data *fsn_event_priv;
-	struct idr *idr;
 
 	ientry = container_of(entry, struct inotify_inode_mark_entry, fsn_entry);
 
@@ -397,10 +407,7 @@ void inotify_ignored_and_remove_idr(struct fsnotify_mark_entry *entry,
 skip_send_ignore:
 
 	/* remove this entry from the idr */
-	spin_lock(&group->inotify_data.idr_lock);
-	idr = &group->inotify_data.idr;
-	idr_remove(idr, ientry->wd);
-	spin_unlock(&group->inotify_data.idr_lock);
+	inotify_remove_from_idr(group, ientry);
 
 	/* removed from idr, drop that reference */
 	fsnotify_put_mark(entry);
@@ -422,6 +429,7 @@ static int inotify_update_watch(struct fsnotify_group *group, struct inode *inod
 {
 	struct fsnotify_mark_entry *entry = NULL;
 	struct inotify_inode_mark_entry *ientry;
+	struct inotify_inode_mark_entry *tmp_ientry;
 	int ret = 0;
 	int add = (arg & IN_MASK_ADD);
 	__u32 mask;
@@ -432,54 +440,65 @@ static int inotify_update_watch(struct fsnotify_group *group, struct inode *inod
 	if (unlikely(!mask))
 		return -EINVAL;
 
-	ientry = kmem_cache_alloc(inotify_inode_mark_cachep, GFP_KERNEL);
-	if (unlikely(!ientry))
+	tmp_ientry = kmem_cache_alloc(inotify_inode_mark_cachep, GFP_KERNEL);
+	if (unlikely(!tmp_ientry))
 		return -ENOMEM;
 	/* we set the mask at the end after attaching it */
-	fsnotify_init_mark(&ientry->fsn_entry, inotify_free_mark);
-	ientry->wd = 0;
+	fsnotify_init_mark(&tmp_ientry->fsn_entry, inotify_free_mark);
+	tmp_ientry->wd = -1;
 
 find_entry:
 	spin_lock(&inode->i_lock);
 	entry = fsnotify_find_mark_entry(group, inode);
 	spin_unlock(&inode->i_lock);
 	if (entry) {
-		kmem_cache_free(inotify_inode_mark_cachep, ientry);
 		ientry = container_of(entry, struct inotify_inode_mark_entry, fsn_entry);
 	} else {
-		if (atomic_read(&group->inotify_data.user->inotify_watches) >= inotify_max_user_watches) {
-			ret = -ENOSPC;
-			goto out_err;
-		}
-
-		ret = fsnotify_add_mark(&ientry->fsn_entry, group, inode, 0);
-		if (ret == -EEXIST)
-			goto find_entry;
-		else if (ret)
+		ret = -ENOSPC;
+		if (atomic_read(&group->inotify_data.user->inotify_watches) >= inotify_max_user_watches)
 			goto out_err;
-
-		entry = &ientry->fsn_entry;
 retry:
 		ret = -ENOMEM;
 		if (unlikely(!idr_pre_get(&group->inotify_data.idr, GFP_KERNEL)))
 			goto out_err;
 
 		spin_lock(&group->inotify_data.idr_lock);
-		/* if entry is added to the idr we keep the reference obtained
-		 * through fsnotify_mark_add.  remember to drop this reference
-		 * when entry is removed from idr */
-		ret = idr_get_new_above(&group->inotify_data.idr, entry,
-					++group->inotify_data.last_wd,
-					&ientry->wd);
+		ret = idr_get_new_above(&group->inotify_data.idr, &tmp_ientry->fsn_entry,
+					group->inotify_data.last_wd,
+					&tmp_ientry->wd);
+
 		spin_unlock(&group->inotify_data.idr_lock);
 		if (ret) {
 			if (ret == -EAGAIN)
 				goto retry;
 			goto out_err;
 		}
+
+		ret = fsnotify_add_mark(&tmp_ientry->fsn_entry, group, inode, 0);
+		if (ret) {
+			inotify_remove_from_idr(group, tmp_ientry);
+			if (ret == -EEXIST)
+				goto find_entry;
+			goto out_err;
+		}
+
+		/* tmp_ientry has been added to the inode, so we are all set up.
+		 * now we just need to make sure tmp_ientry doesn't get freed and
+		 * we need to set up entry and ientry so the generic code can
+		 * do its thing. */
+		ientry = tmp_ientry;
+		entry = &ientry->fsn_entry;
+		tmp_ientry = NULL;
 		atomic_inc(&group->inotify_data.user->inotify_watches);
+
+		group->inotify_data.last_wd = ientry->wd;
+
+		/* since this mark is on the idr, we should hold a reference */
+		fsnotify_get_mark(entry);
 	}
 
+	ret = ientry->wd;
+
 	spin_lock(&entry->lock);
 
 	old_mask = entry->mask;
@@ -510,14 +529,18 @@ retry:
 			fsnotify_recalc_group_mask(group);
 	}
 
-	return ientry->wd;
-
+	/* this either matches fsnotify_find_mark_entry, or init_mark_entry
+	 * depending on which path we took... */
+	fsnotify_put_mark(entry);
 out_err:
-	/* see this isn't supposed to happen, just kill the watch */
-	if (entry) {
-		fsnotify_destroy_mark_by_entry(entry);
-		fsnotify_put_mark(entry);
+	/* could be an error, could be that we found an existing mark */
+	if (tmp_ientry) {
+		/* on the idr but didn't make it on the inode */
+		if (tmp_ientry->wd != -1)
+			inotify_remove_from_idr(group, tmp_ientry);
+		kmem_cache_free(inotify_inode_mark_cachep, tmp_ientry);
 	}
+
 	return ret;
 }
 


