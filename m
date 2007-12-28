Return-Path: <linux-kernel-owner+w=401wt.eu-S1753013AbXL1UoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbXL1UoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbXL1Unf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:43:35 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37079 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbXL1Und (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:43:33 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 13/30] Unionfs: prevent deadlock in cache coherency
Date: Fri, 28 Dec 2007 15:42:47 -0500
Message-Id: <11988745912862-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't try to truncate_inode_pages in in purge_inode_data, because this could
lead to a deadlock between some of address_space ops and dentry
revalidation: the address space op is invoked with a lock on our own page,
and truncate_inode_pages will block on locked pages.  Instead, it should be
enough to be gentler and just invalidate_mapping_pages.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/dentry.c |   32 +++++++++++---------------------
 1 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index c7b6a7c..68c07ba 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -248,32 +248,22 @@ bool is_newer_lower(const struct dentry *dentry)
 }
 
 /*
- * Purge/remove/unmap all date pages of a unionfs inode.  This is called
- * when the lower inode has changed, and we have to force processes to get
- * the new data.
- *
- * XXX: Our implementation works in that as long as a user process will have
- * caused Unionfs to be called, directly or indirectly, even to just do
- * ->d_revalidate; then we will have purged the current Unionfs data and the
- * process will see the new data.  For example, a process that continually
- * re-reads the same file's data will see the NEW data as soon as the lower
- * file had changed, upon the next read(2) syscall (even if the file is
- * still open!)  However, this doesn't work when the process re-reads the
- * open file's data via mmap(2) (unless the user unmaps/closes the file and
- * remaps/reopens it).  Once we respond to ->readpage(s), then the kernel
- * maps the page into the process's address space and there doesn't appear
- * to be a way to force the kernel to invalidate those pages/mappings, and
- * force the process to re-issue ->readpage.  If there's a way to invalidate
- * active mappings and force a ->readpage, let us know please
- * (invalidate_inode_pages2 doesn't do the trick).
+ * Purge and invalidate as many data pages of a unionfs inode.  This is
+ * called when the lower inode has changed, and we want to force processes
+ * to re-get the new data.
  */
 static inline void purge_inode_data(struct inode *inode)
 {
 	/* remove all non-private mappings */
 	unmap_mapping_range(inode->i_mapping, 0, 0, 0);
-
-	if (inode->i_data.nrpages)
-		truncate_inode_pages(&inode->i_data, 0);
+	/* invalidate as many pages as possible */
+	invalidate_mapping_pages(inode->i_mapping, 0, -1);
+	/*
+	 * Don't try to truncate_inode_pages here, because this could lead
+	 * to a deadlock between some of address_space ops and dentry
+	 * revalidation: the address space op is invoked with a lock on our
+	 * own page, and truncate_inode_pages will block on locked pages.
+	 */
 }
 
 void purge_sb_data(struct super_block *sb)
-- 
1.5.2.2

