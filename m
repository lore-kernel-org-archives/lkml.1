Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbXLVBfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbXLVBfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 20:35:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbXLVBd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 20:33:26 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:53931 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751327AbXLVBdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 20:33:18 -0500
Message-ID: <398287205.95879@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071222013314.837299924@mail.ustc.edu.cn>
References: <20071222013147.897522982@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sat, 22 Dec 2007 09:31:50 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
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

======
The benefits of doing readahead instead of read-around:
- less I/O wait thanks to async readahead
- double real I/O size and no more cache hits

Some numbers on 100,000 sequential mmap reads:

                                    user       system    cpu        total
(1-1)  plain -mm, 128KB readaround: 3.224      2.554     48.40%     11.838
(1-2)  plain -mm, 256KB readaround: 3.170      2.392     46.20%     11.976
(2)  patched -mm, 128KB readahead:  3.117      2.448     47.33%     11.607

The patched (2) has smallest total time. It has no cache hit overheads
and less I/O block time(thanks to async readahead). Here the I/O size
makes no much difference, since there's only one single stream.

Note that (1-1)'s real I/O size is 64KB and (1-2)'s real I/O size is
128KB, since the half of the read-around pages will be cache hits.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---

---
 mm/filemap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- linux-2.6.24-rc5-mm1.orig/mm/filemap.c
+++ linux-2.6.24-rc5-mm1/mm/filemap.c
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
