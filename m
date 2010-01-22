Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647Ab0AVOzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab0AVOzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 09:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280Ab0AVOzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 09:55:14 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:59463
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752377Ab0AVOzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 09:55:11 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzab9bh936eMzz1202hzzz32i6bh87h43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWNLFJ-02-1LE-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@googlemail.com>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 05/12] perf/core, x86: reduce number of CONFIG_X86_LOCAL_APIC macros
Date: Fri, 22 Jan 2010 15:22:00 +0100
Message-ID: <1264170127-17402-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
References: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jan 2010 14:54:55.0393 (UTC) FILETIME=[DC0D8110:01CA9B72]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function reserve_pmc_hardware() and release_pmc_hardware() were
hard to read. This patch improves readablity of the code by removing
most of the CONFIG_X86_LOCAL_APIC macros.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c49221b..5c6244b 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -711,9 +711,10 @@ again:
 static atomic_t active_events;
 static DEFINE_MUTEX(pmc_reserve_mutex);
 
+#ifdef CONFIG_X86_LOCAL_APIC
+
 static bool reserve_pmc_hardware(void)
 {
-#ifdef CONFIG_X86_LOCAL_APIC
 	int i;
 
 	if (nmi_watchdog == NMI_LOCAL_APIC)
@@ -728,11 +729,9 @@ static bool reserve_pmc_hardware(void)
 		if (!reserve_evntsel_nmi(x86_pmu.eventsel + i))
 			goto eventsel_fail;
 	}
-#endif
 
 	return true;
 
-#ifdef CONFIG_X86_LOCAL_APIC
 eventsel_fail:
 	for (i--; i >= 0; i--)
 		release_evntsel_nmi(x86_pmu.eventsel + i);
@@ -747,12 +746,10 @@ perfctr_fail:
 		enable_lapic_nmi_watchdog();
 
 	return false;
-#endif
 }
 
 static void release_pmc_hardware(void)
 {
-#ifdef CONFIG_X86_LOCAL_APIC
 	int i;
 
 	for (i = 0; i < x86_pmu.num_counters; i++) {
@@ -762,9 +759,15 @@ static void release_pmc_hardware(void)
 
 	if (nmi_watchdog == NMI_LOCAL_APIC)
 		enable_lapic_nmi_watchdog();
-#endif
 }
 
+#else
+
+static bool reserve_pmc_hardware(void) { return true; }
+static void release_pmc_hardware(void) {}
+
+#endif
+
 static inline bool bts_available(void)
 {
 	return x86_pmu.enable_bts != NULL;
-- 
1.6.6


