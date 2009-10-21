Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbZJUTaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbZJUTaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754935AbZJUTax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:30:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855AbZJUTUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:20:15 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>
Subject: [PATCH 05/41] VFS: Make real_lookup() return a struct path
Date: Wed, 21 Oct 2009 12:19:03 -0700
Message-Id: <1256152779-10054-6-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-5-git-send-email-vaurora@redhat.com>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
 <1256152779-10054-2-git-send-email-vaurora@redhat.com>
 <1256152779-10054-3-git-send-email-vaurora@redhat.com>
 <1256152779-10054-4-git-send-email-vaurora@redhat.com>
 <1256152779-10054-5-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

This patch changes real_lookup() into returning a struct path.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |   82 +++++++++++++++++++++++++++++++++++++----------------------
 1 files changed, 51 insertions(+), 31 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 9c9ecfa..a338496 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -462,10 +462,11 @@ ok:
  * make sure that nobody added the entry to the dcache in the meantime..
  * SMP-safe
  */
-static struct dentry * real_lookup(struct dentry * parent, struct qstr * name, struct nameidata *nd)
+static int real_lookup(struct nameidata *nd, struct qstr *name,
+		       struct path *path)
 {
-	struct dentry * result;
-	struct inode *dir = parent->d_inode;
+	struct inode *dir = nd->path.dentry->d_inode;
+	int res = 0;
 
 	mutex_lock(&dir->i_mutex);
 	/*
@@ -482,27 +483,36 @@ static struct dentry * real_lookup(struct dentry * parent, struct qstr * name, s
 	 *
 	 * so doing d_lookup() (with seqlock), instead of lockfree __d_lookup
 	 */
-	result = d_lookup(parent, name);
-	if (!result) {
+	path->dentry = d_lookup(nd->path.dentry, name);
+	path->mnt = nd->path.mnt;
+	if (!path->dentry) {
 		struct dentry *dentry;
 
 		/* Don't create child dentry for a dead directory. */
-		result = ERR_PTR(-ENOENT);
-		if (IS_DEADDIR(dir))
+		if (IS_DEADDIR(dir)) {
+			res = -ENOENT;
 			goto out_unlock;
+		}
 
-		dentry = d_alloc(parent, name);
-		result = ERR_PTR(-ENOMEM);
+		dentry = d_alloc(nd->path.dentry, name);
 		if (dentry) {
-			result = dir->i_op->lookup(dir, dentry, nd);
-			if (result)
+			path->dentry = dir->i_op->lookup(dir, dentry, nd);
+			if (path->dentry) {
 				dput(dentry);
-			else
-				result = dentry;
+				if (IS_ERR(path->dentry)) {
+					res = PTR_ERR(path->dentry);
+					path->dentry = NULL;
+					path->mnt = NULL;
+				}
+			} else
+				path->dentry = dentry;
+		} else {
+			res = -ENOMEM;
+			path->mnt = NULL;
 		}
 out_unlock:
 		mutex_unlock(&dir->i_mutex);
-		return result;
+		return res;
 	}
 
 	/*
@@ -510,12 +520,20 @@ out_unlock:
 	 * we waited on the semaphore. Need to revalidate.
 	 */
 	mutex_unlock(&dir->i_mutex);
-	if (result->d_op && result->d_op->d_revalidate) {
-		result = do_revalidate(result, nd);
-		if (!result)
-			result = ERR_PTR(-ENOENT);
+	if (path->dentry->d_op && path->dentry->d_op->d_revalidate) {
+		path->dentry = do_revalidate(path->dentry, nd);
+		if (!path->dentry) {
+			res = -ENOENT;
+			path->mnt = NULL;
+		}
+		if (IS_ERR(path->dentry)) {
+			res = PTR_ERR(path->dentry);
+			path->dentry = NULL;
+			path->mnt = NULL;
+		}
 	}
-	return result;
+
+	return res;
 }
 
 /*
@@ -785,35 +803,37 @@ static __always_inline void follow_dotdot(struct nameidata *nd)
 static int do_lookup(struct nameidata *nd, struct qstr *name,
 		     struct path *path)
 {
-	struct vfsmount *mnt = nd->path.mnt;
-	struct dentry *dentry = __d_lookup(nd->path.dentry, name);
+	int err;
 
-	if (!dentry)
+	path->dentry = __d_lookup(nd->path.dentry, name);
+	path->mnt = nd->path.mnt;
+	if (!path->dentry)
 		goto need_lookup;
-	if (dentry->d_op && dentry->d_op->d_revalidate)
+	if (path->dentry->d_op && path->dentry->d_op->d_revalidate)
 		goto need_revalidate;
+
 done:
-	path->mnt = mnt;
-	path->dentry = dentry;
 	__follow_mount(path);
 	return 0;
 
 need_lookup:
-	dentry = real_lookup(nd->path.dentry, name, nd);
-	if (IS_ERR(dentry))
+	err = real_lookup(nd, name, path);
+	if (err)
 		goto fail;
 	goto done;
 
 need_revalidate:
-	dentry = do_revalidate(dentry, nd);
-	if (!dentry)
+	path->dentry = do_revalidate(path->dentry, nd);
+	if (!path->dentry)
 		goto need_lookup;
-	if (IS_ERR(dentry))
+	if (IS_ERR(path->dentry)) {
+		err = PTR_ERR(path->dentry);
 		goto fail;
+	}
 	goto done;
 
 fail:
-	return PTR_ERR(dentry);
+	return err;
 }
 
 /*
-- 
1.6.3.3

