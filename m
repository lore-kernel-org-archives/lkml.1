Return-Path: <linux-kernel-owner+w=401wt.eu-S932522AbYBNEhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522AbYBNEhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 23:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755625AbYBNEgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 23:36:50 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41578 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174AbYBNEgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 23:36:48 -0500
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
From: john stultz <johnstul@us.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <Pine.LNX.4.64.0802120335170.3378@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801251349120.17507@scrub.home>
	 <1201573686.6766.13.camel@localhost>
	 <Pine.LNX.4.64.0801290439480.17507@scrub.home>
	 <1201659263.6766.40.camel@localhost>
	 <Pine.LNX.4.64.0801310251090.17507@scrub.home>
	 <1201745776.6195.14.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801310404480.17507@scrub.home>
	 <1201914175.6216.46.camel@jstultz-laptop>
	 <Pine.LNX.4.64.0802081718040.3378@scrub.home>
	 <1202523452.6174.45.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0802101917030.3378@scrub.home>
	 <1202774999.5984.106.camel@localhost>
	 <Pine.LNX.4.64.0802120335170.3378@scrub.home>
Content-Type: multipart/mixed; boundary="=-X5WDg1cKtK26Up4c0PWi"
Date: Wed, 13 Feb 2008 20:36:36 -0800
Message-Id: <1202963796.6195.141.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-X5WDg1cKtK26Up4c0PWi
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2008-02-12 at 15:36 +0100, Roman Zippel wrote:
> On Mon, 11 Feb 2008, john stultz wrote:
> > This fine grained error accounting is where the bug I'm trying to
> > address is cropping up from. In order to have the comparison we need to
> > have two values:
> >  A: The clocksource's notion of how long the fixed interval is.
> >  B: NTP's notion of how long the fixed interval is.
> > 
> > When no NTP adjustment is being made, these two values should be equal,
> > but currently they are not. This is what causes the 280ppm error seen on
> > my test system.
> > 
> > Part A is calculated in the following fashion:
> > 	#define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
> > 
> > 	Which is then functionally shifted up by TICK_LENGTH_SHIFT, but for the
> > course of this discussion, lets ignore that.
> > 
> > Part B is calculated in ntp_update_frequency() as:
> > 
> > 	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
> > 				<< TICK_LENGTH_SHIFT;
> > 	second_length += (s64)CLOCK_TICK_ADJUST << TICK_LENGTH_SHIFT;
> > 	second_length += (s64)time_freq << (TICK_LENGTH_SHIFT - SHIFT_NSEC);
> > 
> > 	tick_length_base = second_length;
> > 	do_div(tick_length_base, NTP_INTERVAL_FREQ);
> > 
> > 
> > If we're assuming there is no NTP adjustment, and avoiding the
> > TICK_LENGTH_SHIFT, this can be shorted to:
> > 	B = ((TICK_USEC * NSEC_PER_USEC * USER_HZ)
> > 		+ CLOCK_TICK_ADJUST)/NTP_ITNERVAL_FREQ
> > 
> > 
> > The A vs B comparison can be shortened further to:
> > 	NSEC_PER_SEC != (TICK_USEC * NSEC_PER_USEC * USER_HZ)
> > 				+ CLOCK_TICK_ADJUST
> > 
> > So now on to what seems to be the point of contention:
> > 	If A != B, which side do we fix?
> > 
> > 
> > My patches fix the A side so that it matches B, which on its face isn't
> > terribly complicated, but you seem to be suggesting we fix the B side
> > instead (Now I'm assuming here, because there's no patch. So I can only
> > speak to your emails, which were not clear to me).
> 
> If we go from your base assumption above "there is no NTP adjustment", I 
> would actually agree with you and it wouldn't matter much on which side 
> to correct the equation.
> 
> The question is now what happens, if there are NTP adjustments, i.e. when 
> the time_freq value isn't zero. Based on this initialization we tell the 
> NTP daemon the base frequency, although not directly but it knows the 
> length freq1 == 1 sec. If the clock now needs adjustment, the NTP daemon 
> tells the kernel via time_freq how to change the speed so that freq1 == 
> 1 sec + time_freq.
> 
> The problem is now that by using CLOCK_TICK_ADJUST we are cheating and we 
> don't tell the NTP daemon the real frequency. We define 1 sec as freq2 + 
> tick_adjust and with the NTP adjustment we have freq2 + tick_adj == 1 sec 
> + time_freq. Above initialization now calcalutes the base time length for 
> an update interval of freq2 / NTP_INTERVAL_FREQ, this means the requested 
> time_freq adjustment isn't applied to (freq2 + tick_adj) cycles but to 
> freq2 cycles, so this finally means any adjustment made by the NTP daemon 
> is slightly off.

Oh! So your issue is that since time_freq is stored in ppm, or in effect
a usecs per sec offset, when we add it to something other then 1 second
we mis-apply what NTP tells us to. Is that right?


> To demonstrate this let's look at some real values and let's use the PIT 
> for it (as this is where this originated and on which CLOCK_TICK_ADJUST is 
> based on). With freq1=1193182 and HZ=1000 we program the timer with 1193 
> cycles and the actual update frequency is freq2=1193000. To adjust for 
> this difference we change the length of a timer tick:
> 
> 	(NSEC_PER_SEC + CLOCK_TICK_ADJUST) / NTP_INTERVAL_FREQ
> 
> or
> 
> 	(10^9 nsec - 152533 nsec) / 1000
> 
> This way every 1000 interrupts or 1193000 cycles the clock is advanced by 
> 999847467 nsec, so that we advance time according to freq1, but any 
> further adjustments aren't applied to an interval of what the NTP daemon 
> thinks is 1 sec but 999847467 nsec instead.

Right, so if NTP has us apply a 10ppm adjustment, instead of doing:
	NSEC_PER_SEC + 10,000

We're doing:
	NSEC_PER_SEC + CLOCK_TICK_ADJUST + 10,000

Which, if I'm doing my math right, results in a 10.002ppm adjustment
(using the 999847467ns number above), instead of just a 10ppm
adjustment.

Now, true, this is an error, but it is a pretty small one. Even at the
maximum 500ppm value, it only results in an error of 76 parts per
billion. As you'll see below, that tends to be less error then what we
get from the clock granularity. Is there something else I'm missing here
or is this really the core issue you're concerned with?

If not, I'll agree that we may need to tune the "B" side of the
equation, but can we also agree that the very large error caused, even
without NTP adjustments, being involved by the A != B can be addressed
separately. That way if A is calculated in the same way as B, when we
fix B, we will at the same time fix A. Does that sound like a step
forward?

> In consequence this means, if we want to improve timekeeping, we first set 
> the (update_cycles * NTP_INTERVAL_FREQ) interval as close as possible to 
> the real frequency. It doesn't has to be perfect as we usually don't know 
> the real frequency with 100% certainty anyway. 

This might need some more explanation, as I'm not certain I know what
update_cycles refers to. Do you mean cycle_interval? I guess I'm not
completely sure how you're suggesting we change things here.

> Second, we drop the tick 
> adjustment if possible and leave the adjustments to the NTP daemon and as 
> long as the drift is within the 500ppm limit it has no problem to manage 
> this.

Dropping the tick adjustment? By that do you mean the tick_usec value
set by adjtimex()? I don't quite see why we want that. Could you expand
here?


> > However, what happens if a system uses the PIT or jiffies clocksource,
> > which do suffer from the HZ / ACTHZ error resolved by the patch linked
> > to above? Since those clocksources are so course, we still need to take
> > that error into account. So in that regard the assumptions are still
> > valid, no?
> > 
> > You've seemingly suggested we set CLOCK_TICK_ADJUST to zero in the
> > CONFIG_NO_HZ situation, however note that a CONFIG_NO_HZ kernel should
> > be able to  boot and run on a box that only supports the jiffies or pit
> > clocksource (just not be able to switching into NO_HZ mode). Further,
> > how does that resolve the issue w/ the tsc/hpet/acpi_pm clocksources
> > that still exist when CONFIG_NO_HZ=n?
> > 
> > I just don't see how this will work.
> 
> Look at your Part A, with NO_HZ the update interval is much larger, so any 
> rounding error becomes practically irrelevant. In the above PIT example 
> the update interval wouldn't be 1193 cycles but 596591 cycles instead.

Ok, so sitting down and doing the math, I see for the pit clocksource
your point is correct. For relatively fine grained clocksources (the pit
having ~900ns resolution) the larger the cycle_interval gets, the
smaller the error becomes. So when the NTP_INTERVAL_FREQ is 2 instead of
HZ, the error does get quite small, even if we don't add in the
CLOCK_TICK_ADJUST factor.

I think here's where the contention has been, as I've been using the
jiffies clocksource in my head for the previous back-and-forths. The
jiffies clocksource is different, as due to its coarseness, the normal
cycles_interval is only 1. So dropping NTP_INTERVAL_FREQ from HZ to 2
doesn't improve the error, it basically stays constant.

I sat down and ran through some numbers, seeing how the error rates
changed as HZ changed, with and without CLOCK_TICK_ADJUST and how NO_HZ
effects it as well. The .c file is attached, but here is the output for
jiffies, pit, and acpi_pm:


HZ=1000 CLOCK_TICK_ADJUST=-152533
jiffies     	467 ppb error
jiffies NOHZ	467 ppb error
pit     	0 ppb error
pit NOHZ	0 ppb error
acpi_pm     	-280 ppb error
acpi_pm NOHZ	279 ppb error

HZ=100 CLOCK_TICK_ADJUST=15085
jiffies     	15085 ppb error
jiffies NOHZ	15085 ppb error
pit     	-1 ppb error
pit NOHZ	-1 ppb error
acpi_pm     	-281 ppb error
acpi_pm NOHZ	278 ppb error

HZ=250 CLOCK_TICK_ADJUST=56990
jiffies     	-5510 ppb error
jiffies NOHZ	-5510 ppb error
pit     	0 ppb error
pit NOHZ	0 ppb error
acpi_pm     	-281 ppb error
acpi_pm NOHZ	278 ppb error

HZ=300 CLOCK_TICK_ADJUST=-68723
jiffies     	-3523 ppb error
jiffies NOHZ	-3523 ppb error
pit     	1 ppb error
pit NOHZ	1 ppb error
acpi_pm     	-279 ppb error
acpi_pm NOHZ	279 ppb error

HZ=1000 CLOCK_TICK_ADJUST=0
jiffies     	153000 ppb error
jiffies NOHZ	153000 ppb error
pit     	152533 ppb error
pit NOHZ	0 ppb error
acpi_pm     	-127112 ppb error
acpi_pm NOHZ	279 ppb error

HZ=100 CLOCK_TICK_ADJUST=0
jiffies     	0 ppb error
jiffies NOHZ	0 ppb error
pit     	-15086 ppb error
pit NOHZ	0 ppb error
acpi_pm     	12571 ppb error
acpi_pm NOHZ	279 ppb error

HZ=250 CLOCK_TICK_ADJUST=0
jiffies     	-62500 ppb error
jiffies NOHZ	-62500 ppb error
pit     	-56990 ppb error
pit NOHZ	0 ppb error
acpi_pm     	12571 ppb error
acpi_pm NOHZ	279 ppb error

HZ=300 CLOCK_TICK_ADJUST=0
jiffies     	65200 ppb error
jiffies NOHZ	65200 ppb error
pit     	68724 ppb error
pit NOHZ	0 ppb error
acpi_pm     	-15366 ppb error
acpi_pm NOHZ	279 ppb error

So you are right, w/ pit & NO_HZ, the granularity error is always very
small both with or without CLOCK_TICK_ADJUST. 

However, without CLOCK_TICK_ADJUST, the jiffies error increases for all
values of HZ except 100 (which at first seems odd, but seems to be due
to loss from rounding in the ACTHZ calculation).

One interesting surprise in the data: With CLOCK_TICK_ADJUST=0, the
acpi_pm's error frequency shot up in the !NO_HZ cases. This ends up
being due to the acpi_pm being a very close to a multiple (3x) of the
pit frequency, so CLOCK_TICK_ADJUST helps it as well.


> I hope this helps to understand what I suggested. For NO_HZ we can just 
> drop this correction without problems. In the other case it's a little 
> more complicated, but we basically have to check the update interval and 
> if (interval * NTP_INTERVAL_FREQ) is within the 500ppm limit there isn't 
> much we really have to do.

Well, if it weren't for the jiffies clocksource error, to correct for
the sub 100ppb error, I'd agree with you to #define CLOCK_TICK_ADJUST 0
for CONFIG_NO_HZ. But until that's worked out I'm not sure.

Further it seems to point that if we are going to be chasing down small
sub-100ppb errors (which I think would be great to do, but lets not make
users to endure 200+ppm errors while we debate the fine-tuning :) we
might want to consider a method where we let ntp_update_freq take into
account the current clocksource's interval length, so it becomes the
base value against which we apply adjustments (scaled appropriately).


Phew, this is turning into a long mail. So let's summarize:

There are 3 sources of error that we've discussed here:
1) The large (280ppm) error seen with no-NTP adjustment, caused by the
inconsistent (A!=B) interval comparisons which started this discussion,
which my patch does address.

2) The medium (153-0ppm)clocksource granularity error shown in the data
above, caused by the actual interval length not matching the requested
interval length (what CLOCK_TICK_ADJUST tries to compensate for when
using jiffies/PIT).

3) The smaller (0.076ppm max) NTP adjustment error caused by the
parts-per-billion == nsec-per-sec shortcut used in combination w/ a base
interval that is not actually a second (due to CLOCK_TICK_ADJUST being
added in) in ntp_update_frequency() 

All of these are somewhat interdependent. One could consider that #1 is
in part due to #2, and #2 also causes #3, as there isn't proper scaling
being done in #3.

Fixing all of these in one swoop would be great, and I think we should
spend time continuing to refine the code. However, I'm just not sure
that we have a solution at this point for all the cases we have to
consider.

So given I do want to continue this discussion and work, would it be
possible that I fix up the #1 item above (including resolving the double
conflicting merges that have already gone in) as implemented in my last
patch, without your objection?

Again, I really appreciate you're continued deep observations and
feedback here.

thanks
-john

--=-X5WDg1cKtK26Up4c0PWi
Content-Disposition: attachment; filename=error-calc.c
Content-Type: text/x-csrc; name=error-calc.c; charset=utf-8
Content-Transfer-Encoding: 7bit

/* The following contains adapted code from the kernel, thus is Licensed under the GPLv2
 */
#include <stdio.h>

#define HZ 1000

#define NSEC_PER_SEC 1000000000LL

#define PMTMR_TICKS_PER_SEC	3579545

#define CLOCK_TICK_RATE		1193182

#define LATCH  ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
#define CLOCK_TICK_OVERFLOW	(LATCH * HZ - CLOCK_TICK_RATE)
#define SH_DIV(NOM,DEN,LSH) (   (((NOM) / (DEN)) << (LSH))              \
                             + ((((NOM) % (DEN)) << (LSH)) + (DEN) / 2) / (DEN))
#define ACTHZ (SH_DIV (CLOCK_TICK_RATE, LATCH, 8))
#define NSEC_PER_JIFFY	((unsigned long)((((unsigned long long)NSEC_PER_SEC)<<8)/ACTHZ))


#define CLOCK_TICK_ADJUST 0
#define XCLOCK_TICK_ADJUST	(((long long)CLOCK_TICK_OVERFLOW * NSEC_PER_SEC) / \
					(long long)CLOCK_TICK_RATE)


unsigned long hz2mult(unsigned long hz, unsigned long shift)
{
        unsigned long long tmp = NSEC_PER_SEC << shift;
        return (tmp + hz/2)/hz;
}



void calculate_values(char* name, unsigned long mult, unsigned long shift, unsigned long ntp_hz)
{
	unsigned long long tmp;
	unsigned long long length_nsec = (NSEC_PER_SEC + CLOCK_TICK_ADJUST);
	unsigned long long interval_length = length_nsec/ntp_hz;
	long long error;

//	printf("\n%s\n==========\n", name);
	printf("%s	", name);
	tmp = interval_length;
	tmp <<= shift;
	tmp += mult/2;
	tmp /= mult;
	if(tmp == 0) {
		printf("dived to zero!\n");
		tmp = 1;
	}
	
	
	
//	printf("%llu cycles per %llu ns\n", tmp, interval_length);
//	printf("%llu ns per cycle\n", (1*mult)>>shift);
//	printf("%llu ns per interval\n", (tmp*mult)>>shift);


	error = ((interval_length*ntp_hz) << shift) - ((tmp*ntp_hz*mult));
	error >>= shift;
	
	printf("%lld ppb error\n",error);

}


void main(void)
{
	unsigned long shift, mult;
	
	printf("HZ=%ld CLOCK_TICK_ADJUST=%ld\n", HZ, CLOCK_TICK_ADJUST);

	/* jiffies */
	calculate_values("jiffies     ", NSEC_PER_JIFFY  << 8, 8, HZ);
	calculate_values("jiffies NOHZ", NSEC_PER_JIFFY  << 8, 8, 2);
	
	/* pit */
	calculate_values("pit     ", hz2mult(CLOCK_TICK_RATE,20), 20, HZ);
	calculate_values("pit NOHZ", hz2mult(CLOCK_TICK_RATE,20), 20, 2);

	/* acpi_pm */
	calculate_values("acpi_pm     ", hz2mult(PMTMR_TICKS_PER_SEC,22), 22, HZ);
	calculate_values("acpi_pm NOHZ", hz2mult(PMTMR_TICKS_PER_SEC,22), 22, 2);
	
	printf("\n");
}

--=-X5WDg1cKtK26Up4c0PWi--

