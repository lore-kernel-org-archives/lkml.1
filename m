Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbYIDUnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbYIDUnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYIDUnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:43:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53089 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbYIDUnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:43:33 -0400
Date: Thu, 4 Sep 2008 22:43:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Alok Kataria <akataria@vmware.com>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
Message-ID: <20080904204305.GA29065@elte.hu>
References: <20080904150339.896115280@linutronix.de> <20080904153620.GC7120@elte.hu> <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org> <20080904160036.GA18382@elte.hu> <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org> <20080904190728.59634020@lxorguk.ukuu.org.uk> <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> +		unsigned char expect = 0xfe;
> +
> +		t1 = get_cycles();
> +		for (expect = 0xfe, i = 0; i < QUICK_PIT_ITERATIONS; i++, expect--) {
> +			if (!pit_expect_msb(expect))
> +				goto failed;
> +		}
> +		t2 = get_cycles();

i suspect you didnt want the second initialization of 'expect' to 0xfe? 
I fixed that up by removing the second one.

( although i think it would all be even clearer if we initialized 
  'expect' to 0xff before the first call of pit_expect_msb() higher up, 
  and then doing an expect-- before doing this loop - but that is really 
  painting the bikeshed i guess. )

> @@ -189,9 +300,15 @@ unsigned long native_calibrate_tsc(void)
>  {
>  	u64 tsc1, tsc2, delta, pm1, pm2, hpet1, hpet2;
>  	unsigned long tsc_pit_min = ULONG_MAX, tsc_ref_min = ULONG_MAX;
> -	unsigned long flags;
> +	unsigned long flags, fast_calibrate;
>  	int hpet = is_hpet_enabled(), i;
>  
> +	local_irq_save(flags);
> +	fast_calibrate = quick_pit_calibrate();
> +	local_irq_restore(flags);
> +	if (fast_calibrate)
> +		return fast_calibrate;
> +
>  	/*
>  	 * Run 5 calibration loops to get the lowest frequency value
>  	 * (the best estimate). We use two different calibration modes

these bits collided with Thomas's textually but not conceptually: Thomas 
improved the slowpath calibration while you introduced a new fastpath. I 
kept both and applied your patch to tip/x86/tsc.

if you are happy with the commit below, could you please give your 
Signed-off-by for it?

	Ingo

-------------->
>From b6cb513801373e10af6f2df287a8089e3c340e83 Mon Sep 17 00:00:00 2001
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 4 Sep 2008 10:41:22 -0700
Subject: [PATCH] x86: quick TSC calibration

Introduce a fast TSC-calibration method on sane hardware.

It only uses 17920 PIT timer ticks to calibrate the TSC, plus 256 ticks on
each side to make sure the TSC values were very close to the tick, so the
whole calibration takes 15ms. Yet, despite only takign 15ms,
we can actually give pretty stringent guarantees of accuracy:

 - the code requires that we hit each 256-counter block at least 50 times,
   so the TSC error is basically at *MOST* just a few PIT cycles off in
   any direction. In practice, it's going to be about one microseconds
   off (which is how long it takes to read the counter)

 - so over 17920 PIT cycles, we can pretty much guarantee that the
   calibration error is less than one half of a percent.

My testing bears this out: on my machine, the quick-calibration reports
2934.085kHz, while the slow one reports 2933.415.

Yes, the slower calibration is still more precise. For me, the slow
calibration is stable to within about one hundreth of a percent, so it's
(at a guess) roughly an order-and-a-half of magnitude more precise. The
longer you wait, the more precise you can be.

However, the nice thing about the fast TSC PIT synchronization is that
it's pretty much _guaranteed_ to give that 0.5% precision, and fail
gracefully (and very quickly) if it doesn't get it. And it really is
fairly simple (even if there's a lot of _details_ there, and I didn't get
all of those right ont he first try or even the second ;)

The patch says "110 insertions", but 63 of those new lines are actually
comments.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/tsc.c |  111 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 110 insertions(+), 1 deletions(-)
---
 arch/x86/kernel/tsc.c |  119 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 118 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index da033b5..839070b 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -227,6 +227,117 @@ static unsigned long pit_calibrate_tsc(u32 latch, unsigned long ms, int loopmin)
 	return delta;
 }
 
+/*
+ * This reads the current MSB of the PIT counter, and
+ * checks if we are running on sufficiently fast and
+ * non-virtualized hardware.
+ *
+ * Our expectations are:
+ *
+ *  - the PIT is running at roughly 1.19MHz
+ *
+ *  - each IO is going to take about 1us on real hardware,
+ *    but we allow it to be much faster (by a factor of 10) or
+ *    _slightly_ slower (ie we allow up to a 2us read+counter
+ *    update - anything else implies a unacceptably slow CPU
+ *    or PIT for the fast calibration to work.
+ *
+ *  - with 256 PIT ticks to read the value, we have 214us to
+ *    see the same MSB (and overhead like doing a single TSC
+ *    read per MSB value etc).
+ *
+ *  - We're doing 2 reads per loop (LSB, MSB), and we expect
+ *    them each to take about a microsecond on real hardware.
+ *    So we expect a count value of around 100. But we'll be
+ *    generous, and accept anything over 50.
+ *
+ *  - if the PIT is stuck, and we see *many* more reads, we
+ *    return early (and the next caller of pit_expect_msb()
+ *    then consider it a failure when they don't see the
+ *    next expected value).
+ *
+ * These expectations mean that we know that we have seen the
+ * transition from one expected value to another with a fairly
+ * high accuracy, and we didn't miss any events. We can thus
+ * use the TSC value at the transitions to calculate a pretty
+ * good value for the TSC frequencty.
+ */
+static inline int pit_expect_msb(unsigned char val)
+{
+	int count = 0;
+
+	for (count = 0; count < 50000; count++) {
+		/* Ignore LSB */
+		inb(0x42);
+		if (inb(0x42) != val)
+			break;
+	}
+	return count > 50;
+}
+
+/*
+ * How many MSB values do we want to see? We aim for a
+ * 15ms calibration, which assuming a 2us counter read
+ * error should give us roughly 150 ppm precision for
+ * the calibration.
+ */
+#define QUICK_PIT_MS 15
+#define QUICK_PIT_ITERATIONS (QUICK_PIT_MS * PIT_TICK_RATE / 1000 / 256)
+
+static unsigned long quick_pit_calibrate(void)
+{
+	/* Set the Gate high, disable speaker */
+	outb((inb(0x61) & ~0x02) | 0x01, 0x61);
+
+	/*
+	 * Counter 2, mode 0 (one-shot), binary count
+	 *
+	 * NOTE! Mode 2 decrements by two (and then the
+	 * output is flipped each time, giving the same
+	 * final output frequency as a decrement-by-one),
+	 * so mode 0 is much better when looking at the
+	 * individual counts.
+	 */
+	outb(0xb0, 0x43);
+
+	/* Start at 0xffff */
+	outb(0xff, 0x42);
+	outb(0xff, 0x42);
+
+	if (pit_expect_msb(0xff)) {
+		int i;
+		u64 t1, t2, delta;
+		unsigned char expect = 0xfe;
+
+		t1 = get_cycles();
+		for (i = 0; i < QUICK_PIT_ITERATIONS; i++, expect--) {
+			if (!pit_expect_msb(expect))
+				goto failed;
+		}
+		t2 = get_cycles();
+
+		/*
+		 * Ok, if we get here, then we've seen the
+		 * MSB of the PIT decrement QUICK_PIT_ITERATIONS
+		 * times, and each MSB had many hits, so we never
+		 * had any sudden jumps.
+		 *
+		 * As a result, we can depend on there not being
+		 * any odd delays anywhere, and the TSC reads are
+		 * reliable.
+		 *
+		 * kHz = ticks / time-in-seconds / 1000;
+		 * kHz = (t2 - t1) / (QPI * 256 / PIT_TICK_RATE) / 1000
+		 * kHz = ((t2 - t1) * PIT_TICK_RATE) / (QPI * 256 * 1000)
+		 */
+		delta = (t2 - t1)*PIT_TICK_RATE;
+		do_div(delta, QUICK_PIT_ITERATIONS*256*1000);
+		printk("Fast TSC calibration using PIT\n");
+		return delta;
+	}
+failed:
+	return 0;
+}
 
 /**
  * native_calibrate_tsc - calibrate the tsc on boot
@@ -235,9 +346,15 @@ unsigned long native_calibrate_tsc(void)
 {
 	u64 tsc1, tsc2, delta, ref1, ref2;
 	unsigned long tsc_pit_min = ULONG_MAX, tsc_ref_min = ULONG_MAX;
-	unsigned long flags, latch, ms;
+	unsigned long flags, latch, ms, fast_calibrate;
 	int hpet = is_hpet_enabled(), i, loopmin;
 
+	local_irq_save(flags);
+	fast_calibrate = quick_pit_calibrate();
+	local_irq_restore(flags);
+	if (fast_calibrate)
+		return fast_calibrate;
+
 	/*
 	 * Run 5 calibration loops to get the lowest frequency value
 	 * (the best estimate). We use two different calibration modes
