Return-Path: <linux-kernel-owner+w=401wt.eu-S1758949AbZJMG0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949AbZJMG0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 02:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758916AbZJMG0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 02:26:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:33900 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758848AbZJMG0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 02:26:06 -0400
Date: Tue, 13 Oct 2009 06:24:45 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       eranian@gmail.com, fweisbec@gmail.com, tglx@linutronix.de,
       sfr@canb.auug.org.au, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       eranian@gmail.com, fweisbec@gmail.com, tglx@linutronix.de,
       sfr@canb.auug.org.au, mingo@elte.hu
In-Reply-To: <20091013144223.369d616d.sfr@canb.auug.org.au>
References: <20091013144223.369d616d.sfr@canb.auug.org.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events, x86: Fix event constraints code
Message-ID: <tip-7a693d3f0d10f978ebdf3082c41404ab97106567@git.kernel.org>
Git-Commit-ID: 7a693d3f0d10f978ebdf3082c41404ab97106567
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Oct 2009 06:24:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a693d3f0d10f978ebdf3082c41404ab97106567
Gitweb:     http://git.kernel.org/tip/7a693d3f0d10f978ebdf3082c41404ab97106567
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 13 Oct 2009 08:16:30 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 13 Oct 2009 08:19:53 +0200

perf_events, x86: Fix event constraints code

There was namespace overlap due to a rename i did - this caused
the following build warning, reported by Stephen Rothwell against
linux-next x86_64 allmodconfig:

  arch/x86/kernel/cpu/perf_event.c: In function 'intel_get_event_idx':
  arch/x86/kernel/cpu/perf_event.c:1445: warning: 'event_constraint' is used uninitialized in this function

This is a real bug not just a warning: fix it by renaming the
global event-constraints table pointer to 'event_constraints'.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Stephane Eranian <eranian@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091013144223.369d616d.sfr@canb.auug.org.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 9961d84..2e20bca 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -124,7 +124,7 @@ static DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
 	.enabled = 1,
 };
 
-static const struct event_constraint *event_constraint;
+static const struct event_constraint *event_constraints;
 
 /*
  * Not sure about some of these
@@ -1442,12 +1442,12 @@ intel_get_event_idx(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc)
 	const struct event_constraint *event_constraint;
 	int i, code;
 
-	if (!event_constraint)
+	if (!event_constraints)
 		goto skip;
 
 	code = hwc->config & CORE_EVNTSEL_EVENT_MASK;
 
-	for_each_event_constraint(event_constraint, event_constraint) {
+	for_each_event_constraint(event_constraint, event_constraints) {
 		if (code == event_constraint->code) {
 			for_each_bit(i, event_constraint->idxmsk, X86_PMC_IDX_MAX) {
 				if (!test_and_set_bit(i, cpuc->used_mask))
@@ -2047,12 +2047,12 @@ static int p6_pmu_init(void)
 	case 7:
 	case 8:
 	case 11: /* Pentium III */
-		event_constraint = intel_p6_event_constraints;
+		event_constraints = intel_p6_event_constraints;
 		break;
 	case 9:
 	case 13:
 		/* Pentium M */
-		event_constraint = intel_p6_event_constraints;
+		event_constraints = intel_p6_event_constraints;
 		break;
 	default:
 		pr_cont("unsupported p6 CPU model %d ",
@@ -2124,14 +2124,14 @@ static int intel_pmu_init(void)
 		       sizeof(hw_cache_event_ids));
 
 		pr_cont("Core2 events, ");
-		event_constraint = intel_core_event_constraints;
+		event_constraints = intel_core_event_constraints;
 		break;
 	default:
 	case 26:
 		memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
-		event_constraint = intel_nehalem_event_constraints;
+		event_constraints = intel_nehalem_event_constraints;
 		pr_cont("Nehalem/Corei7 events, ");
 		break;
 	case 28:
