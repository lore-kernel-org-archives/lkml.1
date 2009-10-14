Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbZJNG3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbZJNG3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbZJNG3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:29:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:29420 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbZJNG3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:29:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=p0eDMLTpXqFBAK2ByfNl0EAKjZlgUj7jhE1Y7kLlzMDNoXr/RBeFi3fwy+cYJ6k7g3
         xtj306gCSxOG9qDfTLqfJZULJNQlbeEzWM7ZzUVxyiFcwdR6RobmCQjZQfhJF2qZTDra
         fShbaCY/UF1WtIxs54MNhnz4z444hF7Bn5QmU=
Subject: Re: + rtc-disable-hpet-emulation-on-suspend.patch added to -mm tree
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, david-b@pacbell.net,
       hpa@zytor.com, rjw@sisk.pl, tglx@linutronix.de,
       linux-kernel@vger.kernel.org,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <20091014055639.GA784@elte.hu>
References: <200910132208.n9DM83xa031357@imap1.linux-foundation.org>
	 <20091014055639.GA784@elte.hu>
Content-Type: text/plain
Date: Wed, 14 Oct 2009 08:27:23 +0200
Message-Id: <1255501643.4484.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 07:56 +0200, Ingo Molnar wrote:
> * akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
> 
> > ------------------------------------------------------
> > Subject: rtc: disable hpet emulation on suspend
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > 
> > I noticed that rtc wont generate interrupts after a resume from disk.
> > Here hpet rtc emulation is used.
> > 
> > Problem is that rtc hpet comparator, isn't reinitialized after resume.
> > Easiest way to solve this, is always mask all hpet interrupts on suspend
> > This is triggered, when suspending with alarm set.
> > 
> > 
> > Otherwise, hpet driver will think it doesn't need to reinitialize
> > the rtc comparator, thus rtc interrupts won't work.
> > 
> > This emulation isn't need for wakealarm.
> 
> > -		hpet_mask_rtc_irq_bit(mask);
> >  
> > +		/* shut down hpet emulation - we don't need it for alarm */
> > +		hpet_mask_rtc_irq_bit(RTC_PIE|RTC_AIE|RTC_UIE);
> >  		cmos_checkintr(cmos, tmp);
> 
> Would be nice to also unconditionally reinitialize the hpet/rtc after 
> resume - regardless of what state we left it in.

I think this is already done.
Problem was that rtc driver was leaving the RTC_AIE, thus breaking the
initialization.

If there are no users of hpet on suspend, (periodic,alarm,update), then
it won't be initialized on resume (only rtc comparator part, other parts
are initialized correctly nowadays) but as soon as anybody start using
it, it will be.
 

> 
> Also, are you sure this does not break things like 
> CONFIG_PM_TEST_SUSPEND=y which rely on wakealarm?


This shouldn't break anything. hpet irqs aren't used for the actual
alarm.

In fact I used a script to loop over real hibernation cycles, and it
works with or without this patch.

But with this patch, hwclock works after a resume.


Best regards,
	Maxim Levitsky

