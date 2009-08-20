Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbZHTOZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbZHTOZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 10:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbZHTOZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 10:25:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbZHTOZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 10:25:02 -0400
Subject: Re: kernel bug 2.6.31-rc6 (2)
From: Eric Paris <eparis@redhat.com>
To: christoph.thielecke@gmx.de
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200908200748.52348.christoph.thielecke@gmx.de>
References: <200908191448.50304.christoph.thielecke@gmx.de>
	 <1250720787.4198.2.camel@dhcp231-106.rdu.redhat.com>
	 <200908200748.52348.christoph.thielecke@gmx.de>
Content-Type: text/plain
Date: Thu, 20 Aug 2009 10:24:58 -0400
Message-Id: <1250778298.2168.2.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 07:48 +0200, Christoph Thielecke wrote:
> Hello Eric,
> 

> 
> The patch does not apply clean:

That's because I gave you a bad patch (it was against linux-next not
against Linus, sorry   :()

-Eric

---

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index dc32ed8..d8f73c2 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -431,80 +431,29 @@ static void inotify_free_mark(struct fsnotify_mark_entry *entry)
 	kmem_cache_free(inotify_inode_mark_cachep, ientry);
 }
 
-static int inotify_update_watch(struct fsnotify_group *group, struct inode *inode, u32 arg)
+static int inotify_update_existing_watch(struct fsnotify_group *group,
+					 struct inode *inode,
+					 u32 arg)
 {
-	struct fsnotify_mark_entry *entry = NULL;
+	struct fsnotify_mark_entry *entry;
 	struct inotify_inode_mark_entry *ientry;
-	struct inotify_inode_mark_entry *tmp_ientry;
-	int ret = 0;
-	int add = (arg & IN_MASK_ADD);
-	__u32 mask;
 	__u32 old_mask, new_mask;
+	__u32 mask;
+	int add = (arg & IN_MASK_ADD);
+	int ret;
 
 	/* don't allow invalid bits: we don't want flags set */
 	mask = inotify_arg_to_mask(arg);
 	if (unlikely(!mask))
 		return -EINVAL;
 
-	tmp_ientry = kmem_cache_alloc(inotify_inode_mark_cachep, GFP_KERNEL);
-	if (unlikely(!tmp_ientry))
-		return -ENOMEM;
-	/* we set the mask at the end after attaching it */
-	fsnotify_init_mark(&tmp_ientry->fsn_entry, inotify_free_mark);
-	tmp_ientry->wd = -1;
-
-find_entry:
 	spin_lock(&inode->i_lock);
 	entry = fsnotify_find_mark_entry(group, inode);
 	spin_unlock(&inode->i_lock);
-	if (entry) {
-		ientry = container_of(entry, struct inotify_inode_mark_entry, fsn_entry);
-	} else {
-		ret = -ENOSPC;
-		if (atomic_read(&group->inotify_data.user->inotify_watches) >= inotify_max_user_watches)
-			goto out_err;
-retry:
-		ret = -ENOMEM;
-		if (unlikely(!idr_pre_get(&group->inotify_data.idr, GFP_KERNEL)))
-			goto out_err;
-
-		spin_lock(&group->inotify_data.idr_lock);
-		ret = idr_get_new_above(&group->inotify_data.idr, &tmp_ientry->fsn_entry,
-					group->inotify_data.last_wd,
-					&tmp_ientry->wd);
-		spin_unlock(&group->inotify_data.idr_lock);
-		if (ret) {
-			if (ret == -EAGAIN)
-				goto retry;
-			goto out_err;
-		}
+	if (!entry)
+		return -ENOENT;
 
-		ret = fsnotify_add_mark(&tmp_ientry->fsn_entry, group, inode);
-		if (ret) {
-			inotify_remove_from_idr(group, tmp_ientry);
-			if (ret == -EEXIST)
-				goto find_entry;
-			goto out_err;
-		}
-
-		/* tmp_ientry has been added to the inode, so we are all set up.
-		 * now we just need to make sure tmp_ientry doesn't get freed and
-		 * we need to set up entry and ientry so the generic code can
-		 * do its thing. */
-		ientry = tmp_ientry;
-		entry = &ientry->fsn_entry;
-		tmp_ientry = NULL;
-
-		atomic_inc(&group->inotify_data.user->inotify_watches);
-
-		/* update the idr hint */
-		group->inotify_data.last_wd = ientry->wd;
-
-		/* we put the mark on the idr, take a reference */
-		fsnotify_get_mark(entry);
-	}
-
-	ret = ientry->wd;
+	ientry = container_of(entry, struct inotify_inode_mark_entry, fsn_entry);
 
 	spin_lock(&entry->lock);
 
@@ -536,18 +485,103 @@ retry:
 			fsnotify_recalc_group_mask(group);
 	}
 
-	/* this either matches fsnotify_find_mark_entry, or init_mark_entry
-	 * depending on which path we took... */
+	/* return the wd */
+	ret = ientry->wd;
+
+	/* match the get from fsnotify_find_mark_entry() */
 	fsnotify_put_mark(entry);
 
+	return ret;
+}
+
+static int inotify_new_watch(struct fsnotify_group *group,
+			     struct inode *inode,
+			     u32 arg)
+{
+	struct inotify_inode_mark_entry *tmp_ientry;
+	__u32 mask;
+	int ret;
+
+	/* don't allow invalid bits: we don't want flags set */
+	mask = inotify_arg_to_mask(arg);
+	if (unlikely(!mask))
+		return -EINVAL;
+
+	tmp_ientry = kmem_cache_alloc(inotify_inode_mark_cachep, GFP_KERNEL);
+	if (unlikely(!tmp_ientry))
+		return -ENOMEM;
+
+	fsnotify_init_mark(&tmp_ientry->fsn_entry, inotify_free_mark);
+	tmp_ientry->fsn_entry.mask = mask;
+	tmp_ientry->wd = -1;
+
+	ret = -ENOSPC;
+	if (atomic_read(&group->inotify_data.user->inotify_watches) >= inotify_max_user_watches)
+		goto out_err;
+retry:
+	ret = -ENOMEM;
+	if (unlikely(!idr_pre_get(&group->inotify_data.idr, GFP_KERNEL)))
+		goto out_err;
+
+	spin_lock(&group->inotify_data.idr_lock);
+	ret = idr_get_new_above(&group->inotify_data.idr, &tmp_ientry->fsn_entry,
+				group->inotify_data.last_wd,
+				&tmp_ientry->wd);
+	spin_unlock(&group->inotify_data.idr_lock);
+	if (ret) {
+		/* idr was out of memory allocate and try again */
+		if (ret == -EAGAIN)
+			goto retry;
+		goto out_err;
+	}
+
+	/* we are on the idr, now get on the inode */
+	ret = fsnotify_add_mark(&tmp_ientry->fsn_entry, group, inode);
+	if (ret) {
+		/* we failed to get on the inode, get off the idr */
+		inotify_remove_from_idr(group, tmp_ientry);
+		goto out_err;
+	}
+
+	/* we put the mark on the idr, take a reference */
+	fsnotify_get_mark(&tmp_ientry->fsn_entry);
+
+	/* update the idr hint, who cares about races, it's just a hint */
+	group->inotify_data.last_wd = tmp_ientry->wd;
+
+	/* increment the number of watches the user has */
+	atomic_inc(&group->inotify_data.user->inotify_watches);
+
+	/* return the watch descriptor for this new entry */
+	ret = tmp_ientry->wd;
+
+	/* match the ref from fsnotify_init_markentry() */
+	fsnotify_put_mark(&tmp_ientry->fsn_entry);
+
 out_err:
-	/* could be an error, could be that we found an existing mark */
-	if (tmp_ientry) {
-		/* on the idr but didn't make it on the inode */
-		if (tmp_ientry->wd != -1)
-			inotify_remove_from_idr(group, tmp_ientry);
+	if (ret < 0)
 		kmem_cache_free(inotify_inode_mark_cachep, tmp_ientry);
-	}
+
+	return ret;
+}
+
+static int inotify_update_watch(struct fsnotify_group *group, struct inode *inode, u32 arg)
+{
+	int ret = 0;
+
+retry:
+	/* try to update and existing watch with the new arg */
+	ret = inotify_update_existing_watch(group, inode, arg);
+	/* no mark present, try to add a new one */
+	if (ret == -ENOENT)
+		ret = inotify_new_watch(group, inode, arg);
+	/*
+	 * inotify_new_watch could race with another thread which did an
+	 * inotify_new_watch between the update_existing and the add watch
+	 * here, go back and try to update an existing mark again.
+	 */
+	if (ret == -EEXIST)
+		goto retry;
 
 	return ret;
 }


