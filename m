Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbYICCPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbYICCPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 22:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbYICCPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 22:15:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbYICCPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 22:15:07 -0400
Date: Tue, 2 Sep 2008 19:14:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] Fix TSC calibration issues
In-Reply-To: <alpine.LFD.1.10.0809022358370.3243@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0809021906250.3259@nehalem.linux-foundation.org>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020835150.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809020759480.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809021918450.3243@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0809021120120.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809022358370.3243@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Sep 2008, Thomas Gleixner wrote:
>
> +	/*
> +	 * Run 5 calibration loops to get the lowest frequency value
> +	 * (the best estimate). We use two different calibration modes
> +	 * here:
> +	 *
> +	 * 1) PIT loop. We set the PIT Channel 2 to oneshot mode and
> +	 * load a timeout of 50ms. We read the time right after we
> +	 * started the timer and wait until the PIT count down reaches
> +	 * zero. In each wait loop iteration we read the TSC and check
> +	 * the delta to the previous read. We keep track of the min
> +	 * and max values of that delta. The delta is mostly defined
> +	 * by the IO time of the PIT access, so we can detect when a
> +	 * SMI/SMM disturbance happend between the two reads. If the
> +	 * maximum time is significantly larger than the minimum time,
> +	 * then we discard the result and have another try.
> +	 *
> +	 * 2) Reference counter. If available we use the HPET or the
> +	 * PMTIMER as a reference to check the sanity of that value.
> +	 * We use separate TSC readouts and check inside of the
> +	 * reference read for a SMI/SMM disturbance. We dicard
> +	 * disturbed values here as well. We do that around the PIT
> +	 * calibration delay loop as we have to wait for a certain
> +	 * amount of time anyway.
> +	 */
> +	for (i = 0; i < 5; i++) {
> +		tscmin = ULONG_MAX;
> +		tscmax = 0;
> +		pitcnt = 0;
> +
> +		local_irq_save(flags);
> +
> +		/*
> +		 * Read the start value and the reference count of
> +		 * hpet/pmtimer when available:
> +		 */
> +		tsc1 = tsc_read_refs(&pm1, hpet ? &hpet1 : NULL);

This is "wrongish".

You really should do the

	tsc1 = tsc_read_refs(&pm1, hpet ? &hpet1 : NULL);   
	...
	tsc2 = tsc_read_refs(&pm2, hpet ? &hpet2 : NULL);

around the whole loop, because they get more exact with more time inside, 
and they don't improve from looping around.

Also, that code is already _too_ unreadable. How about starting by just 
moving the PIT calibration into a function of its own, like the appended 
patch. And then as a separate patch, improving the heuristics for just the 
PIT calibration.

The others are independent of this issue..

		Linus

---
 arch/x86/kernel/tsc.c |   37 ++++++++++++++++++++-----------------
 1 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 8e786b0..bf7ff5a 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -122,19 +122,9 @@ static u64 tsc_read_refs(u64 *pm, u64 *hpet)
 	return ULLONG_MAX;
 }
 
-/**
- * native_calibrate_tsc - calibrate the tsc on boot
- */
-unsigned long native_calibrate_tsc(void)
+static unsigned long PIT_calibrate_tsc(void)
 {
-	unsigned long flags;
-	u64 tsc1, tsc2, tr1, tr2, delta, pm1, pm2, hpet1, hpet2;
-	int hpet = is_hpet_enabled();
-	unsigned int tsc_khz_val = 0;
-
-	local_irq_save(flags);
-
-	tsc1 = tsc_read_refs(&pm1, hpet ? &hpet1 : NULL);
+	u64 tr1, tr2, delta;
 
 	outb((inb(0x61) & ~0x02) | 0x01, 0x61);
 
@@ -145,17 +135,30 @@ unsigned long native_calibrate_tsc(void)
 	while ((inb(0x61) & 0x20) == 0);
 	tr2 = get_cycles();
 
-	tsc2 = tsc_read_refs(&pm2, hpet ? &hpet2 : NULL);
-
-	local_irq_restore(flags);
-
 	/*
 	 * Preset the result with the raw and inaccurate PIT
 	 * calibration value
 	 */
 	delta = (tr2 - tr1);
 	do_div(delta, 50);
-	tsc_khz_val = delta;
+	return delta;
+}
+
+/**
+ * native_calibrate_tsc - calibrate the tsc on boot
+ */
+unsigned long native_calibrate_tsc(void)
+{
+	unsigned long flags;
+	u64 tsc1, tsc2, pm1, pm2, hpet1, hpet2;
+	int hpet = is_hpet_enabled();
+	unsigned int tsc_khz_val;
+
+	local_irq_save(flags);
+	tsc1 = tsc_read_refs(&pm1, hpet ? &hpet1 : NULL);
+	tsc_khz_val = PIT_calibrate_tsc();
+	tsc2 = tsc_read_refs(&pm2, hpet ? &hpet2 : NULL);
+	local_irq_restore(flags);
 
 	/* hpet or pmtimer available ? */
 	if (!hpet && !pm1 && !pm2) {
