Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbZJAIKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbZJAIKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755838AbZJAIKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:10:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:38319 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755757AbZJAIKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:10:03 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/19] freezer: don't get over-anxious while waiting
Date: Thu,  1 Oct 2009 17:09:00 +0900
Message-Id: <1254384558-1018-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1254384558-1018-1-git-send-email-tj@kernel.org>
References: <1254384558-1018-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 08:09:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Freezing isn't exactly the most latency sensitive operation and
there's no reason to burn cpu cycles and power waiting for it to
complete.  msleep(10) instead of yield().  This should improve
reliability of emergency hibernation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/power/process.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/power/process.c b/kernel/power/process.c
index cc2e553..9d26a0a 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -41,7 +41,7 @@ static int try_to_freeze_tasks(bool sig_only)
 	do_gettimeofday(&start);
 
 	end_time = jiffies + TIMEOUT;
-	do {
+	while (true) {
 		todo = 0;
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
@@ -62,10 +62,15 @@ static int try_to_freeze_tasks(bool sig_only)
 				todo++;
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
-		yield();			/* Yield is okay here */
-		if (time_after(jiffies, end_time))
+		if (!todo || time_after(jiffies, end_time))
 			break;
-	} while (todo);
+
+		/*
+		 * We need to retry.  There's no reason to be
+		 * over-anxious about it and waste power.
+		 */
+		msleep(10);
+	}
 
 	do_gettimeofday(&end);
 	elapsed_csecs64 = timeval_to_ns(&end) - timeval_to_ns(&start);
-- 
1.6.4.2

