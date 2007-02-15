Return-Path: <linux-kernel-owner+w=401wt.eu-S964896AbXBOEPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964896AbXBOEPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 23:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932629AbXBOEPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 23:15:21 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:60824 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932642AbXBOEPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 23:15:18 -0500
X-Sasl-enc: pCe0Pmd/lVdEARqBSqZBquIf5ofNoyvgmqrhHNOEIoCS 1171512914
Date: Thu, 15 Feb 2007 13:15:59 +0900 (WST)
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@osdl.org>
cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       ramana <intraperson@yahoo.com>
Subject: [PATCH 1/2] autofs4 - fix another race between mount and expire
Message-ID: <Pine.LNX.4.64.0702151252550.8001@raven.themaw.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

Jeff Moyer has identified a race between mount and expire.

What happens is that during an expire the situation can arise
that a directory is removed and another lookup is done before
the expire issues a completion status to the kernel module.
In this case, since the the lookup gets a new dentry, it doesn't
know that there is an expire in progress and when it posts its
mount request, matches the existing expire request and waits
for its completion. ENOENT is then returned to user space
from lookup (as the dentry passed in is now unhashed) without
having performed the mount request.

The solution used here is to keep track of dentrys in this
unhashed state and reuse them, if possible, in order to
preserve the flags. Additionally, this infrastructure will
provide the framework for the reintroduction of caching
of mount fails removed earlier in development.

Signed-off-by: Ian Kent <raven@themaw.net>
Acked-by: Jeff Moyer <jmoyer@redhat.com>

Ian

---

--- linux-2.6.20/fs/autofs4/autofs_i.h.lookup-expire-race	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.20/fs/autofs4/autofs_i.h	2007-02-12 12:15:17.000000000 +0900
@@ -52,6 +52,8 @@ struct autofs_info {
 
 	int		flags;
 
+	struct list_head rehash;
+
 	struct autofs_sb_info *sbi;
 	unsigned long last_used;
 	atomic_t count;
@@ -110,6 +112,8 @@ struct autofs_sb_info {
 	struct mutex wq_mutex;
 	spinlock_t fs_lock;
 	struct autofs_wait_queue *queues; /* Wait queue pointer */
+	spinlock_t rehash_lock;
+	struct list_head rehash_list;
 };
 
 static inline struct autofs_sb_info *autofs4_sbi(struct super_block *sb)
--- linux-2.6.20/fs/autofs4/root.c.lookup-expire-race	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.20/fs/autofs4/root.c	2007-02-12 12:14:51.000000000 +0900
@@ -263,7 +263,7 @@ static int try_to_fill_dentry(struct den
 		 */
 		status = d_invalidate(dentry);
 		if (status != -EBUSY)
-			return -ENOENT;
+			return -EAGAIN;
 	}
 
 	DPRINTK("dentry=%p %.*s ino=%p",
@@ -413,7 +413,16 @@ static int autofs4_revalidate(struct den
 		 */
 		status = try_to_fill_dentry(dentry, flags);
 		if (status == 0)
-				return 1;
+			return 1;
+
+		/*
+		 * A status of EAGAIN here means that the dentry has gone
+		 * away while waiting for an expire to complete. If we are
+		 * racing with expire lookup will wait for it so this must
+		 * be a revalidate and we need to send it to lookup.
+		 */
+		if (status == -EAGAIN)
+			return 0;
 
 		return status;
 	}
@@ -459,9 +468,18 @@ void autofs4_dentry_release(struct dentr
 	de->d_fsdata = NULL;
 
 	if (inf) {
+		struct autofs_sb_info *sbi = autofs4_sbi(de->d_sb);
+
 		inf->dentry = NULL;
 		inf->inode = NULL;
 
+		if (sbi) {
+			spin_lock(&sbi->rehash_lock);
+			if (!list_empty(&inf->rehash))
+				list_del(&inf->rehash);
+			spin_unlock(&sbi->rehash_lock);
+		}
+
 		autofs4_free_ino(inf);
 	}
 }
@@ -478,10 +496,80 @@ static struct dentry_operations autofs4_
 	.d_release	= autofs4_dentry_release,
 };
 
+static struct dentry *autofs4_lookup_unhashed(struct autofs_sb_info *sbi, struct dentry *parent, struct qstr *name)
+{
+	unsigned int len = name->len;
+	unsigned int hash = name->hash;
+	const unsigned char *str = name->name;
+	struct list_head *p, *head;
+
+	spin_lock(&dcache_lock);
+	spin_lock(&sbi->rehash_lock);
+	head = &sbi->rehash_list;
+	list_for_each(p, head) {
+		struct autofs_info *ino;
+		struct dentry *dentry;
+		struct qstr *qstr;
+
+		ino = list_entry(p, struct autofs_info, rehash);
+		dentry = ino->dentry;
+
+		spin_lock(&dentry->d_lock);
+
+		/* Bad luck, we've already been dentry_iput */
+		if (!dentry->d_inode)
+			goto next;
+
+		qstr = &dentry->d_name;
+
+		if (dentry->d_name.hash != hash)
+			goto next;
+		if (dentry->d_parent != parent)
+			goto next;
+
+		if (qstr->len != len)
+			goto next;
+		if (memcmp(qstr->name, str, len))
+			goto next;
+
+		if (d_unhashed(dentry)) {
+			struct autofs_info *ino = autofs4_dentry_ino(dentry);
+			struct inode *inode = dentry->d_inode;
+
+			list_del_init(&ino->rehash);
+			dget(dentry);
+			/*
+			 * Make the rehashed dentry negative so the VFS
+			 * behaves as it should.
+			 */
+			if (inode) {
+				dentry->d_inode = NULL;
+				list_del_init(&dentry->d_alias);
+				spin_unlock(&dentry->d_lock);
+				spin_unlock(&sbi->rehash_lock);
+				spin_unlock(&dcache_lock);
+				iput(inode);
+				return dentry;
+			}
+			spin_unlock(&dentry->d_lock);
+			spin_unlock(&sbi->rehash_lock);
+			spin_unlock(&dcache_lock);
+			return dentry;
+		}
+next:
+		spin_unlock(&dentry->d_lock);
+	}
+	spin_unlock(&sbi->rehash_lock);
+	spin_unlock(&dcache_lock);
+
+	return NULL;
+}
+
 /* Lookups in the root directory */
 static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 {
 	struct autofs_sb_info *sbi;
+	struct dentry *unhashed;
 	int oz_mode;
 
 	DPRINTK("name = %.*s",
@@ -497,25 +585,46 @@ static struct dentry *autofs4_lookup(str
 	DPRINTK("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d",
 		 current->pid, process_group(current), sbi->catatonic, oz_mode);
 
-	/*
-	 * Mark the dentry incomplete, but add it. This is needed so
-	 * that the VFS layer knows about the dentry, and we can count
-	 * on catching any lookups through the revalidate.
-	 *
-	 * Let all the hard work be done by the revalidate function that
-	 * needs to be able to do this anyway..
-	 *
-	 * We need to do this before we release the directory semaphore.
-	 */
-	dentry->d_op = &autofs4_root_dentry_operations;
+	unhashed = autofs4_lookup_unhashed(sbi, dentry->d_parent, &dentry->d_name);
+	if (!unhashed) {
+		/*
+		 * Mark the dentry incomplete, but add it. This is needed so
+		 * that the VFS layer knows about the dentry, and we can count
+		 * on catching any lookups through the revalidate.
+		 *
+		 * Let all the hard work be done by the revalidate function that
+		 * needs to be able to do this anyway..
+		 *
+		 * We need to do this before we release the directory semaphore.
+		 */
+		dentry->d_op = &autofs4_root_dentry_operations;
+
+		dentry->d_fsdata = NULL;
+		d_add(dentry, NULL);
+	} else {
+		struct autofs_info *ino = autofs4_dentry_ino(unhashed);
+		DPRINTK("rehash %p with %p", dentry, unhashed);
+		/*
+		 * If we are racing with expire the request might not
+		 * be quite complete but the directory has been removed
+		 * so it must have been successful, so just wait for it.
+		 */
+		if (ino && (ino->flags & AUTOFS_INF_EXPIRING)) {
+			DPRINTK("wait for incomplete expire %p name=%.*s",
+				unhashed, unhashed->d_name.len,
+				unhashed->d_name.name);
+			autofs4_wait(sbi, unhashed, NFY_NONE);
+			DPRINTK("request completed");
+		}
+		d_rehash(unhashed);
+		dentry = unhashed;
+	}
 
 	if (!oz_mode) {
 		spin_lock(&dentry->d_lock);
 		dentry->d_flags |= DCACHE_AUTOFS_PENDING;
 		spin_unlock(&dentry->d_lock);
 	}
-	dentry->d_fsdata = NULL;
-	d_add(dentry, NULL);
 
 	if (dentry->d_op && dentry->d_op->d_revalidate) {
 		mutex_unlock(&dir->i_mutex);
@@ -534,6 +643,8 @@ static struct dentry *autofs4_lookup(str
 			if (sigismember (sigset, SIGKILL) ||
 			    sigismember (sigset, SIGQUIT) ||
 			    sigismember (sigset, SIGINT)) {
+			    if (unhashed)
+				dput(unhashed);
 			    return ERR_PTR(-ERESTARTNOINTR);
 			}
 		}
@@ -548,8 +659,14 @@ static struct dentry *autofs4_lookup(str
 	 * doesn't do the right thing for all system calls, but it should
 	 * be OK for the operations we permit from an autofs.
 	 */
-	if (dentry->d_inode && d_unhashed(dentry))
+	if (dentry->d_inode && d_unhashed(dentry)) {
+		if (unhashed)
+			dput(unhashed);
 		return ERR_PTR(-ENOENT);
+	}
+
+	if (unhashed)
+		return dentry;
 
 	return NULL;
 }
@@ -611,9 +728,10 @@ static int autofs4_dir_symlink(struct in
  * Normal filesystems would do a "d_delete()" to tell the VFS dcache
  * that the file no longer exists. However, doing that means that the
  * VFS layer can turn the dentry into a negative dentry.  We don't want
- * this, because since the unlink is probably the result of an expire.
- * We simply d_drop it, which allows the dentry lookup to remount it
- * if necessary.
+ * this, because the unlink is probably the result of an expire.
+ * We simply d_drop it and add it to a rehash candidates list in the
+ * super block, which allows the dentry lookup to reuse it retaining
+ * the flags, such as expire in progress, in case we're racing with expire.
  *
  * If a process is blocked on the dentry waiting for the expire to finish,
  * it will invalidate the dentry and try to mount with a new one.
@@ -642,7 +760,14 @@ static int autofs4_dir_unlink(struct ino
 
 	dir->i_mtime = CURRENT_TIME;
 
-	d_drop(dentry);
+	spin_lock(&dcache_lock);
+	spin_lock(&sbi->rehash_lock);
+	list_add(&ino->rehash, &sbi->rehash_list);
+	spin_unlock(&sbi->rehash_lock);
+	spin_lock(&dentry->d_lock);
+	__d_drop(dentry);
+	spin_unlock(&dentry->d_lock);
+	spin_unlock(&dcache_lock);
 
 	return 0;
 }
@@ -653,6 +778,9 @@ static int autofs4_dir_rmdir(struct inod
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	struct autofs_info *p_ino;
 	
+	DPRINTK("dentry %p, removing %.*s",
+		dentry, dentry->d_name.len, dentry->d_name.name);
+
 	if (!autofs4_oz_mode(sbi))
 		return -EACCES;
 
@@ -661,6 +789,9 @@ static int autofs4_dir_rmdir(struct inod
 		spin_unlock(&dcache_lock);
 		return -ENOTEMPTY;
 	}
+	spin_lock(&sbi->rehash_lock);
+	list_add(&ino->rehash, &sbi->rehash_list);
+	spin_unlock(&sbi->rehash_lock);
 	spin_lock(&dentry->d_lock);
 	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
--- linux-2.6.20/fs/autofs4/inode.c.lookup-expire-race	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.20/fs/autofs4/inode.c	2007-02-12 12:16:27.000000000 +0900
@@ -48,6 +48,8 @@ struct autofs_info *autofs4_init_ino(str
 	ino->dentry = NULL;
 	ino->size = 0;
 
+	INIT_LIST_HEAD(&ino->rehash);
+
 	ino->last_used = jiffies;
 	atomic_set(&ino->count, 0);
 
@@ -158,14 +160,13 @@ void autofs4_kill_sb(struct super_block 
 	if (!sbi)
 		goto out_kill_sb;
 
-	sb->s_fs_info = NULL;
-
-	if ( !sbi->catatonic )
+	if (!sbi->catatonic)
 		autofs4_catatonic_mode(sbi); /* Free wait queues, close pipe */
 
 	/* Clean up and release dangling references */
 	autofs4_force_release(sbi);
 
+	sb->s_fs_info = NULL;
 	kfree(sbi);
 
 out_kill_sb:
@@ -336,6 +337,8 @@ int autofs4_fill_super(struct super_bloc
 	mutex_init(&sbi->wq_mutex);
 	spin_lock_init(&sbi->fs_lock);
 	sbi->queues = NULL;
+	spin_lock_init(&sbi->rehash_lock);
+	INIT_LIST_HEAD(&sbi->rehash_list);
 	s->s_blocksize = 1024;
 	s->s_blocksize_bits = 10;
 	s->s_magic = AUTOFS_SUPER_MAGIC;
