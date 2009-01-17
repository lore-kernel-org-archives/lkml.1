Return-Path: <linux-kernel-owner+w=401wt.eu-S938100AbZAQCdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938100AbZAQCdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 21:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934380AbZAQCaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 21:30:11 -0500
Received: from smtp-out.google.com ([216.239.33.17]:20685 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934324AbZAQCaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 21:30:07 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=onxMTbocjfnfPpdxSiu+mdjStGDw8LeiRBNFJ5A3LIW0L5qxRNPgp7ZM3BpOSTPIc
	Mho1/TVqQBy2dzHyCzv4w==
From: Mike Waychison <mikew@google.com>
Subject: [PATCH v1 5/8] Parallelize iput()
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Fri, 16 Jan 2009 18:30:02 -0800
Message-ID: <20090117023002.20425.93106.stgit@crlf.corp.google.com>
In-Reply-To: <20090117022936.20425.43248.stgit@crlf.corp.google.com>
References: <20090117022936.20425.43248.stgit@crlf.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.75
X-GMailtapped: mikew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have deffered batching of iputs, we can parallelize the
finalization of inodes to minimize the grabbing of inode_lock.

iput actually grabs the inode_lock twice as it needs to transition the state of
the inode into a finalizing state (I_FREEING, I_WILLFREE) before it can start
flushing the inode out.  It then needs to grab the lock again to unhash it
before releasing the lock and freeing the inode.

This patch turns the drop_inode callbacks in the VFS to this four phase
approach.  I opted to introduce a phase enum and have the callbacks switch on
it rather than creating three new callbacks each.

Signed-off-by: Mike Waychison <mikew@google.com>
---

 fs/inode.c         |  219 +++++++++++++++++++++++++++++++++++++---------------
 include/linux/fs.h |   13 ++-
 2 files changed, 167 insertions(+), 65 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 9aa574d..e19c6ea 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1151,71 +1151,87 @@ EXPORT_SYMBOL(remove_inode_hash);
  * I_FREEING is set so that no-one will take a new reference to the inode while
  * it is being deleted.
  */
-void generic_delete_inode(struct inode *inode)
+int generic_delete_inode(struct inode *inode, enum drop_inode_phase phase)
 {
 	const struct super_operations *op = inode->i_sb->s_op;
 
-	list_del_init(&inode->i_list);
-	list_del_init(&inode->i_sb_list);
-	inode->i_state |= I_FREEING;
-	inodes_stat.nr_inodes--;
-	spin_unlock(&inode_lock);
-
-	security_inode_delete(inode);
-
-	if (op->delete_inode) {
-		void (*delete)(struct inode *) = op->delete_inode;
-		if (!is_bad_inode(inode))
-			DQUOT_INIT(inode);
-		/* Filesystems implementing their own
-		 * s_op->delete_inode are required to call
-		 * truncate_inode_pages and clear_inode()
-		 * internally */
-		delete(inode);
-	} else {
-		truncate_inode_pages(&inode->i_data, 0);
-		clear_inode(inode);
+	switch (phase) {
+	case DIP_START_FREEING:
+		list_del_init(&inode->i_list);
+		list_del_init(&inode->i_sb_list);
+		inode->i_state |= I_FREEING;
+		inodes_stat.nr_inodes--;
+		break;
+	case DIP_DELETING:
+		security_inode_delete(inode);
+		if (op->delete_inode) {
+			void (*delete)(struct inode *) = op->delete_inode;
+			if (!is_bad_inode(inode))
+				DQUOT_INIT(inode);
+			/* Filesystems implementing their own
+			 * s_op->delete_inode are required to call
+			 * truncate_inode_pages and clear_inode()
+			 * internally */
+			delete(inode);
+		} else {
+			truncate_inode_pages(&inode->i_data, 0);
+			clear_inode(inode);
+		}
+		break;
+	case DIP_UNHASHING:
+		hlist_del_init(&inode->i_hash);
+		break;
+	case DIP_DESTROYING:
+		wake_up_inode(inode);
+		BUG_ON(inode->i_state != I_CLEAR);
+		destroy_inode(inode);
+		break;
 	}
-	spin_lock(&inode_lock);
-	hlist_del_init(&inode->i_hash);
-	spin_unlock(&inode_lock);
-	wake_up_inode(inode);
-	BUG_ON(inode->i_state != I_CLEAR);
-	destroy_inode(inode);
+	return 0;
 }
 
 EXPORT_SYMBOL(generic_delete_inode);
 
-static void generic_forget_inode(struct inode *inode)
+static int generic_forget_inode(struct inode *inode,
+				enum drop_inode_phase phase)
 {
 	struct super_block *sb = inode->i_sb;
 
-	if (!hlist_unhashed(&inode->i_hash)) {
-		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
-			list_move(&inode->i_list, &inode_unused);
-		inodes_stat.nr_unused++;
-		if (sb->s_flags & MS_ACTIVE) {
-			spin_unlock(&inode_lock);
-			return;
+	switch (phase) {
+	case DIP_START_FREEING:
+		if (!hlist_unhashed(&inode->i_hash)) {
+			if (!(inode->i_state & (I_DIRTY|I_SYNC)))
+				list_move(&inode->i_list, &inode_unused);
+			inodes_stat.nr_unused++;
+			if (sb->s_flags & MS_ACTIVE)
+				return 1;
+			inode->i_state |= I_WILL_FREE;
 		}
-		inode->i_state |= I_WILL_FREE;
-		spin_unlock(&inode_lock);
-		write_inode_now(inode, 1);
-		spin_lock(&inode_lock);
-		inode->i_state &= ~I_WILL_FREE;
-		inodes_stat.nr_unused--;
-		hlist_del_init(&inode->i_hash);
+		break;
+	case DIP_DELETING:
+		if (!hlist_unhashed(&inode->i_hash))
+			write_inode_now(inode, 1);
+		break;
+	case DIP_UNHASHING:
+		if (!hlist_unhashed(&inode->i_hash)) {
+			inode->i_state &= ~I_WILL_FREE;
+			inodes_stat.nr_unused--;
+			hlist_del_init(&inode->i_hash);
+		}
+		list_del_init(&inode->i_list);
+		list_del_init(&inode->i_sb_list);
+		inode->i_state |= I_FREEING;
+		inodes_stat.nr_inodes--;
+		break;
+	case DIP_DESTROYING:
+		if (inode->i_data.nrpages)
+			truncate_inode_pages(&inode->i_data, 0);
+		clear_inode(inode);
+		wake_up_inode(inode);
+		destroy_inode(inode);
+		break;
 	}
-	list_del_init(&inode->i_list);
-	list_del_init(&inode->i_sb_list);
-	inode->i_state |= I_FREEING;
-	inodes_stat.nr_inodes--;
-	spin_unlock(&inode_lock);
-	if (inode->i_data.nrpages)
-		truncate_inode_pages(&inode->i_data, 0);
-	clear_inode(inode);
-	wake_up_inode(inode);
-	destroy_inode(inode);
+	return 0;
 }
 
 /*
@@ -1223,16 +1239,34 @@ static void generic_forget_inode(struct inode *inode)
  * inode when the usage count drops to zero, and
  * i_nlink is zero.
  */
-void generic_drop_inode(struct inode *inode)
+int generic_drop_inode(struct inode *inode, enum drop_inode_phase phase)
 {
 	if (!inode->i_nlink)
-		generic_delete_inode(inode);
+		return generic_delete_inode(inode, phase);
 	else
-		generic_forget_inode(inode);
+		return generic_forget_inode(inode, phase);
 }
 
 EXPORT_SYMBOL_GPL(generic_drop_inode);
 
+
+typedef int (*drop_op_t)(struct inode *inode, enum drop_inode_phase phase);
+static drop_op_t drop_op(struct inode *inode)
+{
+	const struct super_operations *op = inode->i_sb->s_op;
+	drop_op_t drop = generic_drop_inode;
+
+	if (op && op->drop_inode)
+		drop = op->drop_inode;
+	return drop;
+}
+
+static int drop_inode_phase(struct inode *inode, enum drop_inode_phase phase)
+{
+	drop_op_t drop = drop_op(inode);
+	return drop(inode, phase);
+}
+
 /*
  * Called when we're dropping the last reference
  * to an inode. 
@@ -1246,12 +1280,16 @@ EXPORT_SYMBOL_GPL(generic_drop_inode);
  */
 static inline void iput_final(struct inode *inode)
 {
-	const struct super_operations *op = inode->i_sb->s_op;
-	void (*drop)(struct inode *) = generic_drop_inode;
+	drop_op_t drop = drop_op(inode);
 
-	if (op && op->drop_inode)
-		drop = op->drop_inode;
-	drop(inode);
+	if (drop(inode, DIP_START_FREEING))
+		return;
+	spin_unlock(&inode_lock);
+	drop(inode, DIP_DELETING);
+	spin_lock(&inode_lock);
+	drop(inode, DIP_UNHASHING);
+	spin_unlock(&inode_lock);
+	drop(inode, DIP_DESTROYING);
 }
 
 static void real_iput(struct inode *inode)
@@ -1320,9 +1358,66 @@ static void add_pending_iput(struct postponed_inodes *ppi, struct inode *inode)
 
 static void process_postponed_inodes(struct postponed_inodes *ppi)
 {
+	struct inode *inode;
 	unsigned i;
-	for (i = 0; i < ppi->nr; i++)
-		real_iput(ppi->inodes[i]);
+
+	/*
+	 * Parallel iput is done in four phases:
+	 *
+	 * A) Removing the inode from sb lists and marking the inode as
+	 *    I_FREEING under inode_lock.
+	 * B) Deleting/truncating/clearing the inode with no lock.
+	 * C) Unhashing the inode under inode_lock.
+	 * D) Issuing a wakeup on the inode and destroying.
+	 */
+
+	/*
+	 * Phase (A) Removing inodes from the super_blocks.  We do this under
+	 * lock and may discover inodes that aren't unused anymore.
+	 *
+	 * Phase (A) may be cancelled by the fs, in which case we just forget
+	 * we were looking at the inode.
+	 */
+	spin_lock(&inode_lock);
+	for (i = 0; i < ppi->nr; i++) {
+		int ret;
+		inode = ppi->inodes[i];
+		if (!atomic_dec_and_test(&inode->i_count)) {
+			/* Someone is using this guy. */
+			ppi->inodes[i] = NULL;
+			continue;
+		}
+		ret = drop_inode_phase(inode, DIP_START_FREEING);
+		if (ret)
+			ppi->inodes[i] = NULL;
+	}
+	spin_unlock(&inode_lock);
+
+	/* Phase (B).  Deleting of the inode, which may incur writeout. */
+	for (i = 0; i < ppi->nr; i++) {
+		inode = ppi->inodes[i];
+		if (!inode)
+			continue;
+		drop_inode_phase(inode, DIP_DELETING);
+	}
+
+	/* Phase (C). Unhashing of the inode. */
+	spin_lock(&inode_lock);
+	for (i = 0; i < ppi->nr; i++) {
+		inode = ppi->inodes[i];
+		if (!inode)
+			continue;
+		drop_inode_phase(inode, DIP_UNHASHING);
+	}
+	spin_unlock(&inode_lock);
+
+	/* Phase (D).  Destroying of the in-core inode. */
+	for (i = 0; i < ppi->nr; i++) {
+		inode = ppi->inodes[i];
+		if (!inode)
+			continue;
+		drop_inode_phase(inode, DIP_DESTROYING);
+	}
 }
 
 static void release_postponed_inodes(struct postponed_inodes *ppi)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index aa90620..a7822cd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1374,13 +1374,20 @@ extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
 extern ssize_t vfs_writev(struct file *, const struct iovec __user *,
 		unsigned long, loff_t *);
 
+enum drop_inode_phase {
+	DIP_START_FREEING,
+	DIP_DELETING,
+	DIP_UNHASHING,
+	DIP_DESTROYING,
+};
+
 struct super_operations {
    	struct inode *(*alloc_inode)(struct super_block *sb);
 	void (*destroy_inode)(struct inode *);
 
    	void (*dirty_inode) (struct inode *);
 	int (*write_inode) (struct inode *, int);
-	void (*drop_inode) (struct inode *);
+	int (*drop_inode) (struct inode *, enum drop_inode_phase phase);
 	void (*delete_inode) (struct inode *);
 	void (*put_super) (struct super_block *);
 	void (*write_super) (struct super_block *);
@@ -1907,8 +1914,8 @@ extern void iput(struct inode *);
 extern struct inode * igrab(struct inode *);
 extern ino_t iunique(struct super_block *, ino_t);
 extern int inode_needs_sync(struct inode *inode);
-extern void generic_delete_inode(struct inode *inode);
-extern void generic_drop_inode(struct inode *inode);
+extern int generic_delete_inode(struct inode *inode, enum drop_inode_phase);
+extern int generic_drop_inode(struct inode *inode, enum drop_inode_phase);
 extern void iput_drain_cpu(void);
 extern void iput_drain_all(void);
 

