Return-Path: <linux-kernel-owner+w=401wt.eu-S936005AbYBVVwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936005AbYBVVwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933986AbYBVVoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:44:03 -0500
Received: from cantor.suse.de ([195.135.220.2]:46614 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764402AbYBVVn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:43:59 -0500
Date: Fri, 22 Feb 2008 13:40:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Neil Brown <neilb@suse.de>, Oliver Pinter <oliver.pntr@gmail.com>
Subject: [patch 18/23] NFS: Fix an Oops in encode_lookup()
Message-ID: <20080222214050.GS8686@suse.de>
References: <20080222213114.583282464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nfs-fix-an-oops-in-encode_lookup.patch"
In-Reply-To: <20080222213927.GA8686@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

mainline: 54af3bb543c071769141387a42deaaab5074da55

It doesn't look as if the NFS file name limit is being initialised correctly
in the struct nfs_server. Make sure that we limit whatever is being set in
nfs_probe_fsinfo() and nfs_init_server().

Also ensure that readdirplus and nfs4_path_walk respect our file name
limits.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Neil Brown <neilb@suse.de>
CC: Oliver Pinter <oliver.pntr@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/client.c  |   29 +++++++++++++++++++----------
 fs/nfs/dir.c     |    2 ++
 fs/nfs/getroot.c |    3 +++
 3 files changed, 24 insertions(+), 10 deletions(-)

--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -611,16 +611,6 @@ static int nfs_init_server(struct nfs_se
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
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1162,6 +1162,8 @@ static struct dentry *nfs_readdir_lookup
 	}
 	if (!desc->plus || !(entry->fattr->valid & NFS_ATTR_FATTR))
 		return NULL;
+	if (name.len > NFS_SERVER(dir)->namelen)
+		return NULL;
 	/* Note: caller is already holding the dir->i_mutex! */
 	dentry = d_alloc(parent, &name);
 	if (dentry == NULL)
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -175,6 +175,9 @@ next_component:
 		path++;
 	name.len = path - (const char *) name.name;
 
+	if (name.len > NFS4_MAXNAMLEN)
+		return -ENAMETOOLONG;
+
 eat_dot_dir:
 	while (*path == '/')
 		path++;

-- 
