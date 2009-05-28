Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbZE1WRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbZE1WRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 18:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZE1WRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 18:17:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57889 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbZE1WRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 18:17:41 -0400
Date: Thu, 28 May 2009 18:17:41 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20090528221738.13158.58193.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH]: NMI: add Intel processor 0x6f4 to NMI perfctr1 workaround
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expand Intel NMI perfctr1 workaround to include a Core2 processor stepping
(cpuid family-6, model-f, stepping-4). Resolves a situation where the NMI
would not enable on these processors.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index f6c70a1..4ad5199 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -716,11 +716,15 @@ static void probe_nmi_watchdog(void)
 		wd_ops = &k7_wd_ops;
 		break;
 	case X86_VENDOR_INTEL:
-		/*
-		 * Work around Core Duo (Yonah) errata AE49 where perfctr1
-		 * doesn't have a working enable bit.
+		/* Work around where perfctr1 doesn't have a working enable
+		 * bit as described in the following errata:
+		 * AE49 Core Duo and Intel Core Solo 65 nm
+		 * AN49 Intel Pentium Dual-Core
+		 * AF49 Dual-Core Intel Xeon Processor LV
 		 */
-		if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 14) {
+		if ((boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 14) ||
+		    ((boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 15 &&
+		     boot_cpu_data.x86_mask == 4))) {
 			intel_arch_wd_ops.perfctr = MSR_ARCH_PERFMON_PERFCTR0;
 			intel_arch_wd_ops.evntsel = MSR_ARCH_PERFMON_EVENTSEL0;
 		}
