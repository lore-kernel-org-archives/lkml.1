Return-Path: <linux-kernel-owner+w=401wt.eu-S933367AbZKXQCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367AbZKXQCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758187AbZKXQB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:01:58 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55999 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758186AbZKXQB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:01:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=l+Ze3pEtzM40JiaUs1haTSQaSDZaY+T9GUfYs45yCUDO+vjp6ywJzrOSUvp9Tq8tt5
         NQ8TZswPz+p1xo9KEPhDoHXcCzZNYg4qMfXmyMqycekEz2+ko3OIrHdDYekX41Oc6W9V
         3m3OgGlB38lIKFXN5F5MJlvyohTtFE6QrkiVg=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] cfq-iosched: cleanup unreachable code
Date: Tue, 24 Nov 2009 17:01:49 +0100
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911241701.49677.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cfq_should_idle returns false for no-idle queues that are not the last,
so the control flow will never reach the removed code in a state that
satisfies the if condition.
The unreachable code was added to emulate previous cfq behaviour for
non-NCQ rotational devices. My tests show that even without it, the
performances and fairness are comparable with previous cfq, thanks to
the fact that all seeky queues are grouped together, and that we idle at
the end of the tree.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index d44f8a4..7144649 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1274,19 +1274,6 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	cfq_mark_cfqq_wait_request(cfqq);
 
 	sl = cfqd->cfq_slice_idle;
-	/* are we servicing noidle tree, and there are more queues?
-	 * non-rotational or NCQ: no idle
-	 * non-NCQ rotational : very small idle, to allow
-	 *     fair distribution of slice time for a process doing back-to-back
-	 *     seeks.
-	 */
-	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD &&
-	    service_tree_for(cfqd->serving_prio, SYNC_NOIDLE_WORKLOAD, cfqd)
-		->count > 0) {
-		if (blk_queue_nonrot(cfqd->queue) || cfqd->hw_tag)
-			return;
-		sl = min(sl, msecs_to_jiffies(CFQ_MIN_TT));
-	}
 
 	mod_timer(&cfqd->idle_slice_timer, jiffies + sl);
 	cfq_log_cfqq(cfqd, cfqq, "arm_idle: %lu", sl);
-- 
1.6.2.5


