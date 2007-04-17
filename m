Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbXDQNSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbXDQNSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 09:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbXDQNSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 09:18:32 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:57166 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbXDQNSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 09:18:30 -0400
Date: Tue, 17 Apr 2007 18:55:32 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: [RFC][PATCH 15/15] Union-mount changes for NFS
Message-ID: <20070417132532.GP4001@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070417131459.GA4001@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417131459.GA4001@in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <j.blunck@tu-harburg.de>
Subject: Union-mount changes for NFS

Changes necessary to mount a NFS volume into a union.

Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 fs/nfs/dir.c    |   41 +++++++++++++++++++++++++++--------------
 fs/nfs/inode.c  |    4 ++--
 fs/nfs/unlink.c |    4 ++--
 3 files changed, 31 insertions(+), 18 deletions(-)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -409,7 +409,7 @@ int nfs_do_filldir(nfs_readdir_descripto
 
 		/* Get a dentry if we have one */
 		if (dentry != NULL)
-			dput(dentry);
+			__dput_single(dentry);
 		dentry = nfs_readdir_lookup(desc);
 
 		/* Use readdirplus info */
@@ -435,7 +435,7 @@ int nfs_do_filldir(nfs_readdir_descripto
 	}
 	dir_page_release(desc);
 	if (dentry != NULL)
-		dput(dentry);
+		__dput_single(dentry);
 	dfprintk(DIRCACHE, "NFS: nfs_do_filldir() filling ended @ cookie %Lu; returning = %d\n",
 			(unsigned long long)*desc->dir_cookie, res);
 	return res;
@@ -721,6 +721,16 @@ int nfs_neg_need_reval(struct inode *dir
 	return !nfs_check_verifier(dir, dentry);
 }
 
+static struct dentry * __dget_parent_single(struct dentry *dentry)
+{
+	struct dentry *ret;
+
+	spin_lock(&dentry->d_lock);
+	ret = __dget_single(dentry->d_parent);
+	spin_unlock(&dentry->d_lock);
+	return ret;
+}
+
 /*
  * This is called every time the dcache has a lookup hit,
  * and we should check whether we can really trust that
@@ -742,7 +752,7 @@ static int nfs_lookup_revalidate(struct 
 	struct nfs_fattr fattr;
 	unsigned long verifier;
 
-	parent = dget_parent(dentry);
+	parent = __dget_parent_single(dentry);
 	lock_kernel();
 	dir = parent->d_inode;
 	nfs_inc_stats(dir, NFSIOS_DENTRYREVALIDATE);
@@ -788,7 +798,7 @@ static int nfs_lookup_revalidate(struct 
 	nfs_refresh_verifier(dentry, verifier);
  out_valid:
 	unlock_kernel();
-	dput(parent);
+	__dput_single(parent);
 	dfprintk(LOOKUPCACHE, "NFS: %s(%s/%s) is valid\n",
 			__FUNCTION__, dentry->d_parent->d_name.name,
 			dentry->d_name.name);
@@ -807,7 +817,7 @@ out_zap_parent:
 	}
 	d_drop(dentry);
 	unlock_kernel();
-	dput(parent);
+	__dput_single(parent);
 	dfprintk(LOOKUPCACHE, "NFS: %s(%s/%s) is invalid\n",
 			__FUNCTION__, dentry->d_parent->d_name.name,
 			dentry->d_name.name);
@@ -1057,7 +1067,7 @@ static int nfs_open_revalidate(struct de
 	unsigned long verifier;
 	int openflags, ret = 0;
 
-	parent = dget_parent(dentry);
+	parent = __dget_parent_single(dentry);
 	dir = parent->d_inode;
 	if (!is_atomic_open(dir, nd))
 		goto no_open;
@@ -1088,18 +1098,21 @@ static int nfs_open_revalidate(struct de
 		nfs_refresh_verifier(dentry, verifier);
 	unlock_kernel();
 out:
-	dput(parent);
+	__dput_single(parent);
 	if (!ret)
 		d_drop(dentry);
 	return ret;
 no_open:
-	dput(parent);
+	__dput_single(parent);
 	if (inode != NULL && nfs_have_delegation(inode, FMODE_READ))
 		return 1;
 	return nfs_lookup_revalidate(dentry, nd);
 }
 #endif /* CONFIG_NFSV4 */
 
+/* For union mount we need this:
+ * - lookup the complete union if we found one
+ * - don't return lower layers dentries ... */
 static struct dentry *nfs_readdir_lookup(nfs_readdir_descriptor_t *desc)
 {
 	struct dentry *parent = desc->file->f_path.dentry;
@@ -1115,14 +1128,14 @@ static struct dentry *nfs_readdir_lookup
 	switch (name.len) {
 		case 2:
 			if (name.name[0] == '.' && name.name[1] == '.')
-				return dget_parent(parent);
+				return __dget_parent_single(parent);
 			break;
 		case 1:
 			if (name.name[0] == '.')
-				return dget(parent);
+				return __dget_single(parent);
 	}
 	name.hash = full_name_hash(name.name, name.len);
-	dentry = d_lookup(parent, &name);
+	dentry = d_lookup_single(parent, &name);
 	if (dentry != NULL) {
 		/* Is this a positive dentry that matches the readdir info? */
 		if (dentry->d_inode != NULL &&
@@ -1136,7 +1149,7 @@ static struct dentry *nfs_readdir_lookup
 		}
 		/* No, so d_drop to allow one to be created */
 		d_drop(dentry);
-		dput(dentry);
+		__dput_single(dentry);
 	}
 	if (!desc->plus || !(entry->fattr->valid & NFS_ATTR_FATTR))
 		return NULL;
@@ -1147,13 +1160,13 @@ static struct dentry *nfs_readdir_lookup
 	dentry->d_op = NFS_PROTO(dir)->dentry_ops;
 	inode = nfs_fhget(dentry->d_sb, entry->fh, entry->fattr);
 	if (IS_ERR(inode)) {
-		dput(dentry);
+		__dput_single(dentry);
 		return NULL;
 	}
 
 	alias = d_materialise_unique(dentry, inode);
 	if (alias != NULL) {
-		dput(dentry);
+		__dput_single(dentry);
 		if (IS_ERR(alias))
 			return NULL;
 		dentry = alias;
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -460,7 +460,7 @@ static struct nfs_open_context *alloc_nf
 	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
 	if (ctx != NULL) {
 		atomic_set(&ctx->count, 1);
-		ctx->dentry = dget(dentry);
+		ctx->dentry = __dget_single(dentry);
 		ctx->vfsmnt = mntget(mnt);
 		ctx->cred = get_rpccred(cred);
 		ctx->state = NULL;
@@ -491,7 +491,7 @@ void put_nfs_open_context(struct nfs_ope
 			nfs4_close_state(ctx->state, ctx->mode);
 		if (ctx->cred != NULL)
 			put_rpccred(ctx->cred);
-		dput(ctx->dentry);
+		__dput_single(ctx->dentry);
 		mntput(ctx->vfsmnt);
 		kfree(ctx);
 	}
--- a/fs/nfs/unlink.c
+++ b/fs/nfs/unlink.c
@@ -129,7 +129,7 @@ static void nfs_async_unlink_done(struct
 		return;
 	put_rpccred(data->cred);
 	data->cred = NULL;
-	dput(dir);
+	__dput_single(dir);
 }
 
 /**
@@ -172,7 +172,7 @@ nfs_async_unlink(struct dentry *dentry)
 		status = PTR_ERR(data->cred);
 		goto out_free;
 	}
-	data->dir = dget(dir);
+	data->dir = __dget_single(dir);
 	data->dentry = dentry;
 
 	data->next = nfs_deletes;
