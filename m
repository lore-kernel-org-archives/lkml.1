Return-Path: <linux-kernel-owner+w=401wt.eu-S1759864AbXGTKOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864AbXGTKOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 06:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbXGTKLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 06:11:35 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:59109 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751706AbXGTKLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 06:11:30 -0400
Message-ID: <384926280.22018@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070720101124.083676724@mail.ustc.edu.cn>
References: <20070720100740.106917381@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Fri, 20 Jul 2007 18:07:42 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] mmap read-around simplification
Content-Disposition: inline; filename=remove-mmap-hit.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fold file_ra_state.mmap_hit into file_ra_state.mmap_miss
and make it an int.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 include/linux/fs.h |    3 +--
 mm/filemap.c       |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

--- linux-2.6.22-rc6-mm1.orig/include/linux/fs.h
+++ linux-2.6.22-rc6-mm1/include/linux/fs.h
@@ -777,8 +777,7 @@ struct file_ra_state {
 					   there are only # of pages ahead */
 
 	unsigned int ra_pages;		/* Maximum readahead window */
-	unsigned long mmap_hit;		/* Cache hit stat for mmap accesses */
-	unsigned long mmap_miss;	/* Cache miss stat for mmap accesses */
+	int mmap_miss;			/* Cache miss stat for mmap accesses */
 	unsigned int prev_offset;	/* Offset where last read() ended in a page */
 	unsigned int prev_index;	/* Cache last read() position */
 };
--- linux-2.6.22-rc6-mm1.orig/mm/filemap.c
+++ linux-2.6.22-rc6-mm1/mm/filemap.c
@@ -1389,7 +1389,7 @@ retry_find:
 		 * Do we miss much more than hit in this file? If so,
 		 * stop bothering with read-ahead. It will only hurt.
 		 */
-		if (ra->mmap_miss > ra->mmap_hit + MMAP_LOTSAMISS)
+		if (ra->mmap_miss > MMAP_LOTSAMISS)
 			goto no_cached_page;
 
 		/*
@@ -1415,7 +1415,7 @@ retry_find:
 	}
 
 	if (!did_readaround)
-		ra->mmap_hit++;
+		ra->mmap_miss--;
 
 	/*
 	 * We have a locked page in the page cache, now we need to check

--
