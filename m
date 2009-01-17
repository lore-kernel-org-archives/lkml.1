Return-Path: <linux-kernel-owner+w=401wt.eu-S937836AbZAQCbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937836AbZAQCbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 21:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756639AbZAQC3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 21:29:53 -0500
Received: from smtp-out.google.com ([216.239.45.13]:20123 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759714AbZAQC3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 21:29:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=eAqzfjtHWDftERJ8GNDR2WvoKp4pMynrjky+bRhoj2h35kX5oGGJVE7Ub4zTYptF+
	aiCT+h5M9ZgAfKaMnrDWw==
From: Mike Waychison <mikew@google.com>
Subject: [PATCH v1 2/8] Parallel dput()
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Fri, 16 Jan 2009 18:29:47 -0800
Message-ID: <20090117022947.20425.73786.stgit@crlf.corp.google.com>
In-Reply-To: <20090117022936.20425.43248.stgit@crlf.corp.google.com>
References: <20090117022936.20425.43248.stgit@crlf.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.24.198.77
X-GMailtapped: mikew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implementation of batched dput() which only grabs the dcache_lock once per
batch of dentries.

process_postponed_dentries() now operates on dentries in two phases.  The first
phase is done with dcache_lock held, in which postponed_dput() will take care
of transition the dentry to the LRU, dropping it or killing it.  Note that we
have to enqueue both the dentry and inode seperately as the dentry becomes
negative under lock.

Parents are enqueued and processed immediately because we wish to avoid
recursion.  When enqueing denries for the second phase, we enqueue the child
dentry on a second list (postponed_dentries->pending_dentry_iput.dentries) as
we re-use the original list (postponed_dentries->pending_dput.dentries) as we
discover parents requiring dput.

The second phase handles what is left over from the original dentry_iput
(namely fsnotify, iput and dfree).

Signed-off-by: Mike Waychison <mikew@google.com>
---

 fs/dcache.c |  156 +++++++++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 115 insertions(+), 41 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index ea6b8f0..9760bdb 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -157,32 +157,6 @@ static void dentry_lru_del_init(struct dentry *dentry)
 	}
 }
 
-/**
- * d_kill - kill dentry and return parent
- * @dentry: dentry to kill
- *
- * The dentry must already be unhashed and removed from the LRU.
- *
- * If this is the root of the dentry tree, return NULL.
- */
-static struct dentry *d_kill(struct dentry *dentry)
-	__releases(dentry->d_lock)
-	__releases(dcache_lock)
-{
-	struct dentry *parent;
-
-	list_del(&dentry->d_u.d_child);
-	dentry_stat.nr_dentry--;	/* For d_free, below */
-	/*drops the locks, at that point nobody can reach this dentry */
-	dentry_iput(dentry);
-	if (IS_ROOT(dentry))
-		parent = NULL;
-	else
-		parent = dentry->d_parent;
-	d_free(dentry);
-	return parent;
-}
-
 struct postponed_dentries {
 	unsigned size;
 	struct {
@@ -261,6 +235,15 @@ static void add_pending_dput(struct postponed_dentries *ppd,
 	ppd->pending_dput.dentries[ppd->pending_dput.nr++] = dentry;
 }
 
+static void add_pending_dentry_iput(struct postponed_dentries *ppd,
+				    struct dentry *dentry,
+				    struct inode *inode)
+{
+	unsigned nr = ppd->pending_dentry_iput.nr++;
+	ppd->pending_dentry_iput.dentries[nr] = dentry;
+	ppd->pending_dentry_iput.inodes[nr] = inode;
+}
+
 static DEFINE_PER_CPU(struct postponed_dentries *, postponed_dentries);
 
 static int initialize_postponed_dentries(long cpu)
@@ -300,20 +283,69 @@ static struct notifier_block __cpuinitdata dentry_put_cache_notifier = {
 	&cpuup_callback, NULL, 0
 };
 
-static void real_dput(struct dentry *dentry)
+/**
+ * d_kill - kill dentry and return parent
+ * @dentry: dentry to kill
+ *
+ * The dentry must already be unhashed and removed from the LRU.
+ *
+ * If this is the root of the dentry tree, return NULL.
+ */
+static struct dentry *d_kill(struct dentry *dentry)
+	__releases(dentry->d_lock)
+	__releases(dcache_lock)
 {
-	/* Legacy: */
-repeat:
-	spin_lock(&dcache_lock);
-	if (atomic_dec_and_test(&dentry->d_count)) {
-		spin_unlock(&dcache_lock);
-		return;
+	struct dentry *parent;
+
+	list_del(&dentry->d_u.d_child);
+	dentry_stat.nr_dentry--;	/* For d_free, below */
+	/*drops the locks, at that point nobody can reach this dentry */
+	dentry_iput(dentry);
+	parent = dentry->d_parent;
+	d_free(dentry);
+	return dentry == parent ? NULL : parent;
+}
+
+/**
+ * d_kill_batched - kill dentry and add parent to delayed batch.
+ * @ppd: postponed dentries to enqueue dentry_iput and parent if any.
+ * @dentry: dentry to kill
+ *
+ * The dentry must already be unhashed and removed from the LRU.
+ *
+ * Called with dentry->d_lock and dcache_lock held.  Drops dentry->d_lock.
+ */
+static void d_kill_batched(struct postponed_dentries *ppd,
+			  struct dentry *dentry)
+	__releases(dentry->d_lock)
+{
+	struct inode *inode = dentry->d_inode;
+	struct dentry *parent;
+
+	list_del(&dentry->d_u.d_child);
+	dentry_stat.nr_dentry--;	/* For d_free, below */
+	/* Open coded first half to dentry_iput */
+	if (inode) {
+		dentry->d_inode = NULL;
+		list_del_init(&dentry->d_alias);
 	}
+	spin_unlock(&dentry->d_lock);
+	add_pending_dentry_iput(ppd, dentry, inode);
+	parent = dentry->d_parent;
+	if (parent && parent != dentry)
+		add_pending_dput(ppd, parent);
+}
+
+static void postponed_dput(struct postponed_dentries *ppd,
+			   struct dentry *dentry)
+{
+	if (!atomic_dec_and_test(&dentry->d_count))
+		return;
 
 	spin_lock(&dentry->d_lock);
-	if (atomic_read(&dentry->d_count)) {
+	if (atomic_read(&dentry->d_count) != 0) {
+		/* Raced -- dentry still in use */
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
 		return;
 	}
 
@@ -332,7 +364,6 @@ repeat:
 		dentry_lru_add(dentry);
 	}
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 	return;
 
 unhash_it:
@@ -340,18 +371,61 @@ unhash_it:
 kill_it:
 	/* if dentry was on the d_lru list delete it from there */
 	dentry_lru_del(dentry);
-	dentry = d_kill(dentry);
-	if (dentry)
-		goto repeat;
+	d_kill_batched(ppd, dentry);
+}
+
+static void postponed_dentry_iput(struct postponed_dentries *ppd,
+				  struct dentry *dentry,
+				  struct inode *inode)
+{
+	if (inode) {
+		if (!inode->i_nlink)
+			fsnotify_inoderemove(inode);
+		if (dentry->d_op && dentry->d_op->d_iput)
+			dentry->d_op->d_iput(dentry, inode);
+		else
+			iput(inode);
+	}
+	d_free(dentry);
 }
 
 static void process_postponed_dentries(struct postponed_dentries *ppd)
 {
 	unsigned i;
+	unsigned nr;
 
-	for (i = 0; i < ppd->pending_dput.nr; i++)
-		real_dput(ppd->pending_dput.dentries[i]);
+repeat:
+	/*
+	 * Begin by making sure that the list of dentries queued for
+	 * dentry_iput is empty.
+	 */
+	ppd->pending_dentry_iput.nr = 0;
+
+	/*
+	 * Save off the length of the queue of dentries queued as we re-use the
+	 * array in-place as we discover parent dentries in the first pass.
+	 */
+	nr = ppd->pending_dput.nr;
+	ppd->pending_dput.nr = 0;
+
+	/* First pass: we remove the dentries from the dcache. */
+	spin_lock(&dcache_lock);
+	for (i = 0; i < nr; i++)
+		postponed_dput(ppd, ppd->pending_dput.dentries[i]);
+	spin_unlock(&dcache_lock);
+
+	/* Second pass: Go through and process anything pending dentry_iput */
+	for (i = 0; i < ppd->pending_dentry_iput.nr; i++) {
+		postponed_dentry_iput(ppd,
+				      ppd->pending_dentry_iput.dentries[i],
+				      ppd->pending_dentry_iput.inodes[i]);
+	}
+
+	/* Did we discover any parent dentries? */
+	if (ppd->pending_dput.nr)
+		goto repeat;
 }
+
 /* 
  * This is dput
  *

