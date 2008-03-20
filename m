Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbYCTEo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbYCTEo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 00:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbYCTEop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 00:44:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbYCTEoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 00:44:44 -0400
Message-ID: <47E1EAD6.5080905@redhat.com>
Date: Thu, 20 Mar 2008 01:40:54 -0300
From: Glauber Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 0/79] smpboot integration
References: <12059475744092-git-send-email-gcosta@redhat.com>	 <20080319173533.GA31576@elte.hu>	 <86802c440803191918y11af1269m39a7c7164f5f7d36@mail.gmail.com>	 <86802c440803192000x41a1383fxc2b58ed68e2375b7@mail.gmail.com> <86802c440803192032r2aa15a10pb32ef15fcfc693e7@mail.gmail.com>
In-Reply-To: <86802c440803192032r2aa15a10pb32ef15fcfc693e7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Wed, Mar 19, 2008 at 8:00 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> On Wed, Mar 19, 2008 at 7:18 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>  > On Wed, Mar 19, 2008 at 10:35 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>  >  >
>>  >  >  * Glauber de Oliveira Costa <gcosta@redhat.com> wrote:
>>  >  >
>>  >  >  > Testing and bisectability:
>>  >  >  >
>>  >  >  > The end result was tested in all my hardware (which includes qemu ;-).
>>  >  >  > It does not mean it will boot _your_ hardware, but I did my best ;-)
>>  >  >  >
>>  >  >  > The tree at least compiles in more than 20 randconfigs (for each of
>>  >  >  > x86_64 and i386) For i386, each of the subarchitectures was compiled
>>  >  >  > at least once. (By compile, I obviously mean, every patch,
>>  >  >  > individually)
>>  >  >
>>  >  >  very nice work! I'll pick it up - and i'm not too worried about
>>  >  >  breakages because at 80 patches granularity any problem should be
>>  >  >  identifiable in a very finegrained way.
>>  >  >
>>  >
>>  >  it broke 4 sockets quad core above with 64 bit
>>  >
>>  >  Booting processor 11/15 ip 6000
>>  >  Initializing CPU#11
>>  >  masked ExtINT on CPU#11
>>  >  Calibrating delay using timer specific routine.. 4589.46 BogoMIPS (lpj=9178934)
>>  >  CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
>>  >  CPU: L2 Cache: 512K (64 bytes/line)
>>  >  CPU 11/f -> Node 2
>>  >  CPU: Physical Processor ID: 2
>>  >  CPU: Processor Core ID: 3
>>  >  CPU11: Quad-Core AMD Opteron(tm) Processor 8356 stepping 03
>>  >  checking TSC synchronization [CPU#0 -> CPU#11]: passed.
>>  >  Booting processor 12/16 ip 6000
>>  >
>>  >  looks like local apic id up 4 bit is masked out. so can not start 0x10
>>  >  above any more.
>>
>>  in wakeup_secondary_via_INIT
>>  before the patchsets
>>  64 bit code:
>>
>>         /*
>>          * Send IPI
>>          */
>>         apic_write(APIC_ICR, APIC_INT_LEVELTRIG | APIC_INT_ASSERT
>>                                 | APIC_DM_INIT);
>>
>>
>>  after patchset
>>
>>         /* Boot on the stack */
>>         /* Kick the second */
>>         apic_write_around(APIC_ICR, APIC_DM_NMI | APIC_DEST_LOGICAL);
>>
>>  So that is wrong! esp for system has ext apic id that is has 8 bits
>>  instead of 4 bits.
>>
> 
> it seems there is two wakeup_secondary_cpu. one for NMI and one INIT.
> 
> but should have
> 
> #define WAKE_SECONDARY_VIA_INIT
> 
> for x86_64
> 
> but after
> 
> #ifdef CONFIG_X86_64
> #undef WAKE_SECONDARY_VIA_NMI
> #define WAKE_SECONDARY_VIA_INIT
> #endif
> 
> it still doesn't work.
> 
> YH
Thanks for the testing Yinghai. I'll take a deeper look as soon as I 
can. The two routines are provided, since i386 numa-q inits the startup 
sequence through NMIs. The _VIA_INIT is already defined in x86_64 in the 
mach-default/ headers.

What happens exactly? Does it hang indefinitely ? Or just for a while?
Also, can you provide the exact commit in which this problem start?
(just to be sure)

As a debugging aid, can you also define the Dprintks in the code? I've 
seen hangs before in which the processor was indeed executing its init 
sequence, (although it did not seem to), but was hanging in the 
calibrate loop.

Thanks
