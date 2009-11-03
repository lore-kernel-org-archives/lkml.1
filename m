Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbZKCXo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbZKCXo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbZKCXoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:44:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbZKCXoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:44:23 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 18/20] blkio: arm idle timer even if think time is great then time slice left
Date: Tue,  3 Nov 2009 18:43:55 -0500
Message-Id: <1257291837-6246-19-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Now we plan to wait for a queue to get backlogged before we expire it. So
  we need to arm slice timer even if think time is greater than slice left.
  if process sends next IO early and time slice is left, we will dispatch it
  otherwise we will expire the queue and move on to next queue.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index b7ef953..963659a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1702,15 +1702,6 @@ static bool cfq_arm_slice_timer(struct cfq_data *cfqd, int reset)
 	if (!cic || !atomic_read(&cic->ioc->nr_tasks))
 		return false;
 
-	/*
-	 * If our average think time is larger than the remaining time
-	 * slice, then don't idle. This avoids overrunning the allotted
-	 * time slice.
-	 */
-	if (sample_valid(cic->ttime_samples) &&
-	    (cfqq->slice_end - jiffies < cic->ttime_mean))
-		return false;
-
 	cfq_mark_cfqq_wait_request(cfqq);
 
 	/*
-- 
1.6.2.5

