Return-Path: <linux-kernel-owner+w=401wt.eu-S1752602AbXA2Uid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbXA2Uid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 15:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbXA2Uic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 15:38:32 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50403 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbXA2Uhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 15:37:55 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, akpm@osdl.org,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 4/4] fs/unionfs/: Don't duplicate the struct nameidata
Date: Mon, 29 Jan 2007 15:37:42 -0500
Message-Id: <11701030643398-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.rc1.g5355
In-Reply-To: <11701030631109-git-send-email-jsipek@cs.sunysb.edu>
References: <11701030631109-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The only fields that we have to watch out for are the dentry and vfsmount.
Additionally, this makes Unionfs gentler on the stack as nameidata is rather
large.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/inode.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 3b4a388..1b2e8a8 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -191,15 +191,25 @@ static struct dentry *unionfs_lookup(struct inode *parent,
 				     struct dentry *dentry,
 				     struct nameidata *nd)
 {
-	struct nameidata lowernd; /* TODO: be gentler to the stack */
+	struct path path_save;
+	struct dentry *ret;
 
-	if (nd)
-		memcpy(&lowernd, nd, sizeof(struct nameidata));
-	else
-		memset(&lowernd, 0, sizeof(struct nameidata));
+	/* save the dentry & vfsmnt from namei */
+	if (nd) {
+		path_save.dentry = nd->dentry;
+		path_save.mnt = nd->mnt;
+	}
 
 	/* The locking is done by unionfs_lookup_backend. */
-	return unionfs_lookup_backend(dentry, &lowernd, INTERPOSE_LOOKUP);
+	ret = unionfs_lookup_backend(dentry, nd, INTERPOSE_LOOKUP);
+
+	/* restore the dentry & vfsmnt in namei */
+	if (nd) {
+		nd->dentry = path_save.dentry;
+		nd->mnt = path_save.mnt;
+	}
+
+	return ret;
 }
 
 static int unionfs_link(struct dentry *old_dentry, struct inode *dir,
-- 
1.5.0.rc1.g5355

