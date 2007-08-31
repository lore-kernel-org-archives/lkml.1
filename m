Return-Path: <linux-kernel-owner+w=401wt.eu-S933224AbXHaQVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224AbXHaQVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 12:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932808AbXHaQV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 12:21:26 -0400
Received: from pat.uio.no ([129.240.10.15]:49539 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932803AbXHaQVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 12:21:24 -0400
Subject: Re: recent nfs change causes autofs regression
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frank van Maarseveen <frankvm@frankvm.com>, Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
In-Reply-To: <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>
References: <000701c7eb49$cff701c0$6fe50540$@com>
	 <1188513433.6626.24.camel@heimdal.trondhjem.org>
	 <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>
Content-Type: multipart/mixed; boundary="=-jdoRLdAAt3pwuOl7DeGe"
Date: Fri, 31 Aug 2007 12:21:15 -0400
Message-Id: <1188577275.6649.133.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.072)
X-UiO-Scanned: 7818E01830D41C80EC922FB05FD66AFFFC9337DB
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 211 total 3592334 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jdoRLdAAt3pwuOl7DeGe
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2007-08-30 at 20:49 -0700, Linus Torvalds wrote:
> Please send in a fix. If the fix involves making "nosharecache" the 
> default, then that is better than making policy decisions like this in the 
> kernel. The kernel should do what the user asks and not put in unnecessary 
> roadblocks.

The best I can do given the constraints appears to be to have the kernel
first look for a superblock that matches both the fsid and the
user-specified mount options, and then spawn off a new superblock if
that search fails. The attached patch does just that.

Note that this is not the same as specifying nosharecache everywhere
since nosharecache will never attempt to match an existing superblock.

Finally, for the record: I still feel very uncomfortable about not being
able to report the state of the client setup back to the sysadmin.
AFAIK, the only way to do so is to stat the mountpoints, and compare the
device ids.

Trond


--=-jdoRLdAAt3pwuOl7DeGe
Content-Disposition: inline; filename=linux-2.6.23-009-nosharecache_is_default.dif
Content-Type: message/rfc822; name=linux-2.6.23-009-nosharecache_is_default.dif

From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Fri, 31 Aug 2007 10:45:17 -0400
NFS: Fix the mount regression
Subject: No Subject
Message-Id: <1188576086.6649.118.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/super.c |  110 +++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 64 insertions(+), 46 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index c28f30d..8ed5937 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1303,34 +1303,6 @@ static void nfs_clone_super(struct super_block *sb,
  	nfs_initialise_sb(sb);
 }
 
-static int nfs_set_super(struct super_block *s, void *_server)
-{
-	struct nfs_server *server = _server;
-	int ret;
-
-	s->s_fs_info = server;
-	ret = set_anon_super(s, server);
-	if (ret == 0)
-		server->s_dev = s->s_dev;
-	return ret;
-}
-
-static int nfs_compare_super(struct super_block *sb, void *data)
-{
-	struct nfs_server *server = data, *old = NFS_SB(sb);
-
-	if (memcmp(&old->nfs_client->cl_addr,
-				&server->nfs_client->cl_addr,
-				sizeof(old->nfs_client->cl_addr)) != 0)
-		return 0;
-	/* Note: NFS_MOUNT_UNSHARED == NFS4_MOUNT_UNSHARED */
-	if (old->flags & NFS_MOUNT_UNSHARED)
-		return 0;
-	if (memcmp(&old->fsid, &server->fsid, sizeof(old->fsid)) != 0)
-		return 0;
-	return 1;
-}
-
 #define NFS_MS_MASK (MS_RDONLY|MS_NOSUID|MS_NODEV|MS_NOEXEC|MS_SYNCHRONOUS)
 
 static int nfs_compare_mount_options(const struct super_block *s, const struct nfs_server *b, int flags)
@@ -1359,9 +1331,46 @@ static int nfs_compare_mount_options(const struct super_block *s, const struct n
 		goto Ebusy;
 	if (clnt_a->cl_auth->au_flavor != clnt_b->cl_auth->au_flavor)
 		goto Ebusy;
-	return 0;
+	return 1;
 Ebusy:
-	return -EBUSY;
+	return 0;
+}
+
+struct nfs_sb_mountdata {
+	struct nfs_server *server;
+	int mntflags;
+};
+
+static int nfs_set_super(struct super_block *s, void *data)
+{
+	struct nfs_sb_mountdata *sb_mntdata = data;
+	struct nfs_server *server = sb_mntdata->server;
+	int ret;
+
+	s->s_flags = sb_mntdata->mntflags;
+	s->s_fs_info = server;
+	ret = set_anon_super(s, server);
+	if (ret == 0)
+		server->s_dev = s->s_dev;
+	return ret;
+}
+
+static int nfs_compare_super(struct super_block *sb, void *data)
+{
+	struct nfs_sb_mountdata *sb_mntdata = data;
+	struct nfs_server *server = sb_mntdata->server, *old = NFS_SB(sb);
+	int mntflags = sb_mntdata->mntflags;
+
+	if (memcmp(&old->nfs_client->cl_addr,
+				&server->nfs_client->cl_addr,
+				sizeof(old->nfs_client->cl_addr)) != 0)
+		return 0;
+	/* Note: NFS_MOUNT_UNSHARED == NFS4_MOUNT_UNSHARED */
+	if (old->flags & NFS_MOUNT_UNSHARED)
+		return 0;
+	if (memcmp(&old->fsid, &server->fsid, sizeof(old->fsid)) != 0)
+		return 0;
+	return nfs_compare_mount_options(sb, server, mntflags);
 }
 
 static int nfs_get_sb(struct file_system_type *fs_type,
@@ -1373,6 +1382,9 @@ static int nfs_get_sb(struct file_system_type *fs_type,
 	struct nfs_mount_data *data = raw_data;
 	struct dentry *mntroot;
 	int (*compare_super)(struct super_block *, void *) = nfs_compare_super;
+	struct nfs_sb_mountdata sb_mntdata = {
+		.mntflags = flags,
+	};
 	int error;
 
 	/* Validate the mount data */
@@ -1386,28 +1398,25 @@ static int nfs_get_sb(struct file_system_type *fs_type,
 		error = PTR_ERR(server);
 		goto out;
 	}
+	sb_mntdata.server = server;
 
 	if (server->flags & NFS_MOUNT_UNSHARED)
 		compare_super = NULL;
 
 	/* Get a superblock - note that we may end up sharing one that already exists */
-	s = sget(fs_type, compare_super, nfs_set_super, server);
+	s = sget(fs_type, compare_super, nfs_set_super, &sb_mntdata);
 	if (IS_ERR(s)) {
 		error = PTR_ERR(s);
 		goto out_err_nosb;
 	}
 
 	if (s->s_fs_info != server) {
-		error = nfs_compare_mount_options(s, server, flags);
 		nfs_free_server(server);
 		server = NULL;
-		if (error < 0)
-			goto error_splat_super;
 	}
 
 	if (!s->s_root) {
 		/* initial superblock/root creation */
-		s->s_flags = flags;
 		nfs_fill_super(s, data);
 	}
 
@@ -1460,6 +1469,9 @@ static int nfs_xdev_get_sb(struct file_system_type *fs_type, int flags,
 	struct nfs_server *server;
 	struct dentry *mntroot;
 	int (*compare_super)(struct super_block *, void *) = nfs_compare_super;
+	struct nfs_sb_mountdata sb_mntdata = {
+		.mntflags = flags,
+	};
 	int error;
 
 	dprintk("--> nfs_xdev_get_sb()\n");
@@ -1470,28 +1482,25 @@ static int nfs_xdev_get_sb(struct file_system_type *fs_type, int flags,
 		error = PTR_ERR(server);
 		goto out_err_noserver;
 	}
+	sb_mntdata.server = server;
 
 	if (server->flags & NFS_MOUNT_UNSHARED)
 		compare_super = NULL;
 
 	/* Get a superblock - note that we may end up sharing one that already exists */
-	s = sget(&nfs_fs_type, compare_super, nfs_set_super, server);
+	s = sget(&nfs_fs_type, compare_super, nfs_set_super, &sb_mntdata);
 	if (IS_ERR(s)) {
 		error = PTR_ERR(s);
 		goto out_err_nosb;
 	}
 
 	if (s->s_fs_info != server) {
-		error = nfs_compare_mount_options(s, server, flags);
 		nfs_free_server(server);
 		server = NULL;
-		if (error < 0)
-			goto error_splat_super;
 	}
 
 	if (!s->s_root) {
 		/* initial superblock/root creation */
-		s->s_flags = flags;
 		nfs_clone_super(s, data->sb);
 	}
 
@@ -1729,6 +1738,9 @@ static int nfs4_get_sb(struct file_system_type *fs_type,
 	struct dentry *mntroot;
 	char *mntpath = NULL, *hostname = NULL, *ip_addr = NULL;
 	int (*compare_super)(struct super_block *, void *) = nfs_compare_super;
+	struct nfs_sb_mountdata sb_mntdata = {
+		.mntflags = flags,
+	};
 	int error;
 
 	/* Validate the mount data */
@@ -1744,12 +1756,13 @@ static int nfs4_get_sb(struct file_system_type *fs_type,
 		error = PTR_ERR(server);
 		goto out;
 	}
+	sb_mntdata.server = server;
 
 	if (server->flags & NFS4_MOUNT_UNSHARED)
 		compare_super = NULL;
 
 	/* Get a superblock - note that we may end up sharing one that already exists */
-	s = sget(fs_type, compare_super, nfs_set_super, server);
+	s = sget(fs_type, compare_super, nfs_set_super, &sb_mntdata);
 	if (IS_ERR(s)) {
 		error = PTR_ERR(s);
 		goto out_free;
@@ -1762,7 +1775,6 @@ static int nfs4_get_sb(struct file_system_type *fs_type,
 
 	if (!s->s_root) {
 		/* initial superblock/root creation */
-		s->s_flags = flags;
 		nfs4_fill_super(s);
 	}
 
@@ -1816,6 +1828,9 @@ static int nfs4_xdev_get_sb(struct file_system_type *fs_type, int flags,
 	struct nfs_server *server;
 	struct dentry *mntroot;
 	int (*compare_super)(struct super_block *, void *) = nfs_compare_super;
+	struct nfs_sb_mountdata sb_mntdata = {
+		.mntflags = flags,
+	};
 	int error;
 
 	dprintk("--> nfs4_xdev_get_sb()\n");
@@ -1826,12 +1841,13 @@ static int nfs4_xdev_get_sb(struct file_system_type *fs_type, int flags,
 		error = PTR_ERR(server);
 		goto out_err_noserver;
 	}
+	sb_mntdata.server = server;
 
 	if (server->flags & NFS4_MOUNT_UNSHARED)
 		compare_super = NULL;
 
 	/* Get a superblock - note that we may end up sharing one that already exists */
-	s = sget(&nfs_fs_type, compare_super, nfs_set_super, server);
+	s = sget(&nfs_fs_type, compare_super, nfs_set_super, &sb_mntdata);
 	if (IS_ERR(s)) {
 		error = PTR_ERR(s);
 		goto out_err_nosb;
@@ -1844,7 +1860,6 @@ static int nfs4_xdev_get_sb(struct file_system_type *fs_type, int flags,
 
 	if (!s->s_root) {
 		/* initial superblock/root creation */
-		s->s_flags = flags;
 		nfs4_clone_super(s, data->sb);
 	}
 
@@ -1887,6 +1902,9 @@ static int nfs4_referral_get_sb(struct file_system_type *fs_type, int flags,
 	struct dentry *mntroot;
 	struct nfs_fh mntfh;
 	int (*compare_super)(struct super_block *, void *) = nfs_compare_super;
+	struct nfs_sb_mountdata sb_mntdata = {
+		.mntflags = flags,
+	};
 	int error;
 
 	dprintk("--> nfs4_referral_get_sb()\n");
@@ -1897,12 +1915,13 @@ static int nfs4_referral_get_sb(struct file_system_type *fs_type, int flags,
 		error = PTR_ERR(server);
 		goto out_err_noserver;
 	}
+	sb_mntdata.server = server;
 
 	if (server->flags & NFS4_MOUNT_UNSHARED)
 		compare_super = NULL;
 
 	/* Get a superblock - note that we may end up sharing one that already exists */
-	s = sget(&nfs_fs_type, compare_super, nfs_set_super, server);
+	s = sget(&nfs_fs_type, compare_super, nfs_set_super, &sb_mntdata);
 	if (IS_ERR(s)) {
 		error = PTR_ERR(s);
 		goto out_err_nosb;
@@ -1915,7 +1934,6 @@ static int nfs4_referral_get_sb(struct file_system_type *fs_type, int flags,
 
 	if (!s->s_root) {
 		/* initial superblock/root creation */
-		s->s_flags = flags;
 		nfs4_fill_super(s);
 	}
 

--=-jdoRLdAAt3pwuOl7DeGe--

