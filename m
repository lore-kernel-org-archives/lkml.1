Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbZJLSpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbZJLSpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757850AbZJLSpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:45:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:56198 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757846AbZJLSp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:45:29 -0400
Message-ID: <4AD378B9.3010101@kernel.org>
Date: Mon, 12 Oct 2009 11:43:05 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Ricardo Jorge da Fonseca Marques Ferreira 
	<storm@sys49152.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Yannick Roehlly <yannick.roehlly@free.fr>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, x86@kernel.org
Subject: Re: [PATCH] pci: increase alignment to make more space for hidden
 code
References: <200908072333.24631.storm@sys49152.net> <4ACAC8F1.1050706@kernel.org> <4AD24B5C.4050905@kernel.org> <200910121059.10366.bjorn.helgaas@hp.com> <20091012171915.GB9596@elte.hu>
In-Reply-To: <20091012171915.GB9596@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
>> On Sunday 11 October 2009 03:17:16 pm Yinghai Lu wrote:
>>> for
>>>
>>> http://bugzilla.kernel.org/show_bug.cgi?id=13940
>>>
>>> some system when acpi are enabled, acpi clears some BAR for some devices without
>>> reason, and kernel will need to allocate devices for them.
>> "ACPI clears some BARs"?  I'm dubious.  The handoff state is the same
>> whether we boot with "acpi=off" or not, so the BIOS can't be clearing
>> them.  I really don't think the ACPI code in Linux clears BARs.  The
>> Linux PCI code might be clearing BARs, but it sure would be nice to
>> know exactly why.  Did you ever figure that out?
>>
>>> try to increase alignment to get more safe range for unassigned devices.
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>
>>> ---
>>>  arch/x86/kernel/e820.c |    4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> Index: linux-2.6/arch/x86/kernel/e820.c
>>> ===================================================================
>>> --- linux-2.6.orig/arch/x86/kernel/e820.c
>>> +++ linux-2.6/arch/x86/kernel/e820.c
>>> @@ -1378,8 +1378,8 @@ static unsigned long ram_alignment(resou
>>>  	if (mb < 16)
>>>  		return 1024*1024;
>>>  
>>> -	/* To 32MB for anything above that */
>>> -	return 32*1024*1024;
>>> +	/* To 64MB for anything above that */
>>> +	return 64*1024*1024;
>> How do we know 64MB is the correct alignment?
>>
>> This feels like a hack that accidentally covers up the problem.  I 
>> don't think we understand what's happening well enough.
> 
> Perhaps hidden chipset BARs getting protected by the larger granularity? 
> Do we know the before/after allocation layout?

when acpi=off, BIOS does allocate resource for them

[    0.261960] pci 0000:07:00.0: reg 10 64bit mmio: [0xf4500000-0xf4503fff]
[    0.261970] pci 0000:07:00.0: reg 18 io port: [0x3000-0x30ff]
[    0.262049] pci 0000:07:00.0: supports D1 D2
[    0.262051] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.262058] pci 0000:07:00.0: PME# disabled
[    0.272117] pci 0000:00:1c.4: bridge io port: [0x3000-0x3fff]
[    0.272122] pci 0000:00:1c.4: bridge 32bit mmio: [0xf4500000-0xf45fffff]
[    0.272212] pci 0000:08:00.0: reg 10 64bit mmio: [0xf4600000-0xf4601fff]
[    0.272321] pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
[    0.272330] pci 0000:08:00.0: PME# disabled
[    0.280128] pci 0000:00:1c.5: bridge 32bit mmio: [0xf4600000-0xf46fffff]

when acpi = on 
some devices don't get allocated resources from BIOS

[    0.819921] pci 0000:00:1f.3: reg 10 64bit mmio: [0x000000-0x0000ff]
[    0.819939] pci 0000:00:1f.3: reg 20 io port: [0x1c00-0x1c1f]
[    0.820029] pci 0000:00:1c.0: bridge io port: [0x00-0xfff]
[    0.820033] pci 0000:00:1c.0: bridge 32bit mmio: [0x000000-0x0fffff]
[    0.820041] pci 0000:00:1c.0: bridge 64bit mmio pref: [0x000000-0x0fffff]
[    0.820113] pci 0000:07:00.0: reg 10 64bit mmio: [0x000000-0x003fff]
[    0.820123] pci 0000:07:00.0: reg 18 io port: [0x00-0xff]
[    0.820203] pci 0000:07:00.0: supports D1 D2
[    0.820204] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.820213] pci 0000:07:00.0: PME# disabled
[    0.820289] pci 0000:00:1c.4: bridge io port: [0x00-0xfff]
[    0.820294] pci 0000:00:1c.4: bridge 32bit mmio: [0x000000-0x0fffff]
[    0.820301] pci 0000:00:1c.4: bridge 64bit mmio pref: [0x000000-0x0fffff]
[    0.820388] pci 0000:08:00.0: reg 10 64bit mmio: [0x000000-0x001fff]
[    0.820501] pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
[    0.820510] pci 0000:08:00.0: PME# disabled
[    0.820593] pci 0000:00:1c.5: bridge io port: [0x00-0xfff]
[    0.820598] pci 0000:00:1c.5: bridge 32bit mmio: [0x000000-0x0fffff]
[    0.820605] pci 0000:00:1c.5: bridge 64bit mmio pref: [0x000000-0x0fffff]

and e820 table is
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000b5aa1000 (usable)
[    0.000000]  BIOS-e820: 00000000b5aa1000 - 00000000b5aa7000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5aa7000 - 00000000b5bba000 (usable)
[    0.000000]  BIOS-e820: 00000000b5bba000 - 00000000b5c0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5c0f000 - 00000000b5d08000 (usable)
[    0.000000]  BIOS-e820: 00000000b5d08000 - 00000000b5f0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5f0f000 - 00000000b5f18000 (usable)
[    0.000000]  BIOS-e820: 00000000b5f18000 - 00000000b5f1f000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5f1f000 - 00000000b5f65000 (usable)
[    0.000000]  BIOS-e820: 00000000b5f65000 - 00000000b5f9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000b5f9f000 - 00000000b5fe1000 (usable)
[    0.000000]  BIOS-e820: 00000000b5fe1000 - 00000000b5fff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000b5fff000 - 00000000b6000000 (usable)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)


will be in
[    0.000000] Allocating PCI resources starting at b6000000 (gap:
b6000000:4a000000)

[    7.878413] sky2 driver version 1.23
[    7.884402] sky2 0000:07:00.0: enabling device (0000 -> 0003)
[    7.889483] sky2 0000:07:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.894502] sky2 0000:07:00.0: setting latency timer to 64
[    7.894555] sky2 0000:07:00.0: unsupported chip type 0xff
[    7.899554] sky2 0000:07:00.0: PCI INT A disabled
[    7.904379] sky2: probe of 0000:07:00.0 failed with error -95

[    8.857709] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux,
1.3.27kds
[    8.863357] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[    8.875763] iwlagn 0000:08:00.0: enabling device (0000 -> 0002)
[    8.881477] iwlagn 0000:08:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    8.887083] iwlagn 0000:08:00.0: setting latency timer to 64
[    8.887128] iwlagn 0000:08:00.0: Detected Intel Wireless WiFi Link 5100AGN
REV=0xFDFFFFFF
[    8.892723]   alloc irq_desc for 22 on node 0
[    8.892726]   alloc kstat_irqs on node 0
[    9.073995] iwlagn 0000:08:00.0: Failed, HW not ready
[    9.080292] iwlagn 0000:08:00.0: PCI INT A disabled


07:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8040 PCI-E Fast
Ethernet Controller (rev \
12)  Subsystem: Toshiba America Info Systems Device ff50
...
    Memory at b6000000 (64-bit, non-prefetchable) [size=16K]
    I/O ports at 2000 [size=256]

so the device doesn't like 0xb60000000

with the patch, we will start to use from 0xb8000000 instead.


Also now, when early print pci is used
[    0.000000] pci 0000:07:00.0 config space:
[    0.000000]   00: ab 11 55 43 07 00 10 00 12 00 00 02 10 00 00 00
[    0.000000]   10: 04 00 50 f4 00 00 00 00 01 30 00 00 00 00 00 00
[    0.000000]   20: 00 00 00 00 00 00 00 00 00 00 00 00 79 11 50 ff
[    0.000000]   30: 00 00 00 00 48 00 00 00 00 00 00 00 0b 01 00 00
[    0.000000]   40: 00 00 b0 84 09 c0 a0 01 01 5c 03 fe 00 20 00 13
[    0.000000]   50: 03 5c 00 80 00 00 00 00 00 00 04 00 05 c0 80 00
[    0.000000]   60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   70: 00 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   80: 00 00 00 00 00 30 00 00 00 00 00 00 82 a8 e8 00
[    0.000000]   90: 00 00 00 00 00 00 00 00 a0 25 26 00 00 00 00 00
[    0.000000]   a0: f6 00 00 ff 40 00 08 01 0c 31 33 40 04 0a 10 44
[    0.000000]   b0: 00 00 00 05 00 00 60 20 fa 00 00 00 00 00 00 00
[    0.000000]   c0: 10 00 12 00 c0 8f 04 05 00 20 19 00 11 ac 07 00
[    0.000000]   d0: 48 01 11 10 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   e0: 00 00 00 00 10 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000] pci 0000:08:00.0 config space:
[    0.000000]   00: 86 80 32 42 06 00 10 00 00 00 80 02 10 00 00 00
[    0.000000]   10: 04 00 60 f4 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 01 12
[    0.000000]   30: 00 00 00 00 c8 00 00 00 00 00 00 00 05 01 00 00
[    0.000000]   40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   c0: 00 00 00 00 00 00 00 00 01 d0 23 c8 00 00 00 0d
[    0.000000]   d0: 05 e0 80 00 00 00 00 00 00 00 00 00 00 00 00 00
[    0.000000]   e0: 10 00 01 00 c0 8e 00 10 10 08 19 00 11 9c 06 00
[    0.000000]   f0: 40 01 11 10 00 00 00 00 00 00 00 00 00 00 00 00


[    0.815933] pci 0000:07:00.0: reg 10 64bit mmio: [0x000000-0x003fff]
[    0.815946] pci 0000:07:00.0: reg 18 io port: [0x00-0xff]
[    0.816029] pci 0000:07:00.0: supports D1 D2
[    0.816033] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.816041] pci 0000:07:00.0: PME# disabled
[    0.816223] pci 0000:08:00.0: reg 10 64bit mmio: [0x000000-0x001fff]
[    0.816339] pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
[    0.816348] pci 0000:08:00.0: PME# disabled

so it turns out, it is ACPI subsystem clear those BARs without reason.


Intel guys request the apci dump, to check reason, but didn't report back the reason yet.

YH
