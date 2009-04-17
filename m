Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbZDQWIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbZDQWIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 18:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbZDQWIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 18:08:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55989 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbZDQWIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 18:08:10 -0400
Message-ID: <49E8FD0B.2050308@zytor.com>
Date: Fri, 17 Apr 2009 15:04:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
References: <49E52D3F.1090206@kernel.org> <20090416093152.6605612d@hobbes> <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <20090416235452.GE21405@elte.hu> <alpine.LFD.2.00.0904161716270.4042@localhost.localdomain> <20090417131633.GA30578@elte.hu>
In-Reply-To: <20090417131633.GA30578@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> On Fri, 17 Apr 2009, Ingo Molnar wrote:
>>> Could we perhaps round up to 1MB in this case too?
>> (The below 1MB one).
>>
>> I'd argue against it, at least in this incarnation. I can well 
>> imagine somebody wanting to do resource management in the 640k-1M 
>> window, so..
> 
> ok - indeed - if there's some super-small system with limited 
> address lines and all physical addresses tightly packed with RAM?
> 

No, much more likely that you're having PCI 2.x or PnP devices which 
have 20-bit resources.  It's probably worth noting that at least right 
now, Linux mishandles 20-bit BARs and treat them like 32-bit BARs.  It 
turns out to actually work on a majority of the (quite few) known 
devices which do have 20-bit BARs.

> 
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)       0.639 MB RAM
>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)     0.001 MB
>                                                 [ hole ]       0.250 MB
>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)     0.125 MB
>  BIOS-e820: 0000000000100000 - 000000003ed94000 (usable)    1004.5   MB RAM
>  BIOS-e820: 000000003ed94000 - 000000003ee4e000 (ACPI NVS)     0.7   MB
>  BIOS-e820: 000000003ee4e000 - 000000003fea2000 (usable)      16.3   MB RAM
>  BIOS-e820: 000000003fea2000 - 000000003fee9000 (ACPI NVS)     0.3   MB
>  BIOS-e820: 000000003fee9000 - 000000003feed000 (usable)       0.15  MB RAM
>  BIOS-e820: 000000003feed000 - 000000003feff000 (ACPI data     0.07  MB
>  BIOS-e820: 000000003feff000 - 000000003ff00000 (usable)       0.004 MB RAM
>                                                 [ hole ]       1.0   MB
>                                                 [ hole ]    3072.0   MB
> 
> On this map, using your scheme, we'd fill up that small 1MB hole up 
> to 1GB [mockup]:
> 
>  BIOS-e820: 000000003ff00000 - 0000000040000000 (RAM buffer)
> 
> I guess that's a good thing not just for robustness: a chipset might 
> be faster when DMA or mmio is on some well-isolated physical memory 
> range, not too close to real RAM or other devices?
> 

Realistically, there probably is RAM there, probably consumed by the SMM 
T-seg.

	-hpa
