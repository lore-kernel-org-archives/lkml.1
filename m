Return-Path: <linux-kernel-owner+w=401wt.eu-S1751648AbZKKGPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbZKKGPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 01:15:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbZKKGPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 01:15:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:24209 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbZKKGPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 01:15:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,721,1249282800"; 
   d="scan'208";a="568461661"
Date: Wed, 11 Nov 2009 14:15:16 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com
Subject: [PATCH]cfq-iosched: make nonrot check logic consistent
Message-ID: <20091111061516.GA19748@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cfq_arm_slice_timer() has logic to disable idle window for SSD device. The same
thing should be done at cfq_select_queue() too, otherwise we will still see
idle window. This makes the nonrot check logic consistent in cfq.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/cfq-iosched.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2009-11-11 13:44:00.000000000 +0800
+++ linux/block/cfq-iosched.c	2009-11-11 13:45:33.000000000 +0800
@@ -1215,7 +1215,8 @@ static struct cfq_queue *cfq_select_queu
 	 * conditions to happen (or time out) before selecting a new queue.
 	 */
 	if (timer_pending(&cfqd->idle_slice_timer) ||
-	    (cfqq->dispatched && cfq_cfqq_idle_window(cfqq))) {
+	    (cfqq->dispatched && cfq_cfqq_idle_window(cfqq)
+	    && !(blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag))) {
 		cfqq = NULL;
 		goto keep_queue;
 	}
