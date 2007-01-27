Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbXA0IY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbXA0IY4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 03:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbXA0IYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 03:24:34 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34925 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752174AbXA0IY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 03:24:27 -0500
Message-ID: <369886264.38864@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070127082530.379485097@mail.ustc.edu.cn>
References: <20070127080219.161473179@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Sat, 27 Jan 2007 16:02:27 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Martin Peschke <mp3@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] readahead: laptop mode fix
Content-Disposition: inline; filename=readahead-laptop-mode-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1) make LAPTOP_POLL_INTERVAL independent of page size

2) defer readahead to the _last_ minute

There's no luck for the kernel to know the right time of
waking up the disk in order to hide the spin up latency.

So we make the rule simple:
- The kernel ensures _longest_ spin down time;
- The media player caches enough data to hide the spin up delay.

That means, if one enabled laptop mode, and want to watch movies
without pauses, he should setup proper media player cache as well.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/readahead.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

--- linux-2.6.20-rc4-mm1.orig/mm/readahead.c
+++ linux-2.6.20-rc4-mm1/mm/readahead.c
@@ -37,7 +37,7 @@
 #define INITIAL_RA_PAGES  DIV_ROUND_UP(64*1024, PAGE_CACHE_SIZE)
 
 /* In laptop mode, poll delayed look-ahead on every ## pages read. */
-#define LAPTOP_POLL_INTERVAL 16
+#define LAPTOP_POLL_INTERVAL	DIV_ROUND_UP(64*1024, PAGE_CACHE_SIZE)
 
 /* Set look-ahead size to 1/# of the thrashing-threshold. */
 #define LOOKAHEAD_RATIO 8
@@ -788,28 +788,22 @@ out:
 
 /*
  * Set a new look-ahead mark at @next.
- * Return 0 if the new mark is successfully set.
  */
-static int renew_lookahead(struct address_space *mapping,
+static void defer_lookahead(struct address_space *mapping,
 				struct file_ra_state *ra,
 				pgoff_t offset, pgoff_t next)
 {
 	struct page *page;
 
-	if (offset == ra->lookahead_index &&
-	      next >= ra->readahead_index)
-		return 1;
-
-	if (!(page = find_get_page(mapping, next)))
-		return 1;
+	page = find_get_page(mapping, next);
+	if (!page)
+		return;
 
 	SetPageReadahead(page);
 	page_cache_release(page);
 
 	if (ra->lookahead_index == offset)
 	    ra->lookahead_index = next;
-
-	return 0;
 }
 
 /*
@@ -1617,9 +1611,9 @@ page_cache_readahead_adaptive(struct add
 		 * Defer read-ahead to save energy.
 		 */
 		if (unlikely(laptop_mode && laptop_spinned_down())) {
-			if (!renew_lookahead(mapping, ra, offset,
-						offset + LAPTOP_POLL_INTERVAL))
-				return 0;
+			defer_lookahead(mapping, ra, offset,
+						offset + LAPTOP_POLL_INTERVAL);
+			return 0;
 		}
 	}
 

--
