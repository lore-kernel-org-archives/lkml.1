Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbXISV1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbXISV1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755896AbXISVZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:25:19 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52808 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbXISVZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:25:03 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 6/6] Unionfs: cache coherency after lower objects are removed
Date: Wed, 19 Sep 2007 17:24:40 -0400
Message-Id: <11902370831020-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1190237080683-git-send-email-ezk@cs.sunysb.edu>
References: <1190237080683-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent an oops if a lower file is deleted and then it is stat'ed from the
upper layer.  Ensure that we return a negative dentry so the user will get
an ENOENT.  Properly dput/mntput so we don't leak references at the lower
file system.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Acked-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
---
 fs/unionfs/lookup.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 8eb9749..963d622 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -92,7 +92,7 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 	struct dentry *lower_dir_dentry = NULL;
 	struct dentry *parent_dentry = NULL;
 	struct dentry *d_interposed = NULL;
-	int bindex, bstart, bend, bopaque;
+	int bindex, bstart = -1, bend, bopaque;
 	int dentry_count = 0;	/* Number of positive dentries. */
 	int first_dentry_offset = -1; /* -1 is uninitialized */
 	struct dentry *first_dentry = NULL;
@@ -413,7 +413,14 @@ out:
 	if (!err && UNIONFS_D(dentry)) {
 		BUG_ON(dbend(dentry) > UNIONFS_D(dentry)->bcount);
 		BUG_ON(dbend(dentry) > sbmax(dentry->d_sb));
-		BUG_ON(dbstart(dentry) < 0);
+		if (dbstart(dentry) < 0 &&
+		    dentry->d_inode && bstart >= 0 &&
+		    (!UNIONFS_I(dentry->d_inode) ||
+		     !UNIONFS_I(dentry->d_inode)->lower_inodes)) {
+			unionfs_mntput(dentry->d_sb->s_root, bstart);
+			dput(first_lower_dentry);
+			UNIONFS_I(dentry->d_inode)->stale = 1;
+		}
 	}
 	kfree(whname);
 	if (locked_parent)
@@ -423,6 +430,9 @@ out:
 		unionfs_unlock_dentry(dentry);
 	if (!err && d_interposed)
 		return d_interposed;
+	if (dentry->d_inode && UNIONFS_I(dentry->d_inode)->stale &&
+	    first_dentry_offset >= 0)
+		unionfs_mntput(dentry->d_sb->s_root, first_dentry_offset);
 	return ERR_PTR(err);
 }
 
-- 
1.5.2.2

