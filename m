Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYIDRmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYIDRmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 13:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbYIDRmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 13:42:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752122AbYIDRmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 13:42:14 -0400
Date: Thu, 4 Sep 2008 10:41:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Alok Kataria <akataria@vmware.com>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
In-Reply-To: <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org>
References: <20080904150339.896115280@linutronix.de> <20080904153620.GC7120@elte.hu> <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org> <20080904160036.GA18382@elte.hu> <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Sep 2008, Linus Torvalds wrote:
> 
> I'd post the patch, but I really need to actually _test_ it first, and I 
> haven't rebooted yet.

Just as well. There were various stupid small details, like the fact that 
i8253 timer mode 2 (square wave) decrements by two, which confused me for 
a while until I realized it.

Anyway, here's a suggested diff. The comments are quite extensive, and 
should explain it all. The code should be _very_ robust, in that if 
anything doesn't match expectations, it will fail and fall back on the old 
code. But it should also be very fast, and quite precise.

It only uses 2048 PIT timer ticks to calibrate the TSC, plus 256 ticks on 
each side to make sure the TSC values were very close to the tick, so the 
whole calibration takes less than 2.5ms. Yet, despite only takign 2.5ms, 
we can actually give pretty stringent guarantees of accuracy:

 - the code requires that we hit each 256-counter block at least 35 times, 
   so the TSC error is basically at *MOST* just a few PIT cycles off in 
   any direction. In practice, it's going to be about three microseconds 
   off (which is how long it takes to read the counter)

 - so over 2048 PIT cycles, we can pretty much guarantee that the 
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

(And yes, I do the latching - it's not reqlly required since I only depend 
on the MSB, and it actually makes for slightly lower precision, but it's 
the "safe" thing. And I figured out that the reason I thought that the 
latch stops the count in my earlier experiments was again due to the 
fact that "mode 2" decrements by two, not by one. So latching is fine, 
and the documented way to do this all).

		Linus

---
 arch/x86/kernel/tsc.c |  111 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 110 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 8f98e9d..e14e6c8 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -181,6 +181,109 @@ static unsigned long pit_calibrate_tsc(void)
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
+ *  - We're doing 3 IO's per loop (latch, read, read), and
+ *    we expect them each to take about a microsecond on real
+ *    hardware. So we expect a count value of around 70. But
+ *    we'll be generous, and accept anything over 35.
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
+		/* Latch counter 2 - just to be safe */
+		outb(0x80, 0x43);
+		/* Ignore LSB */
+		inb(0x42);
+		if (inb(0x42) != val)
+			break;
+	}
+	return count > 35;
+}
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
+		u64 t1, t2, delta;
+		unsigned char expect;
+
+		t1 = get_cycles();
+		for (expect = 0xfe; expect > 0xf5; expect--) {
+			t2 = get_cycles();
+			if (!pit_expect_msb(expect))
+				goto failed;
+		}
+		/*
+		 * Ok, if we get here, then we've seen the
+		 * MSB of the PIT go from 0xff to 0xf6, and
+		 * each MSB had many hits, so our TSC reading
+		 * was always very close to the transition.
+		 *
+		 * So t1 is at the 0xff -> 0xfe transition,
+		 * and t2 is at 0xf7->0xf6, and so the PIT
+		 * count difference between the two is 8*256,
+		 * ie 2048.
+		 *
+		 * kHz = ticks / time-in-seconds / 1000;
+		 * kHz = (t2 - t1) / (2048 / PIT_TICK_RATE) / 1000
+		 * kHz = ((t2 - t1) * PIT_TICK_RATE) / (2048 * 1000)
+		 */
+		delta = (t2 - t1)*PIT_TICK_RATE;
+		do_div(delta, 2048*1000);
+		printk("Fast TSC calibration using PIT\n");
+		return delta;
+	}
+failed:
+	return 0;
+}
 
 /**
  * native_calibrate_tsc - calibrate the tsc on boot
@@ -189,9 +292,15 @@ unsigned long native_calibrate_tsc(void)
 {
 	u64 tsc1, tsc2, delta, pm1, pm2, hpet1, hpet2;
 	unsigned long tsc_pit_min = ULONG_MAX, tsc_ref_min = ULONG_MAX;
-	unsigned long flags;
+	unsigned long flags, fast_calibrate;
 	int hpet = is_hpet_enabled(), i;
 
+	local_irq_save(flags);
+	fast_calibrate = quick_pit_calibrate();
+	local_irq_restore(flags);
+	if (fast_calibrate)
+		return fast_calibrate;
+
 	/*
 	 * Run 5 calibration loops to get the lowest frequency value
 	 * (the best estimate). We use two different calibration modes
