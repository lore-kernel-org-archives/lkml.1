Return-Path: <linux-kernel-owner+w=401wt.eu-S1760938AbXJLQMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760938AbXJLQMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932420AbXJLQGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:06:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759042AbXJLQGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:06:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 13/52] CRED: Make block_prepare_write() and co take a
	credentials pointer
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:06:25 +0100
Message-ID: <20071012160625.15119.6170.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make block_prepare_write() and co take a credentials pointer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/block_dev.c              |    2 +-
 fs/buffer.c                 |   23 +++++++++++++----------
 fs/ext3/inode.c             |    8 +++++---
 fs/fat/inode.c              |    3 ++-
 include/linux/buffer_head.h |    8 +++++---
 5 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 1a51716..ef70bba 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -382,7 +382,7 @@ static int blkdev_readpage(struct file * file, struct page * page)
 
 static int blkdev_prepare_write(struct file *file, struct page *page, unsigned from, unsigned to)
 {
-	return block_prepare_write(page, from, to, blkdev_get_block);
+	return block_prepare_write(page, from, to, blkdev_get_block, file->f_cred);
 }
 
 static int blkdev_commit_write(struct file *file, struct page *page, unsigned from, unsigned to)
diff --git a/fs/buffer.c b/fs/buffer.c
index c5b2ebc..bb6ab45 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1759,9 +1759,9 @@ recover:
 }
 
 static int __block_prepare_write(struct inode *inode, struct page *page,
-		unsigned from, unsigned to, get_block_t *get_block)
+		unsigned from, unsigned to, get_block_t *get_block,
+		struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	unsigned block_start, block_end;
 	sector_t block;
 	int err = 0;
@@ -2089,7 +2089,8 @@ int generic_cont_expand_simple(struct inode *inode, loff_t size)
  */
 
 int cont_prepare_write(struct page *page, unsigned offset,
-		unsigned to, get_block_t *get_block, loff_t *bytes)
+		unsigned to, get_block_t *get_block, loff_t *bytes,
+		struct cred *cred)
 {
 	struct address_space *mapping = page->mapping;
 	struct inode *inode = mapping->host;
@@ -2116,7 +2117,8 @@ int cont_prepare_write(struct page *page, unsigned offset,
 			(*bytes)++;
 		}
 		status = __block_prepare_write(inode, new_page, zerofrom,
-						PAGE_CACHE_SIZE, get_block);
+						PAGE_CACHE_SIZE, get_block,
+						cred);
 		if (status)
 			goto out_unmap;
 		zero_user_page(new_page, zerofrom, PAGE_CACHE_SIZE - zerofrom,
@@ -2143,7 +2145,8 @@ int cont_prepare_write(struct page *page, unsigned offset,
 		if (offset <= zerofrom)
 			zerofrom = offset;
 	}
-	status = __block_prepare_write(inode, page, zerofrom, to, get_block);
+	status = __block_prepare_write(inode, page, zerofrom, to, get_block,
+				       cred);
 	if (status)
 		goto out1;
 	if (zerofrom < offset) {
@@ -2164,10 +2167,10 @@ out:
 }
 
 int block_prepare_write(struct page *page, unsigned from, unsigned to,
-			get_block_t *get_block)
+			get_block_t *get_block, struct cred *cred)
 {
 	struct inode *inode = page->mapping->host;
-	int err = __block_prepare_write(inode, page, from, to, get_block);
+	int err = __block_prepare_write(inode, page, from, to, get_block, cred);
 	if (err)
 		ClearPageUptodate(page);
 	return err;
@@ -2217,6 +2220,7 @@ block_page_mkwrite(struct vm_area_struct *vma, struct page *page,
 		   get_block_t get_block)
 {
 	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
+	struct cred *cred = vma->vm_file->f_cred;
 	unsigned long end;
 	loff_t size;
 	int ret = -EINVAL;
@@ -2235,7 +2239,7 @@ block_page_mkwrite(struct vm_area_struct *vma, struct page *page,
 	else
 		end = PAGE_CACHE_SIZE;
 
-	ret = block_prepare_write(page, 0, end, get_block);
+	ret = block_prepare_write(page, 0, end, get_block, cred);
 	if (!ret)
 		ret = block_commit_write(page, 0, end);
 
@@ -2270,9 +2274,8 @@ static void end_buffer_read_nobh(struct buffer_head *bh, int uptodate)
  * On exit the page is fully uptodate in the areas outside (from,to)
  */
 int nobh_prepare_write(struct page *page, unsigned from, unsigned to,
-			get_block_t *get_block)
+			get_block_t *get_block, struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	struct inode *inode = page->mapping->host;
 	const unsigned blkbits = inode->i_blkbits;
 	const unsigned blocksize = 1 << blkbits;
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 70e9e6f..d7e1390 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1158,6 +1158,7 @@ static int ext3_prepare_write(struct file *file, struct page *page,
 			      unsigned from, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
+	struct cred *cred = file->f_cred;
 	int ret, needed_blocks = ext3_writepage_trans_blocks(inode);
 	handle_t *handle;
 	int retries = 0;
@@ -1169,9 +1170,9 @@ retry:
 		goto out;
 	}
 	if (test_opt(inode->i_sb, NOBH) && ext3_should_writeback_data(inode))
-		ret = nobh_prepare_write(page, from, to, ext3_get_block);
+		ret = nobh_prepare_write(page, from, to, ext3_get_block, cred);
 	else
-		ret = block_prepare_write(page, from, to, ext3_get_block);
+		ret = block_prepare_write(page, from, to, ext3_get_block, cred);
 	if (ret)
 		goto prepare_write_failed;
 
@@ -1525,6 +1526,7 @@ static int ext3_journalled_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
 	struct inode *inode = page->mapping->host;
+	struct cred *cred = current->cred;
 	handle_t *handle = NULL;
 	int ret = 0;
 	int err;
@@ -1545,7 +1547,7 @@ static int ext3_journalled_writepage(struct page *page,
 		 */
 		ClearPageChecked(page);
 		ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
-					ext3_get_block);
+					ext3_get_block, cred);
 		if (ret != 0) {
 			ext3_journal_stop(handle);
 			goto out_unlock;
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 2745ce2..955ccaf 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -147,7 +147,8 @@ static int fat_prepare_write(struct file *file, struct page *page,
 			     unsigned from, unsigned to)
 {
 	return cont_prepare_write(page, from, to, fat_get_block,
-				  &MSDOS_I(page->mapping->host)->mmu_private);
+				  &MSDOS_I(page->mapping->host)->mmu_private,
+				  file->f_cred);
 }
 
 static int fat_commit_write(struct file *file, struct page *page,
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 35cadad..fe059f8 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -203,9 +203,10 @@ void block_invalidatepage(struct page *page, unsigned long offset);
 int block_write_full_page(struct page *page, get_block_t *get_block,
 				struct writeback_control *wbc);
 int block_read_full_page(struct page*, get_block_t*);
-int block_prepare_write(struct page*, unsigned, unsigned, get_block_t*);
+int block_prepare_write(struct page*, unsigned, unsigned, get_block_t*,
+			struct cred *);
 int cont_prepare_write(struct page*, unsigned, unsigned, get_block_t*,
-				loff_t *);
+				loff_t *, struct cred *);
 int generic_cont_expand(struct inode *inode, loff_t size);
 int generic_cont_expand_simple(struct inode *inode, loff_t size);
 int block_commit_write(struct page *page, unsigned from, unsigned to);
@@ -216,7 +217,8 @@ sector_t generic_block_bmap(struct address_space *, sector_t, get_block_t *);
 int generic_commit_write(struct file *, struct page *, unsigned, unsigned);
 int block_truncate_page(struct address_space *, loff_t, get_block_t *);
 int file_fsync(struct file *, struct dentry *, int);
-int nobh_prepare_write(struct page*, unsigned, unsigned, get_block_t*);
+int nobh_prepare_write(struct page*, unsigned, unsigned, get_block_t*,
+		       struct cred *);
 int nobh_commit_write(struct file *, struct page *, unsigned, unsigned);
 int nobh_truncate_page(struct address_space *, loff_t);
 int nobh_writepage(struct page *page, get_block_t *get_block,

