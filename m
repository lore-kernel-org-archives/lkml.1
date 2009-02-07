Return-Path: <linux-kernel-owner+w=401wt.eu-S1756968AbZBGDjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbZBGDjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 22:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbZBGDjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 22:39:05 -0500
Received: from cpe-139.126.55.190.in-addr.arpa ([190.55.126.139]:34514 "EHLO
	mail.fedux.com.ar" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbZBGDjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 22:39:04 -0500
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Feb 2009 22:39:04 EST
From: Federico Cuello <fedux@lugmen.org.ar>
To: linux-kernel@vger.kernel.org
Cc: Federico Cuello <fedux@lugmen.org.ar>
Subject: [PATCH] write-back: fix break condition
Date: Sat,  7 Feb 2009 01:33:30 -0200
Message-Id: <1233977610-8919-1-git-send-email-fedux@lugmen.org.ar>
X-Mailer: git-send-email 1.6.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 673353723e7a6550625fb719059c5f31cfaecd18 fixed nr_to_write
counter, but didn't set the break condition properly.

If nr_to_write == 0 after being decremented it will loop one more time
before setting done = 1 and breaking the loop.
---
 mm/page-writeback.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index bb5fa2b..9e2ae50 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -981,20 +981,21 @@ continue_unlock:
 				}
  			}
 
-			if (nr_to_write > 0)
+			if (nr_to_write > 0) {
 				nr_to_write--;
-			else if (wbc->sync_mode == WB_SYNC_NONE) {
-				/*
-				 * We stop writing back only if we are not
-				 * doing integrity sync. In case of integrity
-				 * sync we have to keep going because someone
-				 * may be concurrently dirtying pages, and we
-				 * might have synced a lot of newly appeared
-				 * dirty pages, but have not synced all of the
-				 * old dirty pages.
-				 */
-				done = 1;
-				break;
+				if (nr_to_write == 0 && wbc->sync_mode == WB_SYNC_NONE) {
+					/*
+					 * We stop writing back only if we are not
+					 * doing integrity sync. In case of integrity
+					 * sync we have to keep going because someone
+					 * may be concurrently dirtying pages, and we
+					 * might have synced a lot of newly appeared
+					 * dirty pages, but have not synced all of the
+					 * old dirty pages.
+					 */
+					done = 1;
+					break;
+				}
 			}
 
 			if (wbc->nonblocking && bdi_write_congested(bdi)) {
-- 
1.6.1.2

