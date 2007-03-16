Return-Path: <linux-kernel-owner+w=401wt.eu-S932404AbXCPIwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbXCPIwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932403AbXCPIvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:51:47 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34668 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932458AbXCPIvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:51:10 -0400
Message-ID: <374035060.29167@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070316085053.030235000@mail.ustc.edu.cn>
References: <20070316084856.687942000@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Fri, 16 Mar 2007 16:49:06 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/14] readahead: state based method: protect against tiny size
Content-Disposition: inline; filename=readahead-state-based-method-protect-against-tiny-size.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the tiny I/O size protection code from limit_rala() to
state_based_readahead().

limit_rala() is also called by context based readahead, which has its own
minimal readahead size.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/readahead.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- linux-2.6.21-rc3-mm2.orig/mm/readahead.c
+++ linux-2.6.21-rc3-mm2/mm/readahead.c
@@ -1031,13 +1031,6 @@ static void limit_rala(unsigned long ra_
 	unsigned long stream_shift;
 
 	/*
-	 * Protect against too small I/O sizes,
-	 * by mapping [0, 4*min] to [min, 4*min].
-	 */
-	if (*ra_size < 4 * MIN_RA_PAGES)
-		*ra_size = MIN_RA_PAGES + *ra_size * 3 / 4;
-
-	/*
 	 * Apply basic upper limits.
 	 */
 	if (*ra_size > ra_max)
@@ -1145,6 +1138,13 @@ state_based_readahead(struct address_spa
 	if (!adjust_rala(&ra_size, &la_size))
 		goto cancel_lookahead;
 
+	/*
+	 * Protect against too small I/O sizes,
+	 * by mapping [0, 4*min] to [min, 4*min].
+	 */
+	if (ra_size < 4 * MIN_RA_PAGES)
+		ra_size = MIN_RA_PAGES + ra_size * 3 / 4;
+
 	growth_limit = req_size;
 	growth_limit += ra_max / 16;
 	growth_limit += 2 * ra_old;

--
