Return-Path: <linux-kernel-owner+w=401wt.eu-S1161349AbXDKW5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161349AbXDKW5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161374AbXDKW4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:56:12 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55831 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161369AbXDKWzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:55:45 -0400
Date: Wed, 11 Apr 2007 15:52:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, dev@openvz.org,
       kenneth.w.chen@intel.com, saw@sw.ru, dmonakhov@openvz.org,
       linux-ext4@vger.kernel.org, mingo@elte.hu
Subject: [patch 28/31] revert "retries in ext3_prepare_write() violate
	ordering requirements"
Message-ID: <20070411225253.GC24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="revert-retries-in-ext3_prepare_write-violate-ordering-requirements.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

Revert e92a4d595b464c4aae64be39ca61a9ffe9c8b278.

Dmitry points out

"When we block_prepare_write() failed while ext3_prepare_write() we jump to
 "failure" label and call ext3_prepare_failure() witch search last mapped bh
 and invoke commit_write untill it.  This is wrong!!  because some bh from
 begining to the last mapped bh may be not uptodate.  As a result we commit to
 disk not uptodate page content witch contains garbage from previous usage."

and

"Unexpected file size increasing."

   Call trace the same as it was in first issue but result is different. 
   For example we have file with i_size is zero.  we want write two blocks ,
   but fs has only one free block.

   ->ext3_prepare_write(...from == 0, to == 2048)
     retry:
     ->block_prepare_write() == -ENOSPC# we failed but allocated one block here.
     ->ext3_prepare_failure()
       ->commit_write( from == 0, to == 1024) # after this i_size becomes 1024 :)
     if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
        goto retry;

   Finally when all retries will be spended ext3_prepare_failure return
   -ENOSPC, but i_size was increased and later block trimm procedures can't
   help here.

We don't appear to have the horsepower to fix these issues, so let's put
things back the way they were for now.

Cc: Kirill Korotaev <dev@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ken Chen <kenneth.w.chen@intel.com>
Cc: Andrey Savochkin <saw@sw.ru>
Cc: <linux-ext4@vger.kernel.org>
Cc: Dmitriy Monakhov <dmonakhov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/ext3/inode.c |   85 ++++++--------------------------------------------------
 1 file changed, 10 insertions(+), 75 deletions(-)

--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1148,102 +1148,37 @@ static int do_journal_get_write_access(h
 	return ext3_journal_get_write_access(handle, bh);
 }
 
-/*
- * The idea of this helper function is following:
- * if prepare_write has allocated some blocks, but not all of them, the
- * transaction must include the content of the newly allocated blocks.
- * This content is expected to be set to zeroes by block_prepare_write().
- * 2006/10/14  SAW
- */
-static int ext3_prepare_failure(struct file *file, struct page *page,
-				unsigned from, unsigned to)
-{
-	struct address_space *mapping;
-	struct buffer_head *bh, *head, *next;
-	unsigned block_start, block_end;
-	unsigned blocksize;
-	int ret;
-	handle_t *handle = ext3_journal_current_handle();
-
-	mapping = page->mapping;
-	if (ext3_should_writeback_data(mapping->host)) {
-		/* optimization: no constraints about data */
-skip:
-		return ext3_journal_stop(handle);
-	}
-
-	head = page_buffers(page);
-	blocksize = head->b_size;
-	for (	bh = head, block_start = 0;
-		bh != head || !block_start;
-	    	block_start = block_end, bh = next)
-	{
-		next = bh->b_this_page;
-		block_end = block_start + blocksize;
-		if (block_end <= from)
-			continue;
-		if (block_start >= to) {
-			block_start = to;
-			break;
-		}
-		if (!buffer_mapped(bh))
-		/* prepare_write failed on this bh */
-			break;
-		if (ext3_should_journal_data(mapping->host)) {
-			ret = do_journal_get_write_access(handle, bh);
-			if (ret) {
-				ext3_journal_stop(handle);
-				return ret;
-			}
-		}
-	/*
-	 * block_start here becomes the first block where the current iteration
-	 * of prepare_write failed.
-	 */
-	}
-	if (block_start <= from)
-		goto skip;
-
-	/* commit allocated and zeroed buffers */
-	return mapping->a_ops->commit_write(file, page, from, block_start);
-}
-
 static int ext3_prepare_write(struct file *file, struct page *page,
 			      unsigned from, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
-	int ret, ret2;
-	int needed_blocks = ext3_writepage_trans_blocks(inode);
+	int ret, needed_blocks = ext3_writepage_trans_blocks(inode);
 	handle_t *handle;
 	int retries = 0;
 
 retry:
 	handle = ext3_journal_start(inode, needed_blocks);
-	if (IS_ERR(handle))
-		return PTR_ERR(handle);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out;
+	}
 	if (test_opt(inode->i_sb, NOBH) && ext3_should_writeback_data(inode))
 		ret = nobh_prepare_write(page, from, to, ext3_get_block);
 	else
 		ret = block_prepare_write(page, from, to, ext3_get_block);
 	if (ret)
-		goto failure;
+		goto prepare_write_failed;
 
 	if (ext3_should_journal_data(inode)) {
 		ret = walk_page_buffers(handle, page_buffers(page),
 				from, to, NULL, do_journal_get_write_access);
-		if (ret)
-			/* fatal error, just put the handle and return */
-			journal_stop(handle);
 	}
-	return ret;
-
-failure:
-	ret2 = ext3_prepare_failure(file, page, from, to);
-	if (ret2 < 0)
-		return ret2;
+prepare_write_failed:
+	if (ret)
+		ext3_journal_stop(handle);
 	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
-	/* retry number exceeded, or other error like -EDQUOT */
+out:
 	return ret;
 }
 

-- 
