Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab0CDQvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:51:17 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:14491 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab0CDQth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:49:37 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh2a8h87h66h)
X-Spam-TCS-SCL: 5:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYRO25-01-NBL-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/9] perf, x86: reduce number of CONFIG_X86_LOCAL_APIC macros
Date: Thu, 4 Mar 2010 16:22:03 +0100
Message-ID: <1267716131-17908-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
References: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 04 Mar 2010 16:49:14.0035 (UTC) FILETIME=[9F0EF830:01CABBBA]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
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
index 6531b4b..96b3a98 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -234,9 +234,10 @@ again:
 static atomic_t active_events;
 static DEFINE_MUTEX(pmc_reserve_mutex);
 
+#ifdef CONFIG_X86_LOCAL_APIC
+
 static bool reserve_pmc_hardware(void)
 {
-#ifdef CONFIG_X86_LOCAL_APIC
 	int i;
 
 	if (nmi_watchdog == NMI_LOCAL_APIC)
@@ -251,11 +252,9 @@ static bool reserve_pmc_hardware(void)
 		if (!reserve_evntsel_nmi(x86_pmu.eventsel + i))
 			goto eventsel_fail;
 	}
-#endif
 
 	return true;
 
-#ifdef CONFIG_X86_LOCAL_APIC
 eventsel_fail:
 	for (i--; i >= 0; i--)
 		release_evntsel_nmi(x86_pmu.eventsel + i);
@@ -270,12 +269,10 @@ perfctr_fail:
 		enable_lapic_nmi_watchdog();
 
 	return false;
-#endif
 }
 
 static void release_pmc_hardware(void)
 {
-#ifdef CONFIG_X86_LOCAL_APIC
 	int i;
 
 	for (i = 0; i < x86_pmu.num_events; i++) {
@@ -285,9 +282,15 @@ static void release_pmc_hardware(void)
 
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
1.7.0


