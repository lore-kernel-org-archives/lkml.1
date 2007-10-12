Return-Path: <linux-kernel-owner+w=401wt.eu-S1761317AbXJLQOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761317AbXJLQOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760237AbXJLQGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:06:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760311AbXJLQGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:06:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 17/52] CRED: Make rpcauth_lookupcred() take a credentials
	pointer
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:06:46 +0100
Message-ID: <20071012160646.15119.47405.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make rpcauth_lookupcred() take a credentials pointer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/dir.c                |    3 ++-
 fs/nfs/inode.c              |    2 +-
 fs/nfs/nfs4proc.c           |   12 ++++++++----
 fs/nfs/unlink.c             |    3 ++-
 include/linux/sunrpc/auth.h |    3 ++-
 net/sunrpc/auth.c           |    4 ++--
 6 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index e4a04d1..53b9e24 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1959,6 +1959,7 @@ out:
 
 int nfs_permission(struct inode *inode, int mask, struct nameidata *nd)
 {
+	struct cred *acred = current->cred;
 	struct rpc_cred *cred;
 	int res = 0;
 
@@ -1995,7 +1996,7 @@ force_lookup:
 	if (!NFS_PROTO(inode)->access)
 		goto out_notsup;
 
-	cred = rpcauth_lookupcred(NFS_CLIENT(inode)->cl_auth, 0);
+	cred = rpcauth_lookupcred(NFS_CLIENT(inode)->cl_auth, 0, acred);
 	if (!IS_ERR(cred)) {
 		res = nfs_do_access(inode, cred, mask);
 		put_rpccred(cred);
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 71a49c3..0dd2ac3 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -555,7 +555,7 @@ int nfs_open(struct inode *inode, struct file *filp)
 	struct nfs_open_context *ctx;
 	struct rpc_cred *cred;
 
-	cred = rpcauth_lookupcred(NFS_CLIENT(inode)->cl_auth, 0);
+	cred = rpcauth_lookupcred(NFS_CLIENT(inode)->cl_auth, 0, filp->f_cred);
 	if (IS_ERR(cred))
 		return PTR_ERR(cred);
 	ctx = alloc_nfs_open_context(filp->f_path.mnt, filp->f_path.dentry, cred);
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 4b90e17..9a02b61 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1403,6 +1403,7 @@ out_close:
 struct dentry *
 nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 {
+	struct cred *acred = current->cred;
 	struct path path = {
 		.mnt = nd->mnt,
 		.dentry = dentry,
@@ -1422,7 +1423,7 @@ nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 		BUG_ON(nd->intent.open.flags & O_CREAT);
 	}
 
-	cred = rpcauth_lookupcred(NFS_CLIENT(dir)->cl_auth, 0);
+	cred = rpcauth_lookupcred(NFS_CLIENT(dir)->cl_auth, 0, acred);
 	if (IS_ERR(cred))
 		return (struct dentry *)cred;
 	state = nfs4_do_open(dir, &path, nd->intent.open.flags, &attr, cred);
@@ -1442,6 +1443,7 @@ nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 int
 nfs4_open_revalidate(struct inode *dir, struct dentry *dentry, int openflags, struct nameidata *nd)
 {
+	struct cred *acred = current->cred;
 	struct path path = {
 		.mnt = nd->mnt,
 		.dentry = dentry,
@@ -1449,7 +1451,7 @@ nfs4_open_revalidate(struct inode *dir, struct dentry *dentry, int openflags, st
 	struct rpc_cred *cred;
 	struct nfs4_state *state;
 
-	cred = rpcauth_lookupcred(NFS_CLIENT(dir)->cl_auth, 0);
+	cred = rpcauth_lookupcred(NFS_CLIENT(dir)->cl_auth, 0, acred);
 	if (IS_ERR(cred))
 		return PTR_ERR(cred);
 	state = nfs4_do_open(dir, &path, openflags, NULL, cred);
@@ -1657,6 +1659,7 @@ static int
 nfs4_proc_setattr(struct dentry *dentry, struct nfs_fattr *fattr,
 		  struct iattr *sattr)
 {
+	struct cred *acred = current->cred;
 	struct rpc_cred *cred;
 	struct inode *inode = dentry->d_inode;
 	struct nfs_open_context *ctx;
@@ -1665,7 +1668,7 @@ nfs4_proc_setattr(struct dentry *dentry, struct nfs_fattr *fattr,
 
 	nfs_fattr_init(fattr);
 	
-	cred = rpcauth_lookupcred(NFS_CLIENT(inode)->cl_auth, 0);
+	cred = rpcauth_lookupcred(NFS_CLIENT(inode)->cl_auth, 0, acred);
 	if (IS_ERR(cred))
 		return PTR_ERR(cred);
 
@@ -1885,6 +1888,7 @@ static int
 nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
                  int flags, struct nameidata *nd)
 {
+	struct cred *acred = current->cred;
 	struct path path = {
 		.mnt = nd->mnt,
 		.dentry = dentry,
@@ -1893,7 +1897,7 @@ nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 	struct rpc_cred *cred;
 	int status = 0;
 
-	cred = rpcauth_lookupcred(NFS_CLIENT(dir)->cl_auth, 0);
+	cred = rpcauth_lookupcred(NFS_CLIENT(dir)->cl_auth, 0, acred);
 	if (IS_ERR(cred)) {
 		status = PTR_ERR(cred);
 		goto out;
diff --git a/fs/nfs/unlink.c b/fs/nfs/unlink.c
index 045ab80..c6bcd5c 100644
--- a/fs/nfs/unlink.c
+++ b/fs/nfs/unlink.c
@@ -144,6 +144,7 @@ out_free:
 int
 nfs_async_unlink(struct inode *dir, struct dentry *dentry)
 {
+	struct cred *acred = current->cred;
 	struct nfs_unlinkdata *data;
 	int status = -ENOMEM;
 
@@ -151,7 +152,7 @@ nfs_async_unlink(struct inode *dir, struct dentry *dentry)
 	if (data == NULL)
 		goto out;
 
-	data->cred = rpcauth_lookupcred(NFS_CLIENT(dir)->cl_auth, 0);
+	data->cred = rpcauth_lookupcred(NFS_CLIENT(dir)->cl_auth, 0, acred);
 	if (IS_ERR(data->cred)) {
 		status = PTR_ERR(data->cred);
 		goto out_free;
diff --git a/include/linux/sunrpc/auth.h b/include/linux/sunrpc/auth.h
index 8f97f9a..63fe023 100644
--- a/include/linux/sunrpc/auth.h
+++ b/include/linux/sunrpc/auth.h
@@ -129,7 +129,8 @@ struct rpc_auth *	rpcauth_create(rpc_authflavor_t, struct rpc_clnt *);
 void			rpcauth_release(struct rpc_auth *);
 struct rpc_cred *	rpcauth_lookup_credcache(struct rpc_auth *, struct cred *, int);
 void			rpcauth_init_cred(struct rpc_cred *, const struct cred *, struct rpc_auth *, const struct rpc_credops *);
-struct rpc_cred *	rpcauth_lookupcred(struct rpc_auth *, int);
+struct rpc_cred *	rpcauth_lookupcred(struct rpc_auth *, int,
+					   struct cred *);
 struct rpc_cred *	rpcauth_bindcred(struct rpc_task *);
 void			rpcauth_holdcred(struct rpc_task *);
 void			put_rpccred(struct rpc_cred *);
diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 362a0de..d1cc555 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -334,11 +334,11 @@ out:
 }
 
 struct rpc_cred *
-rpcauth_lookupcred(struct rpc_auth *auth, int flags)
+rpcauth_lookupcred(struct rpc_auth *auth, int flags, struct cred *acred)
 {
 	dprintk("RPC:       looking up %s cred\n",
 		auth->au_ops->au_name);
-	return auth->au_ops->lookup_cred(auth, current->cred, flags);
+	return auth->au_ops->lookup_cred(auth, acred, flags);
 }
 
 void

