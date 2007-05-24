Return-Path: <linux-kernel-owner+w=401wt.eu-S1762969AbXEXCBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762969AbXEXCBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 22:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762331AbXEXB7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 21:59:42 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:42617 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762385AbXEXB7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 21:59:39 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       Trond.Myklebust@netapp.com, neilb@suse.de, mhalcrow@us.ibm.com,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 3/5] nfsctl: Use vfs_path_lookup
Date: Wed, 23 May 2007 21:54:36 -0400
Message-Id: <11799716783384-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11799716781687-git-send-email-jsipek@cs.sunysb.edu>
References: <11799716781687-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

use vfs_path_lookup instead of open-coding the necessary functionality.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Acked-by: NeilBrown <neilb@suse.de>
---
 fs/nfsctl.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/nfsctl.c b/fs/nfsctl.c
index c043136..51f1b31 100644
--- a/fs/nfsctl.c
+++ b/fs/nfsctl.c
@@ -23,19 +23,15 @@
 static struct file *do_open(char *name, int flags)
 {
 	struct nameidata nd;
+	struct vfsmount *mnt;
 	int error;
 
-	nd.mnt = do_kern_mount("nfsd", 0, "nfsd", NULL);
+	mnt = do_kern_mount("nfsd", 0, "nfsd", NULL);
+	if (IS_ERR(mnt))
+		return (struct file *)mnt;
 
-	if (IS_ERR(nd.mnt))
-		return (struct file *)nd.mnt;
-
-	nd.dentry = dget(nd.mnt->mnt_root);
-	nd.last_type = LAST_ROOT;
-	nd.flags = 0;
-	nd.depth = 0;
-
-	error = path_walk(name, &nd);
+	error = vfs_path_lookup(mnt->mnt_root, mnt, name, 0, &nd);
+	mntput(mnt);	/* drop do_kern_mount reference */
 	if (error)
 		return ERR_PTR(error);
 
-- 
1.5.2.rc1.165.gaf9b

