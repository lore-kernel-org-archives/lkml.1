Return-Path: <linux-kernel-owner+w=401wt.eu-S939540AbXG3QSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939540AbXG3QSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938546AbXG3QOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:14:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934545AbXG3QOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:11 -0400
Message-Id: <20070730161324.902275409@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:42 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 19/26] union-mount: Make lookup work for union-mounted file systems
Content-Disposition: inline; filename=um/union-mount-lookup.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On union-mounted file systems the lookup function must also visit lower layers
of the union-stack when doing a lookup. This patches add support for
union-mounts to cached lookups and real lookups.

We have 3 different styles of lookup functions now:
- multiple pathname components, follow mounts, follow union, follow symlinks
- single pathname component, doesn't follow mounts, follow union, doesn't
  follow symlinks
- single pathname component doesn't follow mounts, doesn't follow unions,
  doesn't follow symlinks

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/namei.c            |  467 +++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/namei.h |    6 
 2 files changed, 465 insertions(+), 8 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -31,6 +31,7 @@
 #include <linux/file.h>
 #include <linux/fcntl.h>
 #include <linux/namei.h>
+#include <linux/union.h>
 #include <asm/namei.h>
 #include <asm/uaccess.h>
 
@@ -415,6 +416,167 @@ static struct dentry *cache_lookup(struc
 }
 
 /*
+ * cache_lookup_topmost - lookup the topmost (non-)negative dentry
+ *
+ * This is used for union mount lookups from dcache. The first non-negative
+ * dentry is searched on all layers of the union stack. Otherwise the topmost
+ * negative dentry is return.
+ */
+static int __cache_lookup_topmost(struct nameidata *nd, struct qstr *name,
+				  struct path *path)
+{
+	struct dentry *dentry;
+
+	dentry = d_lookup(nd->dentry, name);
+	if (dentry && dentry->d_op && dentry->d_op->d_revalidate)
+		dentry = do_revalidate(dentry, nd);
+
+	/*
+	 * Remember the topmost negative dentry in case we don't find anything
+	 */
+	path->dentry = dentry;
+	path->mnt = dentry ? nd->mnt : NULL;
+
+	if (!dentry || dentry->d_inode)
+		return !dentry;
+
+	/* look for the first non-negative dentry */
+
+	while (follow_union_down(&nd->mnt, &nd->dentry)) {
+		dentry = d_hash_and_lookup(nd->dentry, name);
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
+	path->mnt = dentry ? mntget(nd->mnt) : NULL;
+	return !dentry;
+}
+
+/*
+ * cache_lookup_union - lookup the rest of the union stack
+ *
+ * This is called after you have the topmost dentry in @path.
+ */
+static int __cache_lookup_union(struct nameidata *nd, struct qstr *name,
+				struct path *path)
+{
+	struct path last = *path;
+	struct dentry *dentry;
+
+	while (follow_union_down(&nd->mnt, &nd->dentry)) {
+		dentry = d_hash_and_lookup(nd->dentry, name);
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
+		/* now we know we found something "real"  */
+		append_to_union(last.mnt, last.dentry, nd->mnt, dentry);
+
+		if (last.dentry != path->dentry)
+			pathput(&last);
+		last.dentry = dentry;
+		last.mnt = mntget(nd->mnt);
+	}
+
+	if (last.dentry != path->dentry)
+		pathput(&last);
+
+	return 0;
+}
+
+/*
+ * cache_lookup - lookup a single pathname part from dcache
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
+	if (!IS_MNT_UNION(nd->mnt)) {
+		path->dentry = cache_lookup(nd->dentry, name, nd);
+		path->mnt = path->dentry ? nd->mnt : NULL;
+		res = path->dentry ? 0 : 1;
+	} else {
+		struct path safe = { .dentry = nd->dentry, .mnt = nd->mnt };
+
+		pathget(&safe);
+		res = __cache_lookup_topmost(nd, name, path);
+		if (res)
+			goto out;
+
+		/* only directories can be part of a union stack */
+		if (!path->dentry->d_inode ||
+		    !S_ISDIR(path->dentry->d_inode->i_mode))
+			goto out;
+
+		/* revalidate the union */
+
+		/* continue lookup on the lower layers of the union */
+		res = __cache_lookup_union(nd, name, path);
+		if (res) {
+			dput(path->dentry);
+			if (path->mnt != safe.mnt)
+				mntput(path->mnt);
+			goto out;
+		}
+
+out:
+		path_release(nd);
+		nd->dentry = safe.dentry;
+		nd->mnt = safe.mnt;
+	}
+
+	return res;
+}
+
+/*
  * Short-cut version of permission(), for calling by
  * path_walk(), when dcache lock is held.  Combines parts
  * of permission() and generic_permission(), and tests ONLY for
@@ -527,6 +689,151 @@ static int real_lookup(struct nameidata 
 	return res;
 }
 
+static inline void copy_nameidata(struct nameidata *old, struct nameidata *new)
+{
+	memset(new, 0, sizeof(*new));
+
+	/* Maybbe we are called via lookup_hash() with a NULL nd argument */
+	if (old) {
+		new->flags = old->flags;
+		memcpy(&new->intent, &old->intent, sizeof(new->intent));
+	}
+}
+
+/*
+ * This is called when a dentries parent is union-mounted and we have
+ * to lookup the overlaid dentries. The lookup starts at the parents
+ * first overlaid dentry of the given dentry. Negative dentries are
+ * ignored and not included in the overlaid list.
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
+	while (follow_union_down(&nd->mnt, &nd->dentry)) {
+		name->hash = full_name_hash(name->name, name->len);
+		if (nd->dentry->d_op && nd->dentry->d_op->d_hash) {
+			err = nd->dentry->d_op->d_hash(nd->dentry, name);
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
+static int __real_lookup_union(struct nameidata *nd, struct qstr *name,
+			       struct path *path)
+{
+	struct path last = *path;
+	struct path next;
+	int err = 0;
+
+	while (follow_union_down(&nd->mnt, &nd->dentry)) {
+		/* We need to recompute the hash for lower layer lookups */
+		name->hash = full_name_hash(name->name, name->len);
+		if (nd->dentry->d_op && nd->dentry->d_op->d_hash) {
+			err = nd->dentry->d_op->d_hash(nd->dentry, name);
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
+			pathput(&last);
+		last.dentry = next.dentry;
+		last.mnt = mntget(next.mnt);
+	}
+
+	if (last.dentry != path->dentry)
+		pathput(&last);
+out:
+	return err;
+}
+
+static int real_lookup_union(struct nameidata *nd, struct qstr *name,
+			     struct path *path)
+{
+	struct path safe = { .dentry = nd->dentry, .mnt = nd->mnt };
+	int res ;
+
+	pathget(&safe);
+	res = __real_lookup_topmost(nd, name, path);
+	if (res)
+		goto out;
+
+	/* only directories can be part of a union stack */
+	if (!path->dentry->d_inode ||
+	    !S_ISDIR(path->dentry->d_inode->i_mode))
+		goto out;
+
+	/* continue lookup on the lower layers of the union */
+	res = __real_lookup_union(nd, name, path);
+	if (res) {
+		dput(path->dentry);
+		if (path->mnt != safe.mnt)
+			mntput(path->mnt);
+		goto out;
+	}
+
+out:
+	path_release(nd);
+	nd->dentry = safe.dentry;
+	nd->mnt = safe.mnt;
+	return res;
+}
+
 static int __emul_lookup_dentry(const char *, struct nameidata *);
 
 /* SMP-safe */
@@ -755,6 +1062,7 @@ static __always_inline void follow_dotdo
 		nd->mnt = parent;
 	}
 	follow_mount(&nd->mnt, &nd->dentry);
+	follow_union_mount(&nd->mnt, &nd->dentry);
 }
 
 /*
@@ -767,6 +1075,9 @@ static int do_lookup(struct nameidata *n
 {
 	int err;
 
+	if (IS_MNT_UNION(nd->mnt))
+		goto need_union_lookup;
+
 	path->dentry = __d_lookup(nd->dentry, name);
 	path->mnt = nd->mnt;
 	if (!path->dentry)
@@ -775,7 +1086,12 @@ static int do_lookup(struct nameidata *n
 		goto need_revalidate;
 
 done:
-	__follow_mount(path);
+	if (nd->mnt != path->mnt) {
+		nd->um_flags |= LAST_LOWLEVEL;
+		follow_mount(&path->mnt, &path->dentry);
+	} else
+		__follow_mount(path);
+	follow_union_mount(&path->mnt, &path->dentry);
 	return 0;
 
 need_lookup:
@@ -784,6 +1100,16 @@ need_lookup:
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
@@ -822,6 +1148,8 @@ static fastcall int __link_path_walk(con
 	if (nd->depth)
 		lookup_flags = LOOKUP_FOLLOW | (nd->flags & LOOKUP_CONTINUE);
 
+	follow_union_mount(&nd->mnt, &nd->dentry);
+
 	/* At this point we know we have a real path component. */
 	for(;;) {
 		unsigned long hash;
@@ -1111,6 +1439,7 @@ static int fastcall do_path_lookup(int d
 
 	nd->last_type = LAST_ROOT; /* if there are only slashes... */
 	nd->flags = flags;
+	nd->um_flags = 0;
 	nd->depth = 0;
 
 	if (*name=='/') {
@@ -1336,6 +1665,128 @@ out:
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
+	while (follow_union_down(&nd->mnt, &nd->dentry)) {
+		name->hash = full_name_hash(name->name, name->len);
+		if (nd->dentry->d_op && nd->dentry->d_op->d_hash) {
+			err = nd->dentry->d_op->d_hash(nd->dentry, name);
+			if (err < 0)
+				goto out;
+		}
+
+		mutex_lock(&nd->dentry->d_inode->i_mutex);
+		err = lookup_hash(nd, name, &next);
+		mutex_unlock(&nd->dentry->d_inode->i_mutex);
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
+static int __hash_lookup_union(struct nameidata *nd, struct qstr *name,
+			       struct path *path)
+{
+	struct path last = *path;
+	struct path next;
+	int err = 0;
+
+	while (follow_union_down(&nd->mnt, &nd->dentry)) {
+		/* We need to recompute the hash for lower layer lookups */
+		name->hash = full_name_hash(name->name, name->len);
+		if (nd->dentry->d_op && nd->dentry->d_op->d_hash) {
+			err = nd->dentry->d_op->d_hash(nd->dentry, name);
+			if (err < 0)
+				goto out;
+		}
+
+		mutex_lock(&nd->dentry->d_inode->i_mutex);
+		err = lookup_hash(nd, name, &next);
+		mutex_unlock(&nd->dentry->d_inode->i_mutex);
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
+			pathput(&last);
+		last.dentry = next.dentry;
+		last.mnt = mntget(next.mnt);
+	}
+
+	if (last.dentry != path->dentry)
+		pathput(&last);
+out:
+	return err;
+}
+
+static int hash_lookup_union(struct nameidata *nd, struct qstr *name,
+			     struct path *path)
+{
+	struct path safe = { .dentry = nd->dentry, .mnt = nd->mnt };
+	int res ;
+
+	pathget(&safe);
+	res = __hash_lookup_topmost(nd, name, path);
+	if (res)
+		goto out;
+
+	/* only directories can be part of a union stack */
+	if (!path->dentry->d_inode ||
+	    !S_ISDIR(path->dentry->d_inode->i_mode))
+		goto out;
+
+	/* continue lookup on the lower layers of the union */
+	res = __hash_lookup_union(nd, name, path);
+	if (res) {
+		dput(path->dentry);
+		if (path->mnt != safe.mnt)
+			mntput(path->mnt);
+		goto out;
+	}
+
+out:
+	path_release(nd);
+	nd->dentry = safe.dentry;
+	nd->mnt = safe.mnt;
+	return res;
+}
+
 /* SMP-safe */
 static inline int __lookup_one_len(const char *name, struct qstr *this, struct dentry *base, int len)
 {
@@ -1740,7 +2191,7 @@ int open_namei(int dfd, const char *path
 	dir = nd->dentry;
 	nd->flags &= ~LOOKUP_PARENT;
 	mutex_lock(&dir->d_inode->i_mutex);
-	error = lookup_hash(nd, &nd->last, &path);
+	error = hash_lookup_union(nd, &nd->last, &path);
 
 do_last:
 	if (error) {
@@ -1846,7 +2297,7 @@ do_link:
 	}
 	dir = nd->dentry;
 	mutex_lock(&dir->d_inode->i_mutex);
-	error = lookup_hash(nd, &nd->last, &path);
+	error = hash_lookup_union(nd, &nd->last, &path);
 	__putname(nd->last.name);
 	goto do_last;
 }
@@ -1879,7 +2330,7 @@ int lookup_create(struct nameidata *nd, 
 	/*
 	 * Do the final lookup.
 	 */
-	err = lookup_hash(nd, &nd->last, path);
+	err = hash_lookup_union(nd, &nd->last, path);
 	if (err)
 		goto fail;
 
@@ -2501,7 +2952,7 @@ static long do_rmdir(int dfd, const char
 			goto exit1;
 	}
 	mutex_lock_nested(&nd.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
-	error = lookup_hash(&nd, &nd.last, &path);
+	error = hash_lookup_union(&nd, &nd.last, &path);
 	if (error)
 		goto exit2;
 	error = vfs_rmdir(nd.dentry->d_inode, path.dentry);
@@ -2575,7 +3026,7 @@ static long do_unlinkat(int dfd, const c
 	if (nd.last_type != LAST_NORM)
 		goto exit1;
 	mutex_lock_nested(&nd.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
-	error = lookup_hash(&nd, &nd.last, &path);
+	error = hash_lookup_union(&nd, &nd.last, &path);
 	if (!error) {
 		/* Why not before? Because we want correct error value */
 		if (nd.last.name[nd.last.len])
@@ -2960,7 +3411,7 @@ static int do_rename(int olddfd, const c
 
 	trap = lock_rename(new_dir, old_dir);
 
-	error = lookup_hash(&oldnd, &oldnd.last, &old);
+	error = hash_lookup_union(&oldnd, &oldnd.last, &old);
 	if (error)
 		goto exit3;
 	/* source must exist */
@@ -2979,7 +3430,7 @@ static int do_rename(int olddfd, const c
 	error = -EINVAL;
 	if (old.dentry == trap)
 		goto exit4;
-	error = lookup_hash(&newnd, &newnd.last, &new);
+	error = hash_lookup_union(&newnd, &newnd.last, &new);
 	if (error)
 		goto exit4;
 	/* target should not be an ancestor of source */
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -20,6 +20,7 @@ struct nameidata {
 	struct vfsmount *mnt;
 	struct qstr	last;
 	unsigned int	flags;
+	unsigned int	um_flags;
 	int		last_type;
 	unsigned	depth;
 	char *saved_names[MAX_NESTED_LINKS + 1];
@@ -40,6 +41,9 @@ struct path {
  */
 enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 
+#define LAST_UNION             0x01
+#define LAST_LOWLEVEL          0x02
+
 /*
  * The bitmask for a lookup event:
  *  - follow links at the end
@@ -55,6 +59,8 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LA
 #define LOOKUP_PARENT		16
 #define LOOKUP_NOALT		32
 #define LOOKUP_REVAL		64
+#define LOOKUP_TOPMOST	       128
+
 /*
  * Intent data
  */

-- 

