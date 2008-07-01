Return-Path: <linux-kernel-owner+w=401wt.eu-S1759021AbYGAJ3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021AbYGAJ3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 05:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758595AbYGAJ3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 05:29:08 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:32551
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758439AbYGAJ3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 05:29:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADSWaUjLO9AP/2dsb2JhbACyBw
X-IronPort-AV: E=Sophos;i="4.27,730,1204470000"; 
   d="scan'208";a="284360239"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 3/5] autofs4 - fix waitq locking
To: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 01 Jul 2008 17:26:06 +0800
Message-ID: <20080701092605.12041.64298.stgit@raven.themaw.net>
In-Reply-To: <20080701092548.12041.69868.stgit@raven.themaw.net>
References: <20080701092548.12041.69868.stgit@raven.themaw.net>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The autofs4_catatonic_mode() function accesses the wait queue without
any locking but can be called at any time. This could lead to a
possible double free of the name field of the wait and a double fput
of the daemon communication pipe or an fput of a NULL file pointer.

Signed-off-by: Ian Kent <raven@themaw.net>

---

 fs/autofs4/inode.c |    4 ++--
 fs/autofs4/waitq.c |   23 ++++++++++++-----------
 2 files changed, 14 insertions(+), 13 deletions(-)


diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index e3e7099..7bb3e5b 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -163,8 +163,8 @@ void autofs4_kill_sb(struct super_block *sb)
 	if (!sbi)
 		goto out_kill_sb;
 
-	if (!sbi->catatonic)
-		autofs4_catatonic_mode(sbi); /* Free wait queues, close pipe */
+	/* Free wait queues, close pipe */
+	autofs4_catatonic_mode(sbi);
 
 	/* Clean up and release dangling references */
 	autofs4_force_release(sbi);
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index d291b07..f8dee31 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -28,6 +28,12 @@ void autofs4_catatonic_mode(struct autofs_sb_info *sbi)
 {
 	struct autofs_wait_queue *wq, *nwq;
 
+	mutex_lock(&sbi->wq_mutex);
+	if (sbi->catatonic) {
+		mutex_unlock(&sbi->wq_mutex);
+		return;
+	}
+
 	DPRINTK("entering catatonic mode");
 
 	sbi->catatonic = 1;
@@ -45,6 +51,8 @@ void autofs4_catatonic_mode(struct autofs_sb_info *sbi)
 	}
 	fput(sbi->pipe);	/* Close the pipe */
 	sbi->pipe = NULL;
+	sbi->pipefd = -1;
+	mutex_unlock(&sbi->wq_mutex);
 }
 
 static int autofs4_write(struct file *file, const void *addr, int bytes)
@@ -398,17 +406,10 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 			wq->name.name, notify);
 	}
 
-	/* wq->name is NULL if and only if the lock is already released */
-
-	if (sbi->catatonic) {
-		/* We might have slept, so check again for catatonic mode */
-		wq->status = -ENOENT;
-		if (wq->name.name) {
-			kfree(wq->name.name);
-			wq->name.name = NULL;
-		}
-	}
-
+	/*
+	 * wq->name.name is NULL iff the lock is already released
+	 * or the mount has been made catatonic.
+	 */
 	if (wq->name.name) {
 		/* Block all but "shutdown" signals while waiting */
 		sigset_t oldset;
