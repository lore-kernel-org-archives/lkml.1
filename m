Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbZJNGgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbZJNGgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZJNGgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:36:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59859 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbZJNGgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:36:18 -0400
Date: Wed, 14 Oct 2009 08:35:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, david-b@pacbell.net,
       hpa@zytor.com, rjw@sisk.pl, tglx@linutronix.de,
       linux-kernel@vger.kernel.org,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: + rtc-disable-hpet-emulation-on-suspend.patch added to -mm tree
Message-ID: <20091014063516.GF784@elte.hu>
References: <200910132208.n9DM83xa031357@imap1.linux-foundation.org> <20091014055639.GA784@elte.hu> <1255501643.4484.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255501643.4484.13.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> On Wed, 2009-10-14 at 07:56 +0200, Ingo Molnar wrote:
> > * akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
> > 
> > > ------------------------------------------------------
> > > Subject: rtc: disable hpet emulation on suspend
> > > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > > 
> > > I noticed that rtc wont generate interrupts after a resume from disk.
> > > Here hpet rtc emulation is used.
> > > 
> > > Problem is that rtc hpet comparator, isn't reinitialized after resume.
> > > Easiest way to solve this, is always mask all hpet interrupts on suspend
> > > This is triggered, when suspending with alarm set.
> > > 
> > > 
> > > Otherwise, hpet driver will think it doesn't need to reinitialize
> > > the rtc comparator, thus rtc interrupts won't work.
> > > 
> > > This emulation isn't need for wakealarm.
> > 
> > > -		hpet_mask_rtc_irq_bit(mask);
> > >  
> > > +		/* shut down hpet emulation - we don't need it for alarm */
> > > +		hpet_mask_rtc_irq_bit(RTC_PIE|RTC_AIE|RTC_UIE);
> > >  		cmos_checkintr(cmos, tmp);
> > 
> > Would be nice to also unconditionally reinitialize the hpet/rtc after 
> > resume - regardless of what state we left it in.
> 
> I think this is already done.
> Problem was that rtc driver was leaving the RTC_AIE, thus breaking the
> initialization.
> 
> If there are no users of hpet on suspend, (periodic,alarm,update), then
> it won't be initialized on resume (only rtc comparator part, other parts
> are initialized correctly nowadays) but as soon as anybody start using
> it, it will be.
>  
> 
> > 
> > Also, are you sure this does not break things like 
> > CONFIG_PM_TEST_SUSPEND=y which rely on wakealarm?
> 
> 
> This shouldn't break anything. hpet irqs aren't used for the actual
> alarm.
> 
> In fact I used a script to loop over real hibernation cycles, and it 
> works with or without this patch.
> 
> But with this patch, hwclock works after a resume.

Excellent - thanks!

	Ingo
