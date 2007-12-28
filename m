Return-Path: <linux-kernel-owner+w=401wt.eu-S1756285AbXL1Usi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbXL1Usi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbXL1UoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:44:16 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37162 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbXL1Unx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:43:53 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 17/30] Unionfs: remove unnecessary locking in follow-link
Date: Fri, 28 Dec 2007 15:42:51 -0500
Message-Id: <1198874593425-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/inode.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 37258c8..7ec9c1b 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -851,7 +851,8 @@ out:
  * nor do we need to revalidate it either.  It is safe to not lock our
  * dentry here, nor revalidate it, because unionfs_follow_link does not do
  * anything (prior to calling ->readlink) which could become inconsistent
- * due to branch management.
+ * due to branch management.  We also don't need to lock our super because
+ * this function isn't affected by branch-management.
  */
 static void *unionfs_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
@@ -859,8 +860,6 @@ static void *unionfs_follow_link(struct dentry *dentry, struct nameidata *nd)
 	int len = PAGE_SIZE, err;
 	mm_segment_t old_fs;
 
-	unionfs_read_lock(dentry->d_sb);
-
 	/* This is freed by the put_link method assuming a successful call. */
 	buf = kmalloc(len, GFP_KERNEL);
 	if (unlikely(!buf)) {
@@ -885,7 +884,6 @@ static void *unionfs_follow_link(struct dentry *dentry, struct nameidata *nd)
 out:
 	unionfs_check_dentry(dentry);
 	unionfs_check_nd(nd);
-	unionfs_read_unlock(dentry->d_sb);
 	return ERR_PTR(err);
 }
 
-- 
1.5.2.2

