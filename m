Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbZIRScE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbZIRScE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 14:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757701AbZIRScC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 14:32:02 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48250 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984AbZIRScB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 14:32:01 -0400
Date: Fri, 18 Sep 2009 20:32:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl
Subject: Re: [PATCH] nfs: fix bdi_unregister() before sb kill
Message-ID: <20090918183203.GG23126@kernel.dk>
References: <20090917124233.GJ23126@kernel.dk> <20090917194027.GS23126@kernel.dk> <1253229410.2783.16.camel@heimdal.trondhjem.org> <20090918064006.GU23126@kernel.dk> <20090918150248.GB23126@kernel.dk> <1253290790.3183.14.camel@heimdal.trondhjem.org> <20090918173608.GD23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090918173608.GD23126@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18 2009, Jens Axboe wrote:
> On Fri, Sep 18 2009, Trond Myklebust wrote:
> > On Fri, 2009-09-18 at 17:02 +0200, Jens Axboe wrote:
> > > On Fri, Sep 18 2009, Jens Axboe wrote:
> > > > On Thu, Sep 17 2009, Trond Myklebust wrote:
> > > > > On Thu, 2009-09-17 at 21:40 +0200, Jens Axboe wrote:
> > > > > > On Thu, Sep 17 2009, Jens Axboe wrote:
> > > > > > > Hi,
> > > > > > > 
> > > > > > > This can cause a hang on NFS umount, since the bdi gets pruned before we
> > > > > > > flush any pending dirty IO. Peter, can you check whether it fixes your
> > > > > > > issue?
> > > > > > 
> > > > > > There's another problem with NFS && backing devices. NFS may call
> > > > > > bdi_destroy() on a bdi without ever called bdi_init(). This was always a
> > > > > > bad idea, now it's an issue.
> > > > > > 
> > > > > > So, Trond, can I safely add a server->flags private flag to indicate
> > > > > > that we have called bdi_init()? Then nfs_free_server() knows when to
> > > > > > call bdi_destroy(). Seems like the safest fix, since error handling is
> > > > > > currently 'just call nfs_free_server()'.
> > > > > 
> > > > > Urgh... Is there any reason why we can't just move the call to
> > > > > bdi_init() into nfs_bdi_register()? It seems bizarre to have to
> > > > > initialise the backing_dev_info twice like this...
> > > > 
> > > > No reason at all, I don't know why it was implemented that way
> > > > originally.
> > > > 
> > > > > If we do that, then we can just look at the BDI_registered state flag in
> > > > > order to figure out if we need to call bdi_unregister()
> > > > 
> > > > That's not exactly pretty either, diving into internal bdi details to
> > > > find out if we did an init/register of the device. BDI_registered is
> > > > just a debug flag, it may even go away again shortly.
> > > 
> > > Trond, we need to make some sort of decision on this very shortly. It
> > > definitely needs to be fixed for -rc1, it's causing NFS oopses. So lets
> > > make some sort of call on this and get it added, then you/we/I can
> > > always pretty it up later.
> > > 
> > 
> > OK... I think the solution is to move the call to bdi_init() into
> > nfs_bdi_register(), then move the calls to nfs_bdi_register() into
> > nfs_set_super() (with an appropriate call to bdi_destroy() if
> > set_anon_super() fails).
> > 
> > Then we can put bdi_destroy() in place of the call to bdi_unregister()
> > in nfs_kill_super().
> 
> Yeah, that sounds cleaner.
> 
> > I'm not going to attempt a patch, since I don't have a copy of your
> > current tree to base it on, but does the above make sense to you?
> 
> My current tree in the NFS area is just a one liner to move the
> bdi_destroy() in nfs_kill_super(). I'll try and cut a patch later
> tonight.

How does this look? It compiles, but I cannot test before sunday. It
would be great if you (or someone else) could :-). Peter, if you have
the time, it would be nice if you could check whether this one works for
you too.

diffstat is tasty, too:

 client.c |    4 ----
 super.c  |   53 ++++++++++++++++++++++++++---------------------------
 2 files changed, 26 insertions(+), 31 deletions(-)


diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index e350bd6..bb93060 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -933,10 +933,6 @@ static int nfs_probe_fsinfo(struct nfs_server *server, struct nfs_fh *mntfh, str
 		goto out_error;
 
 	nfs_server_set_fsinfo(server, &fsinfo);
-	error = bdi_init(&server->backing_dev_info);
-	if (error)
-		goto out_error;
-
 
 	/* Get some general file system info */
 	if (server->namelen == 0) {
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index f1cc058..712950d 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2008,17 +2008,41 @@ struct nfs_sb_mountdata {
 	int mntflags;
 };
 
+static int nfs_bdi_register(struct nfs_server *server)
+{
+	struct backing_dev_info *bdi = &server->backing_dev_info;
+	int err;
+
+	err = bdi_init(bdi);
+	if (!err) {
+		err = bdi_register_dev(bdi, server->s_dev);
+		if (!err)
+			return 0;
+	}
+
+	bdi_destroy(bdi);
+	return err;
+}
+
 static int nfs_set_super(struct super_block *s, void *data)
 {
 	struct nfs_sb_mountdata *sb_mntdata = data;
 	struct nfs_server *server = sb_mntdata->server;
 	int ret;
 
+	ret = nfs_bdi_register(server);
+	if (ret)
+		return ret;
+
 	s->s_flags = sb_mntdata->mntflags;
 	s->s_fs_info = server;
 	ret = set_anon_super(s, server);
-	if (ret == 0)
+	if (ret == 0) {
 		server->s_dev = s->s_dev;
+		return 0;
+	}
+
+	bdi_destroy(&server->backing_dev_info);
 	return ret;
 }
 
@@ -2075,11 +2099,6 @@ static int nfs_compare_super(struct super_block *sb, void *data)
 	return nfs_compare_mount_options(sb, server, mntflags);
 }
 
-static int nfs_bdi_register(struct nfs_server *server)
-{
-	return bdi_register_dev(&server->backing_dev_info, server->s_dev);
-}
-
 static int nfs_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *raw_data, struct vfsmount *mnt)
 {
@@ -2135,10 +2154,6 @@ static int nfs_get_sb(struct file_system_type *fs_type,
 	if (s->s_fs_info != server) {
 		nfs_free_server(server);
 		server = NULL;
-	} else {
-		error = nfs_bdi_register(server);
-		if (error)
-			goto error_splat_super;
 	}
 
 	if (!s->s_root) {
@@ -2191,7 +2206,7 @@ static void nfs_kill_super(struct super_block *s)
 	struct nfs_server *server = NFS_SB(s);
 
 	kill_anon_super(s);
-	bdi_unregister(&server->backing_dev_info);
+	bdi_destroy(&server->backing_dev_info);
 	nfs_fscache_release_super_cookie(s);
 	nfs_free_server(server);
 }
@@ -2236,10 +2251,6 @@ static int nfs_xdev_get_sb(struct file_system_type *fs_type, int flags,
 	if (s->s_fs_info != server) {
 		nfs_free_server(server);
 		server = NULL;
-	} else {
-		error = nfs_bdi_register(server);
-		if (error)
-			goto error_splat_super;
 	}
 
 	if (!s->s_root) {
@@ -2499,10 +2510,6 @@ static int nfs4_remote_get_sb(struct file_system_type *fs_type,
 	if (s->s_fs_info != server) {
 		nfs_free_server(server);
 		server = NULL;
-	} else {
-		error = nfs_bdi_register(server);
-		if (error)
-			goto error_splat_super;
 	}
 
 	if (!s->s_root) {
@@ -2732,10 +2739,6 @@ static int nfs4_xdev_get_sb(struct file_system_type *fs_type, int flags,
 	if (s->s_fs_info != server) {
 		nfs_free_server(server);
 		server = NULL;
-	} else {
-		error = nfs_bdi_register(server);
-		if (error)
-			goto error_splat_super;
 	}
 
 	if (!s->s_root) {
@@ -2813,10 +2816,6 @@ static int nfs4_remote_referral_get_sb(struct file_system_type *fs_type,
 	if (s->s_fs_info != server) {
 		nfs_free_server(server);
 		server = NULL;
-	} else {
-		error = nfs_bdi_register(server);
-		if (error)
-			goto error_splat_super;
 	}
 
 	if (!s->s_root) {

-- 
Jens Axboe

