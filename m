Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab0BCWJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 17:09:00 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54155 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab0BCWI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 17:08:59 -0500
Subject: Re: [PATCH 1/5] ntp: add hardpps implementation
From: john stultz <johnstul@us.ibm.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       "Nikita V. Youshchenko" <yoush@cs.msu.su>, stas@lvk.cs.msu.su,
       Rodolfo Giometti <giometti@enneenne.com>,
       Rodolfo Giometti <giometti@linux.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>
In-Reply-To: <c90af235d8e68733f04b5365d1be2380ccb23569.1265228858.git.lasaine@lvk.cs.msu.su>
References: <cover.1265228858.git.lasaine@lvk.cs.msu.su>
	 <c90af235d8e68733f04b5365d1be2380ccb23569.1265228858.git.lasaine@lvk.cs.msu.su>
Content-Type: text/plain
Date: Wed, 03 Feb 2010 14:08:50 -0800
Message-Id: <1265234930.3255.54.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 23:56 +0300, Alexander Gordeev wrote:
> This commit adds hardpps() implementation based upon the original one
> from the NTPv4 reference kernel code. However, it is highly optimized
> towards very fast syncronization and maximum stickness to PPS signal.
> The typical error is less then a microsecond.
> To make it sync faster I had to throw away exponential phase filter so
> that the full phase offset is corrected immediately. Then I also had to
> throw away median phase filter because it gives a bigger error itself
> if used without exponential filter.
> Maybe we will find an appropriate filtering scheme in the future but
> it's not necessary if the signal quality is ok.
> 
> Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Very cool! Bunch of style comments below.

One other thing: From the comments in the code, it looks like this may
have come straight from the reference implementation. You might want to
provide some extra documentation or comment providing proper credit, and
clarifying that the code is in fact GPLv2 compatible. 

Also please review Section 12 of Documentation/SubmittingPatches 

thanks
-john




[snip]
> +long pps_tf[3];			/* phase median filter */
> +s64 pps_freq;			/* scaled frequency offset (ns/s) */
> +s64 pps_fcount;			/* frequency accumulator */
> +long pps_jitter;		/* nominal jitter (ns) */
> +long pps_stabil;		/* nominal stability (scaled ns/s) */
> +int pps_valid;			/* signal watchdog counter */
> +int pps_shift;			/* nominal interval duration (s) (shift) */
> +int pps_shiftmax;		/* max interval duration (s) (shift) */
> +int pps_intcnt;			/* interval counter */
> +
> +/*
> + * PPS signal quality monitors
> + */
> +long pps_calcnt;		/* calibration intervals */
> +long pps_jitcnt;		/* jitter limit exceeded */
> +long pps_stbcnt;		/* stability limit exceeded */
> +long pps_errcnt;		/* calibration errors */
> +

Shouldn't all of the above values be made static?

[snip]

>  /*
> @@ -233,8 +277,6 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
>   */
>  void second_overflow(void)
>  {
> -	s64 delta;
> -
>  	/* Bump the maxerror field */
>  	time_maxerror += MAXFREQ / NSEC_PER_USEC;
>  	if (time_maxerror > NTP_PHASE_LIMIT) {
> @@ -248,9 +290,27 @@ void second_overflow(void)
>  	 */
>  	tick_length	 = tick_length_base;
> 
> -	delta		 = shift_right(time_offset, SHIFT_PLL + time_constant);
> -	time_offset	-= delta;
> -	tick_length	+= delta;
> +#ifdef CONFIG_NTP_PPS
> +	if (time_status & STA_PPSTIME && time_status & STA_PPSSIGNAL) {
> +		tick_length	+= time_offset;
> +		time_offset	 = 0;
> +	} else
> +#endif /* CONFIG_NTP_PPS */
> +	{
> +		s64 delta;
> +		delta		 =
> +			shift_right(time_offset, SHIFT_PLL + time_constant);
> +		time_offset	-= delta;
> +		tick_length	+= delta;
> +	}


Ugh. Surely there's a better way to do this then using the ifdefs in
code? 

Maybe something like:

#ifdef CONFIG_NTP_PPS
/* Comment about how pps consumes the whole offset */
static inline s64 ntp_offset_chunk(s64 offset)
{
	if (time_status & STA_PPSTIME && time_status & STA_PPSSIGNAL)
		return offset
	else
		return shift_right(offset, SHIFT_PLL + time_constant);
}
#else
static inline s64 ntp_offset_chunk(s64 offset)
{
	return shift_right(offset, SHIFT_PLL + time_constant);
}
#endif

Then in second_overflow():

delta		 = ntp_offset_chunk(time_offset);
time_offset	-= delta;
tick_length	+= delta;

Feel free to use a better name then ntp_offset_chunk(), but this keeps
the logic from being obfuscated by all the #ifdefs


> +#ifdef	CONFIG_NTP_PPS
> +	if (pps_valid > 0)
> +		pps_valid--;
> +	else
> +		time_status &= ~(STA_PPSSIGNAL | STA_PPSJITTER |
> +				 STA_PPSWANDER | STA_PPSERROR);
> +#endif /* CONFIG_NTP_PPS */

Similarly, can some sort of pps_dec_valid() inline function be used
here?

[snip]

> +#ifdef	CONFIG_NTP_PPS
> +
> +/* normalize the timestamp so that nsec is in the
> +   ( -NSEC_PER_SEC / 2, NSEC_PER_SEC / 2 ] interval */
> +static inline struct timespec pps_normalize_ts(struct timespec ts)
> +{
> +	if (ts.tv_nsec > (NSEC_PER_SEC >> 1)) {
> +		ts.tv_nsec -= NSEC_PER_SEC;
> +		ts.tv_sec++;
> +	}
> +
> +	return ts;
> +}

Hrmm.. So by converting a timespec into a second + [-NSEC_PER_SEC/2,
NSEC_PER_SEC/2] value, you aren't really using a timespec anymore,
right? I mean, the timepsec_valid() would fail in many cases, for
instance.

I realize its pretty close, and you *can* use a timespec this way, but
to me it seems reasonable to introduce a new structure (pps_normtime?)
so that its clear you shouldn't exchange timespec values and
pps_normtime values directly?

This is sort of a nit, and maybe others disagree, so not the most
critical issue. But it seems like you're abusing the structure a bit.

[snip]
> +/* decrease frequency calibration interval length */
> +static inline void pps_dec_freq_interval(void)
> +{
> +	if (--pps_intcnt <= -4) {
> +		pps_intcnt = -4;

Is -4 a magic value?

[snip]
> +	} else {	/* good sample */
> +		if (++pps_intcnt >= 4) {
> +			pps_intcnt = 4;

Again, the magic 4?

[snip]
> +	pps_stabil += (div_s64(((s64)delta_mod) <<
> +				(NTP_SCALE_SHIFT - SHIFT_USEC),
> +				NSEC_PER_USEC) - pps_stabil) >> PPS_FAVG;

Hmm. Two 64bit divides in this path? This code would run each second,
right? It would probably be good to see if this could be optimized a
little bit more, but I guess its similar to ntp_update_frequency() which
is called on adjtimex() calls (every 16 seconds at most with networked
ntp).

> +void hardpps(const struct timespec *p_ts, s64 nsec)
> +{
> +	struct timespec ts_norm, freq_norm;
> +
> +	ts_norm = pps_normalize_ts(*p_ts);
> +	freq_norm = pps_normalize_ts(ns_to_timespec(nsec));
> +
[snip]
> +
> +	write_seqlock_irq(&xtime_lock);

This is called possibly in irq context, right? So you probably want to
use write_seqlock_irqsave(), no?


thanks
-john


