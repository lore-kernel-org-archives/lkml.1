Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbZCQIO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbZCQIO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 04:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZCQIOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 04:14:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48209 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbZCQIOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 04:14:34 -0400
Date: Tue, 17 Mar 2009 09:14:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jesper Krogh <jesper@krogh.cc>, john stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
Message-ID: <20090317081412.GA24115@elte.hu>
References: <1236221530.6863.9.camel@localhost.localdomain> <49B57F3D.5030008@krogh.cc> <alpine.LFD.2.00.0903141814180.7421@localhost.localdomain> <49BD225C.4070305@krogh.cc> <alpine.LFD.2.00.0903151050070.3131@localhost.localdomain> <49BD4B2D.7000501@krogh.cc> <alpine.LFD.2.00.0903151146550.3131@localhost.localdomain> <49BD5C7C.2060605@krogh.cc> <49BEA1AD.1090901@krogh.cc> <alpine.LFD.2.00.0903161225210.3675@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903161225210.3675@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 16 Mar 2009, Jesper Krogh wrote:
> > 
> > you were right. It works. No resets so far.
> 
> Goodie.
> 
> Here's a slightly cleaned-up patch that removes the debug 
> messages, and also re-organizes the code a bit so that it 
> actually uses the "better than 500 ppm" as the way to decide 
> when to stop calibrating.
> 
> Why?
> 
> I tested the 500 ppm check on some slower machines, and the 
> old algorithm of just waiting for 15ms actually failed that 
> 500 ppm test. It was _very_ close - 16ms was enough - but it 
> convinced me that the logic was too damn fragile.
> 
> I also think I know why John reported this:
> 
> > Ingo, Thomas: On the hardware I'm testing the fast-pit calibration only
> > triggers probably 80-90% of the time. About 10-20% of the time, the
> > initial check to pit_expect_msb(0xff) fails (count=0), so we may need to
> > look more at this approach.
> 
> and the reason is that when we re-program the PIT, it will 
> actually take until the next timer edge (the incoming 1.1MHz 
> timer) for the new values to take effect. So before the first 
> call to pit_expect_msb(), we should make sure to delay for at 
> least one PIT cycle. The simplest way to do that is to simply 
> read the PIT latch once, it will take about 2us.
> 
> So this patch fixes that too.
> 
> John, does that make the PIT calibration work reliably on your 
> machine?
> 
> The patch looks bigger than it is: most of the noise is just 
> re-indentation and some trivial re-organizing.

Cool. Will you apply it yourself (in the merge window) or should 
we pick it up?

Incidentally, yesterday i wrote a PIT auto-calibration routine 
(see WIP patch below).

The core idea is to use _all_ thousands of measurement points 
(not just two) to calculate the frequency ratio, with a built-in 
noise detector which drops out of the loop if the observed noise 
goes below ~10 ppm.

It is free-running: i.e. it observes noise and if the result 
stabilizes quickly it can exit quickly. (with an upper bound for 
unreliable PITs or virtualized systems, etc.)

It's WIP because it's not working yet (or at all?): i couldnt 
get the statistical model right - it's too noisy at 1000-2000 
ppm and the frequency result is off by 5000 ppm. Totally against 
expectations. I traced it on a box with a good PIT and in the 
trace the calculations look sane and the noise levels go down 
nicely - except that the result sucks.

I also like yours more because it's simpler.

	Ingo

Index: linux/arch/x86/kernel/tsc.c
===================================================================
--- linux.orig/arch/x86/kernel/tsc.c
+++ linux/arch/x86/kernel/tsc.c
@@ -240,63 +240,201 @@ static unsigned long pit_calibrate_tsc(u
 }
 
 /*
- * This reads the current MSB of the PIT counter, and
- * checks if we are running on sufficiently fast and
- * non-virtualized hardware.
+ * Rolling statistical analysis of (PIT,TSC) measurement deltas.
  *
- * Our expectations are:
- *
- *  - the PIT is running at roughly 1.19MHz
- *
- *  - each IO is going to take about 1us on real hardware,
- *    but we allow it to be much faster (by a factor of 10) or
- *    _slightly_ slower (ie we allow up to a 2us read+counter
- *    update - anything else implies a unacceptably slow CPU
- *    or PIT for the fast calibration to work.
- *
- *  - with 256 PIT ticks to read the value, we have 214us to
- *    see the same MSB (and overhead like doing a single TSC
- *    read per MSB value etc).
- *
- *  - We're doing 2 reads per loop (LSB, MSB), and we expect
- *    them each to take about a microsecond on real hardware.
- *    So we expect a count value of around 100. But we'll be
- *    generous, and accept anything over 50.
- *
- *  - if the PIT is stuck, and we see *many* more reads, we
- *    return early (and the next caller of pit_expect_msb()
- *    then consider it a failure when they don't see the
- *    next expected value).
- *
- * These expectations mean that we know that we have seen the
- * transition from one expected value to another with a fairly
- * high accuracy, and we didn't miss any events. We can thus
- * use the TSC value at the transitions to calculate a pretty
- * good value for the TSC frequencty.
+ * We use a decaying average to estimate current noise levels.
+ * If noise falls below the expected threshold we exit the loop
+ * with the result.
+ *
+ * If this never happens - for example because the PIT is unreliable,
+ * then we break out after a limit and fail this type of calibration.
+ *
+ * Note that this method observes the statistical noise as-is without
+ * making any assumptions, so it is fundamentally robust against
+ * occasional PIT blips or SMI related system activities that can
+ * disturb calibration. An SMI in the wrong  moment pushes up the
+ * noise level and causes the calibration loop to exit a tiny bit
+ * later - but still with a precise and reliable result.
  */
-static inline int pit_expect_msb(unsigned char val)
+static s64 sum_slope;
+static s64 sum_slope_noise;
+static s64 prev_slope;
+
+static int nr_measurements;
+
+#define MAX_MEASUREMENTS	10000
+
+#define MIN_MEASUREMENTS	100
+
+struct entry {
+	u64			tsc;
+	unsigned int		pit;
+};
+
+/*
+ * A single measurement is as simple as possible:
+ */
+static inline void do_one_measurement(struct entry *entry)
 {
-	int count = 0;
+	unsigned char pit_lsb, pit_msb;
+	u64 tsc;
 
-	for (count = 0; count < 50000; count++) {
-		/* Ignore LSB */
-		inb(0x42);
-		if (inb(0x42) != val)
-			break;
-	}
-	return count > 50;
+	/*
+	 * We use the PIO accesses as natural TSC serialization barriers:
+	 */
+	pit_lsb			= inb(0x42);
+	tsc			= get_cycles();
+	pit_msb			= inb(0x42);
+
+	entry->tsc		= tsc;
+	entry->pit		= pit_msb*256 + pit_lsb;
+
+	trace_printk("tsc: %Ld, count: %d, nr: %d\n",
+		     entry->tsc, entry->pit, nr_measurements);
 }
 
 /*
- * How many MSB values do we want to see? We aim for a
- * 15ms calibration, which assuming a 2us counter read
- * error should give us roughly 150 ppm precision for
- * the calibration.
+ * We scale numbers up by 1024 to reduce quantization effects:
  */
-#define QUICK_PIT_MS 15
-#define QUICK_PIT_ITERATIONS (QUICK_PIT_MS * PIT_TICK_RATE / 1000 / 256)
+static unsigned long do_delta_analysis(struct entry *e0, struct entry *e1)
+{
+	s64 slope, dslope;
+	s64 noise;
+	int decay;
+	int dc;
+	s64 dt;
+
+	dt = e1->tsc - e0->tsc; /* TSC is going up */
+	dc = e0->pit - e1->pit; /* PIT counter is going down */
+
+	/*
+	 * Delta-PIT-count can be positive (or negative in case of
+	 * an anomaly), but we made sure in do_measurement() that
+	 * it can never be zero:
+	 */
+	slope = 1024 * dt / dc;
+
+	dslope = slope - prev_slope;
+	noise = dslope;
+
+	trace_printk("                   dt:  %20Ld\n", dt);
+	trace_printk("                   dc:  %20d\n", dc);
+	trace_printk("                slope:  %20Ld\n", slope);
+	trace_printk("               dslope:  %20Ld\n", dslope);
+
+	/*
+	 * Add a gentle decaying average to the slope and noise averages:
+	 */
+	trace_printk("       prev sum_slope:  %20Ld\n", sum_slope);
 
-static unsigned long quick_pit_calibrate(void)
+	/*
+	 * Dynamic decay - starts with low values then later on
+	 * the system cools down:
+	 */
+	decay = 1;
+	if (sum_slope_noise)
+		decay = sum_slope / 64 / sum_slope_noise;
+	decay = min(2000, decay);
+	decay = max(nr_measurements/4, decay);
+
+	sum_slope = ((decay - 1)*sum_slope + slope)/decay;
+	trace_printk("        new sum_slope:  %20Ld [decay: %d]\n",
+		     sum_slope, decay);
+
+	trace_printk(" prev sum_slope_noise:  %20Ld\n", sum_slope_noise);
+	sum_slope_noise = (1023*sum_slope_noise + noise)/1024;
+	trace_printk("  new sum_slope_noise:  %20Ld\n", sum_slope_noise);
+
+	prev_slope = slope;
+
+	if (nr_measurements >= 64*MIN_MEASUREMENTS && sum_slope_noise < 10 ) {
+		trace_printk(" => low noise early exit!\n");
+		return 1;
+	}
+
+	return 0;
+}
+
+static int do_measurements(void)
+{
+	unsigned int pit_stuck;
+	unsigned long flags;
+	struct entry e0, e1;
+	int err = 0;
+
+	sum_slope_noise = 0;
+	sum_slope = 0;
+	prev_slope = 0;
+
+	nr_measurements = 0;
+
+	local_irq_save(flags);
+
+	trace_printk("PIT begin\n");
+	do_one_measurement(&e0);
+
+	do_one_measurement(&e0);
+
+	for (;;) {
+		pit_stuck = 0;
+repeat_e1:
+		do_one_measurement(&e1);
+		/*
+		 * The typical case is that the PIT advanced a bit
+		 * since we last read it (the PIOs take time, etc.).
+		 * In case it did not advance (some really fast
+		 * PIO implementation or virtualization) we will allow
+		 * the count to stay 'stuck' up to 100 times:
+		 *
+		 * (Note that making sure that the count progresses also
+		 * simplifies data processing later on.)
+		 */
+		if (e0.pit != e1.pit) {
+			nr_measurements++;
+			if (nr_measurements >= MAX_MEASUREMENTS) {
+				printk("PIT: final count: %d\n", e1.pit);
+				break;
+			}
+			if (do_delta_analysis(&e0, &e1)) {
+				printk("PIT: low-noise count: %d\n", e1.pit);
+				break;
+			}
+			/*
+			 * Reuse the second measurement point for the
+			 * next delta measurement:
+			 */
+			e0 = e1;
+			trace_printk("\n");
+			continue;
+		}
+		if (pit_stuck++ < 100)
+			goto repeat_e1;
+
+		printk(KERN_INFO "PIT auto-calibration: counter stuck at %d!\n",
+			e1.pit);
+		err = -EINVAL;
+	}
+
+	trace_printk("PIT end\n");
+	local_irq_restore(flags);
+
+	return err;
+}
+
+static unsigned long auto_pit_calibrate(void)
+{
+	if (do_measurements() < 0)
+		return 0;
+
+	printk("PIT: sum_slope:        %Ld\n", sum_slope);
+	printk("PIT: Hz:               %Ld\n", sum_slope * PIT_TICK_RATE);
+	printk("PIT: sum_slope_noise:  %Ld\n", sum_slope_noise);
+	printk("PIT: nr_measurements:  %d\n", nr_measurements);
+
+	return sum_slope * PIT_TICK_RATE / 1024 / 1000;
+}
+
+unsigned long quick_pit_calibrate(void)
 {
 	/* Set the Gate high, disable speaker */
 	outb((inb(0x61) & ~0x02) | 0x01, 0x61);
@@ -316,45 +454,7 @@ static unsigned long quick_pit_calibrate
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
-		}
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
-	}
-failed:
-	return 0;
+	return auto_pit_calibrate();
 }
 
 /**
