Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638Ab0AVQBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab0AVQBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 11:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470Ab0AVP7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 10:59:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:38264 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab0AVP7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 10:59:32 -0500
Message-Id: <20100122155535.411197266@chello.nl>
References: <20100122155044.391857484@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 22 Jan 2010 16:50:47 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@google.com, fweisbec@gmail.com, paulus@samba.org, mingo@elte.hu,
       davem@davemloft.net, robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 03/10] perf_event: x86: Allocate the fake_cpuc
Content-Disposition: inline; filename=perf-alloc-fake-pmu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GCC was complaining the stack usage was too large, so allocate
the structure.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/x86/kernel/cpu/perf_event.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -2614,10 +2614,13 @@ static const struct pmu pmu = {
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
@@ -2625,18 +2628,24 @@ static int validate_group(struct perf_ev
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

-- 

