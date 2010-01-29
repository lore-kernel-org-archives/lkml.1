Return-Path: <linux-kernel-owner+w=401wt.eu-S1751144Ab0A2J2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751144Ab0A2J2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756409Ab0A2J2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:28:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:57385 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756122Ab0A2J1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:27:35 -0500
Date: Fri, 29 Jan 2010 09:27:02 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100122155535.411197266@chello.nl>
References: <20100122155535.411197266@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_event: x86: Allocate the fake_cpuc
Message-ID: <tip-502568d563bcc37ac505a83341c0c95b88c015a8@git.kernel.org>
Git-Commit-ID: 502568d563bcc37ac505a83341c0c95b88c015a8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:27:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  502568d563bcc37ac505a83341c0c95b88c015a8
Gitweb:     http://git.kernel.org/tip/502568d563bcc37ac505a83341c0c95b88c015a8
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 22 Jan 2010 14:35:46 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Jan 2010 09:01:35 +0100

perf_event: x86: Allocate the fake_cpuc

GCC was complaining the stack usage was too large, so allocate the
structure.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <20100122155535.411197266@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   29 +++++++++++++++++++----------
 1 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 0bd23d0..7bd359a 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2606,10 +2606,13 @@ static const struct pmu pmu = {
 static int validate_group(struct perf_event *event)
 {
 	struct perf_event *leader = event->group_leader;
-	struct cpu_hw_events fake_cpuc;
-	int n;
+	struct cpu_hw_events *fake_cpuc;
+	int ret, n;
 
-	memset(&fake_cpuc, 0, sizeof(fake_cpuc));
+	ret = -ENOMEM;
+	fake_cpuc = kmalloc(sizeof(*fake_cpuc), GFP_KERNEL | __GFP_ZERO);
+	if (!fake_cpuc)
+		goto out;
 
 	/*
 	 * the event is not yet connected with its
@@ -2617,18 +2620,24 @@ static int validate_group(struct perf_event *event)
 	 * existing siblings, then add the new event
 	 * before we can simulate the scheduling
 	 */
-	n = collect_events(&fake_cpuc, leader, true);
+	ret = -ENOSPC;
+	n = collect_events(fake_cpuc, leader, true);
 	if (n < 0)
-		return -ENOSPC;
+		goto out_free;
 
-	fake_cpuc.n_events = n;
-	n = collect_events(&fake_cpuc, event, false);
+	fake_cpuc->n_events = n;
+	n = collect_events(fake_cpuc, event, false);
 	if (n < 0)
-		return -ENOSPC;
+		goto out_free;
 
-	fake_cpuc.n_events = n;
+	fake_cpuc->n_events = n;
 
-	return x86_schedule_events(&fake_cpuc, n, NULL);
+	ret = x86_schedule_events(fake_cpuc, n, NULL);
+
+out_free:
+	kfree(fake_cpuc);
+out:
+	return ret;
 }
 
 const struct pmu *hw_perf_event_init(struct perf_event *event)
