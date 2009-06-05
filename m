Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbZFEQ6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbZFEQ6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 12:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbZFEQ6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 12:58:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:60891 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756211AbZFEQ6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 12:58:33 -0400
Date: Fri, 5 Jun 2009 16:57:57 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Fix frequency adjustment for < HZ
Message-ID: <tip-6a24ed6c6082ec65d19331a4bfa30c0512a1a822@git.kernel.org>
Git-Commit-ID: 6a24ed6c6082ec65d19331a4bfa30c0512a1a822
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 05 Jun 2009 16:57:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6a24ed6c6082ec65d19331a4bfa30c0512a1a822
Gitweb:     http://git.kernel.org/tip/6a24ed6c6082ec65d19331a4bfa30c0512a1a822
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 5 Jun 2009 18:01:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 5 Jun 2009 18:07:48 +0200

perf_counter: Fix frequency adjustment for < HZ

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    3 +++
 kernel/perf_counter.c        |   32 +++++++++++++++++++++++++-------
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 6bc2500..4f9d39e 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -373,6 +373,9 @@ struct hw_perf_counter {
 	u64				sample_period;
 	atomic64_t			period_left;
 	u64				interrupts;
+
+	u64				freq_count;
+	u64				freq_interrupts;
 #endif
 };
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index f839066..47c92fb 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1187,8 +1187,9 @@ static void perf_log_period(struct perf_counter *counter, u64 period);
 static void perf_adjust_freq(struct perf_counter_context *ctx)
 {
 	struct perf_counter *counter;
+	struct hw_perf_counter *hwc;
 	u64 interrupts, sample_period;
-	u64 events, period;
+	u64 events, period, freq;
 	s64 delta;
 
 	spin_lock(&ctx->lock);
@@ -1196,8 +1197,10 @@ static void perf_adjust_freq(struct perf_counter_context *ctx)
 		if (counter->state != PERF_COUNTER_STATE_ACTIVE)
 			continue;
 
-		interrupts = counter->hw.interrupts;
-		counter->hw.interrupts = 0;
+		hwc = &counter->hw;
+
+		interrupts = hwc->interrupts;
+		hwc->interrupts = 0;
 
 		if (interrupts == MAX_INTERRUPTS) {
 			perf_log_throttle(counter, 1);
@@ -1208,20 +1211,35 @@ static void perf_adjust_freq(struct perf_counter_context *ctx)
 		if (!counter->attr.freq || !counter->attr.sample_freq)
 			continue;
 
-		events = HZ * interrupts * counter->hw.sample_period;
+		if (counter->attr.sample_freq < HZ) {
+			freq = counter->attr.sample_freq;
+
+			hwc->freq_count += freq;
+			hwc->freq_interrupts += interrupts;
+
+			if (hwc->freq_count < HZ)
+				continue;
+
+			interrupts = hwc->freq_interrupts;
+			hwc->freq_interrupts = 0;
+			hwc->freq_count -= HZ;
+		} else
+			freq = HZ;
+
+		events = freq * interrupts * hwc->sample_period;
 		period = div64_u64(events, counter->attr.sample_freq);
 
-		delta = (s64)(1 + period - counter->hw.sample_period);
+		delta = (s64)(1 + period - hwc->sample_period);
 		delta >>= 1;
 
-		sample_period = counter->hw.sample_period + delta;
+		sample_period = hwc->sample_period + delta;
 
 		if (!sample_period)
 			sample_period = 1;
 
 		perf_log_period(counter, sample_period);
 
-		counter->hw.sample_period = sample_period;
+		hwc->sample_period = sample_period;
 	}
 	spin_unlock(&ctx->lock);
 }
