Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab0CHLs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 06:48:29 -0500
Received: from gir.skynet.ie ([193.1.99.77]:44037 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab0CHLs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 06:48:27 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: linux-mm@kvack.org
Cc: Nick Piggin <npiggin@suse.de>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>
Subject: [RFC PATCH 0/3] Avoid the use of congestion_wait under zone pressure
Date: Mon,  8 Mar 2010 11:48:20 +0000
Message-Id: <1268048904-19397-1-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC'ing some people who were involved in the last discussion on the use of
congestion_wait() in the VM)

Under memory pressure, the page allocator and kswapd can go to sleep using
congestion_wait(). In two of these cases, it may not be the appropriate
action as congestion may not be the problem. This patchset replaces two
sets of instances of congestion_wait() usage with a waitqueue sleep with
the view of having the VM behaviour depend on the relevant state of the
zone instead of on congestion which may or may not be a factor. A third
patch updates the frequency zone pressure is checked.

The first patch addresses the page allocator which calls congestion_wait()
to back off. The patch adds a zone->pressure_wq to sleep on instead of the
congestion queues.. If a direct reclaimer or kswapd brings the zone over
the min watermark, processes on the waitqueue are woken up.

The second patch checks zone pressure when a batch of pages from the PCP lists
are freed. The assumption is that there is a reasonable change if processes
are sleeping that a batch of frees can push a zone above its watermark.

The third patch address kswapd going to sleep when it is raising priority. As
vmscan makes more appropriate checks on congestion elsewhere, this patch
puts kswapd back on its own waitqueue to wait for either a timeout or
another process to call wakeup_kswapd.

The tricky problem is determining if this patch is really doing the right
thing. I took three machines X86, X86-64 and PPC64 booted with 1GB of RAM and
ran a series of tests including sysbench, iozone and a desktop latency test.
The performance results that did not involve memory pressure were fine -
no major impact due to the zone_pressure check in the free path. However,
the sysbench and iozone results varied wildly and depended somewhat on the
starting state of the machine. The objective was to see if the tests completed
faster because less time was needlessly spent waiting on congestion but the
fact is the benchmarks were really IO-bound meant there was little difference
with the patch applied. For the record, there were both massive gains and
losses with the patch applied but it was not consistently reproducible.

I'm somewhat at an impasse to identify a reasonable scenario the patch
can make a real difference to. It might depend on a setup like Christian's
with many disks which I cannot reproduce unfortunately. Otherwise, it's a
case of eyeballing the patch and stating whether it makes sense or not.

Nick, I haven't implemented the
queueing-if-a-process-is-already-waiting-for-fairness yet largely because
a proper way has to be devised to measure how "good" or "bad" this patch is.

Any comments on whether this patch is really doing the right thing or
suggestions on how it should be properly tested? Christian, minimally it
would be nice if you could retest your iozone tests to confirm the symptoms
of your problem are still being dealt with.

 include/linux/mmzone.h |    3 ++
 mm/internal.h          |    4 +++
 mm/mmzone.c            |   47 ++++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c        |   53 +++++++++++++++++++++++++++++++++++++++++++----
 mm/vmscan.c            |   13 ++++++++---
 5 files changed, 111 insertions(+), 9 deletions(-)

