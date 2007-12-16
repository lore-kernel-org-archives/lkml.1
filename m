Return-Path: <linux-kernel-owner+w=401wt.eu-S932532AbXLPMIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532AbXLPMIS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 07:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934129AbXLPMEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 07:04:36 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:60641 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S934089AbXLPME0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 07:04:26 -0500
Message-ID: <397806668.49083@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071216120418.360445517@mail.ustc.edu.cn>
References: <20071216115927.986126305@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sun, 16 Dec 2007 19:59:34 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] readahead: save mmap read-around states in file_ra_state
Content-Disposition: inline; filename=readahead-convert-mmap-readaround.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change mmap read-around to share the same code style and data structure
with readahead code.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/filemap.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- linux-2.6.24-rc4-mm1.orig/mm/filemap.c
+++ linux-2.6.24-rc4-mm1/mm/filemap.c
@@ -1333,13 +1333,15 @@ static void do_sync_mmap_readahead(struc
 	if (ra->mmap_miss > MMAP_LOTSAMISS)
 		return;
 
-	ra_pages = max_sane_readahead(file->f_ra.ra_pages);
+	/*
+	 * mmap read-around
+	 */
+	ra_pages = max_sane_readahead(ra->ra_pages);
 	if (ra_pages) {
-		pgoff_t start = 0;
-
-		if (offset > ra_pages / 2)
-			start = offset - ra_pages / 2;
-		do_page_cache_readahead(mapping, file, start, ra_pages);
+		ra->start = max_t(long, 0, offset - ra_pages / 2);
+		ra->size = ra_pages;
+		ra->async_size = 0;
+		ra_submit(ra, mapping, file);
 	}
 }
 

-- 
