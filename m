Return-Path: <linux-kernel-owner+w=401wt.eu-S932251AbZJUT0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbZJUT0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbZJUTZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:25:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866AbZJUTVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:21:10 -0400
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
Subject: [PATCH 24/41] union-mount: Make lookup work for union-mounted file systems
Date: Wed, 21 Oct 2009 12:19:22 -0700
Message-Id: <1256152779-10054-25-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-24-git-send-email-vaurora@redhat.com>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
 <1256152779-10054-2-git-send-email-vaurora@redhat.com>
 <1256152779-10054-3-git-send-email-vaurora@redhat.com>
 <1256152779-10054-4-git-send-email-vaurora@redhat.com>
 <1256152779-10054-5-git-send-email-vaurora@redhat.com>
 <1256152779-10054-6-git-send-email-vaurora@redhat.com>
 <1256152779-10054-7-git-send-email-vaurora@redhat.com>
 <1256152779-10054-8-git-send-email-vaurora@redhat.com>
 <1256152779-10054-9-git-send-email-vaurora@redhat.com>
 <1256152779-10054-10-git-send-email-vaurora@redhat.com>
 <1256152779-10054-11-git-send-email-vaurora@redhat.com>
 <1256152779-10054-12-git-send-email-vaurora@redhat.com>
 <1256152779-10054-13-git-send-email-vaurora@redhat.com>
 <1256152779-10054-14-git-send-email-vaurora@redhat.com>
 <1256152779-10054-15-git-send-email-vaurora@redhat.com>
 <1256152779-10054-16-git-send-email-vaurora@redhat.com>
 <1256152779-10054-17-git-send-email-vaurora@redhat.com>
 <1256152779-10054-18-git-send-email-vaurora@redhat.com>
 <1256152779-10054-19-git-send-email-vaurora@redhat.com>
 <1256152779-10054-20-git-send-email-vaurora@redhat.com>
 <1256152779-10054-21-git-send-email-vaurora@redhat.com>
 <1256152779-10054-22-git-send-email-vaurora@redhat.com>
 <1256152779-10054-23-git-send-email-vaurora@redhat.com>
 <1256152779-10054-24-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

On union-mounted file systems the lookup function must also visit lower layers
of the union-stack when doing a lookup. This patches add support for
union-mounts to cached lookups and real lookups.

We have 3 different styles of lookup functions now:
- multiple pathname components, follow mounts, follow union, follow symlinks
- single pathname component, doesn't follow mounts, follow union, doesn't
  follow symlinks
- single pathname component doesn't follow mounts, doesn't follow unions,
  doesn't follow symlinks

XXX - Needs to be re-organized to reduce code duplication.  But how?

- Create shared lookup_topmost() and build_union() functions that take
  flags or function pointers for real_lookup(), cache_lookup(), etc.
- Push union code farther down into cache_lookup(), etc.
- (your idea here)

XXX - Symlinks to other file systems (and probably submounts) don't
work - see comment in do_lookup().

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c            |  483 ++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/namei.h |    6 +
 2 files changed, 481 insertions(+), 8 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 408380d..b279686 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -33,6 +33,7 @@
 #include <linux/fcntl.h>
 #include <linux/device_cgroup.h>
 #include <linux/fs_struct.h>
+#include <linux/union.h>
 #include <asm/uaccess.h>
 
 #define ACC_MODE(x) ("\000\004\002\006"[(x)&O_ACCMODE])
@@ -415,6 +416,173 @@ static struct dentry *cache_lookup(struct dentry *parent, struct qstr *name,
 	return dentry;
 }
 
+/**
+ * __cache_lookup_topmost - lookup the topmost (non-)negative dentry
+ *
+ * @nd - parent's nameidata
+ * @name - pathname part to lookup
+ * @path - found dentry for pathname part
+ *
+ * This is used for union mount lookups from dcache. The first non-negative
+ * dentry is searched on all layers of the union stack. Otherwise the topmost
+ * negative dentry is returned.
+ */
+static int __cache_lookup_topmost(struct nameidata *nd, struct qstr *name,
+				  struct path *path)
+{
+	struct dentry *dentry;
+
+	dentry = d_lookup(nd->path.dentry, name);
+	if (dentry && dentry->d_op && dentry->d_op->d_revalidate)
+		dentry = do_revalidate(dentry, nd);
+
+	/*
+	 * Remember the topmost negative dentry in case we don't find anything
+	 */
+	path->dentry = dentry;
+	path->mnt = dentry ? nd->path.mnt : NULL;
+
+	if (!dentry || dentry->d_inode)
+		return !dentry;
+
+	/* look for the first non-negative dentry */
+
+	while (follow_union_down(&nd->path.mnt, &nd->path.dentry)) {
+		dentry = d_hash_and_lookup(nd->path.dentry, name);
+
+		/*
+		 * If parts of the union stack are not in the dcache we need
+		 * to do a real lookup
+		 */
+		if (!dentry)
+			goto out_dput;
+
+		/*
+		 * If parts of the union don't survive the revalidation we
+		 * need to do a real lookup
+		 */
+		if (dentry->d_op && dentry->d_op->d_revalidate) {
+			dentry = do_revalidate(dentry, nd);
+			if (!dentry)
+				goto out_dput;
+		}
+
+		if (dentry->d_inode)
+			goto out_dput;
+
+		dput(dentry);
+	}
+
+	return !dentry;
+
+out_dput:
+	dput(path->dentry);
+	path->dentry = dentry;
+	path->mnt = dentry ? mntget(nd->path.mnt) : NULL;
+	return !dentry;
+}
+
+/**
+ * __cache_lookup_build_union - build the union stack for this part,
+ * cached version
+ *
+ * This is called after you have the topmost dentry in @path.
+ */
+static int __cache_lookup_build_union(struct nameidata *nd, struct qstr *name,
+				      struct path *path)
+{
+	struct path last = *path;
+	struct dentry *dentry;
+
+	while (follow_union_down(&nd->path.mnt, &nd->path.dentry)) {
+		dentry = d_hash_and_lookup(nd->path.dentry, name);
+		if (!dentry)
+			return 1;
+
+		if (dentry->d_op && dentry->d_op->d_revalidate) {
+			dentry = do_revalidate(dentry, nd);
+			if (!dentry)
+				return 1;
+		}
+
+		if (!dentry->d_inode) {
+			dput(dentry);
+			continue;
+		}
+
+		/* only directories can be part of a union stack */
+		if (!S_ISDIR(dentry->d_inode->i_mode)) {
+			dput(dentry);
+			break;
+		}
+
+		/* Add the newly discovered dir to the union stack */
+		append_to_union(last.mnt, last.dentry, nd->path.mnt, dentry);
+
+		if (last.dentry != path->dentry)
+			path_put(&last);
+		last.dentry = dentry;
+		last.mnt = mntget(nd->path.mnt);
+	}
+
+	if (last.dentry != path->dentry)
+		path_put(&last);
+
+	return 0;
+}
+
+/**
+ * cache_lookup_union - lookup a single pathname part from dcache
+ *
+ * This is a union mount capable version of what d_lookup() & revalidate()
+ * would do. This function returns a valid (union) dentry on success.
+ *
+ * Remember: On failure it means that parts of the union aren't cached. You
+ * should call real_lookup() afterwards to find the proper (union) dentry.
+ */
+static int cache_lookup_union(struct nameidata *nd, struct qstr *name,
+			      struct path *path)
+{
+	int res ;
+
+	if (!IS_MNT_UNION(nd->path.mnt)) {
+		path->dentry = cache_lookup(nd->path.dentry, name, nd);
+		path->mnt = path->dentry ? nd->path.mnt : NULL;
+		res = path->dentry ? 0 : 1;
+	} else {
+		struct path safe = {
+			.dentry = nd->path.dentry,
+			.mnt = nd->path.mnt
+		};
+
+		path_get(&safe);
+		res = __cache_lookup_topmost(nd, name, path);
+		if (res)
+			goto out;
+
+		/* only directories can be part of a union stack */
+		if (!path->dentry->d_inode ||
+		    !S_ISDIR(path->dentry->d_inode->i_mode))
+			goto out;
+
+		/* Build the union stack for this part */
+		res = __cache_lookup_build_union(nd, name, path);
+		if (res) {
+			dput(path->dentry);
+			if (path->mnt != safe.mnt)
+				mntput(path->mnt);
+			goto out;
+		}
+
+out:
+		path_put(&nd->path);
+		nd->path.dentry = safe.dentry;
+		nd->path.mnt = safe.mnt;
+	}
+
+	return res;
+}
+
 /*
  * Short-cut version of permission(), for calling by
  * path_walk(), when dcache lock is held.  Combines parts
@@ -536,6 +704,146 @@ out_unlock:
 	return res;
 }
 
+/**
+ * __real_lookup_topmost - lookup topmost dentry, non-cached version
+ *
+ * If we reach a dentry with restricted access, we just stop the lookup
+ * because we shouldn't see through that dentry. Same thing for dentry
+ * type mismatch and whiteouts.
+ *
+ * FIXME:
+ * - handle DT_WHT
+ * - handle union stacks in use
+ * - handle union stacks mounted upon union stacks
+ * - avoid unnecessary allocations of union locks
+ */
+static int __real_lookup_topmost(struct nameidata *nd, struct qstr *name,
+				 struct path *path)
+{
+	struct path next;
+	int err;
+
+	err = real_lookup(nd, name, path);
+	if (err)
+		return err;
+
+	if (path->dentry->d_inode)
+		return 0;
+
+	while (follow_union_down(&nd->path.mnt, &nd->path.dentry)) {
+		name->hash = full_name_hash(name->name, name->len);
+		if (nd->path.dentry->d_op && nd->path.dentry->d_op->d_hash) {
+			err = nd->path.dentry->d_op->d_hash(nd->path.dentry,
+							    name);
+			if (err < 0)
+				goto out;
+		}
+
+		err = real_lookup(nd, name, &next);
+		if (err)
+			goto out;
+
+		if (next.dentry->d_inode) {
+			dput(path->dentry);
+			mntget(next.mnt);
+			*path = next;
+			goto out;
+		}
+
+		dput(next.dentry);
+	}
+out:
+	if (err)
+		dput(path->dentry);
+	return err;
+}
+
+/**
+ * __real_lookup_build_union: build the union stack for this pathname
+ * part, non-cached version
+ *
+ * Called when not all parts of the union stack are in cache
+ */
+
+static int __real_lookup_build_union(struct nameidata *nd, struct qstr *name,
+				     struct path *path)
+{
+	struct path last = *path;
+	struct path next;
+	int err = 0;
+
+	while (follow_union_down(&nd->path.mnt, &nd->path.dentry)) {
+		/* We need to recompute the hash for lower layer lookups */
+		name->hash = full_name_hash(name->name, name->len);
+		if (nd->path.dentry->d_op && nd->path.dentry->d_op->d_hash) {
+			err = nd->path.dentry->d_op->d_hash(nd->path.dentry,
+							    name);
+			if (err < 0)
+				goto out;
+		}
+
+		err = real_lookup(nd, name, &next);
+		if (err)
+			goto out;
+
+		if (!next.dentry->d_inode) {
+			dput(next.dentry);
+			continue;
+		}
+
+		/* only directories can be part of a union stack */
+		if (!S_ISDIR(next.dentry->d_inode->i_mode)) {
+			dput(next.dentry);
+			break;
+		}
+
+		/* now we know we found something "real" */
+		append_to_union(last.mnt, last.dentry, next.mnt, next.dentry);
+
+		if (last.dentry != path->dentry)
+			path_put(&last);
+		last.dentry = next.dentry;
+		last.mnt = mntget(next.mnt);
+	}
+
+	if (last.dentry != path->dentry)
+		path_put(&last);
+out:
+	return err;
+}
+
+static int real_lookup_union(struct nameidata *nd, struct qstr *name,
+			     struct path *path)
+{
+	struct path safe = { .dentry = nd->path.dentry, .mnt = nd->path.mnt };
+	int res ;
+
+	path_get(&safe);
+	res = __real_lookup_topmost(nd, name, path);
+	if (res)
+		goto out;
+
+	/* only directories can be part of a union stack */
+	if (!path->dentry->d_inode ||
+	    !S_ISDIR(path->dentry->d_inode->i_mode))
+		goto out;
+
+	/* Build the union stack for this part */
+	res = __real_lookup_build_union(nd, name, path);
+	if (res) {
+		dput(path->dentry);
+		if (path->mnt != safe.mnt)
+			mntput(path->mnt);
+		goto out;
+	}
+
+out:
+	path_put(&nd->path);
+	nd->path.dentry = safe.dentry;
+	nd->path.mnt = safe.mnt;
+	return res;
+}
+
 /*
  * Wrapper to retry pathname resolution whenever the underlying
  * file system returns an ESTALE.
@@ -790,6 +1098,7 @@ static __always_inline void follow_dotdot(struct nameidata *nd)
 		nd->path.mnt = parent;
 	}
 	follow_mount(&nd->path);
+	follow_union_mount(&nd->path.mnt, &nd->path.dentry);
 }
 
 /*
@@ -802,6 +1111,9 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 {
 	int err;
 
+	if (IS_MNT_UNION(nd->path.mnt))
+		goto need_union_lookup;
+
 	path->dentry = __d_lookup(nd->path.dentry, name);
 	path->mnt = nd->path.mnt;
 	if (!path->dentry)
@@ -810,7 +1122,25 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 		goto need_revalidate;
 
 done:
-	__follow_mount(path);
+	if (nd->path.mnt != path->mnt) {
+		/*
+		 * XXX FIXME: We only want to set this flag if we
+		 * crossed from the top layer to the bottom layer of a
+		 * union mount.  But nd->path.mnt != path->mnt is also
+		 * true when we cross from the top layer of a union
+		 * mount to another file system, either by symlink or
+		 * file system mounted on a directory in the union
+		 * mount (probably - haven't tested).
+		 *
+		 * This might be an issue for every mnt/mnt comparison
+		 * - or maybe just during the brief window between
+		 * do_lookup() and do_follow_link() or follow_mount().
+		 */
+		nd->um_flags |= LAST_LOWLEVEL;
+		follow_mount(path);
+	} else
+		__follow_mount(path);
+	follow_union_mount(&path->mnt, &path->dentry);
 	return 0;
 
 need_lookup:
@@ -819,6 +1149,16 @@ need_lookup:
 		goto fail;
 	goto done;
 
+need_union_lookup:
+	err = cache_lookup_union(nd, name, path);
+	if (!err && path->dentry)
+		goto done;
+
+	err = real_lookup_union(nd, name, path);
+	if (err)
+		goto fail;
+	goto done;
+
 need_revalidate:
 	path->dentry = do_revalidate(path->dentry, nd);
 	if (!path->dentry)
@@ -857,6 +1197,8 @@ static int __link_path_walk(const char *name, struct nameidata *nd)
 	if (nd->depth)
 		lookup_flags = LOOKUP_FOLLOW | (nd->flags & LOOKUP_CONTINUE);
 
+	follow_union_mount(&nd->path.mnt, &nd->path.dentry);
+
 	/* At this point we know we have a real path component. */
 	for(;;) {
 		unsigned long hash;
@@ -1041,6 +1383,7 @@ static int path_init(int dfd, const char *name, unsigned int flags, struct namei
 
 	nd->last_type = LAST_ROOT; /* if there are only slashes... */
 	nd->flags = flags;
+	nd->um_flags = 0;
 	nd->depth = 0;
 	nd->root.mnt = NULL;
 
@@ -1249,6 +1592,130 @@ static int lookup_hash(struct nameidata *nd, struct qstr *name,
 	return err;
 }
 
+static int __hash_lookup_topmost(struct nameidata *nd, struct qstr *name,
+				 struct path *path)
+{
+	struct path next;
+	int err;
+
+	err = lookup_hash(nd, name, path);
+	if (err)
+		return err;
+
+	if (path->dentry->d_inode)
+		return 0;
+
+	while (follow_union_down(&nd->path.mnt, &nd->path.dentry)) {
+		name->hash = full_name_hash(name->name, name->len);
+		if (nd->path.dentry->d_op && nd->path.dentry->d_op->d_hash) {
+			err = nd->path.dentry->d_op->d_hash(nd->path.dentry,
+							    name);
+			if (err < 0)
+				goto out;
+		}
+
+		mutex_lock(&nd->path.dentry->d_inode->i_mutex);
+		err = lookup_hash(nd, name, &next);
+		mutex_unlock(&nd->path.dentry->d_inode->i_mutex);
+		if (err)
+			goto out;
+
+		if (next.dentry->d_inode) {
+			dput(path->dentry);
+			mntget(next.mnt);
+			*path = next;
+			goto out;
+		}
+
+		dput(next.dentry);
+	}
+out:
+	if (err)
+		dput(path->dentry);
+	return err;
+}
+
+static int __hash_lookup_build_union(struct nameidata *nd, struct qstr *name,
+				     struct path *path)
+{
+	struct path last = *path;
+	struct path next;
+	int err = 0;
+
+	while (follow_union_down(&nd->path.mnt, &nd->path.dentry)) {
+		/* We need to recompute the hash for lower layer lookups */
+		name->hash = full_name_hash(name->name, name->len);
+		if (nd->path.dentry->d_op && nd->path.dentry->d_op->d_hash) {
+			err = nd->path.dentry->d_op->d_hash(nd->path.dentry,
+							    name);
+			if (err < 0)
+				goto out;
+		}
+
+		mutex_lock(&nd->path.dentry->d_inode->i_mutex);
+		err = lookup_hash(nd, name, &next);
+		mutex_unlock(&nd->path.dentry->d_inode->i_mutex);
+		if (err)
+			goto out;
+
+		if (!next.dentry->d_inode) {
+			dput(next.dentry);
+			continue;
+		}
+
+		/* only directories can be part of a union stack */
+		if (!S_ISDIR(next.dentry->d_inode->i_mode)) {
+			dput(next.dentry);
+			break;
+		}
+
+		/* now we know we found something "real" */
+		append_to_union(last.mnt, last.dentry, next.mnt, next.dentry);
+
+		if (last.dentry != path->dentry)
+			path_put(&last);
+		last.dentry = next.dentry;
+		last.mnt = mntget(next.mnt);
+	}
+
+	if (last.dentry != path->dentry)
+		path_put(&last);
+out:
+	return err;
+}
+
+static int hash_lookup_union(struct nameidata *nd, struct qstr *name,
+			     struct path *path)
+{
+	struct path safe = { .dentry = nd->path.dentry, .mnt = nd->path.mnt };
+	int res ;
+
+	path_get(&safe);
+	res = __hash_lookup_topmost(nd, name, path);
+	if (res)
+		goto out;
+
+	/* only directories can be part of a union stack */
+	if (!path->dentry->d_inode ||
+	    !S_ISDIR(path->dentry->d_inode->i_mode))
+		goto out;
+
+	/* Build the union stack for this part */
+	res = __hash_lookup_build_union(nd, name, path);
+	if (res) {
+		dput(path->dentry);
+		if (path->mnt != safe.mnt)
+			mntput(path->mnt);
+		goto out;
+	}
+
+out:
+	path_put(&nd->path);
+	nd->path.dentry = safe.dentry;
+	nd->path.mnt = safe.mnt;
+	return res;
+}
+
 static int __lookup_one_len(const char *name, struct qstr *this,
 		struct dentry *base, int len)
 {
@@ -1756,7 +2223,7 @@ struct file *do_filp_open(int dfd, const char *pathname,
 	if (flag & O_EXCL)
 		nd.flags |= LOOKUP_EXCL;
 	mutex_lock(&dir->d_inode->i_mutex);
-	error = lookup_hash(&nd, &nd.last, &path);
+	error = hash_lookup_union(&nd, &nd.last, &path);
 
 do_last:
 	if (error) {
@@ -1920,7 +2387,7 @@ do_link:
 	}
 	dir = nd.path.dentry;
 	mutex_lock(&dir->d_inode->i_mutex);
-	error = lookup_hash(&nd, &nd.last, &path);
+	error = hash_lookup_union(&nd, &nd.last, &path);
 	__putname(nd.last.name);
 	goto do_last;
 }
@@ -1971,7 +2438,7 @@ struct dentry *lookup_create(struct nameidata *nd, int is_dir)
 	/*
 	 * Do the final lookup.
 	 */
-	err = lookup_hash(nd, &nd->last, &path);
+	err = hash_lookup_union(nd, &nd->last, &path);
 	if (err) {
 		path.dentry = ERR_PTR(err);
 		goto fail;
@@ -2467,7 +2934,7 @@ static long do_rmdir(int dfd, const char __user *pathname)
 	nd.flags &= ~LOOKUP_PARENT;
 
 	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
-	error = lookup_hash(&nd, &nd.last, &path);
+	error = hash_lookup_union(&nd, &nd.last, &path);
 	if (error)
 		goto exit2;
 	error = mnt_want_write(nd.path.mnt);
@@ -2550,7 +3017,7 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 	nd.flags &= ~LOOKUP_PARENT;
 
 	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
-	error = lookup_hash(&nd, &nd.last, &path);
+	error = hash_lookup_union(&nd, &nd.last, &path);
 	if (!error) {
 		/* Why not before? Because we want correct error value */
 		if (nd.last.name[nd.last.len])
@@ -2954,7 +3421,7 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 
 	trap = lock_rename(new_dir, old_dir);
 
-	error = lookup_hash(&oldnd, &oldnd.last, &old);
+	error = hash_lookup_union(&oldnd, &oldnd.last, &old);
 	if (error)
 		goto exit3;
 	/* source must exist */
@@ -2973,7 +3440,7 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	error = -EINVAL;
 	if (old.dentry == trap)
 		goto exit4;
-	error = lookup_hash(&newnd, &newnd.last, &new);
+	error = hash_lookup_union(&newnd, &newnd.last, &new);
 	if (error)
 		goto exit4;
 	/* target should not be an ancestor of source */
diff --git a/include/linux/namei.h b/include/linux/namei.h
index d870ae2..81afb59 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -20,6 +20,7 @@ struct nameidata {
 	struct qstr	last;
 	struct path	root;
 	unsigned int	flags;
+	unsigned int	um_flags;
 	int		last_type;
 	unsigned	depth;
 	char *saved_names[MAX_NESTED_LINKS + 1];
@@ -35,6 +36,9 @@ struct nameidata {
  */
 enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 
+#define LAST_UNION             0x01
+#define LAST_LOWLEVEL          0x02
+
 /*
  * The bitmask for a lookup event:
  *  - follow links at the end
@@ -49,6 +53,8 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 #define LOOKUP_CONTINUE		 4
 #define LOOKUP_PARENT		16
 #define LOOKUP_REVAL		64
+#define LOOKUP_TOPMOST	       128
+
 /*
  * Intent data
  */
-- 
1.6.3.3

