Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab0CJNWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:22:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:57555 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756574Ab0CJNV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:21:59 -0500
Date: Wed, 10 Mar 2010 13:21:28 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100305154128.966563424@chello.nl>
References: <20100305154128.966563424@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/pebs] perf, x86: Clear the LBRs on init
Message-ID: <tip-74846d35b24b6efd61bb88a0a750b6bb257e6e78@git.kernel.org>
Git-Commit-ID: 74846d35b24b6efd61bb88a0a750b6bb257e6e78
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:21:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74846d35b24b6efd61bb88a0a750b6bb257e6e78
Gitweb:     http://git.kernel.org/tip/74846d35b24b6efd61bb88a0a750b6bb257e6e78
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 5 Mar 2010 13:49:35 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:23:35 +0100

perf, x86: Clear the LBRs on init

Some CPUs have errata where the LBR is not cleared on Power-On. So always
clear the LBRs before use.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
LKML-Reference: <20100305154128.966563424@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c     |   18 ++++++++++++++++--
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |    3 +++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 224c952..c135ed7 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -767,6 +767,20 @@ static __initconst struct x86_pmu core_pmu = {
 	.event_constraints	= intel_core_event_constraints,
 };
 
+static void intel_pmu_cpu_starting(int cpu)
+{
+	init_debug_store_on_cpu(cpu);
+	/*
+	 * Deal with CPUs that don't clear their LBRs on power-up.
+	 */
+	intel_pmu_lbr_reset();
+}
+
+static void intel_pmu_cpu_dying(int cpu)
+{
+	fini_debug_store_on_cpu(cpu);
+}
+
 static __initconst struct x86_pmu intel_pmu = {
 	.name			= "Intel",
 	.handle_irq		= intel_pmu_handle_irq,
@@ -788,8 +802,8 @@ static __initconst struct x86_pmu intel_pmu = {
 	.max_period		= (1ULL << 31) - 1,
 	.get_event_constraints	= intel_get_event_constraints,
 
-	.cpu_starting		= init_debug_store_on_cpu,
-	.cpu_dying		= fini_debug_store_on_cpu,
+	.cpu_starting		= intel_pmu_cpu_starting,
+	.cpu_dying		= intel_pmu_cpu_dying,
 };
 
 static void intel_clovertown_quirks(void)
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 4f3a124..dcec765 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -53,6 +53,9 @@ static void intel_pmu_lbr_reset_64(void)
 
 static void intel_pmu_lbr_reset(void)
 {
+	if (!x86_pmu.lbr_nr)
+		return;
+
 	if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_32)
 		intel_pmu_lbr_reset_32();
 	else
