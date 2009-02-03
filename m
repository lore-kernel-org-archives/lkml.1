Return-Path: <linux-kernel-owner+w=401wt.eu-S1754423AbZBCPpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbZBCPpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 10:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbZBCPpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 10:45:40 -0500
Received: from smtp.nokia.com ([192.100.105.134]:65429 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbZBCPpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 10:45:40 -0500
Subject: [BUGFIX take 4] [PATCH] write-back: fix nr_to_write counter
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <49885ABD.2010600@hp.com>
References: <1233655712.24809.101.camel@localhost.localdomain>
	 <1233668461.30906.4.camel@norville.austin.ibm.com>
	 <1233672349.5138.12.camel@localhost.localdomain>  <49885ABD.2010600@hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Feb 2009 17:44:59 +0200
Message-Id: <1233675899.5138.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Feb 2009 15:44:55.0307 (UTC) FILETIME=[5C524DB0:01C98616]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Fix spelling, pointed to by jim owens]

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Mon, 2 Feb 2009 18:33:49 +0200
Subject: [PATCH] write-back: fix nr_to_write counter

Commit 05fe478dd04e02fa230c305ab9b5616669821dd3 introduced some
@wbc->nr_to_write breakage. Here is the change from the commit:

>--- a/mm/page-writeback.c
>+++ b/mm/page-writeback.c
>@@ -963,8 +963,10 @@ retry:
>                               }
>                       }
>
>                       if (--nr_to_write <= 0)
>                               done = 1;
>                       if (wbc->sync_mode == WB_SYNC_NONE) {
>                               if (--wbc->nr_to_write <= 0)
>                                       done = 1;
>                       }
>                       if (wbc->nonblocking && bdi_write_congested(bdi)) {
>                               wbc->encountered_congestion = 1;
>                               done = 1
>                       }

It makes the following changes:
1. Decrement wbc->nr_to_write instead of nr_to_write
2. Decrement wbc->nr_to_write _only_ if wbc->sync_mode == WB_SYNC_NONE
3. If synced nr_to_write pages, stop only if if wbc->sync_mode ==
WB_SYNC_NONE, otherwise keep going.

However, according to the commit message, the intention was to
only make change 3. Change 1 is a bug. Change 2 does not seem to be
necessary, and it breaks UBIFS expectations, so if needed, it
should be done separately later. And change 2 does not seem to
be documented in the commit message.

This patch does the following:
1. Undo changes 1 and 2
2. Add a comment explaining change 3 (it very useful to have comments in
_code_, not only in the commit).

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/page-writeback.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index b493db7..dc32dae 100644
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
+				 * dirty pages, but have not synced all of the
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

