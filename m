Return-Path: <linux-kernel-owner+w=401wt.eu-S1752602AbZIBOBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbZIBOBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 10:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbZIBN7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 09:59:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41760 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbZIBN71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 09:59:27 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, hch@lst.de, Jan Kara <jack@suse.cz>
Subject: [PATCH 01/16] vfs: Introduce filemap_fdatawait_range
Date: Wed,  2 Sep 2009 15:59:11 +0200
Message-Id: <1251899966-7316-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1251899966-7316-1-git-send-email-jack@suse.cz>
References: <1251899966-7316-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simple helper saves some filesystems conversion from byte offset
to page numbers and also makes the fdata* interface more complete.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/fs.h |    2 ++
 mm/filemap.c       |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 73e9b64..dde471a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2076,6 +2076,8 @@ extern int write_inode_now(struct inode *, int);
 extern int filemap_fdatawrite(struct address_space *);
 extern int filemap_flush(struct address_space *);
 extern int filemap_fdatawait(struct address_space *);
+extern int filemap_fdatawait_range(struct address_space *, loff_t lstart,
+				   loff_t lend);
 extern int filemap_write_and_wait(struct address_space *mapping);
 extern int filemap_write_and_wait_range(struct address_space *mapping,
 				        loff_t lstart, loff_t lend);
diff --git a/mm/filemap.c b/mm/filemap.c
index ccea3b6..65b2e50 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -307,6 +307,26 @@ int wait_on_page_writeback_range(struct address_space *mapping,
 }
 
 /**
+ * filemap_fdatawait_range - wait for all under-writeback pages to complete in a given range
+ * @mapping: address space structure to wait for
+ * @start:	offset in bytes where the range starts
+ * @end:	offset in bytes where the range ends (inclusive)
+ *
+ * Walk the list of under-writeback pages of the given address space
+ * in the given range and wait for all of them.
+ *
+ * This is just a simple wrapper so that callers don't have to convert offsets
+ * to page indexes themselves
+ */
+int filemap_fdatawait_range(struct address_space *mapping, loff_t start,
+			    loff_t end)
+{
+	return wait_on_page_writeback_range(mapping, start >> PAGE_CACHE_SHIFT,
+					    end >> PAGE_CACHE_SHIFT);
+}
+EXPORT_SYMBOL(filemap_fdatawait_range);
+
+/**
  * sync_page_range - write and wait on all pages in the passed range
  * @inode:	target inode
  * @mapping:	target address_space
-- 
1.6.0.2

