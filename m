Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbZETRUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbZETRUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 13:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbZETRT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 13:19:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:48381 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335AbZETRTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 13:19:55 -0400
Date: Wed, 20 May 2009 17:18:57 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20090520102553.298769743@chello.nl>
References: <20090520102553.298769743@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: Log irq_period changes
Message-ID: <tip-26b119bc811a73bac6ecf95bdf284bf31c7955f0@git.kernel.org>
Git-Commit-ID: 26b119bc811a73bac6ecf95bdf284bf31c7955f0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 20 May 2009 17:18:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26b119bc811a73bac6ecf95bdf284bf31c7955f0
Gitweb:     http://git.kernel.org/tip/26b119bc811a73bac6ecf95bdf284bf31c7955f0
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 20 May 2009 12:21:20 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 20 May 2009 12:43:33 +0200

perf_counter: Log irq_period changes

For the dynamic irq_period code, log whenever we change the period so that
analyzing code can normalize the event flow.

[ Impact: add new feature to allow more precise profiling ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <20090520102553.298769743@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    8 ++++++++
 kernel/perf_counter.c        |   40 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 47 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index c8c1dfc..f612941 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -258,6 +258,14 @@ enum perf_event_type {
 	PERF_EVENT_COMM			= 3,
 
 	/*
+	 * struct {
+	 * 	struct perf_event_header	header;
+	 * 	u64				irq_period;
+	 * };
+	 */
+	PERF_EVENT_PERIOD		= 4,
+
+	/*
 	 * When header.misc & PERF_EVENT_MISC_OVERFLOW the event_type field
 	 * will be PERF_RECORD_*
 	 *
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 64113e6..db02eb1 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1046,7 +1046,9 @@ int perf_counter_task_enable(void)
 	return 0;
 }
 
-void perf_adjust_freq(struct perf_counter_context *ctx)
+static void perf_log_period(struct perf_counter *counter, u64 period);
+
+static void perf_adjust_freq(struct perf_counter_context *ctx)
 {
 	struct perf_counter *counter;
 	u64 irq_period;
@@ -1072,6 +1074,8 @@ void perf_adjust_freq(struct perf_counter_context *ctx)
 		if (!irq_period)
 			irq_period = 1;
 
+		perf_log_period(counter, irq_period);
+
 		counter->hw.irq_period = irq_period;
 		counter->hw.interrupts = 0;
 	}
@@ -2407,6 +2411,40 @@ void perf_counter_munmap(unsigned long addr, unsigned long len,
 }
 
 /*
+ *
+ */
+
+static void perf_log_period(struct perf_counter *counter, u64 period)
+{
+	struct perf_output_handle handle;
+	int ret;
+
+	struct {
+		struct perf_event_header	header;
+		u64				time;
+		u64				period;
+	} freq_event = {
+		.header = {
+			.type = PERF_EVENT_PERIOD,
+			.misc = 0,
+			.size = sizeof(freq_event),
+		},
+		.time = sched_clock(),
+		.period = period,
+	};
+
+	if (counter->hw.irq_period == period)
+		return;
+
+	ret = perf_output_begin(&handle, counter, sizeof(freq_event), 0, 0);
+	if (ret)
+		return;
+
+	perf_output_put(&handle, freq_event);
+	perf_output_end(&handle);
+}
+
+/*
  * Generic counter overflow handling.
  */
 
