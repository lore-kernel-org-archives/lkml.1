Return-Path: <linux-kernel-owner+w=401wt.eu-S1762811AbYB0XMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762811AbYB0XMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758766AbYB0XIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:08:52 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:44380 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758749AbYB0XIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:08:31 -0500
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>
Subject: [PATCH 11/11] NFSD: Server implementation of MAC Labeling
Date: Wed, 27 Feb 2008 17:11:34 -0500
Message-Id: <1204150294-4678-12-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the encoding of a MAC label on the server side to be
sent across the wire to the NFSv4 client. At this time there is no method of
receiving a label from the client to be set on the server.

Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 fs/nfsd/nfs4xdr.c   |   90 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/nfsd/vfs.c       |    7 ++++
 security/security.c |    1 +
 3 files changed, 97 insertions(+), 1 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 0e6a179..5de2a91 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -50,6 +50,7 @@
 #include <linux/sunrpc/xdr.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/sunrpc/clnt.h>
+#include <linux/nfs_fs.h>
 #include <linux/nfsd/nfsd.h>
 #include <linux/nfsd/state.h>
 #include <linux/nfsd/xdr4.h>
@@ -58,6 +59,8 @@
 #include <linux/nfs4_acl.h>
 #include <linux/sunrpc/gss_api.h>
 #include <linux/sunrpc/svcauth_gss.h>
+#include <linux/security.h>
+#include <linux/xattr.h>
 
 #define NFSDDBG_FACILITY		NFSDDBG_XDR
 
@@ -416,6 +419,22 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval, struct iattr *ia
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
+		iattr->ia_label_len = dummy32;
+		iattr->ia_label = kmalloc(dummy32 + 1, GFP_ATOMIC);
+		memcpy(iattr->ia_label, buf, dummy32);
+		((char *)iattr->ia_label)[dummy32 + 1] = '\0';
+		iattr->ia_valid |= ATTR_SECURITY_LABEL;
+		defer_free(argp, kfree, iattr->ia_label);
+	}
+#endif /* CONFIG_NFSD_V4_SECURITY_LABEL */
 	if (len != expected_len)
 		goto xdr_error;
 
@@ -1423,6 +1442,44 @@ nfsd4_encode_aclname(struct svc_rqst *rqstp, int whotype, uid_t id, int group,
 	return nfsd4_encode_name(rqstp, whotype, id, group, p, buflen);
 }
 
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+static inline __be32
+nfsd4_encode_security_label(struct svc_rqst *rqstp,
+			    struct dentry *dentry,
+			    __be32 **p, int *buflen)
+{
+	void *context;
+	int err = 0, len;
+
+	const char *suffix = security_maclabel_getname()
+				+ XATTR_SECURITY_PREFIX_LEN;
+
+	len = security_inode_getsecurity(dentry->d_inode, suffix, &context, true);
+	if (len < 0) {
+		err = nfserrno(len);
+		goto out;
+	}
+
+	if (len > NFS4_MAXLABELLEN) {
+		err = nfserrno(len);
+		goto out_err;
+	}
+	if (*buflen < ((XDR_QUADLEN(len) << 2) + 4)) {
+		err =  nfserr_resource;
+		goto out_err;
+	}
+
+	*p = xdr_encode_opaque(*p, context, len);
+	*buflen -= (XDR_QUADLEN(len) << 2) + 4;
+	BUG_ON(*buflen < 0);
+
+out_err:
+	security_release_secctx(context, len);
+out:
+	return err;
+}
+#endif /* CONFIG_NFSD_V4_SECURITY_LABEL */
+
 #define WORD0_ABSENT_FS_ATTRS (FATTR4_WORD0_FS_LOCATIONS | FATTR4_WORD0_FSID | \
 			      FATTR4_WORD0_RDATTR_ERROR)
 #define WORD1_ABSENT_FS_ATTRS FATTR4_WORD1_MOUNTED_ON_FILEID
@@ -1518,6 +1575,16 @@ nfsd4_encode_fattr(struct svc_fh *fhp, struct svc_export *exp,
 			bmval0 &= ~FATTR4_WORD0_FS_LOCATIONS;
 		}
 	}
+
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+	if (bmval1 & FATTR4_WORD1_SECURITY_LABEL) {
+		if (/* XXX !selinux_enabled */0)
+			bmval1 &= ~FATTR4_WORD1_SECURITY_LABEL;
+	}
+#else
+	bmval1 &= ~FATTR4_WORD1_SECURITY_LABEL;
+#endif
+
 	if ((buflen -= 16) < 0)
 		goto out_resource;
 
@@ -1528,15 +1595,25 @@ nfsd4_encode_fattr(struct svc_fh *fhp, struct svc_export *exp,
 
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
+#endif /* CONFIG_NFSD_V4_SECURITY_LABEL */
+
 		WRITE32(2);
 		WRITE32(word0);
-		WRITE32(NFSD_SUPPORTED_ATTRS_WORD1);
+		WRITE32(word1);
 	}
 	if (bmval0 & FATTR4_WORD0_TYPE) {
 		if ((buflen -= 4) < 0)
@@ -1846,6 +1923,17 @@ out_acl:
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
+#endif /* CONFIG_NFSD_V4_SECURITY_LABEL */
+
 	*attrlenp = htonl((char *)p - (char *)attrlenp - 4);
 	*countp = p - buffer;
 	status = nfs_ok;
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 46f59d5..45e9340 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1538,6 +1538,13 @@ nfsd_symlink(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (!host_err) {
 		if (EX_ISSYNC(fhp->fh_export))
 			host_err = nfsd_sync_dir(dentry);
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+		if (iap && (iap->ia_valid & ATTR_SECURITY_LABEL)) {
+			char *key = (char *)security_maclabel_getname();
+			host_err = vfs_setxattr_locked(dnew, key,
+					iap->ia_label, iap->ia_label_len, 0);
+		}
+#endif
 	}
 	err = nfserrno(host_err);
 	fh_unlock(fhp);
diff --git a/security/security.c b/security/security.c
index 1276c98..646a411 100644
--- a/security/security.c
+++ b/security/security.c
@@ -510,6 +510,7 @@ int security_inode_getsecurity(const struct inode *inode, const char *name, void
 		return 0;
 	return security_ops->inode_getsecurity(inode, name, buffer, alloc);
 }
+EXPORT_SYMBOL(security_inode_getsecurity);
 
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags)
 {
-- 
1.5.3.8

