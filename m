Return-Path: <linux-kernel-owner+w=401wt.eu-S1760833AbZFOKsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760833AbZFOKsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 06:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbZFOKsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 06:48:05 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56819 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbZFOKsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 06:48:03 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
References: <4A329CF8.4050502@goop.org> <m1d499yyug.fsf@fess.ebiederm.org>
	<4A35ACB3.9040501@goop.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 15 Jun 2009 03:47:57 -0700
In-Reply-To: <4A35ACB3.9040501@goop.org> (Jeremy Fitzhardinge's message of "Sun\, 14 Jun 2009 19\:06\:43 -0700")
Message-ID: <m1k53dbwo2.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: jeremy@goop.org, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's no local APIC
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> On 06/12/09 13:35, Eric W. Biederman wrote:
>> Jeremy Fitzhardinge<jeremy@goop.org>  writes:
>>
>>    
>>> Parse the ACPI MADT for I/O APIC information, even if the cpu has no
>>> (apparent) local APIC (ie, the CPU's APIC feature flag is clear).
>>>
>>> In principle, the local APIC and the I/O APIC are distinct (but related)
>>> components, which can be independently present.
>>>
>>> In practice this can happen in a Xen system, where the hypervisor has
>>> full control over the local APICs, and delivers interrupts initiated by
>>> the I/O APICs via Xen's event channel mechanism.
>>>      
>>
>> Xen  is giving us a semi bogus acpi table?
>>    
>
> No, not really.  The guest is reading the real BIOS-provided ACPI tables, but
> Xen is clobbering the APIC feature in CPUID so the virtual CPU doesn't appear to
> have a usable local APIC.  Xen itself doesn't care very much about interrupt
> routing or ACPI, and doesn't make any attempt to read or parse the ACPI data
> itself (except for very basic things like the APIC addresses).
>
>> What is the paravirt configuration model with Xen?  Is it documented
>> somewhere?
>>    
>
> Not very well.  The basic idea is that Xen owns the local apics, and does things
> like vector allocation.  The guest kernel is responsible for asking for a
> vector, and doing the appropriate IO APIC programming, and binding that vector
> to an event channel.  The interrupt is then delivered via the normal event
> channel mechanism already in place to deal with all the other event types an
> unprivileged domain can get.

For code reuse and maintainability that is a horrible separation of
responsibility.  Things looks similar to the existing cases until you
get up close and you discover all of the fundamental assumptions are
different so none of the existing code actually works unmodified.

The only clean way I can see to handle this is to make xen dom0 it's own
weird separate subarch that does all of the table parsing of the
firmware tables in completely separate code.  Then once we have something
that works factoring out the commonalities into a helper library for
better long term maintenance.

As it stands right now what Xen wants and what we need to do for normal
hardware are radically different, to the point of painful.  Things like
irq migration, and cpu hotplug require completely different algorithms.

I think Xen dom0 has picked the wrong abstraction for this one.  There
seems to be no gain and a lot of pain asking the slave kernel to
program the ioapics for it, when Xen presents a wildly different
abstraction at the cpu level.

If what xen was provided looked like an ioapic semantically I would
suggest setting cpu_has_apic in a different fashion.  We already have
two local apic variants after all so a 3rd should not be too nasty.
Except the Xen appears to have totally moved the responsibility around
in ways that over constrain the problem by taking, making the
existing code useless.

Please put the Xen dom0 insanity somewhere off in a corner where the rest
of x86 can ignore it.

Eric
