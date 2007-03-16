Return-Path: <linux-kernel-owner+w=401wt.eu-S932348AbXCPI5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbXCPI5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbXCPI4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:56:34 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34643 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932471AbXCPIvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:51:08 -0400
Message-ID: <374035059.35424@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070316085052.550263000@mail.ustc.edu.cn>
References: <20070316084856.687942000@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Fri, 16 Mar 2007 16:49:03 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/14] readahead: call scheme: catch thrashing on lookahead time
Content-Disposition: inline; filename=readahead-call-scheme-catch-thrashing-on-lookahead-time.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the call to thrashing_recovery_readahead() before state_based_readahead().

That catches the rare case where thrashing happened on the time we are to read
the page at ra->lookahead_index. Obviously this case should be handled by
thrashing_recovery_readahead() instead of state_based_readahead().

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/readahead.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- linux-2.6.21-rc3-mm2.orig/mm/readahead.c
+++ linux-2.6.21-rc3-mm2/mm/readahead.c
@@ -1638,6 +1638,13 @@ page_cache_readahead_adaptive(struct add
 		return initial_readahead(mapping, filp, ra, req_size);
 
 	/*
+	 * Recover from possible thrashing.
+	 */
+	if (!page && offset - ra->prev_page <= 1 && ra_has_index(ra, offset))
+		return thrashing_recovery_readahead(mapping, filp, ra,
+								offset, ra_max);
+
+	/*
 	 * State based sequential read-ahead.
 	 */
 	if (offset == ra->prev_page + 1 &&
@@ -1647,13 +1654,6 @@ page_cache_readahead_adaptive(struct add
 						offset, req_size, ra_max);
 
 	/*
-	 * Recover from possible thrashing.
-	 */
-	if (!page && offset - ra->prev_page <= 1 && ra_has_index(ra, offset))
-		return thrashing_recovery_readahead(mapping, filp, ra,
-								offset, ra_max);
-
-	/*
 	 * Backward read-ahead.
 	 */
 	if (!page && try_backward_prefetching(ra, offset, req_size, ra_max))

--
