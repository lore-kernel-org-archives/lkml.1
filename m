Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbXLHUr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbXLHUr2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbXLHUql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:46:41 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34861 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbXLHUqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:46:39 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 2/2] Unionfs: reduce the amount of cache-coherency debugging messages
Date: Sat,  8 Dec 2007 15:46:05 -0500
Message-Id: <11971467681601-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1197146765464-git-send-email-ezk@cs.sunysb.edu>
References: <1197146765464-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/dentry.c |   38 +++++++++++++++++++++++---------------
 1 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index 05d9914..7d27987 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -195,9 +195,11 @@ out:
  * file system doesn't change its inode times quick enough, resulting in a
  * false positive indication (which is harmless, it just makes unionfs do
  * extra work in re-validating the objects).  To minimize the chances of
- * these situations, we delay the detection of changed times by
- * UNIONFS_MIN_CC_TIME (which defaults to 3 seconds, as with NFS's
- * acregmin).
+ * these situations, we still consider such small time changes valid, but we
+ * don't print debugging messages unless the time changes are greater than
+ * UNIONFS_MIN_CC_TIME (which defaults to 3 seconds, as with NFS's acregmin)
+ * because significant changes are more likely due to users manually
+ * touching lower files.
  */
 bool is_newer_lower(const struct dentry *dentry)
 {
@@ -219,20 +221,26 @@ bool is_newer_lower(const struct dentry *dentry)
 			continue;
 
 		/* check if mtime/ctime have changed */
-		if (unlikely((lower_inode->i_mtime.tv_sec -
-			      inode->i_mtime.tv_sec) > UNIONFS_MIN_CC_TIME)) {
-			pr_info("unionfs: new lower inode mtime "
-				"(bindex=%d, name=%s)\n", bindex,
-				dentry->d_name.name);
-			show_dinode_times(dentry);
+		if (unlikely(timespec_compare(&inode->i_mtime,
+					      &lower_inode->i_mtime) < 0)) {
+			if ((lower_inode->i_mtime.tv_sec -
+			     inode->i_mtime.tv_sec) > UNIONFS_MIN_CC_TIME) {
+				pr_info("unionfs: new lower inode mtime "
+					"(bindex=%d, name=%s)\n", bindex,
+					dentry->d_name.name);
+				show_dinode_times(dentry);
+			}
 			return true;
 		}
-		if (unlikely((lower_inode->i_ctime.tv_sec -
-			      inode->i_ctime.tv_sec) > UNIONFS_MIN_CC_TIME)) {
-			pr_info("unionfs: new lower inode ctime "
-				"(bindex=%d, name=%s)\n", bindex,
-				dentry->d_name.name);
-			show_dinode_times(dentry);
+		if (unlikely(timespec_compare(&inode->i_ctime,
+					      &lower_inode->i_ctime) < 0)) {
+			if ((lower_inode->i_ctime.tv_sec -
+			     inode->i_ctime.tv_sec) > UNIONFS_MIN_CC_TIME) {
+				pr_info("unionfs: new lower inode ctime "
+					"(bindex=%d, name=%s)\n", bindex,
+					dentry->d_name.name);
+				show_dinode_times(dentry);
+			}
 			return true;
 		}
 	}
-- 
1.5.2.2

