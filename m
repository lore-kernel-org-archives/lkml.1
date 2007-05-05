Return-Path: <linux-kernel-owner+w=401wt.eu-S934285AbXEEXM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934285AbXEEXM6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 19:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbXEEXMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 19:12:48 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:55134 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbXEEXMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 19:12:31 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       Trond.Myklebust@netapp.com, neilb@suse.de, mhalcrow@us.ibm.com,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 3/4] nfsctl: Use path_component_lookup
Date: Sat,  5 May 2007 19:09:33 -0400
Message-Id: <11784065741216-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.1043.g4342
In-Reply-To: <11784065741163-git-send-email-jsipek@cs.sunysb.edu>
References: <11784065741163-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

use path_component_lookup instead of open-coding the necessary
functionality.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/nfsctl.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/nfsctl.c b/fs/nfsctl.c
index c043136..2035dc7 100644
--- a/fs/nfsctl.c
+++ b/fs/nfsctl.c
@@ -23,19 +23,14 @@
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
+	error = path_component_lookup(mnt->mnt_root, mnt, name, 0, &nd);
 	if (error)
 		return ERR_PTR(error);
 
-- 
1.5.0.3.1043.g4342

