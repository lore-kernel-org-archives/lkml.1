Return-Path: <linux-kernel-owner+w=401wt.eu-S965795AbXG3QXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965795AbXG3QXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938755AbXG3QPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:15:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:58715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932229AbXG3QOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:07 -0400
Message-Id: <20070730161323.796454518@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:30 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 07/26] VFS: Introduce dput() variante that maintains a kill-list
Content-Disposition: inline; filename=um/vfs-dput_freelist.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new variant of dput(). This becomes necessary to
prevent a recursive call to dput() from the union mount code.

  void __dput(struct dentry *dentry, struct list_head *list);

__dput() works mostly like the original dput() did. The main difference is
that it doesn't do a full d_kill() at the end but puts the dentry on a list as
soon as it isn't reachable anymore. Therefore the union mount code can savely
call __dput() when it wants to get rid of underlying dentry references during
a dput(). After calling __dput() the caller must make sure that on all
dentries __d_kill_final() is called. __d_kill_final() is actually doing the
dentry_iput() and is also dereferencing the parent.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/dcache.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 55 insertions(+), 5 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -129,19 +129,56 @@ static void dentry_iput(struct dentry * 
  *
  * If this is the root of the dentry tree, return NULL.
  */
-static struct dentry *d_kill(struct dentry *dentry)
+static struct dentry *__d_kill(struct dentry *dentry, struct list_head *list)
 {
 	struct dentry *parent;
 
 	list_del(&dentry->d_u.d_child);
 	dentry_stat.nr_dentry--;	/* For d_free, below */
-	/*drops the locks, at that point nobody can reach this dentry */
+
+	if (list) {
+		list_del_init(&dentry->d_alias);
+		/* at this point nobody can reach this dentry */
+		list_add(&dentry->d_lru, list);
+		spin_unlock(&dentry->d_lock);
+		spin_unlock(&dcache_lock);
+		return NULL;
+	}
+
+	/* drops the locks, at that point nobody can reach this dentry */
 	dentry_iput(dentry);
 	parent = dentry->d_parent;
 	d_free(dentry);
 	return dentry == parent ? NULL : parent;
 }
 
+void __dput(struct dentry *, struct list_head *);
+
+static void __d_kill_final(struct dentry *dentry, struct list_head *list)
+{
+	struct dentry *parent = dentry->d_parent;
+	struct inode *inode = dentry->d_inode;
+
+	if (inode) {
+		dentry->d_inode = NULL;
+		if (!inode->i_nlink)
+			fsnotify_inoderemove(inode);
+		if (dentry->d_op && dentry->d_op->d_iput)
+			dentry->d_op->d_iput(dentry, inode);
+		else
+			iput(inode);
+	}
+
+	d_free(dentry);
+	if (dentry != parent)
+		__dput(parent, list);
+}
+
+static struct dentry *d_kill(struct dentry *dentry)
+{
+	return __d_kill(dentry, NULL);
+}
+
 /* 
  * This is dput
  *
@@ -171,7 +208,7 @@ static struct dentry *d_kill(struct dent
  * no dcache lock, please.
  */
 
-void dput(struct dentry *dentry)
+void __dput(struct dentry *dentry, struct list_head *list)
 {
 	if (!dentry)
 		return;
@@ -215,14 +252,27 @@ kill_it:
 	 * delete it from there
 	 */
 	if (!list_empty(&dentry->d_lru)) {
-		list_del(&dentry->d_lru);
+		list_del_init(&dentry->d_lru);
 		dentry_stat.nr_unused--;
 	}
-	dentry = d_kill(dentry);
+
+	dentry = __d_kill(dentry, list);
 	if (dentry)
 		goto repeat;
 }
 
+void dput(struct dentry *dentry)
+{
+	LIST_HEAD(mortuary);
+
+	__dput(dentry, &mortuary);
+	while (!list_empty(&mortuary)) {
+		dentry = list_entry(mortuary.next, struct dentry, d_lru);
+		list_del(&dentry->d_lru);
+		__d_kill_final(dentry, &mortuary);
+	}
+}
+
 /**
  * d_invalidate - invalidate a dentry
  * @dentry: dentry to invalidate

-- 

