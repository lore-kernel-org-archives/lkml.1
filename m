Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbZF0AfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbZF0AfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 20:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZF0AfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 20:35:09 -0400
Received: from [65.98.92.6] ([65.98.92.6]:2541 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbZF0AfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 20:35:08 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: <dwmw2@infradead.org>, <dedekind@infradead.org>
Cc: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Date: Fri, 26 Jun 2009 17:10:50 -0700
Subject: [PATCH] UBIFS: Fix integer overflow warnings
Message-Id: <3f15c0091535d0ab4a1d45cbc9eb3667@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This warning was observed on MIPS32 using 2.6.31-rc1 and gcc-4.2.0:

fs/ubifs/io.c: In function 'ubifs_wbuf_init':
fs/ubifs/io.c:860: warning: integer overflow in expression
fs/ubifs/io.c:860: warning: integer overflow in expression
fs/ubifs/io.c:860: warning: integer overflow in expression

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
index bc58571..184157e 100644
--- a/fs/ubifs/io.c
+++ b/fs/ubifs/io.c
@@ -857,7 +857,8 @@ int ubifs_wbuf_init(struct ubifs_info *c, struct ubifs_wbuf *wbuf)
 	 * and hard limits.
 	 */
 	hardlimit = ktime_set(DEFAULT_WBUF_TIMEOUT_SECS, 0);
-	wbuf->delta = (DEFAULT_WBUF_TIMEOUT_SECS * NSEC_PER_SEC) * 2 / 10;
+	wbuf->delta = ((unsigned long long)DEFAULT_WBUF_TIMEOUT_SECS *
+		       NSEC_PER_SEC) * 2 / 10;
 	wbuf->softlimit = ktime_sub_ns(hardlimit, wbuf->delta);
 	hrtimer_set_expires_range_ns(&wbuf->timer,  wbuf->softlimit,
 				     wbuf->delta);
--
