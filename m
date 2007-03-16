Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbXCPIzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbXCPIzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbXCPIzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:55:43 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34629 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932444AbXCPIvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:51:10 -0400
Message-ID: <374035059.71212@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070316085052.284256000@mail.ustc.edu.cn>
References: <20070316084856.687942000@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Fri, 16 Mar 2007 16:49:01 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/14] readahead: thrashing recovery method: refill holes
Content-Disposition: inline; filename=readahead-thrashing-recovery-method-refill-holes.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When thrashing happened in the following abnormal cases:
	1) the old chunk is lost;
	2) random pages are lost due to unbalanced aging.
There will be hole(s) in the otherwise continuous readahead pages.

We recover from it by simply refilling all possible holes and
turning off lookahead.

These kind of abnormal situations are not expected to repeatable for the same
stream. They happen in a random fashion and do not tell much about the system
load. So the best thing we can do is to do nothing more than refilling the
holes.  If thrashing persists, it will quickly fail into the 3) case where we
get the exact thrashing threshold:
	3) the new chunk is thrashed.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/readahead.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- linux-2.6.21-rc3-mm2.orig/mm/readahead.c
+++ linux-2.6.21-rc3-mm2/mm/readahead.c
@@ -1552,20 +1552,23 @@ thrashing_recovery_readahead(struct addr
 					  RA_EVENT_READAHEAD_THRASHING,
 					  ra->readahead_index - offset);
 
-	if (offset < ra->ra_index) {
+	if (offset < ra->ra_index || unbalanced_aging) {
 		/*
-		 * Thrashed when we are in [la_index, ra_index), i.e.
-		 * the old chunk is lost soon after the new one is allocated.
-		 * Ensure that we recover all needed pages in the old chunk.
-		 * And futher keep the lookahead_index untouched.
+		 * 1) The old chunk is lost.
+		 * 2) Some random pages are lost due to unbalanced zone/node aging.
+		 * Refill the hole(s).
+		 * Further thrashings will bring us back to case (3) below.
 		 */
-		ra_size = ra->lookahead_index - offset;
+		ra_size = ra->readahead_index - offset;
 	} else {
-		/* After thrashing, we know the exact thrashing-threshold. */
+		/*
+		 * 3) The new chunk is lost.
+		 * It tells us about the thrashing-threshold.
+		 */
 		ra_size = offset - ra->la_index;
 		update_ra_thrash_bytes(mapping->backing_dev_info, ra_size);
 
-		/* And be cooperative: the system may be hunting for memory. */
+		/* Be cooperative: the system may be hunting for memory. */
 		ra_size = MIN_RA_PAGES + ra_size / 2;
 	}
 

--
