Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbYIDBOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbYIDBOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 21:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbYIDBOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 21:14:46 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:43563 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377AbYIDBOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 21:14:45 -0400
Subject: Re: [PATCH] Fix TSC calibration issues
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Michael Buesch <mb@bu3sch.de>, Dan Hecht <dhecht@vmware.com>
In-Reply-To: <alpine.LFD.1.10.0809031103090.3243@apollo.tec.linutronix.de>
References: <48BB2116.1060904@lwfinger.net>
	 <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de>
	 <48BC2A03.9000104@lwfinger.net>
	 <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809020835150.3243@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0809020759480.3210@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809021918450.3243@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0809021120120.3210@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809022358370.3243@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0809021906250.3259@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809031103090.3243@apollo.tec.linutronix.de>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 03 Sep 2008 18:14:44 -0700
Message-Id: <1220490884.22734.83.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-03 at 02:11 -0700, Thomas Gleixner wrote:
> On Tue, 2 Sep 2008, Linus Torvalds wrote:
> > This is "wrongish".
> >
> > You really should do the
> >
> >       tsc1 = tsc_read_refs(&pm1, hpet ? &hpet1 : NULL);
> >       ...
> >       tsc2 = tsc_read_refs(&pm2, hpet ? &hpet2 : NULL);
> >
> > around the whole loop, because they get more exact with more time inside,
> > and they don't improve from looping around.
> 
> True. Just kept them at the place where my debug patches had left them.

Hi Thomas, 

I agree with Linus that we should move the tsc_read_refs call outside of
the loop. I did those changes and ran some boot-halt tests at my end.
The frequency calibration against the pmtimer/hpet was surely more fine
tuned with this change, the variance that i see now in repeated reboots
is very minimal.

Please have a look at the patch below. 

--
x86: Fine tune TSC calibration.

From: Alok N Kataria <akataria@vmware.com>

As Linus suggested, we should be moving the tsc_read_refs outside of the
loop, this gives us more accurate TSC calibration when calibrating against
hpet/pmtimer, since we are now calibrating over a period of 250ms.


With SMI_THRESHOLD equals to 50000, in the worst case, tsc values read by
tsc_read_refs, could be off by 50000 ticks. On a 2Ghz processor this would
mean an error of 25us. The tsc frequency is calibrated over a period of 250ms
with this patch, hence the worst case error would be around 100ppm down from
500ppm previously without the patch.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
---

 arch/x86/kernel/tsc.c |   54 ++++++++++++++++++++++++++-----------------------
 1 files changed, 29 insertions(+), 25 deletions(-)


diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 346cae5..bc2c1a2 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -188,7 +188,7 @@ static unsigned long pit_calibrate_tsc(void)
 unsigned long native_calibrate_tsc(void)
 {
 	u64 tsc1, tsc2, delta, pm1, pm2, hpet1, hpet2;
-	unsigned long tsc_pit_min = ULONG_MAX, tsc_ref_min = ULONG_MAX;
+	unsigned long tsc_pit_min = ULONG_MAX, tsc_ref = ULONG_MAX;
 	unsigned long flags;
 	int hpet = is_hpet_enabled(), i;
 
@@ -216,31 +216,35 @@ unsigned long native_calibrate_tsc(void)
 	 * calibration delay loop as we have to wait for a certain
 	 * amount of time anyway.
 	 */
+
+	local_irq_save(flags);
+
+	/*
+	 * Read the start value and the reference count of
+	 * hpet/pmtimer when available. Then do the PIT
+	 * calibration iteratively, which will take at least 250ms,
+	 * and read the end value.
+	 */
+	tsc1 = tsc_read_refs(&pm1, hpet ? &hpet1 : NULL);
+
 	for (i = 0; i < 5; i++) {
 		unsigned long tsc_pit_khz;
 
-		/*
-		 * Read the start value and the reference count of
-		 * hpet/pmtimer when available. Then do the PIT
-		 * calibration, which will take at least 50ms, and
-		 * read the end value.
-		 */
-		local_irq_save(flags);
-		tsc1 = tsc_read_refs(&pm1, hpet ? &hpet1 : NULL);
 		tsc_pit_khz = pit_calibrate_tsc();
-		tsc2 = tsc_read_refs(&pm2, hpet ? &hpet2 : NULL);
-		local_irq_restore(flags);
 
 		/* Pick the lowest PIT TSC calibration so far */
 		tsc_pit_min = min(tsc_pit_min, tsc_pit_khz);
 
-		/* hpet or pmtimer available ? */
-		if (!hpet && !pm1 && !pm2)
-			continue;
+	}
+
+	tsc2 = tsc_read_refs(&pm2, hpet ? &hpet2 : NULL);
+	local_irq_restore(flags);
 
-		/* Check, whether the sampling was disturbed by an SMI */
-		if (tsc1 == ULLONG_MAX || tsc2 == ULLONG_MAX)
-			continue;
+	/*
+	 * Check that, either HPET or PM timer is available and,
+	 * the sampling was not disturbed by an SMI.
+	 */
+	if ((hpet || pm1) && (tsc1 != ULLONG_MAX && tsc2 != ULLONG_MAX)) {
 
 		tsc2 = (tsc2 - tsc1) * 1000000LL;
 
@@ -259,7 +263,7 @@ unsigned long native_calibrate_tsc(void)
 		}
 
 		do_div(tsc2, tsc1);
-		tsc_ref_min = min(tsc_ref_min, (unsigned long) tsc2);
+		tsc_ref = tsc2;
 	}
 
 	/*
@@ -277,7 +281,7 @@ unsigned long native_calibrate_tsc(void)
 		}
 
 		/* The alternative source failed as well, disable TSC */
-		if (tsc_ref_min == ULONG_MAX) {
+		if (tsc_ref == ULONG_MAX) {
 			printk(KERN_WARNING "TSC: HPET/PMTIMER calibration "
 			       "failed due to SMI disturbance.\n");
 			return 0;
@@ -287,7 +291,7 @@ unsigned long native_calibrate_tsc(void)
 		printk(KERN_INFO "TSC: using %s reference calibration\n",
 		       hpet ? "HPET" : "PMTIMER");
 
-		return tsc_ref_min;
+		return tsc_ref;
 	}
 
 	/* We don't have an alternative source, use the PIT calibration value */
@@ -297,7 +301,7 @@ unsigned long native_calibrate_tsc(void)
 	}
 
 	/* The alternative source failed, use the PIT calibration value */
-	if (tsc_ref_min == ULONG_MAX) {
+	if (tsc_ref == ULONG_MAX) {
 		printk(KERN_WARNING "TSC: HPET/PMTIMER calibration failed due "
 		       "to SMI disturbance. Using PIT calibration\n");
 		return tsc_pit_min;
@@ -305,7 +309,7 @@ unsigned long native_calibrate_tsc(void)
 
 	/* Check the reference deviation */
 	delta = ((u64) tsc_pit_min) * 100;
-	do_div(delta, tsc_ref_min);
+	do_div(delta, tsc_ref);
 
 	/*
 	 * If both calibration results are inside a 5% window, the we
@@ -316,13 +320,13 @@ unsigned long native_calibrate_tsc(void)
 		printk(KERN_INFO "TSC: PIT calibration confirmed by %s.\n",
 		       hpet ? "HPET" : "PMTIMER");
 		printk(KERN_INFO "TSC: using %s calibration value\n",
-		       tsc_pit_min <= tsc_ref_min ? "PIT" :
+		       tsc_pit_min <= tsc_ref ? "PIT" :
 		       hpet ? "HPET" : "PMTIMER");
-		return tsc_pit_min <= tsc_ref_min ? tsc_pit_min : tsc_ref_min;
+		return tsc_pit_min <= tsc_ref ? tsc_pit_min : tsc_ref;
 	}
 
 	printk(KERN_WARNING "TSC: PIT calibration deviates from %s: %lu %lu.\n",
-	       hpet ? "HPET" : "PMTIMER", tsc_pit_min, tsc_ref_min);
+	       hpet ? "HPET" : "PMTIMER", tsc_pit_min, tsc_ref);
 
 	/*
 	 * The calibration values differ too much. In doubt, we use


