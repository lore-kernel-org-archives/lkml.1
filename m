Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbZCECw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbZCECw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 21:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZCECwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 21:52:17 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42947 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbZCECwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 21:52:16 -0500
Subject: Re: Linux 2.6.29-rc6
From: john stultz <johnstul@us.ibm.com>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
In-Reply-To: <1236220759.6863.7.camel@localhost.localdomain>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>
	 <49A6F39F.9040801@krogh.cc>
	 <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>
	 <49A6FEE2.90700@krogh.cc>
	 <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>
	 <49A70B24.6090706@krogh.cc>
	 <1235685269.6811.11.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>
	 <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>
	 <1235766936.7402.5.camel@localhost.localdomain> <49ABACA0.3090300@krogh.cc>
	 <1236029277.7756.0.camel@localhost.localdomain> <49ACC853.8070205@krogh.cc>
	 <1236110026.6068.18.camel@localhost> <49AD90E2.7050209@krogh.cc>
	 <1236118969.6068.87.camel@localhost> <49AE9EA4.2080500@krogh.cc>
	 <49AECA3B.5030503@krogh.cc>  <1236193075.3793.63.camel@jstultz-laptop>
	 <1236220759.6863.7.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 18:52:10 -0800
Message-Id: <1236221530.6863.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 18:39 -0800, john stultz wrote:
> On Wed, 2009-03-04 at 10:57 -0800, John Stultz wrote:
> > On Wed, 2009-03-04 at 19:36 +0100, Jesper Krogh wrote:
> > > jk@quad12:~$ python drift-test.py 10.192.96.19
> > > 04 Mar 19:27:10         offset: -0.157696       drift: -693.0 ppm
> > > 04 Mar 19:28:10         offset: -0.195134       drift: -625.098360656 ppm
> > > 04 Mar 19:29:10         offset: -0.232579       drift: -624.595041322 ppm
> > > 04 Mar 19:30:10         offset: -0.270021       drift: -624.408839779 ppm
> > > 04 Mar 19:31:11         offset: -0.307461       drift: -621.727272727 ppm
> > > 04 Mar 19:32:11         offset: -0.344903       drift: -622.185430464 ppm
> > > 04 Mar 19:33:11         offset: -0.382345       drift: -622.491712707 ppm
> > > 04 Mar 19:34:11         offset: -0.419794       drift: -622.727488152 ppm
> > > 04 Mar 19:35:11         offset: -0.457239       drift: -622.89626556 ppm
> > 
> > 
> > Yea, so from this and the settled ntpdc -c kerninfo data before, we can
> > see that the drift is further out then the 500ppm NTP can handle.
> > 
> > So with that at least confirmed, we can focus back on to the fast-pit
> > tsc calibration code.
> > 
> > Ingo, Thomas: I'm missing a bit of the context to that patch, other then
> > just speeding up boot times, was there other rational for moving away
> > from the ACPI PM timer based calibration?
> > 
> > Could we maybe add a quick test that the pit reads actually take the
> > assumed 2us max? Doing this maybe via the HPET/ACPI PM?
> 
> Hey Jesper,
> 
> 	Here's a very-hackish patch to see if the approach I'm considering
> might fix the issue you're hitting. Could you apply it, boot the kernel
> a few times and send me the following segments of the dmesg for each of
> those boots (the example below is from my test box)? 
> 
> tsc delta: 44418024
> ref_freq: 3000100  pit_freq: 3000384
> TSC: Fast PIT calibration matches PMTIMER.
> TSC: PIT calibration matches PMTIMER. 1 loops
> Detected 3000.045 MHz processor.
> 
> I'm trying to see how regular the mis-calculation is, as well as see how
> well the alternate calibration method does to handle this on your
> hardware.
> 
> Its likely the fat pit calibration can be better integrated with the
> other calibration methods, so this probably isn't anything close to what
> the actual fix will look like.
> 
> Ingo, Thomas: On the hardware I'm testing the fast-pit calibration only
> triggers probably 80-90% of the time. About 10-20% of the time, the
> initial check to pit_expect_msb(0xff) fails (count=0), so we may need to
> look more at this approach.

Err. Sorry, hit send before I included the patch.

-john



Not for inclusion.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 599e581..2e16d30 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -317,15 +317,17 @@ static unsigned long quick_pit_calibrate(void)
 
 	if (pit_expect_msb(0xff)) {
 		int i;
-		u64 t1, t2, delta;
+		u64 t1, t2, delta, ref1, ref2;
+		u64 ref_freq = 0, pit_freq = 0;
+		int hpet = is_hpet_enabled();
 		unsigned char expect = 0xfe;
 
-		t1 = get_cycles();
+		t1 = tsc_read_refs(&ref1, hpet);
 		for (i = 0; i < QUICK_PIT_ITERATIONS; i++, expect--) {
 			if (!pit_expect_msb(expect))
 				goto failed;
 		}
-		t2 = get_cycles();
+		t2 = tsc_read_refs(&ref2, hpet);
 
 		/*
 		 * Make sure we can rely on the second TSC timestamp:
@@ -333,6 +335,13 @@ static unsigned long quick_pit_calibrate(void)
 		if (!pit_expect_msb(expect))
 			goto failed;
 
+
+		delta = (t2 - t1);
+		if (hpet)
+			ref_freq = calc_hpet_ref(delta*1000000LL, ref1, ref2);
+		else
+			ref_freq = calc_pmtimer_ref(delta*1000000LL, ref1, ref2);
+
 		/*
 		 * Ok, if we get here, then we've seen the
 		 * MSB of the PIT decrement QUICK_PIT_ITERATIONS
@@ -347,10 +356,32 @@ static unsigned long quick_pit_calibrate(void)
 		 * kHz = (t2 - t1) / (QPI * 256 / PIT_TICK_RATE) / 1000
 		 * kHz = ((t2 - t1) * PIT_TICK_RATE) / (QPI * 256 * 1000)
 		 */
-		delta = (t2 - t1)*PIT_TICK_RATE;
-		do_div(delta, QUICK_PIT_ITERATIONS*256*1000);
+		printk("tsc delta: %lld\n", t2-t1);
+
+		pit_freq = delta *  PIT_TICK_RATE;
+		do_div(pit_freq, QUICK_PIT_ITERATIONS*256*1000);
+
+		printk("ref_freq: %lld  pit_freq: %lld\n", ref_freq, pit_freq);
+
+		/* Check the reference deviation */
+		delta = ((u64) pit_freq) * 100;
+		do_div(delta, ref_freq);
+
+		/*
+		 * If both calibration results are inside a 10% window
+		 * then we can be sure, that the calibration
+		 * succeeded. We break out of the loop right away. We
+		 * use the reference value, as it is more precise.
+		 */
+		if (delta >= 90 && delta <= 110) {
+			printk(KERN_INFO
+			       "TSC: Fast PIT calibration matches %s.\n",
+			       hpet ? "HPET" : "PMTIMER");
+			return ref_freq;
+		}
+
 		printk("Fast TSC calibration using PIT\n");
-		return delta;
+		return pit_freq;
 	}
 failed:
 	return 0;
@@ -375,7 +406,7 @@ unsigned long native_calibrate_tsc(void)
 	local_irq_save(flags);
 	fast_calibrate = quick_pit_calibrate();
 	local_irq_restore(flags);
-	if (fast_calibrate)
+	if (0 && fast_calibrate)
 		return fast_calibrate;
 
 	/*


