Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbZLGOjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbZLGOjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 09:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756588AbZLGOjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 09:39:52 -0500
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:41938 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573AbZLGOjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 09:39:51 -0500
Message-ID: <4B1D13B5.9020802@linux.vnet.ibm.com>
Date: Mon, 07 Dec 2009 15:39:49 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>,
       arayananu Gopalakrishnan <narayanan.g@samsung.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com
Subject: Performance regression in scsi sequential throughput (iozone) due
 to "e084b - page-allocator: preserve PFN ordering when __GFP_COLD is set"
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I tracked a huge performance regression for a while and got it bisected 
down to commit "e084b2d95e48b31aa45f9c49ffc6cdae8bdb21d4 - 
page-allocator: preserve PFN ordering when __GFP_COLD is set".

The scenario I'm running is a low memory system (256M total), that does 
sequential I/O with parallel iozone processes.
One process per disk, each process reading a 2Gb file. The disks I use 
are fcp scsi disks attached to a s390 host. File system is ext2.

The regression appears as up to 76% loss in throughput at 16 processes 
(processes are scaled from 1 to 64, performance is bad everywhere - 16 
is just the peak - avg loss is about 40% throughput).
I already know that giving the system just a bit (~64m+) more memory 
solves the issue almost completely, probably because there is almost no 
"memory pressure" left in that cases.
I also know that using direct-I/O instead of I/O through page cache 
doesn't have the problem at all.
Comparing sysstat data taken while running with the kernels just with & 
without the bisected patch shows nothing obvious except that I/O seems 
to take much longer (lower interrupt ratio etc).

The patch alone looks very reasonable, so I'd prefer understanding and 
fixing the real issue instead of getting it eventually reverted due to 
this regression being larger than the one it was intended to fix.
In the patch it is clear that hot pages (cold==0) freed in rmqueue_bulk 
should behave like before. So maybe the question is "are our pages cold 
while they shouldn't be"?
Well I don't really have a clue yet to explain how patch e084b exactly 
causes that big regression, ideas welcome :-)

Kind regards,
Christian


P.S: The original patch is concise enough to attach it here to act as 
reference without bloating the mail too much:
commit e084b2d95e48b31aa45f9c49ffc6cdae8bdb21d4
Author: Mel Gorman <mel@csn.ul.ie>
Date:   Wed Jul 29 15:02:04 2009 -0700

    page-allocator: preserve PFN ordering when __GFP_COLD is set
   
    Fix a post-2.6.24 performace regression caused by
    3dfa5721f12c3d5a441448086bee156887daa961 ("page-allocator: preserve PFN
    ordering when __GFP_COLD is set").
   
    Narayanan reports "The regression is around 15%.  There is no disk 
controller
    as our setup is based on Samsung OneNAND used as a memory mapped 
device on a
    OMAP2430 based board."
   
    The page allocator tries to preserve contiguous PFN ordering when 
returning
    pages such that repeated callers to the allocator have a strong 
chance of
    getting physically contiguous pages, particularly when external 
fragmentation
    is low.  However, of the bulk of the allocations have __GFP_COLD set 
as they
    are due to aio_read() for example, then the PFNs are in reverse PFN 
order.
    This can cause performance degration when used with IO controllers 
that could
    have merged the requests.
   
    This patch attempts to preserve the contiguous ordering of PFNs for 
users of
    __GFP_COLD.
   
    Signed-off-by: Mel Gorman <mel@csn.ul.ie>
    Reported-by: Narayananu Gopalakrishnan <narayanan.g@samsung.com>
    Tested-by: Narayanan Gopalakrishnan <narayanan.g@samsung.com>
    Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
    Cc: <stable@kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index caa9268..ae28c22 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -882,7 +882,7 @@ retry_reserve:
  */
 static int rmqueue_bulk(struct zone *zone, unsigned int order,
             unsigned long count, struct list_head *list,
-            int migratetype)
+            int migratetype, int cold)
 {
     int i;
    
@@ -901,7 +901,10 @@ static int rmqueue_bulk(struct zone *zone, unsigned 
int order,
          * merge IO requests if the physical pages are ordered
          * properly.
          */
-        list_add(&page->lru, list);
+        if (likely(cold == 0))
+            list_add(&page->lru, list);
+        else
+            list_add_tail(&page->lru, list);
         set_page_private(page, migratetype);
         list = &page->lru;
     }
@@ -1119,7 +1122,8 @@ again:
         local_irq_save(flags);
         if (!pcp->count) {
             pcp->count = rmqueue_bulk(zone, 0,
-                    pcp->batch, &pcp->list, migratetype);
+                    pcp->batch, &pcp->list,
+                    migratetype, cold);
             if (unlikely(!pcp->count))
                 goto failed;
         }
@@ -1138,7 +1142,8 @@ again:
         /* Allocate more to the pcp list if necessary */
         if (unlikely(&page->lru == &pcp->list)) {
             pcp->count += rmqueue_bulk(zone, 0,
-                    pcp->batch, &pcp->list, migratetype);
+                    pcp->batch, &pcp->list,
+                    migratetype, cold);
             page = list_entry(pcp->list.next, struct page, lru);
         }
 


-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, Open Virtualization

