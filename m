Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbZHJMSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbZHJMSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbZHJMSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:18:23 -0400
Received: from tundra.namei.org ([65.99.196.166]:60806 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbZHJMSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:18:23 -0400
Date: Mon, 10 Aug 2009 22:17:47 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: iceberg <strakh@ispras.ru>
cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       Eric Paris <eparis@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH] SELinux: re. BUG memory leakage at
 ./security/selinux/hooks.c
In-Reply-To: <alpine.LRH.2.00.0908102152270.10706@tundra.namei.org>
Message-ID: <alpine.LRH.2.00.0908102216430.10792@tundra.namei.org>
References: <200908101257.43672.strakh@ispras.ru> <alpine.LRH.2.00.0908102152270.10706@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please review.

Author: James Morris <jmorris@namei.org>
Date:   Mon Aug 10 22:00:13 2009 +1000

    SELinux: fix memory leakage in /security/selinux/hooks.c
    
    Fix memory leakage in /security/selinux/hooks.c
    
    The buffer always needs to be freed here; we either error
    out or allocate more memory.
    
    Reported-by: iceberg <strakh@ispras.ru>
    Signed-off-by: James Morris <jmorris@namei.org>

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 15c2a08..1e8cfc4 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1285,6 +1285,8 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 		rc = inode->i_op->getxattr(dentry, XATTR_NAME_SELINUX,
 					   context, len);
 		if (rc == -ERANGE) {
+			kfree(context);
+
 			/* Need a larger buffer.  Query for the right size. */
 			rc = inode->i_op->getxattr(dentry, XATTR_NAME_SELINUX,
 						   NULL, 0);
@@ -1292,7 +1294,6 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 				dput(dentry);
 				goto out_unlock;
 			}
-			kfree(context);
 			len = rc;
 			context = kmalloc(len+1, GFP_NOFS);
 			if (!context) {

-- 
James Morris
<jmorris@namei.org>
