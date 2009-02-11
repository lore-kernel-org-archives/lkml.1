Return-Path: <linux-kernel-owner+w=401wt.eu-S1758574AbZBKWqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574AbZBKWqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 17:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbZBKWqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 17:46:21 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:29026 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbZBKWqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 17:46:20 -0500
X-IronPort-AV: E=Sophos;i="4.38,194,1233532800"; 
   d="scan'208";a="247717144"
Date: Wed, 11 Feb 2009 14:46:14 -0800
From: VomLehn <dvomlehn@cisco.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Propagate CRAMFS uncompression errors, v2.1
Message-ID: <20090211224614.GD18872@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-1; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Decompression errors can arise due to corruption of compressed blocks
on flash or in memory. This patch propagates errors detected during
decompression back to the block layer.

Version v2.1:
Now checkpatch clean.

Version v2:
This version revised based on suggestions from Andrew Morton.

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---
 fs/cramfs/inode.c      |   36 ++++++++++++++++++++++++++----------
 fs/cramfs/uncompress.c |    2 +-
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index f40423e..95f42dd 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -461,11 +461,14 @@ static struct dentry * cramfs_lookup(struct inode *dir, struct dentry *dentry, s
 static int cramfs_readpage(struct file *file, struct page * page)
 {
 	struct inode *inode = page->mapping->host;
-	u32 maxblock, bytes_filled;
+	u32 maxblock;
+	int bytes_filled;
 	void *pgdata;
 
 	maxblock = (inode->i_size + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	bytes_filled = 0;
+	pgdata = kmap(page);
+
 	if (page->index < maxblock) {
 		struct super_block *sb = inode->i_sb;
 		u32 blkptr_offset = OFFSET(inode) + page->index*4;
@@ -474,30 +477,43 @@ static int cramfs_readpage(struct file *file, struct page * page)
 		start_offset = OFFSET(inode) + maxblock*4;
 		mutex_lock(&read_mutex);
 		if (page->index)
-			start_offset = *(u32 *) cramfs_read(sb, blkptr_offset-4, 4);
-		compr_len = (*(u32 *) cramfs_read(sb, blkptr_offset, 4) - start_offset);
+			start_offset = *(u32 *) cramfs_read(sb, blkptr_offset-4,
+				4);
+		compr_len = (*(u32 *) cramfs_read(sb, blkptr_offset, 4) -
+			start_offset);
 		mutex_unlock(&read_mutex);
-		pgdata = kmap(page);
+
 		if (compr_len == 0)
 			; /* hole */
-		else if (compr_len > (PAGE_CACHE_SIZE << 1))
-			printk(KERN_ERR "cramfs: bad compressed blocksize %u\n", compr_len);
-		else {
+		else if (unlikely(compr_len > (PAGE_CACHE_SIZE << 1))) {
+			pr_err("cramfs: bad compressed blocksize %u\n",
+				compr_len);
+			goto err;
+		} else {
 			mutex_lock(&read_mutex);
 			bytes_filled = cramfs_uncompress_block(pgdata,
 				 PAGE_CACHE_SIZE,
 				 cramfs_read(sb, start_offset, compr_len),
 				 compr_len);
 			mutex_unlock(&read_mutex);
+			if (unlikely(bytes_filled < 0))
+				goto err;
 		}
-	} else
-		pgdata = kmap(page);
+	}
+
 	memset(pgdata + bytes_filled, 0, PAGE_CACHE_SIZE - bytes_filled);
-	kunmap(page);
 	flush_dcache_page(page);
+	kunmap(page);
 	SetPageUptodate(page);
 	unlock_page(page);
 	return 0;
+
+err:
+	kunmap(page);
+	ClearPageUptodate(page);
+	SetPageError(page);
+	unlock_page(page);
+	return 0;
 }
 
 static const struct address_space_operations cramfs_aops = {
diff --git a/fs/cramfs/uncompress.c b/fs/cramfs/uncompress.c
index fc3ccb7..0233298 100644
--- a/fs/cramfs/uncompress.c
+++ b/fs/cramfs/uncompress.c
@@ -50,7 +50,7 @@ int cramfs_uncompress_block(void *dst, int dstlen, void *src, int srclen)
 err:
 	printk("Error %d while decompressing!\n", err);
 	printk("%p(%d)->%p(%d)\n", src, srclen, dst, dstlen);
-	return 0;
+	return -EIO;
 }
 
 int cramfs_uncompress_init(void)
