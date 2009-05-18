Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbZERQMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbZERQMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbZERQLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:11:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:41554 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756116AbZERQJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:37 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 29/32] union mount: Support for fallthru entries in union mount lookup
Date: Mon, 18 May 2009 18:09:25 +0200
Message-Id: <1242662968-11684-30-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora (Henson) <vaurora@redhat.com>

A fallthru directory entry overrides the opaque flag for its parent
directory (for this directory entry only).  Before, we stopped
building the union stack when we encountered an opaque directory; now
we include directories below opaque directories in the union stack and
check for opacity during lookup.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
---
 fs/dcache.c |    7 +++----
 fs/namei.c  |   59 +++++++++++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 48 insertions(+), 18 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index b6fb688..844a76a 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1086,7 +1086,7 @@ struct dentry *d_alloc_name(struct dentry *parent, const char *name)
 static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 {
 	if (inode) {
-		dentry->d_flags &= ~DCACHE_WHITEOUT;
+		dentry->d_flags &= ~(DCACHE_WHITEOUT|DCACHE_FALLTHRU);
 		list_add(&dentry->d_alias, &inode->i_dentry);
 	}
 	dentry->d_inode = inode;
@@ -1650,9 +1650,8 @@ void d_delete(struct dentry * dentry)
 
 static void __d_rehash(struct dentry * entry, struct hlist_head *list)
 {
-
- 	entry->d_flags &= ~DCACHE_UNHASHED;
- 	hlist_add_head_rcu(&entry->d_hash, list);
+	entry->d_flags &= ~DCACHE_UNHASHED;
+	hlist_add_head_rcu(&entry->d_hash, list);
 }
 
 static void _d_rehash(struct dentry * entry)
diff --git a/fs/namei.c b/fs/namei.c
index 684619c..1f96a66 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -414,6 +414,28 @@ static struct dentry *cache_lookup(struct dentry *parent, struct qstr *name,
 	return dentry;
 }
 
+/*
+ * Theory of operation for opaque, whiteout, and fallthru:
+ *
+ * whiteout: Unconditionally stop lookup here - ENOENT
+ *
+ * opaque: Don't lookup in directories lower in the union stack
+ *
+ * fallthru: While looking up an entry, ignore the opaque flag for the
+ * current directory only.
+ *
+ * A union stack is a linked list of directory dentries which appear
+ * in the same place in the namespace.  When constructing the union
+ * stack, we include directories below opaque directories so that we
+ * can properly handle fallthrus.  All non-fallthru lookups have to
+ * check for the opaque flag on the parent directory and obey it.
+ *
+ * In general, the code pattern is to lookup the the topmost entry
+ * first (either the first visible non-negative dentry or a negative
+ * dentry in the topmost layer of the union), then build the union
+ * stack for the newly looked-up entry (if it is a directory).
+ */
+
 /**
  * __cache_lookup_topmost - lookup the topmost (non-)negative dentry
  *
@@ -443,6 +465,10 @@ static int __cache_lookup_topmost(struct nameidata *nd, struct qstr *name,
 	if (!dentry || (dentry->d_inode || d_is_whiteout(dentry)))
 		return !dentry;
 
+	/* Keep going through opaque directories if we found a fallthru */
+	if (IS_OPAQUE(nd->path.dentry->d_inode) && !d_is_fallthru(dentry))
+		return !dentry;
+
 	/* look for the first non-negative or whiteout dentry */
 
 	while (follow_union_down(&nd->path.mnt, &nd->path.dentry)) {
@@ -468,6 +494,10 @@ static int __cache_lookup_topmost(struct nameidata *nd, struct qstr *name,
 		if (dentry->d_inode || d_is_whiteout(dentry))
 			goto out_dput;
 
+		/* Stop the lookup on opaque parent and non-fallthru child */
+		if (IS_OPAQUE(nd->path.dentry->d_inode) && !d_is_fallthru(dentry))
+			goto out_dput;
+
 		dput(dentry);
 	}
 
@@ -526,9 +556,6 @@ static int __cache_lookup_build_union(struct nameidata *nd, struct qstr *name,
 			path_put(&last);
 		last.dentry = dentry;
 		last.mnt = mntget(nd->path.mnt);
-
-		if (IS_OPAQUE(last.dentry->d_inode))
-			break;
 	}
 
 	if (last.dentry != path->dentry)
@@ -568,8 +595,7 @@ static int cache_lookup_union(struct nameidata *nd, struct qstr *name,
 
 		/* only directories can be part of a union stack */
 		if (!path->dentry->d_inode ||
-		    !S_ISDIR(path->dentry->d_inode->i_mode) ||
-		    IS_OPAQUE(path->dentry->d_inode))
+		    !S_ISDIR(path->dentry->d_inode->i_mode))
 			goto out;
 
 		/* Build the union stack for this part */
@@ -736,6 +762,9 @@ static int __real_lookup_topmost(struct nameidata *nd, struct qstr *name,
 	if (path->dentry->d_inode || d_is_whiteout(path->dentry))
 		return 0;
 
+	if (IS_OPAQUE(nd->path.dentry->d_inode) && !d_is_fallthru(path->dentry))
+		return 0;
+
 	while (follow_union_down(&nd->path.mnt, &nd->path.dentry)) {
 		name->hash = full_name_hash(name->name, name->len);
 		if (nd->path.dentry->d_op && nd->path.dentry->d_op->d_hash) {
@@ -756,6 +785,9 @@ static int __real_lookup_topmost(struct nameidata *nd, struct qstr *name,
 			goto out;
 		}
 
+		if (IS_OPAQUE(nd->path.dentry->d_inode) && !d_is_fallthru(next.dentry))
+			goto out;
+
 		dput(next.dentry);
 	}
 out:
@@ -815,9 +847,6 @@ static int __real_lookup_build_union(struct nameidata *nd, struct qstr *name,
 			path_put(&last);
 		last.dentry = next.dentry;
 		last.mnt = mntget(next.mnt);
-
-		if (IS_OPAQUE(last.dentry->d_inode))
-			break;
 	}
 
 	if (last.dentry != path->dentry)
@@ -839,8 +868,7 @@ static int real_lookup_union(struct nameidata *nd, struct qstr *name,
 
 	/* only directories can be part of a union stack */
 	if (!path->dentry->d_inode ||
-	    !S_ISDIR(path->dentry->d_inode->i_mode) ||
-	    IS_OPAQUE(path->dentry->d_inode))
+	    !S_ISDIR(path->dentry->d_inode->i_mode))
 		goto out;
 
 	/* Build the union stack for this part */
@@ -1125,7 +1153,7 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 {
 	int err;
 
-	if (IS_MNT_UNION(nd->path.mnt) && !IS_OPAQUE(nd->path.dentry->d_inode))
+	if (IS_MNT_UNION(nd->path.mnt))
 		goto need_union_lookup;
 
 	path->dentry = __d_lookup(nd->path.dentry, name);
@@ -1622,6 +1650,9 @@ static int __hash_lookup_topmost(struct nameidata *nd, struct qstr *name,
 	if (path->dentry->d_inode || d_is_whiteout(path->dentry))
 		return 0;
 
+	if (IS_OPAQUE(nd->path.dentry->d_inode) && !d_is_fallthru(path->dentry))
+		return 0;
+
 	while (follow_union_down(&nd->path.mnt, &nd->path.dentry)) {
 		name->hash = full_name_hash(name->name, name->len);
 		if (nd->path.dentry->d_op && nd->path.dentry->d_op->d_hash) {
@@ -1644,6 +1675,9 @@ static int __hash_lookup_topmost(struct nameidata *nd, struct qstr *name,
 			goto out;
 		}
 
+		if (IS_OPAQUE(nd->path.dentry->d_inode) && !d_is_fallthru(next.dentry))
+			goto out;
+
 		dput(next.dentry);
 	}
 out:
@@ -1698,9 +1732,6 @@ static int __hash_lookup_build_union(struct nameidata *nd, struct qstr *name,
 			path_put(&last);
 		last.dentry = next.dentry;
 		last.mnt = mntget(next.mnt);
-
-		if (IS_OPAQUE(last.dentry->d_inode))
-			break;
 	}
 
 	if (last.dentry != path->dentry)
-- 
1.6.1.3

