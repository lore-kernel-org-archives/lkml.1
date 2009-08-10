Return-Path: <linux-kernel-owner+w=401wt.eu-S1753089AbZHJJTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbZHJJTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 05:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZHJJTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 05:19:18 -0400
Received: from smtp.ispras.ru ([83.149.198.201]:33460 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbZHJJTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:19:17 -0400
X-Greylist: delayed 1664 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Aug 2009 05:19:17 EDT
To: linux-kernel@vger.kernel.org
Subject: BUG memory leakage at ./security/selinux/hooks.c
Content-Disposition: inline
From: iceberg <strakh@ispras.ru>
Organization: ISP RAS
Date: Mon, 10 Aug 2009 12:57:43 +0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908101257.43672.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        KERNEL_VERSION: 2.6.30.4
        SUBJECT:  in function inode_doinit_with_dentry memory is not released 
on error  path (if rc<0).
        DESCRIBE:
        In ./security/selinux/hooks.c in function inode_doinit_with_dentry:
1. If in the line 1278 we successfully allocate memory and assign it to 
context variablehen
2. if in the line 1284 getxattr returns -ERANGE and
3. if in the line 1288 getxattr returns rc<0
then we go to out_unlock without releasing memory pointed to by context 
variable.

1278                 context = kmalloc(len, GFP_NOFS);
1279                 if (!context) {
1280                         rc = -ENOMEM;
1281                         dput(dentry);
1282                         goto out_unlock;
1283                 }
1284                 rc = inode->i_op->getxattr(dentry, XATTR_NAME_SELINUX,
1285                                            context, len);
1286                 if (rc == -ERANGE) {
1287                         /* Need a larger buffer.  Query for the
right size. */
1288                         rc = inode->i_op->getxattr(dentry,
XATTR_NAME_SELINUX,
1289                                                    NULL, 0);
1290                         if (rc < 0) {
1291                                 dput(dentry);
1292                                 goto out_unlock;
1293                         }
1294                         kfree(context);
1295                         len = rc;
1296                         context = kmalloc(len, GFP_NOFS);


