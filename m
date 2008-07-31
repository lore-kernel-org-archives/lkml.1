Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbYGaMMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbYGaMMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 08:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbYGaMMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 08:12:44 -0400
Received: from ns.suse.de ([195.135.220.2]:37440 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbYGaMMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 08:12:43 -0400
Date: Thu, 31 Jul 2008 14:12:41 +0200
From: Nick Piggin <npiggin@suse.de>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Potential fix to filemap_fault()
Message-ID: <20080731121241.GA17228@wotan.suse.de>
References: <1217502265.3425.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217502265.3425.15.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 12:04:25PM +0100, Steven Whitehouse wrote:
> Hi,
> 
> We've spotted (with our cluster coherency tests) a couple of issues in
> the current page fault path. One of those is fixed by the below patch,
> so I'd like to know if anybody can spot any unwanted side effects if we
> make this change. The patch prevents us from seeing bus errors when
> accessing what should be valid data within a file. This can currently
> happen when there is a race between invalidation and the page fault
> path.
> 
> After applying this patch, we still see one remaining issue, which I
> think is related to page_mkwrite but we've not finally tracked that one
> down yet. The symptoms of the remaining issue are that we see a blank
> page from time to time, when we should be seeing valid data.
> 
> Steve.
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 42bbc69..9441759 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1563,7 +1563,7 @@ page_not_uptodate:
>  	error = mapping->a_ops->readpage(file, page);
>  	if (!error) {
>  		wait_on_page_locked(page);
> -		if (!PageUptodate(page))
> +		if (PageError(page))
>  			error = -EIO;
>  	}
>  	page_cache_release(page);
> 

Hi Steve,

Yeah this is part of larger problems in our vm/fs with page error handling.
This came up a month or two ago and prompted me to finally start writing
something for it...

I haven't actually spent a lot of time trying to exercise it yet, but if
its on your radar now, let's make a push to get it fixed.

---

- Don't clear PageUptodate on write failure (this can go BUG in the VM, and
  really, the data in the page is still the most uptodate even if we can't
  write it back to disk)
- Don't assume !PageUptodate == EIO, pages can be invalidated in which case
  the read should be retried.
- Haven't gone through filesystems yet, but this gets core code into better 
  shape.

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -1131,20 +1131,17 @@ readpage:
 
 		if (!PageUptodate(page)) {
 			if (lock_page_killable(page))
-				goto readpage_eio;
-			if (!PageUptodate(page)) {
-				if (page->mapping == NULL) {
-					/*
-					 * invalidate_inode_pages got it
-					 */
-					unlock_page(page);
-					page_cache_release(page);
-					goto find_page;
-				}
+				goto readpage_eio; /* EIO wont hit userspace */
+			if (PageError(page)) {
 				unlock_page(page);
 				shrink_readahead_size_eio(filp, ra);
 				goto readpage_eio;
 			}
+			if (!PageUptodate(page)) {
+				unlock_page(page);
+				page_cache_release(page);
+				goto find_page;
+			}
 			unlock_page(page);
 		}
 
@@ -1563,7 +1560,7 @@ page_not_uptodate:
 	error = mapping->a_ops->readpage(file, page);
 	if (!error) {
 		wait_on_page_locked(page);
-		if (!PageUptodate(page))
+		if (unlikely(PageError(page)))
 			error = -EIO;
 	}
 	page_cache_release(page);
@@ -1688,6 +1685,7 @@ retry:
 		unlock_page(page);
 		goto out;
 	}
+	ClearPageError(page);
 	err = filler(data, page);
 	if (err < 0) {
 		page_cache_release(page);
@@ -1709,7 +1707,7 @@ EXPORT_SYMBOL(read_cache_page_async);
  * Read into the page cache. If a page already exists, and PageUptodate() is
  * not set, try to fill the page then wait for it to become unlocked.
  *
- * If the page does not get brought uptodate, return -EIO.
+ * If the page IO fails, return -EIO.
  */
 struct page *read_cache_page(struct address_space *mapping,
 				pgoff_t index,
@@ -1722,7 +1720,7 @@ struct page *read_cache_page(struct addr
 	if (IS_ERR(page))
 		goto out;
 	wait_on_page_locked(page);
-	if (!PageUptodate(page)) {
+	if (PageError(page)) {
 		page_cache_release(page);
 		page = ERR_PTR(-EIO);
 	}
@@ -2039,6 +2037,9 @@ again:
 			 *
 			 * Instead, we have to bring it uptodate here.
 			 */
+			if (PageError(page))
+				return -EIO;
+
 			ret = aops->readpage(file, page);
 			page_cache_release(page);
 			if (ret) {
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c
+++ linux-2.6/mm/memory.c
@@ -2307,10 +2307,11 @@ static int do_swap_page(struct mm_struct
 	if (unlikely(!pte_same(*page_table, orig_pte)))
 		goto out_nomap;
 
-	if (unlikely(!PageUptodate(page))) {
+	if (unlikely(!PageError(page))) {
 		ret = VM_FAULT_SIGBUS;
 		goto out_nomap;
 	}
+	VM_BUG_ON(!PageUptodate(page)); /* page_io.c should guarantee this */
 
 	/* The page isn't present yet, go ahead with the fault. */
 
Index: linux-2.6/mm/shmem.c
===================================================================
--- linux-2.6.orig/mm/shmem.c
+++ linux-2.6/mm/shmem.c
@@ -1280,7 +1280,7 @@ repeat:
 			page_cache_release(swappage);
 			goto repeat;
 		}
-		if (!PageUptodate(swappage)) {
+		if (PageError(swappage)) {
 			shmem_swp_unmap(entry);
 			spin_unlock(&info->lock);
 			unlock_page(swappage);
@@ -1288,6 +1288,11 @@ repeat:
 			error = -EIO;
 			goto failed;
 		}
+		/*
+		 * swap cache doesn't get invalidated, so if not error it
+		 * should be uptodate
+		 */
+		VM_BUG_ON(!PageUptodate(swappage));
 
 		if (filepage) {
 			shmem_swp_set(info, entry, 0);
Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c
+++ linux-2.6/fs/buffer.c
@@ -1999,8 +1999,6 @@ int block_write_begin(struct file *file,
 
 	status = __block_prepare_write(inode, page, start, end, get_block);
 	if (unlikely(status)) {
-		ClearPageUptodate(page);
-
 		if (ownpage) {
 			unlock_page(page);
 			page_cache_release(page);
@@ -2373,10 +2371,7 @@ int block_prepare_write(struct page *pag
 			get_block_t *get_block)
 {
 	struct inode *inode = page->mapping->host;
-	int err = __block_prepare_write(inode, page, from, to, get_block);
-	if (err)
-		ClearPageUptodate(page);
-	return err;
+	return __block_prepare_write(inode, page, from, to, get_block);
 }
 
 int block_commit_write(struct page *page, unsigned from, unsigned to)
@@ -2753,16 +2748,19 @@ has_buffers:
 
 	/* Ok, it's mapped. Make sure it's up-to-date */
 	if (!PageUptodate(page)) {
+again:
 		err = mapping->a_ops->readpage(NULL, page);
 		if (err) {
 			page_cache_release(page);
 			goto out;
 		}
 		lock_page(page);
-		if (!PageUptodate(page)) {
+		if (!PageError(page)) {
 			err = -EIO;
 			goto unlock;
 		}
+		if (!PageUptodate(page))
+			goto again;
 		if (page_has_buffers(page))
 			goto has_buffers;
 	}
Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c
+++ linux-2.6/fs/splice.c
@@ -112,11 +112,16 @@ static int page_cache_pipe_buf_confirm(s
 		/*
 		 * Uh oh, read-error from disk.
 		 */
-		if (!PageUptodate(page)) {
+		if (PageError(page)) {
 			err = -EIO;
 			goto error;
 		}
 
+		if (!PageUptodate(page)) {
+			err = -ENODATA;
+			goto error;
+		}
+
 		/*
 		 * Page is ok afterall, we are done.
 		 */
Index: linux-2.6/fs/mpage.c
===================================================================
--- linux-2.6.orig/fs/mpage.c
+++ linux-2.6/fs/mpage.c
@@ -53,7 +53,11 @@ static void mpage_end_io_read(struct bio
 		if (uptodate) {
 			SetPageUptodate(page);
 		} else {
-			ClearPageUptodate(page);
+			if (PageUptodate(page)) {
+				/* let's get rid of this case ASAP */
+				WARN_ON(1);
+				ClearPageUptodate(page);
+			}
 			SetPageError(page);
 		}
 		unlock_page(page);
Index: linux-2.6/mm/page_io.c
===================================================================
--- linux-2.6.orig/mm/page_io.c
+++ linux-2.6/mm/page_io.c
@@ -77,7 +77,10 @@ void end_swap_bio_read(struct bio *bio, 
 
 	if (!uptodate) {
 		SetPageError(page);
-		ClearPageUptodate(page);
+		if (PageUptodate(page)) {
+			WARN_ON(1);
+			ClearPageUptodate(page);
+		}
 		printk(KERN_ALERT "Read-error on swap-device (%u:%u:%Lu)\n",
 				imajor(bio->bi_bdev->bd_inode),
 				iminor(bio->bi_bdev->bd_inode),
