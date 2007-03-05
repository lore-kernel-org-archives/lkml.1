Return-Path: <linux-kernel-owner+w=401wt.eu-S1750989AbXCEB7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750989AbXCEB7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbXCEB6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:58:23 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38367 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbXCEBzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:55:16 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 10/13] fs/unionfs/: Fix copyup_deleted_file dentry leak
Date: Sun,  4 Mar 2007 20:55:00 -0500
Message-Id: <11730597053791-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.2.260.g2eb065
In-Reply-To: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
References: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 2664be9..aa7c75d 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -41,6 +41,15 @@ static int copyup_deleted_file(struct file *file, struct dentry *dentry,
 	sprintf(name, ".unionfs%*.*lx",
 			i_inosize, i_inosize, hidden_dentry->d_inode->i_ino);
 
+	/*
+	 * Loop, looking for an unused temp name to copyup to.
+	 *
+	 * It's somewhat silly that we look for a free temp tmp name in the
+	 * source branch (bstart) instead of the dest branch (bindex), where
+	 * the final name will be created.  We _will_ catch it if somehow
+	 * the name exists in the dest branch, but it'd be nice to catch it
+	 * sooner than later.
+	 */
 	tmp_dentry = NULL;
 	do {
 		char *suffix = name + nlen - countersize;
@@ -58,7 +67,9 @@ static int copyup_deleted_file(struct file *file, struct dentry *dentry,
 			err = PTR_ERR(tmp_dentry);
 			goto out;
 		}
+		/* don't dput here because of do-while condition eval order */
 	} while (tmp_dentry->d_inode != NULL);	/* need negative dentry */
+	dput(tmp_dentry);
 
 	err = copyup_named_file(dentry->d_parent->d_inode, file, name, bstart,
 				bindex, file->f_dentry->d_inode->i_size);
-- 
1.5.0.2.260.g2eb065

