Return-Path: <linux-kernel-owner+w=401wt.eu-S1760736AbXJLQRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760736AbXJLQRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932429AbXJLQHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:07:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759932AbXJLQHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:07:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 22/52] CRED: Pass credentials to nfs_setattr_update_inode()
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:07:11 +0100
Message-ID: <20071012160711.15119.29436.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials to nfs_setattr_update_inode().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/inode.c         |    6 +++---
 fs/nfs/nfs3proc.c      |    2 +-
 fs/nfs/nfs4proc.c      |    4 ++--
 fs/nfs/proc.c          |    2 +-
 include/linux/nfs_fs.h |    3 ++-
 5 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 8b21608..f76a93c 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -362,14 +362,14 @@ nfs_setattr(struct dentry *dentry, struct iattr *attr)
  * nfs_setattr_update_inode - Update inode metadata after a setattr call.
  * @inode: pointer to struct inode
  * @attr: pointer to struct iattr
+ * @acred: the credentials to use
  *
  * Note: we do this in the *proc.c in order to ensure that
  *       it works for things like exclusive creates too.
  */
-void nfs_setattr_update_inode(struct inode *inode, struct iattr *attr)
+void nfs_setattr_update_inode(struct inode *inode, struct iattr *attr,
+			      struct cred *acred)
 {
-	struct cred *acred = current->cred;
-
 	if ((attr->ia_valid & (ATTR_MODE|ATTR_UID|ATTR_GID)) != 0) {
 		if ((attr->ia_valid & ATTR_MODE) != 0) {
 			int mode = attr->ia_mode & S_IALLUGO;
diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index 4d66cfd..627188e 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -138,7 +138,7 @@ nfs3_proc_setattr(struct dentry *dentry, struct nfs_fattr *fattr,
 	nfs_fattr_init(fattr);
 	status = rpc_call_sync(NFS_CLIENT(inode), &msg, 0, acred);
 	if (status == 0)
-		nfs_setattr_update_inode(inode, sattr);
+		nfs_setattr_update_inode(inode, sattr, acred);
 	dprintk("NFS reply setattr: %d\n", status);
 	return status;
 }
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 83c9b66..c10f3de 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1725,7 +1725,7 @@ nfs4_proc_setattr(struct dentry *dentry, struct nfs_fattr *fattr,
 
 	status = nfs4_do_setattr(inode, fattr, sattr, state, acred);
 	if (status == 0)
-		nfs_setattr_update_inode(inode, sattr);
+		nfs_setattr_update_inode(inode, sattr, acred);
 	if (ctx != NULL)
 		put_nfs_open_context(ctx);
 	put_rpccred(cred);
@@ -1967,7 +1967,7 @@ nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 		status = nfs4_do_setattr(state->inode, &fattr, sattr, state,
 					 acred);
 		if (status == 0)
-			nfs_setattr_update_inode(state->inode, sattr);
+			nfs_setattr_update_inode(state->inode, sattr, acred);
 		nfs_post_op_update_inode(state->inode, &fattr);
 	}
 	if (status == 0 && (nd->flags & LOOKUP_OPEN) != 0)
diff --git a/fs/nfs/proc.c b/fs/nfs/proc.c
index aeb7e38..993d289 100644
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -134,7 +134,7 @@ nfs_proc_setattr(struct dentry *dentry, struct nfs_fattr *fattr,
 	nfs_fattr_init(fattr);
 	status = rpc_call_sync(NFS_CLIENT(inode), &msg, 0, acred);
 	if (status == 0)
-		nfs_setattr_update_inode(inode, sattr);
+		nfs_setattr_update_inode(inode, sattr, acred);
 	dprintk("NFS reply setattr: %d\n", status);
 	return status;
 }
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index f7ab86c..fe3136e 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -307,7 +307,8 @@ extern int nfs_revalidate_mapping_nolock(struct inode *inode,
 					 struct address_space *mapping,
 					 struct cred *acred);
 extern int nfs_setattr(struct dentry *, struct iattr *);
-extern void nfs_setattr_update_inode(struct inode *inode, struct iattr *attr);
+extern void nfs_setattr_update_inode(struct inode *inode, struct iattr *attr,
+				     struct cred *acred);
 extern void nfs_begin_attr_update(struct inode *);
 extern void nfs_end_attr_update(struct inode *);
 extern void nfs_begin_data_update(struct inode *);

