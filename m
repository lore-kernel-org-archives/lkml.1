Return-Path: <linux-kernel-owner+w=401wt.eu-S1759880AbYFLLXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880AbYFLLXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 07:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbYFLLXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 07:23:13 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:40293 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753468AbYFLLXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 07:23:11 -0400
X-Sasl-enc: c64rznIfT2XcnYKVort1Lz3zhcV87yPWA7FCJSVMAPHr 1213269788
Subject: Re: Linux 2.6.26-rc4
From: Ian Kent <raven@themaw.net>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Jeff Moyer <jmoyer@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1213239782.4994.79.camel@raven.themaw.net>
References: <20080603105258.GV28946@ZenIV.linux.org.uk>
	 <1212499623.3025.46.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org>
	 <1212509263.3025.66.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030926330.3473@woody.linux-foundation.org>
	 <1212513189.3025.101.camel@raven.themaw.net>
	 <20080603173029.GD28946@ZenIV.linux.org.uk>
	 <x49ej7ejtry.fsf@segfault.boston.devel.redhat.com>
	 <20080603191859.GG28946@ZenIV.linux.org.uk>
	 <x49abi2jnwf.fsf@segfault.boston.devel.redhat.com>
	 <20080603230026.GH28946@ZenIV.linux.org.uk>
	 <1212547323.3146.45.camel@raven.themaw.net>
	 <1213073861.3024.34.camel@raven.themaw.net>  <484E1F20.4060804@krogh.cc>
	 <1213080010.3024.42.camel@raven.themaw.net>
	 <1213239782.4994.79.camel@raven.themaw.net>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 19:19:02 +0800
Message-Id: <1213269543.4994.102.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-12 at 11:03 +0800, Ian Kent wrote:
> On Tue, 2008-06-10 at 14:40 +0800, Ian Kent wrote:
> > > >>> So what happens if new lookup hits between umount and rmdir?
> > > >> It will wait for the expire to complete and then wait for a mount
> > > >> request to the daemon.
> > > > 
> > > > Actually, that explanation is a bit simple minded.
> > > > 
> > > > It should wait for the expire in ->revalidate().
> > > > Following the expire completion d_invalidate() should return 0, since
> > > > the dentry is now unhashed, which causes ->revalidate() to return 0.
> > > > do_lookup() should see this and call a ->lookup().
> > > > 
> > > > But maybe I've missed something as I'm seeing a problem now.
> > > 
> > > Ok. Ive been running on the patch for a few days now .. and didn't see
> > > any problems. But that being said, I also turned off the --ghost option
> > > to autofs so if it actually is the patch or the different codepaths
> > > being used, I dont know. Since this is a production system, I'm a bit
> > > reluctant to just change a working setup to test it out.
> > 
> > No need to change anything.
> 
> There is a problem with the patch I posted.
> It will allow an incorrect ENOENT return in some cases.
> 
> The patch below is sufficiently different to the original patch I posted
> to warrant a replacement rather than a correction.
> 
> If you can find a way to test this out that would be great.

Oops, I must have not set the Preformat option in Evolution, let me try
again.

autofs4 - don't make expiring dentry negative

From: Ian Kent <raven@themaw.net>

Correct the error of making a positive dentry negative after it has been
instantiated.

This involves removing the code in autofs4_lookup_unhashed() that makes
the dentry negative and updating autofs4_lookup() to check for an
unfinished expire and wait if needed. The dentry used for the lookup
must be negative for mounts to trigger in the required cases so the
dentry can't be re-used (which is probably for the better anyway).

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/autofs_i.h |    6 +--
 fs/autofs4/inode.c    |    6 +--
 fs/autofs4/root.c     |  115 ++++++++++++++++++-------------------------------
 3 files changed, 49 insertions(+), 78 deletions(-)


diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index c3d352d..69b1497 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -52,7 +52,7 @@ struct autofs_info {
 
 	int		flags;
 
-	struct list_head rehash;
+	struct list_head expiring;
 
 	struct autofs_sb_info *sbi;
 	unsigned long last_used;
@@ -112,8 +112,8 @@ struct autofs_sb_info {
 	struct mutex wq_mutex;
 	spinlock_t fs_lock;
 	struct autofs_wait_queue *queues; /* Wait queue pointer */
-	spinlock_t rehash_lock;
-	struct list_head rehash_list;
+	spinlock_t lookup_lock;
+	struct list_head expiring_list;
 };
 
 static inline struct autofs_sb_info *autofs4_sbi(struct super_block *sb)
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 2fdcf5e..94bfc15 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -47,7 +47,7 @@ struct autofs_info *autofs4_init_ino(struct autofs_info *ino,
 	ino->dentry = NULL;
 	ino->size = 0;
 
-	INIT_LIST_HEAD(&ino->rehash);
+	INIT_LIST_HEAD(&ino->expiring);
 
 	ino->last_used = jiffies;
 	atomic_set(&ino->count, 0);
@@ -338,8 +338,8 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	mutex_init(&sbi->wq_mutex);
 	spin_lock_init(&sbi->fs_lock);
 	sbi->queues = NULL;
-	spin_lock_init(&sbi->rehash_lock);
-	INIT_LIST_HEAD(&sbi->rehash_list);
+	spin_lock_init(&sbi->lookup_lock);
+	INIT_LIST_HEAD(&sbi->expiring_list);
 	s->s_blocksize = 1024;
 	s->s_blocksize_bits = 10;
 	s->s_magic = AUTOFS_SUPER_MAGIC;
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index edf5b6b..2e8959c 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -493,10 +493,10 @@ void autofs4_dentry_release(struct dentry *de)
 		struct autofs_sb_info *sbi = autofs4_sbi(de->d_sb);
 
 		if (sbi) {
-			spin_lock(&sbi->rehash_lock);
-			if (!list_empty(&inf->rehash))
-				list_del(&inf->rehash);
-			spin_unlock(&sbi->rehash_lock);
+			spin_lock(&sbi->lookup_lock);
+			if (!list_empty(&inf->expiring))
+				list_del(&inf->expiring);
+			spin_unlock(&sbi->lookup_lock);
 		}
 
 		inf->dentry = NULL;
@@ -518,7 +518,7 @@ static struct dentry_operations autofs4_dentry_operations = {
 	.d_release	= autofs4_dentry_release,
 };
 
-static struct dentry *autofs4_lookup_unhashed(struct autofs_sb_info *sbi, struct dentry *parent, struct qstr *name)
+static struct dentry *autofs4_lookup_expiring(struct autofs_sb_info *sbi, struct dentry *parent, struct qstr *name)
 {
 	unsigned int len = name->len;
 	unsigned int hash = name->hash;
@@ -526,14 +526,14 @@ static struct dentry *autofs4_lookup_unhashed(struct autofs_sb_info *sbi, struct
 	struct list_head *p, *head;
 
 	spin_lock(&dcache_lock);
-	spin_lock(&sbi->rehash_lock);
-	head = &sbi->rehash_list;
+	spin_lock(&sbi->lookup_lock);
+	head = &sbi->expiring_list;
 	list_for_each(p, head) {
 		struct autofs_info *ino;
 		struct dentry *dentry;
 		struct qstr *qstr;
 
-		ino = list_entry(p, struct autofs_info, rehash);
+		ino = list_entry(p, struct autofs_info, expiring);
 		dentry = ino->dentry;
 
 		spin_lock(&dentry->d_lock);
@@ -555,33 +555,17 @@ static struct dentry *autofs4_lookup_unhashed(struct autofs_sb_info *sbi, struct
 			goto next;
 
 		if (d_unhashed(dentry)) {
-			struct inode *inode = dentry->d_inode;
-
-			ino = autofs4_dentry_ino(dentry);
-			list_del_init(&ino->rehash);
+			list_del_init(&ino->expiring);
 			dget(dentry);
-			/*
-			 * Make the rehashed dentry negative so the VFS
-			 * behaves as it should.
-			 */
-			if (inode) {
-				dentry->d_inode = NULL;
-				list_del_init(&dentry->d_alias);
-				spin_unlock(&dentry->d_lock);
-				spin_unlock(&sbi->rehash_lock);
-				spin_unlock(&dcache_lock);
-				iput(inode);
-				return dentry;
-			}
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&sbi->rehash_lock);
+			spin_unlock(&sbi->lookup_lock);
 			spin_unlock(&dcache_lock);
 			return dentry;
 		}
 next:
 		spin_unlock(&dentry->d_lock);
 	}
-	spin_unlock(&sbi->rehash_lock);
+	spin_unlock(&sbi->lookup_lock);
 	spin_unlock(&dcache_lock);
 
 	return NULL;
@@ -591,7 +575,7 @@ next:
 static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 {
 	struct autofs_sb_info *sbi;
-	struct dentry *unhashed;
+	struct dentry *expiring;
 	int oz_mode;
 
 	DPRINTK("name = %.*s",
@@ -607,44 +591,40 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 	DPRINTK("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d",
 		 current->pid, task_pgrp_nr(current), sbi->catatonic, oz_mode);
 
-	unhashed = autofs4_lookup_unhashed(sbi, dentry->d_parent, &dentry->d_name);
-	if (!unhashed) {
-		/*
-		 * Mark the dentry incomplete but don't hash it. We do this
-		 * to serialize our inode creation operations (symlink and
-		 * mkdir) which prevents deadlock during the callback to
-		 * the daemon. Subsequent user space lookups for the same
-		 * dentry are placed on the wait queue while the daemon
-		 * itself is allowed passage unresticted so the create
-		 * operation itself can then hash the dentry. Finally,
-		 * we check for the hashed dentry and return the newly
-		 * hashed dentry.
-		 */
-		dentry->d_op = &autofs4_root_dentry_operations;
-
-		dentry->d_fsdata = NULL;
-		d_instantiate(dentry, NULL);
-	} else {
-		struct autofs_info *ino = autofs4_dentry_ino(unhashed);
-		DPRINTK("rehash %p with %p", dentry, unhashed);
+	expiring = autofs4_lookup_expiring(sbi, dentry->d_parent, &dentry->d_name);
+	if (expiring) {
+		struct autofs_info *ino = autofs4_dentry_ino(expiring);
 		/*
 		 * If we are racing with expire the request might not
 		 * be quite complete but the directory has been removed
 		 * so it must have been successful, so just wait for it.
-		 * We need to ensure the AUTOFS_INF_EXPIRING flag is clear
-		 * before continuing as revalidate may fail when calling
-		 * try_to_fill_dentry (returning EAGAIN) if we don't.
 		 */
 		while (ino && (ino->flags & AUTOFS_INF_EXPIRING)) {
 			DPRINTK("wait for incomplete expire %p name=%.*s",
-				unhashed, unhashed->d_name.len,
-				unhashed->d_name.name);
-			autofs4_wait(sbi, unhashed, NFY_NONE);
+				expiring, expiring->d_name.len,
+				expiring->d_name.name);
+			autofs4_wait(sbi, expiring, NFY_NONE);
 			DPRINTK("request completed");
 		}
-		dentry = unhashed;
+		dput(expiring);
 	}
 
+	/*
+	 * Mark the dentry incomplete but don't hash it. We do this
+	 * to serialize our inode creation operations (symlink and
+	 * mkdir) which prevents deadlock during the callback to
+	 * the daemon. Subsequent user space lookups for the same
+	 * dentry are placed on the wait queue while the daemon
+	 * itself is allowed passage unresticted so the create
+	 * operation itself can then hash the dentry. Finally,
+	 * we check for the hashed dentry and return the newly
+	 * hashed dentry.
+	 */
+	dentry->d_op = &autofs4_root_dentry_operations;
+
+	dentry->d_fsdata = NULL;
+	d_instantiate(dentry, NULL);
+
 	if (!oz_mode) {
 		spin_lock(&dentry->d_lock);
 		dentry->d_flags |= DCACHE_AUTOFS_PENDING;
@@ -668,8 +648,6 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 			if (sigismember (sigset, SIGKILL) ||
 			    sigismember (sigset, SIGQUIT) ||
 			    sigismember (sigset, SIGINT)) {
-			    if (unhashed)
-				dput(unhashed);
 			    return ERR_PTR(-ERESTARTNOINTR);
 			}
 		}
@@ -699,15 +677,9 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 		else
 			dentry = ERR_PTR(-ENOENT);
 
-		if (unhashed)
-			dput(unhashed);
-
 		return dentry;
 	}
 
-	if (unhashed)
-		return dentry;
-
 	return NULL;
 }
 
@@ -769,9 +741,8 @@ static int autofs4_dir_symlink(struct inode *dir,
  * that the file no longer exists. However, doing that means that the
  * VFS layer can turn the dentry into a negative dentry.  We don't want
  * this, because the unlink is probably the result of an expire.
- * We simply d_drop it and add it to a rehash candidates list in the
- * super block, which allows the dentry lookup to reuse it retaining
- * the flags, such as expire in progress, in case we're racing with expire.
+ * We simply d_drop it and add it to a expiring list in the super block,
+ * which allows the dentry lookup to check for an incomplete expire.
  *
  * If a process is blocked on the dentry waiting for the expire to finish,
  * it will invalidate the dentry and try to mount with a new one.
@@ -801,9 +772,9 @@ static int autofs4_dir_unlink(struct inode *dir, struct dentry *dentry)
 	dir->i_mtime = CURRENT_TIME;
 
 	spin_lock(&dcache_lock);
-	spin_lock(&sbi->rehash_lock);
-	list_add(&ino->rehash, &sbi->rehash_list);
-	spin_unlock(&sbi->rehash_lock);
+	spin_lock(&sbi->lookup_lock);
+	list_add(&ino->expiring, &sbi->expiring_list);
+	spin_unlock(&sbi->lookup_lock);
 	spin_lock(&dentry->d_lock);
 	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
@@ -829,9 +800,9 @@ static int autofs4_dir_rmdir(struct inode *dir, struct dentry *dentry)
 		spin_unlock(&dcache_lock);
 		return -ENOTEMPTY;
 	}
-	spin_lock(&sbi->rehash_lock);
-	list_add(&ino->rehash, &sbi->rehash_list);
-	spin_unlock(&sbi->rehash_lock);
+	spin_lock(&sbi->lookup_lock);
+	list_add(&ino->expiring, &sbi->expiring_list);
+	spin_unlock(&sbi->lookup_lock);
 	spin_lock(&dentry->d_lock);
 	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);


