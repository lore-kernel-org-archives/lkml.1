Return-Path: <linux-kernel-owner+w=401wt.eu-S1751551AbXJUXx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbXJUXx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 19:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbXJUXv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 19:51:59 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49211 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbXJUXvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 19:51:51 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>, Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH 3/9] Unionfs: support lower filesystems without writeback capability
Date: Sun, 21 Oct 2007 19:51:16 -0400
Message-Id: <11930106842801-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11930106823372-git-send-email-ezk@cs.sunysb.edu>
References: <11930106823372-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Implement unionfs_writepages.  As per
mm/filemap.c:__filemap_fdatawrite_range(), don't call our writepage if the
lower mapping has BDI_CAP_NO_WRITEBACK capability set.

Signed-off-by: Pekka J Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/mmap.c  |   23 +++++++++++++++++++++++
 fs/unionfs/union.h |    1 +
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index 6440282..b43557e 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -144,6 +144,28 @@ out:
 	return err;
 }
 
+static int unionfs_writepages(struct address_space *mapping,
+			      struct writeback_control *wbc)
+{
+	int err = 0;
+	struct inode *lower_inode;
+	struct inode *inode;
+
+	inode = mapping->host;
+	lower_inode = unionfs_lower_inode(inode);
+	BUG_ON(!lower_inode);
+
+	if (!mapping_cap_writeback_dirty(lower_inode->i_mapping))
+		goto out;
+
+	/* Note: generic_writepages may return AOP_WRITEPAGE_ACTIVATE */
+	err = generic_writepages(mapping, wbc);
+	if (err == 0)
+		unionfs_copy_attr_times(inode);
+out:
+	return err;
+}
+
 /*
  * readpage is called from generic_page_read and the fault handler.
  * If your file system uses generic_page_read for the read op, it
@@ -374,6 +396,7 @@ out:
 
 struct address_space_operations unionfs_aops = {
 	.writepage	= unionfs_writepage,
+	.writepages	= unionfs_writepages,
 	.readpage	= unionfs_readpage,
 	.prepare_write	= unionfs_prepare_write,
 	.commit_write	= unionfs_commit_write,
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 8eb2ee4..6333488 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -45,6 +45,7 @@
 #include <linux/log2.h>
 #include <linux/poison.h>
 #include <linux/mman.h>
+#include <linux/backing-dev.h>
 
 #include <asm/system.h>
 
-- 
1.5.2.2

