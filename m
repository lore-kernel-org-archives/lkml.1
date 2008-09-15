Return-Path: <linux-kernel-owner+w=401wt.eu-S1758029AbYIOVMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbYIOVMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 17:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbYIOVHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 17:07:04 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:64461 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130AbYIOVGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 17:06:35 -0400
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
Subject: [PATCH 13/14] NFS: Extend NFS xattr handlers to accept the security namespace
Date: Mon, 15 Sep 2008 16:41:17 -0400
Message-Id: <1221511278-28051-14-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1221511278-28051-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1221511278-28051-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing NFSv4 xattr handlers do not accept xattr calls to the security
namespace. This patch extends these handlers to accept xattrs from the security
namespace in addition to the default NFSv4 ACL namespace.

Signed-off-by: Matthew N. Dodd <Matthew.Dodd@sparta.com>
Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 fs/nfs/nfs4proc.c   |   52 ++++++++++++++++++++++++++++++++++++++++----------
 security/security.c |    1 +
 2 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 622bf71..845e1da 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3934,10 +3934,17 @@ int nfs4_setxattr(struct dentry *dentry, const char *key, const void *buf,
 {
 	struct inode *inode = dentry->d_inode;
 
-	if (strcmp(key, XATTR_NAME_NFSV4_ACL) != 0)
-		return -EOPNOTSUPP;
-
-	return nfs4_proc_set_acl(inode, buf, buflen);
+	if (strcmp(key, XATTR_NAME_NFSV4_ACL) == 0) {
+		if (!S_ISREG(inode->i_mode) &&
+		   (!S_ISDIR(inode->i_mode) || inode->i_mode & S_ISVTX))
+			return -EPERM;
+		return nfs4_proc_set_acl(inode, buf, buflen);
+	}
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (security_ismaclabel(key))
+		return nfs4_set_security_label(dentry, buf, buflen);
+#endif
+	return -EOPNOTSUPP;
 }
 
 /* The getxattr man page suggests returning -ENODATA for unknown attributes,
@@ -3949,22 +3956,45 @@ ssize_t nfs4_getxattr(struct dentry *dentry, const char *key, void *buf,
 {
 	struct inode *inode = dentry->d_inode;
 
-	if (strcmp(key, XATTR_NAME_NFSV4_ACL) != 0)
-		return -EOPNOTSUPP;
+	if (strcmp(key, XATTR_NAME_NFSV4_ACL) == 0)
+		return nfs4_proc_get_acl(inode, buf, buflen);
 
-	return nfs4_proc_get_acl(inode, buf, buflen);
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (security_ismaclabel(key))
+		return nfs4_get_security_label(inode, buf, buflen);
+#endif
+	return -EOPNOTSUPP;
 }
 
 ssize_t nfs4_listxattr(struct dentry *dentry, char *buf, size_t buflen)
 {
-	size_t len = strlen(XATTR_NAME_NFSV4_ACL) + 1;
+	size_t len = 0, l;
+	char *p;
 
-	if (!nfs4_server_supports_acls(NFS_SERVER(dentry->d_inode)))
+	if (nfs4_server_supports_acls(NFS_SERVER(dentry->d_inode)))
+		len += strlen(XATTR_NAME_NFSV4_ACL) + 1;
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (nfs_server_capable(dentry->d_inode, NFS_CAP_SECURITY_LABEL))
+		len += security_inode_listsecurity(dentry->d_inode, NULL, 0);
+#endif
+	if (!len)
 		return 0;
 	if (buf && buflen < len)
 		return -ERANGE;
-	if (buf)
-		memcpy(buf, XATTR_NAME_NFSV4_ACL, len);
+	if (!buf)
+		return len;
+
+	p = buf;
+	if (nfs4_server_supports_acls(NFS_SERVER(dentry->d_inode))) {
+		l = strlen(XATTR_NAME_NFSV4_ACL) + 1;
+		memcpy(p, XATTR_NAME_NFSV4_ACL, l);
+		p += l;
+	}
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (nfs_server_capable(dentry->d_inode, NFS_CAP_SECURITY_LABEL))
+		p += security_inode_listsecurity(dentry->d_inode, p,
+			buflen - (p - buf));
+#endif
 	return len;
 }
 
diff --git a/security/security.c b/security/security.c
index 2337d7f..44d6e37 100644
--- a/security/security.c
+++ b/security/security.c
@@ -536,6 +536,7 @@ int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer
 		return 0;
 	return security_ops->inode_listsecurity(inode, buffer, buffer_size);
 }
+EXPORT_SYMBOL(security_inode_listsecurity);
 
 void security_inode_getsecid(const struct inode *inode, u32 *secid)
 {
-- 
1.5.5.1

