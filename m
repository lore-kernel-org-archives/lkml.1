Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbXFTVG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbXFTVG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 17:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbXFTVGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 17:06:37 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:47988 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbXFTVGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 17:06:36 -0400
Subject: Re: [RFC] clocksouce implementation for powerpc
From: john stultz <johnstul@us.ibm.com>
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: Daniel Walker <dwalker@mvista.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, LinuxPPC-dev <linuxppc-dev@ozlabs.org>
In-Reply-To: <20070620065710.GR9768@bakeyournoodle.com>
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de>
	 <20070616101637.107940593@inhelltoy.tec.linutronix.de>
	 <1182009083.11539.369.camel@imap.mvista.com>
	 <20070620065710.GR9768@bakeyournoodle.com>
Content-Type: text/plain
Date: Wed, 20 Jun 2007 14:06:01 -0700
Message-Id: <1182373561.6559.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-20 at 16:57 +1000, Tony Breeds wrote:
> On Sat, Jun 16, 2007 at 08:51:23AM -0700, Daniel Walker wrote:
> > On Sat, 2007-06-16 at 10:36 +0000, Thomas Gleixner wrote:
> > > plain text document attachment
> > > (clocksource-add-settimeofday-hook.patch)
> > > From: Tony Breeds <tony@bakeyournoodle.com >
> > > 
> > > I'm working on a clocksource implementation for all powerpc platforms.
> > > some of these platforms needs to do a little work as part of the
> > > settimeofday() syscall and I can't see a way to do that without adding
> > > this hook to clocksource.
> > > 
> > 
> > 
> > I'd like to see how this is used? If the code that uses this API change
> > isn't ready yet, then this patch should really wait..
> 
> This is my current patch to rework arch/powerpc/kernel/time.c to create
> a clocksource.  It's not ready for inclusion.

Hey Tony,
	Thanks for sending this out! I really appreciate this work, as its been
on my todo forever, and I've just not been able to focus on it.
Currently it seems a bit minimal of a conversion (ideally there should
be very little time code left), but It looks like a great start!

More comments below.

> powerpc needs to keep the vdso in sync whenener settimeodfay() is
> called.  Adding the hook the to the clocksource structure was my way of
> allowing this to happen.  There are other approaches, but this seemed to
> best allow for runtime.  Initially I considered using update_vsyscall()
> but this is called from do_timer(), and I don't need this code run then
> :(

I might be missing a subtlety in the ppc code, but I'm still not sure if
I see the need for the clocksource settimeofday hook.

update_vsyscall() is intended to provide a hook that allows the generic
time code to provide all the needed timekeeping state to the arch
specific vsyscall implementation. It is called any time the base
timekeeping variables are changed.

You're already calling timer_recalc_offset from there which looks almost
as expensive as the settime hook, so I'm not sure I understand the
division.

But to your credit, the patch Sergei and I have been slowly working on
(I believe I've sent that to you already, but if not let me know) never
got the VDSO code working, so good show!

> +static void clocksource_settimeofday(struct clocksource *cs,
> +                                     struct timespec *ts)
> +{
> +	u64 new_xsec;
> +
> +#ifdef CONFIG_PPC_ISERIES
> +	if (firmware_has_feature(FW_FEATURE_ISERIES) && first_settimeofday) {
> +		iSeries_tb_recal();
> +		first_settimeofday = 0;
> +	}
> +#endif
> +
> +	/* Make userspace gettimeofday spin until we're done. */
> +	++vdso_data->tb_update_count;
> +	smp_mb();
> +
> +	/* In case of a large backwards jump in time with NTP, we want the
> +	 * clock to be updated as soon as the PLL is again in lock.
> +	 */
> +	last_rtc_update = xtime.tv_sec - 658;
> +
> +	new_xsec = xtime.tv_nsec;
> +	if (new_xsec != 0) {
> +		new_xsec *= XSEC_PER_SEC;
> +		do_div(new_xsec, NSEC_PER_SEC);
> +	}
> +
> +	new_xsec += (u64)xtime.tv_sec * XSEC_PER_SEC;
> +
> +	vdso_data->tz_minuteswest = sys_tz.tz_minuteswest;
> +	vdso_data->tz_dsttime = sys_tz.tz_dsttime;
> +
> +	update_gtod(tb_last_jiffy, new_xsec, do_gtod.varp->tb_to_xs);
> +}
> +
> +void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
> +{
> +	timer_recalc_offset(tb_last_jiffy);
> +	timer_check_rtc();
> +}

I think it would be enlightening to flatten this out a bit. Putting both
the timer_recalc_offset and clocksource_settime code in the same
function. It might illustrate where some optimizations could be done and
where it might make more sense to split things up.

Also I'd leave timer_check_rtc() in the timer_interrupt for now (later
moving it to tglx's generic rtc update).

thanks
-john

