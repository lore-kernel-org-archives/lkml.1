Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbXKZQqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbXKZQqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755915AbXKZQph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:45:37 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52781 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735AbXKZQp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:45:28 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 07/16] Unionfs: remove useless debugging messages
Date: Mon, 26 Nov 2007 11:44:04 -0500
Message-Id: <11960954562048-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
References: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These are considered normal behaviour, they don't really reveal any insight
to the person debugging the code, and they tend to clutter console messages.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |    5 -----
 fs/unionfs/dentry.c     |   15 +++------------
 2 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index b33917e..f714e2f 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -648,11 +648,6 @@ int unionfs_file_release(struct inode *inode, struct file *file)
 
 	if (fileinfo->rdstate) {
 		fileinfo->rdstate->access = jiffies;
-		pr_debug("unionfs: saving rdstate with cookie "
-			 "%u [%d.%lld]\n",
-			 fileinfo->rdstate->cookie,
-			 fileinfo->rdstate->bindex,
-			 (long long)fileinfo->rdstate->dirpos);
 		spin_lock(&inodeinfo->rdlock);
 		inodeinfo->rdcount++;
 		list_add_tail(&fileinfo->rdstate->cache,
diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index edea1a4..05d9914 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -45,12 +45,8 @@ static bool __unionfs_d_revalidate_one(struct dentry *dentry,
 	verify_locked(dentry);
 
 	/* if the dentry is unhashed, do NOT revalidate */
-	if (d_deleted(dentry)) {
-		pr_debug("unionfs: unhashed dentry being "
-			 "revalidated: %*s\n",
-			 dentry->d_name.len, dentry->d_name.name);
+	if (d_deleted(dentry))
 		goto out;
-	}
 
 	BUG_ON(dbstart(dentry) == -1);
 	if (dentry->d_inode)
@@ -460,13 +456,8 @@ static void unionfs_d_release(struct dentry *dentry)
 		printk(KERN_ERR "unionfs: dentry without private data: %.*s\n",
 		       dentry->d_name.len, dentry->d_name.name);
 		goto out;
-	} else if (dbstart(dentry) < 0) {
-		/* this is due to a failed lookup */
-		pr_debug("unionfs: dentry without lower "
-			 "dentries: %.*s\n",
-			 dentry->d_name.len, dentry->d_name.name);
-		goto out_free;
-	}
+	} else if (dbstart(dentry) < 0)
+		goto out_free;  /* due to a (normal) failed lookup */
 
 	/* Release all the lower dentries */
 	bstart = dbstart(dentry);
-- 
1.5.2.2

