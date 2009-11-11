Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbZKKAXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbZKKAXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 19:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbZKKAXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 19:23:16 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:26992 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbZKKAXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 19:23:15 -0500
Message-ID: <4AFA03BB.90405@oracle.com>
Date: Tue, 10 Nov 2009 16:22:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] block core: use round_jiffies on timer to reduce wakeups
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4AFA03F5.017A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Use round_jiffies() variant to schedule the timer along with
other timer wakeups on the same CPU.

Source file also needs to include jiffies.h since it uses
functions or macros from it.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 block/blk-core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- lnx-2632-rc6.orig/block/blk-core.c
+++ lnx-2632-rc6/block/blk-core.c
@@ -17,6 +17,7 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/highmem.h>
+#include <linux/jiffies.h>
 #include <linux/mm.h>
 #include <linux/kernel_stat.h>
 #include <linux/string.h>
@@ -212,7 +213,8 @@ void blk_plug_device(struct request_queu
 		return;
 
 	if (!queue_flag_test_and_set(QUEUE_FLAG_PLUGGED, q)) {
-		mod_timer(&q->unplug_timer, jiffies + q->unplug_delay);
+		mod_timer(&q->unplug_timer,
+			round_jiffies_up(jiffies + q->unplug_delay));
 		trace_block_plug(q);
 	}
 }
