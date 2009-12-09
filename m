Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbZLIGnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbZLIGnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 01:43:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756135AbZLIGnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 01:43:03 -0500
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:54523 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752151AbZLIGnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 01:43:02 -0500
Message-ID: <4B1F46FA.90902@gmail.com>
Date: Wed, 09 Dec 2009 07:43:06 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091205 Lightning/1.0pre Shredder/3.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       erbrochendes@gmx.de, divinespear@gmail.com, andjelo@gmx.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Rt2x00 problem traced back to x86 ACPI/PCI/e820 handling.
References: <4B1D8176.9040209@gmail.com> <4B1D8743.5090009@kernel.org>
In-Reply-To: <4B1D8743.5090009@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Dec 2009 06:43:08.0035 (UTC) FILETIME=[DE1EFD30:01CA789A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/09 23:52, Yinghai Lu wrote:
> Gertjan van Wingerde wrote:
>> Hi Ingo, Yinghai,
>>
>> For a while now we have seen reports of the rt2x00 driver not working correctly
>> where bogus information was read from the EEPROM. This resulted in a non-functional
>> driver.
>> It has been established that the problem has introduced itself sometimes in the 2.6.31
>> development cycle.
>>
>> Lately the failures have been traced back to commit 5d423ccd7ba4285f1084e91b26805e1d0ae978ed
>> of a patch created by Yinghai and committed Ingo.
>>
>> Reverting this patch seems to fix the problems with the rt2x00 driver.
>>
>> Also, it has been established that another work-around is to supply the pci=use_crs boot parameter.
>>
>> Do any of you have any idea as to what is going on here, and if this is something where the
>> rt2x00 driver is at fault, or where the x86 ACPI/PCI/e820 code is buggy?
>>
>> So far I can establish that all the cases for which it is known what kind of HW it is that these
>> are all MSI laptops.
>>
>> The related bug reports are:
>> 	http://bugzilla.kernel.org/show_bug.cgi?id=14460
>> 	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/404596
>>
> 
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000006ffd0000 (usable)
> [    0.000000]  BIOS-e820: 000000006ffd0000 - 000000006ffde000 (ACPI data)
> [    0.000000]  BIOS-e820: 000000006ffde000 - 0000000070000000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
> ...
> [    0.000000] Allocating PCI resources starting at 70000000 (gap: 70000000:8ff80000)
> ...
> 
> [    0.144853] node 0 link 0: io port [1000, ffffff]
> [    0.144853] TOM: 0000000080000000 aka 2048M
> [    0.144853] node 0 link 0: mmio [bdf00000, ddeeffff]
> [    0.144853] node 0 link 0: mmio [80000000, bdefffff]
> [    0.144853] node 0 link 0: mmio [e0000000, efffffff]
> [    0.144853] node 0 link 0: mmio [ddef0000, dfffffff]
> [    0.144853] node 0 link 0: mmio [a0000, bffff]
> [    0.144853] node 0 link 0: mmio [f0000000, ffffffff]
> [    0.144853] bus: [00,ff] on node 0 link 0
> [    0.144853] bus: 00 index 0 io port: [0, ffff]
> [    0.144853] bus: 00 index 1 mmio: [80000000, dfffffff]
> [    0.144853] bus: 00 index 2 mmio: [e0000000, fcffffffff]
> [    0.144853] bus: 00 index 3 mmio: [a0000, bffff]
> ...
> 
> [    0.200570] pci 0000:00:14.0: reg 14 32bit mmio: [0x000000-0x0003ff]
> ...
> [    0.201755] pci 0000:05:04.0: reg 10 32bit mmio: [0x000000-0x000fff]
> [    0.201765] pci 0000:05:04.0: reg 14 32bit mmio: [0x000000-0x0007ff]
> [    0.201986] pci 0000:05:04.2: reg 10 32bit mmio: [0x000000-0x0000ff]
> [    0.202215] pci 0000:05:04.3: reg 10 32bit mmio: [0x000000-0x000fff]
> [    0.202865] pci 0000:05:09.0: reg 10 32bit mmio: [0x000000-0x007fff]
> [    0.202997] pci 0000:00:14.4: transparent bridge
> [    0.203051] pci 0000:00:14.4: bridge 32bit mmio: [0x000000-0x0fffff]
> 
> ..
> 
> [    0.283503] pci 0000:00:14.4: PCI bridge, secondary bus 0000:05
> [    0.283547] pci 0000:00:14.4:   IO window: disabled
> [    0.283596] pci 0000:00:14.4:   MEM window: 0x70000000-0x700fffff
> [    0.283643] pci 0000:00:14.4:   PREFETCH window: disabled
> 
> 
> [    0.283764] pci_bus 0000:05: resource 1 mem: [0x70000000-0x700fffff]
> 
> 
> [    2.140079] ohci1394 0000:05:04.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> [    2.357886] ohci1394: fw-host0: Get PHY Reg timeout [0x00000000/0x00000000/100]
> [    2.399313] ohci1394: fw-host0: Set PHY Reg timeout [0x000044c0/0x00004000/100]
> [    2.494572] ohci1394: fw-host0: OHCI-1394 0.0 (PCI): IRQ=[20]  MMIO=[70008000-700087ff]  Max Packet=[2]  IR/IT contexts=[32/32]
> [    2.529013] ohci1394: fw-host0: Get PHY Reg timeout [0x00000000/0x00000000/100]
> [    2.593817] ohci1394: fw-host0: Serial EEPROM has suspicious values, attempting to set max_packet_size to 512 bytes
> [    3.596012] ohci1394: fw-host0: Get PHY Reg timeout [0x00008500/0x00000000/100]
> [    3.695273] ohci1394: fw-host0: Set PHY Reg timeout [0x00004540/0x00004000/100]
> 
> 
> ...
> 
> 
> and 2.6.30...
> 
> [    0.000000] Allocating PCI resources starting at 80000000 (gap: 70000000:8ff80000)
> 
> 
> looks like BIOS is using [0x70000000 - 0x80000000] 235M ram range for some purpose.
> 
> please try this on top of 2.6.32.
> 
> diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
> index 572ee97..44f7c3d 100644
> --- a/arch/x86/pci/amd_bus.c
> +++ b/arch/x86/pci/amd_bus.c
> @@ -48,8 +48,8 @@ void x86_pci_root_bus_res_quirks(struct pci_bus *b)
>  	    b->resource[1] != &iomem_resource)
>  		return;
>  
> -	/* if only one root bus, don't need to anything */
> -	if (pci_root_num < 2)
> +	/* if no reading for pci conf, don't need to do anything */
> +	if (!pci_root_num)
>  		return;
>  
>  	for (i = 0; i < pci_root_num; i++) {
> 

Thanks for the quick turnaround on this issue.

I got information from one of the bug reporters that the patch indeed fixes the problem.
Please submit patch for mainline and stable for inclusion in mainline and stable 2.6.31
and stable 2.6.32.

---
Gertjan.

