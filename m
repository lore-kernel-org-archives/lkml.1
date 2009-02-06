Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbZBFRLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbZBFRLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 12:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbZBFRLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 12:11:01 -0500
Received: from evergreen.ssec.wisc.edu ([128.104.108.253]:52794 "EHLO
	evergreen.ssec.wisc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbZBFRLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 12:11:01 -0500
Date: Fri, 6 Feb 2009 11:11:00 -0600
From: Daniel Forrest <dan.forrest@ssec.wisc.edu>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: clean up hpet timer reinit
Message-ID: <20090206171100.GA31075@evergreen.ssec.wisc.edu>
Reply-To: Daniel Forrest <dan.forrest@ssec.wisc.edu>
References: <498BF9DA.5030302@openvz.org> <20090206140943.GD3415@elte.hu> <20090206154201.GA28883@evergreen.ssec.wisc.edu> <498C6C90.4070806@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498C6C90.4070806@openvz.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 08:00:00PM +0300, Pavel Emelyanov wrote:
> Daniel Forrest wrote:
> > On Fri, Feb 06, 2009 at 03:09:43PM +0100, Ingo Molnar wrote:
> >> * Pavel Emelyanov <xemul@openvz.org> wrote:
> >>
> >>> Sorry for late response - took some time to re-check this...
> >> Applied to tip:timers/urgent, thanks Pavel!
> >>
> >> Note, since i've already queued up the minimal fix i've created a delta 
> >> cleanup patch from your v2 patch - see it below. (It is the exact same end 
> >> result in terms of code, just a nicer splitup.)
> >>
> >> 	Ingo
> >>
> >> ------------------->
> >> >From ff08f76d738d0ec0f334b187f61e160caa321d54 Mon Sep 17 00:00:00 2001
> >> From: Pavel Emelyanov <xemul@openvz.org>
> >> Date: Wed, 4 Feb 2009 13:40:31 +0300
> >> Subject: [PATCH] x86: clean up hpet timer reinit
> >>
> >> Implement Linus's suggestion: introduce the hpet_cnt_ahead()
> >> helper function to compare hpet time values - like other
> >> wrapping counter comparisons are abstracted away elsewhere.
> >> (jiffies, ktime_t, etc.)
> >>
> >> Reported-by: Kirill Korotaev <dev@openvz.org>
> >> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> >> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >> ---
> >>  arch/x86/kernel/hpet.c |   12 ++++++++++--
> >>  1 files changed, 10 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> >> index c761f91..388254f 100644
> >> --- a/arch/x86/kernel/hpet.c
> >> +++ b/arch/x86/kernel/hpet.c
> >> @@ -897,7 +897,7 @@ static unsigned long hpet_rtc_flags;
> >>  static int hpet_prev_update_sec;
> >>  static struct rtc_time hpet_alarm_time;
> >>  static unsigned long hpet_pie_count;
> >> -static unsigned long hpet_t1_cmp;
> >> +static u32 hpet_t1_cmp;
> >>  static unsigned long hpet_default_delta;
> >>  static unsigned long hpet_pie_delta;
> >>  static unsigned long hpet_pie_limit;
> >> @@ -905,6 +905,14 @@ static unsigned long hpet_pie_limit;
> >>  static rtc_irq_handler irq_handler;
> >>  
> >>  /*
> >> + * Check that the hpet counter c1 is ahead of the c2
> >> + */
> >> +static inline int hpet_cnt_ahead(u32 c1, u32 c2)
> >> +{
> >> +	return (s32)(c2 - c1) < 0;
> >> +}
> >> +
> >> +/*
> >>   * Registers a IRQ handler.
> >>   */
> >>  int hpet_register_irq_handler(rtc_irq_handler handler)
> >> @@ -1075,7 +1083,7 @@ static void hpet_rtc_timer_reinit(void)
> >>  		hpet_t1_cmp += delta;
> >>  		hpet_writel(hpet_t1_cmp, HPET_T1_CMP);
> >>  		lost_ints++;
> >> -	} while ((s32)(hpet_readl(HPET_COUNTER) - hpet_t1_cmp) > 0);
> >> +	} while (!hpet_cnt_ahead(hpet_t1_cmp, hpet_readl(HPET_COUNTER)));
> > 
> > These are not equivalent for the case where the values are equal.
> > 
> > Let "A = hpet_t1_cmp" and "B = hpet_readl(HPET_COUNTER)"
> > 
> > Then "!(A > B)" means "(B - A) >= 0" not "(B - A) > 0"
> > 
> > Shouldn't it be:
> > 
> > +	} while (hpet_cnt_ahead(hpet_readl(HPET_COUNTER), hpet_t1_cmp));
> > 
> > Or am I missing something?
> 
> When comparator it equal to counter (the corner case we're talking about) the
> hpet_cnt_ahead will return false and the loop will go on shifting the cmp,
> which is what we need here.
> 

Okay, as long as that is what is intended.  My point was just that the
code being replaced did not loop when the counts were equal so it
looked like an unintended change.

> >>  
> >>  	if (lost_ints) {
> >>  		if (hpet_rtc_flags & RTC_PIE)
> >> --

-- 
Daniel K. Forrest		Space Science and
dan.forrest@ssec.wisc.edu	Engineering Center
(608) 890 - 0558		University of Wisconsin, Madison
