Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbZAHIEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbZAHIEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 03:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbZAHIEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 03:04:09 -0500
Received: from sh.osrg.net ([192.16.179.4]:35520 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbZAHIEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 03:04:08 -0500
Date: Thu, 08 Jan 2009 16:59:55 +0900 (JST)
Message-Id: <20090108.165955.59302626.ryusuke@osrg.net>
To: chris.mason@oracle.com, akpm@linux-foundation.org
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm] nilfs2: insert checks and hole block allocation
 in page_mkwrite
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <1231350442.27813.36.camel@think.oraclecorp.com>
References: <1231339382.27813.10.camel@think.oraclecorp.com>
	<20090108.023345.105818287.ryusuke@osrg.net>
	<1231350442.27813.36.camel@think.oraclecorp.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Jan 2009 12:47:22 -0500, Chris Mason wrote:
> On Thu, 2009-01-08 at 02:33 +0900, Ryusuke Konishi wrote:
> > On Wed, 07 Jan 2009 09:43:02 -0500, Chris Mason wrote:
> > > On Wed, 2009-01-07 at 22:06 +0900, Ryusuke Konishi wrote:
> > > > Chris Mason told me that page_mkwrite() has some works to do.
> > > > 
> > > > On Wed, 17 Dec 2008 21:52:55 -0500, Chris Mason wrote:
> > > > > nilfs_page_mkwrite doesn't seem to dirty the page?  block_page_mkwrite
> > > > > does more, including checks against i_size and others.
> > > > 
> > > > This will insert i_size check, and hole block allocation code in the
> > > > nilfs_page_mkwrite.
> > > > 
> > > > Previously, the hole block allocation was delayed until just before
> > > > writing for mmapped pages.  This accompanies removal of the delayed
> > > > allocation code.
> > <snip>
> > > > +	/*
> > > > +	 * use i_alloc_sem to stop truncate operations on the inode
> > > > +	 */
> > > > +	down_read(&inode->i_alloc_sem);
> > > 
> > > I'm not 100% sure this is safe.  It seems likely the direct io paths
> > > could trigger a mkwrite with the i_alloc_sem already held?
> > 
> > vmtruncate() can change i_size outside the page lock, and it even
> > calls unmap_mapping_range(). Does it have any problems?
> 
> You're right, i_size can change without you knowing about it, but before
> vmtruncate does anything to the page itself, it locks the page.
> 
> So, we tend to do a somewhat racey check against i_size.  If the page is
> outside i_size, we happily ignore it.  If it is inside i_size, we assume
> it is part of the file.  Most of the code that does this checks i_size
> once after locking the page and saves that value, so if i_size changes
> later on the code at least does consistent operations based on a single
> value of i_size.
> 
> If the page straddles i_size and someone extends the file, they are
> expected to lock the page as well (see block_truncate_page and the
> places it gets called).
> 
> -chris

I got it, using page locking seems OK even for vmtruncate().

I don't know if the mkwrite is actually called from the direct io
path, but no doubt about i_alloc_sem is used in it.  To make this
safer and avoid confusion, I took your advice.

The revised patch is attached below.

Ryusuke
--
nilfs2: insert checks and hole block allocation in page_mkwrite (rev 2)

Chris Mason told me that page_mkwrite() has some works to do.

On Wed, 17 Dec 2008 21:52:55 -0500, Chris Mason wrote:
> nilfs_page_mkwrite doesn't seem to dirty the page?  block_page_mkwrite
> does more, including checks against i_size and others.

This will insert i_size check, a disk capacity check, and hole block
allocation code in the nilfs_page_mkwrite.

Previously, the hole block allocation was delayed until just before
writing for mmapped pages.  This accompanies removal of the delayed
allocation code.

This revision uses a page lock instead of i_alloc_sem for safety.

Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/file.c    |   58 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/nilfs2/segment.c |   44 ++++----------------------------------
 2 files changed, 61 insertions(+), 41 deletions(-)

diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 7ddd42e..c22f97c 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -75,8 +75,62 @@ nilfs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 
 static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 {
-	if (!(vma->vm_flags & (VM_WRITE | VM_MAYWRITE)))
-		return -EPERM;
+	struct inode *inode = vma->vm_file->f_dentry->d_inode;
+	struct nilfs_transaction_info ti;
+	int ret;
+
+	if (unlikely(nilfs_near_disk_full(NILFS_SB(inode->i_sb)->s_nilfs)))
+		return -ENOSPC;
+
+	lock_page(page);
+	if (page->mapping != inode->i_mapping ||
+	    page_offset(page) >= i_size_read(inode) || !PageUptodate(page)) {
+		unlock_page(page);
+		return -EINVAL;
+	}
+
+	/*
+	 * check to see if the page is mapped already (no holes)
+	 */
+	if (PageMappedToDisk(page)) {
+		unlock_page(page);
+		goto mapped;
+	}
+	if (page_has_buffers(page)) {
+		struct buffer_head *bh, *head;
+		int fully_mapped = 1;
+
+		bh = head = page_buffers(page);
+		do {
+			if (!buffer_mapped(bh)) {
+				fully_mapped = 0;
+				break;
+			}
+		} while (bh = bh->b_this_page, bh != head);
+
+		if (fully_mapped) {
+			SetPageMappedToDisk(page);
+			unlock_page(page);
+			goto mapped;
+		}
+	}
+	unlock_page(page);
+
+	/*
+	 * fill hole blocks
+	 */
+	ret = nilfs_transaction_begin(inode->i_sb, &ti, 1);
+	if (unlikely(ret))
+		return ret;
+
+	ret = block_page_mkwrite(vma, page, nilfs_get_block);
+	if (unlikely(ret)) {
+		nilfs_transaction_abort(inode->i_sb);
+		return ret;
+	}
+	nilfs_transaction_commit(inode->i_sb);
+
+ mapped:
 	SetPageChecked(page);
 	wait_on_page_writeback(page);
 	return 0;
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 182fb26..b4b96ac 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -667,42 +667,6 @@ struct nilfs_sc_operations nilfs_sc_dsync_ops = {
 	.write_node_binfo = NULL,
 };
 
-static int nilfs_prepare_data_page(struct inode *inode, struct page *page)
-{
-	int err = 0;
-
-	lock_page(page);
-	if (!page_has_buffers(page))
-		create_empty_buffers(page, 1 << inode->i_blkbits, 0);
-
-	if (!PageMappedToDisk(page)) {
-		struct buffer_head *bh, *head;
-		sector_t blkoff
-			= page->index << (PAGE_SHIFT - inode->i_blkbits);
-
-		int non_mapped = 0;
-
-		bh = head = page_buffers(page);
-		do {
-			if (!buffer_mapped(bh)) {
-				if (!buffer_dirty(bh)) {
-					non_mapped++;
-					continue;
-				}
-				err = nilfs_get_block(inode, blkoff, bh, 1);
-				if (unlikely(err))
-					goto out_unlock;
-			}
-		} while (blkoff++, (bh = bh->b_this_page) != head);
-		if (!non_mapped)
-			SetPageMappedToDisk(page);
-	}
-
- out_unlock:
-	unlock_page(page);
-	return err;
-}
-
 static int nilfs_lookup_dirty_data_buffers(struct inode *inode,
 					   struct list_head *listp,
 					   struct nilfs_sc_info *sci)
@@ -727,9 +691,11 @@ static int nilfs_lookup_dirty_data_buffers(struct inode *inode,
 		struct page *page = pvec.pages[i];
 
 		if (mapping->host) {
-			err = nilfs_prepare_data_page(inode, page);
-			if (unlikely(err))
-				break;
+			lock_page(page);
+			if (!page_has_buffers(page))
+				create_empty_buffers(page,
+						     1 << inode->i_blkbits, 0);
+			unlock_page(page);
 		}
 
 		bh = head = page_buffers(page);
-- 
1.5.6.5

