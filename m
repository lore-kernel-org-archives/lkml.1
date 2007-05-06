Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbXEFRmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbXEFRmk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 13:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbXEFRmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 13:42:24 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:60173 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720AbXEFRmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 13:42:10 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       Trond.Myklebust@netapp.com, neilb@suse.de, mhalcrow@us.ibm.com,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 2/5] sunrpc: Use vfs_path_lookup
Date: Sun,  6 May 2007 13:41:26 -0400
Message-Id: <1178473289960-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.20.g86b9
In-Reply-To: <1178473289617-git-send-email-jsipek@cs.sunysb.edu>
References: <1178473289617-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

use vfs_path_lookup instead of open-coding the necessary functionality.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 net/sunrpc/rpc_pipe.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 9b9ea50..2170329 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -451,21 +451,19 @@ void rpc_put_mount(void)
 static int
 rpc_lookup_parent(char *path, struct nameidata *nd)
 {
+	struct vfsmount *mnt;
+
 	if (path[0] == '\0')
 		return -ENOENT;
-	nd->mnt = rpc_get_mount();
-	if (IS_ERR(nd->mnt)) {
+
+	mnt = rpc_get_mount();
+	if (IS_ERR(mnt)) {
 		printk(KERN_WARNING "%s: %s failed to mount "
 			       "pseudofilesystem \n", __FILE__, __FUNCTION__);
-		return PTR_ERR(nd->mnt);
+		return PTR_ERR(mnt);
 	}
-	mntget(nd->mnt);
-	nd->dentry = dget(rpc_mount->mnt_root);
-	nd->last_type = LAST_ROOT;
-	nd->flags = LOOKUP_PARENT;
-	nd->depth = 0;
 
-	if (path_walk(path, nd)) {
+	if (vfs_path_lookup(mnt->mnt_root, mnt, path, LOOKUP_PARENT, nd)) {
 		printk(KERN_WARNING "%s: %s failed to find path %s\n",
 				__FILE__, __FUNCTION__, path);
 		rpc_put_mount();
-- 
1.5.2.rc1.20.g86b9

