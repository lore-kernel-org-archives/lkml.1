Return-Path: <linux-kernel-owner+w=401wt.eu-S1762783AbXGSXXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762783AbXGSXXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 19:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbXGSXXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 19:23:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42237 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335AbXGSXXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 19:23:34 -0400
Date: Fri, 20 Jul 2007 00:23:31 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, jaharkes@cs.cmu.edu,
       linux-kernel@vger.kernel.org
Subject: [PATCH] coda breakage
Message-ID: <20070719232331.GY21668@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	a) switch by loff_t == __cmpdi2 use.  Replaced with a couple
of obvious ifs; update of ->f_pos in the first one makes sure that we
do the right thing in all cases.
	b) block_signals() and unblock_signals() are globals on UML.
Renamed coda ones; in principle UML probably ought to do rename as
well, but that's another story.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index 04a3dd8..8e61236 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -510,20 +510,20 @@ static int coda_venus_readdir(struct file *coda_file, void *buf,
 	vdir = kmalloc(sizeof(*vdir), GFP_KERNEL);
 	if (!vdir) return -ENOMEM;
 
-	switch (coda_file->f_pos) {
-	case 0:
+	if (coda_file->f_pos == 0) {
 		ret = filldir(buf, ".", 1, 0, de->d_inode->i_ino, DT_DIR);
-		if (ret < 0) break;
+		if (ret < 0)
+			goto out;
 		result++;
 		coda_file->f_pos++;
-		/* fallthrough */
-	case 1:
+	}
+	if (coda_file->f_pos == 1) {
 		ret = filldir(buf, "..", 2, 1, de->d_parent->d_inode->i_ino, DT_DIR);
-		if (ret < 0) break;
+		if (ret < 0)
+			goto out;
 		result++;
 		coda_file->f_pos++;
-		/* fallthrough */
-	default:
+	}
 	while (1) {
 		/* read entries from the directory file */
 		ret = kernel_read(host_file, coda_file->f_pos - 2, (char *)vdir,
@@ -578,7 +578,7 @@ static int coda_venus_readdir(struct file *coda_file, void *buf,
 		 * we've already established it is non-zero. */
 		coda_file->f_pos += vdir->d_reclen;
 	}
-	}
+out:
 	kfree(vdir);
 	return result ? result : ret;
 }
diff --git a/fs/coda/upcall.c b/fs/coda/upcall.c
index e4e766e..cd561d2 100644
--- a/fs/coda/upcall.c
+++ b/fs/coda/upcall.c
@@ -632,7 +632,7 @@ int venus_statfs(struct dentry *dentry, struct kstatfs *sfs)
 /*
  * coda_upcall and coda_downcall routines.
  */
-static void block_signals(sigset_t *old)
+static void coda_block_signals(sigset_t *old)
 {
 	spin_lock_irq(&current->sighand->siglock);
 	*old = current->blocked;
@@ -646,7 +646,7 @@ static void block_signals(sigset_t *old)
 	spin_unlock_irq(&current->sighand->siglock);
 }
 
-static void unblock_signals(sigset_t *old)
+static void coda_unblock_signals(sigset_t *old)
 {
 	spin_lock_irq(&current->sighand->siglock);
 	current->blocked = *old;
@@ -672,7 +672,7 @@ static inline void coda_waitfor_upcall(struct upc_req *req)
 	sigset_t old;
 	int blocked;
 
-	block_signals(&old);
+	coda_block_signals(&old);
 	blocked = 1;
 
 	add_wait_queue(&req->uc_sleep, &wait);
@@ -689,7 +689,7 @@ static inline void coda_waitfor_upcall(struct upc_req *req)
 		if (blocked && time_after(jiffies, timeout) &&
 		    CODA_INTERRUPTIBLE(req))
 		{
-			unblock_signals(&old);
+			coda_unblock_signals(&old);
 			blocked = 0;
 		}
 
@@ -704,7 +704,7 @@ static inline void coda_waitfor_upcall(struct upc_req *req)
 			schedule();
 	}
 	if (blocked)
-		unblock_signals(&old);
+		coda_unblock_signals(&old);
 
 	remove_wait_queue(&req->uc_sleep, &wait);
 	set_current_state(TASK_RUNNING);
