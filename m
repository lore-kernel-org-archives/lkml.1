Return-Path: <linux-kernel-owner+w=401wt.eu-S1752887AbZKCXo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbZKCXo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZKCXo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:44:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbZKCXoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:44:55 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 19/20] blkio: Arm slice timer even if there are requests in driver
Date: Tue,  3 Nov 2009 18:43:56 -0500
Message-Id: <1257291837-6246-20-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o To ensure fairness for a group, we need to make sure at the time of expiry
  queue is backlogged and does not get deleted from the service tree. That
  means for sequential workload, wait for next request before expiry.

o Sometimes we dispatch a request from a queue and we do not wait busy on the
  queue because arm_slice_timer() does not arm slice idle timer because it
  thinks there are requests in driver. Further down in select_cfq_queue()
  we expire the cfqq because time slice expired and queue looses its share
  (vtime jump). Hence idle timer even if there are requests in the driver.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 963659a..d609a10 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1690,12 +1690,6 @@ static bool cfq_arm_slice_timer(struct cfq_data *cfqd, int reset)
 		return false;
 
 	/*
-	 * still requests with the driver, don't idle
-	 */
-	if (rq_in_driver(cfqd))
-		return false;
-
-	/*
 	 * task has exited, don't wait
 	 */
 	cic = cfqd->active_cic;
-- 
1.6.2.5

