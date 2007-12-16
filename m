Return-Path: <linux-kernel-owner+w=401wt.eu-S934636AbXLPMHC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934636AbXLPMHC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 07:07:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934125AbXLPMEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 07:04:34 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:60612 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S934083AbXLPME0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 07:04:26 -0500
Message-ID: <397806668.82846@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071216120418.055796608@mail.ustc.edu.cn>
References: <20071216115927.986126305@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sun, 16 Dec 2007 19:59:32 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] readahead: quick startup on sequential mmap readahead
Content-Disposition: inline; filename=readahead-sequential-quick-start.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the user explicitly sets MADV_SEQUENTIAL, we should really avoid the slow
readahead size ramp-up phase and start full-size readahead immediately.

This patch won't change behavior for the auto-detected sequential mmap reads.
Its previous read-around size is ra_pages/2, so it will be doubled to the full
readahead size anyway.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc4-mm1.orig/mm/filemap.c
+++ linux-2.6.24-rc4-mm1/mm/filemap.c
@@ -1320,7 +1320,7 @@ static void do_sync_mmap_readahead(struc
 
 	if (VM_SequentialReadHint(vma) ||
 			offset - 1 == (ra->prev_pos >> PAGE_CACHE_SHIFT)) {
-		page_cache_sync_readahead(mapping, ra, file, offset, 1);
+		page_cache_sync_readahead(mapping, ra, file, offset, ra->ra_pages);
 		return;
 	}
 

-- 
