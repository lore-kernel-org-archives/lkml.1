Return-Path: <linux-kernel-owner+w=401wt.eu-S933941AbXEUT30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933941AbXEUT30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765390AbXEUTVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:21:36 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46360 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765357AbXEUTV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:21:29 -0400
Message-Id: <20070521191712.241233000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:28 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, stefan.wenk@gmx.at,
       rpurdie@rpsys.net
Subject: [patch 16/69] ppp: Fix ppp_deflate issues with recent zlib_inflate changes
Content-Disposition: inline; filename=ppp-fix-ppp_deflate-issues-with-recent-zlib_inflate-changes.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Richard Purdie <rpurdie@rpsys.net>

The last zlib_inflate update broke certain corner cases for ppp_deflate
decompression handling.  This patch fixes some logic to make things work
properly again.  Users other than ppp_deflate (the only Z_PACKET_FLUSH
user) should be unaffected.

Fixes bug 8405 (confirmed by Stefan)

Signed-off-by: Richard Purdie <rpurdie@rpsys.net>
Cc: Stefan Wenk <stefan.wenk@gmx.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 lib/zlib_inflate/inflate.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- linux-2.6.21.1.orig/lib/zlib_inflate/inflate.c
+++ linux-2.6.21.1/lib/zlib_inflate/inflate.c
@@ -743,12 +743,14 @@ int zlib_inflate(z_streamp strm, int flu
 
     strm->data_type = state->bits + (state->last ? 64 : 0) +
                       (state->mode == TYPE ? 128 : 0);
-    if (((in == 0 && out == 0) || flush == Z_FINISH) && ret == Z_OK)
-        ret = Z_BUF_ERROR;
 
     if (flush == Z_PACKET_FLUSH && ret == Z_OK &&
-            (strm->avail_out != 0 || strm->avail_in == 0))
+            strm->avail_out != 0 && strm->avail_in == 0)
 		return zlib_inflateSyncPacket(strm);
+
+    if (((in == 0 && out == 0) || flush == Z_FINISH) && ret == Z_OK)
+        ret = Z_BUF_ERROR;
+
     return ret;
 }
 

-- 
