Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbZCOBW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbZCOBW4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 21:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbZCOBWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 21:22:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751462AbZCOBWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 21:22:47 -0400
Date: Sat, 14 Mar 2009 18:19:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesper Krogh <jesper@krogh.cc>
cc: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
In-Reply-To: <49B57F3D.5030008@krogh.cc>
Message-ID: <alpine.LFD.2.00.0903141814180.7421@localhost.localdomain>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>  <49A6F39F.9040801@krogh.cc>  <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>  <49A6FEE2.90700@krogh.cc>  <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com> 
 <49A70B24.6090706@krogh.cc>  <1235685269.6811.11.camel@localhost.localdomain>  <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>  <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>  <1235766936.7402.5.camel@localhost.localdomain>
 <49ABACA0.3090300@krogh.cc>  <1236029277.7756.0.camel@localhost.localdomain> <49ACC853.8070205@krogh.cc>  <1236110026.6068.18.camel@localhost> <49AD90E2.7050209@krogh.cc>  <1236118969.6068.87.camel@localhost> <49AE9EA4.2080500@krogh.cc>  <49AECA3B.5030503@krogh.cc>
  <1236193075.3793.63.camel@jstultz-laptop>  <1236220759.6863.7.camel@localhost.localdomain> <1236221530.6863.9.camel@localhost.localdomain> <49B57F3D.5030008@krogh.cc>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Jesper, here's a patch that actually tries to take teh TSC error really 
into account, and which I suspect will result (on your machine) in failing 
the fast PIT calibration. 

It also has a few extra printk's for debugging, and to see just what the 
values are on your machine.

The idea behind the patch is to just keep track of how big the difference 
was in TSC values between two successive reads of the PIT timer. We only 
really care about the difference when the MSB turns around, and we only 
really care about the two end points. The maximum error in TSC estimation 
will simply be the sum of the differences at those points (d1 and d2).

We can then compare the maximum error with the actual TSC differences 
between those points, and see if the max error is within 500 ppm. That 
_should_ mean that it all works - assuming that the PIT itself is running 
at the correct frequency, of course!

Regardless of whether is succeeds or not, it will print out some debug 
messages, which will be interesting to see.

What's nice about this is that it really should make that whole "yes, it's 
really within 500ppm" assertion have some solid legs to stand on. Rather 
than depend on us being able to read the PIT a certain number of times, we 
can literally give an estimation of the max error.

		Linus

---
 arch/x86/kernel/tsc.c |   41 +++++++++++++++++++++++++++++------------
 1 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 599e581..8e1db42 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -273,17 +273,26 @@ static unsigned long pit_calibrate_tsc(u32 latch, unsigned long ms, int loopmin)
  * use the TSC value at the transitions to calculate a pretty
  * good value for the TSC frequencty.
  */
-static inline int pit_expect_msb(unsigned char val)
+static unsigned long pit_expect_msb(unsigned char val, u64 *tscp, unsigned long *deltap)
 {
-	int count = 0;
+	int count;
+	u64 tsc = 0;
 
 	for (count = 0; count < 50000; count++) {
 		/* Ignore LSB */
 		inb(0x42);
 		if (inb(0x42) != val)
 			break;
+		tsc = get_cycles();
 	}
-	return count > 50;
+	*deltap = get_cycles() - tsc;
+	*tscp = tsc;
+
+	/*
+	 * We require _some_ success, but the quality control
+	 * will be based on the error terms on the TSC values.
+	 */
+	return count > 5;
 }
 
 /*
@@ -297,6 +306,10 @@ static inline int pit_expect_msb(unsigned char val)
 
 static unsigned long quick_pit_calibrate(void)
 {
+	u64 t1, t2;
+	unsigned long d1, d2;
+	unsigned char expect = 0xff;
+
 	/* Set the Gate high, disable speaker */
 	outb((inb(0x61) & ~0x02) | 0x01, 0x61);
 
@@ -315,22 +328,24 @@ static unsigned long quick_pit_calibrate(void)
 	outb(0xff, 0x42);
 	outb(0xff, 0x42);
 
-	if (pit_expect_msb(0xff)) {
+	if (pit_expect_msb(0xff, &t1, &d1)) {
 		int i;
-		u64 t1, t2, delta;
-		unsigned char expect = 0xfe;
+		u64 delta;
 
-		t1 = get_cycles();
+		expect--;
 		for (i = 0; i < QUICK_PIT_ITERATIONS; i++, expect--) {
-			if (!pit_expect_msb(expect))
+			if (!pit_expect_msb(expect, &t2, &d2))
 				goto failed;
 		}
-		t2 = get_cycles();
 
 		/*
-		 * Make sure we can rely on the second TSC timestamp:
+		 * We require the max error on the calibration to be
+		 * within 500 ppm, since that's the limit of ntpd
+		 * drift correction. So the TSC delta must be more
+		 * than 2000x the possible error term (d1+d2).
 		 */
-		if (!pit_expect_msb(expect))
+		delta = t2 - t1;
+		if (d1+d2 > delta >> 11)
 			goto failed;
 
 		/*
@@ -347,12 +362,14 @@ static unsigned long quick_pit_calibrate(void)
 		 * kHz = (t2 - t1) / (QPI * 256 / PIT_TICK_RATE) / 1000
 		 * kHz = ((t2 - t1) * PIT_TICK_RATE) / (QPI * 256 * 1000)
 		 */
-		delta = (t2 - t1)*PIT_TICK_RATE;
+		printk("Fast TSC delta=%lld, error=%lu+%lu=%lu\n", delta, d1, d2, d1+d2);
+		delta *= PIT_TICK_RATE;
 		do_div(delta, QUICK_PIT_ITERATIONS*256*1000);
 		printk("Fast TSC calibration using PIT\n");
 		return delta;
 	}
 failed:
+	printk("Fast TSC calibration failed at %u %llu(%lu) %llu(%lu)\n", expect, t1, d1, t2, d2);
 	return 0;
 }
 
