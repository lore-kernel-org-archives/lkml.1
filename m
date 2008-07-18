Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbYGRCmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbYGRCmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 22:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760140AbYGRClQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 22:41:16 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:20807
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759996AbYGRClN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 22:41:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANeff0jLO9AP/2dsb2JhbACvdg
X-IronPort-AV: E=Sophos;i="4.31,207,1215360000"; 
   d="scan'208";a="343549556"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 4/7] autofs4 - fix indirect mount pending expire race
To: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 18 Jul 2008 10:37:18 +0800
Message-ID: <20080718023717.12802.80763.stgit@raven.themaw.net>
In-Reply-To: <20080718023651.12802.59107.stgit@raven.themaw.net>
References: <20080718023651.12802.59107.stgit@raven.themaw.net>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The selection of a dentry for expiration and the setting of the
AUTOFS_INF_EXPIRING flag isn't done atomically which can lead to
lookups walking into an expiring mount.

What happens is that an expire is initiated by the daemon and
a dentry is selected for expire but, since there is no lock
held between the selection and setting of the expiring flag,
a process may find the flag clear and continue walking into
the mount tree at the same time the daemon attempts the expire
it.

Signed-off-by: Ian Kent <raven@themaw.net>

---

 fs/autofs4/autofs_i.h |   10 +++-------
 fs/autofs4/expire.c   |   46 +++++++++++++++++++++++++++++++++++-----------
 fs/autofs4/root.c     |   32 +++++++++++++++++++++++++++-----
 3 files changed, 65 insertions(+), 23 deletions(-)


diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 058e180..5d90ed3 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -138,18 +138,14 @@ static inline int autofs4_oz_mode(struct autofs_sb_info *sbi) {
 static inline int autofs4_ispending(struct dentry *dentry)
 {
 	struct autofs_info *inf = autofs4_dentry_ino(dentry);
-	int pending = 0;
 
 	if (dentry->d_flags & DCACHE_AUTOFS_PENDING)
 		return 1;
 
-	if (inf) {
-		spin_lock(&inf->sbi->fs_lock);
-		pending = inf->flags & AUTOFS_INF_EXPIRING;
-		spin_unlock(&inf->sbi->fs_lock);
-	}
+	if (inf->flags & AUTOFS_INF_EXPIRING)
+		return 1;
 
-	return pending;
+	return 0;
 }
 
 static inline void autofs4_copy_atime(struct file *src, struct file *dst)
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 894fee5..19f5bea 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -292,6 +292,8 @@ static struct dentry *autofs4_expire_indirect(struct super_block *sb,
 	struct list_head *next;
 	int do_now = how & AUTOFS_EXP_IMMEDIATE;
 	int exp_leaves = how & AUTOFS_EXP_LEAVES;
+	struct autofs_info *ino;
+	unsigned int ino_count;
 
 	if (!root)
 		return NULL;
@@ -316,6 +318,9 @@ static struct dentry *autofs4_expire_indirect(struct super_block *sb,
 		dentry = dget(dentry);
 		spin_unlock(&dcache_lock);
 
+		spin_lock(&sbi->fs_lock);
+		ino = autofs4_dentry_ino(dentry);
+
 		/*
 		 * Case 1: (i) indirect mount or top level pseudo direct mount
 		 *	   (autofs-4.1).
@@ -326,6 +331,11 @@ static struct dentry *autofs4_expire_indirect(struct super_block *sb,
 			DPRINTK("checking mountpoint %p %.*s",
 				dentry, (int)dentry->d_name.len, dentry->d_name.name);
 
+			/* Path walk currently on this dentry? */
+			ino_count = atomic_read(&ino->count) + 2;
+			if (atomic_read(&dentry->d_count) > ino_count)
+				goto next;
+
 			/* Can we umount this guy */
 			if (autofs4_mount_busy(mnt, dentry))
 				goto next;
@@ -343,23 +353,25 @@ static struct dentry *autofs4_expire_indirect(struct super_block *sb,
 
 		/* Case 2: tree mount, expire iff entire tree is not busy */
 		if (!exp_leaves) {
-			/* Lock the tree as we must expire as a whole */
-			spin_lock(&sbi->fs_lock);
-			if (!autofs4_tree_busy(mnt, dentry, timeout, do_now)) {
-				struct autofs_info *inf = autofs4_dentry_ino(dentry);
+			/* Path walk currently on this dentry? */
+			ino_count = atomic_read(&ino->count) + 1;
+			if (atomic_read(&dentry->d_count) > ino_count)
+				goto next;
 
-				/* Set this flag early to catch sys_chdir and the like */
-				inf->flags |= AUTOFS_INF_EXPIRING;
-				spin_unlock(&sbi->fs_lock);
+			if (!autofs4_tree_busy(mnt, dentry, timeout, do_now)) {
 				expired = dentry;
 				goto found;
 			}
-			spin_unlock(&sbi->fs_lock);
 		/*
 		 * Case 3: pseudo direct mount, expire individual leaves
 		 *	   (autofs-4.1).
 		 */
 		} else {
+			/* Path walk currently on this dentry? */
+			ino_count = atomic_read(&ino->count) + 1;
+			if (atomic_read(&dentry->d_count) > ino_count)
+				goto next;
+
 			expired = autofs4_check_leaves(mnt, dentry, timeout, do_now);
 			if (expired) {
 				dput(dentry);
@@ -367,6 +379,7 @@ static struct dentry *autofs4_expire_indirect(struct super_block *sb,
 			}
 		}
 next:
+		spin_unlock(&sbi->fs_lock);
 		dput(dentry);
 		spin_lock(&dcache_lock);
 		next = next->next;
@@ -377,6 +390,9 @@ next:
 found:
 	DPRINTK("returning %p %.*s",
 		expired, (int)expired->d_name.len, expired->d_name.name);
+	ino = autofs4_dentry_ino(expired);
+	ino->flags |= AUTOFS_INF_EXPIRING;
+	spin_unlock(&sbi->fs_lock);
 	spin_lock(&dcache_lock);
 	list_move(&expired->d_parent->d_subdirs, &expired->d_u.d_child);
 	spin_unlock(&dcache_lock);
@@ -390,7 +406,9 @@ int autofs4_expire_run(struct super_block *sb,
 		      struct autofs_packet_expire __user *pkt_p)
 {
 	struct autofs_packet_expire pkt;
+	struct autofs_info *ino;
 	struct dentry *dentry;
+	int ret = 0;
 
 	memset(&pkt,0,sizeof pkt);
 
@@ -406,9 +424,14 @@ int autofs4_expire_run(struct super_block *sb,
 	dput(dentry);
 
 	if ( copy_to_user(pkt_p, &pkt, sizeof(struct autofs_packet_expire)) )
-		return -EFAULT;
+		ret = -EFAULT;
 
-	return 0;
+	spin_lock(&sbi->fs_lock);
+	ino = autofs4_dentry_ino(dentry);
+	ino->flags &= ~AUTOFS_INF_EXPIRING;
+	spin_unlock(&sbi->fs_lock);
+
+	return ret;
 }
 
 /* Call repeatedly until it returns -EAGAIN, meaning there's nothing
@@ -433,9 +456,10 @@ int autofs4_expire_multi(struct super_block *sb, struct vfsmount *mnt,
 
 		/* This is synchronous because it makes the daemon a
                    little easier */
-		ino->flags |= AUTOFS_INF_EXPIRING;
 		ret = autofs4_wait(sbi, dentry, NFY_EXPIRE);
+		spin_lock(&sbi->fs_lock);
 		ino->flags &= ~AUTOFS_INF_EXPIRING;
+		spin_unlock(&sbi->fs_lock);
 		dput(dentry);
 	}
 
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 2944b28..2ed2a51 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -133,7 +133,10 @@ static int try_to_fill_dentry(struct dentry *dentry, int flags)
 	/* Block on any pending expiry here; invalidate the dentry
            when expiration is done to trigger mount request with a new
            dentry */
-	if (ino && (ino->flags & AUTOFS_INF_EXPIRING)) {
+	spin_lock(&sbi->fs_lock);
+	if (ino->flags & AUTOFS_INF_EXPIRING) {
+		spin_unlock(&sbi->fs_lock);
+
 		DPRINTK("waiting for expire %p name=%.*s",
 			 dentry, dentry->d_name.len, dentry->d_name.name);
 
@@ -149,8 +152,11 @@ static int try_to_fill_dentry(struct dentry *dentry, int flags)
 		status = d_invalidate(dentry);
 		if (status != -EBUSY)
 			return -EAGAIN;
-	}
 
+		goto cont;
+	}
+	spin_unlock(&sbi->fs_lock);
+cont:
 	DPRINTK("dentry=%p %.*s ino=%p",
 		 dentry, dentry->d_name.len, dentry->d_name.name, dentry->d_inode);
 
@@ -229,15 +235,21 @@ static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
 		goto done;
 
 	/* If an expire request is pending wait for it. */
-	if (ino && (ino->flags & AUTOFS_INF_EXPIRING)) {
+	spin_lock(&sbi->fs_lock);
+	if (ino->flags & AUTOFS_INF_EXPIRING) {
+		spin_unlock(&sbi->fs_lock);
+
 		DPRINTK("waiting for active request %p name=%.*s",
 			dentry, dentry->d_name.len, dentry->d_name.name);
 
 		status = autofs4_wait(sbi, dentry, NFY_NONE);
 
 		DPRINTK("request done status=%d", status);
-	}
 
+		goto cont;
+	}
+	spin_unlock(&sbi->fs_lock);
+cont:
 	/*
 	 * If the dentry contains directories then it is an
 	 * autofs multi-mount with no root mount offset. So
@@ -292,8 +304,11 @@ static int autofs4_revalidate(struct dentry *dentry, struct nameidata *nd)
 	int status = 1;
 
 	/* Pending dentry */
+	spin_lock(&sbi->fs_lock);
 	if (autofs4_ispending(dentry)) {
 		/* The daemon never causes a mount to trigger */
+		spin_unlock(&sbi->fs_lock);
+
 		if (oz_mode)
 			return 1;
 
@@ -316,6 +331,7 @@ static int autofs4_revalidate(struct dentry *dentry, struct nameidata *nd)
 
 		return status;
 	}
+	spin_unlock(&sbi->fs_lock);
 
 	/* Negative dentry.. invalidate if "old" */
 	if (dentry->d_inode == NULL)
@@ -329,6 +345,7 @@ static int autofs4_revalidate(struct dentry *dentry, struct nameidata *nd)
 		DPRINTK("dentry=%p %.*s, emptydir",
 			 dentry, dentry->d_name.len, dentry->d_name.name);
 		spin_unlock(&dcache_lock);
+
 		/* The daemon never causes a mount to trigger */
 		if (oz_mode)
 			return 1;
@@ -521,13 +538,18 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 		 * so it must have been successful, so just wait for it.
 		 */
 		ino = autofs4_dentry_ino(expiring);
-		while (ino && (ino->flags & AUTOFS_INF_EXPIRING)) {
+		spin_lock(&sbi->fs_lock);
+		if (ino->flags & AUTOFS_INF_EXPIRING) {
+			spin_unlock(&sbi->fs_lock);
 			DPRINTK("wait for incomplete expire %p name=%.*s",
 				expiring, expiring->d_name.len,
 				expiring->d_name.name);
 			autofs4_wait(sbi, expiring, NFY_NONE);
 			DPRINTK("request completed");
+			goto cont;
 		}
+		spin_unlock(&sbi->fs_lock);
+cont:
 		spin_lock(&sbi->lookup_lock);
 		if (!list_empty(&ino->expiring))
 			list_del_init(&ino->expiring);
