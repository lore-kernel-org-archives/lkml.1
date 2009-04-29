Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbZD2Kv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbZD2Kv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbZD2KvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:51:01 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:35486
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753836AbZD2Ku7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:50:59 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KIUZGP-03-8M3-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 01/29] x86: perfcounter: remove X86_FEATURE_ARCH_PERFMON flag for AMD cpus
Date: Wed, 29 Apr 2009 12:46:58 +0200
Message-ID: <1241002046-8832-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 10:50:49.0008 (UTC) FILETIME=[5B6B8300:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X86_FEATURE_ARCH_PERFMON is an Intel hardware feature that does not
work on AMD CPUs. The flag is now only used in Intel specific code
(especially initialization).

Signed-off-by: Robert Richter <robert.richter@amd.com>
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
-- 
1.6.1.3


