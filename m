Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab0BUFUJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 00:20:09 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:43712 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab0BUFUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 00:20:06 -0500
Date: Sun, 21 Feb 2010 05:20:03 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "yinghai@kernel.org" <yinghai@kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/2] x86, irq: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR
 instead of 0x1f
In-Reply-To: <4B674C82.9050703@zytor.com>
Message-ID: <alpine.LFD.2.00.1002210438220.1146@eddie.linux-mips.org>
References: <20100114002118.436172066@sbs-t61.sc.intel.com>      <20100114002118.521826763@sbs-t61.sc.intel.com>         <alpine.LFD.2.00.1001240545180.13034@eddie.linux-mips.org>      <4B5C00EB.3000208@zytor.com>    <alpine.LFD.2.00.1001310705280.31764@eddie.linux-mips.org>
 <1265059497.2802.178.camel@sbs-t61.sc.intel.com> <4B674C82.9050703@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

 I have finally managed to get back to it -- sorry for the delay, I'm 
running out of my time.

On Mon, 1 Feb 2010, H. Peter Anvin wrote:

> > As we are using the code from 2.6.28 and no one noticed/complained about
> > this issue for more than 1.5 years, probably the pentium APIC issue is
> > not wide-spread.

 Correct, the problem only affected B1, B3 and B5 steppings of the P54C 
Pentium processor.  These are probably extremely rare these days.  It was 
fixed later on.

 But they can be run-time detected -- if we don't support them anymore 
(assuming keeping them supported is too much of maintenance hassle; Linux 
used to be proud to support hardware nobody else seemed to care of 
anymore, so it's really disappointing to see it go), we should panic() on 
bootstrap and print an appropriate message.  They are CPUID family 5, 
model 2 and steppings 1, 2 and 4, respectively.

 Also the note in arch/x86/kernel/smp.c should be adjusted accordingly 
stating that the erratum is no longer worked around (preferably stating 
the last Linux version it was).

> I *think* it's applicable to all CPUs Pentium III or earlier (but not
> Pentium 4 -- I'm unsure about the Pentium M.)  I don't know about
> non-Intel CPUs; I have a vague memory of the Transmeta Efficeon (the
> only Transmeta chip with an APIC) *not* having this limitation.
> 
> The exact reference is SDM vol 3A 10.8.4, page 10-41 [rev 033US Dec 2009]:
> 
> For the P6 family and Pentium processors, the IRR and ISR registers can
> queue no more than two interrupts per priority level, and will reject
> other interrupts that are received within the same priority level.
> 
> However, section 10.8.2 bullet 3 on page 10-38 (and the flowchart on
> page 10-37) indicate that such an interrupt is returned to the IOAPIC
> for a later retry, i.e. it's not lost.  As such, it's not clear to me
> from reading the SDM that there is actually a problem here...

 Here's the text of the relevant erratum:

 "4AP. Three Interrupts of the Same Priority Causes Lost Local Interrupt

PROBLEM: If three interrupts of the same priority level (priority is 
defined in the 4MSB of the interrupt vector), arrive in the following 
circumstance:

1. A interrupt is being serviced by the CPU, and the proper bit is set in 
   the ISR register.

2. A second interrupt is received from the serial bus.

3. At the same time a third interrupt is received from a local interrupt 
   source, which could include local pins (LVT), an APIC timer (Timer), 
   self-interrupt, or an APIC error interrupt.

If the first two conditions are met the third interrupt will be lost, and 
not serviced.

IMPLICATION: The third interrupt will be ignored and not serviced if the 
specific scenario happens as listed above.

WORKAROUND: The problem can be avoided if different priority levels are 
assigned to serial interrupts, than to local interrupts.

STATUS: For the steppings affected see the Summary Table of Changes at the 
beginning of this section."

so you can see the retry mechanism is not the problem here (or, to be 
exact, the lack of an equivalent for local interrupts seems to be).

 I'm not sure how fatal for Linux the implications are though; even then 
it looks to me the approach we took was an overkill.  It's enough to 
guarantee that the APIC error interrupt, the APIC timer interrupt and 
self-IPIs (do we use any at all though?) do not share their priority 
level(s) with any external interrupt (but they can share the level with 
one another).  We only use ever LINT0/1 interrupts as NMIs (for the NMI 
watchdog and the system error, respectively), or ExtINT (in the case of 
LINT0), so this erratum does not apply to them.

 So what priority level(s) do we use for the APIC error and timer 
interrupts (and self-IPIs, if any) these days and how does it correspond 
to the priorities of external interrupts?  It looks like we can work 
around this erratum indefinitely quite cheaply (and should document it 
decently so that newcomers do not break it like it happened with many bits 
in our APIC code many times already; yes, lost hope, I know...).

  Maciej
