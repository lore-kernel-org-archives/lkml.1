Return-Path: <linux-kernel-owner+w=401wt.eu-S1758877AbZIQSHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbZIQSHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbZIQSHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:07:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:44918 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbZIQSHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:07:52 -0400
Date: Thu, 17 Sep 2009 18:07:23 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf_counter: Do not throttle single swcounter events
Message-ID: <tip-584f7ccaaf27eb67ad137d867518db5c53286304@git.kernel.org>
Git-Commit-ID: 584f7ccaaf27eb67ad137d867518db5c53286304
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 18:07:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  584f7ccaaf27eb67ad137d867518db5c53286304
Gitweb:     http://git.kernel.org/tip/584f7ccaaf27eb67ad137d867518db5c53286304
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 17 Sep 2009 18:47:11 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 17 Sep 2009 20:02:46 +0200

perf_counter: Do not throttle single swcounter events

We can have swcounter events that contribute more than a single
count per event, when used with a non-zero period, those can
generate multiple events, which is when we need throttling.

However, swcounter that contribute only a single count per event
can only come as fast as we can run code, hence don't throttle
them.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 667ab25..fe0d1ad 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3494,14 +3494,15 @@ static void perf_log_throttle(struct perf_counter *counter, int enable)
  * Generic counter overflow handling, sampling.
  */
 
-int perf_counter_overflow(struct perf_counter *counter, int nmi,
-			  struct perf_sample_data *data)
+static int __perf_counter_overflow(struct perf_counter *counter, int nmi,
+				   int throttle, struct perf_sample_data *data)
 {
 	int events = atomic_read(&counter->event_limit);
-	int throttle = counter->pmu->unthrottle != NULL;
 	struct hw_perf_counter *hwc = &counter->hw;
 	int ret = 0;
 
+	throttle = (throttle && counter->pmu->unthrottle != NULL);
+
 	if (!throttle) {
 		hwc->interrupts++;
 	} else {
@@ -3554,6 +3555,12 @@ int perf_counter_overflow(struct perf_counter *counter, int nmi,
 	return ret;
 }
 
+int perf_counter_overflow(struct perf_counter *counter, int nmi,
+			  struct perf_sample_data *data)
+{
+	return __perf_counter_overflow(counter, nmi, 1, data);
+}
+
 /*
  * Generic software counter infrastructure
  */
@@ -3592,6 +3599,7 @@ static void perf_swcounter_overflow(struct perf_counter *counter,
 				    int nmi, struct perf_sample_data *data)
 {
 	struct hw_perf_counter *hwc = &counter->hw;
+	int throttle = 0;
 	u64 overflow;
 
 	data->period = counter->hw.last_period;
@@ -3601,13 +3609,14 @@ static void perf_swcounter_overflow(struct perf_counter *counter,
 		return;
 
 	for (; overflow; overflow--) {
-		if (perf_counter_overflow(counter, nmi, data)) {
+		if (__perf_counter_overflow(counter, nmi, throttle, data)) {
 			/*
 			 * We inhibit the overflow from happening when
 			 * hwc->interrupts == MAX_INTERRUPTS.
 			 */
 			break;
 		}
+		throttle = 0;
 	}
 }
 
