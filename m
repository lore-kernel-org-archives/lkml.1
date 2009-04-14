Return-Path: <linux-kernel-owner+w=401wt.eu-S1758104AbZDNSOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbZDNSOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZDNSOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:14:23 -0400
Received: from smtp6.tech.numericable.fr ([82.216.111.42]:56048 "EHLO
	smtp6.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbZDNSOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:14:22 -0400
Message-ID: <49E4D27A.9040108@numericable.fr>
Date: Tue, 14 Apr 2009 20:14:18 +0200
From: Etienne Basset <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>,
       LSM <linux-security-module@vger.kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Smack: reset inode security blob on remove_xattr
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,

the patch below on top of current -git corrects the behavior of smack_inode_removexattr
to reset the security blob on the inode on SMACK64 xattr removal.
(I'm not quite sure of what the desired behavior on removal of SMACKIPIN/SMACKIPOUT should be)
Here is the behavior of 'attr -r', with and without the patch

without patch :
---------------
debian:/tmp# attr -S -g SMACK64 toto
Attribute "SMACK64" had a 6 byte value for toto:
pouet
debian:/tmp# attr -S -r SMACK64 toto
debian:/tmp# attr -S -g SMACK64 toto
Attribute "SMACK64" had a 6 byte value for toto:
pouet


with patch :
------------
debian:/tmp# attr -S -g SMACK64 toto
Attribute "SMACK64" had a 6 byte value for toto:
pouet
debian:/tmp# attr -S -r SMACK64 toto
debian:/tmp# attr -S -g SMACK64 toto
Attribute "SMACK64" had a 2 byte value for toto:
_


---

the following patch  corrects the behavior of smack_inode_removexattr
to reset the security blob on the inode on SMACK xattr removal
and to reset the security blob on socket on SMACKIPIN/SMACKIPOUT

Signed-off-by: Etienne Basset <etienne.basset@numericable.fr>
---
 security/smack/smack_lsm.c |   57 ++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 9215149..903bb6e 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -686,18 +686,61 @@ static int smack_inode_getxattr(struct dentry *dentry, const char *name)
 static int smack_inode_removexattr(struct dentry *dentry, const char *name)
 {
 	int rc = 0;
-
-	if (strcmp(name, XATTR_NAME_SMACK) == 0 ||
-	    strcmp(name, XATTR_NAME_SMACKIPIN) == 0 ||
-	    strcmp(name, XATTR_NAME_SMACKIPOUT) == 0) {
-		if (!capable(CAP_MAC_ADMIN))
-			rc = -EPERM;
-	} else
+	struct inode *inode;
+	struct inode_smack *isp;
+	struct superblock_smack *sbsp;
+	struct super_block *sbp;
+	struct socket *socket;
+	struct socket_smack *skp;
+	int smack_xattr = 0;
+
+	if (strcmp(name, XATTR_NAME_SMACK) == 0)
+		smack_xattr = 1;
+	else if (strcmp(name, XATTR_NAME_SMACKIPIN) == 0)
+		smack_xattr = 2;
+	else if (strcmp(name, XATTR_NAME_SMACKIPOUT) == 0)
+		smack_xattr = 3;
+	else
 		rc = cap_inode_removexattr(dentry, name);
 
+	if (smack_xattr && !capable(CAP_MAC_ADMIN))
+		rc = -EPERM;
+
 	if (rc == 0)
 		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
 
+	/* if Smack xattr we have to reset the security */
+	if (rc == 0 && smack_xattr) {
+		inode = dentry->d_inode;
+		isp = inode->i_security;
+
+		switch (smack_xattr) {
+		case 1:
+			sbp = inode->i_sb;
+			sbsp = sbp->s_security;
+			isp->smk_inode = sbsp->smk_default;
+			break;
+		case 2:
+			if (S_ISSOCK(inode->i_mode) == 0)
+				break;
+			socket = SOCKET_I(inode);
+			skp = socket->sk->sk_security;
+			/*
+			 * inode->i_security in the socket case should hold the
+			 * smack label of the process that created the socket
+			 * which is the default value for smk_in/smk_out
+			 */
+			skp->smk_in = isp->smk_inode;
+			break;
+		case 3:
+			if (S_ISSOCK(inode->i_mode) == 0)
+				break;
+			socket = SOCKET_I(inode);
+			skp = socket->sk->sk_security;
+			skp->smk_out = isp->smk_inode;
+			break;
+		}
+	}
 	return rc;
 }
 


