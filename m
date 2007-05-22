Return-Path: <linux-kernel-owner+w=401wt.eu-S1765246AbXEVCeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765246AbXEVCeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 22:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759363AbXEVCeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 22:34:10 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53313 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759081AbXEVCeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 22:34:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [PATCH 1/3] Preserve the dirty bit in init_page_buffers
Date: Mon, 21 May 2007 20:31:50 -0600
Message-ID: <m14pm5io6h.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The problem:  When we are trying to free buffers try_to_free_buffers
will look at ramdisk pages with clean buffer heads and remove the
dirty bit from the page.  Resulting in ramdisk pages with data that
get removed from the page cache.  Ouch!

Buffer heads appear on ramdisk pages when a filesystem calls getblk,
which through a series of function calls eventually calls
init_page_buffers. 

So to fix the mismatch between buffer head state and page state this
patch modifies init_page_buffers to transfer the dirty bit from the
page to the buffer heads like we currently do for the uptodate bit.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/buffer.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index aa68206..c6b58e8 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -953,6 +953,7 @@ init_page_buffers(struct page *page, struct block_device *bdev,
 	struct buffer_head *head = page_buffers(page);
 	struct buffer_head *bh = head;
 	int uptodate = PageUptodate(page);
+	int dirty = PageDirty(page);
 
 	do {
 		if (!buffer_mapped(bh)) {
@@ -961,6 +962,8 @@ init_page_buffers(struct page *page, struct block_device *bdev,
 			bh->b_blocknr = block;
 			if (uptodate)
 				set_buffer_uptodate(bh);
+			if (dirty)
+				set_buffer_dirty(bh);
 			set_buffer_mapped(bh);
 		}
 		block++;
-- 
1.5.1.1.181.g2de0

