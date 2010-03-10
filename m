Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab0CJNYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:24:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:53587 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932118Ab0CJNX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:23:57 -0500
Date: Wed, 10 Mar 2010 13:23:25 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/pebs] perf, x86: Deal with multiple state bits for pebs-fmt1
Message-ID: <tip-12ab854d744f04bfc5c6c4db723b7e31fc03eb29@git.kernel.org>
Git-Commit-ID: 12ab854d744f04bfc5c6c4db723b7e31fc03eb29
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:23:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12ab854d744f04bfc5c6c4db723b7e31fc03eb29
Gitweb:     http://git.kernel.org/tip/12ab854d744f04bfc5c6c4db723b7e31fc03eb29
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 6 Mar 2010 18:57:38 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:23:38 +0100

perf, x86: Deal with multiple state bits for pebs-fmt1

Its unclear if the PEBS state record will have only a single bit set, in
case it does not and accumulates bits, deal with that by only processing
each event once.

Also, robustify some of the code.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 9ad0e67..b4680da 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -538,6 +538,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 	struct perf_event *event = NULL;
 	struct perf_raw_record raw;
 	struct pt_regs regs;
+	u64 status = 0;
 	int bit, n;
 
 	if (!ds || !x86_pmu.pebs)
@@ -561,13 +562,22 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 
 	for ( ; at < top; at++) {
 		for_each_bit(bit, (unsigned long *)&at->status, MAX_PEBS_EVENTS) {
-			if (!cpuc->events[bit]->attr.precise)
+			event = cpuc->events[bit];
+			if (!test_bit(bit, cpuc->active_mask))
 				continue;
 
-			event = cpuc->events[bit];
+			WARN_ON_ONCE(!event);
+
+			if (!event->attr.precise)
+				continue;
+
+			if (__test_and_set_bit(bit, (unsigned long *)&status))
+				continue;
+
+			break;
 		}
 
-		if (!event)
+		if (!event || bit >= MAX_PEBS_EVENTS)
 			continue;
 
 		if (!intel_pmu_save_and_restart(event))
