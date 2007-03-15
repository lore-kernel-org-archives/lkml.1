Return-Path: <linux-kernel-owner+w=401wt.eu-S965052AbXCOEOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965052AbXCOEOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 00:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965060AbXCOEOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 00:14:30 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:26438 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965052AbXCOEO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 00:14:29 -0400
Date: Wed, 14 Mar 2007 21:13:29 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/5] fs: introduce new aops and infrastructure
Message-ID: <20070315041329.GB21942@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20070314112529.13798.35417.sendpatchset@linux.site> <20070314112540.13798.97719.sendpatchset@linux.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070314112540.13798.97719.sendpatchset@linux.site>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Wed, Mar 14, 2007 at 02:38:22PM +0100, Nick Piggin wrote:
> Introduce write_begin, write_end, and perform_write aops.
> 
> These are intended to replace prepare_write and commit_write with more
> flexible alternatives that are also able to avoid the buffered write
> deadlock problems efficiently (which prepare_write is unable to do).

> Index: linux-2.6/include/linux/fs.h
> ===================================================================
> --- linux-2.6.orig/include/linux/fs.h
> +++ linux-2.6/include/linux/fs.h
> @@ -449,6 +449,17 @@ struct address_space_operations {
>  	 */
>  	int (*prepare_write)(struct file *, struct page *, unsigned, unsigned);
>  	int (*commit_write)(struct file *, struct page *, unsigned, unsigned);
> +
> +	int (*write_begin)(struct file *, struct address_space *mapping,
> +				loff_t pos, unsigned len, int intr,
> +				struct page **pagep, void **fsdata);
> +	int (*write_end)(struct file *, struct address_space *mapping,
> +				loff_t pos, unsigned len, unsigned copied,
> +				struct page *page, void *fsdata);

Are we going to get rid of the file and intr arguments btw? I'm not sure
intr is useful, and mapping is probably enough to get whatever we inside
->write_begin / ->write_end.

Also, I noticed that you didn't export block_write_begin(),
simple_write_begin(), block_write_end() and simple_write_end() - I think we
want those for client modules.


Attached is a quick patch to hook up the existing ocfs2 write code. This has
been compile tested only for now - one of my test machines isn't
cooperating, so a runtime test will have to wait until tommorrow.

One interesting side effect is that we no longer pass AOP_TRUNCATE_PAGE up a
level. This gives callers less to deal with. And it means that ocfs2 doesn't
have to use the ocfs2_*_lock_with_page() cluster lock variants in
ocfs2_block_write_begin() because it can order cluster locks outside of the
page lock there.

My ocfs2 write rework will be a more serious user of these stuff, including
the fsdata backpointer. That code will also eliminate the entire
ocfs2_*_lock_with_page() cluster locking workarounds for write (they'll have
to remain for ->readpage()). I'm beginning work on cleaning those ocfs2
patches up and getting them plugged into this stuff. I hope to post them in
the next day or two.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com

ocfs2: Convert to new aops

Turn ocfs2_prepare_write() and ocfs2_commit_write() into ocfs2_write_begin()
and ocfs2_write_end().

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 93628b0..e7bcbbd 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -293,29 +293,30 @@ int ocfs2_prepare_write_nolock(struct in
 }
 
 /*
- * ocfs2_prepare_write() can be an outer-most ocfs2 call when it is called
- * from loopback.  It must be able to perform its own locking around
- * ocfs2_get_block().
+ * ocfs2_write_begin() can be an outer-most ocfs2 call when it is
+ * called from elsewhere in the kernel. It must be able to perform its
+ * own locking around ocfs2_get_block().
  */
-static int ocfs2_prepare_write(struct file *file, struct page *page,
-			       unsigned from, unsigned to)
+static int ocfs2_write_begin(struct file *file, struct address_space *mapping,
+			     loff_t pos, unsigned len, int intr,
+			     struct page **pagep, void **fsdata)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = mapping->host;
 	int ret;
 
-	mlog_entry("(0x%p, 0x%p, %u, %u)\n", file, page, from, to);
-
-	ret = ocfs2_meta_lock_with_page(inode, NULL, 0, page);
+	ret = ocfs2_meta_lock(inode, NULL, 0);
 	if (ret != 0) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	ret = ocfs2_prepare_write_nolock(inode, page, from, to);
+	down_read(&OCFS2_I(inode)->ip_alloc_sem);
+	ret = block_write_begin(file, mapping, pos, len, intr, pagep, fsdata,
+				ocfs2_get_block);
+	up_read(&OCFS2_I(inode)->ip_alloc_sem);
 
 	ocfs2_meta_unlock(inode, 0);
 out:
-	mlog_exit(ret);
 	return ret;
 }
 
@@ -388,16 +389,21 @@ out:
 	return handle;
 }
 
-static int ocfs2_commit_write(struct file *file, struct page *page,
-			      unsigned from, unsigned to)
+static int ocfs2_write_end(struct file *file, struct address_space *mapping,
+			   loff_t pos, unsigned len, unsigned copied,
+			   struct page *page, void *fsdata)
 {
 	int ret;
+	unsigned from, to;
 	struct buffer_head *di_bh = NULL;
 	struct inode *inode = page->mapping->host;
 	handle_t *handle = NULL;
 	struct ocfs2_dinode *di;
 
-	mlog_entry("(0x%p, 0x%p, %u, %u)\n", file, page, from, to);
+	mlog_entry("(0x%p, 0x%p)\n", file, page);
+
+	from = pos & (PAGE_CACHE_SIZE - 1);
+	to = from + len;
 
 	/* NOTE: ocfs2_file_aio_write has ensured that it's safe for
 	 * us to continue here without rechecking the I/O against
@@ -441,8 +447,10 @@ static int ocfs2_commit_write(struct fil
 	}
 
 	/* might update i_size */
-	ret = generic_commit_write(file, page, from, to);
-	if (ret < 0) {
+	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
+	if (copied < 0) {
+		ret = copied;
+		copied = 0;
 		mlog_errno(ret);
 		goto out_commit;
 	}
@@ -458,11 +466,10 @@ static int ocfs2_commit_write(struct fil
 	di->i_size = cpu_to_le64((u64)i_size_read(inode));
 
 	ret = ocfs2_journal_dirty(handle, di_bh);
-	if (ret < 0) {
+	if (ret < 0)
 		mlog_errno(ret);
-		goto out_commit;
-	}
 
+	ret = 0;
 out_commit:
 	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
 out_unlock_data:
@@ -470,11 +477,29 @@ out_unlock_data:
 out_unlock_meta:
 	ocfs2_meta_unlock(inode, 1);
 out:
+	if (ret && ret != AOP_TRUNCATED_PAGE) {
+		/*
+		 * We caught an error before block_write_end() -
+		 * unlock and free the page.
+		 */
+		unlock_page(page);
+		page_cache_release(page);
+	} else if (ret == AOP_TRUNCATED_PAGE) {
+		/*
+		 * The cluster locking code avoided a deadlock by
+		 * unlocking the page - simply release here and turn
+		 * the error into something negative for the caller to
+		 * key on.
+		 */
+		page_cache_release(page);
+		ret = -EAGAIN;
+	}
+
 	if (di_bh)
 		brelse(di_bh);
 
 	mlog_exit(ret);
-	return ret;
+	return copied ? copied : ret;
 }
 
 static sector_t ocfs2_bmap(struct address_space *mapping, sector_t block)
@@ -657,8 +682,8 @@ out:
 const struct address_space_operations ocfs2_aops = {
 	.readpage	= ocfs2_readpage,
 	.writepage	= ocfs2_writepage,
-	.prepare_write	= ocfs2_prepare_write,
-	.commit_write	= ocfs2_commit_write,
+	.write_begin	= ocfs2_write_begin,
+	.write_end	= ocfs2_write_end,
 	.bmap		= ocfs2_bmap,
 	.sync_page	= block_sync_page,
 	.direct_IO	= ocfs2_direct_IO
