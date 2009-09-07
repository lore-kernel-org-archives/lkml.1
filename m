Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbZIGOIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbZIGOIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 10:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbZIGOIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 10:08:19 -0400
Received: from smtp.nokia.com ([192.100.105.134]:44273 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbZIGOIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 10:08:18 -0400
Message-ID: <4AA513AA.3010206@nokia.com>
Date: Mon, 07 Sep 2009 17:07:38 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: chris.mason@oracle.com, david@fromorbit.com,
       Andrew Morton <akpm@linux-foundation.org>,
       "Bityutskiy Artem (Nokia-M/Helsinki)" <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] mm: write_cache_pages be more sequential
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Sep 2009 14:07:13.0188 (UTC) FILETIME=[7F73EE40:01CA2FC4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6f3bb7c26936c45d810048f59c369e8d5a5623fc Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Mon, 7 Sep 2009 10:49:11 +0300
Subject: [PATCH] mm: write_cache_pages be more sequential

If a file is written to sequentially, then writeback
should write the pages sequentially also.  However,
that does not always happen.  For example:

1) user writes pages 0, 1 and 2 but 2 is incomplete
2) write_cache_pages writes pages 0, 1 and 2 and sets
writeback_index to 3
3) user finishes writing page 2 and writes pages 3 and 4
4) write_cache_pages writes pages 3 and 4, and then cycles
back and writes page 2 again.

So the pages are written out in the order 0, 1, 2, 3 ,4 ,2
instead of 0, 1, 2, 2, 3, 4.

This situation was noticed on UBIFS because it writes
directly from writepage.  Hence if there is an unexpected
power-loss, a file will end up with a hole even though
the file was written sequentially by the user.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 mm/page-writeback.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 81627eb..7410b7a 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -960,6 +960,8 @@ int write_cache_pages(struct address_space *mapping,
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
 		writeback_index = mapping->writeback_index; /* prev offset */
+		if (writeback_index)
+			writeback_index -= 1;
 		index = writeback_index;
 		if (index == 0)
 			cycled = 1;
-- 
1.5.6.3
