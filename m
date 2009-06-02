Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbZFBWSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbZFBWSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbZFBWSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:18:15 -0400
Received: from smtp-out.google.com ([216.239.33.17]:55131 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbZFBWSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:18:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=gl+vfwtS04x/hUz4AOVu92dsM9muqzg6FOl7im+tSxC0niLYdTe0wQ1Wu1gJMBZDl
	8PM2NWM3wRA8HLls6EywA==
From: Mike Waychison <mikew@google.com>
Subject: [PATCH] Remove __invalidate_mapping_pages variant
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Tue, 02 Jun 2009 15:18:05 -0700
Message-ID: <20090602221804.16461.15918.stgit@crlf.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove __invalidate_mapping_pages atomic variant now that its sole caller can
sleep (fixed in eccb95cee4f0d56faa46ef22fb94dd4a3578d3eb).

This fixes softlockups that can occur while in the drop_caches path.

Signed-off-by: Mike Waychison <mikew@google.com>
---

 fs/drop_caches.c   |    2 +-
 include/linux/fs.h |    3 ---
 mm/truncate.c      |   39 ++++++++++++++++-----------------------
 3 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index b6a719a..a2edb79 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -24,7 +24,7 @@ static void drop_pagecache_sb(struct super_block *sb)
 			continue;
 		__iget(inode);
 		spin_unlock(&inode_lock);
-		__invalidate_mapping_pages(inode->i_mapping, 0, -1, true);
+		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 		iput(toput_inode);
 		toput_inode = inode;
 		spin_lock(&inode_lock);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3b534e5..131dc03 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2043,9 +2043,6 @@ extern int __invalidate_device(struct block_device *);
 extern int invalidate_partition(struct gendisk *, int);
 #endif
 extern int invalidate_inodes(struct super_block *);
-unsigned long __invalidate_mapping_pages(struct address_space *mapping,
-					pgoff_t start, pgoff_t end,
-					bool be_atomic);
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 					pgoff_t start, pgoff_t end);
 
diff --git a/mm/truncate.c b/mm/truncate.c
index 12e1579..ccc3ecf 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -267,8 +267,21 @@ void truncate_inode_pages(struct address_space *mapping, loff_t lstart)
 }
 EXPORT_SYMBOL(truncate_inode_pages);
 
-unsigned long __invalidate_mapping_pages(struct address_space *mapping,
-				pgoff_t start, pgoff_t end, bool be_atomic)
+/**
+ * invalidate_mapping_pages - Invalidate all the unlocked pages of one inode
+ * @mapping: the address_space which holds the pages to invalidate
+ * @start: the offset 'from' which to invalidate
+ * @end: the offset 'to' which to invalidate (inclusive)
+ *
+ * This function only removes the unlocked pages, if you want to
+ * remove all the pages of one inode, you must call truncate_inode_pages.
+ *
+ * invalidate_mapping_pages() will not block on IO activity. It will not
+ * invalidate pages which are dirty, locked, under writeback or mapped into
+ * pagetables.
+ */
+unsigned long invalidate_mapping_pages(struct address_space *mapping,
+				       pgoff_t start, pgoff_t end)
 {
 	struct pagevec pvec;
 	pgoff_t next = start;
@@ -309,30 +322,10 @@ unlock:
 				break;
 		}
 		pagevec_release(&pvec);
-		if (likely(!be_atomic))
-			cond_resched();
+		cond_resched();
 	}
 	return ret;
 }
-
-/**
- * invalidate_mapping_pages - Invalidate all the unlocked pages of one inode
- * @mapping: the address_space which holds the pages to invalidate
- * @start: the offset 'from' which to invalidate
- * @end: the offset 'to' which to invalidate (inclusive)
- *
- * This function only removes the unlocked pages, if you want to
- * remove all the pages of one inode, you must call truncate_inode_pages.
- *
- * invalidate_mapping_pages() will not block on IO activity. It will not
- * invalidate pages which are dirty, locked, under writeback or mapped into
- * pagetables.
- */
-unsigned long invalidate_mapping_pages(struct address_space *mapping,
-				pgoff_t start, pgoff_t end)
-{
-	return __invalidate_mapping_pages(mapping, start, end, false);
-}
 EXPORT_SYMBOL(invalidate_mapping_pages);
 
 /*

