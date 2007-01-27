Return-Path: <linux-kernel-owner+w=401wt.eu-S1751057AbXA0IZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751057AbXA0IZA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 03:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbXA0IYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 03:24:32 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34900 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752170AbXA0IY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 03:24:27 -0500
Message-ID: <369886264.06097@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070127082530.010446696@mail.ustc.edu.cn>
References: <20070127080219.161473179@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Sat, 27 Jan 2007 16:02:25 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Martin Peschke <mp3@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] readahead: thrashing recovery method fix
Content-Disposition: inline; filename=readahead-thrashing-recovery-method-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- keep lookahead_index if the current chunk is lost, so that when we
  revisted this stream, the state based method see a consistent state.
- correct the thrashing-threshold computation
- discount read-ahead size more, to free more memory to the system on pressure
- disable look-ahead when thrashed, just to be safe

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/readahead.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

--- linux-2.6.20-rc4-mm1.orig/mm/readahead.c
+++ linux-2.6.20-rc4-mm1/mm/readahead.c
@@ -1524,28 +1524,26 @@ thrashing_recovery_readahead(struct addr
 						ra->readahead_index - offset);
 #endif
 
-	/*
-	 * Some thrashing occur in (ra_index, la_index], in which case the
-	 * old read-ahead chunk is lost soon after the new one is allocated.
-	 * Ensure that we recover all needed pages in the old chunk.
-	 */
-	if (offset < ra->ra_index)
-		ra_size = ra->ra_index - offset;
-	else {
+	if (offset < ra->ra_index) {
+		/*
+		 * Thrashed when we are in [la_index, ra_index), i.e.
+		 * the old chunk is lost soon after the new one is allocated.
+		 * Ensure that we recover all needed pages in the old chunk.
+		 * And futher keep the lookahead_index untouched.
+		 */
+		ra_size = ra->lookahead_index - offset;
+	} else {
 		/* After thrashing, we know the exact thrashing-threshold. */
-		ra_size = offset - ra->ra_index;
+		ra_size = offset - ra->la_index;
 		update_ra_thrash_bytes(mapping->backing_dev_info, ra_size);
 
-		/* And we'd better be a bit conservative. */
-		ra_size = ra_size * 3 / 4;
+		/* And be cooperative: the system may be hunting for memory. */
+		ra_size = MIN_RA_PAGES + ra_size / 2;
 	}
 
-	if (ra_size > ra_max)
-		ra_size = ra_max;
-
 	ra_set_class(ra, RA_CLASS_THRASHING);
 	ra_set_index(ra, offset, offset);
-	ra_set_size(ra, ra_size, ra_size / LOOKAHEAD_RATIO);
+	ra_set_size(ra, ra_size, 0);
 
 	return ra_submit(ra, mapping, filp);
 }

--
