Return-Path: <linux-kernel-owner+w=401wt.eu-S1756465AbYIDVis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbYIDVis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 17:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYIDVik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 17:38:40 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:52770 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751640AbYIDVij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 17:38:39 -0400
Subject: Re: [RFC patch 0/4] TSC calibration improvements
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org>
References: <20080904150339.896115280@linutronix.de>
	 <20080904153620.GC7120@elte.hu>
	 <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>
	 <20080904160036.GA18382@elte.hu>
	 <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org>
	 <20080904190728.59634020@lxorguk.ukuu.org.uk>
	 <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 04 Sep 2008 14:38:37 -0700
Message-Id: <1220564317.11753.70.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-04 at 13:09 -0700, Linus Torvalds wrote:
> 
> On Thu, 4 Sep 2008, Linus Torvalds wrote:
> >
> > Yeah, I had some memory of latch issues. I wrote the thing originally
> > without the latching, which is why the whole thing is designed to igore
> > the low cycle count. I just decided that doing the latching shouldn't
> > hurt that much, even if it ends up being just a 1us no-op.
> 
> Thinking more about it, that was the wrong decision. After all, the whole
> point of the "quick calibration" is to take care of the good case of
> reasonable hardware - and fall back on a much slower version if there is
> something odd going on.
> 
> So latching things is the wrong thing to do, since it just slows things
> down. No real hardware should need it, and if some odd hardware does
> exist, all the other sanity checks will catch it anyway.
> 
> And yeah, I shouldn't have tried to go from 250ms down to 2.5ms. Aim for
> something like a 15ms calibration instead, which should give plenty of
> precision, while still being much faster than we used to be.
> 
> So how about this?
> 
> (Stage #2 would then be to simplify the main calibration loop now that we
> know that it's there really as a fall-back when the PIT isn't stable for
> some reason, but that's a separate issue).
> 
> Thomas, I assume that this one catches your SMI-laptop and falls back to
> the slow case, the same way Alok already said it catches his VM setup?

Just for the record, I ran this reboot loop for 50 times, and in 1 of
the run the kernel did use fast pit calibration method.
These runs were on vanilla 2.6.27-rc5 with this patch (take 2 from
Linus) and Ingo's fix.
The frequency that was calibrated by this run was 1866.291 Mhz, 
usually it's about 1866.692 Mhz. Slow method calibrates in the same
range.

In all the other 49 odd runs it did calibrate using the slow method. 
I printed the count values to see how much are we missing the fast
method by.

The maximum count value that I see is 84.
In one single reboot run, on an average in about 70 iterations the val
returned from pit_expect_msb is > 50, and eventually we hit a condition
where the value is < 50 and we bail out of the fast method.

So just to be on safer side can we be a little less generous and
increase the threshold to somewhere around 75 from 50 ? Or is there a
good reason not to ?

Thanks,
Alok

> 
>                 Linus
> 
> ---
>  arch/x86/kernel/tsc.c |  119 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 118 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 8f98e9d..4589ae4 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -181,6 +181,117 @@ static unsigned long pit_calibrate_tsc(void)
>         return delta;
>  }
> 
> +/*
> + * This reads the current MSB of the PIT counter, and
> + * checks if we are running on sufficiently fast and
> + * non-virtualized hardware.
> + *
> + * Our expectations are:
> + *
> + *  - the PIT is running at roughly 1.19MHz
> + *
> + *  - each IO is going to take about 1us on real hardware,
> + *    but we allow it to be much faster (by a factor of 10) or
> + *    _slightly_ slower (ie we allow up to a 2us read+counter
> + *    update - anything else implies a unacceptably slow CPU
> + *    or PIT for the fast calibration to work.
> + *
> + *  - with 256 PIT ticks to read the value, we have 214us to
> + *    see the same MSB (and overhead like doing a single TSC
> + *    read per MSB value etc).
> + *
> + *  - We're doing 2 reads per loop (LSB, MSB), and we expect
> + *    them each to take about a microsecond on real hardware.
> + *    So we expect a count value of around 100. But we'll be
> + *    generous, and accept anything over 50.
> + *
> + *  - if the PIT is stuck, and we see *many* more reads, we
> + *    return early (and the next caller of pit_expect_msb()
> + *    then consider it a failure when they don't see the
> + *    next expected value).
> + *
> + * These expectations mean that we know that we have seen the
> + * transition from one expected value to another with a fairly
> + * high accuracy, and we didn't miss any events. We can thus
> + * use the TSC value at the transitions to calculate a pretty
> + * good value for the TSC frequencty.
> + */
> +static inline int pit_expect_msb(unsigned char val)
> +{
> +       int count = 0;
> +
> +       for (count = 0; count < 50000; count++) {
> +               /* Ignore LSB */
> +               inb(0x42);
> +               if (inb(0x42) != val)
> +                       break;
> +       }
> +       return count > 50;
> +}
> +
> +/*
> + * How many MSB values do we want to see? We aim for a
> + * 15ms calibration, which assuming a 2us counter read
> + * error should give us roughly 150 ppm precision for
> + * the calibration.
> + */
> +#define QUICK_PIT_MS 15
> +#define QUICK_PIT_ITERATIONS (QUICK_PIT_MS * PIT_TICK_RATE / 1000 / 256)
> +
> +static unsigned long quick_pit_calibrate(void)
> +{
> +       /* Set the Gate high, disable speaker */
> +       outb((inb(0x61) & ~0x02) | 0x01, 0x61);
> +
> +       /*
> +        * Counter 2, mode 0 (one-shot), binary count
> +        *
> +        * NOTE! Mode 2 decrements by two (and then the
> +        * output is flipped each time, giving the same
> +        * final output frequency as a decrement-by-one),
> +        * so mode 0 is much better when looking at the
> +        * individual counts.
> +        */
> +       outb(0xb0, 0x43);
> +
> +       /* Start at 0xffff */
> +       outb(0xff, 0x42);
> +       outb(0xff, 0x42);
> +
> +       if (pit_expect_msb(0xff)) {
> +               int i;
> +               u64 t1, t2, delta;
> +               unsigned char expect = 0xfe;
> +
> +               t1 = get_cycles();
> +               for (expect = 0xfe, i = 0; i < QUICK_PIT_ITERATIONS; i++, expect--) {
> +                       if (!pit_expect_msb(expect))
> +                               goto failed;
> +               }
> +               t2 = get_cycles();
> +
> +               /*
> +                * Ok, if we get here, then we've seen the
> +                * MSB of the PIT decrement QUICK_PIT_ITERATIONS
> +                * times, and each MSB had many hits, so we never
> +                * had any sudden jumps.
> +                *
> +                * As a result, we can depend on there not being
> +                * any odd delays anywhere, and the TSC reads are
> +                * reliable.
> +                *
> +                * kHz = ticks / time-in-seconds / 1000;
> +                * kHz = (t2 - t1) / (QPI * 256 / PIT_TICK_RATE) / 1000
> +                * kHz = ((t2 - t1) * PIT_TICK_RATE) / (QPI * 256 * 1000)
> +                */
> +               delta = (t2 - t1)*PIT_TICK_RATE;
> +               do_div(delta, QUICK_PIT_ITERATIONS*256*1000);
> +               printk("Fast TSC calibration using PIT\n");
> +               return delta;
> +       }
> +failed:
> +       return 0;
> +}
> 
>  /**
>   * native_calibrate_tsc - calibrate the tsc on boot
> @@ -189,9 +300,15 @@ unsigned long native_calibrate_tsc(void)
>  {
>         u64 tsc1, tsc2, delta, pm1, pm2, hpet1, hpet2;
>         unsigned long tsc_pit_min = ULONG_MAX, tsc_ref_min = ULONG_MAX;
> -       unsigned long flags;
> +       unsigned long flags, fast_calibrate;
>         int hpet = is_hpet_enabled(), i;
> 
> +       local_irq_save(flags);
> +       fast_calibrate = quick_pit_calibrate();
> +       local_irq_restore(flags);
> +       if (fast_calibrate)
> +               return fast_calibrate;
> +
>         /*
>          * Run 5 calibration loops to get the lowest frequency value
>          * (the best estimate). We use two different calibration modes

