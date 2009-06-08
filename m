Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbZFHTc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbZFHTc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbZFHTXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:55 -0400
Received: from thunk.org ([69.25.196.29]:39613 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbZFHTXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:24 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 23/49] vfs: Enable FS_IOC_FIEMAP and FIGETBSZ for all filetypes
Date: Mon,  8 Jun 2009 15:22:41 -0400
Message-Id: <1244488987-32564-24-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-23-git-send-email-tytso@mit.edu>
References: <1244488987-32564-1-git-send-email-tytso@mit.edu>
 <1244488987-32564-2-git-send-email-tytso@mit.edu>
 <1244488987-32564-3-git-send-email-tytso@mit.edu>
 <1244488987-32564-4-git-send-email-tytso@mit.edu>
 <1244488987-32564-5-git-send-email-tytso@mit.edu>
 <1244488987-32564-6-git-send-email-tytso@mit.edu>
 <1244488987-32564-7-git-send-email-tytso@mit.edu>
 <1244488987-32564-8-git-send-email-tytso@mit.edu>
 <1244488987-32564-9-git-send-email-tytso@mit.edu>
 <1244488987-32564-10-git-send-email-tytso@mit.edu>
 <1244488987-32564-11-git-send-email-tytso@mit.edu>
 <1244488987-32564-12-git-send-email-tytso@mit.edu>
 <1244488987-32564-13-git-send-email-tytso@mit.edu>
 <1244488987-32564-14-git-send-email-tytso@mit.edu>
 <1244488987-32564-15-git-send-email-tytso@mit.edu>
 <1244488987-32564-16-git-send-email-tytso@mit.edu>
 <1244488987-32564-17-git-send-email-tytso@mit.edu>
 <1244488987-32564-18-git-send-email-tytso@mit.edu>
 <1244488987-32564-19-git-send-email-tytso@mit.edu>
 <1244488987-32564-20-git-send-email-tytso@mit.edu>
 <1244488987-32564-21-git-send-email-tytso@mit.edu>
 <1244488987-32564-22-git-send-email-tytso@mit.edu>
 <1244488987-32564-23-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

The fiemap and get_blk_size ioctls should be enabled even for
directories.  So move it outisde file_ioctl.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ioctl.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 82d9c42..286f38d 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -414,10 +414,6 @@ static int file_ioctl(struct file *filp, unsigned int cmd,
 	switch (cmd) {
 	case FIBMAP:
 		return ioctl_fibmap(filp, p);
-	case FS_IOC_FIEMAP:
-		return ioctl_fiemap(filp, arg);
-	case FIGETBSZ:
-		return put_user(inode->i_sb->s_blocksize, p);
 	case FIONREAD:
 		return put_user(i_size_read(inode) - filp->f_pos, p);
 	}
@@ -557,6 +553,16 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		error = ioctl_fsthaw(filp);
 		break;
 
+	case FS_IOC_FIEMAP:
+		return ioctl_fiemap(filp, arg);
+
+	case FIGETBSZ:
+	{
+		struct inode *inode = filp->f_path.dentry->d_inode;
+		int __user *p = (int __user *)arg;
+		return put_user(inode->i_sb->s_blocksize, p);
+	}
+
 	default:
 		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
-- 
1.6.3.2.1.gb9f7d.dirty

