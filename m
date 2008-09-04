Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbYIDSbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbYIDSbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbYIDSbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:31:44 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:33867 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751851AbYIDSbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:31:43 -0400
Subject: Re: [RFC patch 0/4] TSC calibration improvements
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Daniel Hecht <dhecht@vmware.com>,
       Garrett Smith <garrett@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <alpine.LFD.1.10.0809041044160.3400@nehalem.linux-foundation.org>
References: <20080904150339.896115280@linutronix.de>
	 <20080904153620.GC7120@elte.hu>
	 <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>
	 <1220549961.11753.22.camel@alok-dev1>
	 <alpine.LFD.1.10.0809041044160.3400@nehalem.linux-foundation.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 04 Sep 2008 11:31:43 -0700
Message-Id: <1220553103.11753.39.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-04 at 10:53 -0700, Linus Torvalds wrote:
> 
> On Thu, 4 Sep 2008, Alok Kataria wrote:
> >
> > Looping for a smaller timeout is really going to strain things for
> > Virtualization.
> 
> Can you check the patch I just sent out?
> 
> It loops for a _very_ short timeout, but on the other hand it should also
> absolutely immediately notice that it's getting the wrong expected values
> under virtualization, and the fast case will then fail early.

Yep tried that, the fast calibration failed in 4-5 reboots that i did
until now. Will do some more runs just to be sure.
> 
> It then falls back on the slow case, but I don't think you can avoid that
> under virtualization.

That's fine i think the slow calibration works well for us and we can
live with the added 200msec delay while booting. 

I am assuming the patch you just sent was for 2.6.27.
And that we won't be changing the timeout's after this patch.
So, can we also apply the 2 patches that I sent yesterday on top of this
one ? the one that calibrated against pmtimer/hpet over the full loop
and the one that fixed the warning message. Both of these will affect
the slower case, which is now not the common case when running on native
hardware.

In the long run though, I think to get rid of all this complexity, we
can think of getting the frequency from the hypervisor. Lets see, i will
try making a patch maybe early next week and send it for the x86 tree.

Thanks,
Alok

> 
> > Even on native hardware if you reduce the  timeout to less than 10ms it
> > may result in errors in the range of 2500ppm on a 2GHz systems when
> > calibrating against pmtimer/hpet, this is far worse than what NTP can
> > correct, afaik NTP can handle errors only upto 500ppm. And IMHO that is
> > the reason why we had a timeout of 50ms before (since it limits the
> > maximum theoretical error to 500ppm)
> 
> I would not mind at all having the more precise thing happen _later_,
> especially if we can do it incrementally.
> 
> One of the problems with the TSC calibration is that we need it fairly
> early (for things like usleep()), and it needs to be in the right
> ballpark. It definitely does not need to be in the parts-per-million
> range, it needs to be in the "within a few percent" range.
> 
> (To make matters worse, the TSC isn't then even used in practice for
> real-time clocks, because of variable frequency and/or halting in idle
> states. So the actual real-time clock will actually be based on HPET or
> PM_TIMER anyway most of the time).
> 
>                 Linus

