Return-Path: <linux-kernel-owner+w=401wt.eu-S1757072AbXKZQqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbXKZQqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbXKZQpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:45:33 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52780 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbXKZQp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:45:27 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 15/16] Unionfs: update our inode size correctly upon partial write
Date: Mon, 26 Nov 2007 11:44:12 -0500
Message-Id: <11960954593171-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
References: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/mmap.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index ea5ef3d..8c07eed 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -250,7 +250,6 @@ static int unionfs_commit_write(struct file *file, struct page *page,
 	int err = -ENOMEM;
 	struct inode *inode, *lower_inode;
 	struct file *lower_file = NULL;
-	loff_t pos;
 	unsigned bytes = to - from;
 	char *page_data = NULL;
 	mm_segment_t old_fs;
@@ -293,12 +292,8 @@ static int unionfs_commit_write(struct file *file, struct page *page,
 	if (err < 0)
 		goto out;
 
-	inode->i_blocks = lower_inode->i_blocks;
-	/* we may have to update i_size */
-	pos = page_offset(page) + to;
-	if (pos > i_size_read(inode))
-		i_size_write(inode, pos);
-	/* if vfs_write succeeded above, sync up our times */
+	/* if vfs_write succeeded above, sync up our times/sizes */
+	fsstack_copy_inode_size(inode, lower_inode);
 	unionfs_copy_attr_times(inode);
 	mark_inode_dirty_sync(inode);
 
-- 
1.5.2.2

