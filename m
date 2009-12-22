Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbZLVRiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbZLVRiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 12:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbZLVRix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 12:38:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754408AbZLVRiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 12:38:52 -0500
Date: Tue, 22 Dec 2009 09:38:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mark Hounschell <markh@compro.net>
cc: Mark Hounschell <dmarkh@cfl.rr.com>, Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fdutils@fdutils.linux.lu,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28 (Was:
 Re: Cannot format floppies under kernel 2.6.*?)
In-Reply-To: <4B30E1B4.7000702@compro.net>
Message-ID: <alpine.LFD.2.00.0912220922250.31313@localhost.localdomain>
References: <4AFB3962.2020106@ntlworld.com> <4B2A3E3E.8060405@knaff.lu> <4B2A4975.8020809@compro.net> <4B2A49F4.6070402@compro.net> <4B2A4B86.8060307@knaff.lu> <4B2A4C78.10107@compro.net> <4B2A4CF7.6040000@knaff.lu> <4B2A4EC9.2030902@compro.net>
 <4B2A4FA5.5000701@knaff.lu> <4B2A5192.6090602@compro.net> <4B2A530D.3080606@knaff! .lu> <4B2A6394.3080705@knaff.lu> <alpine.LFD.2.00.0912170916420.15740@localhost.locald! omain> <4B2A98BB.5080406@knaff.lu> <alpine.LFD.2.00.0912171256560.15740@localhost.localdomain>
 <4B2AAC87.5000703@knaff.lu> <alpine.LFD.2.00.0912171440420.15740@localhost.localdomain> <4B2ABDC8.6090104@knaff.lu> <4B2B4485.6000305@cfl.rr.com> <4B2B5F86.1090403@cfl.rr.com> <alpine.LFD.2.00.0912180716400.3712@localhost.localdomain> <4B2B9F9F.7040802@compro.net>
 <alpine.LFD.2.00.0912180734220.3712@localhost.localdomain> <4B2BE05B.9050006@compro.net> <alpine.LFD.2.00.0912181213540.3712@localhost.localdomain> <4B30E1B4.7000702@compro.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Ingo, Venki and Shaohua added to cc: see the whole thread on lkml for 
  details, but Mark is basically chasing down a situation where the floppy 
  driver seems to have trouble formatting floppies, and it happened 
  between 2.6.27 and .28. The trouble seems to be that a DMA transfer of a 
  memory block transfers the wrong value for the first byte of the block.

  Which should be impossible, but whatever. Some part of the system has a 
  cached buffer that isn't flushed.

  What gets _you_ guys involved is that Mark cannot reproduce the bug if 
  HPET is disabled in the BIOS or by using 'nohpet'. He found that out by 
  pure luck while bisecting, because some time during his bisect, his 
  machine wouldn't even boot with HPET.

  So the problem is: with HPET enabled, 2.6.27.4 _used_ to work. But 
  2.6.28 (and current -git) does not.  Any ideas? ]

On Tue, 22 Dec 2009, Mark Hounschell wrote:
> 
> Ok, I may have something that might help.
> 
> # git bisect bad
> 26afe5f2fbf06ea0765aaa316640c4dd472310c0 is the first bad commit
> commit 26afe5f2fbf06ea0765aaa316640c4dd472310c0
> Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
> Date:   Fri Sep 5 18:02:18 2008 -0700
> 
>     x86: HPET_MSI Initialise per-cpu HPET timers
> 
>     Initialize a per CPU HPET MSI timer when possible. We retain the HPET
>     timer 0 (IRQ 0) and timer 1 (IRQ 8) as is when legacy mode is being used. We
>     setup the remaining HPET timers as per CPU MSI based timers. This per CPU
>     timer will eliminate the need for timer broadcasting with IRQ 0 when there
>     is non-functional LAPIC timer across CPU deep C-states.
> 
>     If there are more CPUs than number of available timers, CPUs that do not
>     find any timer to use will continue using LAPIC and IRQ 0 broadcast.
> 
>     Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>     Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> And of coarse this was the first commit that I could not boot if I had hpet
> enabled. To get this one to boot (single user mode only) I had to add the
> the quiet cmdline option and following patch from to arch/x86/kernel/hpet.c
> 
> commit  5ceb1a04187553e08c6ab60d30cee7c454ee139a
> 
> @ -445,7 +445,7 @@ static int hpet_setup_irq(struct hpet_dev *dev)
>  {
> 
>         if (request_irq(dev->irq, hpet_interrupt_handler,
> -                       IRQF_SHARED|IRQF_NOBALANCING, dev->name, dev))
> +                       IRQF_DISABLED|IRQF_NOBALANCING, dev->name, dev))
>                 return -1;
> 
>         disable_irq(dev->irq);
> 
> AND add the quiet cmdline option.

Ok, so we know why HPET didn't boot for you, and that was fixed later (by 
that 5ceb1a04). But is this also when the floppy started mis-behaving?

IOW, _if_ you boot with that fix from commit 5ceb1a04 (and the quiet 
option - I wonder what that is about: do you have any ideas?), is the 
per-CPU HPET timer commit also the commit that causes floppy problems, or 
is this purely a "bisect when HPET became a boot-up problem"?

			Linus

---
> Also, of all the machines it does work on with hpets enabled, I don't see
> the HPET2 in /proc/interupts as below.
> 
> 
> cat /proc/interrupts
>            CPU0       CPU1       CPU2       CPU3
>   0:         82          0          3          0   IO-APIC-edge      timer
>   1:          0          0       1712          6   IO-APIC-edge      i8042
>   3:          0          0          6          0   IO-APIC-edge
>   4:          0          0          6          0   IO-APIC-edge
>   6:          0          0          4          0   IO-APIC-edge      floppy
>   8:          0          0         60          0   IO-APIC-edge      rtc0
>   9:          0          0          0          0   IO-APIC-fasteoi   acpi
>  12:          0          0      37798        179   IO-APIC-edge      i8042
>  14:          0          0      16462         71   IO-APIC-edge      pata_atiixp
>  15:          0          0       5713         17   IO-APIC-edge      pata_atiixp
>  16:          0          0        904          2   IO-APIC-fasteoi   aic79xx, ohci_hcd:usb2, ohci_hcd:usb4, HDA Intel, ni-pci-gpib
>  17:          0          0          2          0   IO-APIC-fasteoi   ehci_hcd:usb1, parport0, ni-pci-gpib
>  18:          0          0      49940         90   IO-APIC-fasteoi   ohci_hcd:usb5, ohci_hcd:usb6, ohci_hcd:usb7, nvidia
>  19:          0          0        703          2   IO-APIC-fasteoi   aic7xxx, ehci_hcd:usb3, ttySLG0, eth1
>  22:          0          0       1303         15   IO-APIC-fasteoi   ahci
> 
>  24:     261763          0          0          0  HPET_MSI-edge      hpet2
> 
>  29:          0          0        220          5   PCI-MSI-edge      sky2@pci:0000:04:00.0
> NMI:          0          0          0          0   Non-maskable interrupts
> LOC:        138     271356     264446     261050   Local timer interrupts
> SPU:          0          0          0          0   Spurious interrupts
> PMI:          0          0          0          0   Performance monitoring interrupts
> PND:          0          0          0          0   Performance pending work
> RES:       4511       9275       8470       8086   Rescheduling interrupts
> CAL:       3624       8666        523       4543   Function call interrupts
> TLB:        981       1111       1065       1058   TLB shootdowns
> ERR:          0
> MIS:          0
