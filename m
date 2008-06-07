Return-Path: <linux-kernel-owner+w=401wt.eu-S1760601AbYFGBKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601AbYFGBKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760023AbYFGBIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:08:46 -0400
Received: from sous-sol.org ([216.99.217.87]:42248 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760579AbYFGBIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:08:44 -0400
Message-Id: <20080607010610.796754560@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:36 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcin Krol <hawk@pld-linux.org>, Nick Piggin <npiggin@suse.de>
Subject: [patch 21/50] brd: dont show ramdisks in /proc/partitions
Content-Disposition: inline; filename=brd-don-t-show-ramdisks-in-proc-partitions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Marcin Krol <hawk@pld-linux.org>

upstream commit: 53978d0a7a27eb036b9bf33c4caa06257a9dbed7

In 2.6.25, ramdisk devices show up in /proc/partitions, which is a
behaviour change from the old rd.c.  Add GENHD_FL_SUPPRESS_PARTITION_INFO,
which was present in rd.c.

All kernels prior to 2.6.25 weren't displaying ramdisks in
/proc/partitions.  Since there are many userspace tools using information
from /proc/partitions some of them may now behave incorrectly (I didn't
tested any though).  For example before 2.6.25 /proc/partitions was empty
if no block devices like hard disks and such were detected by kernel.  Now
all 16 ramdisks are always visible there.  Some software may rely on such
information (I mean, on empty /proc/partitions).

There was quite similar situation back in 2004, and ramdisks were excluded
back from displaying.  Thats why I called this a regression (maybe a bit
unfortunate).  See this patch for info:
http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.3-rc2/2.6.3-rc2-mm1/broken-out/nbd-proc-partitions-fix.patch

I also think that someone somewhere (long time ago) excluded ramdisks from
/proc/partitions for good reasons.  It is possible that now such new
"feature" is harmless, but I think there are more chances that someone
will say "hey, /proc/partitions has changed, now my software doesn't work"
then "hey where did my new 2.6.25 feature go".  nbd devices are also
excluded, maybe for very same (unknown to me) reasons.

Signed-off-by: Marcin Krol <hawk@pld-linux.org>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/block/brd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -442,6 +442,7 @@ static struct brd_device *brd_alloc(int 
 	disk->fops		= &brd_fops;
 	disk->private_data	= brd;
 	disk->queue		= brd->brd_queue;
+	disk->flags |= GENHD_FL_SUPPRESS_PARTITION_INFO;
 	sprintf(disk->disk_name, "ram%d", i);
 	set_capacity(disk, rd_size * 2);
 

-- 
