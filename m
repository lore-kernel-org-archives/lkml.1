Return-Path: <linux-kernel-owner+w=401wt.eu-S932108AbXFTFqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbXFTFqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 01:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756835AbXFTFqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 01:46:09 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53723 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801AbXFTFqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 01:46:05 -0400
Date: Wed, 20 Jun 2007 11:23:26 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jan Blunck <j.blunck@tu-harburg.de>
Subject: [RFC PATCH 3/4] Lookup changes to support union mount.
Message-ID: <20070620055326.GE4267@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070620055050.GB4267@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070620055050.GB4267@in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Lookup changes to support union mount.

Adds support for looking up dentries inside a union mount point.

This patch modifies the do_lookup() routine to look beyond the top layer for
union mount points/directories. Union mount versions of dcache and real lookup
routines are added to support this. The lookup routines are modified to build a
new union stack when looking up a common named directory in the union stack.

TODO: Check if lookup_hash() and friends also need to know about union mount.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 fs/dcache.c            |   53 ++++++++++++++++++
 fs/namei.c             |  137 +++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/dcache.h |    1 
 3 files changed, 187 insertions(+), 4 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1312,6 +1312,59 @@ next:
  	return found;
 }
 
+/*
+ * Looks for the given @name in dcache by walking through all the layers
+ * of the union stack, starting from the top.
+ * FIXME: If we don't find the dentry in a upper layer, we descend to the
+ * next layer. So there is a chance to miss this dentry in the top layer
+ * if this is the _first_ time lookup of the dentry in this layer. A real
+ * lookup might have fetched a valid dentry in this layer itself, while we
+ * chose to descend to the next lower layer. One solution is not have this
+ * function itself, do the toplevel lookup in dcache and if it fails proceed
+ * to real_lookup_union() directly.
+ */
+struct dentry *__d_lookup_union(struct nameidata *nd, struct qstr *name)
+{
+	struct dentry *dentry;
+	struct nameidata nd_tmp;
+	struct vfsmount *mnt = mntget(nd->mnt);
+	struct qstr this;
+	int err;
+
+	nd_tmp.mnt = nd->mnt;
+	nd_tmp.dentry = nd->dentry;
+
+	this.name = name->name;
+	this.len = name->len;
+	this.hash = name->hash;
+
+	do {
+		/* d_hash() is a repetition for the top layer. */
+		if (nd_tmp.dentry->d_op && nd_tmp.dentry->d_op->d_hash) {
+			err = nd_tmp.dentry->d_op->d_hash(nd_tmp.dentry, &this);
+			if (err < 0)
+				goto out;
+		}
+
+		dentry = __d_lookup(nd_tmp.dentry, &this);
+		if (dentry) {
+			if (dentry->d_inode) {
+				if (nd->mnt != nd_tmp.mnt) {
+					mntput(nd->mnt);
+					nd->mnt = mntget(nd_tmp.mnt);
+				}
+				mntput(mnt);
+				return dentry;
+			} else {
+				dput(dentry);
+			}
+		}
+	} while (next_union_mount(&nd_tmp));
+out:
+	mntput(mnt);
+	return NULL;
+}
+
 /**
  * d_hash_and_lookup - hash the qstr then search for a dentry
  * @dir: Directory to search in
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -515,6 +515,127 @@ static struct dentry * real_lookup(struc
 	return result;
 }
 
+/*
+ * Walks down the parent's union stack looking for the given @name.
+ * Builds unions at subdirectory levels if needed.
+ */
+static struct dentry *real_lookup_union(struct nameidata *nd, struct qstr *name)
+{
+	struct dentry *dentry, *topmost, *prev = NULL;
+	struct nameidata nd_tmp;
+	struct vfsmount *mnt_prev = NULL;
+	struct vfsmount *mnt = mntget(nd->mnt);
+
+	topmost = real_lookup(nd->dentry, name, nd);
+	if (IS_ERR(topmost))
+		goto out;
+
+	/* Found a vaild non-directory dentry in the topmost layer, return. */
+	if (topmost->d_inode && !S_ISDIR(topmost->d_inode->i_mode))
+		goto out;
+
+	nd_tmp.mnt = nd->mnt;
+	nd_tmp.dentry = nd->dentry;
+
+	/*
+	 * At this point we either have a negative dentry or a directory
+	 * as the topmost dentry. Continue to lookup in the bottom layers.
+	 */
+	while (next_union_mount(&nd_tmp)) {
+		dentry = real_lookup(nd_tmp.dentry, name, &nd_tmp);
+		/*
+		 * If there is an error, return the dentry from
+		 * the topmost layer.
+		 */
+		if (IS_ERR(dentry))
+			goto out;
+
+		/*
+		 * Found a negative dentry in this layer, release it and
+		 * continue with the next layer.
+		 */
+		if (!dentry->d_inode) {
+			dput(dentry);
+			continue;
+		}
+
+		/*
+		 * If we find a vaild non-directory dentry in this layer, And
+		 * - if the topmost dentry is negative, return this.
+		 * - or if the topmost dentry is valid (dir), return topmost.
+		 */
+		if (!S_ISDIR(dentry->d_inode->i_mode)) {
+			if (!topmost->d_inode) {
+				mntput(nd->mnt);
+				nd->mnt = mntget(nd_tmp.mnt);
+				dput(topmost);
+				topmost = dentry;
+			} else {
+				dput(dentry);
+			}
+			goto out;
+		}
+
+		/*
+		 * At this point, we have a directory in this layer. And
+		 * - if the topmost dentry is negative, make this directory
+		 * the topmost dentry.
+		 * - or if topmost dentry is valid, union the two directories.
+		 */
+		if (!topmost->d_inode) {
+			mntput(nd->mnt);
+			nd->mnt = mntget(nd_tmp.mnt);
+			dput(topmost);
+			topmost = dget(dentry);
+		} else {
+			struct union_mount *u;
+			struct dentry *top_dentry = prev ? prev : topmost;
+			struct vfsmount *top_mnt = mnt_prev ? mnt_prev :
+							nd->mnt;
+			u = alloc_union_mount(top_mnt, top_dentry, nd_tmp.mnt,
+						dentry);
+			if (!u) {
+				dput(dentry);
+				goto out;
+			}
+			spin_lock(&vfsmount_lock);
+			attach_mnt_union(u);
+			spin_unlock(&vfsmount_lock);
+			/*
+			 * If the lower layer we found has a layer below
+			 * it, no need to continue the lookup, return
+			 * with the topmost we found.
+			 * Else remember this layer so that this becomes
+			 * the top layer for the next union.
+			 */
+			if (next_union_mount_exists(nd_tmp.mnt, dentry)) {
+				dput(dentry);
+				goto out;
+			} else {
+				if (prev)
+					dput(prev);
+				prev = dget(dentry);
+				if (mnt_prev)
+					mntput(mnt_prev);
+				mnt_prev = mntget(nd_tmp.mnt);
+			}
+		}
+
+		/*
+		 * Release the dentry from this layer and continue
+		 * the lookup in the next lower layer.
+		 */
+		dput(dentry);
+	}
+out:
+	if (prev)
+		dput(prev);
+	if (mnt_prev)
+		mntput(mnt_prev);
+	mntput(mnt);
+	return topmost;
+}
+
 static int __emul_lookup_dentry(const char *, struct nameidata *);
 
 /* SMP-safe */
@@ -769,21 +890,29 @@ static __always_inline void follow_dotdo
 static int do_lookup(struct nameidata *nd, struct qstr *name,
 		     struct path *path)
 {
-	struct vfsmount *mnt = nd->mnt;
-	struct dentry *dentry = __d_lookup(nd->dentry, name);
+	struct dentry *dentry;
+
+	if (IS_MNT_UNION(nd->mnt))
+		dentry = __d_lookup_union(nd, name);
+	else
+		dentry = __d_lookup(nd->dentry, name);
 
 	if (!dentry)
 		goto need_lookup;
 	if (dentry->d_op && dentry->d_op->d_revalidate)
 		goto need_revalidate;
 done:
-	path->mnt = mnt;
+	path->mnt = nd->mnt;
 	path->dentry = dentry;
 	__follow_mount(path);
 	return 0;
 
 need_lookup:
-	dentry = real_lookup(nd->dentry, name, nd);
+	if (IS_MNT_UNION(nd->mnt))
+		dentry = real_lookup_union(nd, name);
+	else
+		dentry = real_lookup(nd->dentry, name, nd);
+
 	if (IS_ERR(dentry))
 		goto fail;
 	goto done;
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -289,6 +289,7 @@ extern void d_move(struct dentry *, stru
 /* appendix may either be NULL or be used for transname suffixes */
 extern struct dentry * d_lookup(struct dentry *, struct qstr *);
 extern struct dentry * __d_lookup(struct dentry *, struct qstr *);
+extern struct dentry *__d_lookup_union(struct nameidata *nd, struct qstr *name);
 extern struct dentry * d_hash_and_lookup(struct dentry *, struct qstr *);
 
 /* validate "insecure" dentry pointer */
