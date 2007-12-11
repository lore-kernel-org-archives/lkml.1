Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbXLKGZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbXLKGZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 01:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbXLKGZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 01:25:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:22120 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbXLKGZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 01:25:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,150,1196668800"; 
   d="scan'208";a="431497045"
Subject: Reducing the bdi proporion calculation period to speed up disk
	write
From: zhejiang <zhe.jiang@intel.com>
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 11 Dec 2007 14:25:39 +0800
Message-Id: <1197354339.668.62.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch 04fbfdc14e5f48463820d6b9807daa5e9c92c51f implemented bdi per
device dirty threshold. It works well.
However, the period for proportion calculation may be too large.
For 8G memory, the calc_period_shift() will return 19 as the shift.

When we switch writing operation between different disks, there may be
potential performance issue.

For example, we first write to disk A, then write to disk B.
The proportion for disk B will increase slowly because the denominator
is too large (It's 2^18 + (global_count & counter_mask)).
The disk B will get small dirty page quota for a long time,
it will get blocked frequently though the total dirty page is under the
dirty page limit.

Peter provided a patch to avoid this issue, this patch allow violation
of bdi limits if there is a lot of room on the system.
It looks like:

+if (nr_reclaimable + nr_writeback < (background_thresh +
dirty_thresh) / 2)
+                     break; 

This patch really help to avoid congestion, but if the dirty pages
exceed about 3/4 of the dirty_thresh, congestion still happens if we
write to another disk. 

I think that we can reduce the period to speed up the proportion
adjustment. 

diff -Nur a/page-writeback.c b/page-writeback.c
--- a/page-writeback.c  2007-12-11 13:46:30.000000000 +0800
+++ b/page-writeback.c  2007-12-11 13:47:11.000000000 +0800
@@ -128,10 +128,7 @@
  */
 static int calc_period_shift(void)
 {
-       unsigned long dirty_total;
-
-       dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) /
100;
-       return 2 + ilog2(dirty_total - 1);
+       return 12;
 }


In the 8G memory system, I did some testing with iozone.
I found that reducing the period help to increase the write speed 
when switch to a new disk.


Run  "./iozone -B -i 0 -i 2 -r 4k -s 1000M" twice in the disk B.
Here is the result:

1. With the patch 04fbfdc14e5f48463820d6b9807daa5e9c92c51f
		First	Second
write		78M	173M	
rewrite		112M	203M
randread	1710M	1697M
randwrite	192M	1412M

2. With Peter's patch
write		134M	169M
rewrite		134M	203M
randread	1717M	1705M
randwrite	179M	1412M 

3.Adjust the shift to 12
write		260M	259M
rewrite		240M	246M
randread	1712M	1700M
randwrite	1409M	1409M

4.With Peter's patch and adjust the shift to 12
write 		256M	239M
rewrite		253M	253M
randread	1704M	1716M
randwrite	1414M	1416M


Run  "./iozone -B -i 0 -i 2 -r 4k -s 500M" twice in the disk B.

1. With the patch 04fbfdc14e5f48463820d6b9807daa5e9c92c51f
		First	Second
write		821M	725M	
rewrite		144M	1299M
randread	1740M	1733M
randwrite	1444M	1440M

2. With Peter's patch
write		1100M	1112M
rewrite		1295M	1313M
randread	1745M	1744M
randwrite	1452M	1449M 

3.Adjust the shift to 12
write		1021M	1104M
rewrite		1314M	1311M
randread	1741M	1737M
randwrite	1448M	1445M

4.With Peter's patch and adjust the shift to 12
write 		1104M	1105M
rewrite		1292M	1308M
randread	1737M	1741M
randwrite	1449M	1449M
