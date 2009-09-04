Return-Path: <linux-kernel-owner+w=401wt.eu-S933160AbZIDHEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160AbZIDHEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933069AbZIDHEC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:04:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676AbZIDG6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:58:39 -0400
Message-Id: <20090904065535.901056585@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Fri, 04 Sep 2009 16:51:54 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 13/33] fs: use RCU / seqlock logic for reverse and multi-step operaitons
References: <20090904065142.114706411@nick.local0.net>
Content-Disposition: inline; filename=fs-dcache_lock-multi-step.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remaining usages for dcache_lock is to allow atomic, multi-step read-side
operations over the directory tree by excluding modifications to the tree.
Also, to walk in the leaf->root direction in the tree where we don't have
a natural d_lock ordering.

This could be accomplished by taking every d_lock, but this would mean a
huge number of locks and actually gets very tricky.

Solve this instead by using the rename seqlock for multi-step read-side
operations. Insert operations are not serialised. Delete operations are
tricky when walking up the directory our parent might have been deleted
when dropping locks so also need to check and retry for that.

XXX: hmm, we could of course just take the rename lock if there is any worry
about livelock. Most of these are slow paths.

---
 drivers/staging/pohmelfs/path_entry.c |    7 ++
 fs/autofs4/waitq.c                    |   10 ++
 fs/dcache.c                           |  116 +++++++++++++++++++++++++++++-----
 fs/nfs/namespace.c                    |   10 ++
 fs/seq_file.c                         |    6 +
 5 files changed, 134 insertions(+), 15 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -936,11 +936,15 @@ void shrink_dcache_for_umount(struct sup
  * Return true if the parent or its subdirectories contain
  * a mount point
  */
- 
 int have_submounts(struct dentry *parent)
 {
-	struct dentry *this_parent = parent;
+	struct dentry *this_parent;
 	struct list_head *next;
+	unsigned seq;
+
+rename_retry:
+	this_parent = parent;
+	seq = read_seqbegin(&rename_lock);
 
 	spin_lock(&dcache_lock);
 	if (d_mountpoint(parent))
@@ -974,17 +978,38 @@ resume:
 	 * All done at this level ... ascend and resume the search.
 	 */
 	if (this_parent != parent) {
-		next = this_parent->d_u.d_child.next;
+		struct dentry *tmp;
+		struct dentry *child;
+
+		tmp = this_parent->d_parent;
+		rcu_read_lock();
 		spin_unlock(&this_parent->d_lock);
-		this_parent = this_parent->d_parent;
+		child = this_parent;
+		this_parent = tmp;
 		spin_lock(&this_parent->d_lock);
+		/* might go back up the wrong parent if we have had a rename
+		 * or deletion */
+		if (this_parent != child->d_parent ||
+				// d_unlinked(this_parent) || XXX
+				read_seqretry(&rename_lock, seq)) {
+			spin_unlock(&this_parent->d_lock);
+			spin_unlock(&dcache_lock);
+			rcu_read_unlock();
+			goto rename_retry;
+		}
+		rcu_read_unlock();
+		next = child->d_u.d_child.next;
 		goto resume;
 	}
 	spin_unlock(&this_parent->d_lock);
 	spin_unlock(&dcache_lock);
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
 	return 0; /* No mount points found in tree */
 positive:
 	spin_unlock(&dcache_lock);
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
 	return 1;
 }
 
@@ -1004,10 +1029,15 @@ positive:
  */
 static int select_parent(struct dentry * parent)
 {
-	struct dentry *this_parent = parent;
+	struct dentry *this_parent;
 	struct list_head *next;
+	unsigned seq;
 	int found = 0;
 
+rename_retry:
+	this_parent = parent;
+	seq = read_seqbegin(&rename_lock);
+
 	spin_lock(&dcache_lock);
 	spin_lock(&this_parent->d_lock);
 repeat:
@@ -1017,7 +1047,6 @@ resume:
 		struct list_head *tmp = next;
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
-		BUG_ON(this_parent == dentry);
 
 		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 		dentry_lru_del_init(dentry);
@@ -1058,17 +1087,33 @@ resume:
 	 */
 	if (this_parent != parent) {
 		struct dentry *tmp;
-		next = this_parent->d_u.d_child.next;
+		struct dentry *child;
+
 		tmp = this_parent->d_parent;
+		rcu_read_lock();
 		spin_unlock(&this_parent->d_lock);
-		BUG_ON(tmp == this_parent);
+		child = this_parent;
 		this_parent = tmp;
 		spin_lock(&this_parent->d_lock);
+		/* might go back up the wrong parent if we have had a rename
+		 * or deletion */
+		if (this_parent != child->d_parent ||
+				// d_unlinked(this_parent) || XXX
+				read_seqretry(&rename_lock, seq)) {
+			spin_unlock(&this_parent->d_lock);
+			spin_unlock(&dcache_lock);
+			rcu_read_unlock();
+			goto rename_retry;
+		}
+		rcu_read_unlock();
+		next = child->d_u.d_child.next;
 		goto resume;
 	}
 out:
 	spin_unlock(&this_parent->d_lock);
 	spin_unlock(&dcache_lock);
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
 	return found;
 }
 
@@ -2173,6 +2218,7 @@ char *__d_path(const struct path *path,
 	char *end = buffer + buflen;
 	char *retval;
 
+	rcu_read_lock();
 	prepend(&end, &buflen, "\0", 1);
 	if (d_unlinked(dentry) &&
 		(prepend(&end, &buflen, " (deleted)", 10) != 0))
@@ -2208,6 +2254,7 @@ char *__d_path(const struct path *path,
 	}
 
 out:
+	rcu_read_unlock();
 	return retval;
 
 global_root:
@@ -2244,6 +2291,7 @@ char *d_path(const struct path *path, ch
 	char *res;
 	struct path root;
 	struct path tmp;
+	unsigned seq;
 
 	/*
 	 * We have various synthetic filesystems that never get mounted.  On
@@ -2259,6 +2307,9 @@ char *d_path(const struct path *path, ch
 	root = current->fs->root;
 	path_get(&root);
 	read_unlock(&current->fs->lock);
+
+rename_retry:
+	seq = read_seqbegin(&rename_lock);
 	spin_lock(&dcache_lock);
 	vfsmount_read_lock();
 	spin_lock(&path->dentry->d_lock);
@@ -2267,6 +2318,9 @@ char *d_path(const struct path *path, ch
 	spin_unlock(&path->dentry->d_lock);
 	vfsmount_read_unlock();
 	spin_unlock(&dcache_lock);
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
+
 	path_put(&root);
 	return res;
 }
@@ -2297,9 +2351,14 @@ char *dynamic_dname(struct dentry *dentr
  */
 char *dentry_path(struct dentry *dentry, char *buf, int buflen)
 {
-	char *end = buf + buflen;
+	char *end;
 	char *retval;
+	unsigned seq;
 
+rename_retry:
+	end = buf + buflen;
+	seq = read_seqbegin(&rename_lock);
+	rcu_read_lock(); /* protect parent */
 	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	prepend(&end, &buflen, "\0", 1);
@@ -2323,13 +2382,16 @@ char *dentry_path(struct dentry *dentry,
 		retval = end;
 		dentry = parent;
 	}
+out:
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
+	rcu_read_unlock();
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
 	return retval;
 Elong:
-	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
-	return ERR_PTR(-ENAMETOOLONG);
+	retval = ERR_PTR(-ENAMETOOLONG);
+	goto out;
 }
 
 /*
@@ -2448,9 +2510,13 @@ int is_subdir(struct dentry *new_dentry,
 
 void d_genocide(struct dentry *root)
 {
-	struct dentry *this_parent = root;
+	struct dentry *this_parent;
 	struct list_head *next;
+	unsigned seq;
 
+rename_retry:
+	this_parent = root;
+	seq = read_seqbegin(&rename_lock);
 	spin_lock(&dcache_lock);
 	spin_lock(&this_parent->d_lock);
 repeat:
@@ -2460,6 +2526,7 @@ resume:
 		struct list_head *tmp = next;
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
+
 		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 		if (d_unhashed(dentry) || !dentry->d_inode) {
 			spin_unlock(&dentry->d_lock);
@@ -2476,15 +2543,34 @@ resume:
 		spin_unlock(&dentry->d_lock);
 	}
 	if (this_parent != root) {
-		next = this_parent->d_u.d_child.next;
+		struct dentry *tmp;
+		struct dentry *child;
+
+		tmp = this_parent->d_parent;
 		this_parent->d_count--;
+		rcu_read_lock();
 		spin_unlock(&this_parent->d_lock);
-		this_parent = this_parent->d_parent;
+		child = this_parent;
+		this_parent = tmp;
 		spin_lock(&this_parent->d_lock);
+		/* might go back up the wrong parent if we have had a rename
+		 * or deletion */
+		if (this_parent != child->d_parent ||
+				// d_unlinked(this_parent) || XXX
+				read_seqretry(&rename_lock, seq)) {
+			spin_unlock(&this_parent->d_lock);
+			spin_unlock(&dcache_lock);
+			rcu_read_unlock();
+			goto rename_retry;
+		}
+		rcu_read_unlock();
+		next = child->d_u.d_child.next;
 		goto resume;
 	}
 	spin_unlock(&this_parent->d_lock);
 	spin_unlock(&dcache_lock);
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
 }
 
 /**
Index: linux-2.6/fs/seq_file.c
===================================================================
--- linux-2.6.orig/fs/seq_file.c
+++ linux-2.6/fs/seq_file.c
@@ -459,12 +459,18 @@ int seq_path_root(struct seq_file *m, st
 	if (m->count < m->size) {
 		char *s = m->buf + m->count;
 		char *p;
+		unsigned seq;
 
+rename_retry:
+		seq = read_seqbegin(&rename_lock);
 		spin_lock(&dcache_lock);
 		vfsmount_read_lock();
 		p = __d_path(path, root, s, m->size - m->count);
 		vfsmount_read_unlock();
 		spin_unlock(&dcache_lock);
+		if (read_seqretry(&rename_lock, seq))
+			goto rename_retry;
+
 		err = PTR_ERR(p);
 		if (!IS_ERR(p)) {
 			s = mangle_path(s, p, esc);
Index: linux-2.6/drivers/staging/pohmelfs/path_entry.c
===================================================================
--- linux-2.6.orig/drivers/staging/pohmelfs/path_entry.c
+++ linux-2.6/drivers/staging/pohmelfs/path_entry.c
@@ -85,6 +85,7 @@ int pohmelfs_path_length(struct pohmelfs
 {
 	struct dentry *d, *root, *first;
 	int len = 1; /* Root slash */
+	unsigned seq;
 
 	first = d = d_find_alias(&pi->vfs_inode);
 	if (!d) {
@@ -96,6 +97,9 @@ int pohmelfs_path_length(struct pohmelfs
 	root = dget(current->fs->root.dentry);
 	read_unlock(&current->fs->lock);
 
+	rcu_read_lock();
+rename_retry:
+	seq = read_seqbegin(&rename_lock);
 	spin_lock(&dcache_lock);
 
 	if (!IS_ROOT(d) && d_unhashed(d))
@@ -106,6 +110,9 @@ int pohmelfs_path_length(struct pohmelfs
 		d = d->d_parent;
 	}
 	spin_unlock(&dcache_lock);
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
+	rcu_read_unlock();
 
 	dput(root);
 	dput(first);
Index: linux-2.6/fs/autofs4/waitq.c
===================================================================
--- linux-2.6.orig/fs/autofs4/waitq.c
+++ linux-2.6/fs/autofs4/waitq.c
@@ -189,13 +189,20 @@ static int autofs4_getpath(struct autofs
 	char *buf = *name;
 	char *p;
 	int len = 0;
+	unsigned seq;
 
+	rcu_read_lock();
+rename_retry:
+	seq = read_seqbegin(&rename_lock);
 	spin_lock(&dcache_lock);
 	for (tmp = dentry ; tmp != root ; tmp = tmp->d_parent)
 		len += tmp->d_name.len + 1;
 
 	if (!len || --len > NAME_MAX) {
 		spin_unlock(&dcache_lock);
+		if (read_seqretry(&rename_lock, seq))
+			goto rename_retry;
+		rcu_read_unlock();
 		return 0;
 	}
 
@@ -209,6 +216,9 @@ static int autofs4_getpath(struct autofs
 		strncpy(p, tmp->d_name.name, tmp->d_name.len);
 	}
 	spin_unlock(&dcache_lock);
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
+	rcu_read_unlock();
 
 	return len;
 }
Index: linux-2.6/fs/nfs/namespace.c
===================================================================
--- linux-2.6.orig/fs/nfs/namespace.c
+++ linux-2.6/fs/nfs/namespace.c
@@ -50,9 +50,13 @@ char *nfs_path(const char *base,
 {
 	char *end = buffer+buflen;
 	int namelen;
+	unsigned seq;
 
 	*--end = '\0';
 	buflen--;
+	rcu_read_lock();
+rename_retry:
+	seq = read_seqbegin(&rename_lock);
 	spin_lock(&dcache_lock);
 	while (!IS_ROOT(dentry) && dentry != droot) {
 		namelen = dentry->d_name.len;
@@ -65,6 +69,9 @@ char *nfs_path(const char *base,
 		dentry = dentry->d_parent;
 	}
 	spin_unlock(&dcache_lock);
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
+	rcu_read_unlock();
 	if (*end != '/') {
 		if (--buflen < 0)
 			goto Elong;
@@ -82,6 +89,9 @@ char *nfs_path(const char *base,
 	return end;
 Elong_unlock:
 	spin_unlock(&dcache_lock);
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
+	rcu_read_unlock();
 Elong:
 	return ERR_PTR(-ENAMETOOLONG);
 }


