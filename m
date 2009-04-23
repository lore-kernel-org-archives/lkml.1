Return-Path: <linux-kernel-owner+w=401wt.eu-S1758924AbZDWPIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbZDWPIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758511AbZDWPHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:07:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:33123 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759420AbZDWPHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:07:45 -0400
Message-ID: <49F083B6.7080801@kernel.org>
Date: Thu, 23 Apr 2009 08:05:26 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [RFC PATCH 1/2] pci: don't assume pref memio are 64bit -v3
References: <alpine.LFD.2.00.0904181142530.4042@localhost.localdomain> <49EA57C4.1000603@kernel.org> <alpine.LFD.2.00.0904181602030.2199@localhost.localdomain> <alpine.LFD.2.00.0904182149240.2199@localhost.localdomain> <20090419090208.GA30211@elte.hu> <20090419090615.GA30631@elte.hu> <20090420223305.GA15340@jurassic.park.msu.ru> <49ED0EBC.4070901@kernel.org> <20090421105629.GB17904@jurassic.park.msu.ru> <49EF9C10.6090107@kernel.org> <20090423123619.GA11519@jurassic.park.msu.ru>
In-Reply-To: <20090423123619.GA11519@jurassic.park.msu.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:
> On Wed, Apr 22, 2009 at 03:37:04PM -0700, Yinghai Lu wrote:
>> one system with 4g installed ( there is 1g hole)
>>
>> when 4G installed.
>> BIOS put ACPI etc need the hole
>> [    0.000000] BIOS-provided physical RAM map:
>> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009bc00 (usable)
>> [    0.000000]  BIOS-e820: 000000000009bc00 - 00000000000a0000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000000e3000 - 0000000000100000 (reserved)
>> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bffa0000 (usable)
>> [    0.000000]  BIOS-e820: 00000000bffa0000 - 00000000bffae000 (ACPI data)
>> [    0.000000]  BIOS-e820: 00000000bffae000 - 00000000bfff0000 (ACPI NVS)
>> [    0.000000]  BIOS-e820: 00000000bfff0000 - 00000000c0000000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
>> [    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
>> so in kernel resource will be reserved for 0xbffa0000 - 0xbfff0000 for ACPI
>> 0x100000 -  0xbffa0000 for RAM...
>>
>> and BIOS set
>> [    0.240007] pci 0000:00:01.0: bridge 64bit mmio pref: [0xbdf00000-0xddefffff]
>> [    0.237102] pci 0000:01:00.0: reg 10 32bit mmio: [0xc0000000-0xcfffffff]
>> that is conflict with reserved res. so it can not be reserved Kernel.
>>
>> then Kernel try to get range from 0x140000000 ( above the RAM, 5G and above 4g)
>> and set let the bridge to use it, and ATI cards to use it.
>>
>> but the problem is that ATI only support 32bit ...
> 
> Yinghai, you are trying to get a quick fix for quite a complex problem
> that cannot be solved with a quick fix. Even more, there is no rush on
> a quick fix because it's not a critical bug at all. 32-bit stuff ends
> up above 4G *only* when there is no free space left on the 32-bit
> PCI bus, and it can be considered as very effective (though rather ugly)
> way of disabling the BAR that we failed to allocate.
> In this particular case it was simply a side effect of the "pci_mem_start"
> issue (which was indeed critical, but hopefully fixed now).
> 

i agreed that that is not crital bug at all. pci_mem_start patch should fix that allocation alone.
actually "pci: don't assume pref memio are 64bit" just make kernel give customer surprise.

> 
>> +/* need to insert those two under iomem */
>> +struct resource iomem32_resource = {
>> +	.name	= "PCI mem 32bit",
>> +	.start	= 0,
>> +	.end	= 0xffffffff,
>> +	.flags	= IORESOURCE_MEM,
>> +};
>> +struct resource iomem64_resource = {
>> +	.name	= "PCI mem 64bit",
>> +	.start	= 1ULL<<32,
>> +	.end	= -1,
>> +	.flags	= IORESOURCE_MEM | IORESOURCE_MEM_64,
>> +};
>> +
> 
> This only works on x86 and similar systems with 1:1 CPU address to bus
> address mapping. There is a lot of machines with multiple 32-bit PCI
> bus spaces (4G per PCI domain).

need to move that code to arch code for x86?

YH
