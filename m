Return-Path: <linux-kernel-owner+w=401wt.eu-S934881AbXLPMJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934881AbXLPMJJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 07:09:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934040AbXLPMEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 07:04:38 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:60593 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S933964AbXLPME1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 07:04:27 -0500
Message-ID: <397806668.60816@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071216120417.748714367@mail.ustc.edu.cn>
References: <20071216115927.986126305@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sun, 16 Dec 2007 19:59:30 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] readahead: clean up and simplify the code for filemap page fault readahead
Content-Disposition: inline; filename=readahead-standalone-mmap-readaround.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

This shouldn't really change behavior all that much, but the single
rather complex function with read-ahead inside a loop etc is broken up
into more manageable pieces.

The behaviour is also less subtle, with the read-ahead being done up-front 
rather than inside some subtle loop and thus avoiding the now unnecessary 
extra state variables (ie "did_readaround" is gone).

Cc: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---

Ok, so this is something I did in Mexico when I wasn't scuba-diving, and 
was "watching" the kids at the pool. It was brought on by looking at git 
mmap file behaviour under cold-cache behaviour: git does ok, but my laptop 
disk is really slow, and I tried to verify that the kernel did a 
reasonable job of read-ahead when taking page faults.

I think it did, but quite frankly, the filemap_fault() code was totally 
unreadable. So this separates out the read-ahead cases, and adds more 
comments, and also changes it so that we do asynchronous read-ahead 
*before* we actually wait for the page we are waiting for to become 
unlocked.

Not that it seems to make any real difference on my laptop, but I really 
hated how it was doing a

	page = get_lock_page(..)

and then doing read-ahead after that: which just guarantees that we have 
to wait for any out-standing IO on "page" to complete before we can even 
submit any new read-ahead! That just seems totally broken!

So it replaces the "get_lock_page()" at the top with a broken-out page 
cache lookup, which allows us to look at the page state flags and make 
appropriate decisions on what we should do without waiting for the locked 
bit to clear.

It does add many more lines than it removes:

	 mm/filemap.c |  192 +++++++++++++++++++++++++++++++++++++++-------------------
	 1 files changed, 130 insertions(+), 62 deletions(-)

but that's largely due to (a) the new function headers etc due to the 
split-up and (b) new or extended comments especially about the helper 
functions. The code, in many ways, is actually simpler, apart from the 
fairly trivial expansion of the equivalent of "get_lock_page()" into the 
function.

Comments? I tried to avoid changing the read-ahead logic itself, although 
the old code did some strange things like doing *both* async readahead and 
then looking up the page and doing sync readahead (which I think was just 
due to the code being so damn messily organized, not on purpose).

			Linus

---
 mm/filemap.c |  190 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 128 insertions(+), 62 deletions(-)

--- linux-2.6.24-rc4-mm1.orig/mm/filemap.c
+++ linux-2.6.24-rc4-mm1/mm/filemap.c
@@ -1302,6 +1302,86 @@ static int fastcall page_cache_read(stru
 
 #define MMAP_LOTSAMISS  (100)
 
+/*
+ * Synchronous readahead happens when we don't even find
+ * a page in the page cache at all.
+ */
+static void do_sync_mmap_readahead(struct vm_area_struct *vma,
+				   struct file_ra_state *ra,
+				   struct file *file,
+				   pgoff_t offset)
+{
+	unsigned long ra_pages;
+	struct address_space *mapping = file->f_mapping;
+
+	/* If we don't want any read-ahead, don't bother */
+	if (VM_RandomReadHint(vma))
+		return;
+
+	if (VM_SequentialReadHint(vma)) {
+		page_cache_sync_readahead(mapping, ra, file, offset, 1);
+		return;
+	}
+
+	ra->mmap_miss++;
+
+	/*
+	 * Do we miss much more than hit in this file? If so,
+	 * stop bothering with read-ahead. It will only hurt.
+	 */
+	if (ra->mmap_miss > MMAP_LOTSAMISS)
+		return;
+
+	ra_pages = max_sane_readahead(file->f_ra.ra_pages);
+	if (ra_pages) {
+		pgoff_t start = 0;
+
+		if (offset > ra_pages / 2)
+			start = offset - ra_pages / 2;
+		do_page_cache_readahead(mapping, file, start, ra_pages);
+	}
+}
+
+/*
+ * Asynchronous readahead happens when we find the page,
+ * but it is busy being read, so we want to possibly
+ * extend the readahead further..
+ */
+static void do_async_mmap_readahead(struct vm_area_struct *vma,
+				    struct file_ra_state *ra,
+				    struct file *file,
+				    struct page *page,
+				    pgoff_t offset)
+{
+	struct address_space *mapping = file->f_mapping;
+
+	/* If we don't want any read-ahead, don't bother */
+	if (VM_RandomReadHint(vma))
+		return;
+	if (ra->mmap_miss > 0)
+		ra->mmap_miss--;
+	if (PageReadahead(page))
+		page_cache_async_readahead(mapping, ra, file, page, offset, 1);
+}
+
+/*
+ * A successful mmap hit is when we didn't need any IO at all,
+ * and got an immediate lock on an up-to-date page. There's not
+ * much to do, except decide on whether we want to trigger read-
+ * ahead.
+ *
+ * We currently do the same thing as we did for a locked page
+ * that we're waiting for.
+ */
+static void do_mmap_hit(struct vm_area_struct *vma,
+			struct file_ra_state *ra,
+			struct file *file,
+			struct page *page,
+			pgoff_t offset)
+{
+	do_async_mmap_readahead(vma, ra, file, page, offset);
+}
+
 /**
  * filemap_fault - read in file data for page fault handling
  * @vma:	vma in which the fault was taken
@@ -1321,78 +1401,69 @@ int filemap_fault(struct vm_area_struct 
 	struct address_space *mapping = file->f_mapping;
 	struct file_ra_state *ra = &file->f_ra;
 	struct inode *inode = mapping->host;
+	pgoff_t offset = vmf->pgoff;
 	struct page *page;
 	unsigned long size;
-	int did_readaround = 0;
 	int ret = 0;
 
 	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	if (vmf->pgoff >= size)
 		return VM_FAULT_SIGBUS;
 
-	/* If we don't want any read-ahead, don't bother */
-	if (VM_RandomReadHint(vma))
-		goto no_cached_page;
-
 	/*
-	 * Do we have something in the page cache already?
+	 * Do we have something in the page cache already that
+	 * is unlocked and already up-to-date?
 	 */
-retry_find:
-	page = find_lock_page(mapping, vmf->pgoff);
-	/*
-	 * For sequential accesses, we use the generic readahead logic.
-	 */
-	if (VM_SequentialReadHint(vma)) {
-		if (!page) {
-			page_cache_sync_readahead(mapping, ra, file,
-							   vmf->pgoff, 1);
-			page = find_lock_page(mapping, vmf->pgoff);
-			if (!page)
-				goto no_cached_page;
-		}
-		if (PageReadahead(page)) {
-			page_cache_async_readahead(mapping, ra, file, page,
-							   vmf->pgoff, 1);
-		}
-	}
+	read_lock_irq(&mapping->tree_lock);
+	page = radix_tree_lookup(&mapping->page_tree, offset);
+	if (likely(page)) {
+		int got_lock, uptodate;
+		page_cache_get(page);
+
+		got_lock = !TestSetPageLocked(page);
+		uptodate = PageUptodate(page);
+		read_unlock_irq(&mapping->tree_lock);
 
-	if (!page) {
-		unsigned long ra_pages;
+		if (likely(got_lock)) {
+			/*
+			 * Previous IO error? No read-ahead, but try to
+			 * re-do a single read.
+			 */
+			if (unlikely(!uptodate))
+				goto page_not_uptodate;
 
-		ra->mmap_miss++;
+			do_mmap_hit(vma, ra, file, page, offset);
+			goto found_it;
+		}
 
 		/*
-		 * Do we miss much more than hit in this file? If so,
-		 * stop bothering with read-ahead. It will only hurt.
+		 * We found the page, but it was locked..
+		 *
+		 * So do async readahead and wait for it to
+		 * unlock.
 		 */
-		if (ra->mmap_miss > MMAP_LOTSAMISS)
-			goto no_cached_page;
+		do_async_mmap_readahead(vma, ra, file, page, offset);
+		lock_page(page);
 
-		/*
-		 * To keep the pgmajfault counter straight, we need to
-		 * check did_readaround, as this is an inner loop.
-		 */
-		if (!did_readaround) {
-			ret = VM_FAULT_MAJOR;
-			count_vm_event(PGMAJFAULT);
-		}
-		did_readaround = 1;
-		ra_pages = max_sane_readahead(file->f_ra.ra_pages);
-		if (ra_pages) {
-			pgoff_t start = 0;
-
-			if (vmf->pgoff > ra_pages / 2)
-				start = vmf->pgoff - ra_pages / 2;
-			do_page_cache_readahead(mapping, file, start, ra_pages);
+		/* Did it get truncated? */
+		if (unlikely(page->mapping != mapping)) {
+			unlock_page(page);
+			put_page(page);
+			goto no_cached_page;
 		}
-		page = find_lock_page(mapping, vmf->pgoff);
+	} else {
+		read_unlock_irq(&mapping->tree_lock);
+
+		/* No page in the page cache at all */
+		do_sync_mmap_readahead(vma, ra, file, offset);
+		ret = VM_FAULT_MAJOR;
+		count_vm_event(PGMAJFAULT);
+retry_find:
+		page = find_lock_page(mapping, offset);
 		if (!page)
 			goto no_cached_page;
 	}
 
-	if (!did_readaround)
-		ra->mmap_miss--;
-
 	/*
 	 * We have a locked page in the page cache, now we need to check
 	 * that it's up-to-date. If not, it is going to be due to an error.
@@ -1400,7 +1471,11 @@ retry_find:
 	if (unlikely(!PageUptodate(page)))
 		goto page_not_uptodate;
 
-	/* Must recheck i_size under page lock */
+	/*
+	 * Found the page and have a reference on it.
+	 * We must recheck i_size under page lock
+	 */
+found_it:
 	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	if (unlikely(vmf->pgoff >= size)) {
 		unlock_page(page);
@@ -1408,11 +1483,8 @@ retry_find:
 		return VM_FAULT_SIGBUS;
 	}
 
-	/*
-	 * Found the page and have a reference on it.
-	 */
 	mark_page_accessed(page);
-	ra->prev_pos = (loff_t)page->index << PAGE_CACHE_SHIFT;
+	ra->prev_pos = (loff_t)offset << PAGE_CACHE_SHIFT;
 	vmf->page = page;
 	return ret | VM_FAULT_LOCKED;
 
@@ -1441,12 +1513,6 @@ no_cached_page:
 	return VM_FAULT_SIGBUS;
 
 page_not_uptodate:
-	/* IO error path */
-	if (!did_readaround) {
-		ret = VM_FAULT_MAJOR;
-		count_vm_event(PGMAJFAULT);
-	}
-
 	/*
 	 * Umm, take care of errors if the page isn't up-to-date.
 	 * Try to re-read it _once_. We do this synchronously,

-- 
