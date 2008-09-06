Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbYIFUwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbYIFUwu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 16:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYIFUwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 16:52:42 -0400
Received: from www.tglx.de ([62.245.132.106]:40491 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbYIFUwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 16:52:41 -0400
Date: Sat, 6 Sep 2008 22:52:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alok Kataria <akataria@vmware.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Dan Hecht <dhecht@vmware.com>,
       Garrett Smith <garrett@vmware.com>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
In-Reply-To: <alpine.LFD.1.10.0809062233500.3243@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0809062240170.3243@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>  <20080904160036.GA18382@elte.hu>  <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org> 
 <20080904190728.59634020@lxorguk.ukuu.org.uk>  <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org>  <20080904204305.GA29065@elte.hu> <20080904205236.GA3864@elte.hu> 
 <alpine.LFD.1.10.0809041403450.3117@nehalem.linux-foundation.org>  <20080904213350.GA15678@elte.hu> <1220653095.14401.72.camel@alok-dev1> <alpine.LFD.1.10.0809051522410.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809061803470.3243@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0809061328400.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809062233500.3243@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Sep 2008, Thomas Gleixner wrote:
> On Sat, 6 Sep 2008, Linus Torvalds wrote:
> > 
> > On Sat, 6 Sep 2008, Thomas Gleixner wrote:
> > > 
> > > Adding another check after the second get_cycles() makes it reliable:
> > 
> > My original patch actually had that, and Ingo added it to the -tip tree 
> > too (I think), so that should be the one we're discussing anyway. I just 
> > didn't think it would ever trigger in practice, which is why I removed it. 
> > Mea culpa.
> 
> My bad. Did not test that against -tip, just applied it from mail :)
> 
> Just checked. The -tip version still has the expect-- in the for()
> which might lead to stupid results depending on the gcc madness level.

If Alok has the second check in place and is actually worried about
that 288us impact, then we can add the following (untested), which
does not impact the speed of the check.

Against -tip x86/tsc

Thanks,

	tglx
---

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 6dab90f..3bfe083 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -310,8 +310,8 @@ static unsigned long quick_pit_calibrate(void)
 		unsigned char expect = 0xfe;
 
 		t1 = get_cycles();
-		for (i = 0; i < QUICK_PIT_ITERATIONS; i++, expect--) {
-			if (!pit_expect_msb(expect))
+		for (i = 0; i < QUICK_PIT_ITERATIONS; i++) {
+			if (!pit_expect_msb(expect--))
 				goto failed;
 		}
 		t2 = get_cycles();
@@ -319,7 +319,7 @@ static unsigned long quick_pit_calibrate(void)
 		/*
 		 * Make sure we can rely on the second TSC timestamp:
 		 */
-		if (!pit_expect_msb(--expect))
+		if (!pit_expect_msb(expect))
 			goto failed;
 
 		/*
@@ -338,7 +338,6 @@ static unsigned long quick_pit_calibrate(void)
 		 */
 		delta = (t2 - t1)*PIT_TICK_RATE;
 		do_div(delta, QUICK_PIT_ITERATIONS*256*1000);
-		printk("Fast TSC calibration using PIT\n");
 		return delta;
 	}
 failed:
@@ -356,10 +355,42 @@ unsigned long native_calibrate_tsc(void)
 	int hpet = is_hpet_enabled(), i, loopmin;
 
 	local_irq_save(flags);
+	tsc1 = tsc_read_refs(&ref1, hpet);
 	fast_calibrate = quick_pit_calibrate();
+	tsc2 = tsc_read_refs(&ref1, hpet);
 	local_irq_restore(flags);
-	if (fast_calibrate)
-		return fast_calibrate;
+
+	if (fast_calibrate) {
+		/*
+		 * Return the fast_calibrate value when neither hpet
+		 * nor pmtimer are available.
+		 */
+		if (!hpet && !ref1 && !ref2) {
+			printk("Fast TSC calibration using PIT\n");
+			return fast_calibrate;
+		}
+
+		/* Check, whether the sampling was disturbed by an SMI */
+		if (tsc1 == ULLONG_MAX || tsc2 == ULLONG_MAX)
+			goto slowpath;
+
+		tsc2 = (tsc2 - tsc1) * 1000000LL;
+		if (hpet)
+			tsc2 = calc_hpet_ref(tsc2, ref1, ref2);
+		else
+			tsc2 = calc_pmtimer_ref(tsc2, ref1, ref2);
+
+		/* Check the reference deviation */
+		delta = ((u64) fast_calibrate) * 100;
+		do_div(delta, tsc2);
+
+		if (delta >= 90 && delta <= 110) {
+			printk("Fast TSC calibration using PIT\n");
+			return fast_calibrate;
+		}
+	}
+
+slowpath:
 
 	/*
 	 * Run 5 calibration loops to get the lowest frequency value

