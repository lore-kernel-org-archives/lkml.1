Return-Path: <linux-kernel-owner+w=401wt.eu-S1161436AbXDLBWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161436AbXDLBWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 21:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161437AbXDLBWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 21:22:10 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:49920 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161436AbXDLBWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 21:22:09 -0400
Message-ID: <461D891F.1060309@vmware.com>
Date: Wed, 11 Apr 2007 18:19:27 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dan Hecht <dhecht@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 9/10] Vmi timer update.patch
References: <200704100006.l3A06RUR020644@zach-dev.vmware.com> <20070410023702.GJ10574@sequoia.sous-sol.org> <461BC373.10306@vmware.com> <20070410172429.GN10574@sequoia.sous-sol.org>
In-Reply-To: <20070410172429.GN10574@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> * Zachary Amsden (zach@vmware.com) wrote:
>   
>>>> +void __init vmi_time_init(void)
>>>> +{
>>>> +	/* Disable PIT: BIOSes start PIT CH0 with 18.2hz peridic. */
>>>> +	outb_p(0x3a, PIT_MODE); /* binary, mode 5, LSB/MSB, ch 0 */
>>>>         
>>> That shouldn't be necessary using clockevents.
>>>       
>> Actually, I'm not so sure.  If clockevents simply masks the PIT when 
>> disabling it, we still have overhead of keeping the latch in sync, which 
>> requires a timer at the PIT frequency.  I can instrument to see how 
>> exactly the PIT gets disabled.
>>     
>
> It should switch from pit to vmi-timer, and the switch should do the state
> transistions on pit to go to unused mode.
>   

Ok, here's why we need it: the reason is even more basic.  PIT 
clockevents never get setup; the time_init paravirt-op makes it 
conditional whether the PIT or VMI timer get invoked.  But our BIOS 
still sets it up to run at 18.2 HZ, like any good BIOS would.  We need 
the disable hack, in fact it is actually a good thing to do for native 
hardware.  Why leave the PIT enabled with junk programming from the BIOS 
once we are in the protected mode kernel?  Eventually, on hardware that 
doesn't want to use the PIT at all, this might be wanted to conserve 
power (casually joking but potentially correct argument).

Zach
