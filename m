Return-Path: <linux-kernel-owner+w=401wt.eu-S937801AbXGSNvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937801AbXGSNvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761651AbXGSNsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48586 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932759AbXGSNse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:34 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH for review] [5/48] i386: HPET, check if the counter works
Message-Id: <20070719134833.E28BF14E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Thomas Gleixner <tglx@linutronix.de>

Some systems have a HPET which is not incrementing, which leads to a
complete hang.  Detect it during HPET setup.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/hpet.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

Index: linux/arch/i386/kernel/hpet.c
===================================================================
--- linux.orig/arch/i386/kernel/hpet.c
+++ linux/arch/i386/kernel/hpet.c
@@ -226,7 +226,8 @@ int __init hpet_enable(void)
 {
 	unsigned long id;
 	uint64_t hpet_freq;
-	u64 tmp;
+	u64 tmp, start, now;
+	cycle_t t1;
 
 	if (!is_hpet_capable())
 		return 0;
@@ -273,6 +274,27 @@ int __init hpet_enable(void)
 	/* Start the counter */
 	hpet_start_counter();
 
+	/* Verify whether hpet counter works */
+	t1 = read_hpet();
+	rdtscll(start);
+
+	/*
+	 * We don't know the TSC frequency yet, but waiting for
+	 * 200000 TSC cycles is safe:
+	 * 4 GHz == 50us
+	 * 1 GHz == 200us
+	 */
+	do {
+		rep_nop();
+		rdtscll(now);
+	} while ((now - start) < 200000UL);
+
+	if (t1 == read_hpet()) {
+		printk(KERN_WARNING
+		       "HPET counter not counting. HPET disabled\n");
+		goto out_nohpet;
+	}
+
 	/* Initialize and register HPET clocksource
 	 *
 	 * hpet period is in femto seconds per cycle
