Return-Path: <linux-kernel-owner+w=401wt.eu-S1761371AbZCPTgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761371AbZCPTgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 15:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbZCPTfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 15:35:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754494AbZCPTfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 15:35:52 -0400
Date: Mon, 16 Mar 2009 12:32:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesper Krogh <jesper@krogh.cc>
cc: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.29-rc6
In-Reply-To: <49BEA1AD.1090901@krogh.cc>
Message-ID: <alpine.LFD.2.00.0903161225210.3675@localhost.localdomain>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>  <49A6FEE2.90700@krogh.cc>  <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>  <49A70B24.6090706@krogh.cc>  <1235685269.6811.11.camel@localhost.localdomain> 
 <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>  <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>  <1235766936.7402.5.camel@localhost.localdomain> <49AE9EA4.2080500@krogh.cc>  <49AECA3B.5030503@krogh.cc> 
 <1236193075.3793.63.camel@jstultz-laptop>  <1236220759.6863.7.camel@localhost.localdomain> <1236221530.6863.9.camel@localhost.localdomain> <49B57F3D.5030008@krogh.cc> <alpine.LFD.2.00.0903141814180.7421@localhost.localdomain> <49BD225C.4070305@krogh.cc>
 <alpine.LFD.2.00.0903151050070.3131@localhost.localdomain> <49BD4B2D.7000501@krogh.cc> <alpine.LFD.2.00.0903151146550.3131@localhost.localdomain> <49BD5C7C.2060605@krogh.cc> <49BEA1AD.1090901@krogh.cc>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 16 Mar 2009, Jesper Krogh wrote:
> 
> you were right. It works. No resets so far.

Goodie.

Here's a slightly cleaned-up patch that removes the debug messages, and 
also re-organizes the code a bit so that it actually uses the "better than 
500 ppm" as the way to decide when to stop calibrating.

Why?

I tested the 500 ppm check on some slower machines, and the old algorithm 
of just waiting for 15ms actually failed that 500 ppm test. It was _very_ 
close - 16ms was enough - but it convinced me that the logic was too damn 
fragile.

I also think I know why John reported this:

> Ingo, Thomas: On the hardware I'm testing the fast-pit calibration only
> triggers probably 80-90% of the time. About 10-20% of the time, the
> initial check to pit_expect_msb(0xff) fails (count=0), so we may need to
> look more at this approach.

and the reason is that when we re-program the PIT, it will actually take 
until the next timer edge (the incoming 1.1MHz timer) for the new values 
to take effect. So before the first call to pit_expect_msb(), we should 
make sure to delay for at least one PIT cycle. The simplest way to do that 
is to simply read the PIT latch once, it will take about 2us.

So this patch fixes that too.

John, does that make the PIT calibration work reliably on your machine?

The patch looks bigger than it is: most of the noise is just 
re-indentation and some trivial re-organizing.

			Linus

---
 arch/x86/kernel/tsc.c |  110 +++++++++++++++++++++++++++++--------------------
 1 files changed, 65 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 599e581..d5cebb5 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -273,30 +273,43 @@ static unsigned long pit_calibrate_tsc(u32 latch, unsigned long ms, int loopmin)
  * use the TSC value at the transitions to calculate a pretty
  * good value for the TSC frequencty.
  */
-static inline int pit_expect_msb(unsigned char val)
+static inline int pit_expect_msb(unsigned char val, u64 *tscp, unsigned long *deltap)
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
- * How many MSB values do we want to see? We aim for a
- * 15ms calibration, which assuming a 2us counter read
- * error should give us roughly 150 ppm precision for
- * the calibration.
+ * How many MSB values do we want to see? We aim for
+ * a maximum error rate of 500ppm (in practice the
+ * real error is much smaller), but refuse to spend
+ * more than 25ms on it.
  */
-#define QUICK_PIT_MS 15
-#define QUICK_PIT_ITERATIONS (QUICK_PIT_MS * PIT_TICK_RATE / 1000 / 256)
+#define MAX_QUICK_PIT_MS 25
+#define MAX_QUICK_PIT_ITERATIONS (MAX_QUICK_PIT_MS * PIT_TICK_RATE / 1000 / 256)
 
 static unsigned long quick_pit_calibrate(void)
 {
+	int i;
+	u64 tsc, delta;
+	unsigned long d1, d2;
+
 	/* Set the Gate high, disable speaker */
 	outb((inb(0x61) & ~0x02) | 0x01, 0x61);
 
@@ -315,45 +328,52 @@ static unsigned long quick_pit_calibrate(void)
 	outb(0xff, 0x42);
 	outb(0xff, 0x42);
 
-	if (pit_expect_msb(0xff)) {
-		int i;
-		u64 t1, t2, delta;
-		unsigned char expect = 0xfe;
-
-		t1 = get_cycles();
-		for (i = 0; i < QUICK_PIT_ITERATIONS; i++, expect--) {
-			if (!pit_expect_msb(expect))
-				goto failed;
+	/*
+	 * The PIT starts counting at the next edge, so we
+	 * need to delay for a microsecond. The easiest way
+	 * to do that is to just read back the 16-bit counter
+	 * once from the PIT.
+	 */
+	inb(0x42);
+	inb(0x42);
+
+	if (pit_expect_msb(0xff, &tsc, &d1)) {
+		for (i = 1; i <= MAX_QUICK_PIT_ITERATIONS; i++) {
+			if (!pit_expect_msb(0xff-i, &delta, &d2))
+				break;
+
+			/*
+			 * Iterate until the error is less than 500 ppm
+			 */
+			delta -= tsc;
+			if (d1+d2 < delta >> 11)
+				goto success;
 		}
-		t2 = get_cycles();
-
-		/*
-		 * Make sure we can rely on the second TSC timestamp:
-		 */
-		if (!pit_expect_msb(expect))
-			goto failed;
-
-		/*
-		 * Ok, if we get here, then we've seen the
-		 * MSB of the PIT decrement QUICK_PIT_ITERATIONS
-		 * times, and each MSB had many hits, so we never
-		 * had any sudden jumps.
-		 *
-		 * As a result, we can depend on there not being
-		 * any odd delays anywhere, and the TSC reads are
-		 * reliable.
-		 *
-		 * kHz = ticks / time-in-seconds / 1000;
-		 * kHz = (t2 - t1) / (QPI * 256 / PIT_TICK_RATE) / 1000
-		 * kHz = ((t2 - t1) * PIT_TICK_RATE) / (QPI * 256 * 1000)
-		 */
-		delta = (t2 - t1)*PIT_TICK_RATE;
-		do_div(delta, QUICK_PIT_ITERATIONS*256*1000);
-		printk("Fast TSC calibration using PIT\n");
-		return delta;
 	}
-failed:
+	printk("Fast TSC calibration failed\n");
 	return 0;
+
+success:
+	/*
+	 * Ok, if we get here, then we've seen the
+	 * MSB of the PIT decrement 'i' times, and the
+	 * error has shrunk to less than 500 ppm.
+	 *
+	 * As a result, we can depend on there not being
+	 * any odd delays anywhere, and the TSC reads are
+	 * reliable (within the error). We also adjust the
+	 * delta to the middle of the error bars, just
+	 * because it looks nicer.
+	 *
+	 * kHz = ticks / time-in-seconds / 1000;
+	 * kHz = (t2 - t1) / (I * 256 / PIT_TICK_RATE) / 1000
+	 * kHz = ((t2 - t1) * PIT_TICK_RATE) / (I * 256 * 1000)
+	 */
+	delta += (long)(d2 - d1)/2;
+	delta *= PIT_TICK_RATE;
+	do_div(delta, i*256*1000);
+	printk("Fast TSC calibration using PIT\n");
+	return delta;
 }
 
 /**
