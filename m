Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab0CBOdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 09:33:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:43271 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab0CBOdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 09:33:15 -0500
Date: Tue, 2 Mar 2010 14:30:50 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Restrict the ANY flag
Message-ID: <tip-320ebf09cbb6d01954c9a060266aa8e0d27f4638@git.kernel.org>
Git-Commit-ID: 320ebf09cbb6d01954c9a060266aa8e0d27f4638
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Mar 2010 14:30:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  320ebf09cbb6d01954c9a060266aa8e0d27f4638
Gitweb:     http://git.kernel.org/tip/320ebf09cbb6d01954c9a060266aa8e0d27f4638
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 2 Mar 2010 12:35:37 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Mar 2010 15:06:46 +0100

perf, x86: Restrict the ANY flag

The ANY flag can show SMT data of another task (like 'top'),
so we want to disable it when system-wide profiling is
disabled.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    3 +++
 include/linux/perf_event.h       |   15 +++++++++++++++
 kernel/perf_event.c              |   15 ---------------
 3 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 6531b4b..aab2e1c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -503,6 +503,9 @@ static int __hw_perf_event_init(struct perf_event *event)
 	 */
 	if (attr->type == PERF_TYPE_RAW) {
 		hwc->config |= x86_pmu.raw_event(attr->config);
+		if ((hwc->config & ARCH_PERFMON_EVENTSEL_ANY) &&
+		    perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		return 0;
 	}
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 04f06b4..90e0521 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -857,6 +857,21 @@ extern int sysctl_perf_event_paranoid;
 extern int sysctl_perf_event_mlock;
 extern int sysctl_perf_event_sample_rate;
 
+static inline bool perf_paranoid_tracepoint_raw(void)
+{
+	return sysctl_perf_event_paranoid > -1;
+}
+
+static inline bool perf_paranoid_cpu(void)
+{
+	return sysctl_perf_event_paranoid > 0;
+}
+
+static inline bool perf_paranoid_kernel(void)
+{
+	return sysctl_perf_event_paranoid > 1;
+}
+
 extern void perf_event_init(void);
 extern void perf_tp_event(int event_id, u64 addr, u64 count, void *record, int entry_size);
 extern void perf_bp_event(struct perf_event *event, void *data);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a661e79..482d5e1 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -56,21 +56,6 @@ static atomic_t nr_task_events __read_mostly;
  */
 int sysctl_perf_event_paranoid __read_mostly = 1;
 
-static inline bool perf_paranoid_tracepoint_raw(void)
-{
-	return sysctl_perf_event_paranoid > -1;
-}
-
-static inline bool perf_paranoid_cpu(void)
-{
-	return sysctl_perf_event_paranoid > 0;
-}
-
-static inline bool perf_paranoid_kernel(void)
-{
-	return sysctl_perf_event_paranoid > 1;
-}
-
 int sysctl_perf_event_mlock __read_mostly = 512; /* 'free' kb per user */
 
 /*
