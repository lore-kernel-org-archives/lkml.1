Return-Path: <linux-kernel-owner+w=401wt.eu-S1758836AbZDNS3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836AbZDNS3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758638AbZDNS2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:28:15 -0400
Received: from smtp7.tech.numericable.fr ([82.216.111.43]:50860 "EHLO
	smtp7.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758272AbZDNS2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:28:13 -0400
Message-ID: <49E4D5B6.80202@numericable.fr>
Date: Tue, 14 Apr 2009 20:28:06 +0200
From: Etienne Basset <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>,
       LSM <linux-security-module@vger.kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Smack: check for SMACK xattr max size in  smack_inode_setxattr
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the following patch move the check for SMACK xattr size >= SMK_LABELLEN
from  smack_inode_post_setxattr (which cannot return an error to the user)
to smack_inode_setxattr (which can return an error).

without patch a SMACK setxattr with size >= SMK_LABELLEN returns success although it doesn't 

Signed-off-by: Etienne Basset <etienne.basset@numericable.fr>
---
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 9215149..da6954d 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -610,7 +610,8 @@ static int smack_inode_setxattr(struct dentry *dentry, const char *name,
 		if (!capable(CAP_MAC_ADMIN))
 			rc = -EPERM;
 		/* a label cannot be void and cannot begin with '-' */
-		if (size == 0 || (size > 0 && ((char *)value)[0] == '-'))
+		if (size == 0 || size >= SMK_LABELLEN ||
+		   (size > 0 && ((char *)value)[0] == '-'))
 			rc = -EINVAL;
 	} else
 		rc = cap_inode_setxattr(dentry, name, value, size, flags);
@@ -644,9 +645,6 @@ static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
 	if (strcmp(name, XATTR_NAME_SMACK))
 		return;
 
-	if (size >= SMK_LABELLEN)
-		return;
-
 	isp = dentry->d_inode->i_security;
 
 	/*

