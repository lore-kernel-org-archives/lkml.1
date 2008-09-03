Return-Path: <linux-kernel-owner+w=401wt.eu-S1752136AbYICEBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbYICEBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 00:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750728AbYICEBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 00:01:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707AbYICEBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 00:01:00 -0400
Date: Tue, 2 Sep 2008 21:00:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Alok Kataria <akataria@vmware.com>,
       Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] Fix TSC calibration issues
In-Reply-To: <48BDFBB6.3010106@lwfinger.net>
Message-ID: <alpine.LFD.1.10.0809022056270.3259@nehalem.linux-foundation.org>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020835150.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809020759480.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809021918450.3243@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0809021120120.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809022358370.3243@apollo.tec.linutronix.de> <48BDFBB6.3010106@lwfinger.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Sep 2008, Larry Finger wrote:
> 
> I know that Linus has some problems with this patch, but FWIW it worked on my
> K6. The dmesg output is
> 
> TSC: PIT calibration deviates from PMTIMER: 428809 214401.
> TSC: Using PIT calibration value
> Detected 428.809 MHz processor.

I don't have a problem with what the patch _does_ (I think all the added 
sanity checking is good).

I just don't like how it makes the already rather complex and confusing 
function about ten times _more_ complex and confusing. It needs splitting 
up.

But we can split it up after-the-fact as well as before-the-fact.

Does this cleanup-patch (on _top_ of Thomas' patch) also work for you? It 
should do exactly the same thing, except it splits up the TSC PIT 
calibration into a function of its own.

But I may obviously have introduced some silly bug when cleaning it up, 
so testing necessary..

		Linus

---
 arch/x86/kernel/tsc.c |  132 ++++++++++++++++++++++++++----------------------
 1 files changed, 71 insertions(+), 61 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index ac79bd1..346cae5 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -122,15 +122,75 @@ static u64 tsc_read_refs(u64 *pm, u64 *hpet)
 	return ULLONG_MAX;
 }
 
+/*
+ * Try to calibrate the TSC against the Programmable
+ * Interrupt Timer and return the frequency of the TSC
+ * in kHz.
+ *
+ * Return ULONG_MAX on failure to calibrate.
+ */
+static unsigned long pit_calibrate_tsc(void)
+{
+	u64 tsc, t1, t2, delta;
+	unsigned long tscmin, tscmax;
+	int pitcnt;
+
+	/* Set the Gate high, disable speaker */
+	outb((inb(0x61) & ~0x02) | 0x01, 0x61);
+
+	/*
+	 * Setup CTC channel 2* for mode 0, (interrupt on terminal
+	 * count mode), binary count. Set the latch register to 50ms
+	 * (LSB then MSB) to begin countdown.
+	 */
+	outb(0xb0, 0x43);
+	outb((CLOCK_TICK_RATE / (1000 / 50)) & 0xff, 0x42);
+	outb((CLOCK_TICK_RATE / (1000 / 50)) >> 8, 0x42);
+
+	tsc = t1 = t2 = get_cycles();
+
+	pitcnt = 0;
+	tscmax = 0;
+	tscmin = ULONG_MAX;
+	while ((inb(0x61) & 0x20) == 0) {
+		t2 = get_cycles();
+		delta = t2 - tsc;
+		tsc = t2;
+		if ((unsigned long) delta < tscmin)
+			tscmin = (unsigned int) delta;
+		if ((unsigned long) delta > tscmax)
+			tscmax = (unsigned int) delta;
+		pitcnt++;
+	}
+
+	/*
+	 * Sanity checks:
+	 *
+	 * If we were not able to read the PIT more than 5000
+	 * times, then we have been hit by a massive SMI
+	 *
+	 * If the maximum is 10 times larger than the minimum,
+	 * then we got hit by an SMI as well.
+	 */
+	if (pitcnt < 5000 || tscmax > 10 * tscmin)
+		return ULONG_MAX;
+
+	/* Calculate the PIT value */
+	delta = t2 - t1;
+	do_div(delta, 50);
+	return delta;
+}
+
+
 /**
  * native_calibrate_tsc - calibrate the tsc on boot
  */
 unsigned long native_calibrate_tsc(void)
 {
-	u64 tsc1, tsc2, tr1, tr2, tsc, delta, pm1, pm2, hpet1, hpet2;
+	u64 tsc1, tsc2, delta, pm1, pm2, hpet1, hpet2;
 	unsigned long tsc_pit_min = ULONG_MAX, tsc_ref_min = ULONG_MAX;
-	unsigned long flags, tscmin, tscmax;
-	int hpet = is_hpet_enabled(), pitcnt, i;
+	unsigned long flags;
+	int hpet = is_hpet_enabled(), i;
 
 	/*
 	 * Run 5 calibration loops to get the lowest frequency value
@@ -157,72 +217,22 @@ unsigned long native_calibrate_tsc(void)
 	 * amount of time anyway.
 	 */
 	for (i = 0; i < 5; i++) {
-
-		tscmin = ULONG_MAX;
-		tscmax = 0;
-		pitcnt = 0;
-
-		local_irq_save(flags);
+		unsigned long tsc_pit_khz;
 
 		/*
 		 * Read the start value and the reference count of
-		 * hpet/pmtimer when available:
+		 * hpet/pmtimer when available. Then do the PIT
+		 * calibration, which will take at least 50ms, and
+		 * read the end value.
 		 */
+		local_irq_save(flags);
 		tsc1 = tsc_read_refs(&pm1, hpet ? &hpet1 : NULL);
-
-		/* Set the Gate high, disable speaker */
-		outb((inb(0x61) & ~0x02) | 0x01, 0x61);
-
-		/*
-		 * Setup CTC channel 2* for mode 0, (interrupt on terminal
-		 * count mode), binary count. Set the latch register to 50ms
-		 * (LSB then MSB) to begin countdown.
-		 *
-		 * Some devices need a delay here.
-		 */
-		outb(0xb0, 0x43);
-		outb((CLOCK_TICK_RATE / (1000 / 50)) & 0xff, 0x42);
-		outb((CLOCK_TICK_RATE / (1000 / 50)) >> 8, 0x42);
-
-		tsc = tr1 = tr2 = get_cycles();
-
-		while ((inb(0x61) & 0x20) == 0) {
-			tr2 = get_cycles();
-			delta = tr2 - tsc;
-			tsc = tr2;
-			if ((unsigned int) delta < tscmin)
-				tscmin = (unsigned int) delta;
-			if ((unsigned int) delta > tscmax)
-				tscmax = (unsigned int) delta;
-			pitcnt++;
-		}
-
-		/*
-		 * We waited at least 50ms above. Now read
-		 * pmtimer/hpet reference again
-		 */
+		tsc_pit_khz = pit_calibrate_tsc();
 		tsc2 = tsc_read_refs(&pm2, hpet ? &hpet2 : NULL);
-
 		local_irq_restore(flags);
 
-		/*
-		 * Sanity checks:
-		 *
-		 * If we were not able to read the PIT more than 5000
-		 * times, then we have been hit by a massive SMI
-		 *
-		 * If the maximum is 10 times larger than the minimum,
-		 * then we got hit by an SMI as well.
-		 */
-		if (pitcnt > 5000 && tscmax < 10 * tscmin) {
-
-			/* Calculate the PIT value */
-			delta = tr2 - tr1;
-			do_div(delta, 50);
-
-			/* We take the smallest value into account */
-			tsc_pit_min = min(tsc_pit_min, (unsigned long) delta);
-		}
+		/* Pick the lowest PIT TSC calibration so far */
+		tsc_pit_min = min(tsc_pit_min, tsc_pit_khz);
 
 		/* hpet or pmtimer available ? */
 		if (!hpet && !pm1 && !pm2)
