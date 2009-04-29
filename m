Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473AbZD2NEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbZD2NEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZD2NEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:04:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:44447 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbZD2NEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:04:13 -0400
Date: Wed, 29 Apr 2009 13:03:30 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-2-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-2-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter, x86: remove X86_FEATURE_ARCH_PERFMON flag for AMD cpus
Message-ID: <tip-da1a776be1ac7f78bb30ececbec4c1383163b079@git.kernel.org>
Git-Commit-ID: da1a776be1ac7f78bb30ececbec4c1383163b079
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:03:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da1a776be1ac7f78bb30ececbec4c1383163b079
Gitweb:     http://git.kernel.org/tip/da1a776be1ac7f78bb30ececbec4c1383163b079
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:46:58 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:00 +0200

perf_counter, x86: remove X86_FEATURE_ARCH_PERFMON flag for AMD cpus

X86_FEATURE_ARCH_PERFMON is an Intel hardware feature that does not
work on AMD CPUs. The flag is now only used in Intel specific code
(especially initialization).

[ Impact: refactor code ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1241002046-8832-2-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/amd.c          |    4 ----
 arch/x86/kernel/cpu/perf_counter.c |    6 +++---
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index fd69c51..7e4a459 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -420,10 +420,6 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	if (c->x86 >= 6)
 		set_cpu_cap(c, X86_FEATURE_FXSAVE_LEAK);
 
-	/* Enable Performance counter for K7 and later */
-	if (c->x86 > 6 && c->x86 <= 0x11)
-		set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);
-
 	if (!c->x86_model_id[0]) {
 		switch (c->x86) {
 		case 0xf:
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 0fcbaab..7d0f81d 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -949,6 +949,9 @@ static struct pmc_x86_ops *pmc_intel_init(void)
 	unsigned int unused;
 	unsigned int ebx;
 
+	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
+		return NULL;
+
 	/*
 	 * Check whether the Architectural PerfMon supports
 	 * Branch Misses Retired Event or not.
@@ -987,9 +990,6 @@ static struct pmc_x86_ops *pmc_amd_init(void)
 
 void __init init_hw_perf_counters(void)
 {
-	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
-		return;
-
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_INTEL:
 		pmc_ops = pmc_intel_init();
