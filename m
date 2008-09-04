Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbYIDRjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbYIDRjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 13:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYIDRjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 13:39:23 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:48478 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671AbYIDRjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 13:39:22 -0400
Subject: Re: [RFC patch 0/4] TSC calibration improvements
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Dan Hecht <dhecht@vmware.com>,
       Garrett Smith <garrett@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>
References: <20080904150339.896115280@linutronix.de>
	 <20080904153620.GC7120@elte.hu>
	 <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 04 Sep 2008 10:39:21 -0700
Message-Id: <1220549961.11753.22.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-04 at 08:45 -0700, Linus Torvalds wrote:
> 
> On Thu, 4 Sep 2008, Ingo Molnar wrote:
> >
> > i've added them to tip/x86/tsc and merged it into tip/master - if
> > there's test success we can merge it into x86/urgent as well and push it
> > into v2.6.27. Any objections to that merge route?
> 
> I don't think it's quite that urgent, and wonder what the downside is of
> just changing the timeout to 10ms. On 32-bit x86, it was 30ms (I think)
> before the merge, so it sounds like 50ms was a bit excessive even before
> the whole "loop five times"/
> 
> So _short_ term, I'd really prefer (a) looping just three times and (b)
> looping with a smaller timeout.

Looping for a smaller timeout is really going to strain things for
Virtualization.
Even on native hardware if you reduce the  timeout to less than 10ms it
may result in errors in the range of 2500ppm on a 2GHz systems when
calibrating against pmtimer/hpet, this is far worse than what NTP can
correct, afaik NTP can handle errors only upto 500ppm. And IMHO that is
the reason why we had a timeout of 50ms before (since it limits the
maximum theoretical error to 500ppm)

In addition to that, the pmtimer hardware itself has some drift,
typically in the range of 20 to 100ppm.  If this drift happens to be in
the same direction as the error in measuring the tsc against the
pmtimer, we could have a total error of more than 500ppm in the tsc
frequency calibration code with the 50ms timeout. So anything less than
50msec of timeout is risky for virtualized environment.

If people think that new hardware is good enough to handle these errors
with a smaller timeout value thats okay, but for virtualized environment
we need to keep these timeouts as they are or increase them. 

If still there is a pressing need to reduce the timeout, then
alternatively, as Arjan suggested, we can ask the hardware (hypervisor)
for tsc frequency, and do this only if we are running under a hypervisor
( can't do this for h/w with constant TSC too since its not reliable as
mentioned by Linus).
This tsc freq from hypervisor, can be implemented using cpuid's if the
backend hypervisor supports that (VMware does). Let me know what people
think about this and we can work towards a standard interface. 

Thanks,
Alok
> 
> Long-term, I actually think even 10ms is actually a total waste. I'll post
> my trial "quick calibration" code that is more likely to fail under
> virtualization or SMM (or, indeed, perhaps even on things like TMTA CPU's
> that can have longer latencies due to translation), but that is really
> fast and knows very intimately when it succeeds. I just need to do
> slightly more testing.
> 
>                                 Linus

