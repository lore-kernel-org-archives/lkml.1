Return-Path: <linux-kernel-owner+w=401wt.eu-S1757730AbZFYTnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbZFYTnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759291AbZFYTn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:43:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:45300 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758739AbZFYTn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:43:27 -0400
Date: Thu, 25 Jun 2009 19:42:58 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf_counter: Add scale information to the mmap control page
Message-ID: <tip-7f8b4e4e0988dadfd22330fd147ad2453e19f510@git.kernel.org>
Git-Commit-ID: 7f8b4e4e0988dadfd22330fd147ad2453e19f510
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 25 Jun 2009 19:42:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f8b4e4e0988dadfd22330fd147ad2453e19f510
Gitweb:     http://git.kernel.org/tip/7f8b4e4e0988dadfd22330fd147ad2453e19f510
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 22 Jun 2009 14:34:35 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Jun 2009 21:39:05 +0200

perf_counter: Add scale information to the mmap control page

Add the needed time scale to the self-profile mmap information.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    4 +++-
 kernel/perf_counter.c        |    6 ++++++
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 489d5cb..bcbf1c4 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -232,12 +232,14 @@ struct perf_counter_mmap_page {
 	__u32	lock;			/* seqlock for synchronization */
 	__u32	index;			/* hardware counter identifier */
 	__s64	offset;			/* add to hardware counter value */
+	__u64	time_enabled;		/* time counter active */
+	__u64	time_running;		/* time counter on cpu */
 
 		/*
 		 * Hole for extension of the self monitor capabilities
 		 */
 
-	__u64	__reserved[125];	/* align to 1k */
+	__u64	__reserved[123];	/* align to 1k */
 
 	/*
 	 * Control data for the mmap() data buffer.
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index c2b19c1..23614ad 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1782,6 +1782,12 @@ void perf_counter_update_userpage(struct perf_counter *counter)
 	if (counter->state == PERF_COUNTER_STATE_ACTIVE)
 		userpg->offset -= atomic64_read(&counter->hw.prev_count);
 
+	userpg->time_enabled = counter->total_time_enabled +
+			atomic64_read(&counter->child_total_time_enabled);
+
+	userpg->time_running = counter->total_time_running +
+			atomic64_read(&counter->child_total_time_running);
+
 	barrier();
 	++userpg->lock;
 	preempt_enable();
