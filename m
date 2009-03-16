Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbZCPDSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbZCPDSY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 23:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZCPDSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 23:18:08 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:50123
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751901AbZCPDSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 23:18:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAAJivUl8qWbQ/2dsb2JhbADQQ4N/Bg
X-IronPort-AV: E=Sophos;i="4.38,370,1233500400"; 
   d="scan'208";a="402201647"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 1/2] autofs4 - fix lookup deadlock
To: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Mon, 16 Mar 2009 12:17:12 +0900
Message-ID: <20090316031712.26901.52109.stgit@zeus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A deadlock can occur when user space uses a signal (autofs version 4
uses SIGCHLD for this) to effect expire completion.

The order of events is:

Expire process completes, but before being able to send SIGCHLD to it's
parent ...

Another process walks onto a different mount point and drops the directory
inode semaphore prior to sending the request to the daemon as it must ...

A third process does an lstat on on the expired mount point causing it to
wait on expire completion (unfortunately) holding the directory semaphore.

The mount request then arrives at the daemon which does an lstat and,
deadlock.

For some time I was concerned about releasing the directory semaphore
around the expire wait in autofs4_lookup as well as for the mount call
back. I finally realized that the last round of changes in this function
made the expiring dentry and the lookup dentry separate and distinct so
the check and possible wait can be done anywhere prior to the mount call
back. This patch moves the check to just before the mount call back and
inside the directory inode mutex release.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/root.c |   41 +++++++++++++++++++++--------------------
 1 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 2a41c2a..e8c55d2 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -485,22 +485,6 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 	DPRINTK("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d",
 		 current->pid, task_pgrp_nr(current), sbi->catatonic, oz_mode);
 
-	expiring = autofs4_lookup_expiring(sbi, dentry->d_parent, &dentry->d_name);
-	if (expiring) {
-		/*
-		 * If we are racing with expire the request might not
-		 * be quite complete but the directory has been removed
-		 * so it must have been successful, so just wait for it.
-		 */
-		ino = autofs4_dentry_ino(expiring);
-		autofs4_expire_wait(expiring);
-		spin_lock(&sbi->lookup_lock);
-		if (!list_empty(&ino->expiring))
-			list_del_init(&ino->expiring);
-		spin_unlock(&sbi->lookup_lock);
-		dput(expiring);
-	}
-
 	unhashed = autofs4_lookup_active(sbi, dentry->d_parent, &dentry->d_name);
 	if (unhashed)
 		dentry = unhashed;
@@ -538,14 +522,31 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 	}
 
 	if (!oz_mode) {
+		mutex_unlock(&dir->i_mutex);
+		expiring = autofs4_lookup_expiring(sbi,
+						   dentry->d_parent,
+						   &dentry->d_name);
+		if (expiring) {
+			/*
+			 * If we are racing with expire the request might not
+			 * be quite complete but the directory has been removed
+			 * so it must have been successful, so just wait for it.
+			 */
+			ino = autofs4_dentry_ino(expiring);
+			autofs4_expire_wait(expiring);
+			spin_lock(&sbi->lookup_lock);
+			if (!list_empty(&ino->expiring))
+				list_del_init(&ino->expiring);
+			spin_unlock(&sbi->lookup_lock);
+			dput(expiring);
+		}
+
 		spin_lock(&dentry->d_lock);
 		dentry->d_flags |= DCACHE_AUTOFS_PENDING;
 		spin_unlock(&dentry->d_lock);
-		if (dentry->d_op && dentry->d_op->d_revalidate) {
-			mutex_unlock(&dir->i_mutex);
+		if (dentry->d_op && dentry->d_op->d_revalidate)
 			(dentry->d_op->d_revalidate)(dentry, nd);
-			mutex_lock(&dir->i_mutex);
-		}
+		mutex_lock(&dir->i_mutex);
 	}
 
 	/*

