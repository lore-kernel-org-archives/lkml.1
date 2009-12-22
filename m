Return-Path: <linux-kernel-owner+w=401wt.eu-S1751238AbZLVR5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbZLVR5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 12:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbZLVR5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 12:57:16 -0500
Received: from mx2.compro.net ([12.186.155.4]:29188 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbZLVR5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 12:57:15 -0500
X-IronPort-AV: E=Sophos;i="4.47,437,1257138000"; 
   d="scan'208";a="4808324"
Message-ID: <4B310879.9050701@compro.net>
Date: Tue, 22 Dec 2009 12:57:13 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mark Hounschell <dmarkh@cfl.rr.com>, Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fdutils@fdutils.linux.lu,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28 (Was:
 Re: Cannot format floppies under kernel 2.6.*?)
References: <4AFB3962.2020106@ntlworld.com> <4B2A4975.8020809@compro.net> <4B2A49F4.6070402@compro.net> <4B2A4B86.8060307@knaff.lu> <4B2A4C78.10107@compro.net> <4B2A4CF7.6040000@knaff.lu> <4B2A4EC9.2030902@compro.net> <4B2A4FA5.5000701@knaff.lu> <4B2A5192.6090602@compro.net> <4B2A530D.3080606@knaff! .lu> <4B2A6394.3080705@knaff.lu> <alpine.LFD.2.00.0912170916420.15740@localhost.locald! omain> <4B2A98BB.5080406@knaff.lu> <alpine.LFD.2.00.0912171256560.15740@localhost.localdomain> <4B2AAC87.5000703@knaff.lu> <alpine.LFD.2.00.0912171440420.15740@localhost.localdomain> <4B2ABDC8.6090104@knaff.lu> <4B2B4485.6000305@cfl.rr.com> <4B2B5F86.1090403@cfl.rr.com> <alpine.LFD.2.00.0912180716400.3712@localhost.localdomain> <4B2B9F9F.7040802@compro.net> <alpine.LFD.2.00.0912180734220.3712@localhost.localdomain> <4B2BE05B.9050006@compro.net> <alpine.LFD.2.00.0912181213540.3712@localhost.localdomain> <4B30E1B4.7000702@compro.net> <alpine.LFD.2.00.0912220922250.31313@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912220922250.31313@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2009 12:38 PM, Linus Torvalds wrote:
> 
> [ Ingo, Venki and Shaohua added to cc: see the whole thread on lkml for 
>   details, but Mark is basically chasing down a situation where the floppy 
>   driver seems to have trouble formatting floppies, and it happened 
>   between 2.6.27 and .28. The trouble seems to be that a DMA transfer of a 
>   memory block transfers the wrong value for the first byte of the block.
> 
>   Which should be impossible, but whatever. Some part of the system has a 
>   cached buffer that isn't flushed.
> 
>   What gets _you_ guys involved is that Mark cannot reproduce the bug if 
>   HPET is disabled in the BIOS or by using 'nohpet'. He found that out by 
>   pure luck while bisecting, because some time during his bisect, his 
>   machine wouldn't even boot with HPET.
> 
>   So the problem is: with HPET enabled, 2.6.27.4 _used_ to work. But 
>   2.6.28 (and current -git) does not.  Any ideas? ]
> 
> On Tue, 22 Dec 2009, Mark Hounschell wrote:
>>
>> Ok, I may have something that might help.
>>
>> # git bisect bad
>> 26afe5f2fbf06ea0765aaa316640c4dd472310c0 is the first bad commit
>> commit 26afe5f2fbf06ea0765aaa316640c4dd472310c0
>> Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
>> Date:   Fri Sep 5 18:02:18 2008 -0700
>>
>>     x86: HPET_MSI Initialise per-cpu HPET timers
>>
>>     Initialize a per CPU HPET MSI timer when possible. We retain the HPET
>>     timer 0 (IRQ 0) and timer 1 (IRQ 8) as is when legacy mode is being used. We
>>     setup the remaining HPET timers as per CPU MSI based timers. This per CPU
>>     timer will eliminate the need for timer broadcasting with IRQ 0 when there
>>     is non-functional LAPIC timer across CPU deep C-states.
>>
>>     If there are more CPUs than number of available timers, CPUs that do not
>>     find any timer to use will continue using LAPIC and IRQ 0 broadcast.
>>
>>     Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>>     Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>
>> And of coarse this was the first commit that I could not boot if I had hpet
>> enabled. To get this one to boot (single user mode only) I had to add the
>> the quiet cmdline option and following patch from to arch/x86/kernel/hpet.c
>>
>> commit  5ceb1a04187553e08c6ab60d30cee7c454ee139a
>>
>> @ -445,7 +445,7 @@ static int hpet_setup_irq(struct hpet_dev *dev)
>>  {
>>
>>         if (request_irq(dev->irq, hpet_interrupt_handler,
>> -                       IRQF_SHARED|IRQF_NOBALANCING, dev->name, dev))
>> +                       IRQF_DISABLED|IRQF_NOBALANCING, dev->name, dev))
>>                 return -1;
>>
>>         disable_irq(dev->irq);
>>
>> AND add the quiet cmdline option.
> 
> Ok, so we know why HPET didn't boot for you, and that was fixed later (by 
> that 5ceb1a04). But is this also when the floppy started mis-behaving?
> 

Commit 26afe5f2fbf06ea0765aaa316640c4dd472310c0 is when the floppy stops
working
and also when I could no longer boot with hpet enabled. Commit 5ceb1a04 is
where I found I could boot again with the hpet enabled. It was a simple
patch so backed it into where I was
in order to be able to boot with hpet on.  I did 2 different bisects. First
to find out when I could boot again with hpet on, then the next to find
which caused the floppy problem. Using the patch from the first bisect
(5ceb1a04) while doing the second bisect.

> IOW, _if_ you boot with that fix from commit 5ceb1a04 (and the quiet 
> option - I wonder what that is about: do you have any ideas?), is the 
> per-CPU HPET timer commit also the commit that causes floppy problems, or 
> is this purely a "bisect when HPET became a boot-up problem"?
> 

The quiet option was only needed because with that 5ceb1a04 commit applied
to the kernels I was interested in, kernel messages of some kind went on
for hours and I could not get a login prompt. They went by so fast and I
didn't have a serial console available to see them.
They must not have too important or critical because the machine acted as
normal as any machine in single user mode.

But once I got to a single user login prompt it was for sure the same
floppy problem.

> 
> ---
>> Also, of all the machines it does work on with hpets enabled, I don't see
>> the HPET2 in /proc/interupts as below.
>>
>>
>> cat /proc/interrupts
>>            CPU0       CPU1       CPU2       CPU3
>>   0:         82          0          3          0   IO-APIC-edge      timer
>>   1:          0          0       1712          6   IO-APIC-edge      i8042
>>   3:          0          0          6          0   IO-APIC-edge
>>   4:          0          0          6          0   IO-APIC-edge
>>   6:          0          0          4          0   IO-APIC-edge      floppy
>>   8:          0          0         60          0   IO-APIC-edge      rtc0
>>   9:          0          0          0          0   IO-APIC-fasteoi   acpi
>>  12:          0          0      37798        179   IO-APIC-edge      i8042
>>  14:          0          0      16462         71   IO-APIC-edge      pata_atiixp
>>  15:          0          0       5713         17   IO-APIC-edge      pata_atiixp
>>  16:          0          0        904          2   IO-APIC-fasteoi   aic79xx, ohci_hcd:usb2, ohci_hcd:usb4, HDA Intel, ni-pci-gpib
>>  17:          0          0          2          0   IO-APIC-fasteoi   ehci_hcd:usb1, parport0, ni-pci-gpib
>>  18:          0          0      49940         90   IO-APIC-fasteoi   ohci_hcd:usb5, ohci_hcd:usb6, ohci_hcd:usb7, nvidia
>>  19:          0          0        703          2   IO-APIC-fasteoi   aic7xxx, ehci_hcd:usb3, ttySLG0, eth1
>>  22:          0          0       1303         15   IO-APIC-fasteoi   ahci
>>
>>  24:     261763          0          0          0  HPET_MSI-edge      hpet2
>>
>>  29:          0          0        220          5   PCI-MSI-edge      sky2@pci:0000:04:00.0
>> NMI:          0          0          0          0   Non-maskable interrupts
>> LOC:        138     271356     264446     261050   Local timer interrupts
>> SPU:          0          0          0          0   Spurious interrupts
>> PMI:          0          0          0          0   Performance monitoring interrupts
>> PND:          0          0          0          0   Performance pending work
>> RES:       4511       9275       8470       8086   Rescheduling interrupts
>> CAL:       3624       8666        523       4543   Function call interrupts
>> TLB:        981       1111       1065       1058   TLB shootdowns
>> ERR:          0
>> MIS:          0
> 


Regards
Mark
