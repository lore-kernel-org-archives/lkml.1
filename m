Return-Path: <linux-kernel-owner+w=401wt.eu-S1762854AbYBFXF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762854AbYBFXF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760206AbYBFXEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:04:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:17141 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763296AbYBFXEn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:04:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=v1ZOKjgL3kBxH5UEhmK3hF2cq3WK+ele8Ac7TqM2HBJTeec1iXj/fo3iavhERR64wQTU5GVzlb2Wiyg628LUGPmmt0ADluOGA+2h8zfOoVMYTaPdsjIGL/F8Ko2+dGZ4QSKPyNq0XxsCnzBtGUD6AbN0fHeISysF0qEawy4qPuI=
Message-ID: <6101e8c40802061504j23f6c9e3pe1a86b5627111789@mail.gmail.com>
Date: Thu, 7 Feb 2008 00:04:42 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: Re: [2.6.22.y] {14/17} - nfs-name-len-limit - series for stable kernel #2
In-Reply-To: <6101e8c40802011734u77e39a50q5913b2d79e55cec0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6101e8c40802011734u77e39a50q5913b2d79e55cec0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch-mainline: 2.6.23
References: 325913
GIT: 54af3bb543c071769141387a42deaaab5074da55 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Fri, 28 Sep 2007 12:27:41 -0400
Subject: [PATCH] NFS: Fix an Oops in encode_lookup()

It doesn't look as if the NFS file name limit is being initialised correctly
in the struct nfs_server. Make sure that we limit whatever is being set in
nfs_probe_fsinfo() and nfs_init_server().

Also ensure that readdirplus and nfs4_path_walk respect our file name
limits.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: NeilBrown <neilb@suse.de>

---
 fs/nfs/client.c  |   29 +++++++++++++++++++----------
 fs/nfs/dir.c     |    2 ++
 fs/nfs/getroot.c |    3 +++
 3 files changed, 24 insertions(+), 10 deletions(-)

--- linux-2.6.22-SL103_BRANCH.orig/fs/nfs/client.c
+++ linux-2.6.22-SL103_BRANCH/fs/nfs/client.c
@@ -614,16 +614,6 @@ static int nfs_init_server(struct nfs_se
 	server->namelen  = data->namlen;
 	/* Create a client RPC handle for the NFSv3 ACL management interface */
 	nfs_init_server_aclclient(server);
-	if (clp->cl_nfsversion == 3) {
-		if (server->namelen == 0 || server->namelen > NFS3_MAXNAMLEN)
-			server->namelen = NFS3_MAXNAMLEN;
-		if (!(data->flags & NFS_MOUNT_NORDIRPLUS))
-			server->caps |= NFS_CAP_READDIRPLUS;
-	} else {
-		if (server->namelen == 0 || server->namelen > NFS2_MAXNAMLEN)
-			server->namelen = NFS2_MAXNAMLEN;
-	}
-
 	dprintk("<-- nfs_init_server() = 0 [new %p]\n", clp);
 	return 0;

@@ -820,6 +810,16 @@ struct nfs_server *nfs_create_server(con
 	error = nfs_probe_fsinfo(server, mntfh, &fattr);
 	if (error < 0)
 		goto error;
+	if (server->nfs_client->rpc_ops->version == 3) {
+		if (server->namelen == 0 || server->namelen > NFS3_MAXNAMLEN)
+			server->namelen = NFS3_MAXNAMLEN;
+		if (!(data->flags & NFS_MOUNT_NORDIRPLUS))
+			server->caps |= NFS_CAP_READDIRPLUS;
+	} else {
+		if (server->namelen == 0 || server->namelen > NFS2_MAXNAMLEN)
+			server->namelen = NFS2_MAXNAMLEN;
+	}
+
 	if (!(fattr.valid & NFS_ATTR_FATTR)) {
 		error = server->nfs_client->rpc_ops->getattr(server, mntfh, &fattr);
 		if (error < 0) {
@@ -1010,6 +1010,9 @@ struct nfs_server *nfs4_create_server(co
 	if (error < 0)
 		goto error;

+	if (server->namelen == 0 || server->namelen > NFS4_MAXNAMLEN)
+		server->namelen = NFS4_MAXNAMLEN;
+
 	BUG_ON(!server->nfs_client);
 	BUG_ON(!server->nfs_client->rpc_ops);
 	BUG_ON(!server->nfs_client->rpc_ops->file_inode_ops);
@@ -1082,6 +1085,9 @@ struct nfs_server *nfs4_create_referral_
 	if (error < 0)
 		goto error;

+	if (server->namelen == 0 || server->namelen > NFS4_MAXNAMLEN)
+		server->namelen = NFS4_MAXNAMLEN;
+
 	dprintk("Referral FSID: %llx:%llx\n",
 		(unsigned long long) server->fsid.major,
 		(unsigned long long) server->fsid.minor);
@@ -1141,6 +1147,9 @@ struct nfs_server *nfs_clone_server(stru
 	if (error < 0)
 		goto out_free_server;

+	if (server->namelen == 0 || server->namelen > NFS4_MAXNAMLEN)
+		server->namelen = NFS4_MAXNAMLEN;
+
 	dprintk("Cloned FSID: %llx:%llx\n",
 		(unsigned long long) server->fsid.major,
 		(unsigned long long) server->fsid.minor);
--- linux-2.6.22-SL103_BRANCH.orig/fs/nfs/dir.c
+++ linux-2.6.22-SL103_BRANCH/fs/nfs/dir.c
@@ -1163,6 +1163,8 @@ static struct dentry *nfs_readdir_lookup
 	}
 	if (!desc->plus || !(entry->fattr->valid & NFS_ATTR_FATTR))
 		return NULL;
+	if (name.len > NFS_SERVER(dir)->namelen)
+		return NULL;
 	/* Note: caller is already holding the dir->i_mutex! */
 	dentry = d_alloc(parent, &name);
 	if (dentry == NULL)
--- linux-2.6.22-SL103_BRANCH.orig/fs/nfs/getroot.c
+++ linux-2.6.22-SL103_BRANCH/fs/nfs/getroot.c
@@ -175,6 +175,9 @@ next_component:
 		path++;
 	name.len = path - (const char *) name.name;

+	if (name.len > NFS4_MAXNAMLEN)
+		return -ENAMETOOLONG;
+
 eat_dot_dir:
 	while (*path == '/')
 		path++;


On 2/2/08, Oliver Pinter (Pintér Olivér) <oliver.pntr@gmail.com> wrote:
> mainline: 54af3bb543c071769141387a42deaaab5074da55
>
>
> --
> Thanks,
> Oliver
>


-- 
Thanks,
Oliver
