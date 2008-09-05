Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbYIEWSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbYIEWSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 18:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbYIEWSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 18:18:17 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:58086 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646AbYIEWSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 18:18:16 -0400
Subject: Re: [RFC patch 0/4] TSC calibration improvements
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Dan Hecht <dhecht@vmware.com>,
       Garrett Smith <garrett@vmware.com>
In-Reply-To: <20080904213350.GA15678@elte.hu>
References: <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>
	 <20080904160036.GA18382@elte.hu>
	 <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org>
	 <20080904190728.59634020@lxorguk.ukuu.org.uk>
	 <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org>
	 <20080904204305.GA29065@elte.hu> <20080904205236.GA3864@elte.hu>
	 <alpine.LFD.1.10.0809041403450.3117@nehalem.linux-foundation.org>
	 <20080904213350.GA15678@elte.hu>
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 05 Sep 2008 15:18:15 -0700
Message-Id: <1220653095.14401.72.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-04 at 14:33 -0700, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Thu, 4 Sep 2008, Ingo Molnar wrote:
> > >
> > > hm, unless i'm missing something i think here we still have a small
> > > window for an SMI or some virtualization delay to slip in and cause
> > > massive inaccuracy: if the delay happens _after_ the last
> > > pit_expect_msb() and _before_ the external get_cycles() call. Right?
> >
> > Yes. I had the extra pit_expect_msb() originally, but decided that
> > basically a single-instruction race for somethign that ran without any
> > MSI for 15ms was a bit pointless.
> 
> the race is wider than that i think: all it takes an SMI at the last PIO
> access, so the window should be 1 usec, against a 15000 usecs period.
> That's 1 out of 15,000 boxes coming up with totally incorrect
> calibration.
> 
> we also might have a very theoretical race of an SMI taking exactly 65
> msecs so that the whole PIT wraps around and fools the fastpath - the
> chance for that would be around 1:300 - assuming we only have to hit the
> right MSB with a ~200 usecs precision). That assumes equal distribution
> of SMI costs which they certainly dont have - most of them are much less
> than 60 msecs. So i dont think it's an issue in practice - on real hw.
> 
> But it's still a possibility unless i'm missing something. We could
> protect against that case by reading the IRQ0-pending bit and making
> sure it's not pending after we have done the closing TSC readout.
> 
> > But adding another pit_expect_msb() is certainly not wrong.
> 

Hi, 
I ran the current tree with these patches on my VM setup for both 32 &
64bit around 200 reboots each. 
The system entered the FAST calibration mode more often this time,
around 25% of time.
And i had an interesting case where in the frequency that was calibrated
was 1875Mhz compared to actual ~1866Mhz, leaving an error of 0.5%.

Now, looking at the code.
Even with this last pit_expect_msb check, i think there can be a case
when a error spanning 114usec can slip in the TSC calculation. 

This can happen if, 
in the pit_expect_msb (the one just before the second read_tsc),
we hit an SMI/virtualization event *after* doing the 50 iterations of
PIT read loop, this allows the pit_expect_msb to succeed when the SMI
returns.

If this SMI/Virtualization event spans across the next PIT MSB increment
interval leaving sufficient time (100us) for the last pit_expect_msb to
succeed.
We can have a error of 1MSB tick increment - time taken for the last
pit_expect_msb to succeed, in the read TSC value.

i.e. a error of (214us - 100us) in the 15msec period, i.e. error of
7600PPM ??

And, in order for the TSC clocksource to keep correct time (on systems
where the TSC clocksource is usable), the TSC frequency estimate must be
within 500 ppm of its true frequency, otherwise NTP will not be able to
correct it.

So, IMHO we should not use this algorithm. 

I don't know if increasing the count threshold will help too, since that
threshold value may fail for some system which perform better than our
assumption of "we take 2us to do the 2 PIT reads". Atleast in
virtualized environment I can make no such guarantees. 

Thanks,
Alok

> ok, i kept that bit.
> 
>         Ingo

