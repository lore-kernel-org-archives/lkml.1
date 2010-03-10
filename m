Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab0CJMbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 07:31:15 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:38082 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab0CJMbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 07:31:14 -0500
Message-ID: <4B979104.6010907@linux.vnet.ibm.com>
Date: Wed, 10 Mar 2010 13:31:00 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>, Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [RFC PATCH] Fix Readahead stalling by plugged device queues
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few days ago by checking out some blktrace logs I got from a SLES10
and a SLES11 based systems I realized that readahead might get stalled
in newer kernels. "Newer" meaning upstream git kernels as well.

The following RFC patch applies cleanly to everything between 2.6.32
and git head I tested so far.

I don't know if unplugging on any readahead is too aggressive, but
it was intended for theory verification in the first place.
Check out the improvements described below  - I think it is
definitely worth a discussion or two :-)

--- patch ---

Subject: [PATCH] readahead: unplug backing device to lower latencies

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

This unplugs the backing device we just submitted a readahead to.

It should be save as in low utilized environments it is a huge win
by avoiding latencies in making the readahead available early and
on high load systems the queue is unplugged being drained&filled
concurrently anyway where unplugging is a almost a nop.

On the win side we have huge throughput increases especially in
sequential read loads with <4 processes (4 = unplug threshhold).

Without this patch these scenarios get stalled by plugging, here
some blktrace data.

Old pattern:
 8,208  3       25     0.028152940 29226  Q   R 173880 + 1024 [iozone]
 8,208  3       26     0.028153378 29226  G   R 173880 + 1024 [iozone]
 8,208  3       27     0.028155690 29226  P   N [iozone]
 8,208  3       28     0.028155909 29226  I   R 173880 + 1024 (    2531) [iozone]
 8,208  3       30     0.028621723 29226  Q   R 174904 + 1024 [iozone]
 8,208  3       31     0.028623941 29226  M   R 174904 + 1024 [iozone]
 8,208  3       32     0.028624535 29226  U   N [iozone] 1
 8,208  3       33     0.028625035 29226  D   R 173880 + 2048 (  469126) [iozone]
 8,208  1       26     0.032984442     0  C   R 173880 + 2048 ( 4359407) [0]

New pattern:
 8,209  2       63     0.014241032 18361  Q   R 152360 + 1024 [iozone]
 8,209  2       64     0.014241657 18361  G   R 152360 + 1024 [iozone]
 8,209  2       65     0.014243750 18361  P   N [iozone]
 8,209  2       66     0.014243844 18361  I   R 152360 + 1024 (    2187) [iozone]
 8,209  2       67     0.014244438 18361  U   N [iozone] 2
 8,209  2       68     0.014244844 18361  D   R 152360 + 1024 (    1000) [iozone]
 8,209  1        1     0.016682532     0  C   R 151336 + 1024 ( 3111375) [0]

We already had such a good pattern in the past e.g. in 2.6.27
based kernels, but I didn't find any explicit piece of code that
was removed - maybe it was not intentionally, but just a side
effect in those older kernels.

As the effectiveness of readahead is directly related to its
latency (meaning is it available once the application wants to
read it) the effect of this to application throughput is quite
impressive.
Here some numbers from parallel iozone sequential reads with
one disk per process.

#Processes TP Improvement in %
 1         68.8%
 2         58.4% 
 4         51.9%
 8         37.3%
16         16.2%
32         -0.1%
64          0.3%

This is a low (256m) memory environment and so in the high
parallel cases the readahead scales down properly.
I expect that the benefit of this patch would be visible in
loads >16 threads too with more memory available
(measurements ongoing).

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
---

[diffstat]
 readahead.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

[diff]
Index: linux/mm/readahead.c
===================================================================
--- linux.orig/mm/readahead.c
+++ linux/mm/readahead.c
@@ -188,8 +188,11 @@ __do_page_cache_readahead(struct address
 	 * uptodate then the caller will launch readpage again, and
 	 * will then handle the error.
 	 */
-	if (ret)
+	if (ret) {
 		read_pages(mapping, filp, &page_pool, ret);
+		/* unplug backing dev to avoid latencies */
+		blk_run_address_space(mapping);
+	}
 	BUG_ON(!list_empty(&page_pool));
 out:
 	return ret;



-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance 
