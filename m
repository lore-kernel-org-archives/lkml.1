Return-Path: <linux-kernel-owner+w=401wt.eu-S932484AbZLFIAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484AbZLFIAW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 03:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932298AbZLFIAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 03:00:18 -0500
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:35069 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbZLFH7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 02:59:37 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: stewb@linux-foundation.org, "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC 4/5] nfs, support pathconf(3) with _PC_LINK_MAX
Date: Sun,  6 Dec 2009 16:59:02 +0900
Message-Id: <1260086343-8406-5-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1260086343-8406-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1260086343-8406-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the value via struct statfs.f_spare[0], based upon PATHCONF
procedure. As namemax, it is set to a new member in struct nfs_server,
named linkmax.
Since NFSv2 (v4 too?) doesn't have PATHCONF procedure, it will be set to
LINK_MAX_DEFAULT which is a default value of GLibc implementation.

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/nfs/client.c           |   10 +++++++---
 fs/nfs/super.c            |    1 +
 include/linux/nfs_fs_sb.h |    1 +
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 99ea196..ed3fddd 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -851,6 +851,7 @@ static int nfs_init_server(struct nfs_server *server,
 	server->mountd_protocol = data->mount_server.protocol;
 
 	server->namelen  = data->namlen;
+	server->linkmax  = LINK_MAX_DEFAULT;
 	/* Create a client RPC handle for the NFSv3 ACL management interface */
 	nfs_init_server_aclclient(server);
 	dprintk("<-- nfs_init_server() = 0 [new %p]\n", clp);
@@ -941,14 +942,17 @@ static int nfs_probe_fsinfo(struct nfs_server *server, struct nfs_fh *mntfh, str
 	nfs_server_set_fsinfo(server, &fsinfo);
 
 	/* Get some general file system info */
-	if (server->namelen == 0) {
+	{
 		struct nfs_pathconf pathinfo;
 
 		pathinfo.fattr = fattr;
 		nfs_fattr_init(fattr);
 
-		if (clp->rpc_ops->pathconf(server, mntfh, &pathinfo) >= 0)
-			server->namelen = pathinfo.max_namelen;
+		if (clp->rpc_ops->pathconf(server, mntfh, &pathinfo) >= 0) {
+			if (server->namelen == 0)
+				server->namelen = pathinfo.max_namelen;
+			server->linkmax = pathinfo.max_link;
+		}
 	}
 
 	dprintk("<-- nfs_probe_fsinfo() = 0\n");
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 90be551..ae0599c 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -453,6 +453,7 @@ static int nfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_ffree = res.afiles;
 
 	buf->f_namelen = server->namelen;
+	buf->f_linkmax = server->linkmax;
 
 	return 0;
 
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index 320569e..d66ab43 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -123,6 +123,7 @@ struct nfs_server {
 	unsigned int		acdirmin;
 	unsigned int		acdirmax;
 	unsigned int		namelen;
+ 	unsigned int		linkmax;
 	unsigned int		options;	/* extra options enabled by mount */
 #define NFS_OPTION_FSCACHE	0x00000001	/* - local caching enabled */
 
-- 
1.6.1.284.g5dc13

