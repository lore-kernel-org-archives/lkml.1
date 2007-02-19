Return-Path: <linux-kernel-owner+w=401wt.eu-S1751546AbXBSE54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbXBSE54 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 23:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbXBSE54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 23:57:56 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37484 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbXBSE5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 23:57:55 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 1/1] fs/stack.c: Copy i_nlink after all other attributes are copied
Date: Sun, 18 Feb 2007 23:57:45 -0500
Message-Id: <11718610652955-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.19.gddff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

A user-specified get_nlinks may depend on other inode attributes.

Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/stack.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/stack.c b/fs/stack.c
index 8ffb880..67716f6 100644
--- a/fs/stack.c
+++ b/fs/stack.c
@@ -20,11 +20,6 @@ EXPORT_SYMBOL_GPL(fsstack_copy_inode_size);
 void fsstack_copy_attr_all(struct inode *dest, const struct inode *src,
 				int (*get_nlinks)(struct inode *))
 {
-	if (!get_nlinks)
-		dest->i_nlink = src->i_nlink;
-	else
-		dest->i_nlink = (*get_nlinks)(dest);
-
 	dest->i_mode = src->i_mode;
 	dest->i_uid = src->i_uid;
 	dest->i_gid = src->i_gid;
@@ -34,5 +29,14 @@ void fsstack_copy_attr_all(struct inode *dest, const struct inode *src,
 	dest->i_ctime = src->i_ctime;
 	dest->i_blkbits = src->i_blkbits;
 	dest->i_flags = src->i_flags;
+
+	/*
+	 * Update the nlinks AFTER updating the above fields, because the
+	 * get_links callback may depend on them.
+	 */
+	if (!get_nlinks)
+		dest->i_nlink = src->i_nlink;
+	else
+		dest->i_nlink = (*get_nlinks)(dest);
 }
 EXPORT_SYMBOL_GPL(fsstack_copy_attr_all);
-- 
1.5.0.19.gddff

