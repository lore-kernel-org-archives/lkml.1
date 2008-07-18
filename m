Return-Path: <linux-kernel-owner+w=401wt.eu-S1761235AbYGRCmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761235AbYGRCmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 22:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758365AbYGRCln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 22:41:43 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:9387
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760729AbYGRClk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 22:41:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANeff0jLO9AP/2dsb2JhbACvdg
X-IronPort-AV: E=Sophos;i="4.31,207,1215360000"; 
   d="scan'208";a="291139803"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 6/7] autofs4 - reorganize expire pending wait function calls
To: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 18 Jul 2008 10:37:44 +0800
Message-ID: <20080718023737.12802.24898.stgit@raven.themaw.net>
In-Reply-To: <20080718023651.12802.59107.stgit@raven.themaw.net>
References: <20080718023651.12802.59107.stgit@raven.themaw.net>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch re-orgnirzes the checking for and waiting on
active expires and elininates redundant checks.

Signed-off-by: Ian Kent <raven@themaw.net>

---

 fs/autofs4/autofs_i.h |    1 +
 fs/autofs4/expire.c   |   29 +++++++++++++++++++
 fs/autofs4/root.c     |   75 +++++++------------------------------------------
 3 files changed, 40 insertions(+), 65 deletions(-)


diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 4b40cbc..69a2f5c 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -163,6 +163,7 @@ void autofs4_free_ino(struct autofs_info *);
 
 /* Expiration */
 int is_autofs4_dentry(struct dentry *);
+int autofs4_expire_wait(struct dentry *dentry);
 int autofs4_expire_run(struct super_block *, struct vfsmount *,
 			struct autofs_sb_info *,
 			struct autofs_packet_expire __user *);
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 705b9f0..cdabb79 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -402,6 +402,35 @@ found:
 	return expired;
 }
 
+int autofs4_expire_wait(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	int status;
+
+	/* Block on any pending expire */
+	spin_lock(&sbi->fs_lock);
+	if (ino->flags & AUTOFS_INF_EXPIRING) {
+		spin_unlock(&sbi->fs_lock);
+
+		DPRINTK("waiting for expire %p name=%.*s",
+			 dentry, dentry->d_name.len, dentry->d_name.name);
+
+		status = autofs4_wait(sbi, dentry, NFY_NONE);
+		wait_for_completion(&ino->expire_complete);
+
+		DPRINTK("expire done status=%d", status);
+
+		if (d_unhashed(dentry))
+			return -EAGAIN;
+
+		return status;
+	}
+	spin_unlock(&sbi->fs_lock);
+
+	return 0;
+}
+
 /* Perform an expiry operation */
 int autofs4_expire_run(struct super_block *sb,
 		      struct vfsmount *mnt,
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index bdf190b..9c39fa7 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -130,34 +130,6 @@ static int try_to_fill_dentry(struct dentry *dentry, int flags)
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	int status;
 
-	/* Block on any pending expiry here; invalidate the dentry
-           when expiration is done to trigger mount request with a new
-           dentry */
-	spin_lock(&sbi->fs_lock);
-	if (ino->flags & AUTOFS_INF_EXPIRING) {
-		spin_unlock(&sbi->fs_lock);
-
-		DPRINTK("waiting for expire %p name=%.*s",
-			 dentry, dentry->d_name.len, dentry->d_name.name);
-
-		status = autofs4_wait(sbi, dentry, NFY_NONE);
-		wait_for_completion(&ino->expire_complete);
-
-		DPRINTK("expire done status=%d", status);
-
-		/*
-		 * If the directory still exists the mount request must
-		 * continue otherwise it can't be followed at the right
-		 * time during the walk.
-		 */
-		status = d_invalidate(dentry);
-		if (status != -EBUSY)
-			return -EAGAIN;
-
-		goto cont;
-	}
-	spin_unlock(&sbi->fs_lock);
-cont:
 	DPRINTK("dentry=%p %.*s ino=%p",
 		 dentry, dentry->d_name.len, dentry->d_name.name, dentry->d_inode);
 
@@ -254,22 +226,8 @@ static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
 	}
 
 	/* If an expire request is pending everyone must wait. */
-	spin_lock(&sbi->fs_lock);
-	if (ino->flags & AUTOFS_INF_EXPIRING) {
-		spin_unlock(&sbi->fs_lock);
-
-		DPRINTK("waiting for active request %p name=%.*s",
-			dentry, dentry->d_name.len, dentry->d_name.name);
-
-		status = autofs4_wait(sbi, dentry, NFY_NONE);
-		wait_for_completion(&ino->expire_complete);
+	autofs4_expire_wait(dentry);
 
-		DPRINTK("request done status=%d", status);
-
-		goto cont;
-	}
-	spin_unlock(&sbi->fs_lock);
-cont:
 	/* We trigger a mount for almost all flags */
 	lookup_type = nd->flags & (TRIGGER_FLAGS | TRIGGER_INTENTS);
 	if (!(lookup_type || dentry->d_flags & DCACHE_AUTOFS_PENDING))
@@ -338,6 +296,14 @@ static int autofs4_revalidate(struct dentry *dentry, struct nameidata *nd)
 			return 1;
 
 		/*
+		 * If the directory has gone away due to an expire
+		 * we have been called as ->d_revalidate() and so
+		 * we need to return false and proceed to ->lookup().
+		 */
+		if (autofs4_expire_wait(dentry) == -EAGAIN)
+			return 0;
+
+		/*
 		 * A zero status is success otherwise we have a
 		 * negative error code.
 		 */
@@ -345,15 +311,6 @@ static int autofs4_revalidate(struct dentry *dentry, struct nameidata *nd)
 		if (status == 0)
 			return 1;
 
-		/*
-		 * A status of EAGAIN here means that the dentry has gone
-		 * away while waiting for an expire to complete. If we are
-		 * racing with expire lookup will wait for it so this must
-		 * be a revalidate and we need to send it to lookup.
-		 */
-		if (status == -EAGAIN)
-			return 0;
-
 		return status;
 	}
 	spin_unlock(&sbi->fs_lock);
@@ -563,19 +520,7 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 		 * so it must have been successful, so just wait for it.
 		 */
 		ino = autofs4_dentry_ino(expiring);
-		spin_lock(&sbi->fs_lock);
-		if (ino->flags & AUTOFS_INF_EXPIRING) {
-			spin_unlock(&sbi->fs_lock);
-			DPRINTK("wait for incomplete expire %p name=%.*s",
-				expiring, expiring->d_name.len,
-				expiring->d_name.name);
-			autofs4_wait(sbi, expiring, NFY_NONE);
-			wait_for_completion(&ino->expire_complete);
-			DPRINTK("request completed");
-			goto cont;
-		}
-		spin_unlock(&sbi->fs_lock);
-cont:
+		autofs4_expire_wait(expiring);
 		spin_lock(&sbi->lookup_lock);
 		if (!list_empty(&ino->expiring))
 			list_del_init(&ino->expiring);
