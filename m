Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960Ab0AMHop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab0AMHop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 02:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864Ab0AMHoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 02:44:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:50696 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab0AMHoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 02:44:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,265,1262592000"; 
   d="scan'208";a="763784163"
Date: Wed, 13 Jan 2010 15:44:42 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, jmoyer@redhat.com, vgoyal@redhat.com,
       guijianfeng@cn.fujitsu.com, yanmin_zhang@linux.intel.com
Subject: [PATCH]cfq-iosched: don't stop async queue with async requests
 pending
Message-ID: <20100113074442.GA10492@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My SSD speed of direct write is about 80m/s, while I test page writeback,
the speed can only go to 68m/s. Below patch fixes this.
It appears we missused cfq_should_idle in cfq_may_dispatch. cfq_should_idle
means a queue should idle because it's seekless sync queue or it's the last queue,
which is to maintain service tree time slice. So it doesn't mean the
last queue is always a sync queue. If the last queue is asyn queue,
we definitely shouldn't stop dispatch requests because of pending async
requests.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 918c7fd..8198079 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2222,7 +2222,8 @@ static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	/*
 	 * Drain async requests before we start sync IO
 	 */
-	if (cfq_should_idle(cfqd, cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC])
+	if (cfq_cfqq_sync(cfqq) && cfq_should_idle(cfqd, cfqq)
+		&& cfqd->rq_in_driver[BLK_RW_ASYNC])
 		return false;
 
 	/*
