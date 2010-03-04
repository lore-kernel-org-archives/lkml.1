Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab0CDQti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:49:38 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:43459
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755842Ab0CDQtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:49:35 -0500
X-SpamScore: 0
X-BigFish: VPS0(zba6lz936eMab9bhzz1202hzzz32i87h2a8h6bh43h63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYRO27-02-MPF-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4/9] tsc, x86: use new perfctr reservation functions in tsc code
Date: Thu, 4 Mar 2010 16:22:06 +0100
Message-ID: <1267716131-17908-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
References: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 04 Mar 2010 16:49:14.0145 (UTC) FILETIME=[9F1FC110:01CABBBA]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use reserve_perfctr()/release_perfctr() in tsc code.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/tsc.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index ff98ef2..2cdacae 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -871,7 +871,7 @@ static unsigned long __init calibrate_cpu(void)
 	unsigned long flags;
 
 	for (i = 0; i < 4; i++)
-		if (avail_to_resrv_perfctr_nmi_bit(i))
+		if (reserve_perfctr(i))
 			break;
 	no_ctr_free = (i == 4);
 	if (no_ctr_free) {
@@ -881,8 +881,6 @@ static unsigned long __init calibrate_cpu(void)
 		rdmsrl(MSR_K7_EVNTSEL3, evntsel3);
 		wrmsrl(MSR_K7_EVNTSEL3, 0);
 		rdmsrl(MSR_K7_PERFCTR3, pmc3);
-	} else {
-		reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i);
 	}
 	local_irq_save(flags);
 	/* start measuring cycles, incrementing from 0 */
@@ -900,7 +898,7 @@ static unsigned long __init calibrate_cpu(void)
 		wrmsrl(MSR_K7_PERFCTR3, pmc3);
 		wrmsrl(MSR_K7_EVNTSEL3, evntsel3);
 	} else {
-		release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+		release_perfctr(i);
 	}
 
 	return pmc_now * tsc_khz / (tsc_now - tsc_start);
-- 
1.7.0


