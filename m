Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbYCYWm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbYCYWm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 18:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbYCYWmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 18:42:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbYCYWmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 18:42:19 -0400
Message-ID: <47E97F25.9050507@redhat.com>
Date: Tue, 25 Mar 2008 19:39:33 -0300
From: Glauber Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, andi-suse@firstfloor.org
Subject: Re: [PATCH 45/79] [PATCH] fix apic acking of irqs
References: <12059475744092-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send! -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat <12059477792893-git-send-email-gcosta@redhat.com> <alpine.SOC.1.00.0803201016540.12075@piorun> <47E27D08.9050809@redhat.com> <alpine.SOC.1.00.0803202125520.21415@piorun> <47E7C00B.5000503@redhat.com> <alpine.SOC.1.00.0803241608310.12757@piorun> <47E90149.5040506@redhat.com> <alpine.SOC.1.00.0803251524230.27947@piorun>
In-Reply-To: <alpine.SOC.1.00.0803251524230.27947@piorun>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
> On Tue, 25 Mar 2008, Glauber Costa wrote:
> 
>> the only ESR mention I see in setup_local_APIC() is this:
>>
>>          /* Pound the ESR really hard over the head with a big hammer - mbligh
>> */
>>         if (esr_disable) {
>>                 apic_write(APIC_ESR, 0);
>>                 apic_write(APIC_ESR, 0);
>>                 apic_write(APIC_ESR, 0);
>>                 apic_write(APIC_ESR, 0);
>>         }
>> which seems more like a disablement.
> 
>  There is more later on...
> 
>> the bootup code does clean it, tough, by writing and reading the ESR.
> 
> ... basically for the original Pentium and Pentium/MMX APIC you only had 
> to read the ESR to get at the bits.  The read would clear them as well as 
> a side-effect.  Although at that stage already it was mentioned in the 
> spec that for future compatibility a write of zero beforehand (ignored as 
> the register was r/o) should be performed.  Which indeed became a 
> requirement from PentiumPro onwards as with these processors it was the 
> write that copied the internal error latches into the visible ESR 
> register.  Except that some Pentium APICs had an erratum, where ESR was 
> indeed r/w and the leading write of zero would actually clear the register 
> losing the recorded state, so it had to be avoided despite the 
> recommendation.  Hence the code you can see within:
> 
> if (integrated && !esr_disable) {
> }
> 
> I suppose other APIC implementers were not that keen on keeping bug 
> compatibility, so chances are other APIC core work just fine as specified 
> by the architecture (for whatever the meaning of "fine" is).
> 
>  Note the usual APIC error interrupt handler is smp_error_interrupt().
> 
>>>  I have asked this question already: what kind of CPU are you running on?
>>> Do you really need to have CONFIG_X86_GOOD_APIC clear with it?
>>>
>> My testings that triggered that were with qemu, with randconfigs. Probably it
>> has a good apic, but it is good that it triggered anyway. Otherwise I'd never
>> see it.
> 
>  Ah, I see -- it may be worth checking what actual hardware does and 
> fixing QEMU if necessary for it to match reality then. ;-)
> 
>  OTOH, if actual modern hardware triggered such an error, then for the 
> sake of a generic "runs everywhere" kernel either ack_APIC_irq() or even 
> apic_write_around() could be modified to perform a run-time check if 
> configured with !CONFIG_X86_GOOD_APIC and avoid the read if unnecessary; 
> it's an erratum workaround after all and SMP Pentium systems suffering 
> from this bug (UP Pentium systems did not nor had a way to enable the 
> local APIC normally) are probably an insignificant minority if any at all 
> left these days.  Therefore it should be a negligible sacrifice of 
> performance.
I just tested in some real i386 that I have around here, and the reading
of EOI does not seem to be illegal. (Well, at least in those I've tested).

OTOH, ignoring the read in qemu makes the tree boot just okay. So I 
agree with you now, we might well fix qemu, and revert this patch.

Ingo, any word on that?



>   Maciej

