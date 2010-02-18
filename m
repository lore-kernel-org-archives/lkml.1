Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792Ab0BRWaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 17:30:16 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:53762 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758743Ab0BRWaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 17:30:14 -0500
Subject: Re: Bug in HPET RTC emulation.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: venkatesh.pallipadi@intel.com
Cc: vojtech@suse.cz, Dan Hecht <dhecht@vmware.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1265765192.1470.24.camel@ank32.eng.vmware.com>
References: <1265765192.1470.24.camel@ank32.eng.vmware.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 18 Feb 2010 14:30:08 -0800
Message-Id: <1266532208.4757.14.camel@promb-2n-dhcp251.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Copying LKML]

<ping>

Not sure if you guys got a chance to look at this patch, the fix is
pretty trivial too.

Thanks,
Alok

On Tue, 2010-02-09 at 17:26 -0800, Alok Kataria wrote:
> Hi Venki/ Vojtech,
> 
> We think there exists a bug in the HPET code that emulates the RTC. 
> 
> In the normal case, when the RTC frequency is set, the rtc driver tells
> the hpet code about it here:
> 
> int hpet_set_periodic_freq(unsigned long freq)
> {
> 	uint64_t clc;
> 
> 	if (!is_hpet_enabled())
> 		return 0;
> 
> 	if (freq <= DEFAULT_RTC_INT_FREQ)
> 		hpet_pie_limit = DEFAULT_RTC_INT_FREQ / freq;
> 	else {
> 		clc = (uint64_t) hpet_clockevent.mult * NSEC_PER_SEC;
> 		do_div(clc, freq);
> 		clc >>= hpet_clockevent.shift;
> 		hpet_pie_delta = (unsigned long) clc;
> 	}
> 	return 1;
> }
> 
> If freq is set to 64Hz (DEFAULT_RTC_INT_FREQ) or lower, then
> hpet_pie_limit (a static) is set to non-zero.
> Then, on every one-shot HPET interrupt, hpet_rtc_timer_reinit is called
> to compute the next timeout. Well, that function has this logic:
> 
> 	if (!(hpet_rtc_flags & RTC_PIE) || hpet_pie_limit)
> 		delta = hpet_default_delta;
> 	else
> 		delta = hpet_pie_delta;
> 
> Since hpet_pie_limit is not 0, hpet_default_delta is used. That
> corresponds to 64Hz.
> 
> Now, if you set a different rtc frequency, you'll take the else path
> through hpet_set_periodic_freq, but unfortunately no one resets
> hpet_pie_limit back to 0.
> 
> Boom....now you are stuck with 64Hz HPET interrupts forever. 
> 
> The patch below just resets the hpet_pie_limit value when requested freq
> is greater than DEFAULT_RTC_INT_FREQ, which we think fixes this problem.
> 
> Thanks,
> Alok
> 
> Index: linux-2.6/arch/x86/kernel/hpet.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/hpet.c	2010-01-14 13:47:15.000000000 -0800
> +++ linux-2.6/arch/x86/kernel/hpet.c	2010-02-09 17:20:50.000000000 -0800
> @@ -1135,6 +1135,7 @@ int hpet_set_periodic_freq(unsigned long
>  		do_div(clc, freq);
>  		clc >>= hpet_clockevent.shift;
>  		hpet_pie_delta = clc;
> +		hpet_pie_limit = 0;
>  	}
>  	return 1;
>  }
> 

