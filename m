Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbZBBO60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbZBBO60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 09:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbZBBO6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 09:58:17 -0500
Received: from smtp.nokia.com ([192.100.105.134]:41190 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbZBBO6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 09:58:17 -0500
Subject: [BUGFIX] [PATCH] write-back: fix nr_to_write counter
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Feb 2009 16:57:41 +0200
Message-Id: <1233586661.24809.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Feb 2009 14:57:34.0580 (UTC) FILETIME=[94B40340:01C98546]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

commit 05fe478dd04e02fa230c305ab9b5616669821dd3
Author: Nick Piggin <npiggin@suse.de>
Date:   Tue Jan 6 14:39:08 2009 -0800

    mm: write_cache_pages integrity fix

broke wbc->nr_to_write handling. Here is the fix.

I'm not 100% sure I got things right, because I am far not expert in the
area. Please, review it. The patch fixes my UBIFS issues, which are
caused by the fact that wbc->nr_to_write is not updated.
======================================================================

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Mon, 2 Feb 2009 18:33:49 +0200
Subject: [PATCH] write-back: fix nr_to_write counter

Commit 05fe478dd04e02fa230c305ab9b5616669821dd3 broke @wbc->nr_to_write.
'write_cache_pages()' changes it in the loop, but restores the original
value from @nr_to_write at the end, because of this code:

       if (!wbc->no_nrwrite_index_update) {
                if (wbc->range_cyclic || (range_whole && nr_to_write > 0))
                        mapping->writeback_index = done_index;
                wbc->nr_to_write = nr_to_write;
        }

Well, in case of @wbc->no_nrwrite_index_update != 0, we do change
wbc->nr_to_write, while we should not. This patch fixes this behavior.

Also, I think wbc->nr_to_write should be changed in all cases, not only
when wbc->sync_mode == WB_SYNC_NONE.

Also, I add a comment explaining why we do not stop writing back.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 mm/page-writeback.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index b493db7..13a2b8e 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1051,13 +1051,22 @@ continue_unlock:
 				}
  			}
 
-			if (wbc->sync_mode == WB_SYNC_NONE) {
-				wbc->nr_to_write--;
-				if (wbc->nr_to_write <= 0) {
-					done = 1;
-					break;
-				}
+			if (nr_to_write > 0)
+				nr_to_write--;
+			else if (wbc->sync_mode == WB_SYNC_NONE) {
+				/*
+				 * We stop writing back only if we are not
+				 * doing integrity sync. In case of integrity
+				 * sync we have to keep going because someone
+				 * may be concurrently dirtying pages, and we
+				 * might have synced a lot of newly appeared
+				 * dirty pages, bud have not synced all of the
+				 * old dirty pages.
+				 */
+				done = 1;
+				break;
 			}
+
 			if (wbc->nonblocking && bdi_write_congested(bdi)) {
 				wbc->encountered_congestion = 1;
 				done = 1;
-- 
1.6.0.6

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

