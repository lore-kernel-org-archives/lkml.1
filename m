Return-Path: <linux-kernel-owner+w=401wt.eu-S1762259AbZFQUqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762259AbZFQUqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760251AbZFQUpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:45:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41343 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761523AbZFQUpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:45:11 -0400
From: Jan Blunck <jblunck@suse.de>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       vaurora@redhat.com, hch@lst.de, miklos@szeredi.hu
Subject: [PATCH] VFS: Introduce dput() variant that maintains a kill-list
Date: Wed, 17 Jun 2009 22:45:10 +0200
Message-Id: <1245271510-31542-7-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245271510-31542-1-git-send-email-jblunck@suse.de>
References: <1245271510-31542-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new variant of dput(). This becomes necessary to
prevent a recursive call to dput() from the union mount code.

  void __dput(struct dentry *dentry, struct list_head *list, int greedy);
  struct dentry *__d_kill(struct dentry *dentry, struct list_head *list,
  	 		  int greedy);

__dput() works mostly like the original dput() did. The main difference is
that if it the greedy argument is zero it will put the parent on a special
list instead of trying to get rid of it directly.

Therefore the union mount code can safely call __dput() when it wants to get
rid of underlying dentry references during a dput(). After calling __dput()
or __d_kill() the caller must make sure that __d_kill_final() is called on all
dentries on the kill list. __d_kill_final() is actually doing the
dentry_iput() and is also dereferencing the parent.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
---
 fs/dcache.c |  115 +++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 105 insertions(+), 10 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 191c488..7ab322e 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -157,14 +157,19 @@ static void dentry_lru_del_init(struct dentry *dentry)
 }
 
 /**
- * d_kill - kill dentry and return parent
+ * __d_kill - kill dentry and return parent
  * @dentry: dentry to kill
+ * @list: kill list
+ * @greedy: return parent instead of putting it on the kill list
  *
  * The dentry must already be unhashed and removed from the LRU.
  *
- * If this is the root of the dentry tree, return NULL.
+ * If this is the root of the dentry tree, return NULL. If greedy is zero, we
+ * put the parent of this dentry on the kill list instead. The callers must
+ * make sure that __d_kill_final() is called on all dentries on the kill list.
  */
-static struct dentry *d_kill(struct dentry *dentry)
+static struct dentry *__d_kill(struct dentry *dentry, struct list_head *list,
+			       int greedy)
 	__releases(dentry->d_lock)
 	__releases(dcache_lock)
 {
@@ -172,6 +177,20 @@ static struct dentry *d_kill(struct dentry *dentry)
 
 	list_del(&dentry->d_u.d_child);
 	dentry_stat.nr_dentry--;	/* For d_free, below */
+
+	/*
+	 * If we are not greedy we just put this on a list for later processing
+	 * (follow up to parent, releasing of inode and freeing dentry memory).
+	 */
+	if (!greedy) {
+		list_del_init(&dentry->d_alias);
+		/* at this point nobody can reach this dentry */
+		list_add(&dentry->d_lru, list);
+		spin_unlock(&dentry->d_lock);
+		spin_unlock(&dcache_lock);
+		return NULL;
+	}
+
 	/*drops the locks, at that point nobody can reach this dentry */
 	dentry_iput(dentry);
 	if (IS_ROOT(dentry))
@@ -182,6 +201,54 @@ static struct dentry *d_kill(struct dentry *dentry)
 	return parent;
 }
 
+void __dput(struct dentry *, struct list_head *, int);
+
+static void __d_kill_final(struct dentry *dentry, struct list_head *list)
+{
+	struct dentry *parent;
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
+	if (IS_ROOT(dentry))
+		parent = NULL;
+	else
+		parent = dentry->d_parent;
+	d_free(dentry);
+	__dput(parent, list, 1);
+}
+
+/**
+ * d_kill - kill dentry and return parent
+ * @dentry: dentry to kill
+ *
+ * The dentry must already be unhashed and removed from the LRU.
+ *
+ * If this is the root of the dentry tree, return NULL.
+ */
+static struct dentry *d_kill(struct dentry *dentry)
+{
+	LIST_HEAD(mortuary);
+	struct dentry *parent;
+
+	parent = __d_kill(dentry, &mortuary, 1);
+	while (!list_empty(&mortuary)) {
+		dentry = list_entry(mortuary.next, struct dentry, d_lru);
+		list_del(&dentry->d_lru);
+		__d_kill_final(dentry, &mortuary);
+	}
+
+	return parent;
+}
+
 /* 
  * This is dput
  *
@@ -199,19 +266,24 @@ static struct dentry *d_kill(struct dentry *dentry)
  * Real recursion would eat up our stack space.
  */
 
-/*
- * dput - release a dentry
- * @dentry: dentry to release 
+/**
+ * __dput - release a dentry
+ * @dentry: dentry to release
+ * @list: kill list argument for __d_kill()
+ * @greedy: greedy argument for __d_kill()
  *
  * Release a dentry. This will drop the usage count and if appropriate
  * call the dentry unlink method as well as removing it from the queues and
  * releasing its resources. If the parent dentries were scheduled for release
- * they too may now get deleted.
+ * they too may now get deleted if @greedy is not zero. Otherwise parent is
+ * added to the kill list. The callers must make sure that __d_kill_final() is
+ * called on all dentries on the kill list.
+ *
+ * You probably want to use dput() instead.
  *
  * no dcache lock, please.
  */
-
-void dput(struct dentry *dentry)
+void __dput(struct dentry *dentry, struct list_head *list, int greedy)
 {
 	if (!dentry)
 		return;
@@ -252,12 +324,35 @@ unhash_it:
 kill_it:
 	/* if dentry was on the d_lru list delete it from there */
 	dentry_lru_del(dentry);
-	dentry = d_kill(dentry);
+	dentry = __d_kill(dentry, list, greedy);
 	if (dentry)
 		goto repeat;
 }
 
 /**
+ * dput - release a dentry
+ * @dentry: dentry to release
+ *
+ * Release a dentry. This will drop the usage count and if appropriate
+ * call the dentry unlink method as well as removing it from the queues and
+ * releasing its resources. If the parent dentries were scheduled for release
+ * they too may now get deleted.
+ *
+ * no dcache lock, please.
+ */
+void dput(struct dentry *dentry)
+{
+	LIST_HEAD(mortuary);
+
+	__dput(dentry, &mortuary, 1);
+	while (!list_empty(&mortuary)) {
+		dentry = list_entry(mortuary.next, struct dentry, d_lru);
+		list_del(&dentry->d_lru);
+		__d_kill_final(dentry, &mortuary);
+	}
+}
+
+/**
  * d_invalidate - invalidate a dentry
  * @dentry: dentry to invalidate
  *
-- 
1.6.0.2

