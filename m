Return-Path: <linux-kernel-owner+w=401wt.eu-S1765870AbXGSKHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765870AbXGSKHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbXGSJz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33068 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbXGSJzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:12 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: B.Steinbrink@gmx.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [21/58] i386: Reserve the right performance counter for the Intel PerfMon NMI watchdog
Message-Id: <20070719095506.52E3214E06@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: [** iso-8859-1 charset **] BjörnSteinbrink <B.Steinbrink@gmx.de>

The Intel PerfMon NMI watchdog was using the generic reservation
function which always reserves the first performance counter. But the
watchdog actually uses the second performance counter, thus we need a
specialised function.

Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/cpu/perfctr-watchdog.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

Index: linux/arch/i386/kernel/cpu/perfctr-watchdog.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/perfctr-watchdog.c
+++ linux/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -593,9 +593,27 @@ static int setup_intel_arch_watchdog(uns
 	return 1;
 }
 
+static int intel_arch_reserve(void)
+{
+	if (!reserve_perfctr_nmi(MSR_ARCH_PERFMON_PERFCTR1))
+		return 0;
+
+	if (!reserve_evntsel_nmi(MSR_ARCH_PERFMON_EVENTSEL1)) {
+		release_perfctr_nmi(MSR_ARCH_PERFMON_PERFCTR1);
+		return 0;
+	}
+	return 1;
+}
+
+static void intel_arch_unreserve(void)
+{
+	release_evntsel_nmi(MSR_ARCH_PERFMON_EVENTSEL1);
+	release_perfctr_nmi(MSR_ARCH_PERFMON_PERFCTR1);
+}
+
 static struct wd_ops intel_arch_wd_ops = {
-	.reserve = single_msr_reserve,
-	.unreserve = single_msr_unreserve,
+	.reserve = intel_arch_reserve,
+	.unreserve = intel_arch_unreserve,
 	.setup = setup_intel_arch_watchdog,
 	.rearm = p6_rearm,
 	.stop = single_msr_stop_watchdog,
