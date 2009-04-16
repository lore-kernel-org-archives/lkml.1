Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbZDPV6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbZDPV6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 17:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbZDPV6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 17:58:45 -0400
Received: from smtp6.tech.numericable.fr ([82.216.111.42]:58723 "EHLO
	smtp6.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbZDPV6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 17:58:45 -0400
Message-ID: <49E7AA12.2090406@numericable.fr>
Date: Thu, 16 Apr 2009 23:58:42 +0200
From: Etienne Basset <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: LSM <linux-security-module@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Smack: check for SMACK xattr validity in smack_inode_setxattr
References: <49E4D5B6.80202@numericable.fr> <49E561C8.90306@schaufler-ca.com> <49E57DFF.9030207@numericable.fr> <49E60B2D.5080508@schaufler-ca.com>
In-Reply-To: <49E60B2D.5080508@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the following patch moves checks for SMACK xattr validity
from smack_inode_post_setxattr (which cannot return an error to the user)
to smack_inode_setxattr (which can return an error).

Signed-off-by: Etienne Basset <etienne.basset@numericable.fr>
---
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 9215149..98b3195 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -609,8 +609,12 @@ static int smack_inode_setxattr(struct dentry *dentry, const char *name,
 	    strcmp(name, XATTR_NAME_SMACKIPOUT) == 0) {
 		if (!capable(CAP_MAC_ADMIN))
 			rc = -EPERM;
-		/* a label cannot be void and cannot begin with '-' */
-		if (size == 0 || (size > 0 && ((char *)value)[0] == '-'))
+		/*
+		 * check label validity here so import wont fail on
+		 * post_setxattr
+		 */
+		if (size == 0 || size >= SMK_LABELLEN ||
+		    smk_import(value, size) == NULL)
 			rc = -EINVAL;
 	} else
 		rc = cap_inode_setxattr(dentry, name, value, size, flags);
@@ -644,9 +648,6 @@ static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
 	if (strcmp(name, XATTR_NAME_SMACK))
 		return;
 
-	if (size >= SMK_LABELLEN)
-		return;
-
 	isp = dentry->d_inode->i_security;
 
 	/*


