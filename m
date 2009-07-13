Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbZGMJCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbZGMJCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 05:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbZGMJCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 05:02:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:39948 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137AbZGMJCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 05:02:01 -0400
Date: Mon, 13 Jul 2009 09:01:06 GMT
From: tip-bot for Chris Wilson <chris@chris-wilson.co.uk>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, bgamari.foss@gmail.com,
       tglx@linutronix.de, jbaron@redhat.com, chris@chris-wilson.co.uk,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, bgamari.foss@gmail.com, rostedt@goodmis.org,
       jbaron@redhat.com, tglx@linutronix.de, chris@chris-wilson.co.uk,
       mingo@elte.hu
In-Reply-To: <1246869094-21237-1-git-send-email-chris@chris-wilson.co.uk>
References: <1246869094-21237-1-git-send-email-chris@chris-wilson.co.uk>
Subject: [tip:perfcounters/urgent] perf_counter: Fix the tracepoint channel to perfcounters
Message-ID: <tip-d4d7d0b9545721d3cabb19d15163bbc66b797707@git.kernel.org>
Git-Commit-ID: d4d7d0b9545721d3cabb19d15163bbc66b797707
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 13 Jul 2009 09:01:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d4d7d0b9545721d3cabb19d15163bbc66b797707
Gitweb:     http://git.kernel.org/tip/d4d7d0b9545721d3cabb19d15163bbc66b797707
Author:     Chris Wilson <chris@chris-wilson.co.uk>
AuthorDate: Mon, 6 Jul 2009 09:31:33 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 13 Jul 2009 09:23:10 +0200

perf_counter: Fix the tracepoint channel to perfcounters

Fix a missed rename in EVENT_PROFILE support so that it gets
built and allows tracepoint tracing from the 'perf' tool.

Fix a typo in the (never before built & enabled) portion in
perf_counter.c as well, and update that code to the
attr.config changes as well.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ben Gamari <bgamari.foss@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1246869094-21237-1-git-send-email-chris@chris-wilson.co.uk>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 init/Kconfig          |    2 +-
 kernel/perf_counter.c |   10 +++-------
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 1ce05a4..cb2c092 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -962,7 +962,7 @@ config PERF_COUNTERS
 
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
