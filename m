Return-Path: <linux-kernel-owner+w=401wt.eu-S1759614AbXEVUF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614AbXEVUF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 16:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756775AbXEVUFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 16:05:16 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40402 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbXEVUFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 16:05:15 -0400
Date: Tue, 22 May 2007 23:05:13 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] revoke: fix zero-length kmalloc
Message-ID: <Pine.LNX.4.64.0705222304500.22904@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Fix a zero-length kmalloc in the case where there is nothing to revoke.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/revoke.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

Index: 26-mm/fs/revoke.c
===================================================================
--- 26-mm.orig/fs/revoke.c	2007-05-22 22:58:17.000000000 +0300
+++ 26-mm/fs/revoke.c	2007-05-22 23:01:17.000000000 +0300
@@ -547,22 +547,12 @@ static struct fileset *__alloc_revoke_fs
 	return NULL;
 }
 
-static struct fileset *alloc_revoke_fset(struct inode *inode, struct file *to_exclude)
-{
-	unsigned long nr_fds;
-
-	read_lock(&tasklist_lock);
-	nr_fds = inode_fds(inode, to_exclude);
-	read_unlock(&tasklist_lock);
-
-	return __alloc_revoke_fset(nr_fds);
-}
-
 static int do_revoke(struct inode *inode, struct file *to_exclude)
 {
 	struct revoke_details details;
 	struct fileset *fset = NULL;
 	struct task_struct *g, *p;
+	unsigned long nr_fds;
 	int err = 0;
 
 	if (current->fsuid != inode->i_uid && !capable(CAP_FOWNER)) {
@@ -576,11 +566,18 @@ static int do_revoke(struct inode *inode
 		goto out;
 	}
 
+	read_lock(&tasklist_lock);
+	nr_fds = inode_fds(inode, to_exclude);
+	read_unlock(&tasklist_lock);
+
+	if (!nr_fds)
+		goto out;
+
 	/*
 	 * Pre-allocate memory because the first pass is done under
 	 * tasklist_lock.
 	 */
-	fset = alloc_revoke_fset(inode, to_exclude);
+	fset = __alloc_revoke_fset(nr_fds);
 	if (!fset) {
 		err = -ENOMEM;
 		goto out;
