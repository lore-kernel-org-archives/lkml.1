Return-Path: <linux-kernel-owner+w=401wt.eu-S1750844AbXLVBeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750844AbXLVBeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 20:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbXLVBdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 20:33:24 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:53902 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751260AbXLVBdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 20:33:18 -0500
Message-ID: <398287205.56298@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071222013314.546311527@mail.ustc.edu.cn>
References: <20071222013147.897522982@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sat, 22 Dec 2007 09:31:48 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] readahead: simplify readahead call scheme
Content-Disposition: inline; filename=readahead-merge-sync-async.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is insane and error-prone to insist on the call sites to check for async
readahead after doing any sync one. I.e. whenever someone do a sync readahead:

				if (!page)
					page_cache_sync_readahead(...);

He must try async readahead, too:

				page = find_get_page(...);
				if (PageReadahead(page))
					page_cache_async_readahead(...);

The tricky point is that PG_readahead could be set by a sync readahead for the
_current_ newly faulted in page, and the readahead code simply expects one more
callback to handle it. If the caller fails to do so, it will miss the
PG_readahead bits and never able to start an async readahead.

Avoid it by piggy-backing the async part _inside_ the readahead code.

Now if an async readahead should be started immediately after a sync one,
the readahead logic itself will do it. So the following code becomes valid:

				if (!page)
					page_cache_sync_readahead(...);
				else if (PageReadahead(page))
					page_cache_async_readahead(...);

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/readahead.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- linux-2.6.24-rc5-mm1.orig/mm/readahead.c
+++ linux-2.6.24-rc5-mm1/mm/readahead.c
@@ -402,6 +402,14 @@ ondemand_readahead(struct address_space 
 	ra->async_size = ra->size > req_size ? ra->size - req_size : ra->size;
 
 readit:
+	/*
+	 * An async readahead should be triggered immediately.
+	 * Instead of demanding all call sites to check for async readahead
+	 * immediate after a sync one, start the async part now and here.
+	 */
+	if (!hit_readahead_marker && ra->size == ra->async_size)
+		ra->size *= 2;
+
 	return ra_submit(ra, mapping, filp);
 }
 

-- 
