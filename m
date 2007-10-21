Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbXJUUT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbXJUUT6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 16:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbXJUUTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 16:19:51 -0400
Received: from smtp.nokia.com ([131.228.20.172]:55011 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbXJUUTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 16:19:50 -0400
Message-ID: <471BB45D.8070509@nokia.com>
Date: Sun, 21 Oct 2007 23:19:41 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: forcing write-back from FS - again
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 21 Oct 2007 20:19:42.0170 (UTC) FILETIME=[B6B1B3A0:01C8141F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

some time ago we were talking about doing write-back from inside a file-system 
(http://marc.info/?l=linux-kernel&m=119097117713616&w=2). You said that I'm not 
the only person who needs this, because the same thing is needed for delayed 
allocation.

The problem is that if we initiate write-back from prepare_write() and we are 
having a dirty page lock, we deadlock in write_cache_pages() which tries to 
lock the same page.

You suggested to enhance struct writeback_control and put page that should be 
skipped.

I tried something like

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -61,6 +61,7 @@ struct writeback_control {
         unsigned for_reclaim:1;         /* Invoked from the page allocator */
         unsigned for_writepages:1;      /* This is a writepages() call */
         unsigned range_cyclic:1;        /* range_start is cyclic */
+       struct page *skip_pg;           /* do not write this page back */

         void *fs_private;               /* For use by ->writepages() */
  };

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -641,6 +641,9 @@ retry:
                 for (i = 0; i < nr_pages; i++) {
                         struct page *page = pvec.pages[i];

+                       if (unlikely(page == wbc->skip_pg))
+                               continue;
+
                         /*
                          * At this point we hold neither mapping->tree_lock nor
                          * lock on the page itself: the page may be truncated

but it does not dot actually work, because if we have two processes forcing 
write-back from write_page(), they will mutually deadlock (A waits in 
write_cache_pages() on a page B has locked, B waits on inode or page A has locked).

So this way is not ok, do you have any other ideas?

We could mark page clean temporarily before doing write-back, and mark it dirty 
again, but this seems to be inefficient (although I'm not sure, need to dig 
these functions deeper, but they _seem_ to traverse the radix tree and change 
tags, so marking one page dirty may need to change many tags, but again, I did 
not really dig tis yet).

I'd appreciate any suggestions. Thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
