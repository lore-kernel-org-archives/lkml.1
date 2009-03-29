Return-Path: <linux-kernel-owner+w=401wt.eu-S1759398AbZC2Qmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbZC2Qmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757645AbZC2QiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:38:03 -0400
Received: from cantor.suse.de ([195.135.220.2]:52663 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbZC2Qha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:37:30 -0400
Message-Id: <20090329155749.609663166@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Mon, 30 Mar 2009 02:55:48 +1100
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 09/14] fs: use RCU / seqlock logic for reverse and multi-step operaitons
References: <20090329155539.275927173@nick.local0.net>
Content-Disposition: inline; filename=fs-dcache_lock-multi-step.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remaining usages for dcache_lock is to allow atomic, multi-step read-side
operations over the directory tree by excluding modifications to the tree.
Also, to walk in the leaf->root direction in the tree where we don't have
a natural d_lock ordering. This is the hardest bit.

This could be accomplished by taking every d_lock, but this would mean a
huge number of locks and actually gets very tricky.

Solve this instead by using the rename seqlock for multi-step read-side
operations. Insert operations are not serialised. Delete operations are
tricky when walking up the directory our parent might have been deleted
when dropping locks so also need to check and retry for that. (XXX: I'm
not sure if I've quite got this correct...)

---
 fs/dcache.c   |   98 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
 fs/seq_file.c |    6 +++
 2 files changed, 93 insertions(+), 11 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -912,11 +912,15 @@ void shrink_dcache_for_umount(struct sup
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
@@ -948,17 +952,34 @@ resume:
 	 * All done at this level ... ascend and resume the search.
 	 */
 	if (this_parent != parent) {
+		struct dentry *tmp;
+
 		next = this_parent->d_u.d_child.next;
+		tmp = this_parent->d_parent;
+		rcu_read_lock();
 		spin_unlock(&this_parent->d_lock);
-		this_parent = this_parent->d_parent;
+		this_parent = tmp;
 		spin_lock(&this_parent->d_lock);
+		/* might go back up the wrong parent if we have had a rename
+		 * or deletion */
+		if (d_unhashed(this_parent) || read_seqretry(&rename_lock, seq)) {
+			spin_unlock(&this_parent->d_lock);
+			spin_unlock(&dcache_lock);
+			rcu_read_unlock();
+			goto rename_retry;
+		}
+		rcu_read_unlock();
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
 
@@ -978,10 +999,15 @@ positive:
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
@@ -1032,17 +1058,31 @@ resume:
 	 */
 	if (this_parent != parent) {
 		struct dentry *tmp;
+
 		next = this_parent->d_u.d_child.next;
 		tmp = this_parent->d_parent;
+		rcu_read_lock();
 		spin_unlock(&this_parent->d_lock);
-		BUG_ON(tmp == this_parent);
 		this_parent = tmp;
 		spin_lock(&this_parent->d_lock);
+		/* might go back up the wrong parent if we have had a rename
+		 * or deletion */
+		if (this_parent != parent &&
+				(/* d_unhashed(this_parent) XXX: hmm... */ 0 ||
+				read_seqretry(&rename_lock, seq))) {
+			spin_unlock(&this_parent->d_lock);
+			spin_unlock(&dcache_lock);
+			rcu_read_unlock();
+			goto rename_retry;
+		}
+		rcu_read_unlock();
 		goto resume;
 	}
 out:
 	spin_unlock(&this_parent->d_lock);
 	spin_unlock(&dcache_lock);
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
 	return found;
 }
 
@@ -2154,6 +2194,7 @@ char *__d_path(const struct path *path,
 	char *end = buffer + buflen;
 	char *retval;
 
+	rcu_read_lock();
 	prepend(&end, &buflen, "\0", 1);
 	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
 		(prepend(&end, &buflen, " (deleted)", 10) != 0))
@@ -2189,6 +2230,7 @@ char *__d_path(const struct path *path,
 	}
 
 out:
+	rcu_read_unlock();
 	return retval;
 
 global_root:
@@ -2225,6 +2267,7 @@ char *d_path(const struct path *path, ch
 	char *res;
 	struct path root;
 	struct path tmp;
+	unsigned seq;
 
 	/*
 	 * We have various synthetic filesystems that never get mounted.  On
@@ -2240,6 +2283,9 @@ char *d_path(const struct path *path, ch
 	root = current->fs->root;
 	path_get(&root);
 	read_unlock(&current->fs->lock);
+
+rename_retry:
+	seq = read_seqbegin(&rename_lock);
 	spin_lock(&dcache_lock);
 	spin_lock(&vfsmount_lock);
 	spin_lock(&path->dentry->d_lock);
@@ -2248,6 +2294,9 @@ char *d_path(const struct path *path, ch
 	spin_unlock(&path->dentry->d_lock);
 	spin_unlock(&vfsmount_lock);
 	spin_unlock(&dcache_lock);
+	if (read_seqretry(&rename_lock, seq))
+		goto rename_retry;
+
 	path_put(&root);
 	return res;
 }
@@ -2278,9 +2327,14 @@ char *dynamic_dname(struct dentry *dentr
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
@@ -2304,13 +2358,16 @@ char *dentry_path(struct dentry *dentry,
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
@@ -2430,9 +2487,13 @@ int is_subdir(struct dentry *new_dentry,
 
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
@@ -2456,15 +2517,30 @@ resume:
 		spin_unlock(&dentry->d_lock);
 	}
 	if (this_parent != root) {
+		struct dentry *tmp;
+
 		next = this_parent->d_u.d_child.next;
+		tmp = this_parent->d_parent;
 		this_parent->d_count--;
+		rcu_read_lock();
 		spin_unlock(&this_parent->d_lock);
-		this_parent = this_parent->d_parent;
+		this_parent = tmp;
 		spin_lock(&this_parent->d_lock);
+		/* might go back up the wrong parent if we have had a rename
+		 * or deletion */
+		if (d_unhashed(this_parent) || read_seqretry(&rename_lock, seq)) {
+			spin_unlock(&this_parent->d_lock);
+			spin_unlock(&dcache_lock);
+			rcu_read_unlock();
+			goto rename_retry;
+		}
+		rcu_read_unlock();
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
 		spin_lock(&vfsmount_lock);
 		p = __d_path(path, root, s, m->size - m->count);
 		spin_unlock(&vfsmount_lock);
 		spin_unlock(&dcache_lock);
+		if (read_seqretry(&rename_lock, seq))
+			goto rename_retry;
+
 		err = PTR_ERR(p);
 		if (!IS_ERR(p)) {
 			s = mangle_path(s, p, esc);


