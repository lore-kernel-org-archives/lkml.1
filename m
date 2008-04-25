Return-Path: <linux-kernel-owner+w=401wt.eu-S933198AbYDYWW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198AbYDYWW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 18:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932670AbYDYWUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 18:20:13 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40577 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764372AbYDYWUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 18:20:07 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 08/12] Unionfs: copyup only if file is being written to
Date: Fri, 25 Apr 2008 18:19:04 -0400
Message-Id: <12091619521881-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12091619483888-git-send-email-ezk@cs.sunysb.edu>
References: <12091619483888-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before, we used to copyup on an open(2) call which used flags implying
writing (O_RDWR, O_WRONLY, O_APPEND).  This meant that a file being opened
for writing, then immediately closed (without actually writing to the file),
will still have been copied up.  Now, we don't copyup such files in ->open,
but defer the copyup till later. [Bug #591].

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |    4 ++--
 fs/unionfs/file.c       |    1 +
 fs/unionfs/union.h      |    1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 83034c2..b7d3e38 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -635,7 +635,7 @@ int unionfs_file_release(struct inode *inode, struct file *file)
 	 * This is important for open-but-unlinked files, as well as mmap
 	 * support.
 	 */
-	err = unionfs_file_revalidate(file, true);
+	err = unionfs_file_revalidate(file, UNIONFS_F(file)->wrote_to_file);
 	if (unlikely(err))
 		goto out;
 	unionfs_check_file(file);
@@ -819,7 +819,7 @@ int unionfs_flush(struct file *file, fl_owner_t id)
 	unionfs_read_lock(dentry->d_sb, UNIONFS_SMUTEX_PARENT);
 	unionfs_lock_dentry(dentry, UNIONFS_DMUTEX_CHILD);
 
-	err = unionfs_file_revalidate(file, true);
+	err = unionfs_file_revalidate(file, UNIONFS_F(file)->wrote_to_file);
 	if (unlikely(err))
 		goto out;
 	unionfs_check_file(file);
diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
index f14b38b..09f594d 100644
--- a/fs/unionfs/file.c
+++ b/fs/unionfs/file.c
@@ -67,6 +67,7 @@ static ssize_t unionfs_write(struct file *file, const char __user *buf,
 					lower_file->f_path.dentry->d_inode);
 		fsstack_copy_attr_times(dentry->d_inode,
 					lower_file->f_path.dentry->d_inode);
+		UNIONFS_F(file)->wrote_to_file = true; /* for delayed copyup */
 		unionfs_check_file(file);
 	}
 
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 4ca4e76..ab877ee 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -91,6 +91,7 @@ struct unionfs_file_info {
 	struct file **lower_files;
 	int *saved_branch_ids; /* IDs of branches when file was opened */
 	struct vm_operations_struct *lower_vm_ops;
+	bool wrote_to_file;	/* for delayed copyup */
 };
 
 /* unionfs inode data in memory */
-- 
1.5.2.2

