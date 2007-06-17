Return-Path: <linux-kernel-owner+w=401wt.eu-S1761766AbXFQTNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761766AbXFQTNo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761256AbXFQTKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:10:16 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36890 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761127AbXFQTKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:10:12 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 03/16] Unionfs: Retry lookup for different silly-renamed files
Date: Sun, 17 Jun 2007 15:09:10 -0400
Message-Id: <11821073631675-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
References: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

When we have to copyup an open-but-unlinked file, we have to give it a
temporary name, similar to NFS's silly-renamed files.  So we generate
temporary file names until we find one that doesn't exist, and use it.  The
code had a bug where if the silly-renamed file name already existed, Unionfs
would oops upon copyup to that temp name.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 89a236b..28635d8 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -42,6 +42,7 @@ static int copyup_deleted_file(struct file *file, struct dentry *dentry,
 	sprintf(name, ".unionfs%*.*lx",
 		i_inosize, i_inosize, hidden_dentry->d_inode->i_ino);
 
+retry:
 	/*
 	 * Loop, looking for an unused temp name to copyup to.
 	 *
@@ -68,13 +69,14 @@ static int copyup_deleted_file(struct file *file, struct dentry *dentry,
 			err = PTR_ERR(tmp_dentry);
 			goto out;
 		}
-		/* don't dput here because of do-while condition eval order */
 	} while (tmp_dentry->d_inode != NULL);	/* need negative dentry */
 	dput(tmp_dentry);
 
 	err = copyup_named_file(dentry->d_parent->d_inode, file, name, bstart,
 				bindex, file->f_dentry->d_inode->i_size);
-	if (err)
+	if (err == -EEXIST)
+		goto retry;
+	else if (err)
 		goto out;
 
 	/* bring it to the same state as an unlinked file */
-- 
1.5.2.rc1.165.gaf9b

