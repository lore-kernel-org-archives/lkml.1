Return-Path: <linux-kernel-owner+w=401wt.eu-S932414AbXCPIvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbXCPIvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932508AbXCPIvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:51:07 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34661 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932414AbXCPIvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:51:05 -0400
Message-ID: <374035059.61077@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070316085052.868849000@mail.ustc.edu.cn>
References: <20070316084856.687942000@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Fri, 16 Mar 2007 16:49:05 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/14] readahead: remove parameter ra_max from adjust_rala*()
Content-Disposition: inline; filename=readahead-remove-parameter-ra_max-from-adjust_rala.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the unused parameter @ra_max from adjust_rala() and
adjust_rala_aggressive().

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/readahead.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- linux-2.6.21-rc3-mm2.orig/mm/readahead.c
+++ linux-2.6.21-rc3-mm2/mm/readahead.c
@@ -1000,8 +1000,7 @@ static unsigned long ra_submit(struct fi
  *	- @ra_size stores the estimated thrashing-threshold.
  *	- @la_size stores the look-ahead size of previous request.
  */
-static int adjust_rala(unsigned long ra_max,
-			unsigned long *ra_size, unsigned long *la_size)
+static int adjust_rala(unsigned long *ra_size, unsigned long *la_size)
 {
 	/*
 	 * Cancel asynchrous read-ahead,
@@ -1143,15 +1142,15 @@ state_based_readahead(struct address_spa
 		goto cancel_lookahead;
 	}
 
+	if (!adjust_rala(&ra_size, &la_size))
+		goto cancel_lookahead;
+
 	growth_limit = req_size;
 	growth_limit += ra_max / 16;
 	growth_limit += 2 * ra_old;
 	if (growth_limit > ra_max)
 	    growth_limit = ra_max;
 
-	if (!adjust_rala(growth_limit, &ra_size, &la_size))
-		goto cancel_lookahead;
-
 	limit_rala(growth_limit, la_old, &ra_size, &la_size);
 
 	/* ra_size in its _steady_ state reflects thrashing threshold */
@@ -1345,8 +1344,8 @@ out_unlock:
  * which is safe: the tailing look-ahead part is 'unsafe'. However it will be
  * safeguarded by rescue_pages() when the previous chunks are lost.
  */
-static void adjust_rala_aggressive(unsigned long ra_max,
-				unsigned long *ra_size, unsigned long *la_size)
+static void adjust_rala_aggressive(unsigned long *ra_size,
+				   unsigned long *la_size)
 {
 	pgoff_t offset = *ra_size;
 
@@ -1463,12 +1462,12 @@ has_history_pages:
 
 	if (ra_size >= offset) {
 		ra_size = offset;
-		adjust_rala_aggressive(ra_max, &ra_size, &la_size);
+		adjust_rala_aggressive(&ra_size, &la_size);
 		ra_set_class(ra, RA_CLASS_CONTEXT_AGGRESSIVE);
 	} else {
 		if (ra_size < ra_min)
 		    ra_size = ra_min;
-		if (!adjust_rala(ra_max, &ra_size, &la_size))
+		if (!adjust_rala(&ra_size, &la_size))
 			return -1;
 		ra_set_class(ra, RA_CLASS_CONTEXT);
 	}

--
