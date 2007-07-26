Return-Path: <linux-kernel-owner+w=401wt.eu-S1762908AbXGZQId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762908AbXGZQId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756071AbXGZQIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:08:23 -0400
Received: from pat.uio.no ([129.240.10.15]:58064 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756018AbXGZQIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:08:22 -0400
Subject: Re: [patch] nfs: fix locking in nfs/inode.c in
	nfs_free_open_context
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Krafft <krafft@de.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200707261713.07936.arnd@arndb.de>
References: <20070725170837.5fba5fd1@localhost>
	 <20070726144433.080126f7@localhost> <1185456203.6585.180.camel@localhost>
	 <200707261713.07936.arnd@arndb.de>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 12:08:17 -0400
Message-Id: <1185466097.6585.186.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.076)
X-UiO-Scanned: 31D5B2F3828F4CBF0E290F19A5E2E2590D703436
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 102 total 2979829 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-26 at 17:13 +0200, Arnd Bergmann wrote:
> Unfortunately, you didn't answer my question. The observed problem is
> that the final kref_put gets called at a time where there are still
> references to the context in nfsi->open_files, and other threads
> therefore do get at them.

Actually, I thought I did: I said we need to grab the lock atomically
with the last put. See below.

> The patch holds the i_lock around the kref_put to prevent others
> from searching the list. Ugly, I know, but it seems that's the
> price you pay for using a kref in such unconventional ways, i.e.
> not counting every reference.

Really ugly. Here's an alternative that is a lot more palatable.

Trond

---------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Thu, 26 Jul 2007 12:06:17 -0400
NFS: Fix put_nfs_open_context

We need to grab the inode->i_lock atomically with the last reference put in
order to remove the open context that is being freed from the
nfsi->open_files list.

Fix by converting the kref to a standard atomic counter and then using
atomic_dec_and_lock()...

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/inode.c         |   24 ++++++++----------------
 include/linux/nfs_fs.h |    2 +-
 2 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index bca6cdc..71a49c3 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -468,7 +468,7 @@ static struct nfs_open_context *alloc_nfs_open_context(struct vfsmount *mnt, str
 		ctx->lockowner = current->files;
 		ctx->error = 0;
 		ctx->dir_cookie = 0;
-		kref_init(&ctx->kref);
+		atomic_set(&ctx->count, 1);
 	}
 	return ctx;
 }
@@ -476,21 +476,18 @@ static struct nfs_open_context *alloc_nfs_open_context(struct vfsmount *mnt, str
 struct nfs_open_context *get_nfs_open_context(struct nfs_open_context *ctx)
 {
 	if (ctx != NULL)
-		kref_get(&ctx->kref);
+		atomic_inc(&ctx->count);
 	return ctx;
 }
 
-static void nfs_free_open_context(struct kref *kref)
+void put_nfs_open_context(struct nfs_open_context *ctx)
 {
-	struct nfs_open_context *ctx = container_of(kref,
-			struct nfs_open_context, kref);
+	struct inode *inode = ctx->path.dentry->d_inode;
 
-	if (!list_empty(&ctx->list)) {
-		struct inode *inode = ctx->path.dentry->d_inode;
-		spin_lock(&inode->i_lock);
-		list_del(&ctx->list);
-		spin_unlock(&inode->i_lock);
-	}
+	if (!atomic_dec_and_lock(&ctx->count, &inode->i_lock))
+		return;
+	list_del(&ctx->list);
+	spin_unlock(&inode->i_lock);
 	if (ctx->state != NULL)
 		nfs4_close_state(&ctx->path, ctx->state, ctx->mode);
 	if (ctx->cred != NULL)
@@ -500,11 +497,6 @@ static void nfs_free_open_context(struct kref *kref)
 	kfree(ctx);
 }
 
-void put_nfs_open_context(struct nfs_open_context *ctx)
-{
-	kref_put(&ctx->kref, nfs_free_open_context);
-}
-
 /*
  * Ensure that mmap has a recent RPC credential for use when writing out
  * shared pages
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 9ba4aec..157dcb0 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -71,7 +71,7 @@ struct nfs_access_entry {
 
 struct nfs4_state;
 struct nfs_open_context {
-	struct kref kref;
+	atomic_t count;
 	struct path path;
 	struct rpc_cred *cred;
 	struct nfs4_state *state;


