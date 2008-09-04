Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbYIDPUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbYIDPUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 11:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYIDPTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 11:19:14 -0400
Received: from www.tglx.de ([62.245.132.106]:56990 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583AbYIDPTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:19:13 -0400
Message-Id: <20080904151249.674596699@linutronix.de>
References: <20080904150339.896115280@linutronix.de>
User-Agent: quilt/0.46-1
Date: Thu, 04 Sep 2008 15:18:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Alok Kataria <akataria@vmware.com>,
       Arjan van de Veen <arjan@infradead.org>
Subject: [RFC patch 2/4] x86: TSC: separate hpet/pmtimer calculation out
Content-Disposition: inline;
	filename=tsc-separate-hpet-pmtimer-calculation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/tsc.c |   56 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 41 insertions(+), 15 deletions(-)

Index: linux-2.6/arch/x86/kernel/tsc.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tsc.c
+++ linux-2.6/arch/x86/kernel/tsc.c
@@ -122,6 +122,43 @@ static u64 tsc_read_refs(u64 *pm, u64 *h
 	return ULLONG_MAX;
 }
 
+/*
+ * Calculate the TSC frequency from HPET reference
+ */
+static unsigned long calc_hpet_ref(u64 deltatsc, u64 hpet1, u64 hpet2)
+{
+	u64 tmp;
+
+	if (hpet2 < hpet1)
+		hpet2 += 0x100000000ULL;
+	hpet2 -= hpet1;
+	tmp = ((u64)hpet2 * hpet_readl(HPET_PERIOD));
+	do_div(tmp, 1000000);
+	do_div(deltatsc, tmp);
+
+	return (unsigned long) deltatsc;
+}
+
+/*
+ * Calculate the TSC frequency from PMTimer reference
+ */
+static unsigned long calc_pmtimer_ref(u64 deltatsc, u64 pm1, u64 pm2)
+{
+	u64 tmp;
+
+	if (!pm1 && !pm2)
+		return ULONG_MAX;
+
+	if (pm2 < pm1)
+		pm2 += (u64)ACPI_PM_OVRRUN;
+	pm2 -= pm1;
+	tmp = pm2 * 1000000000LL;
+	do_div(tmp, PMTMR_TICKS_PER_SEC);
+	do_div(deltatsc, tmp);
+
+	return (unsigned long) deltatsc;
+}
+
 #define CAL_MS		50
 #define CAL_LATCH	(CLOCK_TICK_RATE / (1000 / CAL_MS))
 #define CAL_PIT_LOOPS	5000
@@ -247,22 +284,11 @@ unsigned long native_calibrate_tsc(void)
 			continue;
 
 		tsc2 = (tsc2 - tsc1) * 1000000LL;
+		if (hpet)
+			tsc2 = calc_hpet_ref(tsc2, hpet1, hpet2);
+		else
+			tsc2 = calc_pmtimer_ref(tsc2, pm1, pm2);
 
-		if (hpet) {
-			if (hpet2 < hpet1)
-				hpet2 += 0x100000000ULL;
-			hpet2 -= hpet1;
-			tsc1 = ((u64)hpet2 * hpet_readl(HPET_PERIOD));
-			do_div(tsc1, 1000000);
-		} else {
-			if (pm2 < pm1)
-				pm2 += (u64)ACPI_PM_OVRRUN;
-			pm2 -= pm1;
-			tsc1 = pm2 * 1000000000LL;
-			do_div(tsc1, PMTMR_TICKS_PER_SEC);
-		}
-
-		do_div(tsc2, tsc1);
 		tsc_ref_min = min(tsc_ref_min, (unsigned long) tsc2);
 	}
 

-- 

