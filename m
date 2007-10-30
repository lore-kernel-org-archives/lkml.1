Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbXJ3Tlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbXJ3Tlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbXJ3Tk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:40:59 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:45018 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbXJ3Tk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:40:57 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org,
       randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 4/4] Unionfs: use vfs_ioctl
Date: Tue, 30 Oct 2007 15:39:59 -0400
Message-Id: <11937732011790-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11937731993134-git-send-email-ezk@cs.sunysb.edu>
References: <11937731993134-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |   36 ++++++------------------------------
 1 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 7654bcb..c99b519 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -661,35 +661,6 @@ out:
 	return err;
 }
 
-/* pass the ioctl to the lower fs */
-static long do_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	struct file *lower_file;
-	int err;
-
-	lower_file = unionfs_lower_file(file);
-
-	err = security_file_ioctl(lower_file, cmd, arg);
-	if (err)
-		goto out;
-
-	err = -ENOTTY;
-	if (!lower_file || !lower_file->f_op)
-		goto out;
-	if (lower_file->f_op->unlocked_ioctl) {
-		err = lower_file->f_op->unlocked_ioctl(lower_file, cmd, arg);
-	} else if (lower_file->f_op->ioctl) {
-		lock_kernel();
-		err = lower_file->f_op->ioctl(
-			lower_file->f_path.dentry->d_inode,
-			lower_file, cmd, arg);
-		unlock_kernel();
-	}
-
-out:
-	return err;
-}
-
 /*
  * return to user-space the branch indices containing the file in question
  *
@@ -756,6 +727,7 @@ out:
 long unionfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long err;
+	struct file *lower_file;
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
 
@@ -779,7 +751,11 @@ long unionfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	default:
 		/* pass the ioctl down */
-		err = do_ioctl(file, cmd, arg);
+		lower_file = unionfs_lower_file(file);
+		if (lower_file)
+			err = vfs_ioctl(lower_file, cmd, arg);
+		else
+			err = -ENOTTY;
 		break;
 	}
 
-- 
1.5.2.2

