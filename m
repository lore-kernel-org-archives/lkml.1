Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYIDPUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYIDPUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 11:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbYIDPTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 11:19:22 -0400
Received: from www.tglx.de ([62.245.132.106]:56996 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554AbYIDPTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:19:20 -0400
Message-Id: <20080904151249.729279624@linutronix.de>
References: <20080904150339.896115280@linutronix.de>
User-Agent: quilt/0.46-1
Date: Thu, 04 Sep 2008 15:18:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Alok Kataria <akataria@vmware.com>,
       Arjan van de Veen <arjan@infradead.org>
Subject: [RFC patch 3/4] x86: TSC: use one set of reference variables
Content-Disposition: inline; filename=tsc-use-one-set-of-ref-variables.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/tsc.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

Index: linux-2.6/arch/x86/kernel/tsc.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tsc.c
+++ linux-2.6/arch/x86/kernel/tsc.c
@@ -104,7 +104,7 @@ __setup("notsc", notsc_setup);
 /*
  * Read TSC and the reference counters. Take care of SMI disturbance
  */
-static u64 tsc_read_refs(u64 *pm, u64 *hpet)
+static u64 tsc_read_refs(u64 *p, int hpet)
 {
 	u64 t1, t2;
 	int i;
@@ -112,9 +112,9 @@ static u64 tsc_read_refs(u64 *pm, u64 *h
 	for (i = 0; i < MAX_RETRIES; i++) {
 		t1 = get_cycles();
 		if (hpet)
-			*hpet = hpet_readl(HPET_COUNTER) & 0xFFFFFFFF;
+			*p = hpet_readl(HPET_COUNTER) & 0xFFFFFFFF;
 		else
-			*pm = acpi_pm_read_early();
+			*p = acpi_pm_read_early();
 		t2 = get_cycles();
 		if ((t2 - t1) < SMI_TRESHOLD)
 			return t2;
@@ -228,7 +228,7 @@ static unsigned long pit_calibrate_tsc(v
  */
 unsigned long native_calibrate_tsc(void)
 {
-	u64 tsc1, tsc2, delta, pm1, pm2, hpet1, hpet2;
+	u64 tsc1, tsc2, delta, ref1, ref2;
 	unsigned long tsc_pit_min = ULONG_MAX, tsc_ref_min = ULONG_MAX;
 	unsigned long flags;
 	int hpet = is_hpet_enabled(), i;
@@ -267,16 +267,16 @@ unsigned long native_calibrate_tsc(void)
 		 * read the end value.
 		 */
 		local_irq_save(flags);
-		tsc1 = tsc_read_refs(&pm1, hpet ? &hpet1 : NULL);
+		tsc1 = tsc_read_refs(&ref1, hpet);
 		tsc_pit_khz = pit_calibrate_tsc();
-		tsc2 = tsc_read_refs(&pm2, hpet ? &hpet2 : NULL);
+		tsc2 = tsc_read_refs(&ref2, hpet);
 		local_irq_restore(flags);
 
 		/* Pick the lowest PIT TSC calibration so far */
 		tsc_pit_min = min(tsc_pit_min, tsc_pit_khz);
 
 		/* hpet or pmtimer available ? */
-		if (!hpet && !pm1 && !pm2)
+		if (!hpet && !ref1 && !ref2)
 			continue;
 
 		/* Check, whether the sampling was disturbed by an SMI */
@@ -285,9 +285,9 @@ unsigned long native_calibrate_tsc(void)
 
 		tsc2 = (tsc2 - tsc1) * 1000000LL;
 		if (hpet)
-			tsc2 = calc_hpet_ref(tsc2, hpet1, hpet2);
+			tsc2 = calc_hpet_ref(tsc2, ref1, ref2);
 		else
-			tsc2 = calc_pmtimer_ref(tsc2, pm1, pm2);
+			tsc2 = calc_pmtimer_ref(tsc2, ref1, ref2);
 
 		tsc_ref_min = min(tsc_ref_min, (unsigned long) tsc2);
 	}
@@ -300,7 +300,7 @@ unsigned long native_calibrate_tsc(void)
 		printk(KERN_WARNING "TSC: Unable to calibrate against PIT\n");
 
 		/* We don't have an alternative source, disable TSC */
-		if (!hpet && !pm1 && !pm2) {
+		if (!hpet && !ref1 && !ref2) {
 			printk("TSC: No reference (HPET/PMTIMER) available\n");
 			return 0;
 		}
@@ -320,7 +320,7 @@ unsigned long native_calibrate_tsc(void)
 	}
 
 	/* We don't have an alternative source, use the PIT calibration value */
-	if (!hpet && !pm1 && !pm2) {
+	if (!hpet && !ref1 && !ref2) {
 		printk(KERN_INFO "TSC: Using PIT calibration value\n");
 		return tsc_pit_min;
 	}

-- 

