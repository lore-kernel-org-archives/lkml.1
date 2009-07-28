Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbZG1XuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbZG1XuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZG1XuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:50:06 -0400
Received: from kroah.org ([198.145.64.141]:35789 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349AbZG1XuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:03 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:56 2009
Message-Id: <20090728234156.393831871@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [patch 34/71] nilfs2: fix hang problem of log writer which occurs after write failures
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=nilfs2-fix-hang-problem-of-log-writer-which-occurs-after-write-failures.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

commit 8227b29722fdbac72357aae155d171a5c777670c upstream.

Leandro Lucarella gave me a report that nilfs gets stuck after its
write function fails.

The problem turned out to be caused by bugs which leave writeback flag
on pages.  This fixes the problem by ensuring to clear the writeback
flag in error path.

Reported-by: Leandro Lucarella <llucax@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nilfs2/segment.c |   26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1853,19 +1853,6 @@ static int nilfs_segctor_write(struct ni
 	return 0;
 }
 
-static int nilfs_page_has_uncleared_buffer(struct page *page)
-{
-	struct buffer_head *head, *bh;
-
-	head = bh = page_buffers(page);
-	do {
-		if (buffer_dirty(bh) && !list_empty(&bh->b_assoc_buffers))
-			return 1;
-		bh = bh->b_this_page;
-	} while (bh != head);
-	return 0;
-}
-
 static void __nilfs_end_page_io(struct page *page, int err)
 {
 	if (!err) {
@@ -1889,12 +1876,11 @@ static void nilfs_end_page_io(struct pag
 	if (!page)
 		return;
 
-	if (buffer_nilfs_node(page_buffers(page)) &&
-	    nilfs_page_has_uncleared_buffer(page))
-		/* For b-tree node pages, this function may be called twice
-		   or more because they might be split in a segment.
-		   This check assures that cleanup has been done for all
-		   buffers in a split btnode page. */
+	if (buffer_nilfs_node(page_buffers(page)) && !PageWriteback(page))
+		/*
+		 * For b-tree node pages, this function may be called twice
+		 * or more because they might be split in a segment.
+		 */
 		return;
 
 	__nilfs_end_page_io(page, err);
@@ -1957,7 +1943,7 @@ static void nilfs_segctor_abort_write(st
 			}
 			if (bh->b_page != fs_page) {
 				nilfs_end_page_io(fs_page, err);
-				if (unlikely(fs_page == failed_page))
+				if (fs_page && fs_page == failed_page)
 					goto done;
 				fs_page = bh->b_page;
 			}


