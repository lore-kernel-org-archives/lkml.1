Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbZLWAW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbZLWAW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 19:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbZLWAWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 19:22:24 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:53625 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbZLWAWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 19:22:24 -0500
X-Authority-Analysis: v=1.0 c=1 a=BwQm8WjOSfMA:10 a=QyXUC8HyAAAA:8 a=JFYhW9AEnj6xI6WAZToA:9 a=2njQsIiybN09iEw_ei4A:7 a=1HRy3PEy2dnQJGPQdE0Dcr0fRRkA:4 a=dGJ0OcVc7YAA:10
X-Cloudmark-Score: 0
X-Originating-IP: 97.102.92.77
Message-ID: <4B3162BC.9000508@cfl.rr.com>
Date: Tue, 22 Dec 2009 19:22:20 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: "markh@compro.net" <markh@compro.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Alain Knaff <alain@knaff.lu>
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28 (Was:
 Re: Cannot format floppies under kernel 2.6.*?)
References: <4AFB3962.2020106@ntlworld.com> <4B2A4C78.10107@compro.net> <4B2A4CF7.6040000@knaff.lu>	 <4B2A4EC9.2030902@compro.net> <4B2A4FA5.5000701@knaff.lu>	 <4B2A5192.6090602@compro.net> <4B2A530D.3080606@knaff! .lu>	 <4B2A6394.3080705@knaff.lu>	 <alpine.LFD.2.00.0912170916420.15740@localhost.locald! omain>	 <4B2A98BB.5080406@knaff.lu>	 <alpine.LFD.2.00.0912171256560.15740@localhost.localdomain>	 <4B2AAC87.5000703@knaff.lu>	 <alpine.LFD.2.00.0912171440420.15740@localhost.localdomain>	 <4B2ABDC8.6090104@knaff.lu> <4B2B4485.6000305@cfl.rr.com>	 <4B2B5F86.1090403@cfl.rr.com>	 <alpine.LFD.2.00.0912180716400.3712@localhost.localdomain>	 <4B2B9F9F.7040802@compro.net>	 <alpine.LFD.2.00.0912180734220.3712@localhost.localdomain>	 <4B2BE05B.9050006@compro.net>	 <alpine.LFD.2.00.0912181213540.3712@localhost.localdomain>	 <4B30E1B4.7000702@compro.net>	 <alpine.LFD.2.00.0912220922250.31313@localhost.localdomain>	 <4B310879.9050701@compro.net> <1261525076.16916.4.camel@localhost.localdomain>
In-Reply-To: <1261525076.16916.4.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2009 06:37 PM, Pallipadi, Venkatesh wrote:
> On Tue, 2009-12-22 at 09:57 -0800, Mark Hounschell wrote:
>> On 12/22/2009 12:38 PM, Linus Torvalds wrote:
>>>
>>> [ Ingo, Venki and Shaohua added to cc: see the whole thread on lkml for 
>>>   details, but Mark is basically chasing down a situation where the floppy 
>>>   driver seems to have trouble formatting floppies, and it happened 
>>>   between 2.6.27 and .28. The trouble seems to be that a DMA transfer of a 
>>>   memory block transfers the wrong value for the first byte of the block.
>>>
>>>   Which should be impossible, but whatever. Some part of the system has a 
>>>   cached buffer that isn't flushed.
>>>
>>>   What gets _you_ guys involved is that Mark cannot reproduce the bug if 
>>>   HPET is disabled in the BIOS or by using 'nohpet'. He found that out by 
>>>   pure luck while bisecting, because some time during his bisect, his 
>>>   machine wouldn't even boot with HPET.
>>>
>>>   So the problem is: with HPET enabled, 2.6.27.4 _used_ to work. But 
>>>   2.6.28 (and current -git) does not.  Any ideas? ]
>>>
>>> On Tue, 22 Dec 2009, Mark Hounschell wrote:
>>>>
>>>> Ok, I may have something that might help.
>>>>
>>>> # git bisect bad
>>>> 26afe5f2fbf06ea0765aaa316640c4dd472310c0 is the first bad commit
>>>> commit 26afe5f2fbf06ea0765aaa316640c4dd472310c0
>>>> Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
>>>> Date:   Fri Sep 5 18:02:18 2008 -0700
>>>>
>>>>     x86: HPET_MSI Initialise per-cpu HPET timers
>>>>
>>>>     Initialize a per CPU HPET MSI timer when possible. We retain the HPET
>>>>     timer 0 (IRQ 0) and timer 1 (IRQ 8) as is when legacy mode is being used. We
>>>>     setup the remaining HPET timers as per CPU MSI based timers. This per CPU
>>>>     timer will eliminate the need for timer broadcasting with IRQ 0 when there
>>>>     is non-functional LAPIC timer across CPU deep C-states.
>>>>
>>>>     If there are more CPUs than number of available timers, CPUs that do not
>>>>     find any timer to use will continue using LAPIC and IRQ 0 broadcast.
>>>>
>>>>     Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>>>>     Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>>>>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>>>
>>>> And of coarse this was the first commit that I could not boot if I had hpet
>>>> enabled. To get this one to boot (single user mode only) I had to add the
>>>> the quiet cmdline option and following patch from to arch/x86/kernel/hpet.c
>>>>
>>>> commit  5ceb1a04187553e08c6ab60d30cee7c454ee139a
>>>>
>>>> @ -445,7 +445,7 @@ static int hpet_setup_irq(struct hpet_dev *dev)
>>>>  {
>>>>
>>>>         if (request_irq(dev->irq, hpet_interrupt_handler,
>>>> -                       IRQF_SHARED|IRQF_NOBALANCING, dev->name, dev))
>>>> +                       IRQF_DISABLED|IRQF_NOBALANCING, dev->name, dev))
>>>>                 return -1;
>>>>
>>>>         disable_irq(dev->irq);
>>>>
>>>> AND add the quiet cmdline option.
>>>
>>> Ok, so we know why HPET didn't boot for you, and that was fixed later (by 
>>> that 5ceb1a04). But is this also when the floppy started mis-behaving?
>>>
>>
>> Commit 26afe5f2fbf06ea0765aaa316640c4dd472310c0 is when the floppy stops
>> working
>> and also when I could no longer boot with hpet enabled.
> 
> 
> I am missing something here. Commit 26afe5f2 is where system does not
> boot with HPET or is it where the floppy stops working when you boot
> with HPET enabled.
> 

As it happens, both happen there. Commit 5ceb1a04 is where it starts
booting _again_ with hpet enabled. So I took that patch (5ceb1a04) and
applied it to (26afe5f2f) to be able to boot with hpet enabled.  I had to
use the quiet option to get to a login prompt, but there is where the
floppy format first fails, just as it does in 2.6.28 and up.

> Can you try "idle=halt" with both .27 and .28 with /proc/interrupts
> output in each case. With that option, we should be using local APIC
> timer and PIT, HPET or HPET with MSI should not really matter. Does it
> still fail with .28 with that option?
> 

Yes, I will try that for you but will have to wait until the morning. Sorry.

Regards
Mark


