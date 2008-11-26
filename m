Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbYLAQnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbYLAQnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 11:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbYLAQkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 11:40:21 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:34870 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbYLAQjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 11:39:54 -0500
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org, "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
Subject: [PATCH 14/14] NFSD: Server implementation of MAC Labeling
Date: Wed, 26 Nov 2008 16:03:14 -0500
Message-Id: <1227733394-1114-15-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the ability to encode and decode file labels on the server for
the purpose of sending them to the client and also to process label change
requests from the client.

Signed-off-by: Matthew N. Dodd <Matthew.Dodd@sparta.com>
Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 fs/nfsd/export.c          |    3 +
 fs/nfsd/nfs4proc.c        |   35 ++++++++++++++-
 fs/nfsd/nfs4xdr.c         |  106 ++++++++++++++++++++++++++++++++++++++++++---
 fs/nfsd/vfs.c             |   28 ++++++++++++
 include/linux/nfsd/nfsd.h |    2 +
 5 files changed, 166 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index 5839b22..2630759 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -1428,6 +1428,9 @@ static struct flags {
 	{ NFSEXP_ALLSQUASH, {"all_squash", ""}},
 	{ NFSEXP_ASYNC, {"async", "sync"}},
 	{ NFSEXP_GATHERED_WRITES, {"wdelay", "no_wdelay"}},
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+	{ NFSEXP_SECURITY_LABEL, {"security_label", ""}},
+#endif
 	{ NFSEXP_NOHIDE, {"nohide", ""}},
 	{ NFSEXP_CROSSMOUNT, {"crossmnt", ""}},
 	{ NFSEXP_NOSUBTREECHECK, {"no_subtree_check", ""}},
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 669461e..5b910cf 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -49,6 +49,10 @@
 #include <linux/nfs4_acl.h>
 #include <linux/sunrpc/gss_api.h>
 
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+#include <linux/security.h>
+#endif
+
 #define NFSDDBG_FACILITY		NFSDDBG_PROC
 
 static inline void
@@ -103,6 +107,18 @@ do_open_lookup(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nfsd4_o
 					(u32 *)open->op_verf.data,
 					&open->op_truncate, &created);
 
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+		if (!status && open->op_label != NULL) {
+			struct inode *inode = resfh.fh_dentry->d_inode;
+
+			mutex_lock(&inode->i_mutex);
+			/* Is it appropriate to just kick back an error? */
+			status = security_inode_setsecctx(resfh.fh_dentry,
+				open->op_label->label, open->op_label->len);
+			mutex_unlock(&inode->i_mutex);
+		}
+#endif
+
 		/* If we ever decide to use different attrs to store the
 		 * verifier in nfsd_create_v3, then we'll need to change this
 		 */
@@ -432,6 +448,18 @@ nfsd4_create(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		status = nfserr_badtype;
 	}
 
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+	if (!status && create->cr_label != NULL) {
+		struct inode *inode = resfh.fh_dentry->d_inode;
+
+		mutex_lock(&inode->i_mutex);
+		/* Is it appropriate to just kick back an error? */
+		status = security_inode_setsecctx(resfh.fh_dentry,
+				create->cr_label->label, create->cr_label->len);
+		mutex_unlock(&inode->i_mutex);
+	}
+#endif
+
 	if (!status) {
 		fh_unlock(&cstate->current_fh);
 		set_change_info(&create->cr_cinfo, &cstate->current_fh);
@@ -670,6 +698,11 @@ nfsd4_setattr(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 					    setattr->sa_acl);
 	if (status)
 		goto out;
+	if (setattr->sa_label != NULL)
+		status = nfsd4_set_nfs4_label(rqstp, &cstate->current_fh,
+					    setattr->sa_label);
+	if (status)
+		goto out;
 	status = nfsd_setattr(rqstp, &cstate->current_fh, &setattr->sa_iattr,
 				0, (time_t)0);
 out:
@@ -964,7 +997,7 @@ out:
 	return status;
 }
 
-static struct nfsd4_operation nfsd4_ops[OP_RELEASE_LOCKOWNER+1] = {
+static struct nfsd4_operation nfsd4_ops[LAST_NFS4_OP+1] = {
 	[OP_ACCESS] = {
 		.op_func = (nfsd4op_func)nfsd4_access,
 		.op_name = "OP_ACCESS",
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index afcdf4b..69af020 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -59,6 +59,10 @@
 #include <linux/sunrpc/gss_api.h>
 #include <linux/sunrpc/svcauth_gss.h>
 
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+#include <linux/security.h>
+#endif
+
 #define NFSDDBG_FACILITY		NFSDDBG_XDR
 
 /*
@@ -249,7 +253,7 @@ nfsd4_decode_bitmap(struct nfsd4_compoundargs *argp, u32 *bmval)
 
 static __be32
 nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval, struct iattr *iattr,
-    struct nfs4_acl **acl)
+    struct nfs4_acl **acl, struct nfs4_label **label)
 {
 	int expected_len, len = 0;
 	u32 dummy32;
@@ -402,6 +406,39 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval, struct iattr *ia
 			goto xdr_error;
 		}
 	}
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+	if (bmval[1] & FATTR4_WORD1_SECURITY_LABEL) {
+		READ_BUF(4);
+		len += 4;
+		READ32(dummy32);
+		READ_BUF(dummy32);
+		len += (XDR_QUADLEN(dummy32) << 2);
+		READMEM(buf, dummy32);
+
+		if (dummy32 > NFS4_MAXLABELLEN)
+			return nfserr_resource;
+
+		*label = kzalloc(sizeof(struct nfs4_label), GFP_KERNEL);
+		if (*label == NULL) {
+			host_err = -ENOMEM;
+			goto out_nfserr;
+		}
+
+		(*label)->label = kmalloc(dummy32 + 1, GFP_KERNEL);
+		if ((*label)->label == NULL) {
+			host_err = -ENOMEM;
+			kfree(*label);
+			goto out_nfserr;
+		}
+
+		(*label)->len = dummy32;
+		memcpy((*label)->label, buf, dummy32);
+		((char *)(*label)->label)[dummy32] = '\0';
+
+		defer_free(argp, kfree, (*label)->label);
+		defer_free(argp, kfree, *label);
+	}
+#endif
 	if (len != expected_len)
 		goto xdr_error;
 
@@ -495,7 +532,7 @@ nfsd4_decode_create(struct nfsd4_compoundargs *argp, struct nfsd4_create *create
 	if ((status = check_filename(create->cr_name, create->cr_namelen, nfserr_inval)))
 		return status;
 
-	if ((status = nfsd4_decode_fattr(argp, create->cr_bmval, &create->cr_iattr, &create->cr_acl)))
+	if ((status = nfsd4_decode_fattr(argp, create->cr_bmval, &create->cr_iattr, &create->cr_acl, &create->cr_label)))
 		goto out;
 
 	DECODE_TAIL;
@@ -654,7 +691,7 @@ nfsd4_decode_open(struct nfsd4_compoundargs *argp, struct nfsd4_open *open)
 		switch (open->op_createmode) {
 		case NFS4_CREATE_UNCHECKED:
 		case NFS4_CREATE_GUARDED:
-			if ((status = nfsd4_decode_fattr(argp, open->op_bmval, &open->op_iattr, &open->op_acl)))
+			if ((status = nfsd4_decode_fattr(argp, open->op_bmval, &open->op_iattr, &open->op_acl, &open->op_label)))
 				goto out;
 			break;
 		case NFS4_CREATE_EXCLUSIVE:
@@ -853,8 +890,8 @@ nfsd4_decode_setattr(struct nfsd4_compoundargs *argp, struct nfsd4_setattr *seta
 	status = nfsd4_decode_stateid(argp, &setattr->sa_stateid);
 	if (status)
 		return status;
-	return nfsd4_decode_fattr(argp, setattr->sa_bmval,
-				  &setattr->sa_iattr, &setattr->sa_acl);
+	return nfsd4_decode_fattr(argp, setattr->sa_bmval, &setattr->sa_iattr,
+					 &setattr->sa_acl, &setattr->sa_label);
 }
 
 static __be32
@@ -917,7 +954,7 @@ nfsd4_decode_verify(struct nfsd4_compoundargs *argp, struct nfsd4_verify *verify
 	 * nfsd4_proc_verify; however we still decode here just to return
 	 * correct error in case of bad xdr. */
 #if 0
-	status = nfsd4_decode_fattr(ve_bmval, &ve_iattr, &ve_acl);
+	status = nfsd4_decode_fattr(ve_bmval, &ve_iattr, &ve_acl, &ve_label);
 	if (status == nfserr_inval) {
 		status = nfserrno(status);
 		goto out;
@@ -1380,6 +1417,34 @@ nfsd4_encode_aclname(struct svc_rqst *rqstp, int whotype, uid_t id, int group,
 	return nfsd4_encode_name(rqstp, whotype, id, group, p, buflen);
 }
 
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+static inline __be32
+nfsd4_encode_security_label(struct svc_rqst *rqstp, struct dentry *dentry, __be32 **p, int *buflen)
+{
+	void *context;
+	int err;
+	int len;
+
+	err = 0;
+	(void)security_inode_getsecctx(dentry->d_inode, &context, &len);
+	if (len < 0)
+		return nfserrno(len);
+
+	if (*buflen < ((XDR_QUADLEN(len) << 2) + 4)) {
+		err = nfserr_resource;
+		goto out;
+	}
+
+	*p = xdr_encode_opaque(*p, context, len);
+	*buflen -= (XDR_QUADLEN(len) << 2) + 4;
+	BUG_ON(*buflen < 0);
+
+out:
+	security_release_secctx(context, len);
+	return err;
+}
+#endif
+
 #define WORD0_ABSENT_FS_ATTRS (FATTR4_WORD0_FS_LOCATIONS | FATTR4_WORD0_FSID | \
 			      FATTR4_WORD0_RDATTR_ERROR)
 #define WORD1_ABSENT_FS_ATTRS FATTR4_WORD1_MOUNTED_ON_FILEID
@@ -1475,6 +1540,14 @@ nfsd4_encode_fattr(struct svc_fh *fhp, struct svc_export *exp,
 			bmval0 &= ~FATTR4_WORD0_FS_LOCATIONS;
 		}
 	}
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+	if (bmval1 & FATTR4_WORD1_SECURITY_LABEL) {
+		if (/* XXX !selinux_enabled */ 0)
+			bmval1 &= ~FATTR4_WORD1_SECURITY_LABEL;
+	}
+#else
+	bmval1 &= ~FATTR4_WORD1_SECURITY_LABEL;
+#endif
 	if ((buflen -= 16) < 0)
 		goto out_resource;
 
@@ -1485,15 +1558,24 @@ nfsd4_encode_fattr(struct svc_fh *fhp, struct svc_export *exp,
 
 	if (bmval0 & FATTR4_WORD0_SUPPORTED_ATTRS) {
 		u32 word0 = NFSD_SUPPORTED_ATTRS_WORD0;
+		u32 word1 = NFSD_SUPPORTED_ATTRS_WORD1;
 		if ((buflen -= 12) < 0)
 			goto out_resource;
 		if (!aclsupport)
 			word0 &= ~FATTR4_WORD0_ACL;
 		if (!exp->ex_fslocs.locations)
 			word0 &= ~FATTR4_WORD0_FS_LOCATIONS;
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+		if (exp->ex_flags & NFSEXP_SECURITY_LABEL)
+			word1 |= FATTR4_WORD1_SECURITY_LABEL;
+		else
+			word1 &= ~FATTR4_WORD1_SECURITY_LABEL;
+#else
+		word1 &= ~FATTR4_WORD1_SECURITY_LABEL;
+#endif
 		WRITE32(2);
 		WRITE32(word0);
-		WRITE32(NFSD_SUPPORTED_ATTRS_WORD1);
+		WRITE32(word1);
 	}
 	if (bmval0 & FATTR4_WORD0_TYPE) {
 		if ((buflen -= 4) < 0)
@@ -1803,6 +1885,16 @@ out_acl:
 		}
 		WRITE64(stat.ino);
 	}
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+	if (bmval1 & FATTR4_WORD1_SECURITY_LABEL) {
+		status = nfsd4_encode_security_label(rqstp, dentry,
+				&p, &buflen);
+		if (status == nfserr_resource)
+			goto out_resource;
+		if (status)
+			goto out;
+	}
+#endif
 	*attrlenp = htonl((char *)p - (char *)attrlenp - 4);
 	*countp = p - buffer;
 	status = nfs_ok;
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 4433c8f..d4c4365 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -556,6 +556,34 @@ nfsd4_get_nfs4_acl(struct svc_rqst *rqstp, struct dentry *dentry, struct nfs4_ac
 	return error;
 }
 
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+__be32 nfsd4_set_nfs4_label(struct svc_rqst *rqstp, struct svc_fh *fhp,
+    struct nfs4_label *label)
+{
+	__be32 error;
+	int host_error;
+	struct dentry *dentry;
+
+	/* Get inode */
+	/* XXX: should we have a MAY_SSECCTX? */
+	error = fh_verify(rqstp, fhp, 0 /* S_IFREG */, NFSD_MAY_SATTR);
+	if (error)
+		return error;
+
+	dentry = fhp->fh_dentry;
+
+	mutex_lock(&dentry->d_inode->i_mutex);
+	host_error = security_inode_setsecctx(dentry, label->label, label->len);
+	mutex_unlock(&dentry->d_inode->i_mutex);
+	return nfserrno(host_error);
+}
+#else
+__be32 nfsd4_set_nfs4_label(struct svc_rqst *rqstp, struct svc_fh *fhp,
+    struct nfs4_label *label)
+{
+}
+#endif
+
 #endif /* defined(CONFIG_NFS_V4) */
 
 #ifdef CONFIG_NFSD_V3
diff --git a/include/linux/nfsd/nfsd.h b/include/linux/nfsd/nfsd.h
index 8219925..e7393b9 100644
--- a/include/linux/nfsd/nfsd.h
+++ b/include/linux/nfsd/nfsd.h
@@ -87,6 +87,8 @@ __be32		nfsd_setattr(struct svc_rqst *, struct svc_fh *,
 __be32          nfsd4_set_nfs4_acl(struct svc_rqst *, struct svc_fh *,
                     struct nfs4_acl *);
 int             nfsd4_get_nfs4_acl(struct svc_rqst *, struct dentry *, struct nfs4_acl **);
+__be32          nfsd4_set_nfs4_label(struct svc_rqst *, struct svc_fh *,
+                    struct nfs4_label *);
 #endif /* CONFIG_NFSD_V4 */
 __be32		nfsd_create(struct svc_rqst *, struct svc_fh *,
 				char *name, int len, struct iattr *attrs,
-- 
1.5.5.1

