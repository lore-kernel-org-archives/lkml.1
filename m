Return-Path: <linux-kernel-owner+w=401wt.eu-S934198AbXLPMEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934198AbXLPMEq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 07:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932433AbXLPME3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 07:04:29 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:60602 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S933939AbXLPME0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 07:04:26 -0500
Message-ID: <397806668.34228@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071216120417.905514988@mail.ustc.edu.cn>
References: <20071216115927.986126305@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sun, 16 Dec 2007 19:59:31 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] readahead: auto detection of sequential mmap reads
Content-Disposition: inline; filename=readahead-auto-detect-mmap-sequential-reads.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Auto-detect sequential mmap reads and do sync/async readahead for them.

The sequential mmap readahead will be triggered when
- sync readahead: it's a major fault and (prev_offset==offset-1);
- async readahead: minor fault on PG_readahead page with valid readahead state.

It's a bit conservative to require valid readahead state for async readahead,
which means we don't do readahead for interleaved reads for now, but let's make
it safe for this initial try.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---

---
 mm/filemap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- linux-2.6.24-rc4-mm1.orig/mm/filemap.c
+++ linux-2.6.24-rc4-mm1/mm/filemap.c
@@ -1318,7 +1318,8 @@ static void do_sync_mmap_readahead(struc
 	if (VM_RandomReadHint(vma))
 		return;
 
-	if (VM_SequentialReadHint(vma)) {
+	if (VM_SequentialReadHint(vma) ||
+			offset - 1 == (ra->prev_pos >> PAGE_CACHE_SHIFT)) {
 		page_cache_sync_readahead(mapping, ra, file, offset, 1);
 		return;
 	}
@@ -1360,7 +1361,8 @@ static void do_async_mmap_readahead(stru
 		return;
 	if (ra->mmap_miss > 0)
 		ra->mmap_miss--;
-	if (PageReadahead(page))
+	if (PageReadahead(page) &&
+			offset == ra->start + ra->size - ra->async_size)
 		page_cache_async_readahead(mapping, ra, file, page, offset, 1);
 }
 

-- 
