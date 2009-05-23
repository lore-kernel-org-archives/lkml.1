Return-Path: <linux-kernel-owner+w=401wt.eu-S1758512AbZEWAqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512AbZEWAqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 20:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758187AbZEWAqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 20:46:04 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:59084 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758128AbZEWAqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 20:46:03 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Fri, 22 May 2009 19:45:59 -0500
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
References: <200905221139.26941.lkml@morethan.org> <200905221721.08495.lkml@morethan.org> <4A173580.9050304@zytor.com>
In-Reply-To: <4A173580.9050304@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905221946.01808.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri May 22 2009, H. Peter Anvin wrote:
> If there is a driver which relies on locked operations to be atomic with
> respect to the I/O subsystem, it needs to use true locks, not LOCK_PREFIX.
> 
> An interrupt cannot interrupt between two parts of a lockable
> instruction even if it isn't locked (there are non-atomic instructions
> in the x86 architecture, but they can never be locked.)
> 
> The other thing that you might be seeing is that a locked operation may
> be slow enough to keep an otherwise-present race condition from being
> triggered.
> 
> > That tells us nothing, since the CPU technical details are under NDA.
> 
> Have you considered that you might be running into a CPU bug or design
> error?  There was the out-of-order store bug on the Winchip that needed
> workarounds (CONFIG_X86_OOSTORE) that I don't think were ever well
> tested and might very well have bitrotted?
> 
> > All that can be done in this case is report behavior differences from
> > the closest publicly described processor (Pentium-M).
> > 
> > For that purpose, I suggest that a single processor box, with other 
> > hardware that makes memory access independent of the processor's 
> > control using a processor older than P-4 is a potential test bed.
> > "Other hardware that makes memory access..." I previously termed:
> > "buss master DMA" - which is overly specific.  It misleads people
> > into thinking I am seeing hardware control issues rather than
> > non-exclusive memory access.
> > 
> > My earlier comments about taking an interrupt between the memory read
> > and the memory write operations is from a different manual than the
> > one posted.  A manual that only applies to processors older than 
> > the ones supported by the Linux kernel.  
> > Sorry, my bad, grabbed the wrong book, posted the correct link (SH).
> > 
> > Until one or more specific usages of the LOCK_PREFIX macro can be 
> > demonstrated to be incorrect (at least for some of the processors 
> > using this code) - -
> > 
> > Then making the posted change is a single point change that gives a 
> > pair of builds (one with, one without) to compare the behavior of on 
> > the test bed.
> > 
> > It is *not* the preferred change for a general release kernel, the
> > preferred change would be one that makes a specific rather than
> > general correction.  
> > Perhaps only for some functions, perhaps only for some of the 
> > processors that currently select this code.
> > 
> > The observation that executing an unnecessary 'lock' opcode in some
> > cases slows down the machine is not felt by myself to be significant 
> > to duplicating my observations.  Note: I have been wrong before.
> 
> What makes you draw that conclusion, in particular?  A lock prefix
> typically slows down the following instruction dramatically, on some
> processors by many hundreds of cycles.
> 
> > This is as informative as I can make the message.
> > 
> > PS: *not* a single machine failure, tested on five machines, owned
> > by four different people, two brands, with different use histories.
> 
> What do they have in common?
>

Same integrated motherboard.
There is very little information to be gained from staring at a glowing
power on light, that only glows back.  ;)
The lockdep dump posted is the best source of information.

Other observations -

Here is something which these machines do, which may not be happening
with your choice of test machines:

ACPI: Core revision 20090320
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...
..... (found apic 0 pin 0) ...
....... works.

Note: This is on a Uni-processor build.
I have not yet examined the code that generates that set of messages.
Might be a broken work-around?

With the LOCK_PREFIX == ""

Test conditions (same as the lockdep dump) -
VLC playing streaming audio over the wired net connection (8139too) -
from 4 to 8 ssh remote terminal sessions, each running "top" set
to use different display intervales (different in 0.1 second steps) -
Fixed cpu speed at half the rated clock (for the purpose of testing).
Now just hang back and listen for 10 minutes to 4 hours -

When the machine stops running -
You will still hear bursts of sound - -
I am *guessing* that this means the chip set and bus clocks are running,
also that DMA is running - with the result that the HD audio driver
is just replaying the same buffer offset.
There is a PCI-to-PCIe bridge in the chip set and the HD audio hardware
(also on chip) is the only thing detected on the PCIe bus.

The "hold down power button to stop" still works -
I presume that means at least that internal timer is still running.

Repeat the above, *with* LOCK_PREFIX == "\n\tlock; "
When the machine stops - with only minutes rather than hours of uptime -
The machine is silent - I presume this means that DMA is not running.
The "hold down power button to stop" still works -
So clocks are not totally off.

= = = =

Either "lock-up" situation acts as if:
*) cpu is halted with interrupts off; or
*) cpu is in a tight loop with interrupts off
The primary difference is that the DMA has been stopped in the second case.
Presuming my two guesses on that subject above are correct.

Mike

> 	-hpa
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


