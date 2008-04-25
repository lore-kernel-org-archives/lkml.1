Return-Path: <linux-kernel-owner+w=401wt.eu-S933225AbYDYWXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225AbYDYWXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 18:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933044AbYDYWUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 18:20:35 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40613 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932977AbYDYWUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 18:20:24 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 03/12] Unionfs: copy lower times in fsync/fasync only when needed
Date: Fri, 25 Apr 2008 18:18:59 -0400
Message-Id: <12091619501430-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12091619483888-git-send-email-ezk@cs.sunysb.edu>
References: <12091619483888-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/file.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
index 1fe4c30..f14b38b 100644
--- a/fs/unionfs/file.c
+++ b/fs/unionfs/file.c
@@ -196,13 +196,13 @@ int unionfs_fsync(struct file *file, struct dentry *dentry, int datasync)
 		err = lower_inode->i_fop->fsync(lower_file,
 						lower_dentry,
 						datasync);
+		if (!err && bindex == bstart)
+			fsstack_copy_attr_times(inode, lower_inode);
 		mutex_unlock(&lower_inode->i_mutex);
 		if (err)
 			goto out;
 	}
 
-	unionfs_copy_attr_times(inode);
-
 out:
 	if (!err)
 		unionfs_check_file(file);
@@ -244,13 +244,13 @@ int unionfs_fasync(int fd, struct file *file, int flag)
 		lower_file = unionfs_lower_file_idx(file, bindex);
 		mutex_lock(&lower_inode->i_mutex);
 		err = lower_inode->i_fop->fasync(fd, lower_file, flag);
+		if (!err && bindex == bstart)
+			fsstack_copy_attr_times(inode, lower_inode);
 		mutex_unlock(&lower_inode->i_mutex);
 		if (err)
 			goto out;
 	}
 
-	unionfs_copy_attr_times(inode);
-
 out:
 	if (!err)
 		unionfs_check_file(file);
-- 
1.5.2.2

