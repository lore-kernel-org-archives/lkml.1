Return-Path: <linux-kernel-owner+w=401wt.eu-S1760874AbXJLQLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874AbXJLQLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759761AbXJLQGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:06:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760242AbXJLQG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:06:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 12/52] CRED: Make mpage read functions take a credentials
	pointer
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:06:20 +0100
Message-ID: <20071012160620.15119.12112.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make the mpage read functions take a credentials pointer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext3/inode.c       |    5 +++--
 fs/fat/inode.c        |    5 +++--
 fs/mpage.c            |   12 ++++++------
 include/linux/mpage.h |    5 +++--
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index a7ef05c..70e9e6f 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1582,14 +1582,15 @@ out_unlock:
 
 static int ext3_readpage(struct file *file, struct page *page)
 {
-	return mpage_readpage(page, ext3_get_block);
+	return mpage_readpage(page, ext3_get_block, file->f_cred);
 }
 
 static int
 ext3_readpages(struct file *file, struct address_space *mapping,
 		struct list_head *pages, unsigned nr_pages)
 {
-	return mpage_readpages(mapping, pages, nr_pages, ext3_get_block);
+	return mpage_readpages(mapping, pages, nr_pages, ext3_get_block,
+			       file->f_cred);
 }
 
 static void ext3_invalidatepage(struct page *page, unsigned long offset)
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 43c6f4a..2745ce2 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -133,13 +133,14 @@ static int fat_writepages(struct address_space *mapping,
 
 static int fat_readpage(struct file *file, struct page *page)
 {
-	return mpage_readpage(page, fat_get_block);
+	return mpage_readpage(page, fat_get_block, file->f_cred);
 }
 
 static int fat_readpages(struct file *file, struct address_space *mapping,
 			 struct list_head *pages, unsigned nr_pages)
 {
-	return mpage_readpages(mapping, pages, nr_pages, fat_get_block);
+	return mpage_readpages(mapping, pages, nr_pages, fat_get_block,
+			       file->f_cred);
 }
 
 static int fat_prepare_write(struct file *file, struct page *page,
diff --git a/fs/mpage.c b/fs/mpage.c
index 7fc2dce..af97410 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -167,9 +167,9 @@ map_buffer_to_page(struct page *page, struct buffer_head *bh, int page_block)
 static struct bio *
 do_mpage_readpage(struct bio *bio, struct page *page, unsigned nr_pages,
 		sector_t *last_block_in_bio, struct buffer_head *map_bh,
-		unsigned long *first_logical_block, get_block_t get_block)
+		unsigned long *first_logical_block, get_block_t get_block,
+		struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	struct inode *inode = page->mapping->host;
 	const unsigned blkbits = inode->i_blkbits;
 	const unsigned blocks_per_page = PAGE_CACHE_SIZE >> blkbits;
@@ -375,7 +375,7 @@ confused:
  */
 int
 mpage_readpages(struct address_space *mapping, struct list_head *pages,
-				unsigned nr_pages, get_block_t get_block)
+		unsigned nr_pages, get_block_t get_block, struct cred *cred)
 {
 	struct bio *bio = NULL;
 	unsigned page_idx;
@@ -397,7 +397,7 @@ mpage_readpages(struct address_space *mapping, struct list_head *pages,
 					nr_pages - page_idx,
 					&last_block_in_bio, &map_bh,
 					&first_logical_block,
-					get_block);
+					get_block, cred);
 			if (!pagevec_add(&lru_pvec, page))
 				__pagevec_lru_add(&lru_pvec);
 		} else {
@@ -415,7 +415,7 @@ EXPORT_SYMBOL(mpage_readpages);
 /*
  * This isn't called much at all
  */
-int mpage_readpage(struct page *page, get_block_t get_block)
+int mpage_readpage(struct page *page, get_block_t get_block, struct cred *cred)
 {
 	struct bio *bio = NULL;
 	sector_t last_block_in_bio = 0;
@@ -424,7 +424,7 @@ int mpage_readpage(struct page *page, get_block_t get_block)
 
 	clear_buffer_mapped(&map_bh);
 	bio = do_mpage_readpage(bio, page, 1, &last_block_in_bio,
-			&map_bh, &first_logical_block, get_block);
+			&map_bh, &first_logical_block, get_block, cred);
 	if (bio)
 		mpage_bio_submit(READ, bio);
 	return 0;
diff --git a/include/linux/mpage.h b/include/linux/mpage.h
index 068a0c9..5235842 100644
--- a/include/linux/mpage.h
+++ b/include/linux/mpage.h
@@ -14,8 +14,9 @@
 struct writeback_control;
 
 int mpage_readpages(struct address_space *mapping, struct list_head *pages,
-				unsigned nr_pages, get_block_t get_block);
-int mpage_readpage(struct page *page, get_block_t get_block);
+				unsigned nr_pages, get_block_t get_block,
+				struct cred *cred);
+int mpage_readpage(struct page *page, get_block_t get_block, struct cred *cred);
 int mpage_writepages(struct address_space *mapping,
 		struct writeback_control *wbc, get_block_t get_block);
 int mpage_writepage(struct page *page, get_block_t *get_block,

