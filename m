Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbXEFAx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbXEFAx2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 20:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755474AbXEFAx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 20:53:28 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:58118 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbXEFAx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 20:53:27 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk, neilb@suse.de,
       mhalcrow@us.ibm.com, Trond.Myklebust@netapp.com,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 1/1] sunrpc: Use path_component_lookup
Date: Sat,  5 May 2007 20:52:46 -0400
Message-Id: <1178412766906-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.20.g86b9
In-Reply-To: <1178409144.6561.73.camel@heimdal.trondhjem.org>
References: <1178409144.6561.73.camel@heimdal.trondhjem.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

use path_component_lookup instead of open-coding the necessary
functionality.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 net/sunrpc/rpc_pipe.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 9b9ea50..c93a454 100644
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
+	if (path_component_lookup(mnt->mnt_root, mnt, path, LOOKUP_PARENT, nd)) {
 		printk(KERN_WARNING "%s: %s failed to find path %s\n",
 				__FILE__, __FUNCTION__, path);
 		rpc_put_mount();
-- 
1.5.2.rc1.20.g86b9

