Return-Path: <linux-kernel-owner+w=401wt.eu-S1752205AbXA0IY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbXA0IY6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 03:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750887AbXA0IYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 03:24:30 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34856 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751057AbXA0IY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 03:24:26 -0500
Message-ID: <369886263.59195@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070127082529.463795013@mail.ustc.edu.cn>
References: <20070127080219.161473179@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Sat, 27 Jan 2007 16:02:22 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Martin Peschke <mp3@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] readahead: state based method: prevent tiny size
Content-Disposition: inline; filename=readahead-state-based-method-prevent-tiny-size.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- cancel look-ahead if readahead size is small compared to the look-ahead size,
  to avoid too small I/O size, and not to add more memory/io pressure on the
  possibly loaded system.
- prevent issuing tiny readahead size, by applying a minimal limit

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/readahead.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- linux-2.6.20-rc4-mm1.orig/mm/readahead.c
+++ linux-2.6.20-rc4-mm1/mm/readahead.c
@@ -932,17 +932,21 @@ static int adjust_rala(unsigned long ra_
 			unsigned long *ra_size, unsigned long *la_size)
 {
 	/*
-	 * Substract the old look-ahead to get real safe size for the next
-	 * read-ahead request.
+	 * Cancel asynchrous read-ahead,
+	 * if there is a major upsurge of load, or fall of this stream's speed.
 	 */
-	if (*ra_size > *la_size)
-		*ra_size -= *la_size;
-	else {
+	if (*ra_size <= *la_size * 2) {
 		ra_account(NULL, RA_EVENT_READAHEAD_SHRINK, *ra_size);
 		return 0;
 	}
 
 	/*
+	 * Substract the old look-ahead to get real safe size for the next
+	 * read-ahead request.
+	 */
+	*ra_size -= *la_size;
+
+	/*
 	 * Set new la_size according to the (still large) ra_size.
 	 */
 	*la_size = *ra_size / LOOKAHEAD_RATIO;
@@ -956,6 +960,13 @@ static void limit_rala(unsigned long ra_
 	unsigned long stream_shift;
 
 	/*
+	 * Protect against too small I/O sizes,
+	 * by mapping [0, 4*min] to [min, 4*min].
+	 */
+	if (*ra_size < 4 * MIN_RA_PAGES)
+		*ra_size = MIN_RA_PAGES + *ra_size * 3 / 4;
+
+	/*
 	 * Apply basic upper limits.
 	 */
 	if (*ra_size > ra_max)

--
