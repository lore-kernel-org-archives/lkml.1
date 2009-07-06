Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbZGFIcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbZGFIcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 04:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757350AbZGFIbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 04:31:42 -0400
Received: from smtp.fireflyuk.net ([78.156.72.235]:1536 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753384AbZGFIbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 04:31:40 -0400
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
       Ben Gamari <bgamari.foss@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] perfcounters: Fix build for tracepoint profiling
Date: Mon,  6 Jul 2009 09:31:33 +0100
Message-Id: <1246869094-21237-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.6.3.3
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 init/Kconfig          |    2 +-
 kernel/perf_counter.c |   10 +++-------
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 0e8784e..13473ac 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -955,7 +955,7 @@ config PERF_COUNTERS
 
 config EVENT_PROFILE
 	bool "Tracepoint profile sources"
-	depends on PERF_COUNTERS && EVENT_TRACER
+	depends on PERF_COUNTERS && EVENT_TRACING
 	default y
 
 endmenu
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d55a50d..c6c38fb 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3671,7 +3671,7 @@ static const struct pmu perf_ops_task_clock = {
 void perf_tpcounter_event(int event_id)
 {
 	struct perf_sample_data data = {
-		.regs = get_irq_regs();
+		.regs = get_irq_regs(),
 		.addr = 0,
 	};
 
@@ -3687,16 +3687,12 @@ extern void ftrace_profile_disable(int);
 
 static void tp_perf_counter_destroy(struct perf_counter *counter)
 {
-	ftrace_profile_disable(perf_event_id(&counter->attr));
+	ftrace_profile_disable(counter->attr.config);
 }
 
 static const struct pmu *tp_perf_counter_init(struct perf_counter *counter)
 {
-	int event_id = perf_event_id(&counter->attr);
-	int ret;
-
-	ret = ftrace_profile_enable(event_id);
-	if (ret)
+	if (ftrace_profile_enable(counter->attr.config))
 		return NULL;
 
 	counter->destroy = tp_perf_counter_destroy;
-- 
1.6.3.3

