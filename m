Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbZGLS6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbZGLS6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 14:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbZGLS5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 14:57:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60186 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814AbZGLS5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 14:57:35 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       vgoyal@redhat.com
Subject: [PATCH 2/2] cfq-iosched: Do not disable idling for seeky processes if "fairness" is set
Date: Sun, 12 Jul 2009 14:57:10 -0400
Message-Id: <1247425030-25344-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1247425030-25344-1-git-send-email-vgoyal@redhat.com>
References: <1247425030-25344-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o CFQ provides fair access to disk in terms of disk time used to processes.
  Fairness is provided for the applications which have their think time with
  in slice_idle (8ms default) limit.

o CFQ currently disables idling for seeky processes. So even if a process
  has think time with-in slice_idle limits, it will still not get fair share
  of disk. Disabling idling for a seeky process seems good from throughput
  perspective but not necessarily from fairness perspecitve.

0 Do not disable idling based on seek pattern of process if a user has set
  /sys/block/<disk>/queue/iosched/fairness = 1.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 658ea7b..9de8046 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1964,7 +1964,7 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
 
 	if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
-	    (cfqd->hw_tag && CIC_SEEKY(cic)))
+	    (!cfqd->cfq_fairness && cfqd->hw_tag && CIC_SEEKY(cic)))
 		enable_idle = 0;
 	else if (sample_valid(cic->ttime_samples)) {
 		if (cic->ttime_mean > cfqd->cfq_slice_idle)
-- 
1.6.0.6

