Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbYASXFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbYASXFT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 18:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbYASXFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 18:05:05 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:41244 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbYASXFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 18:05:03 -0500
Message-ID: <47928214.60800@mvista.com>
Date: Sat, 19 Jan 2008 15:04:52 -0800
From: Casey Schaufler <cschaufler@mvista.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: akpm@osdl.org, torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH] (2.6.24-rc8-mm1)  -mm v2 Smack socket label setting fix
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>

Correct the checks in smack_inode_setxattr to include the
socket labeling attributes. Simplify and correct
smack_sock_graft, while the values it was setting were
safe they were not correct and the job was not being
done efficiently. smack_inode_setsecurity wasn't
invoking the required netlabel function in the case
where smk_ipout was set. It does now, but that change
required the hook to be moved in the file. This
movement accounts for the bulk of the patch.


Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---

This version corrects an indentation error in the previous patch.

 security/smack/smack.h     |    2
 security/smack/smack_lsm.c |  136 ++++++++++++++++-------------------
 2 files changed, 67 insertions(+), 71 deletions(-)

diff -uprN -X linux-2.6.24-rc8-mm1-base/Documentation/dontdiff linux-2.6.24-rc8-mm1-base/security/smack/smack.h linux-2.6.24-rc8-mm1-smack/security/smack/smack.h
--- linux-2.6.24-rc8-mm1-base/security/smack/smack.h	2008-01-18 14:12:26.000000000 -0800
+++ linux-2.6.24-rc8-mm1-smack/security/smack/smack.h	2008-01-18 15:09:43.000000000 -0800
@@ -130,6 +130,8 @@ struct smack_known {
 #define XATTR_SMACK_IPIN	"SMACK64IPIN"
 #define XATTR_SMACK_IPOUT	"SMACK64IPOUT"
 #define XATTR_NAME_SMACK	XATTR_SECURITY_PREFIX XATTR_SMACK_SUFFIX
+#define XATTR_NAME_SMACKIPIN	XATTR_SECURITY_PREFIX XATTR_SMACK_IPIN
+#define XATTR_NAME_SMACKIPOUT	XATTR_SECURITY_PREFIX XATTR_SMACK_IPOUT
 
 /*
  * smackfs macic number
diff -uprN -X linux-2.6.24-rc8-mm1-base/Documentation/dontdiff linux-2.6.24-rc8-mm1-base/security/smack/smack_lsm.c linux-2.6.24-rc8-mm1-smack/security/smack/smack_lsm.c
--- linux-2.6.24-rc8-mm1-base/security/smack/smack_lsm.c	2008-01-18 14:12:26.000000000 -0800
+++ linux-2.6.24-rc8-mm1-smack/security/smack/smack_lsm.c	2008-01-18 20:22:19.000000000 -0800
@@ -584,8 +584,12 @@ static int smack_inode_getattr(struct vf
 static int smack_inode_setxattr(struct dentry *dentry, char *name,
 				void *value, size_t size, int flags)
 {
-	if (strcmp(name, XATTR_NAME_SMACK) == 0 && !capable(CAP_MAC_ADMIN))
-		return -EPERM;
+	if (!capable(CAP_MAC_ADMIN)) {
+		if (strcmp(name, XATTR_NAME_SMACK) == 0 ||
+		    strcmp(name, XATTR_NAME_SMACKIPIN) == 0 ||
+		    strcmp(name, XATTR_NAME_SMACKIPOUT) == 0)
+			return -EPERM;
+	}
 
 	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
 }
@@ -718,57 +722,6 @@ static int smack_inode_getsecurity(const
 	return rc;
 }
 
-/**
- * smack_inode_setsecurity - set smack xattrs
- * @inode: the object
- * @name: attribute name
- * @value: attribute value
- * @size: size of the attribute
- * @flags: unused
- *
- * Sets the named attribute in the appropriate blob
- *
- * Returns 0 on success, or an error code
- */
-static int smack_inode_setsecurity(struct inode *inode, const char *name,
-				   const void *value, size_t size, int flags)
-{
-	char *sp;
-	struct inode_smack *nsp = inode->i_security;
-	struct socket_smack *ssp;
-	struct socket *sock;
-
-	if (value == NULL || size > SMK_LABELLEN)
-		return -EACCES;
-
-	sp = smk_import(value, size);
-	if (sp == NULL)
-		return -EINVAL;
-
-	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
-		nsp->smk_inode = sp;
-		return 0;
-	}
-	/*
-	 * The rest of the Smack xattrs are only on sockets.
-	 */
-	if (inode->i_sb->s_magic != SOCKFS_MAGIC)
-		return -EOPNOTSUPP;
-
-	sock = SOCKET_I(inode);
-	if (sock == NULL)
-		return -EOPNOTSUPP;
-
-	ssp = sock->sk->sk_security;
-
-	if (strcmp(name, XATTR_SMACK_IPIN) == 0)
-		ssp->smk_in = sp;
-	else if (strcmp(name, XATTR_SMACK_IPOUT) == 0)
-		ssp->smk_out = sp;
-	else
-		return -EOPNOTSUPP;
-	return 0;
-}
 
 /**
  * smack_inode_listsecurity - list the Smack attributes
@@ -1341,6 +1294,60 @@ static int smack_netlabel(struct sock *s
 }
 
 /**
+ * smack_inode_setsecurity - set smack xattrs
+ * @inode: the object
+ * @name: attribute name
+ * @value: attribute value
+ * @size: size of the attribute
+ * @flags: unused
+ *
+ * Sets the named attribute in the appropriate blob
+ *
+ * Returns 0 on success, or an error code
+ */
+static int smack_inode_setsecurity(struct inode *inode, const char *name,
+				   const void *value, size_t size, int flags)
+{
+	char *sp;
+	struct inode_smack *nsp = inode->i_security;
+	struct socket_smack *ssp;
+	struct socket *sock;
+
+	if (value == NULL || size > SMK_LABELLEN)
+		return -EACCES;
+
+	sp = smk_import(value, size);
+	if (sp == NULL)
+		return -EINVAL;
+
+	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
+		nsp->smk_inode = sp;
+		return 0;
+	}
+	/*
+	 * The rest of the Smack xattrs are only on sockets.
+	 */
+	if (inode->i_sb->s_magic != SOCKFS_MAGIC)
+		return -EOPNOTSUPP;
+
+	sock = SOCKET_I(inode);
+	if (sock == NULL)
+		return -EOPNOTSUPP;
+
+	ssp = sock->sk->sk_security;
+
+	if (strcmp(name, XATTR_SMACK_IPIN) == 0)
+		ssp->smk_in = sp;
+	else if (strcmp(name, XATTR_SMACK_IPOUT) == 0) {
+		ssp->smk_out = sp;
+		return smack_netlabel(sock->sk);
+	} else
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+/**
  * smack_socket_post_create - finish socket setup
  * @sock: the socket
  * @family: protocol family
@@ -2192,33 +2199,20 @@ static int smack_socket_getpeersec_dgram
 static void smack_sock_graft(struct sock *sk, struct socket *parent)
 {
 	struct socket_smack *ssp;
-	struct netlbl_lsm_secattr secattr;
-	char smack[SMK_LABELLEN];
 	int rc;
 
-	if (sk == NULL || parent == NULL || parent->sk == NULL)
+	if (sk == NULL)
 		return;
 
 	if (sk->sk_family != PF_INET && sk->sk_family != PF_INET6)
 		return;
 
-	ssp = parent->sk->sk_security;
-
-	memset(smack, '\0', SMK_LABELLEN);
-	netlbl_secattr_init(&secattr);
-	rc = netlbl_sock_getattr(sk, &secattr);
-	if (rc == 0)
-		smack_from_secattr(&secattr, smack);
-	else
-		strncpy(smack, smack_known_huh.smk_known, SMK_MAXLEN);
-	netlbl_secattr_destroy(&secattr);
-
-	netlbl_secattr_init(&secattr);
+	ssp = sk->sk_security;
+	ssp->smk_in = current->security;
+	ssp->smk_out = current->security;
+	ssp->smk_packet[0] = '\0';
 
-	smack_to_secattr(smack, &secattr);
-	if (secattr.flags != NETLBL_SECATTR_NONE)
-		rc = netlbl_sock_setattr(parent->sk, &secattr);
-	netlbl_secattr_destroy(&secattr);
+	rc = smack_netlabel(sk);
 }
 
 /**



-- 

Casey Schaufler
MontaVista Software
cschaufler@mvista.com
408.572.7881

