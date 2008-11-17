Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbYKQS6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbYKQS6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYKQS6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:58:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33896 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbYKQS6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:58:35 -0500
Date: Mon, 17 Nov 2008 13:58:34 -0500
From: Kyle McMartin <kyle@redhat.com>
To: phillip.lougher@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH squashfs] fix squashfs for d_alloc_anon removal
Message-ID: <20081117185834.GA26417@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kyle McMartin <kyle@redhat.com>

diff --git a/fs/squashfs/inode.c b/fs/squashfs/inode.c
index 0c0173c..335ba3e 100644
--- a/fs/squashfs/inode.c
+++ b/fs/squashfs/inode.c
@@ -639,29 +639,14 @@ static struct dentry *squashfs_export_iget(struct super_block *s,
 {
 	squashfs_inode_t inode;
 	struct inode *i;
-	struct dentry *dentry;
+	struct dentry *dentry = ERR_PTR(-ENOENT);
 
 	TRACE("Entered squashfs_export_iget\n");
 
 	inode = squashfs_inode_lookup(s, inode_number);
-	if(inode == SQUASHFS_INVALID_BLK) {
-		dentry = ERR_PTR(-ENOENT);
-		goto failure;
-	}
-
-	i = squashfs_iget(s, inode, inode_number);
-	if(i == NULL) {
-		dentry = ERR_PTR(-EACCES);
-		goto failure;
-	}
-
-	dentry = d_alloc_anon(i);
-	if (dentry == NULL) {
-		iput(i);
-		dentry = ERR_PTR(-ENOMEM);
-	}
+	if (inode != SQUASHFS_INVALID_BLK)
+		dentry = d_obtain_alias(squashfs_iget(s, inode, inode_number));
 
-failure:
 	return dentry;
 }
 
