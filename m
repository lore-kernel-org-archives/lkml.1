Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbZIXIW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbZIXIW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 04:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZIXIW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 04:22:26 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:36211
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752460AbZIXIWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 04:22:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAMvIukrLO0En/2dsb2JhbADWL4QbBYFYZQ
X-IronPort-AV: E=Sophos;i="4.44,444,1249228800"; 
   d="scan'208";a="505927163"
From: Ian Kent <raven@themaw.net>
Subject: [RFC PATCH 05/11] autofs4 - use autofs_info for pending flag
To: Sage Weil <sage@newdream.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Andreas Dilger <adilger@sun.com>, Yehuda Saheh <yehuda@newdream.net>,
       Jim Garlick <garlick@llnl.gov>
Date: Thu, 24 Sep 2009 16:21:52 +0800
Message-ID: <20090924082151.22151.4945.stgit@zeus.themaw.net>
In-Reply-To: <20090924082036.22151.85151.stgit@zeus.themaw.net>
References: <20090924082036.22151.85151.stgit@zeus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate the use of the d_lock spin lock by using the autofs super
block info spin lock. This reduces the number of spin locks we use
by one and makes the code for the following patch (to redirect
->d_revalidate() to ->lookup()) a little simpler.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/autofs_i.h |    3 ++-
 fs/autofs4/expire.c   |    2 +-
 fs/autofs4/root.c     |   58 +++++++++++++++++++++++++++----------------------
 3 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index fe9fc23..3d283ab 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -97,6 +97,7 @@ struct autofs_info {
 
 #define AUTOFS_INF_EXPIRING	(1<<0) /* dentry is in the process of expiring */
 #define AUTOFS_INF_MOUNTPOINT	(1<<1) /* mountpoint status for direct expire */
+#define AUTOFS_INF_PENDING	(1<<2) /* dentry pending mount */
 
 struct autofs_wait_queue {
 	wait_queue_head_t queue;
@@ -163,7 +164,7 @@ static inline int autofs4_ispending(struct dentry *dentry)
 {
 	struct autofs_info *inf = autofs4_dentry_ino(dentry);
 
-	if (dentry->d_flags & DCACHE_AUTOFS_PENDING)
+	if (inf->flags & AUTOFS_INF_PENDING)
 		return 1;
 
 	if (inf->flags & AUTOFS_INF_EXPIRING)
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 3da18d4..a796c94 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -27,7 +27,7 @@ static inline int autofs4_can_expire(struct dentry *dentry,
 		return 0;
 
 	/* No point expiring a pending mount */
-	if (dentry->d_flags & DCACHE_AUTOFS_PENDING)
+	if (ino->flags & AUTOFS_INF_PENDING)
 		return 0;
 
 	if (!do_now) {
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index f6e8ca9..305136b 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -166,32 +166,32 @@ static int try_to_fill_dentry(struct dentry *dentry, int flags)
 
 		/* Turn this into a real negative dentry? */
 		if (status == -ENOENT) {
-			spin_lock(&dentry->d_lock);
-			dentry->d_flags &= ~DCACHE_AUTOFS_PENDING;
-			spin_unlock(&dentry->d_lock);
+			spin_lock(&sbi->fs_lock);
+			ino->flags &= ~AUTOFS_INF_PENDING;
+			spin_unlock(&sbi->fs_lock);
 			return status;
 		} else if (status) {
 			/* Return a negative dentry, but leave it "pending" */
 			return status;
 		}
 	/* Trigger mount for path component or follow link */
-	} else if (dentry->d_flags & DCACHE_AUTOFS_PENDING ||
+	} else if (ino->flags & AUTOFS_INF_PENDING ||
 			autofs4_need_mount(flags) ||
 			current->link_count) {
 		DPRINTK("waiting for mount name=%.*s",
 			dentry->d_name.len, dentry->d_name.name);
 
-		spin_lock(&dentry->d_lock);
-		dentry->d_flags |= DCACHE_AUTOFS_PENDING;
-		spin_unlock(&dentry->d_lock);
+		spin_lock(&sbi->fs_lock);
+		ino->flags |= AUTOFS_INF_PENDING;
+		spin_unlock(&sbi->fs_lock);
 		status = autofs4_wait(sbi, dentry, NFY_MOUNT);
 
 		DPRINTK("mount done status=%d", status);
 
 		if (status) {
-			spin_lock(&dentry->d_lock);
-			dentry->d_flags &= ~DCACHE_AUTOFS_PENDING;
-			spin_unlock(&dentry->d_lock);
+			spin_lock(&sbi->fs_lock);
+			ino->flags &= ~AUTOFS_INF_PENDING;
+			spin_unlock(&sbi->fs_lock);
 			return status;
 		}
 	}
@@ -200,9 +200,9 @@ static int try_to_fill_dentry(struct dentry *dentry, int flags)
 	if (ino)
 		ino->last_used = jiffies;
 
-	spin_lock(&dentry->d_lock);
-	dentry->d_flags &= ~DCACHE_AUTOFS_PENDING;
-	spin_unlock(&dentry->d_lock);
+	spin_lock(&sbi->fs_lock);
+	ino->flags &= ~AUTOFS_INF_PENDING;
+	spin_unlock(&sbi->fs_lock);
 
 	return 0;
 }
@@ -243,18 +243,23 @@ static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
 
 	/* We trigger a mount for almost all flags */
 	lookup_type = autofs4_need_mount(nd->flags);
-	if (!(lookup_type || dentry->d_flags & DCACHE_AUTOFS_PENDING))
+	spin_lock(&sbi->fs_lock);
+	spin_lock(&dcache_lock);
+	if (!(lookup_type || ino->flags & AUTOFS_INF_PENDING)) {
+		spin_unlock(&dcache_lock);
+		spin_unlock(&sbi->fs_lock);
 		goto follow;
+	}
 
 	/*
 	 * If the dentry contains directories then it is an autofs
 	 * multi-mount with no root mount offset. So don't try to
 	 * mount it again.
 	 */
-	spin_lock(&dcache_lock);
-	if (dentry->d_flags & DCACHE_AUTOFS_PENDING ||
+	if (ino->flags & AUTOFS_INF_PENDING ||
 	    (!d_mountpoint(dentry) && __simple_empty(dentry))) {
 		spin_unlock(&dcache_lock);
+		spin_unlock(&sbi->fs_lock);
 
 		status = try_to_fill_dentry(dentry, 0);
 		if (status)
@@ -263,6 +268,7 @@ static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
 		goto follow;
 	}
 	spin_unlock(&dcache_lock);
+	spin_unlock(&sbi->fs_lock);
 follow:
 	/*
 	 * If there is no root mount it must be an autofs
@@ -525,9 +531,10 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 		 current->pid, task_pgrp_nr(current), sbi->catatonic, oz_mode);
 
 	unhashed = autofs4_lookup_active(sbi, dentry->d_parent, &dentry->d_name);
-	if (unhashed)
+	if (unhashed) {
 		dentry = unhashed;
-	else {
+		ino = autofs4_dentry_ino(dentry);
+	} else {
 		/*
 		 * Mark the dentry incomplete but don't hash it. We do this
 		 * to serialize our inode creation operations (symlink and
@@ -569,15 +576,14 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 			 * be quite complete but the directory has been removed
 			 * so it must have been successful, so just wait for it.
 			 */
-			ino = autofs4_dentry_ino(expiring);
 			autofs4_expire_wait(expiring);
 			autofs4_del_expiring(expiring);
 			dput(expiring);
 		}
 
-		spin_lock(&dentry->d_lock);
-		dentry->d_flags |= DCACHE_AUTOFS_PENDING;
-		spin_unlock(&dentry->d_lock);
+		spin_lock(&sbi->fs_lock);
+		ino->flags |= AUTOFS_INF_PENDING;
+		spin_unlock(&sbi->fs_lock);
 		if (dentry->d_op && dentry->d_op->d_revalidate)
 			(dentry->d_op->d_revalidate)(dentry, nd);
 		mutex_lock(&dir->i_mutex);
@@ -587,7 +593,7 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 	 * If we are still pending, check if we had to handle
 	 * a signal. If so we can force a restart..
 	 */
-	if (dentry->d_flags & DCACHE_AUTOFS_PENDING) {
+	if (ino->flags & AUTOFS_INF_PENDING) {
 		/* See if we were interrupted */
 		if (signal_pending(current)) {
 			sigset_t *sigset = &current->pending.signal;
@@ -600,9 +606,9 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 			}
 		}
 		if (!oz_mode) {
-			spin_lock(&dentry->d_lock);
-			dentry->d_flags &= ~DCACHE_AUTOFS_PENDING;
-			spin_unlock(&dentry->d_lock);
+			spin_lock(&sbi->fs_lock);
+			ino->flags &= ~AUTOFS_INF_PENDING;
+			spin_unlock(&sbi->fs_lock);
 		}
 	}
 

