Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZLCDx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZLCDx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 22:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbZLCDx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 22:53:26 -0500
Received: from mga14.intel.com ([143.182.124.37]:18121 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbZLCDxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 22:53:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="218237349"
Date: Thu, 3 Dec 2009 11:53:30 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, akpm@linux-foundation.org
Subject: [RFC]cfq-iosched: no dispatch limit for single queue
Message-ID: <20091203035330.GB13165@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 2f5cb7381b737e24c8046fd4aeab571fb71315f5, each queue can send
up to 4 * 4 requests if only one queue exists. I wonder why we have such limit.
Device supports tag can send more requests. For example, AHCI can send 31
requests. Test (direct aio randread) shows the limits reduce about 4% disk
thoughput.
On the other hand, since we send one request one time, if other queue
pop when current is sending more than cfq_quantum requests, current queue will
stop send requests soon after one request, so sounds there is no big latency.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index aa1e953..e05650f 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1298,9 +1298,9 @@ static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 			return false;
 
 		/*
-		 * Sole queue user, allow bigger slice
+		 * Sole queue user, no limit
 		 */
-		max_dispatch *= 4;
+		max_dispatch = -1;
 	}
 
 	/*
