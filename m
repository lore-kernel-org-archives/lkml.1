Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbZKKAXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbZKKAXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 19:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbZKKAXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 19:23:22 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:40259 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbZKKAXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 19:23:20 -0500
Message-ID: <4AFA03D2.6070701@oracle.com>
Date: Tue, 10 Nov 2009 16:22:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] block: jiffies fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4AFA03F9.0150:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Use HZ-independent calculation of milliseconds.
Add jiffies.h where it was missing since functions or macros
from it are used.

Oh, where has as-iosched.c in linux-next?

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 block/as-iosched.c   |    3 ++-
 block/blk-settings.c |    3 ++-
 block/bsg.c          |    3 ++-
 block/cfq-iosched.c  |    1 +
 4 files changed, 7 insertions(+), 3 deletions(-)

--- lnx-2632-rc6.orig/block/blk-settings.c
+++ lnx-2632-rc6/block/blk-settings.c
@@ -8,6 +8,7 @@
 #include <linux/blkdev.h>
 #include <linux/bootmem.h>	/* for max_pfn/max_low_pfn */
 #include <linux/gcd.h>
+#include <linux/jiffies.h>
 
 #include "blk.h"
 
@@ -141,7 +142,7 @@ void blk_queue_make_request(struct reque
 	q->nr_batching = BLK_BATCH_REQ;
 
 	q->unplug_thresh = 4;		/* hmm */
-	q->unplug_delay = (3 * HZ) / 1000;	/* 3 milliseconds */
+	q->unplug_delay = msecs_to_jiffies(3);	/* 3 milliseconds */
 	if (q->unplug_delay == 0)
 		q->unplug_delay = 1;
 
--- lnx-2632-rc6.orig/block/bsg.c
+++ lnx-2632-rc6/block/bsg.c
@@ -15,6 +15,7 @@
 #include <linux/blkdev.h>
 #include <linux/poll.h>
 #include <linux/cdev.h>
+#include <linux/jiffies.h>
 #include <linux/percpu.h>
 #include <linux/uio.h>
 #include <linux/idr.h>
@@ -197,7 +198,7 @@ static int blk_fill_sgv4_hdr_rq(struct r
 	rq->cmd_len = hdr->request_len;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 
-	rq->timeout = (hdr->timeout * HZ) / 1000;
+	rq->timeout = msecs_to_jiffies(hdr->timeout);
 	if (!rq->timeout)
 		rq->timeout = q->sg_timeout;
 	if (!rq->timeout)
--- lnx-2632-rc6.orig/block/as-iosched.c
+++ lnx-2632-rc6/block/as-iosched.c
@@ -10,6 +10,7 @@
 #include <linux/blkdev.h>
 #include <linux/elevator.h>
 #include <linux/bio.h>
+#include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
@@ -600,7 +601,7 @@ static int as_close_req(struct as_data *
 
 	if (delay == 0)
 		delta = 8192;
-	else if (delay <= (20 * HZ / 1000) && delay <= ad->antic_expire)
+	else if (delay <= msecs_to_jiffies(20) && delay <= ad->antic_expire)
 		delta = 8192 << delay;
 	else
 		return 1;
--- lnx-2632-rc6.orig/block/cfq-iosched.c
+++ lnx-2632-rc6/block/cfq-iosched.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/blkdev.h>
 #include <linux/elevator.h>
+#include <linux/jiffies.h>
 #include <linux/rbtree.h>
 #include <linux/ioprio.h>
 #include <linux/blktrace_api.h>
